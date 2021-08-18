Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F96C4338F
	for <linux-raid@archiver.kernel.org>; Wed, 18 Aug 2021 18:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA8F66108D
	for <linux-raid@archiver.kernel.org>; Wed, 18 Aug 2021 18:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbhHRSWr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 18 Aug 2021 14:22:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58103 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229448AbhHRSWq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 18 Aug 2021 14:22:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629310931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FX1pRda3GcFUHm3oV7Xpyf7jtj1gPZce4Vf6SH1akwQ=;
        b=UHlXxqjnJ+zhrhvn4pOm+/lJTjHhe+VAh3b26epGrP4vXMBJ4neAegEXAQP91Unw5ggCvh
        BoOXe7FiXP8G6ENW20FmvT207Hm9FwmSC6JcmaaQ08UOYxE2qWIV7N4EA6ay0VeXa/8W3y
        mXQTb0NaCm7F4JKLvIvBxgFWIvA1ly8=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-x2Fq3MliP_-8ws246ajJ_A-1; Wed, 18 Aug 2021 14:22:09 -0400
X-MC-Unique: x2Fq3MliP_-8ws246ajJ_A-1
Received: by mail-qv1-f70.google.com with SMTP id l16-20020a0cc2100000b029035a3d6757b3so2767793qvh.14
        for <linux-raid@vger.kernel.org>; Wed, 18 Aug 2021 11:22:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FX1pRda3GcFUHm3oV7Xpyf7jtj1gPZce4Vf6SH1akwQ=;
        b=r5I4dhmpskZv7yMtyR44gfbnmqk1q1uOFEokS5v2icJON+MfzxE0SVi2XzQXmover7
         hmIbs+AWi0uSSkZztT3Expn2rHzSG9QAZqpaUwhLliHYuyEmKX5aKOuKN6wV1m9drcO4
         tkS1ti3b2sWYXu0mIArLIpsXGfmsjIE3iE46LyqRUcf+hL0NP2EXcgMK1UhDu0LjxJHY
         EBVjMttXkAMz6romxGuHYuz+pmVpjzPPL7DF09Smw0KFHtQkNRXh6wLg4F8fE6U8jQDQ
         nNdLeD7qrs9P5Fds99/guvo18oaNcsbbBr5C5AyiE1gU+IY9IMmwbS14DjmRwXXJOGjh
         a1gA==
X-Gm-Message-State: AOAM530ilRnqSmZa9B+Z6NaKwMwTNmkw1mJfzNUDyUd8WubQVtm48WQM
        xPtMA8tWxDNDz3izWk7Re+rB+JRQbR2ZpKqyaFECvpJviX7TpI70JrkUc6kS4vDK5AfKpyajCcQ
        l6ZDc18gPq83BNt2X4JYep0HmhB9yr3Nf6zsuPr3N97hkfoQCJQ9b9AhzbXifhhIIJlDLxPco
X-Received: by 2002:a05:620a:2844:: with SMTP id h4mr11114114qkp.388.1629310929373;
        Wed, 18 Aug 2021 11:22:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZ1q/AU/mFev8q94uYc2l/N2zrcbqHVE2+Wm6po/G4B2cB4Fh8bbXxgPrsedg62fZAluxE1Q==
X-Received: by 2002:a05:620a:2844:: with SMTP id h4mr11114085qkp.388.1629310929103;
        Wed, 18 Aug 2021 11:22:09 -0700 (PDT)
Received: from ?IPv6:2601:18c:600:e550::566a? ([2601:18c:600:e550::566a])
        by smtp.gmail.com with ESMTPSA id y15sm294464qko.78.2021.08.18.11.22.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 11:22:08 -0700 (PDT)
Subject: Re: [PATCH] Fix potential overlap dest buffer
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     jes@trained-monkey.org, mariusz.tkaczyk@linux.intel.com,
        neilb@suse.de, xni@redhat.com, linux-raid@vger.kernel.org
References: <20210817131448.2496995-1-ncroxon@redhat.com>
 <6ffc271e-c24e-aaf7-7392-0041f26e4bf2@molgen.mpg.de>
From:   Nigel Croxon <ncroxon@redhat.com>
Message-ID: <72098bc8-4429-6711-8b90-d5bf1e195ad8@redhat.com>
Date:   Wed, 18 Aug 2021 14:22:07 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <6ffc271e-c24e-aaf7-7392-0041f26e4bf2@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/18/21 2:34 AM, Paul Menzel wrote:
> Dear Nigel,
> 
> 
> Am 17.08.21 um 15:14 schrieb Nigel Croxon:
>> To meet requirements of Common Criteria certification vulnerablility
> 
> vulnerability
> 
>> assessment.
> 
> That’s only part of a sentence? Is that supposed to be read as a 
> continuation of the commit message summary: … to meet requirements …?
> 

Continuation of the commit message. Thanks for catching the
spelling mistake.

>> Static code analysis has been run and found the following
>> error.  Overlapping_buffer: The source buffer potentially overlaps
> 
> It’d be great, if you denoted, which tool was run. Maybe even add a 
> Found-by tag.
> 

I ran the Coverity scan on the latest build.
https://people.redhat.com/ncroxon/mdadm-4.2-rc2-scan-results.html


>> with the destination buffer, which results in undefined
>> behavior for "memcpy".
>>
>> The change is to use memmove instead of memcpy.
>>
>> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
>> ---
>>   sha1.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/sha1.c b/sha1.c
>> index 11be7045..89b32f46 100644
>> --- a/sha1.c
>> +++ b/sha1.c
>> @@ -258,7 +258,7 @@ sha1_process_bytes (const void *buffer, size_t 
>> len, struct sha1_ctx *ctx)
>>       {
>>         sha1_process_block (ctx->buffer, 64, ctx);
>>         left_over -= 64;
>> -      memcpy (ctx->buffer, &ctx->buffer[16], left_over);
>> +      memmove (ctx->buffer, &ctx->buffer[16], left_over);
>>       }
>>         ctx->buflen = left_over;
>>       }
> 
> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
> 
> 
> Kind regards,
> 
> Paul
> 

