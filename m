From: sylvain.depuille@laposte.net
Subject: =?utf-8?Q?Re:_Re=C2=A0:_Re:_Big_trouble_during_reassemble_a_Raid5?=
Date: Wed, 31 Dec 2014 15:51:20 +0100 (CET)
Message-ID: <2050225023.16668598.1420037480502.JavaMail.zimbra@laposte.net>
References: <2105542796.11263344.1419768937013.JavaMail.zimbra@laposte.net> <21665.40484.909891.197506@quad.stoffel.home> <164935924.13594562.1419881845418.JavaMail.zimbra@laposte.net> <21665.47943.879001.195325@quad.stoffel.home> <84D72604-6572-40D9-8861-19B28BBF91B6@laposte.net> <21667.5112.568800.563410@quad.stoffel.home> <367813595.16604641.1420034830100.JavaMail.zimbra@laposte.net> <21668.1236.130012.995660@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21668.1236.130012.995660@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

It's my fault too, because the mailing list doesn't accept HTML format.
And my provider doesn't offer plain text option with the mobile site :-=
(

Back to the issue :

I have stop the raid.
mdadm --stop /dev/md2
mdadm: stopped /dev/md2

cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]=20
unused devices: <none>

And when i try to re-assemble, the command is aborting :
mdadm --assemble --force /dev/md2 /dev/sd[bcde]1
mdadm: /dev/md2 assembled from 2 drives and 1 spare - not enough to sta=
rt the array.


The command wan't re-acquire the sdc1 device :
cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]=20
md2 : inactive sde1[4](S) sdd1[2](S) sdb1[5](S)
      4101001112 blocks super 1.2
      =20
unused devices: <none>


Many thank's for your help.
Best Regards
Sylvain Depuille

----- Mail original -----=20
De: "John Stoffel" <john@stoffel.org>=20
=C3=80: "sylvain depuille" <sylvain.depuille@laposte.net>=20
Cc: "John Stoffel" <john@stoffel.org>=20
Envoy=C3=A9: Mercredi 31 D=C3=A9cembre 2014 15:14:44=20
Objet: Re: Re: Re : Re: Big trouble during reassemble a Raid5=20


sylvain> I have remove the 1TB burny disk, and replace it by the 2TB=20
sylvain> ddrescued of the burny disk.=20

Great,=20

sylvain> But i can't re-assemble the raid.=20
sylvain> mdadm --assemble --force /dev/md2 /dev/sd[bcde]1=20
sylvain> mdadm: /dev/sdb1 is busy - skipping=20
sylvain> mdadm: /dev/sdd1 is busy - skipping=20
sylvain> mdadm: /dev/sde1 is busy - skipping=20
sylvain> mdadm: Merging with already-assembled /dev/md/2=20
sylvain> mdadm: /dev/md/2 assembled from 2 drives and 1 spare - not eno=
ugh to start the array.=20

I think you first need to stop the array, to make sure all the devices=20
aren't in use. Have you looked through the archives of this list for=20
previous examples?=20

So you should be able to do:=20

> mdadm --stop md2=20
> mdadm --assemble --force /dev/md2 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/=
sde1=20

and send the output. You should also be replying to the mailing list=20
as well, which I just noticed you haven't. My fault too!=20


sylvain> cat /proc/mdstat :=20
sylvain> Personalities : [raid1] [raid6] [raid5] [raid4]=20
sylvain> md2 : inactive sdd1[2](S) sde1[4](S) sdb1[5](S)=20
sylvain> 4101001112 blocks super 1.2=20

sylvain> unused devices: <none>=20

sylvain> The result of command mdadm -E /dev/sd[bcde]1 > mdadm-E-new.lo=
g is=20
sylvain> /dev/sdb1:=20
sylvain> Magic : a92b4efc=20
sylvain> Version : 1.2=20
sylvain> Feature Map : 0x1=20
sylvain> Array UUID : 2a1440cd:762a90fb:e3bd2f4d:617acb0e=20
sylvain> Name : le-bohec:2 (local to host le-bohec)=20
sylvain> Creation Time : Tue Apr 9 17:56:19 2013=20
sylvain> Raid Level : raid5=20
sylvain> Raid Devices : 4=20

sylvain> Avail Dev Size : 1953521072 (931.51 GiB 1000.20 GB)=20
sylvain> Array Size : 2930276352 (2794.53 GiB 3000.60 GB)=20
sylvain> Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)=20
sylvain> Data Offset : 2048 sectors=20
sylvain> Super Offset : 8 sectors=20
sylvain> Unused Space : before=3D1960 sectors, after=3D3504 sectors=20
sylvain> State : clean=20
sylvain> Device UUID : 8506e09c:b87a44ed:7b4ee314:777ce89c=20

sylvain> Internal Bitmap : 8 sectors from superblock=20
sylvain> Update Time : Sat Dec 27 22:08:34 2014=20
sylvain> Bad Block Log : 512 entries available at offset 72 sectors=20
sylvain> Checksum : bad52d25 - correct=20
sylvain> Events : 167456=20

sylvain> Layout : left-symmetric=20
sylvain> Chunk Size : 512K=20

sylvain> Device Role : Active device 0=20
sylvain> Array State : AAA. ('A' =3D=3D active, '.' =3D=3D missing, 'R'=
 =3D=3D replacing)=20
sylvain> /dev/sdc1:=20
sylvain> Magic : a92b4efc=20
sylvain> Version : 1.2=20
sylvain> Feature Map : 0x1=20
sylvain> Array UUID : 2a1440cd:762a90fb:e3bd2f4d:617acb0e=20
sylvain> Name : le-bohec:2 (local to host le-bohec)=20
sylvain> Creation Time : Tue Apr 9 17:56:19 2013=20
sylvain> Raid Level : raid5=20
sylvain> Raid Devices : 4=20

sylvain> Avail Dev Size : 1953517954 (931.51 GiB 1000.20 GB)=20
sylvain> Array Size : 2930276352 (2794.53 GiB 3000.60 GB)=20
sylvain> Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)=20
sylvain> Data Offset : 2048 sectors=20
sylvain> Super Offset : 8 sectors=20
sylvain> Unused Space : before=3D1968 sectors, after=3D386 sectors=20
sylvain> State : clean=20
sylvain> Device UUID : 44002aad:d3e17729:a93854eb:4139972e=20

sylvain> Internal Bitmap : 8 sectors from superblock=20
sylvain> Update Time : Sat Dec 27 22:08:22 2014=20
sylvain> Checksum : 6f69285d - correct=20
sylvain> Events : 167431=20

sylvain> Layout : left-symmetric=20
sylvain> Chunk Size : 512K=20

sylvain> Device Role : Active device 1=20
sylvain> Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R'=
 =3D=3D replacing)=20
sylvain> /dev/sdd1:=20
sylvain> Magic : a92b4efc=20
sylvain> Version : 1.2=20
sylvain> Feature Map : 0x1=20
sylvain> Array UUID : 2a1440cd:762a90fb:e3bd2f4d:617acb0e=20
sylvain> Name : le-bohec:2 (local to host le-bohec)=20
sylvain> Creation Time : Tue Apr 9 17:56:19 2013=20
sylvain> Raid Level : raid5=20
sylvain> Raid Devices : 4=20

sylvain> Avail Dev Size : 1953517954 (931.51 GiB 1000.20 GB)=20
sylvain> Array Size : 2930276352 (2794.53 GiB 3000.60 GB)=20
sylvain> Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)=20
sylvain> Data Offset : 2048 sectors=20
sylvain> Super Offset : 8 sectors=20
sylvain> Unused Space : before=3D1968 sectors, after=3D1953507504 secto=
rs=20
sylvain> State : clean=20
sylvain> Device UUID : 44002aad:d3e17729:a93854eb:4139972e=20

sylvain> Internal Bitmap : 8 sectors from superblock=20
sylvain> Update Time : Sat Dec 27 22:08:22 2014=20
sylvain> Checksum : 6f692876 - correct=20
sylvain> Events : 167456=20

sylvain> Layout : left-symmetric=20
sylvain> Chunk Size : 512K=20

sylvain> Device Role : Active device 1=20
sylvain> Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R'=
 =3D=3D replacing)=20
sylvain> /dev/sde1:=20
sylvain> Magic : a92b4efc=20
sylvain> Version : 1.2=20
sylvain> Feature Map : 0x9=20
sylvain> Array UUID : 2a1440cd:762a90fb:e3bd2f4d:617acb0e=20
sylvain> Name : le-bohec:2 (local to host le-bohec)=20
sylvain> Creation Time : Tue Apr 9 17:56:19 2013=20
sylvain> Raid Level : raid5=20
sylvain> Raid Devices : 4=20

sylvain> Avail Dev Size : 4294963199 (2048.00 GiB 2199.02 GB)=20
sylvain> Array Size : 2930276352 (2794.53 GiB 3000.60 GB)=20
sylvain> Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)=20
sylvain> Data Offset : 2048 sectors=20
sylvain> Super Offset : 8 sectors=20
sylvain> Unused Space : before=3D1960 sectors, after=3D2341445631 secto=
rs=20
sylvain> State : clean=20
sylvain> Device UUID : 0ebce28d:1a792d55:76a86538:12cc94dd=20

sylvain> Internal Bitmap : 8 sectors from superblock=20
sylvain> Update Time : Sat Dec 27 22:08:34 2014=20
sylvain> Bad Block Log : 512 entries available at offset 72 sectors - b=
ad blocks present.=20
sylvain> Checksum : 3801cfa - correct=20
sylvain> Events : 167456=20

sylvain> Layout : left-symmetric=20
sylvain> Chunk Size : 512K=20

sylvain> Device Role : spare=20
sylvain> Array State : A.A. ('A' =3D=3D active, '.' =3D=3D missing, 'R'=
 =3D=3D replacing)=20


sylvain> Could you help me to re-assemble safely the raid array?=20

sylvain> Thank's in advance=20
sylvain> Best Regards=20
sylvain> Sylvain Depuille (always in trouble).=20

sylvain> ----- Mail original -----=20
sylvain> De: "John Stoffel" <john@stoffel.org>=20
sylvain> =C3=80: "Sylvain Depuille" <sylvain.depuille@laposte.net>=20
sylvain> Cc: "John Stoffel" <john@stoffel.org>=20
sylvain> Envoy=C3=A9: Mardi 30 D=C3=A9cembre 2014 22:07:04=20
sylvain> Objet: Re: Re: Re : Re: Big trouble during reassemble a Raid5=20


Sylvain> I'm front of the pc! The Pass1 of The ddrescue is Not=20
Sylvain> finished! Sorry for The false News!=20

sylvain> No problem. Let it finish before you make any other attempts t=
o=20
sylvain> re-assemble the array.=20

Sylvain> Of the 5 pass tale the same Time, the command Will finish in 2=
0 or 24 jours.=20

Sylvain> Thank's in advance=20
Sylvain> Best Regards=20


Sylvain> Envoy=C3=A9 depuis un telephone portable=20

>>> Le 29 d=C3=A9c. 2014 =C3=A0 21:36, John Stoffel <john@stoffel.org> =
a =C3=A9crit :=20
>>>=20
>>>=20
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
>>>=20
>>> Sylvain,=20
>>>=20
>>> Always glad to help here. I'm going to try and understand what you=20
>>> wrote and do my best to reply.=20
>>>=20
>>> Is the 1Tb disk the bad disk? And if you re-insert it and re-start=20
>>> the RAID5 array, you only have some minor lost files? If so, I woul=
d=20
>>> probably just copy all the data off the RAID5 onto the single 3Tb d=
isk=20
>>> as a quick and dirty backup, then I'd use 'dd_rescue' to copy the b=
ad=20
>>> 1Tb disk onto the new 2Tb disk.=20
>>>=20
>>> All you would have to do is make a partition on the 2tb disk which =
is=20
>>> the same size (or a little bigger) than the partition on the 1tb di=
sk,=20
>>> then copy the partition over like this:=20
>>>=20
>>> ddrescue /dev/sd[BAD DISK LETTER HERE]1 /dev/sd[2TB disk letter]1 \=
=20
>>> /tmp/rescue.log=20
>>>=20
>>> So say the bad disk is sdc, and the good 2tb is sdf, you would do:=20
>>>=20
>>> ddrescue /dev/sdc1 /dev/sdf1 /tmp/rescue.log=20
>>>=20
>>> and let it go. Then you would assemble the array using the NEW 2tb=20
>>> disk. Ideally you would remove the bad 1tb disk from the system whe=
n=20
>>> trying to do this.=20
>>>=20
>>> But you really do need send us the output of the following commands=
:=20
>>>=20
>>> cat /proc/mdstat=20
>>> cat /proc/partitions=20
>>> mdadm --detail /dev/md#=20
>>>=20
>>> do the above for the RADI5 array.=20
>>>=20
>>> mdadm --examine /dev/sd#1=20
>>>=20
>>> for each disk in the RAID5 array.=20
>>>=20
>>> And we can give you better advice.=20
>>>=20
>>> Good luck!=20
>>>=20
>>>=20
sylvain> ---------------------------------- Sylvain Depuille=20
sylvain> sylvain.depuille@laposte.net ----- Mail d'origine ----- De:=20
sylvain> John Stoffel <john@stoffel.org> =C3=80: sylvain depuille=20
sylvain> <sylvain.depuille@laposte.net> Cc: linux-raid@vger.kernel.org=20
sylvain> Envoy=C3=A9: Mon, 29 Dec 2014 19:32:04 +0100 (CET) Objet: Re: =
Big=20
sylvain> trouble during reassemble a Raid5=20
>>>=20
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
>>>=20
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
>>>=20
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
>>>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
