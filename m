Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B878FC4332F
	for <linux-raid@archiver.kernel.org>; Thu, 15 Dec 2022 11:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiLOLug (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 15 Dec 2022 06:50:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiLOLuf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 15 Dec 2022 06:50:35 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF16629CB0
        for <linux-raid@vger.kernel.org>; Thu, 15 Dec 2022 03:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671105034; x=1702641034;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=diw2kwnueiH4nQLzIDy2MwakKk/7TWik5mKL+OMxSJM=;
  b=Y+DAWQL7ONqt3tPTBdorPY94o5qTER3Fe7BR5kP+3ZQedN2Zw5Br0gRT
   l4SOq+JAMhkHmWfWcXh3affkzCYDLY7Z8N58nBilyb/FEOCuknObqIf3Y
   lVixOlbZ47jcCcGszuynnBcCy0j5X5+Pch/RjrMIV49jp2g2jB0Zet37W
   u0SCZk2An+0Hucu3KbPpi32ICiklajz/60vgiMZhHllT/iZ76/0Wvnc38
   dLuz12tTZx4CAww1WqtcoClE4KPJCoJ9r3VksB89dq7ZSuhNTEyV/dEHS
   aBCVAMEUJmXHn2spCRYpCZSXyLUXFXn9hDFAP26/yhK+bgIXGzzGxZrDK
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="298335372"
X-IronPort-AV: E=Sophos;i="5.96,247,1665471600"; 
   d="scan'208";a="298335372"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 03:50:34 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="627160544"
X-IronPort-AV: E=Sophos;i="5.96,247,1665471600"; 
   d="scan'208";a="627160544"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.41.164])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 03:50:32 -0800
Date:   Thu, 15 Dec 2022 12:50:27 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     lixiaokeng <lixiaokeng@huawei.com>
Cc:     Jes Sorensen <jes@trained-monkey.org>,
        <linux-raid@vger.kernel.org>, linfeilong <linfeilong@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        Wu Guanghao <wuguanghao3@huawei.com>
Subject: Re: [PATCH V2] Fix NULL dereference in super_by_fd
Message-ID: <20221215125027.00002a45@linux.intel.com>
In-Reply-To: <c2cb8668-afc8-459a-9c91-9b0002fbeaa0@huawei.com>
References: <c2cb8668-afc8-459a-9c91-9b0002fbeaa0@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 14 Dec 2022 11:17:41 +0800
lixiaokeng <lixiaokeng@huawei.com> wrote:

> strcpy(st->devnm, devnm);

Hi,
Please use strncpy or snprintf here.

Thanks,
Mariusz
