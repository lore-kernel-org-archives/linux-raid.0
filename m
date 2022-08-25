Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 343FEC04AA5
	for <linux-raid@archiver.kernel.org>; Thu, 25 Aug 2022 06:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234647AbiHYGPT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 25 Aug 2022 02:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234067AbiHYGPS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 25 Aug 2022 02:15:18 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEEC9F76A
        for <linux-raid@vger.kernel.org>; Wed, 24 Aug 2022 23:15:16 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4861E5C7D6;
        Thu, 25 Aug 2022 06:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661408115; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y7CtPUm1RZJnkIR7ivbP+SWgP37+0kEjcnU84ZILhcA=;
        b=MfdDGhxs0b5kfp8XLgGUJXYcnYMchWO0D3DVDLNeteeyuf2x7iAYXleBNUrDaUwXxjBDeE
        bgW2xcap5yrTrdyNClByPnIDpDOAjnJBrEWqdxoKXeomoMER8KFkiwQ94P8qc6wPbnRPZL
        8q8wV/Wr6dd3N+pEjAExdM4W3MzAyxg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661408115;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y7CtPUm1RZJnkIR7ivbP+SWgP37+0kEjcnU84ZILhcA=;
        b=4s1kIdBUCcwEVM2w19wRiF+fsT8JsMp1bjQWSUKOaOmpqRoWhlbjj9BC2GPhWot94/qKLY
        b0u6omZRWIxkFHAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DCBA313A89;
        Thu, 25 Aug 2022 06:15:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0xcZMnITB2O2MwAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 25 Aug 2022 06:15:14 +0000
Message-ID: <f40217bd-5db4-65e9-0829-5d652281f3f2@suse.de>
Date:   Thu, 25 Aug 2022 08:15:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Python tests
Content-Language: en-US
To:     Logan Gunthorpe <logan@eideticom.com>, Coly Li <colyli@suse.de>,
        Lukasz Florczak <lukasz.florczak@linux.intel.com>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        linux-raid@vger.kernel.org
References: <11ab82$jvatnj@fmsmga008-auth.fm.intel.com>
 <8C1AB1D5-54FD-406C-BBA3-509F669C9116@suse.de>
 <494eee73-5da3-55c9-c374-4166f0117288@eideticom.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <494eee73-5da3-55c9-c374-4166f0117288@eideticom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/24/22 22:40, Logan Gunthorpe wrote:
> Hi,
> 
> On 2022-08-24 10:23, Coly Li wrote:
>>
>>
>>> 2022年8月24日 16:15，Lukasz Florczak <lukasz.florczak@linux.intel.com> 写道：
>>>
>>> Hi Coly,
>>> I want to write some mdadm tests for assemblation and incremental
>>> regarding duplicated array names in config and I'd like to do it in
>>> python. I've seen that some time ago[1] you said that you could try to
>>> integrate the python tests framework into the mdadm ci. I was wondering
>>> how is it going? Do you need any help with this subject?
>>>
>>> Thanks,
>>> Lukasz
>>>
>>> [1] https://marc.info/?l=linux-raid&m=165277539509464&w=2
>>
>> Hi Lukasz,
>>
>> Now I just make some of the existed mdadm test scripts running, which are copied from upstream mdadm. There won’t be any conflict for the python testing code between you and me, because now I am just studying Python again and not do any useful thing yet.
>>
>> As I said if no one works on the testing framework, I will do it, but it may take time. How about posting out the python code once you make it, then let’s put it into mdadm-test to test mdadm-CI, and improve whole things step by step.
>>
> 
> I'm not sure if this is of use to anyone but we are very slowly growing
> a testing framework written mostly in python. Its focused on raid5 at
> the moment and still is a fairly sizable mess, but we've caught a lot of
> bugs with it and continue to run it, clean it up and make improvements.
> 
> https://github.com/Eideticom/raid5-tests/
> 
> The 'md.py 'file provides a nice interface to setup an array based on
> ram, loop or block devices and provides methods to degrade, recover or
> grow the array. 'test3' does grow/degrade tests while running IO,
> 'test_all' runs all the tests with an array of different settings.
> 
> Feel free to use anything from it that you may find useful.
> 
When developing 'md_monitor' (https://github.com/hreinecke/md_monitor) 
I've also created an extensive testsuite for it.
The one thing which I found particularly painful is error handling once 
mdadm fails. It's really hard to figure out _what_ went wrong, and more 
often than not mdadm simply locked up on me (try to stall I/O on one 
component device while md is running and you are in a world of pain).

That's when I started to split mdadm into a library, as then we could 
have a python binding and the life would so much more fun.
So maybe I should resurrect that patchset.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman
