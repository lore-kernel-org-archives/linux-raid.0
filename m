Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C0318E02A
	for <linux-raid@vger.kernel.org>; Fri, 18 Oct 2024 08:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729241311; cv=none; b=b9aK+xgDktFfOXt8UvE5rL3n2ICmbBoWZw8ILXq9CGRUb+BoBqXPme3jcdOIR4ctcz4ruQd+w3FMPlWyIIwWmY/UUey7FKxO7T/cGxABvsOO3oOe7eq1OX3icllOGYA69bAGH2RFH3t/Oi8Kz/GwAJZoK4av1aXZQLQkZE4ezKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729241311; c=relaxed/simple;
	bh=Px+sYXR4qfb6dJz+jDkiG9pRpMU6CIShh7UL8d3Adm4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SxENpXQyp/EO6qS9O2O+yDu0LMejHvBdFpG2je+BFDwo9ldYfLX/svS/8nGoFf/hVqwBdYNvTE/Rb0MapDTIvDt1iFieRExcQnxOcYUs5DIgHohrizy3DZ2a7JsX0pInuH+2yFYXmPhiwDSEjMY9Ph9ZSY+NMwF9EF98FX7vpUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DL/KTwdo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DL/KTwdo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729241308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=POvgWO1KE7WbgwFgAuVmEJs/HEac2UqpD1zX4KRn+Sw=;
	b=DL/KTwdoFpz6qAzcAjg1ywFuFBpZVzY0Bc/15sfudAcj8kxFvc3J2cFGuIwUiMpW8ZP7RX
	4now6nAC62GUo6F6PcMInNYM5p+/R4D+BsX7AK4ExszV3NHMfFJIPkkK/2QJEIXoJnpP/Z
	Mh5q4SX18DL0wdczwHAAtjPx6O7wKi0=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-529-aoA4AENwM16r1N9S_Y5n-w-1; Fri,
 18 Oct 2024 04:48:27 -0400
X-MC-Unique: aoA4AENwM16r1N9S_Y5n-w-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7287B1955F3F;
	Fri, 18 Oct 2024 08:48:26 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.5])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 50E2C1956086;
	Fri, 18 Oct 2024 08:48:22 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	ncroxon@redhat.com
Subject: [PATCH V2 1/2] mdadm/Manage: Clear superblock if adding new device fails
Date: Fri, 18 Oct 2024 16:48:16 +0800
Message-Id: <20241018084817.60233-2-xni@redhat.com>
In-Reply-To: <20241018084817.60233-1-xni@redhat.com>
References: <20241018084817.60233-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

The superblock is kept if adding new device fails. It should clear the
superblock if it fails to add a new disk.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
v2: change type of add_new_super to bool
 Manage.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Manage.c b/Manage.c
index 246ef3194aaa..8c58683b83c1 100644
--- a/Manage.c
+++ b/Manage.c
@@ -793,6 +793,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 	int j;
 	mdu_disk_info_t disc;
 	struct map_ent *map = NULL;
+	bool add_new_super = false;
 
 	if (!get_dev_size(tfd, dv->devname, &ldsize)) {
 		if (dv->disposition == 'M')
@@ -1011,6 +1012,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 			goto unlock;
 		if (tst->ss->write_init_super(tst))
 			goto unlock;
+		add_new_super = true;
 	} else if (dv->disposition == 'A') {
 		/*  this had better be raid1.
 		 * As we are "--re-add"ing we must find a spare slot
@@ -1078,6 +1080,8 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 	map_unlock(&map);
 	return 1;
 unlock:
+	if (add_new_super)
+		Kill(dv->devname, tst, 0, -1, 0);
 	map_unlock(&map);
 	return -1;
 }
-- 
2.32.0 (Apple Git-132)

