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