From: Stefan Borggraefe <stefan@spybot.info>
Subject: Re: Help with recovering a RAID5 array
Date: Fri, 10 May 2013 12:14:36 +0200
Message-ID: <2377905.mzbW0zKCvF@chablis>
References: <34199580.p6EyCyMeIZ@chablis> <20130506163102.066b9264@notabene.brown> <4918514.Nmbo5VakCk@chablis>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4918514.Nmbo5VakCk@chablis>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>, Ole Tange <tange@binf.ku.dk>
List-Id: linux-raid.ids

Am Montag, 6. Mai 2013, 10:12:42 schrieb Stefan Borggraefe:
> Am Montag, 6. Mai 2013, 16:31:02 schrieb NeilBrown:
> > Did you stop the array first?
> > 
> >   i.e.
> >   
> >     mdadm --stop /dev/md126
> >     mdadm -Asfvv
> > 
> > NeilBrown
> 
> Thank you Neil, yes this was my mistake. I realised it in the meantime and
> am currently checking the file system using overlay files as suggested in
> 
> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID

fsck.ext4 -y -C 0 /dev/md126

ended with

[7543439.065625] Pid: 13706, comm: fsck.ext4 Tainted: G        W  O 3.2.0-37-
generic #58-Ubuntu
[7543439.065627] Call Trace:
[7543439.065629]  [<ffffffff81067f0f>] warn_slowpath_common+0x7f/0xc0
[7543439.065631]  [<ffffffff81067f6a>] warn_slowpath_null+0x1a/0x20
[7543439.065634]  [<ffffffffa00aea35>] init_stripe+0x245/0x270 [raid456]
[7543439.065637]  [<ffffffffa00b2772>] get_active_stripe+0x3a2/0x3c0 [raid456]
[7543439.065639]  [<ffffffff814e67d9>] ? mddev_bio_destructor+0x19/0x20
[7543439.065641]  [<ffffffff8108bbc0>] ? prepare_to_wait+0x60/0x90
[7543439.065644]  [<ffffffffa00b5b94>] make_request+0x194/0x430 [raid456]
[7543439.065646]  [<ffffffff813030d6>] ? throtl_find_tg+0x46/0x60
[7543439.065647]  [<ffffffff8108bd20>] ? add_wait_queue+0x60/0x60
[7543439.065650]  [<ffffffff814e5f10>] md_make_request+0xd0/0x200
[7543439.065652]  [<ffffffff8111b145>] ? mempool_alloc_slab+0x15/0x20
[7543439.065654]  [<ffffffff812f2264>] generic_make_request.part.50+0x74/0xb0
[7543439.065656]  [<ffffffff812f2678>] generic_make_request+0x68/0x70
[7543439.065658]  [<ffffffff812f2705>] submit_bio+0x85/0x110
[7543439.065660]  [<ffffffff811afa2a>] ? bio_alloc_bioset+0x5a/0xf0
[7543439.065662]  [<ffffffff811a997b>] submit_bh+0xeb/0x120
[7543439.065664]  [<ffffffff811ac615>] block_read_full_page+0x225/0x390
[7543439.065666]  [<ffffffff811b1700>] ? blkdev_get_blocks+0xd0/0xd0
[7543439.065668]  [<ffffffff811190e5>] ? add_to_page_cache_locked+0x85/0xa0
[7543439.065670]  [<ffffffff811b0dc8>] blkdev_readpage+0x18/0x20
[7543439.065672]  [<ffffffff8111967d>] 
do_generic_file_read.constprop.33+0x10d/0x440
[7543439.065675]  [<ffffffff8111a74f>] generic_file_aio_read+0xef/0x280
[7543439.065677]  [<ffffffff813bb14e>] ? tty_wakeup+0x3e/0x80
[7543439.065679]  [<ffffffff81178d8a>] do_sync_read+0xda/0x120
[7543439.065681]  [<ffffffff8129ee13>] ? security_file_permission+0x93/0xb0
[7543439.065683]  [<ffffffff81179211>] ? rw_verify_area+0x61/0xf0
[7543439.065684]  [<ffffffff811796f0>] vfs_read+0xb0/0x180
[7543439.065686]  [<ffffffff8117980a>] sys_read+0x4a/0x90
[7543439.065688]  [<ffffffff81665842>] system_call_fastpath+0x16/0x1b
[7543439.065689] ---[ end trace cce84f1e6de88596 ]---
[7543441.630145] quiet_error: 230464 callbacks suppressed

I think I will give up here and just start again with a clean RAID6 to copy 
the data onto anew.
-- 
Best regards,
Stefan Borggraefe
