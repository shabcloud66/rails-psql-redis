module Analysers

	class RailsMongodbAnalyser


		def self.create_config_template(stack, server)

			#no database being deployed so exit
			return if stack.params[:db_server_type].to_i == Stack::DB_EXTERNAL

			config_path = 'config/mongoid.yml'
			config_file = File.join(stack.scm_dir, config_path)
			FileUtils.copy(config_file, config_file + '.original')
			mongoid_content = YAML::load_file(config_file)

			#TODO: right now we only allow a single db server
			db_server_group = stack.server_groups.find_by_group_type(ServerGroup::SRG_DB)
			db_server = db_server_group.primary_server

			# it may not be localhost if the web servers scaled up for instance
			is_same_server = server.address == db_server.address

			if mongoid_content[stack.environment]['sessions'].nil?
				# no sessions
				context = mongoid_content[stack.environment]
			else
				# no need to check for nil as this is already done during analysis
				context = mongoid_content[stack.environment]['sessions']['default']
			end

			# is its a host or hosts list syntax
			is_hosts_array = !context['hosts'].nil?

			if is_same_server
				# is mongoid3 syntax
				context['hosts'] = ["localhost:27017"] if is_hosts_array
				# not mongoid3 syntax
				context['host'] = "localhost" if !is_hosts_array
			else
				# is mongoid3 syntax
				context['hosts'] = ["#{db_server.address}:27017"] if is_hosts_array
				# not mongoid3 syntax
				context['host'] = db_server.address if !is_hosts_array
			end

			# need to reapply the changes
			if mongoid_content[stack.environment]['sessions'].nil?
				# no sessions
				mongoid_content[stack.environment] = context
			else
				# no need to check for nil as this is already done during analysis
				mongoid_content[stack.environment]['sessions']['default'] = context
			end

			File.open(config_file + ".#{server.id}", "w") { |f| f.write(YAML::dump(mongoid_content)) }
			return { :source => config_path + ".#{server.id}", :target => config_path }
		end

		

	end

end

