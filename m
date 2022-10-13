Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DF9EC4332F
	for <linux-raid@archiver.kernel.org>; Thu, 13 Oct 2022 22:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiJMWpK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 Oct 2022 18:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiJMWpF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 13 Oct 2022 18:45:05 -0400
X-Greylist: delayed 151 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 13 Oct 2022 15:44:58 PDT
Received: from resdmta-c1p-023853.sys.comcast.net (resdmta-c1p-023853.sys.comcast.net [IPv6:2001:558:fd00:56::e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B0960518
        for <linux-raid@vger.kernel.org>; Thu, 13 Oct 2022 15:44:56 -0700 (PDT)
Received: from resomta-c1p-023267.sys.comcast.net ([96.102.18.232])
        by resdmta-c1p-023853.sys.comcast.net with ESMTP
        id j6RpoJa5HOa5xj6uGoCAph; Thu, 13 Oct 2022 22:42:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=comcastmailservice.net; s=20211018a; t=1665700944;
        bh=uV9jv29H6aFjQ0ZSoY1eBV2TaHPRxfvEQYTsQ4HbTmo=;
        h=Received:Received:From:To:Subject:Date:Message-Id:MIME-Version;
        b=spZIFNb6z5BeGTqBl3rpkI4a3ZwN9PXgYkjrXmztgr1637tcIipdmIzSsXjmx8AQu
         i2oqhtzt3rDVlQupoNxOIXlC0bAzi19KSA518cNKaV0Rwhl6NBY844USRVhkUFFfme
         betvWoVl3pjx1k4N+HWlO8gkfcod1xfd9+Hlq8h1z8uTgZEc/kn/h7INO0kPj38SYM
         +Rh9jbFk0oAHvsmEXv6Syqmpfdy2yPfdzkjXve8Cd/MVQ2olLlEWdITXTCAQduTYwl
         uAbKWtf4RFbRt7BRLwedJCRl5WXKWT7vUI1KwoZTiNJ9Mtg5Zgq4ATryZNElMarkKq
         rGrS1SLXoAHeA==
Received: from jderrick-mobl4.amr.corp.intel.com ([71.205.181.50])
        by resomta-c1p-023267.sys.comcast.net with ESMTPA
        id j6toofOVmA6uYj6ttozg6o; Thu, 13 Oct 2022 22:42:02 +0000
X-Xfinity-VAAS: gggruggvucftvghtrhhoucdtuddrgedvfedrfeekuddgudefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuvehomhgtrghsthdqtfgvshhipdfqfgfvpdfpqffurfetoffkrfenuceurghilhhouhhtmecufedtudenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomheplfhonhgrthhhrghnucffvghrrhhitghkuceojhhonhgrthhhrghnrdguvghrrhhitghksehlihhnuhigrdguvghvqeenucggtffrrghtthgvrhhnpedvtdejiefgueelteevudevhfdvjedvhfdtgfehjeeitdevueektdegtedttdehvdenucfkphepjedurddvtdehrddukedurdehtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhephhgvlhhopehjuggvrhhrihgtkhdqmhhosghlgedrrghmrhdrtghorhhprdhinhhtvghlrdgtohhmpdhinhgvthepjedurddvtdehrddukedurdehtddpmhgrihhlfhhrohhmpehjohhnrghthhgrnhdruggvrhhrihgtkheslhhinhhugidruggvvhdpnhgspghrtghpthhtohepjedprhgtphhtthhopehsohhngheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqrhgrihgusehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhhonhgrthhhrghnrdguvghrrhhitghksehsoh
 hlihguihhgmhdrtghomhdprhgtphhtthhopehjohhnrghthhgrnhigrdhskhdruggvrhhrihgtkhesihhnthgvlhdrtghomhdprhgtphhtthhopehmrghrihhushiirdhtkhgrtgiihihksehlihhnuhigrdhinhhtvghlrdgtohhmpdhrtghpthhtohepjhhonhgrthhhrghnrdguvghrrhhitghksehlihhnuhigrdguvghv
X-Xfinity-VMeta: sc=-100.00;st=legit
From:   Jonathan Derrick <jonathan.derrick@linux.dev>
To:     Song Liu <song@kernel.org>
Cc:     <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        jonathan.derrick@solidigm.com, jonathanx.sk.derrick@intel.com,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Jonathan Derrick <jonathan.derrick@linux.dev>
Subject: [PATCH v2 0/3] Bitmap percentage flushing
Date:   Thu, 13 Oct 2022 16:41:48 -0600
Message-Id: <20221013224151.300-1-jonathan.derrick@linux.dev>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This introduces a percentage-flushing mechanism that works in-tandem to the
mdadm delay timer. The percentage argument is based on the number of chunks
dirty (rather than percentage), due to large drives requiring smaller and
smaller percentages (eg, 32TB drives-> 1% is 320GB).

This set hopes to provide a way to make the bitmap flushing more consistent. It
was observed that a synchronous, random write qd1 workload, could make bitmap
writes easily become almost half of the I/O. And in similar workloads with
different timing, it was several minutes between bitmap updates. This is too
inconsistent to be reliable.

This first and second patches adds the flush_threshold parameter. The default
value of 0 defines the default behavior: unplugging immediately just as before.
With a flush-threshold value of 1, it becomes more consistent and paranoid,
flushing on nearly every I/O, leading to a 40% or greater situation. From
there, the flush_threshold can be defined higher for those situations where
power loss is rare and full resync can be tolerated.

The third patch converts the daemon worker to an actual timer. This makes it
more consistent and removes some ugly code.

Jonathan Derrick (3):
  md/bitmap: Add chunk-threshold unplugging
  md/bitmap: Add sysfs interface for flush threshold
  md/bitmap: Convert daemon_work to proper timer

 Documentation/admin-guide/md.rst |  5 ++
 drivers/md/md-bitmap.c           | 98 +++++++++++++++++++++++++-------
 drivers/md/md-bitmap.h           |  4 +-
 drivers/md/md.c                  |  9 ++-
 drivers/md/md.h                  |  2 +
 5 files changed, 93 insertions(+), 25 deletions(-)

-- 
2.31.1

