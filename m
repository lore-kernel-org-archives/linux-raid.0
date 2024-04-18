Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F9B15B969
	for <linux-raid@vger.kernel.org>; Thu, 18 Apr 2024 10:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713435819; cv=none; b=oOK9yZcJtRvSRCuRlViXY+f3Xkb28hOElDXj9IaqaiPgu6tehsw3mhTV71bAO5UEKgvVh+NrBe4Ah402EkjKbKp4U+mzsA5kXqGDK3SMjLAc/511jBl/JVTVEgQly+x/Ex1oVuup+DNZbH10H3GrxE61YZ5kR0zMtgKpW6PtnEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713435819; c=relaxed/simple;
	bh=1Z2U2CykL/kF8DBR8ZRYaY/YZvLtEeflVBukKpjUR+Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LLbekInjSXrMrEpKedNYbqXjJcQB1osUFNz9jDdkZgp7L6Tzv/SpmGp1yYeCWkmopu56aJkExNMbMvIIOigHfXA6IUCeb3ggpysXUShwAXnq7eRTX1BYHSFWf30IaGyEqor3LeIe0OvLrKLB2LLRiWNixJTnD42o/AoBJwm6nv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ta76YrPE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ta76YrPE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713435816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9m1aSjvO+6ptpV/AFb2SyIbAmtHQ5MPGeLImUXRC5Fo=;
	b=Ta76YrPE+DSan6ilww1xqXvV9Pytq7AWe30++eEUuh6hEtYQKBsm4B745FBSaifhNF3JFZ
	5sjk1WHiWAOkiN1R7F2RKNMikrrI+QaMt7tNL7cWkoLUGkVKLV26ggzRof53WzZWa8zb6a
	d+K+IEru9AEBIpTRcTjBj9MKi/x56UI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-394-aajNzz3VO_eGl37GgHaY0w-1; Thu,
 18 Apr 2024 06:23:31 -0400
X-MC-Unique: aajNzz3VO_eGl37GgHaY0w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73FAC385A189;
	Thu, 18 Apr 2024 10:23:31 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.2])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4001D1C060D0;
	Thu, 18 Apr 2024 10:23:27 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	song@kernel.org,
	yukuai1@huaweicloud.com,
	ncroxon@redhat.com,
	colyli@suse.de,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 1/5] tests/test enhance
Date: Thu, 18 Apr 2024 18:23:17 +0800
Message-Id: <20240418102321.95384-2-xni@redhat.com>
In-Reply-To: <20240418102321.95384-1-xni@redhat.com>
References: <20240418102321.95384-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

There are two changes.
First, if md module is not loaded, it gives error when reading
speed_limit_max. So read the value after loading md module which
is done in do_setup

Second, sometimes the test reports error sync action doesn't
happen. But dmesg shows sync action is done. So limit the sync
speed before test. It doesn't affect the test run time. Because
check wait sets the max speed before waiting sync action.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 test | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/test b/test
index 338c2db44fa7..2aa3bd75d503 100755
--- a/test
+++ b/test
@@ -6,7 +6,8 @@ targetdir="/var/tmp"
 logdir="$targetdir"
 config=/tmp/mdadm.conf
 testdir=$PWD/tests
-system_speed_limit=`cat /proc/sys/dev/raid/speed_limit_max`
+system_speed_limit_max=0
+system_speed_limit_min=0
 devlist=
 
 savelogs=0
@@ -39,8 +40,19 @@ ctrl_c() {
 	ctrl_c_error=1
 }
 
+record_system_speed_limit() {
+	system_speed_limit_max=`cat /proc/sys/dev/raid/speed_limit_max`
+	system_speed_limit_min=`cat /proc/sys/dev/raid/speed_limit_min`
+}
+
+# To avoid sync action finishes before checking it, it needs to limit
+# the sync speed
+control_system_speed_limit() {
+       echo $system_speed_limit_min > /proc/sys/dev/raid/speed_limit_max
+}
+
 restore_system_speed_limit() {
-	echo $system_speed_limit > /proc/sys/dev/raid/speed_limit_max
+	echo $system_speed_limit_max > /proc/sys/dev/raid/speed_limit_max
 }
 
 mdadm() {
@@ -103,6 +115,7 @@ do_test() {
 		do_clean
 		# source script in a subshell, so it has access to our
 		# namespace, but cannot change it.
+		control_system_speed_limit
 		echo -ne "$_script... "
 		if ( set -ex ; . $_script ) &> $targetdir/log
 		then
@@ -309,6 +322,7 @@ print_warning() {
 main() {
 	print_warning
 	do_setup
+	record_system_speed_limit
 
 	echo "Testing on linux-$(uname -r) kernel"
 	[ "$savelogs" == "1" ] &&
-- 
2.32.0 (Apple Git-132)

