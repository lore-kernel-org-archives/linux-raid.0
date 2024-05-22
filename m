Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DEB7E572
	for <linux-raid@vger.kernel.org>; Wed, 22 May 2024 08:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716367916; cv=none; b=btb1zegQPME+CLZ7S8KK1N+6x9km+mawRBqr7X+vg10sKTe1gawylA+Z/H4O1uT6XYCzlAjIWR0jDLk3aH5hpqq1TWk/2PsxVbL6tRsQo6ZZMtc5iwrctSebrC/R4a96qi335Ixis7yMBOeGGFOYighXGEl/o1nUGE6qVNoaIl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716367916; c=relaxed/simple;
	bh=s1Q4rGco5SIy3LcEGwUrfKI+MtryTi2WvGd+NOxWuYA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B8Qmrxr1x68zWp2uUDznDRkc+OPFz+XYXCa/q92Ruw5k3qDvSujf7vsmxCtmowo6QOhMe+a5Z8NulSgmuDW5IMdXCStbJMhMm9sOsvkhEx6Io5Fa3wYkOg9Ue3tLqJlgc/XwWBRys4911O2Hj6Le7d+VBOUCrMG/v/BEEa1BwgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JQIwb9S8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JQIwb9S8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716367914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E2WnIGUcDlfDknpzxi7sY8IQGO68PNjb6vEiwKWTwvE=;
	b=JQIwb9S81aDJ8gofPWund94qyKK6bZ12EFT3NyGyNYSzcz/toJWI3InheaU3xepzfkgdhD
	Crq4CIQICXhR+JQgTHDTxFt1IYb928VUALk2e6sjvM0xL6WCyqnFMpGWqnAFiFxzk4HgNM
	YZ4egnMIOgOS88h3scGJEcadg8sJ5t0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-41-DE37hxM0M1a6ssJDCE3aPw-1; Wed,
 22 May 2024 04:51:52 -0400
X-MC-Unique: DE37hxM0M1a6ssJDCE3aPw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1AD9380008E;
	Wed, 22 May 2024 08:51:52 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.11])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 88847C15BB1;
	Wed, 22 May 2024 08:51:50 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	heinzm@redhat.com,
	ncroxon@redhat.com
Subject: [PATCH 18/19] mdadm/tests: 07changelevelintr
Date: Wed, 22 May 2024 16:50:55 +0800
Message-Id: <20240522085056.54818-19-xni@redhat.com>
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

It needs to specify a 2 powered array size when updating array size.
If not, it can't change chunksize.

And sometimes it reports error reshape doesn't happen. In fact the
reshape has finished. It doesn't need to wait before checking
reshape action. Because check function waits itself.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/07changelevelintr        | 9 +++++----
 tests/07changelevelintr.broken | 9 ---------
 2 files changed, 5 insertions(+), 13 deletions(-)
 delete mode 100644 tests/07changelevelintr.broken

diff --git a/tests/07changelevelintr b/tests/07changelevelintr
index 18c63092071e..d921f2b284f9 100644
--- a/tests/07changelevelintr
+++ b/tests/07changelevelintr
@@ -27,11 +27,9 @@ checkgeo() {
 }
 
 restart() {
- sleep 0.5
  check reshape
  mdadm -S $md0
  mdadm -A $md0 $devs --backup-file=$bu
- sleep 0.5
  check reshape
 }
 
@@ -49,13 +47,16 @@ mdadm -G $md0 --layout rs --backup-file=$bu
 restart
 checkgeo md0 raid5 5 $[128*1024] 3
 
-mdadm -G $md0 --array-size 58368
+# It needs to shrink array size first. Choose a value that
+# is power of 2 for array size. If not, it can't change
+# chunk size.
+mdadm -G $md0 --array-size 51200
 mdadm -G $md0 --raid-disks 4 -c 64 --backup-file=$bu
 restart
 checkgeo md0 raid5 4 $[64*1024] 3
 
 devs="$dev0 $dev1 $dev2 $dev3"
-mdadm -G $md0 --array-size 19456
+mdadm -G $md0 --array-size 18432
 mdadm -G $md0 -n 2 -c 256 --backup-file=$bu
 restart
 checkgeo md0 raid5 2 $[256*1024] 3
diff --git a/tests/07changelevelintr.broken b/tests/07changelevelintr.broken
deleted file mode 100644
index 284b49068295..000000000000
--- a/tests/07changelevelintr.broken
+++ /dev/null
@@ -1,9 +0,0 @@
-always fails
-
-Fails with errors:
-
-  mdadm: this change will reduce the size of the array.
-         use --grow --array-size first to truncate array.
-         e.g. mdadm --grow /dev/md0 --array-size 56832
-
-  ERROR: no reshape happening
-- 
2.32.0 (Apple Git-132)

