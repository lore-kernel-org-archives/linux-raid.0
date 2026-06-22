Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A1C3A9D88;
	Mon, 22 Jun 2026 13:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.40.148.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782136346; cv=none; b=IRJ0LVkogWb49+QgUjr3MBnrJx+DxdIjk82mSisxVlypQqrEnLqJa3VTgEBgGeV9MvuX8/U9UPocQAW2Mza00gKeMflu0yj1zt+ZDGBDzsr3CQ4LYfUtXq6uhlW3K13D0p/LopIU8jSPVp0FDf3uOzp+UqkJqQOZ1a9rL/WZ0oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782136346; c=relaxed/simple;
	bh=fyAVTm9/cKs+Cz2N2VGHa/aHjRQ4iU7Z0KGA93bPuWc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=m0WghiQnElZyi3oyADlKQ1BWBbE42ikBUgMi5/etAiEsBcfJPZ4fHRI731Tdk3tz+u6gxuex5kO0dw2DrLrQLXKuzOfyUFCFTPpQpIRWkumMeDE8FOsG8Lb8If685q/nJErUJW1OCE1HR/qV+JzzqNNIF6tFAv+sWc0IAdOVt9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codethink.co.uk; spf=pass smtp.mailfrom=codethink.com; dkim=pass (2048-bit key) header.d=codethink.co.uk header.i=@codethink.co.uk header.b=7nfAn3kv; arc=none smtp.client-ip=78.40.148.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codethink.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codethink.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codethink.co.uk header.i=@codethink.co.uk header.b="7nfAn3kv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=codethink.co.uk; s=imap5-20230908; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:In-Reply-To:
	References; bh=GMmqRh9CyFpDpehaiS8J4tMzKfblNr9nNNRXd+QZ2ZE=; b=7nfAn3kv3Y/WIy
	/RG09bPYtxYrXobGCZm1uxOwCgQ1hH8yiunWn9wkQ3qix9K5VlPln38mNR5qN8GG77xNrs3YKnuSx
	kTU0NhISPANDDQuKmgu4R7COAUGo2wZ+dJcXX/9ulOmxDmJv4XpaPv5hClzHELI/1/8k9uvX7+5Mi
	s9t7s7e8NrI0bjF31h2VqW0rnSn65mJOHl9rjZQW5zEkWc8vy5Zh1ygth0UkoI1hvINmgt/rgUwXH
	CJzzW/JtlwTuSF6elaronGS4PAW9V29EnUE0klA7U+rU23w2m8iYquQ9jMyjOMoQLPQutodMFQ/II
	M8cho8/4GW6SpUuMnC0A==;
Received: from [167.98.27.226] (helo=rainbowdash)
	by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1wbf4K-0053Az-Pk; Mon, 22 Jun 2026 14:52:08 +0100
Received: from ben by rainbowdash with local (Exim 4.99.4)
	(envelope-from <ben@rainbowdash>)
	id 1wbf4K-0000000210v-2L1m;
	Mon, 22 Jun 2026 14:52:08 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: linux-raid@vger.kernel.org,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH] raid6: fix riscv symbol undeclared warnigns
Date: Mon, 22 Jun 2026 14:52:07 +0100
Message-Id: <20260622135207.480540-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.37.2.352.g3c44437643
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: srv_ts003@codethink.com

The riscv rvv.c file is missing the include of pq_arch.h
which defines all the exported functions. Include this
to remove the following sparse warnings:

lib/raid/raid6/riscv/rvv.c:1225:1: warning: symbol 'raid6_rvvx1' was not declared. Should it be static?
lib/raid/raid6/riscv/rvv.c:1226:1: warning: symbol 'raid6_rvvx2' was not declared. Should it be static?
lib/raid/raid6/riscv/rvv.c:1227:1: warning: symbol 'raid6_rvvx4' was not declared. Should it be static?
lib/raid/raid6/riscv/rvv.c:1228:1: warning: symbol 'raid6_rvvx8' was not declared. Should it be static?

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 lib/raid/raid6/riscv/rvv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/raid/raid6/riscv/rvv.c b/lib/raid/raid6/riscv/rvv.c
index 75c9dafedb28..4ac50606f3dc 100644
--- a/lib/raid/raid6/riscv/rvv.c
+++ b/lib/raid/raid6/riscv/rvv.c
@@ -10,6 +10,7 @@
  */
 
 #include "rvv.h"
+#include "pq_arch.h"
 
 #ifdef __riscv_vector
 #error "This code must be built without compiler support for vector"
-- 
2.37.2.352.g3c44437643

