Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534FD3B83FC
	for <linux-raid@vger.kernel.org>; Mon,  8 Jun 2026 09:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780912551; cv=none; b=ud3dHkyvjDFsui0zNUfi07TfxkD86dW+NASTREjStZA1KwZNCW4k1tC0YzRfImKCySCg46ZpvTZPaXn5xadW9lk13Kl8YxoMcl2w5APxU6jLcukJ+SPwikUs+WuxlOEC1k592Oi8r5d2ZOQ7Z+TDzV4EX9mYYrH2xn/vpSv5Zwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780912551; c=relaxed/simple;
	bh=PgGqQfOnvs46FVfNjcIxC0EmsUixMJe8Z5BxVUrZc9g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gKdxcQFb8vtvswd3af4PvcenY5pEZ5Q7oS/xRBBM9wsMewcC522Bm1ta9sUW99PlKzk3iBUOJELPISf7+/llLw5KU/cCOw4H1df6muFRzsvF/Vmdz5zZPmVLddzJA/XrSIfaojWttVlOXzIUGpH9i3FGS9N7n7pvMZI5W/ioH7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=XWHRMoVT; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="XWHRMoVT"
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wWWho-00BRwm-9A; Mon, 08 Jun 2026 11:55:40 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
	Subject:Cc:To:From; bh=ns7GQYXa/xXbn02IqMUE5zju+Fs+k86iB6j0ZJqhncM=; b=XWHRMo
	VTaNjNomq8djVhdHQ0J/vA7wSl5WX4mqBD1/+amkX/J3WQRdqUBrmZjPWu4+DNjGVD+klG5epVyyF
	39/YGs8RFk6Ll8hs60rmYyY+2bmkIsJ1DxcsCa2wBFmW6V+Zyyi9D34x/mFdwnkzMyU/hKdLD2FAn
	zr6MujZjNcki0fHOz2HtW8tyvWPtaNzj2VdQa4AZNaeGh5s83tB+5iBF/iN/rUGF14r+WkQfmbH8r
	M/QZ6tc1HEzkQyzGxdCHTFIKvEz8LpUa/L+V/9CAnB1lJbMZpIyQlE0/lOxTUNmiriaZ3DWg1RVvd
	6xcf2nDWpEiIyufTW/nFDqHhu28w==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wWWhn-0003c1-6n; Mon, 08 Jun 2026 11:55:39 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1wWWhk-00Ag6G-2i;
	Mon, 08 Jun 2026 11:55:36 +0200
From: david.laight.linux@gmail.com
To: Kees Cook <kees@kernel.org>,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org
Cc: Arnd Bergmann <arnd@kernel.org>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH next] drivers/md/md: Use bounded strings ops when setting disk->disk_name
Date: Mon,  8 Jun 2026 10:55:10 +0100
Message-Id: <20260608095523.2606-26-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Laight <david.laight.linux@gmail.com>

Replace strcpy() with strscpy() and sprintf() with snprintf() for safety.

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
This is one of a group of patches that remove potentially unbounded
strcpy() calls.

They are mostly replaced by strscpy() or, when strlen() has just been
called, with memcpy() (usually including the '\0').

Calls with copy string literals into arrays are left unchanged.
They are safe and easily detected as such.

The changes were made by getting the compiler to detect the calls and
then fixing the code by hand.

Note that all the changes are only compile tested.

Some Makefiles were changed to allow files to contain strcpy().
As well as 'difficult to fix' files, this included 'show' functions
as they really need to use sysfs_emit() or seq_printf().

All the patches are being sent individually to avoid very long cc lists.
Apologies for the terse commit messages and likely unexpected tags.
(There are about 100 patches in total.)

 drivers/md/md.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8b568eee8743..4b659d10fa4d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6346,11 +6346,11 @@ struct mddev *md_alloc(dev_t dev, char *name)
 	disk->first_minor = unit << shift;
 	disk->minors = 1 << shift;
 	if (name)
-		strcpy(disk->disk_name, name);
+		strscpy(disk->disk_name, name);
 	else if (partitioned)
-		sprintf(disk->disk_name, "md_d%d", unit);
+		snprintf(disk->disk_name, sizeof (disk->disk_name), "md_d%d", unit);
 	else
-		sprintf(disk->disk_name, "md%d", unit);
+		snprintf(disk->disk_name, sizeof (disk->disk_name), "md%d", unit);
 	disk->fops = &md_fops;
 	disk->private_data = mddev;
 
-- 
2.39.5

