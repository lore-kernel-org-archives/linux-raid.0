Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD7DC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 21 Mar 2022 13:53:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348178AbiCUNye (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 21 Mar 2022 09:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348238AbiCUNyE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 21 Mar 2022 09:54:04 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC82016E215
        for <linux-raid@vger.kernel.org>; Mon, 21 Mar 2022 06:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647870753; x=1679406753;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f1myvLb487qw4dQIZVE6qyiRy5ese9u3UfrcN2YfXsY=;
  b=Doav+g0u60YfmP8WSIglE3K41AsiknDPH0hsbB2dbedHiy8jCWPlNavU
   SaceIr8yOzH/lU9izvi/5xmMIXCLI/jNrvEg8O3yP9KfJtClgFyfL5UcD
   yrDjGl7dVxlk3VFLffqy5pPsTIwvog8wn1aAgrKH0jMxlh3tmpolJkbI7
   hZ0gC8zCZx9jm7P1faAml5hoS/UUsERQQul00obAc3vbgobZVMyEZYZ4y
   GPqUp4gUCPaXTeDbx6yi5o7UuurqA3VXL5LcUmkURC3uvIEupr8cbvuXH
   EYUpG3MpuRv7lAm3LI/y067+B/mM74bOtAqswAdkWKcE552uIZ0ne7m/t
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10292"; a="237498715"
X-IronPort-AV: E=Sophos;i="5.90,198,1643702400"; 
   d="scan'208";a="237498715"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 06:52:33 -0700
X-IronPort-AV: E=Sophos;i="5.90,198,1643702400"; 
   d="scan'208";a="559879856"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.7.104])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 06:52:31 -0700
Date:   Mon, 21 Mar 2022 14:52:26 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Kinga Tanska <kinga.tanska@intel.com>, jes@trained-monkey.org,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH] Assemble: check if device is container before
 scheduling force-clean update
Message-ID: <20220321145226.00003e01@linux.intel.com>
In-Reply-To: <da2d2717-c278-62bc-d1e5-e0d371b66f9b@suse.de>
References: <20220209090940.11973-1-kinga.tanska@intel.com>
 <da2d2717-c278-62bc-d1e5-e0d371b66f9b@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, 19 Mar 2022 23:12:36 +0800
Coly Li <colyli@suse.de> wrote:

> Hi Kinga,
> 
> 
> I am fine with the above idea, except the extra is_container(). IMHO 
> comparing directly with LEVEL_CONTAINER is fine, adding
> is_container() doesn't help too much.
> 
> 

Hi Coly,

It is used in many places and is long. This is the main reason we
changed that. As you can see, some ifs was simplified and readability
is improved.
Generally, if something is repeated two or more times, it should be
gathered inside function. This simplifies future changes (for example
if we decide to add other level check here). Also it simplifies code
analysis (IDE will show us all usages) and it gives basic description.
In this case it could be redundant but IMO it is a design we should
follow.

We already proposed similar inline for raid456 in other patch.

Thanks,
Mariusz
