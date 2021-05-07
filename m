Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F89AC433B4
	for <linux-raid@archiver.kernel.org>; Fri,  7 May 2021 09:48:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E072613D6
	for <linux-raid@archiver.kernel.org>; Fri,  7 May 2021 09:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236835AbhEGJtK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 7 May 2021 05:49:10 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:18109 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236892AbhEGJtK (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 7 May 2021 05:49:10 -0400
Received: from host86-155-154-37.range86-155.btcentralplus.com ([86.155.154.37] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1lex5c-0009uM-8r; Fri, 07 May 2021 10:48:08 +0100
Subject: Re: raid10 redundancy
To:     d tbsky <tbskyd@gmail.com>,
        Adam Goryachev <mailinglists@websitemanagers.com.au>
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
 <AD8C004B-FE83-4ABD-B58A-1F7F8683CD1F@websitemanagers.com.au>
 <CAC6SzHKH62XwudewxtOUyNQYi9QSFar=dZ64fz9HiEW1eZh47g@mail.gmail.com>
Cc:     list Linux RAID <linux-raid@vger.kernel.org>
From:   Wols Lists <antlists@youngman.org.uk>
Message-ID: <60950C7B.5040706@youngman.org.uk>
Date:   Fri, 7 May 2021 10:46:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <CAC6SzHKH62XwudewxtOUyNQYi9QSFar=dZ64fz9HiEW1eZh47g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 07/05/21 02:12, d tbsky wrote:
> Adam Goryachev <mailinglists@websitemanagers.com.au>
>>
>> I guess it depends on your definition of raid 10... In my experience it means one or more raid 1 arrays combine with raid 0, so if each raid 1 arrays had 2 members, then it is either 2, 4, 6, etc for the total number of drives.
> 
> indeed. What I want to use is linux raid10 which can be used on
> 2,3,4,5, etc of disk drives. so it is unlike hardware raid 10.
> 
If you're worried about losing two drives, okay it's more disk space,
but add the third drive and go for three copies. Then adding the fourth
drive will give you extra space. Not the best but heigh ho.

Or make sure you've got a spare drive configured, so if one drive fails
the array will rebuild immediately, and your window of danger is minimised.

Cheers,
Wol
