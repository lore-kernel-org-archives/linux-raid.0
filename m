Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A350E2DCF43
	for <linux-raid@vger.kernel.org>; Fri, 17 Oct 2025 09:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760692490; cv=none; b=sIz91A4WykKD0NUqwNvLw6nqLxl2BNPZa31f+DrDL+dKw9kWWvrujJNxGVVZ0k5IGowXWJmwfES5Rb3hy/mKK/KjE5gap6hbaXpcKEL2949Ajvpo/63o9LStgdfQpfCM4qKsJmVYe8cWucOEHZ3K368YiAi0BTBdcSmuj0FOHgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760692490; c=relaxed/simple;
	bh=t2aA7idVu78WrtCUvNEkAZmqVbD8z4eg99+GgNeT1WE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b8zS+VcQO/m02iSgLbiULm7Mdub92GWFJQ6WZVva9h3Ye6SzPOFqomAjTFiUrVfvKZ65V8NV9rx8XuTxRidWED9Lg04MbB8y8OsFlB2aFbl0tnCtOPWeVpuC6YRY9cKfxPQ6jWXG7nEkhOfTTcJr/mMD4a7ldNSgmhNcPqtFiNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PF3pfpFk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PF3pfpFk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760692486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rd9hKbdQsaIimeE11pYsAyN7yIMvzMKw3n4kahZ1nO8=;
	b=PF3pfpFkkjGk6mg/hWHge1lmnKjIhIY7EwDxnAkT36NmfDSKUjcFfz/NTn0j7/UG9vN4UN
	AQ0Dp4r3EpKrfNMkyFtk6CADQ/BIPsOigkWU1Yzg1pEKz7FFZO0DlL/pVyeR744nDBqoUc
	AdnrlSLUF2AeYKxKg2JtH0DN3DxN4qg=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-588-FyhXXvfsPj6LNS8Vsf4zdA-1; Fri,
 17 Oct 2025 05:14:45 -0400
X-MC-Unique: FyhXXvfsPj6LNS8Vsf4zdA-1
X-Mimecast-MFC-AGG-ID: FyhXXvfsPj6LNS8Vsf4zdA_1760692484
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3B2F81956094;
	Fri, 17 Oct 2025 09:14:44 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.6])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1092330001A7;
	Fri, 17 Oct 2025 09:14:41 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: mtkaczyk@kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 2/2] mdadm/sysfs: close fd before return
Date: Fri, 17 Oct 2025 17:14:33 +0800
Message-Id: <20251017091433.53602-3-xni@redhat.com>
In-Reply-To: <20251017091433.53602-1-xni@redhat.com>
References: <20251017091433.53602-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

It needs to close fd before returning the function.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 sysfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sysfs.c b/sysfs.c
index c030d634b155..e60adc9f549f 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -160,6 +160,7 @@ mdadm_status_t sysfs_set_memb_state_fd(int fd, memb_state_t state, int *err)
 mdadm_status_t sysfs_set_memb_state(char *array_devnm, char *memb_devnm, memb_state_t state)
 {
 	int state_fd = sysfs_open_memb_attr(array_devnm, memb_devnm, "state", O_RDWR);
+	mdadm_status_t status;
 
 	if (!is_fd_valid(state_fd)) {
 		pr_err("Cannot open file descriptor to %s in array %s, aborting.\n",
@@ -167,9 +168,9 @@ mdadm_status_t sysfs_set_memb_state(char *array_devnm, char *memb_devnm, memb_st
 			return MDADM_STATUS_ERROR;
 	}
 
-	return sysfs_set_memb_state_fd(state_fd, state, NULL);
-
+	status = sysfs_set_memb_state_fd(state_fd, state, NULL);
 	close_fd(&state_fd);
+	return status;
 }
 
 /**
-- 
2.32.0 (Apple Git-132)

