@echo on

set PATH_AUTODESK=c:\Program Files\Autodesk
set PATH_BINARY=d:\Works\Ray-Tracing_Systems\HydraDevelop\3dsMaxBinary\HydraRenderer2.3b_binary
set PATH_HYDRA=c:\[Hydra]


del /Q %PATH_BINARY%\[Hydra]\bin2\
del /Q %PATH_BINARY%\[Hydra]\bin2\shaders
del /Q %PATH_BINARY%\max2017\
del /Q %PATH_BINARY%\max2018\
del /Q %PATH_BINARY%\max2019\


copy "%PATH_HYDRA%\bin2"                                             "%PATH_BINARY%\[Hydra]\bin2\"
copy "%PATH_HYDRA%\bin2\shaders"                                     "%PATH_BINARY%\[Hydra]\bin2\shaders"

copy "%PATH_AUTODESK%\3ds Max 2017\Plugins\HydraRender_2017.dlr"     "%PATH_BINARY%\max2017\"
copy "%PATH_AUTODESK%\3ds Max 2017\Plugins\HydraMtl_2017.dlt"        "%PATH_BINARY%\max2017\"
copy "%PATH_AUTODESK%\3ds Max 2017\Plugins\HydraMtlCatcher_2017.dlt" "%PATH_BINARY%\max2017\"
copy "%PATH_AUTODESK%\3ds Max 2017\Plugins\HydraMtlLight_2017.dlt"   "%PATH_BINARY%\max2017\"
copy "%PATH_AUTODESK%\3ds Max 2017\Plugins\HydraLight_2017.dlo"      "%PATH_BINARY%\max2017\"
                                                                       
copy "%PATH_AUTODESK%\3ds Max 2018\Plugins\HydraRender_2018.dlr"     "%PATH_BINARY%\max2018\"
copy "%PATH_AUTODESK%\3ds Max 2018\Plugins\HydraMtl_2018.dlt"        "%PATH_BINARY%\max2018\"
copy "%PATH_AUTODESK%\3ds Max 2018\Plugins\HydraMtlCatcher_2018.dlt" "%PATH_BINARY%\max2018\"
copy "%PATH_AUTODESK%\3ds Max 2018\Plugins\HydraMtlLight_2018.dlt"   "%PATH_BINARY%\max2018\"
copy "%PATH_AUTODESK%\3ds Max 2018\Plugins\HydraLight_2018.dlo"      "%PATH_BINARY%\max2018\"
                                                                       
copy "%PATH_AUTODESK%\3ds Max 2019\Plugins\HydraRender_2019.dlr"     "%PATH_BINARY%\max2019\"
copy "%PATH_AUTODESK%\3ds Max 2019\Plugins\HydraMtl_2019.dlt"        "%PATH_BINARY%\max2019\"
copy "%PATH_AUTODESK%\3ds Max 2019\Plugins\HydraMtlCatcher_2019.dlt" "%PATH_BINARY%\max2019\"
copy "%PATH_AUTODESK%\3ds Max 2019\Plugins\HydraMtlLight_2019.dlt"   "%PATH_BINARY%\max2019\"
copy "%PATH_AUTODESK%\3ds Max 2019\Plugins\HydraLight_2019.dlo"      "%PATH_BINARY%\max2019\"


pause