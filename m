Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D603F9D5
	for <linux-raid@vger.kernel.org>; Fri, 26 Jul 2024 07:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721978090; cv=none; b=g3783mfzzm+bp8+8jgMqer+SwBYgKCKInF8LuB2kY53iLoVs+SCiUjJt1tiEFvVE5UnZr0dYTDZlFMPpWlPLSk92/pwGXkEZPFL/BMl6gE+UgW55PmPq+jTkDfQZH6smLwxGGMFfpkMRvJWlO6HWoXrDXxXtmqbCBXzde+Qx8GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721978090; c=relaxed/simple;
	bh=JagWU1VB7CB2JpugS6SKbsWU++iCjnszvNCZUQEzoUM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m2qZCv9NeEzHPiSZ5pR2uV5T46hLPJqOZgUsDIM0uOp5ceWVLxwKh5AKqM5If5K4AzhlITqS19CISrmJZF4OtRKfWuuDGjEUmpVuIkbEqnNcHjp1/MSbfmu9yV21kpK7cl2WpHcaRLTeCzzrzLuLhWd977uT5maw5FIsd1zikzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LUdl/JwK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LUdl/JwK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721978087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MTExfhUcwdnko0yCc/fq+9jmtIOui91HP3sP81fWmx8=;
	b=LUdl/JwK0pezppp99iChy2mRpWyt4+5pk3ezHo095kWtvimlLMS+VbbK7okPuUHcFYby69
	/5OMlFNtpEiOTE/osK3KSF42LjBLat+fDSRMdSmnWeO+neSkZ3RXC8VfcVWQrD2Wv4cOG/
	kAE0d5KFHrkUvzwLOtxWCMjacMBjLd8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-517-Frmp2nTTPCq1gEfqq9ANnw-1; Fri,
 26 Jul 2024 03:14:44 -0400
X-MC-Unique: Frmp2nTTPCq1gEfqq9ANnw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 351FD1955D4A;
	Fri, 26 Jul 2024 07:14:43 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.28])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A773C19560AE;
	Fri, 26 Jul 2024 07:14:40 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 06/14] mdadm/mdmon: fix coverity issue RESOURCE_LEAK
Date: Fri, 26 Jul 2024 15:14:08 +0800
Message-Id: <20240726071416.36759-7-xni@redhat.com>
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

Fix resource leak problem in mdmon.c

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 mdmon.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mdmon.c b/mdmon.c
index 49921076a37d..f64940d576b4 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -458,22 +458,25 @@ static int mdmon(char *devnm, int must_fork, int takeover)
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
2.32.0 (Apple Git-132)

