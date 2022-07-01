Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E65F4C43334
	for <linux-raid@archiver.kernel.org>; Fri,  1 Jul 2022 16:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbiGAQZp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Jul 2022 12:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbiGAQZo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Jul 2022 12:25:44 -0400
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178E3403FB
        for <linux-raid@vger.kernel.org>; Fri,  1 Jul 2022 09:25:44 -0700 (PDT)
Received: by mail-qt1-f173.google.com with SMTP id g14so778556qto.9
        for <linux-raid@vger.kernel.org>; Fri, 01 Jul 2022 09:25:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=CqLS9/VnMCYBuMzbL3e0tU8Vk7oa/JV3t+gC5Xn/h/k=;
        b=3rpJ1KVQCUixSH6cIL6z1DH+bPcsY1AAy0E1841RYDzYv+zkZHZmYBXNMi7thM2JLM
         TI30NlKWmmoNRV6Dz0XH9S0OJtB7SZwuNvQruvGrwaa0RGINT7oloYkB6boIuxtUhqHE
         lAVEhwrlIkse4Q5BsjXXIZVsy/Om346EZtWCPSyS+UKhIJz4pBdwRvVmbNXeBCUA0Goc
         8jKJ8zNDbVKZnlOR3yzoofLVBQwP6MfyZp2cyNHDIrWWGztODWmk+BGCO1Zo9ks3U+2Y
         npDSvL8sCCKxL4o2utE01D5N3JK+IJrDqSvgWpjJ+UeT6IOshJwr0TnKxitYUgqGGk1A
         TfBw==
X-Gm-Message-State: AJIora/3moWDW5ABEMJ/tGlb954Bb93xZ/jG+NE9SXIsR3Ma2vrjwIU6
        wvXVkohUPaLVMZ7zbwFPPeGi
X-Google-Smtp-Source: AGRyM1tzR5+oekiebA2Cl4ZcA8vDGKaik3m8+xoET3D9HB7EA7KAOUlWMkJMC/Ms3M1Oy/CjZO9H4Q==
X-Received: by 2002:ac8:570f:0:b0:31d:3692:36e0 with SMTP id 15-20020ac8570f000000b0031d369236e0mr4051034qtw.343.1656692743249;
        Fri, 01 Jul 2022 09:25:43 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id k201-20020a37a1d2000000b006a716fed4d6sm17007710qke.50.2022.07.01.09.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 09:25:42 -0700 (PDT)
Date:   Fri, 1 Jul 2022 12:25:41 -0400
From:   Mike Snitzer <snitzer@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: [git pull] device mapper fixes for 5.19-rc5
Message-ID: <Yr8gBVNDik5el/n/@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Linus,

The following changes since commit 90736eb3232d208ee048493f371075e4272e0944:

  dm mirror log: clear log bits up to BITS_PER_LONG boundary (2022-06-23 14:55:43 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.19/dm-fixes-5

for you to fetch changes up to 617b365872a247480e9dcd50a32c8d1806b21861:

  dm raid: fix KASAN warning in raid5_add_disks (2022-06-29 19:48:04 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- 3 fixes for invalid memory accesses discovered by using KASAN while
  running the lvm2 testsuite's dm-raid tests. Includes changes to MD's
  raid5.c given the dependency dm-raid has on the MD code.

----------------------------------------------------------------
Heinz Mauelshagen (1):
      dm raid: fix accesses beyond end of raid member array

Mikulas Patocka (2):
      dm raid: fix KASAN warning in raid5_remove_disk
      dm raid: fix KASAN warning in raid5_add_disks

 drivers/md/dm-raid.c | 34 ++++++++++++++++++----------------
 drivers/md/raid5.c   |  6 +++++-
 2 files changed, 23 insertions(+), 17 deletions(-)
