From: "Calvin Webster" <cwebster@ec.rr.com>
Subject: RE: RAID5: Fixing or Recovering Faulty Disk
Date: Fri, 28 Jun 2002 22:08:40 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <CPEAKNIMKMJOCFPEOBGACEILCFAA.cwebster@ec.rr.com>
References: <NDBBIAKEEKGGEIKCBKNACEPFDAAA.kc130iseo@coastalnet.com>
Reply-To: <cwebster@ec.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <NDBBIAKEEKGGEIKCBKNACEPFDAAA.kc130iseo@coastalnet.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Okay, I'll answer myself then.

I'm sure someone will come up with a better way once I post this.

The goal was to recover from the apparent failure of /dev/sdc1 that occurred
while restoring to the newly created 9-disk array, and to get the array back
in its original configuration.

I managed to accomplish this by taking a series of logical steps that are
outlined below. I was emboldened to do this because I still had the backups
I made prior to adding the new disks.

---------------------------------------------------------------

## After device fails, spare is silently pressed into service
## and reconstruction of parity begins
## When done, spare takes place of "raid-disk" number ([2]) that failed

---------------------------------------------------------------
[root@winggear root]# cat /proc/mdstat
Personalities : [raid5]
read_ahead 1024 sectors
md0 : active raid5 sdh1[7] sdg1[6] sdf1[5] sde1[4] sdd1[3] sdi1[2] sdb1[1]
sda1[0]
      123771648 blocks level 5, 128k chunk, algorithm 0 [8/8] [UUUUUUUU]


unused devices: <none>
---------------------------------------------------------------

## Re-write partition table on "failed" device to erase md
## superblock (with faulty flag)
## I can't find any tools to reset this flag manually, only to set it.

---------------------------------------------------------------
[root@winggear root]# fdisk /dev/sdc

Command (m for help): p

Disk /dev/sdc (Sun disk label): 19 heads, 248 sectors, 7506 cylinders
Units = cylinders of 4712 * 512 bytes

   Device Flag    Start       End    Blocks   Id  System
/dev/sdc1             1      7506  17681780   fd  Linux raid autodetect
/dev/sdc3             0      7506  17684136    5  Whole disk

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
---------------------------------------------------------------

## Add formerly failed device back into array
## It now becomes "spare-disk"

---------------------------------------------------------------
[root@winggear root]# mdadm /dev/md0 -a /dev/sdc1
mdadm: hot added /dev/sdc1
[root@winggear root]# cat /proc/mdstat
Personalities : [raid5]
read_ahead 1024 sectors
md0 : active raid5 sdc1[8] sdh1[7] sdg1[6] sdf1[5] sde1[4] sdd1[3]
sdi1[2] sdb1[
1] sda1[0]
      123771648 blocks level 5, 128k chunk, algorithm 0 [8/8] [UUUUUUUU]


unused devices: <none>
---------------------------------------------------------------

## Set "faulty" flag on sdi1, forcing "spare-disk" into service
## Reconstruction of parity begins on new "spare-disk" (formerly
## raid-disk 2, the apparently "failed" disk)
## However, spare disk retains its raid-disk number ([8])

---------------------------------------------------------------
[root@winggear root]# mdadm /dev/md0 -f /dev/sdi1
mdadm: set /dev/sdi1 faulty in /dev/md0
[root@winggear root]# cat /proc/mdstat
Personalities : [raid5]
read_ahead 1024 sectors
md0 : active raid5 sdc1[8] sdh1[7] sdg1[6] sdf1[5] sde1[4] sdd1[3]
sdi1[2](F) sd
b1[1] sda1[0]
      123771648 blocks level 5, 128k chunk, algorithm 0 [8/7] [UU_UUUUU]

      [>....................]  recovery =  0.0% (7536/17681664)
finish=116.2min
speed=2512K/sec
unused devices: <none>
---------------------------------------------------------------

## Manually "kick" the new "faulty" drive (former spare sdi1) from
## the array.
## Note that it is no longer listed as a raid device.
## We'll wait until the reconstruction of parity is done before
## re-writing the partition table, just in-case...

---------------------------------------------------------------
[root@winggear root]# mdadm /dev/md0 -r /dev/sdi1
mdadm: hot removed /dev/sdi1

[root@winggear root]# cat /proc/mdstat
Personalities : [raid5]
read_ahead 1024 sectors
md0 : active raid5 sdc1[8] sdh1[7] sdg1[6] sdf1[5] sde1[4] sdd1[3]
sdb1[1] sda1[
0]
      123771648 blocks level 5, 128k chunk, algorithm 0 [8/7] [UU_UUUUU]

      [>....................]  recovery =  0.7% (127536/17681664)
finish=139.1mi
n speed=2101K/sec
unused devices: <none>
---------------------------------------------------------------

## Now that we have sdc1 back in the array, let's run fsck with "badblock"
## checking to fix any minor inconsistencies and mark bad blocks
## This takes a few hours on our UltraSparc IIi

----------------------------------------------------------------------------
[root@winggear root]# e2fsck -c /dev/md0
e2fsck 1.23, 15-Aug-2001 for EXT2 FS 0.5b, 95/08/09
Checking for bad blocks (read-only test): done
Pass 1: Checking inodes, blocks, and sizes
Inode 15105025 is in use, but has dtime set.  Fix<y>? yes
...
Inode 15105088 is in use, but has dtime set.  Fix<y>? yes

yyPass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Inode 15105025 (...) has a bad mode (0157306).
Clear<y>? yes
...
Inode 15105088 (...) has a bad mode (0157306).
Clear<y>? yes

Pass 5: Checking group summary information

ARCHIVE: ***** FILE SYSTEM WAS MODIFIED *****
ARCHIVE: 70316/15482880 files (0.2% non-contiguous), 9814872/30942912
blocks
----------------------------------------------------------------------------

## When done, we can see that all is well and sdc1 is back in its original
## position in the array. Strangely, it is still listed last (from right
## to left) in the device list, but has the correct "raid-disk" number.
## The next time this RAID is restarted it will list correctly.

----------------------------------------------------------------------------
[root@winggear root]# cat /proc/mdstat
Personalities : [raid5]
read_ahead 1024 sectors
md0 : active raid5 sdc1[2] sdh1[7] sdg1[6] sdf1[5] sde1[4] sdd1[3]
sdb1[1] sda1[0]
      123771648 blocks level 5, 128k chunk, algorithm 0 [8/8] [UUUUUUUU]


unused devices: <none>
----------------------------------------------------------------------------

## I restart just to be sure there will be no surprises later
## Call me over-cautious.

----------------------------------------------------------------------------
[root@winggear root]# init 6
----------------------------------------------------------------------------

## Now to get the "real" spare back where it belongs so we can relax

## Ensure the RAID is unencumbered by stopping services and unmounting
## filesystems that use the "md" device.

----------------------------------------------------------------------------
[root@winggear root]# umount /home/ftp/pub/redhat/redhat-7.2/disc1
[root@winggear root]# umount /home/ftp/pub/redhat/redhat-7.2/disc2
[root@winggear root]# umount /home/httpd/html/SysAdmin-PerlJournal
[root@winggear root]# umount /home/ftp/pub/redhat/redhat-7.3/disc1
[root@winggear root]# umount /home/ftp/pub/redhat/redhat-7.3/disc2
[root@winggear root]# umount /home/ftp/pub/redhat/redhat-7.3/disc3
[root@winggear root]# umount /home/ftp/pub/redhat/redhat-7.3/docs
[root@winggear root]# umount /home/ftp/pub/redhat/redhat-7.3/srpm1
[root@winggear root]# umount /home/ftp/pub/redhat/redhat-7.3/srpm2
[root@winggear root]# umount /usr/local/archive

[root@winggear root]# df -k
Filesystem           1k-blocks      Used Available Use% Mounted on
/dev/hda5              1008952    149804    807896  16% /
/dev/hda2             25134948  11769720  12088428  50% /home
/dev/hda1             25134948   2299120  21559028  10% /usr
/dev/hda4             25136164  18782932   5076372  79% /var

[root@winggear root]# /etc/init.d/smb stop
Shutting down SMB services:                                [  OK  ]
Shutting down NMB services:                                [  OK  ]
----------------------------------------------------------------------------

## Stop and restart the RAID
## That raid-disk 2 (sdc1) being out of place was bugging me.

----------------------------------------------------------------------------
[root@winggear root]# raidstop /dev/md0
[root@winggear root]# raidstart /dev/md0
[root@winggear root]# cat /proc/mdstat
Personalities : [raid5]
read_ahead 1024 sectors
md0 : active raid5 sdh1[7] sdg1[6] sdf1[5] sde1[4] sdd1[3] sdc1[2]
sdb1[1] sda1[0]
      123771648 blocks level 5, 128k chunk, algorithm 0 [8/8] [UUUUUUUU]


unused devices: <none>
----------------------------------------------------------------------------

## Re-write partition table on the original spare (sdi1), that we manually
## "failed", to erase the md superblock (with faulty flag)

----------------------------------------------------------------------------
[root@winggear root]# fdisk /dev/sdi

Command (m for help): p

Disk /dev/sdi (Sun disk label): 19 heads, 248 sectors, 7506 cylinders
Units = cylinders of 4712 * 512 bytes

   Device Flag    Start       End    Blocks   Id  System
/dev/sdi1             1      7506  17681780   fd  Linux raid autodetect
/dev/sdi3             0      7506  17684136    5  Whole disk

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
----------------------------------------------------------------------------

## Add sdi1 back into array - becomes spare (again)

----------------------------------------------------------------------------
[root@winggear root]# mdadm /dev/md0 -a /dev/sdi1
mdadm: hot added /dev/sdi1

[root@winggear root]# cat /proc/mdstat
Personalities : [raid5]
read_ahead 1024 sectors
md0 : active raid5 sdi1[8] sdh1[7] sdg1[6] sdf1[5] sde1[4] sdd1[3]
sdc1[2] sdb1[1] sda1[0]
      123771648 blocks level 5, 128k chunk, algorithm 0 [8/8] [UUUUUUUU]


unused devices: <none>
----------------------------------------------------------------------------

## One more "fsck" just to be sure...

----------------------------------------------------------------------------
[root@winggear root]# e2fsck -c /dev/md0
e2fsck 1.23, 15-Aug-2001 for EXT2 FS 0.5b, 95/08/09
Checking for bad blocks (read-only test):     27184/ 30942912
----------------------------------------------------------------------------

## Set "monitor" mode so we get notified of any more failures or other
## significant events.
## This should be added to a script in /etc/rc.d for the appropriate
## run level.
## I put it in rc.local

----------------------------------------------------------------------------
mdadm -Fs --delay=120
----------------------------------------------------------------------------

--Cal Webster
cwebster@ec.rr.com


> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org]On Behalf Of Cal Webster
> Sent: Thursday, June 27, 2002 3:41 PM
> To: linux-raid@vger.kernel.org
> Subject: RAID5: Fixing or Recovering Faulty Disk
>
>
> I just expanded our RAID5 software raid from 6 to 9 disks. Prior to the
> change, there were no problems. There were no errors on the console or in
> the logs after installing the disks, before reconfiguring the RAID. I had
> some data corruption problems with "raidreconf" so I
> reconstructed the RAID
> from scratch. Again, no apparent errors.
>
> When I began to restore the data to the array, /dev/sdc generated some
> errors (see below) and was marked faulty, then kicked from the array. The
> hot spare was picked up and synced properly.
>
> I have now completely restored the data but I want to fix
> whatever was wrong
> with "sdc" and add it back into the array. I could find no documentation
> about how to remove the "faulty" flag or check the disk for bad blocks
> without adding it to the array. I'm assuming that it may have had some bad
> spots on the disk, but it's a little suspicious that this happened after
> upgrading the array. This particular disk drive was not physically touched
> during the hardware upgrade. All other drives appear to be operating
> normally.
>
> I'd appreciate any feedback you folks can offer.
>
> --Cal Webster
> Network Manager
> NAWCTSD ISEO CPNC
> cwebster@ec.rr.com
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

