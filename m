From: Javier Marcet <jmarcet@gmail.com>
Subject: Help with two momentarily failed drives out of a 4x3TB Raid 5
Date: Mon, 11 Mar 2013 00:48:35 +0100
Message-ID: <CAAnFQG9b1mUj+BJ3-_N-HjQi2w2Vv5pg4RCErXW5axp32_7T4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have been using what is my a 4x3TB Raid 5 rray for the last 8 months
without an issue but last week I got some recoverable reading errors.
Initially I forced an array check and it finished without problems but
the problem saw up again a day later. I remembered I saw a cable which
I thought I should replace the last time I had to open the server
case, but it was built into the case so I tried not to worry.

At first I tried to reassemble the array after checking all the
connections inside the case and left it overnight. It should have
finished today by noon. Instead I was greeted by a bunch of traces
like this:

20614.984915] WARNING: at drivers/md/raid5.c:352 get_active_stripe+0x6bc/0x7c0()
[20614.984916] Hardware name: To Be Filled By O.E.M.
[20614.984916] Modules linked in: mt2063 drxk cx25840 cx23885
btcx_risc videobuf_dvb tveeprom cx2341x videobuf_dma_sg r8169
videobuf_core
[20614.984920] Pid: 10125, comm: kworker/u:0 Tainted: G        W
3.7.10-himawari #1
[20614.984920] Call Trace:
[20614.984922]  [<ffffffff810b8eaa>] warn_slowpath_common+0x7a/0xb0
[20614.984923]  [<ffffffff810b8ef5>] warn_slowpath_null+0x15/0x20
[20614.984925]  [<ffffffff8163278c>] get_active_stripe+0x6bc/0x7c0
[20614.984926]  [<ffffffff810e99de>] ? __wake_up+0x4e/0x70
[20614.984928]  [<ffffffff81659ec4>] ? md_wakeup_thread+0x34/0x60
[20614.984929]  [<ffffffff810ddac6>] ? prepare_to_wait+0x56/0x90
[20614.984931]  [<ffffffff816368aa>] make_request+0x1aa/0x6f0
[20614.984932]  [<ffffffff810dd850>] ? finish_wait+0x80/0x80
[20614.984934]  [<ffffffff8165b935>] md_make_request+0x105/0x260
[20614.984935]  [<ffffffff813b0e92>] generic_make_request+0xc2/0x110
[20614.984937]  [<ffffffff81644aea>] bch_generic_make_request_hack+0x9a/0xa0
[20614.984938]  [<ffffffff81644eb3>] bch_generic_make_request+0x43/0x190
[20614.984939]  [<ffffffff816479f8>] write_dirty+0x78/0x120
[20614.984941]  [<ffffffff810d597a>] process_one_work+0x13a/0x4f0
[20614.984942]  [<ffffffff81647980>] ? read_dirty_submit+0xe0/0xe0
[20614.984944]  [<ffffffff810d73c5>] worker_thread+0x165/0x480
[20614.984946]  [<ffffffff810d7260>] ? busy_worker_rebind_fn+0x110/0x110
[20614.984947]  [<ffffffff810dd0cb>] kthread+0xbb/0xc0
[20614.984949]  [<ffffffff810dd010>] ? flush_kthread_worker+0x70/0x70
[20614.984950]  [<ffffffff8188872c>] ret_from_fork+0x7c/0xb0
[20614.984951]  [<ffffffff810dd010>] ? flush_kthread_worker+0x70/0x70
[20614.984952] ---[ end trace d2db072c18819bc0 ]---
[20614.984954] sector=8b909ff8 i=2           (null)           (null)
        (null)           (null) 1
[20614.984955] ------------[ cut here ]------------

Thinking that it could still be a loose cable, I decided to order a
case more suited to host the raid (than the server case where the
drives share space with cards and cables). Meanwhile I left the drives
in such a way I could use reliable cables for the two with faulty
cables and tried to assemble the array again.

Initially it didn't want to, and I was using mdadm --force. It started
to rebuild after a few seconds, though. To my dismay it ended the same
way. Only this time I went back through the logs and saw when was the
first back trace: http://bpaste.net/raw/82819/

Here is my raid.status: http://bpaste.net/raw/82820/

I have read all the info in
https://raid.wiki.kernel.org/index.php/RAID_Recovery#Restore_array_by_recreating_.28after_multiple_device_failure.29
and before I lose any chance of copying the data (most of it at least)
trying to forcing a complete rebuild.

I have 4.5 TB used and right now I have the filesystem mounted and I
can use it yet the kernel is spiting that same trace over and over
again. I really don't know what would be the best thing to do right
now and would appreciate any help.


--
Javier Marcet <jmarcet@gmail.com>
