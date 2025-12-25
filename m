Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8881B23BCF7
	for <linux-raid@vger.kernel.org>; Thu, 25 Dec 2025 13:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766667829; cv=none; b=Nv2dWzkpzFWAArjetVuICAOeJQu6llOJZD/cYVqu14JDIKpKdEuT3QTTBIbIhvkKvrNz8nv52TIlEkWjrpzNzEPBRiRwuxSTaY/UvhKrBPuu6lqrFABTv3CY8o0gEdx5HD3MOl7A+zZ64kRL4HoYVdzn8GSOFpVTR2WE025SmHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766667829; c=relaxed/simple;
	bh=+czeTOun7iQEDGEpJW4qqmZFAamwYDxIkiTe97QYJTo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cxiZ8gWa+BeD4lRct9o9LWe2adgyoX81klPYyaD43Lmo101ie7+bJ+PZNq7fvuaeseqq/q+MtqrQth18RahScjm63tyUeVmllQYNcb/cj59CXZE7IOe014ZNrzN3kR0IiBmhs4Fx+aGMHHcZS9OR2rAkEyOVmoyWpvh89b2Cm8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HHx0NeKw; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HHx0NeKw"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a0d06ffa2aso80941265ad.3
        for <linux-raid@vger.kernel.org>; Thu, 25 Dec 2025 05:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766667828; x=1767272628; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dE1QmB/7vK5etUZWCavLMADLFIR3KXAGPm1iedawkO4=;
        b=HHx0NeKw6bbPRJdyX8gKkHDzl0jmi8T0MQUzswjqSJ8IUl07f/YRgYoJDwAyF/qNyG
         lq2XBWfdMiYmY9eTZpT1b09aQW72eiA/LtLg8OmTgrsFx72wLKg+lGNPeSr+LPkDxGbE
         R7XsvIGE+/dY9H8LyXXymONjOARYw/nEXHlomj9rH1OpXoGsC3Z3z5F3vrjeuR+bbtBe
         o7H5fo/D+YjJSIfEf3Mnhnjucalac7C6F4CAsM3alb2QI7EM3cT0vaMjWXBTMfyFYd17
         LHEZ2UC/sftXJvE1boqCqXxsh4HSO9XJT3z3lx50iIt/WkhQaVJeZH3KFqBJd1K3nmFK
         Mysg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766667828; x=1767272628;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dE1QmB/7vK5etUZWCavLMADLFIR3KXAGPm1iedawkO4=;
        b=vAvfffWRw4n/ibKwEaIueGuqej9eUwXUyK5X+edGRqFXsSswu3YNtlRGiev9Nt6Xru
         okyRtNsKzjHxUWpjr+Z8F0hMCJdV/GBsV9c/ZmzzGPpipS80UGJYA+oTwpNpTNf/tRnB
         ph2q2wUwZ8Rc87fyeGXoamjtxf248nhz/d6bA+U/SB7si2lG5WeJBPB76eY2KNqKcaDE
         OyynT1JP01xWzJZ7c0xydKLmC3uZYXrSm+JqEURmDjbzelV/eUhTHw4N4SR593pl6SlF
         hSuBipnzcWKfMNhAUGvb2URrBLAr72N2oOXUUjY4/VkQXO0WAX7+mJ7HbPmOdgeQCieo
         z7aA==
X-Gm-Message-State: AOJu0YwNq9ukBhSS2C8sYI8NGohzD1Dfwspw4PNUd74FYbZFOn3LIZyX
	MVb1Tkq0hSFQm7EXlS/oulDoOo+tTKOWG1B71qRZEokd3BuAdYjUA+fELwHqB9aqdhg=
X-Gm-Gg: AY/fxX7KwSCaV/YAuSNRl1UbnhKvJR6cHKM924YqfxLY4T626eymtSdtNnNOBrnaFoA
	RRLvV0oQK9RX8CUrL2gKPM6uoQFYFVjXFU0S4ICQHyFyHUow2L0G/c5+QtgRiKUuW7dRG/NyphL
	n9GpZPH4oiL3nBNoSEygOglTDNBPWMYRKpf4ZhzstOD0E60mIro7wW18J7/HFB5rvpCj4DjP7ke
	+xUk7K5QZCBKk9fsRZf/XSbw0mNHOsIUVURTH29oyWtdV6kj44OjgUDEvcNmt8ymlpw0yOb/Cu+
	eSSr56PBqVR55ljjonImVV2bXYhZe7jrCXaSE3jmRrZGIRomkl5ckMZcoRPWu6lI7Ikv0wsGiCD
	nzxDC0z6gCf/bajfhOjn879V6aCsUyNvc5RyCxsawz10clTsVCjzudBrNYIjQaTUBcGcEZkM=
X-Google-Smtp-Source: AGHT+IEM8e7gCvZ2eJ9plaJ+SRNbIBkS1Z/NxtAnb4n/cd42BdmjA/o0GCtzg3gIcJl0/mjg4HnPMg==
X-Received: by 2002:a17:902:db11:b0:2a1:deb:c46c with SMTP id d9443c01a7336-2a2f29361e9mr181431815ad.44.1766667827705;
        Thu, 25 Dec 2025 05:03:47 -0800 (PST)
Received: from oslab.. ([2402:f000:4:1006:809:0:a77:18ea])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e48cd07sm19422906b3a.46.2025.12.25.05.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Dec 2025 05:03:47 -0800 (PST)
From: Tuo Li <islituo@gmail.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tuo Li <islituo@gmail.com>
Subject: [PATCH v2] md/raid5: fix possible null-pointer dereferences in raid5_store_group_thread_cnt()
Date: Thu, 25 Dec 2025 21:03:26 +0800
Message-ID: <20251225130326.67780-1-islituo@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The variable mddev->private is first assigned to conf and then checked:

   conf = mddev->private;
    if (!conf) ...

If conf is NULL, then mddev->private is also NULL. In this case,
null-pointer dereferences can occur when calling raid5_quiesce():

  raid5_quiesce(mddev, true);
  raid5_quiesce(mddev, false);

since mddev->private is assigned to conf again in raid5_quiesce(), and conf
is dereferenced in several places, for example:

  conf->quiesce = 0;
  wake_up(&conf->wait_for_quiescent);

To fix this issue, the function should unlock mddev and return before
invoking raid5_quiesce() when conf is NULL, following the existing pattern
in raid5_change_consistency_policy().

Fixes: fa1944bbe622 ("md/raid5: Wait sync io to finish before changing group cnt")
Signed-off-by: Tuo Li <islituo@gmail.com>
---
v2:
* Move the NULL check and early return ahead of the first call to
  raid5_quiesce().
  Thanks to Yu Kuai for helpful advice.
---
 drivers/md/raid5.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e57ce3295292..8dc98f545969 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7187,12 +7187,14 @@ raid5_store_group_thread_cnt(struct mddev *mddev, const char *page, size_t len)
 	err = mddev_suspend_and_lock(mddev);
 	if (err)
 		return err;
+	conf = mddev->private;
+	if (!conf) {
+		mddev_unlock_and_resume(mddev);
+		return -ENODEV;
+	}
 	raid5_quiesce(mddev, true);
 
-	conf = mddev->private;
-	if (!conf)
-		err = -ENODEV;
-	else if (new != conf->worker_cnt_per_group) {
+	if (new != conf->worker_cnt_per_group) {
 		old_groups = conf->worker_groups;
 		if (old_groups)
 			flush_workqueue(raid5_wq);
-- 
2.43.0

