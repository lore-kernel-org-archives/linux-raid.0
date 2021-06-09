Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D24C9C47095
	for <linux-raid@archiver.kernel.org>; Wed,  9 Jun 2021 05:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B717D61352
	for <linux-raid@archiver.kernel.org>; Wed,  9 Jun 2021 05:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbhFIFuF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Jun 2021 01:50:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhFIFuE (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 9 Jun 2021 01:50:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C437661352
        for <linux-raid@vger.kernel.org>; Wed,  9 Jun 2021 05:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623217690;
        bh=659FVspzmEGIMMAwVy9Fp41i0JjGGkpOz0Fh4e/poDI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XrG/saKM5cIei15HyU83sK46sZrtVx2hHEuVB8zfe7Ha2kaeFnJyL4B3q0WExJTUE
         zFSFm2T28+3+PCzhqoD+bVQ9GLm7SSjFFI8kIh1vNwwqUf+8hZ+s5e9GQtcm8qxr5l
         5j8jRQRIrYCd5BDeXS6oGk/e9SlYTm+NLQAwq8dcW7+Q6/ajuj7RfFHqps59cxVL+O
         216oTVzkmV5EAKXfEuZyjZJi/bOuzjxbOdH2FF6SOk+us7PcrCfdcLvp5+qsZEjFpn
         I6vJbxtDXXtT1EQgPsvjhL90of8/C8QqROSt6OX0MS8CUmbE+n4Mcw0vV7nRQlxoTD
         82YVG47hb1dkA==
Received: by mail-lf1-f53.google.com with SMTP id i10so36061328lfj.2
        for <linux-raid@vger.kernel.org>; Tue, 08 Jun 2021 22:48:10 -0700 (PDT)
X-Gm-Message-State: AOAM532tqovxk0r3QerCLC/EMkdqvOnIbvmZutNMxBK0YwEl9xSfEqEo
        xbVzyqn4bM3vs757h50pTaDdi5xLnoHb+8pP8MU=
X-Google-Smtp-Source: ABdhPJx8MEXilyL07wXTur+TJ623jho/vPw9DEvOzVOIeETzW4MELzFahpB2RkzMvqfh+5+TPGvfpb/D6hLSAxgiLrc=
X-Received: by 2002:a05:6512:3713:: with SMTP id z19mr2411397lfr.438.1623217689098;
 Tue, 08 Jun 2021 22:48:09 -0700 (PDT)
MIME-Version: 1.0
References: <162302508816.16225.936948442459930625@noble.neil.brown.name>
 <20210607110702.660443-1-gal.ofri@storing.io> <162306497207.32569.4821556528932781303@noble.neil.brown.name>
In-Reply-To: <162306497207.32569.4821556528932781303@noble.neil.brown.name>
From:   Song Liu <song@kernel.org>
Date:   Tue, 8 Jun 2021 22:47:58 -0700
X-Gmail-Original-Message-ID: <CAPhsuW42ggkudMKpoyZjyuG+nMQUbR8TbeK5mOpe-Z8hvU54WA@mail.gmail.com>
Message-ID: <CAPhsuW42ggkudMKpoyZjyuG+nMQUbR8TbeK5mOpe-Z8hvU54WA@mail.gmail.com>
Subject: Re: [PATCH v2] md/raid5: avoid device_lock in read_one_chunk()
To:     NeilBrown <neilb@suse.de>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Gal Ofri <gal.ofri@storing.io>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jun 7, 2021 at 4:22 AM NeilBrown <neilb@suse.de> wrote:
>
> On Mon, 07 Jun 2021, gal.ofri@storing.io wrote:
[...]
> > -----------------------------------------------
> > without patch | 2M             | ~80% | 24GB/s
> > with patch    | 4M             | 0%   | 55GB/s
> >
> > CC: Song Liu <song@kernel.org>
> > CC: Neil Brown <neilb@suse.de>
> > Signed-off-by: Gal Ofri <gal.ofri@storing.io>
>
> Reviewed-by: NeilBrown <neilb@suse.de>

Applied to md-next. Thanks!

Song
