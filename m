From: "David F." <df7729@gmail.com>
Subject: dm-raid45?
Date: Tue, 26 Nov 2013 10:07:47 -0800
Message-ID: <CAGRSmLv9vpLRr=WdY+YJFhE9aZfGYtYbegTo=g6MUPz5z+NSww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

As a workaround to the mdadm issue with the spare drive we were going
to have them activate DMRAID but that ends up with the information
below.  Specifically something about dm-raid45 but we had to drop that
because it no longer compiles in the latest kernels and we couldn't
find an update that would.   Any ideas?  (still working on getting the
dump - the fact that tmpfs doesn't support sparse files makes having
the customer create the dump via a script we provide a bit more
involved):

ERROR: device-mapper target type "raid45" is not in the kernel
WARN: locking /var/lock/dmraid/.lock
NOTICE: skipping removable device /dev/sda
NOTICE: /dev/sdg: asr     discovering
NOTICE: /dev/sdg: ddf1    discovering
NOTICE: /dev/sdg: ddf1 metadata discovered
NOTICE: /dev/sdg: hpt37x  discovering
NOTICE: /dev/sdg: hpt45x  discovering
NOTICE: /dev/sdg: isw     discovering
NOTICE: /dev/sdg: jmicron discovering
NOTICE: /dev/sdg: lsi     discovering
NOTICE: /dev/sdg: nvidia  discovering
NOTICE: /dev/sdg: pdc     discovering
NOTICE: /dev/sdg: sil     discovering
NOTICE: /dev/sdg: via     discovering
NOTICE: /dev/sdf: asr     discovering
NOTICE: /dev/sdf: ddf1    discovering
NOTICE: /dev/sdf: ddf1 metadata discovered
NOTICE: /dev/sdf: hpt37x  discovering
NOTICE: /dev/sdf: hpt45x  discovering
NOTICE: /dev/sdf: isw     discovering
NOTICE: /dev/sdf: jmicron discovering
NOTICE: /dev/sdf: lsi     discovering
NOTICE: /dev/sdf: nvidia  discovering
NOTICE: /dev/sdf: pdc     discovering
NOTICE: /dev/sdf: sil     discovering
NOTICE: /dev/sdf: via     discovering
NOTICE: /dev/sde: asr     discovering
NOTICE: /dev/sde: ddf1    discovering
NOTICE: /dev/sde: ddf1 metadata discovered
NOTICE: /dev/sde: hpt37x  discovering
NOTICE: /dev/sde: hpt45x  discovering
NOTICE: /dev/sde: isw     discovering
NOTICE: /dev/sde: jmicron discovering
NOTICE: /dev/sde: lsi     discovering
NOTICE: /dev/sde: nvidia  discovering
NOTICE: /dev/sde: pdc     discovering
NOTICE: /dev/sde: sil     discovering
NOTICE: /dev/sde: via     discovering
NOTICE: /dev/sdd: asr     discovering
NOTICE: /dev/sdd: ddf1    discovering
NOTICE: /dev/sdd: ddf1 metadata discovered
NOTICE: /dev/sdd: hpt37x  discovering
NOTICE: /dev/sdd: hpt45x  discovering
NOTICE: /dev/sdd: isw     discovering
NOTICE: /dev/sdd: jmicron discovering
NOTICE: /dev/sdd: lsi     discovering
NOTICE: /dev/sdd: nvidia  discovering
NOTICE: /dev/sdd: pdc     discovering
NOTICE: /dev/sdd: sil     discovering
NOTICE: /dev/sdd: via     discovering
NOTICE: /dev/sdc: asr     discovering
NOTICE: /dev/sdc: ddf1    discovering
NOTICE: /dev/sdc: ddf1 metadata discovered
NOTICE: /dev/sdc: hpt37x  discovering
NOTICE: /dev/sdc: hpt45x  discovering
NOTICE: /dev/sdc: isw     discovering
NOTICE: /dev/sdc: jmicron discovering
NOTICE: /dev/sdc: lsi     discovering
NOTICE: /dev/sdc: nvidia  discovering
NOTICE: /dev/sdc: pdc     discovering
NOTICE: /dev/sdc: sil     discovering
NOTICE: /dev/sdc: via     discovering
NOTICE: /dev/sdb: asr     discovering
NOTICE: /dev/sdb: ddf1    discovering
NOTICE: /dev/sdb: hpt37x  discovering
NOTICE: /dev/sdb: hpt45x  discovering
NOTICE: /dev/sdb: isw     discovering
NOTICE: /dev/sdb: jmicron discovering
NOTICE: /dev/sdb: lsi     discovering
NOTICE: /dev/sdb: nvidia  discovering
NOTICE: /dev/sdb: pdc     discovering
NOTICE: /dev/sdb: sil     discovering
NOTICE: /dev/sdb: via     discovering
NOTICE: added /dev/sdg to RAID set ".ddf1_disks"
NOTICE: added /dev/sdf to RAID set ".ddf1_disks"
NOTICE: added /dev/sde to RAID set ".ddf1_disks"
NOTICE: added /dev/sdd to RAID set ".ddf1_disks"
NOTICE: added /dev/sdc to RAID set ".ddf1_disks"
RAID set "ddf1_MegaSR   R5 #0" was not activated
INFO: Activating GROUP raid set ".ddf1_disks"
WARN: unlocking /var/lock/dmraid/.lock

Output of dmraid --raid_devices command:
/dev/sdg: ddf1, ".ddf1_disks", GROUP, unknown, 285155328 sectors, data@ 0
/dev/sdf: ddf1, ".ddf1_disks", GROUP, ok, 285155328 sectors, data@ 0
/dev/sde: ddf1, ".ddf1_disks", GROUP, ok, 285155328 sectors, data@ 0
/dev/sdd: ddf1, ".ddf1_disks", GROUP, ok, 285155328 sectors, data@ 0
/dev/sdc: ddf1, ".ddf1_disks", GROUP, ok, 285155328 sectors, data@ 0

Output of dmraid -s -s command:
*** Group superset .ddf1_disks
--> Subset
name   : ddf1_MegaSR   R5 #0
size   : 855465984
stride : 128
type   : raid5_ls
status : ok
subsets: 0
devs   : 4
spares : 0
