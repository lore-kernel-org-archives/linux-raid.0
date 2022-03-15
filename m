Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F69C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 15 Mar 2022 16:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350124AbiCOQpQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Mar 2022 12:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243203AbiCOQpQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Mar 2022 12:45:16 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5F9522FD
        for <linux-raid@vger.kernel.org>; Tue, 15 Mar 2022 09:44:03 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 707601F38C;
        Tue, 15 Mar 2022 16:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1647362642; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SMch/Bx14XURSdHVQ6wmfNVe6ciBR2ezFtWfWX1bS2Q=;
        b=UbfZfj3MxcYDpWB8b1H7qqmZAvjpezo1JgHkOegh+0afAebRwVT+Tv/SkTIGRHwPMKFzLI
        yMsbdqYTcSTnKbGMfa/TscwB4u5YfZqdsYrhsdawpLbDmqff7c3wRtfHr+T5eyZlfgF0GA
        FinmgbLzclqtsPVOj5KvJcH4ocgcB4Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1647362642;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SMch/Bx14XURSdHVQ6wmfNVe6ciBR2ezFtWfWX1bS2Q=;
        b=t2dgRullsjNZGXm0Wl8m6YrgISIIT1hR1K2++7+UHJjaJTiJVTMTLDDPqKzkfiuo9aiNpw
        Joug7Z0LdcfeFWAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EC7AC13B66;
        Tue, 15 Mar 2022 16:44:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id h5pgEVDCMGIYRwAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 15 Mar 2022 16:44:00 +0000
Message-ID: <8ee252df-3ee2-36b0-7c4e-ef1f9c8e6f49@suse.de>
Date:   Wed, 16 Mar 2022 00:43:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH 2/2] mdadm: Update config man regarding default files and
 multi-keyword behavior.
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Lukasz Florczak <lukasz.florczak@linux.intel.com>,
        jes@trained-monkey.org, linux-raid@vger.kernel.org
References: <20220315085549.59693-1-lukasz.florczak@linux.intel.com>
 <20220315085549.59693-3-lukasz.florczak@linux.intel.com>
 <70ee6acf-714b-10eb-dfed-284a67ae619d@suse.de>
 <20220315170006.00005871@linux.intel.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220315170006.00005871@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/16/22 12:00 AM, Mariusz Tkaczyk wrote:
> On Tue, 15 Mar 2022 17:57:09 +0800
> Coly Li <colyli@suse.de> wrote:
>
>> On 3/15/22 4:55 PM, Lukasz Florczak wrote:
>>> Simplify default and alternative config file and directory location
>>> references from mdadm(8) as references to mdadm.conf(5). Add FILE
>>> section in config man and explain order and conditions in which
>>> default and alternative config files and directories are used.
>>>
>>> Update config man behavior regarding parsing order when multiple
>>> keywords/config files are involved.
>>>
>>> Additionally add missing HOMECLUSTER keyword description.
>>>
>>> Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
>>
>> Hi Lukasz,
>>
>>
>> This patch doesn't apply on branch 20220315-testing of the mdadm-CI
>> tree, could you please rebase this series on
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/colyli/mdadm.git
>> 20220315-testing
>>
>> Then I will continue to test them.
>>
> Hi Coly,
> This is great to see that something is happening in upstream :)
>
> I can see that you created branch where some patches were merged and
> now you are reporting conflicts now. Our patches are based on last
> mdadm commit (which is mdadm-4.2 ).
> IMO you should try to apply them first on latest master and later
> cherry-pick/ rebase them on top of your testing branch. This should
> automatically resolve most of conflicts. Could you try that?


The testing branch is updated to latest mdadm upstream. Indeed the 
conflict is about blank line as I see, e.g. it removes some \t from 
empty line, but such issue was removed in latest upstream.

Ineed I can fix the conflict, but I don't know how to make you update 
the change from my side. Does it work if I sand you a diff of the patch?

Thanks.


Coly Li

