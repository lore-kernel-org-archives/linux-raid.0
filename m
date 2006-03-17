From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 010 of 13] md: Only checkpoint expansion progress
 occasionally.
Date: Thu, 16 Mar 2006 22:17:43 -0800
Message-ID: <20060316221743.71a21520.akpm@osdl.org>
References: <20060317154017.15880.patches@notabene>
	<1060317044814.16208@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1060317044814.16208@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> wrote:
>
> diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
>  --- ./drivers/md/raid5.c~current~	2006-03-17 11:48:58.000000000 +1100
>  +++ ./drivers/md/raid5.c	2006-03-17 11:48:58.000000000 +1100
>  @@ -1747,8 +1747,9 @@ static int make_request(request_queue_t 

That's a fairly complex function..

I wonder about this:

	spin_lock_irq(&conf->device_lock);
	if (--bi->bi_phys_segments == 0) {
		int bytes = bi->bi_size;

		if ( bio_data_dir(bi) == WRITE )
			md_write_end(mddev);
		bi->bi_size = 0;
		bi->bi_end_io(bi, bytes, 0);
	}
	spin_unlock_irq(&conf->device_lock);

bi_end_io() can be somewhat expensive.  Does it need to happen under the lock?
