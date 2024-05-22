Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344BC80023
	for <linux-raid@vger.kernel.org>; Wed, 22 May 2024 08:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716367922; cv=none; b=sga+LfBvGqD1On+sF7INHSu/qjtXVHMReIJslpMRCGFnv+R3GIwAZdjyy94cNOohyTqko/GRUH65iZxJ358gKQLUsUp8mDaAjrMdflH97qoIhBDCS0ZrkO/VkjldmC1ZprYKcyvVOpT6xQ/XaNeVraOGrvwXJidbwosZXwuvpQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716367922; c=relaxed/simple;
	bh=r19vEAPrzqyFIvlaqnyhgsM5kDqPimRbffwjbR+IDIo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AMekESFsVQOTJAlql5MuZgR3D53IF+TZWr0blP2LuUmDydV3tLdupx5Khh+Inbx1NgcR8P8AQtByviB9OGjrgUgU0/KccSyDacjo9CxrqKJFLGkwZD+E8mOTQYIHX4yQ7RzkpXY3y8SYIUEjDd8dhQDh4TrDxwcIRx1hD0A0Y2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IUBfFV12; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IUBfFV12"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716367920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2+4mYprXFV41ZJZLQkP9ZePdTbKlGJtWMKagNC0AKyo=;
	b=IUBfFV12uuAkRBD28qeqkh1T8ylo0U5HYJCq3dq22122VNWXeGxU+AL++kB3uAZKhG8lTg
	BNHJlZ95J2haahgpKAcKteQCbVVr3rATZeftEd/0u7E0L3fYw+npnNAc5Rl/qJ6Yr6E2M7
	DBHVqtYkL+boPkZGELAnENi13VcC2bI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-163-_yel7oclOn6HtNRjTVOrPQ-1; Wed, 22 May 2024 04:51:56 -0400
X-MC-Unique: _yel7oclOn6HtNRjTVOrPQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9093781227E;
	Wed, 22 May 2024 08:51:55 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.11])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 64AA4C15BB1;
	Wed, 22 May 2024 08:51:53 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	heinzm@redhat.com,
	ncroxon@redhat.com
Subject: [PATCH 19/19] mdadm/tests: disable selinux
Date: Wed, 22 May 2024 16:50:56 +0800
Message-Id: <20240522085056.54818-20-xni@redhat.com>
In-Reply-To: <20240522085056.54818-1-xni@redhat.com>
References: <20240522085056.54818-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Sometimes systemd service fails because selinux. Disable selinux
during testing now. We can enable it in future when having a better
method.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 test          |  3 +++
 tests/func.sh | 10 ++++++++++
 2 files changed, 13 insertions(+)

diff --git a/test b/test
index 4a88de58fdf5..47f53ad78b75 100755
--- a/test
+++ b/test
@@ -16,6 +16,8 @@ devlist=
 # For example, /dev/md0 is created, stops it, then assemble it, the
 # device node will be /dev/md127 (127 is choosed by mdadm autumatically)
 is_foreign="no"
+#disable selinux
+sys_selinux="Permissive"
 
 skipping_linear="no"
 skipping_multipath="no"
@@ -351,6 +353,7 @@ main() {
 		fi
 	done
 
+	restore_selinux
 	exit 0
 }
 
diff --git a/tests/func.sh b/tests/func.sh
index db55542d4011..b2e4d122aa7f 100644
--- a/tests/func.sh
+++ b/tests/func.sh
@@ -167,6 +167,15 @@ is_raid_foreign() {
 	fi
 }
 
+record_selinux() {
+	sys_selinux=`getenforce`
+	setenforce Permissive
+}
+
+restore_selinux() {
+	setenforce $sys_selinux
+}
+
 do_setup() {
 	trap cleanup 0 1 3 15
 	trap ctrl_c 2
@@ -247,6 +256,7 @@ do_setup() {
 	echo 0 > /sys/module/md_mod/parameters/start_ro
 	record_system_speed_limit
 	is_raid_foreign
+	record_selinux
 }
 
 # check various things
-- 
2.32.0 (Apple Git-132)

