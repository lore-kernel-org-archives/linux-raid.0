From: Martin Wilck <mwilck@arcor.de>
Subject: Re: [PATCH 3/3] DDF: compare_super_ddf: fix sequence number check
Date: Mon, 16 Sep 2013 21:53:06 +0200
Message-ID: <523761A2.303@arcor.de>
References: <1379191632-32719-1-git-send-email-mwilck@arcor.de> <1379191632-32719-3-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1379191632-32719-3-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

On 09/14/2013 10:47 PM, mwilck@arcor.de wrote:
> The sequence number check in compare_super_ddf was broken,
> anchor sequence number is always -1.
> 
> With this patch, mdadm will refuse to add a disk with non-matching
> sequence number.
> 
> This fixes Francis Moreau's problem reported with subject
> "mdadm 3.3 fails to kick out non fresh disk".
> 
> FIXME: More work is needed here. Currently mdadm won't even add the
> disk to the container, that's wrong. It should be added as a spare.
> ---
>  super-ddf.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/super-ddf.c b/super-ddf.c
> index 3673cb3..002b271 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -3892,10 +3892,10 @@ static int compare_super_ddf(struct supertype *st, struct supertype *tst)
>  	if (memcmp(first->anchor.guid, second->anchor.guid, DDF_GUID_LEN) != 0)
>  		return 2;
>  
> -	if (!be32_eq(first->anchor.seq, second->anchor.seq)) {
> -		dprintf("%s: sequence number mismatch %u/%u\n", __func__,
> -			be32_to_cpu(first->anchor.seq),
> -			be32_to_cpu(second->anchor.seq));
> +	if (!be32_eq(first->active->seq, second->active->seq)) {
> +		dprintf("%s: sequence number mismatch %u<->%u\n", __func__,
> +			be32_to_cpu(first->active->seq),
> +			be32_to_cpu(second->active->seq));
>  		return 3;
>  	}
>  	if (first->max_part != second->max_part ||

While the fix itself is certainly correct, I don't think any more that
this is the right thing to do. If we reject a disk in compare_super()
just because of a sequence number mismatch, we won't be able to handle
incremental scanning gracefully, because mdadm will never even try to
add it any more. This is exactly what Francis just noticed. However,
just ignoring the sequence number as the code did without the patch is
also incorrect, as Francis noted previously in the "fails to kick out
non fresh disk" thread.

The container loading code already has some logic to deal with different
sequence numbers during assembly (just pick the highest). In case of
incremental assembly, things get more complex. We must be prepared to
read the disk with the "best" (i.e. highest) meta data after other disk,
possibly after some subarrays have already been started. It is possible
that the new best meta data indicates failures previously loaded disks
and already started arrays.

I am still trying to understand exactly how mdadm, mdmon, and kernel
have to play together during incremental assembly in order to get this
right. I think most of this  should take place in mdmon/manager, but I
may be wrong about that.

Martin
