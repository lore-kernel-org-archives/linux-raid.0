From: lists@ida.xs4all.nl
Subject: RAID5 bitmap intent problems
Date: Wed, 28 Dec 2005 21:43:02 +0100
Message-ID: <43B2F8D6.4020006@ida.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I was tired of those long resync periods and decided to go for the
write intent bitmap options.

Soon after installing the bitmap my system froze. On reboot the system
synced the raid device; but as soon as it was accessed the system froze
again. Reboot with an older kernel did not help since the raid array
was not started.

I recoverd by making sure the raid array was not mounted at startup.
And removing the bitmap with:
	mdadm --grow none /dev/md3.

after that everything was fine again.

I hope this report helps in fixing this eventualy,

regards,

Jorg

Here is some basic info about my system:
ida ~ # uname -a
Linux ida.dejong.info 2.6.14-gentoo-r5 #1 SMP PREEMPT Wed Dec 28 15:10:20 CET 2005 i686 AMD Athlon(tm) MP 2000+ AuthenticAMD GNU/Linux
ida ~ # mdadm --version
mdadm - v2.1 - 12 September 2005


And here is a portion of /var/log/messages:

Dec 28 20:49:16 ida kernel: md: md3: sync done.
Dec 28 20:49:16 ida kernel: RAID5 conf printout:
Dec 28 20:49:16 ida kernel:  --- rd:4 wd:4 fd:0
Dec 28 20:49:16 ida kernel:  disk 0, o:1, dev:hdk2
Dec 28 20:49:16 ida kernel:  disk 1, o:1, dev:hdg2
Dec 28 20:49:16 ida kernel:  disk 2, o:1, dev:hde2
Dec 28 20:49:16 ida kernel:  disk 3, o:1, dev:hdi2
Dec 28 20:49:21 ida kernel: md3: bitmap initialized from disk: read 10/10 pages, set 310694 bits, status: 0
Dec 28 20:49:21 ida kernel: created bitmap (152 pages) for device md3
Dec 28 20:49:37 ida kernel: scheduling while atomic: md3_raid5/0x00000001/857
Dec 28 20:49:37 ida kernel:  [<c03cb6df>] schedule+0xc9f/0xcb0
Dec 28 20:49:37 ida kernel:  [<c0120b80>] __wake_up+0x40/0x60
Dec 28 20:49:37 ida kernel:  [<c03420a6>] write_page+0x186/0x190
Dec 28 20:49:37 ida kernel:  [<c013a710>] prepare_to_wait+0x20/0x70
Dec 28 20:49:37 ida kernel:  [<c0342d6b>] bitmap_unplug+0x15b/0x290
Dec 28 20:49:37 ida kernel:  [<c013a840>] autoremove_wake_function+0x0/0x60
Dec 28 20:49:37 ida kernel:  [<c013a840>] autoremove_wake_function+0x0/0x60
Dec 28 20:49:37 ida kernel:  [<c012e6b8>] del_timer_sync+0x28/0x40
Dec 28 20:49:37 ida kernel:  [<c0330b35>] raid5d+0x55/0x2b0
Dec 28 20:49:37 ida kernel:  [<c033fa27>] md_thread+0x67/0x120
Dec 28 20:49:37 ida kernel:  [<c013a840>] autoremove_wake_function+0x0/0x60
Dec 28 20:49:37 ida kernel:  [<c013a840>] autoremove_wake_function+0x0/0x60
Dec 28 20:49:37 ida kernel:  [<c03cb73a>] preempt_schedule+0x4a/0x70
Dec 28 20:49:37 ida kernel:  [<c033f9c0>] md_thread+0x0/0x120
Dec 28 20:49:37 ida kernel:  [<c013a377>] kthread+0xb7/0xc0
Dec 28 20:49:37 ida kernel:  [<c013a2c0>] kthread+0x0/0xc0
Dec 28 20:49:37 ida kernel:  [<c0101211>] kernel_thread_helper+0x5/0x14
Dec 28 20:49:37 ida kernel: scheduling while atomic: md3_raid5/0x00000001/857
Dec 28 20:49:37 ida kernel:  [<c03cb6df>] schedule+0xc9f/0xcb0
Dec 28 20:49:37 ida kernel:  [<c016b35a>] bio_put+0x2a/0x40
Dec 28 20:49:37 ida kernel:  [<c0344890>] clone_endio+0xf0/0x120
Dec 28 20:49:37 ida kernel:  [<c03420a6>] write_page+0x186/0x190
Dec 28 20:49:37 ida kernel:  [<c013a710>] prepare_to_wait+0x20/0x70
Dec 28 20:49:37 ida kernel:  [<c0342d6b>] bitmap_unplug+0x15b/0x290
Dec 28 20:49:37 ida kernel:  [<c013a840>] autoremove_wake_function+0x0/0x60
Dec 28 20:49:37 ida kernel:  [<c013a840>] autoremove_wake_function+0x0/0x60
Dec 28 20:49:37 ida kernel:  [<c012e6b8>] del_timer_sync+0x28/0x40
Dec 28 20:49:37 ida kernel:  [<c0330b35>] raid5d+0x55/0x2b0









