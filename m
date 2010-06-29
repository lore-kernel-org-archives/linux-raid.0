From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm monitor spins with start-failed raid0
Date: Tue, 29 Jun 2010 16:44:22 +1000
Message-ID: <20100629164422.58af25c4@notabene.brown>
References: <20100628063433.GA4867@blorp.plorb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100628063433.GA4867@blorp.plorb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff DeFouw <jeffd@i2k.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 28 Jun 2010 02:34:33 -0400
Jeff DeFouw <jeffd@i2k.com> wrote:

> mdadm --monitor --scan (--oneshot) spins indefinitely without sleeping 
> when an "inactive" start-failed raid0 or linear array is found in 
> /proc/mdstat.  By "start-failed" I mean something attempts to 
> (automatically) assemble and start the array, but the array fails to 
> start.  In my case, an old raid0 is missing a disk.  The mdstat parser 
> assumes all entries have a personality string, but "inactive" arrays 
> don't.
> 
> md0 : inactive sda3[0]
>       2915712 blocks
> 
> The first disk (sda3[0] in this case) is copied as the level string.  
> The mismatch gets the raid0/linear array into the statelist, which is 
> immediately rejected by the statelist loop.  The rejection occurs 
> without marking the mdstat entry as used, so the array is seen as a new 
> entry again, the sleep/break is skipped, a new duplicate state is added 
> to the statelist, and the loop starts again immediately.
> 
> Fixing the parser is simple, but fixing it leads to Monitor ignoring ALL 
> inactive arrays discovered by mdstat.  This is because the mdstat loop 
> requires a level string.  If Monitor should process mdstat-discovered 
> start-failed arrays (as it currently does), then either the level will 
> have to be checked using GET_ARRAY_INFO, or raid0/linear arrays will 
> have to be rejected later.
> 
> This patch only shows how to fix the parser.

Hi Jeff,
 thanks for the patch.  I have queued it for the next release.

I think only the parse needs to be fixed.  mdadm has never been intended to
monitor inactive arrays because  - like linear and raid0 - nothing
interesting can happen to them.

Thanks a lot,
NeilBrown


> 
> ---
>  mdstat.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mdstat.c b/mdstat.c
> index 4a9f370..fdca877 100644
> --- a/mdstat.c
> +++ b/mdstat.c
> @@ -168,9 +168,10 @@ struct mdstat_ent *mdstat_read(int hold, int start)
>  			char *eq;
>  			if (strcmp(w, "active")==0)
>  				ent->active = 1;
> -			else if (strcmp(w, "inactive")==0)
> +			else if (strcmp(w, "inactive")==0) {
>  				ent->active = 0;
> -			else if (ent->active >=0 &&
> +				in_devs = 1;
> +			} else if (ent->active > 0 &&
>  				 ent->level == NULL &&
>  				 w[0] != '(' /*readonly*/) {
>  				ent->level = strdup(w);

