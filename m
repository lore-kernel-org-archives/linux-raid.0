Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAA70C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 13:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238446AbiGSNd7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 09:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237693AbiGSNdo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 09:33:44 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88F88E1CF
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 05:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658234959; x=1689770959;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/xqdPPYdzOBh2UwmtKExS1k3eNr/3IXfydYvQbQLP2M=;
  b=Gf2/M6PD6/V+dbJ/BXEp3HvmyNCrT6hkDM2IImRBq43tsCFx61j1xT4I
   Ih/P3uuX+3YPqxjF+i8SVnLJr7vGDWiSe09jYQF4+wUhdXvOtW7qZzUY+
   6NHn36zLbqbDHYxc0Bd0KDgwd/YumfiFNbOn9RJROZkO4Xh4tlNEqEf20
   3pfp+K0f7I0XAxeNn5xUTkJzj/DCaxGYUPrVr4DxSSqHzZZzR8Gv0LIFp
   j/Gel2Lvmovn8OARQ9xJglkNV3e1mgNVsZt+ftetcDxW9CXUEKjw1lT5O
   8l/P9olDWIk+ftKboEMq0o/SvzqV8bA2zi31IPcC6Y7TxGzM3KftbVy2k
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="287225192"
X-IronPort-AV: E=Sophos;i="5.92,284,1650956400"; 
   d="scan'208";a="287225192"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 05:48:44 -0700
X-IronPort-AV: E=Sophos;i="5.92,284,1650956400"; 
   d="scan'208";a="687100945"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 05:48:42 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org, colyli@suse.de
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 1/3] tests: add test for names
Date:   Tue, 19 Jul 2022 14:48:21 +0200
Message-Id: <20220719124823.20302-2-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220719124823.20302-1-mariusz.tkaczyk@linux.intel.com>
References: <20220719124823.20302-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Current behavior is not documented and tested. This test is a base for
future improvements. It is enough to test it only with native metadata,
because it is generic code. Generated properties are passed to metadata
handler.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 tests/00createnames | 93 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)
 create mode 100644 tests/00createnames

diff --git a/tests/00createnames b/tests/00createnames
new file mode 100644
index 0000000..64b81b9
--- /dev/null
+++ b/tests/00createnames
@@ -0,0 +1,93 @@
+set -x -e
+
+# Test how <devname> and --name= are handled for create mode.
+# We need to check three properties, generated from those parameters:
+# - devnode name
+# - link in /dev/md/ (MD_DEVNAME property from --detail --export)
+# - name in metadata (MD_NAME property from --examine --export)
+
+function _verify() {
+  local DEVNODE_NAME="$1"
+  local WANTED_LINK="$2"
+  local WANTED_NAME="$3"
+
+  local RES="$(mdadm -D --export $DEVNODE_NAME | grep MD_DEVNAME)"
+  if [[ "$?" != "0" ]]; then
+    echo "Cannot get details for $DEVNODE_NAME - unexpected devnode."
+    exit 1
+  fi
+
+  if [[ "$WANTED_LINK" != "empty" ]]; then
+    local EXPECTED="MD_DEVNAME=$WANTED_LINK"
+      if [[ "$RES" != "$EXPECTED" ]]; then
+        echo "$RES doesn't match $EXPECTED."
+        exit 1
+      fi
+  fi
+
+
+  local RES="$(mdadm -E --export $dev0 | grep MD_NAME)"
+  if [[ "$?" != "0" ]]; then
+    echo "Cannot get metadata from $dev0."
+    exit 1
+  fi
+
+  local EXPECTED="MD_NAME=$(hostname):$WANTED_NAME"
+  if [[ "$RES" != "$EXPECTED" ]]; then
+    echo "$RES doesn't match $EXPECTED."
+    exit 1
+  fi
+}
+
+function _create() {
+  local DEVNAME=$1
+  local NAME=$2
+
+  if [[ -z "$NAME" ]]; then
+    mdadm -CR "$DEVNAME" -l0 -n 1 $dev0 --force
+  else
+    mdadm -CR "$DEVNAME" --name="$NAME" -l0 -n 1 $dev0 --force
+  fi
+
+  if [[ "$?" != "0" ]]; then
+    echo "Cannot create device."
+    exit 1
+  fi
+}
+
+# The most trivial case.
+_create "/dev/md/name"
+_verify "/dev/md127" "name" "name"
+mdadm -S "/dev/md127"
+
+_create "name"
+_verify "/dev/md127" "name" "name"
+mdadm -S "/dev/md127"
+
+# Use 'mdX' as name.
+_create "/dev/md/md0"
+_verify "/dev/md127" "md0" "md0"
+mdadm -S "/dev/md127"
+
+_create "md0"
+_verify "/dev/md127" "md0" "md0"
+mdadm -S "/dev/md127"
+
+# <devnode> is used to create MD_DEVNAME but, name is used to create MD_NAME.
+_create "/dev/md/devnode" "name"
+_verify "/dev/md127" "devnode" "name"
+mdadm -S "/dev/md127"
+
+_create "devnode" "name"
+_verify "/dev/md127" "devnode" "name"
+mdadm -S "/dev/md127"
+
+# Devnode points to /dev/ directory. MD_DEVNAME doesn't exist.
+_create "/dev/md0"
+_verify "/dev/md0" "empty" "0"
+mdadm -S "/dev/md0"
+
+# Devnode points to /dev/ directory and name is set.
+_create "/dev/md0" "name"
+_verify "/dev/md0" "empty" "name"
+mdadm -S "/dev/md0"
-- 
2.26.2

