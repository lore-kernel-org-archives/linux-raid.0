Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1899EC433F5
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 16:00:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01D78610FE
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 16:00:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237416AbhJMQCp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Oct 2021 12:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234305AbhJMQCo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 13 Oct 2021 12:02:44 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F56C061570;
        Wed, 13 Oct 2021 09:00:41 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id q125so2631593qkd.12;
        Wed, 13 Oct 2021 09:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PWSeITlyIwPGelI0V+moIuPw2pVju3g7zFiPEO8iBxw=;
        b=pOBLi2/cwkQLHnJAKwrneqMPGLTseUAj6979DPjQ7ORH5nR4WWmKbVLlxwrN9cvX81
         tnU8dOqXHJ6KwLOCalIKradis3Ifeif1SwFvUl0Bhn4mDsj//2jLi8Y3uEYsN/BAy7nb
         Q9GKKjZnYldS461mSy+qmF/fncFgKrognmcuNbLpzPGeD3P6hgkS1C7mDwLfxghH38nd
         BGT85EfdeG3e2bUUFAD8RcPNdJzfK8dBw48qMz8wrS7YdZUIj1smNrTLXVGS55CQGanj
         ixWlehYeEZOsAA4r7gWL8JEXpZE7jz7DZu4OfzGLqgdAjcSEWbGAhLgymQmekSuBZonB
         LN+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PWSeITlyIwPGelI0V+moIuPw2pVju3g7zFiPEO8iBxw=;
        b=J8bxUHyQWFl4Nmw74EYcD1pRWRF+7isN1OnmOEuX0uezOhrEnshRjjrfDWw4BqNkQt
         XRRSWf1jLj2j8kIg4khWXx4/5Xe+R21aFhyU5txr56z3OsDc8PvRtrpT/QSkIW/gzd8T
         tHK4q2eFV61blFe3Kc/mE+4kUNe3X+zSGkgdyX5Zq1b8KQDKd0W6sNTr0StH06tmd80a
         UjQFB7ulZviONKXNDDsgb5IcevF3zqvfExTeJkzHzq9pLemDnQb1O8nsVmpnHl7VQwKD
         UWOa47XptbXOVgSnJzMPolqMc4YgEeUVxrd2tkfunSBMAAmTQzB4q+GGPIutgE88kug9
         5A6A==
X-Gm-Message-State: AOAM530+eiykJnaENN84Z9jkPeuRUj80WtqMJmzEAMLkGPmVYgzLoSBh
        J2HSCOGUcaW9ebiwJ5UL9r8JKHXjTl0t
X-Google-Smtp-Source: ABdhPJzVxXvW8X5yxMKkxpU63Pm0AHS+P+SeJFolARaAZT7lqUMUx3bBzB5Zj1T0f8kO2njZIjDzfQ==
X-Received: by 2002:a05:620a:6b7:: with SMTP id i23mr43656qkh.241.1634140840310;
        Wed, 13 Oct 2021 09:00:40 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id w17sm20161qts.53.2021.10.13.09.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 09:00:39 -0700 (PDT)
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, axboe@kernel.dk
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        alexander.h.duyck@linux.intel.com
Subject: [PATCH 0/5] Minor mm/struct page work
Date:   Wed, 13 Oct 2021 12:00:29 -0400
Message-Id: <20211013160034.3472923-1-kent.overstreet@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Some small buddy allocator/struct page patches

The first two patches are small buddy allocator cleanups - they were supposed to
be prep work patches to replacing buddy allocator freelists with radix trees,
but I'm not sure if that's actually going to be feasible due to highmem - but
the patches are still improvements so I wanted to send them out.

The third, to mm/page_reporting, also came about because that code walks buddy
allocator freelists but is a much more significant cleanup. I have no idea how
to test page reporting though so it's only Correct By Obviousness, so hopefully
Alexander can help us out with that.

The last two patches are important for the struct page cleanups currently
underway. We have a lot of code using page->index and page->mapping in ad-hoc
ways, and this is a real problem given our goal of cutting struct page up into
different types that each have a well defined purpose - and it turns out that a
lot of that code is using those fields for very minor conveniences. We still
need a lot more cleanups like this, I've only done two of the easier ones.

Kent Overstreet (5):
  mm: Make free_area->nr_free per migratetype
  mm: Introduce struct page_free_list
  mm/page_reporting: Improve control flow
  md: Kill usage of page->index
  brd: Kill usage of page->index

 drivers/block/brd.c    |   4 --
 drivers/md/md-bitmap.c |  44 ++++++------
 include/linux/mmzone.h |  22 ++++--
 kernel/crash_core.c    |   4 +-
 mm/compaction.c        |  20 +++---
 mm/page_alloc.c        |  50 +++++++------
 mm/page_reporting.c    | 158 +++++++++++++++--------------------------
 mm/vmstat.c            |  28 +-------
 8 files changed, 138 insertions(+), 192 deletions(-)

-- 
2.33.0

