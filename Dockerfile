# escape=`


# Use the latest Windows Server Core image with .NET Framework 4.8.
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019
# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

# Download the Build Tools bootstrapper.
ADD https://aka.ms/vs/16/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe
# Install Build Tools with the Microsoft.VisualStudio.Workload.AzureBuildTools workload, excluding workloads and components with known issues.
RUN C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
    --installPath C:\BuildTools `
    --add Microsoft.Data.Tools.Msbuild `
    --add Microsoft.Data.Tools.Schema `
    # add SSDT components
    --add Microsoft.VisualStudio.Component.SQL.SSDTBuildSku `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10240 `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10586 `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.14393 `
    --remove Microsoft.VisualStudio.Component.Windows81SDK `
    || IF "%ERRORLEVEL%"=="3010" EXIT 0

ENV SQLPROJ_PATH=
ENV PUBLISH_PROFILE_PATH=
ENV MSBUILD_ACTION="Build,Publish"
ENV MSBUILD_OPTIONAL_PARAMS=" "

RUN mkdir "C:\Program Files (x86)\MSBuild\Microsoft\VisualStudio\v11.0\SSDT"
RUN copy C:\BuildTools\MSBuild\Microsoft\VisualStudio\v16.0\SSDT\Microsoft.Data.Tools.Schema.SqlTasks.targets "C:\Program Files (x86)\MSBuild\Microsoft\VisualStudio\v11.0\SSDT"

CMD ["cmd", "/S", "/C", "C:\\BuildTools\\MSBuild\\Current\\Bin\\MSBuild.exe", `
    "%SQLPROJ_PATH%", `
    "/p:SqlPublishProfilePath=%PUBLISH_PROFILE_PATH%", `
    "/t:%MSBUILD_ACTION%",  `
    "%MSBUILD_OPTIONAL_PARAMS%" `
    ]
    