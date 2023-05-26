Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D857C77B7C
	for <linux-raid@archiver.kernel.org>; Fri, 26 May 2023 03:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235780AbjEZD5O (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 25 May 2023 23:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235687AbjEZD5M (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 25 May 2023 23:57:12 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2446D187
        for <linux-raid@vger.kernel.org>; Thu, 25 May 2023 20:57:11 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id 5614622812f47-38ef6217221so238939b6e.3
        for <linux-raid@vger.kernel.org>; Thu, 25 May 2023 20:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685073430; x=1687665430;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6mmBoczAIhNmAY0KkfWYXYx0/oDmqvp6R25EASfqbLw=;
        b=Bgh+bLdpcn9RXNG3jezqaNqvJiZr6HN9p3WOrDKA6wz2PlyAU0aAwEeX3emi7vv6Hj
         IC7CzOyaOiEuZ2utdccqzyEVyFVY4+eQ/Z/UR6fIcGUlLJlHXhLB74j+tgU3NLIwukQM
         0/gQY0DSbvg37ZkuOI3FCh/PgpkCIZtrW3khxk0Vc05Y9Alx58KxOfT9UbATVSyAU4NY
         TCDjQHHCEmiZ0Wg+5eD1rr+8hnAwOgLD/uMk0qhwUwvPJ5Iz/RtCb1V+93knn15oao2K
         GJHGCi16JiJdu7k8XctIqE8v2A7ioLNyfZKp9mjyl5T3297IZndE2OwpALd5bruPp/l4
         cx6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685073430; x=1687665430;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6mmBoczAIhNmAY0KkfWYXYx0/oDmqvp6R25EASfqbLw=;
        b=YgF4v5CU4N3wV44azREJHPAqzDTb6cs8kOI8W32KariiNVfuLRLQFXosjHQWl1fwT+
         EeB2CyrL+8YmDgFA6dV1oixQr2Px6/PGt+9n+If/B5Gs6hDM7k84yE8do4EcBawcj1Sg
         D/DuerWMzBY/6OL230P6BwUPKrBDCh36ZloflNfzeD7GojGIX9u2/6B8KjsWOmeDlqTD
         CuMcbACM87LA+qeZhavf1j1NJnGBv3Uk3Eq883GpGJmXZmyuOn5a1vmTVZo/B3ovDy45
         YR99xfAwMv0IqPT9gUh3KOiJY9hGtsWvLfAOjZ+maIZBeyKcPbNxRA/zLOd447OtlnNE
         v9/g==
X-Gm-Message-State: AC+VfDyaugx+D+95B8D9nq5IEiS7GJ2AW68G1SgqfojSQJCkAFwRzQBF
        O8+tfqyfbGYSonY1OaL6SoYgU9OWcx4+9rdkqwfjMOpE
X-Google-Smtp-Source: ACHHUZ7FoTiMRLEefq74SAhAOSZwvLIulihQMf1I7Siv3xxFEqAjjlry4v8Xo+JWkTcN3KY2YUurBO3ZVK0wEfXWSHo=
X-Received: by 2002:a05:6808:3089:b0:398:f740:631e with SMTP id
 bl9-20020a056808308900b00398f740631emr511094oib.16.1685073430301; Thu, 25 May
 2023 20:57:10 -0700 (PDT)
MIME-Version: 1.0
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
 <CALTww2_4pS=wF6tR0rVejg1ocyGhkTJic0aA=WCcTXDh+cZXQQ@mail.gmail.com>
In-Reply-To: <CALTww2_4pS=wF6tR0rVejg1ocyGhkTJic0aA=WCcTXDh+cZXQQ@mail.gmail.com>
From:   d tbsky <tbskyd@gmail.com>
Date:   Fri, 26 May 2023 11:56:59 +0800
Message-ID: <CAC6SzHJc6CquhF=XsqKsjTtRNNvoAymd7LjzqMTn13dkbHzerg@mail.gmail.com>
Subject: Re: The read data is wrong from raid5 when recovery happens
To:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Xiao Ni <xni@redhat.com>
> We found a problem recently. The read data is wrong when recovery
> happens. Now we've found it's introduced by patch 10764815f (md: add
> io accounting for raid0 and raid5). I can reproduce this 100%. This
> problem exists in upstream. The test steps are like this:

sorry for the interruption. but I wonder if any current RHEL version
has this problem?
I hope it is safe since I can not find it in bugzilla.
