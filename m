Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F3C7C433F5
	for <linux-raid@archiver.kernel.org>; Wed,  2 Feb 2022 16:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346066AbiBBQ53 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 2 Feb 2022 11:57:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346049AbiBBQ52 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 2 Feb 2022 11:57:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDB1C061714
        for <linux-raid@vger.kernel.org>; Wed,  2 Feb 2022 08:57:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1908BB83105
        for <linux-raid@vger.kernel.org>; Wed,  2 Feb 2022 16:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6205C340ED
        for <linux-raid@vger.kernel.org>; Wed,  2 Feb 2022 16:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643821045;
        bh=5CFcrzdYXPDlO261p5M0lS03Pdl+o0akNhOZbfeYy0g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QQ9qCC4H7CrGVl3tWXBhLfFwx+zwh649HsbNvk1DFCEWWV2KAhiESJ2ZX6lN6rSkV
         a9CNx8enAkMXtGJqbkwQFZyvsWHyOsWMUfVznrcwdUnvySh3l+vRk3c+I0kvw1y/8t
         vlPITCfqwHk17GvlDQovruMiRaKqlERmY++vjTNsINimXOBWmAU45aSnYh3jlgknY1
         3t1UrzIR50NQq6C0wWSi/0Bch9Ls+29VwwpyZYHYZi/FfCVkVnpfH36QeP3O3KkBAs
         TWXtPTZ6AZz0GO7PHfrF+d7Anm7QbnlGIvvKj+Z+9yjI1+Mi/e3WYsZR/S/6RgUGQ7
         X1dT1u0uZeABQ==
Received: by mail-yb1-f181.google.com with SMTP id 23so461109ybf.7
        for <linux-raid@vger.kernel.org>; Wed, 02 Feb 2022 08:57:25 -0800 (PST)
X-Gm-Message-State: AOAM532JjQ9jTLDn0TKCQ3HHWo3cLHOU3uHynAevKyIXQ5xgCW95Gvxr
        hPr7xI7GMBBBL0JDmvMcPu4S9/v2Af07crMOT3U=
X-Google-Smtp-Source: ABdhPJxKrrNozQNizaRf2/gGYx+8kdSjTLOcbZKO7NwuqJw/RoNebgapSulPTbCnZrXMnu/MDzzVmWJ18g7vvRNEejI=
X-Received: by 2002:a5b:a03:: with SMTP id k3mr43529036ybq.219.1643821045035;
 Wed, 02 Feb 2022 08:57:25 -0800 (PST)
MIME-Version: 1.0
References: <a673c90f-d9eb-c6d5-b675-e6c2e1c04e5f@totally.rip>
 <CAPhsuW5H1uROu868FhS5MNXuP=nS_=6b8zUrFv4jBjPEA=joPQ@mail.gmail.com> <858fc88b-40fe-5bb4-e9be-e8b5f66ff562@totally.rip>
In-Reply-To: <858fc88b-40fe-5bb4-e9be-e8b5f66ff562@totally.rip>
From:   Song Liu <song@kernel.org>
Date:   Wed, 2 Feb 2022 08:57:13 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5yfv_ahTwuGCNwgGwyFMpzBOSLwpQH=_PB+MH1zVx_fw@mail.gmail.com>
Message-ID: <CAPhsuW5yfv_ahTwuGCNwgGwyFMpzBOSLwpQH=_PB+MH1zVx_fw@mail.gmail.com>
Subject: Re: NULL pointer dereference in blk_queue_flag_set
To:     jkhsjdhjs <jkhsjdhjs@totally.rip>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Feb 2, 2022 at 4:50 AM jkhsjdhjs <jkhsjdhjs@totally.rip> wrote:
>
> Hey Song,
>
> thanks for the quick reply! I applied your patch on top of 5.17-rc2 and
> it fixes the issue:
>
> [   15.394670] device-mapper: raid: Loading target version 1.15.1
> [   15.395216] device-mapper: raid: Ignoring chunk size parameter for RAID 1
> [   15.395224] device-mapper: raid: Choosing default region size of 4MiB
> [   15.399865] md/raid1:mdX: active with 2 out of 2 mirrors
>

That's great. Thanks!

Would you like to attach Reported-by and Tested-by tag to the fix?

Song
