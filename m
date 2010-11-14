From: Zoltan Szecsei <zoltans@geograph.co.za>
Subject: Confusion with setting up new RAID6 with mdadm
Date: Sun, 14 Nov 2010 17:36:38 +0200
Message-ID: <4CE00206.4000301@geograph.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
I hope this is the correct list to address this on - I've done a lot of=
=20
typing for nothing, if not :-)

I have done days of research, including reading=20
https://raid.wiki.kernel.org/index.php/Linux_Raid, but all I am doing i=
s=20
getting confused in the detail.

My goal is to set up an 8*2TB SiI3132 based RAID6 on Ubuntu 10.04LTS,=20
with LVM and ext4.
The setup will mostly hold thousands of 400MB image files, and they wil=
l=20
not be accessed regularly - they mostly just need to be online. The=20
entire space on all 8 drives can be used, and I want 1 massive=20
filesystem, when I finally mount this RAID device. No boot, root or swa=
p.

I have gone quite far with the help of the local linux group, but after=
=20
I had completed the 27 hour mdadm --create run, further tidbits were=20
thrown at me, and I am trying to get an opinion on if it is worth=20
scrapping this effort, and starting again.



Please can someone provide clarity on:

*If I have to reformat the drives and redo mdadm --create, other than=20
mdadm stop, how can I get rid of all the /dev/md* etc etc so that when =
I=20
restart this exercise, the original bad RAID does not interfere with=20
this new attempt?



*Partition alignment?
Is this relevant for modern HDs (I'm using 5900rpm Seagate 2TB drives)
None of the mdadm helps I've googled or received speak about how to=20
correctly format the drives before running mdadm --create.
All the benchmarks & performance tests I've found, do not bother to say=
=20
whether they have aligned the partitions on the HD

*What is the correct fdisk or parted method get rid of the DOS & GPT=20
flags, and create a correctly aligned partition, and should this be a=20
0xda partiton (& then I use metatdata 1.2 for mdadm)?


*Chunk size:
After reading MANY different opinions, I'm guessing staying at the=20
default chunk size is optimal? Anyone want to add to this argument?


*After partitioning the 8 drives, is this the correct sequence?
mdadm --create /dev/md0 --metadata=3D1.2 --auto=3Dmd --chunk=3D64=20
--level=3Draid6 --raid devices=3D8 /dev/sd[abcdefgh]1
mdadm --detail --scan >> /etc/mdadm.conf
mdadm --assemble /dev/md0 /dev/sd[abcdefg]1


*After this, do I mkfs ext4 first, or LVM first?

*What stride and stripe values should I use?


If you've read this far: Wow! - big thanks.
If you're going to venture some help or affirmation - BIGGER thanks! :=3D=
)

Kind regards to all,
Zoltan



This is where I am, but I'd like to get it right, so am happy to delete=
=20
& restart, if the current state is not fixable.:

**************************************************

root@gs0:/home/geograph# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]=20
[raid4] [raid10]
md_d0 : active raid6 sde1[4] sdg1[6] sdh1[7] sdc1[2] sda1[0] sdb1[1]=20
sdd1[3] sdf1[5]
       11721071616 blocks level 6, 64k chunk, algorithm 2 [8/8] [UUUUUU=
UU]

unused devices: <none>
root@gs0:/home/geograph#
**************************************************

root@gs0:/home/geograph# mdadm -E /dev/md_d0
mdadm: No md superblock detected on /dev/md_d0.

**************************************************
root@gs0:/dev# ls -la /dev/md*
brw-rw---- 1 root disk 254, 0 2010-11-13 16:41 /dev/md_d0
lrwxrwxrwx 1 root root      7 2010-11-13 16:41 /dev/md_d0p1 -> md/d0p1
lrwxrwxrwx 1 root root      7 2010-11-13 16:41 /dev/md_d0p2 -> md/d0p2
lrwxrwxrwx 1 root root      7 2010-11-13 16:41 /dev/md_d0p3 -> md/d0p3
lrwxrwxrwx 1 root root      7 2010-11-13 16:41 /dev/md_d0p4 -> md/d0p4

/dev/md:
total 0
drwxrwx---  2 root disk    140 2010-11-13 16:41 .
drwxr-xr-x 18 root root   4520 2010-11-14 11:42 ..
brw-------  1 root root 254, 0 2010-11-13 16:41 d0
brw-------  1 root root 254, 1 2010-11-13 16:41 d0p1
brw-------  1 root root 254, 2 2010-11-13 16:41 d0p2
brw-------  1 root root 254, 3 2010-11-13 16:41 d0p3
brw-------  1 root root 254, 4 2010-11-13 16:41 d0p4
root@gs0:/dev#

***********************************************
root@gs0:/home/geograph# fdisk -lu

WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util=20
fdisk doesn't support GPT. Use GNU Parted.

Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
256 heads, 63 sectors/track, 242251 cylinders, total 3907029168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/sda1              63  3907024127  1953512032+  fd  Linux raid=20
autodetect

(All 8 disks are as above)
************************************************

root@gs0:/home/geograph# parted /dev/sde
GNU Parted 2.2
Using /dev/sde
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) p
Warning: /dev/sde contains GPT signatures, indicating that it has a GPT=
=20
table.  However, it does not have a valid fake msdos partition table, a=
s=20
it should.  Perhaps it was
corrupted -- possibly by a program that doesn't understand GPT partitio=
n=20
tables.  Or perhaps you deleted the GPT table, and are now using an=20
msdos partition table.  Is this a
GPT partition table?
Yes/No? yes
Model: ATA ST32000542AS (scsi)
Disk /dev/sde: 2000GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End    Size   File system  Name                        =
 =20
=46lags
  1      17.4kB  134MB  134MB               Microsoft reserved=20
partition  msftres

(parted)

****************************************************




--=20

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Zoltan Szecsei PrGISc [PGP0031]
Geograph (Pty) Ltd.
P.O. Box 7, Muizenberg 7950, South Africa.

65 Main Road, Muizenberg 7945
Western Cape, South Africa.

34=B0 6'16.35"S 18=B028'5.62"E

Tel: +27-21-7884897  Mobile: +27-83-6004028
=46ax: +27-86-6115323     www.geograph.co.za
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D



-----
No virus found in this message.
Checked by AVG - www.avg.com
Version: 10.0.1153 / Virus Database: 424/3255 - Release Date: 11/13/10

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
