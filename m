Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B781622ACF3
	for <linux-raid@vger.kernel.org>; Thu,  8 May 2025 12:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746708527; cv=none; b=bS6SMFFrEEGXAagZLEb7SNLyBIell1+ykM0xMlb/gyIQBYrELIp+wC8plg34yeQMsitGQGDy2tBW/2RyGhddHl/uCH/RxWjkWTaXidFOWYjS6UpWYykJ+wI9UZWoxixLxRrCvKSDvWNDQ4ur8ak7GHudjAPcuoclAvcgwEQfTLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746708527; c=relaxed/simple;
	bh=VngPe3dI7ITA/emTpLWSilTKSutCQKfKWo6r9bIw38U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I5sozGWM5rhRtWNe5f05OMyncA1FnYQavjOj79vA/lodcRNxyGeirKUiRNra+xwXAkB4F9ABoOzRcBvTBt6pxEp8+13e/23/Ml8hndEzYBTzIaKJ8j5u5Fkj8/A3PzEngIB0tPpbALUG00UL07j9dn/TeyfNoqRKByNuDduYZyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gPC5njeM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gPC5njeM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746708524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5SpRsNnLDhtYMoKXicvlGkPPqsWFkI2GBB+Cap8p/Ac=;
	b=gPC5njeMDo/eYCCNVvhwQrep5LBqPgaudsDFioUIuqw6ZblQaT5cX9UzhhUw2TiAVc7p3X
	iUbcugjhvubNzyJ2v/wZQVSDQ/hZ3mgJ0fDDWP5KAjE2KlucGU3CXSID3n+Q1Ps+CnxSl8
	M1Z3vAHAWp9Zyu3uwH1O1niDRSyTOXs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-223-R46VacdgPJ66pj2YyISI3A-1; Thu,
 08 May 2025 08:48:41 -0400
X-MC-Unique: R46VacdgPJ66pj2YyISI3A-1
X-Mimecast-MFC-AGG-ID: R46VacdgPJ66pj2YyISI3A_1746708520
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B05521800446;
	Thu,  8 May 2025 12:48:40 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.7])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6A3D519560B3;
	Thu,  8 May 2025 12:48:38 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: mtkaczyk@kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 1/7] mdadm: use standard libc nftw
Date: Thu,  8 May 2025 20:48:25 +0800
Message-Id: <20250508124831.32742-2-xni@redhat.com>
In-Reply-To: <20250508124831.32742-1-xni@redhat.com>
References: <20250508124831.32742-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

commit bd648e3bec3d ("mdadm: Remove klibc and uclibc support") removes
macro HAVE_NFTW/HAVE_FTW and uses libc header ftw.h. But it leaves the
codes in lib.c which let mdadm command call nftw defined in lib.c. It
needs to remove these codes.

The bug can be reproduced by:
mdadm -CR /dev/md0 --level raid5 --metadata=1.1 --chunk=32 --raid-disks 3
--size 10000 /dev/loop1 /dev/loop2 /dev/loop3
mdadm /dev/md0 --grow --chunk=64
mdadm: /dev/md0: cannot open component -unknown-

Fixes: bd648e3bec3d ("mdadm: Remove klibc and uclibc support")
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 lib.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/lib.c b/lib.c
index f36ae03a3fa0..eb6cc1194cab 100644
--- a/lib.c
+++ b/lib.c
@@ -245,28 +245,6 @@ int add_dev(const char *name, const struct stat *stb, int flag, struct FTW *s)
 	return 0;
 }
 
-#ifndef HAVE_NFTW
-#ifdef HAVE_FTW
-int add_dev_1(const char *name, const struct stat *stb, int flag)
-{
-	return add_dev(name, stb, flag, NULL);
-}
-int nftw(const char *path,
-	 int (*han)(const char *name, const struct stat *stb,
-		    int flag, struct FTW *s), int nopenfd, int flags)
-{
-	return ftw(path, add_dev_1, nopenfd);
-}
-#else
-int nftw(const char *path,
-	 int (*han)(const char *name, const struct stat *stb,
-		    int flag, struct FTW *s), int nopenfd, int flags)
-{
-	return 0;
-}
-#endif /* HAVE_FTW */
-#endif /* HAVE_NFTW */
-
 /*
  * Find a block device with the right major/minor number.
  * If we find multiple names, choose the shortest.
-- 
2.32.0 (Apple Git-132)

