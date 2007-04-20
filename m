From: "Rob Bray" <raid@bymeinc.com>
Subject: Raid-1 on top of multipath
Date: Fri, 20 Apr 2007 15:57:35 -0400 (EDT)
Message-ID: <2282.68.254.47.243.1177099055.squirrel@bymeinc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm attempting to do host-based mirroring with one LUN on each of two EMC
CX storage units, each with two service processors. Connection is via
Emulex LP9802, using lpfc driver, and sg.

The two LUNs (with two possible paths each) present fine as /dev/sd[a-d].
I have tried using both md-multipath and dm-multipath on separate
occasions, and made a md-raid1 device on top of them. Both work when all
paths are alive. Both work great when one path to a disk dies. Neither
work when both paths to a disk die.

md-raid1 does not deduce (or is not informed) that the entire multipath
device is dead when dm-multipath is used, and continues to hang i/o on the
raid1 device trying to access the sick dm device.

When md-raid1 is run on top of md-multipath, I get a race. I'm going to
focus on the md-raid1 on md-multpath implementation, as I feel it's more
on-topic for this group.

sda/sdb share a FC cable, and can access the same LUN through two service
processors. The same goes for sdc/sdd.


$ mdadm --create /dev/md0 --level=multipath -n2 /dev/sda /dev/sdb
mdadm: array /dev/md0 started.

$ mdadm --create /dev/md1 --level=multipath -n2 /dev/sdc /dev/sdd
mdadm: array /dev/md1 started.

$ mdadm --create /dev/md16 --level=raid1 -n2 /dev/md0 /dev/md1
mdadm: array /dev/md16 started.

$ cat /proc/mdstat
Personalities : [multipath] [raid1]
md16 : active raid1 md1[1] md0[0]
      52428672 blocks [2/2] [UU]
      [>....................]  resync =  3.3% (1756736/52428672)
finish=6.7min speed=125481K/sec

md0 : active multipath sda[0] sdb[1]
      52428736 blocks [2/2] [UU]

md1 : active multipath sdd[0] sdc[1]
      52428736 blocks [2/2] [UU]

unused devices: <none>


Failing one of the service processor paths results in a [U_] for the
multpath device, and business goes on as usual. It has to be added back in
by hand when the path is restored, whcih is expected.

Failing both of the paths (taking the FC link down) at once results in a
crazy race:

Apr 20 12:59:21 vmprog kernel: lpfc 0000:02:04.0: 0:0203 Nodev timeout on
WWPN 50:6:1:69:30:20:83:45 NPort x7a00ef Data: x8 x7 x0
Apr 20 12:59:21 vmprog kernel: lpfc 0000:02:04.0: 0:0203 Nodev timeout on
WWPN 50:6:1:61:30:20:83:45 NPort x7a01ef Data: x8 x7 x0
Apr 20 12:59:26 vmprog kernel:  rport-0:0-2: blocked FC remote port time
out: removing target and saving binding
Apr 20 12:59:26 vmprog kernel:  rport-0:0-3: blocked FC remote port time
out: removing target and saving binding
Apr 20 12:59:26 vmprog kernel:  0:0:1:0: SCSI error: return code = 0x10000
Apr 20 12:59:26 vmprog kernel: end_request: I/O error, dev sdb, sector
10998152
Apr 20 12:59:26 vmprog kernel: end_request: I/O error, dev sdb, sector
10998160
Apr 20 12:59:26 vmprog kernel: multipath: IO failure on sdb, disabling IO
path.
Apr 20 12:59:26 vmprog kernel: ^IOperation continuing on 1 IO paths.
Apr 20 12:59:26 vmprog kernel: multipath: sdb: rescheduling sector 10998168
Apr 20 12:59:26 vmprog kernel:  0:0:1:0: SCSI error: return code = 0x10000
Apr 20 12:59:26 vmprog kernel: end_request: I/O error, dev sdb, sector
104857344
Apr 20 12:59:26 vmprog kernel: multipath: sdb: rescheduling sector 104857352
Apr 20 12:59:26 vmprog kernel: MULTIPATH conf printout:
Apr 20 12:59:26 vmprog kernel:  --- wd:1 rd:2
Apr 20 12:59:26 vmprog kernel:  disk0, o:0, dev:sdb
Apr 20 12:59:26 vmprog kernel:  disk1, o:1, dev:sda
Apr 20 12:59:26 vmprog kernel: MULTIPATH conf printout:
Apr 20 12:59:26 vmprog kernel:  --- wd:1 rd:2
Apr 20 12:59:26 vmprog kernel:  disk1, o:1, dev:sda
Apr 20 12:59:26 vmprog kernel: multipath: sdb: redirecting sector 10998152
to another IO path
Apr 20 12:59:26 vmprog kernel:  0:0:0:0: rejecting I/O to dead device
Apr 20 12:59:26 vmprog kernel: multipath: only one IO path left and IO error.
Apr 20 12:59:26 vmprog kernel: multipath: sda: rescheduling sector 10998168
Apr 20 12:59:26 vmprog kernel: multipath: sdb: redirecting sector
104857344 to another IO path
Apr 20 12:59:26 vmprog kernel:  0:0:0:0: rejecting I/O to dead device
Apr 20 12:59:26 vmprog kernel: multipath: only one IO path left and IO error.
Apr 20 12:59:26 vmprog kernel: multipath: sda: rescheduling sector 104857352
Apr 20 12:59:26 vmprog kernel: multipath: sda: redirecting sector 10998152
to another IO path
Apr 20 12:59:26 vmprog kernel: multipath: sda: redirecting sector
104857344 to another IO path
Apr 20 12:59:26 vmprog kernel:  0:0:0:0: rejecting I/O to dead device
Apr 20 12:59:26 vmprog kernel: multipath: only one IO path left and IO error.
Apr 20 12:59:26 vmprog kernel: multipath: sda: rescheduling sector 104857352
Apr 20 12:59:26 vmprog kernel:  0:0:0:0: rejecting I/O to dead device
Apr 20 12:59:26 vmprog kernel: multipath: only one IO path left and IO error.
Apr 20 12:59:26 vmprog kernel: multipath: sda: rescheduling sector 10998168
Apr 20 12:59:26 vmprog kernel: multipath: sda: redirecting sector
104857344 to another IO path
Apr 20 12:59:26 vmprog kernel:  0:0:0:0: rejecting I/O to dead device
Apr 20 12:59:26 vmprog kernel: multipath: only one IO path left and IO error.
Apr 20 12:59:26 vmprog kernel: multipath: sda: rescheduling sector 104857352
Apr 20 12:59:26 vmprog kernel: multipath: sda: redirecting sector 10998152
to another IO path
Apr 20 12:59:26 vmprog kernel: multipath: sda: redirecting sector
104857344 to another IO path
Apr 20 12:59:26 vmprog kernel:  0:0:0:0: rejecting I/O to dead device
Apr 20 12:59:26 vmprog kernel: multipath: only one IO path left and IO error.
Apr 20 12:59:26 vmprog kernel: multipath: sda: rescheduling sector 104857352
Apr 20 12:59:26 vmprog kernel:  0:0:0:0: rejecting I/O to dead device
Apr 20 12:59:26 vmprog kernel: multipath: only one IO path left and IO error.
Apr 20 12:59:26 vmprog kernel: multipath: sda: rescheduling sector 10998168
Apr 20 12:59:26 vmprog kernel: multipath: sda: redirecting sector
104857344 to another IO path
..until /var runs out of space :)

$ cat /proc/mdstat
Personalities : [multipath] [raid1]
md16 : active raid1 md1[1] md0[0]
      52428672 blocks [2/2] [UU]

md0 : active multipath sdb[2](F) sda[1]
      52428736 blocks [2/1] [_U]

md1 : active multipath sdd[0] sdc[1]
      52428736 blocks [2/2] [UU]

It probably doesn't help that the /dev/sdX sg instances are torn down when
the FC link goes down. I don't claim to know how multipath would react
when all paths and related special files vanish.

For the purposes of multipath-only, this would be game-over anyway, but in
a raid1 scenario, it would be good if md16 could know that md0 is
completely failed, and that it should continue on md1.

Please let me know if any additional information is useful, or if I should
try something different.

Thanks,
Rob

