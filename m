Return-Path: <SRS0=YcZW=CD=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30A71C433DF
	for <linux-raid@archiver.kernel.org>; Tue, 25 Aug 2020 15:14:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15EFB2075F
	for <linux-raid@archiver.kernel.org>; Tue, 25 Aug 2020 15:14:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbgHYPOQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 25 Aug 2020 11:14:16 -0400
Received: from forward100p.mail.yandex.net ([77.88.28.100]:33541 "EHLO
        forward100p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726180AbgHYPOP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 25 Aug 2020 11:14:15 -0400
Received: from forward100q.mail.yandex.net (forward100q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb97])
        by forward100p.mail.yandex.net (Yandex) with ESMTP id 4D5535980219;
        Tue, 25 Aug 2020 18:14:11 +0300 (MSK)
Received: from mxback3q.mail.yandex.net (mxback3q.mail.yandex.net [IPv6:2a02:6b8:c0e:39:0:640:4545:437c])
        by forward100q.mail.yandex.net (Yandex) with ESMTP id 4A84C7080004;
        Tue, 25 Aug 2020 18:14:11 +0300 (MSK)
Received: from vla5-445dc1c4c112.qloud-c.yandex.net (vla5-445dc1c4c112.qloud-c.yandex.net [2a02:6b8:c18:3609:0:640:445d:c1c4])
        by mxback3q.mail.yandex.net (mxback/Yandex) with ESMTP id UTYOtvWQbS-EA9qY1wp;
        Tue, 25 Aug 2020 18:14:11 +0300
Received: by vla5-445dc1c4c112.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id CJRih8wAAe-EAmmpwHZ;
        Tue, 25 Aug 2020 18:14:10 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH V5 0/5] md/raid10: Improve handling raid10 discard request
To:     Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org,
        song@kernel.org
Cc:     heinzm@redhat.com, ncroxon@redhat.com,
        guoqing.jiang@cloud.ionos.com, colyli@suse.de
References: <1598334183-25301-1-git-send-email-xni@redhat.com>
 <40470980-e397-7dd2-d7b8-16d0518e44c0@yandex.pl>
 <de5cd55b-8bc4-5616-e7d0-1b3c9c9636cc@redhat.com>
From:   Michal Soltys <msoltyspl@yandex.pl>
Message-ID: <7ed28e5d-4953-73b0-15b2-8f18911a8c23@yandex.pl>
Date:   Tue, 25 Aug 2020 17:14:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <de5cd55b-8bc4-5616-e7d0-1b3c9c9636cc@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/25/20 3:25 PM, Xiao Ni wrote:
> 
> 
> On 08/25/2020 06:19 PM, Michal Soltys wrote:
>> On 8/25/20 7:42 AM, Xiao Ni wrote:
>> Are those fixes also possibly related to the issues I found earlier 
>> this year about it's very weird discard handling whenever the 
>> originating request wasn't essentially chunk-aligend ?
> I searched by your email in my email box and I didn't find emails from 
> you at earlier this year. Is there a link? Discard request is usually 
> very big.

Was using different mail then (soltys@ziu.info), but vger seems to be 
refusing .info domain now.

> If the discard request is not chunk aligned, raid10 can handle this 
> problem without my patch. It splits I/O by chunk size and write/discard
> this chunk to all copies.
>>
>> What I found back then is e.g. discard of 4x32gb raid10 taking good 11 
>> minutes via blkdiscard w/o explicit step option.
> 4x32gb means 4 disks and each disk is 32GB?

Using partitions on the disks to be precise, but yea.

> For the discard time problem, as mentioned just now, it splits big 
> discard request into small chunks. So it takes very long time.
> My patch resolves this problem.
>>
>> I still have blktraces of that available, the relevant thread part 
>> with further more detailed followups can be found at:
>>
>> https://www.spinics.net/lists/raid/msg62115.html
>>
> It's a raid456 problem, not raid10.

The part related to raid10 starts at that moment (as well as all 
followups), after Song asked me about raid10 behavior.

The above spinics link has links to blktrace dumps when blkdiscard was 
executed on such raid10. It was split into tiny chunks and executed in 
really weird fashion, that subsequent replies outlined:

https://www.spinics.net/lists/raid/msg62134.html
https://www.spinics.net/lists/raid/msg62164.html

Anyway, just mentioning that after seeing a set of patches related to 
discards and raid10.

I'll doublecheck that behavior with more current kernel version and the 
patches applied.
