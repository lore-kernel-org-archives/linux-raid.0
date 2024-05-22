Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0021C8061D
	for <linux-raid@vger.kernel.org>; Wed, 22 May 2024 08:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716367901; cv=none; b=Ftb7pSy3jFjkbMu/RPetBaMKu2xi0zGQnX5/28PNgRqa3HmjWqaelPXv4WM3LWIkY3GP+BK50rpF4vTw21ggdKAeaPGnwWr2Wz6Sqmi0CxeaRgqtAwIcthV4wAsapuKUXTwaw5h4/cyXLoI7V9jczL8SM2uZeK3ZlDd7vaPM8dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716367901; c=relaxed/simple;
	bh=nE9N3R3u/QOVcgko8IDM2ORatbLD5kaH/IaycOUPdBA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CjN5p9T62y1iB8uGcDU+UZiBQILSEwQis5R5zp//ecklhxHBMwHyByAz44BCehI3/IpdZ03fp8/NdD0PEwxlC5jDa/37ssMEiHWLnsCpkMUzWaF1KS8XhrBIqoXXERH1PYJHTRpg0xxwVlD0PD/Ph4OMbnlsBtqruc9qF9czxxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RPsL3pV3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RPsL3pV3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716367899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WTcVoEJwggvtKBTdZqG77P43Xyr1obP5tzEjjukDYWA=;
	b=RPsL3pV3tXRXDU95yCSS3efUGSerfJ6rIXGKhzBr6wYsKZwd/lKqXHXU1ZAde/lyogNzvI
	kWcHRn2lbY1wt5zoVwip63tTN87QgBEHcOfcOiEUKxNYHiwEiV5baW+UShoMm9BwSi4oko
	EhuKiH4+3+ovbLm/MxcwibKo4zNWJtw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-5vipM5KvP_KYCbERWieoaA-1; Wed, 22 May 2024 04:51:35 -0400
X-MC-Unique: 5vipM5KvP_KYCbERWieoaA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CD1A800994;
	Wed, 22 May 2024 08:51:35 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.11])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7DA43C15BB1;
	Wed, 22 May 2024 08:51:33 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	heinzm@redhat.com,
	ncroxon@redhat.com
Subject: [PATCH 12/19] tests/04update-metadata skip linear
Date: Wed, 22 May 2024 16:50:49 +0800
Message-Id: <20240522085056.54818-13-xni@redhat.com>
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

Add one check that if kernel doesn't support linear/multipath, it can
skip linear/multipath testing.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 test                    |  3 +++
 tests/04update-metadata | 35 ++++++++++++++++++++---------------
 tests/func.sh           |  2 ++
 3 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/test b/test
index 1fce6be2c4a9..f09994e78107 100755
--- a/test
+++ b/test
@@ -17,6 +17,9 @@ devlist=
 # device node will be /dev/md127 (127 is choosed by mdadm autumatically)
 is_foreign="no"
 
+skipping_linear="no"
+skipping_multipath="no"
+
 savelogs=0
 exitonerror=1
 ctrl_c_error=0
diff --git a/tests/04update-metadata b/tests/04update-metadata
index 2b72a303b6a0..c748770cfda7 100644
--- a/tests/04update-metadata
+++ b/tests/04update-metadata
@@ -8,24 +8,29 @@ set -xe
 
 dlist="$dev0 $dev1 $dev2 $dev3"
 
-for ls in linear/4 raid1/1 raid5/3 raid6/2
+if [ $skipping_linear == "yes" ]; then
+	level_list="raid1/1 raid5/3 raid6/2"
+else
+	level_list="linear/4 raid1/1 raid5/3 raid6/2"
+fi
+for ls in $level_list
 do
-  s=${ls#*/} l=${ls%/*}
-  if [[ $l == 'raid1' ]]; then
-	mdadm -CR --assume-clean -e 0.90 $md0 --level $l -n 4 $dlist
-  else
-	mdadm -CR --assume-clean -e 0.90 $md0 --level $l -n 4 -c 64 $dlist
-  fi
-  testdev $md0 $s 19904 64
-  mdadm -S $md0
-  mdadm -A $md0 --update=metadata $dlist
-  testdev $md0 $s 19904 64 check
-  mdadm -S $md0
+	s=${ls#*/} l=${ls%/*}
+	if [[ $l == 'raid1' ]]; then
+		mdadm -CR --assume-clean -e 0.90 $md0 --level $l -n 4 $dlist
+	else
+		mdadm -CR --assume-clean -e 0.90 $md0 --level $l -n 4 -c 64 $dlist
+	fi
+	testdev $md0 $s 19904 64
+	mdadm -S $md0
+	mdadm -A $md0 --update=metadata $dlist
+	testdev $md0 $s 19904 64 check
+	mdadm -S $md0
 done
 
 if mdadm -A $md0 --update=metadata $dlist
 then echo >&2 should fail with v1.0 metadata
-     exit 1
+	exit 1
 fi
 
 mdadm -CR -e 0.90 $md0 --level=6 -n4 -c32 $dlist
@@ -33,7 +38,7 @@ mdadm -S $md0
 
 if mdadm -A $md0 --update=metadata $dlist
 then echo >&2 should fail during resync
-     exit 1
+	exit 1
 fi
 mdadm -A $md0 $dlist
 mdadm --wait $md0 || true
@@ -48,5 +53,5 @@ mdadm -S $md0
 
 if mdadm -A $md0 --update=metadata $dlist
 then echo >&2 should fail when bitmap present
-     exit 1
+	exit 1
 fi
diff --git a/tests/func.sh b/tests/func.sh
index cfe83e552a2a..db55542d4011 100644
--- a/tests/func.sh
+++ b/tests/func.sh
@@ -125,6 +125,7 @@ check_env() {
 		MULTIPATH="yes"
 	if [ "$MULTIPATH" != "yes" ]; then
 		echo "test: skipping tests for multipath, which is removed in upstream 6.8+ kernels"
+		skipping_multipath="yes"
 	fi
 
 	# Check whether to run linear tests
@@ -133,6 +134,7 @@ check_env() {
 		LINEAR="yes"
 	if [ "$LINEAR" != "yes" ]; then
 		echo "test: skipping tests for linear, which is removed in upstream 6.8+ kernels"
+		skipping_linear="yes"
 	fi
 }
 
-- 
2.32.0 (Apple Git-132)

