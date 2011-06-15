From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v2 1/5] md/raid10: optimize read_balance() for 'far
 offset' arrays
Date: Wed, 15 Jun 2011 12:57:15 +1000
Message-ID: <20110615125715.33eb0c3e@notabene.brown>
References: <1308103324-2375-1-git-send-email-namhyung@gmail.com>
	<1308103324-2375-2-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1308103324-2375-2-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 15 Jun 2011 11:02:00 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> If @conf->far_offset > 0, there is only 1 stripe so that we can treat
> the array same as 'near' arrays.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  drivers/md/raid10.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 6e846688962f..fc56bdd8c3fb 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -531,7 +531,7 @@ retry:
>  			break;
>  
>  		/* for far > 1 always use the lowest address */
> -		if (conf->far_copies > 1)
> +		if (conf->far_copies > 1 && conf->far_offset == 0)
>  			new_distance = r10_bio->devs[slot].addr;
>  		else
>  			new_distance = abs(r10_bio->devs[slot].addr -


Hi,
 I realise that I said before that this part was OK but having thought about
 it some more I am not convinced.
 Using the 'distance' from were the head previously was is a fairly poor
 heuristic.  In some cases it is the best we have, but it still isn't good.

 With an 'offset' layout, like with a 'far' layout, sections of the array are
 in a RAID0 layout and we know that reading from a RAID0 gives good speed by
 algorithmically distributing the reads evenly over all the devices.

 Setting new_distance to the 'addr' means that we use the algorithmic
 approach to distribute reads.  Setting it to the difference between addr and
 head_position uses the heuristic approach.

 I much prefer the algorithmic (RAID0) approach were it is possible.  So I'm
 not going to apply this patch.  However if you can demonstrate real speedups
 in some realist test I will reconsider my position.

Thanks,
NeilBrown

