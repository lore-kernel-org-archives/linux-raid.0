Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EF72CA0ECA
	for <linux-raid@archiver.kernel.org>; Tue, 12 Sep 2023 09:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbjILJtP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Sep 2023 05:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbjILJtN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 12 Sep 2023 05:49:13 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82BCBF
        for <linux-raid@vger.kernel.org>; Tue, 12 Sep 2023 02:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694512149; x=1726048149;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vE9+y3HJzGG4cmhMcHnfD2LCzRUJRTahMNqMZfr+8Ms=;
  b=XinHteQbtxN0jbC4nT5aJs4OojM7oYRwZAZdVtS4x+YgAe6RMHbIvdOw
   fCG8Itp74vIU0ohRwYI6qq6vGqpmQUEIrYIL2dRd7JjDPEJdUrOUMF4ii
   mHisZrB8AfITjcXBd0zfjIswXiRU/H8M36AT2FVy0Hw6FtT2qtEWmpBPj
   5V6hXtkgM9IjoLnomgXyKummkeClxEbdqqznqbA33Bt+0QucfiARkKSGG
   uQ7cPnlVZR8l4hGtk98/OxjoWspY5rH6WadY6MfS/Tm+aogdbqnkuk5bG
   eE09GkevfafMzFe3wZFgBoCrc0WeOe62w6azQe89C+iFUMluGfl0gmW6A
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="368585615"
X-IronPort-AV: E=Sophos;i="6.02,139,1688454000"; 
   d="scan'208";a="368585615"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2023 02:49:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="858735219"
X-IronPort-AV: E=Sophos;i="6.02,139,1688454000"; 
   d="scan'208";a="858735219"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.141.64])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2023 02:49:07 -0700
Date:   Tue, 12 Sep 2023 11:49:02 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     Kinga Tanska <kinga.tanska@intel.com>, linux-raid@vger.kernel.org,
        colyli@suse.de
Subject: Re: [PATCH] Assemble: fix redundant memory free
Message-ID: <20230912114902.00003e1c@linux.intel.com>
In-Reply-To: <20230912022701.948-1-kinga.tanska@intel.com>
References: <20230912022701.948-1-kinga.tanska@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 12 Sep 2023 04:27:01 +0200
Kinga Tanska <kinga.tanska@intel.com> wrote:

> Commit e9fb93af0f76 ("Fix memory leak in file Assemble")
> fixes few memory leaks in Assemble, but it introduces
> problem with assembling RAID volume. It was caused by
> clearing metadata too fast, not only on fail in
> select_devices() function.
> This commit removes redundant memory free.
> 
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> ---
>  Assemble.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/Assemble.c b/Assemble.c
> index 61e8cd17..5be58e40 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -428,8 +428,6 @@ static int select_devices(struct mddev_dev *devlist,
>  
>  			/* make sure we finished the loop */
>  			tmpdev = NULL;
> -			free(st);
> -			st = NULL;
>  			goto loop;
>  		} else {
>  			content = *contentp;

Hi Jes,
It is a regression. Please merge it ASAP, it broke a a lot of our tests.

Thanks,
Mariusz
