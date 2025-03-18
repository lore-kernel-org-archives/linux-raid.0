Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B9946B8
	for <linux-raid@vger.kernel.org>; Tue, 18 Mar 2025 05:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742276809; cv=none; b=g3CbLEefgmAVTmfpBw375cMTDtPMF6E9/Yizrn71XTdUJRaY5RovpYHbEK7kmQSN8sSAxqSnkMm6HDVCzIdlGS6Im1dNasiwwosfDHT5lZh/Alm8Mihu0S8PBQPr1waQBrstTC85AMVOR3MTD8SOQBf0/Lv3iZHTWQAthG/T9S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742276809; c=relaxed/simple;
	bh=tabxR7qyK6PkTuUtFrHbUf92/0TfnkEHu9S5tsO32is=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aL8KapjCkYLHfJlcJV7ueRPqH+MQKJ2f3jqR5h9+4pqG7cas0MeFSNGH6vB/0RZr6k0+0AufvezeBkO3j34tTrTI41MjnHWoBKt3xyNu7OCEcnUtSvAcQYNC8d1cU+hGHiAWP18+IwOpXqxoSg/RPDLXZ3o7GxjFQPBLbJkriVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QKVxVddY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QKVxVddY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742276806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1M1bAT3rb7Wsp5/eVGPM4EvmqxRq8XhIyG0in8oo25k=;
	b=QKVxVddYXMb7fOJuF+856MhBJRVVUu5/1omTz0dX3Vyu2ZJN1gn2fs35BC20y8eCtG025Q
	XzoLxsgFqSyVT2NUGUUsGO7jK7JrNZa3G6SaPqIqyptVs4v4bRG1QZsyYOG2SEdNGl3MEA
	W0FCC7xL66EDGS2AjU3zIv9vVSHwErs=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-92-GHKgKneiMYmuuYjgxILdSA-1; Tue,
 18 Mar 2025 01:46:45 -0400
X-MC-Unique: GHKgKneiMYmuuYjgxILdSA-1
X-Mimecast-MFC-AGG-ID: GHKgKneiMYmuuYjgxILdSA_1742276804
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D07E919560B4;
	Tue, 18 Mar 2025 05:46:43 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.5])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 233BA1956094;
	Tue, 18 Mar 2025 05:46:40 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: ncroxon@redhat.com,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 1/1] mdadm: check posix name before setting name and devname
Date: Tue, 18 Mar 2025 13:46:38 +0800
Message-Id: <20250318054638.58276-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

It's good to has limitation for name when creating an array. But the arrays
which were created before patch e2eb503bd797 (mdadm: Follow POSIX Portable
Character Set) can't be assembled. In this patch, it removes the posix
check for assemble mode.

Fixes: e2eb503bd797 (mdadm: Follow POSIX Portable Character Set)
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 config.c |  8 ++------
 mdadm.c  | 11 +++++++++++
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/config.c b/config.c
index 8a8ae5e48c41..ef7dbc4eb29f 100644
--- a/config.c
+++ b/config.c
@@ -208,11 +208,6 @@ static mdadm_status_t ident_check_name(const char *name, const char *prop_name,
 		return MDADM_STATUS_ERROR;
 	}
 
-	if (!is_name_posix_compatible(name)) {
-		ident_log(prop_name, name, "Not POSIX compatible", cmdline);
-		return MDADM_STATUS_ERROR;
-	}
-
 	return MDADM_STATUS_SUCCESS;
 }
 
@@ -512,7 +507,8 @@ void arrayline(char *line)
 
 	for (w = dl_next(line); w != line; w = dl_next(w)) {
 		if (w[0] == '/' || strchr(w, '=') == NULL) {
-			_ident_set_devname(&mis, w, false);
+			if (is_name_posix_compatible(w))
+				_ident_set_devname(&mis, w, false);
 		} else if (strncasecmp(w, "uuid=", 5) == 0) {
 			if (mis.uuid_set)
 				pr_err("only specify uuid once, %s ignored.\n",
diff --git a/mdadm.c b/mdadm.c
index 6200cd0e7f9b..9d5b0e567799 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -732,6 +732,11 @@ int main(int argc, char *argv[])
 				exit(2);
 			}
 
+			if (mode != ASSEMBLE && !is_name_posix_compatible(optarg)) {
+				pr_err("%s Not POSIX compatible\n", optarg);
+				exit(2);
+			}
+
 			if (ident_set_name(&ident, optarg) != MDADM_STATUS_SUCCESS)
 				exit(2);
 
@@ -1289,6 +1294,12 @@ int main(int argc, char *argv[])
 			pr_err("an md device must be given in this mode\n");
 			exit(2);
 		}
+
+		if (mode != ASSEMBLE && !is_name_posix_compatible(devlist->devname)) {
+			pr_err("%s Not POSIX compatible\n", devlist->devname);
+			exit(2);
+		}
+
 		if (ident_set_devname(&ident, devlist->devname) != MDADM_STATUS_SUCCESS)
 			exit(1);
 
-- 
2.32.0 (Apple Git-132)

