Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDFC6C433ED
	for <linux-raid@archiver.kernel.org>; Tue, 13 Apr 2021 00:27:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B563A61246
	for <linux-raid@archiver.kernel.org>; Tue, 13 Apr 2021 00:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239994AbhDMA1o (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Apr 2021 20:27:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239645AbhDMA1o (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 12 Apr 2021 20:27:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAFB26124C
        for <linux-raid@vger.kernel.org>; Tue, 13 Apr 2021 00:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618273645;
        bh=PsBtdoezcKnL1egDwbUE2IroCLH6fTKrX9lrD/I5Y6U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pkfCONo8IIeGWE7/qnlavB5sDid75qNgcDUkVRAtAT0Ji6MQp98HedOUcLrqvWwCh
         XjCWQXRo5gUMRRkN8B+2qpEeGBRtIHI/EE1/Y7yenmIEquEAcwhfKdWJAmAvp1HVL9
         +cZ0aiMPQSZDzFILYsKZtmPWd7mrOvQ7zbJMnXrSU4pWeiZL7hrd0nwpocQmdkqDfu
         Jt5WoCW2s9s7V0neStfL+LG21ghjYS1vxDSVKewEEg2VxCuCtcpIPu9CdB9vwqGRB7
         22YEu87sfROayCv5foXrgAvw769gUAYTpANj8ymH3cvcS2okZtSqDja1mLZRjEN8SV
         uP0Pyyo5xrRPA==
Received: by mail-lf1-f46.google.com with SMTP id z13so7301918lfd.9
        for <linux-raid@vger.kernel.org>; Mon, 12 Apr 2021 17:27:25 -0700 (PDT)
X-Gm-Message-State: AOAM5310g03hCT79XamuWzgtsACd0w88uaB5iwVJlLdYJTghpH4h3lEM
        1n1NzrAyv3WCnd6IPYofRi1JkrooQLhhvh+Y6BQ=
X-Google-Smtp-Source: ABdhPJxoiXs/IKYSzZ4KvMwz4vQ1qlpcXQhrEr2arpdlqRNPtR4cOuQtYpttC0VwSvL4YzbRadpGstDStvq3at7hFhU=
X-Received: by 2002:a05:6512:3582:: with SMTP id m2mr21242729lfr.10.1618273644101;
 Mon, 12 Apr 2021 17:27:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210412080530.2583868-1-hch@lst.de>
In-Reply-To: <20210412080530.2583868-1-hch@lst.de>
From:   Song Liu <song@kernel.org>
Date:   Mon, 12 Apr 2021 17:27:12 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4RSWh-Gr8=gEjTYwn-eRftafhQa7TrFbYMdqpOHk28eg@mail.gmail.com>
Message-ID: <CAPhsuW4RSWh-Gr8=gEjTYwn-eRftafhQa7TrFbYMdqpOHk28eg@mail.gmail.com>
Subject: Re: refactor mddev_find_or_alloc
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Apr 12, 2021 at 1:05 AM Christoph Hellwig <hch@lst.de> wrote:
>
>
> Hi Song,
>
> this series refactor mddev_find_or_alloc so that is more easier to
> read and groups related funtionality into separate helpers.

Applied to md-next. Thanks!

Song
