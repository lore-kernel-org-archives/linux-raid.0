Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2674C19F29
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 12:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237296AbiG1MWq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 08:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238372AbiG1MW1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 08:22:27 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F576BD5C
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 05:22:26 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id E025C373A7;
        Thu, 28 Jul 2022 12:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659010944; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OOZCXXfb0FQRSGUajQWOdU59WnmYW0fsWOEnkPlYrjo=;
        b=mKQF01F5Ryc/QhpkKhelv+Ndb6n2wF9UpX8ibj/tRJX4joft0KuoAH1976qHmerPhLvfmf
        0+Y+wTkM3CPQPJE3NiQH2mfIzweKmc7So5/H2Y8apYrVMOPoBJ76BjTuxgGIyFszMZZP38
        yBmbT1xFVNmlVteXTz1qBlGWZlI5qbg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659010944;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OOZCXXfb0FQRSGUajQWOdU59WnmYW0fsWOEnkPlYrjo=;
        b=l2Kn6ai+IlDTqc6TYfWBNAulG6bgZ3ucgUZDgfrmM0eZ8gb2tylN+p4PZjCTZb+bdVxjIZ
        VtYPcmsVd0WuxBDg==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 6E50E2C141;
        Thu, 28 Jul 2022 12:22:22 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 20/23] tests: add test for names
Date:   Thu, 28 Jul 2022 20:20:58 +0800
Message-Id: <20220728122101.28744-21-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220728122101.28744-1-colyli@suse.de>
References: <20220728122101.28744-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Current behavior is not documented and tested. This test is a base for
future improvements. It is enough to test it only with native metadata,
because it is generic code. Generated properties are passed to metadata
handler.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Acked-by: Coly Li <colyli@suse.de>
---
 tests/00createnames | 93 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)
 create mode 100644 tests/00createnames

diff --git a/tests/00createnames b/tests/00createnames
new file mode 100644
index 00000000..64b81b92
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
2.35.3

