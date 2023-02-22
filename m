Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 469E9C6379F
	for <linux-raid@archiver.kernel.org>; Wed, 22 Feb 2023 22:01:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbjBVWBr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Feb 2023 17:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjBVWBo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Feb 2023 17:01:44 -0500
Received: from resdmta-a1p-077303.sys.comcast.net (resdmta-a1p-077303.sys.comcast.net [IPv6:2001:558:fd01:2bb4::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB01A41B5C
        for <linux-raid@vger.kernel.org>; Wed, 22 Feb 2023 14:01:42 -0800 (PST)
Received: from resomta-a1p-077058.sys.comcast.net ([96.103.145.239])
        by resdmta-a1p-077303.sys.comcast.net with ESMTP
        id UoFCpSICj5N5pUx8opd6Wb; Wed, 22 Feb 2023 21:59:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=comcastmailservice.net; s=20211018a; t=1677103150;
        bh=h+0C5NtDYVf+FIPJ1ybE+IeZyPYfTeODToIYG/ajIrc=;
        h=Received:Received:From:To:Subject:Date:Message-Id:MIME-Version:
         Xfinity-Spam-Result;
        b=oLqo74iDUDKQcJnu/qq0e4biqhDiRmMua4BSVL5o4u1W9u7RVUCUyCTIV3tk84cYx
         Ngd82y/KjD/TUd60BCp99fqDaijhu4Rp0JcqRYRpIIOnJGY9jixH7y2dYRDcePZA0H
         gDszJN7uYBPjec8kE6ZmtaY2U9GGMKehkNCcOJwX24n2pptoQdWLQ1c3XbdisgEV+x
         QwsxaDpKYYR1ixLZifZuBHwRETB5r93gQiRGYlH48vycq5l06AJ7eTUqIYOtNdYQBK
         MVIeqMibnl9bjL3mei+om+n4xeeBMl2Byw/YY6snWD1v4X5Tyxobz82TLAhZgKaBpw
         dCJrfoY9jPPvw==
Received: from jderrick-mobl4.amr.corp.intel.com ([71.205.181.50])
        by resomta-a1p-077058.sys.comcast.net with ESMTPA
        id Ux8JpSr0ZqdkEUx8Npx9ah; Wed, 22 Feb 2023 21:58:48 +0000
X-Xfinity-VAAS: gggruggvucftvghtrhhoucdtuddrgedvhedrudejledgudehfecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucevohhmtggrshhtqdftvghsihdpqfgfvfdppffquffrtefokffrnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeflohhnrghthhgrnhcuffgvrhhrihgtkhcuoehjohhnrghthhgrnhdruggvrhhrihgtkheslhhinhhugidruggvvheqnecuggftrfgrthhtvghrnhepvddtjeeigfeuleetveduvefhvdejvdfhtdfgheejiedtveeukedtgeettddthedvnecukfhppeejuddrvddthedrudekuddrhedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehhvghlohepjhguvghrrhhitghkqdhmohgslhegrdgrmhhrrdgtohhrphdrihhnthgvlhdrtghomhdpihhnvghtpeejuddrvddthedrudekuddrhedtpdhmrghilhhfrhhomhepjhhonhgrthhhrghnrdguvghrrhhitghksehlihhnuhigrdguvghvpdhnsggprhgtphhtthhopeejpdhrtghpthhtohepshhonhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhrrghiugesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopeignhhisehrvgguhhgrthdrtghomhdprhgtphhtthhopehhtghhsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepphhmvghniigvlh
 esmhholhhgvghnrdhmphhgrdguvgdprhgtphhtthhopehsuhhshhhmrgdrkhgrlhgrkhhothgrsehinhhtvghlrdgtohhm
X-Xfinity-VMeta: sc=-100.00;st=legit
From:   Jonathan Derrick <jonathan.derrick@linux.dev>
To:     Song Liu <song@kernel.org>, <linux-raid@vger.kernel.org>
Cc:     Xiao Ni <xni@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Sushma Kalakota <sushma.kalakota@intel.com>,
        Jon Derrick <jonathan.derrick@linux.dev>
Subject: [PATCH v3 0/3] md/bitmap: Optimal last page size
Date:   Wed, 22 Feb 2023 14:58:25 -0700
Message-Id: <20230222215828.225-1-jonathan.derrick@linux.dev>
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

