Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E3039D6EC;
	Wed, 15 Jul 2026 14:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784126930; cv=none; b=XBsETWGcMAAiWNdwsLea0llUc9yXeRcqaO5ahubhudnmzDipHGoF+9tEMplfbrU7YrIln06S7I8s7r8jH2xqZniV0KWPDFNDkkYEyOsOVC7VdkUm4tKylscwZfIASvNpGLV+CO9BtL/WZkMAxGrXnezFcRJ4wJ7w1aNsKFKFRVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784126930; c=relaxed/simple;
	bh=EwLk75BmYbYOqUvvR7QXsDRSBUfC8DKIfHZfhHYN+wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEJxfHvHg0+t2Y5KzpU7O2aK7tnJLDIIsx2vNx7cjchc1P4SXuhE+Lu5TAQMvUUx7janN+Z9t5qvHi4mXTlou0Z5lynsG+AQcN0tNuDtjUPQNqpXimQuPXGoXVD/WOn64Z+j5VFnGxtzXzwqBxeVUQE/x5/kmn9zCUvXrGbYOuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zotmbOC5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zotmbOC5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=c0Almg3B1vcRAPM/occ6NILXdmIPcSVkOclM2ajVpCY=; b=zotmbOC50nk5lcej3S/LLc5wZz
	vvlr4oWiKbAlacREhiep9Wq9W08ks8rzy2O/1nwJPBMPT+dbqbQPDLrlIzM1EagqDy6NC8zynYtDS
	+1JsNrcHe+CtAOwLsICTLhX8EJE43TRLPipSevUGxBmfHpSLIXqqYbrjAHlXYnvTHh7/MTHdebuPb
	jdjs7Z2hn4nbc/Mo6he7meSgcZOafMpeL3bh/G0UgbiF+gN+C8Sc9cWH5dg1KIGZrFI4TNp1QSopm
	IZzwMJGdDAwFu+eQjfDUZOQ9LnFvlPi4wUhc0JXIjlW1WxcCA74ZBeaFVQ2hoYC/4i9zq0QHp5Unm
	DsLHs6UA==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wk0uk-0000000FDB8-1EvO;
	Wed, 15 Jul 2026 14:48:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] raid6: enable lock context analysis
Date: Wed, 15 Jul 2026 16:47:36 +0200
Message-ID: <20260715144825.95432-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260715144825.95432-1-hch@lst.de>
References: <20260715144825.95432-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The code doesn't have any locking, so this is trivial.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/raid/raid6/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/raid/raid6/Makefile b/lib/raid/raid6/Makefile
index 038d6c74d1ba..5cdb7223de2a 100644
--- a/lib/raid/raid6/Makefile
+++ b/lib/raid/raid6/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
+CONTEXT_ANALYSIS := y
+
 ccflags-y			+= -I $(src)
 
 ifeq ($(CONFIG_RAID6_PQ_ARCH),y)
-- 
2.53.0

