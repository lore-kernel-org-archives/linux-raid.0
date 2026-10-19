Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792438625;
	b=Q8Ky7FgigFPdQVlCtqRwHxB8QtCeTP1+pUXX7DUNLxkimM/2JaadBpnkTmel9j60/SaL
	 vp7mcgEUb7kUX4VL1bhli2pm2duKxS1MRl+PKvm+po8J4oNL5LXGAKQ7yVqjZhaQLfuHM
	 lFkmg9zlpSpNHCi8dkCol9d5p5kk8QtL8hhDrpHs6XdhyJrjWuU4VZ6d4Db/N6RBTb30U
	 PXHAajxYblOiczPJrB1a6Mm/tscrYEb16mA0G96u8dhzHAKEQzsV+rqDfVfr7wBp22IVR
	 XQmchZKPBBCv400hjbIIJkYiPKicaFskmMYDVWEN5zJIyAjXATX45I0VSldSz38kWFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792438625;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=FvmBdp1Dmbv2yJxDADj49tSTGQ/TMgCg8VxwxHkXYlo=;
	b=RFaVWo1mL9BUumV/70QOTtOm/2cAtgaPgQn7wsoEc0EIvljC9PN4OEwTsHqXp87aw8iL
	 ShttOthg0O8Wt9wsCDfPqTydFl7vHSIDyjuqDQIN4ELcpBddNfdAFVJIbH8YsjtUddwUx
	 MpR6mkwT1ABzW0cbKfnS03Uw5ILab331tSFZ3csMu4i/zQveqJKu+p9VdNFFx/gcMKwMZ
	 RafJve7SWs1gPEOP/H1Kb352G9AwXlvE6XhFRzLE7/FpR5esvY3TSdMBWsCrFZTPJTqUt
	 Ol1fbyWkpGr48awGB0KEOWlDJfWEPg9NJ3VcamhNCkOh4AwZRscAGLBu/vabMCSgM4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=jw5RywPK;
	arc=none smtp.remote-ip=209.85.217.51
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB381606A31D
	for <linux-raid@vger.kernel.org>; Mon, 19 Oct 2026 19:37:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB381606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=jw5RywPK
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-7cc0fb88c90so70553137.3
        for <linux-raid@vger.kernel.org>; Mon, 19 Oct 2026 12:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792438624; x=1793043424; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FvmBdp1Dmbv2yJxDADj49tSTGQ/TMgCg8VxwxHkXYlo=;
        b=jw5RywPKPKu5GRuRcgskbWzYFCcD0g5ucpK/qpfpLuQnp1pSH1ynMYoeytWy48VM4k
         suzFSX1RFLmCUJgW99Iynkwr4NE5nZtOuGbuBZ1GGdBE/QAsaWm4C8v1WVfTMeTEISFf
         xqlXdHqwHYInPfjieQqVTCq2gdk4mlEqNuEiPo8oZLqmvY3sZiumaBaqNK3ZbeEPDeAa
         vgVsgV4hVrmK4EL2oE64PxVWLGFXBTNcSNiLsQjX8OrL5PhKfpOKbzS93DG/nlvJx1RQ
         UQ7E841Ph1Nv377dSka7PzCTVAM1Ib3FDg6lUs1St2SkzifXXjNFjEVEf4emzEtnEino
         F2bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792438624; x=1793043424;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FvmBdp1Dmbv2yJxDADj49tSTGQ/TMgCg8VxwxHkXYlo=;
        b=rq6b1xFmY86AvUJ3j2yM5syuylILnMjRLEURhSOAG5gaB2/Y4oklaplFpQytrH4nd+
         CyfVEsvcYRmxRLcuBvsTM5npHb6e0LMkyUOiO+GaoZP4spSMlcPsnd9LskYHnbRSyl9j
         8MHG0QB3ivo40CMpdg7OzUEbMgLEwPHJQFnvO4useYKuZ9wfXjLqI2ArV7oM/LdtNb2b
         pwTWfspambWXE1GmJJK/cSKtuLNHnW3dRRAm9bXYKLiOLObD/wHAxeW8NVBkj9O9ylvb
         sqarqk+ZOFWq69ZraYavUOq758RxwhmqT/xgg75+vHIg/nhx9DkRbRC6dPKwUeHGqJfA
         v3jg==
X-Forwarded-Encrypted: i=1; AKwUvBzM28cJ8a1G8QqxtDMnqRdjHt8uKbiMuq0uBjt/PKXzK6kyzDhMnpseZT2S4r0/TUNh19cE1SCsDxDl@vger.kernel.org
X-Gm-Message-State: AFq9FYLSrMvT0AZEs85LNtbo0x2MgkIIW0K1vs3zU181LhRjnf/Ut0+x
	hP2PvwwRCYNtBJOuzJQdWJcjRSryoXGsjKp1+LmhOeT5AHKGnlAGMuIr
X-Gm-Gg: AYBFou3xrhfsiQsKcqrtPLhSYNM7Coarq8ePwwSM8PgiKcfkvIxdjnYD/tlqs5KQDgA
	mHqjw79TdqxmnvS9n0wDxY8bMBJETAktgva7xoQch0cK2CrF8itsUbKh+TqRZoCLVNkj7Pg7Cwf
	mYih8keKxaW4aG3lohykoaWYqJpEo4asH/CsQlU4rTazNBhSZatSgaZBsmxOd1DZr4HW7RtTykM
	ZH2VExuNyXHR1J/8OuQgvZ3CZtNcHyoG7G3JjuKl1fbv04vgKgaSKlGSyXRDHAIorjeXOuh97AB
	UaVkxV6NcxOrMuP9q8WQEr7Rulc1nP3e5hGSKrcP7cDBFl01ejouxvucaprSj97v55KR1UaP2ro
	RwLRyWNjRHHYL9uF9YSeBkMQ/duQ1y4osjNEeLCO9TVzJ8ZhdUC+7/rORk5UwIcN1Y07qvbBccD
	/Ralxjq+OTtTrBm9UbU3k4YxGzXghC3xYJYveGe7hV/AQQr6hAk0q7xjsf2Gq7k0m9Bz1Nf4WWZ
	JTuGN5u7vGLW0VsnYqJINsAtvM3xuzTWt70IMo2p8GldiXcvJ5n7eWurInMVpBLMBSereLJy/sp
	4FYSZDHdOmDYSuCo/Uk=
X-Received: by 2002:a05:6102:1624:b0:7c3:99a3:314e with SMTP id ada2fe7eead31-7cc364a294amr1425709137.0.1792438623550;
        Mon, 19 Oct 2026 12:37:03 -0700 (PDT)
Received: from localhost.localdomain ([132.170.205.109])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-990bb335be9sm1057850241.3.2026.10.19.12.37.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 19 Oct 2026 12:37:03 -0700 (PDT)
From: Sanan Hasanov <sanan.hasanou@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+0b672810a475890d3636@syzkaller.appspotmail.com,
	Sanan Hasanov <sanan.hasanov@ucf.edu>,
	stable@vger.kernel.org
Subject: [PATCH] md: don't allow changing the personality of a failed array
Date: Mon, 19 Oct 2026 15:36:59 -0400
Message-ID: <20261019193659.31381-1-sanan.hasanou@gmail.com>
X-Mailer: git-send-email 2.48.1
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

From: Sanan Hasanov <sanan.hasanov@ucf.edu>

level_store() lets userspace switch a running array to another
personality through the takeover path, and then ignores the return value
of pers->run(). Takeover is expected to always produce something the new
personality can run, but that no longer holds for an array that has
already failed: since commit 57668f0a4cc4 ("raid5: introduce MD_BROKEN"),
has_failed() treats MD_BROKEN as fatal, so raid5_run() refuses such an
array. It then frees the new conf and clears mddev->private, while
level_store() has already installed the raid5 personality and freed the
old one. The array is left with mddev->pers == &raid5_personality and
mddev->private == NULL, and the next operation that reaches the
personality dereferences NULL:

  md/raid0md0: Disk failure on loop0 detected, failing array.
  md/raid:md0: not enough operational devices (1/3 failed)
  md/raid:md0: failed to run raid set.
  KASAN: null-ptr-deref in range [0x0000000000000060-0x0000000000000067]
  RIP: 0010:kasan_byte_accessible+0x12/0x30 mm/kasan/generic.c:210
  Call Trace:
   spin_lock_irq include/linux/spinlock_rt.h:96 [inline]
   lock_all_device_hash_locks_irq drivers/md/raid5.c:107 [inline]
   raid5_quiesce+0xc2/0x8a0 drivers/md/raid5.c
   __md_stop_writes+0xeb/0x4b0 drivers/md/md.c:7038
   md_set_readonly+0x330/0x560 drivers/md/md.c:7138
   array_state_store+0x584/0xe90 drivers/md/md.c:4720

syzbot gets there by failing a member of a raid0 array, which sets
MD_BROKEN, then writing "raid5" to md/level and "readonly" to
md/array_state. The same applies to a two-disk raid1 array whose last
working device has failed: raid1_error() sets MD_BROKEN but leaves
degraded at 1, so raid5_takeover_raid1() still accepts it.

MD_BROKEN is never cleared while the array is running, and a failed
array can't be turned into a working one by changing its level. Refuse
the change up front with -EBUSY, which is also what state_store()
returns when failing a device leaves the array broken.

Fixes: 57668f0a4cc4 ("raid5: introduce MD_BROKEN")
Reported-by: syzbot+0b672810a475890d3636@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0b672810a475890d3636
Cc: stable@vger.kernel.org
Signed-off-by: Sanan Hasanov <sanan.hasanov@ucf.edu>
---
 drivers/md/md.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 680b34a63c..367b183f1e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4088,6 +4088,12 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	    mddev->sysfs_active)
 		goto out_unlock;
 
+	if (test_bit(MD_BROKEN, &mddev->flags)) {
+		pr_warn("md: %s: cannot change personality of a failed array\n",
+			mdname(mddev));
+		goto out_unlock;
+	}
+
 	rv = -EINVAL;
 	if (!mddev->pers->quiesce) {
 		pr_warn("md: %s: %s does not support online personality change\n",
-- 
2.34.1

