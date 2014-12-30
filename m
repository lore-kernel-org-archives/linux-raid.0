From: sylvain.depuille@laposte.net
Subject: =?utf-8?Q?Re:_Re=C2=A0:_Re:_Big_trouble_during_reassemble_a_Raid5?=
Date: Tue, 30 Dec 2014 10:37:11 +0100 (CET)
Message-ID: <1916328338.14439065.1419932231303.JavaMail.zimbra@laposte.net>
References: <2105542796.11263344.1419768937013.JavaMail.zimbra@laposte.net> <938521225.11264152.1419768981146.JavaMail.zimbra@laposte.net> <21665.40484.909891.197506@quad.stoffel.home> <164935924.13594562.1419881845418.JavaMail.zimbra@laposte.net> <21665.47943.879001.195325@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21665.47943.879001.195325@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi John,

I'm sorry! I'm French and my English is poor!
Yesterday, i wrote the mail on a tablett, but my mail's provider doesn'=
t offer plain text option on mobile site :-(

I'm back on a PC under Linux :-) (not crash this one, but not on the sa=
me site, connected by ssh to the broke system).
=46or the history, i have installed PC of many friends under Linux (no =
more Virus problem and Windows Blue Screen).

Yesterday, i have try to you explain what is the history of the issue.
The Raid was fully operational before i change the disk sde by a 3TB di=
sk to grow the Raid, by changing all disks of the raid.=20
But when i have do the re-assemble the disk sdc goes burny :-(

I have keep the old sde 1TB disk in state.

The result of your asked command :

 cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]=20
md2 : inactive sdc1[2](S) sdd1[3](S) sde1[4](S) sdb1[5](S)
      5077760089 blocks super 1.2

major minor  #blocks  name

   8        0  125034840 sda
   8        1     131072 sda1
   8        2   62914560 sda2
   8        3   61865984 sda3
   8       32  976762584 sdc
   8       33  976760001 sdc1
   8       48  976762584 sdd
   8       49  976760001 sdd1
   8       16  976762584 sdb
   8       17  976761560 sdb1
   8       64 2930266584 sde
   8       65 2147482623 sde1

mdadm --detail /dev/md2
/dev/md2:
        Version : 1.2
     Raid Level : raid0
  Total Devices : 4
    Persistence : Superblock is persistent

          State : inactive

           Name : le-bohec:2  (local to host le-bohec)
           UUID : 2a1440cd:762a90fb:e3bd2f4d:617acb0e
         Events : 167456

    Number   Major   Minor   RaidDevice

       -       8       17        -        /dev/sdb1
       -       8       33        -        /dev/sdc1
       -       8       49        -        /dev/sdd1
       -       8       65        -        /dev/sde1


mdadm -E /dev/sd[bcde]1
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 2a1440cd:762a90fb:e3bd2f4d:617acb0e
           Name : le-bohec:2  (local to host le-bohec)
  Creation Time : Tue Apr  9 17:56:19 2013
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953521072 (931.51 GiB 1000.20 GB)
     Array Size : 2930276352 (2794.53 GiB 3000.60 GB)
  Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D1960 sectors, after=3D3504 sectors
          State : clean
    Device UUID : 8506e09c:b87a44ed:7b4ee314:777ce89c

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Dec 27 22:08:34 2014
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : bad62d22 - correct
         Events : 167456

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : A.A. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 2a1440cd:762a90fb:e3bd2f4d:617acb0e
           Name : le-bohec:2  (local to host le-bohec)
  Creation Time : Tue Apr  9 17:56:19 2013
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953517954 (931.51 GiB 1000.20 GB)
     Array Size : 2930276352 (2794.53 GiB 3000.60 GB)
  Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D1968 sectors, after=3D386 sectors
          State : clean
    Device UUID : 44002aad:d3e17729:a93854eb:4139972e

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Dec 27 22:08:22 2014
       Checksum : 6f69285d - correct
         Events : 167431

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 2a1440cd:762a90fb:e3bd2f4d:617acb0e
           Name : le-bohec:2  (local to host le-bohec)
  Creation Time : Tue Apr  9 17:56:19 2013
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953517954 (931.51 GiB 1000.20 GB)
     Array Size : 2930276352 (2794.53 GiB 3000.60 GB)
  Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D1968 sectors, after=3D386 sectors
          State : clean
    Device UUID : 5cff6f7f:ea6b89b6:28e4e8b3:7a2b5a7f

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Dec 27 22:08:34 2014
       Checksum : e81a4f63 - correct
         Events : 167456

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : A.A. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x9
     Array UUID : 2a1440cd:762a90fb:e3bd2f4d:617acb0e
           Name : le-bohec:2  (local to host le-bohec)
  Creation Time : Tue Apr  9 17:56:19 2013
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 4294963199 (2048.00 GiB 2199.02 GB)
     Array Size : 2930276352 (2794.53 GiB 3000.60 GB)
  Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D1960 sectors, after=3D2341445631 sectors
          State : clean
    Device UUID : 0ebce28d:1a792d55:76a86538:12cc94dd

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Dec 27 22:08:34 2014
  Bad Block Log : 512 entries available at offset 72 sectors - bad bloc=
ks present.
       Checksum : 3801cfa - correct
         Events : 167456

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : A.A. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)


Now, i have installed ddrescue on the system, and i go to my friends to=
 add the 2TB disk in the tower, and launch the command.

Many thank's for your help and your patience.
Best Regards
Sylvain Depuille

----- Mail original -----=20
De: "John Stoffel" <john@stoffel.org>=20
=C3=80: "sylvain depuille" <sylvain.depuille@laposte.net>=20
Cc: "John Stoffel" <john@stoffel.org>, linux-raid@vger.kernel.org=20
Envoy=C3=A9: Lundi 29 D=C3=A9cembre 2014 21:36:23=20
Objet: Re: Re : Re: Big trouble during reassemble a Raid5=20


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

Sylvain,=20

Always glad to help here. I'm going to try and understand what you=20
wrote and do my best to reply.=20

Is the 1Tb disk the bad disk? And if you re-insert it and re-start=20
the RAID5 array, you only have some minor lost files? If so, I would=20
probably just copy all the data off the RAID5 onto the single 3Tb disk=20
as a quick and dirty backup, then I'd use 'dd_rescue' to copy the bad=20
1Tb disk onto the new 2Tb disk.=20

All you would have to do is make a partition on the 2tb disk which is=20
the same size (or a little bigger) than the partition on the 1tb disk,=20
then copy the partition over like this:=20

ddrescue /dev/sd[BAD DISK LETTER HERE]1 /dev/sd[2TB disk letter]1 \=20
/tmp/rescue.log=20

So say the bad disk is sdc, and the good 2tb is sdf, you would do:=20

ddrescue /dev/sdc1 /dev/sdf1 /tmp/rescue.log=20

and let it go. Then you would assemble the array using the NEW 2tb=20
disk. Ideally you would remove the bad 1tb disk from the system when=20
trying to do this.=20

But you really do need send us the output of the following commands:=20

cat /proc/mdstat=20
cat /proc/partitions=20
mdadm --detail /dev/md#=20

do the above for the RADI5 array.=20

mdadm --examine /dev/sd#1=20

for each disk in the RAID5 array.=20

And we can give you better advice.=20

Good luck!=20


sylvain> ---------------------------------- Sylvain Depuille=20
sylvain> sylvain.depuille@laposte.net ----- Mail d'origine ----- De:=20
sylvain> John Stoffel <john@stoffel.org> =C3=80: sylvain depuille=20
sylvain> <sylvain.depuille@laposte.net> Cc: linux-raid@vger.kernel.org=20
sylvain> Envoy=C3=A9: Mon, 29 Dec 2014 19:32:04 +0100 (CET) Objet: Re: =
Big=20
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
