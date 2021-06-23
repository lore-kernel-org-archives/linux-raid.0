Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B75EC48BC2
	for <linux-raid@archiver.kernel.org>; Wed, 23 Jun 2021 20:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 659DE60234
	for <linux-raid@archiver.kernel.org>; Wed, 23 Jun 2021 20:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhFWU4X (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Jun 2021 16:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhFWU4X (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 23 Jun 2021 16:56:23 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810F3C061574
        for <linux-raid@vger.kernel.org>; Wed, 23 Jun 2021 13:54:04 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id j12so3170805qtv.11
        for <linux-raid@vger.kernel.org>; Wed, 23 Jun 2021 13:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vxKwQDu2LgFmkbOQtqwYSUCi1WSnYXrfUiJ/QHHB0dQ=;
        b=WkULrihqr8oelrNJ1T13+DlipyLTOBEXDgtXjVxfAWeZWZJYpE9UBnfddAQ7NqpqcE
         RzREfKc8vQclZEZDjH9zZzQYdfFVkqX7bLYrZ0NHINHLNakujykHMNkkMLrRK267SvaC
         /46vgViSoplVZvDZbZK0bPC0FSNX/TV7N+K7tlvKM9owvT2dqgBbW3ZNaxwNqBxVcoLw
         kpJJf/zMq0v20jMivopvqruMILk9MgW+4oAqfK9P4WE3jlkrWhfmQh+IVJ7sXhhpmG8V
         bZIYzV/KZsMfTq3Z8dYzo+4+fR+KkYTGvOkjBUZ62h9ZKBRgftPhGcvJvoqt5s30g6rD
         1FQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vxKwQDu2LgFmkbOQtqwYSUCi1WSnYXrfUiJ/QHHB0dQ=;
        b=TJICyi68IMZ4Q3XRf6yIpRUtDU+BFckVDdgF+SyPvEGEjkHoTZmfNf/Yn9beIgc9mw
         LJA4R7nN12yoh4WzwQjGF+6RM3tU1XoZ6gexlAtcQWgYYf8NP2YlOKEg0Nr3zkr4K+al
         wnxUo1hzqjMoPVc1pfsWdbWkjOIPOCsWnKMvpqrO4RrOukjbT+/jiKiELNc5Xce/rgxs
         HOuu1HqXQjqeQId6dpR25+NYzT0g+QvvfeEjOUjNgCsh4p31A6gFRrh9MERXxLoKYb/P
         O4oDhg2bifQ8rT+IZSj4fd/e3rTukW4s0CYsJPb/e2PNRVUSFRPw4Pd10UX6J5S9pahM
         DRZw==
X-Gm-Message-State: AOAM530CTKWUMF3jTY+ozSUTYVNbbv17zD0lm2y3CoYfwO1TPhocWj7/
        gLZwYf0kXXIdaHAqPhfqA87KPnoDUsYBW3Vrvj5RG3ii7k+OUg==
X-Google-Smtp-Source: ABdhPJximiT+LJD3c+3evIz6B9xI/xREZoDlu/9mQPZI4O7bllTorHbUjmzlbz3El8FItoXJtV1HVycVkniXVU7yk7w=
X-Received: by 2002:ac8:549:: with SMTP id c9mr1753974qth.80.1624481643551;
 Wed, 23 Jun 2021 13:54:03 -0700 (PDT)
MIME-Version: 1.0
References: <03ca5974-60ed-d596-7eff-cac44f4a6d62@gmail.com>
 <24787.28117.662584.586506@quad.stoffel.home> <1986d43d-11e9-fbf0-7812-0aafc6568855@youngman.org.uk>
 <CAAMCDedHYKqBDfTysU=-CtxRMVpftPK1+crewRM2yuTDDq653A@mail.gmail.com>
In-Reply-To: <CAAMCDedHYKqBDfTysU=-CtxRMVpftPK1+crewRM2yuTDDq653A@mail.gmail.com>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Wed, 23 Jun 2021 15:53:37 -0500
Message-ID: <CAAMCDee-1J2DVQWPyqe-rZ-E=Ers3Msvdn8+KpFnRxeyQafXWg@mail.gmail.com>
Subject: Re: Question: RAID cabinet for home use
To:     antlists <antlists@youngman.org.uk>
Cc:     John Stoffel <john@stoffel.org>,
        Bill Hudacek <bill.hudacek@gmail.com>,
        mdraid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

resending without html.  Lovely that you seem to have to disable html
on each reply.

 I found an $80 rackmount case that has 2 sets of 3x5.25" bays and
would take 2 of the  4 into 3 3.5" hot swap bays (icy dock or athena
like devices).
https://www.newegg.com/black-istarusa-d-416/p/N82E16811165215

 Outside of that one I did not see much that had 6 external 5.25"
slots and did not cost a huge amount.   The above is empty, no fans,
no PS.

 I have an old ThermalKing M9 that has 9-5.25" external bays and I
have 3 of the 4 into 3's in it giving me 12 usable hot swap 3.5"
drives, but that case appears to no longer be made, and I seem to
remember when I bought it I only found maybe 3 cases similar to it and
a couple of them were 2x the price.

 Now it appears that the most important feature of a case is having
way too many colorful lighted fans.
