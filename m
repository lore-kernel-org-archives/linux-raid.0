Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFEBAC19F2C
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 12:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238293AbiG1MVw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 08:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238291AbiG1MVl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 08:21:41 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4DA6BD47
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 05:21:40 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 8AA0F1FE12;
        Thu, 28 Jul 2022 12:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659010899; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vw/w2DAnsQtIx9ReFgmQ5gwqdp9NJbLDmk8KWDOPc2g=;
        b=gfmYUhRdWZAHmiMoJ4ddzcJFen6EbbD9hW9idTeL2ryhnYpUOyjoHJ5v4Z5n/pBW3QPlPC
        ATdrO3InZexfJ5mJIZj8qY5pIxb6VOqIy1m0bhwFcIhaCJw5uU1mdiJ1X0XojDMfchJ91h
        txjRr1qZ5Z7WKsv6dwbR1dWT7QqzWCs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659010899;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vw/w2DAnsQtIx9ReFgmQ5gwqdp9NJbLDmk8KWDOPc2g=;
        b=ohlRRpdjhRvD4bw1Su0k+gAdWyPtJkJahyMdHnToz8RsUSVmDJBDyuKceRBHzM8lT86rni
        +IoA4TxfQYaJUjDQ==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id A4BC92C141;
        Thu, 28 Jul 2022 12:21:36 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Mateusz Grzonka <mateusz.grzonka@intel.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 07/23] mdadm: Fix optional --write-behind parameter
Date:   Thu, 28 Jul 2022 20:20:45 +0800
Message-Id: <20220728122101.28744-8-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220728122101.28744-1-colyli@suse.de>
References: <20220728122101.28744-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

The commit noted below changed the behaviour of --write-behind to
require an argument. This broke the 06wrmostly test with the error:

  mdadm: Invalid value for maximum outstanding write-behind writes: (null).
         Must be between 0 and 16383.

To fix this, check if optarg is NULL before parising it, as the original
code did.

[Coly Li fixes the typo in commit log from 'origial' to 'original'.]

Fixes: 60815698c0ac ("Refactor parse_num and use it to parse optarg.")
Cc: Mateusz Grzonka <mateusz.grzonka@intel.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Acked-by: Coly Li <colyli@suse.de>
---
 mdadm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mdadm.c b/mdadm.c
index d0c5e6de..56722ed9 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1201,8 +1201,9 @@ int main(int argc, char *argv[])
 		case O(BUILD, WriteBehind):
 		case O(CREATE, WriteBehind):
 			s.write_behind = DEFAULT_MAX_WRITE_BEHIND;
-			if (parse_num(&s.write_behind, optarg) != 0 ||
-			s.write_behind < 0 || s.write_behind > 16383) {
+			if (optarg &&
+			    (parse_num(&s.write_behind, optarg) != 0 ||
+			     s.write_behind < 0 || s.write_behind > 16383)) {
 				pr_err("Invalid value for maximum outstanding write-behind writes: %s.\n\tMust be between 0 and 16383.\n",
 						optarg);
 				exit(2);
-- 
2.35.3

