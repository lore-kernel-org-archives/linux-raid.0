From: yizhan <yizhan@redhat.com>
Subject: Re: [PATCH 1/3] MD: hold mddev lock for .quiesce in md_do_sync
Date: Sun, 31 Jul 2016 14:03:00 +0800
Message-ID: <a6b89dc2-6a4e-3d4d-0f9a-577f147e8a95@redhat.com>
References: <515fa68e5c4784b08f2ce99c082c923f6b02a3c9.1469922791.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <515fa68e5c4784b08f2ce99c082c923f6b02a3c9.1469922791.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org, linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

I tested these patch and fixed the bug I reported before[1].

[1] WARNING: CPU: 4 PID: 10512 at drivers/md/raid5-cache.c:728 
r5l_do_reclaim+0x415/0x430 [raid456]

Thanks

Yi Zhang


On 07/31/2016 07:54 AM, shli@kernel.org wrote:
> From: Shaohua Li <shli@fb.com>
>
> .quiesce is called with mddev lock hold at most places. There are few
> exceptions. Calling .quesce without the lock hold could create races. For
> example, the .quesce of raid1 can't be recursively. The purpose of the patches
> is to fix a race in raid5-cache. The raid5-cache .quesce will write md
> superblock and should be called with mddev lock hold.
>
> Cc: NeilBrown <neilb@suse.com>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>   drivers/md/md.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 2c3ab6f..0550445 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7945,8 +7945,10 @@ void md_do_sync(struct md_thread *thread)
>   		 * region.
>   		 */
>   		if (mddev->bitmap) {
> +			mddev_lock_nointr(mddev);
>   			mddev->pers->quiesce(mddev, 1);
>   			mddev->pers->quiesce(mddev, 0);
> +			mddev_unlock(mddev);
>   		}
>   	}
>   

