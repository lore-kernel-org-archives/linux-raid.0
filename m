Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BB21B3F0F
	for <linux-raid@vger.kernel.org>; Wed, 14 Aug 2024 14:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723646075; cv=none; b=psqqxdVVRaJsdM5/iExGl1uGqFm3qKuJxBhmwsNbvNW0EYD1OBu49D8ccJY32WArRxq0/wLdR93WZPR4LAgHin/ljJ1YiCqAv/sofcXMcd+ESmt4FWyvAHtEy4XPsZgE65DaWrYbDATBa+sgrFsoIRiEv03k4jdzsDn4MUTK7gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723646075; c=relaxed/simple;
	bh=7+E295+fTdtFYJE7SO/shAHSrnEGhOeeX5vu6OAwvNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=goS7d9B0htXEH4kmSD1gjwKmRjsQWzaD6KNvSx+HxYUGSvRTcUyyraUP86rqTtcyKD+GDv21Y3vmDeZJwKnIqHDz2biJD3OZzdQc75QaczaB/nRATP+FBfTsjJzyGEKDleOACEe7DCbpEwA5IBNmbzLaHDUAindUpfq7K0X91B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B7DO0c1j; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B7DO0c1j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723646072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f+k9OgWsKdKtc2JL0VLbtqiJHf8Tzgl+WMY1WPT70Ug=;
	b=B7DO0c1josQpzpXEaC8Fr99IIoDeBEkBevj1am2ZkYML8+q23niBSpzX+wzP0aZfUWKb7M
	BnYxNFttSf/++ygo5AO0/OruC0S26oUOXFMxG6ySFwbFg8cEQ8fPGdoNFewi7f+bnrfJ4C
	uUYhG0+7wP6cQaXSBaETAzqCYREyWgQ=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-610-mkjJ2jwPODy_EEJ1DSFBhw-1; Wed,
 14 Aug 2024 10:34:27 -0400
X-MC-Unique: mkjJ2jwPODy_EEJ1DSFBhw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C7F6818EA957;
	Wed, 14 Aug 2024 14:34:24 +0000 (UTC)
Received: from fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com (fs-i40c-03.mgmt.fast.eng.rdu2.dc.redhat.com [10.6.24.150])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5AC5D3001FD6;
	Wed, 14 Aug 2024 14:34:22 +0000 (UTC)
From: Alexander Aring <aahringo@redhat.com>
To: teigland@redhat.com
Cc: gfs2@lists.linux.dev,
	song@kernel.org,
	yukuai3@huawei.com,
	agruenba@redhat.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	lucien.xin@gmail.com,
	aahringo@redhat.com
Subject: [RFC dlm/next 01/12] dlm: introduce dlm_find_lockspace_name()
Date: Wed, 14 Aug 2024 10:34:03 -0400
Message-ID: <20240814143414.1877505-2-aahringo@redhat.com>
In-Reply-To: <20240814143414.1877505-1-aahringo@redhat.com>
References: <20240814143414.1877505-1-aahringo@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

A DLM lockspace can be either identified by it's unique id or name. Later
patches will introduce a new netlink api that is using a unique
lockspace name to identify a lockspace in the lslist. This is mostly
required for sysfs functionality that is currently solved by a per
lockspace kobject allocation. The new netlink api cannot simple lookup
the lockspace by a container_of() call to do whatever sysfs is
providing so we introduce dlm_find_lockspace_name() to offer such
functionality.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/lockspace.c | 18 ++++++++++++++++++
 fs/dlm/lockspace.h |  1 +
 2 files changed, 19 insertions(+)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 8afac6e2dff0..00d37125bc44 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -238,6 +238,24 @@ void dlm_lockspace_exit(void)
 	kset_unregister(dlm_kset);
 }
 
+struct dlm_ls *dlm_find_lockspace_name(const char *lsname)
+{
+	struct dlm_ls *ls;
+
+	spin_lock_bh(&lslist_lock);
+
+	list_for_each_entry(ls, &lslist, ls_list) {
+		if (!strncmp(ls->ls_name, lsname, DLM_LOCKSPACE_LEN)) {
+			atomic_inc(&ls->ls_count);
+			goto out;
+		}
+	}
+	ls = NULL;
+ out:
+	spin_unlock_bh(&lslist_lock);
+	return ls;
+}
+
 struct dlm_ls *dlm_find_lockspace_global(uint32_t id)
 {
 	struct dlm_ls *ls;
diff --git a/fs/dlm/lockspace.h b/fs/dlm/lockspace.h
index 47ebd4411926..7898a906aab9 100644
--- a/fs/dlm/lockspace.h
+++ b/fs/dlm/lockspace.h
@@ -22,6 +22,7 @@
 
 int dlm_lockspace_init(void);
 void dlm_lockspace_exit(void);
+struct dlm_ls *dlm_find_lockspace_name(const char *lsname);
 struct dlm_ls *dlm_find_lockspace_global(uint32_t id);
 struct dlm_ls *dlm_find_lockspace_local(void *id);
 struct dlm_ls *dlm_find_lockspace_device(int minor);
-- 
2.43.0

