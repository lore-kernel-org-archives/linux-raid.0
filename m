Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 149D6C43334
	for <linux-raid@archiver.kernel.org>; Fri, 10 Jun 2022 09:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243773AbiFJJtY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 10 Jun 2022 05:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244063AbiFJJtW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 10 Jun 2022 05:49:22 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BC73632F
        for <linux-raid@vger.kernel.org>; Fri, 10 Jun 2022 02:49:20 -0700 (PDT)
Subject: Re: [PATCH mdadm v1 14/14] tests: Add broken files for all broken
 tests
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654854558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ijdeAlHPh+IbiAwnb5BykY+VIG9/rtjUiSgFrIT5f0c=;
        b=sreqzit43wjy9D69g54ECS9BtQ0WYzZYH2SRH8kiSZgtc0vEfOnQFXt/ejMRRNHw6w6tmj
        iQvaQiqQWl90NmXMDta2p22I3dP3ZtAeNug3MgyZV2cUUnyEiEJQ7NUkpyigdS7fw3yqG0
        8gaPFQn9V3P0yzzZ4U0Ep7X+PW7qjzA=
To:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        Jes Sorensen <jsorensen@fb.com>
Cc:     Song Liu <song@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>, Xiao Ni <xni@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>, Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
References: <20220609211130.5108-1-logang@deltatee.com>
 <20220609211130.5108-15-logang@deltatee.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <3b32656b-6d87-39df-625e-93bed6871022@linux.dev>
Date:   Fri, 10 Jun 2022 17:49:09 +0800
MIME-Version: 1.0
In-Reply-To: <20220609211130.5108-15-logang@deltatee.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 6/10/22 5:11 AM, Logan Gunthorpe wrote:
> Each broken file contains the rough frequency of brokeness as well
> as a brief explanation of what happens when it breaks. Estimates
> of failure rates are not statistically significant and can vary
> run to run.
>
> This is really just a view from my window. Tests were done on a
> small VM with the default loop devices, not real hardware. We've
> seen different kernel configurations can cause bugs to appear as well
> (ie. different block schedulers). It may also be that different race
> conditions will be seen on machines with different performance
> characteristics.
>
> These annotations were done with the kernel currently in md/md-next:
>
>   facef3b96c5b ("md: Notify sysfs sync_completed in md_reap_sync_thread()")
>
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---
>   tests/01r5integ.broken                     |  7 ++++
>   tests/01raid6integ.broken                  |  7 ++++
>   tests/04r5swap.broken                      |  7 ++++
>   tests/07autoassemble.broken                |  8 ++++
>   tests/07autodetect.broken                  |  5 +++
>   tests/07changelevelintr.broken             |  9 +++++
>   tests/07changelevels.broken                |  9 +++++
>   tests/07reshape5intr.broken                | 45 ++++++++++++++++++++++
>   tests/07revert-grow.broken                 | 31 +++++++++++++++
>   tests/07revert-shrink.broken               |  9 +++++
>   tests/07testreshape5.broken                | 12 ++++++
>   tests/09imsm-assemble.broken               |  6 +++
>   tests/09imsm-create-fail-rebuild.broken    |  5 +++
>   tests/09imsm-overlap.broken                |  7 ++++
>   tests/10ddf-assemble-missing.broken        |  6 +++
>   tests/10ddf-fail-create-race.broken        |  7 ++++
>   tests/10ddf-fail-two-spares.broken         |  5 +++
>   tests/10ddf-incremental-wrong-order.broken |  9 +++++
>   tests/14imsm-r1_2d-grow-r1_3d.broken       |  5 +++
>   tests/14imsm-r1_2d-takeover-r0_2d.broken   |  6 +++
>   tests/18imsm-r10_4d-takeover-r0_2d.broken  |  5 +++
>   tests/18imsm-r1_2d-takeover-r0_1d.broken   |  6 +++
>   tests/19raid6auto-repair.broken            |  5 +++
>   tests/19raid6repair.broken                 |  5 +++
>   24 files changed, 226 insertions(+)
>   create mode 100644 tests/01r5integ.broken
>   create mode 100644 tests/01raid6integ.broken
>   create mode 100644 tests/04r5swap.broken
>   create mode 100644 tests/07autoassemble.broken
>   create mode 100644 tests/07autodetect.broken
>   create mode 100644 tests/07changelevelintr.broken
>   create mode 100644 tests/07changelevels.broken
>   create mode 100644 tests/07reshape5intr.broken
>   create mode 100644 tests/07revert-grow.broken
>   create mode 100644 tests/07revert-shrink.broken
>   create mode 100644 tests/07testreshape5.broken
>   create mode 100644 tests/09imsm-assemble.broken
>   create mode 100644 tests/09imsm-create-fail-rebuild.broken
>   create mode 100644 tests/09imsm-overlap.broken
>   create mode 100644 tests/10ddf-assemble-missing.broken
>   create mode 100644 tests/10ddf-fail-create-race.broken
>   create mode 100644 tests/10ddf-fail-two-spares.broken
>   create mode 100644 tests/10ddf-incremental-wrong-order.broken
>   create mode 100644 tests/14imsm-r1_2d-grow-r1_3d.broken
>   create mode 100644 tests/14imsm-r1_2d-takeover-r0_2d.broken
>   create mode 100644 tests/18imsm-r10_4d-takeover-r0_2d.broken
>   create mode 100644 tests/18imsm-r1_2d-takeover-r0_1d.broken
>   create mode 100644 tests/19raid6auto-repair.broken
>   create mode 100644 tests/19raid6repair.broken

Just to share some results from my  side, with 5.19-rc1 (revert my
problematic patch of course), below tests failed.

/root/mdadm/tests/00raid0...
/root/mdadm/tests/00readonly...
/root/mdadm/tests/02lineargrow...
/root/mdadm/tests/03r0assem...
/root/mdadm/tests/03r5assem-failed...
/root/mdadm/tests/04r0update...
/root/mdadm/tests/04r5swap...
/root/mdadm/tests/04update-metadata...
/root/mdadm/tests/04update-uuid...
/root/mdadm/tests/05r1-bitmapfile...
/root/mdadm/tests/05r1-grow-external...
/root/mdadm/tests/05r1-n3-bitmapfile...
/root/mdadm/tests/05r1-re-add...
/root/mdadm/tests/05r1-re-add-nosuper...
/root/mdadm/tests/05r5-bitmapfile...
/root/mdadm/tests/05r6-bitmapfile...
/root/mdadm/tests/06wrmostly...
/root/mdadm/tests/07autoassemble...
/root/mdadm/tests/07changelevelintr...
/root/mdadm/tests/07changelevels...
/root/mdadm/tests/07layouts...
/root/mdadm/tests/07revert-grow...
/root/mdadm/tests/07revert-shrink...
/root/mdadm/tests/07testreshape5...
/root/mdadm/tests/09imsm-create-fail-rebuild...
/root/mdadm/tests/09imsm-overlap...
/root/mdadm/tests/10ddf-assemble-missing...
/root/mdadm/tests/10ddf-create...
/root/mdadm/tests/10ddf-fail-readd...
/root/mdadm/tests/10ddf-fail-spare...
/root/mdadm/tests/10ddf-fail-stop-readd...
/root/mdadm/tests/10ddf-fail-twice...
/root/mdadm/tests/10ddf-fail-two-spares...
/root/mdadm/tests/10ddf-incremental-wrong-order...
/root/mdadm/tests/19raid6auto-repair...
/root/mdadm/tests/19raid6repair...

05r1-bitmapfile failed which is probably because external bitmaps are only
work on ext2 and ext3, I guess other 05*-bitmapfile failed due to the same
reason.

01r5integ /01raid6integ  can't finish due to some reason.

BTW, thank you for the effort to make md/mdadm better!

Thanks,
Guoqing
