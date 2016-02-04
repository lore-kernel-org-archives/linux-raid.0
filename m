From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [mdadm PATCH 1/1] Fix some type comparison problems
Date: Thu, 04 Feb 2016 08:12:37 -0500
Message-ID: <wrfjzivgr54q.fsf@redhat.com>
References: <1454588811-3713-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1454588811-3713-1-git-send-email-xni@redhat.com> (Xiao Ni's
	message of "Thu, 4 Feb 2016 20:26:51 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, deepa.kernel@gmail.com
List-Id: linux-raid.ids

Xiao Ni <xni@redhat.com> writes:
> It complains when building on s390 and i686 platform.
>
> Signed-off-by : Xiao Ni <xni@redhat.com>

Hi Xiao,

The description needs to be a little clearer - something more like
"Change utime to unsigned int to be able to hold times until 2106."

> ---
>  Monitor.c | 2 +-
>  util.c    | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Monitor.c b/Monitor.c
> index f19c2e5..9a6cf7e 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -542,7 +542,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
>  		alert("NewArray", st->devname, NULL, ainfo);
>  	}
>  
> -	if (st->utime == array.utime &&
> +	if ((unsigned int)st->utime == array.utime &&
>  	    st->failed == array.failed_disks &&
>  	    st->working == array.working_disks &&
>  	    st->spare == array.spare_disks &&

Instead of the cast, please change the type in struct state.

> diff --git a/util.c b/util.c
> index 970d484..6e7d3fb 100644
> --- a/util.c
> +++ b/util.c
> @@ -1267,7 +1267,7 @@ struct supertype *guess_super_type(int fd, enum guess_types guess_type)
>  	 */
>  	struct superswitch  *ss;
>  	struct supertype *st;
> -	time_t besttime = 0;
> +	unsigned int besttime = 0;
>  	int bestsuper = -1;
>  	int i;

This one is fine.

Thanks,
Jes
