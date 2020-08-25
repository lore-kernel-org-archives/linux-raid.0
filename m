Return-Path: <SRS0=YcZW=CD=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C2CC433E1
	for <linux-raid@archiver.kernel.org>; Tue, 25 Aug 2020 10:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A91DE20706
	for <linux-raid@archiver.kernel.org>; Tue, 25 Aug 2020 10:29:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729710AbgHYK3N (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 25 Aug 2020 06:29:13 -0400
Received: from forward102p.mail.yandex.net ([77.88.28.102]:41861 "EHLO
        forward102p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728117AbgHYK3M (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 25 Aug 2020 06:29:12 -0400
X-Greylist: delayed 452 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Aug 2020 06:29:11 EDT
Received: from mxback9o.mail.yandex.net (mxback9o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::23])
        by forward102p.mail.yandex.net (Yandex) with ESMTP id 48F101D421E9;
        Tue, 25 Aug 2020 13:19:43 +0300 (MSK)
Received: from myt6-016ca1315a73.qloud-c.yandex.net (myt6-016ca1315a73.qloud-c.yandex.net [2a02:6b8:c12:4e0e:0:640:16c:a131])
        by mxback9o.mail.yandex.net (mxback/Yandex) with ESMTP id uY5LZPxb1j-JgF0pUk9;
        Tue, 25 Aug 2020 13:19:43 +0300
Received: by myt6-016ca1315a73.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id KzwQRiNbpu-Jflm1XZn;
        Tue, 25 Aug 2020 13:19:41 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH V5 0/5] md/raid10: Improve handling raid10 discard request
To:     Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org,
        song@kernel.org
Cc:     heinzm@redhat.com, ncroxon@redhat.com,
        guoqing.jiang@cloud.ionos.com, colyli@suse.de
References: <1598334183-25301-1-git-send-email-xni@redhat.com>
From:   Michal Soltys <msoltyspl@yandex.pl>
Message-ID: <40470980-e397-7dd2-d7b8-16d0518e44c0@yandex.pl>
Date:   Tue, 25 Aug 2020 12:19:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1598334183-25301-1-git-send-email-xni@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/25/20 7:42 AM, Xiao Ni wrote:
> Hi all
> 
> Now mkfs on raid10 which is combined with ssd/nvme disks takes a long time.
> This patch set tries to resolve this problem.
> 

Are those fixes also possibly related to the issues I found earlier this 
year about it's very weird discard handling whenever the originating 
request wasn't essentially chunk-aligend ?

What I found back then is e.g. discard of 4x32gb raid10 taking good 11 
minutes via blkdiscard w/o explicit step option.

I still have blktraces of that available, the relevant thread part with 
further more detailed followups can be found at:

https://www.spinics.net/lists/raid/msg62115.html
