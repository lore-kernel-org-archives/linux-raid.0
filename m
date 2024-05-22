Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B194E8004F
	for <linux-raid@vger.kernel.org>; Wed, 22 May 2024 08:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716367893; cv=none; b=nuBG5f2MgzHr2LTJG0LMcuLyH4SVDNuIQvPuA6JW1Z6XevPEb2b71lZnX1KeHaPLCObRccBB+gkQVQDQ9uDq69GJL4RFhVy8GVDC/UVMDuFwvE8ecf8n72a/BOrNvPcpqeVp7Zz+BkMsyIuCojg5OnbDpATOBm3kdN1/Rofy08M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716367893; c=relaxed/simple;
	bh=DbtycjBvs9gkptJJKXkGmQmYh9sIk1b0zAx+oeyHkBM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qufH6dMA+6qvAcsh9OuCgx9CgvXVpT6LCs1yEMTyJ4bkF9NrOIune3sliJgrClY85XOXBX/XTArIUHoGL9ODO+sUteHIM/7DUdnkSy1Eu7jZfLIYmhn0DUUljv+NkyTQAL2mfk4NjC3+Qb1jIj8ZSdX5s8OEo+e/iaiTIKxpZW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E98lyyrd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E98lyyrd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716367890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2vVCTIsyPQmrNfiB0nS1dzR/Y1pZJ0r5kzlaMEGldYc=;
	b=E98lyyrd5/Ky7Z3tkTHb3EV55G5th0I90DVS8kChZbI7Be00/dRuuS5qvF/+sZEnDguz/i
	hXOktPdmYjKctJGYuB2kC6mwqt1/ZbDckyIhVnpyie+ZmbHMRp+IhiPpez5qYUY3olBK58
	wTPm4zny4ETsodKXcQtm0LhDFqD3Gl8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-u4AXZkllN_WydQbtgzSv_g-1; Wed, 22 May 2024 04:51:27 -0400
X-MC-Unique: u4AXZkllN_WydQbtgzSv_g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24FDF800994;
	Wed, 22 May 2024 08:51:27 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.11])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 18C57C15BB1;
	Wed, 22 May 2024 08:51:24 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	heinzm@redhat.com,
	ncroxon@redhat.com
Subject: [PATCH 09/19] mdadm/tests: remove 03r5assem-failed
Date: Wed, 22 May 2024 16:50:46 +0800
Message-Id: <20240522085056.54818-10-xni@redhat.com>
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

03r5assem can run successfully with kernel 6.9.0-rc4

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/03r5assem-failed | 12 ------------
 1 file changed, 12 deletions(-)
 delete mode 100644 tests/03r5assem-failed

diff --git a/tests/03r5assem-failed b/tests/03r5assem-failed
deleted file mode 100644
index d38241df0228..000000000000
--- a/tests/03r5assem-failed
+++ /dev/null
@@ -1,12 +0,0 @@
-
-# Create an array, fail one device while array is active, stop array,
-# then re-assemble listing the failed device first.
-
-mdadm -CR $md1 -l5 -n4 $dev0 $dev1 $dev2 $dev3
-check wait
-
-echo 2000 > /sys/block/md1/md/safe_mode_delay
-mkfs $md1
-mdadm $md1 -f $dev0
-mdadm -S $md1
-mdadm -A $md1 $dev0 $dev1 $dev2 $dev3 || exit 1
-- 
2.32.0 (Apple Git-132)

