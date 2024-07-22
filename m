Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53ABE5464A
	for <linux-raid@vger.kernel.org>; Mon, 22 Jul 2024 08:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721636295; cv=none; b=B6ir9RQ6DDcDUnmbe1Sq4SLYzZH5+4PzhLH51D0dStumoNf9+WvPFMXzMfsKIKk+hNYYHUmyb2nFAHHvgnDF6Tb3jDR7Ea1weAa6cWDaKOpJypAd8yAtv29vuC7Cc8kiuYJuMT93hzbUjBx5wY4H7oXRdy84hr0GXYUuRMxQhQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721636295; c=relaxed/simple;
	bh=Jk7ZsvCeQ5MQ89Riiz01HqNwHR4eFmj+N78+/1RPmgU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hn3HFhPKAL2QrAoPEgd6LEp0ivdcA7URrIlEgSnT0eKK3nof3RlITwp07OZ6txjbwonW+A2Netlbqg/Kn6C4qKVr4dL58KSZrGcvlrT9JT+aS3dvyx2RLIpYPhn60smYsgrRgVYRHiLw1c7SEp12uklhWvkNuEuObHCnCs7WJ/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KrsjGH65; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KrsjGH65"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721636293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6sbZKSWufDYPLpk+yo7avJJz4TOBRKFyQkUzgILprRo=;
	b=KrsjGH65Z1E5LAaNrNF/IWyB1eAblxougBpK/VdpO+3aIpz5/dTLFQt19zLz8rRDBZ4SzY
	ynQB9E6wuiPp5L1rYAUZyqtH1H/0OciUOz4bBTrSYXkbXjMMIzATga1biQO7KPfc1gSMhR
	jNQKe7JlnFXz+f8fJgEM2uN6eMhB7to=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-392-mgRAFYuAPnuyBG5WfzIjaA-1; Mon,
 22 Jul 2024 04:18:09 -0400
X-MC-Unique: mgRAFYuAPnuyBG5WfzIjaA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 085AB1955BFA;
	Mon, 22 Jul 2024 08:18:09 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.7])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8B44F1955D45;
	Mon, 22 Jul 2024 08:18:05 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 07/14] mdadm/mdopen: fix coverity issue CHECKED_RETURN
Date: Mon, 22 Jul 2024 16:17:29 +0800
Message-Id: <20240722081736.20439-8-xni@redhat.com>
In-Reply-To: <20240722081736.20439-1-xni@redhat.com>
References: <20240722081736.20439-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

It needs to check return values when functions return value.

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

