Return-Path: <SRS0=H5I/=DN=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=BAYES_05,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 887CDC41604
	for <linux-raid@archiver.kernel.org>; Tue,  6 Oct 2020 16:01:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B79E2075A
	for <linux-raid@archiver.kernel.org>; Tue,  6 Oct 2020 16:01:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hlnejGog"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbgJFQBN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 6 Oct 2020 12:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbgJFQBN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 6 Oct 2020 12:01:13 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBE4C061755
        for <linux-raid@vger.kernel.org>; Tue,  6 Oct 2020 09:01:13 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id u6so13560559iow.9
        for <linux-raid@vger.kernel.org>; Tue, 06 Oct 2020 09:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tu7N8v8ze8Uwwl4dQWV9yYzTWrRGX6hy7o7ASe3ja9s=;
        b=hlnejGogLbgVhg7lSSULouapRhy2odQ7NxL4IkjxBJfEBcqB5d+Y4l9hYWViqfYk9+
         K0qyPCNrd/qlq+XDZn6tOEiPmXBFY+b2yooCvZdNYSV4YQYUKeanLMiM88HNxf8OnDwN
         RY+QUE8eBbymHOBA/nxRU2J9qPTa5OK+1KArYPi71YkU30gwU4hBUplCMhSxh9DPewCw
         v0LIJnrtYn6WJtiwrOTX7eYsWI5pvTS1TmsisOCJcnO0hOn6Si7lA33S4NxWpR6UauT9
         4oDObyib9c8IEprs411RP3nSLLBLN86kBHue2nVpkmbehhKPzl+loJ3OhLXsKW4XJ8g4
         IGdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tu7N8v8ze8Uwwl4dQWV9yYzTWrRGX6hy7o7ASe3ja9s=;
        b=Vj9Te+JlJU7+OBSWkfa5fNVWw2I98eKnUqh3xOStbBtohtmHDQd8CVRgRuadjSrFMn
         VddYDzojOgErt7X49S20Dha0YEUhQM+E1d2jVYfTUVS+jIis3sLuMmARglzfjGR8jbEu
         tXCTjY3VkQ0nK8EwnKhIEyowPyIVbtyiwocD/AqlWw3AKBVv7Kxnf/8XAO6LgpxYa7nG
         S/gRSMlfLkIkeSGibL8pvE87mUrMwi8rX72VQSLY4xVnLmFVYtsWCzbgHY3hsosPGgjU
         Ty+fTzYt+NhEgpgGfxvPkMspOgITUCD/WhSo6MJdXPbKC4H7kpE3C6Bzut3xWfnZg8lB
         cMgg==
X-Gm-Message-State: AOAM531ZAn2x9MDiffqBs8zUyK/DpUx17iTuNtlcCnnGx0ChKj3EEHKB
        K672gz9Wj/8B+knm45Qwta3F+oEMnAi+/e74tls=
X-Google-Smtp-Source: ABdhPJx8rWVwCvoj/1wHyRhgUAWs9TdyFJKyhkBfnW+YzVZJ02iHEFnaGBYQDSj8xcvZn+tOIogfO96JvGTFEPP/MvU=
X-Received: by 2002:a02:9543:: with SMTP id y61mr1985564jah.64.1602000071838;
 Tue, 06 Oct 2020 09:01:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAHscji30ACa2d0qz-nr5vqPYOP642dwjS5BY07g2DQS7GBG-2A@mail.gmail.com>
 <20201005184449.54225175@natsu> <CAHscji0pNezf6xCpjWto5-21ayoCeLWm34GTYh5TSgxkOw90mw@mail.gmail.com>
 <20201005190421.4ecd8f1b@natsu> <CAHscji1VrccTOaQc4GdWof4E+Bzs5KL0-tJJj0ZUM9Db=QBriw@mail.gmail.com>
 <CAAMCDedZfx+w3NT_QgB0KGkeEQikCtYVy9YuiNEhNaEjXF1C8w@mail.gmail.com>
 <CAHscji01ikKz4fQ_9i4Tb3AraTD+ZcXBbK-Mm+zY4p3p2qbF4Q@mail.gmail.com>
 <CAAMCDeeRNnoC6mdj7L1PdD5Ztek1tzm++UPi3k=hWvBUA=oLxQ@mail.gmail.com> <6f2b7a81-fea3-bc05-a6d3-fc1331e249db@buttersideup.com>
In-Reply-To: <6f2b7a81-fea3-bc05-a6d3-fc1331e249db@buttersideup.com>
From:   Daniel Sanabria <sanabria.d@gmail.com>
Date:   Tue, 6 Oct 2020 17:01:00 +0100
Message-ID: <CAHscji1r8=4bKr3fx_MJ2nxnb9QYcRhnY8uZkoemnrjNLAmiMQ@mail.gmail.com>
Subject: Re: do i need to give up on this setup
To:     Tim Small <tim@buttersideup.com>
Cc:     Roger Heflin <rogerheflin@gmail.com>,
        Roman Mamedov <rm@romanrm.net>,
        Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thank you very much Guys. This is one of the best email lists I'm
subscribed to so thanks to you all !

I've decided to dissolve this array and will use the disks as stand
alone drives. I have another array (raid0) using a pair of the WD
caviar blues and the pair of non-marvell ports and haven't had any
issues in years so will keep that one.

Thanks again,

Dan
