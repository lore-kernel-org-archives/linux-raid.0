Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA102C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 11 Mar 2022 18:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350687AbiCKSBu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 11 Mar 2022 13:01:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236099AbiCKSBr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 11 Mar 2022 13:01:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6181D3DAA;
        Fri, 11 Mar 2022 10:00:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B069B82C8B;
        Fri, 11 Mar 2022 18:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D32BC340F4;
        Fri, 11 Mar 2022 18:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647021641;
        bh=1B9M6WufRHwLGHxN5N+jVnheJKyKK97qoYyy0r2cmFE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aPRXRlocTDs7NSoF+9ir0ya+MiC80Lovu0lYXiiadwUTVfHam8f7WRn8lEv/k8LjT
         ebfB4Ltmps4fgKQrFXkyp6EV+5AgOfDuhlwqzvK0Wmvjgsx4BbPBxjNE3i92+RbxRb
         DPbX3l4bdy+Q8OHHVmURu83vbiOYC0E9Nptm9UBoskr/VoJjlqQwFX8ufvD8+AQ3ZT
         O+5iBh45Di1CmpvOsiYw3+7k7vewTUMcXlyEz4Udj5dhB52xTGkYs6n+sYG5FgsOI6
         ts7aP7bbU11fxF4x+VrQ+uiHQpy/ntAekx1ho0V6IpmK5m/A60So27+VGkM0C2yc17
         sATy63kvXw7uQ==
Received: by mail-yb1-f172.google.com with SMTP id j2so18642076ybu.0;
        Fri, 11 Mar 2022 10:00:41 -0800 (PST)
X-Gm-Message-State: AOAM532XYLOyFOLcYDW8eLel1I+YexCwX7jl7btp8tEF14yeWAbJf/P4
        aPRAS9mvyiwl+/N5YUXmUYIy5FHOXcFk+2J9UAA=
X-Google-Smtp-Source: ABdhPJz2EHkavaai5y+jnroPDDtI+Nu4A9jqDtHhb9kQ5D87ZPlcYUh5gu7T/OHYpQYHCW4UC0hwFCs/C0BIUeHxCPA=
X-Received: by 2002:a05:6902:1ca:b0:624:e2a1:2856 with SMTP id
 u10-20020a05690201ca00b00624e2a12856mr8788676ybh.389.1647021640233; Fri, 11
 Mar 2022 10:00:40 -0800 (PST)
MIME-Version: 1.0
References: <20220311173041.165948-1-axboe@kernel.dk>
In-Reply-To: <20220311173041.165948-1-axboe@kernel.dk>
From:   Song Liu <song@kernel.org>
Date:   Fri, 11 Mar 2022 10:00:28 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4Q5y8Z3=xafPa92Zg-dsU634AfqquFacQADXjU5RJViw@mail.gmail.com>
Message-ID: <CAPhsuW4Q5y8Z3=xafPa92Zg-dsU634AfqquFacQADXjU5RJViw@mail.gmail.com>
Subject: Re: [PATCHSET 0/2] Fix raid rebuild performance regression
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        Larkin Lowrey <llowrey@nuclearwinter.com>,
        Wilson Jonathan <i400sjon@gmail.com>,
        Roger Heflin <rogerheflin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Mar 11, 2022 at 9:30 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> Hi,
>
> This should fix the reported RAID rebuild regression, while also
> providing better performance for other workloads particularly on
> rotating storage.

Thanks for the fix!

Reviewed-by: Song Liu <songliubraving@fb.com>
