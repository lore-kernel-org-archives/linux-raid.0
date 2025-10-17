Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A6821A420
	for <linux-raid@vger.kernel.org>; Fri, 17 Oct 2025 08:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760689841; cv=none; b=EShEEBecQj0fA6GnM5ebAM6+xXDw0j1FepNhBEnvdj/UU9+hJQKK9O5euSVs6R1RZdf0IE21TKlAT4RyQNqeOolZWGnsyAG3xVwZYhpV27q8sBxzXyUhWkXrIAVuNYAwkguWXTZHrupSATY0d9O83WAyHuxRQJQDEzb8y1ReRhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760689841; c=relaxed/simple;
	bh=nH2yR3IZ68ItGbnX387WlDHig2/vQ1CXXjZvrxX7tHo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HWHVBarbtghLTOXGZ60fSpX0G6xmeT10GNYEdveCkfT+JB305vckA1+3+F+ZZTQbiqHxcAd2eDsyBuRUBlmfuNmx7Rb0XEliI9Ggi0UbA8nAHHVazkKD7pzosckUxvZPcwTvzwjLmK/TpLkKg0pQxuajhsfXMlp4h1Atz2DGAE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AFHE7bKj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AFHE7bKj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760689838;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FagEWFjzmCZNOfdswXDtv97OWvcLWDm6A8NJ/kCFTS8=;
	b=AFHE7bKjnZliyvsCCoAUeRWnjx6j86zuSmrpfEQcsVA34uUQzCW0QzL1ciCU5EiQehJiIN
	cjPcK9e5vcZuwTptX4PvlLmQyRN1uAvZaQ03G8FlXSZfzoV46qY5Tweg70f5658mLtbY+Y
	j0Rsyg2DY23NfdSFQdtGWLiUncXfubg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-602-YnE6XWd8OiePgHkrZ6GcTw-1; Fri,
 17 Oct 2025 04:30:35 -0400
X-MC-Unique: YnE6XWd8OiePgHkrZ6GcTw-1
X-Mimecast-MFC-AGG-ID: YnE6XWd8OiePgHkrZ6GcTw_1760689834
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4A9B118002F7;
	Fri, 17 Oct 2025 08:30:34 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.6])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 23D5B1800353;
	Fri, 17 Oct 2025 08:30:31 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: mtkaczyk@kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 1/1] mdadm/Incremental: wait a while before removing a member
Date: Fri, 17 Oct 2025 16:30:29 +0800
Message-Id: <20251017083029.53138-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

We encountered a regression that member disk can't be removed in
incremental remove mode:
mdadm -If /dev/loop0
mdadm: Cannot remove member device loop0 from md127

It doesn't allow to remove a member if sync thread is running. mdadm -If
sets member disk faulty first, then it removes the disk. If sync thread
is running, it will be interrupted by setting a member faulty. But the sync
thread hasn't been reapped. So it needs to wait a while to let kernel to
reap sync thread.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Incremental.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Incremental.c b/Incremental.c
index ba3810e6157f..d04168121199 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1793,6 +1793,12 @@ int Incremental_remove(char *devname, char *id_path, int verbose)
 	if (rv && verbose >= 0)
 		pr_err("Cannot fail member device %s in array %s.\n", devnm, ent->devnm);
 
+	/*
+	 * If resync/recovery is running, sync thread is interrupted by setting member faulty.
+	 * And it needs to wait sometime to let kernel to reap sync thread. If not, it will
+	 * fail to remove it.
+	 */
+	sleep_for(5, 0, true);
 	if (rv == MDADM_STATUS_SUCCESS)
 		rv = sysfs_set_memb_state(ent->devnm, devnm, MEMB_STATE_REMOVE);
 
-- 
2.32.0 (Apple Git-132)

