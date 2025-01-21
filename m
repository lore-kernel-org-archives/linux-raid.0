Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6CA1F540D
	for <linux-raid@vger.kernel.org>; Tue, 21 Jan 2025 15:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737472572; cv=none; b=HIyk1GEPXF5JIrAfbmO4UcSkUAtuo0cATj9YS74mbLSj/jwX6s+uiiSC89m1BKViM9oIy8q3L1uvQnzWt4fdQhZka3GPh7aWGH2DAlxKSFbHEJWANVoSjqyLo9p0APG2gCTMCm1orarcbmkddrb/Nw0A0Q+/OBx4XuZM0p+kX6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737472572; c=relaxed/simple;
	bh=PkaZHFAz9ZhifdKPcEHhzrAoiXZ8Cymkrvjd1grX3sc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mSi4+UP1lp/EjxdxRCOr0574V8RlffzY1FI8u8W/hCkHJomjwlTJMBk/r9EjZbJMvNFLy37rBrTIK23AxbyWyjL0CxrV1jWddmzzaunX7PQSGIAfkTcCvvwrDayAK9/RHVAkz471JX4FiWMz47lqj3BqydXSmcRJ5oWWMkAwwdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Wsu36k4w; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=sQNX06td; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=p0BCeflE; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=TrY/odO8; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Wsu36k4w";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="sQNX06td";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="p0BCeflE";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="TrY/odO8"
Received: from suse-arm.lan (unknown [10.202.80.178])
	by smtp-out2.suse.de (Postfix) with ESMTP id C8D141F37E;
	Tue, 21 Jan 2025 15:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1737472567; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ctEWPvdUEaCzFQfJB4+k4+sHggIaqBIX6TjXP7q78WE=;
	b=Wsu36k4wQ9bmEbHVSGjYCSG1W0hlEq89D8KcENI+Ngtd+vLf3mOQP3ogSqIw5Dyx/HDqee
	HgMf+m+e+G/tJl3PVz6AU3GVFVLgGgY6rsY3F8xjt4ikhG6q5CEZnU9o0eQ0EyzvOJPbyV
	Gf6rPtq7Ux/HobaL7gsHLiXoHS/DoOY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1737472567;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ctEWPvdUEaCzFQfJB4+k4+sHggIaqBIX6TjXP7q78WE=;
	b=sQNX06td1B/Q6yDuAzI0i48hM/FsY3VRb02fjAMzthstX7+lEqEwAkmpR6QaLPakmBtKpC
	ZedzOSZjR+D2z+Bw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1737472566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ctEWPvdUEaCzFQfJB4+k4+sHggIaqBIX6TjXP7q78WE=;
	b=p0BCeflE/X1+Z8JrDzAUlbXwB3JoqokuTsiSRYqFpcl029lWYM6PNGsxx2F2F/PHSD5WKB
	Fyce8J+s1J9lP3NKzecMV16YVwCdM6zeh09SOlz6FqL+chh2UtQa6KP8f9R3zOV8bC6set
	/QW3vcHEGObl2p6e5WvULoYk8xsn6wE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1737472566;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ctEWPvdUEaCzFQfJB4+k4+sHggIaqBIX6TjXP7q78WE=;
	b=TrY/odO8Vacao2mwK/nAY04hT3e07yvU9ORB6pO5AQ/dOy2M0m8x+8AjewDB8culvCvqoy
	XbNKM44GWL7wmfCw==
From: Coly Li <colyli@suse.de>
To: mtkaczyk@kernel.org
Cc: linux-raid@vger.kernel.org,
	Coly Li <colyli@suse.de>
Subject: [PATCH] mdopen: add sbin path to env PATH when call system("modprobe md_mod")
Date: Tue, 21 Jan 2025 23:16:03 +0800
Message-ID: <20250121151603.235606-1-colyli@suse.de>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse-arm.lan:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 

During the boot process if mdadm is called in udev context, sbin paths
like /sbin, /usr/sbin, /usr/local/sbin normally not defined in PATH env
variable, calling system("modprobe md_mod") in create_named_array() may
fail with 'sh: modprobe: command not found' error message.

We don't want to move modprobe binary into udev private directory, so
setting the PATH env is a more proper method to avoid the above issue.

This patch sets PATH env variable with "/sbin:/usr/sbin:/usr/local/sbin"
before calling system("modprobe md_mod"). The change only takes effect
within the udev worker context, not seen by global udev environment.

Signed-off-by: Coly Li <colyli@suse.de>
---
 mdopen.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mdopen.c b/mdopen.c
index 26f0c716..30cf781b 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -39,6 +39,18 @@ int create_named_array(char *devnm)
 
 	fd = open(new_array_file, O_WRONLY);
 	if (fd < 0 && errno == ENOENT) {
+		char buf[PATH_MAX];
+
+		/*
+		 * When called by udev worker context, path of modprobe
+		 * might not be in env PATH. Set sbin paths into PATH
+		 * env to avoid potential failure when run modprobe here.
+		 */
+		memset(buf, 0, PATH_MAX);
+		snprintf(buf, PATH_MAX - 1, "%s:%s", getenv("PATH"),
+			 "/sbin:/usr/sbin:/usr/local/sbin");
+		setenv("PATH", buf, 1);
+
 		if (system("modprobe md_mod") == 0)
 			fd = open(new_array_file, O_WRONLY);
 	}
-- 
2.47.1

