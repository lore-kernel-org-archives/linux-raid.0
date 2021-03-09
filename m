Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C5FBC433E0
	for <linux-raid@archiver.kernel.org>; Tue,  9 Mar 2021 09:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F93864F73
	for <linux-raid@archiver.kernel.org>; Tue,  9 Mar 2021 09:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbhCIJB4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 9 Mar 2021 04:01:56 -0500
Received: from mga18.intel.com ([134.134.136.126]:30697 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229520AbhCIJBr (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 9 Mar 2021 04:01:47 -0500
IronPort-SDR: ab+H8LzKLClsuNLV2CB1btJvITJcNb+NvKRyGJMSPCXXDbrIapvlr4ZgRTEED7wXl7ePrTfRtL
 G6K5tF4Tn66w==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="175797810"
X-IronPort-AV: E=Sophos;i="5.81,234,1610438400"; 
   d="scan'208";a="175797810"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2021 01:01:44 -0800
IronPort-SDR: uFfbKikXrnvG+SNYA1lq4aewUMrACyJZ64GMJaIvr9GSRntVRoC7HGw398Zy+p9Nuw3DCil2uY
 1IuQ6mUNYPoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,234,1610438400"; 
   d="scan'208";a="437594263"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga002.fm.intel.com with ESMTP; 09 Mar 2021 01:01:44 -0800
Received: from [10.213.24.57] (mtkaczyk-MOBL1.ger.corp.intel.com [10.213.24.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 6D486580717;
        Tue,  9 Mar 2021 01:01:43 -0800 (PST)
Subject: Re: [PATCH] mdmonitor: check if udev has finished events processing
To:     Jes Sorensen <jes@trained-monkey.org>,
        Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20210114141416.42934-1-oleksandr.shchirskyi@intel.com>
 <a5f929eb-5103-1646-b321-65886157c9cc@trained-monkey.org>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <51ec46c1-c632-b3a9-010f-8f13aee0e02c@linux.intel.com>
Date:   Tue, 9 Mar 2021 10:01:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <a5f929eb-5103-1646-b321-65886157c9cc@trained-monkey.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 08.03.2021 16:23, Jes Sorensen wrote:

> I think it is reasonable to require libudev in 2021, so I have applied
> this. However if someone feels there is a reason to not have this build
> requirement, I will also accept a patch to make this dependency optional.

Hi Jes,

If community agrees for adding this dependency, I think that is a good
time to drop all legacy code for handling cases if udev is not available.
This code is dead, we cannot compile mdadm without libudev.

Do you agree?

Mariusz
