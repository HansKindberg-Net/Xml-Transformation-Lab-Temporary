A project for laborating with XmlTransformation. Howto hookon and change the default behaviour.

I have set up a virtual machine where I can change the original targets to learn where things happen. I tried first to copy the original targets to this solution but there where to many paths to change to get it working.

The XmlTransformation targets is in (depending on the VS version):

C:\Program Files (x86)\MSBuild\Microsoft\VisualStudio\v12.0\Web\Microsoft.Web.Publishing.targets

	<PropertyGroup>
		<CollectWebConfigsToTransformDependsOn>
			$(OnBeforeCollectWebConfigsToTransform);
			$(CollectWebConfigsToTransformDependsOn);
			PipelineCollectFilesPhase;
		</CollectWebConfigsToTransformDependsOn>
	</PropertyGroup>

	<Target Name="CollectWebConfigsToTransform" DependsOnTargets="$(CollectWebConfigsToTransformDependsOn)" Condition="'$(CollectWebConfigsToTransform)' != 'false'">
		<!-- Gather Sources, Transforms, and Destinations for the TransformXml task -->
		<ItemGroup Condition="'$(ProjectConfigTransformFileName)'!=''">
			<WebConfigsToTransform Include="@(FilesForPackagingFromProject)" Condition="'%(FilesForPackagingFromProject.Filename)%(FilesForPackagingFromProject.Extension)'=='$(ProjectConfigFileName)'">
				<TransformFile>$([System.String]::new($(WebPublishPipelineProjectDirectory)\$([System.IO.Path]::GetDirectoryName($([System.String]::new(%(DestinationRelativePath)))))).TrimEnd('\'))\$(ProjectConfigTransformFileName)</TransformFile>
				<TransformOriginalFolder>$(TransformWebConfigIntermediateLocation)\original</TransformOriginalFolder>
				<TransformFileFolder>$(TransformWebConfigIntermediateLocation)\assist</TransformFileFolder>
				<TransformOutputFile>$(TransformWebConfigIntermediateLocation)\transformed\%(DestinationRelativePath)</TransformOutputFile>
				<TransformScope>$([System.IO.Path]::GetFullPath($(WPPAllFilesInSingleFolder)\%(DestinationRelativePath)))</TransformScope>
			</WebConfigsToTransform>
			<_WebConfigsToTransformOuputs Include="@(WebConfigsToTransform->'%(TransformOutputFile)')" />
		</ItemGroup>
		<CallTarget Targets="$(OnAfterCollectWebConfigsToTransform)" RunEachTargetSeparately="False" />
	</Target>

**Also have a look at the target: ParameterizeTransformWebConfigCore**

## Visual Studio Command Prompt

When I ran "MSBuild.exe" from the ordinary command prompt it opened up Visual Studio. So I tried the **Visual Studio Command Prompt** instead.

- [**Visual Studio Command Prompt**](http://msdn.microsoft.com/en-us/library/ms229859.aspx)

Run the **Visual Studio Command Prompt**:

- C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\Tools\Shortcuts\Developer Command Prompt for VS2013
- Right click -> Run as administrator (not sure if it is necessary, but...)
- CD "C:\Data\Projects\Xml-Transformation-Lab"

Examples:

- msbuild xml-transformation-lab.sln /p:DeployOnBuild=true;PublishProfile=Debug;AllowUntrustedCertificate=true

## Important

<IsWebApplicationProject> in WebApplication\Build\Build.targets is important to have to be able to have a package for both WebApplications and NONE WebApplication and make the
behaviour dependant on that: On build behaviour and On publish behaviour.

Look at, for $(Configuration) dependency:

- TransformWebConfigCore
- PreTransformWebConfig
- CollectWebConfigsToTransform

and look at, for Publish profile name .configs

- ProfileTransformWebConfigCore
- PreProfileTransformWebConfig
- CollectFilesForProfileTransformWebConfigs

Look here http://www.hanselman.com/blog/TinyHappyFeatures3PublishingImprovementsChainedConfigTransformsAndDeployingASPNETAppsFromTheCommandLine.aspx

**I can make a Web.config file with the same name as my Publish Profile and that transform will be run after the build transform.**

Lets say you have

	Web.config
		Web.Debug.config
		Web.Release.config
		Web.Production.config

and you have

- Debug
- Release

as configurations

and as Publish profile name you have

- Production

If the Publish profile **Production** is configured for the configuration **Release** the following happens when publishing

1. Transforming with Web.Release.config is done
2. Transforming with Web.Production.config is done