Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE64170841
	for <linux-raid@vger.kernel.org>; Tue, 28 May 2024 13:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716904319; cv=none; b=aguaYSN0squmf3iI4v371PY9jl24EESiWhoSovEW4NzmljZNqKet1bcODeDsJ4msT1Ic2wbmVP/TZlY7XSwCvK0mx2VcBIb59ef3TxxMxwPEWVvS9mn3GzM8SHQdbEeQbKuBzoauYs66YpFN8eQ0YExnCAECPTk12TcsWBzOrCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716904319; c=relaxed/simple;
	bh=B0rr9LOi9UaXjFJvoa/uVbur2TSeRN3qmowkadCRR6w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=V9LdyBmTNPhzZRqRgZxARWS1LjgYthDWl8pwCgPXLCI6LUdlbMAEejx5touqlQV9YdNxnT7x4JQFzrNfbPNv94KvfTHbhlqj9WxYLqrN+Ofm5dPNUL1nxK5K2AHTFHkNZn5/Qq0Y6OL6cVPZ9S3VhmGUKgvP3JHlzc70Hc2uSDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fQKFTqMe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fQKFTqMe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716904317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rDTalwxQMT35FWyTO5zi/EJcK+LYK+zx1F1WkHi8Db4=;
	b=fQKFTqMeQ/V2ft6SX5oEm0+saL0S8k9C0bVHt00b0lnKS2tJ5iPGzLgCfvt1KXxvTupU6f
	lrTfWbM1qrtlUnZ4SwpiZ2nFLTPJt9gOYEECiIwSU0xfuWnrsOHy0frvQegNMb9hMxyyWB
	uwwOzI6HNR2FkTb0GTCP63kcdamGc/U=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-169-Xm7nyfvlPdqaOuZA2Ll3Ow-1; Tue,
 28 May 2024 09:51:54 -0400
X-MC-Unique: Xm7nyfvlPdqaOuZA2Ll3Ow-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2356A3806711;
	Tue, 28 May 2024 13:51:54 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.10])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BE656400057;
	Tue, 28 May 2024 13:51:52 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org
Subject: [PATCH 0/4] mdadm/tests: fix and enhance some cases
Date: Tue, 28 May 2024 21:51:46 +0800
Message-Id: <20240528135150.26823-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Hi all

This is the third patch set that fix and enhance some test cases.

Xiao Ni (4):
  mdadm/tests: bitmap cases enhance
  mdadm/tests: 04update-uuid
  mdadm/tests: 05r1-re-add-nosuper
  mdadm/tests: remove strace test

 tests/04update-uuid           |  4 ++--
 tests/05r1-grow-internal      | 11 ++++-------
 tests/05r1-grow-internal-1    | 12 ++++--------
 tests/05r1-internalbitmap     | 22 ++++++++++------------
 tests/05r1-internalbitmap-v1a | 22 ++++++++++------------
 tests/05r1-internalbitmap-v1b | 23 ++++++++++-------------
 tests/05r1-internalbitmap-v1c | 22 ++++++++++------------
 tests/05r1-re-add-nosuper     |  2 +-
 tests/07revert-grow           |  2 +-
 tests/07revert-inplace        |  2 +-
 10 files changed, 53 insertions(+), 69 deletions(-)

-- 
2.32.0 (Apple Git-132)

