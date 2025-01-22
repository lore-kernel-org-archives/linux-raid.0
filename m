Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709A3212D62
	for <linux-raid@vger.kernel.org>; Wed, 22 Jan 2025 15:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737559149; cv=none; b=EfaUhas7YchxWpUwSHUsh3m+VM5328iqjQKKMzRR3WF3InoB/6T1EBibbs4Jc1jm4F+92SYIll3JBvFrvXq+zAQUOzLTw3xHDl4A/sCATQkEDK/i1wP/MJJxC5+rem+Uhq950QqfNj2tMqttr3pCXtax4kosHVqg6BXzCcC5y2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737559149; c=relaxed/simple;
	bh=XOl31pEfNCbwimo2D2ZZQPexH0X+kJzB0m/CVMqNtjE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JtNgO5wT5OxzdUlVnWWx7BUBkYf0XsSdTNdjVo4Z0XRrpAdqCDwkG9Rwk0fveVTWTwlv5Ay37i1iKTDd0oumV8zf5wAe3Ncp2jjWVz4HIN5indJrDy12OlNBzpQl5K5UAlpw3Rfka8rVPCduTCMKh617BDicbg0q3n0WHGiaU+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SqEMti1i; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RcaKChc/; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=g2C3hrSQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=iDykTr9e; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SqEMti1i";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RcaKChc/";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="g2C3hrSQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="iDykTr9e"
Received: from suse-arm.lan (unknown [10.202.80.178])
	by smtp-out1.suse.de (Postfix) with ESMTP id 05C05218B2;
	Wed, 22 Jan 2025 15:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1737559145; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=nLPAzXruhEg/nhZhVnDOAlIVunpIq2DHT7d9LebeBB0=;
	b=SqEMti1iTEGlIpROSYHLLbWisrw/EijPbXQmNsMNgdUlUFvNfeYuo6+TZJWjdONYFZy9rO
	agSj3LBenpT6zmAMJHMWDXYCvWUmbd9bxiTTbd9/9V5uWHqwPxZ2EIuxkZZ4eug1Oi+oo0
	v7JlmoJGrzWOjYCyDUKOnZJd3JsYU68=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1737559145;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=nLPAzXruhEg/nhZhVnDOAlIVunpIq2DHT7d9LebeBB0=;
	b=RcaKChc/tORzh+/YrXKBgdSPl0yQ3/SLCPuzZUrCni6Lz7uVFCFkkd9fdapWmJHdu6wlXY
	o9OE3If5QHzqLMAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1737559144; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=nLPAzXruhEg/nhZhVnDOAlIVunpIq2DHT7d9LebeBB0=;
	b=g2C3hrSQbyWNSYWqP8HtznjPwsXbvZioxEeB8MSGJJTbjD3799M0IFOnFKqYeu1mBSoVjx
	SLHPIBIpP2gvpYX8HlY43WTabaJ4whO3RJirrCVH0GUzJUBNhKUo4Xkh0O/0ZJp9AzOODD
	T8uiZU+XePCwmIFCQdHtx7Di4L67kHM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1737559144;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=nLPAzXruhEg/nhZhVnDOAlIVunpIq2DHT7d9LebeBB0=;
	b=iDykTr9ePRwaKnz2XuAyV8c5KzCqrSYfOoiNsthHYHnSUZhNwc0aG6BIEQ9AEaMUdViXUD
	DGb4yUh9+gVTpyBQ==
From: Coly Li <colyli@suse.de>
To: mtkaczyk@kernel.org
Cc: linux-raid@vger.kernel.org,
	Coly Li <colyli@suse.de>
Subject: [PATCH v3]  mdopen: add sbin path to env PATH when call system("modprobe md_mod")
Date: Wed, 22 Jan 2025 23:18:59 +0800
Message-ID: <20250122151859.254365-1-colyli@suse.de>
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
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,suse-arm.lan:helo]
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
Changelog,
v3, check return value of getenv().
v2: set buf[PATH_MAX] to 0 in stack variable announcement.
v1: the original version.

 mdopen.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/mdopen.c b/mdopen.c
index 26f0c716..57252b64 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -39,6 +39,24 @@ int create_named_array(char *devnm)
 
 	fd = open(new_array_file, O_WRONLY);
 	if (fd < 0 && errno == ENOENT) {
+		char buf[PATH_MAX] = {0};
+		char *env_ptr;
+
+		env_ptr = getenv("PATH");
+		/*
+		 * When called by udev worker context, path of modprobe
+		 * might not be in env PATH. Set sbin paths into PATH
+		 * env to avoid potential failure when run modprobe here.
+		 */
+		if (env_ptr)
+			snprintf(buf, PATH_MAX - 1, "%s:%s", env_ptr,
+				 "/sbin:/usr/sbin:/usr/local/sbin");
+		else
+			snprintf(buf, PATH_MAX - 1, "%s",
+				 "/sbin:/usr/sbin:/usr/local/sbin");
+
+		setenv("PATH", buf, 1);
+
 		if (system("modprobe md_mod") == 0)
 			fd = open(new_array_file, O_WRONLY);
 	}
-- 
2.48.1

