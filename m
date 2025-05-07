Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1E025EFB5
	for <linux-raid@vger.kernel.org>; Wed,  7 May 2025 12:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746620416; cv=none; b=Ux076cQx2ihzlHLLFvoJJ1Z7bE0v3W1w3UL+qC11qgsMIXAzvJv89RTmFFK2X25A/L1/VU0Ock5xcaP55LgDbS49na1be7Zd8NAwkl4+xthq5gYJoqg/sYvxrtiTKtxqF3dHEO8b6Zvq2kOI9FCtySCSD9kLzxpGSpqQnCz8eX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746620416; c=relaxed/simple;
	bh=VngPe3dI7ITA/emTpLWSilTKSutCQKfKWo6r9bIw38U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jvApeMFmVeWfYAK82H25CZ9CR6BO3+XsgpRlSl18rGEYFbRNYIUPa+2pXA2h/3f5R2i17HHDhD7SiZR5jwjak9x9AAe8Ox/gnEsmUCuvPghemunfCPEm0ecJBqDobSBK8gfed0v2dXPnbqR1g3VbpaoRdaJAltXiwrEzIj8XzjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZUo+/BhH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZUo+/BhH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746620413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5SpRsNnLDhtYMoKXicvlGkPPqsWFkI2GBB+Cap8p/Ac=;
	b=ZUo+/BhHlPXyMX/M5bCgq06rNNfN9zGtJEGbYe78XnVcwzeAPxzAoe82P8wY28/IJqPxLl
	Kk/Wuy8mYeZs5v+87QH0V8PbFDLcwH9psaICMXWWyWNSorghWx7dVMgxrwJXZyfOBGAf7y
	XxF0riji3fvXNBuKK41YsKQXSCX7rQA=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-664-auZH09y_PGa-Y8ANZzgnnA-1; Wed,
 07 May 2025 08:20:12 -0400
X-MC-Unique: auZH09y_PGa-Y8ANZzgnnA-1
X-Mimecast-MFC-AGG-ID: auZH09y_PGa-Y8ANZzgnnA_1746620411
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5EF211955D45;
	Wed,  7 May 2025 12:20:11 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.7])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3D5331956058;
	Wed,  7 May 2025 12:20:08 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: mtkaczyk@kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 1/3] mdadm: use standard libc nftw
Date: Wed,  7 May 2025 20:20:00 +0800
Message-Id: <20250507122002.20826-2-xni@redhat.com>
In-Reply-To: <20250507122002.20826-1-xni@redhat.com>
References: <20250507122002.20826-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

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

