Return-Path: <SRS0=YcZW=CD=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD66C433DF
	for <linux-raid@archiver.kernel.org>; Tue, 25 Aug 2020 13:25:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E27B20639
	for <linux-raid@archiver.kernel.org>; Tue, 25 Aug 2020 13:25:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F2feRuOg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgHYNZo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 25 Aug 2020 09:25:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21717 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726095AbgHYNZn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 25 Aug 2020 09:25:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598361942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p9hsvgeLrKOCr1YFpXPx0iV7Xvm+WJanrXKSolhhp1g=;
        b=F2feRuOgC6tmgaEud3c1s4BtcIlYVmNCcsYYeWN2bBVjQ1XYYWG+PtXLcEL4e6S/7QNlgP
        qc8Xzd1uHpca7m18e2Flk43kn3vHWOy9UTDYVmLJGBRBMuYlIVSvX/e33uFRGh3yMTBZfg
        JMx/ED79XtfvMTuoIWE9Dnnig1X8f9c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-K2qWbCrCOqyFzY4IzsWNJA-1; Tue, 25 Aug 2020 09:25:37 -0400
X-MC-Unique: K2qWbCrCOqyFzY4IzsWNJA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BB0E80EDA4;
        Tue, 25 Aug 2020 13:25:35 +0000 (UTC)
Received: from [10.72.8.21] (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A4187D4EC;
        Tue, 25 Aug 2020 13:25:31 +0000 (UTC)
Subject: Re: [PATCH V5 0/5] md/raid10: Improve handling raid10 discard request
To:     Michal Soltys <msoltyspl@yandex.pl>, linux-raid@vger.kernel.org,
        song@kernel.org
Cc:     heinzm@redhat.com, ncroxon@redhat.com,
        guoqing.jiang@cloud.ionos.com, colyli@suse.de
References: <1598334183-25301-1-git-send-email-xni@redhat.com>
 <40470980-e397-7dd2-d7b8-16d0518e44c0@yandex.pl>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <de5cd55b-8bc4-5616-e7d0-1b3c9c9636cc@redhat.com>
Date:   Tue, 25 Aug 2020 21:25:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <40470980-e397-7dd2-d7b8-16d0518e44c0@yandex.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 08/25/2020 06:19 PM, Michal Soltys wrote:
> On 8/25/20 7:42 AM, Xiao Ni wrote:
>> Hi all
>>
>> Now mkfs on raid10 which is combined with ssd/nvme disks takes a long 
>> time.
>> This patch set tries to resolve this problem.
>>
>
Hi Michal

> Are those fixes also possibly related to the issues I found earlier 
> this year about it's very weird discard handling whenever the 
> originating request wasn't essentially chunk-aligend ?
I searched by your email in my email box and I didn't find emails from 
you at earlier this year. Is there a link? Discard request is usually 
very big.
If the discard request is not chunk aligned, raid10 can handle this 
problem without my patch. It splits I/O by chunk size and write/discard
this chunk to all copies.
>
> What I found back then is e.g. discard of 4x32gb raid10 taking good 11 
> minutes via blkdiscard w/o explicit step option.
4x32gb means 4 disks and each disk is 32GB?
For the discard time problem, as mentioned just now, it splits big 
discard request into small chunks. So it takes very long time.
My patch resolves this problem.
>
> I still have blktraces of that available, the relevant thread part 
> with further more detailed followups can be found at:
>
> https://www.spinics.net/lists/raid/msg62115.html
>
It's a raid456 problem, not raid10.

Regards
Xiao

