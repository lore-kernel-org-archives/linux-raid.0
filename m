From: "John Stoffel" <john@stoffel.org>
Subject: Re: Re: =?iso-8859-1?Q?Re=A0:?= Re: Big trouble during reassemble a Raid5
Date: Tue, 30 Dec 2014 16:06:34 -0500
Message-ID: <21667.5082.319655.422377@quad.stoffel.home>
References: <2105542796.11263344.1419768937013.JavaMail.zimbra@laposte.net>
	<938521225.11264152.1419768981146.JavaMail.zimbra@laposte.net>
	<21665.40484.909891.197506@quad.stoffel.home>
	<164935924.13594562.1419881845418.JavaMail.zimbra@laposte.net>
	<21665.47943.879001.195325@quad.stoffel.home>
	<1916328338.14439065.1419932231303.JavaMail.zimbra@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1916328338.14439065.1419932231303.JavaMail.zimbra@laposte.net>
Sender: linux-raid-owner@vger.kernel.org
To: sylvain.depuille@laposte.net
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "sylvain" =3D=3D sylvain depuille <sylvain.depuille@laposte.net> =
writes:

sylvain> Hi John,
sylvain> I'm sorry! I'm French and my English is poor!

No problems, your english is much better than I could ever do in
=46rench! =20

sylvain> Yesterday, i have try to you explain what is the history of
sylvain> the issue.  The Raid was fully operational before i change
sylvain> the disk sde by a 3TB disk to grow the Raid, by changing all
sylvain> disks of the raid.  But when i have do the re-assemble the
sylvain> disk sdc goes burny :-(

sylvain> I have keep the old sde 1TB disk in state.

sylvain> The result of your asked command :

sylvain> cat /proc/mdstat
sylvain> Personalities : [raid1] [raid6] [raid5] [raid4]=20
sylvain> md2 : inactive sdc1[2](S) sdd1[3](S) sde1[4](S) sdb1[5](S)
sylvain> 5077760089 blocks super 1.2

Ok, this looks like the raid won't assemble, which is probably fine
for now.=20

sylvain> major minor  #blocks  name

sylvain> 8        0  125034840 sda
sylvain> 8        1     131072 sda1
sylvain> 8        2   62914560 sda2
sylvain> 8        3   61865984 sda3
sylvain> 8       32  976762584 sdc
sylvain> 8       33  976760001 sdc1
sylvain> 8       48  976762584 sdd
sylvain> 8       49  976760001 sdd1
sylvain> 8       16  976762584 sdb
sylvain> 8       17  976761560 sdb1
sylvain> 8       64 2930266584 sde
sylvain> 8       65 2147482623 sde1

Did the reshape or replacement of /dev/sde 1tb work fine to the 3tb
disk?  It's not clear to me, and I want to be safe.  But I think you
should be able to do the --assemble --force command once the dd_rescue
has finished from the bad disk onto the new disk. =20

Then I would also seriously think about moving to RAID6 for your data
as well.  It's cheap insurance when you have lots of important data
and such to keep.

sylvain> mdadm --detail /dev/md2
sylvain> /dev/md2:
sylvain> Version : 1.2
sylvain> Raid Level : raid0
sylvain> Total Devices : 4
sylvain> Persistence : Superblock is persistent

sylvain> State : inactive

sylvain> Name : le-bohec:2  (local to host le-bohec)
sylvain> UUID : 2a1440cd:762a90fb:e3bd2f4d:617acb0e
sylvain> Events : 167456

sylvain> Number   Major   Minor   RaidDevice

sylvain> -       8       17        -        /dev/sdb1
sylvain> -       8       33        -        /dev/sdc1
sylvain> -       8       49        -        /dev/sdd1
sylvain> -       8       65        -        /dev/sde1


sylvain> mdadm -E /dev/sd[bcde]1
sylvain> /dev/sdb1:
sylvain> Magic : a92b4efc
sylvain> Version : 1.2
sylvain> Feature Map : 0x1
sylvain> Array UUID : 2a1440cd:762a90fb:e3bd2f4d:617acb0e
sylvain> Name : le-bohec:2  (local to host le-bohec)
sylvain> Creation Time : Tue Apr  9 17:56:19 2013
sylvain> Raid Level : raid5
sylvain> Raid Devices : 4

sylvain> Avail Dev Size : 1953521072 (931.51 GiB 1000.20 GB)
sylvain> Array Size : 2930276352 (2794.53 GiB 3000.60 GB)
sylvain> Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)
sylvain> Data Offset : 2048 sectors
sylvain> Super Offset : 8 sectors
sylvain> Unused Space : before=3D1960 sectors, after=3D3504 sectors
sylvain> State : clean
sylvain> Device UUID : 8506e09c:b87a44ed:7b4ee314:777ce89c

sylvain> Internal Bitmap : 8 sectors from superblock
sylvain> Update Time : Sat Dec 27 22:08:34 2014
sylvain> Bad Block Log : 512 entries available at offset 72 sectors
sylvain> Checksum : bad62d22 - correct
sylvain> Events : 167456

sylvain> Layout : left-symmetric
sylvain> Chunk Size : 512K

sylvain> Device Role : Active device 0
sylvain> Array State : A.A. ('A' =3D=3D active, '.' =3D=3D missing, 'R'=
 =3D=3D replacing)
sylvain> /dev/sdc1:
sylvain> Magic : a92b4efc
sylvain> Version : 1.2
sylvain> Feature Map : 0x1
sylvain> Array UUID : 2a1440cd:762a90fb:e3bd2f4d:617acb0e
sylvain> Name : le-bohec:2  (local to host le-bohec)
sylvain> Creation Time : Tue Apr  9 17:56:19 2013
sylvain> Raid Level : raid5
sylvain> Raid Devices : 4

sylvain> Avail Dev Size : 1953517954 (931.51 GiB 1000.20 GB)
sylvain> Array Size : 2930276352 (2794.53 GiB 3000.60 GB)
sylvain> Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)
sylvain> Data Offset : 2048 sectors
sylvain> Super Offset : 8 sectors
sylvain> Unused Space : before=3D1968 sectors, after=3D386 sectors
sylvain> State : clean
sylvain> Device UUID : 44002aad:d3e17729:a93854eb:4139972e

sylvain> Internal Bitmap : 8 sectors from superblock
sylvain> Update Time : Sat Dec 27 22:08:22 2014
sylvain> Checksum : 6f69285d - correct
sylvain> Events : 167431

sylvain> Layout : left-symmetric
sylvain> Chunk Size : 512K

sylvain> Device Role : Active device 1
sylvain> Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R'=
 =3D=3D replacing)
sylvain> /dev/sdd1:
sylvain> Magic : a92b4efc
sylvain> Version : 1.2
sylvain> Feature Map : 0x1
sylvain> Array UUID : 2a1440cd:762a90fb:e3bd2f4d:617acb0e
sylvain> Name : le-bohec:2  (local to host le-bohec)
sylvain> Creation Time : Tue Apr  9 17:56:19 2013
sylvain> Raid Level : raid5
sylvain> Raid Devices : 4

sylvain> Avail Dev Size : 1953517954 (931.51 GiB 1000.20 GB)
sylvain> Array Size : 2930276352 (2794.53 GiB 3000.60 GB)
sylvain> Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)
sylvain> Data Offset : 2048 sectors
sylvain> Super Offset : 8 sectors
sylvain> Unused Space : before=3D1968 sectors, after=3D386 sectors
sylvain> State : clean
sylvain> Device UUID : 5cff6f7f:ea6b89b6:28e4e8b3:7a2b5a7f

sylvain> Internal Bitmap : 8 sectors from superblock
sylvain> Update Time : Sat Dec 27 22:08:34 2014
sylvain> Checksum : e81a4f63 - correct
sylvain> Events : 167456

sylvain> Layout : left-symmetric
sylvain> Chunk Size : 512K

sylvain> Device Role : Active device 2
sylvain> Array State : A.A. ('A' =3D=3D active, '.' =3D=3D missing, 'R'=
 =3D=3D replacing)
sylvain> /dev/sde1:
sylvain> Magic : a92b4efc
sylvain> Version : 1.2
sylvain> Feature Map : 0x9
sylvain> Array UUID : 2a1440cd:762a90fb:e3bd2f4d:617acb0e
sylvain> Name : le-bohec:2  (local to host le-bohec)
sylvain> Creation Time : Tue Apr  9 17:56:19 2013
sylvain> Raid Level : raid5
sylvain> Raid Devices : 4

sylvain> Avail Dev Size : 4294963199 (2048.00 GiB 2199.02 GB)
sylvain> Array Size : 2930276352 (2794.53 GiB 3000.60 GB)
sylvain> Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)
sylvain> Data Offset : 2048 sectors
sylvain> Super Offset : 8 sectors
sylvain> Unused Space : before=3D1960 sectors, after=3D2341445631 secto=
rs
sylvain> State : clean
sylvain> Device UUID : 0ebce28d:1a792d55:76a86538:12cc94dd

sylvain> Internal Bitmap : 8 sectors from superblock
sylvain> Update Time : Sat Dec 27 22:08:34 2014
sylvain> Bad Block Log : 512 entries available at offset 72 sectors - b=
ad blocks present.
sylvain> Checksum : 3801cfa - correct
sylvain> Events : 167456

sylvain> Layout : left-symmetric
sylvain> Chunk Size : 512K

sylvain> Device Role : spare
sylvain> Array State : A.A. ('A' =3D=3D active, '.' =3D=3D missing, 'R'=
 =3D=3D replacing)


sylvain> Now, i have installed ddrescue on the system, and i go to my
sylvain> friends to add the 2TB disk in the tower, and launch the
sylvain> command.




sylvain> Many thank's for your help and your patience.
sylvain> Best Regards
sylvain> Sylvain Depuille

sylvain> ----- Mail original -----=20
sylvain> De: "John Stoffel" <john@stoffel.org>=20
sylvain> =C0: "sylvain depuille" <sylvain.depuille@laposte.net>=20
sylvain> Cc: "John Stoffel" <john@stoffel.org>, linux-raid@vger.kernel.=
org=20
sylvain> Envoy=E9: Lundi 29 D=E9cembre 2014 21:36:23=20
sylvain> Objet: Re: Re : Re: Big trouble during reassemble a Raid5=20


sylvain> Hi john, thanks for your answer! I have change a 1TB disk to=20
sylvain> growing the raid with 3TB disk. if i can re-insert the old=20
sylvain> 1TB disk in place of 3TB disk, only some log and history are=20
sylvain> corrupted. i think that is the best way to relaunch the raid=20
sylvain> without data loss. But i dont known how change the timestamp=20
sylvain> of the one raid disk. Have you a magic command to change a=20
sylvain> timestamp of a raid partition, and how known the timestamp of=20
sylvain> the other disk of the raid? After' raid relaunch, i can=20
sylvain> change the burn disk by a 3TB new one. To do the ddrescue, i=20
sylvain> have a 2TB disk spare! Its not the same geometry, is it=20
sylvain> possible? thanks in advance for your help=20

sylvain> Sylvain,=20

sylvain> Always glad to help here. I'm going to try and understand what=
 you=20
sylvain> wrote and do my best to reply.=20

sylvain> Is the 1Tb disk the bad disk? And if you re-insert it and re-s=
tart=20
sylvain> the RAID5 array, you only have some minor lost files? If so, I=
 would=20
sylvain> probably just copy all the data off the RAID5 onto the single =
3Tb disk=20
sylvain> as a quick and dirty backup, then I'd use 'dd_rescue' to copy =
the bad=20
sylvain> 1Tb disk onto the new 2Tb disk.=20

sylvain> All you would have to do is make a partition on the 2tb disk w=
hich is=20
sylvain> the same size (or a little bigger) than the partition on the 1=
tb disk,=20
sylvain> then copy the partition over like this:=20

sylvain> ddrescue /dev/sd[BAD DISK LETTER HERE]1 /dev/sd[2TB disk lette=
r]1 \=20
sylvain> /tmp/rescue.log=20

sylvain> So say the bad disk is sdc, and the good 2tb is sdf, you would=
 do:=20

sylvain> ddrescue /dev/sdc1 /dev/sdf1 /tmp/rescue.log=20

sylvain> and let it go. Then you would assemble the array using the NEW=
 2tb=20
sylvain> disk. Ideally you would remove the bad 1tb disk from the syste=
m when=20
sylvain> trying to do this.=20

sylvain> But you really do need send us the output of the following com=
mands:=20

sylvain> cat /proc/mdstat=20
sylvain> cat /proc/partitions=20
sylvain> mdadm --detail /dev/md#=20

sylvain> do the above for the RADI5 array.=20

sylvain> mdadm --examine /dev/sd#1=20

sylvain> for each disk in the RAID5 array.=20

sylvain> And we can give you better advice.=20

sylvain> Good luck!=20


sylvain> ---------------------------------- Sylvain Depuille=20
sylvain> sylvain.depuille@laposte.net ----- Mail d'origine ----- De:=20
sylvain> John Stoffel <john@stoffel.org> =C0: sylvain depuille=20
sylvain> <sylvain.depuille@laposte.net> Cc: linux-raid@vger.kernel.org=20
sylvain> Envoy=E9: Mon, 29 Dec 2014 19:32:04 +0100 (CET) Objet: Re: Big=
=20
sylvain> trouble during reassemble a Raid5=20

sylvain> Sylvain, I would recommend that you buy a replacement disk=20
sylvain> for the one throwing errors and then run dd_rescue to copy as=20
sylvain> much data from the dying disk to the replacement. Then, and=20
sylvain> only then, do you try to reassemble the array with the=20
sylvain> --force option. That disk is dying, and dying quickly. Can=20
sylvain> you also post the output of mdadm -E /dev/sd[bcde]1 for each=20
sylvain> disk, even the dying one, so we can look at the counts and=20
sylvain> give you some more advice. Also, the output of the mdadm=20
sylvain> --assemble --force /dev/md2 /dev/sd[bcde]1 would also be=20
sylvain> good. The more info the better. Good luck! John=20

sylvain> i'm sorry to ask this questions but the raid 5 with 4 disk is=20
sylvain> in big trouble during re-assemble. 2 disks are out of order.=20
sylvain> I have change a disk of the raid 5 (sde) to growing the raid.=20
sylvain> But a second disk (sdc) have too many bad sector during the=20
sylvain> re-assemble, and shutdown the re-assemble. "mdadm --assemble=20
sylvain> --force /dev/md2 /dev/sd[bcde]1" I have try to correct bad=20
sylvain> sectors with badblocks, but it's finished by no more spare=20
sylvain> sectors and the disk still have some bad sector. badblocks -b=20
sylvain> 512 -o badblocks-sdc.txt -v -n /dev/sdc 1140170000 1140169336=20
sylvain> 1140169400 1140169401 1140169402 1140169403 1140169404=20
sylvain> 1140169405 1140169406 1140169407 1140169416 1140169417=20
sylvain> 1140169418 1140169419 1140169420 1140169421 1140169422=20
sylvain> 1140169423=20

sylvain> For information the mdadm examine return : cat mdadm-exam.txt=20
sylvain> /dev/sdb: MBR Magic : aa55 Partition[0] : 1953523120 sectors=20
sylvain> at 2048 (type fd) /dev/sdc: MBR Magic : aa55 Partition[0] :=20
sylvain> 1953520002 sectors at 63 (type fd) /dev/sdd: MBR Magic : aa55=20
sylvain> Partition[0] : 1953520002 sectors at 63 (type fd) /dev/sde:=20
sylvain> MBR Magic : aa55 Partition[0] : 4294965247 sectors at 2048=20
sylvain> (type fd) I have 2 way to solve the issue. The first, is to=20
sylvain> have special command to pass bad sector during re-assemble as=20
sylvain> "mdadm --assemble --force /dev/md2 /dev/sd[bcde]1" The second=20
sylvain> is change the disk sde with the old good one, but some datas=20
sylvain> have been changed on the raid since i have remove it. But=20
sylvain> these datas are not important. It's only logs and history=20
sylvain> activity. What can i do to recover a maximum datas without=20
sylvain> too many risk? Thank's in advance Best Regards=20
sylvain> ---------------------------------- Sylvain Depuille (in=20
sylvain> trouble) sylvain.depuille@laposte.net -- To unsubscribe from=20
sylvain> this list: send the line "unsubscribe linux-raid" in the body=20
sylvain> of a message to majordomo@vger.kernel.org More majordomo info=20
sylvain> at http://vger.kernel.org/majordomo-info.html=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
