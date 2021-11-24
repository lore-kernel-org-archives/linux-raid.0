Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B520C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 24 Nov 2021 15:47:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242107AbhKXPun (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Nov 2021 10:50:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:47190 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232464AbhKXPun (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 24 Nov 2021 10:50:43 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="222522662"
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="222522662"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 07:47:33 -0800
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="497714087"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO mtkaczyk-MOBL1) ([10.213.25.233])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 07:47:32 -0800
Date:   Wed, 24 Nov 2021 16:47:30 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Message-ID: <7A27EF9C-0844-4ED5-9C07-F0BAE9EDBD72@getmailspring.com>
In-Reply-To: <9508576c-ef82-253b-1e5e-37c7d2f39aad@trained-monkey.org>
References: <9508576c-ef82-253b-1e5e-37c7d2f39aad@trained-monkey.org>
Subject: Re: mdadm last call for 4.2
X-Mailer: Mailspring
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Hi Jes,

> Any last minute serious bugfixes needed for 4.2?
Yes, there is one. We are valdating name length limitation to
prevent buffer overflows in create_mddev().
Could you wait for it?

Thanks,
Mariusz

