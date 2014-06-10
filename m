From: Matthias Eble <psychotrahe@gmail.com>
Subject: md kernel thread hung in raid1_add_disk
Date: Tue, 10 Jun 2014 22:32:42 +0200
Message-ID: <CAKbOo_+414WYYfwEqRnhgdxp-GJGq0_koVaN89RvEydHZ3QZ=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

last week, we had an issue where one md raid1 kernel thread got stuck.
It blocked while adding a new disk. No I/O could complete any more;
cat /proc/mdstat hung.

Interestingly "ps" commands also hung because reading the data of one
process (cat /proc/pid/cmdline) also blocked. To me it looks like a deadlock,
where the raid1 thread got stuck while raising a barrier, and
others (for example jbd2) were waiting for the completion.

The plan was to replace the existing 2 mirror disks with 2 new ones.
The commands that led to the problem were:
  mdadm --add /dev/md/PW1_bin_01 /dev/mapper/wwn-new-disk1
  mdadm --grow /dev/md/PW1_bin_01 -n 3
    ---> let it sync
  mdadm --fail /dev/md/PW1_bin_01 /dev/mapper/wwn-old-disk-1 (dm-8)
  mdadm --remove /dev/md/PW1_bin_01 /dev/mapper/wwn-old-disk-1 (dm-8)
  mdadm --add /dev/md/PW1_bin_01 /dev/mapper/wwn-new-disk2 (dm-115)
    ---> hung

Here are some strack traces:
(the entire log is at
http://pastie.org/pastes/9277512/text?key=e4ifnuef8nbsh5ricfu7sq)

2014-06-05T09:01:59.276852+02:00 myhost kernel: md/raid1:md119: Disk
failure on dm-8, disabling device.
2014-06-05T09:01:59.276876+02:00 myhost kernel: md/raid1:md119:
Operation continuing on 2 devices.
2014-06-05T09:02:27.319939+02:00 myhost kernel: md: unbind<dm-8>
2014-06-05T09:02:27.330942+02:00 myhost kernel: md: export_rdev(dm-8)
2014-06-05T09:02:44.591804+02:00 myhost kernel: md: bind<dm-115>
2014-06-05T09:03:41.647701+02:00 myhost rsyslogd-2177: imuxsock lost
104 messages from pid 48202 due to rate-limiting
2014-06-05T09:05:23.736908+02:00 myhost kernel: INFO: task
md119_raid1:52093 blocked for more than 120 seconds.
2014-06-05T09:05:23.736928+02:00 myhost kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2014-06-05T09:05:23.736930+02:00 myhost kernel: md119_raid1   D
0000000000000007     0 52093      2 0x00000080
2014-06-05T09:05:23.736948+02:00 myhost kernel: ffff8817d790bba0
0000000000000046 ffff8817d790bb68 ffff8817d790bb64
2014-06-05T09:05:23.736953+02:00 myhost kernel: 0000000000000286
ffff88183fe71600 ffff88007d836700 0000000000000df3
2014-06-05T09:05:23.736956+02:00 myhost kernel: ffff881751477058
ffff8817d790bfd8 000000000000fb88 ffff881751477058
2014-06-05T09:05:23.736957+02:00 myhost kernel: Call Trace:
2014-06-05T09:05:23.736961+02:00 myhost kernel: [<ffffffffa02d73fd>]
raise_barrier+0x9d/0x1a0 [raid1]
2014-06-05T09:05:23.736963+02:00 myhost kernel: [<ffffffff81063310>] ?
default_wake_function+0x0/0x20
2014-06-05T09:05:23.736966+02:00 myhost kernel: [<ffffffff81092ae0>] ?
wakeme_after_rcu+0x0/0x20
2014-06-05T09:05:23.736983+02:00 myhost kernel: [<ffffffffa02d7dfc>]
raid1_add_disk+0x11c/0x1c0 [raid1]
2014-06-05T09:05:23.742128+02:00 myhost kernel: [<ffffffff8140d84b>]
md_check_recovery+0x54b/0x6c0
2014-06-05T09:05:23.742142+02:00 myhost kernel: [<ffffffffa02d878c>]
raid1d+0x4c/0x1800 [raid1]
2014-06-05T09:05:23.742144+02:00 myhost kernel: [<ffffffff8150db90>] ?
thread_return+0x4e/0x76e
2014-06-05T09:05:23.742146+02:00 myhost kernel: [<ffffffff8150ea05>] ?
schedule_timeout+0x215/0x2e0
2014-06-05T09:05:23.742150+02:00 myhost kernel: [<ffffffff81405c96>]
md_thread+0x116/0x150
2014-06-05T09:05:23.742153+02:00 myhost kernel: [<ffffffff81096ca0>] ?
autoremove_wake_function+0x0/0x40
2014-06-05T09:05:23.742154+02:00 myhost kernel: [<ffffffff81405b80>] ?
md_thread+0x0/0x150
2014-06-05T09:05:23.742155+02:00 myhost kernel: [<ffffffff81096936>]
kthread+0x96/0xa0
2014-06-05T09:05:23.742156+02:00 myhost kernel: [<ffffffff8100c0ca>]
child_rip+0xa/0x20
2014-06-05T09:05:23.742157+02:00 myhost kernel: [<ffffffff810968a0>] ?
kthread+0x0/0xa0
2014-06-05T09:05:23.742158+02:00 myhost kernel: [<ffffffff8100c0c0>] ?
child_rip+0x0/0x20

2014-06-05T09:05:23.742159+02:00 myhost kernel: INFO: task
jbd2/dm-48-8:55540 blocked for more than 120 seconds.
2014-06-05T09:05:23.742161+02:00 myhost kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2014-06-05T09:05:23.742162+02:00 myhost kernel: jbd2/dm-48-8  D
000000000000000c     0 55540      2 0x00000080
2014-06-05T09:05:23.742163+02:00 myhost kernel: ffff8816d6c6b9a0
0000000000000046 0000000000000000 ffff8830182a2e50
2014-06-05T09:05:23.742164+02:00 myhost kernel: 0000000000000286
0000000000000003 0000000000000001 0000000000000286
2014-06-05T09:05:23.742165+02:00 myhost kernel: ffff881817765ab8
ffff8816d6c6bfd8 000000000000fb88 ffff881817765ab8
2014-06-05T09:05:23.742166+02:00 myhost kernel: Call Trace:
2014-06-05T09:05:23.748008+02:00 myhost kernel: [<ffffffffa02d769a>]
wait_barrier+0x13a/0x180 [raid1]
2014-06-05T09:05:23.748043+02:00 myhost kernel: [<ffffffff81063310>] ?
default_wake_function+0x0/0x20
2014-06-05T09:05:23.748047+02:00 myhost kernel: [<ffffffffa02d9fbe>]
make_request+0x7e/0xd50 [raid1]
2014-06-05T09:05:23.748049+02:00 myhost kernel: [<ffffffffa000167d>] ?
__map_bio+0xad/0x140 [dm_mod]
2014-06-05T09:05:23.748051+02:00 myhost kernel: [<ffffffff81404235>]
md_make_request+0xd5/0x210
2014-06-05T09:05:23.748054+02:00 myhost kernel: [<ffffffff8125ce0e>]
generic_make_request+0x25e/0x530
2014-06-05T09:05:23.748056+02:00 myhost kernel: [<ffffffff8111c575>] ?
mempool_alloc_slab+0x15/0x20
2014-06-05T09:05:23.748059+02:00 myhost kernel: [<ffffffffa00f460e>] ?
jbd2_journal_file_buffer+0x4e/0x90 [jbd2]
2014-06-05T09:05:23.748061+02:00 myhost kernel: [<ffffffff8125d16d>]
submit_bio+0x8d/0x120
2014-06-05T09:05:23.748064+02:00 myhost kernel: [<ffffffff811b4cb6>]
submit_bh+0xf6/0x150
2014-06-05T09:05:23.748067+02:00 myhost kernel: [<ffffffffa00f5bc8>]
jbd2_journal_commit_transaction+0x598/0x14b0 [jbd2]
2014-06-05T09:05:23.748073+02:00 myhost kernel: [<ffffffff810096f0>] ?
__switch_to+0xd0/0x320
2014-06-05T09:05:23.748076+02:00 myhost kernel: [<ffffffff81081a5b>] ?
try_to_del_timer_sync+0x7b/0xe0
2014-06-05T09:05:23.748078+02:00 myhost kernel: [<ffffffffa00fbf38>]
kjournald2+0xb8/0x220 [jbd2]
2014-06-05T09:05:23.748080+02:00 myhost kernel: [<ffffffff81096ca0>] ?
autoremove_wake_function+0x0/0x40
2014-06-05T09:05:23.748082+02:00 myhost kernel: [<ffffffffa00fbe80>] ?
kjournald2+0x0/0x220 [jbd2]
2014-06-05T09:05:23.748084+02:00 myhost kernel: [<ffffffff81096936>]
kthread+0x96/0xa0
2014-06-05T09:05:23.748086+02:00 myhost kernel: [<ffffffff8100c0ca>]
child_rip+0xa/0x20
2014-06-05T09:05:23.748090+02:00 myhost kernel: [<ffffffff810968a0>] ?
kthread+0x0/0xa0
2014-06-05T09:05:23.748092+02:00 myhost kernel: [<ffffffff8100c0c0>] ?
child_rip+0x0/0x20


Short facts:
   * All disks are dm-mp backed FC-SAN volumes.
   * On top are multiple LVM volumes with ext4 file systems
   * Files are used by an Oracle Database (binaries and redo logs, so
it should be direct io, if that matters)
      * the system was online and operational
   * OS is Rhel6, kernel is 2.6.32-358.6.2.el6.x86_64
   * no write intent bitmap is used

Now the questions:
   * does anybody have an idea what the problem could be?
   * or some ideas what I could do to narrow down problem, or find a workaround?

Any help is appreciated.

Thanks in advance
Matthias
