Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0751616BE20
	for <linux-raid@vger.kernel.org>; Wed, 11 Sep 2024 08:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726044901; cv=none; b=Uzl9/xsffuTGdGQ6Uv/A8uQ3F3plD27pFELAV9Q27wvhPsHnF0lcFG2QiVaJYa7o21Ttu0aqUUZW0Jop0PCX9z4iFkNmMNzQBtoKoSO9jPSgkBeT9lLOOx0+RkbqAmpPRVYIdRllLMZ2rFAP31oAca97ujOC1kIgDAjEkeCOnHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726044901; c=relaxed/simple;
	bh=q3mdBdhvEPP3XCQSyxUjsSgFizaFpUqhVjHpdv/xslg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TDGZpwJiGPsQYm4WfsNuYZhxatq8YrQiiX9OjC2L9q1rA/MrqT5tl4Pp81A5wsW9IhYjty7qVfV0u2QDwoEaWDQemGNhVFaJlZhTNZ8aKos5+s8n4KJZtQ8SYdw1LHPbfIGOuAPggdxYniGNcvlMqOeCbn3hFJ5Zrm+Dgnp1aRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XEna9D9W; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XEna9D9W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726044898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a+1VjOfx8xpJDgToWYqTQnaqNxwgZ+emJVaCvXR4SzY=;
	b=XEna9D9WBaHRigJKa/h2krbQwY40mZbI0hKZu+hYAOBniYZ7u6bw0616x9X7wKcekxkhH7
	dDnMDe4g0Ujly60Q2HptZremqxG50nTYu87/wqYMZu+6epZkGmRkIFmG6mav+YuhmSIcCy
	zd+2jp3vFoZp5Sz/0kUaPfdVHUxP7o4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-18-q8QuZA-BPOSbOJE0bvPLKg-1; Wed,
 11 Sep 2024 04:54:57 -0400
X-MC-Unique: q8QuZA-BPOSbOJE0bvPLKg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A818619773C6;
	Wed, 11 Sep 2024 08:54:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.25])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 28AA11956086;
	Wed, 11 Sep 2024 08:54:52 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 05/10] mdadm/tests: wait until level changes
Date: Wed, 11 Sep 2024 16:54:27 +0800
Message-Id: <20240911085432.37828-6-xni@redhat.com>
In-Reply-To: <20240911085432.37828-1-xni@redhat.com>
References: <20240911085432.37828-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

check wait waits reshape finishes, but it doesn't wait level changes.
The level change happens in a forked child progress. So we need to
search the child progress and monitor it.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/05r6tor0 | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tests/05r6tor0 b/tests/05r6tor0
index 2fd51f2ea4bb..b2685b721c2e 100644
--- a/tests/05r6tor0
+++ b/tests/05r6tor0
@@ -13,6 +13,10 @@ check raid5
 testdev $md0 3 19456 512
 mdadm -G $md0 -l0
 check wait; sleep 1
+while ps auxf | grep "mdadm -G" | grep -v grep
+do
+        sleep 1
+done
 check raid0
 testdev $md0 3 19456 512
 mdadm -G $md0 -l5 --add $dev3 $dev4
-- 
2.32.0 (Apple Git-132)

