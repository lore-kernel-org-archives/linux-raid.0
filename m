Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07FC3C4338F
	for <linux-raid@archiver.kernel.org>; Mon, 23 Aug 2021 06:55:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D670261220
	for <linux-raid@archiver.kernel.org>; Mon, 23 Aug 2021 06:55:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234933AbhHWGzz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 23 Aug 2021 02:55:55 -0400
Received: from mga07.intel.com ([134.134.136.100]:28963 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231779AbhHWGzy (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 23 Aug 2021 02:55:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10084"; a="280768073"
X-IronPort-AV: E=Sophos;i="5.84,343,1620716400"; 
   d="scan'208";a="280768073"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2021 23:55:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,343,1620716400"; 
   d="scan'208";a="507165692"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga001.jf.intel.com with ESMTP; 22 Aug 2021 23:55:12 -0700
Received: from [10.213.3.223] (mtkaczyk-MOBL1.ger.corp.intel.com [10.213.3.223])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id B803F580418;
        Sun, 22 Aug 2021 23:55:10 -0700 (PDT)
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Subject: Re: [PATCH V2] Fix buffer size warning for strcpy
To:     Nigel Croxon <ncroxon@redhat.com>, neilb@suse.de,
        jes@trained-monkey.org, xni@redhat.com, linux-raid@vger.kernel.org
References: <20210819131017.2511208-1-ncroxon@redhat.com>
Message-ID: <5d28eff3-d693-92c5-6e84-54846b36a480@linux.intel.com>
Date:   Mon, 23 Aug 2021 08:55:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210819131017.2511208-1-ncroxon@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 19.08.2021 15:10, Nigel Croxon wrote:

> +	memset(ve->name, '\0', sizeof(ve->name));
> +	if (name) {
> +		int l = strlen(ve->name);
> +		if (l > 16)
> +			l = 16;
> +		memcpy(ve->name, name, l);
> +	}

What about:
if (name)
	/*
	 * Name might not be null terminated.
	 */
	strncpy(ve->name, name, sizeof(ve->name));
else
	memset(ve->name, '\0', sizeof(ve->name));

If size is less than sizeof(ve->name) then strncpy will automatically
fill rest with "\0".

Mariusz
