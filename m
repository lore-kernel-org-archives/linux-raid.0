From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: draft howto on making raids for surviving a disk crash
Date: Sun, 03 Feb 2008 10:53:51 -0500
Message-ID: <47A5E38F.6050603@tmr.com>
References: <20080202194131.GA7875@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080202194131.GA7875@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:
> This is intended for the linux raid howto. Please give comments.
> It is not fully ready /keld
>
> Howto prepare for a failing disk
>
> The following will describe how to prepare a system to survive
> if one disk fails. This can be important for a server which is
> intended to always run. The description is mostly aimed at
> small servers, but it can also be used for
> work stations to protect it for not losing data, and be running even =
if a=20
> disk fails. Some recommendations on larger server setup is given
> at the end of the howto.
>
> This requires some extra hardware, especially disks, and the descript=
ion=20
> will also touch how to mak the most out of the disks, be it in terms =
of
> available disk space, or input/output speed.
>
> 1. Creating of partitions
>
> We recommend creating partitions for /boot, root, swap and other file=
 systems.
> This can be done by fdisk, parted or maybe a graphical interface
> like the Mandriva/PClinuxos harddrake2.  It is recommended to use dri=
ves
> with equal sizes and performance characteristics.
>
> If we are using the 2 drives sda and sdb, then sfdisk
> may be used to make all the partitions into raid partitions:
>
>    sfdisk -c /dev/sda 1 fd
>    sfdisk -c /dev/sda 2 fd
>    sfdisk -c /dev/sda 3 fd
>    sfdisk -c /dev/sda 5 fd
>    sfdisk -c /dev/sdb 1 fd
>    sfdisk -c /dev/sdb 2 fd
>    sfdisk -c /dev/sdb 3 fd
>    sfdisk -c /dev/sdb 5 fd
>
> Using:
>
>    fdisk -l /dev/sda /dev/sdb
>
> The partition layout could then look like this:
>
> Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sda1               1          37      297171   fd  Linux raid au=
todetect
> /dev/sda2              38        1132     8795587+  fd  Linux raid au=
todetect
> /dev/sda3            1133        1619     3911827+  fd  Linux raid au=
todetect
> /dev/sda4            1620      121601   963755415    5  Extended
> /dev/sda5            1620      121601   963755383+  fd  Linux raid au=
todetect
>
> Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1               1          37      297171   fd  Linux raid au=
todetect
> /dev/sdb2              38        1132     8795587+  fd  Linux raid au=
todetect
> /dev/sdb3            1133        1619     3911827+  fd  Linux raid au=
todetect
> /dev/sdb4            1620      121601   963755415    5  Extended
> /dev/sdb5            1620      121601   963755383+  fd  Linux raid au=
todetect
>
>
>
> 2. Prepare for boot
>
> The system should be set up to boot from multiple devices, so that
> if one disk fails, the system can boot from another disk.
>
>  =20
NOTE: if the first hd fails some BIOS will consider the 2nd as hdc,=20
while other will use the physical location. SATA drives may also be=20
"moved," and udev may apply interesting and unintuitive names for the=20
devices in these cases. Use of the "UID" notation to identify raid arra=
y=20
members is therefore desirable.
> On Intel hardware, there are two common boot loaders, grub and lilo.
> Both grub and lilo can only boot off a raid1. they cannot boot off
> any other software raid device type. The reason they can boot off
> the raid1 is that hey see the raid1 as a normal disk, they only then =
use
> one of the dishs when booting. The boot stage only involves loading t=
he kernel
> with a initrd image, so not much data is needed for this. The kernel,
> the initrd and other boot files can be put in a small /boot partition=
=2E
> We recommend something like 200 MB on an ext3 raid1.
>
> Make the raid1 and ext3 filesystem:
>
>    mdadm --create /dev/md0 --chunk=3D256 -R -l 1 -n 2 /dev/sda1 /dev/=
sdb1
>    mkfs -t ext3 -f /dev/md0
>
> Make each of the disks bootable by lilo:
>
>    lilo -b /dev/sda /etc/lilo.conf1
>    lilo -b /dev/sdb /etc/lilo.conf2
>
> Make each of the disks bootable by grub
>
> (to be described)
>
> 3. The root file system
>
> The root file system can be on another raid tah the /boot partition.
>  =20
TYPO:=20
-----------------------------------------------------------------------=
--^^^
> We recommend an raid10,f2, as the root file system will mostly be rea=
ds, and
> the raid10,f2 raid type is the fastest for reads, while also sufficie=
nt=20
>  =20
TYPO: s/sufficient/sufficiently/
> fast for writes. Other relevant raid types would be raid10,o2 or raid=
1.
>
> It is recommended to use the udev file system, as this runs in RAM, a=
nd you
> thus can avoid a number of read and writes to disk.
>
> It is recommended that all file systems are mounted with the noatime =
option, this=20
> avoids writing to the filesystem inodes every time a file has been re=
ad or written.
>
> Make the raid10,f2 and ext3 filesystem:
>
>    mdadm --create /dev/md1 --chunk=3D256 -R -l 10 -n 2 -p f2 /dev/sda=
2 /dev/sdb2
>    mkfs -t ext3 -f /dev/md1
>
>
> 4. The swap file system
>
> If a disk fails, where processes are swapped to, then all these proce=
sses fail.
> This may be vital processes for the system, or vital jobs on the syst=
em. You can prevent=20
> the failing of the processes by having the swap partitions on a raid.=
 The swap area
> needed is normally relatively small compared to the overall disk spac=
e available,
> so we recommend the faster raid types over the more space economic. T=
he raid10,f2
> type seems to be the fastest here, other relevant raid types could be=
 raid10,o2 or raid1.
>
> Given that you have created a raid array, you can just make the swap =
partition directly
> on it:
> =20
>    mdadm --create /dev/md2 --chunk=3D256 -R -l 10 -n 2 -p f2 /dev/sda=
3 /dev/sdb3
>    sfdisk -c /dev/md 2 82
>    mkswap /dev/md2
>
>  =20
WARNING: some "recovery" CDs will not use raid10 as swap. This may be a=
=20
problem on small memory systems, and the swap may need to be started an=
d=20
enabled manually.
> Maybe something on /var and /tmp could go here.
>
> 5. The rest of the file systems.
>
> Other file systems can also be protected against one failing disk.
> Which technique to recommend depends on your purpose with the
> disk space. You may mix the different raid types if you have differen=
t types
> of use on the same server, eg a data base and servicing of large file=
s
> from the same server. (This is one of the advantages of software raid
> over hardware raid: you may have different types of raids on
> a disk with a software raid, where a hardware raid only may take one
> type for the whole disk.)
>
> Is disk capacity the main priority, and you have more than 2 drives,
> then raid5 is recommended. Raid5 only uses 1 drive for securing the
> data, while raid1 and raid10 use at least half the capacity.
> For example with 4 drives, raid5 provides 75 % of the total disk
> space as usable, while raid1 and raid10 at most (dependent on the num=
ber
> of copies) give a 50 % usability of the disk space. This becomes even=
 better
> for raid5 with more disks, with 10 disks you only use 10 % for securi=
ty.
>
> Is speed your main priority, then raid10,f2   raid10,o2 or raid1 woul=
d give you
> most speed during normal operation. This even works if you only have =
2 drives.
>
> Is speed with a failed disk a concern, then raid10,o2 could be the ch=
oice, as
> raid10,f2 is somewhat slower in operation, when a disk has failed.
>
>
> Examples:
>
>    mdadm --create /dev/md3 --chunk=3D256 -R -l 10 -n 2 -p f2 /dev/sda=
5 /dev/sdb5
>    mdadm --create /dev/md3 --chunk=3D256 -R -l 10 -n 2 -p o2 /dev/sd[=
ab]5
>    mdadm --create /dev/md3 --chunk=3D256 -R -l  5 -n 4       /dev/sd[=
abcd]5
>
> 6. /etc/mdadm.conf
>
> Something here on /etc/mdadm.conf. What would be safe, allowing
> a system to boot even if a disk has crashed?
>  =20

Recommend PARTITIONS by used
> 7. Recommendation for the setup of larger servers.
>
> Given a larger server setup, with more disks, it is possible to
> survive more than one disk crash. The raid6 array type can be used
> to be able to survive 2 disk crashes, at the expense of the space of =
2 disks.
> The /boot, root and swap partitions can be set up with more disks, eg=
 a=20
> /boot partition made up from a raid1 of 3 disks, and root and swap pa=
rtitons=20
> made up from raid10,f3 arrays. Given that raid6 cannot survive more t=
han the chashes
>  =20
TYPO: s/chashes/crashes/    and "failure" would be better
> of 2 disks, the system disks need not be prepared for more than 2 cra=
ches
>  =20
TYPO: s/craches/crashes/   or "disk failures"
> either, and you can use the rest of the disk IO capacity to speed up =
the system.
>  =20

--=20
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will stil=
l
  be valid when the war is over..." Otto von Bismark=20



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
