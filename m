Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3DE7C74A5B
	for <linux-raid@archiver.kernel.org>; Thu, 23 Mar 2023 15:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbjCWP3Q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Mar 2023 11:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232156AbjCWP3O (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Mar 2023 11:29:14 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F9734317
        for <linux-raid@vger.kernel.org>; Thu, 23 Mar 2023 08:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679585348; x=1711121348;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xe7cMoX5nEw+nbmSlaZ0ANw1cSns8GXN1TZKjvxPL10=;
  b=NBgapu71B2+3It7s/WeLo4YMGctXQWBgedR2Ljy6k3UILKJZjCf/eHDo
   BMXdjDe0XYvh5lJQvhr8mO3kIJ899gE5JLA7bIw7DFKEq4mNMqx67MEdt
   ur0pKW52GdY5zF2LxZlQSWgqaYig8mwxar8QkLCd/ZXCVXKtxDfVPpgdW
   X+lj+7w6QujwHx/FZ5HeJ4fXWOn5IzGxHQ5/JVuT/bEhD81lE8jOhKZlz
   UPojuXCntzLPTb0+cuBMQrQ6N6LBWdAaenvI1Ns+NDUa1AfbyopiKMrh3
   iVXHCfr0hnEC/v9/gjX4/PqcBbYrsA1t6x30GkdsWiKsh9HQxvmUBxOma
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="323385413"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="323385413"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 08:29:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="714856752"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="714856752"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.62.238])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 08:29:06 -0700
Date:   Thu, 23 Mar 2023 16:29:01 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org
Subject: Re: [PATCH v2] Create: Fix checking for container in
 update_metadata
Message-ID: <20230323162901.00005b0a@linux.intel.com>
In-Reply-To: <20230323115000.25364-1-mateusz.grzonka@intel.com>
References: <20230323115000.25364-1-mateusz.grzonka@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jes,
Please merge this to unblock our upstream testing :)

Thanks,
Mariusz

On Thu, 23 Mar 2023 12:50:00 +0100
Mateusz Grzonka <mateusz.grzonka@intel.com> wrote:

> The commit 8a4ce2c05386 ("Create: Factor out add_disks() helpers")
> introduced a regression that caused timeouts and udev failing to create
> links.
> 
> Steps to reproduce the issue were as following:
> $ mdadm -CR imsm -e imsm -n4 /dev/nvme[0-3]n1
> $ mdadm -CR vol -l5 -n4 /dev/nvme[0-3]n1 --assume-clean
> 
> I found the check for container was wrong because negation was missing.
> 
> Fixes: 8a4ce2c05386 ("Create: Factor out add_disks() helpers")
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
> ---
>  Create.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Create.c b/Create.c
> index bbe9e13d..0911bf92 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -328,7 +328,7 @@ static int update_metadata(int mdfd, struct shape *s,
> struct supertype *st,
>  	 * again returns container info.
>  	 */
>  	st->ss->getinfo_super(st, &info_new, NULL);
> -	if (st->ss->external && is_container(s->level) &&
> +	if (st->ss->external && !is_container(s->level) &&
>  	    !same_uuid(info_new.uuid, info->uuid, 0)) {
>  		map_update(map, fd2devnm(mdfd),
>  			   info_new.text_version,

