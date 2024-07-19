Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA45180639
	for <linux-raid@vger.kernel.org>; Fri, 19 Jul 2024 09:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721382775; cv=none; b=DbSJHlNLHve1yuOpNKonEyAUwuIuJhAW+Z7vC/0DRqvKjL7w8efthvp4rW1rMZsRvAbSJrXD6LmLD1b6/0T6jAdyXkqL6h1P0sLreV9uqgPmER8ddwJbFSjWBAXulzQspsR76jqw0NR78E1UzwT0SJpM2IsbB6axexn7TqrM6RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721382775; c=relaxed/simple;
	bh=tag5BlftefiepJqc7jkWwcTRjCO/ns9zT6GikqDABIk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fcZgZiduR8J3pX+dXrR0RtEXDY32Q0SsrpuezBqXXygf9dfEE0uo4b7DO3fnUhilU/reaRec6pRqSDluRsgg29AkjSnJGyF8irzPMcbF+RmTkaAeWf4WvzEb7lq5eW0XPKsbNmSzfYj3UiEFjBaMQ061KCpIwTF3xj/0eK9eFEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B/srJ3FK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B/srJ3FK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721382773;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ySk5ed983etPNR4bLHTO3/Hak9aRMCgSrgfYZy1ukuo=;
	b=B/srJ3FK324l2OzAZ9lIYfnJfySC93q3fgfkGOjatVU3J9mA4ZwmtIkUg3k3E8S0TilIJX
	Q6/eoBp9fgmwhBo6knTZQuVyMlv8ANrxbHA18SzjS2STuLroo529jTFnISy/rRa8KfZxU1
	N81zvoiQbV8cLVqJTbaQjV4Z1r+Ku9Y=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-219-8E7m3fC0NRmV2naVyjjCKg-1; Fri,
 19 Jul 2024 05:52:51 -0400
X-MC-Unique: 8E7m3fC0NRmV2naVyjjCKg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CFBD51955BEF;
	Fri, 19 Jul 2024 09:52:50 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.6])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5038419560B2;
	Fri, 19 Jul 2024 09:52:47 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 07/14] mdadm/mdopen: fix coverity issue CHECKED_RETURN
Date: Fri, 19 Jul 2024 17:52:12 +0800
Message-Id: <20240719095219.9705-8-xni@redhat.com>
In-Reply-To: <20240719095219.9705-1-xni@redhat.com>
References: <20240719095219.9705-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 mdopen.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mdopen.c b/mdopen.c
index eaa59b59..c9fda131 100644
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
2.41.0

