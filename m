From: Simon Mcnair <simonmcnair@gmail.com>
Subject: Re: Linux software RAID assistance
Date: Fri, 18 Feb 2011 09:31:09 +0000
Message-ID: <AANLkTi=420ttuWWG0vCWy00YLmZvGiM9JTF2n-oi2ebu@mail.gmail.com>
References: <4D540F6C.6050904@gmail.com>
	<20110215155315.55d35b8e@notabene.brown>
	<4D5A92F3.1090004@turmel.org>
	<4D5BD678.2050200@gmail.com>
	<4D5BE119.7000804@turmel.org>
	<4D5C0E17.3060306@gmail.com>
	<4D5C140F.9010301@turmel.org>
	<4D5C1508.3040308@gmail.com>
	<4D5C15D3.1070608@turmel.org>
	<4D5C167C.7000101@turmel.org>
	<4D5C1CF8.1020507@gmail.com>
	<4D5C1E0B.9060300@turmel.org>
	<4D5C2061.4060106@gmail.com>
	<4D5C2143.3000907@turmel.org>
	<4D5C2260.3020800@gmail.com>
	<4D5C273E.7020609@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5C273E.7020609@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

time passes.  You are eaten by a Grue.  Sheesh this is taking a long ti=
me.

simon@proxmox:~$ top

top - 09:26:19 up 20:36, 11 users,  load average: 2.46, 2.49, 2.39
Tasks: 334 total,   9 running, 325 sleeping,   0 stopped,   0 zombie
Cpu(s): 52.8%us,  9.4%sy,  0.0%ni, 35.2%id,  2.5%wa,  0.0%hi,  0.2%si, =
 0.0%st
Mem:  12299244k total, 12227584k used,    71660k free, 11042868k buffer=
s
Swap: 11534332k total,        0k used, 11534332k free,   208204k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
18896 root      20   0 12288 1072  460 S   63  0.0 431:16.55 ntfs-3g
18909 root      20   0 12288 1064  460 R   62  0.0 419:17.11 ntfs-3g
18920 root      20   0 12288 1100  492 R   62  0.0 428:17.33 ntfs-3g
 9210 root      20   0  4068  520  328 S   54  0.0 661:59.92 gzip
 9138 root      20   0  4068  524  328 R   53  0.0 647:29.07 gzip
 9247 root      20   0  4068  524  328 S   53  0.0 651:28.36 gzip
25678 root      20   0  4068  524  328 R   52  0.0 439:49.20 gzip
24957 root      20   0  4068  524  328 R   51  0.0 437:44.01 gzip
25792 root      20   0  4068  524  328 S   48  0.0 433:28.14 gzip

This is hardly touching the CPU on the box (in my opinion), any advice
on using renice ?  I've never used it before, but now seems like a
good time ?

tia
Simon

On 16 February 2011 19:36, Phil Turmel <philip@turmel.org> wrote:
> On 02/16/2011 02:15 PM, Simon McNair wrote:
>> proxmox:/home/simon# vgscan --verbose
>> =A0 =A0 Wiping cache of LVM-capable devices
>> =A0 =A0 Wiping internal VG cache
>> =A0 Reading all physical volumes. =A0This may take a while...
>> =A0 =A0 Finding all volume groups
>> =A0 =A0 Finding volume group "pve"
>> =A0 Found volume group "pve" using metadata type lvm2
>> =A0 =A0 Finding volume group "lvm-raid"
>> =A0 Found volume group "lvm-raid" using metadata type lvm2
>> proxmox:/home/simon#
>> proxmox:/home/simon# lvscan --verbose
>> =A0 =A0 Finding all logical volumes
>> =A0 ACTIVE =A0 =A0 =A0 =A0 =A0 =A0'/dev/pve/swap' [11.00 GB] inherit
>> =A0 ACTIVE =A0 =A0 =A0 =A0 =A0 =A0'/dev/pve/root' [96.00 GB] inherit
>> =A0 ACTIVE =A0 =A0 =A0 =A0 =A0 =A0'/dev/pve/data' [354.26 GB] inheri=
t
>> =A0 inactive =A0 =A0 =A0 =A0 =A0'/dev/lvm-raid/RAID' [8.19 TB] inher=
it
>>
>> proxmox:/home/simon# vgchange -ay
>> =A0 3 logical volume(s) in volume group "pve" now active
>> =A0 1 logical volume(s) in volume group "lvm-raid" now active
>
> Heh. =A0Figures.
>
>> proxmox:/home/simon# fsck.ext4 -n /dev/mapper/lvm-raid-RAID
>
> Actually, I wanted you to try with a capital N. =A0Lower case 'n' is =
similar, but not quite the same.
>
>> e2fsck 1.41.3 (12-Oct-2008)
>> fsck.ext4: No such file or directory while trying to open /dev/mappe=
r/lvm-raid-RAID
>>
>> The superblock could not be read or does not describe a correct ext2
>> filesystem. =A0If the device is valid and it really contains an ext2
>> filesystem (and not swap or ufs or something else), then the superbl=
ock
>> is corrupt, and you might try running e2fsck with an alternate super=
block:
>> =A0 =A0 e2fsck -b 8193 <device>
>>
>> proxmox:/home/simon# fsck.ext4 -n /dev/mapper/
>> control =A0 =A0 =A0 =A0 lvm--raid-RAID =A0pve-data =A0 =A0 =A0 =A0pv=
e-root =A0 =A0 =A0 =A0pve-swap
>
> Strange. =A0I guess it does that to distinguish dashes in the VG name=
 from dashes between VG and LV names.
>
>> proxmox:/home/simon# fsck.ext4 -n /dev/mapper/lvm--raid-RAID
>> e2fsck 1.41.3 (12-Oct-2008)
>> /dev/mapper/lvm--raid-RAID has unsupported feature(s): FEATURE_I31
>> e2fsck: Get a newer version of e2fsck!
>>
>> my version of e2fsck always worked before ?
>
> v1.41.14 was release 7 weeks ago. =A0But, I suspect there's corruptio=
n in the superblock. =A0Do you still have your disk images tucked away =
somewhere safe?
>
> If so, try:
>
> 1) The '-b' option to e2fsck. =A0We need to experiment with '-n -b of=
fset' to find the alternate superblock. =A0Trying 'offset' =3D to 8193,=
 16384, and 32768, per the man-page.
>
> 2) A newer e2fsprogs.
>
> Finally,
> 3) mount -r /dev/lvm-raid/RAID /mnt/whatever
>
> Phil
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
