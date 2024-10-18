Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AEB118E02A
	for <linux-raid@vger.kernel.org>; Fri, 18 Oct 2024 08:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729241315; cv=none; b=GJIVr0B7pfThq7Zg3j3x9b2eVN/GSvK4UH1r9RYSQKGDcnTeKSV/GgYP854eP/m2WmPyBof/1m2yTkOIlgLtJ1NtNwRnS/u13btQjMomFrzp2h5CFvRMdHU/ZaYeFYTfXm4RxVKSlGGKigmgePANtFSAgdTK5bXH7l6usx85Cpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729241315; c=relaxed/simple;
	bh=i9MvG6Yid8/6HcCrCIOgmyVZg+6wj/ODmFtDI4qhjZo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ASdTAO+b+fE5H4/1/lP5a6tCvMTIChYr/EEwQ4CbYoS0J4PPEDduDgQEVdnDNMz2z3JZjwD1t74h2IHT4cF135wdgt1WU6Vvy6uuyBMPjgtO3yLrCUyoEIUGk9vWSKfceBeU7dNdQ0/iAiPf2iBzmR5O9WoRuDxb/1VW6q9DVzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MlN/i/A7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MlN/i/A7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729241312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0FAhY7Ixj8tN3zYrJXVCMgqEULEDFL92LELnYSHdGY8=;
	b=MlN/i/A7Jdwg4/l+GmJizCrtxBnVMoBY4g/AWoo35l6gnp/56UpNqkDuR2tAjLRjILMt6d
	gN+O5XdPZSqRqhKTMWQGR0l5XHcgKaB1JANRbLwYFkZxy0mond5e20FIDOqkNnvKEZJJyk
	SnVLIiTXq3vSE45vh3ZzadLQltTtk3A=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-671--sne3yezMyebqu1LiZcjrw-1; Fri,
 18 Oct 2024 04:48:30 -0400
X-MC-Unique: -sne3yezMyebqu1LiZcjrw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 15D981956096;
	Fri, 18 Oct 2024 08:48:30 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.5])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6E1C61956086;
	Fri, 18 Oct 2024 08:48:27 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 2/2] mdadm/Grow: Check new_level interface rather than kernel version
Date: Fri, 18 Oct 2024 16:48:17 +0800
Message-Id: <20241018084817.60233-3-xni@redhat.com>
In-Reply-To: <20241018084817.60233-1-xni@redhat.com>
References: <20241018084817.60233-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Different os distributions have different kernel version themselves.
Check new_level sysfs interface rather than kernel version.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Grow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Grow.c b/Grow.c
index ef1285ecebcf..9032c3e9c09f 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2952,7 +2952,7 @@ static int impose_reshape(struct mdinfo *sra,
 			err = errno;
 
 		/* new_level is introduced in kernel 6.12 */
-		if (!err && get_linux_version() >= 6012000 &&
+		if (!err && sysfs_attribute_available(sra, NULL, "new_level") &&
 				sysfs_set_num(sra, NULL, "new_level", info->new_level) < 0)
 			err = errno;
 
-- 
2.32.0 (Apple Git-132)

