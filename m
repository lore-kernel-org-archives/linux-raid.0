Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 353CAC4332F
	for <linux-raid@archiver.kernel.org>; Mon, 17 Oct 2022 10:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiJQKKx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 17 Oct 2022 06:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbiJQKKv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 17 Oct 2022 06:10:51 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA48050719
        for <linux-raid@vger.kernel.org>; Mon, 17 Oct 2022 03:10:50 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id r14so16744838lfm.2
        for <linux-raid@vger.kernel.org>; Mon, 17 Oct 2022 03:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=46OeGIhIX3eVLk2oUyioaBML+udqJSuV7Lpl7w/A6so=;
        b=O/UBwTCHsfeEY/cGv4FpOYFnfXTokc51jFoLKOX/Yzb3Ld5MH8HWwCxka7N5Xe3tZL
         fHMsmuTPV0lz5ff/JdUduZA9YeIYs1mJQPi9KD1yjXjkA88CkA9Pkqq29dxT9n9GPfuR
         VkV4sQdgGtgqANtUx22Qbgdo1YHoy7Xc3FwHvSNIvMo889P+Fkr8CwnVnpkscY9+mIea
         YxLDh+eWD/1Q5TrRuLmA0H6syoAoa9G6N2wUiaSyfLTAaDstfluW22lVfv1/h18iy/qG
         n7Eb4nMeFhhBpeGmvEQpwtYouIbQj6l1mkQqWh2piHgGkFO4LmFO+UPzFk//KE9RSFa2
         3Z0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=46OeGIhIX3eVLk2oUyioaBML+udqJSuV7Lpl7w/A6so=;
        b=B2fg/gDzvVKy/mmeXCYE6rZOXDKGP+anvKvCaSt7bHNYzFGKl1JO29IncS5NhxFXxS
         UI/8mlqWIZ9fWzpTrwNzRSyXPhKP2Na3/ySZKYow58iF/293r34ZMeTh9mWnxBxKMl9H
         OXkbpzJoq4PPaYgkU4YKk+Wcv3Yxob2Q16u3j3ofL3GjuDN1qJoPDsn3mvTfslDKMgS+
         JNCKh9qVhLVYWE1z6WnYUEsBDI24P19bSxejCppK4iQvjV7Y8J1fH/8iJdPqnXWaN8sJ
         eIqFBFkSdI8U9CsXXCyc9lMZWqpdnULGz7+vdVjWrY3wT5zOWEw1x9nd/8TQs5WWPoOh
         KiXw==
X-Gm-Message-State: ACrzQf3/ncbIP9vWxrIfKP9k84DLfT27L1FHQQJfLJV2/KbW9JuS7XrT
        nQULyiTa9hFQtk80Yd9ap63YXN19MumrnYar1YUpQw==
X-Google-Smtp-Source: AMsMyM73F5ITn6LcEKYDVF++1GBPREdyq5163rrlT5r9f3pB4D3msh5qqVqQf+xRjyV/9IONm2aHr0TOOhR95Ux55PI=
X-Received: by 2002:a05:6512:3404:b0:4a2:c77d:9212 with SMTP id
 i4-20020a056512340400b004a2c77d9212mr3809647lfr.489.1666001449196; Mon, 17
 Oct 2022 03:10:49 -0700 (PDT)
MIME-Version: 1.0
References: <20221014122032.47784-1-jinpu.wang@ionos.com> <202210171721.bveCQYrI-lkp@intel.com>
In-Reply-To: <202210171721.bveCQYrI-lkp@intel.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Mon, 17 Oct 2022 12:10:38 +0200
Message-ID: <CAMGffEnqQbGE5npcv9ujkyyLh+LXU1FKhuiiBVK5Q9BiozyQRg@mail.gmail.com>
Subject: Re: [PATCH] md/bitmap: Fix bitmap chunk size overflow issues.
To:     kernel test robot <lkp@intel.com>
Cc:     linux-raid@vger.kernel.org, kbuild-all@lists.01.org,
        song@kernel.org,
        Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Oct 17, 2022 at 11:17 AM kernel test robot <lkp@intel.com> wrote:
>
> Hi Jack,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on song-md/md-next]
> [also build test WARNING on linus/master v6.1-rc1 next-20221017]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Jack-Wang/md-bitmap-Fix-bitmap-chunk-size-overflow-issues/20221017-103245
> base:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
> patch link:    https://lore.kernel.org/r/20221014122032.47784-1-jinpu.wang%40ionos.com
> patch subject: [PATCH] md/bitmap: Fix bitmap chunk size overflow issues.
> config: microblaze-randconfig-r032-20221017
> compiler: microblaze-linux-gcc (GCC) 12.1.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/68927a99dc7197ea076a3b40d876337073f70a58
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Jack-Wang/md-bitmap-Fix-bitmap-chunk-size-overflow-issues/20221017-103245
>         git checkout 68927a99dc7197ea076a3b40d876337073f70a58
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=microblaze SHELL=/bin/bash drivers/md/
>
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>    drivers/md/md-bitmap.c: In function 'chunksize_store':
> >> drivers/md/md-bitmap.c:2538:27: warning: left shift count >= width of type [-Wshift-count-overflow]
>     2538 |         if (csize >= (1UL << (BITS_PER_BYTE *
>          |                           ^~
>
Thanks will fix in v2.
>
> vim +2538 drivers/md/md-bitmap.c
>
>   2523
>   2524  static ssize_t
>   2525  chunksize_store(struct mddev *mddev, const char *buf, size_t len)
>   2526  {
>   2527          /* Can only be changed when no bitmap is active */
>   2528          int rv;
>   2529          unsigned long csize;
>   2530          if (mddev->bitmap)
>   2531                  return -EBUSY;
>   2532          rv = kstrtoul(buf, 10, &csize);
>   2533          if (rv)
>   2534                  return rv;
>   2535          if (csize < 512 ||
>   2536              !is_power_of_2(csize))
>   2537                  return -EINVAL;
> > 2538          if (csize >= (1UL << (BITS_PER_BYTE *
>   2539                  sizeof(((bitmap_super_t *)0)->chunksize))))
>   2540                  return -EOVERFLOW;
>   2541          mddev->bitmap_info.chunksize = csize;
>   2542          return len;
>   2543  }
>   2544
>
> --
> 0-DAY CI Kernel Test Service
> https://01.org/lkp
