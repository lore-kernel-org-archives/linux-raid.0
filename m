Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC177176241
	for <linux-raid@vger.kernel.org>; Fri, 26 Jul 2024 07:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721978085; cv=none; b=TGdS35XymYLJgcRWhd7ejcD2nUHpRo/WuLZC8ElOxoOSJOd0ofuU/DRAUcAzVXCK6zqNvABiisuqgVrtz6FPFiSCobAUm3mG9yZ9adISyfcw2NpwydbSQDmqixZfxj8mDltI/YaMxLrzRt4Qqm9hBsFH7MrG35aNZYdy59EneCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721978085; c=relaxed/simple;
	bh=zI9wMRvusPHofkN5TVzmpk73L1/hzgGs2nu/wirzi1M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oNfrH3sF+MQyBEqaqpkBBzSsHXP7kIdKQRqnHfZ+5Z/X3bX36z96gMN68yn1aXaMPAx4U1sT0CofJsO1krTy9ocpCzKTDKyW3DIX29NIOTd/PzJ1YQ6rq3Q4G31GjsRMfIiyLkLTOdKqQjfXYRgyGuG6UJy6hChGkngQ4GkeXhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hy2pRO3C; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hy2pRO3C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721978082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CVR2H2Xz9gT4Gy/+sdhhnP3EvKU7h8HT1jwWhCVUnHg=;
	b=hy2pRO3C4z8FTjGiREE1nU1AY8fMG1E6dZHU9DUaJ5EPo9t37JoDAqvsKtG1DSq1xqxVRY
	JRG4HKIN6zumaWJv5quXTHOZCVuFaExzBKUP4X+yny1ZBuJM+dBdarTr6C85YJwINq7bPM
	OH1qO4cnONQ9hFTfcIgGvPqsegT+rLg=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-315-ULPVJBaoOQiuGLn30Q_KUA-1; Fri,
 26 Jul 2024 03:14:40 -0400
X-MC-Unique: ULPVJBaoOQiuGLn30Q_KUA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 15B0B19560B0;
	Fri, 26 Jul 2024 07:14:40 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.28])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 70CED19560AE;
	Fri, 26 Jul 2024 07:14:36 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 05/14] mdadm/mdmon: fix coverity issue CHECKED_RETURN
Date: Fri, 26 Jul 2024 15:14:07 +0800
Message-Id: <20240726071416.36759-6-xni@redhat.com>
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

It needs to check return values when functions have return value.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 mdmon.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mdmon.c b/mdmon.c
index 5fdb5cdb5a49..49921076a37d 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -198,8 +198,12 @@ static void try_kill_monitor(pid_t pid, char *devname, int sock)
 	/* Wait for monitor to exit by reading from the socket, after
 	 * clearing the non-blocking flag */
 	fl = fcntl(sock, F_GETFL, 0);
+	if (fl < 0)
+		return;
+
 	fl &= ~O_NONBLOCK;
-	fcntl(sock, F_SETFL, fl);
+	if (fcntl(sock, F_SETFL, fl) < 0)
+		return;
 	n = read(sock, buf, 100);
 
 	/* If there is I/O going on it might took some time to get to
@@ -249,7 +253,10 @@ static int make_control_sock(char *devname)
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
2.32.0 (Apple Git-132)

