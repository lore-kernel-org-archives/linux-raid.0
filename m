Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BDFFC4338F
	for <linux-raid@archiver.kernel.org>; Thu, 12 Aug 2021 06:49:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F52C61019
	for <linux-raid@archiver.kernel.org>; Thu, 12 Aug 2021 06:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234641AbhHLGtw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 12 Aug 2021 02:49:52 -0400
Received: from mga05.intel.com ([192.55.52.43]:32153 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233567AbhHLGtv (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 12 Aug 2021 02:49:51 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10073"; a="300877065"
X-IronPort-AV: E=Sophos;i="5.84,315,1620716400"; 
   d="scan'208";a="300877065"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 23:49:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,315,1620716400"; 
   d="scan'208";a="422443599"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga003.jf.intel.com with ESMTP; 11 Aug 2021 23:49:26 -0700
Received: from [10.213.3.5] (mtkaczyk-MOBL1.ger.corp.intel.com [10.213.3.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 684C75808D9;
        Wed, 11 Aug 2021 23:49:25 -0700 (PDT)
Subject: Re: [PATCH V2] Fix return value from fstat calls
To:     Nigel Croxon <ncroxon@redhat.com>, jes@trained-monkey.org,
        linux-raid@vger.kernel.org, xni@redhat.com
References: <20210810151507.1667518-1-ncroxon@redhat.com>
 <20210811190930.1822317-1-ncroxon@redhat.com>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <0506adac-d237-c03f-fbf3-12bd862598da@linux.intel.com>
Date:   Thu, 12 Aug 2021 08:49:23 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210811190930.1822317-1-ncroxon@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Nigel,
On 11.08.2021 21:09, Nigel Croxon wrote:

> +				pr_err("fstat failed for %s: %s\n",devname, strerror(errno));
> +		pr_err("fstat failed from %s: %s\n",fname, strerror(errno));
Typo, I guess that you want to use "for".

> +			pr_err("fstat failed for %s: %s\n",dev, strerror(errno));
> +		pr_err("fstat failed for %s: %s\n",devname, strerror(errno));
> +		pr_err("fstat failed for %s: %s\n",devname, strerror(errno));
> +		pr_err("fstat failed: %s\n", strerror(errno));
> +			pr_err("fstat failed: %s\n", strerror(errno));
> +		pr_err("fstat failed for %s: %s\n",devname, strerror(errno));
> +		pr_err("fstat failed for %s: %s\n",devname, strerror(errno));

> +		pr_err("fstat failed for %s: %s\n",devname, strerror(errno));
> +		pr_err("fstat failed for %s: %s\n",devname, strerror(errno));

You are using similar error message across code. If you think that printing
error in this case is worth to be added then please define wrapper for fstat
with error message and use that.
Current solution is typo friendly (and I found one) and breaks DNRY rule.
Any modern C IDE is able to find references- result is same as in search via
string in case of error.

Mariusz
