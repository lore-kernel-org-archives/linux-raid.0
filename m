Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E5B288502
	for <linux-raid@vger.kernel.org>; Thu, 15 May 2025 09:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747300138; cv=none; b=Q3kL2UifpuMw7JjOIwnkHWD0vPxI6QsJFzf/5D8EYzO+mGdjNJhVgyPfU+pXWHjt7hYlV3mGYw5+y/tF3+dZ0d35XRsCgQ9kdjyP81UzSkXYILMLzoAFgv5551UjRWf22gHIzd3sEAdxJr3kAPL9BJTifpNc8baMXBvZrnbV19U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747300138; c=relaxed/simple;
	bh=GgpsxwurEKUbdgcxXPzzkpZdKEqArFGa1aTOJX/oB4Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=j04kVs1XeqEfChf7Gq79l2sHd531Fmb8nT0oR6HEa4Fr0SY/WmKUuwZbMQ3/+uvOjj7T950LE8S0NUVypXVq0NenoMdaRI8RwG8qLvzUekYnaN7OALgYfyktb8Hh3jSMg8dPdWhcruHV3/odnctWmxz6gd3TMLbuWviD9/il7gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TxuGM3p2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TxuGM3p2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747300135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Z47iSJW5NJtT7CpxIqwQbwpxn8rvxKIOvCkw7RfwDWc=;
	b=TxuGM3p2tpbgeZxTVs4mfXsEvPthTBBvMV0Rd51N2HgK3mfUCbMh9rmtpLhkWnuo/tdx+8
	uIueK4RIdhwgNqQOeDN5ApUAs7B4LbdaPBFVQaLkOE0w9lYa39K62x8nlg3biS2vO84qvA
	0ZkziIUc01JKnfVY4Br5aY4EXJL0EXg=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-448-hjTyQ1VwOmiBXEHSmwhx3w-1; Thu,
 15 May 2025 05:08:53 -0400
X-MC-Unique: hjTyQ1VwOmiBXEHSmwhx3w-1
X-Mimecast-MFC-AGG-ID: hjTyQ1VwOmiBXEHSmwhx3w_1747300132
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2C5E91956095;
	Thu, 15 May 2025 09:08:52 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.66.61.200])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9BC051800268;
	Thu, 15 May 2025 09:08:49 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: yukuai1@huaweicloud.com,
	ncroxon@redhat.com,
	song@kernel.org
Subject: [PATCH V2 0/2] md: call del_gendisk in sync way
Date: Thu, 15 May 2025 17:08:45 +0800
Message-Id: <20250515090847.2356-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Now del_gendisk is called in a queue work which has a small window
that mdadm --stop command exits but the device node still exists.
It causes trouble in regression tests. This patch set tries to resolve
this problem.

v2: don't remove MD_DELETED

Xiao Ni (2):
  md: Don't clear MD_CLOSING until mddev is freed
  md: call del_gendisk in control path

 drivers/md/md.c | 68 ++++++++++++++++++++++++++++++++++++-------------
 drivers/md/md.h | 16 +++++++++++-
 2 files changed, 65 insertions(+), 19 deletions(-)

-- 
2.32.0 (Apple Git-132)

