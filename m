Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC33FC433F5
	for <linux-raid@archiver.kernel.org>; Wed, 25 May 2022 18:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237784AbiEYSWe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 25 May 2022 14:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235445AbiEYSWd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 25 May 2022 14:22:33 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA8EB0D22
        for <linux-raid@vger.kernel.org>; Wed, 25 May 2022 11:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=endTWqWnLIsuO2KqBubtzrZ0IX7Tvk0o5yoTMmO282g=; b=VrcgTupoZqcjbBdLzF5XWuo6lc
        2cAwAtsXA9dS294Wpg1ZJ6rvLIhD69e0FULzNAlLIW5GVc7kr+fma5PPIPX/ic16v2ky12lOmB5sf
        KylfhIxH/iIn0K3FJxzhM9ZqN8TdJ0YHqhPNX7MwQu7iEqaU/e8GPPw8AMmXU7FECuB3PRy2hSb15
        jxOQyz4s+WSywP6YHL6hfcN/5sUBFs7i+Pv9aW+JeuI5d7/9iQ6mihaPuGx4IhC7xukniwxI6VV2S
        e3JuYfLtCnDZfe8YxzTo+K1PA3dLKDLPhOtcQMj0oeys3yVcsmHokZL5Ds9mFjpuFxXdjGJR9rINz
        NwlP2syg==;
Received: from s0106ac1f6bb1ecac.cg.shawcable.net ([70.73.163.230] helo=[192.168.11.155])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1ntve6-007Lm3-Es; Wed, 25 May 2022 12:22:11 -0600
Message-ID: <ae6d294a-e9ec-a81d-6085-a9341ed8a470@deltatee.com>
Date:   Wed, 25 May 2022 12:22:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Song Liu <song@kernel.org>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>,
        Paolo Valente <paolo.valente@linaro.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <20220505081641.21500-1-guoqing.jiang@linux.dev>
 <20220506113656.25010-1-guoqing.jiang@linux.dev>
 <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
 <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev>
 <CAPhsuW6U3g-Xikbw4mAJOH1-kN42rYHLiq_ocv==436azhm33g@mail.gmail.com>
 <b4244eab-d9e2-20a0-ebce-1a96e8fadb91@deltatee.com>
 <836b2a93-65be-8d6c-8610-18373b88f86d@molgen.mpg.de>
 <5b0584a3-c128-cb53-7c8a-63744c60c667@linux.dev>
 <4edc9468-d195-6937-f550-211bccbd6756@molgen.mpg.de>
 <954f9c33-7801-b6d2-65e3-9e5237905886@linux.dev>
 <82a08e9c-e3f4-4eb6-cb06-58b96c0f01a8@deltatee.com>
 <775d6734-2b08-21a8-a093-f750d31ce6ce@linux.dev>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <775d6734-2b08-21a8-a093-f750d31ce6ce@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 70.73.163.230
X-SA-Exim-Rcpt-To: guoqing.jiang@linux.dev, buczek@molgen.mpg.de, song@kernel.org, jack@suse.cz, axboe@kernel.dk, paolo.valente@linaro.org, linux-raid@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-05-25 03:04, Guoqing Jiang wrote:
> I would prefer to focus on block tree or md tree. With latest block tree
> (commit 44d8538d7e7dbee7246acda3b706c8134d15b9cb), I get below
> similar issue as Donald reported, it happened with the cmd (which did
> work with 5.12 kernel).
> 
> vm79:~/mdadm> sudo ./test --dev=loop --tests=05r1-add-internalbitmap

Ok, so this test passes for me, but my VM was not running with bfq. It
also seems we have layers upon layers of different bugs to untangle.
Perhaps you can try the tests with bfq disabled to make progress on the
other regression I reported.

If I enable bfq and set the loop devices to the bfq scheduler, then I
hit the same bug as you and Donald. It's clearly a NULL pointer
de-reference in the bfq code, which seems to be triggered on the
partition read after mdadm opens a block device (not sure if it's the md
device or the loop device but I suspect the latter seeing it's not going
through any md code).

Simplifying things down a bit, the null pointer dereference can be
triggered by creating an md device with loop devices that have bfq
scheduler set:

  mdadm --create --run /dev/md0 --level=1 -n2 /dev/loop0 /dev/loop1

The crash occurs in bfq_bio_bfqg() with blkg_to_bfqg() returning NULL.
It's hard to trace where the NULL comes from in there -- the code is a
bit complex.

I've found that the bfq bug exists in current md-next (42b805af102) but
did not trigger in the base tag of v5.18-rc3. Bisecting revealed the bug
was introduced by:

  4e54a2493e58 ("bfq: Get rid of __bio_blkcg() usage")

Reverting that commit and the next commit (075a53b7) on top of md-next
was confirmed to fix the bug.

I've copied Jan, Jens and Paolo who can hopefully help with this. A
cleaned up stack trace follows this email for their benefit.

Logan

--

 BUG: KASAN: null-ptr-deref in bfq_bio_bfqg+0x65/0xf0
 Read of size 1 at addr 0000000000000094 by task mdadm/850

 CPU: 1 PID: 850 Comm: mdadm Not tainted
5.18.0-rc3-eid-vmlocalyes-dbg-00005-g42b805af1024 #2113
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2
04/01/2014
 Call Trace:
  <TASK>
  dump_stack_lvl+0x5a/0x74
  kasan_report.cold+0x5f/0x1a9
  __asan_load1+0x4d/0x50
  bfq_bio_bfqg+0x65/0xf0
  bfq_bic_update_cgroup+0x2f/0x340
  bfq_insert_requests+0x568/0x5800
  blk_mq_sched_insert_request+0x180/0x230
  blk_mq_submit_bio+0x9f0/0xe50
  __submit_bio+0xeb/0x100
  submit_bio_noacct_nocheck+0x1fd/0x470
  submit_bio_noacct+0x350/0xa80
  submit_bio+0x84/0xf0
  submit_bh_wbc+0x27a/0x2b0
  block_read_full_page+0x578/0xb60
  blkdev_readpage+0x18/0x20
  do_read_cache_folio+0x290/0x430
  read_cache_page+0x41/0x130
  read_part_sector+0x7a/0x3d0
  read_lba+0x161/0x340
  efi_partition+0x1ce/0xdd0
  bdev_disk_changed+0x2e9/0x6a0
  blkdev_get_whole+0xd5/0x140
  blkdev_get_by_dev.part.0+0x37f/0x570
  blkdev_get_by_dev+0x51/0x60
  blkdev_open+0xa4/0x140
  do_dentry_open+0x2a7/0x6d0
  vfs_open+0x58/0x60
  path_openat+0x77e/0x13f0
  do_filp_open+0x154/0x280
  do_sys_openat2+0x119/0x2c0
  __x64_sys_openat+0xe7/0x160
  do_syscall_64+0x3b/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae

--

bfq_bio_bfqg+0x65/0xf0:

bfq_bio_bfqg at block/bfq-cgroup.c:619
 614 		struct blkcg_gq *blkg = bio->bi_blkg;
 615 		struct bfq_group *bfqg;
 616 	
 617 		while (blkg) {
 618 			bfqg = blkg_to_bfqg(blkg);
>619<			if (bfqg->online) {
 620 				bio_associate_blkg_from_css(bio,
 621 				return bfqg;
 622 			}
 623 			blkg = blkg->parent;
 624 		
