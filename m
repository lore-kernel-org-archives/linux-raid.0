Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E811EC77B7A
	for <linux-raid@archiver.kernel.org>; Wed, 31 May 2023 15:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbjEaPbb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 31 May 2023 11:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbjEaPb2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 31 May 2023 11:31:28 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E1310E
        for <linux-raid@vger.kernel.org>; Wed, 31 May 2023 08:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685547087; x=1717083087;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2+CWrNL0aMAY7FaBDnkhD5xU9At7V9DxeviYNZQ3pVs=;
  b=ZjCqwFz6uARFu0cjBA3d+JNJC/9OPiaeiJggTZGsuRq7T6WTCV+HSAmY
   40nCPdS7ZY4HWRqFfDjWszFWloYqgL5AZeS3tEdURwO7ekyY6fd7Tm1y3
   AYRO7Wu0kKEOeWNusy8J4nc3vhJ+yZVB282u+5m0X+5qdLk4bqsoArWx3
   j6ymlIUOXDrZf/glCZRiSOhlXqWK5U1MI2QMvO+rttMTixfn4y2gAzXJ1
   aRLc7rxmyOgI0VDayhMPNsCL7Xf16cWCa4KlIhzF5gjWiK/Wqz9mOcywx
   1YitdfiX3XSWLubZ7wh8tQegMMCbGTsEi3i1E7Af/U1iBYlgLQVFKubao
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="344787261"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="344787261"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 08:31:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="657367546"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="657367546"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.132.89])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 08:30:59 -0700
Date:   Wed, 31 May 2023 17:30:54 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, colyli@suse.de
Subject: Re: [PATCH 0/6] imsm: expand improvements
Message-ID: <20230531173054.00003622@linux.intel.com>
In-Reply-To: <20230531152108.18103-1-mariusz.tkaczyk@linux.intel.com>
References: <20230531152108.18103-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 31 May 2023 17:21:02 +0200
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:

> merge_extents() was initially designed to support creation only. Expand
> feature was added later and the current code was not updated properly.
> Now, we can see two issues:
> 1. --size=max used with expand and create result in different array size.
> 2. In scenarios, where volume were deleted an recreated it may not be
> possible to expand the volume.
> 
> The patchset addresses listed issues and removes limitation to the last
> volume for expand.
> 
> Mariusz Tkaczyk (6):
>   imsm: move sum_extents calculations to merge_extents()
>   imsm: imsm_get_free_size() refactor.
>   imsm: introduce round_member_size_to_mb()
>   imsm: move expand verification code into new function
>   imsm: return free space after volume for expand
>   imsm: fix free space calculations
> 
>  super-intel.c | 363 ++++++++++++++++++++++++++++----------------------
>  1 file changed, 202 insertions(+), 161 deletions(-)
> 

Sent by mistake. Please ignore this.

Sorry for noise,
Mariusz
