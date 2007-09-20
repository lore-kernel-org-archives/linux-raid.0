From: "Wiesner Thomas" <thomas@bau-konform.at>
Subject: Re: mke2fs stuck in D state while creating filesystem on md*
Date: Thu, 20 Sep 2007 13:26:06 +0200
Message-ID: <op.tyx91sa188izfi@barton2>
References: <op.txtvfnrh88izfi@barton2> <46F010EE.3000202@tmr.com> <op.tyv6r8sb88izfi@barton2> <170fa0d20709191819w694cb7ddo37a19817ae4dfcad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed	delsp=yes
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <170fa0d20709191819w694cb7ddo37a19817ae4dfcad@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> If/when you experience the hang again please get a trace of all  
> processes with:
> echo t > /proc/sysrq-trigger
>
> Of particular interest is the mke2fs trace; as well as any md threads.
>

Ok I've played around a bit. I didn't get those long hangs which I  
described in my initial mail
but smaller ones. I used loopback devices again. When everything is  
working correct, creating the
filesystem on the md device takes about 0.3s (if the data is still cached)  
to about 4s (if there is some
disk activity).

I noticed the following odd behaviour: The hangs occur usually after the  
md device was created.
Subsequent re-formattings don't seem to trigger it (at least very  
infrequent, I don't know).
But directly after creation, it happens quite often. Most of the time it  
takes only a few seconds longer
than expected but once it took 18s and another time 38s to complete. All  
in all I needed to recreate
and reformat the md device approximately 20 to 30 times to get those 2  
long hangs.
The long hangs don't seem to be that frequent.

Test system is unchanged (same as in my first mail), but I had to  
recompile the kernel for SysRq support.

mke2fs took 18s while I took this trace:
Sep 20 11:30:04 hazard kernel: loop0         S F7440320     0  1520      2  
(L-TLB)
Sep 20 11:30:04 hazard kernel:        f7573f7c 00000046 edfbd9a0 f7440320  
c0180370 f8a4450c 00000000 f89f1240
Sep 20 11:30:04 hazard kernel:        f74a9e00 edfbd9a0 edfbd9a0 c1d0b050  
c1d510b0 c1d511bc 000002cd d1518e89
Sep 20 11:30:04 hazard kernel:        00000059 f7d51f08 f7d51e00 f7573fa4  
f7573fb0 f89f1c57 00000000 c1d510b0
Sep 20 11:30:04 hazard kernel: Call Trace:
Sep 20 11:30:04 hazard kernel:  [<c0180370>] bio_put+0x20/0x30
Sep 20 11:30:04 hazard kernel:  [<f8a4450c>] super_written+0x7c/0xd0  
[md_mod]
Sep 20 11:30:04 hazard kernel:  [<f89f1240>] do_lo_send_aops+0x0/0x220  
[loop]
Sep 20 11:30:04 hazard kernel:  [<f89f1c57>] loop_thread+0x147/0x170 [loop]
Sep 20 11:30:04 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:30:04 hazard kernel:  [<c0117a77>] __wake_up_common+0x37/0x60
Sep 20 11:30:04 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:30:04 hazard kernel:  [<f89f1b10>] loop_thread+0x0/0x170 [loop]
Sep 20 11:30:04 hazard kernel:  [<c012d00a>] kthread+0x6a/0x70
Sep 20 11:30:04 hazard kernel:  [<c012cfa0>] kthread+0x0/0x70
Sep 20 11:30:04 hazard kernel:  [<c0104bcf>] kernel_thread_helper+0x7/0x38
Sep 20 11:30:04 hazard kernel:  =======================
Sep 20 11:30:04 hazard kernel: loop1         S F74404A0     0  1522      2  
(L-TLB)
Sep 20 11:30:04 hazard kernel:        f7525f7c 00000046 edfbdba0 f74404a0  
c0180370 f8a4450c 00000000 f89f1240
Sep 20 11:30:04 hazard kernel:        f74a9e00 edfbdba0 edfbdba0 c1d0b050  
c1d49590 c1d4969c 000002f1 d1517029
Sep 20 11:30:04 hazard kernel:        00000059 f7d51108 f7d51000 f7525fa4  
f7525fb0 f89f1c57 00000000 c1d49590
Sep 20 11:30:04 hazard kernel: Call Trace:
Sep 20 11:30:04 hazard kernel:  [<c0180370>] bio_put+0x20/0x30
Sep 20 11:30:04 hazard kernel:  [<f8a4450c>] super_written+0x7c/0xd0  
[md_mod]
Sep 20 11:30:04 hazard kernel:  [<f89f1240>] do_lo_send_aops+0x0/0x220  
[loop]
Sep 20 11:30:04 hazard kernel:  [<f89f1c57>] loop_thread+0x147/0x170 [loop]
Sep 20 11:30:04 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:30:04 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:30:04 hazard kernel:  [<f89f1b10>] loop_thread+0x0/0x170 [loop]
Sep 20 11:30:04 hazard kernel:  [<c012d00a>] kthread+0x6a/0x70
Sep 20 11:30:04 hazard kernel:  [<c012cfa0>] kthread+0x0/0x70
Sep 20 11:30:04 hazard kernel:  [<c0104bcf>] kernel_thread_helper+0x7/0x38
Sep 20 11:30:04 hazard kernel:  =======================
Sep 20 11:30:04 hazard kernel: loop2         S F74403E0     0  1524      2  
(L-TLB)
Sep 20 11:30:04 hazard kernel:        f7577f7c 00000046 edfbd9a0 f74403e0  
c0180370 f8a4450c 00000000 f89f1240
Sep 20 11:30:04 hazard kernel:        f74a9e00 edfbd9a0 edfbd9a0 c1d0b050  
c1d49a90 c1d49b9c 00000399 d1514f81
Sep 20 11:30:04 hazard kernel:        00000059 f7d51308 f7d51200 f7577fa4  
f7577fb0 f89f1c57 00000000 c1d49a90
Sep 20 11:30:04 hazard kernel: Call Trace:
Sep 20 11:30:04 hazard kernel:  [<c0180370>] bio_put+0x20/0x30
Sep 20 11:30:04 hazard kernel:  [<f8a4450c>] super_written+0x7c/0xd0  
[md_mod]
Sep 20 11:30:04 hazard kernel:  [<f89f1240>] do_lo_send_aops+0x0/0x220  
[loop]
Sep 20 11:30:04 hazard kernel:  [<f89f1c57>] loop_thread+0x147/0x170 [loop]
Sep 20 11:30:04 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:30:04 hazard kernel:  [<c0117a77>] __wake_up_common+0x37/0x60
Sep 20 11:30:04 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:30:04 hazard kernel:  [<f89f1b10>] loop_thread+0x0/0x170 [loop]
Sep 20 11:30:04 hazard kernel:  [<c012d00a>] kthread+0x6a/0x70
Sep 20 11:30:04 hazard kernel:  [<c012cfa0>] kthread+0x0/0x70
Sep 20 11:30:04 hazard kernel:  [<c0104bcf>] kernel_thread_helper+0x7/0x38
Sep 20 11:30:04 hazard kernel:  =======================
Sep 20 11:30:04 hazard kernel: md0_raid5     S 00000000     0  1702      2  
(L-TLB)
Sep 20 11:30:04 hazard kernel:        f749ff48 00000046 f8a46892 00000000  
c16e0da0 00000001 00000004 00000000
Sep 20 11:30:04 hazard kernel:        00000001 00000001 00000000 f749e000  
c1d0b050 c1d0b15c 0000008c d151937b
Sep 20 11:30:04 hazard kernel:        00000059 7fffffff 7fffffff ed8e0808  
f749ffa4 c02ffc25 00000000 ed8e0800
Sep 20 11:30:04 hazard kernel: Call Trace:
Sep 20 11:30:04 hazard kernel:  [<f8a46892>] md_update_sb+0x1f2/0x340  
[md_mod]
Sep 20 11:30:04 hazard kernel:  [<c02ffc25>] schedule_timeout+0x95/0xa0
Sep 20 11:30:04 hazard kernel:  [<f8a4a992>] md_thread+0xe2/0x110 [md_mod]
Sep 20 11:30:04 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:30:04 hazard kernel:  [<c0117a77>] __wake_up_common+0x37/0x60
Sep 20 11:30:04 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:30:04 hazard kernel:  [<f8a4a8b0>] md_thread+0x0/0x110 [md_mod]
Sep 20 11:30:04 hazard kernel:  [<c012d00a>] kthread+0x6a/0x70
Sep 20 11:30:04 hazard kernel:  [<c012cfa0>] kthread+0x0/0x70
Sep 20 11:30:04 hazard kernel:  [<c0104bcf>] kernel_thread_helper+0x7/0x38
Sep 20 11:30:04 hazard kernel:  =======================
Sep 20 11:30:04 hazard kernel: mke2fs        D C0144F9B     0  1745   1465  
(NOTLB)
Sep 20 11:30:04 hazard kernel:        f70b7c5c 00000086 f70b7d00 c0144f9b  
f7556e5c 00000003 c039ea00 00000003
Sep 20 11:30:04 hazard kernel:        00000003 c01795c6 00000000 00000000  
f798b0b0 f798b1bc 00000076 cd991190
Sep 20 11:30:04 hazard kernel:        0000005a f70b7c6c 00004f9d f70b7cc0  
f70b7c98 c02ffbdb f70b7d00 c1ce3f20
Sep 20 11:30:04 hazard kernel: Call Trace:
Sep 20 11:30:04 hazard kernel:  [<c0144f9b>] generic_writepages+0x2b/0x30
Sep 20 11:30:04 hazard kernel:  [<c01795c6>] __sync_single_inode+0xd6/0x1e0
Sep 20 11:30:04 hazard kernel:  [<c02ffbdb>] schedule_timeout+0x4b/0xa0
Sep 20 11:30:04 hazard kernel:  [<c0123760>] process_timeout+0x0/0x10
Sep 20 11:30:04 hazard kernel:  [<c02ffb5e>] io_schedule_timeout+0xe/0x30
Sep 20 11:30:04 hazard kernel:  [<c014960f>] congestion_wait+0x6f/0x90
Sep 20 11:30:04 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:30:04 hazard kernel:  [<c0179a5b>] sync_sb_inodes+0x1cb/0x260
Sep 20 11:30:04 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:30:04 hazard kernel:  [<c01446ad>] get_dirty_limits+0xd/0xb0
Sep 20 11:30:04 hazard kernel:  [<c0144833>] balance_dirty_pages+0xe3/0x140
Sep 20 11:30:04 hazard kernel:  [<c0140f5b>]  
generic_file_buffered_write+0x2fb/0x620
Sep 20 11:30:04 hazard kernel:  [<c01711a9>] file_update_time+0x39/0xb0
Sep 20 11:30:04 hazard kernel:  [<c0141514>]  
__generic_file_aio_write_nolock+0x294/0x550
Sep 20 11:30:04 hazard kernel:  [<c023d6e1>] do_con_write+0x251/0x7b0
Sep 20 11:30:04 hazard kernel:  [<c0141821>]  
generic_file_aio_write_nolock+0x51/0xb0
Sep 20 11:30:04 hazard kernel:  [<c015d6a0>] do_sync_write+0xc0/0x100
Sep 20 11:30:04 hazard kernel:  [<c0233b7a>] write_chan+0x14a/0x200
Sep 20 11:30:04 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:30:04 hazard kernel:  [<c022ef27>] tty_write+0x97/0x200
Sep 20 11:30:04 hazard kernel:  [<c0181849>] block_llseek+0x99/0xd0
Sep 20 11:30:04 hazard kernel:  [<c015d5e0>] do_sync_write+0x0/0x100
Sep 20 11:30:04 hazard kernel:  [<c015d769>] vfs_write+0x89/0x110
Sep 20 11:30:04 hazard kernel:  [<c015d8b7>] sys_write+0x47/0x80
Sep 20 11:30:04 hazard kernel:  [<c01040a6>] syscall_call+0x7/0xb
Sep 20 11:30:04 hazard kernel:  =======================


2 traces of the same mke2fs call, which took about 38s to complete.
Sep 20 11:58:48 hazard kernel: loop0         S F7440320     0  1520      2  
(L-TLB)
Sep 20 11:58:48 hazard kernel:        f7573f7c 00000046 ed88a6a0 f7440320  
c0180370 f8a4450c 00000000 f89f1240
Sep 20 11:58:48 hazard kernel:        f74a9e00 ed88a6a0 ed88a6a0 f7c0b590  
c1d510b0 c1d511bc 000002dc 31917e86
Sep 20 11:58:48 hazard kernel:        000001ec f7d51f08 f7d51e00 f7573fa4  
f7573fb0 f89f1c57 00000000 c1d510b0
Sep 20 11:58:48 hazard kernel: Call Trace:
Sep 20 11:58:48 hazard kernel:  [<c0180370>] bio_put+0x20/0x30
Sep 20 11:58:48 hazard kernel:  [<f8a4450c>] super_written+0x7c/0xd0  
[md_mod]
Sep 20 11:58:48 hazard kernel:  [<f89f1240>] do_lo_send_aops+0x0/0x220  
[loop]
Sep 20 11:58:48 hazard kernel:  [<f89f1c57>] loop_thread+0x147/0x170 [loop]
Sep 20 11:58:48 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:58:48 hazard kernel:  [<c0117a77>] __wake_up_common+0x37/0x60
Sep 20 11:58:48 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:58:48 hazard kernel:  [<f89f1b10>] loop_thread+0x0/0x170 [loop]
Sep 20 11:58:48 hazard kernel:  [<c012d00a>] kthread+0x6a/0x70
Sep 20 11:58:48 hazard kernel:  [<c012cfa0>] kthread+0x0/0x70
Sep 20 11:58:48 hazard kernel:  [<c0104bcf>] kernel_thread_helper+0x7/0x38
Sep 20 11:58:48 hazard kernel:  =======================
Sep 20 11:58:48 hazard kernel: loop1         S F74404A0     0  1522      2  
(L-TLB)
Sep 20 11:58:48 hazard kernel:        f7525f7c 00000046 ed88a620 f74404a0  
c0180370 f8a4450c 00000000 f89f1240
Sep 20 11:58:48 hazard kernel:        f74a9e00 ed88a620 ed88a620 f7c0b590  
c1d49590 c1d4969c 00000316 31915869
Sep 20 11:58:48 hazard kernel:        000001ec f7d51108 f7d51000 f7525fa4  
f7525fb0 f89f1c57 00000000 c1d49590
Sep 20 11:58:48 hazard kernel: Call Trace:
Sep 20 11:58:48 hazard kernel:  [<c0180370>] bio_put+0x20/0x30
Sep 20 11:58:48 hazard kernel:  [<f8a4450c>] super_written+0x7c/0xd0  
[md_mod]
Sep 20 11:58:48 hazard kernel:  [<f89f1240>] do_lo_send_aops+0x0/0x220  
[loop]
Sep 20 11:58:48 hazard kernel:  [<f89f1c57>] loop_thread+0x147/0x170 [loop]
Sep 20 11:58:48 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:58:48 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:58:48 hazard kernel:  [<f89f1b10>] loop_thread+0x0/0x170 [loop]
Sep 20 11:58:48 hazard kernel:  [<c012d00a>] kthread+0x6a/0x70
Sep 20 11:58:48 hazard kernel:  [<c012cfa0>] kthread+0x0/0x70
Sep 20 11:58:48 hazard kernel:  [<c0104bcf>] kernel_thread_helper+0x7/0x38
Sep 20 11:58:48 hazard kernel:  =======================
Sep 20 11:58:48 hazard kernel: loop2         S F74403E0     0  1524      2  
(L-TLB)
Sep 20 11:58:48 hazard kernel:        f7577f7c 00000046 ed88a6a0 f74403e0  
c0180370 f8a4450c 00000000 f89f1240
Sep 20 11:58:48 hazard kernel:        f74a9e00 ed88a6a0 ed88a6a0 f7c0b590  
c1d49a90 c1d49b9c 00000589 31912eef
Sep 20 11:58:48 hazard kernel:        000001ec f7d51308 f7d51200 f7577fa4  
f7577fb0 f89f1c57 00000000 c1d49a90
Sep 20 11:58:48 hazard kernel: Call Trace:
Sep 20 11:58:48 hazard kernel:  [<c0180370>] bio_put+0x20/0x30
Sep 20 11:58:48 hazard kernel:  [<f8a4450c>] super_written+0x7c/0xd0  
[md_mod]
Sep 20 11:58:48 hazard kernel:  [<f89f1240>] do_lo_send_aops+0x0/0x220  
[loop]
Sep 20 11:58:48 hazard kernel:  [<f89f1c57>] loop_thread+0x147/0x170 [loop]
Sep 20 11:58:48 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:58:48 hazard kernel:  [<c0117a77>] __wake_up_common+0x37/0x60
Sep 20 11:58:48 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:58:48 hazard kernel:  [<f89f1b10>] loop_thread+0x0/0x170 [loop]
Sep 20 11:58:48 hazard kernel:  [<c012d00a>] kthread+0x6a/0x70
Sep 20 11:58:48 hazard kernel:  [<c012cfa0>] kthread+0x0/0x70
Sep 20 11:58:48 hazard kernel:  [<c0104bcf>] kernel_thread_helper+0x7/0x38
Sep 20 11:58:48 hazard kernel:  =======================
Sep 20 11:58:48 hazard kernel: pdflush       S F235A99F     0  5046      2  
(L-TLB)
Sep 20 11:58:48 hazard kernel:        ecc9df98 00000046 00000040 f235a99f  
000001e9 ffffffff f7991530 c0408960
Sep 20 11:58:48 hazard kernel:        ecc9df78 c02ff323 0000000f c1d45550  
f7991530 f799163c 00000040 f235ae1b
Sep 20 11:58:48 hazard kernel:        000001e9 ecc9dfc0 ecc9dfb4 fffffffc  
00000000 c0145591 c01456c0 00000000
Sep 20 11:58:48 hazard kernel: Call Trace:
Sep 20 11:58:48 hazard kernel:  [<c02ff323>] preempt_schedule+0x53/0x70
Sep 20 11:58:48 hazard kernel:  [<c0145591>] __pdflush+0x91/0x1c0
Sep 20 11:58:48 hazard kernel:  [<c01456c0>] pdflush+0x0/0x30
Sep 20 11:58:48 hazard kernel:  [<c01456c0>] pdflush+0x0/0x30
Sep 20 11:58:48 hazard kernel:  [<c01456e3>] pdflush+0x23/0x30
Sep 20 11:58:48 hazard kernel:  [<c012d00a>] kthread+0x6a/0x70
Sep 20 11:58:48 hazard kernel:  [<c012cfa0>] kthread+0x0/0x70
Sep 20 11:58:48 hazard kernel:  [<c0104bcf>] kernel_thread_helper+0x7/0x38
Sep 20 11:58:48 hazard kernel:  =======================
Sep 20 11:58:48 hazard kernel: md0_raid5     S 00000000     0  5173      2  
(L-TLB)
Sep 20 11:58:48 hazard kernel:        ec967f48 00000046 f8a46892 00000000  
c16dbb60 00000001 00000004 00000000
Sep 20 11:58:48 hazard kernel:        00000001 00000001 00000000 ec966000  
f7c0b590 f7c0b69c 0000012f 31918931
Sep 20 11:58:48 hazard kernel:        000001ec 7fffffff 7fffffff f756ff68  
ec967fa4 c02ffc25 00000000 f756ff60
Sep 20 11:58:48 hazard kernel: Call Trace:
Sep 20 11:58:48 hazard kernel:  [<f8a46892>] md_update_sb+0x1f2/0x340  
[md_mod]
Sep 20 11:58:48 hazard kernel:  [<c02ffc25>] schedule_timeout+0x95/0xa0
Sep 20 11:58:48 hazard kernel:  [<f8a4a992>] md_thread+0xe2/0x110 [md_mod]
Sep 20 11:58:48 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:58:48 hazard kernel:  [<c0117a77>] __wake_up_common+0x37/0x60
Sep 20 11:58:48 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:58:48 hazard kernel:  [<f8a4a8b0>] md_thread+0x0/0x110 [md_mod]
Sep 20 11:58:48 hazard kernel:  [<c012d00a>] kthread+0x6a/0x70
Sep 20 11:58:48 hazard kernel:  [<c012cfa0>] kthread+0x0/0x70
Sep 20 11:58:48 hazard kernel:  [<c0104bcf>] kernel_thread_helper+0x7/0x38
Sep 20 11:58:48 hazard kernel:  =======================
Sep 20 11:58:48 hazard kernel: mke2fs        D C0144F9B     0  5209   1465  
(NOTLB)
Sep 20 11:58:48 hazard kernel:        ecc5bc5c 00000082 ecc5bd00 c0144f9b  
f7556e5c 00000003 c039ea00 00000003
Sep 20 11:58:48 hazard kernel:        00000003 c01795c6 00000000 f799bab0  
f798b0b0 f798b1bc 000000a8 8ae6572a
Sep 20 11:58:48 hazard kernel:        000001ec ecc5bc6c 0006e540 ecc5bcc0  
ecc5bc98 c02ffbdb ecc5bd00 c1cdee80
Sep 20 11:58:48 hazard kernel: Call Trace:
Sep 20 11:58:48 hazard kernel:  [<c0144f9b>] generic_writepages+0x2b/0x30
Sep 20 11:58:48 hazard kernel:  [<c01795c6>] __sync_single_inode+0xd6/0x1e0
Sep 20 11:58:48 hazard kernel:  [<c02ffbdb>] schedule_timeout+0x4b/0xa0
Sep 20 11:58:48 hazard kernel:  [<c0123760>] process_timeout+0x0/0x10
Sep 20 11:58:48 hazard kernel:  [<c02ffb5e>] io_schedule_timeout+0xe/0x30
Sep 20 11:58:48 hazard kernel:  [<c014960f>] congestion_wait+0x6f/0x90
Sep 20 11:58:48 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:58:48 hazard kernel:  [<c0179a5b>] sync_sb_inodes+0x1cb/0x260
Sep 20 11:58:48 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:58:48 hazard kernel:  [<c01446ad>] get_dirty_limits+0xd/0xb0
Sep 20 11:58:48 hazard kernel:  [<c0144833>] balance_dirty_pages+0xe3/0x140
Sep 20 11:58:48 hazard kernel:  [<c0140f5b>]  
generic_file_buffered_write+0x2fb/0x620
Sep 20 11:58:48 hazard kernel:  [<c01711a9>] file_update_time+0x39/0xb0
Sep 20 11:58:48 hazard kernel:  [<c0141514>]  
__generic_file_aio_write_nolock+0x294/0x550
Sep 20 11:58:48 hazard kernel:  [<c01f1988>] fast_clear_page+0x8/0x60
Sep 20 11:58:48 hazard kernel:  [<c01432c2>] prep_new_page+0xb2/0x100
Sep 20 11:58:48 hazard kernel:  [<c0141821>]  
generic_file_aio_write_nolock+0x51/0xb0
Sep 20 11:58:48 hazard kernel:  [<c015d6a0>] do_sync_write+0xc0/0x100
Sep 20 11:58:48 hazard kernel:  [<c0143ac3>] __alloc_pages+0x53/0x2d0
Sep 20 11:58:48 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:58:48 hazard kernel:  [<c014d2a4>] __handle_mm_fault+0xb4/0x220
Sep 20 11:58:48 hazard kernel:  [<c0181849>] block_llseek+0x99/0xd0
Sep 20 11:58:48 hazard kernel:  [<c015d5e0>] do_sync_write+0x0/0x100
Sep 20 11:58:48 hazard kernel:  [<c015d769>] vfs_write+0x89/0x110
Sep 20 11:58:48 hazard kernel:  [<c015d8b7>] sys_write+0x47/0x80
Sep 20 11:58:48 hazard kernel:  [<c01040a6>] syscall_call+0x7/0xb
Sep 20 11:58:48 hazard kernel:  =======================

Sep 20 11:59:21 hazard kernel: loop0         S F7440320     0  1520      2  
(L-TLB)
Sep 20 11:59:21 hazard kernel:        f7573f7c 00000046 ed88a4e0 f7440320  
c0180370 f8a4450c 00000000 f89f1240
Sep 20 11:59:21 hazard kernel:        f74a9e00 ed88a4e0 ed88a4e0 f7c0b590  
c1d510b0 c1d511bc 000002f9 a8eb7111
Sep 20 11:59:21 hazard kernel:        000001ec f7d51f08 f7d51e00 f7573fa4  
f7573fb0 f89f1c57 00000000 c1d510b0
Sep 20 11:59:21 hazard kernel: Call Trace:
Sep 20 11:59:21 hazard kernel:  [<c0180370>] bio_put+0x20/0x30
Sep 20 11:59:21 hazard kernel:  [<f8a4450c>] super_written+0x7c/0xd0  
[md_mod]
Sep 20 11:59:21 hazard kernel:  [<f89f1240>] do_lo_send_aops+0x0/0x220  
[loop]
Sep 20 11:59:21 hazard kernel:  [<f89f1c57>] loop_thread+0x147/0x170 [loop]
Sep 20 11:59:21 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:59:21 hazard kernel:  [<c0117a77>] __wake_up_common+0x37/0x60
Sep 20 11:59:21 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:59:21 hazard kernel:  [<f89f1b10>] loop_thread+0x0/0x170 [loop]
Sep 20 11:59:21 hazard kernel:  [<c012d00a>] kthread+0x6a/0x70
Sep 20 11:59:21 hazard kernel:  [<c012cfa0>] kthread+0x0/0x70
Sep 20 11:59:21 hazard kernel:  [<c0104bcf>] kernel_thread_helper+0x7/0x38
Sep 20 11:59:21 hazard kernel:  =======================
Sep 20 11:59:21 hazard kernel: loop1         S F74404A0     0  1522      2  
(L-TLB)
Sep 20 11:59:21 hazard kernel:        f7525f7c 00000046 ed88a520 f74404a0  
c0180370 f8a4450c 00000000 f89f1240
Sep 20 11:59:21 hazard kernel:        f74a9e00 ed88a520 ed88a520 f7c0b590  
c1d49590 c1d4969c 00000303 a8eb4965
Sep 20 11:59:21 hazard kernel:        000001ec f7d51108 f7d51000 f7525fa4  
f7525fb0 f89f1c57 00000000 c1d49590
Sep 20 11:59:21 hazard kernel: Call Trace:
Sep 20 11:59:21 hazard kernel:  [<c0180370>] bio_put+0x20/0x30
Sep 20 11:59:21 hazard kernel:  [<f8a4450c>] super_written+0x7c/0xd0  
[md_mod]
Sep 20 11:59:21 hazard kernel:  [<f89f1240>] do_lo_send_aops+0x0/0x220  
[loop]
Sep 20 11:59:21 hazard kernel:  [<f89f1c57>] loop_thread+0x147/0x170 [loop]
Sep 20 11:59:21 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:59:21 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:59:21 hazard kernel:  [<f89f1b10>] loop_thread+0x0/0x170 [loop]
Sep 20 11:59:21 hazard kernel:  [<c012d00a>] kthread+0x6a/0x70
Sep 20 11:59:21 hazard kernel:  [<c012cfa0>] kthread+0x0/0x70
Sep 20 11:59:21 hazard kernel:  [<c0104bcf>] kernel_thread_helper+0x7/0x38
Sep 20 11:59:21 hazard kernel:  =======================
Sep 20 11:59:21 hazard kernel: loop2         S F74403E0     0  1524      2  
(L-TLB)
Sep 20 11:59:21 hazard kernel:        f7577f7c 00000046 ed88a4e0 f74403e0  
c0180370 f8a4450c 00000000 f89f1240
Sep 20 11:59:21 hazard kernel:        f74a9e00 ed88a4e0 ed88a4e0 f7c0b590  
c1d49a90 c1d49b9c 00000566 a8eb2055
Sep 20 11:59:21 hazard kernel:        000001ec f7d51308 f7d51200 f7577fa4  
f7577fb0 f89f1c57 00000000 c1d49a90
Sep 20 11:59:21 hazard kernel: Call Trace:
Sep 20 11:59:21 hazard kernel:  [<c0180370>] bio_put+0x20/0x30
Sep 20 11:59:21 hazard kernel:  [<f8a4450c>] super_written+0x7c/0xd0  
[md_mod]
Sep 20 11:59:21 hazard kernel:  [<f89f1240>] do_lo_send_aops+0x0/0x220  
[loop]
Sep 20 11:59:21 hazard kernel:  [<f89f1c57>] loop_thread+0x147/0x170 [loop]
Sep 20 11:59:21 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:59:21 hazard kernel:  [<c0117a77>] __wake_up_common+0x37/0x60
Sep 20 11:59:21 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:59:21 hazard kernel:  [<f89f1b10>] loop_thread+0x0/0x170 [loop]
Sep 20 11:59:21 hazard kernel:  [<c012d00a>] kthread+0x6a/0x70
Sep 20 11:59:21 hazard kernel:  [<c012cfa0>] kthread+0x0/0x70
Sep 20 11:59:21 hazard kernel:  [<c0104bcf>] kernel_thread_helper+0x7/0x38
Sep 20 11:59:21 hazard kernel:  =======================
Sep 20 11:59:21 hazard kernel: pdflush       S C0144A3B     0  5046      2  
(L-TLB)
Sep 20 11:59:21 hazard kernel:        ecc9df98 00000046 0000040c c0144a3b  
00002b30 00005661 00000000 00000000
Sep 20 11:59:21 hazard kernel:        00000000 fffffff4 0000040c f798b0b0  
f7991530 f799163c 000000d4 9aa491be
Sep 20 11:59:21 hazard kernel:        000001ec ecc9dfc0 ecc9dfb4 fffffffc  
00000000 c0145591 c01456c0 00000000
Sep 20 11:59:21 hazard kernel: Call Trace:
Sep 20 11:59:21 hazard kernel:  [<c0144a3b>] background_writeout+0x7b/0xa0
Sep 20 11:59:21 hazard kernel:  [<c0145591>] __pdflush+0x91/0x1c0
Sep 20 11:59:21 hazard kernel:  [<c01456c0>] pdflush+0x0/0x30
Sep 20 11:59:21 hazard kernel:  [<c01456c0>] pdflush+0x0/0x30
Sep 20 11:59:21 hazard kernel:  [<c01456e3>] pdflush+0x23/0x30
Sep 20 11:59:21 hazard kernel:  [<c012d00a>] kthread+0x6a/0x70
Sep 20 11:59:21 hazard kernel:  [<c012cfa0>] kthread+0x0/0x70
Sep 20 11:59:21 hazard kernel:  [<c0104bcf>] kernel_thread_helper+0x7/0x38
Sep 20 11:59:21 hazard kernel:  =======================
Sep 20 11:59:21 hazard kernel: md0_raid5     S 00000000     0  5173      2  
(L-TLB)
Sep 20 11:59:21 hazard kernel:        ec967f48 00000046 f8a46892 00000000  
c16dbb60 00000046 00000004 00000000
Sep 20 11:59:21 hazard kernel:        00000001 00000001 00000000 ec966000  
f7c0b590 f7c0b69c 00000127 a8eb7b71
Sep 20 11:59:21 hazard kernel:        000001ec 7fffffff 7fffffff f756ff68  
ec967fa4 c02ffc25 00000000 f756ff60
Sep 20 11:59:21 hazard kernel: Call Trace:
Sep 20 11:59:21 hazard kernel:  [<f8a46892>] md_update_sb+0x1f2/0x340  
[md_mod]
Sep 20 11:59:21 hazard kernel:  [<c02ffc25>] schedule_timeout+0x95/0xa0
Sep 20 11:59:21 hazard kernel:  [<f8a4a992>] md_thread+0xe2/0x110 [md_mod]
Sep 20 11:59:21 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:59:21 hazard kernel:  [<c0117a77>] __wake_up_common+0x37/0x60
Sep 20 11:59:21 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:59:21 hazard kernel:  [<f8a4a8b0>] md_thread+0x0/0x110 [md_mod]
Sep 20 11:59:21 hazard kernel:  [<c012d00a>] kthread+0x6a/0x70
Sep 20 11:59:21 hazard kernel:  [<c012cfa0>] kthread+0x0/0x70
Sep 20 11:59:21 hazard kernel:  [<c0104bcf>] kernel_thread_helper+0x7/0x38
Sep 20 11:59:21 hazard kernel:  =======================
Sep 20 11:59:21 hazard kernel: mke2fs        D C0144F9B     0  5209   1465  
(NOTLB)
Sep 20 11:59:21 hazard kernel:        ecc5bc5c 00000082 ecc5bd00 c0144f9b  
f7556e5c 00000003 c039ea00 00000003
Sep 20 11:59:21 hazard kernel:        00000003 c01795c6 00000000 f798b5b0  
f798b0b0 f798b1bc 00000083 4209671b
Sep 20 11:59:21 hazard kernel:        000001f4 ecc5bc6c 00070589 ecc5bcc0  
ecc5bc98 c02ffbdb ecc5bd00 c1e55ec4
Sep 20 11:59:21 hazard kernel: Call Trace:
Sep 20 11:59:21 hazard kernel:  [<c0144f9b>] generic_writepages+0x2b/0x30
Sep 20 11:59:21 hazard kernel:  [<c01795c6>] __sync_single_inode+0xd6/0x1e0
Sep 20 11:59:21 hazard kernel:  [<c02ffbdb>] schedule_timeout+0x4b/0xa0
Sep 20 11:59:21 hazard kernel:  [<c0123760>] process_timeout+0x0/0x10
Sep 20 11:59:21 hazard kernel:  [<c02ffb5e>] io_schedule_timeout+0xe/0x30
Sep 20 11:59:21 hazard kernel:  [<c014960f>] congestion_wait+0x6f/0x90
Sep 20 11:59:21 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:59:21 hazard kernel:  [<c0179a5b>] sync_sb_inodes+0x1cb/0x260
Sep 20 11:59:21 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:59:21 hazard kernel:  [<c01446ad>] get_dirty_limits+0xd/0xb0
Sep 20 11:59:21 hazard kernel:  [<c0144833>] balance_dirty_pages+0xe3/0x140
Sep 20 11:59:21 hazard kernel:  [<c0140f5b>]  
generic_file_buffered_write+0x2fb/0x620
Sep 20 11:59:21 hazard kernel:  [<c01711a9>] file_update_time+0x39/0xb0
Sep 20 11:59:21 hazard kernel:  [<c0141514>]  
__generic_file_aio_write_nolock+0x294/0x550
Sep 20 11:59:21 hazard kernel:  [<c023d6e1>] do_con_write+0x251/0x7b0
Sep 20 11:59:21 hazard kernel:  [<c01f1988>] fast_clear_page+0x8/0x60
Sep 20 11:59:21 hazard kernel:  [<c0141821>]  
generic_file_aio_write_nolock+0x51/0xb0
Sep 20 11:59:21 hazard kernel:  [<c015d6a0>] do_sync_write+0xc0/0x100
Sep 20 11:59:21 hazard kernel:  [<c0233b7a>] write_chan+0x14a/0x200
Sep 20 11:59:21 hazard kernel:  [<c012d550>]  
autoremove_wake_function+0x0/0x50
Sep 20 11:59:21 hazard kernel:  [<c022ef27>] tty_write+0x97/0x200
Sep 20 11:59:21 hazard kernel:  [<c0181849>] block_llseek+0x99/0xd0
Sep 20 11:59:21 hazard kernel:  [<c015d5e0>] do_sync_write+0x0/0x100
Sep 20 11:59:21 hazard kernel:  [<c015d769>] vfs_write+0x89/0x110
Sep 20 11:59:21 hazard kernel:  [<c015d8b7>] sys_write+0x47/0x80
Sep 20 11:59:21 hazard kernel:  [<c01040a6>] syscall_call+0x7/0xb
Sep 20 11:59:21 hazard kernel:  =======================
Sep 20 11:59:21 hazard kernel: sleep         S C012FFB3     0  5279   1467  
(NOTLB)
Sep 20 11:59:21 hazard kernel:        ee29ff44 00000086 f74bbf64 c012ffb3  
c03a5db0 c9461234 000001f2 00000001
Sep 20 11:59:21 hazard kernel:        c03a5da8 c9461234 000001f2 f7991030  
c1d0b050 c1d0b15c 0001c160 2bea5089
Sep 20 11:59:21 hazard kernel:        000001f4 ee29ff64 00000001 00000001  
00000000 c03000fb 00000001 00000000
Sep 20 11:59:21 hazard kernel: Call Trace:
Sep 20 11:59:21 hazard kernel:  [<c012ffb3>] enqueue_hrtimer+0xa3/0xc0
Sep 20 11:59:21 hazard kernel:  [<c03000fb>] do_nanosleep+0x3b/0x70
Sep 20 11:59:21 hazard kernel:  [<c01303a5>] hrtimer_nanosleep+0x45/0xe0
Sep 20 11:59:21 hazard kernel:  [<c0115f88>] do_page_fault+0x398/0x590
Sep 20 11:59:21 hazard kernel:  [<c0130330>] hrtimer_wakeup+0x0/0x20
Sep 20 11:59:21 hazard kernel:  [<c0130499>] sys_nanosleep+0x59/0x60
Sep 20 11:59:21 hazard kernel:  [<c01040a6>] syscall_call+0x7/0xb
