Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 389ABC49EA3
	for <linux-raid@archiver.kernel.org>; Mon, 28 Jun 2021 14:34:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F7BC61D09
	for <linux-raid@archiver.kernel.org>; Mon, 28 Jun 2021 14:34:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbhF1Ogn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 28 Jun 2021 10:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235285AbhF1OfR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 28 Jun 2021 10:35:17 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5950DC08E834
        for <linux-raid@vger.kernel.org>; Mon, 28 Jun 2021 07:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:Cc:References:To:Subject:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JgDoWd7nmte+GDd/9bYSPraCozU27CG4X79KcG1aT1I=; b=NGjzcmX7SYsN89dJsAb/SDAFLD
        3r9B2BVAL/86Gu5dF4S9J36YJcI9hDjYUGwEx1TEZl7kBCHKCWkgEux1iuxxGuUM1Xk2XJZkqiX/K
        i9r+i413UHqZAwB7YSPupkWl9K6QzHvBGI5qSiR116BF/rjKwvHz4vvrdKv3yMG2x8j2mZ/+7d13R
        pQJT3YPVUpjV5qKMhQkAhcZyQSUFA2VkuOySLBexEemBrDrqbUJz/cfAKw87J66rtggG81i4a/mwB
        VH2Iuqc64l4XRRqZhSWVKyvqptiOTzhSVIusQr6oWsAxjuwlmKmH3vklfXbLJ8ThB6Chrw3Dt7S0T
        KtcvIn5w==;
Received: from c-98-192-104-236.hsd1.ga.comcast.net ([98.192.104.236] helo=[192.168.19.160])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1lxsB9-0000d3-DV; Mon, 28 Jun 2021 14:24:03 +0000
Subject: Re: 4-disk RAID6 (non-standard layout) normalise hung, now all disks
 spare
To:     Jason Flood <3mu5555@gmail.com>, linux-raid@vger.kernel.org
References: <007601d769ba$ced0e870$6c72b950$@gmail.com>
 <6d412bf3-a7b9-1f08-2da9-96d34d8f112b@turmel.org>
 <00f101d76a7b$bdb3fc50$391bf4f0$@gmail.com>
 <df60eb5f-b1c0-b3f8-4985-3cb8d9dcc531@youngman.org.uk>
 <011e281f-7ea3-9491-29fd-5e1574aa5819@turmel.org>
 <004b01d76b44$f8ff7b80$eafe7280$@gmail.com>
Cc:     'antlists' <antlists@youngman.org.uk>
From:   Phil Turmel <philip@turmel.org>
Message-ID: <7a7bd6ba-317f-acaa-6b2c-f57768098697@turmel.org>
Date:   Mon, 28 Jun 2021 10:24:02 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <004b01d76b44$f8ff7b80$eafe7280$@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Good morning Jason,

On 6/27/21 7:09 AM, Jason Flood wrote:
> Good morning Phil, Wol,
> 
>> So force was sufficient to assemble.  But you are still stuck at 99%.
> 
>> Look at the output of ps to see if mdmon is still running (that is the background process that actually reshapes stripe by stripe).  If not, look in your logs for clues as to why it died.
> 
>> If you can't find anything significant, the next step would be to backup the currently functioning array to another system/drive collection and start from scratch.  I wouldn't trust anything else with the information available.
> 
>> Phil
> 
> Will do, thanks. I have a few assignments due next weekend so I may not be able to report back for a week.

No worries.

>> ps.  Convention on kernel.org mailing lists is to NOT top-post, and to trim unnecessary context.
> 
> Sorry. First time on a mailing list since well before Outlook was invented!

No worries.  Also note that many mailing lists disagree with this.  And 
with kernel.org's convention to CC: all participants.  You almost can't 
avoid getting flamed one way or the other. (:

> Thanks again, Phil and Wol.

You're welcome.

Phil
