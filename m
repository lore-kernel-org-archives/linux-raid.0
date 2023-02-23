Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BFF1C61DA4
	for <linux-raid@archiver.kernel.org>; Thu, 23 Feb 2023 19:53:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjBWTxL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Feb 2023 14:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBWTxJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Feb 2023 14:53:09 -0500
Received: from resqmta-c1p-023462.sys.comcast.net (resqmta-c1p-023462.sys.comcast.net [IPv6:2001:558:fd00:56::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754491A4A6
        for <linux-raid@vger.kernel.org>; Thu, 23 Feb 2023 11:53:08 -0800 (PST)
Received: from resomta-c1p-023265.sys.comcast.net ([96.102.18.226])
        by resqmta-c1p-023462.sys.comcast.net with ESMTP
        id VB4NpOR26tHQ1VHeNpKz5E; Thu, 23 Feb 2023 19:53:07 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=comcastmailservice.net; s=20211018a; t=1677181987;
        bh=/KtCWZMEnb8H9/lPIWUEVFepLUvNEjoX6IxfE6FFsDw=;
        h=Received:Received:From:To:Subject:Date:Message-Id:MIME-Version:
         Xfinity-Spam-Result;
        b=Gr3M5wOWWWbz8jDWFnT4fVxt/LiC34j0bUvgEN6oZAzXEExEdPH+qkJrE0b3tNx1b
         vfKyGZyFEWLLFnrs6/oPMsPg9VoBgnFB3dOuDsQY/SgL1f1Ru9Bmst6JNYVP9G4kwI
         YmxvThMxGUhm2HvjGgGNMvfdDv6qt7m/iei4vHerpsTuhkQGL0BQQa7+RF+nWsVBRO
         +Z85P0tzHz/Fr5z72XadVwq6yIH4miuLQIgq0BycNgjdvh/S5MkM0A7tvx253b9v6Z
         N/769C/Ic1SHlGRg8iW66G4t6AWeX/x8/H9dyQCkMFUd3QCJ2qA/NXKpXf1q/E+/Ol
         zJWhfoOMAOUmg==
Received: from jderrick-mobl4.amr.corp.intel.com ([71.205.181.50])
        by resomta-c1p-023265.sys.comcast.net with ESMTPA
        id VHdspbaW8XNRJVHdxpbD5p; Thu, 23 Feb 2023 19:52:46 +0000
X-Xfinity-VAAS: gggruggvucftvghtrhhoucdtuddrgedvhedrudekuddguddvjecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucevohhmtggrshhtqdftvghsihdpqfgfvfdppffquffrtefokffrnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeflohhnrghthhgrnhcuffgvrhhrihgtkhcuoehjohhnrghthhgrnhdruggvrhhrihgtkheslhhinhhugidruggvvheqnecuggftrfgrthhtvghrnhepvddtjeeigfeuleetveduvefhvdejvdfhtdfgheejiedtveeukedtgeettddthedvnecukfhppeejuddrvddthedrudekuddrhedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehhvghlohepjhguvghrrhhitghkqdhmohgslhegrdgrmhhrrdgtohhrphdrihhnthgvlhdrtghomhdpihhnvghtpeejuddrvddthedrudekuddrhedtpdhmrghilhhfrhhomhepjhhonhgrthhhrghnrdguvghrrhhitghksehlihhnuhigrdguvghvpdhnsggprhgtphhtthhopeelpdhrtghpthhtohepshhonhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhrrghiugesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehhrdhrvghinhgulhesthhhvghlohhunhhgvgdrnhgvthdprhgtphhtthhopeignhhisehrvgguhhgrthdrtghomhdprhgtphhtthhopehhtg
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
Subject: [PATCH v4 0/3] md/bitmap: Optimal last page size
Date:   Thu, 23 Feb 2023 12:52:22 -0700
Message-Id: <20230223195225.534-1-jonathan.derrick@linux.dev>
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

v3->v4: Fixed reviewers concerns
v2->v3: Prep patch added and types fixed
Added helpers for optimal I/O sizes

Jon Derrick (3):
  md: Move sb writer loop to its own function
  md: Fix types in sb writer
  md: Use optimal I/O size for last bitmap page

 drivers/md/md-bitmap.c | 142 ++++++++++++++++++++++++-----------------
 1 file changed, 82 insertions(+), 60 deletions(-)

-- 
2.27.0

