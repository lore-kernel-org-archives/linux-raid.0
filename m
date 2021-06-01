Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E0D5C4708F
	for <linux-raid@archiver.kernel.org>; Tue,  1 Jun 2021 16:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E10F5613E7
	for <linux-raid@archiver.kernel.org>; Tue,  1 Jun 2021 16:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbhFAQgS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 1 Jun 2021 12:36:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:42739 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234017AbhFAQgQ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 1 Jun 2021 12:36:16 -0400
IronPort-SDR: BjlW1R/+YkF341W/bH6h1eW3Koxlc88uHox9PNocKZmaAaRVfXEt/4nLof9u0AreRe8F5VpTxn
 rTYpYd2so5Pw==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="200571292"
X-IronPort-AV: E=Sophos;i="5.83,240,1616482800"; 
   d="scan'208";a="200571292"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 09:34:34 -0700
IronPort-SDR: h8ADUHe5DXNe+RQ7HsqATo6JvpSpyDGh0X16nOoK7qY5HNcZeMSYnctF55qGz9oCzerZQVlXTS
 /IQ1aiDd6Qmw==
X-IronPort-AV: E=Sophos;i="5.83,240,1616482800"; 
   d="scan'208";a="479346276"
Received: from oshchirs-mobl.ger.corp.intel.com (HELO [10.213.27.34]) ([10.213.27.34])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 09:34:33 -0700
Subject: Re: [PATCH 1/1] It needs to check offset array is NULL or not in
 async_xor_offs
To:     Song Liu <song@kernel.org>, Xiao Ni <xni@redhat.com>
Cc:     Nigel Croxon <ncroxon@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
References: <1622182598-13110-1-git-send-email-xni@redhat.com>
 <CAPhsuW5O0ii77JFpYTB+RyPKzHmqQDGdr+8wMC4=CNtv=_daNg@mail.gmail.com>
From:   Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>
Message-ID: <9bb16539-d084-c2ba-256b-bc0901bccf7d@linux.intel.com>
Date:   Tue, 1 Jun 2021 18:34:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAPhsuW5O0ii77JFpYTB+RyPKzHmqQDGdr+8wMC4=CNtv=_daNg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/1/2021 12:53 AM, Song Liu wrote:
> On Thu, May 27, 2021 at 11:16 PM Xiao Ni <xni@redhat.com> wrote:
>>
>> Now we support sharing one big page when PAGE_SIZE is not equal 4096.
>> 4096 bytes is the default stripe size. To support this it adds a
>> page offset array in raid5_percpu's scribble. It passes the page
>> offset array to async_xor_offs. But there are some users that don't
>> use the page offset array. In raid5-ppl.c, async_xor passes NULL to
>> asynx_xor_offs. So it needs to check src_offs is NULL or not.
>>
>> Fixes: ceaf2966ab08(async_xor: increase src_offs when dropping destination page)
>> Reported-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>
>> Signed-off-by: Xiao Ni <xni@redhat.com>
> 
> Oleksandr,
> 
> Could you please verify this fixes the issue, and reply with your Tested-by?
> 
> Thanks,
> Song
> 

I can confirm that this patch fixes a NULL pointer dereference issue for me.
Thanks for the fix!

Tested-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>

>> ---
>>   crypto/async_tx/async_xor.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
>> index 6cd7f70..d8a9152 100644
>> --- a/crypto/async_tx/async_xor.c
>> +++ b/crypto/async_tx/async_xor.c
>> @@ -233,7 +233,8 @@ async_xor_offs(struct page *dest, unsigned int offset,
>>                  if (submit->flags & ASYNC_TX_XOR_DROP_DST) {
>>                          src_cnt--;
>>                          src_list++;
>> -                       src_offs++;
>> +                       if (src_offs)
>> +                               src_offs++;
>>                  }
>>
>>                  /* wait for any prerequisite operations */
>> --
>> 2.7.5
>>


Regards,
Oleksandr Shchirskyi
