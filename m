Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71304C77B7A
	for <linux-raid@archiver.kernel.org>; Fri, 26 May 2023 07:52:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242563AbjEZHwP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 26 May 2023 03:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242560AbjEZHwO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 26 May 2023 03:52:14 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99549E4D
        for <linux-raid@vger.kernel.org>; Fri, 26 May 2023 00:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685087527; x=1716623527;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uhlz3ulBE2nfUIRVg+goYyDJMeE5/Ss9tv6TDEpGuGI=;
  b=jQw+yLWSTjwDlWZMLnk2D70eXLM+N/2nv4HryM5teZUlyEWIo0a7p682
   srQWhGCSt5QR8RzSFLSfz3J6/ie2aoIMk6XL0ssltMjN8aenguaCPUKZy
   Zoy74pruoo5yEhQEWvUQdVsJOZnQlnLGck76EjUD7ZBybhAFnW5tGeEaa
   cGQXKNiBF5vVB0sV97FCGAkvo3lFDG6nmKVbocbpVeaNrypsS45Prw+Ms
   freC3M50GNlI/UHc5vy8pP/2VMVfI3YjlM1QRaDDbnpRq2GXVmxAhfFSR
   urtLv5TD/+0IFXZHbn4IFaWewnLhqhxhthKFWOEj/kc7vXmx8Eov1pWe+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="343641523"
X-IronPort-AV: E=Sophos;i="6.00,193,1681196400"; 
   d="scan'208";a="343641523"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 00:52:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="775000601"
X-IronPort-AV: E=Sophos;i="6.00,193,1681196400"; 
   d="scan'208";a="775000601"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.130.205])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 00:52:05 -0700
Date:   Fri, 26 May 2023 09:52:00 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>,
        Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH v2] Incremental: remove obsoleted calls to udisks
Message-ID: <20230526095200.00004c9c@linux.intel.com>
In-Reply-To: <20230525170843.4616-1-colyli@suse.de>
References: <20230525170843.4616-1-colyli@suse.de>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 26 May 2023 01:08:43 +0800
Coly Li <colyli@suse.de> wrote:

> Utilility udisks is removed from udev upstream, calling this obsoleted
> command in run_udisks() doesn't make any sense now.
> 
> This patch removes the calls chain of udisks, which includes routines
> run_udisk(), force_remove(), and 2 locations where force_remove() are
> called. Considering force_remove() is removed with udisks util, it is
> fair to remove Manage_stop() inside force_remove() as well.
> 
> After force_remove() is not called anymore, if Manage_subdevs() returns
> failure due to a busy array, nothing else to do. If the failure is from
> a broken array and verbose information is wanted, a warning message will
> be printed by pr_err().
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
> Cc: Jes Sorensen <jes@trained-monkey.org>
> ---
> Changelog,
> v2: improve based on code review comments from Mariusz.
> v1: initial version.
> 
>  Incremental.c | 88 ++++++++++++++++++++++++---------------------------
>  1 file changed, 42 insertions(+), 46 deletions(-)
> 
> diff --git a/Incremental.c b/Incremental.c
> index f13ce02..d390a08 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -1628,56 +1628,38 @@ release:
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
>  	struct mdinfo mmdi;
> +	char buf[32];

Another place where we hard-coding array size. We already
addressed it (patch is waiting for internal regression), so please left it as is
for now. Just to let everyone know.

>  	int subfd = open_dev(memb->devnm);
>  
> -	if (subfd >= 0) {
> -		rv = Manage_subdevs(memb->devnm, subfd, devlist, verbose,
> -				    0, UOPT_UNDEFINED, 0);
> -		if (rv & 2) {
> -			if (sysfs_init(&mmdi, -1, memb->devnm))
> -				pr_err("unable to initialize sysfs for:
> %s\n",
> -				       memb->devnm);
> -			else
> -				force_remove(memb->devnm, subfd, &mmdi,
> -					     verbose);
> +	if (subfd < 0)
> +		return;
> +
> +	rv = Manage_subdevs(memb->devnm, subfd, devlist, verbose,
> +			    0, UOPT_UNDEFINED, 0);
> +	if (rv) {
> +		/*
> +		 * If the array is busy or no verbose info
> +		 * desired, nonthing else to do.
> +		 */
> +		if ((rv & 2) || verbose <= 0)
> +			goto close;
> +
> +		/* Otherwise if failed due to a broken array, warn */
> +		if (sysfs_init(&mmdi, -1, memb->devnm) == 0 &&
> +		    sysfs_get_str(&mmdi, NULL, "array_state",
> +				  buf, sizeof(buf)) > 0 &&
> +		    strncmp(buf, "broken", 6) == 0) {
> +			pr_err("Fail to remove %s from broken array.\n",
> +			       memb->devnm);

The codes above and below are almost the same now, can we move them to a
function?
>  		}
> -		close(subfd);
>  	}
> +close:
> +	close(subfd);
>  }
>  
>  /*
> @@ -1760,11 +1742,22 @@ int IncrementalRemove(char *devname, char *id_path,
> int verbose) } else {
>  		rv |= Manage_subdevs(ent->devnm, mdfd, &devlist,
>  				    verbose, 0, UOPT_UNDEFINED, 0);
> -		if (rv & 2) {
> -		/* Failed due to EBUSY, try to stop the array.
> -		 * Give udisks a chance to unmount it first.
> -		 */
> -			rv = force_remove(ent->devnm, mdfd, &mdi, verbose);
> +		if (rv) {
I would prefer to reverse logic to make one indentation less (if that is
possible):
if (rv != 0)
    goto end;
but it is fine anyway.

> +			/*
> +			 * If the array is busy or no verbose info
> +			 * desired, nothing else to do.
> +			 */
> +			if ((rv & 2) || verbose <= 0)
> +				goto end;
> +
> +			/* Otherwise if failed due to a broken array, warn */
> +			if (sysfs_get_str(&mdi, NULL, "array_state",
> +					  buf, sizeof(buf)) > 0 &&
> +			    strncmp(buf, "broken", 6) == 0) {

Broken is defined in sysfs_array_states[], can we use it?
if (map_name(sysfs_array_states, buf) == ARRAY_BROKEN)
I know that it could looks like a little overhead but compiler should do
the job here.
> +				pr_err("Fail to remove %s from broken
> array.\n",
> +				       ent->devnm);
Not exactly, The broken may be raised even if disk is removed. It is a case for
raid456 and raid1/10 with fail_last_dev=1. I would say just "%s is in broken
state.\n" 
Should be exclude arrays which are already broken (broken was set before we
called mdadm -If)? I don't see printing this message everytime as a problem, but
it is something you should consider.

And I forgot to say it eariler, could you consider adding test/s for both IMSM and native?
It is something that should be tested.
Sorry, scope is growing :(

Thanks,
Mariusz
