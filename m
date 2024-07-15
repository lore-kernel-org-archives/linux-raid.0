Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411B7B64E
	for <linux-raid@vger.kernel.org>; Mon, 15 Jul 2024 07:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721028978; cv=none; b=GbqI+WXCuQVPJJ0qHYupNNmSn6FwQHugP06x0Knsm6fiGFFMX/TE8IWlxO9bZQWGGZbH/aZ3lOo05Dlvaz/DZPsMeOC/4Q69UJqo7vU9QbUB5Og5SVYvSlZdHDgBF8Rm9AH6MqEXD+Vvo0IggQHqIGHRWhUTn2rhuLn3K2AIxY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721028978; c=relaxed/simple;
	bh=SUBEjqpz/KkhOY/3A9zkr3YbSmZWy+TUASwhMDkyNFM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Sk4icwZDsATU4z9YK8r4hcVbDmBvusaqJbimh/luBUs0ookvHRXYTpUYOLrBbfYuQ8N2gfzkWGm0gK2KvCsALM3DDHZOoxGeJCXf20WpihBCxE5YtkxXfF68xHeSQ1gy103EOCQ/98TzD1dL9gmmMU4k5ofMiMVhSV04UuvwROI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DJyfkY3g; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DJyfkY3g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721028975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=BA8P/pbtmYqBB6nXWqYUT3xDE/Q8OVQhcKtO2nPqs1o=;
	b=DJyfkY3gP8Iwx9UmQN2LESxIsfW6H8Q32FYezR9Y1um3hdRN7SpIUWD3DsFhB2/QYbUQJ2
	luwMI1sFeip2LjB1sUZViYVHa3nRoo4xxwVFKpX0moAVtPEyeK8bXVJ6eShgX7htMPJws/
	FGCWQyemVJ5OHer9dC1khC735nJ9s/s=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-384-yKGDhEWuPSifUA_g1iMZkA-1; Mon,
 15 Jul 2024 03:36:11 -0400
X-MC-Unique: yKGDhEWuPSifUA_g1iMZkA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E8ABE1955BED;
	Mon, 15 Jul 2024 07:36:09 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.27])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 58C6C1955D42;
	Mon, 15 Jul 2024 07:36:06 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 00/15] mdadm: fix coverity issues
Date: Mon, 15 Jul 2024 15:35:49 +0800
Message-Id: <20240715073604.30307-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Hi all

This patch set fixes coverity issues.

Xiao Ni (15):
  mdadm/Manage: 01r1fail cases fails
  mdadm/Grow: fix coverity issue CHECKED_RETURN
  mdadm/Grow: fix coverity issue RESOURCE_LEAK
  mdadm/Grow: fix coverity issue STRING_OVERFLOW
  mdadm/Incremental: fix coverity issues.
  mdadm/mdmon: fix coverity issue CHECKED_RETURN
  mdadm/mdmon: fix coverity issue RESOURCE_LEAK
  mdadm/mdopen: fix coverity issue CHECKED_RETURN
  mdadm/mdopen: fix coverity issue STRING_OVERFLOW
  mdadm/mdstat: fix coverity issue CHECKED_RETURN
  mdadm/super0: fix coverity issue CHECKED_RETURN and EVALUATION_ORDER
  mdadm/super1: fix coverity issue CHECKED_RETURN
  mdadm/super1: fix coverity issue DEADCODE
  mdadm/super1: fix coverity issue EVALUATION_ORDER
  mdadm/super1: fix coverity issue RESOURCE_LEAK

 Grow.c        | 98 ++++++++++++++++++++++++++++++++++++++++-----------
 Incremental.c | 20 +++++------
 Manage.c      |  2 +-
 mdmon.c       | 11 ++++--
 mdopen.c      |  8 +++--
 mdstat.c      | 12 +++++--
 super0.c      | 10 ++++--
 super1.c      | 32 ++++++++++++-----
 8 files changed, 144 insertions(+), 49 deletions(-)

-- 
2.32.0 (Apple Git-132)

