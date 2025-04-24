Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5591F22127E
	for <linux-raid@vger.kernel.org>; Thu, 24 Apr 2025 10:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745488859; cv=none; b=aNU6r6D4RfIimCb4Fi7yUbaFVboDgjFZSoRBl4e/nmNmngmWq19VEFcaFIvitDJavlHtg5QXSR/JtX1GoRIMk3wJJsBXWb84c4iK/waxxhh05A0E6eB2LDaYWnGgWEplvd9cIaIvAJb69Wz4+5P5d/WCgb9MDJtUKg45Qm6EiQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745488859; c=relaxed/simple;
	bh=xSPS54+b5vXW2NEk3zvZDXCALMtX0h7FdD1fYWcjB6A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Kwo6NYs94kgur/kjXCewQRENiS8MHhRZLwIsMXM7+CzucpyUHyAHcrWwzzJZBDe1gS3CMBihlD83tV9J8LHoJVWmFfcG2z7I2Eush1YJSobxBxQv109coCyvVB2S9FMND10Y1nJOUg1doIshgeymBmI1kcunawsL3FxCUMOlluQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CJWLDgcl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CJWLDgcl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745488856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=80WwSw3syy1gssHL6Bqix6TpUcrpZU7KAodnt6Yi+r4=;
	b=CJWLDgclxLE2JFKaxszdyaHJ0c7K8xAeM0I4pRx/0B8gotKvivuavKWJe5xLTO5JZLgjjA
	udkcZi296youb3oZsOuxhVAMmxhZ33xoA4hm2b9EPWLUQulwOoQG5hPOkii2eK60uyaGch
	wF3ZvVUXWYpf/Ji0rN8ue6k6uUZSRUQ=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-52-E3oc-SHON4G6orx1VRyiyg-1; Thu,
 24 Apr 2025 06:00:52 -0400
X-MC-Unique: E3oc-SHON4G6orx1VRyiyg-1
X-Mimecast-MFC-AGG-ID: E3oc-SHON4G6orx1VRyiyg_1745488851
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E57CD195608A;
	Thu, 24 Apr 2025 10:00:50 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.20])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6107418001DA;
	Thu, 24 Apr 2025 10:00:46 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	yukuai1@huaweicloud.com,
	ncroxon@redhat.com,
	hch@lst.de
Subject: [PATCH RFC 0/3] md: call del_gendisk in sync way
Date: Thu, 24 Apr 2025 18:00:41 +0800
Message-Id: <20250424100044.33564-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

This patch clears some flags and counters related stopping an array
and calls del_gendisk in sync way.

Xiao Ni (3):
  md: replace MD_DELETED with MD_CLOSING
  md: replace ->openers with ->active
  md: call del_gendisk in sync way

 drivers/md/md.c | 67 ++++++++++++++++++++++---------------------------
 drivers/md/md.h | 13 ----------
 2 files changed, 30 insertions(+), 50 deletions(-)

-- 
2.32.0 (Apple Git-132)

