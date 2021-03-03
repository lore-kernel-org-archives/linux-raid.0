Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43610C1550A
	for <linux-raid@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EA2E64F45
	for <linux-raid@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236893AbhCCX75 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 3 Mar 2021 18:59:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:54172 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242631AbhCCLqP (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 3 Mar 2021 06:46:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2929EAD2B;
        Wed,  3 Mar 2021 11:45:12 +0000 (UTC)
Subject: Re: [RFC PATCH v1 1/6] badblocks: add more helper structure and
 routines in badblocks.h
To:     Hannes Reinecke <hare@suse.de>
Cc:     antlists@youngman.org.uk, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        linux-raid@vger.kernel.org, vishal.l.verma@intel.com,
        linux-nvdimm@lists.01.org, linux-block@vger.kernel.org,
        neilb@suse.de
References: <20210302040252.103720-1-colyli@suse.de>
 <20210302040252.103720-2-colyli@suse.de>
 <96a899a9-151e-ff8c-c61c-900df1122357@suse.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <01aee83b-89d6-6048-ebfc-d07be1aaea7e@suse.de>
Date:   Wed, 3 Mar 2021 19:45:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <96a899a9-151e-ff8c-c61c-900df1122357@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/3/21 4:20 PM, Hannes Reinecke wrote:
> On 3/2/21 5:02 AM, Coly Li wrote:
>> This patch adds the following helper structure and routines into
>> badblocks.h,
>> - struct bad_context
>>   This structure is used in improved badblocks code for bad table
>>   iteration.
>> - BB_END()
>>   The macro to culculate end LBA of a bad range record from bad
>>   table.
>> - badblocks_full() and badblocks_empty()
>>   The inline routines to check whether bad table is full or empty.
>> - set_changed() and clear_changed()
>>   The inline routines to set and clear 'changed' tag from struct
>>   badblocks.
>>
>> These new helper structure and routines can help to make the code more
>> clear, they will be used in the improved badblocks code in following
>> patches.
>>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> ---
>>  include/linux/badblocks.h | 32 ++++++++++++++++++++++++++++++++
>>  1 file changed, 32 insertions(+)
>>
>> diff --git a/include/linux/badblocks.h b/include/linux/badblocks.h
>> index 2426276b9bd3..166161842d1f 100644
>> --- a/include/linux/badblocks.h
>> +++ b/include/linux/badblocks.h
>> @@ -15,6 +15,7 @@
>>  #define BB_OFFSET(x)	(((x) & BB_OFFSET_MASK) >> 9)
>>  #define BB_LEN(x)	(((x) & BB_LEN_MASK) + 1)
>>  #define BB_ACK(x)	(!!((x) & BB_ACK_MASK))
>> +#define BB_END(x)	(BB_OFFSET(x) + BB_LEN(x))
>>  #define BB_MAKE(a, l, ack) (((a)<<9) | ((l)-1) | ((u64)(!!(ack)) << 63))
>>  
>>  /* Bad block numbers are stored sorted in a single page.
>> @@ -41,6 +42,14 @@ struct badblocks {
>>  	sector_t size;		/* in sectors */
>>  };
>>  
>> +struct bad_context {
>> +	sector_t	start;
>> +	sector_t	len;
>> +	int		ack;
>> +	sector_t	orig_start;
>> +	sector_t	orig_len;
>> +};
>> +
> Maybe rename it to 'badblocks_context'.
> It's not the context which is bad ...
> 

Copied, I will modify it in next version.

Thanks for the suggestion.

Coly Li

