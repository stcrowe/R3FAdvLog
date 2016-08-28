
R3F_LOG_CFG_no_gravity_objects_can_be_set_in_height_over_ground = true;


#include "addons_config\A3_vanilla.sqf"
#include "addons_config\ACE.sqf"

// public variables for creation factory
R3F_LOG_CFG_CF_sell_back_bargain_rate = 0.75;
R3F_LOG_CFG_CF_resell_time = 3;

R3F_CF_global_factory =
	[
		["Sand Bags", "Concrete Barriers", "H-Barriers", "Bunkers", "Road Block", "Lamps", "Signs", "Flags", "Camo", "Statics", "Wood", "Misc"],

		[
			// Sand Bags
			[
				["Land_BagFence_Corner_F", 10],
				["Land_BagFence_End_F", 5],
				["Land_BagFence_Long_F", 10],
				["Land_BagFence_Round_F", 10],
				["Land_BagFence_Short_F", 10],
				["Land_BagFence_01_corner_green_F", 10],
				["Land_BagFence_01_end_green_F", 5],
				["Land_BagFence_01_long_green_F", 10],
				["Land_BagFence_01_round_green_F", 10],
				["Land_BagFence_01_short_green_F", 10]

			],

			//CB
			[
				["Land_CncBarrier_F", 15],
				["Land_CncBarrierMedium_F", 40],
				["Land_CncBarrierMedium4_F", 60],
				["Land_CncBarrier_stripes_F", 15],
				["Land_CncWall1_F", 20],
				["Land_CncWall4_F", 30],
				["Land_Concrete_SmallWall_4m_F", 100],
				["Land_Concrete_SmallWall_8m_F", 180],
				["Land_CncShelter_F", 200]
			],

			//H-B
			[
				["Land_HBarrier_1_F", 10],
				["Land_HBarrier_3_F", 20],
				["Land_HBarrier_5_F", 30],
				["Land_HBarrier_Big_F", 40],
				["Land_HBarrierWall_corridor_F", 80],
				["Land_HBarrierWall_corner_F", 60],
				["Land_HBarrierWall6_F", 60],
				["Land_HBarrierWall4_F", 50],
				["Land_HBarrierTower_F", 500],
				["Land_HBarrier_01_line_1_green_F", 10],
				["Land_HBarrier_01_line_3_green_F", 20],
				["Land_HBarrier_01_line_5_green_F", 30],
				["Land_HBarrier_01_big_4_green_F", 40],
				["Land_HBarrier_01_wall_corridor_green_F", 80],
				["Land_HBarrier_01_wall_corner_green_F", 60],
				["Land_HBarrier_01_wall_6_green_F", 60],
				["Land_HBarrier_01_wall_4_green_F", 50],
				["Land_HBarrier_01_big_tower_green_F", 500]
			],

			// Bunkers
			[
				["Land_BagBunker_Small_F", 100],
				["Land_BagBunker_Large_F", 300],
				["Land_BagBunker_Tower_F", 500],
				["Land_BagBunker_01_small_green_F", 100],
				["Land_BagBunker_01_large_green_F", 300],
				["Land_HBarrier_01_tower_green_F", 500]
			],

			//Road Block
			[
				["ArrowDesk_L_F", 5],
				["ArrowDesk_R_F", 5],
				["RoadCone_F", 5],
				["RoadCone_L_F", 5],
				["RoadBarrier_small_F", 5],
				["RoadBarrier_F", 5],
				["Land_RoadCone_01_F", 5],
				["Land_BarGate_F", 15],
				["Land_Razorwire_F", 5]
			],

			//Lamps
			[
				["Land_Camping_Light_F", 5],
				["Land_PortableLight_single_F", 10],
				["Land_PortableLight_double_F", 20]
			],

			//Signs
			[
				["Land_Sign_WarningMilitaryArea_F", 5],
				["Land_Sign_Mines_F", 2],
				["Land_Sign_WarningUnexplodedAmmo_F", 5],
				["Land_Sign_WarningMilitaryVehicles_F", 5],
				["Land_Sign_WarningMilAreaSmall_F", 5]
			],

			//Flags
			[
				["Flag_US_F", 5],
				["Flag_UK_F", 5],
				["Flag_Altis_F", 5],
				["Flag_AltisColonial_F", 5],
				["Flag_UNO_F", 5],
				["Flag_NATO_F", 5],
				["Flag_CTRG_F", 5],
				["Flag_Gendarmerie_F", 5],
				["Flag_AAF_F", 5],
				["Flag_FIA_F", 5],
				["Flag_CSAT_F", 5],
				["Flag_Viper_F", 5],
				["Flag_RedCrystal_F", 5],
				["Flag_FD_Blue_F", 5],
				["Flag_FD_Green_F", 5],
				["Flag_FD_Orange_F", 5],
				["Flag_FD_Purple_F", 5],
				["Flag_FD_Red_F", 5],
				["Flag_Green_F", 5],
				["Flag_Blue_F", 5],
				["Flag_Red_F", 5],
				["Flag_White_F", 5]
			],

			//Camo
			[
				["CamoNet_OPFOR_F", 10],
				["CamoNet_OPFOR_open_F", 10],
				["CamoNet_OPFOR_big_F", 10],
				["CamoNet_BLUFOR_F", 10],
				["CamoNet_BLUFOR_open_F", 10],
				["CamoNet_BLUFOR_big_F", 10],
				["CamoNet_INDP_F", 10],
				["CamoNet_INDP_open_F", 10],
				["CamoNet_INDP_big_F", 10],
				["CamoNet_ghex_F", 10],
				["CamoNet_ghex_open_F", 10],
				["CamoNet_ghex_big_F", 10],
				["Land_IRMaskingCover_01_F", 40],
				["Land_IRMaskingCover_02_F", 30]
			],

			[
				["B_HMG_01_high_F", 500],
				["B_HMG_01_F", 500],
				["B_Mortar_01_F", 500]
			],

			//Wood
			[
				["Land_Obstacle_Ramp_F", 10],
				["Land_Obstacle_Bridge_F", 20],
				["Land_Obstacle_Climb_F", 20],
				["Land_Plank_01_8m_F", 10],
				["Land_Plank_01_4m_F", 5]
			],

			//Misc
			[
				["Land_CampingChair_V2_F", 5],
				["Land_CampingTable_F", 5],
				["Land_CampingTable_small_F", 5],
				["Land_CampingChair_V1_F", 5],
				["Land_TentDome_F", 5],
				["Land_Campfire_F", 10],
				["Land_PaperBox_closed_F", 5],
				["Land_PaperBox_open_empty_F", 5],
				["Land_Pallet_MilBoxes_F", 5],
				["Land_Laptop_device_F", 5],
				["Land_Laptop_unfolded_F", 5],
				["Land_TentA_F", 5],
				["Land_FieldToilet_F", 5],
				["Land_Pallets_F", 5],
				["Land_ToiletBox_F", 5],
				["Land_TripodScreen_01_dual_v1_F", 5],
				["Land_Portable_generator_F", 5],
				["Land_TripodScreen_01_dual_v2_F", 5],
				["Land_TripodScreen_01_large_F", 5],
				["Land_PortableGenerator_01_F", 5],
				["Land_SatelliteAntenna_01_F", 5],
				["MapBoard_seismic_F", 5],
				["MapBoard_stratis_F", 5],
				["MapBoard_altis_F", 5],
				["Land_MapBoard_F", 5]
			]
		]
];