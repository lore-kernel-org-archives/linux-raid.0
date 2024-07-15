Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832DD22EF4
	for <linux-raid@vger.kernel.org>; Mon, 15 Jul 2024 07:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721029025; cv=none; b=WPbqsGBdaignpvz+FK9Xsm7M/39zs8U+I9qW3h6M6Gzx9RKjGv+Vo3sOI7jV8K1fR3fkZs257Cerx2lfmqRahW0KvQaZQTMEkx9DRx9d3nJ0XLCAMVoRrSCuo3kftT2g79jmh9dnJWBNttsI3j4rFRv+I+Izn9Om522psw/bcRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721029025; c=relaxed/simple;
	bh=k9C+qwxwT+8zmvvXeECuL6SM1MpukA+JKTkicTFibqk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o7RHAL5dlakjBFoQeBHj00RGcP3iqKcepuw9lQeIFHyLrh3F3sAYY3U1sGmjBpmYPIYPZKJ6JQwlj9+hogqmlmSfnPlLcyyApi12xTfc5EcBkkRMnU5IT6lqiFgxbQzWBt+Evm+PO8FLrjFQr8cz15LsLZ6tntHsq2/4MADELHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kvu1Dcak; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kvu1Dcak"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721029023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=loCkOTgHVwH+LIqyvWVyzmSINYz0omLTflX14X4MP2s=;
	b=Kvu1DcakqJO+Ll+GnUHCgKzIOAv7atDKhaF4tU9ppV2omVMQbbbid9lmzVTcBIpp4Lml8q
	RTwNKS3eYYyFKk6Byam/bUNAKszFHHzH8ZqbRAoxSnQz2GkZZW5BYintDHy+MtjhP/9FAv
	w8bJOeqlbQvWyNk5UcIXJVQz0o2jhi0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-655-__Nsrfb8OrqldqXpzk6ljQ-1; Mon,
 15 Jul 2024 03:37:00 -0400
X-MC-Unique: __Nsrfb8OrqldqXpzk6ljQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 73CF81955F40;
	Mon, 15 Jul 2024 07:36:59 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.27])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D7EB51955D42;
	Mon, 15 Jul 2024 07:36:56 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 15/15] mdadm/super1: fix coverity issue RESOURCE_LEAK
Date: Mon, 15 Jul 2024 15:36:04 +0800
Message-Id: <20240715073604.30307-16-xni@redhat.com>
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
 super1.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/super1.c b/super1.c
index 243eeb1a0174..9c9c7dd14c15 100644
--- a/super1.c
+++ b/super1.c
@@ -923,10 +923,12 @@ static int examine_badblocks_super1(struct supertype *st, int fd, char *devname)
 	offset <<= 9;
 	if (lseek64(fd, offset, 0) < 0) {
 		pr_err("Cannot seek to bad-blocks list\n");
+		free(bbl);
 		return 1;
 	}
 	if (read(fd, bbl, size) != size) {
 		pr_err("Cannot read bad-blocks list\n");
+		free(bbl);
 		return 1;
 	}
 	/* 64bits per entry. 10 bits is block-count, 54 bits is block
@@ -947,6 +949,7 @@ static int examine_badblocks_super1(struct supertype *st, int fd, char *devname)
 
 		printf("%20llu for %d sectors\n", sector, count);
 	}
+	free(bbl);
 	return 0;
 }
 
-- 
2.32.0 (Apple Git-132)

