Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3E8B64E
	for <linux-raid@vger.kernel.org>; Mon, 15 Jul 2024 07:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721028991; cv=none; b=bDrSw+arwjw+DZwooQb3URxXGFGBs/0XwU+Y3lj/DjyvNKlXKh7eMAZaluwG0mEDFwj2XW0hfbbnA7hWmJJKgTxenxiTrrWCwkt2BkN3/gB8cLhPJj+d8G34F+LzI3EuncCiHNxEyf+wSM9/JBPTfIMkX0NN03zwC6hiMUfS3CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721028991; c=relaxed/simple;
	bh=aRiZ0JTkgXvqyHitZ/WnqMEca+aIqmaagVVrGH2XbSQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SdVhDwQgJxTZoyDzbJ0NUkSiZg5f8k4jBko+O8Xshl+d5QyGLUwuH4jajbPfsnNokzkgbJdSHKcPLdw3suPzxSFpR24MHkYyIuX5/G2bEsArAAq0u+1Cn5nTjHG3iZIyK2yQ8sYo9k/wiP4pSXJ5SR1I42S7SHyX1GfwatjYqA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ONFZZ+Wd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ONFZZ+Wd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721028988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JIhtR+yxrMSFsbe07NAfDG1CFlJeCCCk+vt2hurQzTQ=;
	b=ONFZZ+Wdi70WcpOBUMvSlZHsN59V+2AkuigtdTAbNfuNw32oh2n0OOTm8p41nmqtBn7eO+
	Ctm8JxrJsIg7GshH5f+3whwImxm8EqFVj7WE4nkCewoCXuy8nuKn74l1WmttVwdobfcUpv
	4yW1lJBnmGvWX5BrVmuROqC9rTENrQ8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-616-PCDgpbN1PkWjP4Lf1Vk1pQ-1; Mon,
 15 Jul 2024 03:36:24 -0400
X-MC-Unique: PCDgpbN1PkWjP4Lf1Vk1pQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 08DA91955D44;
	Mon, 15 Jul 2024 07:36:23 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.27])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AF8471955D42;
	Mon, 15 Jul 2024 07:36:20 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 04/15] mdadm/Grow: fix coverity issue STRING_OVERFLOW
Date: Mon, 15 Jul 2024 15:35:53 +0800
Message-Id: <20240715073604.30307-5-xni@redhat.com>
In-Reply-To: <20240715073604.30307-1-xni@redhat.com>
References: <20240715073604.30307-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Grow.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Grow.c b/Grow.c
index 632be7db8d38..24f8eb8d3dee 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1694,6 +1694,8 @@ char *analyse_change(char *devname, struct mdinfo *info, struct reshape *re)
 					/* Current RAID6 layout has a RAID5
 					 * equivalent - good
 					 */
+					if (strlen(ls) > (40-1))
+						return "layout %s length is bigger than destination";
 					strcat(strcpy(layout, ls), "-6");
 					l = map_name(r6layout, layout);
 					if (l == UnSet)
-- 
2.32.0 (Apple Git-132)

