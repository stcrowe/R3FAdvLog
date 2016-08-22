
R3F_LOG_CFG_no_gravity_objects_can_be_set_in_height_over_ground = true;


#include "addons_config\A3_vanilla.sqf"
#include "addons_config\ACE.sqf"



R3F_CF_global_factory = missionNamespace getVariable ["R3F_CF_global_factory",
	[
		["Sand Bags", "Concrete Barriers", "H-Barriers", "Bunkers", "Road Block", "Lamps", "Signs", "Flags", "Camo", "Statics", "Wood", "Misc"],

		[
			// Sand Bags
			["Land_BagFence_Corner_F",
			"Land_BagFence_End_F",
			"Land_BagFence_Long_F",
			"Land_BagFence_Round_F",
			"Land_BagFence_Short_F",
			"Land_BagFence_01_corner_green_F",
			"Land_BagFence_01_end_green_F",
			"Land_BagFence_01_long_green_F",
			"Land_BagFence_01_round_green_F",
			"Land_BagFence_01_short_green_F"

			],

			//CB
			[
			"Land_CncBarrier_F",
			"Land_CncBarrierMedium_F",
			"Land_CncBarrierMedium4_F",
			"Land_CncBarrier_stripes_F",
			"Land_CncWall1_F",
			"Land_CncWall4_F",
			"Land_Concrete_SmallWall_4m_F",
			"Land_Concrete_SmallWall_8m_F",
			"Land_CncShelter_F"
			],

			//H-B
			[
			"Land_HBarrier_1_F",
			"Land_HBarrier_3_F",
			"Land_HBarrier_5_F",
			"Land_HBarrier_Big_F",
			"Land_HBarrierWall_corridor_F",
			"Land_HBarrierWall_corner_F",
			"Land_HBarrierWall6_F",
			"Land_HBarrierWall4_F",
			"Land_HBarrierTower_F",
			"Land_HBarrier_01_line_1_green_F",
			"Land_HBarrier_01_line_3_green_F",
			"Land_HBarrier_01_line_5_green_F",
			"Land_HBarrier_01_big_4_green_F",
			"Land_HBarrier_01_wall_corridor_green_F",
			"Land_HBarrier_01_wall_corner_green_F",
			"Land_HBarrier_01_wall_6_green_F",
			"Land_HBarrier_01_wall_4_green_F",
			"Land_HBarrier_01_big_tower_green_F"
			],

			// Bunkers
			[
				"Land_BagBunker_Small_F",
				"Land_BagBunker_Large_F",
				"Land_BagBunker_Tower_F",
				"Land_BagBunker_01_small_green_F",
				"Land_BagBunker_01_large_green_F",
				"Land_HBarrier_01_tower_green_F"
			],

			//Road Block
			["ArrowDesk_L_F",
			"ArrowDesk_R_F",
			"RoadCone_F",
			"RoadCone_L_F",
			"RoadBarrier_small_F",
			"RoadBarrier_F",
			"Land_RoadCone_01_F",
			"Land_BarGate_F",
			"Land_Razorwire_F"],

			//Lamps
			[
			"Land_Camping_Light_F",
			"Land_PortableLight_single_F",
			"Land_PortableLight_double_F"
			],

			//Signs
			[
			"Land_Sign_WarningMilitaryArea_F",
			"Land_Sign_Mines_F",
			"Land_Sign_WarningUnexplodedAmmo_F",
			"Land_Sign_WarningMilitaryVehicles_F",
			"Land_Sign_WarningMilAreaSmall_F"
			],

			//Flags
			[
			"Flag_US_F",
			"Flag_UK_F",
			"Flag_Altis_F",
			"Flag_AltisColonial_F",
			"Flag_UNO_F",
			"Flag_NATO_F",
			"Flag_CTRG_F",
			"Flag_Gendarmerie_F",
			"Flag_AAF_F",
			"Flag_FIA_F",
			"Flag_CSAT_F",
			"Flag_Viper_F",
			"Flag_RedCrystal_F",
			"Flag_FD_Blue_F",
			"Flag_FD_Green_F",
			"Flag_FD_Orange_F",
			"Flag_FD_Purple_F",
			"Flag_FD_Red_F",
			"Flag_Green_F",
			"Flag_Blue_F",
			"Flag_Red_F",
			"Flag_White_F"
			],

			//Camo
			[
			"CamoNet_OPFOR_F",
			"CamoNet_OPFOR_open_F",
			"CamoNet_OPFOR_big_F",
			"CamoNet_BLUFOR_F",
			"CamoNet_BLUFOR_open_F",
			"CamoNet_BLUFOR_big_F",
			"CamoNet_INDP_F",
			"CamoNet_INDP_open_F",
			"CamoNet_INDP_big_F",
			"CamoNet_ghex_F",
			"CamoNet_ghex_open_F",
			"CamoNet_ghex_big_F",
			"Land_IRMaskingCover_01_F",
			"Land_IRMaskingCover_02_F"
			],

			[
			"B_HMG_01_high_F",
			"B_HMG_01_F",
			"B_Mortar_01_F"
			],

			//Wood
			[
			"Land_Obstacle_Ramp_F",
			"Land_Obstacle_Bridge_F",
			"Land_Obstacle_Climb_F",
			"Land_Plank_01_8m_F",
			"Land_Plank_01_4m_F"
			],

			//Misc
			[
			"Land_CampingChair_V2_F",
			"Land_CampingTable_F",
			"Land_CampingTable_small_F",
			"Land_CampingChair_V1_F",
			"Land_TentDome_F",
			"Land_Campfire_F",
			"Land_PaperBox_closed_F",
			"Land_PaperBox_open_empty_F",
			"Land_Pallet_MilBoxes_F",
			"Land_Laptop_device_F",
			"Land_Laptop_unfolded_F",
			"Land_TentA_F",
			"Land_FieldToilet_F",
			"Land_Pallets_F",
			"Land_ToiletBox_F",
			"Land_TripodScreen_01_dual_v1_F",
			"Land_Portable_generator_F",
			"Land_TripodScreen_01_dual_v2_F",
			"Land_TripodScreen_01_large_F",
			"Land_PortableGenerator_01_F",
			"Land_SatelliteAntenna_01_F",
			"MapBoard_seismic_F",
			"MapBoard_stratis_F",
			"MapBoard_altis_F",
			"Land_MapBoard_F"
			]
		],

		[
			[10, 5, 10, 10, 10, 10, 5, 10, 10, 10],
			[15, 40, 60, 15, 20, 30, 100, 180, 200],
			[10, 20, 30, 40, 80, 50, 50, 50, 500, 10, 20, 30, 40, 80, 50, 50, 50, 500],
			[100, 300, 500, 100, 300, 500],
			[5, 5, 5, 5, 5, 5, 10, 5],
			[5, 10, 20],
			[5, 2, 5, 5, 5],
			[5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5],
			[10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 40, 30],
			[500, 500, 500],
			[10, 20, 20, 10, 5],
			[5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5]
		]
	]
];