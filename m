Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA6015B99E
	for <linux-raid@vger.kernel.org>; Thu, 18 Apr 2024 10:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713435824; cv=none; b=d2gAbPlfEuFU1HeGsco1DfOT8rU1rpzcmlPP9Thx+zGhlmsyk1+kGwcSbi19fol+KGWEpRlfoqIfWqiJC47NZfw3dIPt+Y8dYed16LiCG8zjTsVAowOG01O36dwZf2gLUv8d4rkfZiRUqpEkblvQ9R4qyTnlLlYDfGGutIpolUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713435824; c=relaxed/simple;
	bh=0ime0OeMQ0fyDzzUQ9ElIvA1IrdMHn0mTD1kfgy0U2M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bXtPeMtazn4457j5KlgxXmVsafbMb4UDpma892llv3Gs77VI5Igw8WZdTOOdR+ou4m8cp2N+ar3HSGwq/XWnDPrWBqfJDgpZyNnWPJ5PZfoYrN6TW49AnLXJrTNnNIPgkidf+4fAyZyBSyexVMuXCal2kzqTK6dYfuNqttowVS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M5ctT7Ag; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M5ctT7Ag"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713435822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qv0BhHNERyA0kgVeE7lCSPXvLcamv/eInAMyJMlLw/Y=;
	b=M5ctT7AgXGBgG+7T07BiOH5AINbxp1lwTuhNWpPdX2kALBXFRouL52eAmjTMtecuMBepJ6
	HmuovlOi8s5/tlcGBUBRkTKw8XtvaoN1WFYL32vAf0DjFWrYrcFpm4/s51d8IX8ctRNlYr
	iO7Uk76Vc/mzVtd5aKZInz2NYqh89zI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-604-6DKntCfRPn2EV5tqE2s7EQ-1; Thu,
 18 Apr 2024 06:23:39 -0400
X-MC-Unique: 6DKntCfRPn2EV5tqE2s7EQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05C491C3F0E2;
	Thu, 18 Apr 2024 10:23:39 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.2])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DCB5E1C060D0;
	Thu, 18 Apr 2024 10:23:35 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	song@kernel.org,
	yukuai1@huaweicloud.com,
	ncroxon@redhat.com,
	colyli@suse.de,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 3/5] tests/01r5fail enhance
Date: Thu, 18 Apr 2024 18:23:19 +0800
Message-Id: <20240418102321.95384-4-xni@redhat.com>
In-Reply-To: <20240418102321.95384-1-xni@redhat.com>
References: <20240418102321.95384-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

After removing dev0, the recovery starts because it already has a spare
disk. It's good to check recovery. But it's not right to check recovery
after adding dev3. Because the recovery may finish. It depends on the
recovery performance of the testing machine. If the recovery finishes,
it will fail. But dev3 is only added as a spare disk, we can't expect
there is a recovery happens.

So remove the codes about adding dev3.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/01r5fail | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/tests/01r5fail b/tests/01r5fail
index 873dba585e58..c210d6e747f2 100644
--- a/tests/01r5fail
+++ b/tests/01r5fail
@@ -17,11 +17,7 @@ check wait
 mdadm $md0 --fail $dev0
 mdadm $md0 --remove $dev3 $dev0
 check recovery
-check state _UUU
-
-mdadm $md0 -a $dev3
-check recovery
 check wait
 check state UUUU
 
-mdadm -S $md0
\ No newline at end of file
+mdadm -S $md0
-- 
2.32.0 (Apple Git-132)

