From: Ferenc Wagner <wferi@niif.hu>
Subject: aoe freezes 2.6.26.6
Date: Mon, 20 Oct 2008 19:12:26 +0200
Message-ID: <871vyb9on9.fsf@tac.ki.iif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: wferi@niif.hu
List-Id: linux-raid.ids

Hi,

I'm not sure whether linux-raid is the proper place for this bug report.
Please redirect me if not.

I've got a total of 55 AoE devices.  Some of them come from Coraid
EtherDrive 1521 boxes (e1[0-3].*) and some are VS21 logical units
(e10[01].*).  This works with 2.6.18 and its stock AoE driver (v22).
But if I load the aoe module under 2.6.26.6, it freezes my system like
this:

xen2-ha:~# modprobe aoe
[  425.542655] aoe: AoE v47 initialised.
[  425.566656] aoe: e100.0: setting 8192 byte data frames on bond0:003048656128
[  425.580808] aoe: e100.1: setting 8192 byte data frames on bond0:003048656128
[...]
[  425.838389] aoe: e101.4: setting 8192 byte data frames on bond0:003048656128
[  425.852571] aoe: e13.0: setting 8704 byte data frames on bond0:00304860e573
[...]
[  426.432169] aoe: 0030486561 e100.4 vace0 has 195313664 sectors
[  426.738441] aoe: 0030486568 e100.5 vace0 has 195313664 sectors
[...]
[  433.257817] aoe: can't find target e100.0:00304860e573
[  437.436417] aoe: can't find target e100.0:00304860e573
[...]
[  618.634945] aoe: can't find target e100.0:00304860e573

and this line repeats until I reboot the machine.  The console stops
responding to anything but sysrq:

[  590.944278] SysRq : Show Blocked State
[  590.944278]   task                PC stack   pid father
[  590.944278] events/0      D 61d25b93     0    15      2
[  590.944278]        f7495a80 00000046 00000010 61d25b93 00000052 f7495c0c c2817fa0 00000000 
[  590.944278]        f742cfcc 0001db8a 00526eda 00000000 0001db8a f742cfcc 0001db8a c28016a0 
[  591.013732]        c2817fa0 0245f000 c28016a0 c01566f6 c02b8040 f7497d28 f7497d28 c0156729 
[  591.013732] Call Trace:
[  591.013732]  [<c01566f6>] sync_page+0x0/0x36
[  591.013732]  [<c02b8040>] io_schedule+0x49/0x80
[  591.013732]  [<c0156729>] sync_page+0x33/0x36
[  591.013732]  [<c02b816c>] __wait_on_bit_lock+0x2a/0x52
[  591.013732]  [<c01566e8>] __lock_page+0x4e/0x54
[  591.013732]  [<c01317a9>] wake_bit_function+0x0/0x3c
[  591.013732]  [<c0156bca>] read_cache_page_async+0x9e/0xf8
[  591.013732]  [<c01948be>] blkdev_readpage+0x0/0xc
[  591.113733]  [<c01a8688>] adfspart_check_ICS+0x0/0x14c
[  591.113733]  [<c0157ee3>] read_cache_page+0xa/0x3f
[  591.113733]  [<c01a7f65>] read_dev_sector+0x26/0x60
[  591.113733]  [<c01a8688>] adfspart_check_ICS+0x0/0x14c
[  591.113733]  [<c01a86a8>] adfspart_check_ICS+0x20/0x14c
[  591.113733]  [<c01e1063>] sprintf+0x1d/0x20
[  591.113733]  [<c01a8688>] adfspart_check_ICS+0x0/0x14c
[  591.113733]  [<c01a854d>] rescan_partitions+0x10e/0x249
[  591.113733]  [<c01945ed>] do_open+0x1eb/0x28f
[  591.113733]  [<c01946f4>] __blkdev_get+0x63/0x6e
[  591.213733]  [<c0194709>] blkdev_get+0xa/0xc
[  591.213733]  [<c01a83f3>] register_disk+0xc9/0x115
[  591.213733]  [<c01d6a41>] add_disk+0x2c/0x6b
[  591.213733]  [<c01d5da8>] exact_match+0x0/0x7
[  591.213733]  [<c01d67e3>] exact_lock+0x0/0xd
[  591.213733]  [<f8ab1256>] aoeblk_gdalloc+0x10e/0x159 [aoe]
[  591.213733]  [<f8ab20ba>] aoecmd_sleepwork+0x0/0xa4 [aoe]
[  591.213733]  [<f8ab20d6>] aoecmd_sleepwork+0x1c/0xa4 [aoe]
[  591.213733]  [<f8ab20ba>] aoecmd_sleepwork+0x0/0xa4 [aoe]
[  591.213733]  [<c012edee>] run_workqueue+0x74/0xf2
[  591.213733]  [<c012f4c9>] worker_thread+0x0/0xbd
[  591.213733]  [<c012f57c>] worker_thread+0xb3/0xbd
[  591.213733]  [<c013177c>] autoremove_wake_function+0x0/0x2d
[  591.213733]  [<c01316bb>] kthread+0x38/0x5d
[  591.213733]  [<c0131683>] kthread+0x0/0x5d
[  591.213733]  [<c01044f3>] kernel_thread_helper+0x7/0x10

(The rest of the output is mostly garbled because of flow control
issues, but I can overcome that if necessary.)

I know there are newer version of the aoe driver available (I tested
v62 with 2.6.18 and prepared to test v63 under this kernel), but
before that I decided to bring up the issue here.

Is this a known bug, perhaps with a known fix?  I would be interested
in getting it into a stable update, to have distro kernels which don't
freeze right after startup.  Or maybe it's a deeper issue, which
should be fixed anyway...  Any ideas?

(Please Cc me, I'm not on the list.)
-- 
Thanks,
Feri.
