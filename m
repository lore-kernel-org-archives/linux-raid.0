From: Hans Kraus <hans@hanswkraus.com>
Subject: Weird problem: mdadm blocks
Date: Sun, 22 Dec 2013 10:01:26 +0100
Message-ID: <52B6AA66.5050502@hanswkraus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

my backup system (running backuppc) has developed a weird problem:
calls from command line "mdadm --detail /dev/mdX" block, for every
existing raid on the system, and can be only terminated with ^C. This
is true even for the newest mdadm built from git.

"cat /proc/mdstat" blocks too. All mounted raids are working (at least
ls <mountpoint> is), exept for one, md127 (the storage of backuppc).
There ls is blocking and is not terminable by ^C.

The raid structure is the following:
md2, md3, m4	raid1 for swap, /boot, /
md30		raid0 for short term storage
md10, md11, md12, md13	raid0, built from 2x 2TB or 1TB + 3TB drives
md127		raid5 built from md10, md11, md12, md13

I recently (some 12 hours ago) added md13 again and the system was
rebuilding from a degraded state. The file system on md127 is xfs. All
the physical rives are OK, at least according to smartmontools.
Webmin 1.660 reports:
CPU load averages 	16.96 (1 min) 15.04 (5 mins) 12.67 (15 mins)
CPU usage 		0% user, 1% kernel, 99% IO, 0% idle

Is there any way to diagnose the problem further? I'm reluctant to
do a reboot.

Regards, Hans
