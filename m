Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3946117E46E
	for <linux-raid@vger.kernel.org>; Fri, 18 Oct 2024 08:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729239737; cv=none; b=uMjgdRqrl+BlGHrnASlMjtcwKPLNe2HLLEGiEtmDbZdTEooWM7z37lDsrucM9372PwheULcuSckrcqhv36LxIJTWbg3rTtxuvXINJugV6ZhImaYK7ht6EARFODxMwePwSu5LegdaT9oPwKFna1S5TOxEm2QgTIq5eynTa5Djj98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729239737; c=relaxed/simple;
	bh=PkG8p3c9aH+4389k2FRvGNQWVwVUYzmjWybU0f/cz0k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CJtI6dwC9Z6c88zeBQ+izIocXsmhSW7M9ypH9QjhQgDpzixGibDMEyqSMQhgO+MYKkZ/ScfA70Bjqxo5hO7wAQGGAEUCXPSZB+NmSwoHnGMhkqZ1ZKMVaebV6ZIkLvI1dxpeAbkce48u7Va8bgp5RfPnVDwo/HzWdM7cdRI/JI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WbxbSw3q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WbxbSw3q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729239734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2/d2rVBz84tVT8ySM4MG1UeNs4Cw3FcmHRHfnPyciI0=;
	b=WbxbSw3qi1U5eANmPpDey3k0R8st1taCJAHWuHqUpxRefYWyNumTOvfXTS7u1UF/ClWdGv
	JYJVVznWZOqsG5aRYu9R4L9ZPHtzxWz/mJpM+Ff7g6QyA/URZU4nsrOUSPfO4dN7nLb9be
	Sor4h4bIG1jZeqRv4hlOezK+HY0NLK8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-449-i8Qt1czbN1-7PiGn13r_rg-1; Fri,
 18 Oct 2024 04:22:10 -0400
X-MC-Unique: i8Qt1czbN1-7PiGn13r_rg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C8501955EA5;
	Fri, 18 Oct 2024 08:22:09 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.5])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D9C7919560A3;
	Fri, 18 Oct 2024 08:22:06 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 0/2] mdadm: minor fixes
Date: Fri, 18 Oct 2024 16:22:01 +0800
Message-Id: <20241018082203.59963-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Xiao Ni (2):
  Clear superblock if adding new device fails
  Check new_level interface rather than kernel version

 Grow.c   | 2 +-
 Manage.c | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

-- 
2.32.0 (Apple Git-132)

