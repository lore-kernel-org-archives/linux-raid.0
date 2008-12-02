From: Neil Brown <neilb@suse.de>
Subject: Re: Kernel BUG
Date: Wed, 3 Dec 2008 10:38:14 +1100
Message-ID: <18741.50918.712839.804410@notabene.brown>
References: <150c16850812011409hf507ac6m5b168571ee6b453e@mail.gmail.com>
	<150c16850812021306p4334516fo4124b29aa3c117d7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Justin Maggard on Tuesday December 2
Sender: linux-raid-owner@vger.kernel.org
To: Justin Maggard <jmaggard10@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday December 2, jmaggard10@gmail.com wrote:
> Hi all,
> 
> I just ran across a kernel bug seemingly in md.  It's not something
> people should run across normally, but here are details.
> * System is a regular x86 running a Core2 processor in 32-bit mode.
> 
> * The issue happens with raid1, raid5, and raid6 personalities (that's
> all I tested with).
> * I was not able to reproduce the issue without md.
> * It showed up for me starting with vanilla 2.6.27, and is still an
> issue with 2.6.27.7 and 2.6.28-rc6, but it did not happen with 2.6.26.
> 
> 
> It is very easy to reproduce:
> 1) Create an md array with >= 1 disk
> 2) Start a task writing to the array ("dd if=/dev/zero of=/dev/md0
> bs=1M count=10000 &" does the trick for me)
> 3) Force an improper reboot with reboot -fn

Thanks for reporting this.  And sorry for not responding when you
posted it over a week ago to linux-kernel.  I did see it....

It seems that the in-kernel shutdown process is stopping the md arrays
before all dirty data is flushed.  I guess that is reasonable as the
'-n' means "don't sync".  However the kernel keeps flushing out dirty
data after the shutdown has started and that seems to be the problem.

The fact that it has only recently started happening is a useful clue.
It would be really helpful to use 'git bisect' to find out which
change introduced the problem.  That should make it a lot easier to
understand the cause.

I might try to give this a try, but if you are able to try that too it
would be very helpful.

Thanks,
NeilBrown


> 
> If you need any more information, let me know.
> 
> Console capture is below:
> 
> nv6-j1:/mnt# reboot -nf
> 
> md: stopping all md devices.
> 
> ------------[ cut here ]------------
> Kernel BUG at c0682ca7 [verbose debug info unavailable]
> 
> 
> invalid opcode: 0000 [#1] SMP
> Modules linked in:
> 
> 
> 
> Pid: 3661, comm: kjournald Not tainted (2.6.27.6 #1)
> 
> EIP: 0060:[<c0682ca7>] EFLAGS: 00010246 CPU: 1
> 
> 
> EIP is at md_write_start+0x157/0x160
> 
> EAX: 00000001 EBX: f71c7e00 ECX: f2bb7940 EDX: f2bb7940
> ESI: 000000ff EDI: f2bb7940 EBP: 00000008 ESP: f65d3da4
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process kjournald (pid: 3661, ti=f65d2000 task=f6cef540 task.ti=f65d2000)
> 
> 
> Stack: f717bdc0 c06890e5 007f40a0 00000000 00000000 f7144920 000000ff f2bb7940
>        c06783e0 00000000 00000001 00000008 f73c1ca0 007f4218 00000000 f702b96c
>        f2bb7840 f71b2bc0 11027f60 f2bb7940 f702b880 f71c7e00 007f4220 ef326398
> 
> 
> Call Trace:
> 
>  [<c06890e5>] __map_bio+0x35/0xa0
> 
>  [<c06783e0>] make_request+0x40/0x6b0
> 
>  [<c068a444>] dm_request+0xd4/0x120
> 
>  [<c0581b1f>] generic_make_request+0x12f/0x280
> 
> 
>  [<c044a5ed>] mempool_alloc+0x2d/0xe0
> 
>  [<c0583108>] submit_bio+0x58/0xf0
> 
>  [<c048d5c5>] bvec_alloc_bs+0x65/0x110
> 
>  [<c048d891>] bio_alloc_bioset+0x61/0x90
> 
>  [<c0489a31>] submit_bh+0xd1/0x110
> 
> 
>  [<c04c8eaa>] journal_do_submit_data+0x2a/0x40
> 
>  [<c04c9c0d>] journal_commit_transaction+0xcad/0xcf0
> 
>  [<c0430fe0>] autoremove_wake_function+0x0/0x40
> 
>  [<c0427b75>] try_to_del_timer_sync+0x45/0x50
> 
> 
>  [<c04cc429>] kjournald+0xa9/0x1c0
> 
>  [<c0430fe0>] autoremove_wake_function+0x0/0x40
> 
>  [<c04cc380>] kjournald+0x0/0x1c0
> 
>  [<c0430ce2>] kthread+0x42/0x70
> 
>  [<c0430ca0>] kthread+0x0/0x70
> 
> 
>  [<c0403c13>] kernel_thread_helper+0x7/0x14
> 
>  =======================
> Code: ff ff e9 f9 fe ff ff c7 83 34 01 00 00 00 00 00 00 f0 80 4b 18
> 02 8b 83 dc 00 00 00 be 01 00 0
> 
> 0 00 e8 ee 9a ff ff e9 7c ff ff ff <0f> 0b eb fe 90 8d 74 26 00 83 ec
> 10 89 74 24 04 89 7c 24 08 89
> 
> 
> EIP: [<c0682ca7>] md_write_start+0x157/0x160 SS:ESP 0068:f65d3da4
> 
> ------------[ cut here ]------------
> ---[ end trace 02aba934bad77262 ]---
> Kernel BUG at c0682ca7 [verbose debug info unavailable]
> 
> 
> invalid opcode: 0000 [#2] SMP
> Modules linked in:
> 
> 
> 
> Pid: 3665, comm: pdflush Tainted: G      D   (2.6.27.6 #1)
> 
> EIP: 0060:[<c0682ca7>] EFLAGS: 00010246 CPU: 0
> 
> 
> EIP is at md_write_start+0x157/0x160
> 
> EAX: 00000001 EBX: f71c7e00 ECX: f2bb7cc0 EDX: f2bb7cc0
> ESI: 000000ff EDI: f2bb7cc0 EBP: 00000008 ESP: c5b25c44
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process pdflush (pid: 3665, ti=c5b24000 task=f701a040 task.ti=c5b24000)
> 
> 
> Stack: f717bdc0 c06890e5 007f50a0 00000000 00000000 f7144920 000000ff f2bb7cc0
>        c06783e0 00000000 00000001 00000008 f73c1ca0 007f4210 00000000 f702b96c
>        f2bb7a40 f71b2bc0 11026f60 f2bb7cc0 f702b880 f71c7e00 007f4218 efc04fa8
> 
> 
> Call Trace:
> 
>  [<c06890e5>] __map_bio+0x35/0xa0
> 
>  [<c06783e0>] make_request+0x40/0x6b0
> 
>  [<c068a444>] dm_request+0xd4/0x120
> 
>  [<c0581b1f>] generic_make_request+0x12f/0x280
> 
> 
>  [<c044a5ed>] mempool_alloc+0x2d/0xe0
> 
>  [<c0583108>] submit_bio+0x58/0xf0
> 
>  [<c048d5c5>] bvec_alloc_bs+0x65/0x110
> 
>  [<c048d891>] bio_alloc_bioset+0x61/0x90
> 
>  [<c0489a31>] submit_bh+0xd1/0x110
> 
> 
>  [<c048b8bd>] __block_write_full_page+0x1ed/0x360
> 
>  [<c04c7d9f>] start_this_handle+0x8f/0x330
> 
>  [<c04b7e00>] ext3_get_block+0x0/0x110
> 
>  [<c048bb1a>] block_write_full_page+0xea/0x100
> 
> 
>  [<c04b7e00>] ext3_get_block+0x0/0x110
> 
>  [<c04b9713>] ext3_ordered_writepage+0xa3/0x170
> 
>  [<c04b64d0>] bget_one+0x0/0x10
> 
>  [<c044dbe8>] __writepage+0x8/0x30
> 
>  [<c044e13f>] write_cache_pages+0x20f/0x320
> 
> 
>  [<c044dbe0>] __writepage+0x0/0x30
> 
>  [<c044e270>] generic_writepages+0x20/0x30
> 
>  [<c044e2c9>] do_writepages+0x49/0x50
> 
>  [<c0485aea>] __writeback_single_inode+0x8a/0x2e0
> 
> 
>  [<c068bb7a>] dm_table_any_congested+0x2a/0x60
> 
>  [<c04860fe>] generic_sync_sb_inodes+0x1ce/0x2d0
> 
>  [<c048656b>] writeback_inodes+0x7b/0xa0
> 
>  [<c044eba8>] background_writeout+0x98/0xc0
> 
> 
>  [<c044f0b0>] pdflush+0x0/0x1a0
> 
>  [<c044f19b>] pdflush+0xeb/0x1a0
> 
>  [<c044eb10>] background_writeout+0x0/0xc0
> 
>  [<c0430ce2>] kthread+0x42/0x70
> 
>  [<c0430ca0>] kthread+0x0/0x70
> 
> 
>  [<c0403c13>] kernel_thread_helper+0x7/0x14
> 
>  =======================
> Code: ff ff e9 f9 fe ff ff c7 83 34 01 00 00 00 00 00 00 f0 80 4b 18
> 02 8b 83 dc 00 00 00 be 01 00 0
> 
> 0 00 e8 ee 9a ff ff e9 7c ff ff ff <0f> 0b eb fe 90 8d 74 26 00 83 ec
> 10 89 74 24 04 89 7c 24 08 89
> 
> 
> EIP: [<c0682ca7>] md_write_start+0x157/0x160 SS:ESP 0068:c5b25c44
> 
> ---[ end trace 02aba934bad77262 ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
