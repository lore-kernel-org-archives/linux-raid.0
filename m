Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CEA7C4338F
	for <linux-raid@archiver.kernel.org>; Wed, 25 Aug 2021 15:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFFD66109E
	for <linux-raid@archiver.kernel.org>; Wed, 25 Aug 2021 15:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbhHYPih (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 25 Aug 2021 11:38:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:37353 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233573AbhHYPih (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 25 Aug 2021 11:38:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10087"; a="214422439"
X-IronPort-AV: E=Sophos;i="5.84,351,1620716400"; 
   d="scan'208";a="214422439"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 08:37:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,351,1620716400"; 
   d="scan'208";a="464812262"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga007.jf.intel.com with ESMTP; 25 Aug 2021 08:37:50 -0700
Received: from [10.213.22.91] (mtkaczyk-MOBL1.ger.corp.intel.com [10.213.22.91])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 005795808BB;
        Wed, 25 Aug 2021 08:37:49 -0700 (PDT)
Subject: Re: [PATCH V5] Fix buffer size warning for strcpy
To:     Nigel Croxon <ncroxon@redhat.com>, jes@trained-monkey.org,
        linux-raid@vger.kernel.org
References: <20210825153014.2780505-1-ncroxon@redhat.com>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <bca34a46-1e94-6885-78da-45ff2eb43b6a@linux.intel.com>
Date:   Wed, 25 Aug 2021 17:37:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210825153014.2780505-1-ncroxon@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 25.08.2021 17:30, Nigel Croxon wrote:
> To meet requirements of Common Criteria certification vulnerability
> assessment. Static code analysis has been run and found the following
> error:
> buffer_size_warning: Calling "strncpy" with a maximum size
> argument of 16 bytes on destination array "ve->name" of
> size 16 bytes might leave the destination string unterminated.
> https://people.redhat.com/ncroxon/mdadm-4.2-rc2-scan-results.html
> 
> The change is to make the destination size to fit the allocated size.
> 
> V5:
> Simplify the the strnlen call.
> 
> V4:
> Code cleanup of the interim "if" statement.
> 
> V3: Doc change only:
> The code change from filling ve->name with spaces to filling it with
> null-terminated is to comform to the SNIA - Common RAID Disk Data
> Format Specification. The format for VD_Name (ve->name) specifies
> the field to be either ASCII or UNICODE. Bit 2 of the VD_Type field
> MUST be used to determine the Unicode or ASCII format of this field.
> If this field is not used, all bytes MUST be set to zero.
> 
> V2: Change from zero-terminated to zero-padded on memset and
> change from using strncpy to memcpy, feedback from Neil Brown.
> 
> Tested-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
> ---
>   super-ddf.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/super-ddf.c b/super-ddf.c
> index dc8e512f..2eb617e6 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -2637,9 +2637,11 @@ static int init_super_ddf_bvd(struct supertype *st,
>   		ve->init_state = DDF_init_not;
>   
>   	memset(ve->pad1, 0xff, 14);
> -	memset(ve->name, ' ', 16);
> -	if (name)
> -		strncpy(ve->name, name, 16);
> +	memset(ve->name, '\0', sizeof(ve->name));
> +	if (name) {
> +		int l = strnlen(name, sizeof(ve->name));
> +		memcpy(ve->name, name, l);
> +	}
>   	ddf->virt->populated_vdes =
>   		cpu_to_be16(be16_to_cpu(ddf->virt->populated_vdes)+1);
>   
> 

Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
