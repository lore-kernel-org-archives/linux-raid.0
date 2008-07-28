From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: bug in mdadm --grow --size=max
Date: Mon, 28 Jul 2008 12:53:13 -0500
Message-ID: <cccedfc60807281053q1bc68e46r4c276a445c538e8a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Summary:

I created (on 3x 4.0G partitions) a 3-device raid5, forcing the size
to be 1/2 the actual size (approx).
I then grew the raid using --grow --size=max.
The kernel blatted errors about the bitmap.
Uh oh.



turnip:~ # mdadm --create /dev/md99 --level=raid5 --size=2000000
--raid-devices=3 --spare-devices=0 --assume-clean --metadata=1.2
/dev/sdb3 /dev/sdc3 /dev/sdd3 --bitmap=internal
mdadm: largest drive (/dev/sdb3) exceed size (2000000K) by more than 1%
Continue creating array? y
mdadm: array /dev/md99 started.
turnip:~ # mdadm --grow --size=max /dev/md99

Jul 28 12:50:43 turnip kernel: md: bind<sdb3>
Jul 28 12:50:43 turnip kernel: md: bind<sdc3>
Jul 28 12:50:43 turnip kernel: md: bind<sdd3>
Jul 28 12:50:43 turnip kernel: raid5: device sdd3 operational as raid disk 2
Jul 28 12:50:43 turnip kernel: raid5: device sdc3 operational as raid disk 1
Jul 28 12:50:43 turnip kernel: raid5: device sdb3 operational as raid disk 0
Jul 28 12:50:43 turnip kernel: raid5: allocated 3224kB for md99
Jul 28 12:50:43 turnip kernel: raid5: raid level 5 set md99 active
with 3 out of 3 devices, algorithm 2
Jul 28 12:50:43 turnip kernel: RAID5 conf printout:
Jul 28 12:50:43 turnip kernel:  --- rd:3 wd:3
Jul 28 12:50:43 turnip kernel:  disk 0, o:1, dev:sdb3
Jul 28 12:50:43 turnip kernel:  disk 1, o:1, dev:sdc3
Jul 28 12:50:43 turnip kernel:  disk 2, o:1, dev:sdd3
Jul 28 12:50:43 turnip kernel: md99: bitmap initialized from disk:
read 1/1 pages, set 15625 bits
Jul 28 12:50:43 turnip kernel: created bitmap (8 pages) for device md99
Jul 28 12:50:47 turnip kernel: md: resync of RAID array md99
Jul 28 12:50:47 turnip kernel: md: minimum _guaranteed_  speed: 1000
KB/sec/disk.
Jul 28 12:50:47 turnip kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for resync.
Jul 28 12:50:47 turnip kernel: md: using 128k window, over a total of
3903744 blocks.
Jul 28 12:50:47 turnip kernel: md99: invalid bitmap page request: 8 (> 7)
Jul 28 12:50:47 turnip syslog-ng[3022]: last message repeated 655 times


-- 
Jon
