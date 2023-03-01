Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F9F8C64ED6
	for <linux-raid@archiver.kernel.org>; Wed,  1 Mar 2023 13:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjCANuQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Mar 2023 08:50:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjCANuP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Mar 2023 08:50:15 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D28031E2E
        for <linux-raid@vger.kernel.org>; Wed,  1 Mar 2023 05:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677678614; x=1709214614;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=faPuqKhK+qMVMFMff/mA6oJ3xGc9j0kaIfJPjAdydIA=;
  b=N0PAoelCYMvRTCvW+rmqDX8C+qU1+eCfh+7YUW+YfbtYHTJrN12Hq6Rf
   sczT/PKEKOhrqhQz3CfDvN/FjHfVIFXsXgPpQDT3qRaP3nsOewnSxRgyC
   e3akTfC5kY5710ABo7dgFkSDDb03/AirSNPF5TVsFRubxc5qLz8ZEzG0H
   +1IUHyYKEdCZyV0wwb4OITz5oNyI9iurZIRgRE4NXsqk/oN4fXm9LV96C
   aJ4t7i2n3JSshJ4oEqbbfhjURmVZAenqVQduAdRroN/NlW3fHDiwqZtmT
   fnWo5+DDJcoz9touT3jistz3eSJSrYmNDZoEHu/eViCxl10OHnzyR7k50
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="420671187"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="420671187"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 05:50:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="798434459"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="798434459"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.57.49])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 05:50:12 -0800
Date:   Wed, 1 Mar 2023 14:50:07 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     NeilBrown <neilb@suse.de>
Cc:     Jes Sorensen <jes@trained-monkey.org>, linux-raid@vger.kernel.org,
        Martin Wilck <martin.wilck@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Subject: Re: [PATCH 6/6] mdmon improvements for switchroot
Message-ID: <20230301145007.00001f62@linux.intel.com>
In-Reply-To: <167745678753.16565.5052083348539533042.stgit@noble.brown>
References: <167745586347.16565.4353184078424535907.stgit@noble.brown>
        <167745678753.16565.5052083348539533042.stgit@noble.brown>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Neil,
We found typo. We fixed that to test the change.
Other comments are less important.

On Mon, 27 Feb 2023 11:13:07 +1100
NeilBrown <neilb@suse.de> wrote:

> We need a new mdmon@mdfoo instance to run in the root filesystem after
> switch root, as /sys and /dev are removed from the initrd.
> 
> systemd will not start a new unit with the same name running while the
> old unit is still active, and we want the two mdmon processes to overlap
> in time to avoid any risk of deadlock which a write is attempted with no
> mdmon running.
> 
> So we need a different unit name in the initrd than in the root.  Apart
> from the name, everything else should be the same.
> 
> This is easily achieved using a different instance name as the
> mdmon@.service unit file already supports multiple instances (for
> different arrays).
> 
> So start "mdmon@mdfoo.service" from root, but
> "mdmon@initrd-mdfoo.service" from the initrd.  udev can tell which
> circumstance is the case by looking for /etc/initrd-release.
> continue_from_systemd() is enhanced so that the "initrd-" prefix can be
> requested.
> 
> Teach mdmon that a container name like "initrd/foo" should be treated
> just like "foo".  Note that systemd passes the instance name
> "initrd-foo" as "initrd/foo".
> 
> We don't need a similar machanism at shutdown because dracut runs
> "mdmon --takeover --all" when appropriate.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>

> diff --git a/mdmon.c b/mdmon.c
> index 6d37b17c3f53..25abdd71fb1e 100644
> --- a/mdmon.c
> +++ b/mdmon.c
> @@ -368,7 +368,11 @@ int main(int argc, char *argv[])
>  	}
>  
>  	if (!all && argv[optind]) {
> -		container_name = get_md_name(argv[optind]);
> +		static const char prefix[] = "initrd/";
> +		container_name = argv[optind];
> +		if (strncmp(container_name, prefix, sizeof(prefix)-1) == 0)
> +			container_name += sizeof(prefix)-1;
> +		container_name = get_md_name(container_name);

"sizeof(prefix)-1" there should be spaces before and after operator.

You are defining similar literals in 2 places:
prefix[] = "initrd/"
*prefix = in_initrd() ? "initrd-", "";

When I see something like this, I need to ask why it is not globally defined
because in the future we would need to define it for the firth and fourth time.
I see the difference in last sign ('/' and '-'). We can omit that.
I would like propose something like:

in mdadm.h:
#DEFINE MDMON_PREFIX "initrd"

in mdmon, do not check last sign. whatever it is, we don't really care, just
skip it. All we need to know is that it not belongs to container name.
Hope it works correctly:
	if (strncmp(container_name, MDMON_PREFIX, sizeof(prefix) - 1) == 0)
		container_name += sizeof(MDMON_PREFIX);
	
And later in start_mdmon include '-' in snprintf:
		 "%s@%s%s.service", service_name, MDMON_PREFIX"-" ?: "",

I think that we don't need to pass whole char* value, we can use bool, the one
possibility is "initrd" now. If that would be changed, we can use enum and maps
interface:
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/maps.c

This is lesson learned by code study, we needed to put big effort to correct
similar case with reshapes because pointers become overkill through
years:
https://lore.kernel.org/linux-raid/20230102083524.28893-1-mateusz.kusiak@intel.com/

It my my personal view so you are free to make decision. I will accept it but
please note that mdadm is full of same literals (just find /dev/md or /dev/md/)
so that is why I'm especially sensitive in that cases.

> --git a/util.c b/util.c index 6b44662db7cd..1d433d1826b5 100644 --- a/util.c
> +++ b/util.c @@ -1906,6 +1906,7 @@ int start_mdmon(char *devnm)
>  	int len;
>  	pid_t pid;
>  	int status;
> +	char *prefix = in_initrd() ? "initrd-", "";

The most important thing:
typo, should be in_initrd() ? "initrd-": "";

>  	char pathbuf[1024];
>  	char *paths[4] = {
>  		pathbuf,
> @@ -1916,7 +1917,7 @@ int start_mdmon(char *devnm)
>  
>  	if (check_env("MDADM_NO_MDMON"))
>  		return 0;
> -	if (continue_via_systemd(devnm, MDMON_SERVICE))
> +	if (continue_via_systemd(devnm, MDMON_SERVICE, prefix))
>  		return 0;
>  
>  	/* That failed, try running mdmon directly */
> @@ -2187,7 +2188,7 @@ void manage_fork_fds(int close_all)
>   *	1- if systemd service has been started
>   *	0- otherwise
>   */
> -int continue_via_systemd(char *devnm, char *service_name)
> +int continue_via_systemd(char *devnm, char *service_name, char *prefix)
>  {
>  	int pid, status;
>  	char pathbuf[1024];
> @@ -2199,7 +2200,7 @@ int continue_via_systemd(char *devnm, char
> *service_name) case  0:
>  		manage_fork_fds(1);
>  		snprintf(pathbuf, sizeof(pathbuf),
> -			 "%s@%s.service", service_name, devnm);
> +			 "%s@%s%s.service", service_name, prefix ?: "",
> devnm); status = execl("/usr/bin/systemctl", "systemctl", "restart",
>  			       pathbuf, NULL);
>  		status = execl("/bin/systemctl", "systemctl", "restart",
> 
> 

Thanks,
Mariusz
