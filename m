From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 002 of 2] md: Improve the is_mddev_idle test
Date: Thu, 10 May 2007 00:33:04 -0700
Message-ID: <20070510003304.c5fc35d2.akpm@linux-foundation.org>
References: <20070510161940.20204.patches@notabene>
	<1070510062231.20403@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759749AbXEJHd1@vger.kernel.org>
In-Reply-To: <1070510062231.20403@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 10 May 2007 16:22:31 +1000 NeilBrown <neilb@suse.de> wrote:

> The test currently looks for any (non-fuzz) difference, either
> positive or negative.  This clearly is not needed.  Any non-sync
> activity will cause the total sectors to grow faster than the sync_io
> count (never slower) so we only need to look for a positive differences.
> 
> ...
>
> --- .prev/drivers/md/md.c	2007-05-10 15:51:54.000000000 +1000
> +++ ./drivers/md/md.c	2007-05-10 16:05:10.000000000 +1000
> @@ -5095,7 +5095,7 @@ static int is_mddev_idle(mddev_t *mddev)
>  		 *
>  		 * Note: the following is an unsigned comparison.
>  		 */
> -		if ((curr_events - rdev->last_events + 4096) > 8192) {
> +		if ((long)curr_events - (long)rdev->last_events > 4096) {
>  			rdev->last_events = curr_events;
>  			idle = 0;

In which case would unsigned counters be more appropriate?
