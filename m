Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B55A42
	for <linux-raid@vger.kernel.org>; Thu, 18 Jan 2024 10:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705573856; cv=none; b=Fv6lSscW7NtDPdplm4jOAh2uATDVj1l3zfZq3ZmUzme1GLGyXX/EDaes9pe4X+WboFUUcDbj0cz1ipbUAApNJU9YaBk3DgWZUf0RPxKR4zTihGK+qII5st3G1RfmjnpLkCLOszGaUo5M7IVs2BMoRdQjbUuYMI/KGLljbxkGHz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705573856; c=relaxed/simple;
	bh=Oyz++gXu86lZR46CWuAnPcCf+JC4oYux74InBvpIY48=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding; b=f0eV8N4z8Uxm1YvPlAXTJHY696Jii9hIuuu9zObU41EGjMirAhoYFH6PygwTfn2Qnqz6Gmszh+SsOEzzro9Cqmtf/vDiA2t6XyUTM6Mi5aWjeHUYrXqrnqFhPs9N5SefqPas9s+4+v7ghs5FWhSh2rNmFQypmOrbKqwhVviPpD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bM9CZnsM; arc=none smtp.client-ip=134.134.136.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bM9CZnsM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705573855; x=1737109855;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Oyz++gXu86lZR46CWuAnPcCf+JC4oYux74InBvpIY48=;
  b=bM9CZnsMrWODPf8ZnOOMQSloEwehHChJR6x3A4gft4InaVSTOyI36SnZ
   rkbR1TdxEyJBlqi/2af9pQjej3d2FL6o4hxiC7ws9fPDpNvsDod4Kqeet
   i7A3NVv5Yn0/nFet6Ij048L6tBnelAwnJBN7b3/36WPevu6QIfzF7LC0B
   SEc0ZNaIKpnOvAoyMBoc532dxeNbOLv9W62uEcfdodsasc8N216NV8dfw
   0cziTSYvEHdKzxqlpaHXIH5UiIJs7aVH5M38nylBYmqvQvHlDCSUea3Pp
   MjpbkbJ3+Q4h3gErRHRYBPylaabG5LqpxMnJaS33HcXzCrcMHde5Bf7jO
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="390858564"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="390858564"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2024 02:30:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="1115927039"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="1115927039"
Received: from patodeveloperka.igk.intel.com ([10.102.109.29])
  by fmsmga005.fm.intel.com with ESMTP; 18 Jan 2024 02:30:53 -0800
From: Mateusz Kusiak <mateusz.kusiak@intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org,
	mariusz.tkaczyk@linux.intel.com
Subject: [PATCH v2 3/5] Super-intel: Fix first checkpoint restart
Date: Thu, 18 Jan 2024 11:30:17 +0100
Message-Id: <20240118103019.12385-4-mateusz.kusiak@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240118103019.12385-1-mateusz.kusiak@intel.com>
References: <20240118103019.12385-1-mateusz.kusiak@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When imsm based array is stopped after reaching first checkpoint and
then assembled, first checkpoint is reported as 0.

This behaviour is valid only for initial checkpoint, if the array was
stopped while performing some action.

Last checkpoint value is not taken from metadata but always starts
with 0 and it's incremented when sync_completed in sysfs changes.

In simplification, read_and_act() is responsible for checkpoint updates
and is executed each time sysfs checkpoint update happens. For first
checkpoint it is executed twice and due to marking checkpoint before
triggering any action on the array, it is impossible to read
sync_completed from sysfs in just two iterations.

The workaround to this is not marking any checkpoint for first
sysfs checkpoint after RAID assembly, to preserve checkpoint value
stored in metadata.

Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
---
 super-intel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/super-intel.c b/super-intel.c
index 6a664a2e58d3..ebf43209e75d 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -8741,6 +8741,9 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 		super->updates_pending++;
 	}
 
+	if (a->prev_action == idle)
+		goto skip_mark_checkpoint;
+
 mark_checkpoint:
 	/* skip checkpointing for general migration,
 	 * it is controlled in mdadm
-- 
2.35.3

