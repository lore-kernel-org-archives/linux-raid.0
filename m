Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0882D5C97
	for <linux-raid@vger.kernel.org>; Fri, 17 Oct 2025 09:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760692485; cv=none; b=HmA0wqiwJ7lWhr5yUDk1rmLo0jv1fLkQaKxCYn6PoiwX48G6gUuxNiYNxiLXgv3F8gV8ABJ+6iezRKw1eoxnoBQwcxTKwCnq4T4aUBI7QmeqPn6QV1NPt6fqeUAZaQx/iS/pJFllQHwgZnMzlE6Ta9Eulqa8CX3okAGjRR4cf00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760692485; c=relaxed/simple;
	bh=Tfy6LmO/gDois0pSph6lna7sNlScz9wHSH93cxN6FZA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DNSVxAzl7u5nd7FR40J4BwafZRgKfWJfopB48eKivWAD2OB6DJqfyHKdDrwyvR/KPj5E6o/uB2HZdGb3d2SspjdRB4qCmWKwL2ow8I1EZvwPiQ80P/Z4x9eH/PS6QJsS+bYBP5n7J11mNlAYWwOwN74KLDhlhW+dkhxwjq6bOEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d3wPm3nB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d3wPm3nB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760692482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=O1639JY+0KRdpV7QH7dScQ8EaS0VOiLYj4o/0FtUc0E=;
	b=d3wPm3nBYBqyIKMBv2ym8xxOfu2ZyiUp2NKP2uSU5aWXbZMq8TOGuJbD4z4piUxbzl76Qi
	Kdq68Iu6ujr9iKCIWQzBaxpZss+rzjtnSE+tuHr3FcoBa+1cp3hg9/grexTi4kHjGsMXSw
	NMWCi1At1dPPHTtwySRuVPpkBjxQAp8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-615-jwWhJAfZN8mi2hZwrNVJOQ-1; Fri,
 17 Oct 2025 05:14:38 -0400
X-MC-Unique: jwWhJAfZN8mi2hZwrNVJOQ-1
X-Mimecast-MFC-AGG-ID: jwWhJAfZN8mi2hZwrNVJOQ_1760692478
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 166CF19560A1;
	Fri, 17 Oct 2025 09:14:38 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.6])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A0B86300019F;
	Fri, 17 Oct 2025 09:14:35 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: mtkaczyk@kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 0/2] -If can't work if sync is running
Date: Fri, 17 Oct 2025 17:14:31 +0800
Message-Id: <20251017091433.53602-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Xiao Ni (2):
  mdadm/Incremental: wait a while before removing a member
  mdadm/sysfs: close fd before return

 Incremental.c | 22 +++++++++++++++++++---
 sysfs.c       |  5 +++--
 2 files changed, 22 insertions(+), 5 deletions(-)

-- 
2.32.0 (Apple Git-132)

