From: Jon Lewis <jlewis@lewis.org>
Subject: RE: raid5 won't resync
Date: Tue, 31 Aug 2004 16:09:35 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0408311549460.1949@web1.mmaero.com>
References: <200408311450.i7VEoH310038@watkins-home.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200408311450.i7VEoH310038@watkins-home.com>
To: linux-raid@vger.kernel.org
Cc: aaron@america.com
List-Id: linux-raid.ids

Now we've got a new problem with the raid array from last night.  We've
switched qlogic drivers to one that some people have posted is more stable
than the one we were using.  This unfortunately changed all the scsi
device names.  i.e.

abcdefg hijklmn has become
hijklmn abcdefg

I put the following in /etc/mdadm.conf:

DEVICE /dev/sd[abcdefghijklmn][1]
ARRAY /dev/md2 level=raid5 num-devices=10 UUID=532d4b61:48f5278b:4fd2e730:6dd4a608

That DEVICE line should cover all the members (under their new device
names) for the raid5 array.

then I ran:

mdadm --assemble /dev/md2 --uuid 532d4b61:48f5278b:4fd2e730:6dd4a608
or
mdadm --assemble /dev/md2 --scan

Both terminate with the same result:

mdadm: /dev/md2 assembled from 4 drives and 1 spare - not enough to start
the array.

but if I look at /proc/mdstat, it did find all 10 (actually 11) devices.

# cat /proc/mdstat
Personalities : [raid1]
read_ahead 1024 sectors
md2 : inactive sdc1[6] sdm1[10] sdf1[9] sde1[8] sdd1[7] sdg1[5] sdl1[4]
sdn1[3] sdk1[2] sdj1[1] sdi1[0]
      0 blocks
md1 : active raid1 hda1[0] hdc1[1]
      30716160 blocks [2/2] [UU]
      [>....................]  resync =  3.5% (1098392/30716160) finish=298.2min speed=1654K/sec
md0 : active raid1 sdh2[0] sda2[1]
      104320 blocks [2/2] [UU]

unused devices: <none>

I suspect it's found both the failed drive (originally sde1, now named
sdl1) and the spare that it had started, but never finished, rebuilding
on (sdg1, now sdn1).  Why is mdadm saying there are only 4 devices + 1
spare?  Is there a best way to proceed at this point to try to get this
array repaired?

----------------------------------------------------------------------
 Jon Lewis                   |  I route
 Senior Network Engineer     |  therefore you are
 Atlantic Net                |
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________
