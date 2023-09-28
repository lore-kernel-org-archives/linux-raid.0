Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D86CE7B17
	for <linux-raid@archiver.kernel.org>; Thu, 28 Sep 2023 09:53:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjI1Jxd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Sep 2023 05:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjI1Jxc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Sep 2023 05:53:32 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F0695
        for <linux-raid@vger.kernel.org>; Thu, 28 Sep 2023 02:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695894810; x=1727430810;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LemNzHL8c5654c0K6zh86X+GxR9jat9udoispU2z7Ek=;
  b=NT1rLNAB6+JfhaGiyZ1mnL+dLfT+NFfMWOahne9TeJxnZcHNUhL8qzhZ
   s4w93gUEs/v73War2NrecHgE7Zy5Eiye7+DLrYY1HOB9umvJRMrXPGWLO
   KyqMjt9yndTdDPXoMpvPPOrVXz3VyLHAbETLPveppUcYHmBpA+QRtCHoJ
   rNh1LKVYBzZlR6OZgPXX7+0rFP/32kWWBSOTGHbJfEko+taAlOmY6lNA1
   jDCv1xWyzImN5XM9x62m3PgnYhVhnuOd4LsPGVUDV+ExzEn9oiffVE8jx
   Nj7qY0PbWsVFayp1duljRvAXRMcHjun8Kjy7h384fMU+JQivHcoznGRhH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="367083838"
X-IronPort-AV: E=Sophos;i="6.03,183,1694761200"; 
   d="scan'208";a="367083838"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2023 02:53:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="784635664"
X-IronPort-AV: E=Sophos;i="6.03,183,1694761200"; 
   d="scan'208";a="784635664"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.152.98])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2023 02:53:28 -0700
Date:   Thu, 28 Sep 2023 11:53:23 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 4/4] mdadm: Print version to stdout
Message-ID: <20230928115323.00001e3f@linux.intel.com>
In-Reply-To: <20230927025219.49915-5-xni@redhat.com>
References: <20230927025219.49915-1-xni@redhat.com>
        <20230927025219.49915-5-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 27 Sep 2023 10:52:19 +0800
Xiao Ni <xni@redhat.com> wrote:

> The version information is not error information. Print it
> to stdout.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  mdadm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mdadm.c b/mdadm.c
> index 076b45e030b3..0b8854baf1aa 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -128,7 +128,7 @@ int main(int argc, char *argv[])
>  			continue;
>  
>  		case 'V':
> -			fputs(Version, stderr);
> +			fputs(Version, stdout);
>  			exit(0);
>  
>  		case 'v': c.verbose++;

I agree with this change but...
This one is risky for users. I can realize that some users may check that
from stderr because it is how we implemented it many years ago.

I remember that I removed calls to mdam --help from dracut in the past:
https://github.com/mtkaczyk/dracut/commit/d3d37003dcecdf01f6ae0f4764d74cd035aade73#diff-f2466410e3aff8aeba95038d29b1652581c97d8d7d9feb4011d7b8bc103de1b0L64

And I can see that it does redirection "2>&1". I think that in general this kind
of problem is handled this way, so overall I ready to take the risk of changing
it to stdout by default.

Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Thanks,
Mariusz
