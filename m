Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6F926B0B2
	for <linux-raid@vger.kernel.org>; Mon, 19 May 2025 10:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747649380; cv=none; b=afmTRBN+viaviFylzyjHUAUrP7DF+YCuQaaGSfNUHIOvq13BOoW3iVolLHUf4zx6FF6LpN//tZ+EyDyKHI4q8ifiK7gjpJkBUSt+q6h0Dz3t+sDz/jlXrt890qqu5sFrTjEBul9ZSB2yhq8EjfPPnJvNcYEuwos1uuv6UtTBfLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747649380; c=relaxed/simple;
	bh=HH1898krjK25JpcBZ1TLUpPRraueOvBe4hNsvs8YjyY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=aIa9QR/WcpI5QNeRx0Q5UCB1VEFDW1jUl2UYvd2KFWIGZybylGqS+7kfQs1QoVlkV9kyIm0SznuPWuG4kMXLJN3gNP17Atxx8AAzJ5WgYWT2zFN4T4MG3iKbqJkXuqQ6AHW7pSYZPNNEy/I0MbkGJcLTtpjsrWIR+v2QFzvaGgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bV/iT439; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bV/iT439"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747649377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PSZ7MB2soSpTMSnsklsMI5di52vamFa079jSlGs/aXg=;
	b=bV/iT439oM6UiOSbLXB5VoVIhaVSPBzNrqy2SsG5jhbb9I27FUaOMp9BUf1aIpoXLNloND
	7JTZWt839CY7OIwcx6U+yGHl5AopqS/mHMCJtedSyL0ZbVHBLETZogXiRoW1apeW85AuS4
	TyJvIBrkInqLiSFa/rOVkoWjwIRjMjU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-503-56b6B4R0Mq6bynSSV_PDXw-1; Mon,
 19 May 2025 06:09:34 -0400
X-MC-Unique: 56b6B4R0Mq6bynSSV_PDXw-1
X-Mimecast-MFC-AGG-ID: 56b6B4R0Mq6bynSSV_PDXw_1747649373
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4F9E41955DAD;
	Mon, 19 May 2025 10:09:33 +0000 (UTC)
Received: from [10.22.80.45] (unknown [10.22.80.45])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 48B7019560AA;
	Mon, 19 May 2025 10:09:31 +0000 (UTC)
Date: Mon, 19 May 2025 12:09:28 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
cc: Song Liu <song@kernel.org>, zkabelac@redhat.com, 
    linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
    "yukuai (C)" <yukuai3@huawei.com>
Subject: [PATCH] md/raid1,raid10: don't pass down the REQ_RAHEAD flag
In-Reply-To: <04231d91-cf1f-a932-f24f-996f888f0dd7@redhat.com>
Message-ID: <c561484d-f056-2531-8fd6-27be0dabca05@redhat.com>
References: <34fa755d-62c8-4588-8ee1-33cb1249bdf2@redhat.com> <98ac5772-9931-17fd-1fc4-18d2c737b079@huaweicloud.com> <04231d91-cf1f-a932-f24f-996f888f0dd7@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

The commit e879a0d9cb08 ("md/raid1,raid10: don't ignore IO flags") breaks
the lvm2 test shell/lvcreate-large-raid.sh. The commit changes raid1 and
raid10 to pass down all the flags from the incoming bio. The problem is
when we pass down the REQ_RAHEAD flag - bios with this flag may fail
anytime and md-raid is not prepared to handle this failure.

This commit fixes the code, so that the REQ_RAHEAD flag is not passed
down.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: e879a0d9cb08 ("md/raid1,raid10: don't ignore IO flags")

---
 drivers/md/raid1.c  |    1 +
 drivers/md/raid10.c |    1 +
 2 files changed, 2 insertions(+)

Index: linux-2.6/drivers/md/raid1.c
===================================================================
--- linux-2.6.orig/drivers/md/raid1.c
+++ linux-2.6/drivers/md/raid1.c
@@ -1404,6 +1404,7 @@ static void raid1_read_request(struct md
 	read_bio->bi_iter.bi_sector = r1_bio->sector +
 		mirror->rdev->data_offset;
 	read_bio->bi_end_io = raid1_end_read_request;
+	read_bio->bi_opf &= ~REQ_RAHEAD;
 	if (test_bit(FailFast, &mirror->rdev->flags) &&
 	    test_bit(R1BIO_FailFast, &r1_bio->state))
 	        read_bio->bi_opf |= MD_FAILFAST;
Index: linux-2.6/drivers/md/raid10.c
===================================================================
--- linux-2.6.orig/drivers/md/raid10.c
+++ linux-2.6/drivers/md/raid10.c
@@ -1263,6 +1263,7 @@ static void raid10_write_one_disk(struct
 	mbio->bi_iter.bi_sector	= (r10_bio->devs[n_copy].addr +
 				   choose_data_offset(r10_bio, rdev));
 	mbio->bi_end_io	= raid10_end_write_request;
+	mbio->bi_opf &= ~REQ_RAHEAD;
 	if (!replacement && test_bit(FailFast,
 				     &conf->mirrors[devnum].rdev->flags)
 			 && enough(conf, devnum))

