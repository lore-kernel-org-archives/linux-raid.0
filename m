Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A02F1EBA09
	for <linux-raid@vger.kernel.org>; Tue, 11 Mar 2025 05:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741669430; cv=none; b=d4p4zSTxI3DyUKu+ozxqTNXr5GvChe9o26I+61P/hKZepn9pKMj4F/JFj8diZcZtr2Sl9r4XYunMSSgj0ZcYB6cYhM1fV23xixlp6SsDb0fHMj3e0Jb/LimesaHRS/e6WOEdrbeUIPZwBKBQlXLZ5X/d5U/kzo1xmCIGotmOuR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741669430; c=relaxed/simple;
	bh=wh3NI5MWM1VASL560o948AhOFg2rJnghRDP2R5N3n5k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V88K4a11W1j1QyKboeIsdS2O7zzDkWcMHYyH0ru2tqmTCSOTY4KhZ5nChkD2HfBF9g45jEMjvTAwycYgg7XABA1Z/SUde4eha1LV1Qvl5LU/B+kJ83Mg5EkSYh8LgpJ6015g+ZpvYLHVpLw55L7Zhc8HiiRGAIzenqNnLPxhAro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SDZ5jZ7O; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SDZ5jZ7O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741669427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ARL+5PsxLQ/LCmZV1omlifJFAPKs4A+cEL0dR6IAXr8=;
	b=SDZ5jZ7OAC8m6wrG3ugxu2ObZJ8oM9t71V1IvH9z5QnvHzcWssWTmpSHDzGBCwbj/KFtKe
	ooAjsQfqJrSR+l27r1ypPZ0Db7bVm2GZoaK4d3ng26iYu97cRVAcCsMb662lKwNmwsuZiE
	0Z68Nasrj9YidbjTMJ9SGmhXeXeWEWo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-260-yUyBY2m6NFqBOx6HGbpRGA-1; Tue,
 11 Mar 2025 01:03:46 -0400
X-MC-Unique: yUyBY2m6NFqBOx6HGbpRGA-1
X-Mimecast-MFC-AGG-ID: yUyBY2m6NFqBOx6HGbpRGA_1741669425
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4037A180AF52;
	Tue, 11 Mar 2025 05:03:45 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.22])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 645771800268;
	Tue, 11 Mar 2025 05:03:41 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: mariusz.tkaczyk@linux.intel.com,
	ncroxon@redhat.com,
	blazej.kucman@linux.intel.com
Subject: [PATCH 3/4] mdadm/tests: ddf template fix
Date: Tue, 11 Mar 2025 13:03:26 +0800
Message-Id: <20250311050327.4889-4-xni@redhat.com>
In-Reply-To: <20250311050327.4889-1-xni@redhat.com>
References: <20250311050327.4889-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

If it's a device mapper device, bd is null. So use the result from
/proc/mounts directly.

For example:
grep ' / ' /proc/mounts | awk '{print }' ->
/dev/mapper/rhel_storageqe--104-root
lsblk -no PKNAME /dev/mapper/rhel_storageqe--104-root -> null

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/env-ddf-template | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tests/env-ddf-template b/tests/env-ddf-template
index 4f4ad0f32c0c..ebc0ebf3ab1e 100644
--- a/tests/env-ddf-template
+++ b/tests/env-ddf-template
@@ -3,8 +3,7 @@ sha1_sum() {
 }
 
 get_rootdev() {
-    local part=$(grep ' / ' /proc/mounts | awk '{print $1}')
-    local bd=/dev/$(lsblk -no PKNAME $part)
+    local bd=$(grep ' / ' /proc/mounts | awk '{print $1}')
     [ -b $bd ] || exit 1
     echo $bd
 }
-- 
2.32.0 (Apple Git-132)

