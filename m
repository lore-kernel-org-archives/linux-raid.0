Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2395315B980
	for <linux-raid@vger.kernel.org>; Thu, 18 Apr 2024 10:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713435819; cv=none; b=A2zenaYJKDnowctvy5aDRRo+w25lZ5+jFiecsBV0zT2IXmDi1RZ+wXXLRTIdTGlNuWh8oB8R4MO6cTjx0LknhNg63IQzKkDWWvOHwVQ4UYk56U+mvfbwrnShuWY87uyvFtxzMOe6ldfae15VTZq955F2cmnnI/PtkTCXYsCoiDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713435819; c=relaxed/simple;
	bh=QeToasVBnJxRkRih8P3xFN76OOqD0WotTYtbwVIX4r8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uqeqLuAJHa/KUvj+zb3RSycdo4oXxHHS1Guhe3YRJHiSbataZQntNO/Nkn4WhHOKKz4E2fR7FXaj2UQsNfcOFRH6+TaoPZISIrE4ibGGCOJvsHbvLtIqm5CfJR5Hh9XjZ/RWVR+tBaA/DQJtKadwGWFvQiTvdhWLlz5vv/bQ/w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AzNaMDxQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AzNaMDxQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713435817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YVwbSl7gEUcEmgDIDKx+BqOu2/sGgsIgUhnStj8o3Qc=;
	b=AzNaMDxQLeTP5lC3gvKByqPShp8F5Rz2VL4O4LlR+yt22zmZt0Uoo6knZSEv6pjN538T9R
	JLfV/2lLwt0x5YamzODkbdFuPXB0g9+osoZ7uxfZYgwjFqFl+RL49o3OyAWt8PL2EjAAfl
	YikX1OF1tWtbSgCwG7GEVQCu3T6H6MQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-564-H6qWFBUEPhee7LQyYLzvIQ-1; Thu,
 18 Apr 2024 06:23:35 -0400
X-MC-Unique: H6qWFBUEPhee7LQyYLzvIQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 385523C00084;
	Thu, 18 Apr 2024 10:23:35 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.2])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 284081C060D0;
	Thu, 18 Apr 2024 10:23:31 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	song@kernel.org,
	yukuai1@huaweicloud.com,
	ncroxon@redhat.com,
	colyli@suse.de,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH 2/5] tests/00createnames enhance
Date: Thu, 18 Apr 2024 18:23:18 +0800
Message-Id: <20240418102321.95384-3-xni@redhat.com>
In-Reply-To: <20240418102321.95384-1-xni@redhat.com>
References: <20240418102321.95384-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

Now 00createnames doesn't check Create names=yes config. Without this
config, mdadm creates /dev/md127 device node when mdadm --create
/dev/md/test. With this config, it creates /dev/md_test. This patch
only adds the check. If it has this config, it returns directly
without error.

And this case has an error. For super1, if the length of hostname
is >= 32, it doesn't add hostname in metadata name. Fix this problem
by checking the length of hostname.

And this patch adds a check if device node exists.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/00createnames            |  9 +++++++++
 tests/templates/names_template | 15 ++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/tests/00createnames b/tests/00createnames
index a95e7d2bb085..2eb3d9331dda 100644
--- a/tests/00createnames
+++ b/tests/00createnames
@@ -3,6 +3,15 @@ set -x -e
 
 # Test how <devname> and --name= are handled for create mode.
 
+create_with_name=`cat /etc/mdadm.conf | grep "^Create*.names=yes"`
+
+if [ -n "$create_with_name" ]; then
+	exit 0
+fi
+
+#The following cases don't consider the names=yes setting in mdadm.conf
+#It needs to add the respecting cases which consider names=yes config
+
 # The most trivial case.
 names_create "/dev/md/name"
 names_verify "/dev/md127" "name" "name"
diff --git a/tests/templates/names_template b/tests/templates/names_template
index 1b6cd14bf51d..4c7ff8c27f73 100644
--- a/tests/templates/names_template
+++ b/tests/templates/names_template
@@ -30,6 +30,7 @@ function names_verify() {
 	local DEVNODE_NAME="$1"
 	local WANTED_LINK="$2"
 	local WANTED_NAME="$3"
+	local EXPECTED=""
 
 	local RES="$(mdadm -D --export $DEVNODE_NAME | grep MD_DEVNAME)"
 	if [[ "$?" != "0" ]]; then
@@ -46,13 +47,25 @@ function names_verify() {
 		exit 1
 	fi
 
+	if [ -b /dev/md/$WANTED_LINK ]; then
+		echo "/dev/md/$WANTED_LINK doesn't exit"
+	fi
+
 	local RES="$(mdadm -D --export $DEVNODE_NAME | grep MD_NAME)"
 	if [[ "$?" != "0" ]]; then
 		echo "Cannot get metadata from $dev0."
 		exit 1
 	fi
 
-	local EXPECTED="MD_NAME=$(hostname):$WANTED_NAME"
+	#If the lenght of hostname is >= 32, super1 doesn't use hostname
+	#in metadata
+	local is_super1="$(mdadm -D --export $DEVNODE_NAME | grep MD_METADATA=1.2)"
+	hostname=$(hostname)
+	if [ -n "$is_super1" -a `expr length $(hostname)` -lt 32 ]; then
+		EXPECTED="MD_NAME=$(hostname):$WANTED_NAME"
+	else
+		EXPECTED="MD_NAME=$WANTED_NAME"
+	fi
 	if [[ "$RES" != "$EXPECTED" ]]; then
 		echo "$RES doesn't match $EXPECTED."
 		exit 1
-- 
2.32.0 (Apple Git-132)

