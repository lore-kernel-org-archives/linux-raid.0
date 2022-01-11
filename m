Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71D09C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 11 Jan 2022 14:06:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239829AbiAKOGY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 Jan 2022 09:06:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238129AbiAKOGX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 11 Jan 2022 09:06:23 -0500
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF238C06173F
        for <linux-raid@vger.kernel.org>; Tue, 11 Jan 2022 06:06:22 -0800 (PST)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by rin.romanrm.net (Postfix) with SMTP id 09F1C666;
        Tue, 11 Jan 2022 14:06:17 +0000 (UTC)
Date:   Tue, 11 Jan 2022 19:06:17 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org
Subject: Re: [RFC PATCH] Add wrappers for singular/plural form generation
Message-ID: <20220111190617.6e01747f@nvm>
In-Reply-To: <20220111134145.28695-1-mateusz.grzonka@intel.com>
References: <20220111134145.28695-1-mateusz.grzonka@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 11 Jan 2022 14:41:45 +0100
Mateusz Grzonka <mateusz.grzonka@intel.com> wrote:

> Replace ternary operators checking for plural forms of words: "drive",
> "spare" and "disk" by wrappers.

As I understand the aim was for a limited scope change making the code
nicer to read.

But going a bit further, did you consider making the new function just return
a ready-to-use "5 drives" string, and also getting rid of the explicit "%d" in
front of it everywhere?

The "sorp" name is puzzling at first, but I don't know maybe that's a
convention somewhere.

> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
> ---
>  Assemble.c    | 20 ++++++++++----------
>  Grow.c        | 12 ++++++------
>  Query.c       |  6 +++---
>  mdadm.h       | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  super-intel.c |  9 +++++----
>  5 files changed, 74 insertions(+), 23 deletions(-)
> 
> diff --git a/Assemble.c b/Assemble.c
> index 704b8293..7e1c3e64 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1126,9 +1126,9 @@ static int start_array(int mdfd,
>  	if (content->array.level == LEVEL_CONTAINER) {
>  		sysfs_rules_apply(mddev, content);
>  		if (c->verbose >= 0) {
> -			pr_err("Container %s has been assembled with %d drive%s",
> +			pr_err("Container %s has been assembled with %d %s",
>  			       mddev, okcnt + sparecnt + journalcnt,
> -			       okcnt + sparecnt + journalcnt == 1 ? "" : "s");
> +			       sorp_drive(okcnt + sparecnt + journalcnt));
>  			if (okcnt < (unsigned)content->array.raid_disks)
>  				fprintf(stderr, " (out of %d)\n",
>  					content->array.raid_disks);
> @@ -1219,9 +1219,9 @@ static int start_array(int mdfd,
>  						sparecnt?",":" and",
>  						rebuilding_cnt);
>  				if (sparecnt)
> -					fprintf(stderr, " and %d spare%s",
> +					fprintf(stderr, " and %d %s",
>  						sparecnt,
> -						sparecnt == 1 ? "" : "s");
> +						sorp_spare(sparecnt));
>  				if (content->journal_clean)
>  					fprintf(stderr, " and %d journal",
>  						journalcnt);
> @@ -1300,8 +1300,8 @@ static int start_array(int mdfd,
>  		return 1;
>  	}
>  	if (c->runstop == -1) {
> -		pr_err("%s assembled from %d drive%s",
> -		       mddev, okcnt, okcnt == 1 ? "" : "s");
> +		pr_err("%s assembled from %d %s",
> +		       mddev, okcnt, sorp_drive(okcnt));
>  		if (okcnt != (unsigned)content->array.raid_disks)
>  			fprintf(stderr, " (out of %d)",
>  				content->array.raid_disks);
> @@ -1309,14 +1309,14 @@ static int start_array(int mdfd,
>  		return 2;
>  	}
>  	if (c->verbose >= -1) {
> -		pr_err("%s assembled from %d drive%s",
> -		       mddev, okcnt, okcnt == 1 ? "" : "s");
> +		pr_err("%s assembled from %d %s",
> +		       mddev, okcnt, sorp_drive(okcnt));
>  		if (rebuilding_cnt)
>  			fprintf(stderr, "%s %d rebuilding",
>  				sparecnt ? "," : " and", rebuilding_cnt);
>  		if (sparecnt)
> -			fprintf(stderr, " and %d spare%s", sparecnt,
> -				sparecnt == 1 ? "" : "s");
> +			fprintf(stderr, " and %d %s", sparecnt,
> +				sorp_spare(sparecnt));
>  		if (!enough(content->array.level, content->array.raid_disks,
>  			    content->array.layout, 1, avail))
>  			fprintf(stderr, " - not enough to start the array.\n");
> diff --git a/Grow.c b/Grow.c
> index 9c6fc95e..fa7325f7 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1950,10 +1950,10 @@ int Grow_reshape(char *devname, int fd,
>  	    array.spare_disks + added_disks <
>  	    (s->raiddisks - array.raid_disks) &&
>  	    !c->force) {
> -		pr_err("Need %d spare%s to avoid degraded array, and only have %d.\n"
> +		pr_err("Need %d %s to avoid degraded array, and only have %d.\n"
>  		       "       Use --force to over-ride this check.\n",
>  		       s->raiddisks - array.raid_disks,
> -		       s->raiddisks - array.raid_disks == 1 ? "" : "s",
> +		       sorp_spare(s->raiddisks - array.raid_disks),
>  		       array.spare_disks + added_disks);
>  		return 1;
>  	}
> @@ -3136,10 +3136,10 @@ static int reshape_array(char *container, int fd, char *devname,
>  
>  	if (!force && info->new_level > 1 && info->array.level > 1 &&
>  	    spares_needed > info->array.spare_disks + added_disks) {
> -		pr_err("Need %d spare%s to avoid degraded array, and only have %d.\n"
> +		pr_err("Need %d %s to avoid degraded array, and only have %d.\n"
>  		       "       Use --force to over-ride this check.\n",
>  		       spares_needed,
> -		       spares_needed == 1 ? "" : "s",
> +		       sorp_spare(spares_needed),
>  		       info->array.spare_disks + added_disks);
>  		goto release;
>  	}
> @@ -3149,8 +3149,8 @@ static int reshape_array(char *container, int fd, char *devname,
>  		- array.raid_disks;
>  	if ((info->new_level > 1 || info->new_level == 0) &&
>  	    spares_needed > info->array.spare_disks +added_disks) {
> -		pr_err("Need %d spare%s to create working array, and only have %d.\n",
> -		       spares_needed, spares_needed == 1 ? "" : "s",
> +		pr_err("Need %d %s to create working array, and only have %d.\n",
> +		       spares_needed, sorp_spare(spares_needed),
>  		       info->array.spare_disks + added_disks);
>  		goto release;
>  	}
> diff --git a/Query.c b/Query.c
> index 23fbf8aa..630ad2ff 100644
> --- a/Query.c
> +++ b/Query.c
> @@ -91,10 +91,10 @@ int Query(char *dev)
>  		printf("%s: is an md device, but gives \"%s\" when queried\n",
>  		       dev, strerror(ioctlerr));
>  	else {
> -		printf("%s: %s %s %d devices, %d spare%s. Use mdadm --detail for more detail.\n",
> +		printf("%s: %s %s %d %s, %d %s. Use mdadm --detail for more detail.\n",
>  		       dev, human_size_brief(larray_size,IEC),
> -		       map_num(pers, level), raid_disks,
> -		       spare_disks, spare_disks == 1 ? "" : "s");
> +		       map_num(pers, level), raid_disks, sorp_drive(raid_disks),
> +		       spare_disks, sorp_spare(spare_disks));
>  	}
>  	st = guess_super(fd);
>  	if (st && st->ss->compare_super != NULL)
> diff --git a/mdadm.h b/mdadm.h
> index c7268a71..129da587 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -808,6 +808,56 @@ static inline void close_fd(int *fd)
>  		*fd = -1;
>  }
>  
> +/**
> + * sorp() - Decides whether to use singular or plural word form.
> + * @singular: Word in a singular form.
> + * @plural: Word in a plural form.
> + * @count: Number of objects being concerned.
> + *
> + * Depending on @count function decides whether to use singular or plural form.
> + *
> + * Return: Pointer to either singular or plural form provided.
> + */
> +static inline char *sorp(char *singular, char *plural, int count)
> +{
> +	if (count < 2)
> +		return singular;
> +	return plural;
> +}
> +
> +/**
> + * sorp_drive() - Decides whether to use singular or plural form for "drive"
> + * @count: Number of drives.
> + *
> + * Return: Pointer to string containing either singular or plural form of "drive"
> + */
> +static inline char *sorp_drive(int count)
> +{
> +	return sorp("drive", "drives", count);
> +}
> +
> +/**
> + * sorp_disk() - Decides whether to use singular or plural form for "disk"
> + * @count: Number of disks.
> + *
> + * Return: Pointer to string containing either singular or plural form of "disk"
> + */
> +static inline char *sorp_disk(int count)
> +{
> +	return sorp("disk", "disks", count);
> +}
> +
> +/**
> + * sorp_spare() - Decides whether to use singular or plural form for "spare"
> + * @count: Number of spares.
> + *
> + * Return: Pointer to string containing either singular or plural form of "spare"
> + */
> +static inline char *sorp_spare(int count)
> +{
> +	return sorp("spare", "spares", count);
> +}
> +
>  struct active_array;
>  struct metadata_update;
>  
> diff --git a/super-intel.c b/super-intel.c
> index d5fad102..64d11e8f 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -7267,8 +7267,9 @@ validate_geometry_imsm_orom(struct intel_super *super, int level, int layout,
>  
>  	/* capabilities of OROM tested - copied from validate_geometry_imsm_volume */
>  	if (!is_raid_level_supported(super->orom, level, raiddisks)) {
> -		pr_vrb("platform does not support raid%d with %d disk%s\n",
> -			level, raiddisks, raiddisks > 1 ? "s" : "");
> +		pr_vrb("platform does not support raid%d with %d %s\n",
> +			level, raiddisks,
> +			sorp_disk(raiddisks));
>  		return 0;
>  	}
>  
> @@ -11213,10 +11214,10 @@ static int imsm_reshape_is_allowed_on_container(struct supertype *st,
>  			if (!is_raid_level_supported(super->orom,
>  						     member->array.level,
>  						     geo->raid_disks)) {
> -				dprintf("platform does not support raid%d with %d disk%s\n",
> +				dprintf("platform does not support raid%d with %d %s\n",
>  					 info->array.level,
>  					 geo->raid_disks,
> -					 geo->raid_disks > 1 ? "s" : "");
> +					 sorp_disk(geo->raid_disks));
>  				break;
>  			}
>  			/* check if component size is aligned to chunk size


-- 
With respect,
Roman
