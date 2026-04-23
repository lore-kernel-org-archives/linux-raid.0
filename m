Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29AB37C118
	for <linux-raid@vger.kernel.org>; Thu, 23 Apr 2026 10:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776939212; cv=none; b=VUqDh5SbzF+zcuF5ZwE7hUTW9ZOPCeTVcOJ9BvIYqOBh7bccU5r1MQAgKUpW2pThviXrdic0c2kzdYqoYy2ci5P3yngQhK2s/3brWU37/RU3uqvopf9t3y/BN71PQHuvaNrDcRzy7HCh+0tKmBEZenOQyFPiCx/sEyhpBxnl/hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776939212; c=relaxed/simple;
	bh=BFgSLuyGF45cFZJ5kjot3K10/DX2p6hJz1boGY1v0Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbUhLOONLfzZrreKuSJ+gOdNTC7nsspNP8HILp5l5OWd6PTGkGSWRFH3zYAqoAfFiH9cITqvCOBluujsK0nXHYroEu/U6sHe+zoK6ksJa/B7MZpXzwcg8B3sjE8CbMyarvZ8JyTA7lQ9LjThngDZXWsUPGhb/QWMt6RJlrpaLtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VZZrapHR; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VZZrapHR"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4838c15e3cbso59843445e9.3
        for <linux-raid@vger.kernel.org>; Thu, 23 Apr 2026 03:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776939208; x=1777544008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QJJoHWfjIYcyVr3kqYM2gLBS1v38HSn5RQ7YXMRbXlc=;
        b=VZZrapHRK74utgJ8+S4HLSoOj6j1Q2KrEFJOjUH6h51OCdTVVfpOOzfABZJ8fkDszq
         lVQ3WO453FOh3Xr5Q3v3lPaZukeOQWzyw/HeFcN1Fr39QEw5CCO6dXCOW6drT73lQsQS
         QhySNGgl6+9hYpmdbquHHEytg495qPi1vyEBEPBUYfN/hVkoYJXgK1AuTZeVbUSMN3u2
         ev0QT66Qo95qfWnHTaUTxsLyWmwUROg7MLmP7T/E6NWVKv6j4SsGvu2W1H/WGtihnWqb
         hc+ghd1PwElGJXmuVCH+VOtrAOBqazStTYESzsqSxArMFKeEWfkPAoAd+QMvMRLA/XNY
         I0YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776939208; x=1777544008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QJJoHWfjIYcyVr3kqYM2gLBS1v38HSn5RQ7YXMRbXlc=;
        b=cj1saK/nTMVF2H2K35PCENkBKmQ7iJzwtHB8DkCjPrNRlGJXfQ5fykQSmeQriEkqnF
         ms/a3X9FeGC5tdfPZbK/EbpFg8YIwDBNJA46mLT6WMSqt4AWfebs3PB66DLxvpPcCCpP
         WUDMorQAduK3wyCa+IlTR8Ap/EvrFNRo2ejWD2YbWn8gkoBUC7z6cQoVlchxpEaNkCQu
         4uqD4tI52fkD+Nt13uimH6is+gnIdu0OIEZDckJ1IjRag0HNHNp/3U1B1nFlI01z1ij0
         oilPFjHjWF+OJbzHTaIp7eestuYY+cqdiLkfcWTCqFIzM8t9hQz3lftJ/tRMh3F4lYAw
         lBlA==
X-Gm-Message-State: AOJu0YzAjj4qTMpmK4zTR2ylbJvSThnQ1UeAfV2MxFI/TR5Caw7etq/M
	GGjUXvj83XFJdjz8NduNEoN7gMRgHwjCZM1qkfQo7Y/2lOWzQ8WuCTU1
X-Gm-Gg: AeBDieumMvBL2QOJANgz25KNmPaJsxzmJQrFf6i//z4hIQT2azPkAH8MTNjtBruP7tv
	EakDoTPGZOU+PXfxpOsjgqGhFAelO16M5Vh7vDgXrg+ELHs97YpG2k95WmePk37+Dsq6+Mx5PzG
	Fj/YTqqFTr968YgO66jUHO6Up2EsgyRZ2h3yauC/UGEKgbv0P62ckiCeQbIE4Iw+zZR7YOd7rBA
	9RmasQKVTEZqFFifvgaOXECq30xbdl+JZaZ0PbHYi4e90Pc1RuP8mTM4r4ZaiDHJpkyh0st1WCY
	l92/qjWuhaAjgsGZjWwN+LNIS3D8YF0L3lHP9jef6TvHP9wmdU/H6JqgnYd8AWvxf6nnPDZNM6+
	mFP5AQvRwCEYjqcyG68ib274NwvX2Op0zj7J6ZGqFtz+ZFwcly0hGz7ZwD2l3Rj11uC4/92Pe8C
	DjEpE1oHzF8RKN0qkMI5NBtouyr6tMv629HdlqjxBo79cw
X-Received: by 2002:a05:600c:5294:b0:486:fa35:aef2 with SMTP id 5b1f17b1804b1-488fb73d53bmr349782545e9.4.1776939208169;
        Thu, 23 Apr 2026 03:13:28 -0700 (PDT)
Received: from yocto.. ([2a02:3037:60e:ee7d:34af:34c4:890b:2c47])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e4d525sm49741217f8f.31.2026.04.23.03.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 03:13:27 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH 3/3] md: use ATTRIBUTE_GROUPS() for md default sysfs attributes
Date: Thu, 23 Apr 2026 12:13:03 +0200
Message-ID: <20260423101303.48196-4-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260423101303.48196-1-abd.masalkhi@gmail.com>
References: <20260423101303.48196-1-abd.masalkhi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the md_default_group and md_attr_groups with
ATTRIBUTE_GROUPS().

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/md.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 346d071c1b8e..0e55639211f2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6045,10 +6045,7 @@ static struct attribute *md_default_attrs[] = {
 	&md_logical_block_size.attr,
 	NULL,
 };
-
-static const struct attribute_group md_default_group = {
-	.attrs = md_default_attrs,
-};
+ATTRIBUTE_GROUPS(md_default);
 
 static struct attribute *md_redundancy_attrs[] = {
 	&md_scan_mode.attr,
@@ -6073,11 +6070,6 @@ static const struct attribute_group md_redundancy_group = {
 	.attrs = md_redundancy_attrs,
 };
 
-static const struct attribute_group *md_attr_groups[] = {
-	&md_default_group,
-	NULL,
-};
-
 static ssize_t
 md_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
 {
@@ -6154,7 +6146,7 @@ static const struct sysfs_ops md_sysfs_ops = {
 static const struct kobj_type md_ktype = {
 	.release	= md_kobj_release,
 	.sysfs_ops	= &md_sysfs_ops,
-	.default_groups	= md_attr_groups,
+	.default_groups	= md_default_groups,
 };
 
 int mdp_major = 0;
-- 
2.43.0

