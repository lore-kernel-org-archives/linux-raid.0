From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: [PATCH] md: check arrays is suspended in mddev_detach before call
 quiesce operations
Date: Sat, 7 Mar 2020 17:56:54 +0100
Message-ID: <3be8072d-cecc-d61c-6509-5094b1b24191@cloud.ionos.com>
References: <20200211101004.2993-1-guoqing.jiang@gmx.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200211101004.2993-1-guoqing.jiang@gmx.us>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ping ...

On 2/11/20 11:10 AM, Guoqing Jiang wrote:
> From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> 
> Don't call quiesce(1) and quiesce(0) if array is already suspended,
> otherwise in level_store, the array is writable after mddev_detach
> in below part though the intention is to make array writable after
> resume.
> 
> 	mddev_suspend(mddev);
> 	mddev_detach(mddev);
> 	...
> 	mddev_resume(mddev);
> 
> And it also causes calltrace as follows in [1].
> 
> [48005.653834] WARNING: CPU: 1 PID: 45380 at kernel/kthread.c:510 kthread_=
> park+0x77/0x90
> [...]
> [48005.653976] CPU: 1 PID: 45380 Comm: mdadm Tainted: G           OE     5=
> .4.10-arch1-1 #1
> [48005.653979] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M=
> ./J4105-ITX, BIOS P1.40 08/06/2018
> [48005.653984] RIP: 0010:kthread_park+0x77/0x90
> [48005.654015] Call Trace:
> [48005.654039]  r5l_quiesce+0x3c/0x70 [raid456]
> [48005.654052]  raid5_quiesce+0x228/0x2e0 [raid456]
> [48005.654073]  mddev_detach+0x30/0x70 [md_mod]
> [48005.654090]  level_store+0x202/0x670 [md_mod]
> [48005.654099]  ? security_capable+0x40/0x60
> [48005.654114]  md_attr_store+0x7b/0xc0 [md_mod]
> [48005.654123]  kernfs_fop_write+0xce/0x1b0
> [48005.654132]  vfs_write+0xb6/0x1a0
> [48005.654138]  ksys_write+0x67/0xe0
> [48005.654146]  do_syscall_64+0x4e/0x140
> [48005.654155]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [48005.654161] RIP: 0033:0x7fa0c8737497
> 
> [1]: https://bugzilla.kernel.org/show_bug.cgi?id=3D206161
> 
> Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> =2D--
>   drivers/md/md.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d3212d61e660..92c626b506d6 100644
> =2D-- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6076,7 +6076,7 @@ EXPORT_SYMBOL_GPL(md_stop_writes);
>   static void mddev_detach(struct mddev *mddev)
>   {
>   	md_bitmap_wait_behind_writes(mddev);
> -	if (mddev->pers && mddev->pers->quiesce) {
> +	if (mddev->pers && mddev->pers->quiesce && !mddev->suspended) {
>   		mddev->pers->quiesce(mddev, 1);
>   		mddev->pers->quiesce(mddev, 0);
>   	}
> =2D-
> 2.17.1
> 
