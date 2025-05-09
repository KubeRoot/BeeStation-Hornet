/obj/item/storage/wallet
	name = "wallet"
	desc = "It can hold a few small and personal things."
	icon = 'icons/obj/storage/storage.dmi'
	icon_state = "wallet"
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_ID

	var/obj/item/card/id/front_id = null
	var/list/combined_access

/obj/item/storage/wallet/Initialize(mapload)
	. = ..()
	atom_storage.max_slots = 4
	atom_storage.set_holdable(list(
		/obj/item/stack/spacecash,
		/obj/item/holochip,
		/obj/item/card,
		/obj/item/clothing/mask/cigarette,
		/obj/item/flashlight/pen,
		/obj/item/seeds,
		/obj/item/stack/medical,
		/obj/item/toy/crayon,
		/obj/item/coin,
		/obj/item/dice,
		/obj/item/disk,
		/obj/item/implanter,
		/obj/item/lighter,
		/obj/item/lipstick,
		/obj/item/match,
		/obj/item/paper,
		/obj/item/pen,
		/obj/item/photo,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/syringe,
		/obj/item/screwdriver,
		/obj/item/stamp,
		/obj/item/clothing/accessory/badge/officer))

/obj/item/storage/wallet/Exited(atom/movable/gone, direction)
	. = ..()
	refreshID()

/obj/item/storage/wallet/proc/refreshID()
	LAZYCLEARLIST(combined_access)

	if(!(front_id in src))
		front_id = null
	for(var/obj/item/card/id/I in contents)
		if(!front_id)
			front_id = I
		LAZYINITLIST(combined_access)
		combined_access |= I.access
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.wear_id == src)
			H.sec_hud_set_ID()
	update_icon()

/obj/item/storage/wallet/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	refreshID()

/obj/item/storage/wallet/update_icon()
	var/new_state = "wallet"
	if(front_id)
		if("wallet_[front_id.icon_state]" in icon_states(src.icon)) //fixes the bug that would make your wallet disappear with the new ids
			new_state = "wallet_[front_id.icon_state]"
		else
			new_state = "wallet_id"
	if(new_state != icon_state)		//avoid so many icon state changes.
		icon_state = new_state

/obj/item/storage/wallet/GetID()
	return front_id

/obj/item/storage/wallet/RemoveID()
	if(!front_id)
		return
	. = front_id
	front_id.forceMove(get_turf(src))

/obj/item/storage/wallet/InsertID(obj/item/inserting_item)
	var/obj/item/card/inserting_id = inserting_item.RemoveID()
	if(!inserting_id)
		return FALSE
	attackby(inserting_id)
	if(inserting_id in contents)
		return TRUE
	return FALSE

/obj/item/storage/wallet/GetAccess()
	if(LAZYLEN(combined_access))
		return combined_access
	else
		return ..()

/obj/item/storage/wallet/random
	icon_state = "random_wallet"
	worn_icon_state = "wallet"

/obj/item/storage/wallet/random/PopulateContents()
	new /obj/item/holochip(src, rand(5,30))
	update_icon()
