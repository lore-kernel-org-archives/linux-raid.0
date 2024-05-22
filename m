Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD38046522
	for <linux-raid@vger.kernel.org>; Wed, 22 May 2024 08:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716367913; cv=none; b=HVNxlY9TwMwy57fys/eRFGXSfkD19k2RLLz6/hgPiAKL9DqOXOvtHRIvrfLxbsXJRFCa8zQqR9Epj5IrCluJQ7VcUsZSLYIXfO2owiRaQP1QL96xx5Kund2UPWU7AEi9zt0OdD1HHyhRLJkVykOmdZOQ8zD6LaQMaP/xPXmXhjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716367913; c=relaxed/simple;
	bh=SOZ59asLs27lMDTwpwYPIfrmXcSoq+KoQgz8ezZHN2s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EQn4Pl3+QgfU7rGi1HK+Wx8tCZ/nslu9XLvI83Ptqc627K2sYAstN1MJxU19nnwVXHx6SBDNPvKYxPOmrJNV2tMlLVNVm5/BF5yZgXT3LEYZHG+yVFxhzseFrFMldJJHwZwaF8rWjgH5jK4A+seQcwJojjRevzmYXGMfYJmJtRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YBUk8veQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YBUk8veQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716367910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OVO7qCTniPvXgcAneiPeJ8scOpW7Dk2H/zPoE1J8DSQ=;
	b=YBUk8veQZMn6Md9Y/5ZY+XJxb4hUv08xX+DicTFKmsSaF/AeXxVYEXOlow/bozBmPdow7o
	s4qSDnWWRhGIOBBN64OGldJDFPN93/uWwwHCdMRc5fN4d6uclMviy0AAc8rYvSvpyfD03V
	yADSEIwtQU9VtNhxqIPeEK2s1CBFOI4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-329-__w5f3ypP-io3QihPszqBQ-1; Wed,
 22 May 2024 04:51:47 -0400
X-MC-Unique: __w5f3ypP-io3QihPszqBQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C552A3C025BE;
	Wed, 22 May 2024 08:51:46 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.11])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B05C0C15BB1;
	Wed, 22 May 2024 08:51:44 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	heinzm@redhat.com,
	ncroxon@redhat.com
Subject: [PATCH 16/19] mdadm/tests: 07autoassemble
Date: Wed, 22 May 2024 16:50:53 +0800
Message-Id: <20240522085056.54818-17-xni@redhat.com>
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

This test is used to test stacked array auto assemble.

There are two different cases depends on if array is foreign or not.
If the array is foreign, the stacked array (md0 is on md1 and md2)
can't be assembled with name md0. Because udev rule will run when md1
and md2 are assembled and mdadm -I doesn't specify homehost. So it
will treat stacked array (md0) as foreign array and choose md127 as
the device node name (/dev/md127)

Add the case that stacked array is local.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 test                        |  2 ++
 tests/07autoassemble        | 37 +++++++++++++++++++++++++++++++++++--
 tests/07autoassemble.broken |  8 --------
 3 files changed, 37 insertions(+), 10 deletions(-)
 delete mode 100644 tests/07autoassemble.broken

diff --git a/test b/test
index f09994e78107..4a88de58fdf5 100755
--- a/test
+++ b/test
@@ -39,6 +39,8 @@ md2=/dev/md2
 # if user doesn't specify minor number, mdadm chooses minor number
 # automatically from 127.
 md127=/dev/md127
+md126=/dev/md126
+md125=/dev/md125
 mdp0=/dev/md_d0
 mdp1=/dev/md_d1
 
diff --git a/tests/07autoassemble b/tests/07autoassemble
index e689be7c4a10..9dc781497070 100644
--- a/tests/07autoassemble
+++ b/tests/07autoassemble
@@ -10,7 +10,14 @@ mdadm -Ss
 mdadm -As -c /dev/null --homehost=testing -vvv
 testdev $md1 1 $mdsize1a 64
 testdev $md2 1 $mdsize1a 64
-testdev $md0 2 $mdsize11a 512
+# md1 and md2 will be incremental assemble by udev rule. And
+# the testing machines' hostname is not testing. The md0 will
+# be considered as a foreign array. It can use 0 as metadata
+# name. md127 will be used
+testdev $md127 2 $mdsize11a 512
+mdadm --stop $md127
+mdadm --zero-superblock $md1
+mdadm --zero-superblock $md2
 mdadm -Ss
 
 mdadm --zero-superblock $dev0 $dev1 $dev2 $dev3
@@ -20,5 +27,31 @@ mdadm -CR $md0 -l0 -n2 $md1 $dev2  --homehost=testing
 mdadm -Ss
 mdadm -As -c /dev/null --homehost=testing -vvv
 testdev $md1 1 $mdsize1a 64
-testdev $md0 1 $[mdsize1a+mdsize11a] 512
+testdev $md127 1 $[mdsize1a+mdsize11a] 512
+mdadm --stop $md127
+mdadm --zero-superblock $md1
+mdadm -Ss
+
+# Don't specify homehost when creating raid and use the test
+# machine's homehost. For super1.2, if homehost name's length
+# is > 32, it doesn't use homehost name in metadata name and
+# the array will be treated as foreign array
+mdadm --zero-superblock $dev0 $dev1 $dev2 $dev3
+mdadm -CR $md1 -l1 -n2 $dev0 $dev1
+mdadm -CR $md2 -l1 -n2 $dev2 $dev3
+mdadm -CR $md0 -l0 -n2 $md1 $md2
+mdadm -Ss
+mdadm -As -c /dev/null
+if [ $is_foreign == "yes" ]; then
+	# md127 is md1
+	testdev $md127 1 $mdsize1a 64
+	# md126 is md0, udev rule incremental assemble it
+	testdev $md126 2 $mdsize11a 512
+	# md125 is md2
+	testdev $md125 1 $mdsize1a 64
+else
+	testdev $md1 1 $mdsize1a 64
+	testdev $md2 1 $mdsize1a 64
+	testdev $md0 2 $mdsize11a 512
+fi
 mdadm -Ss
diff --git a/tests/07autoassemble.broken b/tests/07autoassemble.broken
deleted file mode 100644
index 8be09407f628..000000000000
--- a/tests/07autoassemble.broken
+++ /dev/null
@@ -1,8 +0,0 @@
-always fails
-
-Prints lots of messages, but the array doesn't assemble. Error
-possibly related to:
-
-  mdadm: /dev/md/1 is busy - skipping
-  mdadm: no recogniseable superblock on /dev/md/testing:0
-  mdadm: /dev/md/2 is busy - skipping
-- 
2.32.0 (Apple Git-132)

