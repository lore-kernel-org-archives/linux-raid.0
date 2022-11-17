Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E3EC433FE
	for <linux-raid@archiver.kernel.org>; Thu, 17 Nov 2022 14:29:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239353AbiKQO3W (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 17 Nov 2022 09:29:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239711AbiKQO2y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 17 Nov 2022 09:28:54 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFD02AE3B
        for <linux-raid@vger.kernel.org>; Thu, 17 Nov 2022 06:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668695334; x=1700231334;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=21izwsQGsdT9AuZs7xSLypA7pA3Flw78iePejMYdHus=;
  b=mW3bvcQcs9+TsWiAwJTP0PMLpi7ckT15Fh0NuJMZA/7aGAOah7wDWmJ6
   9hMy/lMltTqgVx5uIAxgeDWEM6lvQeNczJQQSJPUKMvJ841Fx2BDk191r
   m3hfEqLMvw8AUy7elqATlS17ORnhC6XQ6GktniNSamY+9tbmyAmC6KYWd
   3sdBcj8OGSJuqb6AH3e5yJCAuMhq7O9ylsyQOeFJMRJnY0gTRJe1CLLUG
   1d6JMhhQchMz1DD2a5TJXpqODsM4H71G20VAfnFab8uflZCsJx8lEzY21
   70kDOmY0i77DUIcPhGsSsjYb26xYUzyOAoQOrP61/F52LmZLIMZv1fRNS
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="310492397"
X-IronPort-AV: E=Sophos;i="5.96,171,1665471600"; 
   d="scan'208";a="310492397"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 06:28:53 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="884886569"
X-IronPort-AV: E=Sophos;i="5.96,171,1665471600"; 
   d="scan'208";a="884886569"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.213.28.141])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 06:28:48 -0800
Date:   Thu, 17 Nov 2022 15:28:43 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     NeilBrown <neilb@suse.de>, Jes Sorensen <jsorensen@fb.com>,
        Song Liu <song@kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Zdenek Kabelac <zkabelac@redhat.com>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [PATCH] mdadm: fix compilation failure on the x32 ABI
Message-ID: <20221117152843.00002f30@linux.intel.com>
In-Reply-To: <alpine.LRH.2.21.2211040957470.19553@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.21.2211040957470.19553@file01.intranet.prod.int.rdu2.redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 4 Nov 2022 10:01:22 -0400 (EDT)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
> 
> Here I'm sending a patch for the mdadm utility. It fixes compile failure 
> on the x32 ABI.
> 
> Mikulas
> 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> The x32 ABI has 32-bit long and 64-bit time_t. Consequently, it reports 
> printf arguments mismatch when attempting to print time using the "%ld" 
> format specifier.
> 
> Fix this by converting times to long long and using %lld when printing
> them.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  monitor.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: mdadm/monitor.c
> ===================================================================
> --- mdadm.orig/monitor.c	2022-11-04 14:25:52.000000000 +0100
> +++ mdadm/monitor.c	2022-11-04 14:28:05.000000000 +0100
> @@ -449,9 +449,9 @@ static int read_and_act(struct active_ar
>  	}
>  
>  	gettimeofday(&tv, NULL);
> -	dprintf("(%d): %ld.%06ld state:%s prev:%s action:%s prev: %s
> start:%llu\n",
> +	dprintf("(%d): %lld.%06lld state:%s prev:%s action:%s prev: %s
> start:%llu\n", a->info.container_member,
> -		tv.tv_sec, tv.tv_usec,
> +		(long long)tv.tv_sec, (long long)tv.tv_usec,
>  		array_states[a->curr_state],
>  		array_states[a->prev_state],
>  		sync_actions[a->curr_action],
> 
Hi Mikulas,
This is just a debug log in mdmon, feel free to remove the time totally.

Thanks,
Mariusz
