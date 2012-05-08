From: "D. Lin" <dlbulk-mllr@yahoo.com>
Subject: Re: help: re-add needed after each reboot
Date: Mon, 7 May 2012 23:41:34 -0700
Message-ID: <64ab9901e23522f72fbb035f9c15c145.squirrel@anguish>
References: <5d1b39dd26f138ed494e779218d21346.squirrel@anguish.kchang.net>
    <20120508064914.18c39f80.458732@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120508064914.18c39f80.458732@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for your help.

>
> Would it be equally accurate to say that it didn't happen when you were
> running ubunutu 11.10??  My point is that maybe the important change is
> not in the kernel.
>

My system was running 11.04 when things worked. I skipped 11.10.


> What do you have in /etc/mdadm.conf ? (or maybe /etc/mdadm/mdadm.conf)

# egrep -v '^#|^$' /etc/mdadm/mdadm.conf
DEVICE partitions
CREATE owner=root group=disk mode=0660 auto=yes
HOMEHOST <system>


> If you stop the array, then
>
>   mdadm -Asvvv
>
> what messages are generated, and what is the result?
>

root@anguish:/# mdadm --misc --stop /dev/md0
mdadm: stopped /dev/md0

[195415.073137] md0: detected capacity change from 4000789299200 to 0
[195415.073150] md: md0 stopped.
[195415.073166] md: unbind<sdc1>
[195415.092175] md: export_rdev(sdc1)
[195415.092210] md: unbind<sdd1>
[195415.092413] md: export_rdev(sdd1)
[195415.092533] md: unbind<sdb1>
[195415.104245] md: export_rdev(sdb1)


# mdadm -Asvvv
mdadm: looking for devices for further assembly
mdadm: no RAID superblock on /dev/sdd
mdadm: no RAID superblock on /dev/sdc
mdadm: no RAID superblock on /dev/sdb
mdadm: /dev/sdd1 is identified as a member of /dev/md/disc:0, slot 1.
mdadm: /dev/sdc1 is identified as a member of /dev/md/disc:0, slot 0.
mdadm: /dev/sdb1 is identified as a member of /dev/md/disc:0, slot 2.
mdadm: added /dev/sdd1 to /dev/md/disc:0 as 1
mdadm: added /dev/sdb1 to /dev/md/disc:0 as 2
mdadm: added /dev/sdc1 to /dev/md/disc:0 as 0
mdadm: /dev/md/disc:0 has been started with 3 drives.
mdadm: looking for devices for further assembly
mdadm: looking for devices for further assembly
mdadm: no recogniseable superblock on /dev/md/disc:0
mdadm: cannot open device /dev/sdd1: Device or resource busy
mdadm: cannot open device /dev/sdd: Device or resource busy
mdadm: cannot open device /dev/sdc1: Device or resource busy
mdadm: cannot open device /dev/sdc: Device or resource busy
mdadm: cannot open device /dev/sdb1: Device or resource busy
mdadm: cannot open device /dev/sdb: Device or resource busy

root@anguish:/# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md127 : active raid5 sdc1[4] sdb1[3] sdd1[2]
      3907020800 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3]
[UUU]
      bitmap: 0/15 pages [0KB], 65536KB chunk

unused devices: <none>


please note that the md device is now md127, as opposed to md0. When
2.6.38 was running, md127 was auto discovered.


Now, I reboot the system. md0 is auto discovered and degraded.

[    1.649849] md: linear personality registered for level -1
[    1.658472] md: multipath personality registered for level -4
[    1.665077] md: raid0 personality registered for level 0
[    1.669855] md: raid1 personality registered for level 1
[    1.869347] md: bind<sdd1>
[    2.157297] md: bind<sdb1>
[    2.168850] md: raid6 personality registered for level 6
[    2.168923] md: raid5 personality registered for level 5
[    2.168999] md: raid4 personality registered for level 4
[    2.352210] md: raid10 personality registered for level 10
[    2.378106] md/raid:md0: device sdb1 operational as raid disk 2
[    2.378158] md/raid:md0: device sdd1 operational as raid disk 1
[    2.378503] md/raid:md0: allocated 3228kB
[    2.378629] md/raid:md0: raid level 5 active with 2 out of 3 devices,
algorithm 2
[    2.378939] created bitmap (15 pages) for device md0
[    2.379386] md0: bitmap initialized from disk: read 1/1 pages, set 0 of
29809 bits
[    2.401485] md0: detected capacity change from 0 to 4000789299200
[    2.410364]  md0: unknown partition table


$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid5 sdb1[3] sdd1[2]
      3907020800 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2]
[_UU]
      bitmap: 7/15 pages [28KB], 65536KB chunk



