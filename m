From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] MD: raid1, fix BUG caused by flags handling
Date: Thu, 12 Aug 2010 14:06:41 +0200
Message-ID: <4C63E3D1.1010800@gmail.com>
References: <1281614465-2816-1-git-send-email-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1281614465-2816-1-git-send-email-jslaby@suse.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>
Cc: neilb@suse.de, akpm@linux-foundation.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-raid.ids

On 08/12/2010 02:01 PM, Jiri Slaby wrote:
> Commit 74450be1 (block: unify flags for struct bio and struct request)

Actually there are more than the two below introduced by the commit.
Hold on, I will post v2.

> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -787,8 +787,8 @@ static int make_request(mddev_t *mddev, struct bio * bio)
>  	struct bio_list bl;
>  	struct page **behind_pages = NULL;
>  	const int rw = bio_data_dir(bio);
> -	const bool do_sync = (bio->bi_rw & REQ_SYNC);
> -	bool do_barriers;
> +	const unsigned long do_sync = (bio->bi_rw & REQ_SYNC);
> +	unsigned long do_barriers;
>  	mdk_rdev_t *blocked_rdev;
>  
>  	/*


-- 
js
