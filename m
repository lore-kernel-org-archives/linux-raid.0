Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A0EEB64D8
	for <linux-raid@archiver.kernel.org>; Thu, 15 Jun 2023 01:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238493AbjFOBrg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Jun 2023 21:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237790AbjFOBrf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Jun 2023 21:47:35 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4792EDF
        for <linux-raid@vger.kernel.org>; Wed, 14 Jun 2023 18:47:33 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QhQCN1KH1z4f3kht
        for <linux-raid@vger.kernel.org>; Thu, 15 Jun 2023 09:47:28 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgBnHbGsbYpkuYDsLg--.36696S3;
        Thu, 15 Jun 2023 09:47:25 +0800 (CST)
Subject: Re: [song-md:md-next 25/29] drivers/md/raid1-10.c:117:25: error:
 casting from randomized structure pointer type 'struct block_device *' to
 'struct md_rdev *'
To:     kernel test robot <lkp@intel.com>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <202306142042.fmjfmTF8-lkp@intel.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <dd0d4b24-a149-6796-90c6-b41e569d7902@huaweicloud.com>
Date:   Thu, 15 Jun 2023 09:47:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <202306142042.fmjfmTF8-lkp@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgBnHbGsbYpkuYDsLg--.36696S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCr1xCFyxGrW5Kw4DJFykuFg_yoW5Zr1Dpa
        yUKayUG3y8XrW8GayDW3yUW3W5tws5J343Ca4rG347Aw45ZFWUtF97Kry3WFyDCr1DKrWU
        ZFs7K3ykK34DtFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
        6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUrR6zUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

ÔÚ 2023/06/14 20:32, kernel test robot Ð´µÀ:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
> head:   460af1f9d9e62acce4a21f9bd00b5bcd5963bcd4
> commit: 8295efbe68c080047e98d9c0eb5cb933b238a8cb [25/29] md/raid1-10: factor out a helper to submit normal write
> config: arm-randconfig-r026-20230612 (https://download.01.org/0day-ci/archive/20230614/202306142042.fmjfmTF8-lkp@intel.com/config)
> compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
> reproduce (this is a W=1 build):
>          mkdir -p ~/bin
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # install arm cross compiling tool for clang build
>          # apt-get install binutils-arm-linux-gnueabi
>          # https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?id=8295efbe68c080047e98d9c0eb5cb933b238a8cb
>          git remote add song-md git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git
>          git fetch --no-tags song-md md-next
>          git checkout 8295efbe68c080047e98d9c0eb5cb933b238a8cb
>          # save the config file
>          mkdir build_dir && cp config build_dir/.config
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=arm olddefconfig
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash drivers/
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202306142042.fmjfmTF8-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>     In file included from drivers/md/raid10.c:80:
>>> drivers/md/raid1-10.c:117:25: error: casting from randomized structure pointer type 'struct block_device *' to 'struct md_rdev *'
>       117 |         struct md_rdev *rdev = (struct md_rdev *)bio->bi_bdev;

I didn't hit this warning with W=1 in my local machine, so I guess this
might related to compiler. I'm using gcc (GCC) 12.2.1 and here is clang
version 17.0.0.

I'm planning to get rid of all these weird usage, which is used a lot in
raid, to borrow a field to store something else temporarily, but this
might take sometime.

Can someone help to confirm following change can prevent this warning?

struct md_rdev *rdev = (void *)bio->bi_bdev

Thanks,
Kuai

>           |                                ^
>     1 error generated.
> 
> 
> vim +117 drivers/md/raid1-10.c
> 
>     113	
>     114	
>     115	static inline void raid1_submit_write(struct bio *bio)
>     116	{
>   > 117		struct md_rdev *rdev = (struct md_rdev *)bio->bi_bdev;
>     118	
>     119		bio->bi_next = NULL;
>     120		bio_set_dev(bio, rdev->bdev);
>     121		if (test_bit(Faulty, &rdev->flags))
>     122			bio_io_error(bio);
>     123		else if (unlikely(bio_op(bio) ==  REQ_OP_DISCARD &&
>     124				  !bdev_max_discard_sectors(bio->bi_bdev)))
>     125			/* Just ignore it */
>     126			bio_endio(bio);
>     127		else
>     128			submit_bio_noacct(bio);
>     129	}
>     130	
> 

