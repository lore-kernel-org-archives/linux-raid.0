Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C437120309
	for <linux-raid@vger.kernel.org>; Wed, 28 Aug 2024 02:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724811144; cv=none; b=UiqqPpb6fzeULQ6rhWBGWRfMTVLTOtvuGngcA+RsUf11q5d1tRZH5V3PI+/naUaddxMiTE+G+rbfsPcz+9pMiMVJ7M/KJPiJggDF8bugP22Y7inw3qZiUTdaAixRLRdTKB0W02EakXzqvHVyb47gvRhCMh8MwdVHhQLzMuixJNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724811144; c=relaxed/simple;
	bh=4qfbl9hAQorvWZFfbf64JRp8MibxyiOhcrCScnW8zNI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T3o9rah29ozbKO/fBfucE0QaPGF/m44xLyRd/3VS1lisF4SM8GF4ExcV2EtgadfUbAi4T85TuL2babH4Jqa7T3MS47TPc4STQWkiur3wc8CW7h0G2oPsx2gyJz13THcx2lA5fYSrNBb0MCfRbCMJeJ/3bdPTQz5ywer9qTlIJGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K1PFZubG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K1PFZubG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724811141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GT16vcBr50+XsM1YmgUEHGZtATf0H3H7SFTEBryLmto=;
	b=K1PFZubGwolKxDWEvi1L2Cm7ilEIssRhQYWCxDoUaL3THOjFyA8zEEPRkEXGgXGdsOG2uu
	F4iJ87JWQOz6NDvs+94fkZZyMBiXPjF4uxJxpMbJcxxw2Lv8HdDE54l8J1ddTCzZgnr8st
	fngEaHSs+iAIJnJyOsi10PiILZEtgIQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-448-0MYKwHxzPY-hX9LNafSscQ-1; Tue,
 27 Aug 2024 22:12:16 -0400
X-MC-Unique: 0MYKwHxzPY-hX9LNafSscQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C55481955BFE;
	Wed, 28 Aug 2024 02:12:15 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.24])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 91D0D3001FF9;
	Wed, 28 Aug 2024 02:12:11 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 01/10] mdadm/Grow: Update new level when starting reshape
Date: Wed, 28 Aug 2024 10:11:41 +0800
Message-Id: <20240828021150.63240-2-xni@redhat.com>
In-Reply-To: <20240828021150.63240-1-xni@redhat.com>
References: <20240828021150.63240-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Reshape needs to specify a backup file when it can't update data offset
of member disks. For this situation, first, it starts reshape and then
it kicks off mdadm-grow-continue service which does backup job and
monitors the reshape process. The service is a new process, so it needs
to read superblock from member disks to get information.

But in the first step, it doesn't update new level in superblock. So
it can't change level after reshape finishes, because the new level is
not right. So records the new level in the first step.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Grow.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Grow.c b/Grow.c
index 5810b128aa99..97e48d86a33f 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2946,6 +2946,9 @@ static int impose_reshape(struct mdinfo *sra,
 		if (!err && sysfs_set_num(sra, NULL, "layout",
 					  reshape->after.layout) < 0)
 			err = errno;
+		if (!err && sysfs_set_num(sra, NULL, "new_level",
+					info->new_level) < 0)
+			err = errno;
 		if (!err && subarray_set_num(container, sra, "raid_disks",
 					     reshape->after.data_disks +
 					     reshape->parity) < 0)
-- 
2.32.0 (Apple Git-132)

