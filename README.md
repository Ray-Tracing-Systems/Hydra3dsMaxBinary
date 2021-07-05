# Hydra Renderer 3ds Max Plugin
This is the official place to release the binaries and installer of the Hydra Renderer plugin for 3ds max.

Installation:

1) Remove the old version of the renderer through the standard Windows tools, if there is one.
2) Download and unpack "HydraRendererXXX_Installer.zip" from "Releases" page and "Latest release" tag.
3) Install "HydraRendererInstaller.msi".
4) In the 3d max renderer settings, select "Hydra renderer".
5) Read the documentation, it will save a lot of time.
http://www.ray-tracing.com/HydraRenderHelp.github.io/index.html

Installation without an installer.

1) Remove the old version of the renderer through the standard Windows tools, if there is one.
2) Download and unpack "HydraRenderer2.5_binary.zip" from "Releases" page and release tag.
3) Copy the "[Hydra]" folder to the root of the "C:\" drive.
4) Copy the files from the "max20xx" folders to the plugins folder of your 3d max. For example, from "max2021" to "c:\Program Files\Autodesk\3ds Max 2021\Plugins\".

Installing updates (pre-release versions).

1) Install the full version using any of the above methods.
2) Download the update files from "Releases" page and "Pre-release" tag.
3) Unpack the archives and overwrite the contents to the appropriate folders. For example:

"bin2" in "C:\[Hydra]\bin2\".
"3ds Max 20xx "in" c:\Program Files\Autodesk\3ds Max 2021\Plugins\".

4) Delete the files in the folder " C:\[Hydra]\bin2\shadercache\".

----------------------------------------------------------------------------

If you have problems with the launch, please see the installation and troubleshooting information in the documentation:
http://www.ray-tracing.com/HydraRenderHelp.github.io/start.html


The initial basics of the work can be found on our website:
http://www.raytracing.ru/3dsmax.html


If you have any error when working with the render, or when installing it, which you could not solve, write to us about it:
https://vk.com/hydrarenderer

You can also create a new issue here:
https://gitlab.com/raytracingsystems/3dsmaxplugin/-/issues
