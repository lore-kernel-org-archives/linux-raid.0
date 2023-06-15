Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F420EEB64D9
	for <linux-raid@archiver.kernel.org>; Thu, 15 Jun 2023 15:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbjFOPl3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 15 Jun 2023 11:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbjFOPl2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 15 Jun 2023 11:41:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A85F18D
        for <linux-raid@vger.kernel.org>; Thu, 15 Jun 2023 08:41:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F7B9621AA
        for <linux-raid@vger.kernel.org>; Thu, 15 Jun 2023 15:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830B2C433C8;
        Thu, 15 Jun 2023 15:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686843686;
        bh=q+fviFTWnM7ClsGX6apcWowNa53cnN1O72GvNjKUj0Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SKfb1f/w9pZO+h+1XLESWFDO2CoIXYaH2Lndd1KRL97/gOrvism9Bmc11aklQSxEi
         An/2qknfAU9opeiNg3ImVtB0EkjfCx3A7qrGMk8Z2mTaTfx/vWkx8Gag35CFBbWpb3
         EbKdUOHV16f+qV588pDcCYFlogCQNQWLJPhsCrr1uK2dIc0ojkAssqt7DfeLRYT6X4
         MPcL5pfJ/0om02PTH8oXR5nZxLFrpy++/40PvwpFf2oAVFcAMf7fZPm0B/nO5pJjKR
         hOBUcXtHuMqwMfltRw69f2wj7XhWH3mpI+4okIUy9GqwrtvZYLMRSaTURMF/TqjGIH
         /DC7TVaZaqH1Q==
Date:   Thu, 15 Jun 2023 08:41:23 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     kernel test robot <lkp@intel.com>, llvm@lists.linux.dev,
        oe-kbuild-all@lists.linux.dev, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>, "yukuai (C)" <yukuai3@huawei.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [song-md:md-next 25/29] drivers/md/raid1-10.c:117:25: error:
 casting from randomized structure pointer type 'struct block_device *' to
 'struct md_rdev *'
Message-ID: <20230615154123.GA3665766@dev-arch.thelio-3990X>
References: <202306142042.fmjfmTF8-lkp@intel.com>
 <dd0d4b24-a149-6796-90c6-b41e569d7902@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dd0d4b24-a149-6796-90c6-b41e569d7902@huaweicloud.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Jun 15, 2023 at 09:47:24AM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2023/06/14 20:32, kernel test robot 写道:
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
> > head:   460af1f9d9e62acce4a21f9bd00b5bcd5963bcd4
> > commit: 8295efbe68c080047e98d9c0eb5cb933b238a8cb [25/29] md/raid1-10: factor out a helper to submit normal write
> > config: arm-randconfig-r026-20230612 (https://download.01.org/0day-ci/archive/20230614/202306142042.fmjfmTF8-lkp@intel.com/config)
> > compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
> > reproduce (this is a W=1 build):
> >          mkdir -p ~/bin
> >          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >          chmod +x ~/bin/make.cross
> >          # install arm cross compiling tool for clang build
> >          # apt-get install binutils-arm-linux-gnueabi
> >          # https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?id=8295efbe68c080047e98d9c0eb5cb933b238a8cb
> >          git remote add song-md git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git
> >          git fetch --no-tags song-md md-next
> >          git checkout 8295efbe68c080047e98d9c0eb5cb933b238a8cb
> >          # save the config file
> >          mkdir build_dir && cp config build_dir/.config
> >          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=arm olddefconfig
> >          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash drivers/
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202306142042.fmjfmTF8-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> >     In file included from drivers/md/raid10.c:80:
> > > > drivers/md/raid1-10.c:117:25: error: casting from randomized structure pointer type 'struct block_device *' to 'struct md_rdev *'
> >       117 |         struct md_rdev *rdev = (struct md_rdev *)bio->bi_bdev;
> 
> I didn't hit this warning with W=1 in my local machine, so I guess this
> might related to compiler. I'm using gcc (GCC) 12.2.1 and here is clang
> version 17.0.0.

Interesting, I would have expected the GCC plugin to have the same
behavior as clang (which has randstruct in the compiler proper) and
error when casting randomized structures but I just tested with
aarch64-linux-gnu-gcc (GCC) 13.1.0 and drivers/md/raid10.c builds just
fine, so confirmed.

For the record, this is a hard error, not a warning, so the build is
broken in -next because of this:

https://github.com/ClangBuiltLinux/continuous-integration2/actions/runs/5278732212/jobs/9552208141

> I'm planning to get rid of all these weird usage, which is used a lot in
> raid, to borrow a field to store something else temporarily, but this
> might take sometime.
> 
> Can someone help to confirm following change can prevent this warning?
> 
> struct md_rdev *rdev = (void *)bio->bi_bdev

Yes, this fixes the build.

In the future, if you need to reproduce issues with clang, I have
prebuilt versions of stable clang/LLVM available on kernel.org:

https://mirrors.edge.kernel.org/pub/tools/llvm/

Cheers,
Nathan

> >           |                                ^
> >     1 error generated.
> > 
> > 
> > vim +117 drivers/md/raid1-10.c
> > 
> >     113	
> >     114	
> >     115	static inline void raid1_submit_write(struct bio *bio)
> >     116	{
> >   > 117		struct md_rdev *rdev = (struct md_rdev *)bio->bi_bdev;
> >     118	
> >     119		bio->bi_next = NULL;
> >     120		bio_set_dev(bio, rdev->bdev);
> >     121		if (test_bit(Faulty, &rdev->flags))
> >     122			bio_io_error(bio);
> >     123		else if (unlikely(bio_op(bio) ==  REQ_OP_DISCARD &&
> >     124				  !bdev_max_discard_sectors(bio->bi_bdev)))
> >     125			/* Just ignore it */
> >     126			bio_endio(bio);
> >     127		else
> >     128			submit_bio_noacct(bio);
> >     129	}
> >     130	
> > 
> 
> 
