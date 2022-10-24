Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D15A6FA373F
	for <linux-raid@archiver.kernel.org>; Mon, 24 Oct 2022 15:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbiJXPnI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Oct 2022 11:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiJXPmw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Oct 2022 11:42:52 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD00DCAC3
        for <linux-raid@vger.kernel.org>; Mon, 24 Oct 2022 07:34:02 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id f37so17014036lfv.8
        for <linux-raid@vger.kernel.org>; Mon, 24 Oct 2022 07:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=F2IB/YqNsoJ7/85EEnXA3FXFIsmny6HSt9BE0V8b/sw=;
        b=V7D5i0I16TqWw8KBc4e4VaoSyQmMV28RZ1oaFy2dXXdCEftB8b7pO0EpY9QqTPBuoK
         xhJXzNwWEwmB3CeN979zls034wvy5t57Dpc+TB1pKQEt1KM26vQDUsvryp3h9VjcOZ8O
         OpJxxIQLwuehdGMaWhwf0P88Xz+7HQaYZEYL9d1h7MtbvI6nn2U9J1UCEU2H1q2sIfOz
         irqmpu9cQgin4IEngc6Az56YZ5nPAQI89Gp54i7KUKoFVczcsIEzfpqSZyPFMnjlMEW8
         nIStu8ttEIZ8i6Mf9HwomjmTITl8Ruu+E2wBhq6H5VFyoWQUYo+pvTypy5LplEkfWArx
         Yyug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F2IB/YqNsoJ7/85EEnXA3FXFIsmny6HSt9BE0V8b/sw=;
        b=ymXDi7jCirLLw/oK/KPnSfatCV5WZL5HnE26E9TT5lg6RYaWSvpwlQtHfhl2RN6GaX
         Ns2S/30OgB4tIpxs9VOe42hXQZ6LEldqIFUqVJTr8HKtXIpPuKbTn5QuouTcICFhNHoC
         ZMUjXQ9QEoDhthETdZxHATnqSHDJ/G4EVgpkVyv9yVgY01MGKVPOwAjKlpZYt9hBPPeD
         D58qUYHNxFKB65Z2KeyslXYL1374Yvv4kz1att3RzRSC64LiuaI+VkgQqI/nCDwJ854/
         2vCNrb8MCHa0B/UWFQq7hLk53HtAhvBXlZrOyLksFKqAxE26WvFDKOb8vGhrMAHLe4ze
         81Sg==
X-Gm-Message-State: ACrzQf3Emxmb/KvcDgqx9/u45/wnYoC5s9MVkRitcxiE81eWcyXJCbob
        6PzAerH+oBXKpwFqH3vLlEA3f8udOTfRv6Uu+8pwTjN+493ICg==
X-Google-Smtp-Source: AMsMyM5nBFXzvpi018zgtXpXdd+AbtPZS4QNH9xLwYEzI5psUs2D+ItgYIJqnLIOhDlvFny9BiyAv+K8cIV9/Fy5brM=
X-Received: by 2002:a05:6512:108c:b0:4a2:a46d:1a1a with SMTP id
 j12-20020a056512108c00b004a2a46d1a1amr13239812lfg.471.1666621891683; Mon, 24
 Oct 2022 07:31:31 -0700 (PDT)
MIME-Version: 1.0
References: <202210211004.sOqZyVWM-lkp@intel.com>
In-Reply-To: <202210211004.sOqZyVWM-lkp@intel.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Mon, 24 Oct 2022 16:31:20 +0200
Message-ID: <CAMGffEnpQiYm94hJLYFXTOX7DNPrZDUERrz97QENsNuHVa5JEQ@mail.gmail.com>
Subject: Re: [song-md:md-next 6/6] drivers/md/md-bitmap.c:2541:12: warning:
 result of comparison of constant 4294967296 with expression of type 'unsigned
 long' is always false
To:     kernel test robot <lkp@intel.com>, Song Liu <song@kernel.org>
Cc:     Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>,
        llvm@lists.linux.dev, kbuild-all@lists.01.org,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Oct 21, 2022 at 4:21 AM kernel test robot <lkp@intel.com> wrote:
>
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
> head:   c748adfcbe0bd0c760c68d78434a1dfc0344b6b6
> commit: c748adfcbe0bd0c760c68d78434a1dfc0344b6b6 [6/6] md/bitmap: Fix bitmap chunk size overflow issues
> config: i386-randconfig-a004
> compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?id=c748adfcbe0bd0c760c68d78434a1dfc0344b6b6
>         git remote add song-md git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git
>         git fetch --no-tags song-md md-next
>         git checkout c748adfcbe0bd0c760c68d78434a1dfc0344b6b6
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/md/
>
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
> >> drivers/md/md-bitmap.c:2541:12: warning: result of comparison of constant 4294967296 with expression of type 'unsigned long' is always false [-Wtautological-constant-out-of-range-compare]
>            if (csize >= (1ULL << (BITS_PER_BYTE *
>                ~~~~~ ^  ~~~~~~~~~~~~~~~~~~~~~~~~~
>    1 warning generated.
>
Thx for catch it.
This can be fixed by:
diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 44f29cb1fde1..be9f3a768c9f 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2538,7 +2538,7 @@ chunksize_store(struct mddev *mddev, const char
*buf, size_t len)
        if (csize < 512 ||
            !is_power_of_2(csize))
                return -EINVAL;
-       if (csize >= (1ULL << (BITS_PER_BYTE *
+       if (BITS_PER_LONG == 64 && csize >= (1ULL << (BITS_PER_BYTE *

Song, do you want a seperate fix or will you fold it into the patch itself?
>
> vim +2541 drivers/md/md-bitmap.c
>
>   2526
>   2527  static ssize_t
>   2528  chunksize_store(struct mddev *mddev, const char *buf, size_t len)
>   2529  {
>   2530          /* Can only be changed when no bitmap is active */
>   2531          int rv;
>   2532          unsigned long csize;
>   2533          if (mddev->bitmap)
>   2534                  return -EBUSY;
>   2535          rv = kstrtoul(buf, 10, &csize);
>   2536          if (rv)
>   2537                  return rv;
>   2538          if (csize < 512 ||
>   2539              !is_power_of_2(csize))
>   2540                  return -EINVAL;
> > 2541          if (csize >= (1ULL << (BITS_PER_BYTE *
>   2542                  sizeof(((bitmap_super_t *)0)->chunksize))))
>   2543                  return -EOVERFLOW;
>   2544          mddev->bitmap_info.chunksize = csize;
>   2545          return len;
>   2546  }
>   2547
>
> --
> 0-DAY CI Kernel Test Service
> https://01.org/lkp
