Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF8AC77B7E
	for <linux-raid@archiver.kernel.org>; Thu,  1 Jun 2023 07:29:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbjFAH33 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 1 Jun 2023 03:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbjFAH32 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 1 Jun 2023 03:29:28 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37961136
        for <linux-raid@vger.kernel.org>; Thu,  1 Jun 2023 00:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685604567; x=1717140567;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xDZHU71QpCP7/dg4gXk3GRKDPF2kj0AaXzENZe/Npv8=;
  b=PZEW3mKs3uVPnpLT8yv2WD/w28x8MxmaSselZCgU/XnymeKAT1tQIMOV
   9fNhcERoNNk5oi8IzriIX5RtDLm5PRq6W8dh+Niz4O6TGkvqK++Q4ci5b
   /Sh1CbhormbgVePIfD0qdYU/TFtGHWiR5jiW1q8p+LJzLs98S5lGSmkpz
   k4i1cmZ6PUvbmVu4bDgdLBP0uzcJL/WXzoyLXPD/z5vTJy9TedfwKBFoc
   Y99qOJkUYFN9nuIMo5gZ4i5zACBjiI5M9O4oH7Yzo8bPtf9GWdtyygfmB
   f/oBJdnqeMIL3nUSD3EFDInKENYruOLEzsQJT9Rcdvw3UQFHEWjPtQyoJ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="345007120"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="345007120"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 00:28:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="707221112"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="707221112"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 00:28:35 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, colyli@suse.de
Subject: [PATCH 1/6] tests: create names_template
Date:   Thu,  1 Jun 2023 09:27:45 +0200
Message-Id: <20230601072750.20796-2-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230601072750.20796-1-mariusz.tkaczyk@linux.intel.com>
References: <20230601072750.20796-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Create templates directory and names_template. Move code from
00createnames. This code will be reused for 00confnames in next patch.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 tests/00createnames            | 86 +++++++---------------------------
 tests/templates/names_template | 53 +++++++++++++++++++++
 2 files changed, 70 insertions(+), 69 deletions(-)
 create mode 100644 tests/templates/names_template

diff --git a/tests/00createnames b/tests/00createnames
index 64b81b92..064eeef2 100644
--- a/tests/00createnames
+++ b/tests/00createnames
@@ -1,93 +1,41 @@
 set -x -e
+. tests/templates/names_template
 
 # Test how <devname> and --name= are handled for create mode.
-# We need to check three properties, generated from those parameters:
-# - devnode name
-# - link in /dev/md/ (MD_DEVNAME property from --detail --export)
-# - name in metadata (MD_NAME property from --examine --export)
-
-function _verify() {
-  local DEVNODE_NAME="$1"
-  local WANTED_LINK="$2"
-  local WANTED_NAME="$3"
-
-  local RES="$(mdadm -D --export $DEVNODE_NAME | grep MD_DEVNAME)"
-  if [[ "$?" != "0" ]]; then
-    echo "Cannot get details for $DEVNODE_NAME - unexpected devnode."
-    exit 1
-  fi
-
-  if [[ "$WANTED_LINK" != "empty" ]]; then
-    local EXPECTED="MD_DEVNAME=$WANTED_LINK"
-      if [[ "$RES" != "$EXPECTED" ]]; then
-        echo "$RES doesn't match $EXPECTED."
-        exit 1
-      fi
-  fi
-
-
-  local RES="$(mdadm -E --export $dev0 | grep MD_NAME)"
-  if [[ "$?" != "0" ]]; then
-    echo "Cannot get metadata from $dev0."
-    exit 1
-  fi
-
-  local EXPECTED="MD_NAME=$(hostname):$WANTED_NAME"
-  if [[ "$RES" != "$EXPECTED" ]]; then
-    echo "$RES doesn't match $EXPECTED."
-    exit 1
-  fi
-}
-
-function _create() {
-  local DEVNAME=$1
-  local NAME=$2
-
-  if [[ -z "$NAME" ]]; then
-    mdadm -CR "$DEVNAME" -l0 -n 1 $dev0 --force
-  else
-    mdadm -CR "$DEVNAME" --name="$NAME" -l0 -n 1 $dev0 --force
-  fi
-
-  if [[ "$?" != "0" ]]; then
-    echo "Cannot create device."
-    exit 1
-  fi
-}
 
 # The most trivial case.
-_create "/dev/md/name"
-_verify "/dev/md127" "name" "name"
+names_create "/dev/md/name"
+names_verify "/dev/md127" "name" "name"
 mdadm -S "/dev/md127"
 
-_create "name"
-_verify "/dev/md127" "name" "name"
+names_create "name"
+names_verify "/dev/md127" "name" "name"
 mdadm -S "/dev/md127"
 
 # Use 'mdX' as name.
-_create "/dev/md/md0"
-_verify "/dev/md127" "md0" "md0"
+names_create "/dev/md/md0"
+names_verify "/dev/md127" "md0" "md0"
 mdadm -S "/dev/md127"
 
-_create "md0"
-_verify "/dev/md127" "md0" "md0"
+names_create "md0"
+names_verify "/dev/md127" "md0" "md0"
 mdadm -S "/dev/md127"
 
 # <devnode> is used to create MD_DEVNAME but, name is used to create MD_NAME.
-_create "/dev/md/devnode" "name"
-_verify "/dev/md127" "devnode" "name"
+names_create "/dev/md/devnode" "name"
+names_verify "/dev/md127" "devnode" "name"
 mdadm -S "/dev/md127"
 
-_create "devnode" "name"
-_verify "/dev/md127" "devnode" "name"
+names_create "devnode" "name"
+names_verify "/dev/md127" "devnode" "name"
 mdadm -S "/dev/md127"
 
 # Devnode points to /dev/ directory. MD_DEVNAME doesn't exist.
-_create "/dev/md0"
-_verify "/dev/md0" "empty" "0"
+names_create "/dev/md0"
+names_verify "/dev/md0" "empty" "0"
 mdadm -S "/dev/md0"
 
 # Devnode points to /dev/ directory and name is set.
-_create "/dev/md0" "name"
-_verify "/dev/md0" "empty" "name"
+names_create "/dev/md0" "name"
+names_verify "/dev/md0" "empty" "name"
 mdadm -S "/dev/md0"
diff --git a/tests/templates/names_template b/tests/templates/names_template
new file mode 100644
index 00000000..9f09be9e
--- /dev/null
+++ b/tests/templates/names_template
@@ -0,0 +1,53 @@
+# NAME is optional. Testing with native 1.2 superblock.
+function names_create() {
+	local DEVNAME=$1
+	local NAME=$2
+
+	if [[ -z "$NAME" ]]; then
+		mdadm -CR "$DEVNAME" -l0 -n 1 $dev0 --force
+	else
+		mdadm -CR "$DEVNAME" --name="$NAME" --metadata=1.2 -l0 -n 1 $dev0 --force
+	fi
+
+	if [[ "$?" != "0" ]]; then
+		echo "Cannot create device."
+		exit 1
+	fi
+}
+
+# Three properties to check:
+# - devnode name
+# - link in /dev/md/ (MD_DEVNAME property from --detail --export)
+# - name in metadata (MD_NAME property from --detail --export)- that works only with 1.2 sb.
+function names_verify() {
+	local DEVNODE_NAME="$1"
+	local WANTED_LINK="$2"
+	local WANTED_NAME="$3"
+
+	local RES="$(mdadm -D --export $DEVNODE_NAME | grep MD_DEVNAME)"
+	if [[ "$?" != "0" ]]; then
+		echo "Cannot get details for $DEVNODE_NAME - unexpected devnode."
+		exit 1
+	fi
+
+	if [[ "$WANTED_LINK" != "empty" ]]; then
+		local EXPECTED="MD_DEVNAME=$WANTED_LINK"
+	fi
+
+	if [[ "$RES" != "$EXPECTED" ]]; then
+		echo "$RES doesn't match $EXPECTED."
+		exit 1
+	fi
+
+	local RES="$(mdadm -D --export $DEVNODE_NAME | grep MD_NAME)"
+	if [[ "$?" != "0" ]]; then
+		echo "Cannot get metadata from $dev0."
+		exit 1
+	fi
+
+	local EXPECTED="MD_NAME=$(hostname):$WANTED_NAME"
+	if [[ "$RES" != "$EXPECTED" ]]; then
+		echo "$RES doesn't match $EXPECTED."
+		exit 1
+	fi
+}
-- 
2.26.2

