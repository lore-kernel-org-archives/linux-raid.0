Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1649DC433E0
	for <linux-raid@archiver.kernel.org>; Sun,  3 Jan 2021 21:42:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3AEF208BA
	for <linux-raid@archiver.kernel.org>; Sun,  3 Jan 2021 21:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbhACVmO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 3 Jan 2021 16:42:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:37528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbhACVmN (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 3 Jan 2021 16:42:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B4D2207C9;
        Sun,  3 Jan 2021 21:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609710093;
        bh=cD2FnRzoEeOnyRkbvnTXdlKJd3Z9weaquM8Zry7ePpA=;
        h=From:To:Cc:Subject:Date:From;
        b=mFFi6lFv6f2HyUqZcfVyiHZiJFwPC/57VYz8bcP6aYgi1hBL3ujOZyN9JfTQMSGXy
         FCSTZsd1sN+gtf/Z5OLFzkHfHUXMbl49kscW1f46cP6eWZ58dAMpZoAwrfyERFxFJd
         YdZ09Grwddh/CDP9NbvSxH/mY9IwB2moOHPYZfGexvLu0gnZxZxCNoHlTTMRXymX8F
         c2tJ2oKtAkABXkte1+o2Jk7bgEeA4opxxIgG0l8hpNcDCLZjz9SgRLA1j4YOYaEbzS
         cHLsVResKArOQLGg1a051YmuzvPqotrjBVTYg5gWcFO8GXn0QnVK/ro88oRHzvvGHQ
         BHyIwqvVuda6A==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Song Liu <song@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dm zoned: select CONFIG_CRC32
Date:   Sun,  3 Jan 2021 22:40:51 +0100
Message-Id: <20210103214129.1996037-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Without crc32 support, this driver fails to link:

arm-linux-gnueabi-ld: drivers/md/dm-zoned-metadata.o: in function `dmz_write_sb':
dm-zoned-metadata.c:(.text+0xe98): undefined reference to `crc32_le'
arm-linux-gnueabi-ld: drivers/md/dm-zoned-metadata.o: in function `dmz_check_sb':
dm-zoned-metadata.c:(.text+0x7978): undefined reference to `crc32_le'

Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/md/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index b7e2d9666614..a67b9ed3ca89 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -622,6 +622,7 @@ config DM_ZONED
 	tristate "Drive-managed zoned block device target support"
 	depends on BLK_DEV_DM
 	depends on BLK_DEV_ZONED
+	select CRC32
 	help
 	  This device-mapper target takes a host-managed or host-aware zoned
 	  block device and exposes most of its capacity as a regular block
-- 
2.29.2

