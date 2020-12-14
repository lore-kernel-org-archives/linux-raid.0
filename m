Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8F42C2BB40
	for <linux-raid@archiver.kernel.org>; Mon, 14 Dec 2020 17:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EBB821D7F
	for <linux-raid@archiver.kernel.org>; Mon, 14 Dec 2020 17:50:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439016AbgLNRtl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Dec 2020 12:49:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32569 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2439839AbgLNRtd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 14 Dec 2020 12:49:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607968087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=I7Ckpg9ORH87HoCvloaykZ4ZIvN/i9MuLsNlW7R/uGo=;
        b=IXGzyhkvj+4BKTE6zngfeeqpUArhMyOWqsAOiZxapHQ70yEZkJNB6fbH5aa8VnbNrAty+n
        LjeyvCJ12vS2A5Nwck30zOj0QO62JKPDdn80bHs5BXZr9YT7+ETk4g5DwNwj0LwfetriPY
        Rwiqft4ovjhJlNGXRPxsSZ9E41/WD2c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-JchcsMI8PkqcDHaaFDT-wQ-1; Mon, 14 Dec 2020 12:48:03 -0500
X-MC-Unique: JchcsMI8PkqcDHaaFDT-wQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B0C5107ACF7;
        Mon, 14 Dec 2020 17:48:01 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 51AD66267C;
        Mon, 14 Dec 2020 17:47:58 +0000 (UTC)
Date:   Mon, 14 Dec 2020 12:47:57 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org, axboe@kernel.dk,
        song@kernel.org, linux-raid@vger.kernel.org,
        davej@codemonkey.org.uk, gregkh@linuxfoundation.org
Subject: [git pull] 2 reverts for 5.11 to fix v5.10 MD regression
Message-ID: <20201214174757.GC2290@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Linus,

The following changes since commit 2c85ebc57b3e1817b6ce1a6b703928e113a90442:

  Linux 5.10 (2020-12-13 14:41:30 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.11/revert-problem-v5.10-raid-changes

for you to fetch changes up to 0941e3b0653fef1ea68287f6a948c6c68a45c9ba:

  Revert "dm raid: fix discard limits for raid1 and raid10" (2020-12-14 12:12:08 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
A cascade of MD reverts occurred late in the v5.10-rcX cycle due to MD
raid10 discard optimizations having introduced potential for
corruption. Those reverts exposed a dm-raid.c compiler warning that
wasn't ever knowingly introduced. That min_not_zero() type mismatch
warning was thought to be safely fixed simply by changing 'struct
mddev' to use 'unsigned int' rather than int for chunk_sectors members
in that struct. I proposed either using a cast local to dm-raid.c but
thought changing the type to 'unsigned int' more correct. While that
may be, not enough testing was paired with code review associated with
making that change. As such we were left exposed and the result was a
report that with v5.10 btrfs on MD RAID6 failed to mount:
https://lkml.org/lkml/2020/12/14/7

Given that report, it is justified to simply revert these offending
commits. stable@ has already taken steps to revert these for 5.10.1 -
this pull request just makes sure mainline does so too.

----------------------------------------------------------------
Mike Snitzer (2):
      Revert "md: change mddev 'chunk_sectors' from int to unsigned"
      Revert "dm raid: fix discard limits for raid1 and raid10"

 drivers/md/dm-raid.c | 12 +++++-------
 drivers/md/md.h      |  4 ++--
 2 files changed, 7 insertions(+), 9 deletions(-)

