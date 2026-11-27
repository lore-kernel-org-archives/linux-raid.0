Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795739575;
	b=5CPOc1/AkZcjfjbmJZUBtGIsLh05Lf10ChTquQvVOgUv3WQE+qVJRUzlTVBMUK6OIwHB
	 5fj4EYnJzW12NImBJBd6fRzy5GDP+FfGqer65fTRZmaUkzS9Gj6nJ1WZlWlSMOd+9gI7Z
	 zC9XXIEl7AcHC+lH3Im0tN1uJD/dXMYyov39SEkkz2J1ngf83tWDKh3eonn7zVlWgWwsh
	 +7uwGc82RwNsfPp0xuwWFehwm9zF31JePDO6SYv/od0Vm6y+OY839tmDW8pQLygFq9FB/
	 GZ1ULC2o24sPKn/sX4R/ry4eGvZHkwTkYPgWDbU89bhjDVtPWR+zc+3KRo7/ndMfqEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795739575;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Y/VaSmPm1p19a5o3iTOi8KEaRCqj1m9Qx4cpltOCUKQ=;
	b=w1l2ehUNQ19nEQs4DMLX+x/C2t4vpw48dkS8tts3s+9J2ZDe0xqUrXhfIDPe0ViPDyah
	 eoZk3OiCLzkK5vZxeJsCQBZv/epQS4/urKbnHJdnNjkACB/EXRFWSJsFAHB8dqcyouAAp
	 6REZLYcw3Jxuz+KS/B60/QyzqaWbB3CrEkQcv5NO+FCaUkGMH2azD1jvue1pSv+t604Te
	 tfUZwIDZDhRFpiOMuO1AfQBC7oKR+cwxOcvgguZUfZzHB+Yd2Mrpd3mxvQCT+iy5zyOdL
	 wQM2YmyrZ8vk9WfqMt94RlOCUtle1Bc9G7S9FSYTGJRsSSoTpbuTI+9MzI8mMS6198g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b="o/2pr7u3";
	arc=none smtp.remote-ip=79.135.106.113
Received: from mail-106113.protonmail.ch (mail-106113.protonmail.ch [79.135.106.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E8D606A6A8
	for <linux-raid@vger.kernel.org>; Fri, 27 Nov 2026 00:32:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4E8D606A6A8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=o/2pr7u3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795739572; x=1795998772;
	bh=Y/VaSmPm1p19a5o3iTOi8KEaRCqj1m9Qx4cpltOCUKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=o/2pr7u3WeU45cO5JjBaRSY0B1noSo2yxtTD2YYKWEHPzQwz1mrVr5BOIvPLvqgsc
	 Uf6Wsp/mkk5hVWvjq2KmbpFxK0kNmBD04mlWCRy3CgTpNkhJIg3YyAvvxuxytqTHOY
	 JrsphckybEJjNa/ZSI5d7/cSVkYm6bE8Gu68hQPyMz3DgBa+JxZtrufKX8x9TuoTI/
	 mmCkcNf5NTECK0QAndmpbfE8Wt/fewsWZmjK5IBONC56gI/WgzZBvd60oCFxHFQI3P
	 iyiIU1HhQ4aPNMYE2hWI2jke898WeE07papXIg3Oya7XfRdppNc9rBgvQ45R2Q5NWK
	 kvsUqcdsekSEw==
X-Pm-Submission-Id: 4jbDsH2lcXz2ScQJ
From: Miroslav Cimerman <mc@raidlab.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	NeilBrown <neil@brown.name>,
	Mariusz Tkaczyk <mtkaczyk@kernel.org>,
	Kenta Akagi <k@mgml.me>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] md/raid1,raid10: hold writes that skip a newly failed device
Date: Fri, 27 Nov 2026 00:32:30 +0000
Message-ID: <20261127003231.1180197-8-mc@raidlab.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261127003231.1180197-1-mc@raidlab.org>
References: <20261127003231.1180197-1-mc@raidlab.org>
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

A device can fail between the wait for blocked devices and the device
selection of a write. The selection skips Faulty devices, so the write
completes before the superblock records the failure. Before the commits
below, the selection waited for a Blocked device.

Give the write to a Faulty device while its failure might not be
recorded: while it is Blocked, or after MD_BROKEN. raid1_submit_write()
fails the copy at once, and the write is held. Waiting for Blocked
again would miss MD_BROKEN: md_update_sb() clears Blocked even when the
superblock write failed.

This needs "md/raid1,raid10: hold writes that fail on a faulty device"
and "md/raid1,raid10: fail held writes when the array fails".

Fixes: 88ed59c4cc6c ("md/raid1: factor out helper to handle blocked rdev from raid1_write_request()")
Fixes: f2e7e269a752 ("md/raid10: pull the code that wait for blocked dev into one function")
Cc: stable@vger.kernel.org
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
 drivers/md/raid1-10.c | 12 ++++++++++++
 drivers/md/raid1.c    |  9 ++++++++-
 drivers/md/raid10.c   | 13 +++++++++----
 3 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 341a9785e3f2..f8fa9cdc4080 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -125,6 +125,18 @@ static inline void raid1_submit_write(struct bio *bio)
 		submit_bio_noacct(bio);
 }
 
+/*
+ * Give a write to a Faulty device while its failure might not be recorded:
+ * Blocked is set until it is, and after MD_BROKEN it might never be.
+ * raid1_submit_write() fails the copy, and the write is held.
+ */
+static inline bool raid1_write_to_faulty(struct mddev *mddev,
+					 struct md_rdev *rdev)
+{
+	return test_bit(Blocked, &rdev->flags) ||
+	       (!mddev_is_dm(mddev) && test_bit(MD_BROKEN, &mddev->flags));
+}
+
 static inline bool raid1_add_bio_to_plug(struct mddev *mddev, struct bio *bio,
 				      blk_plug_cb_fn unplug, int copies)
 {
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f596b36ec6e1..508673e8c02e 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1524,8 +1524,15 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 			write_behind = false;
 
 		r1_bio->bios[i] = NULL;
-		if (!rdev || test_bit(Faulty, &rdev->flags))
+		if (!rdev)
+			continue;
+		if (test_bit(Faulty, &rdev->flags)) {
+			if (raid1_write_to_faulty(mddev, rdev)) {
+				atomic_inc(&rdev->nr_pending);
+				r1_bio->bios[i] = bio;
+			}
 			continue;
+		}
 
 		if (test_bit(WriteErrorSeen, &rdev->flags)) {
 			sector_t first_bad;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 519b6ac0accd..6ea84eb8bf87 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1387,14 +1387,19 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 
 		rdev = conf->mirrors[d].rdev;
 		rrdev = conf->mirrors[d].replacement;
-		if (rdev && (test_bit(Faulty, &rdev->flags)))
+		r10_bio->devs[i].bio = NULL;
+		r10_bio->devs[i].repl_bio = NULL;
+
+		if (rdev && test_bit(Faulty, &rdev->flags)) {
+			if (raid1_write_to_faulty(mddev, rdev)) {
+				r10_bio->devs[i].bio = bio;
+				atomic_inc(&rdev->nr_pending);
+			}
 			rdev = NULL;
+		}
 		if (rrdev && (test_bit(Faulty, &rrdev->flags)))
 			rrdev = NULL;
 
-		r10_bio->devs[i].bio = NULL;
-		r10_bio->devs[i].repl_bio = NULL;
-
 		if (!rdev && !rrdev)
 			continue;
 		if (rdev && test_bit(WriteErrorSeen, &rdev->flags)) {
-- 
2.53.0

