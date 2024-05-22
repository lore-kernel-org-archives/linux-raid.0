Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66A47710B
	for <linux-raid@vger.kernel.org>; Wed, 22 May 2024 08:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716367888; cv=none; b=L2/aC31BWvv5QTffdQOk/QBvJFiqfxvPKKKIhW0gjhuWVLJoDgWTRR5O6aQb6dUQTSu8ERaKDkB1OFokNRhVK3a7A7M4UTpo9n8dPK4AYfiUVezndXTvHym3jmXdIlYOyhjTeDRXpH7ntkemrHLW88mhD/ou8ipYijgW446s+vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716367888; c=relaxed/simple;
	bh=KyFlFKLgNaS+AutvlUnOCX2rVMyAVz6OZbDj6By0pPw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ophj7bnUnStuAaZd8DGaSKVKFcM3sPFCldj+SE6+gRjZFFIOwiviiFwKOgJL+IKiowpE7zmABaAO3ECE4P5gHLmYoVVwpPvzWhF+7ghF9uUtU/5KL70QgqL6Z3RDFZ+pYTq4ydguB104z68n2bBVaArj43irAA1wKunL3AVdx4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bgcPgnDy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bgcPgnDy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716367885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CeESm+IPkdpGhq9+Gaw3hiWNjzUOnGXM1P7XbXsUUdc=;
	b=bgcPgnDyuRb/DKtGeVmjut81Lc/WHb2E840a1OWjQ9SmxIiNMPbO/czWobdqVUlPAftX/D
	ehghTQHzybLPo8BajvkQATtGrYFbeC0bM/WaP09o03F3kPWYpFqjUINTXsvE3pz2G+LSwn
	t/pvAvfnNih+YW3DWjeh5w7k3G+aTPo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-IoWsoNHBPYa4bx0XxEjSwQ-1; Wed, 22 May 2024 04:51:21 -0400
X-MC-Unique: IoWsoNHBPYa4bx0XxEjSwQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65C238058D1;
	Wed, 22 May 2024 08:51:21 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.11])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1D6F2C15BB1;
	Wed, 22 May 2024 08:51:18 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	heinzm@redhat.com,
	ncroxon@redhat.com
Subject: [PATCH 07/19] mdadm/tests: 03assem-incr enhance
Date: Wed, 22 May 2024 16:50:44 +0800
Message-Id: <20240522085056.54818-8-xni@redhat.com>
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

It fails when hostname lenght > 32. Because the super1 metadata name
doesn't include hostname when hostname length > 32. Then mdadm thinks
the array is a foreign array if no device link is specified when
assembling the array. It chooses a minor number from 127.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 test               |  3 +++
 tests/03assem-incr | 20 +++++++++++++-------
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/test b/test
index 814ce1992b0c..1fce6be2c4a9 100755
--- a/test
+++ b/test
@@ -33,6 +33,9 @@ LVM_VOLGROUP=mdtest
 md0=/dev/md0
 md1=/dev/md1
 md2=/dev/md2
+# if user doesn't specify minor number, mdadm chooses minor number
+# automatically from 127.
+md127=/dev/md127
 mdp0=/dev/md_d0
 mdp1=/dev/md_d1
 
diff --git a/tests/03assem-incr b/tests/03assem-incr
index 38880a7fed10..21215a34f93b 100644
--- a/tests/03assem-incr
+++ b/tests/03assem-incr
@@ -9,15 +9,21 @@ set -x -e
 levels=(raid0 raid1 raid5)
 
 if [ "$LINEAR" == "yes" ]; then
-  levels+=( linear )
+	levels+=( linear )
 fi
 
 for l in ${levels[@]}
 do
-  mdadm -CR $md0 -l $l -n5 $dev0 $dev1 $dev2 $dev3 $dev4 --assume-clean
-  mdadm -S md0
-  mdadm -I $dev1
-  mdadm -I $dev3
-  mdadm -A /dev/md0  $dev0 $dev1 $dev2 $dev3 $dev4
-  mdadm -S /dev/md0
+	mdadm -CR $md0 -l $l -n5 $dev0 $dev1 $dev2 $dev3 $dev4 --assume-clean
+	mdadm -S $md0
+	mdadm -I $dev1
+	mdadm -I $dev3
+	mdadm -A $md0  $dev0 $dev1 $dev2 $dev3 $dev4
+	# If one array is foreign (metadata name doesn't have the machine's
+	# hostname), mdadm chooses a minor number automatically from 127
+	if [ $is_foreign == "no" ]; then
+		mdadm -S $md0
+	else
+		mdadm -S $md127
+	fi
 done
-- 
2.32.0 (Apple Git-132)

