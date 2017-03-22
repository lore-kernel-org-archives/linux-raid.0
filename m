From: Tim Small <tim@buttersideup.com>
Subject: Hang on md RAID5 -> RAID6 reshape
Date: Wed, 22 Mar 2017 10:41:31 +0000
Message-ID: <2ca87d41-6c9b-57be-c7b6-c9aafadc3d70@seoss.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

I seem to have hit a bug on reshape (3 disk RAID5 to 4 disk RAID6).

[1050078.168330] ata7.00: error: { UNC }
[1050078.177689] ata7.00: configured for UDMA/133
[1050078.177704] sd 6:0:0:0: [sdd] tag#1 FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[1050078.177707] sd 6:0:0:0: [sdd] tag#1 Sense Key : Medium Error [current]
[1050078.177709] sd 6:0:0:0: [sdd] tag#1 Add. Sense: Unrecovered read
error - auto reallocate failed
[1050078.177712] sd 6:0:0:0: [sdd] tag#1 CDB: Read(10) 28 00 02 f4 00 00
00 04 00 00
[1050078.177713] blk_update_request: I/O error, dev sdd, sector 49545912
[1050078.179067] ata7: EH complete
[1050080.945668] raid5_end_read_request: 216 callbacks suppressed
[1050080.945672] md/raid:md2: read error corrected (8 sectors at
28572344 on sde2)
[1050080.945674] md/raid:md2: read error corrected (8 sectors at
28572352 on sde2)
[1050080.945675] md/raid:md2: read error corrected (8 sectors at
28572360 on sde2)
[1050080.945677] md/raid:md2: read error corrected (8 sectors at
28572368 on sde2)
[1050080.945678] md/raid:md2: read error corrected (8 sectors at
28572376 on sde2)
[1050080.945680] md/raid:md2: read error corrected (8 sectors at
28572384 on sde2)
[1050080.945681] md/raid:md2: read error corrected (8 sectors at
28572392 on sde2)
[1050080.945683] md/raid:md2: read error corrected (8 sectors at
28572400 on sde2)
[1050080.945685] md/raid:md2: read error corrected (8 sectors at
28572408 on sde2)
[1050080.945686] md/raid:md2: read error corrected (8 sectors at
28572416 on sde2)
[1050635.232146] INFO: task md2_reshape:23542 blocked for more than 120
seconds.
[1050635.233729]       Not tainted 4.8.0-34-generic #36~16.04.1-Ubuntu
[1050635.235284] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[1050635.236858] md2_reshape     D ffff887187b3fb58     0 23542      2
0x00000000
[1050635.236863]  ffff887187b3fb58 ffff8871f7c50001 ffff8871cdad6c00
ffff886fd5615100
[1050635.236866]  0000000000000253 ffff887187b40000 0000000001eff000
ffff887187b3fbd8
[1050635.236868]  ffff8870233c8688 ffff8870233c8400 ffff887187b3fb70
ffffffff9fc91d45
[1050635.236870] Call Trace:
[1050635.236878]  [<ffffffff9fc91d45>] schedule+0x35/0x80
[1050635.236886]  [<ffffffffc0382ea2>] reshape_request+0x682/0x970 [raid456]
[1050635.236889]  [<ffffffff9f4c74d0>] ? wake_atomic_t_function+0x60/0x60
[1050635.236892]  [<ffffffffc03834bb>] raid5_sync_request+0x32b/0x3b0
[raid456]
[1050635.236896]  [<ffffffff9faebb75>] md_do_sync+0x955/0xf00
[1050635.236898]  [<ffffffff9f4c74d0>] ? wake_atomic_t_function+0x60/0x60
[1050635.236902]  [<ffffffff9f490c83>] ? kernel_sigaction+0x43/0xe0
[1050635.236904]  [<ffffffff9fae83e9>] md_thread+0x139/0x150
[1050635.236905]  [<ffffffff9fae82b0>] ? find_pers+0x70/0x70
[1050635.236908]  [<ffffffff9f4a4008>] kthread+0xd8/0xf0
[1050635.236910]  [<ffffffff9fc9679f>] ret_from_fork+0x1f/0x40
[1050635.236912]  [<ffffffff9f4a3f30>] ? kthread_create_on_node+0x1e0/0x1e0


I'm assuming the reallocation is unrelated, since it happened 8 minutes
before the hang.  I didn't explicitly check the underlying device
health, but since there were other md devices using the same drive set I
assume they were OK (no other kernel messages relating to I/O failures
or problems with the other md devices when I rebooted about 9 hours
later).

After reboot, assembly with backup-file (and echo 1 >
/sys/module/md_mod/parameters/start_dirty_degraded) it is continuing the
reshape.

Tim.
