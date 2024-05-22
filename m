Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F0A46522
	for <linux-raid@vger.kernel.org>; Wed, 22 May 2024 08:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716367910; cv=none; b=NekokiHa7TOpIX21esWHtFiXwCgUaF7AHsNgS0ZaGTFwGt/HdHneGrlpzdpsGMIVl+OE7I/3y6kUwvwsTmJ0/XTMQVzn42b1wahQHHI1ocNxBMMtknCZf2K3iNrCFsP4JQjV9azslQ/8naev9YCILilMxcLyIElksQJ4Ms+e470=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716367910; c=relaxed/simple;
	bh=Ki+m0fJLOynfQuU74ZsWm41Hjvi3IKWcnlW7vrtjvpc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rJc1QWhILZjxMhMC1KwwFv8Io2ibZSj8PnFCbUvYkEpGHWXzbhd7jeU4V7b+xphBtjuBkv4hD3JBoHCqNwWz62KOqG2MwiU34+27ogphWRXyb4kjvVjURcQ/JkffWGYubcdLfnhM7hZu3NekMGK8rXvserD21ugqkFIOiOHnRxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GeOotfie; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GeOotfie"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716367907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/O1W5i9/giphgtMY4vltoNSUnOeEOu1D0dJ6hrZW63A=;
	b=GeOotfie/4hHlUVNvNne4jjRdlT7DP41rU78+a3OD8UkmZcVNtuz85/0Gj97z8cl+lyfnJ
	ZG4tMs0QDma4Q7YCcaWIevmG7uH42KCxFuzE2IHTSKZiOkIix9XpghmPbvE+D2b+pmT3wm
	5rzzQvu++x+SeC8T3tQ1DxxbXRZldfg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-130-A6K6T9O9NYGBLwCNa0zhRQ-1; Wed,
 22 May 2024 04:51:44 -0400
X-MC-Unique: A6K6T9O9NYGBLwCNa0zhRQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC7CD3800089;
	Wed, 22 May 2024 08:51:43 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.11])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E3B3AC15BB9;
	Wed, 22 May 2024 08:51:41 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	heinzm@redhat.com,
	ncroxon@redhat.com
Subject: [PATCH 15/19] mdadm/tests: 06name enhance
Date: Wed, 22 May 2024 16:50:52 +0800
Message-Id: <20240522085056.54818-16-xni@redhat.com>
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

It needs to check hostname in metadata name if one array is
local. Add the check in this case.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/06name | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tests/06name b/tests/06name
index 86eaab69e3a1..c3213f6c9f7b 100644
--- a/tests/06name
+++ b/tests/06name
@@ -3,8 +3,14 @@ set -x
 # create an array with a name
 
 mdadm -CR $md0 -l0 -n2 --metadata=1 --name="Fred" $dev0 $dev1
-mdadm -E $dev0 | grep 'Name : Fred' > /dev/null || exit 1
-mdadm -D $md0 | grep 'Name : Fred' > /dev/null || exit 1
+
+if [ $is_foreign == "no" ]; then
+	mdadm -E $dev0 | grep "Name : $(hostname):Fred" > /dev/null || exit 1
+	mdadm -D $md0 | grep "Name : $(hostname):Fred" > /dev/null || exit 1
+else
+	mdadm -E $dev0 | grep "Name : Fred" > /dev/null || exit 1
+	mdadm -D $md0 | grep "Name : Fred" > /dev/null || exit 1
+fi
 mdadm -S $md0
 
 mdadm -A $md0 --name="Fred" $devlist
-- 
2.32.0 (Apple Git-132)

