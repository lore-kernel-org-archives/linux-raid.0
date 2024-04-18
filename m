Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F5815B572
	for <linux-raid@vger.kernel.org>; Thu, 18 Apr 2024 10:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713435815; cv=none; b=awPSSLW0BKrCRC0ISH8UzV6hC02NtpoE9RwKv+zjKKQhqhOnKShm+0fVKrNHhe7+kneB6PpAW2lcCP+p6NWBNENF++HOzSTAus4UUx74vGRcCxn6eZ3yw5hl6bEWe+s5iJosSmRSfVeVq1c/Tv4Jr1dFwFhc+KYBcwAh7cfYrDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713435815; c=relaxed/simple;
	bh=m8N+6B/QTnOfG3R867fv9diu515KmR4ghWwELA4dnDo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lowFaXhK6eA1sNdtIzB51Ej9sF3qllMZmzFWvKbTOl5fuRoeclse7RCDTDlPTZylkK/lx0kA0K9uD0zsgX8O3FOiCgUQ0eVcguNfArt6Zc9fmLf3AA6QxN8ixTGthYveSsrBVnsl15gZ29eynuqtb15eIJK7+nm6+cRkvIoxFGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FPYqep3J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FPYqep3J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713435812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/mzxgHDSMz0Sjfnk8ZQt2YhAJt1ncDNXWn6090iPIXc=;
	b=FPYqep3JaR4Q8Dd1qXloUuPxnR4taKDP9e2pp6Hdvr0IkJ2N+mLD5UKyPvabYXoeYjTP/E
	yWl7k9ORpcSwSGzMzIRYApsagaHFjvJFNkHarUteVPNnMgUeqTGv9zgwLYOmT5jKuKiCGA
	WUhnczyBEaxXjUXKm/pwyJ2Z3FRuSWk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-xBFOEdyGNEqGOllWcx02wA-1; Thu, 18 Apr 2024 06:23:28 -0400
X-MC-Unique: xBFOEdyGNEqGOllWcx02wA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75EAB1044573;
	Thu, 18 Apr 2024 10:23:27 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.2])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BC5851C060D1;
	Thu, 18 Apr 2024 10:23:23 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	song@kernel.org,
	yukuai1@huaweicloud.com,
	ncroxon@redhat.com,
	colyli@suse.de,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH RFC 0/5] mdadm tests fix and enhance
Date: Thu, 18 Apr 2024 18:23:16 +0800
Message-Id: <20240418102321.95384-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

Hi all

This patch set tries to fix and enhance mdadm tests. This is just the
beginning of this job. I want to send it out to get some opinions to
avoid some faults and better methods.

Xiao Ni (5):
  tests/test enhance
  tests/00createnames enhance
  tests/01r5fail enhance
  tests/01r5integ.broken
  tests/01raid6integ.broken can be removed

 test                           | 18 ++++++++++++++++--
 tests/00createnames            |  9 +++++++++
 tests/01r5fail                 |  6 +-----
 tests/01r5integ.broken         |  7 -------
 tests/01raid6integ.broken      |  7 -------
 tests/templates/names_template | 15 ++++++++++++++-
 6 files changed, 40 insertions(+), 22 deletions(-)
 delete mode 100644 tests/01r5integ.broken
 delete mode 100644 tests/01raid6integ.broken

-- 
2.32.0 (Apple Git-132)

