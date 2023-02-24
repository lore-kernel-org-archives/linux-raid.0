Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C59AC6FA8E
	for <linux-raid@archiver.kernel.org>; Fri, 24 Feb 2023 18:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjBXSgj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Feb 2023 13:36:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjBXSgi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Feb 2023 13:36:38 -0500
Received: from resqmta-h1p-028589.sys.comcast.net (resqmta-h1p-028589.sys.comcast.net [IPv6:2001:558:fd02:2446::6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA5A6C51B
        for <linux-raid@vger.kernel.org>; Fri, 24 Feb 2023 10:36:37 -0800 (PST)
Received: from resomta-h1p-027911.sys.comcast.net ([96.102.179.202])
        by resqmta-h1p-028589.sys.comcast.net with ESMTP
        id VbNnpHY5mEHHIVctRpD1Wt; Fri, 24 Feb 2023 18:34:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=comcastmailservice.net; s=20211018a; t=1677263645;
        bh=78so3fKGuj8F6zb7IeKTcDs5CHPtkAK2XUSzVQMT474=;
        h=Received:Received:From:To:Subject:Date:Message-Id:MIME-Version:
         Xfinity-Spam-Result;
        b=h02q92QO7O7gH/4U5NUFejbJ7xzOqQMp06lqKJ+O7kiTt3oY2Wa2Z/2gLhyTKV4i/
         fqOCaE/HoOgGISbHVKifxJjHVFy0TNZXJ9AWKveuM+jCh2Wg2drawaKRcpFEm1n+MI
         GWI5GzaVV9f7KypyNTKhH2Hn2woSAatjeVQoNYnbb4WyzK1qmO/QxkLJqSQKWFY4Kj
         CN2SUg4oSVH6YNDCTGB+Omcl7f/1ytm+OdzwKiPqQyT0jY1if91dOVEnpwsS7fRnrN
         Q03DmCjOHvbv74rqz2Tr8gCxIotIZmd8OFGXIDb8MxhQ7KSCYwy+WvxIV+0sapHen9
         ZCbsK1qN7WeZg==
Received: from jderrick-mobl4.amr.corp.intel.com ([71.205.181.50])
        by resomta-h1p-027911.sys.comcast.net with ESMTPA
        id VcsvpymQMN2puVct0pamhq; Fri, 24 Feb 2023 18:33:44 +0000
X-Xfinity-VAAS: gggruggvucftvghtrhhoucdtuddrgedvhedrudekfedguddtlecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucevohhmtggrshhtqdftvghsihdpqfgfvfdppffquffrtefokffrnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeflohhnrghthhgrnhcuffgvrhhrihgtkhcuoehjohhnrghthhgrnhdruggvrhhrihgtkheslhhinhhugidruggvvheqnecuggftrfgrthhtvghrnhepvddtjeeigfeuleetveduvefhvdejvdfhtdfgheejiedtveeukedtgeettddthedvnecukfhppeejuddrvddthedrudekuddrhedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehhvghlohepjhguvghrrhhitghkqdhmohgslhegrdgrmhhrrdgtohhrphdrihhnthgvlhdrtghomhdpihhnvghtpeejuddrvddthedrudekuddrhedtpdhmrghilhhfrhhomhepjhhonhgrthhhrghnrdguvghrrhhitghksehlihhnuhigrdguvghvpdhnsggprhgtphhtthhopeelpdhrtghpthhtohepshhonhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhrrghiugesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehhrdhrvghinhgulhesthhhvghlohhunhhgvgdrnhgvthdprhgtphhtthhopeignhhisehrvgguhhgrthdrtghomhdprhgtphhtthhopehhtg
 hhsehlshhtrdguvgdprhgtphhtthhopehhtghhsehinhhfrhgruggvrggurdhorhhg
X-Xfinity-VMeta: sc=-100.00;st=legit
From:   Jonathan Derrick <jonathan.derrick@linux.dev>
To:     Song Liu <song@kernel.org>, <linux-raid@vger.kernel.org>
Cc:     Reindl Harald <h.reindl@thelounge.net>, Xiao Ni <xni@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Christoph Hellwig <hch@infradead.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Sushma Kalakota <sushma.kalakota@intel.com>,
        Jon Derrick <jonathan.derrick@linux.dev>
Subject: [PATCH v5 0/3] md/bitmap: Optimal last page size
Date:   Fri, 24 Feb 2023 11:33:20 -0700
Message-Id: <20230224183323.638-1-jonathan.derrick@linux.dev>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Jon Derrick <jonathan.derrick@linux.dev>

Currently the last bitmap page write will size itself down to the logical block
size. This could cause less performance for devices which have atomic write
units larger than the block size, such as many NVMe devices with 4kB write
units and 512B block sizes. There is usually a large amount of space after the
bitmap and using the optimal I/O size could favor speed over size.

This was tested on an Intel/Solidigm P5520 drive with lba format 512B,
optimal I/O size of 4kB, resulting in a > 10x IOPS increase.

See patch 3 log for results.

v4->v5: Initialized rdev (kernel test bot)
v3->v4: Fixed reviewers concerns
v2->v3: Prep patch added and types fixed
Added helpers for optimal I/O sizes

Jon Derrick (3):
  md: Move sb writer loop to its own function
  md: Fix types in sb writer
  md: Use optimal I/O size for last bitmap page

 drivers/md/md-bitmap.c | 143 ++++++++++++++++++++++++-----------------
 1 file changed, 83 insertions(+), 60 deletions(-)

-- 
2.27.0

