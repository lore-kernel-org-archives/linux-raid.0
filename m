From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] Allow level migration only for single-array container
Date: Wed, 19 Oct 2016 11:26:11 -0400
Message-ID: <wrfjy41kuzqk.fsf@redhat.com>
References: <1476275382-1566-1-git-send-email-mariusz.dabrowski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1476275382-1566-1-git-send-email-mariusz.dabrowski@intel.com>
        (Mariusz Dabrowski's message of "Wed, 12 Oct 2016 14:29:42 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Cc: linux-raid@vger.kernel.org, tomasz.majchrzak@intel.com, aleksey.obitotskiy@intel.com, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com, maksymilian.kunt@intel.com
List-Id: linux-raid.ids

Mariusz Dabrowski <mariusz.dabrowski@intel.com> writes:
> IMSM doesn't allow to change RAID level of array in container with two
> arrays but array count check is being done too late (after removing disks)
> and in some cases (e. g. RAID 0 and RAID 1 migrated to RAID 0) both arrays
> become degraded. This patch adds array count check before disks are being
> removed.
>
> Signed-off-by: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
> ---
>  Grow.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>
> diff --git a/Grow.c b/Grow.c
> index 628f0e7..bcd27f5 100755
> --- a/Grow.c
> +++ b/Grow.c
> @@ -777,6 +777,25 @@ int remove_disks_for_takeover(struct supertype *st,
>  	struct mdinfo *remaining;
>  	int slot;
>  
> +	if (st->ss->external) {
> +		int rv = 0;
> +		struct mdinfo *arrays = st->ss->container_content(st, NULL);
> +		/* containter_content returns list of arrays in container
> +		 * If arrays->next is not NULL it means that there are 2 arrays in
> +		 * container and operation should be blocked
> +		 */
> +		if (arrays) {
> +			if (arrays->next)
> +				rv = 1;
> +			sysfs_free(arrays);
> +			if (rv) {
> +				pr_err("Error. Cannot perform operation on /dev/%s\n", st->devnm);
> +				pr_err("For this operation it MUST be single array in container\n");
> +				return rv;
> +			}
> +		}
> +	}
> +

Applied, but do remember code is 80 characters wide - except for print
statements. I will fixup that comment line as part of applying it.

Thanks,
Jes
