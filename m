Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5089DC4332F
	for <linux-raid@archiver.kernel.org>; Sun,  4 Dec 2022 13:08:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiLDNIa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 4 Dec 2022 08:08:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiLDNI3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 4 Dec 2022 08:08:29 -0500
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AF51145C
        for <linux-raid@vger.kernel.org>; Sun,  4 Dec 2022 05:08:27 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4NQ6S85zv8zXLf
        for <linux-raid@vger.kernel.org>; Sun,  4 Dec 2022 14:08:24 +0100 (CET)
Message-ID: <258ce1f1-6f0d-230b-1e2c-002149cc4eb5@thelounge.net>
Date:   Sun, 4 Dec 2022 14:08:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: about linear and about RAID10
Content-Language: en-US
To:     Linux RAID list <linux-raid@vger.kernel.org>
References: <20221124032821.628cd042@nvm> <20221124211019.GE19721@jpo>
 <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
 <20221125133050.GH19721@jpo>
 <CAAMCDee6cyM5Uw6DitWtBL3W8NbW7j0DZcUp8A2CXWZbYceXeA@mail.gmail.com>
 <20221128144630.GN19721@jpo>
 <548f5325-0c3b-1642-2b08-ae7b637b3ad3@thelounge.net>
 <25477.7682.651953.966662@quad.stoffel.home> <20221203055816.GT19721@jpo>
 <dad4a4d4-70bb-f09b-c2fc-05dc2d21f8bb@youngman.org.uk>
 <20221203182721.GV19721@jpo>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <20221203182721.GV19721@jpo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 03.12.22 um 19:27 schrieb David T-G:
> Anthony, et al --
> 
> ...and then Wols Lists said...
> % On 03/12/2022 05:58, David T-G wrote:
> % >
> % > I've finally convinced The Boss to spring for additional disks so that I
> % > can mirror, so our two servers both have SSD mirroring; yay.  The web
> % > server doesn't need much space, so it has a pair of 4T HDDs mirrored as
> % > well ... but as RAID10 since I thought that that was cool.  Ah, well.
> %
> % Raid 10 across two drives? Do I read you right? So you can easily add a 3rd
> % drive to get 6TB of usable storage, but raid 10 x 2 drives = raid 1 ...
> 
> Thanks for the aa/bb/cc non-symmetrical layout help recently.  I think I
> see where you're going here.  But that isn't what I have in this case.
> 
> Each disk is sliced into two large partitions that take up about half:
> 
> The two halves of each disk are then mirrored across -- BUT in an "X"
> layout.  Note that b1 pairs with c2 and c1 pairs with b2.
> 
> Finally, the mirrors are striped together (perhaps that should have been
> a linear instead) to make the final device.
> 
> The theory was that each disk would hold half of the total in the first
> half of its space and that md would be clever enough to ask the proper
> disk for the sector to keep the head in that short run.  Writes cover the
> whole disk one way or another, of course, but reads should require less
> head movement and be quicker.

but common sense should tell you that's nonsense with slicing! that only 
would be true if it would be instead of partitions on the same disk 
*psyiscal devices*

partitions are always nosense when it comes to performance, they are for 
logical sepearate data and nothing else


