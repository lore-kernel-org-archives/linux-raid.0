Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1B5B64E
	for <linux-raid@vger.kernel.org>; Mon, 15 Jul 2024 07:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721029001; cv=none; b=JudlCiZr05dl8AcQhMOYdp3Op85CnTA2wAm3gDniOcorgXv6pgFEMHokhRL9ONPxqxhOa58UDuiVKJx6BzQMoJz6lV6oTaJy1utxDhR6aVevMwkxqcgy5/PN1mnvEURNMX4qzTrFkgn+5AX3mvrZ8Bq2heZQuuczdITZy8Ho1IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721029001; c=relaxed/simple;
	bh=RXP23DtOGXK3+tSFqXY9Slz7KKDcP0oaZeOOZflPLmQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OPXhIzrmcyk0WqUxe8tjhv+OJqRXarZ0K/gKB8FD0cCUwh0zCUn6jbnKaCJrNv7YW3CRVh1AgnpbzTmm+tFsVOYrham6aNhyZnPVAsAWxQTjHJuw3ndVh1Vk7YBTYjyrJolCsUfYc2lBHOUCiDMEg2h1MP9IkV5zNj3+SC8j1OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QS8MR5vs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QS8MR5vs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721028998;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gVW31/ozUUqNbCMMDDl8mTcttCzEnh444FPD7Xp2PMM=;
	b=QS8MR5vsmmZISAK0HabvvCCuP6Ckd+ObhmjIdp2jKIwcvb19ijSnXuGTaR4GeIgeV3zjUT
	zFcpd4VWtfGkhj5GNVuz8Q1szv7byrwgnrxXamMcbZqPmGqKawwXNb9h2ZaYebYyXcL/D0
	XrsUrkFWnjBUqxE8GqXaKoV6uJ7yCoI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-456-dbvZPRtDM3-RN0c-7AM7dw-1; Mon,
 15 Jul 2024 03:36:37 -0400
X-MC-Unique: dbvZPRtDM3-RN0c-7AM7dw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 66F5E195609F;
	Mon, 15 Jul 2024 07:36:36 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.27])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CAE891955D44;
	Mon, 15 Jul 2024 07:36:33 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 08/15] mdadm/mdopen: fix coverity issue CHECKED_RETURN
Date: Mon, 15 Jul 2024 15:35:57 +0800
Message-Id: <20240715073604.30307-9-xni@redhat.com>
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
 mdopen.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mdopen.c b/mdopen.c
index eaa59b5925af..c9fda131558b 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -406,7 +406,11 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 				perror("chown");
 			if (chmod(devname, ci->mode))
 				perror("chmod");
-			stat(devname, &stb);
+			if (stat(devname, &stb) < 0) {
+				pr_err("failed to stat %s\n",
+						devname);
+				return -1;
+			}
 			add_dev(devname, &stb, 0, NULL);
 		}
 		if (use_mdp == 1)
-- 
2.32.0 (Apple Git-132)

