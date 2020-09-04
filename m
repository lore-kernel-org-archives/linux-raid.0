Return-Path: <SRS0=BPCQ=CN=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D31C43461
	for <linux-raid@archiver.kernel.org>; Fri,  4 Sep 2020 03:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10423206D4
	for <linux-raid@archiver.kernel.org>; Fri,  4 Sep 2020 03:23:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I2VdhWBp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729762AbgIDDX0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Sep 2020 23:23:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59342 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729691AbgIDDXY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Sep 2020 23:23:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599189797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lCCsJDjh5HIbl8kgBSySkiDIfTw0TBim+PMdOfCxwQM=;
        b=I2VdhWBpMBKchz7Npols7Q6kYKb3wB2jhkDMsjzM0nHBpAHrNLxZv0JjMDKiDu7HLxN/k3
        LJeqjz3HnNyT+kKWpO9Vpx60wHZjBKBhH0HhNOipYOirj3PAdh8Lz70kXSEfvV+PMNKz4g
        kx2bUOG8/o4giFKqF4WlodkpqY2Cg5c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-2FcFfNjQNjWMpulrTZOS-Q-1; Thu, 03 Sep 2020 23:23:00 -0400
X-MC-Unique: 2FcFfNjQNjWMpulrTZOS-Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1CDD41DDE1;
        Fri,  4 Sep 2020 03:22:59 +0000 (UTC)
Received: from T590 (ovpn-12-109.pek2.redhat.com [10.72.12.109])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D2B56196FD;
        Fri,  4 Sep 2020 03:22:48 +0000 (UTC)
Date:   Fri, 4 Sep 2020 11:22:44 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Veronika Kabatova <vkabatov@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        linux-block@vger.kernel.org, Changhui Zhong <czhong@redhat.com>,
        Rachel Sibley <rasibley@redhat.com>,
        Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Subject: Re: =?utf-8?B?8J+SpSBQQU5JQ0tFRA==?= =?utf-8?Q?=3A?= Test report for
 kernel 5.9.0-rc3-020ad03.cki (block)
Message-ID: <20200904032244.GA808936@T590>
References: <cki.538AE6A321.BMB0X5ZYG5@redhat.com>
 <0f92c40e-b234-896c-0810-af36ee95e259@redhat.com>
 <18db2772-3f37-55a7-d92e-dbcbe92d2cc4@kernel.dk>
 <ad1bf306-6f23-9b7c-842f-766a6efbda3e@redhat.com>
 <1300213431.10047993.1599163090152.JavaMail.zimbra@redhat.com>
 <cc956f4c-9b71-2b02-80be-dd387316dad8@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cc956f4c-9b71-2b02-80be-dd387316dad8@kernel.dk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Sep 03, 2020 at 02:53:39PM -0600, Jens Axboe wrote:
> On 9/3/20 1:58 PM, Veronika Kabatova wrote:
> > 
> > 
> > ----- Original Message -----
> >> From: "Rachel Sibley" <rasibley@redhat.com>
> >> To: "Jens Axboe" <axboe@kernel.dk>, "CKI Project" <cki-project@redhat.com>, linux-block@vger.kernel.org
> >> Cc: "Changhui Zhong" <czhong@redhat.com>
> >> Sent: Thursday, September 3, 2020 8:59:48 PM
> >> Subject: Re: 💥 PANICKED: Test report for kernel 5.9.0-rc3-020ad03.cki (block)
> >>
> >>
> >>
> >> On 9/3/20 1:46 PM, Jens Axboe wrote:
> >>> On 9/3/20 11:10 AM, Rachel Sibley wrote:
> >>>>
> >>>> On 9/3/20 1:07 PM, CKI Project wrote:
> >>>>>
> >>>>> Hello,
> >>>>>
> >>>>> We ran automated tests on a recent commit from this kernel tree:
> >>>>>
> >>>>>          Kernel repo:
> >>>>>          https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
> >>>>>               Commit: 020ad0333b03 - Merge branch 'for-5.10/block' into
> >>>>>               for-next
> >>>>>
> >>>>> The results of these automated tests are provided below.
> >>>>>
> >>>>>       Overall result: FAILED (see details below)
> >>>>>                Merge: OK
> >>>>>              Compile: OK
> >>>>>                Tests: PANICKED
> >>>>>
> >>>>> All kernel binaries, config files, and logs are available for download
> >>>>> here:
> >>>>>
> >>>>>     https://cki-artifacts.s3.us-east-2.amazonaws.com/index.html?prefix=datawarehouse/2020/09/02/613166
> >>>>>
> >>>>> One or more kernel tests failed:
> >>>>>
> >>>>>       ppc64le:
> >>>>>        💥 storage: software RAID testing
> >>>>>
> >>>>>       aarch64:
> >>>>>        💥 storage: software RAID testing
> >>>>>
> >>>>>       x86_64:
> >>>>>        💥 storage: software RAID testing
> >>>>
> >>>> Hello,
> >>>>
> >>>> We're seeing a panic for all non s390x arches triggered by swraid test.
> >>>> Seems to be reproducible
> >>>> for all succeeding pipelines after this one, and we haven't yet seen it in
> >>>> mainline or yesterday's
> >>>> block tree results.
> >>>>
> >>>> Thank you,
> >>>> Rachel
> >>>>
> >>>> https://cki-artifacts.s3.us-east-2.amazonaws.com/datawarehouse/2020/09/02/613166/build_aarch64_redhat%3A968098/tests/8757835_aarch64_3_console.log
> >>>>
> >>>> [ 8394.609219] Internal error: Oops: 96000004 [#1] SMP
> >>>> [ 8394.614070] Modules linked in: raid0 loop raid456 async_raid6_recov
> >>>> async_memcpy async_pq async_xor async_tx dm_log_writes dm_flakey
> >>>> rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache
> >>>> rfkill sunrpc vfat fat xgene_hwmon xgene_enet at803x mdio_xgene xgene_rng
> >>>> xgene_edac mailbox_xgene_slimpro drm ip_tables xfs sdhci_of_arasan
> >>>> sdhci_pltfm i2c_xgene_slimpro crct10dif_ce sdhci gpio_dwapb cqhci
> >>>> xhci_plat_hcd
> >>>> gpio_xgene_sb gpio_keys aes_neon_bs
> >>>> [ 8394.654298] CPU: 3 PID: 471427 Comm: kworker/3:2 Kdump: loaded Not
> >>>> tainted 5.9.0-rc3-020ad03.cki #1
> >>>> [ 8394.663299] Hardware name: AppliedMicro X-Gene Mustang Board/X-Gene
> >>>> Mustang Board, BIOS 3.06.25 Oct 17 2016
> >>>> [ 8394.672999] Workqueue: md_misc mddev_delayed_delete
> >>>> [ 8394.677853] pstate: 40400085 (nZcv daIf +PAN -UAO BTYPE=--)
> >>>> [ 8394.683399] pc : percpu_ref_exit+0x5c/0xc8
> >>>> [ 8394.687473] lr : percpu_ref_exit+0x20/0xc8
> >>>> [ 8394.691547] sp : ffff800019f33d00
> >>>> [ 8394.694843] x29: ffff800019f33d00 x28: 0000000000000000
> >>>> [ 8394.700129] x27: ffff0003c63ae000 x26: ffff8000120b6228
> >>>> [ 8394.705414] x25: 0000000000000001 x24: ffff0003d8322a80
> >>>> [ 8394.710698] x23: 0000000000000000 x22: 0000000000000000
> >>>> [ 8394.715983] x21: 0000000000000000 x20: ffff8000121d2000
> >>>> [ 8394.721266] x19: ffff0003d8322af0 x18: 0000000000000000
> >>>> [ 8394.726550] x17: 0000000000000000 x16: 0000000000000000
> >>>> [ 8394.731834] x15: 0000000000000007 x14: 0000000000000003
> >>>> [ 8394.737119] x13: 0000000000000000 x12: ffff0003888a1978
> >>>> [ 8394.742403] x11: ffff0003888a1918 x10: 0000000000000001
> >>>> [ 8394.747688] x9 : 0000000000000000 x8 : 0000000000000000
> >>>> [ 8394.752972] x7 : 0000000000000400 x6 : 0000000000000001
> >>>> [ 8394.758257] x5 : ffff800010423030 x4 : ffff8000121d2e40
> >>>> [ 8394.763540] x3 : 0000000000000000 x2 : 0000000000000000
> >>>> [ 8394.768825] x1 : 0000000000000000 x0 : 0000000000000000
> >>>> [ 8394.774110] Call trace:
> >>>> [ 8394.776544]  percpu_ref_exit+0x5c/0xc8
> >>>> [ 8394.780273]  md_free+0x64/0xa0
> >>>> [ 8394.783311]  kobject_put+0x7c/0x218
> >>>> [ 8394.786781]  mddev_delayed_delete+0x3c/0x50
> >>>> [ 8394.790944]  process_one_work+0x1c4/0x450
> >>>> [ 8394.794932]  worker_thread+0x164/0x4a8
> >>>> [ 8394.798662]  kthread+0xf4/0x120
> >>>> [ 8394.801787]  ret_from_fork+0x10/0x18
> >>>> [ 8394.805344] Code: 2a0403e0 350002c0 a9400262 52800001 (f9400000)
> >>>> [ 8394.811407] ---[ end trace 481cab6e1ad73da1 ]---
> >>>
> >>> Ming, I wonder if this is:
> >>>
> >>> commit d0c567d60f3730b97050347ea806e1ee06445c78
> >>> Author: Ming Lei <ming.lei@redhat.com>
> >>> Date:   Wed Sep 2 20:26:42 2020 +0800
> >>>
> >>>      percpu_ref: reduce memory footprint of percpu_ref in fast path
> >>>
> >>> Rachel, any chance you can do a run with that commit reverted?
> >>
> >> Hi Jens, yes we're working on it and will share our findings as soon as the
> >> job finishes.
> >>
> > 
> > Hi Jens, we can confirm that there are no panics and the test passes
> > with the patch reverted.
> > 
> > 
> > We also realized that this patch is a likely cause of serious problems
> > on ppc64le during LTP testing as well, specifically msgstress04. Both
> > issues started occurring at the same time, we just didn't notice as the
> > test was crashing.
> > 
> > 
> > [ 5682.999169] msgstress04 invoked oom-killer: gfp_mask=0x40cc0(GFP_KERNEL|__GFP_COMP), order=0, oom_score_adj=0 
> > [ 5682.999981] CPU: 1 PID: 170909 Comm: msgstress04 Kdump: loaded Not tainted 5.9.0-rc3-020ad03.cki #1 
> > [ 5683.000048] Call Trace: 
> > [ 5683.000098] [c00000023de972e0] [c000000000927e00] dump_stack+0xc4/0x114 (unreliable) 
> > [ 5683.000161] [c00000023de97330] [c000000000386958] dump_header+0x64/0x274 
> > [ 5683.000205] [c00000023de973c0] [c000000000385534] oom_kill_process+0x284/0x290 
> > [ 5683.000259] [c00000023de97400] [c0000000003862b0] out_of_memory+0x220/0x790 
> > [ 5683.000307] [c00000023de974a0] [c000000000408890] __alloc_pages_slowpath.constprop.0+0xd60/0xeb0 
> > [ 5683.000370] [c00000023de97670] [c000000000408d20] __alloc_pages_nodemask+0x340/0x400 
> > [ 5683.000426] [c00000023de97700] [c000000000434dec] alloc_pages_current+0xac/0x130 
> > [ 5683.000479] [c00000023de97750] [c000000000442fc4] allocate_slab+0x584/0x810 
> > [ 5683.000525] [c00000023de977c0] [c000000000447e7c] ___slab_alloc+0x44c/0xa30 
> > [ 5683.000571] [c00000023de978b0] [c000000000448494] __slab_alloc+0x34/0x60 
> > [ 5683.000615] [c00000023de978e0] [c000000000448b48] kmem_cache_alloc+0x688/0x700 
> > [ 5683.000671] [c00000023de97940] [c0000000003d9c80] __pud_alloc+0x70/0x1e0 
> > [ 5683.000717] [c00000023de97990] [c0000000003ddbb4] copy_page_range+0x1204/0x1490 
> > [ 5683.000779] [c00000023de97b20] [c00000000013b7c0] dup_mm+0x370/0x6e0 
> > [ 5683.000826] [c00000023de97bd0] [c00000000013ce10] copy_process+0xd20/0x1950 
> > [ 5683.000870] [c00000023de97c90] [c00000000013dc64] _do_fork+0xa4/0x560 
> > [ 5683.000915] [c00000023de97d00] [c00000000013e24c] __do_sys_clone+0x7c/0xa0 
> > [ 5683.000965] [c00000023de97dc0] [c00000000002f9a4] system_call_exception+0xe4/0x1c0 
> > [ 5683.001019] [c00000023de97e20] [c00000000000d140] system_call_common+0xf0/0x27c 
> > 
> > The test then manages the fill the console log with good 4G of dump...
> > this is actually visible in the ppc64le console log from the linked
> > artifacts (warnings, it's a huge file!):
> > 
> > https://cki-artifacts.s3.us-east-2.amazonaws.com/datawarehouse/2020/09/02/613166/build_ppc64le_redhat%3A968099/tests/8757368_ppc64le_3_console.log
> > 
> > 
> > There are also more ppc64le traces in the other log (of reasonable size):
> > https://cki-artifacts.s3.us-east-2.amazonaws.com/datawarehouse/2020/09/02/613166/build_ppc64le_redhat%3A968099/tests/8757337_ppc64le_2_console.log
> 
> I'll revert this change for now.

It is one MD's bug, and percpu_ref_exit() may be called on one ref not
initialized via percpu_ref_init(), and the following patch can fix the
issue:

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 607278207023..9c55489066d2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5599,7 +5599,9 @@ static void md_free(struct kobject *ko)
                blk_cleanup_queue(mddev->queue);
        if (mddev->gendisk)
                put_disk(mddev->gendisk);
-       percpu_ref_exit(&mddev->writes_pending);
+
+       if (mddev->writes_pending.percpu_count_ptr)
+               percpu_ref_exit(&mddev->writes_pending);

        bioset_exit(&mddev->bio_set);
        bioset_exit(&mddev->sync_set);


Thanks,
Ming

