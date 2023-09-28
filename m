Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFE02CE7B11
	for <linux-raid@archiver.kernel.org>; Thu, 28 Sep 2023 09:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbjI1J2H (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Sep 2023 05:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbjI1J2F (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Sep 2023 05:28:05 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0BB1AC
        for <linux-raid@vger.kernel.org>; Thu, 28 Sep 2023 02:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695893281; x=1727429281;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y+Vpp6pSu5qB6L6UVgoub1/SPEcKyzLvl4YDPeWUDRc=;
  b=kk/3Hhp6yZ/EB8FZT2d6QK+8+ZUAGcAQgZKSIwSvTeSk6Z0L7n5jsopy
   DHGUu/Qfv6tM/IIfzQyJ+uyO4zhFeEqk3OYB8ZeenIhogBqTgZ3hw4xIj
   bPzsOXlg9KNZ6/IayX1lWFgY67uQvh/v2RdIzFFSqDyv2u8WnEd1aepoF
   87xUJzvKi9EU/wZFfkWl71efJEx0tbtub4Xu7IWXG804fYnJuJp5iCYxD
   W2ssVUNMxgLrjK+AuyYiWSgmm3hbuMUECXwkDKA2gvaIiel1OTimf92SG
   R6r927oOAh9b7/yhHsUSDRae07QUyvaEoniUojhBk57SPyW+JblHI7uI5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="448509923"
X-IronPort-AV: E=Sophos;i="6.03,183,1694761200"; 
   d="scan'208";a="448509923"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2023 02:27:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="752900732"
X-IronPort-AV: E=Sophos;i="6.03,183,1694761200"; 
   d="scan'208";a="752900732"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.152.98])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2023 02:27:57 -0700
Date:   Thu, 28 Sep 2023 11:27:52 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 2/4 v2] mdadm/tests: Don't run mknod before losetup
Message-ID: <20230928112752.0000135b@linux.intel.com>
In-Reply-To: <20230927025219.49915-3-xni@redhat.com>
References: <20230927025219.49915-1-xni@redhat.com>
        <20230927025219.49915-3-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 27 Sep 2023 10:52:17 +0800
Xiao Ni <xni@redhat.com> wrote:

> Sometimes it can fail:
> losetup: /var/tmp/mdtest0: failed to set up loop device: No such device or
> address /dev/loop0 and /var/tmp/mdtest0 are already created before losetup.
> 
> Because losetup can create device node by itself. So remove mknod.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  tests/func.sh | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tests/func.sh b/tests/func.sh
> index 9710a53b8a73..5053b0121f1d 100644
> --- a/tests/func.sh
> +++ b/tests/func.sh
> @@ -170,7 +170,6 @@ do_setup() {
>  				dd if=/dev/zero of=$targetdir/mdtest$d
> count=$sz bs=1K > /dev/null 2>&1 # make sure udev doesn't touch
>  			mdadm --zero $targetdir/mdtest$d 2> /dev/null
> -			[ -b /dev/loop$d ] || mknod /dev/loop$d b 7 $d
>  			if [ $d -eq 7 ]
>  			then
>  				losetup /dev/loop$d $targetdir/mdtest6 # for
> multipath use

Hello,
Same as in previous case, it is waiting for Jes:
https://patchwork.kernel.org/project/linux-raid/patch/20230908084435.30674-1-xni@redhat.com/

I'm ignoring this one.
Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Thanks,
Mariusz
