Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90CB40F8EE
	for <linux-raid@vger.kernel.org>; Wed,  4 Feb 2026 14:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770213691; cv=none; b=ZnMT/s4sLSgrbJDzsrONLOtqYJIyzECZUdx0pVuKbPPPxrbN/zgsoVE94+SHtT68W5tHLS2YQZvyNWm472/wlHyl0ybSrkoP7lTIg+LSwaPreYmIl52uNLoEqNaOBqCHBexyeOPHu98AeJjhJdgVozpXAcMhzLaKqzKsNXejOiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770213691; c=relaxed/simple;
	bh=+lDrVeW2SJJBNwke/YXBfxU8zCT74cUGvHgi2eG7d9E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t+UK0rBnhgch6J0g2Jlt3pAvtWFHv2s/zfuizLxDl8jH37wBA2/o4viUWlPUQLQT8jH77Taixs88C4yLIU5RGh01cP/HrDCeHut6p795SLpj/8bA3nmR2nZWl537xz1d+6tkPONiV3+jFk9EgzDgz8o6w/PupfmdhiPl9gYVq6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CpQ9MRlg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CpQ9MRlg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770213689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3OQ8wAVVBfAmF2LsywSmj+2r0U5MR2C6aoBnc3s2BV4=;
	b=CpQ9MRlg5Xbl05nsqVUbWx6H82Ihafo1mWB4THc25Ijc4K9XLLtGGGczx9rQSVcdCrH+1u
	gt+K31Xm3OgWOOeeIpnsLVSz2KHwZkbHm0g05mKjMwKhrCL+a6SZwwNc5NGk2LjRM4XaYd
	GV3aZGUagCeWIwMpPDVP7Ln8iy0OluU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-191-v-JVdWFkNvqq2myx6sKpeQ-1; Wed,
 04 Feb 2026 09:01:27 -0500
X-MC-Unique: v-JVdWFkNvqq2myx6sKpeQ-1
X-Mimecast-MFC-AGG-ID: v-JVdWFkNvqq2myx6sKpeQ_1770213686
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C63901800378;
	Wed,  4 Feb 2026 14:01:26 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.66])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 37F701800464;
	Wed,  4 Feb 2026 14:01:24 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mtkaczyk@kernel.org
Cc: linux-raid@vger.kernel.org
Subject: [PATCH 1/1] mdadm/imsm: use creation_time for ctime in container info
Date: Wed,  4 Feb 2026 22:00:25 +0800
Message-ID: <20260204140122.8312-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

When a disk has both DDF and IMSM metadata (e.g., migrated from DDF
to IMSM or has remnant DDF metadata), guess_super_type() selects the
metadata with the later creation time. Previously, IMSM always
returned ctime=0 in getinfo_super_imsm(), causing it to lose to DDF
which extracts a real timestamp from its GUID.

This resulted in the wrong metadata being selected during assembly,
leading to boot failures when LVM activated raw PVs instead of MD
devices.

Fix this by extracting the actual creation time from the IMSM
metadata structure (mpb->creation_time) instead of hardcoding 0.
This ensures that when both metadata types are present, the more
recent one is correctly selected.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 super-intel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index e9fce12c35c7..2ff9d4862f7f 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3826,11 +3826,13 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 	/* Set raid_disks to zero so that Assemble will always pull in valid
 	 * spares
 	 */
+	mpb = super->anchor;
+
 	info->array.raid_disks    = 0;
 	info->array.level         = LEVEL_CONTAINER;
 	info->array.layout        = 0;
 	info->array.md_minor      = -1;
-	info->array.ctime         = 0; /* N/A for imsm */
+	info->array.ctime         = __le64_to_cpu(mpb->creation_time);
 	info->array.utime         = 0;
 	info->array.chunk_size    = 0;
 
@@ -3850,7 +3852,6 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 	info->bb.supported = 1;
 
 	/* do we have the all the insync disks that we expect? */
-	mpb = super->anchor;
 	info->events = __le32_to_cpu(mpb->generation_num);
 
 	for (i = 0; i < mpb->num_raid_devs; i++) {
-- 
2.50.1 (Apple Git-155)

