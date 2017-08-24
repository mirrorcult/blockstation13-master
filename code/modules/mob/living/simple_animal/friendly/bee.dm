//holy crap bee!! (tg edition)
/mob/living/simple_animal/goonbee
	name = "Space bee"
	desc = "That's a space bee."
	icon = 'icons/mob/bee.dmi'
	icon_state = "petbee-wings"
	icon_living = "petbee-wings"
	icon_dead = "petbee-dead"
	health = 40
	maxHealth = 40
	var/lazymeter = 0 //makes bee sleep
	var/thickness = 0 //If Bee, Is Fed, Get Thicc!
	var/douwantfeed = 0 //if bee is thicc, pollinate plant. 5/20 chance it actually pollinates.
	var/attacked = 0 //bee turns angery
	var/sleeping = 0 //wheter is it slepeing or not
	var/cangetfat = 1 //can it get thicc
	var/spritestate = "petbee"
	var/originalsprite = "petbee"

/mob/living/simple_animal/goonbee/New()
	..()
	while(health>0)
		sleep(1)
		lazymeter = lazymeter + 1
		searchforhydro(1,0)
		searchforhydro(-1,0)
		searchforhydro(0,1)
		searchforhydro(0,-1)

		if(attacked>0)
			icon_state = "[spritestate]-wings-angery" //angery!!!!!!!!!!
			stop_automated_movement = 0
		else
			if(sleeping==0)
				if(cangetfat==1)
					if(thickness>100)
						spritestate = "bubsbee"
						thickness = thickness - 0.03 //very slow unthicc
					else
						spritestate = originalsprite
				else
					spritestate = originalsprite
				icon_state = "[spritestate]-wings" //bee can move around, buzz, etc
				stop_automated_movement = 0
			else
				if(cangetfat==1)
					if(thickness>100)
						spritestate = "bubsbee"
						thickness = thickness - 0.01 //slower unthicc while sleeping
					else
						spritestate = originalsprite
				else
					spritestate = originalsprite
				icon_state = "[spritestate]-sleep" //bee will sleep, no movement
				stop_automated_movement = 1

		if(lazymeter==1000)
			if(attacked==0)
				sleeping = 1
			else
				lazymeter = 995 //let's try sleeping again later

		if(lazymeter>1500)
			sleeping=  0
			lazymeter = 0

/mob/living/simple_animal/goonbee/proc/searchforhydro(var/offx,var/offy)
	if(isturf(locate(x+offx,y+offy,z)))
		var/turf/t = locate(x+offx,y+offy,z)
		var/obj/machinery/hydroponics/a = t.loc
		if(a)
			a.nutrilevel = a.nutrilevel + 1

/mob/living/simple_animal/goonbee/bullet_act(obj/item/projectile/Proj)
	if(!Proj)
		return
	attacked += 10
	if((Proj.damage_type == BURN))
		adjustBruteLoss(abs(Proj.damage)*2) //fire projectiles hurt bee by the double
		Proj.on_hit(src)
	else
		..(Proj)
	return 0

/mob/living/simple_animal/goonbee/attackby(obj/item/W, mob/living/user, params)
	///obj/item/weapon/reagent_containers/food/snacks/honeybar
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/honeybar) && !stat) //Let's you feed bees honey bars.
		to_chat(user, "<span class='notice'>You feed the bee the honey bar. It buzzes happily.</span>")
		thickness = thickness + 10
		if(thickness>100)
			to_chat(user, "<span class='danger'>You're overfeeding the bee!</span>")
		var/obj/item/weapon/reagent_containers/food/snacks/honeybar/S = W
		qdel(S)
		attacked = 0
		return

	if(istype(W,/obj/item/weapon/disk/bee) && !stat) //GET DNA
		to_chat(user, "<span class='notice'>You carefully take the DNA from the bee.</span>")
		var/obj/item/weapon/disk/bee/S = W
		S.hasdna = 1
		S.icon_state = "beedisk2"
		attacked = 0
		return

	if(W.force > 0)
		attacked += W.force
	..()

/mob/living/simple_animal/goonbee/biian
	name = "Bee-an"
	desc = "Kay Jole's Pet."
	icon_state = "beean-wings"
	icon_living = "beean-wings"
	icon_dead = "beean-dead"
	spritestate = "beean"
	originalsprite = "beean"
	cangetfat = 0

/mob/living/simple_animal/larvagoonbee
	name = "Bee Larva"
	desc = "Buzz!"
	icon = 'icons/mob/bee.dmi'
	icon_state = "petbee_larva"
	icon_living = "petbee_larva"
	icon_dead = "petbee_larva-dead"
	var/grownamount = 0

/mob/living/simple_animal/larvagoonbee/New()
	while(grownamount<1000)
		grownamount = grownamount + 1
		sleep(2)
	icon_state = "petbee_larva-grow"
	sleep(20)
	new /mob/living/simple_animal/goonbee(locate(x,y,z))
	qdel(src)