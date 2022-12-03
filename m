Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B797FC4332F
	for <linux-raid@archiver.kernel.org>; Sat,  3 Dec 2022 12:20:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiLCMUV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Dec 2022 07:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiLCMUU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Dec 2022 07:20:20 -0500
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA291A39C
        for <linux-raid@vger.kernel.org>; Sat,  3 Dec 2022 04:20:19 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4NPTR53s0CzXLx
        for <linux-raid@vger.kernel.org>; Sat,  3 Dec 2022 13:20:12 +0100 (CET)
Message-ID: <9b3fcbcb-6e26-f0b7-4986-a97484e88620@thelounge.net>
Date:   Sat, 3 Dec 2022 13:20:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: about linear and about RAID10
Content-Language: en-US
To:     Linux RAID list <linux-raid@vger.kernel.org>
References: <20221123220736.GD19721@jpo> <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
 <20221125133050.GH19721@jpo>
 <CAAMCDee6cyM5Uw6DitWtBL3W8NbW7j0DZcUp8A2CXWZbYceXeA@mail.gmail.com>
 <20221128144630.GN19721@jpo>
 <548f5325-0c3b-1642-2b08-ae7b637b3ad3@thelounge.net>
 <20221203054528.GR19721@jpo>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <20221203054528.GR19721@jpo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 03.12.22 um 06:45 schrieb David T-G:
> Reindl, et al --
> 
> ...and then Reindl Harald said...
> %
> % Am 28.11.22 um 15:46 schrieb David T-G:
> % > I don't at this time have a device free to plug in locally to back up the
> % > volume to destroy and rebuild as linear, so that will have to wait.  When
> % > I do get that chance, though, will that help me get to the awesome goal
> % > of actually INCREASING performance by including a RAID0 layer?
> %
> % stacking layers over layers will *never* increase performance - a pure RAID0
> % will but if one disk is dead all is lost
> 
> True, and we definitely don't want that.

but you do when i read your posts

> % additional RAID0 on top or below another RAID won't help
> 
> I could believe that, because what I don't know about RAID would fill a
> book, but I thought that the idea of RAID10 speeding up access was that
> the first half of the data is on the FIRST half of the /first/ disk
> and the second half of the data is on the FIRST half of the /second/
> disk and so the heads only move over half the disk for reads.

common sense: in the moment you have already reads and span a RAID0 over 
them the aceess pattern is far waway from first and second disk

common sense: you wrote you are dealing mostly with small files - they 
don't gain from striping because they are typically not striped at all

> % your main problem starts by slicing your drives in dozens of partitions and
> % "the idea being that each piece of which should take less time to rebuild if
> % something fails"
> [snip]
> 
> Whoops!  You're on the wrong machine.  This one mirrors two disks; that
> one is the one that has a bunch.

well, when you mix different machines into the same thread i am out here
