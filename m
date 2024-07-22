Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E09166313
	for <linux-raid@vger.kernel.org>; Mon, 22 Jul 2024 08:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721636302; cv=none; b=MCH4ulaipw+emMW1mhI5ao5/M83kW+/2fThGmc27OOjq3Kn+MpEGq96TDhy165mIKwxQafJ3AXzwSNFT+KNGSp9XaQfies6xzHp+binc4Ja+udbHDBUOlDNmdNgWC89YoGn3fcj4qAvlIOuADsdQ7tneVUea4J5VOj7kUMzPOks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721636302; c=relaxed/simple;
	bh=s8yhPIOsJ7MBDVxGDKOneteJRCZ7ar8nENdMkmhXoRk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oC84bcR8sEHBrI6WTs49Nm3E8XwPQZ+lP+WSsOxCrdzEgg3ayW8CiU3xXVc8UemR2FSTq3RwdZIWhTlegaWwjNeNJDGMFSXNno8u6aHqUiDftv/VVVcb70eO264sg3FnEYt5LAaKhbVjTpmhyjEddOr/oWXCwlRaPwDaHbc2j+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F4lwH4mf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F4lwH4mf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721636299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pcDI4MsQ1XT0n6+itwy/cymJYUc8vhlmcLwV1nxeYyg=;
	b=F4lwH4mfbaCGqibJ+61U9p2j67Ez07vHUD93Aho0ZizsEYbMLXaE+RM0zwGdNR3PXOEP5g
	YDzIUQPUrJK49PEo4sx8bq/CTdApD+SCmb0KWBiQuDs8PlQdkj9d33bT15AT0jV4d6cB9d
	XrFtchdaA24vr4wmCPtx+BFLvoO1218=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-509-9FGmQBolPcW9Zbh66hwaiA-1; Mon,
 22 Jul 2024 04:18:17 -0400
X-MC-Unique: 9FGmQBolPcW9Zbh66hwaiA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F1EA1955BEF;
	Mon, 22 Jul 2024 08:18:16 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.7])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D75391955D47;
	Mon, 22 Jul 2024 08:18:13 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 09/14] mdadm/mdstat: fix coverity issue CHECKED_RETURN
Date: Mon, 22 Jul 2024 16:17:31 +0800
Message-Id: <20240722081736.20439-10-xni@redhat.com>
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

It needs to check return values when functions return value.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 mdstat.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mdstat.c b/mdstat.c
index e233f094..930d59ee 100644
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
2.41.0

