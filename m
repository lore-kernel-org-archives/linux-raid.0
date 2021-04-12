Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C838CC433ED
	for <linux-raid@archiver.kernel.org>; Mon, 12 Apr 2021 14:39:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C5E9610CA
	for <linux-raid@archiver.kernel.org>; Mon, 12 Apr 2021 14:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242700AbhDLOkF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Apr 2021 10:40:05 -0400
Received: from mga18.intel.com ([134.134.136.126]:21253 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242616AbhDLOjl (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 12 Apr 2021 10:39:41 -0400
IronPort-SDR: ECtrO1SepQ1CD/KkFrhliMC3vRDayKZedzSqKt+2CtItMP+027TSztCBheh5fzPwo8Rdvj2dWq
 wuAb20H3albQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9952"; a="181724098"
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="181724098"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2021 07:39:21 -0700
IronPort-SDR: z/BzO9f+8rPO16K0RigMye8B4rgfbmtEuDRfluHO/ahhbMzFUWEuqwI1DW4k2B8jJis2il2pRq
 FY1i/8Q+iF2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="420426244"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga007.jf.intel.com with ESMTP; 12 Apr 2021 07:39:21 -0700
Received: from [10.213.0.224] (mtkaczyk-MOBL1.ger.corp.intel.com [10.213.0.224])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 9803A5802B1;
        Mon, 12 Apr 2021 07:39:20 -0700 (PDT)
Subject: new mdadm release
References: <b8589184-3b64-61fc-fd4c-1e12a91da4ce@linux.intel.com>
To:     Jes Sorensen <jes@trained-monkey.org>,
        linux-raid <linux-raid@vger.kernel.org>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
X-Forwarded-Message-Id: <b8589184-3b64-61fc-fd4c-1e12a91da4ce@linux.intel.com>
Message-ID: <be13bd5f-d448-5682-c896-de5abef64be5@linux.intel.com>
Date:   Mon, 12 Apr 2021 16:39:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <b8589184-3b64-61fc-fd4c-1e12a91da4ce@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jes,
IMSM part is seems to be ready now. No new issue occurs.
Could you please mark release candidate on current top?

Sorry for noice, I forgot to add mailing list.

Thanks,
Mariusz
