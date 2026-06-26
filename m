Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5307E363C61
	for <linux-raid@vger.kernel.org>; Fri, 26 Jun 2026 08:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782463427; cv=none; b=H4KG9BAVDLX6Bz20xp/7Bh99uJkmHIx7vpGelhPXU0N8kC6IIYHypI576I6B3L2VNq6QXDg3hZeZ8EkfsRCa+N7K5SLsytnx+Y4S5/8bmA5bWNPBe9PVKBMu4PHB9zwRXi1VhWFeM2qgrNfTacSMkglLzsPg1fIgRKhjNhsYLo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782463427; c=relaxed/simple;
	bh=gi6cjj4yVrM928zwD15uDmvPXd6Clwc+js6B3393dJE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tUFXEf8vetHlAMnjqkwu4Wg+mtjwuB0g8WtmdUzfhZh5Eba2tBuZ6nLwO3P/FEV9DR+YO0ksNjvVYN8bfD2OPwmC0enRLCzHAtiBJ5GiYAF0jqZZNdDwy+Y9PGjFzM+rrjzCqm9mObxlDV1JRDxnyT0LJtN1l8X+SyWMKY+w8so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H1nW048o; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H1nW048o"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-490bc6a7958so13243685e9.1
        for <linux-raid@vger.kernel.org>; Fri, 26 Jun 2026 01:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782463425; x=1783068225; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RzRs5rqLLtXVGsPkhyCwyE08g4chaY0AjMl0jB56qQo=;
        b=H1nW048oTChxfiAu/iy1Xc0skWP75+a5K0NuycSqJ7BsXHX1kkbi1YPw0TnHUlN8OM
         1bwRnG7+rl395MsMc+okYKV+JxqayqrKIgptFS+WeFQvDRAz7E90GPLmL6FePxyeSj8L
         4y/F6CiUmwZx1ckkwTi+OBSwmzp+tnE9QXS/26cV5yWs3L8lIPy7BBdF32kRk65eOLAr
         I4ZW3uO8D19qP2NEmdNeLL0gIsf4HqydDbR003WIM+kLwMwtuGtccr5XhOLBdajWgnNL
         CZiG934ivNicAbe5OSTQ2VDiISH00exjK/I+Z9jQnfI2FdylfbZV12hnAuQKwxXR7Qr3
         AjKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782463425; x=1783068225;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RzRs5rqLLtXVGsPkhyCwyE08g4chaY0AjMl0jB56qQo=;
        b=VGntRYcVLTQcWLDHzjuJOIpqH9Pn3fXjmNsBvp/puWXPmIeJfXKGNeVudfA/b5aOgC
         79z8Yd5oRESthPi/JR2mWteikrfbGxldLPsAFqR6v/aAl+oTQBRudBN1WmdOHEYVrCnC
         ANMX3HgErIfJOsRqoGBEl9jyDojUwtU0zsdrAKkFq/hfCslxHA16rBusD7dfXAR0cezG
         SsfyCmNlX7NRmBJhe6rKGRg0nGEKA0x4mMz849sp10SO/lL0Y/PlCgNSXn9toxTdmIYn
         +tkko2ZhlQhKBr9Agg+Q5dLm20KAq8BpFX4zaoUBaXnTrGwLx88KZOjIEZ1EKHRPV+vN
         shZw==
X-Forwarded-Encrypted: i=1; AFNElJ+P6dKikqw+5A4gBaZRCJ+X15mnYqEa4jiavgb5KdN9DWL9a69MU+14ucp/p0AuDHPvyxx6x7OMoA/b@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1hO3dhqPbwxkIWOoleEhwypH7vR6HjsUXci6smanQUfCIu8ZX
	qv2A1oOLI+ZUZwqOGTIjRtpkqGpIeKV2PxA4lhRRKcdbbeunMdd+5RtU
X-Gm-Gg: AfdE7cn3nXbfwzw7Jzur9P0ZhNwd3RGbMaQDW3Azuradc40PI1U49uT4oh6UXar2plB
	B28Vkwuf6EHqjsIFdeB1BJMofpEgKWdEHXaTMJmRL4qnNELzTEtelFtnMHeY2zFrcPUVjD/7gLD
	RUhzdpJnFk0l6YuD0w1DYfjcNof2FCkVKAyybqMfxYWzgdfNgTURqgeggJmmZGBN0/6kkxtvVgD
	GA0UZq3zU28dSqWXRHDXp9bk8AVmX394nbJUX5QIuVfMI6kyhBcoYyjF0AJPGl+bHVt0tU5eMNe
	bsiQSop4PGJGJYEIOXHveLBuFp7olYyzdfIH59ytftu/bCIaDSC5AQ+eXLKO7WbhemlBxcJVZOT
	ZFEEdwODZl7qTxLMoxZRaRapYwTzSxbUkBmpcH0bSmy4QBkLHKcDMT8zA4VEVsP7g3jNBEh9uDe
	23j3fH8crbZ90d4D+RQ8PKraWiRXvZL5omQREJRGb5A6wNghlKXn9Ws2W+AR36F47qvkmUfA==
X-Received: by 2002:a05:600c:540f:b0:492:6f5c:fd8c with SMTP id 5b1f17b1804b1-4926f5d0214mr1724275e9.15.1782463424661;
        Fri, 26 Jun 2026 01:43:44 -0700 (PDT)
Received: from snowdrop.snailnet.com (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4926c278ab2sm23257135e9.1.2026.06.26.01.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 01:43:44 -0700 (PDT)
From: David Laight <david.laight.linux@gmail.com>
To: Kees Cook <kees@kernel.org>,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org
Cc: Arnd Bergmann <arnd@kernel.org>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH v2 next] drivers/md/md: Use bounded strings ops when setting disk->disk_name
Date: Fri, 26 Jun 2026 09:43:34 +0100
Message-Id: <20260626084334.3012-1-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace strcpy() with strscpy() and sprintf() with snprintf() for safety.

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---

v2: Make sizeof look like a function call for consistency.

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
+		snprintf(disk->disk_name, sizeof(disk->disk_name), "md_d%d", unit);
 	else
-		sprintf(disk->disk_name, "md%d", unit);
+		snprintf(disk->disk_name, sizeof (disk->disk_name), "md%d", unit);
 	disk->fops = &md_fops;
 	disk->private_data = mddev;
 
-- 
2.39.5

