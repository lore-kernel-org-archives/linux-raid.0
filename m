Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457B4B64E
	for <linux-raid@vger.kernel.org>; Mon, 15 Jul 2024 07:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721029007; cv=none; b=tQWcK7cPhUYDhqCQ+i469ioEgvnmRQ3omUWp23L+2BjCm64ZNdBWdp7sbzasWz+9gESBsDi7SAJLcAICnmnV7o3+cglPHUwS7/KnxXuqyk/2WGpmxIlIicBfrKmtNph4gNMUh/rFd//LvFq2EJtEfmNIwQtMXPktDUNC6XA4Pgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721029007; c=relaxed/simple;
	bh=BC9uO78ju5/oU6ArITKP89WXgNm5+WgprbKcHcaKisM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qMuBgILJxcdJtr7z75K7Do1ZhN/phLJv8It7YtWf5AMt3ZZzwGgDut94NPLrzfUEkFUmsfkMgjL2OGUyjqs+cGFThoTsODzh20HHX7REeaqSFCv7FORq8/Op4t4bAf/8xY0Lk64DPvCJ2ZsN2UdgNLdDMbJq7MLPUfKQ7wW26UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ghio9aIZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ghio9aIZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721029005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rR6If9dMQ3lMrb/2DiEkvJQ2tN9q7qHigaBzYHs0zmw=;
	b=Ghio9aIZPoWlLqlixxDzh6y91x/blhCv0plDNlTBNju/hZ1ytOqiiamv2v9+uicv1iOo6f
	19g7QWE/oQrwT9zjPJo7CL6zHMBwB21qMYhxSsDATfa0faCsuTb1JgOiKkLvIIrZk+hb/s
	ADqp9S70eEw9L1AHeTstVTD9GwFtpOA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-267-Q4OWXK3wM86RWDVjm9JeXw-1; Mon,
 15 Jul 2024 03:36:43 -0400
X-MC-Unique: Q4OWXK3wM86RWDVjm9JeXw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EFA3B195421B;
	Mon, 15 Jul 2024 07:36:42 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.27])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 674521955D42;
	Mon, 15 Jul 2024 07:36:39 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 10/15] mdadm/mdstat: fix coverity issue CHECKED_RETURN
Date: Mon, 15 Jul 2024 15:35:59 +0800
Message-Id: <20240715073604.30307-11-xni@redhat.com>
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
 mdstat.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mdstat.c b/mdstat.c
index e233f094c480..930d59ee2325 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -146,8 +146,11 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 		f = fopen("/proc/mdstat", "r");
 	if (f == NULL)
 		return NULL;
-	else
-		fcntl(fileno(f), F_SETFD, FD_CLOEXEC);
+
+	if (fcntl(fileno(f), F_SETFD, FD_CLOEXEC) < 0) {
+		fclose(f);
+		return NULL;
+	}
 
 	all = NULL;
 	end = &all;
@@ -281,7 +284,10 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 	}
 	if (hold && mdstat_fd == -1) {
 		mdstat_fd = dup(fileno(f));
-		fcntl(mdstat_fd, F_SETFD, FD_CLOEXEC);
+		if (fcntl(mdstat_fd, F_SETFD, FD_CLOEXEC) < 0) {
+			fclose(f);
+			return NULL;
+		}
 	}
 	fclose(f);
 
-- 
2.32.0 (Apple Git-132)

