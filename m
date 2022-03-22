Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13BCEC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 22 Mar 2022 15:29:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235796AbiCVPaa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 22 Mar 2022 11:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235805AbiCVPa3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 22 Mar 2022 11:30:29 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60E48BE05
        for <linux-raid@vger.kernel.org>; Tue, 22 Mar 2022 08:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647962941; x=1679498941;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JUyyY3FhLWUCRknI9ixGWwwGH+LpK5h5rod48hT8AjE=;
  b=crtQrW3fZkMaXLfKRLAQ84IAFXmHi2Q7QUS8vu+qPxkHcPLLmqxO7LKT
   T2QLrm0FASUPDYsKSmVpTBqjtOIlKsoqmK4vOl/1UG7tf2D2gvnSJL1rr
   WDJbGCI8qDbrlApXBl1v9/FKc8iqe3Un7shTM/d42wTdJVu8sv8ZiagjL
   vnf6XkeGGDdn8EMljj2oD40lOiMVJEE/X0tW3nSKML4TGPMSntQHBO37y
   1CZWhhyPiaT4YaFXDvn6KZU9wtsEdgMiDnNeSzgi2OlJcp8kPfZj9cmOn
   MB2jVrYUFiqGYPjFjAzundxP3HFK4BqwqCeojPmUX2yW/TsO/4/Hb26Km
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="282686431"
X-IronPort-AV: E=Sophos;i="5.90,201,1643702400"; 
   d="scan'208";a="282686431"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 08:29:01 -0700
X-IronPort-AV: E=Sophos;i="5.90,201,1643702400"; 
   d="scan'208";a="518924956"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.10.5])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 08:28:59 -0700
Date:   Tue, 22 Mar 2022 16:28:54 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org, Coly Li <colyli@suse.de>
Cc:     linux-raid@vger.kernel.org
Subject: Re: [PATCH 0/2] Add map_num_s
Message-ID: <20220322162854.00005881@linux.intel.com>
In-Reply-To: <20220120121833.16055-1-mariusz.tkaczyk@linux.intel.com>
References: <20220120121833.16055-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Coly,
Could you review?

Thanks,
Mariusz

On Thu, 20 Jan 2022 13:18:31 +0100
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:
> Hi Jes,
> In this patchset not null version of map_num() was added.
> Additionally, I propagaded default_layout() for Build mode.
> 
> I tested changes and I didn't find any regression.
> 
> Mariusz Tkaczyk (2):
>   Create, Build: use default_layout()
>   mdadm: add map_num_s()
> 
>  Assemble.c    |  6 ++---
>  Build.c       | 23 +-----------------
>  Create.c      | 67
> +++++++++++++++++++++++++++++++-------------------- Detail.c      |
> 4 +-- Grow.c        | 16 ++++++------
>  Query.c       |  4 +--
>  maps.c        | 24 ++++++++++++++++++
>  mdadm.c       | 20 +++++++--------
>  mdadm.h       |  3 ++-
>  super-ddf.c   |  6 ++---
>  super-intel.c |  2 +-
>  super0.c      |  2 +-
>  super1.c      |  2 +-
>  sysfs.c       |  9 ++++---
>  14 files changed, 103 insertions(+), 85 deletions(-)
> 

