From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH] md/raid5: Add compensation in sysfs for raid456.
Date: Tue, 14 Jan 2014 14:00:18 +0400
Message-ID: <52D50AB2.1080806@msgid.tls.msk.ru>
References: <201401141340162970440@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201401141340162970440@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

14.01.2014 09:40, majianpeng wrote:
> For non-fullstripe-write, raid456 need read some old data no matter how
> rcw or rmw. We use compensation to recored the value about the
> additional read-data.The unit of compenstaion is PAGE_SIZE.
> Using the formula compensation*PAGE_SIZE/write_count_for_md, we can know
> the efficiency.Using this we can tune the write mode to get the best
> efficiency.

Just a very small nitpick:

> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -494,6 +494,11 @@ struct r5conf {
>  	struct r5worker_group	*worker_groups;
>  	int			group_cnt;
>  	int			worker_cnt_per_group;
> +
> +	/*For non-fullstripe-write, it need read some data

Missing space in the comment ;)

/mjt
