Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D872128370
	for <linux-raid@vger.kernel.org>; Thu,  3 Oct 2024 18:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727978449; cv=none; b=GxuaAbIOVFBv3pmKGdQVJev7PIMFCMLes2Y9CImcMF/loKwidIdCcn9mbsbbf/oxW5vC1BTp6654WRPnS9BIgUReyQwMzwGqBR9CLqUTg+GXapLdrkTePFmdBTBLGjF+R8kZTGu8NxnEBdwlKJbV8lVT+dUf59NMHZee/PZspno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727978449; c=relaxed/simple;
	bh=KTLgEh5056WlPmNIOMq4zru8Azwbm3Yt/IQ4o+lDjIo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G4Z30/b6dm+vrJ9DtOKcLTEetOxaIcjSGzBxVQ6budkLwbjvmWnGXgAyduLvTIpdH7daYH2+LJpjcaoGWskoDzLYgQ2ik5FWX4k3TmPTkx/u3e/RrY30FgsonqucSAJu9dGQlVCr7AKxt7wFFBn7nAOfPabIFxzkuh/DqRh9BCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wm0NkbuY; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wm0NkbuY"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-20b6c311f62so11864955ad.0
        for <linux-raid@vger.kernel.org>; Thu, 03 Oct 2024 11:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727978447; x=1728583247; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3NTKJ5C9xtlIIQnXYIMzFu8nCrEj//jAyvqtv/0xMT8=;
        b=Wm0NkbuYw5okZotICk7PGRC8a/fb6vLCbbz02WiCr3RDxL0om6pY/NZEafy7Hf4yob
         q1uJ5O+tJicqMIPrkYdZFBPJmE2ljERKTSu3bfWOJzuWejpZ41nDkc76d0Vo1fkRpAeX
         uvVlYZwlDLzcOm8Pd7ay+IQUvnLGKa3jlfJ+qMxNWEFYCo3UL2Jvl8QWGSzSgcc32J04
         gMewObj/kVYXUD+pFazhqmnChIXE9Pt+zV0NqSmAJrCbDruPHYYxhiDYDXe/kKJVFC1z
         tFgsw0u5dbmwj2HyXftAHv2Q8ePGolnTz8BlGykOfO3rXkHVtRYUq6QsR1KiloIp95l/
         zOfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727978447; x=1728583247;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3NTKJ5C9xtlIIQnXYIMzFu8nCrEj//jAyvqtv/0xMT8=;
        b=IuVY8NoqswYwfFLRxwU/WATmXpSIQQedqaQCsxOlwYOlrVbJtR5zS8uMD49fY+FCi1
         y4+lxLtPo+icykiveoAbihqVczqcRyWgKq3SQplPJiVLZphm2Qu+Mwfovv9aSuiPe5ru
         BUSZGlbC+MYmaX/0oVUv52Mq7iRmwMzxioU1MrTOPXGCCVl1FjlbQ7bJ9k65oEoGMnpd
         OPcjT9flZdTVE/wsKiYL98jgs7OLc2RJRKuIBglCqOJDkFIXfIf8jJ0ujJwg0UFDPGzE
         AV4Wo9BKNRNMcZZABMXuFEuY+TYnDuvQk0zUrWRCuEaCj5L1t25hDwfeXDHgfngXv0z4
         uIQg==
X-Gm-Message-State: AOJu0YxI3QWSHruBTqGTdrSao45wF3a5l16uzN2tZdLS4xzRzLtxa+8e
	kiWH0er7a9TGushSeodqlWzJGaS/2NOqdAja4CsYtu+Z6usFLIJzQIgDhQ==
X-Google-Smtp-Source: AGHT+IHo15TQ0gA6HT8XBGExY4vVsUE+xUrWbwtbc3cqn5d8gZIOlwM4wHOJR4q7EZgam2gDGQ3eRQ==
X-Received: by 2002:a17:902:e891:b0:20b:adec:2a1e with SMTP id d9443c01a7336-20bfe49538cmr313915ad.26.1727978446691;
        Thu, 03 Oct 2024 11:00:46 -0700 (PDT)
Received: from localhost.localdomain ([2600:8800:1600:140::ec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20beefafd8asm11498625ad.215.2024.10.03.11.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 11:00:43 -0700 (PDT)
From: Paul Luse <paulluselinux@gmail.com>
To: linux-raid@vger.kernel.org
Cc: paul.e.luse@intel.com,
	Paul Luse <paulluselinux@gmail.com>
Subject: [PATCH] md: yet another CI email test - do not review
Date: Thu,  3 Oct 2024 11:00:40 -0700
Message-ID: <20241003180040.6808-1-paulluselinux@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CI email test

Signed-off-by: Paul Luse <paulluselinux@gmail.com>
---
 drivers/md/raid1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f55c8e67d059..c6d474b5d5dd 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -62,7 +62,7 @@ static int check_and_add_serial(struct md_rdev *rdev, struct r1bio *r1_bio,
 	sector_t lo = r1_bio->sector;
 	sector_t hi = lo + r1_bio->sectors;
 	struct serial_in_rdev *serial = &rdev->serial[idx];
-
+	xxx
 	spin_lock_irqsave(&serial->serial_lock, flags);
 	/* collision happened */
 	if (raid1_rb_iter_first(&serial->serial_rb, lo, hi))
-- 
2.46.0

