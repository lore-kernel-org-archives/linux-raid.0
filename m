Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0657602A
	for <linux-raid@vger.kernel.org>; Tue, 20 Feb 2024 15:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708443073; cv=none; b=N6O73xjjOuVcX347eRYWXQMQJNgEZPxF8fnOHe3k1LWUT1wI0N+PkxjeNd61DNs4EQ9qG8hTo0p31YSbs1/+onEOpdYAjZ3AGiXOkYTb+RiscpIJJHH3BpLi5DXWWWwv5aLOOz+n0HWJ37nh98JXK+Nmiv+iXPrs0ousC8xcnhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708443073; c=relaxed/simple;
	bh=8iH2sCj+sBdk4P7RGoQLMzwHYYIrWPzQ9Ew+aPPgQzI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=T31JOh8em+YvcxDd5hbjvrpq1rOeuzdCygjUE/mCFhO92vXu/FdkrLC4lp3ZWvOQaisjyCMP1T1+93VCgTlUJT9gCJwfHPZXTXDqRYMRvUsmju43DaEmwWgsgHzXhv67ACYTYWRhPzRlQtKWHICmkOIhKZZVbzXpA0Iqshwx6Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZehuJwDt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZehuJwDt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708443070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JM/6/mvtcBs5QkNQCS4CWF9Aa8TY5CUdynAMOiCaQgs=;
	b=ZehuJwDtjLEssxsRFcKGZC47cIG7whv9/J+JeeY/BtgZH2hSIST1+9aG+8i9nDDVrtxIer
	9g6GGPxE4Qnucbe4vIrzTvzYl5OtIS/TZPMs3q7FaIDHZaEsoCRnDS1OCZFrp3LgYf0fBX
	Ie6mcKdteEb2k8KF/sldI8X1T4OzjjE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-380-ioPcnDBcPeKrOj92Pp9dzw-1; Tue,
 20 Feb 2024 10:31:09 -0500
X-MC-Unique: ioPcnDBcPeKrOj92Pp9dzw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F386C3816444;
	Tue, 20 Feb 2024 15:31:04 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.2])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E7E302022AAC;
	Tue, 20 Feb 2024 15:31:00 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: song@kernel.org
Cc: yukuai1@huaweicloud.com,
	bmarzins@redhat.com,
	heinzm@redhat.com,
	snitzer@kernel.org,
	ncroxon@redhat.com,
	neilb@suse.de,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH RFC V2 0/4] Fix regression bugs
Date: Tue, 20 Feb 2024 23:30:55 +0800
Message-Id: <20240220153059.11233-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

Hi all

Sorry, I know this patch set conflict with Yu Kuai's patch set. But
I have to send out this patch set. Now we're facing some deadlock
regression problems. So it's better to figure out the root cause and
fix them. But Kuai's patch set looks too complicate for me. And like
we're talking in the emails, Kuai's patch set breaks some rules. It's
not good to fix some problem by breaking the original logic. If we really
need to break some logic. It's better to use a distinct patch set to
describe why we need them.

This patch is based on linus's tree. The tag is 6.8-rc5. If this patch set
can be accepted. We need to revert Kuai's patches which have been merged
in Song's tree (md-6.8-20240216 tag). This patch set has four patches.
The first two resolves deadlock problems. With these two patches, it can
resolve most deadlock problem. The third one fixes active_io counter bug.
The fouth one fixes the raid5 reshape deadlock problem.

I have run lvm2 regression test. There are 4 failed cases:
shell/dmsetup-integrity-keys.sh
shell/lvresize-fs-crypt.sh
shell/pvck-dump.sh
shell/select-report.sh

Xiao Ni (4):
  Clear MD_RECOVERY_WAIT when stopping dmraid
  Set MD_RECOVERY_FROZEN before stop sync thread
  md: Missing decrease active_io for flush io
  Don't check crossing reshape when reshape hasn't started

 drivers/md/dm-raid.c |  2 ++
 drivers/md/md.c      |  8 +++++++-
 drivers/md/raid5.c   | 22 ++++++++++------------
 3 files changed, 19 insertions(+), 13 deletions(-)

-- 
2.32.0 (Apple Git-132)

