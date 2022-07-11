Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB83FC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 11 Jul 2022 03:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiGKDeY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 10 Jul 2022 23:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGKDeY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 10 Jul 2022 23:34:24 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829F862CC;
        Sun, 10 Jul 2022 20:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=P7YzCVqNHhOLgeVqVrx43f24ZBviyuF5w7w7XSB/y4c=; b=ptpsIiQMXr5ztcVclTxUxY+rFU
        mwu8xox2f+LrvI2HQguRaOxdLccsdHDEtvvDhBx2v2aoXRElvMEHs+MP4SNnmn7T9OHAoRXLeUNIC
        ZZZF4ml2NYx4JzXLI3nTFpYXRsyVayL3tvavnqg/qHuoBGgN9timfaYILpBzEbVga4rWtCB0YYD3j
        9SWGBf5b/9xFVA7qy8w0HDYOvfIB1+gNM4lWofFHBx6uGm0khTDSGO4WdawDxnHJzIl8G/LWvErRv
        Hoc1HcJ5CNbzubx3frVTjztLoRWjENGLbSb/qwPcKKH5P3Foij1de4EXF5he2adeh0LWnMUhIOfri
        qOOtM1aQ==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oAkBI-00BhAY-LM; Sun, 10 Jul 2022 21:33:58 -0600
Message-ID: <55940f1e-bd93-e167-2580-35880ab1e702@deltatee.com>
Date:   Sun, 10 Jul 2022 21:33:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-CA
To:     Christoph Hellwig <hch@lst.de>
Cc:     axboe@kernel.dk, shinichiro.kawasaki@wdc.com,
        dan.j.williams@intel.com, yukuai3@huawei.com, ming.lei@redhat.com,
        linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>
References: <20220614074827.458955-1-hch@lst.de>
 <20220614074827.458955-5-hch@lst.de>
 <72a5bf2e-cd56-a85c-2b99-cb8729a66fed@deltatee.com>
 <20220708060126.GA16457@lst.de>
 <c43e40da-7549-0c81-2a3c-d837b59f7e76@deltatee.com>
 <20220709081745.GA26411@lst.de>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20220709081745.GA26411@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: hch@lst.de, axboe@kernel.dk, shinichiro.kawasaki@wdc.com, dan.j.williams@intel.com, yukuai3@huawei.com, ming.lei@redhat.com, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: REGRESSION: [PATCH 4/4] block: freeze the queue earlier in
 del_gendisk
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org




On 2022-07-09 02:17, Christoph Hellwig wrote:
> On Fri, Jul 08, 2022 at 09:55:55AM -0600, Logan Gunthorpe wrote:
>> I agree it's a mess, probably buggy and could use a cleanup with a
>> free_disk method. But I'm not sure the all_mdevs lifetime issues are the
>> problem here. If the entry in all_mdevs outlasts the disk, then
>> md_alloc() will just fail earlier. Many test scripts rely on the fact
>> that you can stop an mddev and recreate it immediately after. We need
>> some way of ensuring any deleted disks are fully deleted before trying
>> to make a new mddev, in case the new one has the same name as one being
>> deleted.
> 
> I think those tests are broken.  But fortunately that is just an
> assumption in the tests, while device name reuse is a real problem.
> 
> I could not reproduce your problem, but on the for-5.20/block
> tree I see a hang in 10ddf-geometry when running the tests.

Ah, strange. I never saw an issue with that test, though I didn't run
that one repeatedly with the latest branch. So maybe it was an
intermittent like I saw with 11spare-migration and I just missed it.

> The branch here:
> 
>     git://git.infradead.org/users/hch/block.git md-lifetime-fixes
>     http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/md-lifetime-fixes
> 
> fixes that for me and does not introduce new regressions.  Can you
> check if that helps your problem?

Yes, I can confirm those patches fix the bug I was seeing too.


I did a fairly quick review of the patches:

 - In the patch that introduces md_free_disk() it looks like md_free()
can still be called from the error path of md_alloc() before
mddev->gendisk is set... which seems to make things rather complicated
seeing we then can't use free_disk to finish the cleanup if the disk
hasn't been created yet. I probably need to take closer look at this
but, it might make more sense for the cleanup to remain in md_free() but
call kobject_put() in md_free_disk() and del_gendisk() in
mdev_delayed_delete(). Then md_alloc() can still use kobject_put() in
the error path and it makes a little more sense seeing we'd still be
freeing the kobject stuff in it's own release method instead of the
disks free method.

 - In the patch with md_rdevs_overlap, it looks like we remove the
rcu_read_lock(), which definitely seems out of place and probably isn't
correct. But the comment that was recreated still references the rcu so
probably should be changed.

 - The last patch has a typo in the title (disk is *a* freed).

Thanks!

Logan
