Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C61DAC4332F
	for <linux-raid@archiver.kernel.org>; Sun,  4 Dec 2022 13:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiLDNNp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 4 Dec 2022 08:13:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiLDNNp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 4 Dec 2022 08:13:45 -0500
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE94D17436
        for <linux-raid@vger.kernel.org>; Sun,  4 Dec 2022 05:13:43 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4NQ6ZF6wWFzXLf
        for <linux-raid@vger.kernel.org>; Sun,  4 Dec 2022 14:13:41 +0100 (CET)
Message-ID: <d5b06e58-c4c3-cd58-5fc6-c4c872a5005b@thelounge.net>
Date:   Sun, 4 Dec 2022 14:13:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: about linear and about RAID10
Content-Language: en-US
To:     Linux RAID list <linux-raid@vger.kernel.org>
References: <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
 <20221125133050.GH19721@jpo>
 <CAAMCDee6cyM5Uw6DitWtBL3W8NbW7j0DZcUp8A2CXWZbYceXeA@mail.gmail.com>
 <20221128144630.GN19721@jpo>
 <548f5325-0c3b-1642-2b08-ae7b637b3ad3@thelounge.net>
 <25477.7682.651953.966662@quad.stoffel.home> <20221203055816.GT19721@jpo>
 <dad4a4d4-70bb-f09b-c2fc-05dc2d21f8bb@youngman.org.uk>
 <20221203182721.GV19721@jpo>
 <dfbbb68c-6563-a56b-d4de-dc932cd40005@youngman.org.uk>
 <20221204025316.GF19721@jpo>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <20221204025316.GF19721@jpo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 04.12.22 um 03:53 schrieb David T-G:
> % Hmm ... so being pedantic about terminology that's a definite raid-1+0, not
> % linux-raid-10.
> 
> OK.  I'll try rereading the wiki pages and see where I went wrong.
> Perhaps they can be clarified.
it's simply: a *native* linux mdadm RAID10 is not excatly the same as 
any other RAID10 combining RAID1+RAID0
