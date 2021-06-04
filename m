Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E412C47096
	for <linux-raid@archiver.kernel.org>; Fri,  4 Jun 2021 01:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3259F613F4
	for <linux-raid@archiver.kernel.org>; Fri,  4 Jun 2021 01:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhFDB2F (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Jun 2021 21:28:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229685AbhFDB2E (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 3 Jun 2021 21:28:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B01E5613F6
        for <linux-raid@vger.kernel.org>; Fri,  4 Jun 2021 01:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622769978;
        bh=XugPG1QeYD+pqYq9Eug6znVVi5l4OzaL1u1wjX8epdA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=E2S5O0oOwHr7XddzmHqcENidC3dPSkNiuxTIwvd0030Z2kUg8gS1ShWaeTvzaRXaC
         q978m5O+eBTfls9BGzBMuqTwHo0cYmAKOo/3rr2Yj1ZqLFPNlvaKGY7kt/+YBjW8rO
         MiyIoHAr/y2e1RR47oIRM/YVKsEcbBhxKGHtgjULbAExUEsQZvhgJuBcuwJvJudz3x
         LKhjaJHaZzziu2+MxfuQzRXa1qeW/Rhbxi3yeQB6xar5/BaGG5/wI/ORfcdyuXVm1D
         5qeqp/8G60ODXClpwAO34PQZ1RwTEQQdCFn6WXPeGG9eWkTjjlGbbYAxjY5D4hscpG
         tE0eq0B9jfqjA==
Received: by mail-lf1-f44.google.com with SMTP id n12so4612311lft.10
        for <linux-raid@vger.kernel.org>; Thu, 03 Jun 2021 18:26:18 -0700 (PDT)
X-Gm-Message-State: AOAM532YO1iisnA5j9nIr1Y3iKZHW5QlC3AYEHRjxeDc9E7VgGg6yhBk
        nc9NwOkakQQ99XHZ6XlE/J4LHOCqNvNGJsezwGU=
X-Google-Smtp-Source: ABdhPJxJTbGcvtOOo3PUPWuWyLsyyAFCTvR0hEFJDDOCj3pyKTI3nCkGRBa0uUv5QBSdQaa+esegVI3RwdEoe26oRQw=
X-Received: by 2002:ac2:4899:: with SMTP id x25mr534406lfc.372.1622769977082;
 Thu, 03 Jun 2021 18:26:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210603092107.1415706-1-jiangguoqing@kylinos.cn>
In-Reply-To: <20210603092107.1415706-1-jiangguoqing@kylinos.cn>
From:   Song Liu <song@kernel.org>
Date:   Thu, 3 Jun 2021 18:26:06 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5xqYivtVsmDD_kaaBVZXhiUY2bQrEEA=mX6Q8x5QvLUg@mail.gmail.com>
Message-ID: <CAPhsuW5xqYivtVsmDD_kaaBVZXhiUY2bQrEEA=mX6Q8x5QvLUg@mail.gmail.com>
Subject: Re: [PATCH 0/2] incremental patches about io stats
To:     Guoqing Jiang <jgq516@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Jun 3, 2021 at 2:21 AM Guoqing Jiang <jgq516@gmail.com> wrote:
>
> Hi Song,
>
> The first one addressed Christoph's comment, and I also add another one
> to explain why error handling is not needed there. Please review.
>

Applied to md-next.Thanks!

Song
