From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm --stop goes off and never comes back?
Date: Thu, 20 Dec 2007 12:45:05 +1100
Message-ID: <18281.51489.845404.884191@notabene.brown>
References: <cccedfc60712181311i6bfd755v659ad5b81bc81dc5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Nelson on Tuesday December 18
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday December 18, jnelson-linux-raid@jamponi.net wrote:
> This just happened to me.
> Create raid with:
> 
> mdadm --create /dev/md2 --level=raid10 --raid-devices=3
> --spare-devices=0 --layout=o2 /dev/sdb3 /dev/sdc3 /dev/sdd3
> 
> cat /proc/mdstat
> 
> md2 : active raid10 sdd3[2] sdc3[1] sdb3[0]
>       5855424 blocks 64K chunks 2 offset-copies [3/3] [UUU]
>       [==>..................]  resync = 14.6% (859968/5855424)
> finish=1.3min speed=61426K/sec
> 
> Some log messages:
> 
> Dec 18 15:02:28 turnip kernel: md: md2: raid array is not clean --
> starting background reconstruction
> Dec 18 15:02:28 turnip kernel: raid10: raid set md2 active with 3 out
> of 3 devices
> Dec 18 15:02:28 turnip kernel: md: resync of RAID array md2
> Dec 18 15:02:28 turnip kernel: md: minimum _guaranteed_  speed: 1000
> KB/sec/disk.
> Dec 18 15:02:28 turnip kernel: md: using maximum available idle IO
> bandwidth (but not more than 200000 KB/sec) for resync.
> Dec 18 15:02:28 turnip kernel: md: using 128k window, over a total of
> 5855424 blocks.
> Dec 18 15:03:36 turnip kernel: md: md2: resync done.
> Dec 18 15:03:36 turnip kernel: md: checkpointing resync of md2.
> 
> I tried to stop the array:
> 
> mdadm --stop /dev/md2
> 
> and mdadm never came back. It's off in the kernel somewhere. :-(
> 
> kill, of course, has no effect.
> The machine still runs fine, the rest of the raids (md0 and md1) work
> fine (same disks).
> 
> The output (snipped, only mdadm) of 'echo t > /proc/sysrq-trigger'
> 
> Dec 18 15:09:13 turnip kernel: mdadm         S 0001e5359fa38fb0     0
> 3943      1 (NOTLB)
> Dec 18 15:09:13 turnip kernel:  ffff810033e7ddc8 0000000000000086
> 0000000000000000 0000000000000092
> Dec 18 15:09:13 turnip kernel:  0000000000000fc7 ffff810033e7dd78
> ffffffff80617800 ffffffff80617800
> Dec 18 15:09:13 turnip kernel:  ffffffff8061d210 ffffffff80617800
> ffffffff80617800 0000000000000000
> Dec 18 15:09:13 turnip kernel: Call Trace:
> Dec 18 15:09:13 turnip kernel:  [<ffffffff803fac96>]
> __mutex_lock_interruptible_slowpath+0x8b/0xca
> Dec 18 15:09:13 turnip kernel:  [<ffffffff802acccb>] do_open+0x222/0x2a5
> Dec 18 15:09:13 turnip kernel:  [<ffffffff8038705d>] md_seq_show+0x127/0x6c1
> Dec 18 15:09:13 turnip kernel:  [<ffffffff80275597>] vma_merge+0x141/0x1ee
> Dec 18 15:09:13 turnip kernel:  [<ffffffff802a2aa0>] seq_read+0x1bf/0x28b
> Dec 18 15:09:13 turnip kernel:  [<ffffffff8028a42d>] vfs_read+0xcb/0x153
> Dec 18 15:09:13 turnip kernel:  [<ffffffff8028a7c1>] sys_read+0x45/0x6e
> Dec 18 15:09:13 turnip kernel:  [<ffffffff80209c2e>] system_call+0x7e/0x83
> 
> 
> 
> What happened? Is there any debug info I can provide before I reboot?

Don't know.... very odd.

The rest of the 'sysrq' output would possibly help.

NeilBrown
