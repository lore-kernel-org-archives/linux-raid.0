From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: suggest disk numbers in a raidset?
Date: Fri, 20 May 2016 10:38:30 +0200
Message-ID: <20160520083830.GA3189@metamorpher.de>
References: <CAC6SzHJ8Wi18opzDbzjtT+niM5QKOyOU3AAeo0npbDsV+sQOTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAC6SzHJ8Wi18opzDbzjtT+niM5QKOyOU3AAeo0npbDsV+sQOTQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: d tbsky <tbskyd@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 20, 2016 at 01:13:43PM +0800, d tbsky wrote:
> I wonder how many disks can a software raid6 array handled?

mdadm claims 256

# mdadm --create /dev/md42 --level=6 -n 999 ...
mdadm: no more than 256 raid-devices supported for level 6

Actually trying to create a RAID with that many, using 256*4M loop devices on tmpfs

# mdadm --create /dev/md42 --level=6 -n 256 /dev/loop{0..255}
mdadm: Defaulting to version 1.2 metadata
Segmentation fault

[  210.798267] md: bind<loop255>
[  210.798898] md/raid:md42: not clean -- starting background reconstruction
[  210.798909] divide error: 0000 [#1] SMP 
[  210.798925] CPU: 0 PID: 6397 Comm: mdadm Not tainted 4.5.5 #1
[  210.798937] Hardware name: MSI MS-7817/B85M-E45 (MS-7817), BIOS V10.9 04/21/2015
[  210.798953] task: ffff8800828dcec0 ti: ffff8803eced0000 task.ti: ffff8803eced0000
[  210.798968] RIP: 0010:[<ffffffff814602d1>]  [<ffffffff814602d1>] reciprocal_value+0x21/0x60
[  210.798989] RSP: 0018:ffff8803eced3bc8  EFLAGS: 00010247
[  210.799000] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000020
[  210.799015] RDX: 0000000000000000 RSI: 000000000000001f RDI: 0000000000000000
[  210.799029] RBP: 0000000000000080 R08: 00000000000154d8 R09: ffffffff81c708ad
[  210.799043] R10: ffffea000dadc500 R11: 0000000000000002 R12: 0000000000001020
[  210.799057] R13: 00000000024000c0 R14: 0000000000000100 R15: 0000000000000000
[  210.799071] FS:  0000000001b3e880(0063) GS:ffff88041ea00000(0000) knlGS:0000000000000000
[  210.799087] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  210.799098] CR2: 0000561aa6bbe068 CR3: 000000036b775000 CR4: 00000000001406f0
[  210.799112] Stack:
[  210.799118]  ffffffff8145aa0b ffff880082866000 0000000000000080 00000000024000c0
[  210.799135]  0000000000000100 0000000000000100 ffffffff81e6b9a0 ffffffff816fff88
[  210.799152]  ffff880082866000 ffffe8ffffa01a90 ffff8803defde000 ffffffff8170184c
[  210.799170] Call Trace:
[  210.799179]  [<ffffffff8145aa0b>] ? flex_array_alloc+0xbb/0xf0
[  210.799193]  [<ffffffff816fff88>] ? scribble_alloc+0x18/0x50
[  210.799231]  [<ffffffff8170184c>] ? alloc_scratch_buffer+0x7c/0x90
[  210.799253]  [<ffffffff817036d6>] ? setup_conf+0x3c6/0x800
[  210.799267]  [<ffffffff8117fd66>] ? printk+0x43/0x4b
[  210.799288]  [<ffffffff81704444>] ? raid5_run+0x854/0xad0
[  210.799311]  [<ffffffff8142d648>] ? __bioset_create+0x1c8/0x280
[  210.799346]  [<ffffffff81718eef>] ? md_run+0x27f/0x970
[  210.799368]  [<ffffffff81186c06>] ? free_hot_cold_page_list+0x26/0x40
[  210.799381]  [<ffffffff817195ea>] ? do_md_run+0xa/0xa0
[  210.799402]  [<ffffffff8171baae>] ? md_ioctl+0xe9e/0x1b60
[  210.799427]  [<ffffffff8119f5ae>] ? tlb_flush_mmu_free+0x2e/0x50
[  210.799429]  [<ffffffff811a0492>] ? tlb_finish_mmu+0x12/0x40
[  210.799430]  [<ffffffff811a669e>] ? unmap_region+0xbe/0xe0
[  210.799441]  [<ffffffff8143d7a7>] ? blkdev_ioctl+0x237/0x8c0
[  210.799443]  [<ffffffff811f0d74>] ? block_ioctl+0x34/0x40
[  210.799445]  [<ffffffff811d3568>] ? do_vfs_ioctl+0x88/0x590
[  210.799446]  [<ffffffff811a810d>] ? do_munmap+0x32d/0x450
[  210.799447]  [<ffffffff811d3aa6>] ? SyS_ioctl+0x36/0x70
[  210.799460]  [<ffffffff818b7e5b>] ? entry_SYSCALL_64_fastpath+0x16/0x6e
[  210.799479] Code: ff ff ff 0f 1f 80 00 00 00 00 8d 47 ff be ff ff ff ff 89 ff 0f bd f0 8d 4e 01 b8 01 00 00 00 31 d2 48 d3 e0 48 29 f8 48 c1 e0 20 <48> f7 f7 85 c9 ba 01 00 00 00 0f 4f ca 83 c0 01 ba 00 00 00 00 
[  210.799480] RIP  [<ffffffff814602d1>] reciprocal_value+0x21/0x60
[  210.799481]  RSP <ffff8803eced3bc8>
[  210.805216] ---[ end trace c271c2a4daa3678c ]---

So that didn't work too well.

> the LSI hardware raid (2208/3108) can only put 32 disks in an array

I would be a little suprised if there was a 32 disk limit.

The question is whether you really want that many disks in a single array.

After all, the more disks, the more likely you have more than one disk fail, 
due to various causes (not just the disk itself, also cable problems, etc.)
Do you test your disks regularly? md raid checks, smart self tests, do you 
actually replace them when they start reallocating sectors, ...?

Do you want everything to be gone when the raid fails or just half? ;)

I'm not sure if I'd be comfortable with more than ~24 disks in a raid6.

> in the future, maybe add another 20 disks into the array

If you have 20 disks now you could create a 20 disk raid6 now; 
if you add 20 disks later you can choose... grow by 20? or just 
create another 20 disk raid set. I think I'd go for the latter.

But it's a personal choice. You have to make it yourself. 
Just make sure you have good monitoring for your disks, 
if you don't detect disk errors early, raid redundancy might not save you.

Regards
Andreas Klauer
