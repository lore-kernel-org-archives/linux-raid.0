Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA09C4338F
	for <linux-raid@archiver.kernel.org>; Fri, 13 Aug 2021 07:00:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3372460234
	for <linux-raid@archiver.kernel.org>; Fri, 13 Aug 2021 07:00:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239058AbhHMHAz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 Aug 2021 03:00:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:65334 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238988AbhHMHAz (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 13 Aug 2021 03:00:55 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10074"; a="237556535"
X-IronPort-AV: E=Sophos;i="5.84,318,1620716400"; 
   d="scan'208";a="237556535"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 00:00:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,318,1620716400"; 
   d="scan'208";a="422783078"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga003.jf.intel.com with ESMTP; 13 Aug 2021 00:00:27 -0700
Received: from [10.213.30.238] (mtkaczyk-MOBL1.ger.corp.intel.com [10.213.30.238])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 84A29580C55;
        Fri, 13 Aug 2021 00:00:26 -0700 (PDT)
Subject: Re: [PATCH V2] Fix return value from fstat calls
To:     NeilBrown <neilb@suse.de>, Nigel Croxon <ncroxon@redhat.com>
Cc:     jes@trained-monkey.org, xni@redhat.com, linux-raid@vger.kernel.org
References: <20210810151507.1667518-1-ncroxon@redhat.com>
 <20210811190930.1822317-1-ncroxon@redhat.com>
 <162872237888.31578.18083659195262526588@noble.neil.brown.name>
 <346e8651-d861-45c7-9058-68008e691b93@Canary>
 <162881060124.15074.6150940509008984778@noble.neil.brown.name>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <5b71689a-6d07-0dfd-a4b6-26322ee3136e@linux.intel.com>
Date:   Fri, 13 Aug 2021 09:00:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <162881060124.15074.6150940509008984778@noble.neil.brown.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 13.08.2021 01:23, NeilBrown wrote:
>>
>> The fstat() function will fail if:
>> [EBADF] - The fildes argument is not a valid file descriptor.
> 
> But we never pass an invalid file descriptor
> 
We can't guarantee that. There is always a minimal chance to pass
wrong/invalid argument caused by bug somewhere else in mdadm logic.
I think that handling such case is reasonable from security point
of view but agree that it could be a dead check (if everything is
well implemented).

> And you didn't list "EFAULT", but of course we never pass an invalid
> memory address either.

As before, we can't guarantee it, too. For now it seems to be well handled
but implementation may change and vulnerability might be missed during
review. Is safer to handle that some way.

>> [EIO] - An I/O error occurred while reading from the file system.
> 
> fstat() doesn't do IO, it just reports data from the cache.
> 
>> [EOVERFLOW] - The file size in bytes or the number of blocks allocated to the file or the file serial number cannot be represented correctly in the structure pointed to by buf.
>>
>> The fstat() function may fail if:
>>
>> [EOVERFLOW] - One of the values is too large to store into the structure pointed to by the buf argument.
>>
> 
> Those don't happen in practice for the fstat() calls that mdadm makes
> either.
> 
Agree, but it could be changed.

> I think this patch is adding noise to the source code without actually
> providing any real value.  I would much prefer that if you really feel
> there is value, then just add a wrapper:
> 
> int  safe_fstat(....)
> {
>      int ret = fstat(.....);
>      char message[]="mdadm: fstat failed, so aborting\n"
>      if (ret == 0)
>           return 0;
>      write(2, message, sizeof(message)-1);
>      exit(1);
> }
> 
> Then just change every "fstat" in the code that bothers you to
> "safe_fstat()".
> 
> This approach of adding pointless checks because some static analysis
> tool thinks you should is not an approach that I approve of.

Maybe It won't be useful for users but it may help developers to avoid
trivial mistakes. As you told, if everything is fine then check is dead.
In my opinion any error handling is better than nothing.

Anyway, I think that there is a lot of more dangerous lines.

Regards,
Mariusz
