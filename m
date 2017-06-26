From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [BUG] md: oops sync_page_io+0x38/0x180
Date: Mon, 26 Jun 2017 11:57:15 +0800
Message-ID: <20170626035714.GA702@ming.t460p>
References: <20170623104744.GA5830@ming.t460p>
 <20170623111601.GB5830@ming.t460p>
 <20170623162410.ngf5o2o36axmc67p@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170623162410.ngf5o2o36axmc67p@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids

On Fri, Jun 23, 2017 at 09:24:10AM -0700, Shaohua Li wrote:
> On Fri, Jun 23, 2017 at 07:16:02PM +0800, Ming Lei wrote:
> > On Fri, Jun 23, 2017 at 06:47:44PM +0800, Ming Lei wrote:
> > > Hi,
> > > 
> > > When I boot a VM, the following kernel oops is triggerd:
> > > 
> > > [    4.850206] BUG: unable to handle kernel NULL pointer dereference at 00000000000006a0
> > > [    4.851131] IP: sync_page_io+0x38/0x180
> > > [    4.851445] PGD 2759bc067
> > > [    4.851446] P4D 2759bc067
> > > [    4.851621] PUD 277838067
> > > [    4.851835] PMD 0
> > > 
> > > [    4.852152] Oops: 0000 [#1] PREEMPT SMP
> > > [    4.852494] Dumping ftrace buffer:
> > > [    4.852758]    (ftrace buffer empty)
> > > [    4.853062] Modules linked in: nd_pmem psmouse serio_raw ahci libahci floppy nvme nvme_core ib_iser rdma_cm iw_cm ib_cm ib_core configfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi null_blk configs autofs4
> > > [    4.855190] CPU: 3 PID: 661 Comm: mdadm Not tainted 4.12.0-rc6.quiesce-v3-next-20170623-09867-ga73468728fd8 #248
> > > [    4.856310] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.10.2-0-g5f4c7b1-prebuilt.qemu-project.org 04/01/2014
> > > [    4.857458] task: ffffa33bf749b340 task.stack: ffffa667812e8000
> > > [    4.857992] RIP: 0010:sync_page_io+0x38/0x180
> > > [    4.858349] RSP: 0018:ffffa667812ebb18 EFLAGS: 00010297
> > > [    4.858804] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffd43fc9da2100
> > > [    4.859465] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffa33bf740d800
> > > [    4.860137] RBP: ffffa667812ebb50 R08: 0000000000000000 R09: 0000000000000000
> > > [    4.860774] R10: 0000000023386c39 R11: 0000000000000000 R12: ffffa33bf740d800
> > > [    4.861817] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000001
> > > [    4.863150] FS:  00007f0aa0304700(0000) GS:ffffa33bfac00000(0000) knlGS:0000000000000000
> > > [    4.864412] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [    4.865001] CR2: 00000000000006a0 CR3: 0000000276883000 CR4: 00000000003406e0
> > > [    4.865663] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > [    4.866332] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > [    4.867025] Call Trace:
> > > [    4.867178]  read_disk_sb.constprop.66+0x72/0xc0
> > > [    4.867572]  super_1_load+0xb7/0x7a0
> > > [    4.867897]  ? blkdev_get_by_dev+0x58/0x70
> > > [    4.868222]  ? lock_rdev+0x6c/0xb0
> > > [    4.868476]  md_import_device+0x187/0x230
> > > [    4.868851]  ? check_preemption_disabled+0x35/0x120
> > > [    4.869266]  add_new_disk+0xc2/0x760
> > > [    4.869541]  md_ioctl+0x1fc7/0x23a0
> > > [    4.869824]  ? __might_fault+0x67/0xd0
> > > [    4.870109]  ? autostart_arrays+0x710/0x710
> > > [    4.870451]  blkdev_ioctl+0x5b8/0xbd0
> > > [    4.870750]  block_ioctl+0x61/0x80
> > > [    4.871003]  ? blkdev_fallocate+0x240/0x240
> > > [    4.871371]  do_vfs_ioctl+0xb0/0x890
> > > [    4.871640]  ? check_preemption_disabled+0x35/0x120
> > > [    4.872061]  ? entry_SYSCALL_64_fastpath+0x5/0xc2
> > > [    4.872463]  ? __this_cpu_preempt_check+0x1c/0x20
> > > [    4.872867]  ? __fget_light+0x56/0xb0
> > > [    4.873148]  ? security_file_ioctl+0x62/0x80
> > > [    4.873498]  SyS_ioctl+0x94/0xc0
> > > [    4.873735]  entry_SYSCALL_64_fastpath+0x23/0xc2
> > > [    4.874121] RIP: 0033:0x7f0a9fe26687
> > > [    4.874391] RSP: 002b:00007ffca16ec628 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > > [    4.875105] RAX: ffffffffffffffda RBX: 00007ffca16efa6b RCX: 00007f0a9fe26687
> > > [    4.875779] RDX: 00007ffca16eca38 RSI: 0000000040140921 RDI: 0000000000000004
> > > [    4.876544] RBP: ffffffffa35cbbcc R08: 0000000000200000 R09: 0000000000000014
> > > [    4.877253] R10: 0000000000000361 R11: 0000000000000246 R12: ffffa667812ebf88
> > > [    4.877968] R13: 0000000000000004 R14: 00007ffca16ec8cd R15: 0000000001db35b0
> > > [    4.878657]  ? __this_cpu_preempt_check+0x1c/0x20
> > > [    4.879341] Code: 41 55 41 54 49 89 fc 53 49 89 f5 45 89 ce 48 83 ec 10 89 55 d0 48 89 4d c8 44 89 45 d4 44 8b 7d 10 e8 7d 63 91 ff 49 8b 44 24 18 <48> 8b 98 a0 06 00 00 48 85 db 0f 84 12 01 00 00 e8 63 63 91 ff
> > > [    4.885691] RIP: sync_page_io+0x38/0x180 RSP: ffffa667812ebb18
> > > [    4.886208] CR2: 00000000000006a0
> > > [    4.886441] ---[ end trace 5e7fbbf3076a4aab ]---
> > 
> > Looks this oops is caused by the following patch:
> > 
> > 	5a85071c2cbc md: use a separate bio_set for synchronous IO.
> > 
> > Once it is reverted, my VM boots successfully without this oops.
> 
> Thanks for the report, this should fix it:
> 
> 
> commit 7f053a6a745557b3f3ad63e9d28ba85c3c0b1563
> Author: Shaohua Li <shli@fb.com>
> Date:   Fri Jun 23 09:19:49 2017 -0700
> 
>     MD: fix a null dereference
>     
>     rdev->mddev could be null in start time.
>     
>     Reported-by: Ming Lei <ming.lei@redhat.com>
>     Fix: 5a85071c2cbc(md: use a separate bio_set for synchronous IO.)
>     Cc: NeilBrown <neilb@suse.com>
>     Signed-off-by: Shaohua Li <shli@fb.com>
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 65ad837aeb54..092b48f8095e 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -205,7 +205,7 @@ EXPORT_SYMBOL_GPL(bio_alloc_mddev);
>  
>  static struct bio *md_bio_alloc_sync(struct mddev *mddev)
>  {
> -	if (!mddev->sync_set)
> +	if (!mddev || !mddev->sync_set)
>  		return bio_alloc(GFP_NOIO, 1);
>  
>  	return bio_alloc_bioset(GFP_NOIO, 1, mddev->sync_set);
> --

Looks this patch fixes the issue.

Tested-by: Ming Lei <ming.lei@redhat.com>

Thanks, 
Ming
