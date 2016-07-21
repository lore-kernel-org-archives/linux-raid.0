From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] mdcheck: Send progress messages to system log
Date: Thu, 21 Jul 2016 11:53:01 -0400
Message-ID: <wrfjlh0vj8de.fsf@redhat.com>
References: <1463497979.31691.7.camel@billmerriam.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1463497979.31691.7.camel@billmerriam.com> (Bill Merriam's
	message of "Tue, 17 May 2016 11:12:59 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Bill Merriam <lists@billmerriam.com>
Cc: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Bill Merriam <lists@billmerriam.com> writes:
> From 03bec5cfdd87f25b1669a4b62d19cf872403d37a Mon Sep 17 00:00:00 2001
> From: Bill Merriam <bill@merriam.net>
> Date: Tue, 17 May 2016 10:16:13 -0400
> Subject: [PATCH] The mdcheck script now adds messages to the system log
> to
>  report on progress of the array check.  These are issued when mdcheck
> starts
>  or continues a check and when it suspends a check at the expiration of
>  duration.  The messages either report the check has completed or the
> block
>  number of the current and last block in the array and the percentage of
>  completion.
>
> Signed-off-by: Bill Merriam <bill@merriam.net>
> ---
>  misc/mdcheck | 7 +++++++
>  1 file changed, 7 insertions(+)

Bill,

Principle of patch looks fine, but the formatting is all messed
up. Could you please try to clean it up a bit and resend it? If your
mail client auto-wraps it, please try sending it as an attachment.

In general code and comments should stay within 80 characters as with
the kernel.

Sorry for the late response, I missed your posting as I was traveling at
the time. Thanks to Neil for nagged me about it.

Cheers,
Jes

>
> diff --git a/misc/mdcheck b/misc/mdcheck
> index 2c8f54d..c33e3f6 100644
> --- a/misc/mdcheck
> +++ b/misc/mdcheck
> @@ -100,6 +100,8 @@ do
>  		continue
>  	else
>  		start=`cat "$fl"`
> +		size=$(expr $(cat $sys/md/component_size) \* 2)
> +		logger $(echo $dev $start $size | awk '{printf "MDCHECK Continuing
> check on %s at block %i of %i, %6.2f%% complete\n", $1, $2, $3,
> $2/$3*100 }')
>  	fi
>  
>  	cnt=$[cnt+1]
> @@ -129,6 +131,7 @@ do
>  		then
>  			eval MD_${i}_fl=
>  			rm -f $fl
> +			logger "MDCHECK check completed on ${sys##*/}, removing $fl"
>  			continue;
>  		fi
>  		read a rest < $sys/md/sync_completed
> @@ -156,4 +159,8 @@ do
>  	fi
>  	echo idle > $sys/md/sync_action
>  	cat $sys/md/sync_min > $fl
> +	dev=${sys##*/}
> +	start=$(cat $fl)
> +	size=$(expr $(cat $sys/md/component_size) \* 2)
> +	logger $(echo $dev $start $size | awk '{printf "MDCHECK Suspending
> check on %s at block %i of %i, %6.2f%% complete\n", $1, $2, $3,
> $2/$3*100 }')
>  done
