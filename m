Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D29BFC43334
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jul 2022 08:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237710AbiGTIU2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Jul 2022 04:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239877AbiGTIU1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Jul 2022 04:20:27 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F3A3B976
        for <linux-raid@vger.kernel.org>; Wed, 20 Jul 2022 01:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658305225; x=1689841225;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=skwO77cob8xNt+YJplkQgKHfImKR8OTax6QqbIVJNPE=;
  b=aKPklGhJYnS9T/pHfTktFzJzQVoo93d9qXO2omUKEnU/ulR/JdQTQEow
   66D2uVENRzZB8QXv3X/xXAzjaE4aqj9muKnWTKWIIaCrPvo6if+Nylu7r
   0AlBhwlUTgTq2V+9AXhdCjvsy4I9JthuCBsrnNQ1D8ZFCV3EGbS/lUx3p
   Dv+fTTvmAj3QZC5sWfzWMrUYxuzy5B6kY19VAyrK7Pub1QLyEGIBd+IRE
   mRE768/0KuV4ezxl0p2gU1gvn/U3Rxu9j0dIWmQEZCx43kW/+RPkG80ve
   g36rJB3a9AyH9CngHGSde2BQPqAT8ROsJpW5suT6QntLAWSS56vErApKA
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="312406803"
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="312406803"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 01:20:25 -0700
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="625568575"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.55.87])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 01:20:21 -0700
Date:   Wed, 20 Jul 2022 10:20:15 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        linux-raid@vger.kernel.org, Jes Sorensen <jsorensen@fb.com>,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>, Xiao Ni <xni@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Coly Li <colyli@suse.de>, Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH mdadm] mdadm: Don't open md device for CREATE and
 ASSEMBLE
Message-ID: <20220720102015.00000bd0@linux.intel.com>
In-Reply-To: <dcaf3af0-95c5-bf9a-bd2c-9c6a60c67e97@deltatee.com>
References: <20220714223749.17250-1-logang@deltatee.com>
        <150ffbb2-9881-9c1f-cc5e-331926b8e423@linux.dev>
        <20220719132739.00001b94@linux.intel.com>
        <dcaf3af0-95c5-bf9a-bd2c-9c6a60c67e97@deltatee.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 19 Jul 2022 10:43:06 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:

> On 2022-07-19 05:27, Mariusz Tkaczyk wrote:
> > On Fri, 15 Jul 2022 10:20:26 +0800
> > Guoqing Jiang <guoqing.jiang@linux.dev> wrote:  
> >> On 7/15/22 6:37 AM, Logan Gunthorpe wrote:  
> >>> To fix this, don't bother trying to open the md device for CREATE and
> >>> ASSEMBLE commands, as the file descriptor will never be used anyway
> >>> even if it is successfully openned.  
> > Hi All,
> > 
> > This is not a fix, it just reduces race probability because file descriptor
> > will be opened later.  
> 
> That's not correct. The later "open" call actually will use the new_array
> parameter which will wait for the workqueue before creating a new array
> device, so the old one is properly cleaned up and there is no longer
> a race condition with this patch. If new_array doesn't exist and it falls back
> to a regular open, then it will still do the right thing and open the device 
> with create_on_open.

Array is created by /sys/module/md/parameters/new_array if chosen_name has
certain form. For IMSM, when we are creating arrays using "/dev/md/name" or
"name" only create_on_open is used (if no "names=yes" in config). I
understand that it works with tests but I don't feel that it is complete yet.
Could you how it behaves when we use "whatever"? 

#mdadm -CR whatever -l0 -n2 /dev/nvme[01]n1

Please do not use --name= parameter.

I want to disable create_on_open and always use new_array in the future, without
fallback to create_on_open possibility. So I would like to have solution which
is not relying on it.
> 
> > I tried to resolve it in the past by adding completion to md driver and
> > force mdadm --stop command to wait for sysfs clean up but I have never
> > finished it. IMO it is a better way, wait for device to be fully removed by
> > MD during stop. Thoughts?  
> 
> I don't think that would work very well. Userspace would end up blocking
> on --stop indefinitely if there are any references delaying cleanup to
> the device. That's not very user friendly. Given that opening the md
> device has side-effects, I think we should avoid opening when we
> should know that we are about to try to create a new device.

Got it, thanks!

Hmm, so maybe the existing MD device should be marked as "in the middle of
removal" somehow to gives mdadm possibility to detect that. If we are using
node as name "/dev/mdX" then we will need to throw error, but when node needs
to be determined by find_free_devnm() then it will simply skip this one and
gives next one. But it will require changes in kernel probably.

> 
> > One objection I have here is that error handling is changed, so it could be
> > harmful change for users.   
> 
> Hmm, yes seems like I was a bit sloppy here. However, it still seems possible
> to fix this up by not pre-opening the device. The only use for the mdfd
> in CREATE, ASSEMBLE and BUILD is to get the minor number if
> ident.super_minor == -2 and check if an existing specified device is an md 
> device (which may be redundant). We could replace this with a stat() call to
> avoid opening the device. What about the patch at the end of this email?

LGTM, I put small comment. But as I said before, probably it don't fix all
creation cases.

Thanks,
Mariusz

> 
> >>>
> >>> Side note: it would be nice to disable create_on_open as well to help
> >>> solve this, but it seems the work for this was never finished. By default,
> >>> mdadm will create using the old node interface when a name is specified
> >>> unless the user specifically puts names=yes in a config file, which
> >>> doesn't seem to be vcreate_on_openery common yet.    
> >>
> >> Hmm, 'create_on_open' is default to true, not sure if there is any side 
> >> effect
> >> after change to false.  
> > 
> > I'm slowly working on this. The change is not simple, starting from terrible
> > create_mddev code and char *mddev and char *name rules , ending with hidden
> > references which we are not aware off (it is common to create temp node and
> > open mddevice in mdadm) and other references in systemd (because of that,
> > udev is avoiding to open device).
> > This also indicate that we should drop partition discover in kernel and use
> > udev in the future, especially for external metadata (where RO -> RW
> > transition happens during assembly). But this is a separate problem.  
> 
> I'm glad to hear someone is still working on that. Thanks!
> 
> Logan
> 
> --
> 
> diff --git a/mdadm.c b/mdadm.c
> index 56722ed997a2..7b757c79d6bf 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -1349,6 +1349,8 @@ int main(int argc, char *argv[])
>  
>  	if (mode == MANAGE || mode == BUILD || mode == CREATE ||
>  	    mode == GROW || (mode == ASSEMBLE && ! c.scan)) {
> +		struct stat stb;
> +
>  		if (devs_found < 1) {
>  			pr_err("an md device must be given in this mode\n");
>  			exit(2);
> @@ -1361,37 +1363,31 @@ int main(int argc, char *argv[])
>  			mdfd = open_mddev(devlist->devname, 1);
>  			if (mdfd < 0)
>  				exit(1);
> +
> +			fstat(mdfd, &stb);
>  		} else {
>  			char *bname = basename(devlist->devname);
> +			int ret;
>  
>  			if (strlen(bname) > MD_NAME_MAX) {
>  				pr_err("Name %s is too long.\n",
> devlist->devname); exit(1);
>  			}
> -			/* non-existent device is OK */
> -			mdfd = open_mddev(devlist->devname, 0);
> -		}
> -		if (mdfd == -2) {
> -			pr_err("device %s exists but is not an md array.\n",
> devlist->devname);
> -			exit(1);
> -		}
> -		if ((int)ident.super_minor == -2) {
> -			struct stat stb;
> -			if (mdfd < 0) {
> +
> +			ret = stat(devlist->devname, &stb);
> +			if (ident.super_minor == -2 && ret) {
>  				pr_err("--super-minor=dev given, and listed
> device %s doesn't exist.\n", devlist->devname);
> +				exit(1);
> +			}
please check ret != 0.

> +
> +			if (!ret && !md_array_valid_stat(&stb)) {
> +				pr_err("device %s exists but is not an md
> array.\n", devlist->devname); exit(1);
>  			}
> -			fstat(mdfd, &stb);
> -			ident.super_minor = minor(stb.st_rdev);
> -		}
> -		if (mdfd >= 0 && mode != MANAGE && mode != GROW) {
> -			/* We don't really want this open yet, we just might
> -			 * have wanted to check some things
> -			 */
> -			close(mdfd);
> -			mdfd = -1;
>  		}
> +		if (ident.super_minor == -2)
> +			ident.super_minor = minor(stb.st_rdev);
>  	}
>  
>  	if (s.raiddisks) {
> diff --git a/mdadm.h b/mdadm.h
> index 05ef881f4709..7462336b381c 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1504,6 +1504,7 @@ extern int Restore_metadata(char *dev, char *dir,
> struct context *c, struct supertype *st, int only);
>  
>  int md_array_valid(int fd);
> +int md_array_valid_stat(struct stat *st);
>  int md_array_active(int fd);
>  int md_array_is_active(struct mdinfo *info);
>  int md_get_array_info(int fd, struct mdu_array_info_s *array);
> diff --git a/util.c b/util.c
> index cc94f96ef120..20acdcf6af22 100644
> --- a/util.c
> +++ b/util.c
> @@ -250,6 +250,23 @@ int md_array_valid(int fd)
>  	return !ret;
>  }
>  
> +int md_array_valid_stat(struct stat *st)
> +{
> +	struct mdinfo *sra;
> +	char *devnm;
> +
> +	devnm = stat2devnm(st);
> +	if (!devnm)
> +		return 0;
> +
> +	sra = sysfs_read(-1, devnm, GET_ARRAY_STATE);
> +	if (!sra)
> +		return 0;
> +
> +	free(sra);
> +	return 1;
> +}
> +
>  int md_array_active(int fd)
>  {
>  	struct mdinfo *sra;

