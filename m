Return-Path: <SRS0=ezIp=CY=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56735C433E2
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 11:16:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19A8320731
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 11:16:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="beSP275v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgIOLQ1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Sep 2020 07:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgIOLPi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Sep 2020 07:15:38 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40AEBC06174A
        for <linux-raid@vger.kernel.org>; Tue, 15 Sep 2020 04:14:54 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id y4so2433882ljk.8
        for <linux-raid@vger.kernel.org>; Tue, 15 Sep 2020 04:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bABfzPQ48+/BbIhaejj9L9AdWMUk5pH26BMstObvOB0=;
        b=beSP275vBOK1FOinJt0YKvm0spfMdNmtMFKuM8hOLXEpJBhJqtzmNGG2pimW22bwrP
         N/Xu+acV4PlnQNaF7HCbecxda6hdqeEC7uL5mtyWeQVx8JWbs2g/9qciJeGANFJ+F33X
         C6X06lpTMXu7rNzYt5GYc7D5voTG9N01QA+4V6LKA91razb48eUItJ0xYtj3zIz52Kg6
         t3sFRvhZMtSSl2uqaq+h4PQoT18sm5U4dMhy4J+i94zbHJcyqoxKabONK/+J/klLHLyU
         kBT5Tmor5YvrKOCnQKvu31C5aGD+joyjiDAaEFLma5iU4U48Gazoc3piVnAfftkxbjgI
         uqYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bABfzPQ48+/BbIhaejj9L9AdWMUk5pH26BMstObvOB0=;
        b=UlfvfkF4ffSsUE/zm7QF9P2KK0+UirpIpYkUbbTXQ3jLE8BKa35DVopakJUgx/JqXz
         t42U5HoQl0w1Nx5Clg84LWUIwldV5IC73tB8V2/VSl5J918NFnYf7yMS2xJDsOazP7Mx
         WMOGnR84BV61tMADEvj2D5ukpH4yK/lU46Eig65WXisbSBiyPvHOKPArGXIIY5H4QNDx
         MfhjZ5shgOpqlEQXYWtPqJP6+4L3dYIgGzeK+EjmnC3rKE7oSdhbufgXD5DmPtkoS4cT
         E3Hs3gXxIv3Ib2q7teSfTLx3qbq/uFNYbpgESuIeZEHeEHlmKHdTEeYlFPtd1aFpg6EI
         5MBQ==
X-Gm-Message-State: AOAM533gDCLICxVwoQe3IaJBTwg4SE9kJqs0KBBnWoQ67vQuB3+u+J4u
        HRCx3mW2Q6n1aMNCI8SJEPSfypA7u11u6zExMTmrLy3M5wOraA==
X-Google-Smtp-Source: ABdhPJxAML/uMhE2VJWeZEe69nNM4egGX9yHtvWmToiNWFK7IwSqgjKEmG6v2wUHy8vhR8pWOA6Vi+wznFzqTpBakOI=
X-Received: by 2002:a2e:8841:: with SMTP id z1mr6393633ljj.292.1600168491317;
 Tue, 15 Sep 2020 04:14:51 -0700 (PDT)
MIME-Version: 1.0
References: <1cf0d18c-2f63-6bca-9884-9544b0e7c54e.ref@aim.com>
 <1cf0d18c-2f63-6bca-9884-9544b0e7c54e@aim.com> <e3cb1bbe-65eb-5b75-8e99-afba72156b6e@youngman.org.uk>
 <ef3719a9-ae53-516e-29ee-36d1cdf91ef1@aim.com> <5F54146F.40808@youngman.org.uk>
 <274cb804-9cf1-f56c-9ee4-56463f052c09@aim.com> <ddd9b5b9-88e6-e730-29f4-30dfafd3a736@youngman.org.uk>
 <38f9595b-963e-b1f5-3c29-ad8981e677a7@aim.com> <9220ea81-3a81-bb98-22e3-be1a123113a1@youngman.org.uk>
 <24413.1342.676749.275674@quad.stoffel.home> <9ba44595-8986-0b22-7495-d8a15fb96dbd@youngman.org.uk>
 <24414.5523.261076.733659@quad.stoffel.home> <5F5E425B.3040501@youngman.org.uk>
 <24416.8802.152441.102558@quad.stoffel.home>
In-Reply-To: <24416.8802.152441.102558@quad.stoffel.home>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Tue, 15 Sep 2020 06:14:40 -0500
Message-ID: <CAAMCDefi-Y8joeobCJt-9_a8cDpeVWDsfGeVxXFWuQiwH2G0JQ@mail.gmail.com>
Subject: Re: Linux raid-like idea
To:     John Stoffel <john@stoffel.org>
Cc:     Wols Lists <antlists@youngman.org.uk>,
        Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> I've been looking at them for a while now, but hesitating
> because... not sure why.  I'm using a CoolerMaster case with five
> 5.25" bays, plus a 3.5" bay external, and another three or four
> internal 3.5" bays.  Works great.  Nice and plain and not flashing
> lights or other bling.  And not too loud either.  Which is good.
>
> But I've used crappy drive cages before, crappy hot swap ones.  Not
> good.  And I think it's time I just went with a 4U rack mount with a
> bunch of hot swap bays, if I could only find one that wasn't an arm
> and a leg.
>

I have had good luck with the ICY DOCK brand how swap I have 4
different 4 bay-3bay
ones spanning 6+ years and they all seem to just work.    And each
newer version seemed
to have improved design from the prior ones (plugs easier to get to, and such).
