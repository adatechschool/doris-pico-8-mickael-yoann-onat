pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

function _init()
 hud_x=0
 hud_y=0
 create_player()
 sorts={}
 enemies={}
	count_time = 200
 _update= menu_update
 _draw= menu_draw
 init_msg()
	create_msg("yom",c_intro_text_1,
	c_intro_text_2, c_intro_text_3,c_intro_text_4)
 music_start=false
 init_game_state()
 score=0
 flash_duration = 1
 flash_start_time = 0
end

function game_update()
 update_msg()
 	if not music_start then
  --music(0)
		music_start=true
	end
	if not messages[1] then
		player_movement()
		count_time +=1
	end
 
	update_camera()
	
	--shoot
	if btnp(❎) and p.state=="white" then
	gandalf()
	elseif (btnp(❎) and p.state=="normal") 
					or (btnp(❎) and p.state=="fire")
					or (btnp(❎) and p.state=="water")
					or (btnp(❎) and p.state=="plant")
	then shoot()
	end
	
	
	 
	update_sorts()
 	if count_time==500 then -- 5 secondes environ
		spawn_enemies(ceil(rnd(wave_size)))
		count_time=0
		wave_size += 1
	end
	update_enemies()
	whereIs_topLeft()

end





function game_draw()
	cls()
	draw_map()
	draw_player()
	draw_msg()
	hud()
	draw_ui()
	print("score:"..score,hud_x,hud_y,7)
	
	--flash
	if time()-flash_start_time < flash_duration then
	rectfill(0, 0, 127*8, 127*8, 7)
	end

	--enemies
	for e in all (enemies) do
		if e.state=="normal" then
			spr(44,e.x*8+e.eox,e.y*8+e.eoy)
		end
		if e.state=="fire" then
			spr(60,e.x*8+e.eox,e.y*8+e.eoy)
		end
		if e.state=="water" then
			spr(61,e.x*8+e.eox,e.y*8+e.eoy)
		end
		if e.state=="plant" then
			spr(62,e.x*8+e.eox,e.y*8+e.eoy)	
		end
		--print(e.state)
	end
	
	for s in all (sorts) do
		spr(p.power_sprite,s.x*8,s.y*8)
	end

--	print(p.ballspeed)
--	print(p.axe)


end

function  menu_update()
 if  btn(5) then
 _update= game_update
 _draw= game_draw
 end
end


function menu_draw ()
camera()
	cls(3)
	rectfill(31,83,105,119,14)
	rectfill(28,80,102,116,2)
	spr(40,128/2-4,64)
	spr(44,128/1-20,64)
	spr(44,128/1-40,64)
	spr(44,128/1-100,64)
	spr(44,128/1-120,64)
	spr(16,128/1-120,20,2,2)
	spr(57,128/1-47,64)
	spr(57,128/1-58,64)
 print("yom",60,35,7)
	print(c_title_text,25,86,7)
 print("press x  pour start",30,105,7)
 c_title_text="l'invasion des monstres!"
end
 
function whereIs_topLeft()
if(p.x<=7) then
	hud_x = 0
elseif(p.x>=120) then
	hud_x = 112*8
else
	hud_x = p.x*8+p.ox-7.5*8
end
if(p.y<=7) then
	hud_y = 0
elseif(p.y>=56) then
	hud_y = 48*8
else 
	hud_y = p.y*8+p.oy-7.5*8
end
end
 
 function hud()

	if p.life==3 then
		spr(65,hud_x+107,hud_y)
	  	spr(65,hud_x+113,hud_y)
	  	spr(65,hud_x+119,hud_y)
  	elseif p.life==2 then
		spr(65,hud_x+107,hud_y)
		spr(65,hud_x+113,hud_y)
		spr(67,hud_x+119,hud_y)
   elseif p.life==1 then
		spr(65,hud_x+107,hud_y)
		spr(67,hud_x+113,hud_y)
		spr(67,hud_x+119,hud_y)
   elseif p.life<=0 then
		spr(67,hud_x+107,hud_y)
		spr(67,hud_x+113,hud_y)
		spr(67,hud_x+119,hud_y)
  
 	end
end 
function draw_ui()
hud()

 end
 



function draw_game_state()

  cls()
  print("hp: " .. state.life, 0, 0, 7)
end
-->8
--map

function draw_map()
	map(0,0,0,0,128,64)
end

function check_flag(flag,x,y)
	local sprite=mget(x,y)
	return fget(sprite,flag)
end





function update_camera()
	local camx=mid(0,p.x-7.5+p.ox/8,127-15)
	local camy=mid(0,p.y-7.5+p.oy/8,63-15)
	camera(camx*8,camy*8)
end


//function next_tile(x,y)

// sprite=mget(x,y)
 //mset(x,y,sprite+1)
//end

//function pick_up_power(x,y)
//next_tile(x,y)
//p.power+=1
//sfx(1)
//end
    
    
-->8
--player

function create_player()
	p={x=5,y=5,
	ox=0, oy=0,
	start_ox=0,start_oy=0,
	anim_t=0,
	sprite=40,
	power=1,ballspeed=3,portee=40,
	life=3,
	axe="x",
	state="normal",
	power_sprite=41,
	shoot_sfx=sfx(06)
	}
end




function draw_player()
	spr(p.sprite,p.x*8+p.ox,p.y*8+p.oy)

end

sens = 0

function player_movement()

newx=p.x
newy=p.y

--test de sante 
--  (btn(5)) then 
--	if (live >0) live -=1
--end






if p.anim_t == 0 then

	newox=0
	newoy=0

	if btn(➡️) then
		newx+=1
		newox=-8
		p.axe = "x"
 		if p.ballspeed<0 and p.portee<0 then
  		p.ballspeed=p.ballspeed*(-1)
  		p.portee=p.portee*(-1)
 		end
	elseif btn(⬅️) then
 		newx-=1
 		newox=8
 		p.axe = "x"
 		if p.ballspeed>0 and p.portee>0 then
  			p.ballspeed=p.ballspeed*(-1)
  			p.portee=p.portee*(-1)
 		end
	elseif btn(⬇️) then
		newy+=1
		newoy=-8
		p.axe = "y"
		if p.ballspeed<0 then
  			p.ballspeed=p.ballspeed*(-1)
  			p.portee=p.portee*(-1)
 		end
	elseif btn(⬆️) then
		newy-=1
		newoy=8
		p.axe = "y"
		if p.ballspeed>0 then
  			p.ballspeed=p.ballspeed*(-1)
  			p.portee=p.portee*(-1)
 		end
	end
end
-- interact(newx,newy)
	
	if (newx!=p.x or newy!=p.y) and not check_flag(0,newx,newy) then
		p.x=mid(0,newx,127)
		p.y=mid(0,newy,63)
		p.start_ox=newox
		p.start_oy=newoy
		p.anim_t=1
	end
	
--animation joueur
p.anim_t=max(p.anim_t-0.4,0)
p.ox=p.start_ox*p.anim_t
p.oy=p.start_oy*p.anim_t

-- //function interact(x,y)
-- // if check_flag(2,x,y) then
-- //pick_up_power(x,y)

--  //end
-- //end
change_state()

end


--interaction 3 elements

function change_state()
	if check_flag(1,p.x,p.y) then 
	p.sprite=36
	p.state="fire"
	p.power_sprite=57
	shoot_sfx=sfx(03)
	elseif check_flag(2,p.x,p.y) then 
	p.sprite=37
	p.state="water"
	p.power_sprite=58
	shoot_sfx=sfx(04)
	elseif check_flag(3,p.x,p.y) then 
	p.sprite=38
	p.state="plant"
	p.power_sprite=59
	shoot_sfx=sfx(05)
	elseif check_flag(4,p.x,p.y) then
	p.state="white"
	p.sprite=39
	end
end





-->8
--sorts


function shoot()
sfx(shoot_sfx)
local player_x=p.x
local player_y=p.y
local player_portee = p.portee
local player_axe = p.axe
local player_ballspeed = p.ballspeed
	local new_ball={
		position_init_x = player_x,
		position_init_y = player_y,
		x=player_x,
		y=player_y,
		speed=player_ballspeed/8,
		portee=player_portee/8,
		axe = player_axe
	}
	add(sorts,new_ball)
end



function update_sorts()
	for i, s in ipairs(sorts) do
		
		if s.axe == "x" then
		s.x += s.speed
		end
		if s.axe == "y" then
		s.y += s.speed
		end
		if (s.portee > 0 and s.x > (s.position_init_x + s.portee)) then
			del(sorts, s)
		elseif (s.portee < 0 and s.x < (s.position_init_x + s.portee)) then
			del(sorts, s)
		elseif (s.portee > 0 and s.y > (s.position_init_y + s.portee)) then
			del(sorts, s)
		elseif (s.portee < 0 and s.y < (s.position_init_y + s.portee)) then
			del(sorts, s)
		end
	end
end

function gandalf()
		if p.state=="white" then
			flash_start_time = time() -- t-0 du flash			
			enemies={}
			score += 5
			p.state="normal"
			p.sprite=40
		end
end
-->8
--enemies

wave_size = 5
elements={"normal", "fire", "plant", "water"}

function spawn_enemies(amount)
	gap=(20-8*amount)/(amount+1)
	state_init=rnd(elements)
	for i=1,amount do
		new_enemy={
		x=p.x+gap*i+8*(i-1),
		y=p.y+gap*i+8*(i-1),
		blocked = 0,
		anim_te=0,
		start_eox=0,
		start_eoy=0,   
		life=2,
		speed=0.1,
		eox = 0,
		eoy = 0,
		state=state_init
		}
		local spawn_spot = flr(rnd(4))+1
			if (spawn_spot == 1) new_enemy.x -= 30 
			if (spawn_spot == 2) new_enemy.x += 30
			if (spawn_spot == 3) new_enemy.y -= 30
			if (spawn_spot == 4) new_enemy.y += 30

		add(enemies,new_enemy)
 	end
end

function update_enemies()



	if rnd(1)<0.5 then
		change_way=true
	else 
		change_way=false
	end

	for e in all(enemies) do

		if (e.blocked>50 and ((p.x-e.x < -100/8) or (p.x-e.x > 100/8) or (p.y-e.y < -100/8) or (p.y-e.y > 100/8))) then
			e.anim_te = 0
		
			if p.x>e.x then
				
				e.x += 1
				-- e.eox = e.x
			
			elseif p.x<e.x then
				
				e.x -= 1
				-- e.eox = e.x
				
			end
		

			if p.y>e.y then
				
				e.y += 1
				-- e.eoy = e.y
				
			elseif p.y<e.y then
 				
				e.y -= 1
				-- e.eoy = e.y
		
			end
		end

	
		enemy_newx = e.x
		enemy_newy= e.y
		enemy_newox = 0
		enemy_newoy = 0

		if e.anim_te == 0 then

		
			if p.x>e.x and not change_way then
			
				enemy_newx += 1
				enemy_newox = -8
			
			elseif p.x<e.x and not change_way then
				
 				enemy_newx -= 1
				enemy_newox = 8
				
			end
		
		

			if p.y>e.y and change_way then
				
				enemy_newy += 1
				enemy_newoy = -8
				
			elseif p.y<e.y and change_way then
 				
				enemy_newy -= 1
				enemy_newoy = 8
		
			end
		end

		if check_flag(0,enemy_newx,e.y) then
			e.blocked += 1
		end

		if check_flag(0,e.x,enemy_newy) then
			e.blocked += 1
		end

		if (enemy_newx!=e.x or enemy_newy!=e.y) and not check_flag(0,enemy_newx,enemy_newy) then
			e.x=mid(0,enemy_newx,127)
			e.y=mid(0,enemy_newy,63)
			e.start_eox = enemy_newox
			e.start_eoy = enemy_newoy
			e.anim_te=1
			e.blocked = 0
		
		end	

		e.anim_te=max(e.anim_te-e.speed,0)
		e.eox=e.start_eox*e.anim_te
		e.eoy=e.start_eoy*e.anim_te
	
		if ((e.x-p.x)<0.8) and ((e.y-p.y)<0.8) and ((e.x-p.x>-0.8)) and ((e.y-p.y)>-0.8) then
			p.life -= 1
			del(enemies,e)
		end

		

		for s in all(sorts) do
			if ((s.x-e.x)<0.8) and ((s.y-e.y)<0.8) and ((s.x-e.x>-0.8)) and ((s.y-e.y)>-0.8)then
				if p.state=="normal" then
					e.life -=1
				end
				
				if p.state=="fire" then	
				 if e.state=="water" then
				 	e.life -=0
				 elseif e.state=="plant" then
				 	e.life -=2
				 else
				 	e.life -=1
					end
				end
				
				if p.state=="water" then	
				 if e.state=="plant" then
				 	e.life -=0
				 elseif e.state=="fire" then
				 	e.life -=2
				 else
				 	e.life -=1
					end
				end
				
				if p.state=="plant" then	
				 if e.state=="fire" then
				 	e.life -=0
				 elseif e.state=="water" then
				 	e.life -=2
				 else
				 	e.life -=1
					end
				end
				
			del(sorts,s)
			end
		
		end
		
		
		
			if e.life == 0 then
				del(enemies,e)
				score += 1
			end
	 
	
	end
end

-->8
-- tables

--[[
sorts
normal={sprite=40,
								power=1,
								power_sprite=41
								--sfx(06),
								--ballspeed=2,
								--portee=50,
								--active=true
							}
							
fire		={sprite=36,
								power=1,
								power_sprite=57
								--sfx(03),
								--ballspeed=2,
								--portee=50,
								--active=false
							}
							
water	={sprite=37,
								power=1,
								power_sprite=58
								--sfx(04),
								--ballspeed=2,
								--portee=50,
								--active=false
							}
							
plant	={sprite=38,
								power=1,
								power_sprite=59
								--sfx(05),
								--ballspeed=2,
								--portee=50,
							 --active=false
							}

	
----------------------------
enemies

e={normal, fire, water, plant}

e.normal={spr=44,life=4}

e.fire={spr=45,life=4}

e.water={spr=46,life=4}

e.plant={spr=47,life=4}


if p.fire then
	else if e.water then
 	p.fire.power=0
	else if e.plant then
 	p.fire.power=2
	
else if p.water then
 if e.fire then
 	p.water.power=2
 else if e.plant then
 	p.water.power=0
	
else if p.plant then
 if e.fire then
 	p.plant.power=0
	else if e.water then
 	p.plant.power=2
 	
]]
-->8
--message

function init_msg()
 msg_title=""
	messages={}
end

function create_msg(name,...)
	msg_title=name
	messages={...}
end

function update_msg()
	if (btnp(4)) then
		if messages[1] then
			sfx(0)
			deli(messages,1)
		end
	end
end

function draw_msg()
	if messages[1] then
		local y=90
		rectfill(10,y,15+#msg_title*3,
			y+8,1)
		print(msg_title,10,y+1,6)
		rectfill(1,y+9,135,y+21,1)
		print(messages[1],1,y+10,6)
	end
end

c_intro_text_1="oh nonnnn! \npress c to continue"
c_intro_text_2="une invasion de monstres...\npress c to continue"
c_intro_text_3="je dois les battre a tout prix!!! \nle sort de la planete en depend!\npress c to continue"
c_intro_text_4="press x to shoot"
c_intro_text_5="you shall not pass !!!"
-->8



function init_game_state()

state = {
    life = 100,
      }
end



function update_game_state()

 if ((e.x-p.x)<0.8) and ((e.y-p.y)<0.8) and ((e.x-p.x>-0.8)) and ((e.y-p.y)>-0.8) then
    state.life = state.life - 1
    
 end 
   if btn(5) then
    state.life = state.life + 1
  end
end

 
 

__gfx__
dddddddd3333333333bbbb33cccccccc4444444433333333444444443333333333333333311311134d4d4d4dd6d6545422f44407777777773366663333333333
dddddddd333333333bbaabb3ccccccccdddddddd333b33334444444433633333333b33331cc1ccc155555554d6d65d5d22f44407777777773663366333333833
dddddddd333333333bbbab13cccccccccccccccc33ba333344444444636363333b3b3b331ccca1134d4d4d4dd6dd54540000000777777777366636d333383838
dddddddd333333333bbbb313cccccccccccccccc3ba3ab1344444444333333333333333331ca9cc155555555ddd65d5d2f44407777777777366663d333333333
dddddddd33333333313b3313cccccccccccccccc313a3b134444444433333333333333331cccccc166d666d6d6d654542f44407777777777363633d333333333
dddddddd3333333333111133cccccccccccccccc331111334444444433333333333333331c1cc113ddddddddd6d65d5d00000077777777773366663333333333
dddddddd3333333333322333cccccccccccccccc33322333444444443333633333333b3331b113b3666d666dd6dd5454f444077777777777333dd33333833333
dddddddd3333333333144233cccccccccccccccc331442334444444433636363333b3b3b3b33333bddddddd66dd65d5df44407777777777733655d3383838333
33eeeeeeeeeeeee3333cc33346666664333333337cc77777338888333338333300000000666663664a4444a44a4994a40aa0000066d666d6dd0ddd0d0d555550
eeeeeeeeeeeeeeee333cccc366dddd66dd6666ddc76c7777388aa8833338833344444044666663664a4444a415199151aaaa0000dddddddd00000000d0000005
2e2222e2222e2e2233cccccc6d666676d116111dc6cc77773888a8133389983344444044666663664a4444a411111111a9aaaaaa666d666dddd0ddd0d0222205
2e2222e2222e2e2233cccc7c6d666676611667167cc777773888a3133899a9834444404466666366aaa99aaa11111111a0aaaaaadddddddd00000000d0444405
22222222222222223dcccccc6d6666766177671677777cc731383313389aa98300000000333333334949949415111151aaaa9a9a6d666d66d0ddd0ddd0444405
2e2222e2222e2e223dccccc366777766d666666d7777c7cc338888333899988344444404663666664a4444a44a4444a49aa90909dddddddd00000000d0440405
2e2222e2222e2e223ddcccc35666666533336d337777cccc333223333888888344444404663666664a4444a44a4444a409900009d666d6660ddd0dddd0444405
eeeeeeeeeeeeeeee33dddc33455555543333633377777cc7331992333388883300000000663666664a4444a44a4444a400000000dddddddd00000000d0444405
3ddddddddddddddd0d555550dddddddd000000000000000000000000000000000000000000111100d5555ddd0000000000000000008808800880088000000000
3dddddddddddddddd0000005dddddddd88888008ccccc00cbbbbb00b7777700a2222200201cccc10d5665ddd0000000000009090088888888008800800000000
3ddddddddddd4444d0400005dddddddd88668804cc66cc04bb66bb0477667704226622041c5665c1d55555550088066004409949088888888000000800000000
3dd22222dddd47c4d0400005dddddddd86767804c6767c04b6767b0476a6a704267672041c6776c1dddd5dd50088866044449090088888888000000800000000
3dd24444dddd4cc4d0400005dddddddd86666804c6666c04b6666b0476666704266662041c6776c1dddd55550088866044499090008888800800008000000000
3dd24444dddd4444d0400005dddddddd888a8864cccacc64bbbabb64777a7764222a22641c5665c1d5555ddd0008860004999999000888000080080000000000
3dd24449ddd66666d0401005dddddddd088880040cccc0040bbbb004077770040222200401cccc10d5dd5ddd0000800009949900000080000008800000000000
3dd24444ddddddddd0410105dddddddd088880040cccc0040bbbb004077770040222200400111100d5555ddd0000000009909090000000000000000000000000
00080000000cc000000b000000000000000000000000000000000000337373330000000000000000000000000000000000080000000cc000000b000000000000
000880000007ccc0000bb00000000000888880000000000000111100333a333322222000000000000000000000000000000880000007ccc0000bb00000000000
0089980000cccccc00b33b000000000088668800000000000188881033747333226622000001111000011110001111000089980000cccccc00b33b0000000000
0890a08000cc0c0c0b3030b000000000867678000000000018999981333433332676720001188871011ccc7101bbb7100895a58000cc7c7c0b3737b000000000
089aa9800dcccccc0b3333b000000000866668000000000089a77a9833343333266662001889aa981ccccccc1bbbbb31089aa9800dcccccc0b3333b000000000
089998800dccccc00b333bb000000000444444480000000018999981333433334444444201188881011cccc101333310089998800dccccc00b333bb000000000
088888800ddcccc00bb3bbb0000000000888800000000000018888103334333302222000000111100001111000111100088888800ddcccc00bb3bbb000000000
0088880000dddc0000bbbb000000000008888000000000000011110033343333022220000000000000000000000000000088880000dddc0000bbbb0000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000008808800088066000660660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000888e800088866000666760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000008888800088866000666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000888000008860000066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000080000000800000006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010801010101010101010101010103030303030101010101010101010801010101010102110101010101010101010101010101010101010f01010
10000000e0e0e0e0e0e0e0e0e0e0e0e0e0919191c09191e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0c0e0e0e0e0e0e0e0e0e0
1010101010101010101010102010101010101050303030303010101010101010101010101010101010101010101010101010101010101010f010101010101010
10000000e0e0d0d0d0d0d0d0d0d0d0d0d0d0d091d091d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d091d0d0d0d0d0d0d0d0d0d0d0e0
101080102191919191101010101010101010101010101010501010101010101010101010101010101010101010101010101010f0101010101010101061101010
10000000e0e0d0d0d0e0d0d0d0d0d0d0d0d0d0917091d0d0e0d0d0d070d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d070d0d0d091d0d0d0d0d070d0d0d0d070e0
10101010101010201010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10000000e0e0d0d0d0d0d0d0d0d0d070d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d091d0d0d0d0d0d0d0d0d0d0d0e0
10101010101010101010108010101010101010101010101010101010101010101010101010101010101010f01010101010101010101010101010101071101010
10000000e0e0d070d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d090d0d0e0d0d0d0d0d0d0d0d0d0d0d0d091d0d0d0d0d0d0d0d0d0d0d0e0
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010104040404040401010106110101010101010
10000000e0e0d0d0d0e0d0d0d0d0d0d0d0d0d0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d070d0d0d0d0d0d0d0d0d091d0d0d0d0d0d0d0d0d0d0d0e0
1010e010101010101010101010101010101010101010101010101010101010101010101010101010101010101010103030303030301010101010101010101010
10000000e0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d091d0d0d0d0d0d0d0d0d0d0d0e0
101010101010e010701010801010101010101010101010101010101010101010101010101010101010101010101010303010101010101010f010101010101010
10000000e0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d070d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d041d0d0d091d0d0d0d0d0d0d0d0d0d0d0e0
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010106110101010101010101010101010101010101010
10000000e0e070d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d070e0
101010101010101010101010101010101010101010101010101010101010101010108010101010101010101010101010101010106110101010101010f0101010
10000000e0e09191919191919170d0d070d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d070d0d0d0d0d0d0d0d0d0d0d070d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e0
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010f010101010106110101010101010101010101010
10000000e0e0d0d0e0d0d0d091d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d070d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e0
1010701010101010101010101010e01010101010101010101010101010101010101010101010101010101010101010f010101010101010101010101010101010
10000000e0e021d0d070d0d091d0d0d0d0d0d0d0d0d0d0d0d0d0d070d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e0
1010101010e0101010101010101010101010101010e010101010101010101010101010101010101010101010101010101010101010f010101010101010101010
10000000e0d070d0d0d0d0d091d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e0
1010e01010101010101010101010101010101010101010101010101010101010101010101010101010f010101010101010101010101010101010101010101010
10000000e0d0d0d0d0d0d0d091d0d0d0d0d0d0d0d0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d091d0d0d070d0d0d0e0
10101010101010701010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10000000e0d0d0d0d0d0d0d0f1d0d0d0d0d0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d091d0d0d0d0d0d0d0e0
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010e010
10000000e09191919191919191d0d0d0d0d0d0d0d0d0d0d0d0d070d0d0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d091d0d0d0d0d091d0d0d091919191e0
1010101010101010101010e010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10000000e0d0d0d0d0d0e0d0d070d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d070d0d0d0d0d0d09191d070d0d0d09191919191d0d0d0e0
101010101010101010101010101010107010101010101010101010e0101010101010101010101010101010101010101010101010101010101010101010101010
10000000e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d070d0d0d0d0d0d0d0d0d0d0d0d091d0d0d0d0d0d0d0d0d0d0d0d0d0d0e0
1010701010101070101010101010101010101010101010101010101010101010101010101010e010101010107010101010107010101010101010101010101010
10000000e0d0d0d070d0d0d0d0d0d0d0e0d0d070d0d0d0d0d071d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d091d0d0d0d0d0d0d0d0d0d070d0d0d0e0
101070101010101010101010701010101010e010101010101010101010101010e010107010101010101010101010101010101010101010101010101010101010
10000000e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d070d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d070d0d091d0d0d0d0d0d0d0d0d0d0d0d0d0d0e0
10101010101010101010101010101010101010101010101010101010101010101010101010101040404040101010101010e01010101010101010101010101010
10000000e0d0d0d0e0e0e0e0e0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e0d0e0e0e0e0d0d0d0d0d0d0d0d0d0d091d0d0d0d0d0d0d0d0d0d0d0d0d0d0e0
1010101010e010101010101010101010101010107010101010101010101010101010101010104130303030404010101010101010101010101010101010101010
10000000e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0
10101010101010101010101010101041101010101010101010101010101010101070101010104030303030303010101010101010101010711010101010101010
100000000000000000000000000000000000000000000000000000e0d0d0f0e0d0d0d0d0e0f0d0d0616151815151515151515151510000000000000000000000
1010101010101010101010404040404010101010101010101010e0101010101010101010101030303030303030101010101010e0101010101010101010101010
100000000000000000000000000000000000000000000000000000e0d0d0f0d0d0d0d0d0d0f0d0d0515151816151515151515151510000000000000000000000
101010101010101010101030303030301010101010101010101010101010101010101010e0101030303030301010101010101010101010101010101010101010
100000000000000000000000000000000000000000000000000000e0d0d0f0d0d0d0d0d0d0110101717171607171715151515151510000000000000000000000
10101010101010701010403030301010101070101010101010101010101010101010211010101010101010101010107010101070101010101010101010101010
100000000000000000000000000000000000000000000000000000e0d0d0110101d0d0d0d0d0d0d0515151816161613030305151510000000000000000000000
10107010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
100000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0616151816151513030303051510000000000000000000000
1010101010101010101010101010701010101010109010101010101010101010101010101010101010701010101010101010e010101010101010101010101010
100000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0616151515151513030303051510000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
100000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0616151515151515151515151510000000000000000000000
1010e010101010101070101010107010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
100000000000000000000000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0616161616161515151515151510000000000000000000000
101010101070101010101010101010e01010101010101010101010101010101010101010101010101010101010e01010101010101010101010e0101010101010
10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010
10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000010101010000000801010000010001010400010001020100000000000100010100000000000080000000010000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010f01010101010101010101000001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0101010101010101010101050101010101010101010105010101010101010101010101010101010101010101010101010101010101010116010101010101010f010000000202101101010101010101010101010101011801010101010101021606060606060f0606060606060606010606161616160101010101161616161616
010801010101010801010101010101010101010101010101080101010101010101010101010101010101010101010101010101010101010101010101160101010100000002022021010101010801010101010112010118010101050101010216060f06060606060606060606060f060606060606060606060606060606060616
010101080101010101010101090108010101010101010101010101010101010101010101010101080801010101010101010101010f010101010101010101010101000000020201010101010101010101010108010101180101010101080102160606061606060606060606060606060606060606060606060f06060606060616
010101010201010101010101010101010101010101010101010101010101010101010101010101010101010116010101010901010101010101010f0101010101010000000202010108010101010101010101010101011801010101010101021606060606060606060606060606060606060606060606060606060606060f0616
0101010101010101010101010101010101010101080101010101010101010101080101010101010101010101010101010101010101010101010101010101010101000000020218181818010101010101010101010108181818181801010102160606060606060606060606061606060606060606060606060606160606060616
010101010108010101010101010101010101010101010101010101010101010101010101050101010101010101010101010101010101010f01010101010101010100000002020101010801010501010101010101010101010101180108010216060f060606060606060606060606060606060606060606060606060606060616
0101010101010101010505050501010101010101010101010101010101050101010101010101010101010101010101010101011601010101010101010116010101000000020201010101010101010101010101010101010101011801010102160606060606060606060606060606060606060606060606060606060606060616
0101010801010101010510110501010105010a0a0a0a0a0a0a0a0101010101010101010101010101010101010101010f0101010101010101010101010101010101000000020201010101010101010101010801010101010101011805010102160606061206060606060606060606060606060606060606060606060606060616
01010101010101010114202105010801010101232323232a230b010101010101010101010101010101010101010101010101010101010101011601010101010101000000020201010101010101010101010101010101010101010101010102160606060f06060606060606060606060606060606060606060606060606060616
01010105010101010801190101010101191919232a232323230b01010101010101010101010101010101010101010101010101010101010101010404040404040100000002020108010101010801010101010101010101010101010101010216060606060606060f060606060606060606060606060606060606060606060616
010101010101010101011919191919191901012323232312230b010101010101010101010101010101010f01010101010101010101010101010103030303030301000000020201010101010101010101010101010101010801010101170102160606060606060606060606160606160606060606060606060f06060606060f16
0101010114010101010101010101010101141d2323232323230b010101010101010101010101010101010101010101010101010101010101010103030303030301000000020501080101050101010101010101010101010101010108010102160606060606060606060606060606060606060606060606060606060606060616
0101010101040404010101010501010101011d232a232323230b01010101080101010801010101010101010101010101010101010f010101010101010101010f01000000020501010101010101010101010101050101010101180101010102160606160606060606060606060606060606060606060606060606060606060616
0101010801030303040101010101010101011d232323232a230b010101010101010101010101010101010101010101010101010101010101010101160101010101000000020501010101010101010101010101010101010101180501010102060606060606060606060606060606060606060606060606060606061606060616
0101010101030303030101010108013701011d1d1d1d1d1d1d0b010101010101010105010101010101010104040401010101010101011601010101010101010101000000020501010101010108010101010108010101010101181818181802060606060606060606060606060606060606060606060606060f06060606060616
010101010108010101010101010101010101010201010101010101010101010101010101010101010101010303030101010101010101010101010101010101010100000002050101010101010101010101010101010101010101010101010a0606060f0606060606060606060606060606060606060606060606060606060616
01010101050101010101010101010101010101010101020101010101010101010101010101010101010104030301010101010101010101010101010101010101010000000202181818181818010101010501010101010801010101010801011606060606060f0606060606060606060606060f060606060606060606060f0616
01010101010101010101010101010101010101010101010101010101010201010101010101010101010101030301010f0101010101010101160101010116010101000000020501010801011801010101010101010101010101010501010101160606060606060606060606060606060606060606060606060606060606060616
01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010000000205010101010118010101010101010101010101010101010101011606060606060606060606060606060606060606060606060606060f0606060616
01010101010101010101010801010101010101010101010101010101010101010101010101010101010101010101010101010101010f0101010101010101010101000000020501010105011801010108010101010101010101010101010101160606060606060606060606060f06060606060606060606060606060606060616
010101080101010101010101010101010101010101010101010101010101010101010101010101010f010101010101010101010101010101010101010101010101000000020501010101011801010101010101010101010101010101010101160606060606060606060606060606060606060606060606060606060606060616
0101010101010101010101010101010201010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000020501090105011f01010101010303030201010101010105010101160606060606060606060606060606060606060606060606060606060606090616
01010101010101010101020101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010116010101010f01010000000205010101010118010101010503030301010101010801010101011606060f0606060606170606060606060606060606060606060606060606060616
010101010108010101010101010101010101010108010105010101010201010101010101010101010101010101010101010101010101010101010101010101010100000002181818181818180101010101030303010101010101101108010116060606060616060613060606060606060606060606060f060606060606060616
010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010f01010101010101010100000002050108010101010101080101030303010101010118202118180116060606060f0606060f0606060606060606060f06060606060606061606060616
010201010101010101010108010101010101010101010101010101010101010101010101010101010101010f010101011601010101010101010101010101010101000000020501010101010101010101010105010501010101050101010101160606060606060606060606060616060606060606060606060606060606060616
0101010101010101010101010101010201010101010101010101010101170101010108010101010101010101010101010101010101010101010101010101010101000000020501010101050101010101010101010101010101010101010501160606060606060606060606060606060606060606060606060606060606060f16
01010108010101010801010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010f010100000002050101010101010101010101010101010108010101030303030116060f060606160606060606061606060606060606060606060606060606060616
01010101010101010201010101010101010101010102010101010101010101010101010101010101010101010101010101010101010101010101010f01010101010000000205010108010101010101010101010101010101010503030103011606060606060606060606060606060606060f060606060606060f060616060f16
010102010101010101010101010101010101010101040404010101010101010101010101010101010101010101010101010101010f01160101010101010101010100000002050101010101010101080101010101010101020202030303030116060606060606060606060f060606061606060606060606060606060606060616
010101010101010101010101010101010101050104030303030501010101010101010101010101010101010101010f010101010101010101010101010101010101000000020505050505050505050505050505050105050505050505050505161616161616161616161616161616161616161616161606161616161616161616
__sfx__
0001000018050180701a0601a0401a0701a0500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000500001b0501e0501f0501f050240501b0500b05016050240001400023000130001300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001000000000200501f0501e0501c0501b0501a05017050150501405012050110500f0500f0500a0500905008050070500705008050090500905007050040500105000050000500005000000000000000000000
000400000b5000761014630186301c6301b6300f6300b6300361002610006100260001600016001c600216001e6000b6000760006600056000760007600186001a6001c600000000000000000000000000000000
000200001f0001d0502005021050200501f0501c0501a050150500e0501a0500c050140501705018050150500f0500705003050010500105016000210001b0001000008000000000000000000000000000000000
000200000330008550065500e5500855014550095501a55012550285500f5503955013550255501f5000a500095000b5000f5001250014500165001a50019500195001a5001c5000430004300000000000000000
00040000007500175002750037500575007750097500c7500e7501075014750187501d750237500c70008700077000b70010700157001a7001a7001c7001f7002070004300033000330003300033000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011800000e02010020110201302011020100200e0200c0200e02011020100200e0200e020110200e0200e0200e02010020110201302011020100200e0200c0201002011020100200e0200e020110200e0200e020
011800002602000000000000000028020000000000000000240200000026020000000000000000000000000028020000002902000000280200000026020000002402000000000000000000000000000000000000
__music__
00 08424344
02 08094344

