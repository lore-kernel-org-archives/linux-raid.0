Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6AFBFA373F
	for <linux-raid@archiver.kernel.org>; Mon, 24 Oct 2022 19:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbiJXTx5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Oct 2022 15:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233290AbiJXTxL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Oct 2022 15:53:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0180E18E720
        for <linux-raid@vger.kernel.org>; Mon, 24 Oct 2022 11:17:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21FEFB8162A
        for <linux-raid@vger.kernel.org>; Mon, 24 Oct 2022 17:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE92DC43470
        for <linux-raid@vger.kernel.org>; Mon, 24 Oct 2022 17:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666631300;
        bh=w8GS0/IXGpCBIGFmh/uIswIITFQHhCJFbcyulouW26s=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YaahfrujUzOyMhqHPxy+sOLhef/ceV1bhCh7O5OOc1mdC88yQOi1GDrzqx/LgUTaJ
         RYkUVzmN2R6VDFTzsBpTwPhZJrmjDssmlKppAvWkqxPrm/4WbcrrPZ+kX5OkumpJYU
         WgH/qRTOjg7DiJ4hXCCQhzhvHpWJefnkM7gYASNrRcp56fOJZ8+7U97hx92T/raFIF
         qkqAiCsoFwUQieNFnifyB1VPf9gKuNa1/hkbcI/M0AjS6hkm5pnIKRzkykxFoJ1PED
         D9ysYjzrvie4SOBkSnf1KrxdUwjledYHSuALfoLVh94TDmmTKBHnUpUWoVdi+7uFcm
         swdusg354i6+A==
Received: by mail-ej1-f43.google.com with SMTP id k2so6595917ejr.2
        for <linux-raid@vger.kernel.org>; Mon, 24 Oct 2022 10:08:20 -0700 (PDT)
X-Gm-Message-State: ACrzQf14RAXL6yaanzeIh46QXqN0ifdatgzw8steodUSO+aZEAfDErZt
        dFGXQ8BSGnIQFjCYSJ92orYZlUwHC4Ss8zSmRoQ=
X-Google-Smtp-Source: AMsMyM40/vi4ST/iWpZ0r91eWjW2hEKXf6OVws5NWjYVweSYjNn6fW38ap/cIlAKNckYBr/ZhEfPlU5VyhwrEsPyYIs=
X-Received: by 2002:a17:906:58c6:b0:78d:b37f:5ce5 with SMTP id
 e6-20020a17090658c600b0078db37f5ce5mr29132484ejs.707.1666631299016; Mon, 24
 Oct 2022 10:08:19 -0700 (PDT)
MIME-Version: 1.0
References: <202210211004.sOqZyVWM-lkp@intel.com> <CAMGffEnpQiYm94hJLYFXTOX7DNPrZDUERrz97QENsNuHVa5JEQ@mail.gmail.com>
In-Reply-To: <CAMGffEnpQiYm94hJLYFXTOX7DNPrZDUERrz97QENsNuHVa5JEQ@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 24 Oct 2022 10:08:07 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6POWR8-My-jCaVetLV5puAA5rSPSnxGiAffGQmNYU5wg@mail.gmail.com>
Message-ID: <CAPhsuW6POWR8-My-jCaVetLV5puAA5rSPSnxGiAffGQmNYU5wg@mail.gmail.com>
Subject: Re: [song-md:md-next 6/6] drivers/md/md-bitmap.c:2541:12: warning:
 result of comparison of constant 4294967296 with expression of type 'unsigned
 long' is always false
To:     Jinpu Wang <jinpu.wang@ionos.com>
Cc:     kernel test robot <lkp@intel.com>,
        Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>,
        llvm@lists.linux.dev, kbuild-all@lists.01.org,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Oct 24, 2022 at 7:31 AM Jinpu Wang <jinpu.wang@ionos.com> wrote:
>
> On Fri, Oct 21, 2022 at 4:21 AM kernel test robot <lkp@intel.com> wrote:
> >
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
> > head:   c748adfcbe0bd0c760c68d78434a1dfc0344b6b6
> > commit: c748adfcbe0bd0c760c68d78434a1dfc0344b6b6 [6/6] md/bitmap: Fix bitmap chunk size overflow issues
> > config: i386-randconfig-a004
> > compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
> > reproduce (this is a W=1 build):
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?id=c748adfcbe0bd0c760c68d78434a1dfc0344b6b6
> >         git remote add song-md git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git
> >         git fetch --no-tags song-md md-next
> >         git checkout c748adfcbe0bd0c760c68d78434a1dfc0344b6b6
> >         # save the config file
> >         mkdir build_dir && cp config build_dir/.config
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/md/
> >
> > If you fix the issue, kindly add following tag where applicable
> > | Reported-by: kernel test robot <lkp@intel.com>
> >
> > All warnings (new ones prefixed by >>):
> >
> > >> drivers/md/md-bitmap.c:2541:12: warning: result of comparison of constant 4294967296 with expression of type 'unsigned long' is always false [-Wtautological-constant-out-of-range-compare]
> >            if (csize >= (1ULL << (BITS_PER_BYTE *
> >                ~~~~~ ^  ~~~~~~~~~~~~~~~~~~~~~~~~~
> >    1 warning generated.
> >
> Thx for catch it.
> This can be fixed by:
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 44f29cb1fde1..be9f3a768c9f 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -2538,7 +2538,7 @@ chunksize_store(struct mddev *mddev, const char
> *buf, size_t len)
>         if (csize < 512 ||
>             !is_power_of_2(csize))
>                 return -EINVAL;
> -       if (csize >= (1ULL << (BITS_PER_BYTE *
> +       if (BITS_PER_LONG == 64 && csize >= (1ULL << (BITS_PER_BYTE *
>
> Song, do you want a seperate fix or will you fold it into the patch itself?

Please fold this in the patch and resend. I will replace the commit and force
push to md-next.

Thanks,
Song

> >
> > vim +2541 drivers/md/md-bitmap.c
> >
> >   2526
> >   2527  static ssize_t
> >   2528  chunksize_store(struct mddev *mddev, const char *buf, size_t len)
> >   2529  {
> >   2530          /* Can only be changed when no bitmap is active */
> >   2531          int rv;
> >   2532          unsigned long csize;
> >   2533          if (mddev->bitmap)
> >   2534                  return -EBUSY;
> >   2535          rv = kstrtoul(buf, 10, &csize);
> >   2536          if (rv)
> >   2537                  return rv;
> >   2538          if (csize < 512 ||
> >   2539              !is_power_of_2(csize))
> >   2540                  return -EINVAL;
> > > 2541          if (csize >= (1ULL << (BITS_PER_BYTE *
> >   2542                  sizeof(((bitmap_super_t *)0)->chunksize))))
> >   2543                  return -EOVERFLOW;
> >   2544          mddev->bitmap_info.chunksize = csize;
> >   2545          return len;
> >   2546  }
> >   2547
> >
> > --
> > 0-DAY CI Kernel Test Service
> > https://01.org/lkp
