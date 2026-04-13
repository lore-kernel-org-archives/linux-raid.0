Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539EC1A680B
	for <linux-raid@vger.kernel.org>; Mon, 13 Apr 2026 22:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776120363; cv=none; b=bizCEfGlBSU3tr2SApohugsixzhVIRHvTf1cxeyjXUJt/01M6a7RXa3AffnYTopjPtL/ZjzqRJxeGvGPiWdFG5uWsWbiLUd2AKubAxgrFj8GPeTPWYtO6M8PjTxf7zlHaRUt9icX/kn2Igpe6NbpFB5AI9iumLRatsn2ivNw1Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776120363; c=relaxed/simple;
	bh=+eAb+RTmhMrwJDsMgjYOwzlsqjhfdHS1JyxZlD5AGlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GKP79ZMoQsraHbdmpwgHlHcLGkRIhiiitgPM+9q1vm9ABMy5p/ZBkiO9/NbbVuPOtTOGQmDj69fEXX6SLl01WJAakBGGc9B2mtKoAEs2OJMsVOMjstKkUMTtaEHdNyiywBe4aTiU5MGbB3pRvdmlEh+vTAZdvLxUAUi5bBKaOqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E0ZZypH2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E0ZZypH2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776120361;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=03pBm6xfAaUOYFwcJ0CcDvIZCyj6b0opiY7GcQOqij8=;
	b=E0ZZypH2OdHhg/ZsRHn2u5riMEU7U9ia9O5LjWwrFPSAJrHUvjxfEWs039yg5oieo5xoFY
	TA9DuV1n0tNb7m1mfEE56d533SyMBEhthq9A4nI1xoEHodQ742KBi9Xz56qzkM4hZKT7L+
	XERfQpdouAuUmOMgICVqv9gNQodd7bw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-680-x5WnlnbvPum6w1jWdXO4cw-1; Mon,
 13 Apr 2026 18:46:00 -0400
X-MC-Unique: x5WnlnbvPum6w1jWdXO4cw-1
X-Mimecast-MFC-AGG-ID: x5WnlnbvPum6w1jWdXO4cw_1776120358
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 919AA195608E;
	Mon, 13 Apr 2026 22:45:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EEE7E1955D88;
	Mon, 13 Apr 2026 22:45:57 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63DMjuJR1914513
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 13 Apr 2026 18:45:56 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63DMjuxr1914512;
	Mon, 13 Apr 2026 18:45:56 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>,
        Song Liu <song@kernel.org>, Li Nan <linan122@huawei.com>
Cc: linux-raid@vger.kernel.org, dm-devel@lists.linux.dev,
        Xiao Ni <xni@redhat.com>, Nigel Croxon <ncroxon@redhat.com>
Subject: [PATCH] md/raid5: Don't set bi_status on STRIPE_WAIT_RESHAPE
Date: Mon, 13 Apr 2026 18:45:56 -0400
Message-ID: <20260413224556.1914504-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

When make_stripe_request() encounters a clone bio that crosses the
reshape position while the reshape cannot make progress, it was setting
bi->bi_status to BLK_STS_RESOURCE when returning STRIPE_WAIT_RESHAPE.
This will update the original bio's bi_status in md_end_clone_io().
Afterwards, md_handle_request() will wait for the device to become
unsuspended and submit a new cloned bio. However, even if that clone
completes successfully, it will not clear the original bio's bi_status.

There's no need to set bi_status when retrying the bio. md will already
error out the bio correctly if it is set REQ_NOWAIT. Otherwise it will
be retried. dm-raid will already end the bio with DM_MAPIO_REQUEUE.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/raid5.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index dc0c680ca199..690c65cd1e29 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6042,7 +6042,6 @@ static enum stripe_result make_stripe_request(struct mddev *mddev,
 	raid5_release_stripe(sh);
 out:
 	if (ret == STRIPE_SCHEDULE_AND_RETRY && reshape_interrupted(mddev)) {
-		bi->bi_status = BLK_STS_RESOURCE;
 		ret = STRIPE_WAIT_RESHAPE;
 		pr_err_ratelimited("dm-raid456: io across reshape position while reshape can't make progress");
 	}
-- 
2.53.0

