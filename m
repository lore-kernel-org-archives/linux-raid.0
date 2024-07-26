Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5F9225D7
	for <linux-raid@vger.kernel.org>; Fri, 26 Jul 2024 07:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721978095; cv=none; b=PlpXWCqUr8Vi+hR225froPhZtFPRQWAzmrApNf15jPxLnw0zr35Ou4dzOGmNmLkHiVL+vSK91LJEo9NxG6IGEbf7ir3gjDqDcoRxJrvK6ZG5tk9MVADHr0h7lq/Xydi5wVLLpODsux2iiAHzbODEJydJ0lho/+avCUSmIsm7awY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721978095; c=relaxed/simple;
	bh=Xd7A33fZcGyggE1os5YxgaZK7tDMlReQ0gLkzsCDopM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q+ZbPr/R9lquqaUITuJlv5jhGO3hlxbUempSGy4XzgsIG0q1MWtK/40HF6xBp5o6NZPshYcR28A6WB0DTt3ZP6aTNGLQyr0euc2Na6lB1KS/a46sZRBN0cvocT78Wvt52c8vWcM3MK2aiG5GmVicmbknCMcSHhFvXTE9UB42UVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xg1LNJSK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xg1LNJSK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721978093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=odmuhjorkDC7YxJmJ20uV0qDT33jqVqwezwfuRnNvAg=;
	b=Xg1LNJSKGo9hTzXnz3Jm3SEeJOe09Ne2j602uwX9L3NTalFlumwsIEOnu/WgBW5/uBWSez
	5pX7EjdwG5x4L5i/rpawUTW7Szo6pQG676x+CZDn+cPRsD+keXDE7F56lV6zahFkgi9ir4
	dSdtBHdJsJBjlYrNbKOD80w45e22BfQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-93-p14AROS_OuOHB77iRvP6_g-1; Fri,
 26 Jul 2024 03:14:47 -0400
X-MC-Unique: p14AROS_OuOHB77iRvP6_g-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B02219560B4;
	Fri, 26 Jul 2024 07:14:47 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.28])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D633119560AE;
	Fri, 26 Jul 2024 07:14:43 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 07/14] mdadm/mdopen: fix coverity issue CHECKED_RETURN
Date: Fri, 26 Jul 2024 15:14:09 +0800
Message-Id: <20240726071416.36759-8-xni@redhat.com>
In-Reply-To: <20240726071416.36759-1-xni@redhat.com>
References: <20240726071416.36759-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

It needs to check return values when functions return value.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 mdopen.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mdopen.c b/mdopen.c
index eaa59b5925af..c9fda131558b 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -406,7 +406,11 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 				perror("chown");
 			if (chmod(devname, ci->mode))
 				perror("chmod");
-			stat(devname, &stb);
+			if (stat(devname, &stb) < 0) {
+				pr_err("failed to stat %s\n",
+						devname);
+				return -1;
+			}
 			add_dev(devname, &stb, 0, NULL);
 		}
 		if (use_mdp == 1)
-- 
2.32.0 (Apple Git-132)

