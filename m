Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A4C3C433EF
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 10:52:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA53660FC1
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 10:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhJHKyh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Oct 2021 06:54:37 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17266 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbhJHKyh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Oct 2021 06:54:37 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1633690355; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=ZMyhz+WI7jW6qwhAeLJtIT9TsduxevZYO4chUUBZ3DHLOsrRglcv9NkdcWXoeZLKG8p1tfW3MRzKPMHePIXN/mbcj6MGFklLdir8vTOMzlNwN5Ty0dfzqhQdsyfzlnPRIqlCIzWHMKISYi84s09PImVVXTc+jdFFxf15ZmTl+OQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1633690355; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=XAz1P+Q8NG5eQf1pbIdxXzg1xj/xE57mXo8Gq6P81mk=; 
        b=NnBfzc2FUaTLBzkErryeOup9U7Zt/OSJVQJQ/W3o4ZTg32LGYyhBBsnEq1N3FuBXg6ytTMFbLqIt9+NwLaioJWixSYj+y9stgsfnw1icxgRADDrPbYtAN62IYAo4Qb91ravYRNWOP7QfT7W8tFaYIm8ChjXMGP362VBahyIKhrg=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [100.110.16.7] (163.114.131.1 [163.114.131.1]) by mx.zoho.eu
        with SMTPS id 1633690351862862.8178454100281; Fri, 8 Oct 2021 12:52:31 +0200 (CEST)
Subject: Re: [PATCH V2] Grow: Close cfd file descriptor
To:     Mateusz Kusiak <mateusz.kusiak@intel.com>,
        linux-raid@vger.kernel.org
References: <20210830133237.7957-1-mateusz.kusiak@intel.com>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <9e7e124c-270d-49e7-b7a9-f471e74cde93@trained-monkey.org>
Date:   Fri, 8 Oct 2021 06:52:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210830133237.7957-1-mateusz.kusiak@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/30/21 9:32 AM, Mateusz Kusiak wrote:
> Unclosed file descriptor causes resource leak if error occurs.
> 
> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>

Hi Mateusz,

Thanks for looking at this. Please could you provide a more elaborate
commit message when you submit these commits. It is also unclear what
changed between v1 and v2 of your patch.

Grow_reshape() is a beast and it really could do with some cleaning up.
This would also be a good time to work on returning meaningful error
codes instead of those horrible 1 and 2 values for errors.

While I think your patch is technically correct, I think it makes the
code harder to read and discourages cleaning up the error codes. In
particular I don't like the goto error which is just a shortcut for not
setting rv before the jump. Can we please drop that and maybe longer
term focus on returning more meaningful error codes?

Given that Grow_reshape() is such a beast, what do you think of
splitting off the section from around line 1869 into a helper function,
something like Validate_External_Reshape() or something like that?
Basically the code covered in this if() statement:

	/* in the external case we need to check that the requested reshape is
	 * supported, and perform an initial check that the container holds the
	 * pre-requisite spare devices (mdmon owns final validation)
	 */
	if (st->ss->external) {

If you want to send me a smaller patch that adds the cleanup to release:
and the additional jumps to there, then I am happy to apply that for now.

Thanks,
Jes


> ---
>  Grow.c | 82 +++++++++++++++++++++++++---------------------------------
>  1 file changed, 35 insertions(+), 47 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index 7506ab46..dec6b742 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1796,7 +1796,7 @@ int Grow_reshape(char *devname, int fd,
>  	struct supertype *st;
>  	char *subarray = NULL;
>  
> -	int frozen;
> +	int frozen = 0;
>  	int changed = 0;
>  	char *container = NULL;
>  	int cfd = -1;
> @@ -1805,7 +1805,7 @@ int Grow_reshape(char *devname, int fd,
>  	int added_disks;
>  
>  	struct mdinfo info;
> -	struct mdinfo *sra;
> +	struct mdinfo *sra = NULL;
>  
>  	if (md_get_array_info(fd, &array) < 0) {
>  		pr_err("%s is not an active md array - aborting\n",
> @@ -1851,14 +1851,14 @@ int Grow_reshape(char *devname, int fd,
>  	}
>  	if (s->raiddisks > st->max_devs) {
>  		pr_err("Cannot increase raid-disks on this array beyond %d\n", st->max_devs);
> -		return 1;
> +		goto error;
>  	}
>  	if (s->level == 0 && (array.state & (1 << MD_SB_BITMAP_PRESENT)) &&
>  		!(array.state & (1 << MD_SB_CLUSTERED)) && !st->ss->external) {
>  		array.state &= ~(1 << MD_SB_BITMAP_PRESENT);
>  		if (md_set_array_info(fd, &array) != 0) {
>  			pr_err("failed to remove internal bitmap.\n");
> -			return 1;
> +			goto error;
>  		}
>  	}
>  
> @@ -1880,16 +1880,14 @@ int Grow_reshape(char *devname, int fd,
>  		}
>  		if (cfd < 0) {
>  			pr_err("Unable to open container for %s\n", devname);
> -			free(subarray);
> -			return 1;
> +			goto error;
>  		}
>  
>  		retval = st->ss->load_container(st, cfd, NULL);
>  
>  		if (retval) {
>  			pr_err("Cannot read superblock for %s\n", devname);
> -			free(subarray);
> -			return 1;
> +			goto error;
>  		}
>  
>  		/* check if operation is supported for metadata handler */
> @@ -1900,6 +1898,7 @@ int Grow_reshape(char *devname, int fd,
>  			cc = st->ss->container_content(st, subarray);
>  			for (content = cc; content ; content = content->next) {
>  				int allow_reshape = 1;
> +				rv = 1;
>  
>  				/* check if reshape is allowed based on metadata
>  				 * indications stored in content.array.status
> @@ -1913,26 +1912,23 @@ int Grow_reshape(char *devname, int fd,
>  				if (!allow_reshape) {
>  					pr_err("cannot reshape arrays in container with unsupported metadata: %s(%s)\n",
>  					       devname, container);
> -					sysfs_free(cc);
> -					free(subarray);
> -					return 1;
> +					break;
>  				}
>  				if (content->consistency_policy ==
>  				    CONSISTENCY_POLICY_PPL) {
>  					pr_err("Operation not supported when ppl consistency policy is enabled\n");
> -					sysfs_free(cc);
> -					free(subarray);
> -					return 1;
> +					break;
>  				}
>  				if (content->consistency_policy ==
>  				    CONSISTENCY_POLICY_BITMAP) {
>  					pr_err("Operation not supported when write-intent bitmap is enabled\n");
> -					sysfs_free(cc);
> -					free(subarray);
> -					return 1;
> +					break;
>  				}
> +				rv = 0;
>  			}
>  			sysfs_free(cc);
> +			if (rv == 1)
> +				goto release;
>  		}
>  		if (mdmon_running(container))
>  			st->update_tail = &st->updates;
> @@ -1950,7 +1946,7 @@ int Grow_reshape(char *devname, int fd,
>  		       s->raiddisks - array.raid_disks,
>  		       s->raiddisks - array.raid_disks == 1 ? "" : "s",
>  		       array.spare_disks + added_disks);
> -		return 1;
> +		goto error;
>  	}
>  
>  	sra = sysfs_read(fd, NULL, GET_LEVEL | GET_DISKS | GET_DEVS |
> @@ -1963,17 +1959,15 @@ int Grow_reshape(char *devname, int fd,
>  	} else {
>  		pr_err("failed to read sysfs parameters for %s\n",
>  			devname);
> -		return 1;
> +		goto error;
>  	}
>  	frozen = freeze(st);
>  	if (frozen < -1) {
>  		/* freeze() already spewed the reason */
> -		sysfs_free(sra);
> -		return 1;
> +		goto error;
>  	} else if (frozen < 0) {
>  		pr_err("%s is performing resync/recovery and cannot be reshaped\n", devname);
> -		sysfs_free(sra);
> -		return 1;
> +		goto error;
>  	}
>  
>  	/* ========= set size =============== */
> @@ -1989,15 +1983,13 @@ int Grow_reshape(char *devname, int fd,
>  
>  		if (orig_size == 0) {
>  			pr_err("Cannot set device size in this type of array.\n");
> -			rv = 1;
> -			goto release;
> +			goto error;
>  		}
>  
>  		if (reshape_super(st, s->size, UnSet, UnSet, 0, 0, UnSet, NULL,
>  				  devname, APPLY_METADATA_CHANGES,
>  				  c->verbose > 0)) {
> -			rv = 1;
> -			goto release;
> +			goto error;
>  		}
>  		sync_metadata(st);
>  		if (st->ss->external) {
> @@ -2126,8 +2118,7 @@ size_change_error:
>  			if (err == EBUSY &&
>  			    (array.state & (1<<MD_SB_BITMAP_PRESENT)))
>  				cont_err("Bitmap must be removed before size can be changed\n");
> -			rv = 1;
> -			goto release;
> +			goto error;
>  		}
>  		if (s->assume_clean) {
>  			/* This will fail on kernels older than 3.0 unless
> @@ -2183,10 +2174,7 @@ size_change_error:
>  		err = remove_disks_for_takeover(st, sra, array.layout);
>  		if (err) {
>  			dprintf("Array cannot be reshaped\n");
> -			if (cfd > -1)
> -				close(cfd);
> -			rv = 1;
> -			goto release;
> +			goto error;
>  		}
>  		/* Make sure mdmon has seen the device removal
>  		 * and updated metadata before we continue with
> @@ -2200,8 +2188,7 @@ size_change_error:
>  	info.array = array;
>  	if (sysfs_init(&info, fd, NULL)) {
>  		pr_err("failed to initialize sysfs.\n");
> -		rv = 1;
> -		goto release;
> +		goto error;
>  	}
>  	strcpy(info.text_version, sra->text_version);
>  	info.component_size = s->size*2;
> @@ -2222,8 +2209,7 @@ size_change_error:
>  			pr_err("%s has a non-standard layout.  If you wish to preserve this\n", devname);
>  			cont_err("during the reshape, please specify --layout=preserve\n");
>  			cont_err("If you want to change it, specify a layout or use --layout=normalise\n");
> -			rv = 1;
> -			goto release;
> +			goto error;
>  		}
>  	} else if (strcmp(s->layout_str, "normalise") == 0 ||
>  		   strcmp(s->layout_str, "normalize") == 0) {
> @@ -2239,8 +2225,7 @@ size_change_error:
>  			}
>  		} else {
>  			pr_err("%s is only meaningful when reshaping a RAID6 array.\n", s->layout_str);
> -			rv = 1;
> -			goto release;
> +			goto error;
>  		}
>  	} else if (strcmp(s->layout_str, "preserve") == 0) {
>  		/* This means that a non-standard RAID6 layout
> @@ -2261,8 +2246,7 @@ size_change_error:
>  			info.new_layout = map_name(r6layout, l);
>  		} else {
>  			pr_err("%s in only meaningful when reshaping to RAID6\n", s->layout_str);
> -			rv = 1;
> -			goto release;
> +			goto error;
>  		}
>  	} else {
>  		int l = info.new_level;
> @@ -2283,14 +2267,12 @@ size_change_error:
>  			break;
>  		default:
>  			pr_err("layout not meaningful with this level\n");
> -			rv = 1;
> -			goto release;
> +			goto error;
>  		}
>  		if (info.new_layout == UnSet) {
>  			pr_err("layout %s not understood for this level\n",
>  				s->layout_str);
> -			rv = 1;
> -			goto release;
> +			goto error;
>  		}
>  	}
>  
> @@ -2359,8 +2341,7 @@ size_change_error:
>  				  info.array.raid_disks, info.delta_disks,
>  				  c->backup_file, devname,
>  				  APPLY_METADATA_CHANGES, c->verbose)) {
> -			rv = 1;
> -			goto release;
> +			goto error;
>  		}
>  		sync_metadata(st);
>  		rv = reshape_array(container, fd, devname, st, &info, c->force,
> @@ -2369,10 +2350,17 @@ size_change_error:
>  		frozen = 0;
>  	}
>  release:
> +	if (cfd > -1)
> +		close(cfd);
> +	free(subarray);
>  	sysfs_free(sra);
>  	if (frozen > 0)
>  		unfreeze(st);
> +	free(st);
>  	return rv;
> +error:
> +	rv = 1;
> +	goto release;
>  }
>  
>  /* verify_reshape_position()
> 

