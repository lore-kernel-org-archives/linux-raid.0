Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD4F2C433FE
	for <linux-raid@archiver.kernel.org>; Wed,  9 Nov 2022 22:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbiKIWiU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Nov 2022 17:38:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbiKIWhz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Nov 2022 17:37:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3105817A97
        for <linux-raid@vger.kernel.org>; Wed,  9 Nov 2022 14:37:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9C7A61CE8
        for <linux-raid@vger.kernel.org>; Wed,  9 Nov 2022 22:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB75C433C1
        for <linux-raid@vger.kernel.org>; Wed,  9 Nov 2022 22:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668033434;
        bh=O81Z+GAocD21ZbMo9EytBWxhqvzGghvNI+EUWp2d1wQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BnrmAu8QEipEQ9V8tFEFwkJZxFhb3FDNWW/5pbEHu5TbfxqQtNUtz4neaB1CnHibV
         PAvtRIC81HPBrqIMpcJ5Hyx3lGlxKxnCmuavnpPlVaDiOERn/IWbQOxU4GAmOOT7b5
         +wbLvxb7mVuX+K3sfHm5mNg4e+AGkbtVwW95dNMOM4Ar7TmQEWULwgmlbKBJzQB+XS
         e3KjwMd5WtAVBuLKs6xIBQaO4vRyqYI2W2jHCuboSIE4DYxq4f6AM3uQJHOvWptclG
         VsW3upMDcPTntwSx7cVCrCQ56mOYhop6+l23sXsPZwOT+IkLHB2tvoA1XORjqlybTt
         MB/e3qD9mEvug==
Received: by mail-ej1-f42.google.com with SMTP id q9so741071ejd.0
        for <linux-raid@vger.kernel.org>; Wed, 09 Nov 2022 14:37:14 -0800 (PST)
X-Gm-Message-State: ANoB5pkSVARbdK9PlBx6DE2Of8bOfz6/pwZKuXILsc2rVc64hq8ChhA2
        y4BqoBUQpsNkMVwGcCK492BHpuGpVWVnhDjkHxI=
X-Google-Smtp-Source: AA0mqf6esjcJrISpyyYlKEl5DY/VjaM3owux4lIaML4lxbbOrRGX8zEQhUATFRN5Fnpw+I4z+ld142mNIX6x71HWy8c=
X-Received: by 2002:a17:907:2995:b0:7ae:8956:ab56 with SMTP id
 eu21-20020a170907299500b007ae8956ab56mr4494937ejc.719.1668033432283; Wed, 09
 Nov 2022 14:37:12 -0800 (PST)
MIME-Version: 1.0
References: <CAP4dvsc725oZMso+=gmWSoGRLN9m3Q8D1zhHuz=Q+qfGqTdXCw@mail.gmail.com>
In-Reply-To: <CAP4dvsc725oZMso+=gmWSoGRLN9m3Q8D1zhHuz=Q+qfGqTdXCw@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 9 Nov 2022 14:37:00 -0800
X-Gmail-Original-Message-ID: <CAPhsuW74_B1iZjnaqqTaV5xWjdrwLgF6K3LP6w_b09x1iVccEA@mail.gmail.com>
Message-ID: <CAPhsuW74_B1iZjnaqqTaV5xWjdrwLgF6K3LP6w_b09x1iVccEA@mail.gmail.com>
Subject: Re: raid5 deadlock issue
To:     Zhang Tianci <zhangtianci.1997@bytedance.com>
Cc:     linux-raid@vger.kernel.org,
        Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

 Hi Tianci,

Thanks for the report.


On Tue, Nov 8, 2022 at 10:50 PM Zhang Tianci
<zhangtianci.1997@bytedance.com> wrote:
>
> Hi Song,
>
> I am tracking down a deadlock in Linux-5.4.56.
>
[...]
>
> $ cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md10 : active raid5 nvme9n1p1[9] nvme8n1p1[7] nvme7n1p1[6]
> nvme6n1p1[5] nvme5n1p1[4] nvme4n1p1[3] nvme3n1p1[2] nvme2n1p1[1]
> nvme1n1p1[0]
>       15001927680 blocks super 1.2 level 5, 512k chunk, algorithm 2
> [9/9] [UUUUUUUUU]
>       [====>................]  check = 21.0% (394239024/1875240960)
> finish=1059475.2min speed=23K/sec
>       bitmap: 1/14 pages [4KB], 65536KB chunk

How many instances of this issue do we have? If more than one, I wonder
they are all running the raid5 check (as this one is).

>
> $ mdadm -D /dev/md10
> /dev/md10:
>         Version : 1.2
>   Creation Time : Fri Sep 23 11:47:03 2022
>      Raid Level : raid5
>      Array Size : 15001927680 (14306.95 GiB 15361.97 GB)
>   Used Dev Size : 1875240960 (1788.37 GiB 1920.25 GB)
>    Raid Devices : 9
>   Total Devices : 9
>     Persistence : Superblock is persistent
>
>   Intent Bitmap : Internal
>
>     Update Time : Sun Nov  6 01:29:49 2022
>           State : active, checking
>  Active Devices : 9
> Working Devices : 9
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Check Status : 21% complete
>
>            Name : dc02-pd-t8-n021:10  (local to host dc02-pd-t8-n021)
>            UUID : 089300e1:45b54872:31a11457:a41ad66a
>          Events : 3968
>
>     Number   Major   Minor   RaidDevice State
>        0     259        8        0      active sync   /dev/nvme1n1p1
>        1     259        6        1      active sync   /dev/nvme2n1p1
>        2     259        7        2      active sync   /dev/nvme3n1p1
>        3     259       12        3      active sync   /dev/nvme4n1p1
>        4     259       11        4      active sync   /dev/nvme5n1p1
>        5     259       14        5      active sync   /dev/nvme6n1p1
>        6     259       13        6      active sync   /dev/nvme7n1p1
>        7     259       21        7      active sync   /dev/nvme8n1p1
>        9     259       20        8      active sync   /dev/nvme9n1p1
>
> And some internal state of the raid5 by crash or sysfs:
>
> $ cat /sys/block/md10/md/stripe_cache_active
> 4430               # There are so many active stripe_head
>
> crash > foreach UN bt | grep md_bitmap_startwrite | wc -l
> 48                    # So there are only 48 stripe_head blocked by
> the bitmap counter.
> crash > list -o stripe_head.lru -s stripe_head.state -O
> r5conf.delayed_list -h 0xffff90c1951d5000
> .... # There are so many stripe_head, and the number is 4382.
>
> There are 4430 active stripe_head, and 4382 are in delayed_list, the
> last 48 blocked by the bitmap counter.
> So I guess this is the second deadlock.
>
> Then I reviewed the changelog after the commit 391b5d39faea "md/raid5:
> Fix Force reconstruct-write io stuck in degraded raid5" date
> 2020-07-31, and found no related fixup commit. And I'm not sure my
> understanding of raid5 is right. So I wondering if you can help
> confirm whether my thoughts are right or not.

Have you tried to reproduce this with the latest kernel? There are a few fixes
after 2020, for example

  commit 3312e6c887fe7539f0adb5756ab9020282aaa3d4

Thanks,
Song
