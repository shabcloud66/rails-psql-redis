## Contents of this Cloud 66 sample:

This repository uses the following database, which should <i>not</i> be changed.
<table>
  <tr>
    <td><b>Database</b></td>
    <td>PostgreSQL & Redis</td>
  </tr>
</table>

The following settings may be changed on a new branch. See below for naming and documentation conventions.

| Branch           | master                      | 
| ---------------- |:---------------------------:|
| Rails            | 3.2.13                      |
| Rack server      | Puma                        |
| Manifest file    | PostGIS                     |
| Deployment hooks | -                           |
| Process file     | Rack server, rake workers   |

If you would like to modify the contents of this repository, please create a new branch. When doing so, please remember to:
* Follow conventions when naming the branch (ie. if you want to use the Puma rack server, please name the branch _Puma_)
* Add a section to this document in the above format stating your changes
