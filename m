From: Thomas Heilberg <theilberg42@gmail.com>
Subject: Re: Raid 5 rebuild with only 2 spare devices
Date: Sat, 12 Feb 2011 19:30:57 +0100
Message-ID: <AANLkTi=UxgH1nWyeCWjiHJtLCqiQx6iNtN0HJ9uCyADT@mail.gmail.com>
References: <4D542872.3090102@gmail.com>
	<4D544586.4010506@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D544586.4010506@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2011/2/10 John Robinson <john.robinson@anonymous.org.uk>:

> Those loop devices are now trashed since you didn't re-create the array with
> exactly the parameters with which it was initially created. Your settings
> make me think the array was created with an older version of mdadm; the
> defaults for metadata version and chunk size changed a little while ago.
> Anyway, if you're trying again, you should specify -e 0.90 -c 64. While
> you're at it, add --assume-clean to avoid any rebuild, which in your case
> may in fact destroy good data (though the array's parity would end up
> consistent). Or if as you noted in your other reply you're going to have to
> wait 15 hours before trying anything, maybe wait until The Boss[1] makes a
> more intelligent suggestion than I can; he usually posts at times that
> appear to be overnight to me but are presumably sensible times of day for
> him.

It worked! Although I am not quite sure why.
This is what I did:


root@backup-server:/media# mdadm -Cv /dev/md2 -e 0.90 -c 64
--assume-clean -n3 -l5 /dev/loop[012]
mdadm: layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: /dev/loop0 appears to be part of a raid array:
    level=raid5 devices=3 ctime=Thu Nov 19 21:09:37 2009
mdadm: layout defaults to left-symmetric
mdadm: /dev/loop1 appears to be part of a raid array:
    level=raid5 devices=3 ctime=Thu Nov 19 21:09:37 2009
mdadm: layout defaults to left-symmetric
mdadm: /dev/loop2 appears to be part of a raid array:
    level=raid5 devices=3 ctime=Thu Nov 19 21:09:37 2009
mdadm: size set to 1463481216K
Continue creating array? y
mdadm: array /dev/md2 started.

root@backup-server:/media# mdadm -D /dev/md2
/dev/md2:
        Version : 0.90
  Creation Time : Sat Feb 12 18:25:55 2011
     Raid Level : raid5
     Array Size : 2926962432 (2791.37 GiB 2997.21 GB)
  Used Dev Size : 1463481216 (1395.68 GiB 1498.60 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Sat Feb 12 18:25:55 2011
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : b5a7fcfb:b98b8cb8:41761e78:ef14cd93 (local to host
backup-server)
         Events : 0.1

    Number   Major   Minor   RaidDevice State
       0       7        0        0      active sync   /dev/loop0
       1       7        1        1      active sync   /dev/loop1
       2       7        2        2      active sync   /dev/loop2
root@backup-server:/media# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md2 : active (auto-read-only) raid5 loop2[2] loop1[1] loop0[0]
      2926962432 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
unused devices: <none>

After that pvscan found my LVM:

root@backup-server:/media# pvscan
  PV /dev/md2    VG server   lvm2 [2,73 TiB / 86,37 GiB free]
root@backup-server:/media# vgscan
  Reading all physical volumes.  This may take a while...
  Found volume group "server" using metadata type lvm2
root@backup-server:/media# lvs
  LV        VG     Attr   LSize   Origin Snap%  Move Log Copy%  Convert
  daten     server -wi---   2,58t
  gentoo    server -wi---  20,00g
  home      server -wi---  20,00g
  root      server -wi---  25,00g

root@backup-server:/media# vgchange -ay
  4 logical volume(s) in volume group "server" now active

Then of course I checked all filesystems with e2fsck and it appears
that all my data is ok. I'm so happy thank you both for the help. :)

But there is one thing I don't understand. I did that recreating act 2
times. The first time it didn't work and I had to restore the
raid-partitions from my backup(this time onto a btrfs partition in the
hope I could use its snapshot feature) and then it worked. Is it
possible that the order of the devices is important for the recreate
process?
I mean mdadm -C... /dev/loop1 /dev/loop0 /dev/loop2 instead of the
normal order? Because I did that by mistake(or to be more precise I
"mounted" the second image into loop0)

This would be important to me because, then I could just directly
recreate my raid and wouldn't need to copy 2,2TB over LAN.

Anyway thank you again for the help.

Thomas
