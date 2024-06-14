Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72320801
	for <linux-raid@vger.kernel.org>; Fri, 14 Jun 2024 02:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718333112; cv=none; b=CTvbpvA7eHsf18+IHCX2rUxqBZt8XDCZFMSexfhu39MfEa00KqRx2DlyJ9EF8xumPdXe/ey/5O/arjJ2ySIMHFvOqo2pRS0ftgCWWeBY12oiKDoq3ibVeOhc8n4UiGPukPwc1f3DACr9Yh7RrUNAYkCUBZCuKFsVYJSv5Mca7tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718333112; c=relaxed/simple;
	bh=KIGpLMD5aGmO8GlxhY74P4gJVNku6YSRfmvHB6Ga1RQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Bs4bkaj6TjRTFRpVLyJba61WNggACzyFoKUw4Jfe/sCX0xJw1IdRB/gjUDP6Td1fiMNtmeKIBBm2C79jOJfsnD9AT3y/wTX/XtdxGtpnzvSHrBNejhw+egJTxJWwe2FvoN6732vmIPjUZzQq2LXoYE0JErkWzbDXUgY/dE9GOWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JZu2Wy42; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JZu2Wy42"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718333109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=57x2IiuJ/Mf05bkpKVYYhSaemiY4gsUhIJbDfvBliBM=;
	b=JZu2Wy42V4LRWLykIU+XjPRgtAp9sLvUUDyT4Hr8/af4PkuabQxkxQfD4GsGoURER4xzwV
	FZ6z44VgrXaAGtCRb9qgNlAWFSYYFjiIeUGX3ey2NEHl516secwUBzAnIA+c9ti1PyayH/
	CL8pz7/0wtqRd/RpEtvrzvi8DcajPyg=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-583-0sulnbFsOk2IG3HYOSiqeg-1; Thu,
 13 Jun 2024 22:45:07 -0400
X-MC-Unique: 0sulnbFsOk2IG3HYOSiqeg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E46BB19560A2;
	Fri, 14 Jun 2024 02:45:06 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.6])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EFBFD1955E87;
	Fri, 14 Jun 2024 02:45:04 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org
Subject: [PATCH 1/1] mdadm/tests: judge foreign array in test cases
Date: Fri, 14 Jun 2024 10:45:01 +0800
Message-Id: <20240614024501.10832-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

It needs to use array name when judging if one array is foreign or not.
So calling is_raid_foreign in test cases which need it.

Fixes: 41706a915684 ('mdadm/tests: names_template enhance')
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/03assem-incr             | 2 ++
 tests/06name                   | 2 ++
 tests/07autoassemble           | 3 +++
 tests/func.sh                  | 9 +++++----
 tests/templates/names_template | 2 ++
 5 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/tests/03assem-incr b/tests/03assem-incr
index 21215a34f93b..56afbf2cd7b7 100644
--- a/tests/03assem-incr
+++ b/tests/03assem-incr
@@ -12,6 +12,8 @@ if [ "$LINEAR" == "yes" ]; then
 	levels+=( linear )
 fi
 
+is_raid_foreign $md0
+
 for l in ${levels[@]}
 do
 	mdadm -CR $md0 -l $l -n5 $dev0 $dev1 $dev2 $dev3 $dev4 --assume-clean
diff --git a/tests/06name b/tests/06name
index c3213f6c9f7b..9ec3437bfe5a 100644
--- a/tests/06name
+++ b/tests/06name
@@ -2,6 +2,8 @@ set -x
 
 # create an array with a name
 
+is_raid_foreign $md0
+
 mdadm -CR $md0 -l0 -n2 --metadata=1 --name="Fred" $dev0 $dev1
 
 if [ $is_foreign == "no" ]; then
diff --git a/tests/07autoassemble b/tests/07autoassemble
index 9dc781497070..b6630e171992 100644
--- a/tests/07autoassemble
+++ b/tests/07autoassemble
@@ -2,6 +2,9 @@
 # create two raid1s, build a raid0 on top, then
 # tear it down and get auto-assemble to rebuild it.
 
+#the length of md0/md1/md2 is same. So use md0 here.
+is_raid_foreign $md0
+
 mdadm -CR $md1 -l1 -n2 $dev0 $dev1  --homehost=testing
 mdadm -CR $md2 -l1 -n2 $dev2 $dev3  --homehost=testing
 mdadm -CR $md0 -l0 -n2 $md1 $md2  --homehost=testing
diff --git a/tests/func.sh b/tests/func.sh
index b2e4d122aa7f..284e9a654d6e 100644
--- a/tests/func.sh
+++ b/tests/func.sh
@@ -157,10 +157,12 @@ restore_system_speed_limit() {
 
 is_raid_foreign() {
 
-	# If the length of hostname is >= 32, super1 doesn't use
-	# hostname in metadata
+	name=$1
+	# super1 uses this formula strlen(homehost)+1+strlen(name) < 32
+	# to decide if an array is foreign or local. It adds homehost if
+	# one array is local
 	hostname=$(hostname)
-	if [ `expr length $(hostname)` -lt 32 ]; then
+	if [ `expr length "$(hostname)$name"` -lt 31 ]; then
 		is_foreign="no"
 	else
 		is_foreign="yes"
@@ -255,7 +257,6 @@ do_setup() {
 	[ -f /proc/mdstat ] || modprobe md_mod
 	echo 0 > /sys/module/md_mod/parameters/start_ro
 	record_system_speed_limit
-	is_raid_foreign
 	record_selinux
 }
 
diff --git a/tests/templates/names_template b/tests/templates/names_template
index 88ad5b8c6b38..c94245eaab2a 100644
--- a/tests/templates/names_template
+++ b/tests/templates/names_template
@@ -4,6 +4,8 @@ function names_create() {
 	local NAME=$2
 	local NEG_TEST=$3
 
+	is_raid_foreign $DEVNAME
+
 	if [[ -z "$NAME" ]]; then
 		mdadm -CR "$DEVNAME" -l0 -n 1 $dev0 --force
 	else
-- 
2.32.0 (Apple Git-132)

