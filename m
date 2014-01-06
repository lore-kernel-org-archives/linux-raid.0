From: NeilBrown <neilb@suse.de>
Subject: Re: looking for advice on raid0+raid5 array recovery with mdadm and
 sector offset
Date: Mon, 6 Jan 2014 12:41:43 +1100
Message-ID: <20140106124143.287894da@notabene.brown>
References: <CANgodhBjRyNDwJwOxepqxX0zMaLtnniYpwWe_k7hjgfRP0UpvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/N914d9dXJ.wNvOzu0bq=qvo"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANgodhBjRyNDwJwOxepqxX0zMaLtnniYpwWe_k7hjgfRP0UpvA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: den Hoog <speedyden@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/N914d9dXJ.wNvOzu0bq=qvo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 2 Jan 2014 20:45:24 +0100 den Hoog <speedyden@gmail.com> wrote:

> Hi Neil
>=20
> I apologize if I made mistakes with the first mail post but probably
> something went wrong, so this is a retry.
>=20
> I'm looking for advice on my plan to recover my raid5 volume with mdadm.
>=20
> I was in a hurry and made a stupid mistake when upgrading the MB bios.
> Forgot to turn on the Intel SATA raid, and Windows recovery erased the
> first disk of 4.
>=20
> It is an array of 4x4TB, in a matrix, having 1 RAID0 volume, and 1 RAID5 =
vol.
> Although the array displays a failed array in Windows, 3 disks are
> active, and 1 is missing and showing as a non-raid array being
> available.
>=20
> In (my) theory, I should still be able to recover the raid5 vol. with
> the remaining 3 disks, however I should specify the specific sector
> offset I guess.
> I read many articles on this, but none of them address the
> 'difficulty' of recovering a specific volume when multiple exist in an
> array.
>=20
> Although I've some backups, I really would appreciate your help in
> getting this recovered.
> sda is the SSD
> sdb is the 'missing' and erased drive (serial ending on P82C)
> sdc is the second drive in the array
> sdd is the 3rd drive in the array
> sde is the 4th drive in the array
> sdf is the usb stick I'm running Fedora live from
>=20
> What I've done so far :
>=20
> - Started Fedora 15 Live from a USB
> - installed the mdadm package data_offset and compiled
>=20
>=20
> My plan to work with an offset to recover the [HitR5] volume:
>=20
> - echo 1 > /sys/module/md_mod/parameters/
> start_dirty_degraded
> - mdadm -C /dev/md/imsm -e imsm -n 4 /dev/sdb /dev/sdc /dev/sdd /dev/sde
> - mdadm -C /dev/md0 -l5 -n4 -c 128   /dev/sdb:1073746184s
> /dev/sdc:1073746184s /dev/sdd:1073746184s /dev/sde:1073746184s

This certainly won't work.
You need "--data-offset=3Dvariable" for the "NNNNs" suffixes to be recognis=
ed,
and even then it only works for 1.x metadata, not for imsm metadata.

There isn't much support for sticking together broken IMSM arrays at
present.  Your best bet is to re-create the whole array.

So:
   mdadm -C /dev/md/imsm -e imsm -n 4 /dev/sd[bcde]
   mdadm -C /dev/md0 -l0 -n4 -c 128K -z 512G /dev/md/imsm

then check that /dev/md0 looks OK for the RAID0 array.
If it does then you can continue to create the raid5 array

   mdadm -C /dev/md1 -l5 -n4 -c 128k --assume-clean /dev/md/imsm

That *should* then be correct.

If the RAID0 array doesn't look right, the possible sdb really was cleared
rather than just having the metadata erased.
In this case the RAID0 is definitely gone and it will be a bit harder to
create the RAID5.  It could be something like:

   mdadm -C /dev/md1 -l5 -n4 -c 128k missing /dev/sd[cde]

but I'm not sure that 'missing' is works for imsm.  If you need to go this
way I can try to make 'missing' for for imsm.  It shouldn't be too hard.

NeilBrown


>=20
>=20
> I'm in doubt about working with missing disks first to start a
> degraded array, with -C and missing for the first drive.
> Or choosing assemble --auto, or as stated above and create the volume wit=
h an
> offset.
>=20
> Another thing I'm not certain of: do I need to build a new mdadm with
> data_offset, or is it already present in my 3.2.6 version?
> When I built a new version with Neils mdadm I ended up with a 3.2.5 18May=
2012
> version.
>=20
> As I guess I have only one shot at this I have not executed anything yet.
>=20
> thanks many for your help, time and advice!
>=20
> best regards Dennis
>=20
>=20
> =3D=3D=3D=3D=3D=3D=3Doutput mdadm -Evvvvs=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>=20
> root@localhost ~]# mdadm -Evvvvs
>=20
> mdadm: No md superblock detected on /dev/dm-1.
>=20
> mdadm: No md superblock detected on /dev/dm-0.
>=20
> /dev/sdf1:
>=20
>    MBR Magic : aa55
>=20
> Partition[0] :    432871117 sectors at   3224498923 (type 07)
>=20
> Partition[1] :   1953460034 sectors at   3272020941 (type 16)
>=20
> Partition[3] :    924335794 sectors at     50200576 (type 00)
>=20
> /dev/sdf:
>=20
>    MBR Magic : aa55
>=20
> Partition[0] :     15769600 sectors at         2048 (type 0b)
>=20
> /dev/sde:
>=20
>           Magic : Intel Raid ISM Cfg Sig.
>=20
>         Version : 1.3.00
>=20
>     Orig Family : f3437c9b
>=20
>          Family : f3437c9d
>=20
>      Generation : 00002c5f
>=20
>      Attributes : All supported
>=20
>            UUID : 47b011c7:4a8531ea:7e94ab93:06034952
>=20
>        Checksum : 671f5f84 correct
>=20
>     MPB Sectors : 2
>=20
>           Disks : 4
>=20
>    RAID Devices : 2
>=20
>=20
>   Disk03 Serial : PL1321LAG4RXEH
>=20
>           State : active
>=20
>              Id : 00000005
>=20
>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>=20
>=20
> [HitR0]:
>=20
>            UUID : 73ecf2cf:fcfd2598:d6523381:71e57931
>=20
>      RAID Level : 0
>=20
>         Members : 4
>=20
>           Slots : [_UUU]
>=20
>     Failed disk : 1
>=20
>       This Slot : 3
>=20
>      Array Size : 4294967296 (2048.00 GiB 2199.02 GB)
>=20
>    Per Dev Size : 1073742088 (512.00 GiB 549.76 GB)
>=20
>   Sector Offset : 0
>=20
>     Num Stripes : 4194304
>=20
>      Chunk Size : 128 KiB
>=20
>        Reserved : 0
>=20
>   Migrate State : idle
>=20
>       Map State : failed
>=20
>     Dirty State : clean
>=20
>=20
> [HitR5]:
>=20
>            UUID : 71626250:b8fc1262:3545d952:69eb329e
>=20
>      RAID Level : 5
>=20
>         Members : 4
>=20
>           Slots : [_UU_]
>=20
>     Failed disk : 3
>=20
>       This Slot : 3 (out-of-sync)
>=20
>      Array Size : 20220831744 (9642.04 GiB 10353.07 GB)
>=20
>    Per Dev Size : 6740279304 (3214.02 GiB 3451.02 GB)
>=20
>   Sector Offset : 1073746184
>=20
>     Num Stripes : 26329208
>=20
>      Chunk Size : 128 KiB
>=20
>        Reserved : 0
>=20
>   Migrate State : idle
>=20
>       Map State : failed
>=20
>     Dirty State : clean
>=20
>=20
>   Disk00 Serial : PL2311LAG1P82C:0
>=20
>           State : active
>=20
>              Id : ffffffff
>=20
>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>=20
>=20
>   Disk01 Serial : PL1321LAG4NMEH
>=20
>           State : active
>=20
>              Id : 00000003
>=20
>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>=20
>=20
>   Disk02 Serial : PL1321LAG4TH4H
>=20
>           State : active
>=20
>              Id : 00000004
>=20
>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>=20
> /dev/sdd:
>=20
>           Magic : Intel Raid ISM Cfg Sig.
>=20
>         Version : 1.3.00
>=20
>     Orig Family : f3437c9b
>=20
>          Family : f3437c9d
>=20
>      Generation : 00002c5f
>=20
>      Attributes : All supported
>=20
>            UUID : 47b011c7:4a8531ea:7e94ab93:06034952
>=20
>        Checksum : 671f5f84 correct
>=20
>     MPB Sectors : 2
>=20
>           Disks : 4
>=20
>    RAID Devices : 2
>=20
>=20
>   Disk02 Serial : PL1321LAG4TH4H
>=20
>           State : active
>=20
>              Id : 00000004
>=20
>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>=20
>=20
> [HitR0]:
>=20
>            UUID : 73ecf2cf:fcfd2598:d6523381:71e57931
>=20
>      RAID Level : 0
>=20
>         Members : 4
>=20
>           Slots : [_UUU]
>=20
>     Failed disk : 1
>=20
>       This Slot : 2
>=20
>      Array Size : 4294967296 (2048.00 GiB 2199.02 GB)
>=20
>    Per Dev Size : 1073742088 (512.00 GiB 549.76 GB)
>=20
>   Sector Offset : 0
>=20
>     Num Stripes : 4194304
>=20
>      Chunk Size : 128 KiB
>=20
>        Reserved : 0
>=20
>   Migrate State : idle
>=20
>       Map State : failed
>=20
>     Dirty State : clean
>=20
>=20
> [HitR5]:
>=20
>            UUID : 71626250:b8fc1262:3545d952:69eb329e
>=20
>      RAID Level : 5
>=20
>         Members : 4
>=20
>           Slots : [_UU_]
>=20
>     Failed disk : 3
>=20
>       This Slot : 2
>=20
>      Array Size : 20220831744 (9642.04 GiB 10353.07 GB)
>=20
>    Per Dev Size : 6740279304 (3214.02 GiB 3451.02 GB)
>=20
>   Sector Offset : 1073746184
>=20
>     Num Stripes : 26329208
>=20
>      Chunk Size : 128 KiB
>=20
>        Reserved : 0
>=20
>   Migrate State : idle
>=20
>       Map State : failed
>=20
>     Dirty State : clean
>=20
>=20
>   Disk00 Serial : PL2311LAG1P82C:0
>=20
>           State : active
>=20
>              Id : ffffffff
>=20
>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>=20
>=20
>   Disk01 Serial : PL1321LAG4NMEH
>=20
>           State : active
>=20
>              Id : 00000003
>=20
>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>=20
>=20
>   Disk03 Serial : PL1321LAG4RXEH
>=20
>           State : active
>=20
>              Id : 00000005
>=20
>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>=20
> /dev/sdc:
>=20
>           Magic : Intel Raid ISM Cfg Sig.
>=20
>         Version : 1.3.00
>=20
>     Orig Family : f3437c9b
>=20
>          Family : f3437c9d
>=20
>      Generation : 00002c5f
>=20
>      Attributes : All supported
>=20
>            UUID : 47b011c7:4a8531ea:7e94ab93:06034952
>=20
>        Checksum : 671f5f84 correct
>=20
>     MPB Sectors : 2
>=20
>           Disks : 4
>=20
>    RAID Devices : 2
>=20
>=20
>   Disk01 Serial : PL1321LAG4NMEH
>=20
>           State : active
>=20
>              Id : 00000003
>=20
>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>=20
>=20
> [HitR0]:
>=20
>            UUID : 73ecf2cf:fcfd2598:d6523381:71e57931
>=20
>      RAID Level : 0
>=20
>         Members : 4
>=20
>           Slots : [_UUU]
>=20
>     Failed disk : 1
>=20
>       This Slot : 1
>=20
>      Array Size : 4294967296 (2048.00 GiB 2199.02 GB)
>=20
>    Per Dev Size : 1073742088 (512.00 GiB 549.76 GB)
>=20
>   Sector Offset : 0
>=20
>     Num Stripes : 4194304
>=20
>      Chunk Size : 128 KiB
>=20
>        Reserved : 0
>=20
>   Migrate State : idle
>=20
>       Map State : failed
>=20
>     Dirty State : clean
>=20
>=20
> [HitR5]:
>=20
>            UUID : 71626250:b8fc1262:3545d952:69eb329e
>=20
>      RAID Level : 5
>=20
>         Members : 4
>=20
>           Slots : [_UU_]
>=20
>     Failed disk : 3
>=20
>       This Slot : 1
>=20
>      Array Size : 20220831744 (9642.04 GiB 10353.07 GB)
>=20
>    Per Dev Size : 6740279304 (3214.02 GiB 3451.02 GB)
>=20
>   Sector Offset : 1073746184
>=20
>     Num Stripes : 26329208
>=20
>      Chunk Size : 128 KiB
>=20
>        Reserved : 0
>=20
>   Migrate State : idle
>=20
>       Map State : failed
>=20
>     Dirty State : clean
>=20
>=20
>   Disk00 Serial : PL2311LAG1P82C:0
>=20
>           State : active
>=20
>              Id : ffffffff
>=20
>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>=20
>=20
>   Disk02 Serial : PL1321LAG4TH4H
>=20
>           State : active
>=20
>              Id : 00000004
>=20
>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>=20
>=20
>   Disk03 Serial : PL1321LAG4RXEH
>=20
>           State : active
>=20
>              Id : 00000005
>=20
>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>=20
> mdadm: No md superblock detected on /dev/sdb1.
>=20
> /dev/sdb:
>=20
>    MBR Magic : aa55
>=20
> Partition[0] :   4294967295 sectors at            1 (type ee)
>=20
> /dev/sda2:
>=20
>    MBR Magic : aa55
>=20
> Partition[0] :   1816210284 sectors at   1920221984 (type 72)
>=20
> Partition[1] :   1953653108 sectors at   1936028192 (type 6c)
>=20
> Partition[3] :          447 sectors at     27722122 (type 00)
>=20
> /dev/sda1:
>=20
>    MBR Magic : aa55
>=20
> Partition[0] :   1816210284 sectors at   1920221984 (type 72)
>=20
> Partition[1] :   1953653108 sectors at   1936028192 (type 6c)
>=20
> Partition[3] :          447 sectors at     27722122 (type 00)
>=20
> /dev/sda:
>=20
>    MBR Magic : aa55
>=20
> Partition[0] :       716800 sectors at         2048 (type 07)
>=20
> Partition[1] :    499396608 sectors at       718848 (type 07)
>=20
> mdadm: No md superblock detected on /dev/loop4.
>=20
> mdadm: No md superblock detected on /dev/loop3.
>=20
> mdadm: No md superblock detected on /dev/loop2.
>=20
> mdadm: No md superblock detected on /dev/loop1.
>=20
> mdadm: No md superblock detected on /dev/loop0.
>=20
> /dev/md127:
>=20
>           Magic : Intel Raid ISM Cfg Sig.
>=20
>         Version : 1.3.00
>=20
>     Orig Family : f3437c9b
>=20
>          Family : f3437c9d
>=20
>      Generation : 00002c5f
>=20
>      Attributes : All supported
>=20
>            UUID : 47b011c7:4a8531ea:7e94ab93:06034952
>=20
>        Checksum : 671f5f84 correct
>=20
>     MPB Sectors : 2
>=20
>           Disks : 4
>=20
>    RAID Devices : 2
>=20
>=20
>   Disk02 Serial : PL1321LAG4TH4H
>=20
>           State : active
>=20
>              Id : 00000004
>=20
>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>=20
>=20
> [HitR0]:
>=20
>            UUID : 73ecf2cf:fcfd2598:d6523381:71e57931
>=20
>      RAID Level : 0
>=20
>         Members : 4
>=20
>           Slots : [_UUU]
>=20
>     Failed disk : 1
>=20
>       This Slot : 2
>=20
>      Array Size : 4294967296 (2048.00 GiB 2199.02 GB)
>=20
>    Per Dev Size : 1073742088 (512.00 GiB 549.76 GB)
>=20
>   Sector Offset : 0
>=20
>     Num Stripes : 4194304
>=20
>      Chunk Size : 128 KiB
>=20
>        Reserved : 0
>=20
>   Migrate State : idle
>=20
>       Map State : failed
>=20
>     Dirty State : clean
>=20
>=20
> [HitR5]:
>=20
>            UUID : 71626250:b8fc1262:3545d952:69eb329e
>=20
>      RAID Level : 5
>=20
>         Members : 4
>=20
>           Slots : [_UU_]
>=20
>     Failed disk : 3
>=20
>       This Slot : 2
>=20
>      Array Size : 20220831744 (9642.04 GiB 10353.07 GB)
>=20
>    Per Dev Size : 6740279304 (3214.02 GiB 3451.02 GB)
>=20
>   Sector Offset : 1073746184
>=20
>     Num Stripes : 26329208
>=20
>      Chunk Size : 128 KiB
>=20
>        Reserved : 0
>=20
>   Migrate State : idle
>=20
>       Map State : failed
>=20
>     Dirty State : clean
>=20
>=20
>   Disk00 Serial : PL2311LAG1P82C:0
>=20
>           State : active
>=20
>              Id : ffffffff
>=20
>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>=20
>=20
>   Disk01 Serial : PL1321LAG4NMEH
>=20
>           State : active
>=20
>              Id : 00000003
>=20
>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
>=20
>=20
>   Disk03 Serial : PL1321LAG4RXEH
>=20
>           State : active
>=20
>              Id : 00000005
>=20
>     Usable Size : 7814030862 (3726.02 GiB 4000.78 GB)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/N914d9dXJ.wNvOzu0bq=qvo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUsoJ1znsnt1WYoG5AQImwg/+Id0aUrGbo/vEibj63RAcJED25AdJHaqE
jo9aa3omw8jB4wuMhKzEcJejza94xh/Jke3bLkMCYmG5uo7gAXznSc/Pq2kO/Rtx
jDLSPotrkAysD389J4SLtQzzkXj+PovaYWHh7VGrBB3+d1Cc2hB3yXruiDNxytRR
Gwr2ATiyNi/G5r2CJOB2DZm36ozdBWaANRsvJa1pZIgy/EEdqCmYZ5nZso4ulSwQ
+dJZxyVTnJqgUYrOACxTkSxNhuqCnvrF2+xgx2llcMrzslvUUPNuxl5IHntsPW1P
i5DSRvLmyGduCli5ElWQR35IqFpo5Qde12nag+f6dQ0cdsCbXLLvNcxHJvUrBSDK
gaj8ua65gNJwSeg4zlyq5SO3Eiq4OaH19gNjzUmoHT5D0of9t/HQcq1uNEND36EX
xpOcAtuBxIT1zINkeUw2ldpLBcnj1EoFBoEyRXWrAHsLne2JPqSn72w6zDI7XhQN
mXuuaBOKFGGsnWdfADD80yIgCWLER+FVCxrFF1Vme+Yaly8y2v10meZ2k8bpyi9q
sFCkNA4rommR1ApwiTg6ACXhg5dPHB4cnx8T40e2fOhNYx7RIPsNo7cVUrBV8rZX
IsZYb+zDKLuPEKnUU3K4gTNvOfvlKBbdPXOaUu4gbT1s5TqnzR+/+FeQocGNi3Ik
+8tPyI8Q5rc=
=KK7o
-----END PGP SIGNATURE-----

--Sig_/N914d9dXJ.wNvOzu0bq=qvo--
