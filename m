Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E906C4332F
	for <linux-raid@archiver.kernel.org>; Sun, 27 Nov 2022 22:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiK0WRk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 27 Nov 2022 17:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiK0WRj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 27 Nov 2022 17:17:39 -0500
Received: from len.romanrm.net (len.romanrm.net [91.121.86.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E19270A
        for <linux-raid@vger.kernel.org>; Sun, 27 Nov 2022 14:17:36 -0800 (PST)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by len.romanrm.net (Postfix) with SMTP id 67E0140165;
        Sun, 27 Nov 2022 22:17:34 +0000 (UTC)
Date:   Mon, 28 Nov 2022 03:17:33 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Wol <antlists@youngman.org.uk>
Cc:     Reindl Harald <h.reindl@thelounge.net>,
        piergiorgio.sartor@nexgo.de, John Stoffel <john@stoffel.org>,
        David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: how do i fix these RAID5 arrays?
Message-ID: <20221128031733.054a063b@nvm>
In-Reply-To: <531e8606-94b4-d48b-1d5a-72cc7d078755@youngman.org.uk>
References: <fd543697-14a6-0868-82a1-be61790e07f3@thelounge.net>
        <20221123220736.GD19721@jpo>
        <20221124032821.628cd042@nvm>
        <20221124211019.GE19721@jpo>
        <f58964da-4ded-61a8-bd6a-e2391557b38a@youngman.org.uk>
        <25474.28874.952381.412636@quad.stoffel.home>
        <0c7ad6eff626c8440734909300ebc50d9b1bf615@nexgo.de>
        <4379b4f4-9e7f-a7dc-fc29-6c22b12bf3ea@thelounge.net>
        <531e8606-94b4-d48b-1d5a-72cc7d078755@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, 27 Nov 2022 22:05:07 +0000
Wol <antlists@youngman.org.uk> wrote:

> When mdadm creates an array - IF IT SUPPORTED TRIM - you could tell it 
> "this is a blank array, don't bother initialising it". So it would 
> initialise an internal bitmap to say "all these stripes are empty".
> 
> As the file system above sends writes down, mdadm would update the 
> bitmap to say "these stripes are in use".
> 
> AND THIS IS WHAT I MEAN BY "SUPPORTING TRIM" - when the filesystem sends 
> a trim command, saying "I'm no longer using these blocks", MDADM WOULD 
> REMEMBER, and if appropriate clear the bitmap.

mdadm supports TRIM in the sense that it properly passes down TRIM of the
array to participant member devices, for them to do their own underlying
storage management operations. Even from the complex RAID levels such as RAID5
and RAID6. This is commendable and IIRC far from always was the case.

Stretching "TRIM support" to mean a hypothetical used-blocks-accounting
feature and use of that to speed-up rebuilds, is a surefire way to get
misunderstood in a conversation. As is saying "mdadm doesn't support TRIM"
only due to it not having that specific advanced feature.

-- 
With respect,
Roman
