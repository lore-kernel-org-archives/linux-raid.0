Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C682EC54EE9
	for <linux-raid@archiver.kernel.org>; Tue, 13 Sep 2022 20:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiIMUsr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 13 Sep 2022 16:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiIMUsq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 13 Sep 2022 16:48:46 -0400
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B9974DD9
        for <linux-raid@vger.kernel.org>; Tue, 13 Sep 2022 13:48:45 -0700 (PDT)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by rin.romanrm.net (Postfix) with SMTP id 4BE9B66F;
        Tue, 13 Sep 2022 20:48:42 +0000 (UTC)
Date:   Wed, 14 Sep 2022 01:48:41 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Reindl Harald <h.reindl@thelounge.net>
Cc:     Pascal Hambourg <pascal@plouf.fr.eu.org>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
Subject: Re: change UUID of RAID devcies
Message-ID: <20220914014841.0d42fd4b@nvm>
In-Reply-To: <75a3c54a-c436-32a3-10c9-e9bc75d8a143@thelounge.net>
References: <2341a2a9-b86e-f0e5-784a-05dbd474dec5@thelounge.net>
        <05a1161b-d798-c68f-d37c-a9fc373c6e73@thelounge.net>
        <0023fefe-aad1-e692-48dd-e354497f6e41@plouf.fr.eu.org>
        <1fb05e0f-34b7-3ec4-bc00-ec540e592f19@thelounge.net>
        <3fc0b889-3ef9-652e-6452-2eeede918683@plouf.fr.eu.org>
        <9e537739-2fbd-2c99-8191-54faf0a69a8b@thelounge.net>
        <6b4a5399-5053-4a51-26d7-2f62c47c2981@plouf.fr.eu.org>
        <65ee1134-60e4-4577-74c7-0ba15ae39225@thelounge.net>
        <97b66977-97c7-21aa-f1d9-f0d34a0fcf9b@plouf.fr.eu.org>
        <b428f8c6-cf8b-218c-3cae-8f36327901f7@thelounge.net>
        <ec3b9673-688b-18c8-188b-246e9c63a2d0@plouf.fr.eu.org>
        <071b8b8a-7a50-3eec-22d4-5880ff3f80e9@thelounge.net>
        <8babedc5-a2e7-326f-3340-10e354aecb45@plouf.fr.eu.org>
        <15f573c4-0c96-885f-659f-bfa2cbd698a7@thelounge.net>
        <20220914003228.4377cc6a@nvm>
        <93ea4d09-d6f9-0c5f-1b8e-e610af592834@thelounge.net>
        <20220914012801.5b2dce25@nvm>
        <75a3c54a-c436-32a3-10c9-e9bc75d8a143@thelounge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 13 Sep 2022 22:46:23 +0200
Reindl Harald <h.reindl@thelounge.net> wrote:

> > It has never occured to me to check, but you could also specify arrays by
> > "name=" there, instead of UUID. See "man mdadm.conf".
> 
> and the name is *what*

Name is, see mdadm --detail /dev/md1 | grep Name

> ARRAY /dev/md1 UUID=b7475879:c95d9a47:c5043c02:0c5ae720
> ARRAY /dev/md2 UUID=ea253255:cb915401:f32794ad:ce0fe396

-- 
With respect,
Roman
