From: Daniel Koch <koch@triple6.org>
Subject: Re: Failed to grow
Date: Fri, 14 Aug 2015 22:09:55 +0200
Message-ID: <c2bcdf30a27b0ddb4c84eb4bc9444f8d@mail.triple6.org>
References: <621f0ebc8080e4ab56eaacde5f9416cf@mail.triple6.org>
 <3161f36377c85c092f4f3a461295e76a@mail.triple6.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3161f36377c85c092f4f3a461295e76a@mail.triple6.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

=46ixed.

=46irst make sure to use an overlay for testing:
https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAI=
D#Making_the_harddisks_read-only_using_an_overlay_file

Try this
https://raid.wiki.kernel.org/index.php/RAID_Recovery#Restore_array_by_r=
ecreating_.28after_multiple_device_failure.29

It worked so did on the real disks without overlay.

Thanks to frostschutz, SwedeMike and djselbeck from irc ( #linux-raid o=
n=20
freenode ) for saving me.
---
Viele Gr=C3=BC=C3=9Fe,

Daniel Koch

Am 2015-08-14 11:22, schrieb Daniel Koch:
> I crawled the archive of the list and found that --invalid-backup wit=
h
> a faked and empty backup might help. Here is the result:
>=20
> mdadm --assemble --force --run --verbose /dev/md0
> --backup-file=3Dempty.bak --invalid-backup
> mdadm: looking for devices for /dev/md0
> mdadm: no RAID superblock on /dev/sda5
> mdadm: no RAID superblock on /dev/sda2
> mdadm: no RAID superblock on /dev/sda1
> mdadm: no RAID superblock on /dev/sda
> mdadm: /dev/sdn is identified as a member of /dev/md0, slot 9.
> mdadm: /dev/sdj is identified as a member of /dev/md0, slot 5.
> mdadm: /dev/sdh is identified as a member of /dev/md0, slot 3.
> mdadm: /dev/sdm is identified as a member of /dev/md0, slot 8.
> mdadm: /dev/sdl is identified as a member of /dev/md0, slot 7.
> mdadm: /dev/sdk is identified as a member of /dev/md0, slot 6.
> mdadm: /dev/sdi is identified as a member of /dev/md0, slot 4.
> mdadm: /dev/sdg is identified as a member of /dev/md0, slot 2.
> mdadm: /dev/sdd is identified as a member of /dev/md0, slot 10.
> mdadm: /dev/sde is identified as a member of /dev/md0, slot 12.
> mdadm: /dev/sdb is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdf is identified as a member of /dev/md0, slot 11.
> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 1.
> mdadm: :/dev/md0 has an active reshape - checking if critical section
> needs to be restored
> mdadm: Cannot read from empty.bak
> mdadm: No backup metadata on device-12
> mdadm: Failed to find backup of critical section
> mdadm: continuing without restoring backup
> mdadm: added /dev/sdc to /dev/md0 as 1
> mdadm: added /dev/sdg to /dev/md0 as 2
> mdadm: added /dev/sdh to /dev/md0 as 3
> mdadm: added /dev/sdi to /dev/md0 as 4
> mdadm: added /dev/sdj to /dev/md0 as 5
> mdadm: added /dev/sdk to /dev/md0 as 6
> mdadm: added /dev/sdl to /dev/md0 as 7
> mdadm: added /dev/sdm to /dev/md0 as 8
> mdadm: added /dev/sdn to /dev/md0 as 9
> mdadm: added /dev/sdd to /dev/md0 as 10
> mdadm: added /dev/sdf to /dev/md0 as 11
> mdadm: added /dev/sde to /dev/md0 as 12
> mdadm: added /dev/sdb to /dev/md0 as 0
> mdadm: failed to RUN_ARRAY /dev/md0: Invalid argument
>=20
>=20
> kern.log:
> Aug 14 11:18:20 claw-storage kernel: [  599.182677] md: md0 stopped.
> Aug 14 11:18:20 claw-storage kernel: [  599.184459]  sdn: unknown
> partition table
> Aug 14 11:18:20 claw-storage kernel: [  599.185604]  sdj: unknown
> partition table
> Aug 14 11:18:20 claw-storage kernel: [  599.186424]  sdm: unknown
> partition table
> Aug 14 11:18:20 claw-storage kernel: [  599.187869]  sdl: unknown
> partition table
> Aug 14 11:18:20 claw-storage kernel: [  599.189108]  sdi: unknown
> partition table
> Aug 14 11:18:21 claw-storage kernel: [  599.213722]  sde: unknown
> partition table
> Aug 14 11:18:21 claw-storage kernel: [  599.214073] md: bind<sdc>
> Aug 14 11:18:21 claw-storage kernel: [  599.214248] md: bind<sdg>
> Aug 14 11:18:21 claw-storage kernel: [  599.214427] md: bind<sdh>
> Aug 14 11:18:21 claw-storage kernel: [  599.214438]  sdb: sdb1
> Aug 14 11:18:21 claw-storage kernel: [  599.214620] md: bind<sdi>
> Aug 14 11:18:21 claw-storage kernel: [  599.214845] md: bind<sdj>
> Aug 14 11:18:21 claw-storage kernel: [  599.215000] md: bind<sdk>
> Aug 14 11:18:21 claw-storage kernel: [  599.215140] md: bind<sdl>
> Aug 14 11:18:21 claw-storage kernel: [  599.215278]  sdf: unknown
> partition table
> Aug 14 11:18:21 claw-storage kernel: [  599.215337] md: bind<sdm>
> Aug 14 11:18:21 claw-storage kernel: [  599.215477] md: bind<sdn>
> Aug 14 11:18:21 claw-storage kernel: [  599.215588] md: bind<sdd>
> Aug 14 11:18:21 claw-storage kernel: [  599.216165] md: bind<sdf>
> Aug 14 11:18:21 claw-storage kernel: [  599.216400]  sde: unknown
> partition table
> Aug 14 11:18:21 claw-storage kernel: [  599.216923] md: bind<sde>
> Aug 14 11:18:21 claw-storage kernel: [  599.217159]  sdf: unknown
> partition table
> Aug 14 11:18:21 claw-storage kernel: [  599.217513] md: bind<sdb>
> Aug 14 11:18:21 claw-storage kernel: [  599.218292]  sdl: unknown
> partition table
> Aug 14 11:18:21 claw-storage kernel: [  599.218743] md/raid:md0:
> reshape_position too early for auto-recovery - aborting.
> Aug 14 11:18:21 claw-storage kernel: [  599.220772] md: pers->run()=20
> failed ...
> Aug 14 11:18:21 claw-storage kernel: [  599.222047]  sdi: unknown
> partition table
> Aug 14 11:18:21 claw-storage kernel: [  599.222135] md: md0 stopped.
> Aug 14 11:18:21 claw-storage kernel: [  599.222142] md: unbind<sdb>
> Aug 14 11:18:21 claw-storage kernel: [  599.222616]  sdb: sdb1
> Aug 14 11:18:21 claw-storage kernel: [  599.223612]  sdi: unknown
> partition table
> Aug 14 11:18:21 claw-storage kernel: [  599.224397]  sdl: unknown
> partition table
> Aug 14 11:18:21 claw-storage kernel: [  599.225077]  sdf: unknown
> partition table
> Aug 14 11:18:21 claw-storage kernel: [  599.225907]  sde: unknown
> partition table
> Aug 14 11:18:21 claw-storage kernel: [  599.226498]  sdb: sdb1
> Aug 14 11:18:21 claw-storage kernel: [  599.232193] md:=20
> export_rdev(sdb)
> Aug 14 11:18:21 claw-storage kernel: [  599.232205] md: unbind<sde>
> Aug 14 11:18:21 claw-storage kernel: [  599.247747] md:=20
> export_rdev(sde)
> Aug 14 11:18:21 claw-storage kernel: [  599.247766] md: unbind<sdf>
> Aug 14 11:18:21 claw-storage kernel: [  599.271766] md:=20
> export_rdev(sdf)
> Aug 14 11:18:21 claw-storage kernel: [  599.271774] md: unbind<sdd>
> Aug 14 11:18:21 claw-storage kernel: [  599.287796] md:=20
> export_rdev(sdd)
> Aug 14 11:18:21 claw-storage kernel: [  599.287818] md: unbind<sdn>
> Aug 14 11:18:21 claw-storage kernel: [  599.319830] md:=20
> export_rdev(sdn)
> Aug 14 11:18:21 claw-storage kernel: [  599.319841] md: unbind<sdm>
> Aug 14 11:18:21 claw-storage kernel: [  599.331804] md:=20
> export_rdev(sdm)
> Aug 14 11:18:21 claw-storage kernel: [  599.331816] md: unbind<sdl>
> Aug 14 11:18:21 claw-storage kernel: [  599.346199] md:=20
> export_rdev(sdl)
> Aug 14 11:18:21 claw-storage kernel: [  599.346221] md: unbind<sdk>
> Aug 14 11:18:21 claw-storage kernel: [  599.355791] md:=20
> export_rdev(sdk)
> Aug 14 11:18:21 claw-storage kernel: [  599.355805] md: unbind<sdj>
> Aug 14 11:18:21 claw-storage kernel: [  599.371779] md:=20
> export_rdev(sdj)
> Aug 14 11:18:21 claw-storage kernel: [  599.371794] md: unbind<sdi>
> Aug 14 11:18:21 claw-storage kernel: [  599.387838] md:=20
> export_rdev(sdi)
> Aug 14 11:18:21 claw-storage kernel: [  599.387850] md: unbind<sdh>
> Aug 14 11:18:21 claw-storage kernel: [  599.403814] md:=20
> export_rdev(sdh)
> Aug 14 11:18:21 claw-storage kernel: [  599.403839] md: unbind<sdg>
> Aug 14 11:18:21 claw-storage kernel: [  599.431842] md:=20
> export_rdev(sdg)
> Aug 14 11:18:21 claw-storage kernel: [  599.431852] md: unbind<sdc>
> Aug 14 11:18:21 claw-storage kernel: [  599.463878] md:=20
> export_rdev(sdc)
> Aug 14 11:18:21 claw-storage kernel: [  599.465322] md: bind<sdn>
> Aug 14 11:18:21 claw-storage kernel: [  599.467200] md: bind<sdj>
> Aug 14 11:18:21 claw-storage kernel: [  599.469274] md: bind<sde>
> Aug 14 11:18:21 claw-storage kernel: [  599.471375] md: bind<sdi>
> Aug 14 11:18:21 claw-storage kernel: [  599.473784] md: bind<sdf>
> Aug 14 11:18:21 claw-storage kernel: [  599.476780] md: bind<sdl>
> Aug 14 11:18:21 claw-storage kernel: [  599.480103] md: bind<sdm>
> Aug 14 11:18:21 claw-storage kernel: [  599.488333] md: bind<sdb>
>=20
> #cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : inactive sdm[8](S) sdn[9](S) sdj[5](S) sdb[0](S) sdf[11](S)
> sdi[4](S) sde[13](S) sdl[12](S)
>       14161940096 blocks super 1.2
>=20
> unused devices: <none>
>=20
> So no luck at all. All disks are accessable using smart which makes m=
e
> think they are operational.
> ---
> Viele Gr=C3=BC=C3=9Fe,
>=20
> Daniel Koch
>=20
> Am 2015-08-13 17:53, schrieb Daniel Koch:
>> Hello every one,
>>=20
>> I have a huge problem. I started to grow a array with ( the added
>> device is /dev/sde )
>> # mdadm --grow --raid-devices=3D13 /dev/md0 --backup-file=3Dmd0.bak
>>=20
>> after that there way 0 disk activity so i checked it with
>> # cat /proc/mdstat
>>=20
>> everything looked fine but speed was 0K/sec for about 1-2 hours. I
>> decided to reboot the system as grow should continue after that. Aft=
er
>> that the array wasn't assembled at all. So i wanted to do it myself:
>>=20
>> # mdadm --assemble /dev/md0 /dev/sd[b-n] --backup-file=3Dmd0.bak=20
>> --verbose
>> mdadm: looking for devices for /dev/md0
>> mdadm: /dev/sdb is identified as a member of /dev/md0, slot 0.
>> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 1.
>> mdadm: /dev/sdd is identified as a member of /dev/md0, slot 10.
>> mdadm: /dev/sde is identified as a member of /dev/md0, slot 12.
>> mdadm: /dev/sdf is identified as a member of /dev/md0, slot 11.
>> mdadm: /dev/sdg is identified as a member of /dev/md0, slot 2.
>> mdadm: /dev/sdh is identified as a member of /dev/md0, slot 3.
>> mdadm: /dev/sdi is identified as a member of /dev/md0, slot 4.
>> mdadm: /dev/sdj is identified as a member of /dev/md0, slot 5.
>> mdadm: /dev/sdk is identified as a member of /dev/md0, slot 6.
>> mdadm: /dev/sdl is identified as a member of /dev/md0, slot 7.
>> mdadm: /dev/sdm is identified as a member of /dev/md0, slot 8.
>> mdadm: /dev/sdn is identified as a member of /dev/md0, slot 9.
>> mdadm: :/dev/md0 has an active reshape - checking if critical sectio=
n
>> needs to be restored
>> mdadm: No backup metadata on md0.bak
>> mdadm: No backup metadata on device-12
>> mdadm: Failed to find backup of critical section
>> mdadm: Failed to restore critical section for reshape, sorry.
>>=20
>> Backup looks broken. What can i do ?
>>=20
>> # mdadm --version
>> mdadm - v3.3.2 - 21st August 2014
>>=20
>> # uname -a
>> Linux claw-storage 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt11-1+deb8u=
3
>> (2015-08-04) x86_64 GNU/Linux
>>=20
>> # du -sch md0.bak
>> 56M     md0.bak
>>=20
>> # mdadm --examine /dev/sd[b-n]
>> /dev/sdb:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x4
>>      Array UUID : 633c1520:61c07f69:26a83b45:b9756587
>>            Name : claw-storage:0  (local to host claw-storage)
>>   Creation Time : Tue Jan 14 12:48:49 2014
>>      Raid Level : raid6
>>    Raid Devices : 13
>>=20
>>  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
>>      Array Size : 16115078144 (15368.54 GiB 16501.84 GB)
>>   Used Dev Size : 2930014208 (1397.14 GiB 1500.17 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>    Unused Space : before=3D262064 sectors, after=3D976752816 sectors
>>           State : clean
>>     Device UUID : f3d9392c:a9290f8e:4ded7efc:284b4ecf
>>=20
>>   Reshape pos'n : 0
>>   Delta Devices : 1 (12->13)
>>=20
>>     Update Time : Thu Aug 13 17:11:05 2015
>>        Checksum : 11cb12c0 - correct
>>          Events : 72402
>>=20
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>=20
>>    Device Role : Active device 0
>>    Array State : AAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g, 'R' =3D=3D=20
>> replacing)
>> /dev/sdc:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x4
>>      Array UUID : 633c1520:61c07f69:26a83b45:b9756587
>>            Name : claw-storage:0  (local to host claw-storage)
>>   Creation Time : Tue Jan 14 12:48:49 2014
>>      Raid Level : raid6
>>    Raid Devices : 13
>>=20
>>  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
>>      Array Size : 16115078144 (15368.54 GiB 16501.84 GB)
>>   Used Dev Size : 2930014208 (1397.14 GiB 1500.17 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>    Unused Space : before=3D262064 sectors, after=3D976752816 sectors
>>           State : clean
>>     Device UUID : a5b4533d:d5a4cdc5:e6dcd3aa:4a845044
>>=20
>>   Reshape pos'n : 0
>>   Delta Devices : 1 (12->13)
>>=20
>>     Update Time : Thu Aug 13 17:11:05 2015
>>        Checksum : 7dfa9159 - correct
>>          Events : 72402
>>=20
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>=20
>>    Device Role : Active device 1
>>    Array State : AAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g, 'R' =3D=3D=20
>> replacing)
>> /dev/sdd:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x4
>>      Array UUID : 633c1520:61c07f69:26a83b45:b9756587
>>            Name : claw-storage:0  (local to host claw-storage)
>>   Creation Time : Tue Jan 14 12:48:49 2014
>>      Raid Level : raid6
>>    Raid Devices : 13
>>=20
>>  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
>>      Array Size : 16115078144 (15368.54 GiB 16501.84 GB)
>>   Used Dev Size : 2930014208 (1397.14 GiB 1500.17 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>    Unused Space : before=3D262064 sectors, after=3D976752816 sectors
>>           State : clean
>>     Device UUID : d39aede2:af92f321:8b6fbd9f:45c73ddf
>>=20
>>   Reshape pos'n : 0
>>   Delta Devices : 1 (12->13)
>>=20
>>     Update Time : Thu Aug 13 17:11:05 2015
>>        Checksum : f913b0b - correct
>>          Events : 72402
>>=20
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>=20
>>    Device Role : Active device 10
>>    Array State : AAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g, 'R' =3D=3D=20
>> replacing)
>> /dev/sde:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x4
>>      Array UUID : 633c1520:61c07f69:26a83b45:b9756587
>>            Name : claw-storage:0  (local to host claw-storage)
>>   Creation Time : Tue Jan 14 12:48:49 2014
>>      Raid Level : raid6
>>    Raid Devices : 13
>>=20
>>  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
>>      Array Size : 16115078144 (15368.54 GiB 16501.84 GB)
>>   Used Dev Size : 2930014208 (1397.14 GiB 1500.17 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>    Unused Space : before=3D262056 sectors, after=3D976752816 sectors
>>           State : clean
>>     Device UUID : 13fcdab1:69ce4358:5f1ee2b2:c809b990
>>=20
>>   Reshape pos'n : 0
>>   Delta Devices : 1 (12->13)
>>=20
>>     Update Time : Thu Aug 13 17:11:05 2015
>>   Bad Block Log : 512 entries available at offset 72 sectors
>>        Checksum : d976c9a6 - correct
>>          Events : 72402
>>=20
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>=20
>>    Device Role : Active device 12
>>    Array State : AAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g, 'R' =3D=3D=20
>> replacing)
>> /dev/sdf:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x4
>>      Array UUID : 633c1520:61c07f69:26a83b45:b9756587
>>            Name : claw-storage:0  (local to host claw-storage)
>>   Creation Time : Tue Jan 14 12:48:49 2014
>>      Raid Level : raid6
>>    Raid Devices : 13
>>=20
>>  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
>>      Array Size : 16115078144 (15368.54 GiB 16501.84 GB)
>>   Used Dev Size : 2930014208 (1397.14 GiB 1500.17 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>    Unused Space : before=3D262064 sectors, after=3D976752816 sectors
>>           State : clean
>>     Device UUID : 487f70bd:b63c29d6:185aa418:208dc16d
>>=20
>>   Reshape pos'n : 0
>>   Delta Devices : 1 (12->13)
>>=20
>>     Update Time : Thu Aug 13 17:11:05 2015
>>        Checksum : a5b479ef - correct
>>          Events : 72402
>>=20
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>=20
>>    Device Role : Active device 11
>>    Array State : AAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g, 'R' =3D=3D=20
>> replacing)
>> /dev/sdg:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x4
>>      Array UUID : 633c1520:61c07f69:26a83b45:b9756587
>>            Name : claw-storage:0  (local to host claw-storage)
>>   Creation Time : Tue Jan 14 12:48:49 2014
>>      Raid Level : raid6
>>    Raid Devices : 13
>>=20
>>  Avail Dev Size : 2930015024 (1397.14 GiB 1500.17 GB)
>>      Array Size : 16115078144 (15368.54 GiB 16501.84 GB)
>>   Used Dev Size : 2930014208 (1397.14 GiB 1500.17 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>    Unused Space : before=3D262064 sectors, after=3D816 sectors
>>           State : clean
>>     Device UUID : b798e990:6b50f1a0:3cde1ced:3a20dfaf
>>=20
>>   Reshape pos'n : 0
>>   Delta Devices : 1 (12->13)
>>=20
>>     Update Time : Thu Aug 13 17:11:05 2015
>>        Checksum : 2053b0c9 - correct
>>          Events : 72402
>>=20
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>=20
>>    Device Role : Active device 2
>>    Array State : AAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g, 'R' =3D=3D=20
>> replacing)
>> /dev/sdh:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x4
>>      Array UUID : 633c1520:61c07f69:26a83b45:b9756587
>>            Name : claw-storage:0  (local to host claw-storage)
>>   Creation Time : Tue Jan 14 12:48:49 2014
>>      Raid Level : raid6
>>    Raid Devices : 13
>>=20
>>  Avail Dev Size : 2930015024 (1397.14 GiB 1500.17 GB)
>>      Array Size : 16115078144 (15368.54 GiB 16501.84 GB)
>>   Used Dev Size : 2930014208 (1397.14 GiB 1500.17 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>    Unused Space : before=3D262064 sectors, after=3D816 sectors
>>           State : clean
>>     Device UUID : bfe03a04:fda138cc:ef11727c:ff1b58d2
>>=20
>>   Reshape pos'n : 0
>>   Delta Devices : 1 (12->13)
>>=20
>>     Update Time : Thu Aug 13 17:11:05 2015
>>        Checksum : 70ba79db - correct
>>          Events : 72402
>>=20
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>=20
>>    Device Role : Active device 3
>>    Array State : AAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g, 'R' =3D=3D=20
>> replacing)
>> /dev/sdi:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x4
>>      Array UUID : 633c1520:61c07f69:26a83b45:b9756587
>>            Name : claw-storage:0  (local to host claw-storage)
>>   Creation Time : Tue Jan 14 12:48:49 2014
>>      Raid Level : raid6
>>    Raid Devices : 13
>>=20
>>  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
>>      Array Size : 16115078144 (15368.54 GiB 16501.84 GB)
>>   Used Dev Size : 2930014208 (1397.14 GiB 1500.17 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>    Unused Space : before=3D262064 sectors, after=3D976752816 sectors
>>           State : clean
>>     Device UUID : 4fdb8a05:3157bd26:f93ee8d7:fdd42f9f
>>=20
>>   Reshape pos'n : 0
>>   Delta Devices : 1 (12->13)
>>=20
>>     Update Time : Thu Aug 13 17:11:05 2015
>>        Checksum : 2f151d28 - correct
>>          Events : 72402
>>=20
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>=20
>>    Device Role : Active device 4
>>    Array State : AAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g, 'R' =3D=3D=20
>> replacing)
>> /dev/sdj:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x4
>>      Array UUID : 633c1520:61c07f69:26a83b45:b9756587
>>            Name : claw-storage:0  (local to host claw-storage)
>>   Creation Time : Tue Jan 14 12:48:49 2014
>>      Raid Level : raid6
>>    Raid Devices : 13
>>=20
>>  Avail Dev Size : 2930015024 (1397.14 GiB 1500.17 GB)
>>      Array Size : 16115078144 (15368.54 GiB 16501.84 GB)
>>   Used Dev Size : 2930014208 (1397.14 GiB 1500.17 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>    Unused Space : before=3D262064 sectors, after=3D816 sectors
>>           State : clean
>>     Device UUID : 6010b774:e02b08ed:29484f97:b03e8a48
>>=20
>>   Reshape pos'n : 0
>>   Delta Devices : 1 (12->13)
>>=20
>>     Update Time : Thu Aug 13 17:11:05 2015
>>        Checksum : 93158c4c - correct
>>          Events : 72402
>>=20
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>=20
>>    Device Role : Active device 5
>>    Array State : AAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g, 'R' =3D=3D=20
>> replacing)
>> /dev/sdk:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x4
>>      Array UUID : 633c1520:61c07f69:26a83b45:b9756587
>>            Name : claw-storage:0  (local to host claw-storage)
>>   Creation Time : Tue Jan 14 12:48:49 2014
>>      Raid Level : raid6
>>    Raid Devices : 13
>>=20
>>  Avail Dev Size : 2930015024 (1397.14 GiB 1500.17 GB)
>>      Array Size : 16115078144 (15368.54 GiB 16501.84 GB)
>>   Used Dev Size : 2930014208 (1397.14 GiB 1500.17 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>    Unused Space : before=3D262064 sectors, after=3D816 sectors
>>           State : clean
>>     Device UUID : afab65ff:a79ed9e7:30ccd918:e2e1c21a
>>=20
>>   Reshape pos'n : 0
>>   Delta Devices : 1 (12->13)
>>=20
>>     Update Time : Thu Aug 13 17:11:05 2015
>>        Checksum : 6c58c19c - correct
>>          Events : 72402
>>=20
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>=20
>>    Device Role : Active device 6
>>    Array State : AAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g, 'R' =3D=3D=20
>> replacing)
>> /dev/sdl:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x4
>>      Array UUID : 633c1520:61c07f69:26a83b45:b9756587
>>            Name : claw-storage:0  (local to host claw-storage)
>>   Creation Time : Tue Jan 14 12:48:49 2014
>>      Raid Level : raid6
>>    Raid Devices : 13
>>=20
>>  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
>>      Array Size : 16115078144 (15368.54 GiB 16501.84 GB)
>>   Used Dev Size : 2930014208 (1397.14 GiB 1500.17 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>    Unused Space : before=3D262056 sectors, after=3D976752816 sectors
>>           State : clean
>>     Device UUID : 8a9031cf:f9b5a888:70363d53:b269047d
>>=20
>>   Reshape pos'n : 0
>>   Delta Devices : 1 (12->13)
>>=20
>>     Update Time : Thu Aug 13 17:11:05 2015
>>   Bad Block Log : 512 entries available at offset 72 sectors
>>        Checksum : b3d8bda7 - correct
>>          Events : 72402
>>=20
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>=20
>>    Device Role : Active device 7
>>    Array State : AAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g, 'R' =3D=3D=20
>> replacing)
>> /dev/sdm:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x4
>>      Array UUID : 633c1520:61c07f69:26a83b45:b9756587
>>            Name : claw-storage:0  (local to host claw-storage)
>>   Creation Time : Tue Jan 14 12:48:49 2014
>>      Raid Level : raid6
>>    Raid Devices : 13
>>=20
>>  Avail Dev Size : 2930015024 (1397.14 GiB 1500.17 GB)
>>      Array Size : 16115078144 (15368.54 GiB 16501.84 GB)
>>   Used Dev Size : 2930014208 (1397.14 GiB 1500.17 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>    Unused Space : before=3D262064 sectors, after=3D816 sectors
>>           State : clean
>>     Device UUID : 1eefdd8c:75b58c0c:f0c555bd:e704e89e
>>=20
>>   Reshape pos'n : 0
>>   Delta Devices : 1 (12->13)
>>=20
>>     Update Time : Thu Aug 13 17:11:05 2015
>>        Checksum : 472538a0 - correct
>>          Events : 72402
>>=20
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>=20
>>    Device Role : Active device 8
>>    Array State : AAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g, 'R' =3D=3D=20
>> replacing)
>> /dev/sdn:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x4
>>      Array UUID : 633c1520:61c07f69:26a83b45:b9756587
>>            Name : claw-storage:0  (local to host claw-storage)
>>   Creation Time : Tue Jan 14 12:48:49 2014
>>      Raid Level : raid6
>>    Raid Devices : 13
>>=20
>>  Avail Dev Size : 2930015024 (1397.14 GiB 1500.17 GB)
>>      Array Size : 16115078144 (15368.54 GiB 16501.84 GB)
>>   Used Dev Size : 2930014208 (1397.14 GiB 1500.17 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>    Unused Space : before=3D262064 sectors, after=3D816 sectors
>>           State : clean
>>     Device UUID : b8f9a259:c4522982:88538283:497eed43
>>=20
>>   Reshape pos'n : 0
>>   Delta Devices : 1 (12->13)
>>=20
>>     Update Time : Thu Aug 13 17:11:05 2015
>>        Checksum : f4b8e783 - correct
>>          Events : 72402
>>=20
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>=20
>>    Device Role : Active device 9
>>    Array State : AAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g, 'R' =3D=3D=20
>> replacing)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
=20
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
