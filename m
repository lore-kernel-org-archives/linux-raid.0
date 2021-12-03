Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16704C433F5
	for <linux-raid@archiver.kernel.org>; Fri,  3 Dec 2021 14:59:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381615AbhLCPCd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Dec 2021 10:02:33 -0500
Received: from mga17.intel.com ([192.55.52.151]:43037 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243873AbhLCPCc (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 3 Dec 2021 10:02:32 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10186"; a="217674077"
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="217674077"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 06:59:06 -0800
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="513732967"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.0.98])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 06:59:05 -0800
Date:   Fri, 3 Dec 2021 15:59:00 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Subject: Re: mdadm last call for 4.2
Message-ID: <20211203155900.00002fcf@linux.intel.com>
In-Reply-To: <285f7faf-c40e-4484-9256-8732f07c7335.maildroid@localhost>
References: <9508576c-ef82-253b-1e5e-37c7d2f39aad@trained-monkey.org>
        <7A27EF9C-0844-4ED5-9C07-F0BAE9EDBD72@getmailspring.com>
        <285f7faf-c40e-4484-9256-8732f07c7335.maildroid@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jes,
Thanks for waiting. This one is important:
https://lore.kernel.org/linux-raid/20211203143115.4544-1-blazej.kucman@intel.com/

Please also look into this one, I hope that problem is clear now:
https://lore.kernel.org/linux-raid/BN9PR11MB5339A4F4E6C52FF7C4646084E4629@BN9PR11MB5339.namprd11.prod.outlook.com/

Thanks,
Mariusz
