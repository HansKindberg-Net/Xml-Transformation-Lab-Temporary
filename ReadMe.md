A project for laborating with XmlTransformation. Howto hookon and change the default behaviour.

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