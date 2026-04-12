Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71E620E334
	for <linux-raid@vger.kernel.org>; Sun, 12 Apr 2026 15:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776008552; cv=none; b=WAT0tCdZNGCd1UwuFIM+uWXWnEy+RgMwN0DBfZGbCjxfD0aus6QatofJMyXc5XCRGbdLaaKsElpD5YTEbBNKLp9roktG7T5P3gu6cE5aKI0W0+ERYH/tTDd6OHVZlpYa7poA/is69qVuN2YK4pPohMe347ViB1Vk6KggfB6AGDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776008552; c=relaxed/simple;
	bh=6EZ4uudlTlmt1z3B9/SeVUJSAjeCc5mAleyjMUXVJWU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NBRO8xOiX7yOjOkipxA3XbOU4KAPL+E3QuDdrDxxdu34WdQnMQtyAMy6w1r0AYuE+UmaCcWUTtm+XiHC1nMMDIGKdiGiudIuuVJXSSWzTyjeU4eKvMGe+9xfQ4FxMIrdVsuMp5IOwEhEL+9GHH9J9OJTeJxVY4auXqLdu0zoeIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BB/oLqz4; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BB/oLqz4"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-82f37c09352so190887b3a.0
        for <linux-raid@vger.kernel.org>; Sun, 12 Apr 2026 08:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776008551; x=1776613351; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=asIGxvququexs7PTZV6rQ9JxYEOvHAcXSlP0iwqlnoo=;
        b=BB/oLqz4M5PFWj5rIgUf+6acYCwCV2QRUt73FDizWZOFEZYQo6VI/UPRIty80Prl0K
         9GREfmFdbXI3INM93367IDttTY5j0y5vmUFEAAhI4HuR4WYV8Zte6ySpH6cruYgYFxmD
         QOeDTgzKCCoV6qjbGjuVTw6FnmvxCJug8nkx1QoGM952uo//MvUQO2UEcy7C0xnBh4je
         eBU89kbHb5tW0qG+UubMutV2aEG2kbe+XEDqmMvjGdckg/3q5IUdI6iZ+y/rugt8FqY+
         zMpkrmZ5zBs4GKcw/oVYc87gYttnzRMz6TIT92d26prDYsifbM5yksm5aflJLN7m7y7h
         Espg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776008551; x=1776613351;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=asIGxvququexs7PTZV6rQ9JxYEOvHAcXSlP0iwqlnoo=;
        b=s2tFUVlEuGdL5U+FjQgjIISGQjXnen99xBfM42GHx74UmwRhDNjB2sXtOalVbYBGj6
         tSXIfpXX0npr7KMRcESz+WVImzxp9SAPdJxjFHr99HxlL0GoRFIq6FP9Kb+z6reNuETJ
         EjhHcDJRdydkJBPqhUl7F3VD5oRsnTczpWhklpfOxL5z5oWEJA5fHN5v32YUn6j6CPl/
         3tbRA4P3zMCVlWLQ2jDgubF5oUjMIfs7bAZFKuRaFVXZQu/5RB7R9djKOXDRdVrowFeU
         FkdrHK1EENjQPP2IxlYV9jbqVMcCAfxNw1AFv5rcFbBr2KOXd1BlMwQLOA7NTSY0RHpG
         7KsA==
X-Forwarded-Encrypted: i=1; AJvYcCVm7RJux5qSqVMbLi3mUqzmFsZzTEVyuMaeYnsj5UuK/JCqMefYD96HWNLk6UlTZNfjDV4lho+BV7wR@vger.kernel.org
X-Gm-Message-State: AOJu0YyZSop+x+4sl5BYwqFo067mbDTPv0kakXkErd+K3tzjEQ8G/nqa
	r/Esvmu5h3JZ/E0XuQ4hb8BKAZkp8aVHVwjh6+oHpbTTcJ/eCTS2p6Qr
X-Gm-Gg: AeBDieu5BCoX5NWPCOCAUGAD5bYmwQf7LuGo4OReZKoxzsbbABNKFH6X4DImKvOBcQ7
	ltBBcM/v5UXc+Pf+8mnprra8jM9ScEe2eN13wTRwoxPRbujdZdeFNWmOD47jw/Q5ss/mJEV52DO
	83AA+SpyneqXJAheIKkCfunEA4xzwsg7IDauDpYoKqwz8q1FyPRqaSgA30rNRgXrh8Z0TubqeSe
	IHhi84IccR1YBR8ZZk4Muqb7Rq+pApRnEsm8Xyjsa13pDDS0jIjM0aO+dRUjJIbOEIhcpxX79ud
	Sb61QUDhwCGQu5t8QvThu9Z5nGBxc9SAGP9icov+lRg5rFGF4twNGqjJ9Zqf6Z0iM43w9TfgLd6
	O1FekDSnYWvb4z1WIA2dIjwM+Lbl7ndgKjYAszxTI8sx7WBQ1YEIRcprEN3oyT6arhjGOeGKD3M
	3LCFnUAEk0bmD95mitWfgodpQ=
X-Received: by 2002:a05:6a20:728b:b0:395:acfc:b679 with SMTP id adf61e73a8af0-39fc9509e72mr14563770637.18.1776008551078;
        Sun, 12 Apr 2026 08:42:31 -0700 (PDT)
Received: from lgs.. ([2409:893d:1188:142d:f515:539:1a62:ab91])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7921534918sm8255671a12.0.2026.04.12.08.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 08:42:30 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] md: fix kobject reference leak in md_import_device()
Date: Sun, 12 Apr 2026 23:42:19 +0800
Message-ID: <20260412154219.2560732-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

md_import_device() initializes rdev->kobj with kobject_init() before
checking the device size and loading the superblock.

When one of the later checks fails, the error path still frees rdev
directly with kfree(). This bypasses the kobject release path and leaves
the kobject reference unbalanced.

After kobject_init(), release rdev through kobject_put() instead of
kfree().

Fixes: f9cb074bff8e ("Kobject: rename kobject_init_ng() to kobject_init()")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/md/md.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6d73f6e196a9..4ce7512dc834 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3871,6 +3871,9 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 
 out_blkdev_put:
 	fput(rdev->bdev_file);
+	md_rdev_clear(rdev);
+	kobject_put(&rdev->kobj);
+	return ERR_PTR(err);
 out_clear_rdev:
 	md_rdev_clear(rdev);
 out_free_rdev:
-- 
2.43.0

