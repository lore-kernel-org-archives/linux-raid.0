Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0093227E93
	for <linux-raid@vger.kernel.org>; Thu,  8 May 2025 12:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746708535; cv=none; b=jt9Lq6CHq1ZeZHcQcmIDFThw8h1NzFTaSz1gXrj/dNda5hUea6p42l9LvmYPMsJuJYrKGlFx611MUFO4PpvDu939YhDEynKqnkUpDm2l8tDlI2a+axywaGDBFwxnWaXx/q9+r+hCFrlo79WcLtR0FAZJYJotgFXZdMlMxl07pws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746708535; c=relaxed/simple;
	bh=I9UBUPG3OQ4nTQD418FIRSTwihK+GpMgruVZtF5NpSo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Kx1slgLbvOjRwzryQMO+3oUn+ASl9o/oCyv60wa0284toWiPsBce9g5FyGFykx52AuO7xcPg+oMwKTWPjsnFFnvFx+9twlAJ8gZiJ0cwB64Cxt3rFlZaDQfyv/s8HCTjaRJd45eJRXTQaTu6kd8Kxc8Xa2aF8V1by2idPq1KIpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iPDty9h7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iPDty9h7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746708532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tA5zPuQrJ2yJZKfyPbDbfxtsKuCWtNFprIvQ2xfjRXY=;
	b=iPDty9h75ZlZ3gnDsIx/RrCY66b6pxCkDoNb1JhtQdwvjc0tkTk9BJDbUb954uWcLmlA3O
	1YiJpHDM/PwsdPnAHiuwSX6QrbjlQtiVFBNlZFI25oE5Bl96V2UsxBDZnLkiZsyybmNcdu
	X4LG2iMmZJ1OZhYWSAnkrduB40/z5rI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-665-GfQgL33zNOSdCAbNaIRNuw-1; Thu,
 08 May 2025 08:48:51 -0400
X-MC-Unique: GfQgL33zNOSdCAbNaIRNuw-1
X-Mimecast-MFC-AGG-ID: GfQgL33zNOSdCAbNaIRNuw_1746708530
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9587C180035E;
	Thu,  8 May 2025 12:48:50 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.7])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 25C6419560B3;
	Thu,  8 May 2025 12:48:47 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: mtkaczyk@kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 4/7] mdadm: give more time to wait sync thread to reap
Date: Thu,  8 May 2025 20:48:28 +0800
Message-Id: <20250508124831.32742-5-xni@redhat.com>
In-Reply-To: <20250508124831.32742-1-xni@redhat.com>
References: <20250508124831.32742-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

01r5fail case reports error sometimes:
++ '[' -n '2248 / 35840' ']'
++ die 'resync or recovery is happening!'
++ echo -e '\n\tERROR: resync or recovery is happening! \n'

    ERROR: resync or recovery is happening!

sync thread is reapped in md_thread. So we need to give more time to
wait sync thread to reap.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/func.sh | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tests/func.sh b/tests/func.sh
index e42c7d56d9a2..19ad8b3211e3 100644
--- a/tests/func.sh
+++ b/tests/func.sh
@@ -357,7 +357,10 @@ check() {
 		done
 	;;
 	nosync )
-		sleep 0.5
+		# sync thread is reapped in md_thread, give it more time to wait sync thread
+		# to reap. Before this change, it gives 0.5s which is too small. Sometimes
+		# the sync thread can't be reapped and error happens
+		sleep 3
 		# Since 4.2 we delay the close of recovery until there has been a chance for
 		# spares to be activated.  That means that a recovery that finds nothing
 		# to do can still take a little longer than expected.
-- 
2.32.0 (Apple Git-132)

