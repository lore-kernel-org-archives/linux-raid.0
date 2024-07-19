Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192A081219
	for <linux-raid@vger.kernel.org>; Fri, 19 Jul 2024 09:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721382776; cv=none; b=H443ECC5ghcKMMGkTTb95X2Za7ihHDqMREW0uHZFCvIva6ug6zQh9Iqwd7saJXLDp/yKb87PBkrSuhg4yOrls6bhbpHKHk0RSCipTAU4MduiXGKZbdbBtLiTES9ub0z4soHH1ZMhKui0v0VDnhu69gDEP6JYwVsJvg3ufJLJLRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721382776; c=relaxed/simple;
	bh=/wAxpmekW4VOSsF9/3tL8FkT2NNzmQZ64SPwvB2fF3A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TjN0B6Az50xpqujzRr0sbmWCmZtkpROy59AKxEY8byk0gMgimApDMsJHmzgMN0PfYPaImu8NX+M5jYxbopObD+ORcfw4in/eQIzikfp4+FtlIsagPTce0KBBkyi/sPK7gZW/jrI/+GMYe+SnliaMnD+xaLsCHtemBNFNXSeUB7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YqRMxmor; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YqRMxmor"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721382774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GLnyqZlt6Mr+IFCgxfJddZF1aLt/Som7K6bijcHPpD4=;
	b=YqRMxmor5Df7OAUotyxIykv7/tkfIHxk5s/rUrrOBnOUsznOc1z+LpneBe37DO53qDQhaV
	o3h7GtM8URVobwHnUlCRtQDncNStPjmBE837RnUnL/6rX/+D5Tyl8BF+We/r/XaAIuUJy0
	ojgQgfr1TvyX/7H2vaXl27aDG3XA8WQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-58-XVk9ToRLPKKYa05mSkhIFQ-1; Fri,
 19 Jul 2024 05:52:48 -0400
X-MC-Unique: XVk9ToRLPKKYa05mSkhIFQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A319F1955D48;
	Fri, 19 Jul 2024 09:52:47 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.6])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 30A6019560B2;
	Fri, 19 Jul 2024 09:52:43 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 06/14] mdadm/mdmon: fix coverity issue RESOURCE_LEAK
Date: Fri, 19 Jul 2024 17:52:11 +0800
Message-Id: <20240719095219.9705-7-xni@redhat.com>
In-Reply-To: <20240719095219.9705-1-xni@redhat.com>
References: <20240719095219.9705-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 mdmon.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mdmon.c b/mdmon.c
index b6fe302e..a498c9bd 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -455,22 +455,25 @@ static int mdmon(char *devnm, int must_fork, int takeover)
 	if (must_fork) {
 		if (pipe(pfd) != 0) {
 			pr_err("failed to create pipe\n");
+			close_fd(&mdfd);
 			return 1;
 		}
 		switch(fork()) {
 		case -1:
 			pr_err("failed to fork: %s\n", strerror(errno));
+			close_fd(&mdfd);
 			return 1;
 		case 0: /* child */
-			close(pfd[0]);
+			close_fd(&pfd[0]);
 			break;
 		default: /* parent */
-			close(pfd[1]);
+			close_fd(&pfd[1]);
 			if (read(pfd[0], &status, sizeof(status)) != sizeof(status)) {
 				wait(&status);
 				status = WEXITSTATUS(status);
 			}
-			close(pfd[0]);
+			close_fd(&pfd[0]);
+			close_fd(&mdfd);
 			return status;
 		}
 	} else
-- 
2.41.0

