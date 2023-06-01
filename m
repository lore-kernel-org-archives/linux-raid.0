Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B26EC7EE29
	for <linux-raid@archiver.kernel.org>; Thu,  1 Jun 2023 07:29:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbjFAH3b (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 1 Jun 2023 03:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbjFAH33 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 1 Jun 2023 03:29:29 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED8413D
        for <linux-raid@vger.kernel.org>; Thu,  1 Jun 2023 00:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685604567; x=1717140567;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qy7a6pb3YsaeeHsAeJpNYCfHXMVF4+DtNSxIWCbqoQA=;
  b=VBgoO0bUSWnEuyQSGaFZQ3b7imEqzYaeFuGVZTVA78du25h20q9KFgR/
   XTiKmDDAbGGW3GbYg4HHQ4DC+Nphp9Q3ICwblD7N06pH69XA99ej+m3KL
   Tk+1vb0X7Jot7t0DOCpVAZIMgjW4zlpRrxt1EtcfH6Xm/Xb+BX3C/MH9o
   mBApZZMXxHQVxqt6k0aX2DcNhnmZwpROpP772vVi/1NcF4DLhygFgGU7x
   bwunfmIooYIKfNRVC8JWKy+xlEiskRqgS0hbQ8O5U6sBhbSj04otebVsS
   N5CU37noq1J04T86Rh9HLG6NoZGzTN2Idefd1YrWvhw78c6ikaA6jO/2D
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="345007130"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="345007130"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 00:28:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="707221120"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="707221120"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 00:28:37 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, colyli@suse.de
Subject: [PATCH 2/6] tests: create 00confnames
Date:   Thu,  1 Jun 2023 09:27:46 +0200
Message-Id: <20230601072750.20796-3-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230601072750.20796-1-mariusz.tkaczyk@linux.intel.com>
References: <20230601072750.20796-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The test is an attempt to document current implementation of devnode
and name handling for config entries. It is focused on incremental-
default way of array assembling on boot.
The expectations are aligned to current implementation for native
metadata because it is the most complicated scenario- both variables
can be set.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 tests/00confnames              | 107 +++++++++++++++++++++++++++++++++
 tests/templates/names_template |  20 ++++++
 2 files changed, 127 insertions(+)
 create mode 100644 tests/00confnames

diff --git a/tests/00confnames b/tests/00confnames
new file mode 100644
index 00000000..4990cb5e
--- /dev/null
+++ b/tests/00confnames
@@ -0,0 +1,107 @@
+set -x -e
+. tests/templates/names_template
+
+# Test how <devname> and <name> from config are handled during Incremental assemblation.
+# 1-6 <devnode> only tests (no <name> in config).
+# 6-10 <devname> and <name> combinations are tested.
+# 11-13 corner cases.
+
+names_create "/dev/md/name"
+local _UUID="$(mdadm -D --export /dev/md127 | grep MD_UUID | cut -d'=' -f2)"
+[[ "$_UUID" == "" ]] && echo "Cannot obtain UUID for $DEVNODE_NAME" && exit 1
+
+
+# 1. <devname> definition consistent with metadata name.
+names_make_conf $_UUID "/dev/md/name" "empty" $config
+mdadm -S "/dev/md127"
+mdadm -I $dev0 --config=$config
+names_verify "/dev/md127" "name" "name"
+mdadm -S "/dev/md127"
+
+# 2. Same as 1, but use short name form of <devname>.
+names_make_conf $_UUID "name" "empty" $config
+mdadm -I $dev0 --config=$config
+names_verify "/dev/md127" "name" "name"
+mdadm -S "/dev/md127"
+
+# 3. Same as 1, but use different <devname> than metadata provides.
+names_make_conf $_UUID "/dev/md/other" "empty" $config
+mdadm -I $dev0 --config=$config
+names_verify "/dev/md127" "other" "name"
+mdadm -S "/dev/md127"
+
+# 4. Same as 3, but use short name form of <devname>.
+names_make_conf $_UUID "other" "empty" $config
+mdadm -I $dev0 --config=$config
+names_verify "/dev/md127" "other" "name"
+mdadm -S "/dev/md127"
+
+# 5. Force particular node creation by setting <devname> to /dev/mdX. Link is not created in this
+# case.
+names_make_conf $_UUID "/dev/md4" "empty" $config
+mdadm -I $dev0 --config=$config
+names_verify "/dev/md4" "empty" "name"
+mdadm -S "/dev/md4"
+
+# 6. <devname> set to /dev/mdX, <name> same as in metadata.
+# Metadata name and default node used - controversial. Current behavior documented.
+names_make_conf $_UUID "/dev/md22" "name" $config
+mdadm -I $dev0 --config=$config
+names_verify "/dev/md127" "name" "name"
+mdadm -S "/dev/md127"
+
+# 7. <devname> set to /dev/mdX, <name> different than in metadata.
+# Metadata name and default node used - controversial. Current behavior documented.
+names_make_conf $_UUID "/dev/md8" "other" $config
+mdadm -I $dev0 --config=$config
+names_verify "/dev/md127" "name" "name"
+mdadm -S "/dev/md127"
+
+# 8. Both <devname> and <name> different than in metadata.
+# Metadata name and default node used - controversial. Current behavior documented.
+names_make_conf $_UUID "devnode" "other_name" $config
+mdadm -I $dev0 --config=$config
+names_verify "/dev/md127" "name" "name"
+mdadm -S "/dev/md127"
+
+# 9. <devname> set to metadata name, <name> different than in metadata.
+# Metadata name and default node used - controversial. Current behavior documented.
+names_make_conf $_UUID "name" "other_name" $config
+mdadm -I $dev0 --config=$config
+names_verify "/dev/md127" "name" "name"
+mdadm -S "/dev/md127"
+
+# 10. Bad <devname> set, no <name>.
+# Metadata name and default node used - expected.
+names_make_conf $_UUID "/im/bad/devname" "empty" $config
+mdadm -I $dev0 --config=$config
+names_verify "/dev/md127" "name" "name"
+mdadm -S "/dev/md127"
+
+# 11. <devname> with some special symbols and locales, no <name>.
+# It needs to wait a while for timeout because udev cannot create a link - known issue.
+names_make_conf $_UUID "tźż-\.,<>st+-" "empty" $config
+mdadm -I $dev0 --config=$config
+names_verify "/dev/md127" "tźż-\.,<>st+-" "name"
+mdadm -S "/dev/md127"
+
+# 12. No <devname> and <name> set.
+# Metadata name and default node used - expected.
+names_make_conf $_UUID "empty" "empty" $config
+mdadm -I $dev0 --config=$config
+names_verify "/dev/md127" "name" "name"
+mdadm -S "/dev/md127"
+
+# 13. No <devname>, <name> set to /dev/mdX.
+# Entry should be ignored, it is not ignored but result is good anyway.
+names_make_conf $_UUID "empty" "/dev/md12" $config
+mdadm -I $dev0 --config=$config
+names_verify "/dev/md127" "name" "name"
+mdadm -S "/dev/md127"
+
+# 13. No <devname>, <name> with special symbols and locales.
+# Entry should be ignored, it is not ignored but result is good anyway.
+names_make_conf $_UUID "empty" "./\śćń#&" $config
+mdadm -I $dev0 --config=$config
+names_verify "/dev/md127" "name" "name"
+mdadm -S "/dev/md127"
diff --git a/tests/templates/names_template b/tests/templates/names_template
index 9f09be9e..8d2b5c81 100644
--- a/tests/templates/names_template
+++ b/tests/templates/names_template
@@ -51,3 +51,23 @@ function names_verify() {
 		exit 1
 	fi
 }
+
+# Generate ARRAYLINE for tested array.
+names_make_conf() {
+	local UUID="$1"
+	local WANTED_DEVNAME="$2"
+	local WANTED_NAME="$3"
+	local CONF="$4"
+
+	local LINE="ARRAY metadata=1.2 UUID=$UUID"
+
+	if [[ "$WANTED_DEVNAME" != "empty" ]]; then
+		LINE="$LINE $WANTED_DEVNAME"
+	fi
+
+	if [[ "$WANTED_NAME" != "empty" ]]; then
+		LINE="$LINE name=$WANTED_NAME"
+	fi
+
+	echo $LINE > $CONF
+}
-- 
2.26.2

