From: Mathias Mueller <raidfail@gmx.de>
Subject: Re: broken raid level 5 array caused by user error
Date: Wed, 11 Nov 2015 00:47:39 +0100
Message-ID: <ceee2de5aba3ca77efc1146e19896b90@pingofdeath.de>
References: <3c05d813e42324cdf95989784f6d7b17@pingofdeath.de>
 <56426499.8000205@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56426499.8000205@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Linux raid <linux-raid@vger.kernel.org>, linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil

> You're not providing enough information.  Show the new vs. old
> name/serial combinations, then show the --create and fsck
> command/output, one by one.

sorry, here you go:

sdb -> sde  Serial Number: JK1170YBHYV6MD
sdc -> sdf  Serial Number: JK1100YAG64A1T
sdd -> sdg  Serial Number: JK1121YAG7YDLS
sde -> sdh  Serial Number: ML0220F30PZUVD


> We know the possible order combinations:
>  sdc1 sdb1 sdd1 sde1
>  sdc1 sdd1 sdb1 sde1
>  sde1 sdb1 sdd1 sdc1
>  sde1 sdd1 sdb1 sdc1

so I used this combinations:

sdf1 sde1 sdg1 sdh1
sdf1 sdg1 sde1 sdh1
sdh1 sde1 sdg1 sdf1
sdh1 sdg1 sde1 sdf1


> For now, use data offset 2048 for all of them.

output of all eight combinations:


mdadm --create --assume-clean -l5 -n4 --chunk=64 --data-offset=2048 
--metadata=1.2 /dev/md0 /dev/sdf1 /dev/sde1 /dev/sdg1 /dev/sdh1
mdadm: /dev/sdf1 appears to contain an ext2fs file system
        size=1953513560K  mtime=Thu Jan  1 01:00:00 1970
mdadm: /dev/sdf1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Tue Nov 10 22:24:54 2015
mdadm: /dev/sde1 appears to contain an ext2fs file system
        size=1953513560K  mtime=Thu Jan  1 01:00:00 1970
mdadm: /dev/sde1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Tue Nov 10 22:24:54 2015
mdadm: /dev/sdg1 appears to contain an ext2fs file system
        size=1953512000K  mtime=Wed May 11 17:58:03 2011
mdadm: /dev/sdg1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Tue Nov 10 22:24:54 2015
mdadm: /dev/sdh1 appears to contain an ext2fs file system
        size=1953513560K  mtime=Mon Apr  8 11:04:10 2013
mdadm: /dev/sdh1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Tue Nov 10 22:24:54 2015
Continue creating array? y
mdadm: array /dev/md0 started.

fsck -n /dev/md0
fsck from util-linux 2.23.2
e2fsck 1.42.9 (28-Dec-2013)
ext2fs_open2: Bad magic number in super-block
fsck.ext2: Superblock invalid, trying backup blocks...
fsck.ext2: Bad magic number in super-block while trying to open /dev/md0

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate 
superblock:
     e2fsck -b 8193 <device>

=======================

mdadm --create --assume-clean -l5 -n4 --chunk=512 --data-offset=2048 
--metadata=1.2 /dev/md0 /dev/sdf1 /dev/sde1 /dev/sdg1 /dev/sdh1
mdadm: /dev/sdf1 appears to contain an ext2fs file system
        size=1953513560K  mtime=Thu Jan  1 01:00:00 1970
mdadm: /dev/sdf1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:29:57 2015
mdadm: /dev/sde1 appears to contain an ext2fs file system
        size=1953513560K  mtime=Thu Jan  1 01:00:00 1970
mdadm: /dev/sde1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:29:57 2015
mdadm: /dev/sdg1 appears to contain an ext2fs file system
        size=1953512000K  mtime=Wed May 11 17:58:03 2011
mdadm: /dev/sdg1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:29:57 2015
mdadm: /dev/sdh1 appears to contain an ext2fs file system
        size=1953513560K  mtime=Mon Apr  8 11:04:10 2013
mdadm: /dev/sdh1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:29:57 2015
Continue creating array? y
mdadm: array /dev/md0 started.

fsck -n /dev/md0
fsck from util-linux 2.23.2
e2fsck 1.42.9 (28-Dec-2013)
ext2fs_open2: Bad magic number in super-block
fsck.ext2: Superblock invalid, trying backup blocks...
fsck.ext2: Bad magic number in super-block while trying to open /dev/md0

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate 
superblock:
     e2fsck -b 8193 <device>


================================
================================

mdadm --create --assume-clean -l5 -n4 --chunk=64 --data-offset=2048 
--metadata=1.2 /dev/md0 /dev/sdf1 /dev/sdg1 /dev/sde1 /dev/sdh1
mdadm: /dev/sdf1 appears to contain an ext2fs file system
        size=1953513560K  mtime=Thu Jan  1 01:00:00 1970
mdadm: /dev/sdf1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:31:56 2015
mdadm: /dev/sdg1 appears to contain an ext2fs file system
        size=1953512000K  mtime=Wed May 11 17:58:03 2011
mdadm: /dev/sdg1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:31:56 2015
mdadm: /dev/sde1 appears to contain an ext2fs file system
        size=1953513560K  mtime=Thu Jan  1 01:00:00 1970
mdadm: /dev/sde1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:31:56 2015
mdadm: /dev/sdh1 appears to contain an ext2fs file system
        size=1953513560K  mtime=Mon Apr  8 11:04:10 2013
mdadm: /dev/sdh1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:31:56 2015
Continue creating array? y
mdadm: array /dev/md0 started.

fsck -n /dev/md0
fsck from util-linux 2.23.2
e2fsck 1.42.9 (28-Dec-2013)
ext2fs_open2: Bad magic number in super-block
fsck.ext2: Superblock invalid, trying backup blocks...
fsck.ext2: Bad magic number in super-block while trying to open /dev/md0

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate 
superblock:
     e2fsck -b 8193 <device>

=====================

mdadm --create --assume-clean -l5 -n4 --chunk=512 --data-offset=2048 
--metadata=1.2 /dev/md0 /dev/sdf1 /dev/sdg1 /dev/sde1 /dev/sdh1
mdadm: /dev/sdf1 appears to contain an ext2fs file system
        size=1953513560K  mtime=Thu Jan  1 01:00:00 1970
mdadm: /dev/sdf1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:34:05 2015
mdadm: /dev/sdg1 appears to contain an ext2fs file system
        size=1953512000K  mtime=Wed May 11 17:58:03 2011
mdadm: /dev/sdg1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:34:05 2015
mdadm: /dev/sde1 appears to contain an ext2fs file system
        size=1953513560K  mtime=Thu Jan  1 01:00:00 1970
mdadm: /dev/sde1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:34:05 2015
mdadm: /dev/sdh1 appears to contain an ext2fs file system
        size=1953513560K  mtime=Mon Apr  8 11:04:10 2013
mdadm: /dev/sdh1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:34:05 2015
Continue creating array? y
mdadm: array /dev/md0 started.

fsck -n /dev/md0
fsck from util-linux 2.23.2
e2fsck 1.42.9 (28-Dec-2013)
ext2fs_open2: Bad magic number in super-block
fsck.ext2: Superblock invalid, trying backup blocks...
fsck.ext2: Bad magic number in super-block while trying to open /dev/md0

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate 
superblock:
     e2fsck -b 8193 <device>


=====================
=====================

mdadm --create --assume-clean -l5 -n4 --chunk=64 --data-offset=2048 
--metadata=1.2 /dev/md0 /dev/sdh1 /dev/sde1 /dev/sdg1 /dev/sdf1
mdadm: /dev/sdh1 appears to contain an ext2fs file system
        size=1953513560K  mtime=Mon Apr  8 11:04:10 2013
mdadm: /dev/sdh1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:37:01 2015
mdadm: /dev/sde1 appears to contain an ext2fs file system
        size=1953513560K  mtime=Thu Jan  1 01:00:00 1970
mdadm: /dev/sde1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:37:01 2015
mdadm: /dev/sdg1 appears to contain an ext2fs file system
        size=1953512000K  mtime=Wed May 11 17:58:03 2011
mdadm: /dev/sdg1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:37:01 2015
mdadm: /dev/sdf1 appears to contain an ext2fs file system
        size=1953513560K  mtime=Thu Jan  1 01:00:00 1970
mdadm: /dev/sdf1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:37:01 2015
Continue creating array? y
mdadm: array /dev/md0 started.

fsck -n /dev/md0
fsck from util-linux 2.23.2
e2fsck 1.42.9 (28-Dec-2013)
ext2fs_open2: Bad magic number in super-block
fsck.ext2: Superblock invalid, trying backup blocks...
fsck.ext2: Bad magic number in super-block while trying to open /dev/md0

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate 
superblock:
     e2fsck -b 8193 <device>

=====================

mdadm --create --assume-clean -l5 -n4 --chunk=512 --data-offset=2048 
--metadata=1.2 /dev/md0 /dev/sdh1 /dev/sde1 /dev/sdg1 /dev/sdf1
mdadm: /dev/sdh1 appears to contain an ext2fs file system
        size=1953513560K  mtime=Mon Apr  8 11:04:10 2013
mdadm: /dev/sdh1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:34:59 2015
mdadm: /dev/sde1 appears to contain an ext2fs file system
        size=1953513560K  mtime=Thu Jan  1 01:00:00 1970
mdadm: /dev/sde1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:34:59 2015
mdadm: /dev/sdg1 appears to contain an ext2fs file system
        size=1953512000K  mtime=Wed May 11 17:58:03 2011
mdadm: /dev/sdg1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:34:59 2015
mdadm: /dev/sdf1 appears to contain an ext2fs file system
        size=1953513560K  mtime=Thu Jan  1 01:00:00 1970
mdadm: /dev/sdf1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:34:59 2015
Continue creating array? y
mdadm: array /dev/md0 started.

fsck -n /dev/md0
fsck from util-linux 2.23.2
e2fsck 1.42.9 (28-Dec-2013)
ext2fs_open2: Bad magic number in super-block
fsck.ext2: Superblock invalid, trying backup blocks...
fsck.ext2: Bad magic number in super-block while trying to open /dev/md0

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate 
superblock:
     e2fsck -b 8193 <device>


=====================
=====================

mdadm --create --assume-clean -l5 -n4 --chunk=64 --data-offset=2048 
--metadata=1.2 /dev/md0 /dev/sdh1 /dev/sdg1 /dev/sde1 /dev/sdf1
mdadm: /dev/sdh1 appears to contain an ext2fs file system
        size=1953513560K  mtime=Mon Apr  8 11:04:10 2013
mdadm: /dev/sdh1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:38:17 2015
mdadm: /dev/sdg1 appears to contain an ext2fs file system
        size=1953512000K  mtime=Wed May 11 17:58:03 2011
mdadm: /dev/sdg1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:38:17 2015
mdadm: /dev/sde1 appears to contain an ext2fs file system
        size=1953513560K  mtime=Thu Jan  1 01:00:00 1970
mdadm: /dev/sde1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:38:17 2015
mdadm: /dev/sdf1 appears to contain an ext2fs file system
        size=1953513560K  mtime=Thu Jan  1 01:00:00 1970
mdadm: /dev/sdf1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:38:17 2015
Continue creating array? y
mdadm: array /dev/md0 started.

fsck -n /dev/md0
fsck from util-linux 2.23.2
e2fsck 1.42.9 (28-Dec-2013)
ext2fs_open2: Bad magic number in super-block
fsck.ext2: Superblock invalid, trying backup blocks...
fsck.ext2: Bad magic number in super-block while trying to open /dev/md0

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate 
superblock:
     e2fsck -b 8193 <device>

=====================

mdadm --create --assume-clean -l5 -n4 --chunk=512 --data-offset=2048 
--metadata=1.2 /dev/md0 /dev/sdh1 /dev/sdg1 /dev/sde1 /dev/sdf1
mdadm: /dev/sdh1 appears to contain an ext2fs file system
        size=1953513560K  mtime=Mon Apr  8 11:04:10 2013
mdadm: /dev/sdh1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:39:16 2015
mdadm: /dev/sdg1 appears to contain an ext2fs file system
        size=1953512000K  mtime=Wed May 11 17:58:03 2011
mdadm: /dev/sdg1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:39:16 2015
mdadm: /dev/sde1 appears to contain an ext2fs file system
        size=1953513560K  mtime=Thu Jan  1 01:00:00 1970
mdadm: /dev/sde1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:39:16 2015
mdadm: /dev/sdf1 appears to contain an ext2fs file system
        size=1953513560K  mtime=Thu Jan  1 01:00:00 1970
mdadm: /dev/sdf1 appears to be part of a raid array:
        level=raid5 devices=4 ctime=Wed Nov 11 00:39:16 2015
Continue creating array? y
mdadm: array /dev/md0 started.

fsck -n /dev/md0
fsck from util-linux 2.23.2
e2fsck 1.42.9 (28-Dec-2013)
ext2fs_open2: Bad magic number in super-block
fsck.ext2: Superblock invalid, trying backup blocks...
fsck.ext2: Bad magic number in super-block while trying to open /dev/md0

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate 
superblock:
     e2fsck -b 8193 <device>


Thanks and best regards!

Mathias


