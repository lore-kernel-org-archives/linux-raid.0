Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDFD32ED3A
	for <linux-raid@vger.kernel.org>; Tue, 28 Oct 2025 13:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761658668; cv=none; b=rJ3HhLecF00zM6OJgjyq8BHVnwQLXmE9bEMJejicFubjovCWG/abqDJ+updTqmflyCXMnHj5in5E/OCwlRAH5raXgmSxaI+VVqlCunvC6BHEuLIuhlvFeWBU7yRmMwYxnO+nkfq2eEM46B5EYxmUpKYhTRhDuaWfyckr3sfzxws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761658668; c=relaxed/simple;
	bh=G/70OEllmf8po5YaiipULogXWr6YVxSgJT7S2we0RZA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sfkqLU5mBH+jsTi8E6Wi0GyV10bH1gVRaRhevMa4E9Wv2s5vqxABgi2lLeoFso93DjHgpU3EJ8W5MXtZzUKwOyNOoBwLkdd00FXNr7eRTv6FafgdR6jURulGQr3vJItg1I/B014wWCAaVLkMg6kn0yicmUmEYMY7wIuwOEAaZrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SaqJIxSz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SaqJIxSz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761658665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=glBiKPhbamxty7i2K11BDbwgwNs2rBHD13zvpkH2KJs=;
	b=SaqJIxSzZdM07NUODAt7jKr2zUA3x2Se/oYFuV8tDZwQgTwO09SEF+aG2zPVN32FFazHWT
	I3quMp0zc2Z9obJ8how2K1PaMQ8VxstsgvIHV2VSKCNFbKgTvzb4ykUH4gmsqo5+fYVol5
	jIYAUtMf9FTP/TiTflH7FPmGHJ6RaNM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-43-EDj2SDQUM8acuhbwVjzicg-1; Tue,
 28 Oct 2025 09:37:43 -0400
X-MC-Unique: EDj2SDQUM8acuhbwVjzicg-1
X-Mimecast-MFC-AGG-ID: EDj2SDQUM8acuhbwVjzicg_1761658662
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB8BE180065F;
	Tue, 28 Oct 2025 13:37:42 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.11])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 171E11954B06;
	Tue, 28 Oct 2025 13:37:39 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: yukuai@fnnas.com,
	song@kernel.org
Subject: [PATCH 1/1] md: avoid repeated calls to del_gendisk
Date: Tue, 28 Oct 2025 21:37:37 +0800
Message-Id: <20251028133737.98300-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

There is a uaf problem which is found by case 23rdev-lifetime:

Oops: general protection fault, probably for non-canonical address 0xdead000000000122
RIP: 0010:bdi_unregister+0x4b/0x170
Call Trace:
 <TASK>
 __del_gendisk+0x356/0x3e0
 mddev_unlock+0x351/0x360
 rdev_attr_store+0x217/0x280
 kernfs_fop_write_iter+0x14a/0x210
 vfs_write+0x29e/0x550
 ksys_write+0x74/0xf0
 do_syscall_64+0xbb/0x380
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff5250a177e

The sequence is:
1. rdev remove path gets reconfig_mutex
2. rdev remove path release reconfig_mutex in mddev_unlock
3. md stop calls do_md_stop and sets MD_DELETED
4. rdev remove path calls del_gendisk because MD_DELETED is set
5. md stop path release reconfig_mutex and calls del_gendisk again

So there is a race condition we should resolve. This patch adds a
flag MD_DO_DELETE to avoid the race condition.

Fixes: 9e59d609763f ("md: call del_gendisk in control path")
Signed-off-by: Xiao Ni <xni@redhat.com>
Suggested-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md.c | 3 ++-
 drivers/md/md.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 41c476b40c7a..8e0554ab757c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -941,7 +941,8 @@ void mddev_unlock(struct mddev *mddev)
 		 * do_md_stop. dm raid only uses md_stop to stop. So dm raid
 		 * doesn't need to check MD_DELETED when getting reconfig lock
 		 */
-		if (test_bit(MD_DELETED, &mddev->flags))
+		if (test_bit(MD_DELETED, &mddev->flags) &&
+			!test_and_set_bit(MD_DO_DELETE, &mddev->flags)
 			del_gendisk(mddev->gendisk);
 	}
 }
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1979c2d4fe89..7f2875bf974b 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -354,6 +354,7 @@ enum mddev_flags {
 	MD_HAS_MULTIPLE_PPLS,
 	MD_NOT_READY,
 	MD_BROKEN,
+	MD_DO_DELETE,
 	MD_DELETED,
 };
 
-- 
2.32.0 (Apple Git-132)

