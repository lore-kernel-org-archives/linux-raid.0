Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3172222AC
	for <linux-raid@vger.kernel.org>; Thu,  5 Mar 2026 01:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772673535; cv=none; b=n/3fnO9nIlMrn/hEMuz5U1McyF7467ppDMWyDFFqlH4rV0s/jV1j6aua/takZf9M38R3J4aWqv/OiDBJ6f59A3DLHkm38FbiPj7znx4edEYQXkzzccNEGqaL+33UHA0Aghmu5ZapqArv4WepleYtWMnn3Gokuvk2YUkcD19yo8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772673535; c=relaxed/simple;
	bh=35F0blZ2s0BfgRGOuFxkbJ1WNDavqwx0grGTLLIlTyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTjQapxYg5RK8uQIFrrbsXrVHHYUxfjyDLmKu48H7AmW0B3rKXsuz1lPAJJHku4Tyx7HVEujFXyCGoAxB5c3qAFwRxT9858h6vppc8ZfdvIDyHGfoNkxGgXGbdLQdSsIo1WBcIjkm0e5qHRZCX7JyNs4g+/ZGdOodsWjpRcZP7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dyz6Tgmg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dyz6Tgmg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772673533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZSsfgm5zoXI+zLOiMJadmMYBVSg9venOAEZB22ooOf4=;
	b=Dyz6TgmgLUDf/syIW564BnlsFTxojeOTr6EV6bXY1TBOV2NabeoW2l7QJ9CApen976u3iQ
	Nn6LekWDiJgY7VnUQZKMQAbUvFYVppx1hDSEC0rmkmgyxDK7CMrnZiPaLTKK3PcPL5pz3a
	SkeybeXLFXD6frgZkXfW0R7lkL6nBWQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-330-lVoV3aOsMQKNoAhR4OFSJg-1; Wed,
 04 Mar 2026 20:18:52 -0500
X-MC-Unique: lVoV3aOsMQKNoAhR4OFSJg-1
X-Mimecast-MFC-AGG-ID: lVoV3aOsMQKNoAhR4OFSJg_1772673531
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 272471800464;
	Thu,  5 Mar 2026 01:18:51 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.20])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BFCC730001A1;
	Thu,  5 Mar 2026 01:18:48 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	ncroxon@redhat.com
Subject: [PATCH v2 2/2] md/raid1: serialize overlap io for writemostly disk
Date: Thu,  5 Mar 2026 09:18:34 +0800
Message-ID: <20260305011839.5118-3-xni@redhat.com>
In-Reply-To: <20260305011839.5118-1-xni@redhat.com>
References: <20260305011839.5118-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

In behind mode, overlap bios for writemostly device are queued.
Those overlapped bios need to wait in waitqueue. They will be woken
up once the in-tree bio finishes.

Previously, using wait_event() would wake up all waiters simultaneously,
and they would compete for the tree lock. The bio which gets the lock
first will be handled, so the write sequence cannot be guaranteed.

For example:
bio1(100,200)
bio2(150,200)
bio3(150,300)

The write sequence of fast device is bio1,bio2,bio3. But the write
sequence of slow device could be bio1,bio3,bio2 due to lock competition.
This causes data corruption.

Use prepare_to_wait_exclusive() to ensure FIFO ordering. This adds
waiters to the tail of the waitqueue and wakes them from the head,
guaranteeing that bios are processed in the order they arrived.

Fixes: 3e148a320979 ("md/raid1: fix potential data inconsistency issue with write behind device")
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
---
v2: use prepare_to_wait_exclusive
 drivers/md/raid1.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index be2565dee420..a95085fb3015 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -85,12 +85,20 @@ static void wait_for_serialization(struct md_rdev *rdev, struct r1bio *r1_bio)
 	struct serial_info *si;
 	int idx = sector_to_idx(r1_bio->sector);
 	struct serial_in_rdev *serial = &rdev->serial[idx];
+	DEFINE_WAIT(wait);
 
 	if (WARN_ON(!mddev->serial_info_pool))
 		return;
 	si = mempool_alloc(mddev->serial_info_pool, GFP_NOIO);
-	wait_event(serial->serial_io_wait,
-		   check_and_add_serial(rdev, r1_bio, si, idx) == 0);
+
+	for (;;) {
+		prepare_to_wait_exclusive(&serial->serial_io_wait, &wait,
+					  TASK_UNINTERRUPTIBLE);
+		if (check_and_add_serial(rdev, r1_bio, si, idx) == 0)
+			break;
+		schedule();
+	}
+	finish_wait(&serial->serial_io_wait, &wait);
 }
 
 static void remove_serial(struct md_rdev *rdev, sector_t lo, sector_t hi)
-- 
2.50.1 (Apple Git-155)

