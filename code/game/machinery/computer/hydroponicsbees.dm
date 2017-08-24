/obj/machinery/computer/hydropc
	name = "hydroponics computer"
	desc = "Used for creating stuff."
	icon_screen = "solar"
	icon_keyboard = "power_key"
	circuit = /obj/item/weapon/circuitboard/computer/hydropc
	light_color = LIGHT_COLOR_YELLOW
	var/mob/living/operator //Who's operating the computer right now
	var/howmuchmatter = 50
	var/researchlevel = 0 //Only normal bees
	var/cooldown = 0
	var/repeatvar = 1

/obj/machinery/computer/hydropc/New()
	..()
	spawn(1)
		while(repeatvar==1)
			if(cooldown>0)
				cooldown = cooldown - 0.1
			sleep(1)

/obj/machinery/computer/hydropc/attack_ai(mob/user)
	if(!IsAdminGhost(user))
		to_chat(user,"<span class='warning'>[src] does not support AI control.</span>") //no0
		return
	..(user)

/obj/machinery/computer/hydropc/interact(mob/living/user)
	var/dat
	dat += "Welcome to the bee upload! Create bees here. Matter : [howmuchmatter]<br>"
	dat += "Bee Research level : [researchlevel]<br>"
	if(researchlevel>0)
		dat += "<a href='?src=\ref[src];create_bee=1'>Create Bee (5 matter)</a><br>"
	else
		dat += "You have no bee research disks installed.<br>"
	if(researchlevel>1)
		dat += "<a href='?src=\ref[src];create_beean=1'>Create Bee-an (5 matter)</a><br>"
	var/datum/browser/popup = new(user, "hydroponics_pc", name, 600, 400)
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(icon, icon_state))
	popup.open()

/obj/machinery/computer/hydropc/Topic(href, href_list)
	if(..())
		return
	if(!usr || !usr.canUseTopic(src) || usr.incapacitated() || stat || QDELETED(src))
		return
	if(cooldown>0)
		say("Warning! Matter recharging, some actions may not work.")
	if(href_list["create_bee"])
		if(cooldown==0)
			//bees!
			if(howmuchmatter>4)
				spawn(1)
					howmuchmatter = howmuchmatter - 5
					var/turf/T = get_turf(src)
					playsound(T, 'sound/items/party_horn.ogg', 50, 1, -1)
					new /mob/living/simple_animal/goonbee(T)
					cooldown = 500
			interact(usr) //Refresh the UI after a filter changes
	if(href_list["create_beean"])
		if(cooldown==0)
		//bees!
			if(howmuchmatter>4)
				spawn(1)
					howmuchmatter = howmuchmatter - 5
					var/turf/T = get_turf(src)
					playsound(T, 'sound/items/party_horn.ogg', 50, 1, -1)
					new /mob/living/simple_animal/goonbee/biian(T)
					cooldown = 500
			interact(usr) //Refresh the UI after a filter changes
	interact(usr) //Refresh the UI after a filter changes

/obj/machinery/computer/hydropc/emag_act(mob/living/user)
	if(emagged)
		return
	user.visible_message("<span class='warning'>You emag [src], Nothing happens. It's emagged though.</span>")
	log_game("[key_name_admin(user)] emagged [src] at [get_area(src)].")
	playsound(src, "sparks", 50, 1)
	emagged = 1

/obj/machinery/computer/hydropc/attackby(obj/item/W, mob/living/user, params)
	///obj/item/weapon/reagent_containers/food/snacks/honeybar
	if(cooldown==0)
		if(istype(W,/obj/item/weapon/disk/bee) && !stat) //Let's you feed bees honey bars.
			var/obj/item/weapon/disk/bee/S = W
			if(S.hasdna==1)
				cooldown = 500
				to_chat(user, "<span class='notice'>You insert the bee data disk And download it.</span>")
				researchlevel = researchlevel + 1
				qdel(S)
				return
	else
		say("Error downloading disk.")
/obj/item/weapon/disk/bee
	name = "bee data disk"
	icon = 'icons/obj/items.dmi'
	icon_state = "beedisk" //Gosh I hope syndies don't mistake them for the nuke disk.
	var/hasdna = 0