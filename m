Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEB0AC433F5
	for <linux-raid@archiver.kernel.org>; Tue,  8 Feb 2022 07:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347170AbiBHHTO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Feb 2022 02:19:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235671AbiBHHTK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Feb 2022 02:19:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFCBC0401F1
        for <linux-raid@vger.kernel.org>; Mon,  7 Feb 2022 23:19:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97B996163F
        for <linux-raid@vger.kernel.org>; Tue,  8 Feb 2022 07:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095FDC004E1
        for <linux-raid@vger.kernel.org>; Tue,  8 Feb 2022 07:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644304749;
        bh=fLIWDm6u/LMHc7if610lqW8EWzYOuozqoX7YGmcplnc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=edX1Qibj+fVx+KRTsJUklMuSW+/Jj/2P8MIojZRUSxH9BXUpb83+3mGGyDgqCDfh3
         R0qegnUGSpudZFtiXTT+qSV82QtmmpJEzQhzjCu848gQKs+p5kwl1q7eTWDMOZKYqc
         JU265FZyTRp2kPhD/n5TXmPIHBH4ocd+dg6TpKIZnJJ6I572L3PO1eVEOcW1zWs85R
         YTk2ZGQit+RjRn0WzvXh4ElcItefDouYc5ZDOE2q4FKI1DDCA9cbbgTHrqZvldYoqd
         DyaaYfRExGyCQrgyNjjWgV+RdfxfZ5f/3afp55ffubKHcZ37RiYzEZlqF2F7x1y/QP
         ZZ16J3WNsQCoA==
Received: by mail-yb1-f179.google.com with SMTP id p19so759720ybc.6
        for <linux-raid@vger.kernel.org>; Mon, 07 Feb 2022 23:19:08 -0800 (PST)
X-Gm-Message-State: AOAM531Dg12KuaU2yyNHllAeacRKNpMqg/IrN7+fzYnSYdt0CcJg45nc
        bmpfnrs0FxGsATi/dadKNA2xnMXJD5uFvgT2sAE=
X-Google-Smtp-Source: ABdhPJzDFwyHY5PN7fvVTD20YL032hxEprpYAM7B8MYHk12JycHLxh8IHEEuP98aMMaZ/FQe2gerOLzFGU77Wu/897A=
X-Received: by 2002:a0d:ff83:: with SMTP id p125mr3462571ywf.472.1644304748134;
 Mon, 07 Feb 2022 23:19:08 -0800 (PST)
MIME-Version: 1.0
References: <20220127153912.26856-1-mariusz.tkaczyk@linux.intel.com>
In-Reply-To: <20220127153912.26856-1-mariusz.tkaczyk@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 7 Feb 2022 23:18:57 -0800
X-Gmail-Original-Message-ID: <CAPhsuW54_9CTR6sh7mnQ6O77F2HNArLHGWHYsUdbNGy7pXgipQ@mail.gmail.com>
Message-ID: <CAPhsuW54_9CTR6sh7mnQ6O77F2HNArLHGWHYsUdbNGy7pXgipQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] Improve failed arrays handling.
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Jan 27, 2022 at 7:39 AM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> Hi Song,
> I've made changes as discussed in v2[1]. I did manual testing with IMSM
> metadata.
>
> Patch 1:
> - "%pg" propagated and raid0/linear_error refactored as Suggested by Guoqing.
> - missed dm-event, suggested by Guoqing- verified. IMO the behavior is same as
>   before.
>
> Patch 2:
> - Commit id fixed, suggested by Gouqing.
> - Description rework, suggested by Xiao (discussed offline).
> - fail_last_dev handling added (and verified).
> - MD_BROKEN description modified, suggested by Gouqing.
> - Descriptions for raid1_error and raid10_error are added, redundant comments
>   are removed.
>
> Patch3:
> - Error message for failed array changed, suggested by you.
> - MD_BROKEN setter moved to has_failed(), suggested by Gouqing.
> - has_failed() refactored
>
> Other notes:
> I followed kernel-doc style guidelines when editing or adding new descriptions.
> Please let me know if you consider it as unnecessary and messy.
>
> I also noticed potential issue during refactor related to MD_FAILFAST_SUPPORTED,
> please see the flag definition. I'm wondering if fail_last_dev functionality is
> not against failfast. Should I start separate thread for that?
>
> [1] https://lore.kernel.org/linux-raid/CAPhsuW43QfDNGEu72o2_eqDZ5vGq3tbFvdZ-W+dxVqcEhHmJ5w@mail.gmail.com/T/#t
>
> Mariusz Tkaczyk (3):
>   raid0, linear, md: add error_handlers for raid0 and linear
>   md: Set MD_BROKEN for RAID1 and RAID10
>   raid5: introduce MD_BROKEN

With some changes (mostly from feedback), applied to md-next.

Thanks,
Song
