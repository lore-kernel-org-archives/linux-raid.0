Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A300C77B7D
	for <linux-raid@archiver.kernel.org>; Fri,  5 May 2023 08:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbjEEItS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 5 May 2023 04:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjEEItR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 5 May 2023 04:49:17 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44F818916
        for <linux-raid@vger.kernel.org>; Fri,  5 May 2023 01:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683276556; x=1714812556;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xp8e7zcnTcRILubNOi7os3Sz13kpn6QtNaPoavdhCn0=;
  b=gd2J5qrdr97UIPI0saAZaaSqE7gohJHjbDVIIDnkj9nK+GtfQAbxr/ug
   k/q4HDCeznw+KeE7o25Ckv2uuXDGug+EcDwD7VTuWTydN69dF+oliJOOr
   vhGHurYx6uOVAOXgPI9DsP5OGMOSGBEHY+3C+H1dLyLrhShu8qq6J4xui
   RXGGWzXJBxDk1z+Xz8eQxmrnJ7/rFrrCpYJXbS8/G8QgDQQGvBE+APNV1
   vxoQgh11JYGtHtOc5w7hTvum/U8ZKtoD4nc8QmGfj/ljeKxQW+3huldV/
   eemanaaxetLatypFGpNgdKJLEQoMXvpuCqDHOaRbrv2S+MTQYNQJQm3eW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10700"; a="377241242"
X-IronPort-AV: E=Sophos;i="5.99,251,1677571200"; 
   d="scan'208";a="377241242"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2023 01:49:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10700"; a="1027374362"
X-IronPort-AV: E=Sophos;i="5.99,251,1677571200"; 
   d="scan'208";a="1027374362"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.139.56])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2023 01:49:15 -0700
Date:   Fri, 5 May 2023 10:49:10 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Subject: Re: [PATCH] Incremental: remove obsoleted calls to udisks
Message-ID: <20230505104910.00000aa9@linux.intel.com>
In-Reply-To: <20230505052231.7787-1-colyli@suse.de>
References: <20230505052231.7787-1-colyli@suse.de>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri,  5 May 2023 13:22:31 +0800
Coly Li <colyli@suse.de> wrote:

> Utilility udisks is removed from udev upstream, calling this obsoleted
> command in run_udisks() doesn't make any sense now.
> 
> This patch removes the calls chain of udisks, which includes routines
> run_udisk(), force_remove(), and 2 locations where force_remove() are
> called.
> 
> In remove_from_member_array() and IncrementalRemove(), if return value
> of calling Manage_subdevs() is not 0, don't call force_remove() and only
> print error message when parameter 'verbose' is true.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
> Cc: Jes Sorensen <jes@trained-monkey.org>
> ---
>  Incremental.c | 50 +++++++-------------------------------------------
>  1 file changed, 7 insertions(+), 43 deletions(-)
> 
> diff --git a/Incremental.c b/Incremental.c
> index 49a71f7..e1a953a 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -1630,54 +1630,18 @@ release:
>  	return rv;
>  }
>  
> -static void run_udisks(char *arg1, char *arg2)
> -{
> -	int pid = fork();
> -	int status;
> -	if (pid == 0) {
> -		manage_fork_fds(1);
> -		execl("/usr/bin/udisks", "udisks", arg1, arg2, NULL);
> -		execl("/bin/udisks", "udisks", arg1, arg2, NULL);
> -		exit(1);
> -	}
> -	while (pid > 0 && wait(&status) != pid)
> -		;
> -}
> -
> -static int force_remove(char *devnm, int fd, struct mdinfo *mdi, int verbose)
> -{
> -	int rv;
> -	int devid = devnm2devid(devnm);
> -
> -	run_udisks("--unmount", map_dev(major(devid), minor(devid), 0));
> -	rv = Manage_stop(devnm, fd, verbose, 1);

Hi Coly,
Please see that you removed Manage_stop(). Now mdadm won't try to
stop failed arrays. It is good change but please describe it.

> -	if (rv) {
> -		/* At least we can try to trigger a 'remove' */
> -		sysfs_uevent(mdi, "remove");
> -		if (verbose)
> -			pr_err("Fail to stop %s too.\n", devnm);
> -	}
> -	return rv;
> -}
> -
>  static void remove_from_member_array(struct mdstat_ent *memb,
>  				    struct mddev_dev *devlist, int verbose)
>  {
>  	int rv;
> -	struct mdinfo mmdi;
>  	int subfd = open_dev(memb->devnm);
>  
>  	if (subfd >= 0) {
>  		rv = Manage_subdevs(memb->devnm, subfd, devlist, verbose,
>  				    0, UOPT_UNDEFINED, 0);
> -		if (rv & 2) {
> -			if (sysfs_init(&mmdi, -1, memb->devnm))
> -				pr_err("unable to initialize sysfs for:
> %s\n",
> -				       memb->devnm);
> -			else
> -				force_remove(memb->devnm, subfd, &mmdi,
> -					     verbose);
> -		}
> +		if ((rv & 2) && verbose)

There is a rule (at least we at Intel tried to follow) to use indirect
comparisons only for pointers. I know that we don't have log level in mdadm,
we need to compare with values directly:
if ((rv & 2) && verbose > 0)

It is not mandatory, just to let you know.
> +			pr_err("Fail to remove %s from array.\n",
> memb->devnm);

Could we make this error less "dangerous"? I mean that someone may think that
something is wrong here but it is not - the message is expected in case when
raid becomes failed. Note that for raid5 disk is removed from array but EBUSY
is returned anyway. Maybe we should check for MD_BROKEN in array_state to
differentiate and make errors more detailed?

Same applies to the native case below.

>  		close(subfd);
>  	}
>  }
> @@ -1763,10 +1727,10 @@ int IncrementalRemove(char *devname, char *id_path,
> int verbose) rv |= Manage_subdevs(ent->devnm, mdfd, &devlist,
>  				    verbose, 0, UOPT_UNDEFINED, 0);
>  		if (rv & 2) {
> -		/* Failed due to EBUSY, try to stop the array.
> -		 * Give udisks a chance to unmount it first.
> -		 */
> -			rv = force_remove(ent->devnm, mdfd, &mdi, verbose);
> +			if (verbose)
> +				pr_err("Fail to remove %s from array.\n",
> ent->devnm);
> +			/* Only return 0 or 1 */
> +			rv = !!rv;
we are in if (rv & 2) so I think that we can simply set rv = 1, am I right?

>  			goto end;
>  		}
>  	}

Thanks,
Mariusz
