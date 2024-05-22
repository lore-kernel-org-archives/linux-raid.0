Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3693280046
	for <linux-raid@vger.kernel.org>; Wed, 22 May 2024 08:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716367878; cv=none; b=rp6aIMJ+7V2BVMKYs0FBFXODpticVgHKK2dtBfwCtwYCuiG/jnKMW5dbQDJ7zm7KL8fj3oZyhMQnmTzp84qYt1HUHKJhvm9qSPZHEw6o9oAq+UfH27rh7mu9iXEi53uwn2ypaV+8DUTG5+r/Q2M38hmOypP2XlAHpvaWCvZgFzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716367878; c=relaxed/simple;
	bh=xDLS+HBobZvI8Bp/xZO4MkJIxKrJhHK4/jvyx0IY+Gs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UIoskqW8/rXDCSLfePFf1+DIYLlV2em3+osPK+MmiDGTCuAIJNxDwVIP15XeuV/MpmnNAZ/t//Lgr85gzBVwML9cIhVXRD3nTFXCOIPWNS0gz6ltfaPaVjVfxNCPvklp+ghnCuUjoYCfAFwEYwaKW3vGz3sDDw3dlUUOzq+BOF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mx/ohwb9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mx/ohwb9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716367876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xY+deuSavt7Rx4yM5VbroGZv149KQlWRNm9KNcUloWc=;
	b=Mx/ohwb9j879DhoBRxRpp/poWZmkGgB8XMKoZGabzUuy1ZVd0AxYmvJ7oeQV15iV4BMwfJ
	sFRJYnI2ZwAURyMXEK1iZExjPP9f/GH1LQMg35WMwJw4moDuCC8Xril5Fym7uRIMKFb1kg
	R1tUv43tgvU9FKn/5A+PW6gyYN7++Sk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-425-xUpVVvYkPD6kYfIVrhLUOA-1; Wed,
 22 May 2024 04:51:13 -0400
X-MC-Unique: xUpVVvYkPD6kYfIVrhLUOA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A04E81C29EA1;
	Wed, 22 May 2024 08:51:12 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.11])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 767AAC15BB1;
	Wed, 22 May 2024 08:51:10 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	heinzm@redhat.com,
	ncroxon@redhat.com
Subject: [PATCH 04/19] mdadm/tests: test enhance
Date: Wed, 22 May 2024 16:50:41 +0800
Message-Id: <20240522085056.54818-5-xni@redhat.com>
In-Reply-To: <20240522085056.54818-1-xni@redhat.com>
References: <20240522085056.54818-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

There are two changes.
First, if md module is not loaded, it gives error when reading
speed_limit_max. So read the value after loading md module which
is done in do_setup

Second, sometimes the test reports error sync action doesn't
happen. But dmesg shows sync action is done. So limit the sync
speed before test. It doesn't affect the test run time. Because
check wait sets the max speed before waiting sync action. And
recording speed_limit_max/min in do_setup.

Fixes: 4c12714d1ca0 ('test: run tests on system level mdadm')
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 test          | 10 +++++-----
 tests/func.sh | 26 +++++++++++++++++++++++---
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/test b/test
index 338c2db44fa7..ff403293d60b 100755
--- a/test
+++ b/test
@@ -6,7 +6,10 @@ targetdir="/var/tmp"
 logdir="$targetdir"
 config=/tmp/mdadm.conf
 testdir=$PWD/tests
-system_speed_limit=`cat /proc/sys/dev/raid/speed_limit_max`
+system_speed_limit_max=0
+system_speed_limit_min=0
+test_speed_limit_min=100
+test_speed_limit_max=500
 devlist=
 
 savelogs=0
@@ -39,10 +42,6 @@ ctrl_c() {
 	ctrl_c_error=1
 }
 
-restore_system_speed_limit() {
-	echo $system_speed_limit > /proc/sys/dev/raid/speed_limit_max
-}
-
 mdadm() {
 	rm -f $targetdir/stderr
 	case $* in
@@ -103,6 +102,7 @@ do_test() {
 		do_clean
 		# source script in a subshell, so it has access to our
 		# namespace, but cannot change it.
+		control_system_speed_limit
 		echo -ne "$_script... "
 		if ( set -ex ; . $_script ) &> $targetdir/log
 		then
diff --git a/tests/func.sh b/tests/func.sh
index b474442b6abe..221cff158f8c 100644
--- a/tests/func.sh
+++ b/tests/func.sh
@@ -136,6 +136,23 @@ check_env() {
 	fi
 }
 
+record_system_speed_limit() {
+	system_speed_limit_max=`cat /proc/sys/dev/raid/speed_limit_max`
+	system_speed_limit_min=`cat /proc/sys/dev/raid/speed_limit_min`
+}
+
+# To avoid sync action finishes before checking it, it needs to limit
+# the sync speed
+control_system_speed_limit() {
+	echo $test_speed_limit_min > /proc/sys/dev/raid/speed_limit_min
+	echo $test_speed_limit_max > /proc/sys/dev/raid/speed_limit_max
+}
+
+restore_system_speed_limit() {
+	echo $system_speed_limit_min > /proc/sys/dev/raid/speed_limit_max
+	echo $system_speed_limit_max > /proc/sys/dev/raid/speed_limit_max
+}
+
 do_setup() {
 	trap cleanup 0 1 3 15
 	trap ctrl_c 2
@@ -214,6 +231,7 @@ do_setup() {
 	ulimit -c unlimited
 	[ -f /proc/mdstat ] || modprobe md_mod
 	echo 0 > /sys/module/md_mod/parameters/start_ro
+	record_system_speed_limit
 }
 
 # check various things
@@ -265,15 +283,17 @@ check() {
 		fi
 	;;
 	wait )
-		p=`cat /proc/sys/dev/raid/speed_limit_max`
-		echo 2000000 > /proc/sys/dev/raid/speed_limit_max
+		min=`cat /proc/sys/dev/raid/speed_limit_min`
+		max=`cat /proc/sys/dev/raid/speed_limit_max`
+		echo 200000 > /proc/sys/dev/raid/speed_limit_max
 		sleep 0.1
 		while grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat ||
 			grep -v idle > /dev/null /sys/block/md*/md/sync_action
 		do
 			sleep 0.5
 		done
-		echo $p > /proc/sys/dev/raid/speed_limit_max
+		echo $min > /proc/sys/dev/raid/speed_limit_min
+		echo $max > /proc/sys/dev/raid/speed_limit_max
 	;;
 	state )
 		grep -sq "blocks.*\[$2\]\$" /proc/mdstat ||
-- 
2.32.0 (Apple Git-132)

