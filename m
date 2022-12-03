Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EA3DC352A1
	for <linux-raid@archiver.kernel.org>; Sat,  3 Dec 2022 15:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiLCP0a (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Dec 2022 10:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiLCP03 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Dec 2022 10:26:29 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02D72035D
        for <linux-raid@vger.kernel.org>; Sat,  3 Dec 2022 07:26:26 -0800 (PST)
Received: from host86-138-24-20.range86-138.btcentralplus.com ([86.138.24.20] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1p1RRB-0002yV-4G
        for linux-raid@vger.kernel.org;
        Sat, 03 Dec 2022 12:16:09 +0000
Message-ID: <dad4a4d4-70bb-f09b-c2fc-05dc2d21f8bb@youngman.org.uk>
Date:   Sat, 3 Dec 2022 12:16:09 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: about linear and about RAID10
Content-Language: en-GB
To:     Linux RAID list <linux-raid@vger.kernel.org>
References: <20221123220736.GD19721@jpo> <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
 <20221125133050.GH19721@jpo>
 <CAAMCDee6cyM5Uw6DitWtBL3W8NbW7j0DZcUp8A2CXWZbYceXeA@mail.gmail.com>
 <20221128144630.GN19721@jpo>
 <548f5325-0c3b-1642-2b08-ae7b637b3ad3@thelounge.net>
 <25477.7682.651953.966662@quad.stoffel.home> <20221203055816.GT19721@jpo>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <20221203055816.GT19721@jpo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 03/12/2022 05:58, David T-G wrote:
> % This is my mantra as well here.  For my home system, I prefer
> % symplicity and robustness and performance, so I tend just use RAID1
> 
> I've finally convinced The Boss to spring for additional disks so that I
> can mirror, so our two servers both have SSD mirroring; yay.  The web
> server doesn't need much space, so it has a pair of 4T HDDs mirrored as
> well ... but as RAID10 since I thought that that was cool.  Ah, well.

Raid 10 across two drives? Do I read you right? So you can easily add a 
3rd drive to get 6TB of usable storage, but raid 10 x 2 drives = raid 1 ...

Changing topic slightly, if you have multiple slices per drive, raided 
(which I've done, I wanted /, /home and /var on their own devices), it 
is quite easy to lose just one slice. But that *should* be down to 
mis-configured devices. Get a soft-read error, the *linux* timeout kicks 
in, and the partition gets kicked out.

But that sort of problem should take no time whatsoever to recover from. 
With journalling or bitmap (you'll need to read up on the details) a 
re-add should just replay the lost writes, and you're back in business. 
So - if your aim is speed of recovery - there's no point splitting the 
disk into slices. There are good reasons for doing it, but that isn't 
one of them!

Cheers,
Wol
