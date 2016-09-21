From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH][RESEND] Fix RAID metadata check
Date: Wed, 21 Sep 2016 10:42:41 -0400
Message-ID: <wrfjoa3h9uvy.fsf@redhat.com>
References: <1473849811-29110-1-git-send-email-mariusz.dabrowski@intel.com>
        <1474442220-28895-1-git-send-email-mariusz.dabrowski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1474442220-28895-1-git-send-email-mariusz.dabrowski@intel.com>
        (Mariusz Dabrowski's message of "Wed, 21 Sep 2016 09:17:00 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Cc: linux-raid@vger.kernel.org, tomasz.majchrzak@intel.com, aleksey.obitotskiy@intel.com, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com, maksymilian.kunt@intel.com
List-Id: linux-raid.ids

Mariusz Dabrowski <mariusz.dabrowski@intel.com> writes:
> mdadm recognizes devices with partition table as part of an RAID array
> and invalid warning message is displayed. After this fix proper warning
> messages are being displayed for MBR/GPT disks and devices with RAID
> metadata.

A couple of issues here - in general please respect proper coding
style. This patch is a mess :(

> Signed-off-by: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
> ---
>  util.c | 28 +++++++++++++++++-----------
>  1 file changed, 17 insertions(+), 11 deletions(-)
>
> diff --git a/util.c b/util.c
> index c38ede7..5c845a0 100644
> --- a/util.c
> +++ b/util.c
> @@ -710,17 +710,23 @@ int check_raid(int fd, char *name)
>  
>  	if (!st)
>  		return 0;
> -	st->ss->load_super(st, fd, name);
> -	/* Looks like a raid array .. */
> -	pr_err("%s appears to be part of a raid array:\n",
> -		name);
> -	st->ss->getinfo_super(st, &info, NULL);
> -	st->ss->free_super(st);
> -	crtime = info.array.ctime;
> -	level = map_num(pers, info.array.level);
> -	if (!level) level = "-unknown-";
> -	cont_err("level=%s devices=%d ctime=%s",
> -		 level, info.array.raid_disks, ctime(&crtime));
> +	if (st->ss->add_to_super != NULL) {
> +		st->ss->load_super(st, fd, name);
> +		/* Looks like a raid array .. */
> +		pr_err("%s appears to be part of a raid array:\n",
> +			name);

Code lines are 80 characters - again when moving code around like this,
please do it properly.

> +		st->ss->getinfo_super(st, &info, NULL);
> +		st->ss->free_super(st);
> +		crtime = info.array.ctime;
> +		level = map_num(pers, info.array.level);
> +		if (!level) level = "-unknown-";

if () and action should never be on the same line. Yes I know it was in
the old code, but then please fix it up when you move it around.

> +		cont_err("level=%s devices=%d ctime=%s",
> +		level, info.array.raid_disks, ctime(&crtime));

The indentation here is not acceptable, please do it properly like you
would in the kernel too.

> +	}
> +	else {

Ehm?

> +		/* Looks like GPT or MBR */
> +		pr_err("partition table exists on %s\n", name);
> +	}
>  	return 1;
>  }

Cheers,
Jes
