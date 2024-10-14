Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1A8101EE
	for <linux-raid@vger.kernel.org>; Mon, 14 Oct 2024 01:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728869258; cv=none; b=WdRfO7kr0rOhxtgjTCIDnblkA5PowvlU1s5mkGdL14VCnDGh/6ZtkU0787hNB6eyZpe+aWXEiqbqiTLsdbE2wlHN9cUHKqx5A4m7ads1a+u4xt3RxO5XExR7a4Od0QJ7DNVOotUlDsoITqEvisbVFC7mvQNoVUNlTrxL2BhlLBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728869258; c=relaxed/simple;
	bh=4ZUXS+fpXMj0rqGVsOfAWazL9hWyK+uoeVHAyuMdy7c=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=I7fl+Z4e11AHBNIPQHcbwr3jBeDhPwbBTl8CxYyzgRyXgqNLzPZNhO/rlaOTHmG6xqoAebNMtoASX+vI5Cg0BpbU/jzw7SHqoxNP5eN64s7NI7RWfJowTxavekakswfjDiuSXZbQMNaM3hRYzpkfOy1sTdZwzGbHTimErPgX5h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ttt0v0IY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ttt0v0IY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728869254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=4ZUXS+fpXMj0rqGVsOfAWazL9hWyK+uoeVHAyuMdy7c=;
	b=Ttt0v0IYBBbdkVJ047e6RWuE0fh0JKwhzPs0JKDX0fVe2LjWue1R1Q7VQqqE/sibnhx+QP
	ZPDpRO0OA3Ghvon45IA5N+4i+vaO6OnYafR7UO8MtknxfRgkZRLMO1B6K0R3NqUsPZCAHd
	Ft+zESLRlMRyWYMggBtL0jzAcUK4lFU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-580-xMTe649hPVCV0sK32Rfkpw-1; Sun,
 13 Oct 2024 21:27:31 -0400
X-MC-Unique: xMTe649hPVCV0sK32Rfkpw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1A80619560B1;
	Mon, 14 Oct 2024 01:27:29 +0000 (UTC)
Received: from fedora (unknown [10.72.116.46])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3794819560AA;
	Mon, 14 Oct 2024 01:27:22 +0000 (UTC)
Date: Mon, 14 Oct 2024 09:27:17 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Hamza Mahfooz <someguy@effective-light.com>,
	Christoph Hellwig <hch@lst.de>,
	Dan Williams <dan.j.williams@intel.com>
Cc: ming.lei@redhat.com, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, linux-raid@vger.kernel.org,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [Report] annoyed dma debug warning "cacheline tracking EEXIST,
 overlapping mappings aren't supported"
Message-ID: <ZwxzdWmYcBK27mUs@fedora>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Hello Guys,

I got more and more reports on DMA debug warning "cacheline tracking EEXIST,
overlapping mappings aren't supported" in storage related tests:

1) liburing
- test/iopoll-overflow.t
- test/sq-poll-dup.t

Same buffer is used in more than 1 IO.

2) raid1 driver

- same buffer is used in more than 1 bio

3) some storage utilities
- dm thin provisioning utility of thin_check
- `dt`(https://github.com/RobinTMiller/dt)

I looks like same user buffer is used in more than 1 dio.

4) some self cooked test code which does same thing with 1)

In storage stack, the buffer provider is far away from the actual DMA
controller operating code, which doesn't have the knowledge if
DMA_ATTR_SKIP_CPU_SYNC should be set.

And suggestions for avoiding this noise?

Thanks,
Ming

