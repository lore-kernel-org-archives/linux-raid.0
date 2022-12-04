Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC2CC4332F
	for <linux-raid@archiver.kernel.org>; Sun,  4 Dec 2022 13:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiLDNEo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 4 Dec 2022 08:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiLDNEn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 4 Dec 2022 08:04:43 -0500
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8CCDFA6
        for <linux-raid@vger.kernel.org>; Sun,  4 Dec 2022 05:04:37 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4NQ6Mk1vWhzXLf
        for <linux-raid@vger.kernel.org>; Sun,  4 Dec 2022 14:04:29 +0100 (CET)
Message-ID: <6d67a7a2-ca24-1dd3-a124-28c9f41a840d@thelounge.net>
Date:   Sun, 4 Dec 2022 14:04:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: batches and serial numbers (was "Re: md vs LVM and VMs and ...")
Content-Language: en-US
To:     Linux RAID list <linux-raid@vger.kernel.org>
References: <20221124211019.GE19721@jpo>
 <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
 <CAAMCDecPXmZsxaAPcSOOY4S7_ieRZC8O_u7LjLLH-t8L-6+21Q@mail.gmail.com>
 <20221125132259.GG19721@jpo>
 <CAAMCDed1-4zFgHMS760dO1pThtkrn8K+FMuG-QQ+9W-FE0iq9Q@mail.gmail.com>
 <20221125194932.GK19721@jpo> <20221128142422.GM19721@jpo>
 <ab803396-fb7f-50b6-9aa8-2803aa526fe4@sotapeli.fi>
 <20221203054130.GP19721@jpo>
 <1e419d58-46d8-affa-36dc-ef8c14760305@youngman.org.uk>
 <20221203180425.GU19721@jpo>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <20221203180425.GU19721@jpo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 03.12.22 um 19:04 schrieb David T-G:
> % But if all your drives are the same make, model(, and batch), there is a not
> % insignificant risk they will all share the same defects, and fail at the
> % same time. It's accepted the risk is small, but it's there.
> 
> What is the problem?  Is it the manufacturer's firmware?  Is it the day
> they were made?  

you simply don't know until the problem hits you

not so long ago some HP enterprise SSDs for example had a timebomb in 
their firmware by some 32bit counter (power on i think) which killed the 
complete device when not fixed with a firmware update - when that 
happens and all your drives are the same type and bougzt at the same day 
your RAID is gone forever

it's simply common sense that two drives with different ages and from 
different vendos are unlikely failaing within a few hours for the same 
reason

on a 4 disk RAID10 i prefer 2 different disk series with a different age 
by at least one month whenever possible
