Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE1A3B42E5;
	Mon, 22 Jun 2026 13:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.40.148.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782136550; cv=none; b=JPQqIDYGBqrMMD3o2BFiOASJdXBYVM9Aq+XR9Ya/VSvJh9fQuRFztp11utrfURXywOZ4YLij1Iv1wrfVANPL4mbEAzoNfujee1UCSM2jhcLjE5Fm/y1pYB2s/Pyf6ieSBEI8sNeUv9EhS3k3miVMYVcCW/PQD+NL6MFD6dG/m6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782136550; c=relaxed/simple;
	bh=9BvRdIBACByVDe76RnoHiZf7cg+E5YVxC4MdC7cIOVI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=r5ai4BWV3zXyd58ohwFivpVK66MRr/LpIKtBzq59sqC8OmLPSm+gsCR4errGE2oW426KwPagwPMDmoHdpSgNsHP5VobSqtuzT5+GDZUY+PvXZmA8RcjsFaGd96ZFVheWbhdBdsQ755+SzMfm1xfaX7nsqYh8f6Go2AvaB11OZd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codethink.co.uk; spf=pass smtp.mailfrom=codethink.com; dkim=pass (2048-bit key) header.d=codethink.co.uk header.i=@codethink.co.uk header.b=X0tKilYS; arc=none smtp.client-ip=78.40.148.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codethink.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codethink.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codethink.co.uk header.i=@codethink.co.uk header.b="X0tKilYS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=codethink.co.uk; s=imap5-20230908; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:In-Reply-To:
	References; bh=C39aNqUfckICrRYUCJ32OG2byxRISEpkNLemt876ss4=; b=X0tKilYS6zomJR
	E3hkyJNf1I7llPV05Z9be2Ar/qM5UDYXqtGqrKVaCKuX26RUyFnAwf3pGaOxDr0NWy7JPUgY2kRwv
	MlxpOg45gk/N0b421jCN9MBle5Mer68Yc3V441CHMRgGzgLpeZByzgoX2AMges3WUImm2HViocHh9
	bKiBBgRuMTI8uDhb70sF3qYaNgcWeSy/p+vzOqL26NR3l4fFI2epCTzwxWkAXDTYoCho6sBJRkQzs
	RC0AoGv6UghP5lxXDhZChU90yTC49XR2vOd9aRoA07YhKbo8ylSIM4u+lm3CgarkK/reFl4kt/PO2
	ypGCu/GSLeekZ5sb7/Eg==;
Received: from [167.98.27.226] (helo=rainbowdash)
	by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1wbf7h-0053ms-Ak; Mon, 22 Jun 2026 14:55:37 +0100
Received: from ben by rainbowdash with local (Exim 4.99.4)
	(envelope-from <ben@rainbowdash>)
	id 1wbf7g-000000021Gt-3fYo;
	Mon, 22 Jun 2026 14:55:36 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: linux-raid@vger.kernel.org,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH] raid6: fix raid6_recov_rvv symbol undeclared warning
Date: Mon, 22 Jun 2026 14:55:35 +0100
Message-Id: <20260622135535.481534-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.37.2.352.g3c44437643
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: srv_ts003@codethink.com

The riscv recov_rvv.c should have included pq_arch.h for
the definition of raid6_recov_rvv. Add the include to
fix the following sparse warning:

lib/raid/raid6/riscv/recov_rvv.c:218:32: warning: symbol 'raid6_recov_rvv' was not declared. Should it be static?

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 lib/raid/raid6/riscv/recov_rvv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/raid/raid6/riscv/recov_rvv.c b/lib/raid/raid6/riscv/recov_rvv.c
index 2305940276dd..78e158a3e332 100644
--- a/lib/raid/raid6/riscv/recov_rvv.c
+++ b/lib/raid/raid6/riscv/recov_rvv.c
@@ -8,6 +8,7 @@
 #include <linux/raid/pq.h>
 #include "algos.h"
 #include "rvv.h"
+#include "pq_arch.h"
 
 static void __raid6_2data_recov_rvv(int bytes, u8 *p, u8 *q, u8 *dp,
 				    u8 *dq, const u8 *pbmul,
-- 
2.37.2.352.g3c44437643

