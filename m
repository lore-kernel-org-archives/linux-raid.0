Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE311C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 17 Nov 2021 07:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DC9C62F90
	for <linux-raid@archiver.kernel.org>; Wed, 17 Nov 2021 07:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbhKQHUc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 Nov 2021 02:20:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:57796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229973AbhKQHUb (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 17 Nov 2021 02:20:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8617261BFB
        for <linux-raid@vger.kernel.org>; Wed, 17 Nov 2021 07:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637133453;
        bh=6rlux3GjOoo8gqHEpQr6T4MSp6j3qNyOcLVXvcWfDaY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VFJp4QpZtt1DQ4qGscEHUscsp1arczJ92iWviMPzDWCtdCbKl2IcmjTbopR19P7u5
         TCr+dPUwNnviZxP/sjWGO+Cwa34sU4f+m4BTfEILupcdofjVuKCJNhlRP4Kws6JSqD
         YYXw10GOn2liLlUwRR4lRJBvbKQSvQNWfxGdMjy/kdtglxCCki38GRgCvm+6x2wGyb
         tT+4DHAuZ8bDlxomM3tTRxxkSUwDLWlwlxAJrdq8Z+Mxd7jVlCRSu1udPAD+bKyHJ2
         Qqy/ZSNKA1SRwBLOF39LArL7K6VYcF1E2Y7hHVbFl0Ako+cMwv3ZHIzKRAgG6nV0Nt
         8oAmrc92PZxSw==
Received: by mail-yb1-f174.google.com with SMTP id e136so4679738ybc.4
        for <linux-raid@vger.kernel.org>; Tue, 16 Nov 2021 23:17:33 -0800 (PST)
X-Gm-Message-State: AOAM5323urkX7kKeJUMmJcEUXNVPHxlD5Fvy+6F2xcYYA6JVSAG9zapl
        snJPuj5rIW22BPIChH8HYvW6g8Qwc/1sD8E2b3Q=
X-Google-Smtp-Source: ABdhPJyRLxdhRjd+T318qt4a2q6F9zcR66wDDTll0fZOJhRFMiMVqUGN8MY4OaCXXHzZEpRThRpgjYSERzQZd+dxV2A=
X-Received: by 2002:a25:8882:: with SMTP id d2mr14990327ybl.68.1637133452763;
 Tue, 16 Nov 2021 23:17:32 -0800 (PST)
MIME-Version: 1.0
References: <20211116102134.1738347-1-markus@hochholdinger.net>
In-Reply-To: <20211116102134.1738347-1-markus@hochholdinger.net>
From:   Song Liu <song@kernel.org>
Date:   Tue, 16 Nov 2021 23:17:21 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4zBGnKAV_TWaZ78NVEhOUw61xYYKda1c33YB=JtAfChA@mail.gmail.com>
Message-ID: <CAPhsuW4zBGnKAV_TWaZ78NVEhOUw61xYYKda1c33YB=JtAfChA@mail.gmail.com>
Subject: Re: [PATCH v2] md: fix update super 1.0 on rdev size change
To:     Markus Hochholdinger <markus@hochholdinger.net>
Cc:     linux-raid <linux-raid@vger.kernel.org>, Xiao Ni <xni@redhat.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Nov 16, 2021 at 2:22 AM Markus Hochholdinger
<markus@hochholdinger.net> wrote:
>
> The superblock of version 1.0 doesn't get moved to the new position on a
> device size change. This leads to a rdev without a superblock on a known
> position, the raid can't be re-assembled.
>
> The line was removed by mistake and is re-added by this patch.
>
> Fixes: d9c0fa509eaf ("md: fix max sectors calculation for super 1.0")
>
> Signed-off-by: Markus Hochholdinger <markus@hochholdinger.net>
> Reviewd-by: Xiao Ni <xni@redhat.com>

Applied to md-fixes. Thanks!

This version still has some minor issues. I fixed them before applying. For
future patches, please run ./scripts/checkpatch.pl on the .patch file.

Song
