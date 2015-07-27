From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 07/12] md-cluster: init suspend_list and suspend_lock
 early in join
Date: Mon, 27 Jul 2015 11:29:25 -0500
Message-ID: <55B65C65.2080108@suse.de>
References: <1436518453-12660-1-git-send-email-gqjiang@suse.com>
 <1436518883-12783-1-git-send-email-gqjiang@suse.com>
 <1436518883-12783-4-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1436518883-12783-4-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 07/10/2015 04:01 AM, Guoqing Jiang wrote:
> If the node just join the cluster, and receive the msg from other nodes
> before init suspend_list, it will cause kernel crash due to NULL pointer
> dereference, so move the initializations early to fix the bug.
>
> md-cluster: Joined cluster 3578507b-e0cb-6d4f-6322-696cd7b1b10c slot 3
> BUG: unable to handle kernel NULL pointer dereference at           (null)
> ... ... ...
> Call Trace:
> [<ffffffffa0444924>] process_recvd_msg+0x2e4/0x330 [md_cluster]
> [<ffffffffa0444a06>] recv_daemon+0x96/0x170 [md_cluster]
> [<ffffffffa045189d>] md_thread+0x11d/0x170 [md_mod]
> [<ffffffff810768c4>] kthread+0xb4/0xc0
> [<ffffffff8151927c>] ret_from_fork+0x7c/0xb0
> ... ... ...
> RIP  [<ffffffffa0443581>] __remove_suspend_info+0x11/0xa0 [md_cluster]
>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>

Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

> ---
>   drivers/md/md-cluster.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index b80a689..6f1ea3c 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -671,6 +671,8 @@ static int join(struct mddev *mddev, int nodes)
>   	if (!cinfo)
>   		return -ENOMEM;
>
> +	INIT_LIST_HEAD(&cinfo->suspend_list);
> +	spin_lock_init(&cinfo->suspend_lock);
>   	init_completion(&cinfo->completion);
>
>   	mutex_init(&cinfo->sb_mutex);
> @@ -736,9 +738,6 @@ static int join(struct mddev *mddev, int nodes)
>   		goto err;
>   	}
>
> -	INIT_LIST_HEAD(&cinfo->suspend_list);
> -	spin_lock_init(&cinfo->suspend_lock);
> -
>   	ret = gather_all_resync_info(mddev, nodes);
>   	if (ret)
>   		goto err;
>

-- 
Goldwyn
