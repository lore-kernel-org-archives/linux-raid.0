Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E88380639
	for <linux-raid@vger.kernel.org>; Fri, 19 Jul 2024 09:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721382769; cv=none; b=JnWq1YXw7hNAICJaP6pPDEEHHLJqLJ8Jma56gH+IaojXAuJqhwP//BNn859y1PTlqHBz0bq/Eq3aaG0B4tXA8KHG3yG7mZh80/t0MJspr9HGQkb0XF8fdaHvosGzdDJs3BbyY1COfDWxS9tz21VdU1ydz0+b278+Bi6n6AESjZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721382769; c=relaxed/simple;
	bh=lFsjtYALpAM4femGZEmb7rBukzfeNEjYqfEcRB+pi3Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DD93z1x94PgGOmPeFTUkuF4eLmoraexHhM/D3wanpTAwflUunKOB+ym3KKJdSOEdmh1IqXe3zjK30kHkR5RpwmcZ5DJULYY6mbATsu3stTOg6sU7oGNBv/w3LNdu3U2D1gck7JprpUkQYVnH6mBZ2AHsj51jllFnhiUVJM9zcR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ibVb5D2A; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ibVb5D2A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721382766;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3V5fqe00m9jnqvqgTJrztaBWSByR7ji5rJ4GoswSWnI=;
	b=ibVb5D2A4h/Yxg6FgpjzQfT2ZwWf40DdkbXzxicGYmFtH3ODwDwDsy73lXvUSvV5S7wUs4
	rWzhogAm/ZfC3P4W0NC3WEMPngHf3ewc6Zt6Q6NtE3+3AM+F5xVxCWFqqRxW096Hap6MpW
	qMmXcMFaDjHVg1subWFEP7lOKyQrKTo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-470-ldD8bbRFPvmDBmpfdPrUow-1; Fri,
 19 Jul 2024 05:52:44 -0400
X-MC-Unique: ldD8bbRFPvmDBmpfdPrUow-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 473371944CE4;
	Fri, 19 Jul 2024 09:52:43 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.6])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BF4911955F68;
	Fri, 19 Jul 2024 09:52:40 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 05/14] mdadm/mdmon: fix coverity issue CHECKED_RETURN
Date: Fri, 19 Jul 2024 17:52:10 +0800
Message-Id: <20240719095219.9705-6-xni@redhat.com>
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
 mdmon.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mdmon.c b/mdmon.c
index 5fdb5cdb..b6fe302e 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -199,7 +199,8 @@ static void try_kill_monitor(pid_t pid, char *devname, int sock)
 	 * clearing the non-blocking flag */
 	fl = fcntl(sock, F_GETFL, 0);
 	fl &= ~O_NONBLOCK;
-	fcntl(sock, F_SETFL, fl);
+	if (fcntl(sock, F_SETFL, fl) < 0)
+		return;
 	n = read(sock, buf, 100);
 
 	/* If there is I/O going on it might took some time to get to
@@ -249,7 +250,10 @@ static int make_control_sock(char *devname)
 	listen(sfd, 10);
 	fl = fcntl(sfd, F_GETFL, 0);
 	fl |= O_NONBLOCK;
-	fcntl(sfd, F_SETFL, fl);
+	if (fcntl(sfd, F_SETFL, fl) < 0) {
+		close_fd(&sfd);
+		return -1;
+	}
 	return sfd;
 }
 
-- 
2.41.0

