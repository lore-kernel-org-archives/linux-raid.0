Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8FF7ECAAA1
	for <linux-raid@archiver.kernel.org>; Mon, 12 Sep 2022 09:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiILJ0h (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Sep 2022 05:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiILJ0c (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 12 Sep 2022 05:26:32 -0400
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A7825EAC
        for <linux-raid@vger.kernel.org>; Mon, 12 Sep 2022 02:26:29 -0700 (PDT)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by rin.romanrm.net (Postfix) with SMTP id 319AE5F9;
        Mon, 12 Sep 2022 09:26:26 +0000 (UTC)
Date:   Mon, 12 Sep 2022 14:26:24 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Reindl Harald <h.reindl@thelounge.net>
Cc:     Wols Lists <antlists@youngman.org.uk>,
        Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
Subject: Re: 3 way mirror
Message-ID: <20220912142624.63ba4b5c@nvm>
In-Reply-To: <fe532dc9-daef-e096-f729-d1cd752f18d2@thelounge.net>
References: <CAJH6TXj0y_bfJ1q50S7xnTyz_4BSrgNboim9e+zK1nKZX9MR3g@mail.gmail.com>
        <53f5754d-e3e2-a8ba-bedb-07eb2b594595@thelounge.net>
        <CAJH6TXi=pCvV2xcyWcOD4KVDP6BcoPdgdMqhSwyW9BMVEhtzYA@mail.gmail.com>
        <dcef59a2-b8f6-ef8b-2fd6-2c8bfdfba4ad@thelounge.net>
        <2bcebfce-6def-38f8-99be-1f5702905f94@youngman.org.uk>
        <fe532dc9-daef-e096-f729-d1cd752f18d2@thelounge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 12 Sep 2022 10:16:55 +0200
Reindl Harald <h.reindl@thelounge.net> wrote:

> > That's called paranoia
> 
> that's called common sense
> 
> > ALL drives have hiccups when there's absolutely 
> > nothing wrong with them. What are the manufacturer's error figures? 
> > Expect at least one error every two or three complete passes of pretty 
> > much every large big disk nowadays?
> i don't expect any SMART error at all and if one hits after years of 
> uptime fine that the drive don't fail completly - but would i trust it? no!

I have multiple drives (Hitachi) which have developed around 3 to 10
reallocated sectors, and then just continue to work for years, not increasing
those further. Throwing them away would be uneconomical. Not always a
reallocated sector is a sign of impeding failure, what you need to look for is
if there is more than one, and the count is increasing quickly.

Generally though, if you are way too concerned about individual drive failures,
it could be a sign that you do not have a robust enough backup scheme in place.

-- 
With respect,
Roman
