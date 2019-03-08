From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH] md: Fix failed allocation of md_register_thread
Date: Fri, 8 Mar 2019 11:12:40 +0800
Message-ID: <854b0e4a-35e4-4666-5d05-c1f9ffaceae8@suse.com>
References: <20190304224854.12494-1-pakki001@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190304224854.12494-1-pakki001@umn.edu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Aditya Pakki <pakki001@umn.edu>
Cc: kjlu@umn.edu, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



On 3/5/19 6:48 AM, Aditya Pakki wrote:
> mddev->sync_thread can be set to NULL on kzalloc failure downstream.
> The patch checks for such a scenario and frees allocated resources.
>
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---
>   drivers/md/raid10.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index abb5d382f64d..f52b4d9bcd24 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -3939,6 +3939,8 @@ static int raid10_run(struct mddev *mddev)
>   		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
>   		mddev->sync_thread = md_register_thread(md_do_sync, mddev,
>   							"reshape");
> +		if (!mddev->sync_thread)
> +			goto out_free_conf;
>   	}
>   
>   	return 0;

Could you make the change for raid5 as well? It also doesn't check the 
failure
in raid5_run.

Thanks,
Guoqing
