From: Timo Boettcher <spida@gmx.net>
Subject: raid5 failed "Operation continuing on 4 devices" (out of 8)
Date: Thu, 2 Oct 2003 02:08:41 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <618309640.20031002020841@gmx.net>
Reply-To: Timo Boettcher <spida@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a raid5 that lost a drive today, taking 3 others (out of 8)
down, too. md tried to operate the raid on 4 out of 8 devices, so it's
down. I have some (very cut down, but still long) logs attached, with
my guesses at what happened. Of course, I am trying to get the array
back online.
Here is the conf:

raiddev /dev/md0
        raid-level              5
        nr-raid-disks   8
        nr-spare-disks  0
        persistent-superblock 1
        parity-algorithm        left-symmetric
        chunk-size              32
        device                  /dev/sdc5
        raid-disk       0
        device                  /dev/sdd5
        raid-disk       1
        device                  /dev/sde5
        raid-disk       2
        device                  /dev/sdf5
        raid-disk       3
        device                  /dev/sdg5
        raid-disk       4
        device                  /dev/sdh5
        raid-disk       5
        device                  /dev/sdi5
        raid-disk       6
        device                  /dev/sdj5
        raid-disk       7

When I came up ok, it used to look like:

Sep 30 20:18:54 server md: scsi/host3/bus0/target9/lun0/part5's event counter: 0000049d
Sep 30 20:18:54 server md: scsi/host3/bus0/target8/lun0/part5's event counter: 0000049d
Sep 30 20:18:54 server md: scsi/host3/bus0/target6/lun0/part5's event counter: 0000049d
Sep 30 20:18:54 server md: scsi/host3/bus0/target5/lun0/part5's event counter: 0000049d
Sep 30 20:18:54 server md: scsi/host2/bus0/target13/lun0/part5's event counter: 0000049d
Sep 30 20:18:54 server md: scsi/host2/bus0/target12/lun0/part5's event counter: 0000049d
Sep 30 20:18:54 server md: scsi/host2/bus0/target11/lun0/part5's event counter: 0000049d
Sep 30 20:18:54 server md: scsi/host2/bus0/target10/lun0/part5's event counter: 0000049d
Sep 30 20:18:54 server raid5: device scsi/host3/bus0/target9/lun0/part5 operational as raid disk 3
Sep 30 20:18:54 server raid5: device scsi/host3/bus0/target8/lun0/part5 operational as raid disk 2
Sep 30 20:18:54 server raid5: device scsi/host3/bus0/target6/lun0/part5 operational as raid disk 1
Sep 30 20:18:54 server raid5: device scsi/host3/bus0/target5/lun0/part5 operational as raid disk 0
Sep 30 20:18:54 server raid5: device scsi/host2/bus0/target13/lun0/part5 operational as raid disk 7
Sep 30 20:18:54 server raid5: device scsi/host2/bus0/target12/lun0/part5 operational as raid disk 6
Sep 30 20:18:54 server raid5: device scsi/host2/bus0/target11/lun0/part5 operational as raid disk 5
Sep 30 20:18:54 server raid5: device scsi/host2/bus0/target10/lun0/part5 operational as raid disk 4
Sep 30 20:18:54 server raid5: allocated 8523kB for md0
Sep 30 20:18:54 server raid5: raid level 5 set md0 active with 8 out of 8 devices, algorithm 2
Sep 30 20:18:54 server RAID5 conf printout:
Sep 30 20:18:54 server --- rd:8 wd:8 fd:0
Sep 30 20:18:54 server disk 0, s:0, o:1, n:0 rd:0 us:1 dev:scsi/host3/bus0/target5/lun0/part5
Sep 30 20:18:54 server disk 1, s:0, o:1, n:1 rd:1 us:1 dev:scsi/host3/bus0/target6/lun0/part5
Sep 30 20:18:54 server disk 2, s:0, o:1, n:2 rd:2 us:1 dev:scsi/host3/bus0/target8/lun0/part5
Sep 30 20:18:54 server disk 3, s:0, o:1, n:3 rd:3 us:1 dev:scsi/host3/bus0/target9/lun0/part5
Sep 30 20:18:54 server disk 4, s:0, o:1, n:4 rd:4 us:1 dev:scsi/host2/bus0/target10/lun0/part5
Sep 30 20:18:54 server disk 5, s:0, o:1, n:5 rd:5 us:1 dev:scsi/host2/bus0/target11/lun0/part5
Sep 30 20:18:54 server disk 6, s:0, o:1, n:6 rd:6 us:1 dev:scsi/host2/bus0/target12/lun0/part5
Sep 30 20:18:54 server disk 7, s:0, o:1, n:7 rd:7 us:1 dev:scsi/host2/bus0/target13/lun0/part5
Sep 30 20:18:54 server RAID5 conf printout:
Sep 30 20:18:54 server --- rd:8 wd:8 fd:0
Sep 30 20:18:54 server disk 0, s:0, o:1, n:0 rd:0 us:1 dev:scsi/host3/bus0/target5/lun0/part5
Sep 30 20:18:54 server disk 1, s:0, o:1, n:1 rd:1 us:1 dev:scsi/host3/bus0/target6/lun0/part5
Sep 30 20:18:54 server disk 2, s:0, o:1, n:2 rd:2 us:1 dev:scsi/host3/bus0/target8/lun0/part5
Sep 30 20:18:54 server disk 3, s:0, o:1, n:3 rd:3 us:1 dev:scsi/host3/bus0/target9/lun0/part5
Sep 30 20:18:54 server disk 4, s:0, o:1, n:4 rd:4 us:1 dev:scsi/host2/bus0/target10/lun0/part5
Sep 30 20:18:54 server disk 5, s:0, o:1, n:5 rd:5 us:1 dev:scsi/host2/bus0/target11/lun0/part5
Sep 30 20:18:54 server disk 6, s:0, o:1, n:6 rd:6 us:1 dev:scsi/host2/bus0/target12/lun0/part5
Sep 30 20:18:54 server disk 7, s:0, o:1, n:7 rd:7 us:1 dev:scsi/host2/bus0/target13/lun0/part5
Sep 30 20:18:54 server md: updating md0 RAID superblock on device

But:
Drive scsi2:A:10 fails, taking the whole cable down.

Oct  1 11:57:33 server raid5: Disk failure on scsi/host2/bus0/target10/lun0/part5, disabling device. Operation continuing on 7 devices
Oct  1 11:57:33 server md0: no spare disk to reconstruct array! -- continuing in degraded mode
Oct  1 11:57:33 server raid5: Disk failure on scsi/host2/bus0/target12/lun0/part5, disabling device. Operation continuing on 6 devices
Oct  1 11:57:33 server md0: no spare disk to reconstruct array! -- continuing in degraded mode
Oct  1 11:57:34 server raid5: Disk failure on scsi/host2/bus0/target13/lun0/part5, disabling device. Operation continuing on 5 devices
Oct  1 11:57:34 server md0: no spare disk to reconstruct array! -- continuing in degraded mode
Oct  1 11:57:46 server raid5: Disk failure on scsi/host2/bus0/target11/lun0/part5, disabling device. Operation continuing on 4 devices
Oct  1 11:57:46 server md0: no spare disk to reconstruct array! -- continuing in degraded mode


Why does it try to operate a raid5 on 6 (5, 4) out of 8 devices? That couldn't work, could it?
*poof* Here the machine goes down. Daemons are still working, but no disc-access => no login
Reboot

Oct  1 20:03:43 server md: scsi/host2/bus0/target13/lun0/part5's event counter: 000004a1
Oct  1 20:03:43 server md: scsi/host2/bus0/target12/lun0/part5's event counter: 0000049f
Oct  1 20:03:43 server md: scsi/host2/bus0/target11/lun0/part5's event counter: 000004a2
Oct  1 20:03:43 server md: scsi/host3/bus0/target9/lun0/part5's event counter: 000004a3
Oct  1 20:03:43 server md: scsi/host3/bus0/target8/lun0/part5's event counter: 000004a3
Oct  1 20:03:43 server md: scsi/host3/bus0/target6/lun0/part5's event counter: 000004a3
Oct  1 20:03:43 server md: scsi/host3/bus0/target5/lun0/part5's event counter: 000004a3
Oct  1 20:03:43 server md: scsi/host2/bus0/target10/lun0/part5's event counter: 0000049e
Oct  1 20:03:43 server md: superblock update time inconsistency -- using the most recent one
Oct  1 20:03:43 server md: freshest: scsi/host3/bus0/target9/lun0/part5
Oct  1 20:03:43 server md: kicking non-fresh scsi/host2/bus0/target13/lun0/part5 from array!
Oct  1 20:03:43 server md: unbind<scsi/host2/bus0/target13/lun0/part5,7>
Oct  1 20:03:43 server md: export_rdev(scsi/host2/bus0/target13/lun0/part5)
Oct  1 20:03:43 server md: kicking non-fresh scsi/host2/bus0/target12/lun0/part5 from array!
Oct  1 20:03:43 server md: unbind<scsi/host2/bus0/target12/lun0/part5,6>
Oct  1 20:03:43 server md: export_rdev(scsi/host2/bus0/target12/lun0/part5)
Oct  1 20:03:43 server md: kicking non-fresh scsi/host2/bus0/target10/lun0/part5 from array!
Oct  1 20:03:43 server md: unbind<scsi/host2/bus0/target10/lun0/part5,5>
Oct  1 20:03:43 server md: export_rdev(scsi/host2/bus0/target10/lun0/part5)
Oct  1 20:03:43 server md0: removing former faulty scsi/host2/bus0/target10/lun0/part5!
Oct  1 20:03:43 server md0: kicking faulty scsi/host2/bus0/target11/lun0/part5!
Oct  1 20:03:43 server md: unbind<scsi/host2/bus0/target11/lun0/part5,4>
Oct  1 20:03:43 server md: export_rdev(scsi/host2/bus0/target11/lun0/part5)
Oct  1 20:03:43 server md0: removing former faulty scsi/host2/bus0/target12/lun0/part5!
Oct  1 20:03:43 server md0: removing former faulty scsi/host2/bus0/target13/lun0/part5!
Oct  1 20:03:43 server md: md0: raid array is not clean -- starting background reconstruction
Oct  1 20:03:43 server md0: max total readahead window set to 1736k
Oct  1 20:03:43 server md0: 7 data-disks, max readahead per data-disk: 248k
Oct  1 20:03:43 server raid5: device scsi/host3/bus0/target9/lun0/part5 operational as raid disk 3
Oct  1 20:03:43 server raid5: device scsi/host3/bus0/target8/lun0/part5 operational as raid disk 2
Oct  1 20:03:43 server raid5: device scsi/host3/bus0/target6/lun0/part5 operational as raid disk 1
Oct  1 20:03:43 server raid5: device scsi/host3/bus0/target5/lun0/part5 operational as raid disk 0
Oct  1 20:03:43 server raid5: not enough operational devices for md0 (4/8 failed)
Oct  1 20:03:43 server RAID5 conf printout:
Oct  1 20:03:43 server --- rd:8 wd:4 fd:4
Oct  1 20:03:43 server disk 0, s:0, o:1, n:0 rd:0 us:1 dev:scsi/host3/bus0/target5/lun0/part5
Oct  1 20:03:43 server disk 1, s:0, o:1, n:1 rd:1 us:1 dev:scsi/host3/bus0/target6/lun0/part5
Oct  1 20:03:43 server disk 2, s:0, o:1, n:2 rd:2 us:1 dev:scsi/host3/bus0/target8/lun0/part5
Oct  1 20:03:43 server disk 3, s:0, o:1, n:3 rd:3 us:1 dev:scsi/host3/bus0/target9/lun0/part5
Oct  1 20:03:43 server disk 4, s:0, o:0, n:4 rd:4 us:1 dev:[dev 00:00]
Oct  1 20:03:43 server disk 5, s:0, o:0, n:5 rd:5 us:1 dev:[dev 00:00]
Oct  1 20:03:43 server disk 6, s:0, o:0, n:6 rd:6 us:1 dev:[dev 00:00]
Oct  1 20:03:43 server disk 7, s:0, o:0, n:7 rd:7 us:1 dev:[dev 00:00]
Oct  1 20:03:43 server raid5: failed to run raid set md0

I saw that something was wrong in the logs, and IBM DFT told me scsi2:A:10 had died from "excessive shock", so I took it out and booted up again

Oct  2 00:33:31 server md: scsi/host3/bus0/target9/lun0/part5's event counter: 000004a3
Oct  2 00:33:31 server md: scsi/host3/bus0/target8/lun0/part5's event counter: 000004a3
Oct  2 00:33:31 server md: scsi/host3/bus0/target6/lun0/part5's event counter: 000004a3
Oct  2 00:33:31 server md: scsi/host3/bus0/target5/lun0/part5's event counter: 000004a3
Oct  2 00:33:31 server md: scsi/host2/bus0/target13/lun0/part5's event counter: 000004a1
Oct  2 00:33:31 server md: scsi/host2/bus0/target12/lun0/part5's event counter: 0000049f
Oct  2 00:33:31 server md: scsi/host2/bus0/target11/lun0/part5's event counter: 000004a2
Oct  2 00:33:31 server md: superblock update time inconsistency -- using the most recent one
Oct  2 00:33:31 server md: freshest: scsi/host3/bus0/target9/lun0/part5
Oct  2 00:33:31 server md: kicking non-fresh scsi/host2/bus0/target13/lun0/part5 from array!
Oct  2 00:33:31 server md: unbind<scsi/host2/bus0/target13/lun0/part5,6>
Oct  2 00:33:31 server md: export_rdev(scsi/host2/bus0/target13/lun0/part5)
Oct  2 00:33:31 server md: kicking non-fresh scsi/host2/bus0/target12/lun0/part5 from array!
Oct  2 00:33:31 server md: unbind<scsi/host2/bus0/target12/lun0/part5,5>
Oct  2 00:33:31 server md: export_rdev(scsi/host2/bus0/target12/lun0/part5)
Oct  2 00:33:31 server md: device name has changed from sdj5 to scsi/host3/bus0/target9/lun0/part5 since last import!
Oct  2 00:33:31 server md: device name has changed from scsi/host3/bus0/target9/lun0/part5 to scsi/host3/bus0/target8/lun0/part5 since last import!
Oct  2 00:33:31 server md: device name has changed from scsi/host3/bus0/target8/lun0/part5 to scsi/host3/bus0/target6/lun0/part5 since last import!
Oct  2 00:33:31 server md: device name has changed from scsi/host3/bus0/target6/lun0/part5 to scsi/host3/bus0/target5/lun0/part5 since last import!
Oct  2 00:33:31 server md: device name has changed from scsi/host2/bus0/target12/lun0/part5 to scsi/host2/bus0/target11/lun0/part5 since last import!
Oct  2 00:33:31 server md0: removing former faulty scsi/host2/bus0/target11/lun0/part5!
Oct  2 00:33:31 server md0: kicking faulty scsi/host2/bus0/target11/lun0/part5!
Oct  2 00:33:31 server md: unbind<scsi/host2/bus0/target11/lun0/part5,4>
Oct  2 00:33:31 server md: export_rdev(scsi/host2/bus0/target11/lun0/part5)
Oct  2 00:33:31 server md0: removing former faulty scsi/host2/bus0/target13/lun0/part5!
Oct  2 00:33:31 server md0: removing former faulty scsi/host3/bus0/target5/lun0/part5!
Oct  2 00:33:31 server md: md0: raid array is not clean -- starting background reconstruction
Oct  2 00:33:31 server md0: max total readahead window set to 1736k
Oct  2 00:33:31 server md0: 7 data-disks, max readahead per data-disk: 248k
Oct  2 00:33:31 server raid5: device scsi/host3/bus0/target9/lun0/part5 operational as raid disk 3
Oct  2 00:33:31 server raid5: device scsi/host3/bus0/target8/lun0/part5 operational as raid disk 2
Oct  2 00:33:31 server raid5: device scsi/host3/bus0/target6/lun0/part5 operational as raid disk 1
Oct  2 00:33:31 server raid5: device scsi/host3/bus0/target5/lun0/part5 operational as raid disk 0
Oct  2 00:33:31 server raid5: not enough operational devices for md0 (4/8 failed)
Oct  2 00:33:31 server RAID5 conf printout:
Oct  2 00:33:31 server --- rd:8 wd:4 fd:4
Oct  2 00:33:31 server disk 0, s:0, o:1, n:0 rd:0 us:1 dev:scsi/host3/bus0/target5/lun0/part5
Oct  2 00:33:31 server disk 1, s:0, o:1, n:1 rd:1 us:1 dev:scsi/host3/bus0/target6/lun0/part5
Oct  2 00:33:31 server disk 2, s:0, o:1, n:2 rd:2 us:1 dev:scsi/host3/bus0/target8/lun0/part5
Oct  2 00:33:31 server disk 3, s:0, o:1, n:3 rd:3 us:1 dev:scsi/host3/bus0/target9/lun0/part5
Oct  2 00:33:31 server disk 4, s:0, o:0, n:4 rd:4 us:1 dev:[dev 00:00]
Oct  2 00:33:31 server disk 5, s:0, o:0, n:5 rd:5 us:1 dev:[dev 00:00]
Oct  2 00:33:31 server disk 6, s:0, o:0, n:6 rd:6 us:1 dev:[dev 00:00]
Oct  2 00:33:31 server disk 7, s:0, o:0, n:7 rd:7 us:1 dev:[dev 00:00]
Oct  2 00:33:31 server raid5: failed to run raid set md0

So what shoul I do now?
I guess the first step would be to fix my raidtab to contain real names:

raiddev /dev/md0
        raid-level              5
        nr-raid-disks   8
        nr-spare-disks  0
        persistent-superblock 1
        parity-algorithm        left-symmetric
        chunk-size              32
        device                  /dev/scsi/host3/bus0/target5/lun0/part5
        raid-disk       0
        device                  /dev/scsi/host3/bus0/target6/lun0/part5
        raid-disk       1
        device                  /dev/scsi/host3/bus0/target8/lun0/part5
        raid-disk       2
        device                  /dev/scsi/host3/bus0/target9/lun0/part5
        raid-disk       3
        device                  /dev/scsi/host3/bus0/target10/lun0/part5
        raid-disk       4
        device                  /dev/scsi/host3/bus0/target11/lun0/part5
        raid-disk       5
        device                  /dev/scsi/host3/bus0/target12/lun0/part5
        raid-disk       6
        device                  /dev/scsi/host3/bus0/target13/lun0/part5
        raid-disk       7

According to the howto I should set "the disks" (which one, all?) to
failed-disk, and then do mkraid...
How should I proceed to get that array back?

Please Help
Any help appreciated.

 Timo

