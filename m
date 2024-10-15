Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D5C1AF0CF
	for <linux-raid@vger.kernel.org>; Tue, 15 Oct 2024 17:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729013764; cv=none; b=hXzJQhK0lPVjrIKgdCqcKNDWIIA4B3LC0AUnMwABpyUE8imcAkEji0cecjsF9xPao/WKC2uf+5VGLeUSjYQ63gAOS1FXlkoWw83BGNSNeH6a7CoFYZniYdDt4qpw6uQQFcBBPjzLULrRFBvuU1noeMUdcll+tAhmoHtJpVabqP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729013764; c=relaxed/simple;
	bh=y1zxvhOTjKEHdR1KJbymAkdsssLbQUVHcxEj5DtU33w=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=GP5yyA+ygBVYfvlM4Zm0eN5MTdSJpnZkhCBpbqqYuDuboM+/f/r4tkC0zYXNIgxKSgcW/JqoZjZIW01CHP+jNJMlox7+8jSZZLOLy8lUxYPZKYsJw4L3Ay2io9Lm0QN72vl8zJ+QqNsRcFCflDMyAf3ICLzSHFJlk0l60cgqrKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F/OVO2y9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F/OVO2y9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729013760;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=m4DpcWDpPylx//Fe12J05As8Kvs0djHi3yxVshD28Yw=;
	b=F/OVO2y9HYnkCsyXIAOAfM/ngjZ7AEyIm1l+QSnfALCssOCzQA730XWDvqOSIJQ0qU1ELd
	0A3PREafQRJiKL/70DOZAlbVSJhUTr0qn6BR6dqUH5wpZQWPZaS4vblO5bbgI38A7xeu06
	WPpSWip0rVVKwumLFLox2akOsEj1iCg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-325-B1tp8BSGOMGvtoiqIrZH8w-1; Tue,
 15 Oct 2024 13:35:58 -0400
X-MC-Unique: B1tp8BSGOMGvtoiqIrZH8w-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7CC8D1956089
	for <linux-raid@vger.kernel.org>; Tue, 15 Oct 2024 17:35:57 +0000 (UTC)
Received: from lobefedora.redhat.com (unknown [10.22.17.196])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A288A1955E93;
	Tue, 15 Oct 2024 17:35:56 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: linux-raid@vger.kernel.org,
	loberman@redhat.com
Subject: [PATCH] Add the ":" to the allowed_symbols list to work with the latest POSIX changes
Date: Tue, 15 Oct 2024 13:35:24 -0400
Message-ID: <20241015173553.276546-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
 lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib.c b/lib.c
index f36ae03a..cb4b6a0f 100644
--- a/lib.c
+++ b/lib.c
@@ -485,7 +485,7 @@ bool is_name_posix_compatible(const char * const name)
 {
 	assert(name);
 
-	char allowed_symbols[] = "-_.";
+	char allowed_symbols[] = "-_.:";
 	const char *n = name;
 
 	if (!is_string_lq(name, NAME_MAX))
-- 
2.42.0

