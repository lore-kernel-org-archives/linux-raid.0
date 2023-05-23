Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5DF0C7EE26
	for <linux-raid@archiver.kernel.org>; Tue, 23 May 2023 18:36:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237952AbjEWSgN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 23 May 2023 14:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235384AbjEWSgH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 23 May 2023 14:36:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9632120
        for <linux-raid@vger.kernel.org>; Tue, 23 May 2023 11:36:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7396562DA4
        for <linux-raid@vger.kernel.org>; Tue, 23 May 2023 18:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A9DC4339E
        for <linux-raid@vger.kernel.org>; Tue, 23 May 2023 18:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684866962;
        bh=U7NjGne/yRQxzowV+AzT1KR1wAm5ZIeHfrNFXUStrM0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cXV3/3ulx3HInGvcq8qbvr5ayClxeFCwycXVYPq0iou2dKhFNRWjfSnDCLzRM8g9m
         F10BdZaU+6rxFUy7JpHeXI6X3QuOrIMYdeomZnkHBavO16UsK5z/bExmK1Ke8eXU/z
         mhtObf+ALjOrisZ5nx3C2Xg6du++8hoWMONK1TXTg76l0UJy0HQI8Y+f3ZfZWJ0CYI
         rt2uLV45ErwNvMMT8+XSpijqthjVoKiXCJb8JFIejm4OCQp7ukhheTlZ7djvlLmno+
         AIm2QberSGGNyfwxM/zeb6zysLa05Rm91kbegD80LlxjL45t1ZBaQB3bc5gvM7mw/1
         3S24pGIMDeWwg==
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-4f3b337e842so184940e87.3
        for <linux-raid@vger.kernel.org>; Tue, 23 May 2023 11:36:02 -0700 (PDT)
X-Gm-Message-State: AC+VfDxVCZdWg8U65SxqR47IESEEi4hr8EVAIK//qrGax/5LCuID6ZQL
        znl+Q8ejIUWWeAWHov54uanZsxxqV2B8wSgiq38=
X-Google-Smtp-Source: ACHHUZ5HVOSj1+YOWYmyJCLLN7KNDufBEMxkgWnbtO6gqdzyNzJbM5Khmu2VV3rAv9wKhEqZhxABDqgbneqTgQYbZr8=
X-Received: by 2002:ac2:5323:0:b0:4f4:b3a6:4135 with SMTP id
 f3-20020ac25323000000b004f4b3a64135mr1837539lfh.55.1684866960704; Tue, 23 May
 2023 11:36:00 -0700 (PDT)
MIME-Version: 1.0
References: <202305191808.4xsaLKSZ-lkp@intel.com> <5e8a5f4f-e71c-97a4-6ace-974753a1a528@linux.dev>
In-Reply-To: <5e8a5f4f-e71c-97a4-6ace-974753a1a528@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Tue, 23 May 2023 11:35:47 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6aAZK5gAtSpLOTdoNhJDBpY24vvp13kkp=yQ_cADauXw@mail.gmail.com>
Message-ID: <CAPhsuW6aAZK5gAtSpLOTdoNhJDBpY24vvp13kkp=yQ_cADauXw@mail.gmail.com>
Subject: Re: [song-md:module_alloc_test 5/6] arch/powerpc/kernel/module.c:108:8:
 error: unused variable 'ptr'
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     kernel test robot <lkp@intel.com>, llvm@lists.linux.dev,
        oe-kbuild-all@lists.linux.dev, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, May 19, 2023 at 4:05=E2=80=AFAM Guoqing Jiang <guoqing.jiang@linux.=
dev> wrote:
>
>
>
> On 5/19/23 18:41, kernel test robot wrote:
> > Hi Song,
> >
> > FYI, the error/warning was bisected to this commit, please ignore it if=
 it's irrelevant.
> >
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git modul=
e_alloc_test
>
> Could you only post test results for md-next/md-fixes branches to raid
> list? Since this is
> obvious irrelevant to the list.

Created https://github.com/intel/lkp-tests/pull/303 to silent these reports=
.

Sorry for the noise.

Thank,
Song
