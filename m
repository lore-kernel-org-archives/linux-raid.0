Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7235C433E6
	for <linux-raid@archiver.kernel.org>; Tue, 16 Mar 2021 14:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98AA165092
	for <linux-raid@archiver.kernel.org>; Tue, 16 Mar 2021 14:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237621AbhCPOy6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 16 Mar 2021 10:54:58 -0400
Received: from mga05.intel.com ([192.55.52.43]:17077 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237578AbhCPOy3 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 16 Mar 2021 10:54:29 -0400
IronPort-SDR: zdUZOrnwl/aJ8pF1igbkBqhFo0MRP06my0WGdL0q3RLih16yLrXMTHmVJk5HOlC9tL0eP3RJz7
 nZGFNfGmMP/A==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="274314798"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="274314798"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 07:54:26 -0700
IronPort-SDR: AQqAV3Nq07Oj+z1SHazu3kyZHsf1w5XPe6iw8armg/a1Z6WsWM5+f28QOjumPy/dpQoTeHu7P5
 0bWHvLOab9vQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="440108339"
Received: from linux.intel.com ([10.54.29.200])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Mar 2021 07:54:26 -0700
Received: from [10.249.154.67] (mtkaczyk-MOBL1.ger.corp.intel.com [10.249.154.67])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 2FB095807EA;
        Tue, 16 Mar 2021 07:54:24 -0700 (PDT)
Subject: Re: [PATCH] mdadm: fix reshape from RAID5 to RAID6 with backup file
To:     Jes Sorensen <jes@trained-monkey.org>,
        Nigel Croxon <ncroxon@redhat.com>, linux-raid@vger.kernel.org,
        xni@redhat.com
References: <20210120200542.19139-1-ncroxon@redhat.com>
 <84ed6e32-3b69-f13d-b1b8-33166c92e5ab@trained-monkey.org>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <eb0060d3-756d-c6f9-66d7-bcd7b0468bf7@linux.intel.com>
Date:   Tue, 16 Mar 2021 15:54:22 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <84ed6e32-3b69-f13d-b1b8-33166c92e5ab@trained-monkey.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Nigel,

Blame told us, that yours patch introduce regression in following
scenario:

#mdadm -CR imsm0 -e imsm -n4 /dev/nvme[0125]n1
#mdadm -CR volume -l0 --chunk 64 --raid-devices=1 /dev/nvme0n1 --force
#mdadm -G /dev/md/imsm0 -n2

At the end of reshape, level doesn't back to RAID0.
Could you look into it?
Let me know, if you need support.

Thanks,
Mariusz
