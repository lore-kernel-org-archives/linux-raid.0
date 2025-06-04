Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C5F1EEA5D
	for <linux-raid@vger.kernel.org>; Wed,  4 Jun 2025 09:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749028076; cv=none; b=WDF/LxrNiOytrq6Tt/IPNl72wSK8sCTgzfZb/zYDsF4c4EkZgHHoe3YrRNLPfHwzxRG/dy0gZPZDx4Hq7ZULNul4yxXDrKSytfpVmRpoy1Odi7kB4hm/MUsYCv7R6L37HEY6EK7yVQAtudCn3mSEtfO7Bk38S7r3+9F0E2/jrrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749028076; c=relaxed/simple;
	bh=pc26cPE7WP6VkqTUQTgJoHZgfIcqKKoqPs5TRsQkfG4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JJw/Ff+lmtKzSZA48ydjVqnfaUIGWPZW91aggIamStapJtEvw8LPCcCy37le4Q9kJz5ZSRpXWxOqlfSlXcQ1tXSQy2z1xFkCnTiMyqfplCY4eBc+rJ5U+Kv/so+kNTyd4q4qjQG51tk/LVmJ4v7fUOFyaHgpOelWdm+rvux6Fmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hHNUfMGc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hHNUfMGc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749028073;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=U3sqyRmr07EMIzBn6B/yVIB72ttcLEctGXHs3WzhQ44=;
	b=hHNUfMGcYMkaEURiaSkWzfVJTkZq1fO1JmxdT7ZMolEL1mwvR6nFiiYMm5BAtSRin8DkQz
	1p1g+qzQr6zHMT6HEoNDoeaBOooBHnZSuwnEipI20r8dsZlPMQ1890WbXGpzAivO/+VEQH
	SMuDm4NmSGiHzoRBDzLgby8kjUM6bQg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-488-yVjERxd2O_iO6KmjuIAUbg-1; Wed,
 04 Jun 2025 05:07:50 -0400
X-MC-Unique: yVjERxd2O_iO6KmjuIAUbg-1
X-Mimecast-MFC-AGG-ID: yVjERxd2O_iO6KmjuIAUbg_1749028069
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6445C1801A00;
	Wed,  4 Jun 2025 09:07:49 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.9])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 53164180045B;
	Wed,  4 Jun 2025 09:07:44 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	ncroxon@redhat.com,
	song@kernel.org,
	yukuai1@huaweicloud.com
Subject: [PATCH V4 0/3] md: call del_gendisk in sync way
Date: Wed,  4 Jun 2025 17:07:39 +0800
Message-Id: <20250604090742.37089-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Now del_gendisk is called in a queue work which has a small window
that mdadm --stop command exits but the device node still exists.
It causes trouble in regression tests. This patch set tries to resolve
this problem.

v1: replace MD_DELETED with MD_CLOSING
v2: keep MD_CLOSING
v3: call den_gendisk in mddev_unlock, and remove ->to_remove in stop path
and adjust the order of patches
v4: only remove the codes in stop path.

Xiao Ni (3):
  md: call del_gendisk in control path
  md: Don't clear MD_CLOSING until mddev is freed
  md: remove/add redundancy group only in level change

 drivers/md/md.c | 44 ++++++++++++++++++++++++++------------------
 drivers/md/md.h | 26 ++++++++++++++++++++++++--
 2 files changed, 50 insertions(+), 20 deletions(-)

-- 
2.32.0 (Apple Git-132)

