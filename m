Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6DBAC433ED
	for <linux-raid@archiver.kernel.org>; Fri, 16 Apr 2021 07:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACD61610E7
	for <linux-raid@archiver.kernel.org>; Fri, 16 Apr 2021 07:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238711AbhDPHUX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Apr 2021 03:20:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:2686 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230466AbhDPHUW (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 16 Apr 2021 03:20:22 -0400
IronPort-SDR: v/nY9OCLCQRa+wYbOrSpiBf9TSxnBVDmxf2/dgXeZPvgPr0o+ZFUZQSJ+t3pW5KCH4/UJTwcZc
 LoYJZZpP6uTw==
X-IronPort-AV: E=McAfee;i="6200,9189,9955"; a="191812738"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="191812738"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 00:19:58 -0700
IronPort-SDR: Qm6Xq35NTLCe55kvFaDMV7PW88niOcnuC+FvaY6s6JlX2j9QzP7SeD1kxZNDKRVlO3LYLftvoJ
 SkHuvxMTHBZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="453241717"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga002.fm.intel.com with ESMTP; 16 Apr 2021 00:19:58 -0700
Received: from [10.213.3.95] (mtkaczyk-MOBL1.ger.corp.intel.com [10.213.3.95])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 62C5158090C;
        Fri, 16 Apr 2021 00:19:56 -0700 (PDT)
Subject: Re: mdadm-4.2-rc1
To:     Jes Sorensen <jes.sorensen@gmail.com>,
        "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
References: <a1e3bf9d-0e92-c88e-13a1-7d2f6482fb01@gmail.com>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <07c7605c-113c-5fc9-06d7-8881e33207fb@linux.intel.com>
Date:   Fri, 16 Apr 2021 09:19:53 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <a1e3bf9d-0e92-c88e-13a1-7d2f6482fb01@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 14.04.2021 17:22, Jes Sorensen wrote:
> I have pushed mdadm-4.2-rc1 to git and there should be binaries pushed
> as well.
> 
> Note I had to fix checking the return value of get_dev_sector_size() in
> super-intel.c. I think I got it right, but I don't have a test machine
> with IMSM at the moment, so please test I didn't break it.
> 
> Thanks,
> Jes
> 

Hello,
Looks good, no new issue observed.

Thanks,
Mariusz
