Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3010580628
	for <linux-raid@vger.kernel.org>; Wed, 22 May 2024 08:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716367882; cv=none; b=Muh2XCOI9jixgzOowlWzXX2KsA6xJlIDjsAd1ebAQ+9VrQHoVYhFTZgo/+rlUd0hc8jdoZunjq3CYfwBdxjEDkvyHDYF4Lhtv2T8m8/jTDihMs1mR9+5S7P/g/Omw4xUstEPX9tyqSTc077HzV1aJR3TyC8zbqoGY6WLU1O3Jcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716367882; c=relaxed/simple;
	bh=Zt9kZZje5RvDpp1t3Ang0h0IfxQHSgezXSLuGtpvGjw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PBn5e1hILuKyuZGjhUeJZwHconPh5k6fFkF1O+Tk5nF5c4//h4P/X3H6VSRRwPpwiDigjOnYtc2VZ0c5wxxaWx7IiYKC0mYTG+Bn/po6Ojh+RRlL9GutqmeF+fpnGma4/1eFPP1s/CkaqernvVpxYE42XEztHO3vvtca9sDZgnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZGWcIJaj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZGWcIJaj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716367880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YEHAuPusEdx7cCLdFiApOE3Y4WyLKL0xNXnyajxT2Uo=;
	b=ZGWcIJaj9g5XpROWjZGmYXILUsxLJxusDgsa6i5FMMjzW4gh+BdoVYhjNhllHz8+zPeldC
	Hl40/df8aDAYDa9aiUHZcdNJPhHibtEzFeYpru+Tq9DzBAQWCU2dZ9bqHKACy543JBUn4r
	hXe/TsczZzt2mUjw0swaKr3HlAAf+lw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-315-DwmhbsZgMh6iMMze3kBg2w-1; Wed, 22 May 2024 04:51:18 -0400
X-MC-Unique: DwmhbsZgMh6iMMze3kBg2w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EADA81227E;
	Wed, 22 May 2024 08:51:18 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.11])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 37E5DC15BB9;
	Wed, 22 May 2024 08:51:15 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	heinzm@redhat.com,
	ncroxon@redhat.com
Subject: [PATCH 06/19] mdadm/tests: names_template enhance
Date: Wed, 22 May 2024 16:50:43 +0800
Message-Id: <20240522085056.54818-7-xni@redhat.com>
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

For super1, if the length of hostname is >= 32, it doesn't add hostname
in metadata name. Fix this problem by checking the length of hostname.
Because other cases may use need to check this, so do the check in
do_setup.

And this patch adds a check if link /dev/md/name exists.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 test                           |  5 +++++
 tests/func.sh                  | 13 +++++++++++++
 tests/templates/names_template | 14 ++++++++++++--
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/test b/test
index 3da53f871122..814ce1992b0c 100755
--- a/test
+++ b/test
@@ -11,6 +11,11 @@ system_speed_limit_min=0
 test_speed_limit_min=100
 test_speed_limit_max=500
 devlist=
+# If super1 metadata name doesn't have the same hostname with machine,
+# it's treated as foreign.
+# For example, /dev/md0 is created, stops it, then assemble it, the
+# device node will be /dev/md127 (127 is choosed by mdadm autumatically)
+is_foreign="no"
 
 savelogs=0
 exitonerror=1
diff --git a/tests/func.sh b/tests/func.sh
index 221cff158f8c..cfe83e552a2a 100644
--- a/tests/func.sh
+++ b/tests/func.sh
@@ -153,6 +153,18 @@ restore_system_speed_limit() {
 	echo $system_speed_limit_max > /proc/sys/dev/raid/speed_limit_max
 }
 
+is_raid_foreign() {
+
+	# If the length of hostname is >= 32, super1 doesn't use
+	# hostname in metadata
+	hostname=$(hostname)
+	if [ `expr length $(hostname)` -lt 32 ]; then
+		is_foreign="no"
+	else
+		is_foreign="yes"
+	fi
+}
+
 do_setup() {
 	trap cleanup 0 1 3 15
 	trap ctrl_c 2
@@ -232,6 +244,7 @@ do_setup() {
 	[ -f /proc/mdstat ] || modprobe md_mod
 	echo 0 > /sys/module/md_mod/parameters/start_ro
 	record_system_speed_limit
+	is_raid_foreign
 }
 
 # check various things
diff --git a/tests/templates/names_template b/tests/templates/names_template
index 1b6cd14bf51d..88ad5b8c6b38 100644
--- a/tests/templates/names_template
+++ b/tests/templates/names_template
@@ -30,6 +30,7 @@ function names_verify() {
 	local DEVNODE_NAME="$1"
 	local WANTED_LINK="$2"
 	local WANTED_NAME="$3"
+	local EXPECTED=""
 
 	local RES="$(mdadm -D --export $DEVNODE_NAME | grep MD_DEVNAME)"
 	if [[ "$?" != "0" ]]; then
@@ -38,7 +39,12 @@ function names_verify() {
 	fi
 
 	if [[ "$WANTED_LINK" != "empty" ]]; then
-		local EXPECTED="MD_DEVNAME=$WANTED_LINK"
+		EXPECTED="MD_DEVNAME=$WANTED_LINK"
+
+		if [ ! -b /dev/md/$WANTED_LINK ]; then
+			echo "/dev/md/$WANTED_LINK doesn't exit"
+			exit 1
+		fi
 	fi
 
 	if [[ "$RES" != "$EXPECTED" ]]; then
@@ -52,7 +58,11 @@ function names_verify() {
 		exit 1
 	fi
 
-	local EXPECTED="MD_NAME=$(hostname):$WANTED_NAME"
+	if [ $is_foreign == "no" ]; then
+		EXPECTED="MD_NAME=$(hostname):$WANTED_NAME"
+	else
+		EXPECTED="MD_NAME=$WANTED_NAME"
+	fi
 	if [[ "$RES" != "$EXPECTED" ]]; then
 		echo "$RES doesn't match $EXPECTED."
 		exit 1
-- 
2.32.0 (Apple Git-132)

