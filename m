Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 756C0C63777
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 21:50:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C08620857
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 21:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730332AbgK3Vuh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Nov 2020 16:50:37 -0500
Received: from mail.thelounge.net ([91.118.73.15]:22409 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbgK3Vuh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 30 Nov 2020 16:50:37 -0500
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4ClJmf47DwzXVl;
        Mon, 30 Nov 2020 22:49:54 +0100 (CET)
To:     antlists <antlists@youngman.org.uk>,
        David T-G <davidtg-robot@justpickone.org>,
        linux-raid@vger.kernel.org
References: <e6b7a61d16a25c433438c670fa4c0b4f@posteo.de>
 <20201130200503.GV1415@justpickone.org>
 <01a571de-8ae8-3d9e-6f3d-16555ad93ea3@youngman.org.uk>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Subject: Re: partitions & filesystems (was "Re: ???root account locked???
 after removing one RAID1 hard disc")
Message-ID: <2d0fcd02-9e3a-d11a-a1cf-a47c1b6ce2c3@thelounge.net>
Date:   Mon, 30 Nov 2020 22:49:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <01a571de-8ae8-3d9e-6f3d-16555ad93ea3@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 30.11.20 um 21:51 schrieb antlists:
> On 30/11/2020 20:05, David T-G wrote:
>> You don't see any "filesystem" or, more correctly, partition in your
>>
>>    fdisk -l
>>
>> output because you have apparently created your filesystem on the entire
>> device (hey, I didn't know one could do that!). 
> 
> That, actually, is the norm. It is NOT normal to partition a raid array

it IS normal for several reasons

* you may end with a replacement disk which is subtle
   smaller and hence you normally make the partition
   a little smaller then the device

* in case of SSD you reserve some space for
   better wear-levelling

* in case you ever need to reinstall your OS you
   want your data not in the same filesystem
