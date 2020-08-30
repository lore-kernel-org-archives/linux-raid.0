Return-Path: <SRS0=i/ST=CI=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0349C433E2
	for <linux-raid@archiver.kernel.org>; Sun, 30 Aug 2020 22:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7939B20693
	for <linux-raid@archiver.kernel.org>; Sun, 30 Aug 2020 22:17:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgH3WRR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 30 Aug 2020 18:17:17 -0400
Received: from forward103p.mail.yandex.net ([77.88.28.106]:49297 "EHLO
        forward103p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726178AbgH3WRQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sun, 30 Aug 2020 18:17:16 -0400
Received: from mxback15o.mail.yandex.net (mxback15o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::66])
        by forward103p.mail.yandex.net (Yandex) with ESMTP id 3748718C00E2;
        Mon, 31 Aug 2020 01:17:01 +0300 (MSK)
Received: from iva7-f62245f79210.qloud-c.yandex.net (iva7-f62245f79210.qloud-c.yandex.net [2a02:6b8:c0c:2e83:0:640:f622:45f7])
        by mxback15o.mail.yandex.net (mxback/Yandex) with ESMTP id MCkTpr81NE-H0qa7F5t;
        Mon, 31 Aug 2020 01:17:01 +0300
Received: by iva7-f62245f79210.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id N5j6LnARF2-GxHiFgcP;
        Mon, 31 Aug 2020 01:17:00 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: Best way to add caching to a new raid setup.
To:     Ram Ramesh <rramesh2400@gmail.com>, Roman Mamedov <rm@romanrm.net>,
        "R. Ramesh" <rramesh@verizon.net>
Cc:     Linux Raid <linux-raid@vger.kernel.org>
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
 <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
 <20200828224616.58a1ad6c@natsu>
 <448afb39-d277-445f-cc42-2dfc5210da7b@gmail.com>
From:   Michal Soltys <msoltyspl@yandex.pl>
Message-ID: <91219637-1930-5193-13f9-d547930ea522@yandex.pl>
Date:   Mon, 31 Aug 2020 00:16:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <448afb39-d277-445f-cc42-2dfc5210da7b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 20/08/28 22:39, Ram Ramesh wrote:
> On 8/28/20 12:46 PM, Roman Mamedov wrote:
>> On Thu, 27 Aug 2020 21:31:07 -0500
>> Also my impression is that LVM has more solid and reliable codebase, but
>> bcache might provide a somewhat better the performance boost due to 
>> caching.
>>
> Thanks for the info on bcache. I do not think it will be my favorite. I 
> am going to try LVM cache as my first choice. Note that the new disks 
> will be spare disks for some time and I will be able to try out a few 
> things before deciding to put it into use.

I had some _very nasty_ adventures with LVM's cache, that ended with 
rather massive corruption at the end of the last year. I described it in:

https://github.com/lvmteam/lvm2/issues/26

though not much from that was answered or commented, except confirmation 
that flushing issue was fixed.

At the same time I have yet to have bcache failing on me (and it - so 
far flawlessly - did survive kernel panics (bugged nic drivers) and 
disks dying).

YMMV of course, just _make sure_ to have backups. And make sure to test 
it thoroughly in your setup (including things like hard reset).

