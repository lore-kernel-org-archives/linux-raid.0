Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6720113C8F2
	for <linux-raid@vger.kernel.org>; Mon,  3 Jun 2024 21:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717451775; cv=none; b=RvQyQtoCosveb/wnzvOk1GLpEkhd3uUb0e4bZA2cOTfhRp0dLY7IjVi8Z7gq59dhTgmrWGa/et8V2DdgRP6ZRPsXb5aN3/xJxtyRGh80PjijPK1FZULHiUvtl7Q56CSwHPlpn1HSJZeaRFh4lLMcc0iMdA3shvf36lCeZQtJi5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717451775; c=relaxed/simple;
	bh=lJSYqPVnbpDc5YM6Z6gAE26HGft7QpixXUV8OA7VU0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DwnxR3LKRltlkg/7bxGcTHu6IBTYxSvC/fk7MdIhGZnwd6CO1ejtBUm8/KH1fjYhlruvq0YT2NJRoX1vHVR+LN7MLakTIGjZaTvK/WTuosZOol+CHXJ2DWyHLkF8QeCeu+6SSG0q+GAQwdO4KBjBXXCdHNF6nIxomgMJrRDmG6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N0Aw4JNd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N0Aw4JNd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717451772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OWI8Av5qgSFzPq64lyUR9sWGRzYNmkWr6DlMVO9bubU=;
	b=N0Aw4JNdgqU7MK0pLXf98o6C9mx0/iylISuKA7gUNMxn6JqtHeF9bNyUZj7WazjuzuKtnp
	TBCs0V8zhuBvr1CIHzlYtEa+HX1HCCuE6bzZh7NfcISaskB3kkyFi/PARmPJHRsSOuPRzr
	mFkrjt9cjsDvx+tNf7CauE0XzuA6H6k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-88qit2loOaiLAONRKz8MmA-1; Mon, 03 Jun 2024 17:56:09 -0400
X-MC-Unique: 88qit2loOaiLAONRKz8MmA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0846101A525;
	Mon,  3 Jun 2024 21:56:08 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com [10.6.24.150])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C19E3200F074;
	Mon,  3 Jun 2024 21:56:08 +0000 (UTC)
From: Alexander Aring <aahringo@redhat.com>
To: teigland@redhat.com
Cc: gfs2@lists.linux.dev,
	song@kernel.org,
	yukuai3@huawei.com,
	linux-raid@vger.kernel.org,
	aahringo@redhat.com
Subject: [PATCH dlm/next 5/8] dlm: introduce DLM_LSFL_SOFTIRQ_SAFE
Date: Mon,  3 Jun 2024 17:55:55 -0400
Message-ID: <20240603215558.2722969-6-aahringo@redhat.com>
In-Reply-To: <20240603215558.2722969-1-aahringo@redhat.com>
References: <20240603215558.2722969-1-aahringo@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

This patch introduces the per lockspace DLM_LSFL_SOFTIRQ_SAFE flag to
signal that the user is ready to handle ast/bast callbacks in
softirq context. It is a reserved dlm kernel lockspace flag as seen from
the user space yet. We not chose available 0x4 flag as this was recently
flag that was dropped and should be not reused now. In future, if all
users changed to use DLM_LSFL_SOFTIRQ_SAFE, we can hopefully drop this
flag and dlm code functionality (dlm_callback workqueue) which belongs to
it.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/lockspace.c       |  3 +++
 include/linux/dlm.h      | 17 ++++++++++++++++-
 include/uapi/linux/dlm.h |  2 ++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index be5dd5c990e5..51f9516b710d 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -630,6 +630,9 @@ int dlm_new_user_lockspace(const char *name, const char *cluster,
 			   void *ops_arg, int *ops_result,
 			   dlm_lockspace_t **lockspace)
 {
+	if (flags & DLM_LSFL_SOFTIRQ)
+		return -EINVAL;
+
 	return __dlm_new_lockspace(name, cluster, flags, lvblen, ops,
 				   ops_arg, ops_result, lockspace);
 }
diff --git a/include/linux/dlm.h b/include/linux/dlm.h
index c58c4f790c04..bacda9898f2b 100644
--- a/include/linux/dlm.h
+++ b/include/linux/dlm.h
@@ -35,6 +35,9 @@ struct dlm_lockspace_ops {
 			      int num_slots, int our_slot, uint32_t generation);
 };
 
+/* only relevant for kernel lockspaces, will be removed in future */
+#define DLM_LSFL_SOFTIRQ __DLM_LSFL_RESERVED0
+
 /*
  * dlm_new_lockspace
  *
@@ -55,6 +58,11 @@ struct dlm_lockspace_ops {
  *   used to select the directory node.  Must be the same on all nodes.
  * DLM_LSFL_NEWEXCL
  *   dlm_new_lockspace() should return -EEXIST if the lockspace exists.
+ * DLM_LSFL_SOFTIRQ
+ *   dlm request callbacks (ast, bast) are softirq safe. Flag should be
+ *   preferred by users. Will be default in some future. If set the
+ *   strongest context for ast, bast callback is softirq as it avoids
+ *   an additional context switch.
  *
  * lvblen: length of lvb in bytes.  Must be multiple of 8.
  *   dlm_new_lockspace() returns an error if this does not match
@@ -121,7 +129,14 @@ int dlm_release_lockspace(dlm_lockspace_t *lockspace, int force);
  * call.
  *
  * AST routines should not block (at least not for long), but may make
- * any locking calls they please.
+ * any locking calls they please. If DLM_LSFL_SOFTIRQ for kernel
+ * users of dlm_new_lockspace() is passed the ast and bast callbacks
+ * can be processed in softirq context. Also some of the callback
+ * contexts are in the same context as the DLM lock request API, users
+ * must not hold locks while calling dlm lock request API and trying
+ * to acquire this lock in the callback again, this will end in a
+ * lock recursion. For newer implementation the DLM_LSFL_SOFTIRQ
+ * should be used.
  */
 
 int dlm_lock(dlm_lockspace_t *lockspace,
diff --git a/include/uapi/linux/dlm.h b/include/uapi/linux/dlm.h
index e7e905fb0bb2..4eaf835780b0 100644
--- a/include/uapi/linux/dlm.h
+++ b/include/uapi/linux/dlm.h
@@ -71,6 +71,8 @@ struct dlm_lksb {
 /* DLM_LSFL_TIMEWARN is deprecated and reserved. DO NOT USE! */
 #define DLM_LSFL_TIMEWARN	0x00000002
 #define DLM_LSFL_NEWEXCL     	0x00000008
+/* currently reserved due in-kernel use */
+#define __DLM_LSFL_RESERVED0	0x00000010
 
 
 #endif /* _UAPI__DLM_DOT_H__ */
-- 
2.43.0

