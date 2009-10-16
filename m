From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Raid reconstructing and process hanging in D state
Date: Fri, 16 Oct 2009 04:37:14 -0400 (EDT)
Message-ID: <alpine.DEB.2.00.0910160436160.2841@p34.internal.lan>
References: <Pine.LNX.4.64.0910160703260.2463@praktifix.dwd.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751635AbZJPIhw@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0910160703260.2463@praktifix.dwd.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids



On Fri, 16 Oct 2009, Holger Kiehl wrote:

> Hello
>
> I have a SW Raid6 over 8 disk with a plain 2.6.31.4 kernel. When the
> raid is reconstructed I get a lot of process hanging for a long time
> in D-state. In fact /var/log/messages shows the following errors:
>
>   Oct 16 04:09:01 hermes kernel: md: data-check of RAID array md3
>   Oct 16 04:09:01 hermes kernel: md: minimum _guaranteed_  speed: 1000 
> KB/sec/disk.
>   Oct 16 04:09:01 hermes kernel: md: data-check of RAID array md1
>   Oct 16 04:09:01 hermes kernel: md: minimum _guaranteed_  speed: 1000 
> KB/sec/disk.
>   Oct 16 04:09:01 hermes kernel: md: using maximum available idle IO 
> bandwidth (but not more than 200000 KB/sec) for data-check.
>   Oct 16 04:09:01 hermes kernel: md: using maximum available idle IO 
> bandwidth (but not more than 200000 KB/sec) for data-check.
>   Oct 16 04:09:01 hermes kernel: md: using 128k window, over a total of 
> 70613632 blocks.
>   Oct 16 04:09:01 hermes kernel: md: using 128k window, over a total of 
> 70613632 blocks.
>   Oct 16 04:09:01 hermes kernel: md: delaying data-check of md0 until md3 
> has finished (they share one or more physical units)
>   Oct 16 04:09:01 hermes kernel: md: delaying data-check of md2 until md0 
> has finished (they share one or more physical units)
>   Oct 16 04:09:01 hermes kernel: md: delaying data-check of md0 until md3 
> has finished (they share one or more physical units)
>   Oct 16 04:09:01 hermes kernel: md: data-check of RAID array md4
>   Oct 16 04:09:01 hermes kernel: md: minimum _guaranteed_  speed: 1000 
> KB/sec/disk.
>   Oct 16 04:09:01 hermes kernel: md: using maximum available idle IO 
> bandwidth (but not more than 200000 KB/sec) for data-check.
>   Oct 16 04:09:01 hermes kernel: md: using 128k window, over a total of 
> 292413440 blocks.
>   Oct 16 04:12:06 hermes kernel: INFO: task pdflush:409 blocked for more 
> than 120 seconds.
>   Oct 16 04:12:06 hermes kernel: "echo 0 > 
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>   Oct 16 04:12:06 hermes kernel: pdflush       D ffff8800280910e8     0 
> 409      2 0x00000000
>   Oct 16 04:12:06 hermes kernel: ffff88083ced7aa0 0000000000000046 
> 0000000000000000 ffffea001cc87148
>   Oct 16 04:12:06 hermes kernel: ffff88083ced7a80 ffffffff81107530 
> ffff88083c57e6f8 000000000000e0e8
>   Oct 16 04:12:06 hermes kernel: ffff88083c57e6f8 0000000000011c80 
> 0000000000011c80 00000001037141e6
>   Oct 16 04:12:06 hermes kernel: Call Trace:
>   Oct 16 04:12:06 hermes kernel: [<ffffffff81107530>] ? 
> __block_write_full_page+0x200/0x2f2
>   Oct 16 04:12:06 hermes kernel: [<ffffffff81182376>] 
> start_this_handle+0x2dc/0x3b1
>   Oct 16 04:12:06 hermes kernel: [<ffffffff8107fb43>] ? 
> autoremove_wake_function+0x0/0x5a
>   Oct 16 04:12:06 hermes kernel: [<ffffffff811825ee>] 
> jbd2_journal_start+0xb2/0x101
>   Oct 16 04:12:06 hermes kernel: [<ffffffff81167fe5>] 
> ext4_journal_start_sb+0x62/0xa1
>   Oct 16 04:12:06 hermes kernel: [<ffffffff8115c051>] 
> ext4_da_writepages+0x1f1/0x430
>   Oct 16 04:12:06 hermes kernel: [<ffffffff810734d5>] ? 
> lock_timer_base+0x3a/0x78
>   Oct 16 04:12:06 hermes kernel: [<ffffffff810b3816>] 
> do_writepages+0x35/0x5b
>   Oct 16 04:12:06 hermes kernel: [<ffffffff810fec80>] 
> writeback_single_inode+0x17c/0x37e
>   Oct 16 04:12:06 hermes kernel: [<ffffffff810a30b4>] ? 
> delayacct_end+0x8c/0xad
>   Oct 16 04:12:06 hermes kernel: [<ffffffff810ff366>] 
> generic_sync_sb_inodes+0x2b4/0x451
>   Oct 16 04:12:06 hermes kernel: [<ffffffff810ff644>] 
> writeback_inodes+0x95/0xfe
>   Oct 16 04:12:06 hermes kernel: [<ffffffff810b3a36>] wb_kupdate+0xbb/0x142
>   Oct 16 04:12:06 hermes kernel: [<ffffffff810b4917>] ? pdflush+0x0/0x22b
>   Oct 16 04:12:06 hermes kernel: [<ffffffff810b4a47>] pdflush+0x130/0x22b
>   Oct 16 04:12:06 hermes kernel: [<ffffffff810b397b>] ? wb_kupdate+0x0/0x142
>   Oct 16 04:12:06 hermes kernel: [<ffffffff8107f71f>] kthread+0x9b/0xa3
>   Oct 16 04:12:06 hermes kernel: [<ffffffff8102ccaa>] child_rip+0xa/0x20
>   Oct 16 04:12:06 hermes kernel: [<ffffffff8107f684>] ? kthread+0x0/0xa3
>   Oct 16 04:12:06 hermes kernel: [<ffffffff8102cca0>] ? child_rip+0x0/0x20
>   Oct 16 04:12:06 hermes kernel: INFO: task kjournald2:2166 blocked for more 
> than 120 seconds.
>   Oct 16 04:12:06 hermes kernel: "echo 0 > 
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>   Oct 16 04:12:06 hermes kernel: kjournald2    D ffff8800280c50e8     0 
> 2166      2 0x00000000
>   Oct 16 04:12:06 hermes kernel: ffff8808392cdcd0 0000000000000046 
> 0000000000000000 ffffffff81058376
>   Oct 16 04:12:06 hermes kernel: 0000000000000000 ffff88083930b0a0 
> ffff88083a2b4a38 000000000000e0e8
>   Oct 16 04:12:06 hermes kernel: ffff88083a2b4a38 0000000000011c80 
> 0000000000011c80 0000000103713338
>   Oct 16 04:12:06 hermes kernel: Call Trace:
>   Oct 16 04:12:06 hermes kernel: [<ffffffff81058376>] ? 
> __wake_up_common+0x58/0xa2
>   Oct 16 04:12:06 hermes kernel: [<ffffffff811829f3>] 
> jbd2_journal_commit_transaction+0x189/0x10e6
>   Oct 16 04:12:06 hermes kernel: [<ffffffff8105aee5>] ? 
> __dequeue_entity+0x41/0x5d
>   Oct 16 04:12:06 hermes kernel: [<ffffffff8102a527>] ? 
> __switch_to+0xce/0x2af
>   Oct 16 04:12:06 hermes kernel: [<ffffffff8106118d>] ? 
> finish_task_switch+0x6d/0x116
>   Oct 16 04:12:06 hermes kernel: [<ffffffff810734d5>] ? 
> lock_timer_base+0x3a/0x78
>   Oct 16 04:12:06 hermes kernel: [<ffffffff8107fb43>] ? 
> autoremove_wake_function+0x0/0x5a
>   Oct 16 04:12:06 hermes kernel: [<ffffffff81073577>] ? 
> try_to_del_timer_sync+0x64/0x82
>   Oct 16 04:12:06 hermes kernel: [<ffffffff81187505>] kjournald2+0x10e/0x23f
>   Oct 16 04:12:06 hermes kernel: [<ffffffff8107fb43>] ? 
> autoremove_wake_function+0x0/0x5a
>   Oct 16 04:12:06 hermes kernel: [<ffffffff811873f7>] ? kjournald2+0x0/0x23f
>   Oct 16 04:12:06 hermes kernel: [<ffffffff8107f71f>] kthread+0x9b/0xa3
>   Oct 16 04:12:06 hermes kernel: [<ffffffff8102ccaa>] child_rip+0xa/0x20
>   Oct 16 04:12:06 hermes kernel: [<ffffffff8107f684>] ? kthread+0x0/0xa3
>   Oct 16 04:12:06 hermes kernel: [<ffffffff8102cca0>] ? child_rip+0x0/0x20
>
> Lowering the reconstruction rate to 10000 in
> /proc/sys/dev/raid/speed_limit_max solved the problem. But I was under
> the impression that the raid code would lower this speed (to 
> speed_limit_min?)
> automatically when there are other process trying to access the device.
> Are the other parameters one can tune so that the reconstruction does
> not eat all the IO?
>
> Thanks,
> Holger
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hi,

I have the same problem with mdadm/raid-1, if you do not limit the speed 
in the speed_limit_min paramter, it will starve the I/O from all other 
processes and result in the same problem you are having.

But for me I'm not sure about the reconstruction-- this happens for me 
during a raid verify/check.

Justin.
