# SSDTPowerTemplate

After years of experimenting with [SQL Server Data Tools SSDT](https://docs.microsoft.com/en-us/sql/ssdt/download-sql-server-data-tools-ssdt?view=sql-server-ver15) this is my vision how the project in SSDT should be structured and handled. This is strongly my opinion and some of the ideas/code were done by other people as well. There is no warranty or guarantee that this template will work for you and/or not break anything...

---
 ### [Projects structure](#header_projects_structure)
 ### [tSQLt](#header_tsqlt)
* #### [Improvements](#subheader_improvements)
 ### [tSQLt samples](#header_tsqlt_samples)
 ### [Projects changes](#header_project_changes)
* #### [sqlproj file ordering to avoid merge conflicts](#subheader_sql_file_ordering_to_avoid_merge_conflicts)
* #### [gitignore](#subheader_gitignore)
* #### [Developer specific publish profiles](#subheader_developer_specific_publish_profiles)
* #### [System databases](#subheader_system_databases)
* #### [Code analysis](#subheader_code_analysis)
 ### [One time pre/post scripts](#header_one_time_prepost_scripts)
 ### [Default settings for publish profiles](#header_default_settings_for_publish_profiles)
---
## <a name="header_projects_structure"></a>Projects structure
There are 4 projects in the solution:
* *MainDatabase* - that's the database that would be mainly referenced by consumer. This database is not referenced by any other database (except tests one). This is not requirement for that database, you can have several like that, however they be should designed in a way to avoid circular dependency that is not supported by SSDT natively
* *MainDatabase.Tests* - the database for storing [tSQLt unit tests](www.tsqlt.org). This database is referencing `tslqt_objects.dacpac` with `the same database` option as well as `MainDatabase` with the same option. There are other references, but they are needed just because they are referenced in the main project. When you publish that project it will publish all the objects from `MainDatabase`, `tSQLt` framework objects + all the unit tests from `MainDatabase.Tests`.
* *AnotherDbSameInstance* - the database project that is referenced in the `MainDatabase` project that is meant to be located on the same instance
* *AnotherDbAnotherInstance* - the database project that is referenced in the `MainDatabase` project that is meant to be located on the different instance

There are synonyms created in `MainDatabase` for all the objects needed to be referenced from `AnotherDbSameInstance` and `AnotherDbAnotherInstance`. Synonyms seems to be the best working solution to work with external objects so I strongly advice to do so.

## <a name="header_tsqlt"></a>tSQLt
### <a name="subheader_improvements"></a>Improvements
The dacpac included in the project consists an unofficial version of the `tSQLt`. It has all the objects as the original frameworks as 2 new features developed by me that has Pull Requests open in the main project but still not merged to the main branch. These 2 new features are:
* Faking synonyms with `tSQLt.FakeTable` procedure. Native functionality with only synonyms that are referencing object on the same database. New functionality can work with external objects as well.
* Simplify mocking functions with `tSQLt.FakeFunction`. In original version for mocking the function, you were needed to create new function and then pass it to the framework that would replace the original one. New functionality allows you to pass the table with the data or code snippet that will return needed output.


## <a name="header_tsqlt_samples"></a>tSQLt samples
Few unit tests samples are added as well. Additionally all unit tests will be running after each `Tests` project publish


## <a name="header_project_changes"></a>Projects changes

### <a name="subheader_sql_file_ordering_to_avoid_merge_conflicts"></a>sqlproj file ordering to avoid merge conflicts
When working with SSDT in a team, there are lots of the troubles when merging `sqlproj` file as it is adding entries to the xml chaotically. To avoid this there is `build_VS2017.targets` file referenced in each solution. That build target script will order the elements in the `sqlproj` file with every project build. **Note**: as the project file is re-ordered by external script, Visual Studio treats it as the project file changed and will ask you to reload the project after the build. **Tip**: as there is no actual change in the project, you can simply click on "Ignore all" button that would not reload the project.

### <a name="subheader_gitignore"></a>gitignore
Temporary/binary and other non-source are excluded from source control. 

### <a name="subheader_developer_specific_publish_profiles"></a>Developer specific publish profiles
All publish profiles that ends with `.local_only.publish.xml` will be ignored. One can keep it's own version of the publish profile with it's own variables and/or other settings.
### <a name="subheader_system_databases"></a>System databases
`msdb` and `master` are included in the main project

### <a name="subheader_code_analysis"></a>Code analysis
Code analysis is enabled for all projects
## <a name="header_one_time_prepost_scripts"></a>One time pre/post scripts
## <a name="header_default_settings_for_publish_profiles"></a>Default settings for publish profiles

## <a name="header_publish_with_docker"></a>Publish with docker
You can publish this project using docker, you don't need to have Visual Studio or/and MsBuild to be installed on your machine. **Note**: docker should have access to your database as well as to the shared folder.

This is an example how you can publish the project. You should run it from the root folder (`Dockerfile` should be located there)
```
docker build - -t msbuildssdt < Dockerfile
docker run^
 --name msbuildssdt^
 -v C:\Sources\SSDTPowerTemplate:C:\DataBaseProject^
 -e SQLPROJ_PATH=C:\DataBaseProject\MainDatabase.Tests\MainDatabase.Tests.sqlproj^
 -e PUBLISH_PROFILE_PATH=C:\DataBaseProject\MainDatabase.Tests\PublishProfiles\MainDatabase.local_only.publish.xml^
 msbuildssdt 
```
Please note that `C:\Sources\SSDTPowerTemplate` is the root folder located on your host (local) machine. All the paths starting with `C:\DataBaseProject` are the paths inside docker

to be continued...