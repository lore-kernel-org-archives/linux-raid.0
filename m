Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594E2158535
	for <linux-raid@vger.kernel.org>; Wed, 22 Jan 2025 03:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737518047; cv=none; b=pkdvNhYeZH6LMgYL6tbWAJ/m+bcP8WwFTWutQjCQoP26vuSCi5wKQ6KTb5EewmLIu9dMGjetMS75BGUCnQSa82dp3UQINOVT+I61NfGBQ/T7FxDgGRBg9+JXWY1tsSH9Dqv0iKEmsa+KFAvXt8AJMaf61HXM5Cd4El3R2c7nZyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737518047; c=relaxed/simple;
	bh=adkpm0kDwawPPKIEojtW+EDs0edtxnYLlQP2TvtNQxg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ib17n+50CqeHONA9qFoQ69vbHCeW1493GZALHh/3zhYGOb2IwBlSaKtJwO4Ma9rTsWq0WfTNAZvbySsrCIqY4oqQkY+OLqqFAbppAFPgkiqxtvfuK/E64f35Gi8uYoaHerOKI1PhG7n1ge3m2k6siQ+uwGtD8Y/dQ4tjBr6DbP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zX7tb2FB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Ae80oUOI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zX7tb2FB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Ae80oUOI; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zX7tb2FB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Ae80oUOI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zX7tb2FB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Ae80oUOI"
Received: from suse-arm.lan (unknown [10.202.80.178])
	by smtp-out1.suse.de (Postfix) with ESMTP id 597F7211F2;
	Wed, 22 Jan 2025 03:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1737518044; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cDc+43FrQ8uPOrqI+aPQ2d/lSxl6BVuJKfiuwiMzdKY=;
	b=zX7tb2FBxeFzaHl3t2ZIkld4JrQB79i0pB8W9ZGNZgPhf2lA80GFfAQZ/K5zawBMaA5zmu
	vK7PfZmvi6Fb5XIEhvlyV8UHcJfav6YJCwiBitX3TUueFoAPJguIiO8PF3WpiFmOcRMK4t
	KfrSY+YXrVHgvCSkJ56tzEIeFjCuJuc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1737518044;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cDc+43FrQ8uPOrqI+aPQ2d/lSxl6BVuJKfiuwiMzdKY=;
	b=Ae80oUOIrChCeCT+Z31C4PYEZ02/zbxaIGuDezrmXk5OMoQ9M/g+IQnuAQK5aS4r0oAZnd
	Cak/E8LeGhzjktBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1737518044; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cDc+43FrQ8uPOrqI+aPQ2d/lSxl6BVuJKfiuwiMzdKY=;
	b=zX7tb2FBxeFzaHl3t2ZIkld4JrQB79i0pB8W9ZGNZgPhf2lA80GFfAQZ/K5zawBMaA5zmu
	vK7PfZmvi6Fb5XIEhvlyV8UHcJfav6YJCwiBitX3TUueFoAPJguIiO8PF3WpiFmOcRMK4t
	KfrSY+YXrVHgvCSkJ56tzEIeFjCuJuc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1737518044;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cDc+43FrQ8uPOrqI+aPQ2d/lSxl6BVuJKfiuwiMzdKY=;
	b=Ae80oUOIrChCeCT+Z31C4PYEZ02/zbxaIGuDezrmXk5OMoQ9M/g+IQnuAQK5aS4r0oAZnd
	Cak/E8LeGhzjktBw==
From: Coly Li <colyli@suse.de>
To: mtkaczyk@kernel.org
Cc: linux-raid@vger.kernel.org,
	Coly Li <colyli@suse.de>
Subject: [PATCH v2]  mdopen: add sbin path to env PATH when call system("modprobe md_mod")
Date: Wed, 22 Jan 2025 11:53:59 +0800
Message-ID: <20250122035359.251194-1-colyli@suse.de>
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
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[]
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
v2: set buf[PATH_MAX] to 0 in stack variable announcement.
v1: the original version.


 mdopen.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mdopen.c b/mdopen.c
index 26f0c716..65bd8a1b 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -39,6 +39,17 @@ int create_named_array(char *devnm)
 
 	fd = open(new_array_file, O_WRONLY);
 	if (fd < 0 && errno == ENOENT) {
+		char buf[PATH_MAX] = {0};
+
+		/*
+		 * When called by udev worker context, path of modprobe
+		 * might not be in env PATH. Set sbin paths into PATH
+		 * env to avoid potential failure when run modprobe here.
+		 */
+		snprintf(buf, PATH_MAX - 1, "%s:%s", getenv("PATH"),
+			 "/sbin:/usr/sbin:/usr/local/sbin");
+		setenv("PATH", buf, 1);
+
 		if (system("modprobe md_mod") == 0)
 			fd = open(new_array_file, O_WRONLY);
 	}
-- 
2.48.1

