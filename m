From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: RAID5: failing an active component during spare rebuild - arrays hangs
Date: Sun, 5 Jun 2011 22:41:55 +0300
Message-ID: <BANLkTinwr9UE_B+MSXfbE2nAv0wLrTvhXg@mail.gmail.com>
References: <BANLkTikkeoCsr3-UBSPEDrYwh4jGSn=MaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTikkeoCsr3-UBSPEDrYwh4jGSn=MaA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everybody,
I am testing a scenario, in which I create a RAID5 with three devices:
/dev/sd{a,b,c}. Since I don't supply --force to mdadm during creation,
it treats the array as degraded and starts rebuilding the sdc as a
spare. This is as documented.

Then I do --fail on /dev/sda. I understand that at this point my data
is gone, but I think should still be able to tear down the array.

Sometimes I see that /dev/sda is kicked from the array as faulty, and
/dev/sdc is also removed and marked as a spare. Then I am able to tear
down the array.

But sometimes, it looks like the system hits some kind of a deadlock.
mdadm --detail produces:

=A0=A0=A0 Update Time : Sun Jun=A0 5 21:54:34 2011
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : active, FAILED
=A0Active Devices : 1
Working Devices : 2
=A0Failed Devices : 1
=A0 Spare Devices : 1

=A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
=A0=A0=A0=A0 Chunk Size : 512K

=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : ubuntu:zvp_1123
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : 48a15fb6:b6410bb9:a2ca173e:009203=
2c
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 67

=A0=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 faulty spare rebuilding=A0=A0 /dev/sda
=A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 16=A0=A0=A0=A0=
=A0=A0=A0 1=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdb
=A0=A0=A0=A0=A0=A0 3=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 32=A0=A0=A0=A0=
=A0=A0=A0 2=A0=A0=A0=A0=A0 spare rebuilding=A0=A0 /dev/sdc

So the faulty device and the spare are not kicked out of the array. At
this point I am unable to do anything with the array:

root@ubuntu:~# sudo mdadm --stop /dev/md1123
mdadm: failed to stop array /dev/md1123: Device or resource busy
Perhaps a running process, mounted filesystem or active volume group?
root@ubuntu:~# sudo mdadm /dev/md1123 --remove /dev/sda
mdadm: hot remove failed for /dev/sda: Device or resource busy
root@ubuntu:~# sudo mdadm /dev/md1123 --remove /dev/sdb
mdadm: hot remove failed for /dev/sdb: Device or resource busy
root@ubuntu:~# sudo mdadm /dev/md1123 --remove /dev/sdc
mdadm: hot remove failed for /dev/sdc: Device or resource busy

This is happening on ubuntu-natty, with mdadm - v3.1.4 - 31st August 20=
10.
Looking at some code in mdadm/Detail.c, it looks like /dev/sda has
been marked only as MD_DISK_FAULTY, but has not yet been kicked out of
the array. The "spare" and "rebuilding" prints also result from that.

Same thing also happens (sometimes) when I manually initiate resync
(by writing 'repair' to 'sync_action'), and later manually failing one
of the devices. Then I also saw messages like this in the syslog:
Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350454] INFO: task
md1123_resync:7993 blocked for more than 120 seconds.
Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350552] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350644] md1123_resync=A0=A0 D
0000000000000000=A0=A0=A0=A0 0=A0 7993=A0=A0=A0=A0=A0 2 0x00000004
Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350647]=A0 ffff8800b56b1cd0
0000000000000046 ffff8800b56b1fd8 ffff8800b56b0000
Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350649]=A0 0000000000013d00
ffff880036c09a98 ffff8800b56b1fd8 0000000000013d00
Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350652]=A0 ffff8800b7f1adc0
ffff880036c096e0 ffff8800b56b1cb0 ffff880036c56610
Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350654] Call Trace:
Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350657]=A0 [<ffffffff81492885>]
md_do_sync+0xb45/0xc90
Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350660]=A0 [<ffffffff81087940>]=
 ?
autoremove_wake_function+0x0/0x40
Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350663]=A0 [<ffffffff8107861b>]=
 ?
recalc_sigpending+0x1b/0x50
Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350665]=A0 [<ffffffff8148c516>]
md_thread+0x116/0x150
Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350667]=A0 [<ffffffff8148c400>]=
 ?
md_thread+0x0/0x150
Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350669]=A0 [<ffffffff810871f6>]
kthread+0x96/0xa0
Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350672]=A0 [<ffffffff8100cde4>]
kernel_thread_helper+0x4/0x10
Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350674]=A0 [<ffffffff81087160>]=
 ?
kthread+0x0/0xa0
Jun=A0 5 21:42:00 ubuntu kernel: [ 2280.350676]=A0 [<ffffffff8100cde0>]=
 ?
kernel_thread_helper+0x0/0x10

This is pretty easy for me to reproduce.

Basically, I would like to know what the user is expected to do when
more than one RAID5 array component fails during rebuild/resync.

Thanks,
=A0 Alex.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
