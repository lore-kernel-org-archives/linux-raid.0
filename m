From: Rory Jaffe <rsjaffe@gmail.com>
Subject: RAID5 Shrinking array-size nearly killed the system
Date: Fri, 11 Mar 2011 20:58:09 -0800
Message-ID: <AANLkTikQ5_xm3+JKP8pR=oYO5xi6Qk1=VrSsiBkgtB6q@mail.gmail.com>
References: <AANLkTimrq904HRZfx6RpPrVNd0EJ5AkUZtytY7TqcFYv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimrq904HRZfx6RpPrVNd0EJ5AkUZtytY7TqcFYv@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Using Ubuntu 10.10 mdadm v 3.2. ext4 filesystem.=C2=A0I wanted to shrin=
k
from 6 disks to 4. I have about 2TB of files on the disks. So, I ran
$ sudo mdadm -G -n 4 /dev/md0
which gave the message:

mdadm: this change will reduce the size of the array.
=C2=A0=C2=A0 =C2=A0 =C2=A0 use --grow --array-size first to truncate ar=
ray.
=C2=A0=C2=A0 =C2=A0 =C2=A0 e.g. mdadm --grow /dev/md0 --array-size 5857=
612608

then ran
$ sudo mdadm --grow /dev/md0 --array-size 5857612608
and started testing the filesystem prior to reducing the array. I
quickly found out that the filesystem was broken. It was broken enough
that I couldn't even get access to commands, including sudo, mdadm,
reboot, and ls. I had to power down the system and restart it. There
were a number of disk errors, but managed to restart the system and it
looks like there wasn't much damage. fstab is listed after my
questions.
Questions:
1. Is there a safer way to shrink the file system prior to reducing
the number of disks in the array?
2. Is there a way of rearranging the files and directories to make the
file system shrink safer?
3. Is there something I did that caused the crash?
Thanks-Rory


# /etc/fstab: static file system information.
#
# Use 'blkid -o value -s UUID' to print the universally unique identifi=
er
# for a device; this may be used with UUID=3D as a more robust way to n=
ame
# devices that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point> =C2=A0 <type> =C2=A0<options> =C2=A0 =C2=A0=
 =C2=A0 <dump> =C2=A0<pass>
proc =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/proc =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 proc =C2=A0 =C2=A0nodev,noexec,nosuid 0 =C2=A0 =C2=A0 =C2=
=A0 0
# / was on /dev/md0 during installation
UUID=3D9a978b70-e034-4d79-9e1d-237a67b553d5 / =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 ext4
commit=3D60,errors=3Dremount-ro,usrjquota=3Daquota.user,grpjquota=3Daqu=
ota.group,jqfmt=3Dvfsv1,barrier=3D0
=C2=A00 =C2=A0 =C2=A0 =C2=A0 1
# /boot was on /dev/sdb1 during installation
UUID=3D5beb5144-6d2f-4a73-b9e9-442355d8f529 /boot =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 ext2
defaults =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 2
# swap was on /dev/sda1 during installation
UUID=3D31660a21-3f99-4ffb-81cc-501dc6ce5de7 none =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0swap =C2=A0 =C2=A0sw
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 0
# swap was on /dev/sdc1 during installation
UUID=3Df168588d-8b9e-45c3-b9ae-f90f66906616 none =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0swap =C2=A0 =C2=A0sw
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 0
# swap was on /dev/sdd1 during installation
UUID=3D05cadc48-59df-479e-b5ed-b9e9322cb905 none =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0swap =C2=A0 =C2=A0sw
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 0
# swap was on /dev/sde1 during installation
UUID=3D61fba94d-e6c5-4a58-b0cd-9d878b55b65c none =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0swap =C2=A0 =C2=A0sw
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 0
# swap was on /dev/sdf1 during installation
UUID=3D47737641-7555-4cbc-9bf6-508c9f2035bc none =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0swap =C2=A0 =C2=A0sw
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 0
# swap was on /dev/sdg1 during installation
UUID=3Dad06f3d6-a6ec-445a-bcfb-427fec72725b none =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0swap =C2=A0 =C2=A0sw
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 0
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
