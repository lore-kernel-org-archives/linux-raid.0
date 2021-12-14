Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6A91C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 14 Dec 2021 01:11:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241638AbhLNBLg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Dec 2021 20:11:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54908 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbhLNBLf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Dec 2021 20:11:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB3E9B81747
        for <linux-raid@vger.kernel.org>; Tue, 14 Dec 2021 01:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9062EC34605
        for <linux-raid@vger.kernel.org>; Tue, 14 Dec 2021 01:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639444293;
        bh=Uf2Y8ybPsIM++2gnWntpfhTRpCgF9HFM20tbyL2jobU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=U5qtKcJK8n1zQdaSqmL/miZd62aDYPPS16iSC9ADHW1UsfzJW7Y5OaQjqj5Q010rn
         OtoyXUqO8hvdlp5GCF/az/znHVEPYn1wBjNq3oXf3zJXN0J43iziaL3q25lshR1Uc7
         qxnz6DUk+mXIle9DnlCXzvPfIFohmJw8xJikAXNfo5VNGNcdAmJoXJ0XijlwNVRyKa
         NtOa772+b7d+r2Y67JdsO00k4QEe8Upvwh3GCW2KzjlEq+nLsui4kbUa6ArGGNuE04
         5KlE0GLGhHjdLZuFKJtC/rgwQmOnY3POk7QtU/wvipF3kmkP92ZFREFRxJ1LdISAID
         xo+/2Bfth5TNw==
Received: by mail-yb1-f174.google.com with SMTP id x32so42542646ybi.12
        for <linux-raid@vger.kernel.org>; Mon, 13 Dec 2021 17:11:33 -0800 (PST)
X-Gm-Message-State: AOAM531458KVIoEVDQja5IuvNdEXQ6pe/eyNjXIjvpAfKoRid82Mq77W
        L8d27oW7fIBlW1wsanP5C1W1ja8E/M54kieVi24=
X-Google-Smtp-Source: ABdhPJze6ScRaM95GpZLHcZnTiEg0x7O2ZJDemJbn/66ou/ZDrOei+Tf/yiGLdhZJXO0SNx8CqwySKv2LkxbxcbJjsM=
X-Received: by 2002:a25:a283:: with SMTP id c3mr2414116ybi.219.1639444292738;
 Mon, 13 Dec 2021 17:11:32 -0800 (PST)
MIME-Version: 1.0
References: <CAPhsuW6mSmxPOmU9=Gq-z_gV4V09+SFqrpKx33LzR=6Rg1fGZw@mail.gmail.com>
 <20211110181441.9263-1-vverma@digitalocean.com> <20211110181441.9263-4-vverma@digitalocean.com>
 <CAPhsuW5drRBWOV9-i7cQWHAwSe5qHff5k23Y2-LsNGS_s8updw@mail.gmail.com>
 <2354ab61-0d13-aec5-a45f-23c5cd3db319@digitalocean.com> <CAPhsuW7r-JX+zOadzbzLDa0WxZdLws9=mTbPc0ci6qNfRBxgjA@mail.gmail.com>
 <998a933f-e3af-2f2c-79c6-ae5a75f286de@digitalocean.com> <b70fded5-8f65-7767-25c1-d45b1dcbbddf@kernel.dk>
 <78d5f029-791e-6d3f-4871-263ec6b5c09b@digitalocean.com>
In-Reply-To: <78d5f029-791e-6d3f-4871-263ec6b5c09b@digitalocean.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 13 Dec 2021 17:11:21 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6VsNPcG3VSLPk-zq16GYp1CN=X0jk9AGveAWaCBLgoig@mail.gmail.com>
Message-ID: <CAPhsuW6VsNPcG3VSLPk-zq16GYp1CN=X0jk9AGveAWaCBLgoig@mail.gmail.com>
Subject: Re: [RFC PATCH v4 4/4] md: raid456 add nowait support
To:     Vishal Verma <vverma@digitalocean.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>, rgoldwyn@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Dec 13, 2021 at 4:53 PM Vishal Verma <vverma@digitalocean.com> wrote:
>
[...]
>
> What kernel base are you using for your patches?
>
> These were based out of for-5.16-tag (037c50bfb)

Please rebase on top of md-next branch from here:

https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git

Thanks,
Song
