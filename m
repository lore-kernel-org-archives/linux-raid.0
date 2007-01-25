From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: change strip_cache_size freeze the whole raid
Date: Wed, 24 Jan 2007 19:16:14 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0701241915550.4070@p34.internal.lan>
References: <001801c73e14$c3177170$28df0f3d@kylecea1512a3f>
 <17845.7488.24108.298825@notabene.brown> <Pine.LNX.4.64.0701241822040.16771@p34.internal.lan>
 <17847.63039.766387.855859@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17847.63039.766387.855859@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: kyle <kylewong@southa.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 25 Jan 2007, Neil Brown wrote:

> On Wednesday January 24, jpiszcz@lucidpixels.com wrote:
> > Here you go Neil:
> > 
> > p34:~# echo 512 > /sys/block/md3/md/stripe_cache_size
> > p34:~# echo 1024 > /sys/block/md3/md/stripe_cache_size
> > p34:~# echo 2048 > /sys/block/md3/md/stripe_cache_size
> > p34:~# echo 4096 > /sys/block/md3/md/stripe_cache_size
> > p34:~# echo 8192 > /sys/block/md3/md/stripe_cache_size
> > <...... FROZEN ........> 
> > 
> > I ran echo t > /proc/sysrq-trigger and then copied the relevant parts of 
> > kern.log and I am attaching them to this e-mail.
> > 
> > Please confirm this is what you needed.
> 
> Perfect.  Thanks.
> 
> This bit:
> 
>    574	Jan 24 18:22:21 p34 kernel: [273475.825645] bash          D C7BEBAAC     0 16821  16820                     (NOTLB)
>    575	Jan 24 18:22:21 p34 kernel: [273475.825653]        c7bebac0 00000082 00000002 c7bebaac c7bebaa8 00000000 5b48e428 c6cdc560 
>    576	Jan 24 18:22:21 p34 kernel: [273475.825665]        c7bebad8 00010b03 00000011 00000009 cb093a53 0000f8b2 00017216 c6cdc66c 
>    577	Jan 24 18:22:21 p34 kernel: [273475.825838]        c1fe3280 00000001 c20c70c0 c3272058 f75c4a80 c7bebad8 c016a258 f7b12520 
>    578	Jan 24 18:22:21 p34 kernel: [273475.825850] Call Trace:
>    579	Jan 24 18:22:21 p34 kernel: [273475.825853]  [<c016a258>] dput+0x18/0x150
>    580	Jan 24 18:22:21 p34 kernel: [273475.825857]  [<c0161f84>] __link_path_walk+0xb04/0xc90
>    581	Jan 24 18:22:21 p34 kernel: [273475.825862]  [<c03600ad>] md_write_start+0x8d/0x120
>    582	Jan 24 18:22:21 p34 kernel: [273475.825867]  [<c012eac0>] autoremove_wake_function+0x0/0x50
>    583	Jan 24 18:22:21 p34 kernel: [273475.825871]  [<c03557a8>] make_request+0x38/0x560
>    584	Jan 24 18:22:21 p34 kernel: [273475.825876]  [<c02409ce>] xfs_log_move_tail+0x3e/0x1b0
>    585	Jan 24 18:22:21 p34 kernel: [273475.825881]  [<c023c9fa>] xfs_iomap+0x2ca/0x720
>    586	Jan 24 18:22:21 p34 kernel: [273475.825885]  [<c026d77a>] generic_make_request+0xda/0x150
>    587	Jan 24 18:22:21 p34 kernel: [273475.825890]  [<c026fe32>] submit_bio+0x72/0x110
>    588	Jan 24 18:22:21 p34 kernel: [273475.825895]  [<c013da6b>] mempool_alloc+0x2b/0xf0
>    589	Jan 24 18:22:21 p34 kernel: [273475.825899]  [<c034f1a0>] raid5_mergeable_bvec+0x0/0x90
>    590	Jan 24 18:22:21 p34 kernel: [273475.825904]  [<c017c052>] __bio_add_page+0x102/0x190
>    591	Jan 24 18:22:21 p34 kernel: [273475.825909]  [<c017c117>] bio_add_page+0x37/0x50
>    592	Jan 24 18:22:21 p34 kernel: [273475.826073]  [<c025be8b>] xfs_submit_ioend_bio+0x1b/0x30
>    593	Jan 24 18:22:21 p34 kernel: [273475.826078]  [<c025c10e>] xfs_page_state_convert+0x26e/0xff0
>    594	Jan 24 18:22:21 p34 kernel: [273475.826082]  [<c0155509>] slab_destroy+0x59/0x90
>    595	Jan 24 18:22:21 p34 kernel: [273475.826088]  [<c025d102>] xfs_vm_writepage+0x62/0x100
>    596	Jan 24 18:22:21 p34 kernel: [273475.826092]  [<c014396d>] shrink_inactive_list+0x5dd/0x8a0
>    597	Jan 24 18:22:21 p34 kernel: [273475.826097]  [<c0143cd1>] shrink_zone+0xa1/0x100
>    598	Jan 24 18:22:21 p34 kernel: [273475.826102]  [<c01447e0>] try_to_free_pages+0x140/0x260
>    599	Jan 24 18:22:21 p34 kernel: [273475.826106]  [<c013fb4f>] __alloc_pages+0x13f/0x2f0
>    600	Jan 24 18:22:21 p34 kernel: [273475.826111]  [<c0350dd3>] grow_one_stripe+0x93/0x100
>    601	Jan 24 18:22:21 p34 kernel: [273475.826115]  [<c0350ee6>] raid5_store_stripe_cache_size+0xa6/0xc0
>    602	Jan 24 18:22:21 p34 kernel: [273475.826120]  [<c0361a83>] md_attr_store+0x73/0x90
>    603	Jan 24 18:22:21 p34 kernel: [273475.826125]  [<c0192302>] sysfs_write_file+0xa2/0x100
>    604	Jan 24 18:22:21 p34 kernel: [273475.826129]  [<c01595f6>] vfs_write+0xa6/0x160
>    605	Jan 24 18:22:21 p34 kernel: [273475.826134]  [<c0192260>] sysfs_write_file+0x0/0x100
>    606	Jan 24 18:22:21 p34 kernel: [273475.826138]  [<c0159d31>] sys_write+0x41/0x70
>    607	Jan 24 18:22:21 p34 kernel: [273475.826303]  [<c0103138>] syscall_call+0x7/0xb
>    608	Jan 24 18:22:21 p34 kernel: [273475.826307]  =======================
> 
> Tells me what is happening.
> We try to allocate memory to increase the stripe cache (__alloc_pages)
> which requires memory to be freed, so shrink_zone gets called which
> calls into the 'xfs' filesystem which eventually trying to write to
> the raid5 array.  The raid5 array is currently 'clean' so we need to
> mark the superblock as dirty first (md_write_start), but that needs a
> lock that is being held while we grow the stripe cache.  Deadlock.
> 
> So the patch I posted (changing GFP_KERNEL to GFP_NOIO) will avoid
> this as it will then fail the allocation rather than initiate IO.
> However it might be better if I can find a way to avoid the
> deadlock....
> 
> I'll see what I can come up with.
> 
> Thanks,
> NeilBrown
> 

Okay-- thanks for the explanation and I will await a future patch..

Justin.
