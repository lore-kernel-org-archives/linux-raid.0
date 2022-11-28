Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E6B2C433FE
	for <linux-raid@archiver.kernel.org>; Mon, 28 Nov 2022 15:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiK1Pcz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 28 Nov 2022 10:32:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232769AbiK1Pc3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 28 Nov 2022 10:32:29 -0500
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8522F2
        for <linux-raid@vger.kernel.org>; Mon, 28 Nov 2022 07:32:25 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4NLTwz5yqwzXLf;
        Mon, 28 Nov 2022 16:32:19 +0100 (CET)
Message-ID: <548f5325-0c3b-1642-2b08-ae7b637b3ad3@thelounge.net>
Date:   Mon, 28 Nov 2022 16:32:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: about linear and about RAID10
Content-Language: en-US
To:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
References: <20221123220736.GD19721@jpo> <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
 <20221125133050.GH19721@jpo>
 <CAAMCDee6cyM5Uw6DitWtBL3W8NbW7j0DZcUp8A2CXWZbYceXeA@mail.gmail.com>
 <20221128144630.GN19721@jpo>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <20221128144630.GN19721@jpo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 28.11.22 um 15:46 schrieb David T-G:
> I don't at this time have a device free to plug in locally to back up the
> volume to destroy and rebuild as linear, so that will have to wait.  When
> I do get that chance, though, will that help me get to the awesome goal
> of actually INCREASING performance by including a RAID0 layer?

stacking layers over layers will *never* increase performance - a pure 
RAID0 will but if one disk is dead all is lost

additional RAID0 on top or below another RAID won't help

your main problem starts by slicing your drives in dozens of partitions 
and "the idea being that each piece of which should take less time to 
rebuild if something fails"

when a drive fails all your partitions on that drive are gone - so 
rebuild isn't faster at the end

with that slicing and layers over layers you get unpredictable 
head-movemnets slowing things down

keep it SIMPLE!
