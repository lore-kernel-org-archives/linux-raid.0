Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403F122EF4
	for <linux-raid@vger.kernel.org>; Mon, 15 Jul 2024 07:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721029002; cv=none; b=odzTBYKbP3+zhZRPRQpFmX5gfMgzTgQDhQYCcPXH2Y1X65TuysMEtgXhKmwVgYxh/w2PCZ2JMArzTnJ+WXr83RFxc8Z3Z5Mosz/05ihd6axdGktlQY9brv//llq93GYw2gdSSDUPRycVkHoPIDuSlzokqWh11uX4L1j+LsdbQ5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721029002; c=relaxed/simple;
	bh=WRZHpgGascNfyOu1s2oA5wYP6OfbHIivnAJW8C4BI+E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r4xU/SlN7gPVMSKROrhgr+7S23+xb7+ayHDK1CeMlMN6Ly+hZ/uenwg0lie+OGhQVF+E8rD4qSSNA+WVBDHGUZt3wfgdg8Fb33EhwvWI/YpdOUYhkcmke83ZBx48knkV/8gYsIybCor+P34oh7otkYmzDm5a9nRUJzq/LWLWJRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aUaOCFBM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aUaOCFBM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721029000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M2sG6ajFf5Fml1zBqqHC09LuKfrlzK4qH721KOacoQI=;
	b=aUaOCFBMoYGHqphJwu/BSu4YkUOsP2CKLTKmMBu46M/39Q38tAYglrvIBCNfMbDkDq4wGB
	e4c57dODCVTlH2QAolE3HfHY268SY57FjAmOMjEM2exPzNIhsc1Schn5MTCqJDa5onwNWd
	SCE8uDX6fgCBi4pbDoHWnrAuYnzFYh4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-645-A55nHAUDOZGjlDH5GHiNGA-1; Mon,
 15 Jul 2024 03:36:34 -0400
X-MC-Unique: A55nHAUDOZGjlDH5GHiNGA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 032791955BF6;
	Mon, 15 Jul 2024 07:36:33 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.27])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 905601955D48;
	Mon, 15 Jul 2024 07:36:30 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 07/15] mdadm/mdmon: fix coverity issue RESOURCE_LEAK
Date: Mon, 15 Jul 2024 15:35:56 +0800
Message-Id: <20240715073604.30307-8-xni@redhat.com>
In-Reply-To: <20240715073604.30307-1-xni@redhat.com>
References: <20240715073604.30307-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 mdmon.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mdmon.c b/mdmon.c
index b8f71e5db555..f0e89924aef7 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -455,11 +455,13 @@ static int mdmon(char *devnm, int must_fork, int takeover)
 	if (must_fork) {
 		if (pipe(pfd) != 0) {
 			pr_err("failed to create pipe\n");
+			close(mdfd);
 			return 1;
 		}
 		switch(fork()) {
 		case -1:
 			pr_err("failed to fork: %s\n", strerror(errno));
+			close(mdfd);
 			return 1;
 		case 0: /* child */
 			close(pfd[0]);
@@ -471,6 +473,7 @@ static int mdmon(char *devnm, int must_fork, int takeover)
 				status = WEXITSTATUS(status);
 			}
 			close(pfd[0]);
+			close(mdfd);
 			return status;
 		}
 	} else
-- 
2.32.0 (Apple Git-132)

