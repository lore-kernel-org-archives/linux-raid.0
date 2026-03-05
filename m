Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C201D514E
	for <linux-raid@vger.kernel.org>; Thu,  5 Mar 2026 01:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772673437; cv=none; b=k3e+vsxexFRVx7/cLxeSuC+pTmXmy6X5YV7A3HXDZeA5gR2+zyEgBTl5YSFmUv4TomuXaU5R1Fl9FJhO/GV6CNIFRxqiJMRACvkoAw4I/Ed4ITpHPYb9nOts0GNl+oFa+SC+8zaQjduHebhorUmxFpQz6UE4NvAnLP1ybT38cao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772673437; c=relaxed/simple;
	bh=Vcw4rlARdD1959OswOXHqUCiCZOes0xs/t2Mw0FSdZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ewN19J1YzM31AeNpRhJdSLLb6gCPxHLfJCd6gTACfcmRZlXfR4LOhr1lEyYU0q1fVuCNbm2K+DpcJhASv8W9ZeQLDp1CDlkOj46W54idzo0jSFXmPRynM+a/EG/yAKQ9I6vfGDENJEogon09JqlPVdkLfPONbxECy5H4Utek618=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dN/QBbdQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dN/QBbdQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772673433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Mf2xoFwp/Rnx8FZwMbu/RgFD13wInqP81iICptnUJ4A=;
	b=dN/QBbdQp25ZRbEwGm6GnEyYyYdfAC30EXFgknCGF6xJ/C+5D+CAnt33J/VCLbyEf9Rfd7
	XeTWNxlTya9pJTfLWTLGo8pA9kq9ted5uLPG/o1RVD8YlHvpJKl/OWIUkgVM3BSgBBNrAf
	j0jzP27XMiDbLqjswBYbQKVf/eVN9+8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-501-7PAhx1wYM9KYVWfGvmJhaw-1; Wed,
 04 Mar 2026 20:17:11 -0500
X-MC-Unique: 7PAhx1wYM9KYVWfGvmJhaw-1
X-Mimecast-MFC-AGG-ID: 7PAhx1wYM9KYVWfGvmJhaw_1772673431
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D31EA1800561;
	Thu,  5 Mar 2026 01:17:10 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.20])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BCB2430001A1;
	Thu,  5 Mar 2026 01:17:08 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 0/2] md/raid1: serialize overlapped ios for writemostly device
Date: Thu,  5 Mar 2026 09:16:47 +0800
Message-ID: <20260305011705.5048-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Xiao Ni (2):
  md/raid1: fix the comparing region of interval tree
  md/raid1: serialize overlap io for writemostly disk

 drivers/md/raid1.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

-- 
2.50.1 (Apple Git-155)

