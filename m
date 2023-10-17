Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A04ACDB474
	for <linux-raid@archiver.kernel.org>; Tue, 17 Oct 2023 07:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234718AbjJQH5D (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 17 Oct 2023 03:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234701AbjJQH47 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 17 Oct 2023 03:56:59 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7676EF0
        for <linux-raid@vger.kernel.org>; Tue, 17 Oct 2023 00:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697529417; x=1729065417;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6ZxTCas6/pyfP2QmnJYOzFB0NzQmviXDbpww5/2D67E=;
  b=QIAA77155be6w1+6el27ieRwl9wTeW0J8zdIDUVR7mw3LyhAA3QtSc4a
   QOgvIgZQJQ5hCVaZRyOAmldpueOxcWO1WbwP3r3mDgEWM1XAAhf5Sjwiy
   dM9p4Z2g22jLGcbEcJEG1V/5m6qkUR6AmYul3sGNP/92/p9DNt2/3YQgb
   cb4iVTK9kKpy6cLSBwmQN63u/WVPSU8zf6d354TID9ObQiTJGZOlSfpUX
   K/GE94hBlEXQOEZD2upzgTUhT0JDppgzLF89M1iFjEWe7UCKHgD3XvLpP
   Ve8BU+WqXKBVizMccuaIzb7xkYzxuCW9ee3oh8ag6Iycy0OY/nejKxRxO
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="389593921"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="389593921"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 00:56:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="3984205"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.158.98])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 00:57:01 -0700
Date:   Tue, 17 Oct 2023 09:56:15 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     jes@trained-monkey.org, colyli@suse.de, linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/1] mdadm/udev: Don't add member disk if super is
 disabled in conf file
Message-ID: <20231017095615.00000088@linux.intel.com>
In-Reply-To: <20231017054848.42279-1-xni@redhat.com>
References: <20231017054848.42279-1-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 17 Oct 2023 13:48:48 +0800
Xiao Ni <xni@redhat.com> wrote:

> Superblocks can be disabled behind AUTO in mdadm.conf. For this situation udev
> rule still can handle the member disk. But it's not expected. Change the udev
> rule to check the conf file before handling member disk.
> 
Hi Xiao,

I'm reading manual and for me it is something that should gone. Why we need
this? Kernel is responsible for bringing up partitions, not udev.
https://linux.die.net/man/5/mdadm.conf

"From 2.6.28 all md array devices are partitionable, hence this option is not
needed."

I need from you to deeply understand this feature, why it was needed, what it
gives now to help community take a decision what is the right thing to do.

I would prefer to ask mdadm to provide such option from config. You
cannot simply assume that /etc/mdadm.conf is the right conf location. To not
make it over complicated and bug friendly we should get this by mdadm. mdadm
has conf file location determination so that should guarantee it is always
the same value.

Thanks,
Mariusz

> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  udev-md-raid-assembly.rules | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/udev-md-raid-assembly.rules b/udev-md-raid-assembly.rules
> index d4a7f0a5a049..a0f9494f4461 100644
> --- a/udev-md-raid-assembly.rules
> +++ b/udev-md-raid-assembly.rules
> @@ -16,6 +16,10 @@ ENV{SYSTEMD_READY}=="0", GOTO="md_inc_end"
>  # Then the change event happens.
>  # When adding md/dm devices, ID_FS_TYPE can only be linux_raid_member
>  # after change event happens.
> +ENV{ID_FS_TYPE}=="linux_raid_member", \
> +	PROGRAM="/usr/bin/egrep -c ^AUTO.*+1\.x.*-1\.x.*$ /etc/mdadm.conf",
> GOTO="md_inc" +ENV{ID_FS_TYPE}=="linux_raid_member", \
> +	PROGRAM="/usr/bin/egrep -c ^AUTO.*-1\.x.*$ /etc/mdadm.conf",
> GOTO="md_inc_end" ENV{ID_FS_TYPE}=="linux_raid_member", GOTO="md_inc"
>  
>  # "noiswmd" on kernel command line stops mdadm from handling
> @@ -26,9 +30,20 @@ IMPORT{cmdline}="noiswmd"
>  IMPORT{cmdline}="nodmraid"
>  
>  ENV{nodmraid}=="?*", GOTO="md_inc_end"
> +
> +ENV{ID_FS_TYPE}=="ddf_raid_member", \
> +	PROGRAM="/usr/bin/egrep -c ^AUTO.*+ddf.*-ddf.*$ /etc/mdadm.conf",
> GOTO="md_inc" +ENV{ID_FS_TYPE}=="ddf_raid_member", \
> +	PROGRAM="/usr/bin/egrep -c ^AUTO.*-ddf.*$ /etc/mdadm.conf",
> GOTO="md_inc_end" ENV{ID_FS_TYPE}=="ddf_raid_member", GOTO="md_inc"
> +
>  ENV{noiswmd}=="?*", GOTO="md_inc_end"
> +ENV{ID_FS_TYPE}=="isw_raid_member", \
> +	PROGRAM="/usr/bin/egrep -c ^AUTO.*+imsm.*-imsm.*$ /etc/mdadm.conf",
> GOTO="md_inc" +ENV{ID_FS_TYPE}=="isw_raid_member", \
> +	PROGRAM="/usr/bin/egrep -c ^AUTO.*-imsm.*$ /etc/mdadm.conf",
> GOTO="md_inc_end" ENV{ID_FS_TYPE}=="isw_raid_member", ACTION!="change",
> GOTO="md_inc" +
>  GOTO="md_inc_end"

For sure IMSM does not support it.

Thanks,
Mariusz
