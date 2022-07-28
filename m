Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D3BC04A68
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 16:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbiG1QfX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 12:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiG1QfP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 12:35:15 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E48959D
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 09:35:13 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id p5so2836817edi.12
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 09:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=WuvoJ90b2lCyCsNl1uoWkwZZ34W9Zu4j6EvkcDdXVwQ=;
        b=jvQqyGbQc9RYesbut9vgjY0VzhqNEBnF3cfsQbiO2p4n6Mzc2nJb2+y8eY2mMiOcZD
         VltXGjkq3ui1UvSrfncIGFRJviK9WRplIBZ9tT/01bLoKwiNfLtrSoIEFs/XyOyS7JmS
         n+tGv2wwMpCYk7ehwo72EG/nqoP044Oca6p2o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=WuvoJ90b2lCyCsNl1uoWkwZZ34W9Zu4j6EvkcDdXVwQ=;
        b=3bsEBYdbIgKFrgpYKNdHGlZPaqoDm/6C3VUL6cXyd0j1/PlDQNPrYxz8szeq+VNBFn
         45MAu4EGeOShH3Rxn2L1X3kQ+4lX2jzlQW0er//x9YyDxNisQ3RdssBr0trpsCPP7mot
         zt5cjBRe78CwQiU5+I5/JDXo7JVPnmicykfsdJTJmNcGD1jfv6UaO0o6e5VHXsmMuS0K
         PKkilhLtsFUWmm/kYTVhQ0uRAohesMmxnQHmHoGfeGKPOM4HmG+GCoyXk93z0pjgwisz
         +O1iGcDby8Qkn/z2Y0dQ/5+IbFSTlxBYcw1cnfHKBaO1dY839NjYdopagw0fNzLhVT/9
         kr4A==
X-Gm-Message-State: AJIora+e88P6vqa5B9UGgVWHjLn/Fq0XCWjaFEUpvGP9lRoH9nHUU9oV
        IeXajj/st+xRl4SanKBFwyzuHToVZBkwZuyz
X-Google-Smtp-Source: AGRyM1t5SeOKUMHMBVWz87oYvc4YC3qGRW5gvSZQHzizTmV9W2kLzGY6yQT96DjKTsvcIyEMBjk+aA==
X-Received: by 2002:aa7:db87:0:b0:43b:a0d5:8848 with SMTP id u7-20020aa7db87000000b0043ba0d58848mr28294166edt.60.1659026111575;
        Thu, 28 Jul 2022 09:35:11 -0700 (PDT)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com. [209.85.221.51])
        by smtp.gmail.com with ESMTPSA id b10-20020a1709063caa00b00703671ebe65sm574372ejh.198.2022.07.28.09.35.10
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 09:35:10 -0700 (PDT)
Received: by mail-wr1-f51.google.com with SMTP id bn9so2912032wrb.9
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 09:35:10 -0700 (PDT)
X-Received: by 2002:adf:ead2:0:b0:21d:8b49:6138 with SMTP id
 o18-20020adfead2000000b0021d8b496138mr18613494wrn.138.1659026109819; Thu, 28
 Jul 2022 09:35:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220728085412.1.I242d21b378410eb6f9897a3160efb56e5608c59d@changeid>
In-Reply-To: <20220728085412.1.I242d21b378410eb6f9897a3160efb56e5608c59d@changeid>
From:   Doug Anderson <dianders@chromium.org>
Date:   Thu, 28 Jul 2022 09:34:56 -0700
X-Gmail-Original-Message-ID: <CAD=FV=UR+DhWuc555q8dde7MJwgkvG-s1rWYXqQ-afdo3q80pw@mail.gmail.com>
Message-ID: <CAD=FV=UR+DhWuc555q8dde7MJwgkvG-s1rWYXqQ-afdo3q80pw@mail.gmail.com>
Subject: Re: [PATCH] dm: verity-loadpin: Drop use of dm_table_get_num_targets()
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>, dm-devel@redhat.com,
        Song Liu <song@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Milan Broz <gmazyland@gmail.com>, linux-raid@vger.kernel.org,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

On Thu, Jul 28, 2022 at 8:54 AM Matthias Kaehlcke <mka@chromium.org> wrote:
>
> Commit 2aec377a2925 ("dm table: remove dm_table_get_num_targets()
> wrapper") in linux-dm/for-next removed the function
> dm_table_get_num_targets() which is used by verity-loadpin. Access
> table->num_targets directly instead of using the defunct wrapper.
>
> Fixes: b6c1c5745ccc ("dm: Add verity helpers for LoadPin")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
>
>  drivers/md/dm-verity-loadpin.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

FWIW:

Reviewed-by: Douglas Anderson <dianders@chromium.org>
