Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31E37C4338F
	for <linux-raid@archiver.kernel.org>; Tue, 24 Aug 2021 13:07:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15C8D61374
	for <linux-raid@archiver.kernel.org>; Tue, 24 Aug 2021 13:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237298AbhHXNHr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 24 Aug 2021 09:07:47 -0400
Received: from mga05.intel.com ([192.55.52.43]:31361 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237363AbhHXNHq (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 24 Aug 2021 09:07:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="302887249"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="302887249"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 06:07:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="515449785"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga004.fm.intel.com with ESMTP; 24 Aug 2021 06:06:58 -0700
Received: from [10.237.140.108] (mtkaczyk-MOBL1.ger.corp.intel.com [10.237.140.108])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 1F6765808BC;
        Tue, 24 Aug 2021 06:06:56 -0700 (PDT)
Subject: Re: [PATCH V4] Fix buffer size warning for strcpy
To:     Nigel Croxon <ncroxon@redhat.com>, jes@trained-monkey.org,
        linux-raid@vger.kernel.org
References: <20210824123007.2776483-1-ncroxon@redhat.com>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <891a1b41-d860-fd86-489c-beb44fdd291e@linux.intel.com>
Date:   Tue, 24 Aug 2021 15:06:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210824123007.2776483-1-ncroxon@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Nigel,

> -	memset(ve->name, ' ', 16);
> +	memset(ve->name, '\0', sizeof(ve->name));
>   	if (name)
> -		strncpy(ve->name, name, 16);
> +		memcpy(ve->name, name, strnlen(ve->name, sizeof(ve->name)));
>   	ddf->virt->populated_vdes =
>   		cpu_to_be16(be16_to_cpu(ddf->virt->populated_vdes)+1);

As I wrote under v3, you should use 'name' instead 've->name' in strnlen.
've->name' has length 0. You can also consider usage of memccpy.

Thanks,
Mariusz
