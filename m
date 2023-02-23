Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7DD4C61DA4
	for <linux-raid@archiver.kernel.org>; Thu, 23 Feb 2023 01:27:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjBWB1c (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Feb 2023 20:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjBWB1b (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Feb 2023 20:27:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8463866E
        for <linux-raid@vger.kernel.org>; Wed, 22 Feb 2023 17:27:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18501B818E5
        for <linux-raid@vger.kernel.org>; Thu, 23 Feb 2023 01:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25C6C4339B
        for <linux-raid@vger.kernel.org>; Thu, 23 Feb 2023 01:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677115647;
        bh=c1fPwmnCrcbDARuajdKYz1g/MEmU8WK+5Fql45Z7Rk8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Eyi8dYx5tnqRlUaWSR0sV7jF7+cLCMSxhlpSknrBvOHfBQmxAhy0NpMbynmoCGGZm
         kke+fE6m+rWy9eU5CwP7MO8LOR5gUgwlUDteUgvmecwR5GTFpwPpZ5AgQKcYTPnNCX
         iLaKkhhkOf9LyP8JPEivPkstgvkHVCwRc3OoR7yR/+oKTcyRJhkCUtMC7Nk2mTCLke
         AB+XQ5pK3pBoL5WoOTgNkNhQEhKqYGVxtaACkwO5fLqTVuxobq9cIB2smHqKZNXx7D
         J29YVuUYhh5lRvcgW5XHuM2W0SYoA+z90t6H3AMI4PLgIgmVUAfs0XpkeZewJnBQhg
         hCDHQ97wd09TA==
Received: by mail-lj1-f181.google.com with SMTP id h9so9630201ljq.2
        for <linux-raid@vger.kernel.org>; Wed, 22 Feb 2023 17:27:27 -0800 (PST)
X-Gm-Message-State: AO0yUKV2J3Qt+6ZZBNAnVzFg738q6kPY9KdfD+iXJxvn/ssQub6epbic
        IBplgT0ir10XHT0cOl0Hr9QmsbpMUPXfzr8aC9k=
X-Google-Smtp-Source: AK7set9V15OHlLAWoP31nW+g9VtWLWoM3QXEDudWyiOZ8FQnZmqcU0V2OCuRB6mbMjoRrIEBHsBCEXaEALAlJSXHMso=
X-Received: by 2002:a2e:a4ba:0:b0:295:9a96:a5fd with SMTP id
 g26-20020a2ea4ba000000b002959a96a5fdmr977234ljm.5.1677115645707; Wed, 22 Feb
 2023 17:27:25 -0800 (PST)
MIME-Version: 1.0
References: <20230222035916.83647-1-xni@redhat.com>
In-Reply-To: <20230222035916.83647-1-xni@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 22 Feb 2023 17:27:11 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4isHd6jY5wrEChRFeXYviwOPPR=J52HBp4MD=F3J2zzQ@mail.gmail.com>
Message-ID: <CAPhsuW4isHd6jY5wrEChRFeXYviwOPPR=J52HBp4MD=F3J2zzQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] md: Free resources in __md_stop
To:     Xiao Ni <xni@redhat.com>
Cc:     yukuai1@huaweicloud.com, linux-raid@vger.kernel.org,
        yi.zhang@huawei.com, yangerkun@huawei.com, heinzm@redhat.com,
        ncroxon@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Feb 21, 2023 at 7:59 PM Xiao Ni <xni@redhat.com> wrote:
>
> If md_run() fails after ->active_io is initialized, then percpu_ref_exit
> is called in error path. However, later md_free_disk will call
> percpu_ref_exit again which leads to a panic because of null pointer
> dereference. It can also trigger this bug when resources are initialized
> but are freed in error path, then will be freed again in md_free_disk.
>
> BUG: kernel NULL pointer dereference, address: 0000000000000038
> Oops: 0000 [#1] PREEMPT SMP
> Workqueue: md_misc mddev_delayed_delete
> RIP: 0010:free_percpu+0x110/0x630
> Call Trace:
>  <TASK>
>  __percpu_ref_exit+0x44/0x70
>  percpu_ref_exit+0x16/0x90
>  md_free_disk+0x2f/0x80
>  disk_release+0x101/0x180
>  device_release+0x84/0x110
>  kobject_put+0x12a/0x380
>  kobject_put+0x160/0x380
>  mddev_delayed_delete+0x19/0x30
>  process_one_work+0x269/0x680
>  worker_thread+0x266/0x640
>  kthread+0x151/0x1b0
>  ret_from_fork+0x1f/0x30
>
> For creating raid device, md raid calls do_md_run->md_run, dm raid calls
> md_run. We alloc those memory in md_run. For stopping raid device, md raid
> calls do_md_stop->__md_stop, dm raid calls md_stop->__md_stop. So we can
> free those memory resources in __md_stop.
>
> Fixes: 72adae23a72c ("md: Change active_io to percpu")
> Reported-and-tested-by: Yu Kuai <yukuai3@huawei.com>
> Signed-off-by: Xiao Ni <xni@redhat.com>

Applied to md-fixes. Thanks!

Song
