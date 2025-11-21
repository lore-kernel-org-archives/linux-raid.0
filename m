Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDEE2FF65E
	for <linux-raid@vger.kernel.org>; Fri, 21 Nov 2025 18:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763751372; cv=none; b=nOGP8y3N3LXCdujMdvb9leWC7rB19mUjOH1Oq9JAUz2L8Bdgm5x6dIs9VkclB2mjZSEup6jKJs4oXTYEkVZfTscKJ3obgFYqXtwlFAhaLOvpeV9yiaKSU/hkZOgKzLKhKZnvAE0AiryWoLy4lxwjJiqurJIQHd+58ErHJFUvCQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763751372; c=relaxed/simple;
	bh=zfwQIbnvaasPrRfd85X17NT+3Fvn87FRsSICcM1T/iE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Wj62WUv5sR5UdFCmPjBpZ6+qhji2U4mKX2AVRAYXpxIkXLJSuQsVY6lgklxdujWIySh43VipcUzpoKwjD/W5WwyPi5MbxLn5BMzy+tRbU9ef2mVUssq2iHQP+nnm4Vti6FoMG8rID8JSrk1EA73H+/ik7xDehqeZPqUu4vWLN8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=udOjsKGc; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="udOjsKGc"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-297d50cd8c4so76919405ad.0
        for <linux-raid@vger.kernel.org>; Fri, 21 Nov 2025 10:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763751371; x=1764356171; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cOXpZFP7JafzEo1QXA8hpFIXo5iDGQ1MfkFWj7h3OIA=;
        b=udOjsKGcQy7MDMy4udyHENXAppmrYuzhmtwQoyrIoFPAX7NPZBPhPJxBYuCVURvu39
         eqBP/y7sHTZuf/W2kvur1Q/NYexHCW9nduUSpvqZQbrJIO6b0pUODKTe4zCncV1mQEjk
         Kb9k8LPJJEIumKgKxvV/mPHfzTvw7PjVdfxFJ0Rtt55S+guNEXCaTjVDNuZzS/62ptpj
         upio6CCbjfV2bjA6suvw1b19WBLDhecbWGlYRCHRYDrBkXDq4K14MjzBMhA9AWf1QPq3
         0VlPVttHxvk5OvRa/CyvHbHc3Tc5+qI9W9MSoMDO1wwhbdkQ2S0l39wTYkbswYaAvjG8
         RP5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763751371; x=1764356171;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cOXpZFP7JafzEo1QXA8hpFIXo5iDGQ1MfkFWj7h3OIA=;
        b=GCcV95DojCmVWah+px5qnaMOP+m7t4sTb4HPNgOzPXF73m3tnIV5JCWYVaeefGF+GO
         JDJvLK/la4ET0hAT664aGTIlKn8wYhiD7s1MYsu2n2e/hCjXvG284B6ei3uLuH66XGKP
         S03AjNsBENGmSbgKwjQBJppekZ4H2P4qs2Iprl5+AkSBXApNcFoKe0DFmeoTVSZb2uj6
         CLpUBKokgYrRVjmmU5Xaah2W0Ywu5HOXgu9HtHoaxuMnGiKbFBPCLYTghryU+pSyFa6O
         mJk5+urD5oKMS/hiBDss/VlUSiux5T9gHAXmno845tW4wgpyrk1lhF1UdSESrGzHGjWA
         qyBQ==
X-Gm-Message-State: AOJu0YwERnurCJ0N25b6dxVNLXFdDauWQrinjKoHYI3TU4Yr2qPfriID
	UaGts7Js+A3LYLGwWvYvF9fwGJFzU/24PORW2O00tn06KbDZiJnhtKfIgTQ9X3Hx6sGjNAdDDUk
	blJQiUY28i0dzyxbpsYQMorZNkZBidiqj5LYo259OrtxQYBivNFUGWDfVkxlnuEjbqp/4f64d33
	ysKzi0sulRQP4Sb3C4i/VGyWSStEYplqTwA9f42+kkdS9zsMluLpO4ULdWng==
X-Google-Smtp-Source: AGHT+IFNQKh7e35NIAzPzlAePh87dCromKwc8fP7tim5DMwZjkxch5TUPALvrMYIGnMQwbOuqlMzdPAb9ATtfsk=
X-Received: from pldd21.prod.google.com ([2002:a17:902:c195:b0:290:28e2:ce54])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:13c6:b0:27d:6f49:febc with SMTP id d9443c01a7336-29b6be78408mr44998655ad.1.1763751370793;
 Fri, 21 Nov 2025 10:56:10 -0800 (PST)
Date: Fri, 21 Nov 2025 18:49:34 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121184934.2751440-1-tarunsahu@google.com>
Subject: [RFC PATCH] md: remove legacy 1s delay in md_notify_reboot
From: Tarun Sahu <tarunsahu@google.com>
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, song@kernel.org
Cc: berrange@redhat.com, neil@brown.name, hch@lst.de, 
	pasha.tatashin@soleen.com, khazhy@chromium.org, mclapinski@google.com, 
	khazhy@google.com, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"

During system shutdown, the md driver registered notifier function
(md_notify_reboot) currently imposes a hardcoded one-second delay.

This delay was introduced approximately 23 years ago and was likely
necessary for the hardware generation of that time. Proposing this
patch to make sure there are no known devices that need this delay.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
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

