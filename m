From: =?UTF-8?B?0JjQstCw0L0g0JjRgdCw0LXQsg==?= <1@crownet.ru>
Subject: raid6 stuck at reshape
Date: Wed, 4 Nov 2015 12:53:17 +0700
Message-ID: <CAD1MkcxpYFx061bSzhTq_43tTPe_3Wz1unPP9LYRGrJJHXPnPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

1. init state:
md3 : active raid6 sdm[10] sdl[9] sdj[8] sdg[7] sdh[6] sdi[5] sdk[4]
sdf[3] sde[2] sdd[1] sdc[0]
      26328453120 blocks super 1.2 level 6, 4096k chunk, algorithm 2
[11/11] [UUUUUUUUUUU]
      bitmap: 0/22 pages [0KB], 65536KB chunk

2. mdadm /dev/md3 -a /dev/sdn
mdadm --grow /dev/md3 --raid-devices=12 --backup-file=/home/raid/md3.backup

md3 : active raid6 sdn[11] sdm[10] sdl[9] sdj[8] sdg[7] sdh[6] sdi[5]
sdk[4] sdf[3] sde[2] sdd[1] sdc[0]
      26328453120 blocks super 1.2 level 6, 4096k chunk, algorithm 2
[12/12] [UUUUUUUUUUUU]
      [>....................]  reshape =  0.0% (0/2925383680)
finish=3047274.6min speed=0K/sec
      bitmap: 0/22 pages [0KB], 65536KB chunk

# ps aux|grep md3
root      5232 _54.8_  0.0      0     0 ?        R    10:55  56:43 [md3_raid6]
root      6956 _98.4_  0.4  53904 49896 ?        RL   11:01  96:29
mdadm --grow /dev/md3 --raid-devices=12
--backup-file=/home/raid/md3.backup

# cat /sys/block/md3/md/reshape_position
81920

what can I do about it?

P.S. If I stop the array, it can no longer be assembled:
# mdadm -S /dev/md3
# mdadm -A /dev/md3
mdadm: :/dev/md3 has an active reshape - checking if critical section
needs to be restored
mdadm: Failed to restore critical section for reshape, sorry.

mdadm --assemble /dev/md3 -vv --backup-file /home/raid/md3.backup -f
mdadm: looking for devices for /dev/md3
...
mdadm: /dev/sdn is identified as a member of /dev/md3, slot 11.
mdadm: /dev/sdl is identified as a member of /dev/md3, slot 9.
mdadm: /dev/sdg is identified as a member of /dev/md3, slot 7.
mdadm: /dev/sdm is identified as a member of /dev/md3, slot 10.
mdadm: /dev/sdj is identified as a member of /dev/md3, slot 8.
mdadm: /dev/sdk is identified as a member of /dev/md3, slot 4.
mdadm: /dev/sdf is identified as a member of /dev/md3, slot 3.
mdadm: /dev/sdd is identified as a member of /dev/md3, slot 1.
mdadm: /dev/sdi is identified as a member of /dev/md3, slot 5.
mdadm: /dev/sdh is identified as a member of /dev/md3, slot 6.
mdadm: /dev/sde is identified as a member of /dev/md3, slot 2.
mdadm: /dev/sdc is identified as a member of /dev/md3, slot 0.
mdadm: :/dev/md3 has an active reshape - checking if critical section
needs to be restored
mdadm: restoring critical section
mdadm: Error restoring backup from md3.backup
mdadm: Failed to restore critical section for reshape, sorry.

# mdadm --assemble /dev/md3 -vv --invalid-backup -f
...
mdadm: :/dev/md3 has an active reshape - checking if critical section
needs to be restored
mdadm: No backup metadata on device-11
mdadm: Failed to find backup of critical section
mdadm: continuing without restoring backup
mdadm: added /dev/sdd to /dev/md3 as 1
mdadm: added /dev/sde to /dev/md3 as 2
mdadm: added /dev/sdf to /dev/md3 as 3
mdadm: added /dev/sdk to /dev/md3 as 4
mdadm: added /dev/sdi to /dev/md3 as 5
mdadm: added /dev/sdh to /dev/md3 as 6
mdadm: added /dev/sdg to /dev/md3 as 7
mdadm: added /dev/sdj to /dev/md3 as 8
mdadm: added /dev/sdl to /dev/md3 as 9
mdadm: added /dev/sdm to /dev/md3 as 10
mdadm: added /dev/sdn to /dev/md3 as 11
mdadm: added /dev/sdc to /dev/md3 as 0
mdadm: failed to RUN_ARRAY /dev/md3: Invalid argument

I had to create array again.
After that the array is operating normally, but I still can't grow it.

P.S.S. kernel: 3.14.56
