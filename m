From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: 2 drives failed, one "active", one with wrong event count
Date: Thu, 28 Jan 2010 10:05:10 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1001280952060.15329@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I have a ubuntu 9.04 system with the default mdadm and kernel (2.6.28).

During the night two drives out of my 6 drive raid5 was kicked out due to 
sata timeouts. I rebooted the system and tried to assemble the array, but 
it would end up with 2 spares and 4 working drives, thus not enough.

More examination showed that of the two drives not working, one was 
"active" (as opposed to clean), and another one had a different event 
count from all the other drives.

Doing --assemble --force yielded:

[ 7748.103782] md: bind<sdg>
[ 7748.103989] md: bind<sdb>
[ 7748.104164] md: bind<sdc>
[ 7748.104315] md: bind<sde>
[ 7748.104456] md: bind<sdf>
[ 7748.104631] md: bind<sdd>
[ 7748.104664] md: kicking non-fresh sde from array!
[ 7748.104684] md: unbind<sde>
[ 7748.120532] md: export_rdev(sde)
[ 7748.120554] md: md0: raid array is not clean -- starting background 
reconstruction
[ 7748.122135] raid5: device sdd operational as raid disk 0
[ 7748.122153] raid5: device sdf operational as raid disk 5
[ 7748.122169] raid5: device sdc operational as raid disk 3
[ 7748.122186] raid5: device sdb operational as raid disk 2
[ 7748.122202] raid5: device sdg operational as raid disk 1
[ 7748.122218] raid5: cannot start dirty degraded array for md0
[ 7748.122234] RAID5 conf printout:
[ 7748.122248]  --- rd:6 wd:5
[ 7748.122261]  disk 0, o:1, dev:sdd
[ 7748.122275]  disk 1, o:1, dev:sdg
[ 7748.122289]  disk 2, o:1, dev:sdb
[ 7748.122303]  disk 3, o:1, dev:sdc
[ 7748.122317]  disk 5, o:1, dev:sdf
[ 7748.122331] raid5: failed to run raid set md0
[ 7748.122346] md: pers->run() failed ...

# mdadm --examine /dev/sd[bcdefg] | grep -i State
           State : clean
    Array State : _uUu_u 5 failed
           State : clean
    Array State : _uuU_u 5 failed
           State : active
    Array State : Uuuu_u 4 failed
           State : clean
    Array State : uuuuUu 3 failed
           State : clean
    Array State : _uuu_U 5 failed
           State : clean
    Array State : _Uuu_u 5 failed

So sde has another event count, sdd is "active" and thus making the array 
drity I guess.

Now, I mucked around a bit with assemble and examine, and then at one time 
the array tried to start with only two drives:

[ 8803.797521] raid5: device sdc operational as raid disk 3
[ 8803.797541] raid5: device sdd operational as raid disk 0
[ 8803.797558] raid5: not enough operational devices for md0 (4/6 failed)
[ 8803.797575] RAID5 conf printout:
[ 8803.797589]  --- rd:6 wd:2
[ 8803.797602]  disk 0, o:1, dev:sdd
[ 8803.797616]  disk 3, o:1, dev:sdc
[ 8803.797630] raid5: failed to run raid set md0
[ 8803.797645] md: pers->run() failed ...

I then stopped and started it again two times, and all of a sudden it 
assembled correctly and started reconstruction:

[ 8842.040824] md: md0 stopped.
[ 8842.040853] md: unbind<sdc>
[ 8842.056512] md: export_rdev(sdc)
[ 8842.056549] md: unbind<sdd>
[ 8842.068510] md: export_rdev(sdd)
[ 8865.784578] md: md0 stopped.
[ 8867.003573] md: bind<sdg>
[ 8867.003753] md: bind<sdb>
[ 8867.003981] md: bind<sdc>
[ 8867.004148] md: bind<sde>
[ 8867.004291] md: bind<sdf>
[ 8867.004489] md: bind<sdd>
[ 8867.004522] md: kicking non-fresh sde from array!
[ 8867.004541] md: unbind<sde>
[ 8867.020030] md: export_rdev(sde)
[ 8867.020052] md: md0: raid array is not clean -- starting background reconstruction
[ 8867.021633] raid5: device sdd operational as raid disk 0
[ 8867.021651] raid5: device sdf operational as raid disk 5
[ 8867.021667] raid5: device sdc operational as raid disk 3
[ 8867.021683] raid5: device sdb operational as raid disk 2
[ 8867.021699] raid5: device sdg operational as raid disk 1
[ 8867.021715] raid5: cannot start dirty degraded array for md0
[ 8867.021731] RAID5 conf printout:
[ 8867.021745]  --- rd:6 wd:5
[ 8867.021759]  disk 0, o:1, dev:sdd
[ 8867.021772]  disk 1, o:1, dev:sdg
[ 8867.021786]  disk 2, o:1, dev:sdb
[ 8867.021800]  disk 3, o:1, dev:sdc
[ 8867.021814]  disk 5, o:1, dev:sdf
[ 8867.021828] raid5: failed to run raid set md0
[ 8867.021843] md: pers->run() failed ...
[ 9044.443949] md: md0 stopped.
[ 9044.443981] md: unbind<sdd>
[ 9044.452013] md: export_rdev(sdd)
[ 9044.452066] md: unbind<sdf>
[ 9044.464011] md: export_rdev(sdf)
[ 9044.464039] md: unbind<sdc>
[ 9044.476009] md: export_rdev(sdc)
[ 9044.476056] md: unbind<sdb>
[ 9044.492010] md: export_rdev(sdb)
[ 9044.492037] md: unbind<sdg>
[ 9044.504010] md: export_rdev(sdg)
[ 9297.387893] md: bind<sdd>
[ 9301.337867] md: bind<sdc>
[ 9399.256047] md: md0 still in use.
[ 9399.678154] md: array md0 already has disks!
[ 9409.702060] md: md0 stopped.
[ 9409.702087] md: unbind<sdc>
[ 9409.712012] md: export_rdev(sdc)
[ 9409.712062] md: unbind<sdd>
[ 9409.724009] md: export_rdev(sdd)
[ 9411.880427] md: md0 still in use.
[ 9413.518157] md: bind<sdg>
[ 9413.518357] md: bind<sdb>
[ 9413.518527] md: bind<sdc>
[ 9413.518675] md: bind<sde>
[ 9413.518817] md: bind<sdf>
[ 9413.518987] md: bind<sdd>
[ 9413.519019] md: md0: raid array is not clean -- starting background reconstruction
[ 9413.521094] raid5: device sdd operational as raid disk 0
[ 9413.521113] raid5: device sdf operational as raid disk 5
[ 9413.521129] raid5: device sde operational as raid disk 4
[ 9413.521145] raid5: device sdc operational as raid disk 3
[ 9413.521162] raid5: device sdb operational as raid disk 2
[ 9413.521178] raid5: device sdg operational as raid disk 1
[ 9413.521859] raid5: allocated 6396kB for md0
[ 9413.521875] raid5: raid level 5 set md0 active with 6 out of 6 devices, algorithm 2
[ 9413.521901] RAID5 conf printout:
[ 9413.521915]  --- rd:6 wd:6
[ 9413.521928]  disk 0, o:1, dev:sdd
[ 9413.521942]  disk 1, o:1, dev:sdg
[ 9413.521956]  disk 2, o:1, dev:sdb
[ 9413.521970]  disk 3, o:1, dev:sdc
[ 9413.521984]  disk 4, o:1, dev:sde
[ 9413.521998]  disk 5, o:1, dev:sdf
[ 9413.522145] md0: detected capacity change from 0 to 10001993891840

Anyone have any idea what's going on?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
