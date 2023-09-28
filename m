Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61807CE7B10
	for <linux-raid@archiver.kernel.org>; Thu, 28 Sep 2023 09:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbjI1JZK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Sep 2023 05:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbjI1JZE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Sep 2023 05:25:04 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3999CC2
        for <linux-raid@vger.kernel.org>; Thu, 28 Sep 2023 02:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695893094; x=1727429094;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r62hy+Pa1ieaHX78u1sfOz+vWWoQn0cysjRCFEtQogs=;
  b=kyrvfY2aPwdMwERZKHNfEHMtXIDyqcZGtLX9EVwoVdNKM/XecxprphyJ
   v9BK8bqpjAmnylR1sWmtSKTmAPzV+c5CEYvn2dEQ7iwf5aYTuykwUCEnV
   +JXQ9fvXW7daIpH9BuDUjE2sRSD0IvjfJa93/IvjMXNgrGRtfSgHva7P5
   91w6PKyD7baNx/z0SMxWTkjgvgWu5av3rJO6xx6Am7qdcbZZLMh1Dos0i
   UHDc8XGfloC4u0UrnQIkIC7FNvOUv+BUFtbR13WzWwECY8xmQr/cuUuhB
   8nCqB9puUX6+GsYq2ZL0bVXQ5l4XeZPaxATPiTxLATnuyw+kNkB0WZE7r
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="385883080"
X-IronPort-AV: E=Sophos;i="6.03,183,1694761200"; 
   d="scan'208";a="385883080"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2023 02:24:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="699203424"
X-IronPort-AV: E=Sophos;i="6.03,183,1694761200"; 
   d="scan'208";a="699203424"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.152.98])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2023 02:24:52 -0700
Date:   Thu, 28 Sep 2023 11:24:48 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/4 v2] mdadm/tests: Fix regular expression failure
Message-ID: <20230928112448.000010f6@linux.intel.com>
In-Reply-To: <20230927025219.49915-2-xni@redhat.com>
References: <20230927025219.49915-1-xni@redhat.com>
        <20230927025219.49915-2-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 27 Sep 2023 10:52:16 +0800
Xiao Ni <xni@redhat.com> wrote:

> The test fails because of the regular expression.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  tests/06name | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/06name b/tests/06name
> index 4d5e824d3e0e..86eaab69e3a1 100644
> --- a/tests/06name
> +++ b/tests/06name
> @@ -3,8 +3,8 @@ set -x
>  # create an array with a name
>  
>  mdadm -CR $md0 -l0 -n2 --metadata=1 --name="Fred" $dev0 $dev1
> -mdadm -E $dev0 | grep 'Name : [^:]*:Fred ' > /dev/null || exit 1
> -mdadm -D $md0 | grep 'Name : [^:]*:Fred ' > /dev/null || exit 1
> +mdadm -E $dev0 | grep 'Name : Fred' > /dev/null || exit 1
> +mdadm -D $md0 | grep 'Name : Fred' > /dev/null || exit 1
>  mdadm -S $md0
>  
>  mdadm -A $md0 --name="Fred" $devlist

Hello Xiao,
I can see that it is not sent first time. Previous version was moved by me to
the "awaiting_upstream" state on patchwork but I forgot to answer.
You don't need to send it again. I'm ignoring this one. Anyway, here my
approval:

Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

https://patchwork.kernel.org/project/linux-raid/patch/20230907085744.18967-1-xni@redhat.com/

Thanks,
Mariusz
