Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E92C9CA0ECA
	for <linux-raid@archiver.kernel.org>; Tue, 12 Sep 2023 13:40:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235592AbjILNkX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Sep 2023 09:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbjILNkW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 12 Sep 2023 09:40:22 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFDD10CE
        for <linux-raid@vger.kernel.org>; Tue, 12 Sep 2023 06:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694526018; x=1726062018;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uhel42wcwMwd0k1BdH7W2pRwJPJpbRpj8o+//8WxQXc=;
  b=Krs+iSOJ4EV5vVhyHZ/KxRil5pgJS8R0hsQ4Iotgyd2e6sMy/GS6/KCF
   Jg46u9iq/P8KsNotMXVrysluSnwszRz4yoU+kKh0cSk350gWQ8+QGCmfY
   qqhV05LDsPNaSw4YImRbUB45E/fPkJYLs82llQx3uRsMqfD05XEkPeLAu
   15S2EY7dACdnyHWwcw2nx1GtB2EnBV7dqlzHrLhkyXW0vZ2mzX7mEp4yX
   OblK9fN6SgsWIJ+YEmsnLwYaXjtZD/3XaKZ6Ouv2AiuVrVtrjpNHaPA6J
   5L6jZaRjUjrc2sxXPSIXUNpEnBdyPqsQhQq6aFbZZ1RksaPpGpTuo8++E
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="444810622"
X-IronPort-AV: E=Sophos;i="6.02,139,1688454000"; 
   d="scan'208";a="444810622"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2023 06:40:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="737123396"
X-IronPort-AV: E=Sophos;i="6.02,139,1688454000"; 
   d="scan'208";a="737123396"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.141.64])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2023 06:40:16 -0700
Date:   Tue, 12 Sep 2023 15:40:11 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        AceLan Kao <acelan@gmail.com>,
        "yukuai (C)" <yukuai3@huawei.com>,
        "yangerkun@huawei.com" <yangerkun@huawei.com>
Subject: Re: [PATCH v2] md: do not _put wrong device in md_seq_next
Message-ID: <20230912154011.00007399@linux.intel.com>
In-Reply-To: <5a71d6a0-c971-1e28-110d-a6ad2f81cda0@huaweicloud.com>
References: <20230912130124.666-1-mariusz.tkaczyk@linux.intel.com>
        <5a71d6a0-c971-1e28-110d-a6ad2f81cda0@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 12 Sep 2023 21:25:24 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> Hi,
> 
> ÔÚ 2023/09/12 21:01, Mariusz Tkaczyk Ð´µÀ:
> > During working on changes proposed by Kuai [1], I determined that
> > mddev->active is continusly decremented for array marked by MD_CLOSING.
> > It brought me to md_seq_next() changed by [2]. I determined the regression
> > here, if mddev_get() fails we updated mddev pointer and as a result we
> > _put failed device.  
> 
> This mddev is decremented while there is another mddev increased, that's
> why AceLan said that single array can't reporduce the problem.
> 
> And because mddev->active is leaked, then del_gendisk() will never be
> called for the mddev while closing the array, that's why user will
> always see this array, cause infiniate loop open -> stop array -> close
> for systemd-shutdown.

Ohh, I see the scenario now...
First array can be successfully stopped. We marked MD_DELETED and proceed
with scheduling wq but in the middle of that md_seq_next() increased active for
other array and decrement active for the one with MD_DELETED.
For this next array we are unable to reach active == 0 anymore.

Song, let me know if you need description like that in commit message.

Thanks!
Mariusz
