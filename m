From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] md - 2 of 10 - Don't allow raid5 rebuild to swamp raid5
 stripe cache
Date: Thu, 15 Jan 2004 17:33:17 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040115173317.3a356afc.akpm@osdl.org>
References: <E1AhIe9-0002U2-00@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1AhIe9-0002U2-00@notabene>
To: NeilBrown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@cse.unsw.edu.au> wrote:
>
> +	if (sh == NULL) {
> +		sh = get_active_stripe(conf, sector_nr, pd_idx, 0);
> +		/* make sure we don't swamp the stripe cache if someone else
> +		 * is trying to get access 
> +		 */
> +		yield();
> +	}

In 2.6, yield() has utterly awful behaviour when there are a lot of other
runnable tasks.

Have you tested this when the kernel is busy doing other stuff, like a
`make -j2' or a few busywait loops?  You might find that rebuild simply
stops.


