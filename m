Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02C89C4338F
	for <linux-raid@archiver.kernel.org>; Mon, 23 Aug 2021 15:36:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D887060FBF
	for <linux-raid@archiver.kernel.org>; Mon, 23 Aug 2021 15:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhHWPhS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 23 Aug 2021 11:37:18 -0400
Received: from mga04.intel.com ([192.55.52.120]:62468 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231656AbhHWPhS (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 23 Aug 2021 11:37:18 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="215284091"
X-IronPort-AV: E=Sophos;i="5.84,344,1620716400"; 
   d="scan'208";a="215284091"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2021 08:36:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,344,1620716400"; 
   d="scan'208";a="443475594"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga002.jf.intel.com with ESMTP; 23 Aug 2021 08:36:34 -0700
Received: from [10.213.3.223] (mtkaczyk-MOBL1.ger.corp.intel.com [10.213.3.223])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 266E25808AC;
        Mon, 23 Aug 2021 08:36:33 -0700 (PDT)
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Subject: Re: [PATCH V3] Fix buffer size warning for strcpy
To:     Nigel Croxon <ncroxon@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
References: <20210823143525.2517040-1-ncroxon@redhat.com>
Message-ID: <1c777af7-dda5-4332-74d0-0d4e1ba58031@linux.intel.com>
Date:   Mon, 23 Aug 2021 17:36:31 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210823143525.2517040-1-ncroxon@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 23.08.2021 16:35, Nigel Croxon wrote:
> To meet requirements of Common Criteria certification vulnerability
> assessment. Static code analysis has been run and found the following
> error:
> buffer_size_warning: Calling "strncpy" with a maximum size
> argument of 16 bytes on destination array "ve->name" of
> size 16 bytes might leave the destination string unterminated.
> 

Yeah, please ignore my comment to v2- the task here it remove error, not
to acknowledge it.

> +		int l = strlen(ve->name);
> +		if (l > 16)
> +			l = 16;
I think that whole "if" statement can be replaced by:
strnlen(ve->name, sizeof(ve->name))
> +		memcpy(ve->name, name, l);
> +	}

