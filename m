Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6295125BA
	for <linux-raid@vger.kernel.org>; Mon, 22 Jul 2024 08:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721636295; cv=none; b=Z8VjwPDoqt/MMIuaVFoG0kpB4w6wwaL8x+vRpqYi+QDhlTe+cvDY/BX4Y7QEfj7iVfVI2V6oWohduhUCjVyJeHuCIsWKj9mSwqSfvj7GvOix+PBAQNOrG+i5O65wtQr+jGUntrRq35kzKiKfbYFCanTimzIfEjRaqJyCxtvkGSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721636295; c=relaxed/simple;
	bh=8TJlGUxB1Q0rMDAuGXF9KIOUDFuQYhf9x/h9eFWI5NM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CKhqVuPpREAgpVHIc/+wZtDK19DX23k/YBv8dLyHphO4WxNR7y/qfw2yqSLkIn79xB9vDZ2HlHReSGYZ4MQTbiHBp5H5T8UtWk9V2KgkiHne5aGTjK+JZ0bvJo1cqHfmA4VFGD30zEKEBnOJL56w2S8HEi+2zyEPCsokZkJCqPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B48+5jtU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B48+5jtU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721636292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hiaJCI+haqroRgJVkzSkJZ7HOBNJPa2z9XZrY7zkrr8=;
	b=B48+5jtUcdBm2Rly4xg7Z04L+QnWUWcCABktlj3KrZb+t0CTqWsJFlYZ8JF0KHCYp1Pr6p
	QhWkDS3EEmeQSpSYm7lGmv6xRfnfjgfJ3WzwprpjBY+nA8LEAijzeB8IE0HjKe81iqbQIo
	3hVBdU3yr6tqlPZC/iuQjbwPKhCGnsA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-452-Tx5R8zvKNRWDMhgR_OQOQw-1; Mon,
 22 Jul 2024 04:18:02 -0400
X-MC-Unique: Tx5R8zvKNRWDMhgR_OQOQw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 676CC1955F42;
	Mon, 22 Jul 2024 08:18:01 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.7])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F2D9E195605A;
	Mon, 22 Jul 2024 08:17:58 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 05/14] mdadm/mdmon: fix coverity issue CHECKED_RETURN
Date: Mon, 22 Jul 2024 16:17:27 +0800
Message-Id: <20240722081736.20439-6-xni@redhat.com>
In-Reply-To: <20240722081736.20439-1-xni@redhat.com>
References: <20240722081736.20439-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

It needs to check return values when functions have return value.

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

