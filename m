Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6CB25F79B
	for <linux-raid@vger.kernel.org>; Wed,  7 May 2025 12:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746620421; cv=none; b=gi93CuucexFWCrTNcLNkbuwbsrIXmZljQFk5RtByYmPlbcKzZx+EhfnbqB2lCmahEDeHJayPu73YotndyNWNJuIRWgHUG1NIZjoGI2w5jGnon8hiy9NRwTEWAKhsTymD4Wzi4XJ0uCQkUgOUwQ8S1K8IfKlTI9Y8FkIqIoxCLlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746620421; c=relaxed/simple;
	bh=vd63MerwxKzapcJ1YRg63QDuCAiFnUPe6qCA2TEUXbo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oRMvGyUrtQCbTXIh1LGkjswxbC/X4taJeevnCzoSDE5Fk9q3i6wtyNrX0j29o5WBDdgX97zYeet9P33inumwi4oVxOoEqdv3BPSMrDLCb68cbdAXLrP/hiTYnp7HpZ+bSAKDiWfla9lo8yibIp6zGHD7feeD/WFBTtjCYfrguuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=grylZiDf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="grylZiDf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746620418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+B6xc3+9IXgbXjpVlQI0fMZZF4iEdCLWgf7slsKG5B0=;
	b=grylZiDfXYu/OimUps9gvxIYWEGtzzkW+byBaLC0Kq4jzV8kY+qqHziO9DUf0CcIwlGpj/
	Xv1SQEacZZpIiKOYWvns91trtNAAPXDTuOM0ubAXZinTkCfeuiznLoTB5nqs9S5vda1MJT
	e/DB6IH3Mz9rK0Vw/JDlR85aR48qZfo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-580-vCL7IE-iOIu711_iw1HPQw-1; Wed,
 07 May 2025 08:20:15 -0400
X-MC-Unique: vCL7IE-iOIu711_iw1HPQw-1
X-Mimecast-MFC-AGG-ID: vCL7IE-iOIu711_iw1HPQw_1746620414
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8930518003FC;
	Wed,  7 May 2025 12:20:14 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.7])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2DBE71956055;
	Wed,  7 May 2025 12:20:11 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: mtkaczyk@kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 2/3] mdadm: fix building errors
Date: Wed,  7 May 2025 20:20:01 +0800
Message-Id: <20250507122002.20826-3-xni@redhat.com>
In-Reply-To: <20250507122002.20826-1-xni@redhat.com>
References: <20250507122002.20826-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Some building errors are found in ppc64le platform:
format '%llu' expects argument of type 'long long unsigned int', but
argument 3 has type 'long unsigned int' [-Werror=format=]

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 super-ddf.c   | 9 +++++----
 super-intel.c | 3 ++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 6e7db924d2b1..dda8b7fedd64 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1606,9 +1606,9 @@ static void examine_vd(int n, struct ddf_super *sb, char *guid)
 			       map_num(ddf_sec_level, vc->srl) ?: "-unknown-");
 		}
 		printf("  Device Size[%d] : %llu\n", n,
-		       be64_to_cpu(vc->blocks)/2);
+		       (unsigned long long)(be64_to_cpu(vc->blocks)/2));
 		printf("   Array Size[%d] : %llu\n", n,
-		       be64_to_cpu(vc->array_blocks)/2);
+		       (unsigned long long)(be64_to_cpu(vc->array_blocks)/2));
 	}
 }
 
@@ -1665,7 +1665,7 @@ static void examine_pds(struct ddf_super *sb)
 		printf("       %3d    %08x  ", i,
 		       be32_to_cpu(pd->refnum));
 		printf("%8lluK ",
-		       be64_to_cpu(pd->config_size)>>1);
+				(unsigned long long)be64_to_cpu(pd->config_size)>>1);
 		for (dl = sb->dlist; dl ; dl = dl->next) {
 			if (be32_eq(dl->disk.refnum, pd->refnum)) {
 				char *dv = map_dev(dl->major, dl->minor, 0);
@@ -2901,7 +2901,8 @@ static unsigned int find_unused_pde(const struct ddf_super *ddf)
 static void _set_config_size(struct phys_disk_entry *pde, const struct dl *dl)
 {
 	__u64 cfs, t;
-	cfs = min(dl->size - 32*1024*2ULL, be64_to_cpu(dl->primary_lba));
+	cfs = min((unsigned long long)dl->size - 32*1024*2ULL,
+			(unsigned long long)(be64_to_cpu(dl->primary_lba)));
 	t = be64_to_cpu(dl->secondary_lba);
 	if (t != ~(__u64)0)
 		cfs = min(cfs, t);
diff --git a/super-intel.c b/super-intel.c
index b7b030a20432..4fbbc98d915c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2325,7 +2325,8 @@ static void export_examine_super_imsm(struct supertype *st)
 	printf("MD_LEVEL=container\n");
 	printf("MD_UUID=%s\n", nbuf+5);
 	printf("MD_DEVICES=%u\n", mpb->num_disks);
-	printf("MD_CREATION_TIME=%llu\n", __le64_to_cpu(mpb->creation_time));
+	printf("MD_CREATION_TIME=%llu\n",
+			(unsigned long long)__le64_to_cpu(mpb->creation_time));
 }
 
 static void detail_super_imsm(struct supertype *st, char *homehost,
-- 
2.32.0 (Apple Git-132)

