Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE95C433EF
	for <linux-raid@archiver.kernel.org>; Wed,  5 Jan 2022 20:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244157AbiAEUme (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 5 Jan 2022 15:42:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbiAEUmd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 5 Jan 2022 15:42:33 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6227FC061245
        for <linux-raid@vger.kernel.org>; Wed,  5 Jan 2022 12:42:33 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id w7so807223oiw.0
        for <linux-raid@vger.kernel.org>; Wed, 05 Jan 2022 12:42:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q9iK7Hsey8hRjYjiLiunP7I7JdEEO3oT4GSYPJgt3VE=;
        b=UOx/bTsZfum+2ApmD1CsBPjVacoHrUkVSN5fspHSp+i1EeeqJAMuoJv+63A4bbYTFH
         NrfU00UtyYgrlT8pO8fpaVJmXwCRPEolQwA1EFMxiU+k1pZPe2pzumqcZ9R5hx/WGwrg
         LTRDQNPEtTKx1coq7dQRWL9hBHPJumeHI8oSNVmWHzTzYQxDd4bUEQBsclKh4IiytBAH
         Lo30ZsH2yCEw3wki3EBmu4bJXDedmOo0pU+5YZvH2aHh/zWTnIWEHm8OhE2AFPBTLPD+
         /ed6dUKezST5R+670M9Q289lgsfB0jpS4pcs8+4AUmwIaxdXw+H3LObhYLzohglbxFcX
         FawQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q9iK7Hsey8hRjYjiLiunP7I7JdEEO3oT4GSYPJgt3VE=;
        b=w8sGYFEr8PAtKwLiOdjlLQqBGMQHUfwdUybK7JHjJ+iOTgHkGJsQ/Cd9SIFrB1rZYx
         61SYE0WhHmOi+RiUqu+qytoYgquPZsfcBfSdh6uttoq2zkoxNp1xZcmmUfAMfV0pknXl
         TL8GK3XyyYBW0L++FKNE7Fc5ugGIPZNXzioKLHkY1oXIQZlz4mG65dajyqEoPEPSxQ8q
         l0QXeDZrT8J7zwvIETfTOBhB4HD0rEvpQyuxQquq9u2g7232w2k+LI5mR4WxsoaxQodE
         HYfOXok76dFIVecxO7ZOfhnXyj6524BWVF1Y59PkaE2PzH35t6LtN+b0QusYrikd3W2Q
         Uddw==
X-Gm-Message-State: AOAM530io8S6DdhslsXl8tST67PS4NMsYmHwz8aIPqJWxSKoOKHhCeK3
        5i169LDcrWlqFvfNpp29xkk=
X-Google-Smtp-Source: ABdhPJwCAMB0XOMaahjwUd8wbJ+ZYkWkc8FypcWjNcTiD5P00WVcDkEHnGYAyB0Nj+iMtBlTiHYzOA==
X-Received: by 2002:a05:6808:20a0:: with SMTP id s32mr2744123oiw.23.1641415352741;
        Wed, 05 Jan 2022 12:42:32 -0800 (PST)
Received: from [192.168.0.92] (cpe-70-94-157-206.satx.res.rr.com. [70.94.157.206])
        by smtp.gmail.com with ESMTPSA id c4sm8504492ook.16.2022.01.05.12.42.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 12:42:32 -0800 (PST)
Subject: Re: mdadm regression tests fail
To:     Wols Lists <antlists@youngman.org.uk>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-raid@vger.kernel.org
Cc:     "Douglas R. Reno" <renodr2002@gmail.com>,
        Pierre Labastie <pierre.labastie@neuf.fr>
References: <c4c17b11-16f4-ef70-5897-02f923907963@gmail.com>
 <45492ddd-42f1-674f-af27-5e0a0aace8c9@infradead.org>
 <96d9e6d4-16e5-6bfe-fc5a-7d0dfbaeadf0@youngman.org.uk>
From:   Bruce Dubbs <bruce.dubbs@gmail.com>
Message-ID: <c85495ef-d5ef-e3b7-338d-4cc5173e0c55@gmail.com>
Date:   Wed, 5 Jan 2022 14:42:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <96d9e6d4-16e5-6bfe-fc5a-7d0dfbaeadf0@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

My point is that many of the tests fail.  It's not that someone should use the 
superblock v0.9.  That's only an example. The test should be removed or marked 
"Expected FAIL" or similar.  Our users run the tests as a confidence check that the 
build is successful.  They are generally not trying to debug the package.

I can certainly say that the tests are broken and leave it at that.  If it were only 
a couple of tests that fail, we generally say something like testA and testG are 
known to fail, but in this case fully half of the tests fail.

I would like to know what the maintainers think of the regression tests.  Are they 
maintained?  Should they all pass?  For our users there are far too many tests to run 
them individually.

   -- Bruce


On 1/5/22 11:44 AM, Wols Lists wrote:
> Bear in mind raid superblock v0.9 is deprecated as in "if it breaks it won't be fixed 
> for you".
> 
> So I would skip this test, and if you're mentioning raid in the handbook, tell people 
> they need to use one of the v1.x formats.
> 
> (NB - you can always point them at the linux raid wiki.)
> 
> Cheers,
> Wol
> 
> On 05/01/2022 17:12, Randy Dunlap wrote:
>> Hi.
>> [adding linux-raid mailing list]
>>
>>
>> On 1/4/22 10:55, Bruce Dubbs wrote:
>>> I am trying to document the mdadm-4.2 installation procedures for our book,
>>> https://www.linuxfromscratch.org/blfs/view/svn/postlfs/mdadm.html
>>>
>>> For testing, I am doing a simple:
>>>
>>>    make
>>>    sudo ./test --keep-going --logdir=test-logs --save-logs
>>>
>>> But I get failures for about half the tests.
>>>
>>> Digging in a bit I just ran:
>>>
>>>   sudo ./test --tests=00raid0 --logdir=test-logs
>>>
>>> This is the first test that fails.  With some hacking, it appears that the first 
>>> portion of this test that fails is:
>>>
>>>    mdadm -CR $md0 -e0.90 -l0 -n4 $dev0 $dev1 $dev2 $dev3
>>>
>>> This resolves to
>>>
>>>    mdadm -CR /dev/md0 -e0.90 -l0 -n4 /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3
>>>
>>> There is not a lot of error output in the test, so I manually ran:
>>>
>>>    dd if=/dev/zero of=/tmp/mdtest0 count=20000 bs=1K
>>>    losetup /dev/loop0 /tmp/mdtest0
>>>
>>> For /dev/loop[0123]
>>>
>>> Then I ran
>>>
>>>    mdadm -CR /dev/md0 -e0.90 -l0 -n4 /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3
>>>    mdadm: 0.90 metadata does not support layouts for RAID0
>>>
>>> My question is whether the regression tests in the tarball are valid for mdadm-4.2?
>>>
>>>    -- Bruce Dubbs
>>>       linuxfromscratch.org
>>>
>>> Note: The kernel is version 5.15.12.
>>
> 

