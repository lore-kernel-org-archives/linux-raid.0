Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98097F486
	for <linux-raid@vger.kernel.org>; Wed, 22 May 2024 08:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716367879; cv=none; b=gyUQYPB128cLoqOQxB5exZ9rXOLno6CCqJZF/5gTS9MC5ju4oZvBXM6rq8RcylX4xd9uNPG6yPfMDlm3hVKSqlQsCwZOU96R+VajGYfuM2ioUOHxCAsrc33evYKVrXc8KtCs0s/OqpipAOSl3EVuU1XRqzH3NGb8x75WZ5biZ8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716367879; c=relaxed/simple;
	bh=mpV+FUYQDamOUAqmuTpFFOI5DYVWGMxFSHTKzYtqqyM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tAxnoqB/bn9/2x3UTEM5vZzyrCvNhCBV8w9Vr01MDK4uQnPHJhk3UpRnTzNgHysmJKOn7R+q01ztkb6/zykbrAZESLaZi+qzrNjBElw9Qd6SrYIiB2zLfxFy59UobG/dKRamoyDv1BBQIoY4UnhR3EjJkUFo4sVZCdGNPvDoSLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jWcd0rEO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jWcd0rEO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716367876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4acbDdOAxd10ZWCSOH++imn4YKmDBzD73Trmf+POX2w=;
	b=jWcd0rEOzQksRj4wsSk++cSSRPfiqA0IGC9T7TU1qK8Cegjt5n5AlWby0aE8zmtlclA4Ah
	otWRKpUAmpm59i4wfiHM7uOAOvxyvjxW3n/o1s57HD5BmdKwbtd6z54lZWvAE5bt3fYiQ1
	zMwwlLuQ8a1AT4Gx5ZNpjuBY9BOvUAY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-422-HXeRoEwDM8-B-9Zq6pTCbA-1; Wed,
 22 May 2024 04:51:15 -0400
X-MC-Unique: HXeRoEwDM8-B-9Zq6pTCbA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82D7629AA3AD;
	Wed, 22 May 2024 08:51:15 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.11])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 687C8C15BB9;
	Wed, 22 May 2024 08:51:13 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	heinzm@redhat.com,
	ncroxon@redhat.com
Subject: [PATCH 05/19] mdadm/tests: test don't fail when systemd reports error
Date: Wed, 22 May 2024 16:50:42 +0800
Message-Id: <20240522085056.54818-6-xni@redhat.com>
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

Sometimes systemd reports error in dmesg and test fails. Add
a condition to avoid this failure.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 test | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test b/test
index ff403293d60b..3da53f871122 100755
--- a/test
+++ b/test
@@ -109,7 +109,7 @@ do_test() {
 			if [ -f "${_script}.inject_error" ]; then
 				echo "dmesg checking is skipped because test inject error"
 			else
-				dmesg | grep -iq "error\|call trace\|segfault" &&
+				dmesg | grep -iq "error\|call trace\|segfault" | grep -v "systemd" &&
 					die "dmesg prints errors when testing $_basename!"
 			fi
 			echo "succeeded"
-- 
2.32.0 (Apple Git-132)

