Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DCF155393
	for <linux-raid@vger.kernel.org>; Tue,  9 Jul 2024 09:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720518439; cv=none; b=ceGtAIJsehiAgXBbZsJwFwnAwb43frYrY9LVbMAf4W9ssXRRb1GSsp/7wkaUBoIIpXUV8l8+FzUXc+k+b6VMHvuHePwYAURbG0rPtdrHBqbmhNPwUcUNFWWcuPHs+hIkV7U7Z78C8S0KFfJZpVDRhIpByQS/DxpN59U1AR4eUC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720518439; c=relaxed/simple;
	bh=iSeZW4Gx9kfFG+aBrmglqjBSsUK77Icc8BSjbnKfHu4=;
	h=From:To:Cc:Subject:Date:Message-Id; b=ZV4212cmPMiGgiAyLAPolHCBJJ4Q/pJhEaMtcAsFxoRq836Iw5T//TW2L+/dqK46HWbrdTKG93kwW8E74KlgRtKyBnpwfdGu8o7mh5qL9QxI0AJl2/ZWvO96xT4SaimLxPvoLGdobh2mCADom+rDqH0n4/qiuAHy8PUDT44K6Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zadara.com; spf=pass smtp.mailfrom=zadarastorage.com; dkim=pass (2048-bit key) header.d=zadara.com header.i=@zadara.com header.b=fev9P7pt; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zadara.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zadarastorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zadara.com header.i=@zadara.com header.b="fev9P7pt"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-42565670e20so35601905e9.0
        for <linux-raid@vger.kernel.org>; Tue, 09 Jul 2024 02:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara.com; s=google; t=1720518436; x=1721123236; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iQteGAjUM+1Orr0k5IbIqRaZnPXEqokzFQtao2uUXZE=;
        b=fev9P7ptUzJi/Lr47BI35lymSq/v762ENpp0aQK/JSNH+7MKUDO8Hj8E0h2uDM7vpb
         rzUe4k3088IcHHNZ+A1MI8ci4vT4Q2Vgjno967TPJnB8HEKzYaa6dgrDYynyLcZnwDuh
         ahN2t1A53upWO5Y1Mpi0I8tN08COzS51rMy1+/rfW/XUIfZo8WbNq5+raL20BfgrvuYU
         Rofo3shimPaR3qfnk5ze48CsfemYFnvQ0MJRor0kP4CKD8oz3vEdPCHeF5x6QhysdKX/
         VPVXSI2ylHha5Fvd8QSwmh6ODT3w74t9r1CA8t0FxJsR8KCn48e9HNNdJIPwgB6B7Qz3
         UfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720518436; x=1721123236;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iQteGAjUM+1Orr0k5IbIqRaZnPXEqokzFQtao2uUXZE=;
        b=VEv/DnLsksIavWRv+Rws/1E9Hxzm+DADiySLsh5GyyoddleyM3KRIprFKonigLC05K
         YHXOqeyWTG8ewyRUjZFEUtMoko1PLc5iJh2J6hitOZG2PzphzhoCVsIXbZtsXKTV/awp
         p/wkcs0D0BX+1SjUW1pTOXy3LEsu2VPvEuvst4YpxwbsvYiBIP22UoYPsEXjLotH+FrP
         w55WGphu2eJDCnZiGPwrKa+UkWVsy8Pj4V5nOmcpM20sd9tI4GK4N8KaOthAVd1Wm/OA
         5ETRTkGMljbw+x4YDCcNGyyhUXB9sXYmvTe0XKtcqo/qTVxfNZNI5im9wyeopCEzXyG+
         QcOg==
X-Gm-Message-State: AOJu0YwgberLHn8ILRTfhUaDJpDQN+7VGbbWW9o1L4IrpTAySPwSoyYu
	d35+mD5tNBuHGA69vWM6v+VPQYSwhNGBu+RWw64mwXB3+yM+SI+L7g6MDxpVZu3RlVncUrRz6tw
	Z
X-Google-Smtp-Source: AGHT+IErYTtkkP8P+14FzcvzObgvw1LhhHcCgufN6sNmhmRhgZ4qbpKK+d2LI638RiZobQ9lpo00hw==
X-Received: by 2002:a05:600c:424a:b0:426:6f0e:8ba4 with SMTP id 5b1f17b1804b1-426722ccc5cmr14601665e9.8.1720518435680;
        Tue, 09 Jul 2024 02:47:15 -0700 (PDT)
Received: from localhost.localdomain ([82.166.81.77])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4265e9de055sm128290535e9.34.2024.07.09.02.47.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2024 02:47:15 -0700 (PDT)
From: Alex Lyakas <alex@zadara.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	yukuai3@huawei.com,
	Alex Lyakas <alex@zadara.com>
Subject: [RFC PATCH NOT FOR INCLUSION] Concerns about logic of raid1.c::fix_sync_read_error()
Date: Tue,  9 Jul 2024 12:46:55 +0300
Message-Id: <1720518415-20336-1-git-send-email-alex@zadara.com>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

fix_sync_read_error() is called when a SYNC read (resync, repair or check) failes to read from any devices.
This funciton retries the reads starting from "read_disk" until it suceeds, otherwise it aborts.
If it succeeds to read from a particular device, it attempts to write the same data backwards until it returns to "read_disk".
Then it retries the reads backwards, starting from the device that it succeeded to read from, till "read_disk".
On any failure of these reads/writes, assuming bad blocks feature is disabled, md_error() is called on a particular rdev,
which will kick it out the array, and set MD_RECOVERY_INTR, which will eventually abort the resync/check/repair.

The issue that I see, is that this function is oriented on the "read_disk" to not fail.
I have marked in the patch some suspicious lines.
This function reads and writes always from/into pages of the "read_disk" bio, and eventually it marks the "read_disk"
bio as "success".

Consider the following scenario:
- We have RAID1 going through "repair" with drives A, B; all were selected for reading in raid1_sync_request().
- A was marked as "read_disk".
- Reads from both drives failed, so fix_sync_read_error() is called.
- fix_sync_read_error() retries the reads starting from A, but A still fails the read, whereas B succeeds.
- Now the code writes the same data back to A, which let's assume fails.
- md_error() is called, A is marked as Faulty, MD_RECOVERY_INTR is set
- r1_bio->bios[A]->bi_end_io = NULL;
- Now the code skips reading data from A, because bi_end_io is set to NULL.
- bio->bi_status = 0; // this marks the A's bios as success, but bi_end_io is NULL on it
- fix_sync_read_error() returns success
- process_checks() is called
- process_checks() executes the loop to find "primary", but no primary can be selected, because:
  - A has bi_end_io set to NULL
  - B has bad bi_status
- As a result, "primary" will be set to out of bounds, and r1_bio->bios[primary] will access some invalid memory location.

Can you please review the scenario above, and please let me know whether I am missing something?
---
 drivers/md/raid1.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7b8a71c..2eb1d0b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2119,10 +2119,11 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 	 */
 	struct mddev *mddev = r1_bio->mddev;
 	struct r1conf *conf = mddev->private;
 	struct bio *bio = r1_bio->bios[r1_bio->read_disk];
 	struct page **pages = get_resync_pages(bio)->pages;
+	===> these pages belong to the bio on "read_disk"
 	sector_t sect = r1_bio->sector;
 	int sectors = r1_bio->sectors;
 	int idx = 0;
 	struct md_rdev *rdev;
 
@@ -2153,10 +2154,11 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 				 * active, and resync is currently active
 				 */
 				rdev = conf->mirrors[d].rdev;
 				if (sync_page_io(rdev, sect, s<<9,
 						 pages[idx],
+						 ===> we are reading into pages of "read_disk"
 						 REQ_OP_READ, false)) {
 					success = 1;
 					break;
 				}
 			}
@@ -2206,10 +2208,11 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 			if (r1_bio->bios[d]->bi_end_io != end_sync_read)
 				continue;
 			rdev = conf->mirrors[d].rdev;
 			if (r1_sync_page_io(rdev, sect, s,
 					    pages[idx],
+					    ===> we are writing pages from "read_disk"
 					    REQ_OP_WRITE) == 0) {
 				r1_bio->bios[d]->bi_end_io = NULL;
 				rdev_dec_pending(rdev, mddev);
 			}
 		}
@@ -2221,19 +2224,21 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 			if (r1_bio->bios[d]->bi_end_io != end_sync_read)
 				continue;
 			rdev = conf->mirrors[d].rdev;
 			if (r1_sync_page_io(rdev, sect, s,
 					    pages[idx],
+					    ===> we are reading into pages of "read_disk"
 					    REQ_OP_READ) != 0)
 				atomic_add(s, &rdev->corrected_errors);
 		}
 		sectors -= s;
 		sect += s;
 		idx ++;
 	}
 	set_bit(R1BIO_Uptodate, &r1_bio->state);
 	bio->bi_status = 0;
+	==> This bio belongs to "read_disk", but the appropriate rdev might have failed to "fix" the error
 	return 1;
 }
 
 static void process_checks(struct r1bio *r1_bio)
 {
-- 
1.9.1

