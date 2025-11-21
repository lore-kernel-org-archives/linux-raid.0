Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6B22BE047
	for <linux-raid@vger.kernel.org>; Fri, 21 Nov 2025 19:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763752467; cv=none; b=jESusdN/zBWBzp7PKmNuj4Orlre/HeWCtVSOLFh1fqyH/k0C+DsaJsy6Epf6y6Lzo96JLXqI0qtExz9smRuzPoVNu18+l0TSpIdV1W18EfqEzGBA3xQxtuOm8PXkD2lYNBO0BTW2k5XhNCZlpZHos+IXsR4wpP28jTXLDCKqfjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763752467; c=relaxed/simple;
	bh=6XHbdE7Cl2AW8C7I4nYeJXpehHAgLoxsdbsHy0jwxQY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=MYuwxXQAHRecP0lyiUPCqbwN3M5oIA2bQbf7K/dvyY/VaSnZX/u2KymKJjVtH08vKMMkOzpwqwj3/A5S5CQ5nWxUI1pygYJHW0NoHq24z4JmMYRkvmwCxAwwCFvnh96bBelCoF/BZE5SV2t0sO1cUovtAYWtEtorKqefYnL8KZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QrNPGAOJ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QrNPGAOJ"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3418ad76023so5233231a91.0
        for <linux-raid@vger.kernel.org>; Fri, 21 Nov 2025 11:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763752465; x=1764357265; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ao/6ZXxMc6Z81jJHtK2fJh36s23Ta/p72z+HIg0LrzI=;
        b=QrNPGAOJiyWF1nPZNKgtsBrHFdV9hs7Kp70DdLg9s/GZ345tcT7bWYCXHStRTTDXva
         k9CAQgdYwWl6H+SXyjShgsJ/zoA+W52ZqcBS9ogXdDxkOcQETjdRGgpzEbmzDLuiTgku
         ymYbri7koEjTdsLKAeerNXYVApwDcr/edraP7KopPt+yN0O+oPRHqRi9mcnuYN64xFni
         aRs/UbpZkucVwfJiDuDmA+tCjL6YdVN9Z27xqRm3IyqM+IAehdHKp0MH7WJf+8/J8YXZ
         GHjXa52qYRijUmO/2hGMJqU4lxgGENYmlH/as6NN6V6NC5uGXTTVaZK5c0BGfsABFIXn
         BC1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763752465; x=1764357265;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ao/6ZXxMc6Z81jJHtK2fJh36s23Ta/p72z+HIg0LrzI=;
        b=oDeI441NnzdqKlKwvQGhb4yiiLndcRKXuMBDldMKRQDSguslYIFUapVJl8v2QA/uc1
         fxRX1EqktQ2YsqUXgfL9sE668XOD3ClTYeHRiTXsZ1s0LQfCpt7nsSoIT2XmIit5lwYw
         aqbTEH1fs4h/i9wElhqYwBXU4QWpPixNpor4jw0/zsWnIbHIn8vGw9OpsKi8X0t2z8bC
         IJ6av8kdtEaqBrQW5se9R7UQgH3d+9JYJwhK1/PO7JuSLBIR0w8adw/AmiATWTOqjtqH
         WTP4hhf1nDHZZg49oexjH/K4EMu9ozWAwjxlWvgwFknEIi+6KKhSWKlEWz6wcN5sHAlb
         aWrw==
X-Gm-Message-State: AOJu0YxnTrO8/82VsZbByy/NiRe01+vN62myViarYCsuzffKBI/nz5kO
	RGINFMyPnDUpwN5STTxkoVTmH33HHirwe0TKGUsKpgAEy2P1U5O+EdzxtC3L9TtEaqezSq4I92r
	fhL5gcfuZMfPhZIBRwIwKG4vH4PsdyYA6yUcz/7Tr9RiAJ5w++l/sKEimD4UllBsBBhBlpJsgwL
	fe6zFTeBD/Gq/PyGmTxxNvB/yCSY/HPRYl3dF/JzAku7csr6vr6EEPDFyFGQ==
X-Google-Smtp-Source: AGHT+IEdpeXvhCE6/slRQyGoUn5xgRhHbN47nseVRQHPwwmRdUeRC4l2yFrEqesh0ActqFAViS37dhyCjlqvUHg=
X-Received: from pjuv1.prod.google.com ([2002:a17:90a:d581:b0:342:8ef1:9719])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3d0f:b0:340:d578:f299 with SMTP id 98e67ed59e1d1-34733e45883mr3904022a91.3.1763752465312;
 Fri, 21 Nov 2025 11:14:25 -0800 (PST)
Date: Fri, 21 Nov 2025 19:14:22 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121191422.2758555-1-tarunsahu@google.com>
Subject: [RFC PATCH v2] md: remove legacy 1s delay in md_notify_reboot
From: Tarun Sahu <tarunsahu@google.com>
To: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, song@kernel.org
Cc: berrange@redhat.com, neil@brown.name, hch@lst.de, 
	pasha.tatashin@soleen.com, mclapinski@google.com, khazhy@google.com, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"

During system shutdown, the md driver registered notifier function
(md_notify_reboot) currently imposes a hardcoded one-second delay.

This delay was introduced approximately 23 years ago and was likely
necessary for the hardware generation of that time. Proposing this
patch to make sure there are no known devices that need this delay.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
v2:
	Added linux-scsi mailing list

 drivers/md/md.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b086cbf24086..66c4d66b4b86 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9704,7 +9704,6 @@ static int md_notify_reboot(struct notifier_block *this,
 			    unsigned long code, void *x)
 {
 	struct mddev *mddev;
-	int need_delay = 0;
 
 	spin_lock(&all_mddevs_lock);
 	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
@@ -9718,21 +9717,11 @@ static int md_notify_reboot(struct notifier_block *this,
 				mddev->safemode = 2;
 			mddev_unlock(mddev);
 		}
-		need_delay = 1;
 		spin_lock(&all_mddevs_lock);
 		mddev_put_locked(mddev);
 	}
 	spin_unlock(&all_mddevs_lock);
 
-	/*
-	 * certain more exotic SCSI devices are known to be
-	 * volatile wrt too early system reboots. While the
-	 * right place to handle this issue is the given
-	 * driver, we do want to have a safe RAID driver ...
-	 */
-	if (need_delay)
-		msleep(1000);
-
 	return NOTIFY_DONE;
 }
 
-- 
2.52.0.rc2.455.g230fcf2819-goog

