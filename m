Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF2213A888
	for <linux-raid@vger.kernel.org>; Mon, 15 Jul 2024 07:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721028994; cv=none; b=fVRY8KIC01l6yicvL++a1qd5X61yPVJP8vN72rtQsJTBSY22Ye94h6BYDct1YlRrHVFkkupgq3f4FydZHLKKpUsOKK99dCaR1x2CE7SZ/xUOl0E/xShNOlXAjZtXLdzhKY7JkVJH4nVt6QtOlooA97AOCkrbU2oFzZitAb9bnVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721028994; c=relaxed/simple;
	bh=MH2qGCDwoJPmCWdF3xX+Q9Wxg4H/uzs6CMmNQCi4X80=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sWU2OHpNKjM5xhGcwS7f1m1BznlpBp4GqreCZt7ZBVaeWjnNA8ZkT5dfIi97MXrTbBVxH2Tq8p/4nKomlfQ6JnCSRyQGZcLfNNlAF2dlSBh8P0IWDyXyjYpW+zTdOEv7PZ9UabIM24Yoh+Cskad34XfW1BOZuGHHS9QBzN1V1DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eT6wK1jR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eT6wK1jR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721028992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uhqXtnzDcUhJ6UGlgJ1UyS2V5x5WmKX1gKs6L8gpqtw=;
	b=eT6wK1jR0SbDhGQG16djVihagE0f0u8c8cdb8aTsa/msScyrWPcJ/oC+cexPliTpTbUT5n
	P+jmpHY0vEtSHIEGc/9C7undXJHc5BGN9ngGiloTJDxwsVJV6UqNUbHn08OfOhLZyRS1d9
	bpQzzP/kpm3vK/1QyOXGj1lAoOveXnI=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-84-qZF35zQ3PN6F71VsXk-ETg-1; Mon,
 15 Jul 2024 03:36:30 -0400
X-MC-Unique: qZF35zQ3PN6F71VsXk-ETg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C29E41955BF2;
	Mon, 15 Jul 2024 07:36:29 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.27])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3ED111955D42;
	Mon, 15 Jul 2024 07:36:26 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 06/15] mdadm/mdmon: fix coverity issue CHECKED_RETURN
Date: Mon, 15 Jul 2024 15:35:55 +0800
Message-Id: <20240715073604.30307-7-xni@redhat.com>
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
 mdmon.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mdmon.c b/mdmon.c
index 5fdb5cdb5a49..b8f71e5db555 100644
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
+		close(sfd);
+		return -1;
+	}
 	return sfd;
 }
 
-- 
2.32.0 (Apple Git-132)

