Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF95BC433F5
	for <linux-raid@archiver.kernel.org>; Thu,  6 Oct 2022 22:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbiJFWLq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 6 Oct 2022 18:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbiJFWLn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 6 Oct 2022 18:11:43 -0400
Received: from resqmta-h1p-028587.sys.comcast.net (resqmta-h1p-028587.sys.comcast.net [IPv6:2001:558:fd02:2446::b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A181C1142E2
        for <linux-raid@vger.kernel.org>; Thu,  6 Oct 2022 15:11:42 -0700 (PDT)
Received: from resomta-h1p-028434.sys.comcast.net ([96.102.179.205])
        by resqmta-h1p-028587.sys.comcast.net with ESMTP
        id gUKsoUFaawQEAgZ3FowRCF; Thu, 06 Oct 2022 22:09:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=comcastmailservice.net; s=20211018a; t=1665094149;
        bh=IKYUboxuiUIaVRLX9+Ls9Ayah1lDyM2CjdHPVn2SJhY=;
        h=Received:Received:From:To:Subject:Date:Message-Id:MIME-Version;
        b=tcvsIkAD7d34hJVXUA58qFDQ7QNXcvmF+rwPO7Wf53S8lm6Lqv4qOufSF9tnTzASU
         Gbpp1mhrYjMVh6I3WpBa8zWiZqx3crDePqdVaDMQaxNmic/1pTvIhfAjYeB5EEt1LH
         WbNA6Eg8I5p3cSQvJ0GMpeciOAfF373y1+QJFAHl+VzZ8G5ON+ECCXklU+UfxN7XHr
         ZZF1QU7QuxlDget5/zhrOYxc9888m1J9510ejOKtn5mn1yIUDlSyUKlLpB8BmqWbYA
         ocmlobcp2gPW+PEa8qxwQnOsugQwt69ADXKBrQApKyKMD66j9FGjW+Z7bYMk+w9SQx
         IOdxEa2DFT0yw==
Received: from jderrick-mobl4.amr.corp.intel.com ([71.205.181.50])
        by resomta-h1p-028434.sys.comcast.net with ESMTPA
        id gZ2nocknTZjG3gZ2roEgwk; Thu, 06 Oct 2022 22:08:47 +0000
X-Xfinity-VAAS: gggruggvucftvghtrhhoucdtuddrgedvfedrfeeiiedgtdeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuvehomhgtrghsthdqtfgvshhipdfqfgfvpdfpqffurfetoffkrfenuceurghilhhouhhtmecufedtudenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomheplfhonhgrthhhrghnucffvghrrhhitghkuceojhhonhgrthhhrghnrdguvghrrhhitghksehlihhnuhigrdguvghvqeenucggtffrrghtthgvrhhnpedvtdejiefgueelteevudevhfdvjedvhfdtgfehjeeitdevueektdegtedttdehvdenucfkphepjedurddvtdehrddukedurdehtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhephhgvlhhopehjuggvrhhrihgtkhdqmhhosghlgedrrghmrhdrtghorhhprdhinhhtvghlrdgtohhmpdhinhgvthepjedurddvtdehrddukedurdehtddpmhgrihhlfhhrohhmpehjohhnrghthhgrnhdruggvrhhrihgtkheslhhinhhugidruggvvhdpnhgspghrtghpthhtohepiedprhgtphhtthhopehsohhngheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqrhgrihgusehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhhonhgrthhhrghnrdguvghrrhhitghksehsoh
 hlihguihhgmhdrtghomhdprhgtphhtthhopehjohhnrghthhgrnhigrdhskhdruggvrhhrihgtkhesihhnthgvlhdrtghomhdprhgtphhtthhopehjohhnrghthhgrnhdruggvrhhrihgtkheslhhinhhugidruggvvh
X-Xfinity-VMeta: sc=-100.00;st=legit
From:   Jonathan Derrick <jonathan.derrick@linux.dev>
To:     Song Liu <song@kernel.org>
Cc:     <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        jonathan.derrick@solidigm.com, jonathanx.sk.derrick@intel.com,
        Jonathan Derrick <jonathan.derrick@linux.dev>
Subject: [PATCH 0/2] Bitmap percentage flushing
Date:   Thu,  6 Oct 2022 16:08:37 -0600
Message-Id: <20221006220840.275-1-jonathan.derrick@linux.dev>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This introduces a percentage-flushing mechanism that works in-tandem to
the delay timer. The percentage argument is based on the number of
chunks dirty. It was chosen to use number of chunks due to large drives requiring
smaller and smaller percentages (eg, 32TB drives-> 1% is 320GB).

The first patch fixes a performance gap observed in RAID1
configurations. With a synchronous qd1 workload, bitmap writes can
easily become almost half of the I/O. This could be argued to be
expected, but undesirable. Moving the unplug operation to the periodic
delay work seemed to help the situation.

The second part of this set adds a new field in the superblock and
version, allowing for a new argument through mdadm specifying the number
of chunks allowed to be dirty before flushing.

Accompanying this set is an RFC for mdadm patch. It lacks documentation
which will be sent in v2 if this changeset is appropriate.

Jonathan Derrick (2):
  md/bitmap: Move unplug to daemon thread
  md/bitmap: Add chunk-count-based bitmap flushing

 drivers/md/md-bitmap.c | 38 +++++++++++++++++++++++++++++++++++---
 drivers/md/md-bitmap.h |  5 ++++-
 drivers/md/md.h        |  1 +
 drivers/md/raid1.c     |  2 --
 drivers/md/raid10.c    |  4 ----
 5 files changed, 40 insertions(+), 10 deletions(-)

-- 
2.31.1

