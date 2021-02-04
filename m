Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE435C433E0
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 17:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A31664F65
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 17:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238497AbhBDRqf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 Feb 2021 12:46:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:60956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238428AbhBDRaI (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 4 Feb 2021 12:30:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13F2164F72
        for <linux-raid@vger.kernel.org>; Thu,  4 Feb 2021 17:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612459767;
        bh=6frdPYibE1SFxHQfKNlmE629v0toTQVEEoLVvFhVuRk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iJOZw3kf8V62DDaCNZcqCKZSybVYMTkll2Av4WsZz6ZMWpc6bhpsEQKTJ1u+poVjh
         0VsI5cinpTt8oXZ2TZXDsH6Xg/n0utFTA/1JTJGbjHhenf4x4Sryf1gXGecG3Eiudl
         1fo4P93syWIBudTdKMgJBiO7bAB93gbsdPRGsgNEetVN8oWarxoUsg5Rc534zuwv+j
         D+KRNsgUPe4VTeFnUdWJkEqW6eZ3G59il1iYfySQNaNyJVlXSpFEwHrZ+PBEy8gv5O
         EPlJVeewuPoJlhq0KPZUdJRA7mUtmrsDcjeMMkjbt1g1p1k/H72JGAYmJP6DJGAK1u
         cktpViB44PloA==
Received: by mail-lf1-f48.google.com with SMTP id b2so5781151lfq.0
        for <linux-raid@vger.kernel.org>; Thu, 04 Feb 2021 09:29:26 -0800 (PST)
X-Gm-Message-State: AOAM532pxRnzjFqj8ozjJ/FgA7/lnPRtkBY5u9OxiULdJ6LNkN23in/Q
        /Qunxq0LZj+MvQi7y2GMd8RYxXg47PijAQrr9ok=
X-Google-Smtp-Source: ABdhPJyP5CGNXc4M2JonVkl+FbgGKQRjd3VwROpGcpkz2ljAuiCdNu4x+CtvbispS19nwfDyYFoGO5MAoHmlp4fJ1tM=
X-Received: by 2002:a05:6512:b1b:: with SMTP id w27mr269278lfu.10.1612459765262;
 Thu, 04 Feb 2021 09:29:25 -0800 (PST)
MIME-Version: 1.0
References: <1612418238-9976-1-git-send-email-xni@redhat.com>
 <6359e6e0-4e50-912c-1f97-ae07db3eba70@redhat.com> <CAPhsuW6paostmNby1sHTPYM+2mmz_wxKBTw7e1G6tGFtema7Ow@mail.gmail.com>
 <3b95c7ad-f400-0a60-7f7a-6bc3e49967f8@redhat.com>
In-Reply-To: <3b95c7ad-f400-0a60-7f7a-6bc3e49967f8@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 4 Feb 2021 09:29:13 -0800
X-Gmail-Original-Message-ID: <CAPhsuW67-Zd7N14DsE+04H1YfBW1rJrfArZypG88mwZT45_+Hg@mail.gmail.com>
Message-ID: <CAPhsuW67-Zd7N14DsE+04H1YfBW1rJrfArZypG88mwZT45_+Hg@mail.gmail.com>
Subject: Re: [PATCH V2 0/5] md/raid10: Improve handling raid10 discard request
To:     Xiao Ni <xni@redhat.com>
Cc:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Matthew Ruffell <matthew.ruffell@canonical.com>,
        Coly Li <colyli@suse.de>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Nigel Croxon <ncroxon@redhat.com>, hch@infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Feb 4, 2021 at 12:39 AM Xiao Ni <xni@redhat.com> wrote:
>
>
>
> On 02/04/2021 04:12 PM, Song Liu wrote:
> > On Wed, Feb 3, 2021 at 11:42 PM Xiao Ni <xni@redhat.com> wrote:
> >> Hi Song
> >>
> >> Please ignore the v2 version. There is a place that needs to be fix.
> >> I'll re-send
> >> v2 version again.
> > What did you change in the new v2? Removing "extern" in the header?
> > For small changes like this, I can just update it while applying the patches.
> > If we do need resend (for bigger changes), it's better to call it v3.
>
> Yes, it only removes "extern" in patch1.
> >
> > I was testing the first v2 in the past hour or so, it looks good in the test.
> > I will take a closer look tomorrow. On the other hand, we are getting close
> > to the 5.12 merge window, so it is a little too late for bigger
> > changes like this.
> > Therefore, I would prefer to wait until 5.13. If you need it in 5.12 for some
> > reason, please let me know.
> Is md-next a branch that is used before merging? If so, could you merge
> the patches
> to md-next if your test pass? There is a bug that needs to be fixed in
> rhel. We can
> backport the patches if you merge the patches to md-next.

Yes, I can apply them to md-next. But I rebase it from time to time, so the
hash tag will change.

Thanks,
Song
