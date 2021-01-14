Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED9DDC433E6
	for <linux-raid@archiver.kernel.org>; Thu, 14 Jan 2021 13:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A980C23A59
	for <linux-raid@archiver.kernel.org>; Thu, 14 Jan 2021 13:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbhANNC5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Jan 2021 08:02:57 -0500
Received: from mga14.intel.com ([192.55.52.115]:60766 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbhANNC4 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 14 Jan 2021 08:02:56 -0500
IronPort-SDR: pqU6oLM9Dr+bczC9o1M1At9lAOdlldo98gWBHj0Zkmhd5h6bJupumjX4yh50b1DYfOP5ITjQOS
 4zTtg8mk7rGg==
X-IronPort-AV: E=McAfee;i="6000,8403,9863"; a="177581206"
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="177581206"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2021 05:02:15 -0800
IronPort-SDR: 2HiRFOi6V++YlducTM6R7z8sn4KfHXePxlbD5aoPsONHWSjoiYy+Hq4F+GCme1JUjQ4RxQ5+ls
 WBqkGynxCnTg==
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="382260157"
Received: from unknown (HELO gklab-109-123.igk.intel.com) ([10.102.109.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2021 05:02:13 -0800
From:   Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH v2] Document PPL in man md
Date:   Thu, 14 Jan 2021 13:59:20 +0100
Message-Id: <20210114125920.42675-1-oleksandr.shchirskyi@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Partial Parity Log (PPL) was not documented in the man md.
Added brief info about PPL.

Signed-off-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
---
 md.4 | 44 +++++++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff --git a/md.4 b/md.4
index 60fdd274..7a0bc7e6 100644
--- a/md.4
+++ b/md.4
@@ -219,7 +219,7 @@ Once you have updated the layout you will not be able to mount the array
 on an older kernel.  If you need to revert to an older kernel, the
 layout information can be erased with the
 .B "--update=layout-unspecificed"
-option.  If you use this option to 
+option.  If you use this option to
 .B --assemble
 while running a newer kernel, the array will NOT assemble, but the
 metadata will be update so that it can be assembled on an older kernel.
@@ -909,26 +909,40 @@ The list is particularly useful when recovering to a spare.  If a few blocks
 cannot be read from the other devices, the bulk of the recovery can
 complete and those few bad blocks will be recorded in the bad block list.
 
-.SS RAID456 WRITE JOURNAL
+.SS RAID WRITE HOLE
 
-Due to non-atomicity nature of RAID write operations, interruption of
-write operations (system crash, etc.) to RAID456 array can lead to
-inconsistent parity and data loss (so called RAID-5 write hole).
+Due to non-atomicity nature of RAID write operations,
+interruption of write operations (system crash, etc.) to RAID456
+array can lead to inconsistent parity and data loss (so called
+RAID-5 write hole).
+To plug the write hole md supports two mechanisms described below.
 
-To plug the write hole, from Linux 4.4 (to be confirmed),
-.I md
-supports write ahead journal for RAID456. When the array is created,
-an additional journal device can be added to the array through
-.IR write-journal
-option. The RAID write journal works similar to file system journals.
-Before writing to the data disks, md persists data AND parity of the
-stripe to the journal device. After crashes, md searches the journal
-device for incomplete write operations, and replay them to the data
-disks.
+.TP
+DIRTY STRIPE JOURNAL
+From Linux 4.4, md supports write ahead journal for RAID456.
+When the array is created, an additional journal device can be added to
+the array through write-journal option. The RAID write journal works
+similar to file system journals. Before writing to the data
+disks, md persists data AND parity of the stripe to the journal
+device. After crashes, md searches the journal device for
+incomplete write operations, and replay them to the data disks.
 
 When the journal device fails, the RAID array is forced to run in
 read-only mode.
 
+.TP
+PARTIAL PARITY LOG
+From Linux 4.12 md supports Partial Parity Log (PPL) for RAID5 arrays only.
+Partial parity for a write operation is the XOR of stripe data chunks not
+modified by the write. PPL is stored in the metadata region of RAID member drives,
+no additional journal drive is needed.
+After crashes, if one of the not modified data disks of
+the stripe is missing, this updated parity can be used to recover its
+data.
+
+This mechanism is documented more fully in the file
+Documentation/md/raid5-ppl.rst
+
 .SS WRITE-BEHIND
 
 From Linux 2.6.14,
-- 
2.27.0

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
ul. Sowackiego 173 | 80-298 Gdask | Sd Rejonowy Gdask Pnoc | VII Wydzia Gospodarczy Krajowego Rejestru Sdowego - KRS 101882 | NIP 957-07-52-316 | Kapita zakadowy 200.000 PLN.
Ta wiadomo wraz z zacznikami jest przeznaczona dla okrelonego adresata i moe zawiera informacje poufne. W razie przypadkowego otrzymania tej wiadomoci, prosimy o powiadomienie nadawcy oraz trwae jej usunicie; jakiekolwiek przegldanie lub rozpowszechnianie jest zabronione.
This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). If you are not the intended recipient, please contact the sender and delete all copies; any review or distribution by others is strictly prohibited.
 

