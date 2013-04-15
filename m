From: Pierre Martineau <pierre.martineau@inserm.fr>
Subject: RAID5 recovering
Date: Mon, 15 Apr 2013 15:47:39 +0200
Message-ID: <516C04FB.3030604@inserm.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020501020003090709040609"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------020501020003090709040609
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

Dear Raid experts,

I have a Raid5 volume that recently crashed and I need you advices=20
before doing some irreversible action.

Let me first summarize the past and current state.

1) I had a nicely running RAID5 volume with 3 x 1 To disks (LVM on top=20
and several LVM volumes in ext3 and axt4) but volume was now a bit too=20
small and I decided to add a new 1 To disk.

2) I added a new disk and did not do anything for a couple of days (Raid=20
still running with 3 disks)

3) One of the old disk failed and was ejected from the RAID.

4) The ejected disk was not even present as /dev/sdX. I thus tested the=20
connections and the disk came back.

5) I resync the ejected disk and I was back with my original 3 disk array=
.

6) I waited 2-3 days and everything was fine. I then added the new disk=20
and resync.

7) I had now a running 4 disk RAID5 array, I created a new volume and=20
started copying on it.

8) During the week-end, 2 disks were ejected from the array, the new=20
installed one and the same than previously (step 3)

9) Again the 2 disks were not present in /dev/sdX. I thus checked again=20
the connections and the problem was a molex connector. The two ejected=20
disks were on the same molex and this explains why both were detected as=20
faulty.

Now, my list of errors as a newbie.

4) I did not save all the informations before proceeding (mdadm=20
--examine, /etc/mdadm/mdadm.conf, syslog, ...)

5) I tried to assemble the disks with
mdadm --assemble --scan
with no result

6) I thus tried and this is my big error I think !!!
mdadm --assemble /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1

I forgot in this command /dev/md0 after assemble.
Because of this /dev/sdb1 suberblock was removed and now mdadm--examine=20
/dev/sdb1 returns "No md superblock detected on /dev/sdb1"

I would like now to be more cautious. If some nice expert from the list=20
would be nice enough to tell me if the proposed method described below=20
is the right approach I will be grateful for the rest of my life :-)

7) I read the RAID wiki and the list.

8) I saved
mdadm --examine /dev/sd[bcde]1
dmesg
syslog
/etc/mdadm/mdadm.conf
fdisk -lu /dev/sd[bcde]

I put the content of this files at the end of this message (except dmesg=20
and syslog because they are very long).

9) /dev/sdd is the new disk. This is clear in the fdisk listing since it=20
is a 4K sector disk.
The normal order of the raid is thus (see mdadm --examine /dev/sd[de]1)
sdb1 sdc1 sde1 sdd1

10) Events are
/dev/sdb1: no md superblock (see 6)
/dev/sdc1: Events : 112358
/dev/sdd1: Events : 112333
/dev/sde1: Events : 112358

It seems that sdd was the first disk removed.
Presumably sdb1 is in sync since it was running with sdc1 when the sdd1=20
and sde1 were ejected from the array (see 8) but I can't be sure since I=20
stupidly erased its superblock!

11) I propose to re-create the array with the --assume-clean option,=20
then check everything using "fsck -n" and "mount -o ro"
the command would be:

mdadm --create /dev/md0 -e 0.90 --assume-clean --level=3D5 --n=3D4 \
--chunk=3D64 --size=3D976759936 /dev/sdb1 /dev/sdc1 /dev/sde1 /dev/sdd1

however, since sdd1 is not really in sync since its event count is a bit=20
lower I could also just try

mdadm --create /dev/md0 -e 0.90 --assume-clean --level=3D5 --n=3D4 \
--chunk=3D64 --size=3D976759936 /dev/sdb1 /dev/sdc1 /dev/sde1 missing

however, I'm not completely sure for sdb1 since it does not have a=20
superblock I could also try

mdadm --create /dev/md0 -e 0.90 --assume-clean --level=3D5 --n=3D4 \
--chunk=3D64 --size=3D976759936 missing /dev/sdc1 /dev/sde1 /dev/sdd1

Would you use the 4 disks as in the first command or do you think that=20
the 20 event difference is a big problem?
If it works, what it the best way to test that everything is ok?

Thanks a lot for your help.

------------------------------- /etc/mdadm/mdadm.conf=20
----------------------------------------------
# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD superblocks.
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE /dev/sd*1 /dev/sdf1 /dev/sdc1 /dev/sdd1

# auto-create devices with Debian standard permissions
CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR root

# definitions of existing MD arrays
ARRAY /dev/md0 level=3Draid5 num-devices=3D3=20
UUID=3D760291c6:73cd6884:c91d1289:ceb97d9c

# This file was auto-generated on Wed, 04 Mar 2009 17:10:18 +0100
# by mkconf $Id$

--------------------------------- mdadm --examine /dev/sd[bcde]1=20
----------------------------------------------------------
#mdadm --examine /dev/sd[bcde]1

mdadm: No md superblock detected on /dev/sdb1.

/dev/sdc1:
Magic : a92b4efc
Version : 00.90.00
UUID : 760291c6:73cd6884:c91d1289:ceb97d9c (local to host backup)
Creation Time : Wed Mar 4 17:13:19 2009
Raid Level : raid5
Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
Array Size : 2930279808 (2794.53 GiB 3000.61 GB)
Raid Devices : 4
Total Devices : 4
Preferred Minor : 0

Update Time : Thu Apr 11 03:03:18 2013
State : clean
Active Devices : 2
Working Devices : 2
Failed Devices : 2
Spare Devices : 0
Checksum : 2329d0 - correct
Events : 112358

Layout : left-symmetric
Chunk Size : 64K

Number Major Minor RaidDevice State
this 1 8 33 1 active sync /dev/sdc1

0 0 8 17 0 active sync
1 1 8 33 1 active sync /dev/sdc1
2 2 0 0 2 active sync
3 3 0 0 3 faulty removed
/dev/sdd1:
Magic : a92b4efc
Version : 00.90.00
UUID : 760291c6:73cd6884:c91d1289:ceb97d9c (local to host backup)
Creation Time : Wed Mar 4 17:13:19 2009
Raid Level : raid5
Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
Array Size : 2930279808 (2794.53 GiB 3000.61 GB)
Raid Devices : 4
Total Devices : 4
Preferred Minor : 0

Update Time : Wed Apr 10 23:52:35 2013
State : active
Active Devices : 4
Working Devices : 4
Failed Devices : 0
Spare Devices : 0
Checksum : 21461c - correct
Events : 112333

Layout : left-symmetric
Chunk Size : 64K

Number Major Minor RaidDevice State
this 3 8 49 3 active sync /dev/sdd1

0 0 8 17 0 active sync
1 1 8 33 1 active sync /dev/sdc1
2 2 8 65 2 active sync /dev/sde1
3 3 8 49 3 active sync /dev/sdd1
/dev/sde1:
Magic : a92b4efc
Version : 00.90.00
UUID : 760291c6:73cd6884:c91d1289:ceb97d9c (local to host backup)
Creation Time : Wed Mar 4 17:13:19 2009
Raid Level : raid5
Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
Array Size : 2930279808 (2794.53 GiB 3000.61 GB)
Raid Devices : 4
Total Devices : 4
Preferred Minor : 0

Update Time : Wed Apr 10 23:52:35 2013
State : active
Active Devices : 4
Working Devices : 4
Failed Devices : 0
Spare Devices : 0
Checksum : 214643 - correct
Events : 112358

Layout : left-symmetric
Chunk Size : 64K

Number Major Minor RaidDevice State
this 2 8 65 2 active sync /dev/sde1

0 0 8 17 0 active sync
1 1 8 33 1 active sync /dev/sdc1
2 2 8 65 2 active sync /dev/sde1
3 3 8 49 3 active sync /dev/sdd1

---------------------------------------------------- fdisk -lu=20
/dev/sd[bcde] -----------------------------------------------
Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00025fce

Device Boot Start End Blocks Id System
/dev/sdb1 63 1953520064 976760001 fd Linux raid autodetect

Disk /dev/sdc: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000a177b

Device Boot Start End Blocks Id System
/dev/sdc1 63 1953520064 976760001 fd Linux raid autodetect

Disk /dev/sdd: 1000.2 GB, 1000204886016 bytes
16 heads, 29 sectors/track, 4210183 cylinders, total 1953525168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x9ab6c5c9

Device Boot Start End Blocks Id System
/dev/sdd1 2048 1953522049 976760001 fd Linux raid autodetect

Disk /dev/sde: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000291d5

Device Boot Start End Blocks Id System
/dev/sde1 63 1953520064 976760001 fd Linux raid autodetect



--=20
Pierre MARTINEAU

Institut de Recherche en Canc=E9rologie de Montpellier
Inserm U896 =96 Universit=E9 Montpellier 1 =96 CRLC Val d=92Aurelle
Campus Val d=92Aurelle
208 Rue des Apothicaires
F-34298 Montpellier Cedex 5, France

Tel: +33 (0)4 67 61 37 43
Fax: +33 (0)4 67 61 37 87
E-mail:pierre.martineau@inserm.fr
E-mail:pierre.martineau@montpellier.unicancer.fr
Site internet:http://www.ircm.fr


--------------020501020003090709040609
Content-Type: text/x-vcard; charset=utf-8;
 name="pierre_martineau.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="pierre_martineau.vcf"

begin:vcard
fn:Pierre MARTINEAU
n:MARTINEAU;Pierre
org:INSERM U896;IRCM
adr:208 rue des Apothicaires;;CRLC Val d'Aurelle-Paul Lamarque;Montpellier;;34298;France
email;internet:pierre.martineau@inserm.fr
tel;work:+33 (0)4 67 61 37 43
tel;fax:+33 (0)4 67 61 37 87
x-mozilla-html:FALSE
url:http://www.ircm.fr
version:2.1
end:vcard


--------------020501020003090709040609--
