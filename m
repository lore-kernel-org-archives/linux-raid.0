Received: from mvsmtppost03.nm.naver.com (mvsmtppost03.nm.naver.com [61.247.196.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05860201021
	for <linux-raid@vger.kernel.org>; Thu,  9 Jan 2025 06:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.247.196.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736405705; cv=none; b=eymtw9wFRg6bsyRxCgDsnlvfUgTI31c0Aec4LukqpxeQJ9lEYXa3IqMSmlCMFeY378jWdsSE2TdV9Kisn1DTN9+Uu5eaqKepnHQDB8sHThnsAsBkm9aD6SB7gOKhABGUtt2B60w2jDZCcybBHQXAUgwXOm9wfgjBK4thqDDq9Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736405705; c=relaxed/simple;
	bh=msvf7d7I3eNITLfI3auDjP9zx1GfVfrNoxv9h80dHGA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n7i699xCFIXlHo1J7gA5ryv4fWHEk3LFUSnx+nwNi29Q0qIxKPQd0z9fKqPwrVP630dgbvq8KUfmS8nev59Y4qxbgx3BvXKe4Ux55FEYbbR/iSoA9Wb+xP0QHaQgpr/EL1SiXi9yQhmGHRzKbOcNICzxFLKbq7cGNcuM4kQe/+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com; spf=pass smtp.mailfrom=naver.com; dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b=tgczGl5n; arc=none smtp.client-ip=61.247.196.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b="tgczGl5n"
Received: from cvsendbo012.nm ([10.112.24.38])
  by mvsmtppost03.nm.naver.com with ESMTP id RQRMgS2kQjaPVaowPME-oQ
  for <linux-raid@vger.kernel.org>;
  Thu, 09 Jan 2025 06:34:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1736404486; bh=msvf7d7I3eNITLfI3auDjP9zx1GfVfrNoxv9h80dHGA=;
	h=From:To:Subject:Date:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=tgczGl5nJfOJjDJdGBBcy1x1F+mrDOLZ1kyF23V4oKgPLWW0kjWS9P3r19IKH/kHh
	 KiD7Kmyq9dho/2X1imqREN9d24mQY403KkTno27u3DAPX5BfWCZAdRrKMk2pTGC9fu
	 /yX9lxePdcRgnCd/6Bw9Y248W8dgPwIV7gE0+6zGN6zvz0fZmXTIuJ7PWdNWJJlXQF
	 UFC2/tdInzbCpxJvrPFiS68CZuSv0m2fIfhMkpSn2vkyucGCV0cFp/03uZVNhkqmQN
	 eeD5Dw38XAPJumpJXxeoYQgeU/Q5lNC4guGC3mZehvhH/y38hZ2LwDzq9KYLt6jdVC
	 LL6UV95ifoQ0w==
X-Session-ID: mMu+6aZ2SOyLW-6d3y70yw
X-Works-Send-Opt: k/YdjAJYjHmlKxu/FoJYKxgXKBwkx0eFjAJYKg==
X-Works-Smtp-Source: sZYXKqMqFqJZ+Hm9aAgZ+6E=
Received: from Linux.. ([125.132.232.68])
  by cvnsmtp012.nm.naver.com with ESMTP id mMu+6aZ2SOyLW-6d3y70yw
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Thu, 09 Jan 2025 06:34:45 -0000
From: Cherniaev Andrei <dungeonlords789@naver.com>
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	song@kernel.org,
	Cherniaev Andrei <dungeonlords789@naver.com>
Subject: [PATCH 1/1] md: Fix typo in comment
Date: Thu,  9 Jan 2025 15:34:44 +0900
Message-ID: <20250109063444.865682-1-dungeonlords789@naver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Cherniaev Andrei <dungeonlords789@naver.com>
---
 include/uapi/linux/raid/md_p.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index 5a43c23f53bf..36a3394e5066 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -76,10 +76,10 @@
 #define MD_DISK_SYNC		2 /* disk is in sync with the raid set */
 #define MD_DISK_REMOVED		3 /* disk is in sync with the raid set */
 #define MD_DISK_CLUSTER_ADD     4 /* Initiate a disk add across the cluster
-				   * For clustered enviroments only.
+				   * For clustered environments only.
 				   */
 #define MD_DISK_CANDIDATE	5 /* disk is added as spare (local) until confirmed
-				   * For clustered enviroments only.
+				   * For clustered environments only.
 				   */
 #define MD_DISK_FAILFAST	10 /* Send REQ_FAILFAST if there are multiple
 				    * devices available - and don't try to
-- 
2.43.0

