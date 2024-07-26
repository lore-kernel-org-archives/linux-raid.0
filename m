Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E0E176ABB
	for <linux-raid@vger.kernel.org>; Fri, 26 Jul 2024 07:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721978098; cv=none; b=nnDHx3+Cixpn9WP4pCk50r1Ykh6kqvla66oiuzWHPXxMlVQzw0jOL5AMdYBc1Ll5FpecEHoVmz6+hctUuoUb+uGTPFYIuGXhFsxbybVgizeoNFzDafV/fxYItBNtv3iQKEPAmZ5Zhk/5agNox0bnLXqEFNT6qZt9BVJjKmwK13w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721978098; c=relaxed/simple;
	bh=Kxrb6KqAYDg1yd7xOWiuUwWg6DUJHLgBcoiY+IrYlkU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tUFAPRpFVjMFSurn9iwjApI7QZ67sxYGzlaLuAVC2AYoeFNxGipYMoTG7QTOkX83fN50Eg9D1+uWiRYXhmlEIraCjljejLoH2JgHVsYbv7PLXa/0OsDr2TBVS8oUWC2u9jm4qWEg2wOcujqnif/klvpbOca2lzm1yKFLoVIqtws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y7V2cx04; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y7V2cx04"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721978096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cct98WuoLJcrROJAxKUTywOAdEjh6LOS/q6Vou7MqOk=;
	b=Y7V2cx04s807TUYjVnJVMOTrgyuNZFNHOABmkpIFA0TFs+p6D52kawBEKuv9K7wqXdX763
	FzRKn7EgeTJpA69SsYyMYJyyQ/hYFuvhAEtl9jz9ymRLfv8JU5wzmjOxaauJe+9/9EDaSk
	aKdoMKTYIMN41X9DKRtvrHi6cpWpGw8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-26-R4_AD3WrPDmog2KZhnOb6A-1; Fri,
 26 Jul 2024 03:14:54 -0400
X-MC-Unique: R4_AD3WrPDmog2KZhnOb6A-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 22E4A19560B0;
	Fri, 26 Jul 2024 07:14:53 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.28])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A9A2419560AE;
	Fri, 26 Jul 2024 07:14:50 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 09/14] mdadm/mdstat: fix coverity issue CHECKED_RETURN
Date: Fri, 26 Jul 2024 15:14:11 +0800
Message-Id: <20240726071416.36759-10-xni@redhat.com>
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

