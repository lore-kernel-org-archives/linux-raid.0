Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02222C43334
	for <linux-raid@archiver.kernel.org>; Wed,  6 Jul 2022 15:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbiGFPIT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 6 Jul 2022 11:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbiGFPIN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 6 Jul 2022 11:08:13 -0400
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BE7275C5
        for <linux-raid@vger.kernel.org>; Wed,  6 Jul 2022 08:08:11 -0700 (PDT)
Received: by mail-qt1-f177.google.com with SMTP id x1so18603619qtv.8
        for <linux-raid@vger.kernel.org>; Wed, 06 Jul 2022 08:08:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ScRkAz/VqtB+AtxqVIwVUVdF/rIZB4AANK+myVEOT60=;
        b=B7ELmbpxW5IFzRoTOSPlqIOPzpy/4IhYhkoyFNeOZhCTOtl2YgwZbTfQT1rG/zbR0f
         w8th4gdJPpsta7ItSvRRygStHrIZPZMuUv+IXu456sofhstKmmV92sJ8SCldUywL/ujk
         YPdQyFyLlD6QpUr2Xelbremvn0HJtDybOlty9/EX91jI5EkNhVqTYXIDA/EkGsmDHVPi
         q5qjLXkqt1FzBfNmz78BX2ng76ZiZqJWj4mZVWqZUQ+wdvikI1AsiwOsK7BWHNe0MMFB
         dOcMwkFPQV85WgcAtQzTWgABmXbpvdA+prZqXjjF7AjIk3EM+L5DZhHt6f5/52vOEmpA
         ErpA==
X-Gm-Message-State: AJIora/u2NLeUy0vhdV4d4MPLWggY7eRrRpmbLjlZALQLwhJdoZY+lgh
        aKQuIVgmUA7C2eumj9sebBVa
X-Google-Smtp-Source: AGRyM1vURiVQNneit1uIOq0gI+2o4Q1iXAOnL3S780GQ4xr/mr7+VNJ3IiJ/UQzyRS8zDfx/h2ANCg==
X-Received: by 2002:a05:622a:196:b0:319:83f5:7a2c with SMTP id s22-20020a05622a019600b0031983f57a2cmr33294199qtw.0.1657120090010;
        Wed, 06 Jul 2022 08:08:10 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id l26-20020ac848da000000b003177969a48fsm24329478qtr.21.2022.07.06.08.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 08:08:09 -0700 (PDT)
Date:   Wed, 6 Jul 2022 11:08:08 -0400
From:   Mike Snitzer <snitzer@kernel.org>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     Alasdair Kergon <agk@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        Douglas Anderson <dianders@chromium.org>,
        linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
        linux-security-module@vger.kernel.org,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v7 2/3] LoadPin: Enable loading from trusted dm-verity
 devices
Message-ID: <YsWlWIbzJtUQUaWy@redhat.com>
References: <20220627153526.3750341-1-mka@chromium.org>
 <20220627083512.v7.2.I01c67af41d2f6525c6d023101671d7339a9bc8b5@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627083512.v7.2.I01c67af41d2f6525c6d023101671d7339a9bc8b5@changeid>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jun 27 2022 at 11:35P -0400,
Matthias Kaehlcke <mka@chromium.org> wrote:

> Extend LoadPin to allow loading of kernel files from trusted dm-verity [1]
> devices.
> 
> This change adds the concept of trusted verity devices to LoadPin. LoadPin
> maintains a list of root digests of verity devices it considers trusted.
> Userspace can populate this list through an ioctl on the new LoadPin
> securityfs entry 'dm-verity'. The ioctl receives a file descriptor of
> a file with verity digests as parameter. Verity reads the digests from
> this file after confirming that the file is located on the pinned root.
> The digest file must contain one digest per line. The list of trusted
> digests can only be set up once, which is typically done at boot time.
> 
> When a kernel file is read LoadPin first checks (as usual) whether the file
> is located on the pinned root, if so the file can be loaded. Otherwise, if
> the verity extension is enabled, LoadPin determines whether the file is
> located on a verity backed device and whether the root digest of that
> device is in the list of trusted digests. The file can be loaded if the
> verity device has a trusted root digest.
> 
> Background:
> 
> As of now LoadPin restricts loading of kernel files to a single pinned
> filesystem, typically the rootfs. This works for many systems, however it
> can result in a bloated rootfs (and OTA updates) on platforms where
> multiple boards with different hardware configurations use the same rootfs
> image. Especially when 'optional' files are large it may be preferable to
> download/install them only when they are actually needed by a given board.
> Chrome OS uses Downloadable Content (DLC) [2] to deploy certain 'packages'
> at runtime. As an example a DLC package could contain firmware for a
> peripheral that is not present on all boards. DLCs use dm-verity to verify
> the integrity of the DLC content.
> 
> [1] https://www.kernel.org/doc/html/latest/admin-guide/device-mapper/verity.html
> [2] https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/dlcservice/docs/developer.md
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> Acked-by: Kees Cook <keescook@chromium.org>

Acked-by: Mike Snitzer <snitzer@kernel.org>
