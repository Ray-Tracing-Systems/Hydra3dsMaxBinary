/*
Last change: 09/10/2019
Author: Ray Tracing Systems.
Overwrite some of the settings of all the HydraMtl materials.
*/

global OverrideParametersTool
try DestroyDialog OverrideParametersTool catch()

struct structHydraParam 
(
	diffMult,
	reflMult,
	reflExtrus,		
	brdf,
	fresnel,
	bumpTextures
)
	
struct structParamOn
(
	diffMultOn,
	reflMultOn,
	reflExtrusOn,		
	brdfOn,
	fresnelOn,
	bumpTexturesOn
)

paramOn = structParamOn diffMultOn: false reflMultOn: false reflExtrusOn: false brdfOn: false fresnelOn: false bumpTexturesOn: false 

(--start ms
	
fn OverrideParameters mtl hParam=
(		
	case classof mtl of
	(
		hydraMaterial:
		(			
			if (paramOn.diffMultOn == on) 	then mtl.mtl_diffuse_mult  		= hParam.diffMult
			if (paramOn.reflMultOn == on) 	then mtl.mtl_reflect_mult  		= hParam.reflMult	
			if (paramOn.reflExtrusOn) 	then mtl.mtl_reflect_extrusion	= hParam.reflExtrus - 1		
			if (paramOn.fresnelOn)		then mtl.mtl_refl_fresnel_on    	= hParam.fresnel
			if (paramOn.brdfOn) 			then mtl.mtl_reflect_brdf			= hParam.brdf - 1
			if (paramOn.bumpTexturesOn and hParam.bumpTextures != true) then 
				mtl.mtl_normal_map = undefined
		)
		
		--------------------------------------------------------------------------------------------		
		
		MultiMaterial: 
		(
			-- function call itself to harvest the materials inside the MultiMaterial
			local u
			orgMtl = mtl
			
			for u = 1 to mtl.numsubs do 
			(
				OverrideParameters mtl[u] hParam
			)				
		)
		
		--------------------------------------------------------------------------------------------
		
		Blend: 
		(
			OverrideParameters mtl.map1 hParam
			OverrideParameters mtl.map2	hParam	 			
		)	
	)	 
) 


----------------------------------------------------------------
--  Set Parameter Function
-----------------------------------------------------------------

fn setMtlParam mtl param val =
(	
	case classof mtl of
	(
		hydraMaterial:
		(	
			SetProperty mtl param val
		)
	
		MultiMaterial: 
		(                    
			local u
			orgMtl = mtl                    
			for u = 1 to mtl.numsubs do setMtlParam mtl[u] param val                                    
		)
	)
)



----------------------------------------------------------------------------------
-- Menu
----------------------------------------------------------------------------------

rollout OverrideParametersTool "Override parameters tool" width:310 height:340
(
    local mtls = sceneMaterials
    local sel  
	local mtl
    local hParam = structHydraParam diffMult:1 reflMult:1 fresnel:true brdf:1 reflExtrus:1 bumpTextures:true

	
	checkbox 'fresn_chk' "" pos:[179,150] width:18 height:20 checked:true align:#left
	spinner 'diffMult_spn' "" pos:[180,30] width:60 height:16 range:[0,1,1] align:#left
	label 'lbl28' "Diffuse multiply:" pos:[60,30] width:100 height:20 align:#left
	label 'lbl29' "Reflect multiply:" pos:[60,60] width:100 height:20 align:#left
	label 'lbl30' "Bump/normal map:" pos:[60,180] width:110 height:20 align:#left
	spinner 'reflMult_spn' "" pos:[180,60] width:60 height:16 range:[0,1,1] align:#left
	label 'lbl34' "Reflect BRDF:" pos:[60,90] width:100 height:20 align:#left
	label 'lbl35' "Reflect extrusion:" pos:[60,120] width:100 height:20 align:#left
	label 'lbl36' "Reflect fresnel:" pos:[60,150] width:100 height:20 align:#left
	checkbox 'bump_chk' "" pos:[180,180] width:18 height:20 checked:true align:#left
	dropdownList 'brdf_ddl' "" pos:[180,90] width:110 height:21 items:#("Phong", "TorrSparr", "Beckmann", "GGX", "TRGGX") align:#left
	dropdownList 'extrus_ddl' "" pos:[180,120] width:110 height:21 items:#("Strong", "Luminance") align:#left
	
	button 'btnConvert' "Apply" pos:[80,260] width:150 height:40 align:#left	
	
	
	checkbox 'param_diffMult_chk' "" pos:[40,30] width:20 height:20 align:#left
	checkbox 'param_reflMult_chk' "" pos:[40,60] width:20 height:20 align:#left
	checkbox 'param_brdf_chk' "" pos:[40,90] width:20 height:20 align:#left
	checkbox 'param_exrtrus_chk' "" pos:[40,120] width:20 height:20 align:#left
	checkbox 'param_fresnel_chk' "" pos:[40,150] width:20 height:20 align:#left
	checkbox 'param_bump_chk' "" pos:[40,180] width:20 height:20 align:#left
	
	
	on fresn_chk changed state 	do
		hParam.fresnel 				= state
	on diffMult_spn changed val 	do
		hParam.diffMult 			= val
	on reflMult_spn changed val	do
		hParam.reflMult 			= val
	on bump_chk changed state 	do
		hParam.bumpTextures 	= state
	on brdf_ddl selected sel 		do
		hParam.brdf 				= sel
	on extrus_ddl selected sel 		do
		hParam.reflExtrus 		= sel
	
	on btnConvert pressed do
	(	        
	    with undo on
	    (				
			local orgSceneMaterials = OverrideParametersTool.mtls
	        
	        for i = 1 to orgSceneMaterials.count do 
	        (
	            local u
	            if (orgSceneMaterials[i] != undefined) do
				(				
					OverrideParameters orgSceneMaterials[i] hParam
					print ("override " + orgSceneMaterials[i].name)					
				)
	        )		
	    )	
	)
	
	on param_diffMult_chk changed state 			do
		paramOn.diffMultOn 			= state
	on param_reflMult_chk changed state 			do
		paramOn.reflMultOn 			= state
	on param_brdf_chk changed state 		do
		paramOn.brdfOn 			= state
	on param_exrtrus_chk changed state 		do
		paramOn.reflExtrusOn 			= state
	on param_fresnel_chk changed state 		do
		paramOn.fresnelOn 			= state
	on param_bump_chk changed state 		do
		paramOn.bumpTexturesOn 			= state
)

createDialog OverrideParametersTool

)--end ms