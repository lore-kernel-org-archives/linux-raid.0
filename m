Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9281FC433FE
	for <linux-raid@archiver.kernel.org>; Tue, 29 Nov 2022 22:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236177AbiK2WWs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 29 Nov 2022 17:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236132AbiK2WWr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 29 Nov 2022 17:22:47 -0500
Received: from len.romanrm.net (len.romanrm.net [91.121.86.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8414D13D46
        for <linux-raid@vger.kernel.org>; Tue, 29 Nov 2022 14:22:45 -0800 (PST)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by len.romanrm.net (Postfix) with SMTP id 1ECD040165;
        Tue, 29 Nov 2022 22:22:41 +0000 (UTC)
Date:   Wed, 30 Nov 2022 03:22:40 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Jani Partanen <jiipee@sotapeli.fi>
Cc:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: md RAID0 can be grown (was "Re: how do i fix these RAID5
 arrays?")
Message-ID: <20221130032240.06da2435@nvm>
In-Reply-To: <ab803396-fb7f-50b6-9aa8-2803aa526fe4@sotapeli.fi>
References: <20221123220736.GD19721@jpo>
        <20221124032821.628cd042@nvm>
        <20221124211019.GE19721@jpo>
        <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
        <CAAMCDecPXmZsxaAPcSOOY4S7_ieRZC8O_u7LjLLH-t8L-6+21Q@mail.gmail.com>
        <20221125132259.GG19721@jpo>
        <CAAMCDed1-4zFgHMS760dO1pThtkrn8K+FMuG-QQ+9W-FE0iq9Q@mail.gmail.com>
        <20221125194932.GK19721@jpo>
        <20221128142422.GM19721@jpo>
        <ab803396-fb7f-50b6-9aa8-2803aa526fe4@sotapeli.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 29 Nov 2022 23:17:15 +0200
Jani Partanen <jiipee@sotapeli.fi> wrote:

> joined example 1TB and 2TB together with md linear so I could add that as 
> member to other 3TB raid5 pool.

I realize you describe a past setup, but as a fun tip, you could have used md
RAID0 for this: with different sized devices it would automatically stripe the
first 1TB of both disks, and then continue with the tail of 2TB drive as-is.
This would provide some linear speed benefit for the most part of the device,
with no change in reliability in this scheme compared to md linear.

-- 
With respect,
Roman
