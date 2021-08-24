Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA8A4C4338F
	for <linux-raid@archiver.kernel.org>; Tue, 24 Aug 2021 07:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B11DE610D0
	for <linux-raid@archiver.kernel.org>; Tue, 24 Aug 2021 07:35:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234865AbhHXHgD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 24 Aug 2021 03:36:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:50338 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235010AbhHXHfz (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 24 Aug 2021 03:35:55 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="214132112"
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="214132112"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 00:35:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="443714576"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga002.jf.intel.com with ESMTP; 24 Aug 2021 00:35:11 -0700
Received: from [10.237.140.108] (mtkaczyk-MOBL1.ger.corp.intel.com [10.237.140.108])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id AD0055805CB;
        Tue, 24 Aug 2021 00:35:10 -0700 (PDT)
Subject: Re: [PATCH V3] Fix buffer size warning for strcpy
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
To:     Nigel Croxon <ncroxon@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
References: <20210823143525.2517040-1-ncroxon@redhat.com>
 <1c777af7-dda5-4332-74d0-0d4e1ba58031@linux.intel.com>
Message-ID: <92a90fb5-c9d7-92ea-2133-307fdb96e2a2@linux.intel.com>
Date:   Tue, 24 Aug 2021 09:35:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1c777af7-dda5-4332-74d0-0d4e1ba58031@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Nigel,
It current form it is not working. See my finding below.

On 23.08.2021 17:36, Tkaczyk, Mariusz wrote:
> 
>> +        int l = strlen(ve->name);
i think that you want to use name instead of ve->name.
length of ve->name is zero after memset.

>> +        if (l > 16)
>> +            l = 16;
> I think that whole "if" statement can be replaced by:
> strnlen(ve->name, sizeof(ve->name))

I did a mistake here.
I want to suggest usage of:
l = strnlen(name, sizeof(ve->name));

>> +        memcpy(ve->name, name, l);
>> +    }
>
Thanks,
Mariusz
