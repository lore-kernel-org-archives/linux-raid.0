From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Severe, huge data corruption with softraid
Date: Thu, 3 Mar 2005 04:01:08 +0100
Message-ID: <k8bif2-qfd.ln1@news.it.uc3m.es>
References: <42264AF4.4000600@tls.msk.ru> <42265307.5040400@tls.msk.ru> <nc3if2-utt.ln1@news.it.uc3m.es> <42266738.3050809@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev <mjt@tls.msk.ru> wrote:
> >>Unable to handle kernel paging request at virtual address f8924690
> > 
> > That address is bogus. Looks more like a negative integer. I suppose
> > ram corruption is a posibility too.
> 
> Ram corruption in what sense?  Faulty DIMM?

Anything.

> Well, it indeed is possible, everything is possible.  This is 2Gb
> of ECC memory (2x512 and 4x256 modules in 6 banks) from Kingston,
> ValueRam I think (the expensive one, that is ;)

It that case the corruption, if it is so, will originate in overheated
cpu, bus, or bridge, rather than the ram itself. Or disk, disk
controller, etc.

> The machine is on UPS, and power is very stable here too.
> 
> >>  printing eip:
> >>f8924690
> >>*pde = 02127067
> >>*pte = 00000000
> >>Oops: 0000 [#1]
> >>SMP
> >>Modules linked in: raid10 nfsd exportfs raid5 xor nfs lockd sunrpc 8250 serial_core w83627hf i2c_sensor
> >>i2c_isa i2c_core e1000 genrtc ext3 jbd mbcache raid1 sd_mod md aic79xx scsi_mod
> >>CPU:    1
> >>EIP:    0060:[<f8924690>]    Not tainted VLI
> >>EFLAGS: 00010286   (2.6.9-i686smp-0)
> >>EIP is at 0xf8924690
> >>eax: ecd04028   ebx: c99ead40   ecx: c21dc380   edx: c99ead40
> >>esi: ecd04028   edi: f8924690   ebp: c21dc380   esp: f1d39cac
> >>ds: 007b   es: 007b   ss: 0068
> >>Process dio (pid: 21941, threadinfo=f1d39000 task=f7d40890)
> >>Stack: c015b5dd c99ead40 c10063a0 00001000 00000000 c015b64c 00001000 00000000
> >>        f7d23800 00000000 c01778f2 00000000 f7d23800 c017798d f7d23800 c10063a0
> >>        c0177a4e 00000000 00000001 00000000 f7d2384c f7d23800 c0177e78 00001000
> > 
> > Code?
> 
> Hmm?

You didn't quote the code listing from the oops printout.

> I'm terrible sorry but I never tried to go that deep.  I just don't know
> what you mean here.  Well, maybe I know what did you mean, but I don't know
> how to convert that series of hex numbers into something sensitive... ;)

It's not THOSE but thers I was referring to.

> >>Call Trace:
> >>  [<c015b5dd>] __bio_add_page+0x13d/0x180
> > 
> > 3/4 of the way through.
> > 
> >>  [<c015b64c>] bio_add_page+0x2c/0x40
> >>  [<c01778f2>] dio_bio_add_page+0x22/0x70
> >>  [<c017798d>] dio_send_cur_page+0x4d/0xa0
> >>  [<c0177a4e>] submit_page_section+0x6e/0x140
> >>  [<c0177e78>] do_direct_IO+0x288/0x380
> > 
> > That looks the relevant entry.
> 
> And what to do with it?

Nothing. Look at the code for a clue maybe. Anyway, it's nothing to do
with RAID.

> >>  [<c0178164>] direct_io_worker+0x1f4/0x520
> >>  [<c017869d>] __blockdev_direct_IO+0x20d/0x308
> >>  [<c015d770>] blkdev_get_blocks+0x0/0x70
> >>  [<c015d83f>] blkdev_direct_IO+0x5f/0x80
> >>  [<c015d770>] blkdev_get_blocks+0x0/0x70
> >>  [<c013c304>] generic_file_direct_IO+0x74/0x90
> >>  [<c013b352>] generic_file_direct_write+0x62/0x170
> >>  [<c016f7cb>] inode_update_time+0xbb/0xc0
> >>  [<c013bcfe>] generic_file_aio_write_nolock+0x2ce/0x490
> >>  [<c013bf51>] generic_file_write_nolock+0x91/0xc0
> >>  [<c011ae9e>] scheduler_tick+0x16e/0x470
> >>  [<c0115135>] smp_apic_timer_interrupt+0x85/0xf0
> >>  [<c011c850>] autoremove_wake_function+0x0/0x50
> >>  [<c015e6c0>] blkdev_file_write+0x0/0x30
> >>  [<c015e6e0>] blkdev_file_write+0x20/0x30
> >>  [<c0156770>] vfs_write+0xb0/0x110
> >>  [<c0156897>] sys_write+0x47/0x80
> >>  [<c010603f>] syscall_call+0x7/0xb
> >>Code:  Bad EIP value.
> > 
> > More info needed.
> 
> The question is: how? ;)

There should be a bit of the oops where it shows you the code fragment.

But it doesn't look very informative. It's a straight DIO write that
oopsed.

Peter 

