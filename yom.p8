pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
function _init()
 create_player()
 sorts={}
end

function _update()
	player_movement()
	update_camera()
	if (btnp(❎)) shoot()
	update_sorts()
end

function _draw()
	cls()
	draw_map()
	draw_player()
	
	for s in all (sorts) do
		spr(30,s.x,s.y)
	end
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
	local camx=mid(0,p.x-7.5,127-15)
	local camy=mid(0,p.y-7.5,63-15)
	camera(camx*8,camy*8)
end
-->8
--player

function create_player()
	p={x=10,y=10,sprite=39}
end

function draw_player()
	spr(p.sprite,p.x*8,p.y*8)
end

function player_movement()
	newx=p.x
	newy=p.y

	if (btn(➡️)) newx+=0.51
	if (btn(⬅️)) newx-=0.51
	if (btn(⬇️)) newy+=0.51
	if (btn(⬆️)) newy-=0.51
	
	if not check_flag(0,newx,newy) then
		p.x=mid(0,newx,127)
		p.y=mid(0,newy,63)
	else
		sfx=0
	end
end

-->8
--sorts

function shoot()
	local new_ball={
		x=p.x*8,
		y=p.y*8,
		speed=2
	}
	add(sorts,new_ball)
end

--t={portee=20}

function update_sorts()
	for s in all(sorts) do
		local position_init=p.x*8
		s.x+=s.speed
	 if (s.x>(position_init+20)) del (sorts,s)
	end
end
__gfx__
dddddddd3333333333bbbb33cccccccc444444443333333344444444333333333333333331131113550000ff5555555522f44407777777773366663333333333
dddddddd333333333bbaabb3ccccccccdddddddd333b33334444444433633333333b33331cc1ccc1000ff0ff0005555522f44407777777773663366333333833
dddddddd333333333bbbab13cccccccccccccccc33ba333344444444636363333b3b3b331ccca113ff0ff0ff440000550000000777777777366636d333383838
dddddddd333333333bbbb313cccccccccccccccc3ba3ab1344444444333333333333333331ca9cc1ff0ff044440440002f44407777777777366663d333333333
dddddddd33333333313b3313cccccccccccccccc313a3b134444444433333333333333331cccccc1ff044000440440442f44407777777777363633d333333333
dddddddd3333333333111133cccccccccccccccc331111334444444433333333333333331c1cc11344000033ff04404400000077777777773366663333333333
dddddddd3333333333322333cccccccccccccccc33322333444444443333633333333b3331b113b300033333220ff044f444077777777777333dd33333833333
dddddddd3333333333144233cccccccccccccccc331442334444444433636363333b3b3b3b33333b33333333220220fff44407777777777733655d3383838333
33eeeeeeeeeeeee3333cc33346666664777777777cc77777338888333338333300000000666663664a4444a44a4994a40aa0000066d666d6dd0ddd0d0d555550
eeeeeeeeeeeeeeee333cccc366dddd66dd6666ddc76c7777388aa8833338833344444044666663664a4444a415199151aaaa0000dddddddd00000000d0000005
2e2222e2222e2e2233cccccc6d666676d116111dc6cc77773888a8133389983344444044666663664a4444a411111111a9aaaaaa666d666dddd0ddd0d0222205
2e2222e2222e2e2233cccc7c6d666676611667167cc777773888a3133899a9834444404466666366aaa99aaa11111111a0aaaaaadddddddd00000000d0444405
22222222222222223dcccccc6d6666766177671677777cc731383313389aa98300000000333333334949949415111151aaaa9a9a6d666d66d0ddd0ddd0444405
2e2222e2222e2e223dccccc366777766d666666d7777c7cc338888333899988344444404663666664a4444a44a4444a49aa90909dddddddd00000000d0440405
2e2222e2222e2e223ddcccc35666666577776d777777cccc333223333888888344444404663666664a4444a44a4444a409900009d666d6660ddd0dddd0444405
eeeeeeeeeeeeeeee33dddc33455555547777677777777cc7331992333388883300000000663666664a4444a44a4444a400000000dddddddd00000000d0444405
3ddddddddddddddd0d555550dddddddd000000000000000000000000000000000000000000111100000000000000000000000000000000000000000000000000
3dddddddddddddddd0000005dddddddd88888008ccccc00c333330037777700a2222200201288210000000000000000000000000000000000000000000000000
3ddddddddddd4444d0400005dddddddd88668804cc66cc0433663304776677042266220412899821000000000000000000000000000000000000000000000000
3dd22222dddd47c4d0400005dddddddd86767804c6767c043676730476a6a70426767204189aa981000000000000000000000000000000000000000000000000
3dd24444dddd4cc4d0400005dddddddd86666804c6666c04366663047666670426666204189aa981000000000000000000000000000000000000000000000000
3dd24444dddd4444d0400005dddddddd888a8864cccacc64333a3364777a7764222a226412899821000000000000000000000000000000000000000000000000
3dd24449ddd66666d0401005dddddddd088880040cccc00403333004077770040222200401288210000000000000000000000000000000000000000000000000
3dd24444ddddddddd0410105dddddddd088880040cccc00403333004077770040222200400111100000000000000000000000000000000000000000000000000
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
1010101010e010101010101010101010101010107010101010101010101010101010101010101030303030404010101010101010101010101010101010101010
10000000e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0
10101010101010101010101010101010101010101010101010101010101010101070101010104030303030303010101010101010101010711010101010101010
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
0000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010f01010101010101010101000000020202020202020202020202020202020202050505050505050505161616161616161616161616161616161616161616161616161616161616161616
0101010101010101010101050101010101010101010105010101010101010101010101010101010101010101010101010101010101010116010101010101010f010000000202101101010101010101010101010101011801010101010101021606060606060f0606060606060606060606161616161616161616161616161616
010801010101010801010101010101010101010101010101080101010101010101010101010101010101010101010101010101010101010101010101160101010100000002022021010101010801010101010112010118010101050101010216060f06060606060606060606060f060606060606060606060606060606060616
010101080101010101010101090108010101010101010101010101010101010101010101010101080801010101010101010101010f010101010101010101010101000000020201010101010101010101010108010101180101010101080102160606061606060606060606060606060606060606060606060f06060606060616
010101010201010101010101010101010101010101010101010101010101010101010101010101010101010116010101010901010101010101010f0101010101010000000202010108010101010101010101010101011801010101010101021606060606060606060606060606060606060606060606060606060606060f0616
0101010101010101010104040301010101010101080101010101010101010101080101010101010101010101010101010101010101010101010101010101010101000000020218181818010101010101010101010108181818181801010102160606060606060606060606061606060606060606060606060606160606060616
010101010108010101040303030401010101010101010101010101010101010101010101050101010101010101010101010101010101010f01010101010101010100000002020101010801010501010101010101010101010101180108010216060f060606060606060606060606060606060606060606060606060606060616
0101010101011901010303030303010101010101010101010101010101050101010101010101010101010101010101010101011601010101010101010116010101000000020201010101010101010101010101010101010101011801010102160606060606060606060606060606060606060606060606060606060606060616
0108010801011901010101010101010105011d1d1d1d1d1d1d1d0101010101010101010101010101010101010101010f0101010101010101010101010101010101000000020201010101010101010101010801010101010101011805010102160606061206060606060606060606060606060606060606060606060606060616
010101010101190101010101010108010101012323232323231d010101010101010101010101010101010101010101010101010101010101011601010101010101000000020201010101010101010101010101010101010101010101010102160606060f06060606060606060606060606060606060606060606060606060616
010101050101190108010101010101011919192323232323231d01010101010101010101010101010101010101010101010101010101010101010404040404040100000002020108010101010801010101010101010101010101010101010216060606060606060f060606060606060606060606060606060606060606060616
010101010101010101010101011919191901012323232312231d010101010101010101010101010101010f01010101010101010101010101010103030303030301000000020201010101010101010101010101010101010801010101170102160606060606060606060606160606160606060606060606060f06060606060f16
0101010101010101010101010101010101011d2323232323231d010101010101010101010101010101010101010101010101010101010101010103030303030301000000020501080101050101010101010101010101010101010108010102160606060606060606060606060606060606060606060606060606060606060616
0101010101010101010101010501010101011d2323232323231d01010101080101010801010101010101010101010101010101010f010101010101010101010f01000000020501010101010101010101010101050101010101180101010102160606160606060606060606060606060606060606060606060606060606060616
0101010801010101010101010101010101011d2323232323231d010101010101010101010101010101010101010101010101010101010101010101160101010101000000020501010101010101010101010101010101010101180501010102060606060606060606060606060606060606060606060606060606061606060616
0101010101010101010101010108010101011d1d1d1d1d1d1d1d010101010101010105010101010101010104040401010101010101011601010101010101010101000000020501010101010108010101010108010101010101181818181802060606060606060606060606060606060606060606060606060f06060606060616
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
