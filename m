Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F26D2C433F5
	for <linux-raid@archiver.kernel.org>; Fri,  8 Apr 2022 16:59:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbiDHRBr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Apr 2022 13:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiDHRBq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Apr 2022 13:01:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836D730F9DF
        for <linux-raid@vger.kernel.org>; Fri,  8 Apr 2022 09:59:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F2166215B
        for <linux-raid@vger.kernel.org>; Fri,  8 Apr 2022 16:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78EF4C385A1
        for <linux-raid@vger.kernel.org>; Fri,  8 Apr 2022 16:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649437181;
        bh=zw0ARdpDW+LHaYLhbRipJvSqF5I9fE4zNhVIKiMDzkk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=AVvrnUpG0r7Sd2BxopNyrcXYjMsAcEPgcPmb/5t2LtTOoRxv6ErWOUraJDkWatd0T
         jf0ERbr332R1mCKrYsTnNRFNeBDmwC2oziiqWSv6pPDzClNithi8azXQVXq6WLkhqh
         avM79PZXbdXHt+h0iLd7QxcFZfhmQHea+Ew3FQSw9qHa3nPaBrfudzgkWbrDJO1j3P
         bxD8GtfgnLyFgkU9vOel20I0qKaPFIgc+zXnYNZm383W9+8ntB24c4+JZcU2VaEr0y
         iN3/LbYuTB85xH9OV88oZhKm9pTqsCLdugY7UATEKYeTmofDCIt2FUstJ/tsJxeWe8
         DHKN8zApSENWg==
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-2ebd70a4cf5so44457567b3.3
        for <linux-raid@vger.kernel.org>; Fri, 08 Apr 2022 09:59:41 -0700 (PDT)
X-Gm-Message-State: AOAM533/vuSHvtOswQZPCVdjq+cTZxEjvIW5ADf5xXbCr7YbtGRmTMV9
        mg/iAAZIerDc2svqILCZli5Hk/2NHoF9i6XqI9w=
X-Google-Smtp-Source: ABdhPJxN73uoVcCYYBfki9c/0hIF/UpOD7XZqJF940MVCJFev3IAU6GkIHPcW2oyqzKWBL19bEPTaXs9wv36q98x2No=
X-Received: by 2002:a0d:d610:0:b0:2eb:70c9:e7b0 with SMTP id
 y16-20020a0dd610000000b002eb70c9e7b0mr17781828ywd.447.1649437180489; Fri, 08
 Apr 2022 09:59:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220401021317.4046-1-heming.zhao@suse.com>
In-Reply-To: <20220401021317.4046-1-heming.zhao@suse.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 8 Apr 2022 09:58:59 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6TSD0Uiv7c+Xg7JD=n_EmSAX-FEQwM94CZoMfwFK+NEQ@mail.gmail.com>
Message-ID: <CAPhsuW6TSD0Uiv7c+Xg7JD=n_EmSAX-FEQwM94CZoMfwFK+NEQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] md: fix md_bitmap_read_sb sanity check issue &
 deprecated api issue
To:     Heming Zhao <heming.zhao@suse.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Mar 31, 2022 at 7:13 PM Heming Zhao <heming.zhao@suse.com> wrote:
>
> v4: split v3 to two patches.
>     - one for sanity check issue
>     - one for strlcpy to strscpy, and duplicated issue.
>
> v3: fixed "uninitialized symbol" error which reported by kbuild robot.
>
> v2: revise commit log
>       - change mdadm "FPE" error to "Segmentation fault" error
>         ("FPE" belongs to another issue)
>       - add kernel crash log
>     modify a comment style to follow code rule
>     change strlcpy to strscpy for strlcpy is marked as deprecated in:
>     - Documentation/process/deprecated.rst
>
> v1: for fixing sanity check issue in md_bitmap_read_sb() created v1.
>
> Heming Zhao (2):
>   md/bitmap: don't set sb values if can't pass sanity check
>   md: replace deprecated strlcpy & remove duplicated line

Applied to md-next. Thanks!
