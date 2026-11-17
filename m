Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794907294;
	b=MhQi77jnJzQWyxhdgHUnDLOmBtDhBAHdARADOseftnusVk4IoOBQN78sKypOdWb1/C1U
	 8x2iEOhED9V65isN2ewZ/lq9kM8LUKvERQ+kiyR/Miy7laDXHTsdm8oD8vdeXZ5GPPY+4
	 OTE4IIxvwHGFelSWW478viT1dvTxaOTFAunQq4WTxKHuMFXGzr1shJGNvhR/XOfNTs7I6
	 mo8CGmkVGApyCGaztHxlqT1DwhprUBqpap2IFPcuL+XdazcMRl7eaDuGNVho5q7/N+XLq
	 /wuJcSrFJKXwWKkC4wIxbZRiEHj7XvfkIvBOFPpszpq5/UNzGbYM1agJ6iFbBVVpqyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794907294;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V5C32j7KQtTkw2KKwIqJ7ZKWPh3APBzMNv1Aof2IOsg=;
	b=DZbDAmFf/deGU/jdGnyLuv/FwOcWjrqf/3omSdU/ZywJvu410Snjd3JhLw1KmGi0w63t
	 SoUVqcrd7URYxiI3h6WZGNF0v/SNZR6NwpwTJ7KviFeM80lFC3Nlv/035uLdvw56mGy/C
	 Cg+xDnuRR5ZS8dh3qPxBawDZ8bF4SMAngdDyn+eY2fmIYKipw8mKa0Q81MJh8OaGJ6fAk
	 FISiv2mfI0Tcv3XrggOrrVolPn61sXI3zkztN1O9gFyRb/ZHMS2Xp8BwHuXOqQ3lYxKXi
	 UhSbkmG/2pYzXDnHOhGoqjdD0HYPyZ6N2B+SD+XY+RnsHCZWQ2Ns/J0bFgTVYCbgvzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vKpSprbp;
	arc=none smtp.remote-ip=209.85.210.179
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0355D606A336
	for <linux-raid@vger.kernel.org>; Tue, 17 Nov 2026 09:21:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0355D606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vKpSprbp
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8b5c3288e6cso1984800b3a.3
        for <linux-raid@vger.kernel.org>; Tue, 17 Nov 2026 01:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794907293; x=1795512093; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V5C32j7KQtTkw2KKwIqJ7ZKWPh3APBzMNv1Aof2IOsg=;
        b=vKpSprbpMiiYi8HmgBFAbSBdNJ+AKqjeniNUkcJfH1FyyPtXU36hapcigKFt4FSxsJ
         a5xJvHlVBPf7HLm78iCJYfTrYmg8sPB3uZNMmJylFU/0DjU7t4QMFYfFgq0XEu03J/lm
         lGR9iTukqLor8F70voAbVdYI2g60oa06Nl81CVdl0+lJ7HVpbaeoPkOQWYJzU5sJqeUH
         SFWrG7bzBn4LUBj5tgXTSuMOCuqvykGyjLwsEqRgO5DqlNqTqFKR/yK1sP4k9AArzGSh
         BN9smaww8aZdSW4tVNn9e/Ist7olhPoQMep3kuYDYO5YRv0q45HemtlkDU3jEr42faw9
         0eBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794907293; x=1795512093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=V5C32j7KQtTkw2KKwIqJ7ZKWPh3APBzMNv1Aof2IOsg=;
        b=mqMxx+cOcl7NLgLwHLv+W7SbAyEvIU+X9pvGvcZvjXTF2OZ7/iN3I+sPEEYLD7E2hU
         k9kXyeHACbpPjAJpp4rnOZhgeQGdxJXNthJHz6i+euIbHkVWSX2xJ8SvLf74Urmmh8Wk
         8srxwLciE3bLpuStf7oQj/OmRrEnolmwZfZfXbTFVel2k6IVlnu93QO0Na7HCUvPyKy0
         xR9EXrcHuxU6pTxXGgxF8ZvXyExI6HwM1MZAbrQUjbymf8R459d0x0oGu4dLo/6744Gm
         V2KuH6o4lj+fQyjmP+CcDnAaxTm2/Fwkex9s7+RKKP97PlFanYkkfpoM4ENUFFmwRKvw
         5vYA==
X-Forwarded-Encrypted: i=1; AL+hErHPd9NYJ3A4gFBbBuhjBWXMhY/wqbxIMajZ9ZqdSWN3YJmZxF6usAABcqjjFrIXkIy0WLmXS1vF2m+E@vger.kernel.org
X-Gm-Message-State: APuU4Z8IXH4oUEqrCsIG84SkuSGOo0p7209WrxayhfffrppK8cX/9wwg
	GbKqoeyRryWy4cuD2bMe2auIWzV3UXUQ1FtF3VSWbg77k1r9VlWk5Trx
X-Gm-Gg: AYBFou0o8R9qHNIUpdNiaIc35jUGnsvc7UKr6qHa1y67frjaNvQPzS8IS/5K374xNq8
	DaJ54m9gNbrhZDgVsylmZ/q8L0ANrQxTJ5etDNA7rjq2LdAfr3InauJSIQUlujhW8Ho7fiOA1vq
	u6NWCygz56itbufhWFuwnyWhvVTayU12VWGXqJh1DQbCF2WNetcMCgN3we2CCFE6AtqHgYVNWMZ
	6OHV6dCKnPd2bpYZIYMeIpFpOSSYNbQqjxDLwGD74tvDKGz13uE5Ta7aD1wQnPCkduGW9KjsFga
	IM+Vwbu2XKIZk+ombZgXe39YkhNJOJP5wlEKl8mLtI6gBei7JHN9qNy8rrEQaCKFUWBJUH+CQcK
	/CxpX+PPrkvgI3AcHQ+m3apKEh4SOFGwc5Db1fw6Esi8IXLyc0i3csIuYSqdd0Y2YxaJNlbgKSj
	aYhlHLN9FX/gGZKrzZJAyL4iDSbV8hY5UmQ/wl10wdL/m8uOJmIR48RTmU3kvmvwnBhOxVjoDXK
	bcZDH6rFOwCM8VVfdZUKqGZ7MUz04B7JU+CmuV91eJWTYf7NJ8hx1QATxCSOP6h9623Cserw2x4
	3/0gFtOHbeEcfhhKwrvGVwJxPdUVbe0tPYKaqG8=
X-Received: by 2002:a05:6a00:1a92:b0:886:d769:615 with SMTP id d2e1a72fcca58-8beb1fd9e52mr12502977b3a.1.1794907293239;
        Tue, 17 Nov 2026 01:21:33 -0800 (PST)
Received: from TheRealOne ([2409:40e1:499:722a:52aa:d755:8f06:9251])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed204f7d6sm5014996b3a.35.2026.11.17.01.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 01:21:32 -0800 (PST)
From: Chandradhar Kumar <chandradhar.2003@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io
Cc: xiao@kernel.org,
	magiclinan@didiglobal.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com,
	Chandradhar Kumar <chandradhar.2003@gmail.com>
Subject: [PATCH v5 3/3] md: enforce max_disks and MD_SB_DISKS in raid_disks and slot sysfs stores
Date: Tue, 17 Nov 2026 14:50:53 +0530
Message-ID: <20261117092053.10884-4-chandradhar.2003@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117092053.10884-1-chandradhar.2003@gmail.com>
References: <20261117092053.10884-1-chandradhar.2003@gmail.com>
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

Userspace can configure a persistent v0.90 array via sysfs with
mddev->raid_disks > MD_SB_DISKS or rdev->raid_disk >= MD_SB_DISKS when
mddev->max_disks is not yet populated or when writing to the inactive
or reshape sysfs paths.

Enforce the disk and slot bounds in raid_disks_store() and slot_store()
so invalid configurations are rejected upfront with -EINVAL or -ENOSPC:

1. In raid_disks_store(), reject values exceeding INT_MAX to prevent
   signed overflow when assigning to mddev->raid_disks, and check
   mddev->max_disks and MD_SB_DISKS (for persistent v0.90 arrays)
   before branching into active, reshape, or inactive configuration.
2. In slot_store(), reject slot >= mddev->max_disks or slot >=
   MD_SB_DISKS (for persistent v0.90 arrays) in both the active
   hot-add and inactive configuration branches.

Fixes: 1a33a379e678 ("md: reject v0.90 arrays with too many devices")
Signed-off-by: Chandradhar Kumar <chandradhar.2003@gmail.com>
---
 drivers/md/md.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b09553078353..9fac810edc26 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3387,6 +3387,12 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 		if (slot >= rdev->mddev->raid_disks &&
 		    slot >= rdev->mddev->raid_disks + rdev->mddev->delta_disks)
 			return -ENOSPC;
+		if ((rdev->mddev->max_disks &&
+		     slot >= rdev->mddev->max_disks) ||
+		    (rdev->mddev->persistent &&
+		     rdev->mddev->major_version == 0 &&
+		     slot >= MD_SB_DISKS))
+			return -ENOSPC;
 
 		rdev->raid_disk = slot;
 		if (test_bit(In_sync, &rdev->flags))
@@ -3408,6 +3414,12 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 		if (slot >= rdev->mddev->raid_disks &&
 		    slot >= rdev->mddev->raid_disks + rdev->mddev->delta_disks)
 			return -ENOSPC;
+		if ((rdev->mddev->max_disks &&
+		     slot >= rdev->mddev->max_disks) ||
+		    (rdev->mddev->persistent &&
+		     rdev->mddev->major_version == 0 &&
+		     slot >= MD_SB_DISKS))
+			return -ENOSPC;
 		rdev->raid_disk = slot;
 		/* assume it is working */
 		clear_bit(Faulty, &rdev->flags);
@@ -4471,11 +4483,20 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 	err = kstrtouint(buf, 10, &n);
 	if (err < 0)
 		return err;
+	if (n > INT_MAX)
+		return -EINVAL;
 
 	err = mddev_suspend_and_lock(mddev);
 	if (err)
 		return err;
 	noio_flags = memalloc_noio_save();
+	if ((mddev->max_disks && n > mddev->max_disks) ||
+	    (mddev->persistent && mddev->major_version == 0 &&
+	     n > MD_SB_DISKS)) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
 	if (mddev->pers) {
 		if (n != mddev->raid_disks)
 			err = update_raid_disks(mddev, n);
-- 
2.56.1

