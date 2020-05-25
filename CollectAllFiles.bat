@echo on

set PATH_AUTODESK=c:\Program Files\Autodesk
set PATH_BINARY=d:\Works\Ray-Tracing_Systems\HydraDevelop\3dsMaxBinary\HydraRenderer_binary
set PATH_HYDRA=c:\[Hydra]


del /Q %PATH_BINARY%\[Hydra]\bin2\
del /Q %PATH_BINARY%\[Hydra]\bin2\shaders
del /Q %PATH_BINARY%\max2017\
del /Q %PATH_BINARY%\max2018\
del /Q %PATH_BINARY%\max2019\
del /Q %PATH_BINARY%\max2020\
del /Q %PATH_BINARY%\max2021\

copy "%PATH_HYDRA%\bin2"                                             "%PATH_BINARY%\[Hydra]\bin2\"
copy "%PATH_HYDRA%\bin2\shaders"                                     "%PATH_BINARY%\[Hydra]\bin2\shaders"

copy "%PATH_AUTODESK%\3ds Max 2017\Plugins\HydraAO_2017.dlt"         "%PATH_BINARY%\max2017\"
copy "%PATH_AUTODESK%\3ds Max 2017\Plugins\HydraBackEnvir_2017.dlt"  "%PATH_BINARY%\max2017\"
copy "%PATH_AUTODESK%\3ds Max 2017\Plugins\HydraBlendedBox_2017.dlt" "%PATH_BINARY%\max2017\"
copy "%PATH_AUTODESK%\3ds Max 2017\Plugins\HydraLight_2017.dlo"      "%PATH_BINARY%\max2017\"
copy "%PATH_AUTODESK%\3ds Max 2017\Plugins\HydraMtl_2017.dlt"        "%PATH_BINARY%\max2017\"
copy "%PATH_AUTODESK%\3ds Max 2017\Plugins\HydraMtlCatcher_2017.dlt" "%PATH_BINARY%\max2017\"
copy "%PATH_AUTODESK%\3ds Max 2017\Plugins\HydraMtlLight_2017.dlt"   "%PATH_BINARY%\max2017\"
copy "%PATH_AUTODESK%\3ds Max 2017\Plugins\HydraRender_2017.dlr"     "%PATH_BINARY%\max2017\"
copy "%PATH_AUTODESK%\3ds Max 2017\Plugins\HydraSunSky_2017.dlo"     "%PATH_BINARY%\max2017\"
                                                                       
copy "%PATH_AUTODESK%\3ds Max 2018\Plugins\HydraAO_2018.dlt"         "%PATH_BINARY%\max2018\"
copy "%PATH_AUTODESK%\3ds Max 2018\Plugins\HydraBackEnvir_2018.dlt"  "%PATH_BINARY%\max2018\"
copy "%PATH_AUTODESK%\3ds Max 2018\Plugins\HydraBlendedBox_2018.dlt" "%PATH_BINARY%\max2018\"
copy "%PATH_AUTODESK%\3ds Max 2018\Plugins\HydraLight_2018.dlo"      "%PATH_BINARY%\max2018\"
copy "%PATH_AUTODESK%\3ds Max 2018\Plugins\HydraMtl_2018.dlt"        "%PATH_BINARY%\max2018\"
copy "%PATH_AUTODESK%\3ds Max 2018\Plugins\HydraMtlCatcher_2018.dlt" "%PATH_BINARY%\max2018\"
copy "%PATH_AUTODESK%\3ds Max 2018\Plugins\HydraMtlLight_2018.dlt"   "%PATH_BINARY%\max2018\"
copy "%PATH_AUTODESK%\3ds Max 2018\Plugins\HydraRender_2018.dlr"     "%PATH_BINARY%\max2018\"
copy "%PATH_AUTODESK%\3ds Max 2018\Plugins\HydraSunSky_2018.dlo"     "%PATH_BINARY%\max2018\"

copy "%PATH_AUTODESK%\3ds Max 2019\Plugins\HydraAO_2019.dlt"         "%PATH_BINARY%\max2019\"
copy "%PATH_AUTODESK%\3ds Max 2019\Plugins\HydraBackEnvir_2019.dlt"  "%PATH_BINARY%\max2019\"
copy "%PATH_AUTODESK%\3ds Max 2019\Plugins\HydraBlendedBox_2019.dlt" "%PATH_BINARY%\max2019\"
copy "%PATH_AUTODESK%\3ds Max 2019\Plugins\HydraLight_2019.dlo"      "%PATH_BINARY%\max2019\"
copy "%PATH_AUTODESK%\3ds Max 2019\Plugins\HydraMtl_2019.dlt"        "%PATH_BINARY%\max2019\"
copy "%PATH_AUTODESK%\3ds Max 2019\Plugins\HydraMtlCatcher_2019.dlt" "%PATH_BINARY%\max2019\"
copy "%PATH_AUTODESK%\3ds Max 2019\Plugins\HydraMtlLight_2019.dlt"   "%PATH_BINARY%\max2019\"
copy "%PATH_AUTODESK%\3ds Max 2019\Plugins\HydraRender_2019.dlr"     "%PATH_BINARY%\max2019\"
copy "%PATH_AUTODESK%\3ds Max 2019\Plugins\HydraSunSky_2019.dlo"     "%PATH_BINARY%\max2019\"

copy "%PATH_AUTODESK%\3ds Max 2020\Plugins\HydraAO_2020.dlt"         "%PATH_BINARY%\max2020\"
copy "%PATH_AUTODESK%\3ds Max 2020\Plugins\HydraBackEnvir_2020.dlt"  "%PATH_BINARY%\max2020\"
copy "%PATH_AUTODESK%\3ds Max 2020\Plugins\HydraBlendedBox_2020.dlt" "%PATH_BINARY%\max2020\"
copy "%PATH_AUTODESK%\3ds Max 2020\Plugins\HydraLight_2020.dlo"      "%PATH_BINARY%\max2020\"
copy "%PATH_AUTODESK%\3ds Max 2020\Plugins\HydraMtl_2020.dlt"        "%PATH_BINARY%\max2020\"
copy "%PATH_AUTODESK%\3ds Max 2020\Plugins\HydraMtlCatcher_2020.dlt" "%PATH_BINARY%\max2020\"
copy "%PATH_AUTODESK%\3ds Max 2020\Plugins\HydraMtlLight_2020.dlt"   "%PATH_BINARY%\max2020\"
copy "%PATH_AUTODESK%\3ds Max 2020\Plugins\HydraRender_2020.dlr"     "%PATH_BINARY%\max2020\"
copy "%PATH_AUTODESK%\3ds Max 2020\Plugins\HydraSunSky_2020.dlo"     "%PATH_BINARY%\max2020\"

copy "%PATH_AUTODESK%\3ds Max 2021\Plugins\HydraAO_2021.dlt"         "%PATH_BINARY%\max2021\"
copy "%PATH_AUTODESK%\3ds Max 2021\Plugins\HydraBackEnvir_2021.dlt"  "%PATH_BINARY%\max2021\"
copy "%PATH_AUTODESK%\3ds Max 2021\Plugins\HydraBlendedBox_2021.dlt" "%PATH_BINARY%\max2021\"
copy "%PATH_AUTODESK%\3ds Max 2021\Plugins\HydraLight_2021.dlo"      "%PATH_BINARY%\max2021\"
copy "%PATH_AUTODESK%\3ds Max 2021\Plugins\HydraMtl_2021.dlt"        "%PATH_BINARY%\max2021\"
copy "%PATH_AUTODESK%\3ds Max 2021\Plugins\HydraMtlCatcher_2021.dlt" "%PATH_BINARY%\max2021\"
copy "%PATH_AUTODESK%\3ds Max 2021\Plugins\HydraMtlLight_2021.dlt"   "%PATH_BINARY%\max2021\"
copy "%PATH_AUTODESK%\3ds Max 2021\Plugins\HydraRender_2021.dlr"     "%PATH_BINARY%\max2021\"
copy "%PATH_AUTODESK%\3ds Max 2021\Plugins\HydraSunSky_2021.dlo"     "%PATH_BINARY%\max2021\"

pause