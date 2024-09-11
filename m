Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5719D15B0FE
	for <linux-raid@vger.kernel.org>; Wed, 11 Sep 2024 08:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726044887; cv=none; b=ReUSqBZoVf52tLj8hHmjJ8/FjKFzRDMITpxJktamncbZLHD7kfiSYw4Ns7w52sI4Kk7lEQeu29mrRQ5kva5wpTcmW+PHSWYV+6jIHrS26zjToHoUZGHp4ttp9jlfTDyfxO9eVhe2l1DsAruq4NzAxorJKgn7dsHNTokOvucpQqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726044887; c=relaxed/simple;
	bh=ua/FYaODjHmjPDdhksun0THTWHHqhZssw4kaDnaeFOc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ihgOO6qAr2ut+T/ADPHUNreVzTyL1lIxYtq9QVYBx5bQX0mugp6FfpVnXJks4xWcvXjj6E95BNvNYXJK1Pwg5qa3pjAd8rRC8MazbmMRjZfnS5zBkebkIHe1kHWA4jqcu+CEiGygCgJWnBHqds4qsP+UXbO0UrFmA3lHLIgM4Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cqJhSHlK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cqJhSHlK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726044884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TDrzRtQK5HXJvwcCoGJt29uDGncvitlKBo/++7u52BI=;
	b=cqJhSHlKeGQHRwWMWPxGjiFbqDO8gp/eQNhDb2wCxw4LRhISgFUG4Coy4jAw7c3xzoVIrQ
	fF/HymBvSlK2IZrnQ6lWoxoNXwq+PLzZF4deoLEf/2FRE8YgPOrJUIZnZsrJ3GtQa6DLKe
	FhRsJGqtCLxwKtgNY2A+Bcu0xavFSPc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-438-vc4Mo8JvOeC5KWqgYjBnlw-1; Wed,
 11 Sep 2024 04:54:43 -0400
X-MC-Unique: vc4Mo8JvOeC5KWqgYjBnlw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D4F6C1955D55;
	Wed, 11 Sep 2024 08:54:41 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.25])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5F56A195608A;
	Wed, 11 Sep 2024 08:54:38 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	ncroxon@redhat.com
Subject: [PATCH V2 1/1] mdadm/Grow: Update new level when starting reshape
Date: Wed, 11 Sep 2024 16:54:23 +0800
Message-Id: <20240911085432.37828-2-xni@redhat.com>
In-Reply-To: <20240911085432.37828-1-xni@redhat.com>
References: <20240911085432.37828-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Reshape needs to specify a backup file when it can't update data offset
of member disks. For this situation, first, it starts reshape and then
it kicks off mdadm-grow-continue service which does backup job and
monitors the reshape process. The service is a new process, so it needs
to read superblock from member disks to get information.

But in the first step, it doesn't update new level in superblock. So
it can't change level after reshape finishes, because the new level is
not right. So records the new level in the first step.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
v2: format change, add get_linux_version
 Grow.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Grow.c b/Grow.c
index 5810b128aa99..533f301468af 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2941,15 +2941,24 @@ static int impose_reshape(struct mdinfo *sra,
 		 * persists from some earlier problem.
 		 */
 		int err = 0;
+
 		if (sysfs_set_num(sra, NULL, "chunk_size", info->new_chunk) < 0)
 			err = errno;
+
 		if (!err && sysfs_set_num(sra, NULL, "layout",
 					  reshape->after.layout) < 0)
 			err = errno;
+
+		/* new_level is introduced in kernel 6.12 */
+		if (!err && get_linux_version() >= 6012000 &&
+				sysfs_set_num(sra, NULL, "new_level", info->new_level) < 0)
+			err = errno;
+
 		if (!err && subarray_set_num(container, sra, "raid_disks",
 					     reshape->after.data_disks +
 					     reshape->parity) < 0)
 			err = errno;
+
 		if (err) {
 			pr_err("Cannot set device shape for %s\n", devname);
 
-- 
2.32.0 (Apple Git-132)

