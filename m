Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794484223;
	b=Zds2gQotvmyfHgzAnFwl1wuShiT5G+Z28WZxOspt2NalUrTvZCuMOdDDdxYs906W7zrF
	 xr9+Hk9wDxvUrFv/CHiDX5yMD9bkZPWD9gIuxHl+NkVeNg1ObfVHIYlcLfZ65zs8jFFMa
	 uqyjQs4RkKXfYrsm+GxbdFc11iObypuUdiL/zM67T60B4J6AtplTcZRF9BgGEhrKVcoaa
	 LQhzuUmDF38u9KBYqLFCPfa7EoT4xnNmwEHVXFt2/WAf1fDV7DKraQXXCpQaLf1j4vVfG
	 Gc6Nzb0lTT2sBatuMrtHXP5km4dYIjPm7EMYjx4ImjTLDjANBHRsHoPuhDTNMm4NUyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794484223;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=RLp801KKfsVZdQYaLNag2TdSqnCBgSM2Gu0Olt6/xr4=;
	b=xCXxKn8mw6nAcviAmWK8IEebrKgZSOQZolmT4fsIL9FnQUiggsSyVq/rQXRTylUsXET7
	 0NqDrWD6rstWqLuIM47KY9uWGyuGxc3JnqB0ngaJfnX9vRuqbohbDhxD21+rNb+kFm4CO
	 gYS0yHwB1RDTvVueB6etOr5XeByoQBCeiQcpzyF5MGnWrpmsct+71v5kXZxJycPQeSnA4
	 u8rNgGPTSh6bSf29ssZTsaxCKLIMAY7PO6o82dLlE/mbrGG1jsjrkqmIGgWIIZvW043yN
	 cLO6Sy2ifFPEg/+hQA8+rEOfwPO+xyrtNN8C/7nL3B+bV4yzl13RBylqn4eTZQFZgvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NQdHOowS;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBFA606A884
	for <linux-raid@vger.kernel.org>; Thu, 12 Nov 2026 11:50:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BBBFA606A884
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NQdHOowS
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a5720b0a57so4835805e9.0
        for <linux-raid@vger.kernel.org>; Thu, 12 Nov 2026 03:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794484221; x=1795089021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RLp801KKfsVZdQYaLNag2TdSqnCBgSM2Gu0Olt6/xr4=;
        b=NQdHOowSUtwMiLAq1OZHrxWGu8Gk2SiZZWfidzx0/bi1IORyg8THEANFrlUktiIT7+
         SXGi42w44hN4Rq1U0JfxnMvVX/nhS9YjUmFAsAP4cI9AEn5yjlesmvYLWHPm357I72BO
         hlrEDw6/LOOkC6x0pqWQyeuBI5uC03T1SYkIu54p5xZADvxIZJ8zw3CuH65u5EEEm2dz
         0obWumfn9xsErrswweH7qAxz2dvpDMP3ZoGTHAtXVR+csoOt+3sj7Ke2eQpBPYu7oEy2
         9sB6QYT+Vnw9lkwAGHW2+Bnxbk0i0KzP2G+LoYGo00/UDpDzoWuqZU77Jyx5SlPMWH1f
         Erow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794484221; x=1795089021;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RLp801KKfsVZdQYaLNag2TdSqnCBgSM2Gu0Olt6/xr4=;
        b=EaciSSUtsw6SnoQd2RV8FD2bCL886vVstPwEVp5p1QEYIxUVHjjYNtZj7hdxvdhWoq
         TacdZbFEdp8jzd3OjAttnN6PkrkyTpRYH4t3MESMWMW0LMJzMOiXKrIGq/eNTiiSWAlJ
         km/DFPDm9HEewXmBwpvy66MYlvbw8Ff6cOetkD5MulYAsAbGZEipQd47Vl5d6NFyC+8I
         xVC3Y+ciHkcpzshVqkamK6MtovTMSN9HV1kCibBUXmC6yAHbL8y1U8+mBfKmL4jbTnuy
         uNinENRjZedONw8xnnJJtb7TymqKuIx1U9W2xNPxpjUaCxZ8+uN9bCi4jvh7LBKa4aB9
         K9BQ==
X-Gm-Message-State: APuU4Z/L5lOeyeJdkirUglik2fCoDsRuQbt6zi/5RqAtoeXxyAwnlqRW
	y7apGNhp/Obas+YgAL0GToRElIyz6LVQsm1XZZtHQXk4BeEZNHrKLoJm
X-Gm-Gg: AYBFou1fs+8PDQZG6KHgwDVMPRGJZ3C4wGoZ8QB1tyPO6rNawKiP/z/2GiJgnqFdXCZ
	cMi1NI1spskbPmodttQeU8untsQgS4UuZWqtx9zzJJiClD++OLN5QnVhsMV1HrxHfgrLk5QAiLD
	MHFBsl8o53fGQ9m8C+HM0NHSF4SXfgl8E53cJLLzcPT4I+pl7sN33wDLwsMHdRkYfURtcXH9xRB
	CkoZMJzZBEQSQHo1ZnbklhnkhE5vkVe9+AKgN3/gCKPEu8UMW9dhvf+WiAFGiQzm/DoMuz3TF3i
	ishpRDOSaPIeWJNLyOvVzpM0oLjDHuj+sLRPQi2lkM3Y76PjwJVLz6wdbg4Qh0A7p0owOMe+gfP
	7JLWzSXn0mWNWFAJi/BXPa1ez4GbrQbmt8E3eLW2lYZ9f34dUsukLHinaL7GwG0+AQ/aFL48UNj
	yURY7bCr37CDd67ivII+T/ZBicrIXmoZCrbcryW8L4/QKQ2SogNtmSzDmPhGlqOKln5lqohfrwR
	w24fn01if8IvNGfQoPoq8DB2yGbX8LOeYQLNvsnc25a9qITZdviBeNiO9tOD4BhQTbOv6mVCxi/
	TMrEwOSt8RZI456dHqAI/P9V
X-Received: by 2002:a05:600c:63c1:b0:4ba:1fd:cd84 with SMTP id 5b1f17b1804b1-4bb4e2e9c30mr37576545e9.12.1794484221022;
        Thu, 12 Nov 2026 03:50:21 -0800 (PST)
Received: from env.. ([195.72.110.73])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4989a2a505asm14476287f8f.13.2026.11.12.03.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 03:50:20 -0800 (PST)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	sashiko-bot <sashiko-bot@kernel.org>
Subject: [PATCH] md: make mddev_get() fail until md_alloc() has finished
Date: Thu, 12 Nov 2026 11:49:58 +0000
Message-ID: <20261112114958.2244-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

md_alloc() makes the disk visible with add_disk() before it adds
mddev->kobj. In between, md_open() can take a reference with
mddev_get() and send ioctls to an mddev whose kobject is not set up
yet, for example ADD_NEW_DISK, which adds the rdev kobject under
mddev->kobj.

If kobject_add() then fails, md_alloc() drops its own reference and
expects mddev_put() to delete the mddev. A reference taken in the
window keeps it alive instead, and if a command such as SET_ARRAY_INFO
sets ->ctime, the final __mddev_put() keeps the mddev for good.

Add mddev->sysfs_live, set under all_mddevs_lock after kobject_add()
succeeds and the sysfs handles are cached. Make mddev_get() fail
while it is not set. mddev_get() already runs under all_mddevs_lock,
so whoever gets a reference sees a fully set up mddev.

Also, send the KOBJ_ADD uevent only after mddev->sysfs_live is set,
so that user space reacting to it finds a usable mddev.

An open that races with md_alloc() now fails with -ENODEV, and a
sysfs read in md/ before the flag is set fails with -EBUSY.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20261029202209.1422567-1-abd.masalkhi@gmail.com?part=4
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/md.c | 10 ++++++++--
 drivers/md/md.h |  4 ++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 154ee5a65cb7..20acd1e25e9e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -627,7 +627,7 @@ static inline struct mddev *mddev_get(struct mddev *mddev)
 {
 	lockdep_assert_held(&all_mddevs_lock);
 
-	if (test_bit(MD_DELETED, &mddev->flags))
+	if (test_bit(MD_DELETED, &mddev->flags) || !mddev->sysfs_live)
 		return NULL;
 	atomic_inc(&mddev->active);
 	return mddev;
@@ -6403,10 +6403,16 @@ struct mddev *md_alloc(dev_t dev, char *name)
 		return ERR_PTR(error);
 	}
 
-	kobject_uevent(&mddev->kobj, KOBJ_ADD);
 	mddev->sysfs_state = sysfs_get_dirent_safe(mddev->kobj.sd, "array_state");
 	mddev->sysfs_level = sysfs_get_dirent_safe(mddev->kobj.sd, "level");
+
+	spin_lock(&all_mddevs_lock);
+	mddev->sysfs_live = true;
+	spin_unlock(&all_mddevs_lock);
+
+	kobject_uevent(&mddev->kobj, KOBJ_ADD);
 	mutex_unlock(&disks_mutex);
+
 	return mddev;
 
 out_put_disk:
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 6440da292105..5e026307ca64 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -417,6 +417,10 @@ struct mddev {
 	struct mutex			suspend_mutex;
 	struct percpu_ref		active_io;
 	int				ro;
+	bool				sysfs_live; /* set under all_mddevs_lock
+						     * after kobject_add()
+						     * succeeds, never cleared
+						     */
 	int				sysfs_active; /* set when sysfs deletes
 						       * are happening, so run/
 						       * takeover/stop are not safe
-- 
2.43.0

