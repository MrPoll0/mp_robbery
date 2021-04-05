MP = {}
MP.Config = {}

MP.Config.Locales = {
    ['alreadyRobbed'] = "¡Ya me han robado y ~r~no ~w~me queda dinero!",
    ['cashrecieved'] = 'Has robado:',
    ['currency'] = '€',
    ['no_cops'] = '~r~No ~w~hay suficientes ~b~policías',
    ['cop_msg'] = 'La cámara de seguridad ha tomado una foto del ladrón',
    ['kill_msg'] = 'La cámara de seguridad ha tomado una foto del asesino',
    ['set_waypoint'] = 'Establecer la ruta en el GPS',
    ['robbery'] = 'Robo en progreso',
    ['kill'] = 'Asesinato',
    ['too_far_bag'] = 'Estás demasiado lejos de la bolsa y las ratas te han robado el dinero',
    ['walked_too_far'] = 'Has salido de la zona del robo'
}

local city = GetConvar("city", "")

if city == "Paleto Bay" then 
MP.Config.Locations = {
	["24/7"] = {
		[1] = {
			name = "24/7 Paleto",
			coords = vector3(1727.57, 6415.1, 34.04), 
			heading = 237.46,
			reward = {2500, 5000},
			coolDown = 1800000,
			policeRequired = 3,
			robbed = false,
			robbing = false,
		},
		[2] = {
			name = "LTD Grapeseed",
			coords = vector3(1696.76, 4923.38, 41.06), 
			heading = 329.61,
			reward = {2500, 5000},
			coolDown = 1800000,
			policeRequired = 3,
			robbed = false,
			robbing = false,
		},
		[3] = {
			name = "24/7 Palominio",
			coords = vector3(2678.39, 3278.73, 54.24), 
			heading = 333.75,
			reward = {2500, 5000},
			coolDown = 1800000,
			policeRequired = 3,
			robbed = false,
			robbing = false,
		},
		[4] = {
			name = "24/7 Paleto",
			coords = vector3(160.21, 6641.65, 30.71), 
			heading = 225.06,
			reward = {2500, 5000},
			coolDown = 1800000,
			policeRequired = 3,
			robbed = false,
			robbing = false,
		},
		[5] = {
			name = "Paleto Liquor",
			coords = vector3(-161.03, 6321.16, 30.59), 
			heading = 316.35,
			reward = {2500, 5000},
			coolDown = 1800000,
			policeRequired = 3,
			robbed = false,
			robbing = false,
		},
		[6] = {
			name = "24/7 Great Ocean",
			coords = vector3(-2539.1, 2314.13, 32.41), 
			heading = 92.61,
			reward = {2500, 5000},
			coolDown = 1800000,
			policeRequired = 3,
			robbed = false,
			robbing = false,
		},
	},
	["Bank"] = {
		[1] = {
			name = "",
			coords = vector3(0.0, 0.0, 0.0),
			reward = 0,
			time = 0,
			waitTime = 0,
			policeRequired = 0,
			itemsRequired = {}
		},
	},
	["GrandBank"] = {
		[1] = {
			name = "",
			coords = vector3(0.0, 0.0, 0.0),
			reward = 0,
			time = 0,
			waitTime = 0,
			policeRequired = 0,
			itemsRequired = {}
		},
	}
}
elseif city == "Los Santos" then 
	MP.Config.Locations = {
	["24/7"] = {
		[1] = {
			name = "24/7 Paleto",
			coords = vector3(-1486.29, -378.02, 39.16), 
			heading = 139.41,
			reward = {2500, 5000},
			coolDown = 1800000,
			policeRequired = 3,
			robbed = false,
			robbing = false,
		},
		[2] = {
			name = "LTD Grapeseed",
			coords = vector3(-1221.97, -908.29, 11.33), 
			heading = 29.16,
			reward = {2500, 5000},
			coolDown = 1800000,
			policeRequired = 3,
			robbed = false,
			robbing = false,
		},
		[3] = {
			name = "24/7 Palominio",
			coords = vector3(-706.13, -913.56, 18.22), 
			heading = 91.18,
			reward = {2500, 5000},
			coolDown = 1800000,
			policeRequired = 3,
			robbed = false,
			robbing = false,
		},
		[4] = {
			name = "24/7 Paleto",
			coords = vector3(-46.63, -1757.85, 28.42), 
			heading = 43.45,
			reward = {2500, 5000},
			coolDown = 1800000,
			policeRequired = 3,
			robbed = false,
			robbing = false,
		},
		[5] = {
			name = "Paleto Liquor",
			coords = vector3(24.48, -1347.24, 28.5), 
			heading = 260.75,
			reward = {2500, 5000},
			coolDown = 1800000,
			policeRequired = 3,
			robbed = false,
			robbing = false,
		},
		[6] = {
			name = "24/7 Great Ocean",
			coords = vector3(1134.16, -982.55, 45.42), 
			heading = 275.62,
			reward = {2500, 5000},
			coolDown = 1800000,
			policeRequired = 3,
			robbed = false,
			robbing = false,
		},
		[7] = {
			name = "24/7 Great Ocean",
			coords = vector3(1164.74, -322.63, 68.21), 
			heading = 102.17,
			reward = {2500, 5000},
			coolDown = 1800000,
			policeRequired = 3,
			robbed = false,
			robbing = false,
		},
		[8] = {
			name = "24/7 Great Ocean",
			coords = vector3(372.49, 326.39, 102.57), 
			heading = 256.84,
			reward = {2500, 5000},
			coolDown = 1800000,
			policeRequired = 3,
			robbed = false,
			robbing = false,
		},
		[9] = {
			name = "24/7 Great Ocean",
			coords = vector3(-2966.41, 390.99, 14.04), 
			heading = 85.62,
			reward = {2500, 5000},
			coolDown = 1800000,
			policeRequired = 3,
			robbed = false,
			robbing = false,
		},
		[10] = {
			name = "24/7 Great Ocean",
			coords = vector3(2557.2, 380.76, 107.62), 
			heading = 352.01,
			reward = {2500, 5000},
			coolDown = 1800000,
			policeRequired = 3,
			robbed = false,
			robbing = false,
		},
	},
	["Bank"] = {
		[1] = {
			name = "",
			coords = vector3(0.0, 0.0, 0.0),
			reward = 0,
			time = 0,
			waitTime = 0,
			policeRequired = 0,
			itemsRequired = {}
		},
	},
	["GrandBank"] = {
		[1] = {
			name = "",
			coords = vector3(0.0, 0.0, 0.0),
			reward = 0,
			time = 0,
			waitTime = 0,
			policeRequired = 0,
			itemsRequired = {}
		},
	}
}

end