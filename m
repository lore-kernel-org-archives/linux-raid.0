From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v2] RAID1: Avoid unnecessary loop to decrease
 conf->nr_queued in raid1d()
Date: Wed, 16 Nov 2016 22:36:32 +0800
Message-ID: <785b7474-2e3a-e423-08d7-26cb6136a235@suse.de>
References: <1479305968-18473-1-git-send-email-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1479305968-18473-1-git-send-email-colyli@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

ÔÚ 2016/11/16 ÏÂÎç10:19, Coly Li Ð´µÀ:
[snip]
> ---
>  drivers/md/raid1.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> Index: linux-raid1/drivers/md/raid1.c
> ===================================================================
> --- linux-raid1.orig/drivers/md/raid1.c
> +++ linux-raid1/drivers/md/raid1.c
> @@ -2387,17 +2387,17 @@ static void raid1d(struct md_thread *thr
[snip]
>  		while (!list_empty(&tmp)) {
>  			r1_bio = list_first_entry(&tmp, struct r1bio,
>  						  retry_list);
>  			list_del(&r1_bio->retry_list);
> +			spin_lock_irqsave(&conf->device_lock, flags);
> +			conf->nr_queued--;
> +			spin_unlock_irqrestore(&conf->device_lock, flags);
[snip]

Now I work on another 2 patches for a simpler I/O barrier, and a
lockless I/O submit on raid1, where conf->nr_queued will be in atomic_t.
So spin lock expense will not exist any more. Just FYI.

Coly


