From: krause@mogli-soft.de
Subject: Re: recover short-time-power-failure of raid 5?
Date: Mon, 25 Nov 2002 10:42:14 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18GFks-0001XZ-00@config8.kundenserver.de>
References: <15841.25746.94261.22043@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15841.25746.94261.22043@notabene.cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@cse.unsw.edu.au> schrieb am 25.11.2002, 00:45:22:
> On Sunday November 24, krause@mogli-soft.de wrote:
> > hi folks!
> > 
> > i am using a small 3-disk software raid on a linux redhat 7.3 system for
> > my home directory. 
> > never had any problems since today, somehow the power cable of to two of
> > my disks dropped (a fan in the case got loose which was connected to the
> > same cable!). only some seconds later i shut down the system, switched
> > it off and reconneceted the disks. the raid device /dev/md0 was not used
> > by the time the power failure happend (i was not logged in, /dev/md0
> > only contains /home), so actually there should be no loss of data.
> > but how do i tell the system just to reuse the disks? 
> 
> 
>  mdadm -A /dev/md0 --force /dev/sda1 /dev/sdb1 /dev/sdc2
> 
> NeilBrown

hello neilbrown, 

thanks a lot for your fast response!
i tried the command as you suggested but i am not sure if it really
worked, it seems that /dev/sdc2 is not yet used (but of course i may be
wrong! ;-) )
after i ran "mdadm -A /dev/md0 --force /dev/sda1 /dev/sdb1 /dev/sdc2" i
got in my /var/log/messages:

--->8---
Nov 25 10:09:31 merlin kernel:  [events: 000000fe]
Nov 25 10:09:31 merlin kernel: md: bind<sdb1,1>
Nov 25 10:09:31 merlin kernel:  [events: 000000fe]
Nov 25 10:09:31 merlin kernel: md: bind<sda1,2>
Nov 25 10:09:31 merlin kernel: md: sda1's event counter: 000000fe
Nov 25 10:09:31 merlin kernel: md: sdb1's event counter: 000000fe
Nov 25 10:09:31 merlin kernel: md0: removing former faulty sdc2!
Nov 25 10:09:31 merlin kernel: md0: max total readahead window set to
512k
Nov 25 10:09:31 merlin kernel: md0: 2 data-disks, max readahead per
data-disk: 256k
Nov 25 10:09:31 merlin kernel: raid5: device sda1 operational as raid
disk 0
Nov 25 10:09:31 merlin kernel: raid5: device sdb1 operational as raid
disk 1
Nov 25 10:09:31 merlin kernel: raid5: md0, not all disks are operational
-- trying to recover array
Nov 25 10:09:31 merlin kernel: raid5: allocated 3291kB for md0
Nov 25 10:09:31 merlin kernel: raid5: raid level 5 set md0 active with 2
out of 3 devices, algorithm 0
Nov 25 10:09:31 merlin kernel: RAID5 conf printout:
Nov 25 10:09:31 merlin kernel:  --- rd:3 wd:2 fd:1
Nov 25 10:09:31 merlin kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
Nov 25 10:09:31 merlin kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb1
Nov 25 10:09:31 merlin kernel:  disk 2, s:0, o:0, n:2 rd:2 us:1 dev:[dev
00:00]
Nov 25 10:09:31 merlin kernel: RAID5 conf printout:
Nov 25 10:09:31 merlin kernel:  --- rd:3 wd:2 fd:1
Nov 25 10:09:31 merlin kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
Nov 25 10:09:31 merlin kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb1
Nov 25 10:09:31 merlin kernel:  disk 2, s:0, o:0, n:2 rd:2 us:1 dev:[dev
00:00]
Nov 25 10:09:31 merlin kernel: md: updating md0 RAID superblock on
device
Nov 25 10:09:31 merlin kernel: md: sda1 [events: 000000ff]<6>(write)
sda1's sb offset: 4192960
Nov 25 10:09:31 merlin kernel: md: recovery thread got woken up ...
Nov 25 10:09:31 merlin kernel: md0: no spare disk to reconstruct array!
-- continuing in degraded mode
Nov 25 10:09:31 merlin kernel: md: recovery thread finished ...
Nov 25 10:09:31 merlin kernel: md: sdb1 [events: 000000ff]<6>(write)
sdb1's sb offset: 4192832
---8<---

then i ran "raidstop /dev/md0" because i thought i did somethin wrong!
/var/log/messages said:
--->8---
Nov 25 10:09:54 merlin kernel: md: marking sb clean...
Nov 25 10:09:54 merlin kernel: md: updating md0 RAID superblock on
device
Nov 25 10:09:54 merlin kernel: md: sda1 [events: 00000100]<6>(write)
sda1's sb offset: 4192960
Nov 25 10:09:54 merlin kernel: md: sdb1 [events: 00000100]<6>(write)
sdb1's sb offset: 4192832
Nov 25 10:09:55 merlin kernel: md: md0 stopped.
Nov 25 10:09:55 merlin kernel: md: unbind<sda1,1>
Nov 25 10:09:55 merlin kernel: md: export_rdev(sda1)
Nov 25 10:09:55 merlin kernel: md: unbind<sdb1,0>
Nov 25 10:09:55 merlin kernel: md: export_rdev(sdb1)
---8<---

but then i tried another "mdadm ..." just to see if maybe it takes to
steps/runs to get back two drives, but again /var/log/messages was not
encouraging (for me):

--->8---
Nov 25 10:10:15 merlin kernel:  [events: 00000100]
Nov 25 10:10:15 merlin kernel: md: bind<sdb1,1>
Nov 25 10:10:15 merlin kernel:  [events: 00000100]
Nov 25 10:10:15 merlin kernel: md: bind<sda1,2>
Nov 25 10:10:15 merlin kernel: md: sda1's event counter: 00000100
Nov 25 10:10:15 merlin kernel: md: sdb1's event counter: 00000100
Nov 25 10:10:15 merlin kernel: md0: max total readahead window set to
512k
Nov 25 10:10:15 merlin kernel: md0: 2 data-disks, max readahead per
data-disk: 256k
Nov 25 10:10:15 merlin kernel: raid5: device sda1 operational as raid
disk 0
Nov 25 10:10:15 merlin kernel: raid5: device sdb1 operational as raid
disk 1
Nov 25 10:10:15 merlin kernel: raid5: md0, not all disks are operational
-- trying to recover array
Nov 25 10:10:15 merlin kernel: raid5: allocated 3291kB for md0
Nov 25 10:10:15 merlin kernel: raid5: raid level 5 set md0 active with 2
out of 3 devices, algorithm 0
Nov 25 10:10:15 merlin kernel: RAID5 conf printout:
Nov 25 10:10:15 merlin kernel:  --- rd:3 wd:2 fd:1
Nov 25 10:10:15 merlin kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
Nov 25 10:10:15 merlin kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb1
Nov 25 10:10:15 merlin kernel:  disk 2, s:0, o:0, n:2 rd:2 us:1 dev:[dev
00:00]
Nov 25 10:10:15 merlin kernel: RAID5 conf printout:
Nov 25 10:10:15 merlin kernel:  --- rd:3 wd:2 fd:1
Nov 25 10:10:15 merlin kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
Nov 25 10:10:15 merlin kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb1
Nov 25 10:10:15 merlin kernel:  disk 2, s:0, o:0, n:2 rd:2 us:1 dev:[dev
00:00]
Nov 25 10:10:15 merlin kernel: md: updating md0 RAID superblock on
device
Nov 25 10:10:15 merlin kernel: md: sda1 [events: 00000101]<6>(write)
sda1's sb offset: 4192960
Nov 25 10:10:15 merlin kernel: md: recovery thread got woken up ...
Nov 25 10:10:15 merlin kernel: md0: no spare disk to reconstruct array!
-- continuing in degraded mode
Nov 25 10:10:15 merlin kernel: md: recovery thread finished ...
Nov 25 10:10:15 merlin kernel: md: sdb1 [events: 00000101]<6>(write)
sdb1's sb offset: 4192832
---8<---

what about disk /dev/sdc2 ? i have tried to access /dev/sdc1 (a small
ext2 partition) and the data there was correct, so it seems that the
disk is accessable and did not got damaged by the shot power failure.

how can i get the third disk back into the raid system? or do i have to
backup all reconstructed data from the two disks and reinit the raid
from the start?

thanks again in advance!
(i hope my surely stupid questions don't bother you!)

   markus
