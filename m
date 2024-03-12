Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7529878691
	for <linux-raid@vger.kernel.org>; Tue, 12 Mar 2024 10:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710237723; cv=none; b=eh2sQuKi5MwrjDK8P5Vmv99HYxlxmZu+FNi45QlOwrE7y/ullwXpkHTBoaB4Uv1JLymWJfVcYSdUMkY44vnmMjjzs+pvdmFsLIfADnqn9mToXB7y4rM2IHwgNQKTcULhuexO948RgQg32+Bkng9woG4QX7xzp3WS7dNcPOkw7wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710237723; c=relaxed/simple;
	bh=M8BBDjMdTObywP3OdKRJh2Q63dvkCb9GibwuZc/M6w8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Q7LmURMRPARrvRe1YPuAeA9J50/ghcundAK4po/EQlhh7M/8Ebg1APsFCbIZHG8WcRgzrrfzNyc8ic9g2M86GwX7FiY52EAXsMiPwzmu3+42wYX8x2oGfyb9uuuek/Fw744aF2enaaeXEgeSdLKYQlYWcE2t+HxuwpvqpHFBZMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=yvUL2yLU; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Fg8zx+uY; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="yvUL2yLU";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Fg8zx+uY"
From: Alexander Kanavin <alex@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1710237719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1rE0Ml72O8LASLZB5V5YXLpG3qE/VslVY8HoRQMBLtY=;
	b=yvUL2yLUrLphmo9Sajbv6Tn1c5ENl1PP3IZilKvpv1byRzKyu75zW8fQQPLtB7bZ7uHDjn
	dWz8oQI9ptBV4k4rA0F95lzqyovz3Ew6bdG9ahFWnWlJWeUkr0bRTj0oA4aWy5vEzQ6ohp
	ZVUSD6OcvaBfFWeQfKNhfEkWGnyEs5kcFqEoeozjOJxZ4DZSySZcnGAOh9h6ehLTnKRlE/
	dRJnPNk1obWs0K4zxA8vC4A7iplWgAG9yFj3T1b320YB/sGf/2adMHMgjfZHGpD/gKp11n
	F0aZdsoyEyhBw7+fJWC/dtVBVUIeTwXCMo5qz03KMKD33X4C+/UdP8kHTdSvjg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1710237719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1rE0Ml72O8LASLZB5V5YXLpG3qE/VslVY8HoRQMBLtY=;
	b=Fg8zx+uYqG0VvA6UbG1xt/0mc7RAx+NsZruUGOUEEbTWbWlajRu/SdGTxRdbT0nq571LDR
	QZD45Q8Z7z0b59Ag==
To: mariusz.tkaczyk@linux.intel.com,
	linux-raid@vger.kernel.org
Cc: Alexander Kanavin <alex@linutronix.de>
Subject: [mdadm][PATCH] util.c: add limits.h include for NAME_MAX definition
Date: Tue, 12 Mar 2024 11:01:50 +0100
Message-Id: <20240312100150.392586-1-alex@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Alexander Kanavin <alex@linutronix.de>
---
 util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/util.c b/util.c
index 05ad3343..49a9c6e2 100644
--- a/util.c
+++ b/util.c
@@ -36,7 +36,7 @@
 #include	<ctype.h>
 #include	<dirent.h>
 #include	<dlfcn.h>
-
+#include	<limits.h>
 
 /*
  * following taken from linux/blkpg.h because they aren't
-- 
2.39.2

