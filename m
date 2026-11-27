Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795739565;
	b=WdArKIDJ+T+mj9nyBE1lnBCVh5VNvHOgccQXkoo2JB6cDPlFfo9PRR6PMlM738Kqs1NO
	 WSprQZE2Q+6b1LQLem1aekJ8njVuDUc+gWT1fobx1k4rnDaqxzjrFoCNSU6OgezuR7+cc
	 2AAjdRzcz/vH8jEtamczFkrmealLO23nsD2sUSLvCAH0yCFVhS5fhUsOea7n1gDzySAnv
	 5h0XgXQX6LdJiGXOerE+0yCi/1vEizYAnIzmz5na37l48uwYrkdfWB5D4yD2qLVVUl3Tt
	 m/MB8FgEBN0nT4OrAKQ+sbyU2x3j5f/UKR0XmwjDOTxgc97DnyCJx//lZZmmpmbwWBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795739565;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WFOlnWLmxVs+d/m6XENE7MTE2CKrqhRq+ItGAT7dH58=;
	b=HRm/4K9vp/cjM77chzFNX4AaPsv8YROjMK9pyT5Y/N0yOE3/nKyclBKWJ/aEmu+y2IVs
	 0xZY3gFswOUqqgLSi6DaQhd9jzKMPhAx3Kwm98rJIr1SbrWTZPI6G9nmJTJ3eWo1ind9L
	 dCxQSna5nHTvtchtEaaajTGZfnm8LYcgvRmx6RPNctZPzImRrbe0lW585Gc7sr8oVSl0Q
	 6JLAxTqr47XIeFOuPJLQB7s9hvQaul++9uXJGsMD7qgMFHzbv9Lxm6J0gOf2y2AHCu2sa
	 zy1GoEjKmyiOMYvud1Hj9gPTcQ52epco8Of6fZ6Ua4I9r3rIAw9ZrcbZvXqbsejjlbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=HVazN9M2;
	arc=none smtp.remote-ip=185.70.43.170
Received: from mail-43170.protonmail.ch (mail-43170.protonmail.ch [185.70.43.170])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A13606A32D;
	Fri, 27 Nov 2026 00:32:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08A13606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=HVazN9M2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795739562; x=1795998762;
	bh=WFOlnWLmxVs+d/m6XENE7MTE2CKrqhRq+ItGAT7dH58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=HVazN9M2t9p7iJqTzZLlOUnJLhlTlNo3w8FjUHn5unFUzyeyjZ1dJHKQLYLAbIF5e
	 R7lE6RPKwZEQF3LpFPXSkC2hPy4LloOcpFaqZREe16+d2xbgAbvpq4cDVnDNkm8l0R
	 68X0TN04aUnFZ6h28EYt8BfeWbHcA0c3LT9LISH6zEkE/RsQM5ARQun/SIvCLtfxlg
	 kUEMjQAz8y3iQcOHDXTwW7zhOD7tfqfsuvcL8rYXNosi82OCqdwA8Vu+FhBeTuWfAg
	 q2O4xXCc6Is6/nx52VmiAJq2Nj0lDPhXvJM2s+1zz+NfXRcZcLUaxS71Nj+rrv0h8m
	 t1iK7KlJygExg==
X-Pm-Submission-Id: 4jbDs43Vpkz2SchB
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
Subject: [PATCH 1/8] md/raid1,raid10: fail held writes when the array fails
Date: Fri, 27 Nov 2026 00:32:24 +0000
Message-ID: <20261127003231.1180197-2-mc@raidlab.org>
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

raid1 and raid10 hold a write that failed on one device until the
superblock records that device as faulty.

If the superblock write then fails on the last working device, the
error handler sets MD_BROKEN, keeps that device In_sync and requests no
new superblock update. md_update_sb() clears MD_SB_CHANGE_PENDING, and
the held write completes with success. No superblock records the failed
device. After a restart, both devices assemble as in sync, and reads
can return the old data of the failed one.

Fail the held writes when MD_BROKEN is set. dm-raid does not reject
writes when MD_BROKEN is set, so leave it unchanged.

Found with FuzzyRAID, a fault injection fuzzer for RAID
implementations.

Fixes: 55ce74d4bfe1 ("md/raid1: ensure device failure recorded before write request returns.")
Fixes: 95af587e95aa ("md/raid10: ensure device failure recorded before write request returns.")
Cc: stable@vger.kernel.org # v5.19+
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
 drivers/md/raid1.c  | 8 ++++++++
 drivers/md/raid10.c | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 25b80ad52f00..37d120a63778 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2629,6 +2629,14 @@ static void raid1d(struct md_thread *thread)
 			list_del(&r1_bio->retry_list);
 			idx = sector_to_idx(r1_bio->sector);
 			atomic_dec(&conf->nr_queued[idx]);
+			/*
+			 * If the array failed while this write was held, the
+			 * failed copy might not be recorded. Fail the write,
+			 * except for dm-raid.
+			 */
+			if (!mddev_is_dm(mddev) &&
+			    test_bit(MD_BROKEN, &mddev->flags))
+				clear_bit(R1BIO_Uptodate, &r1_bio->state);
 			if (test_bit(R1BIO_WriteError, &r1_bio->state))
 				close_write(r1_bio);
 			raid_end_bio_io(r1_bio);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 68f42cad32a5..a65bd65ae7bd 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2942,6 +2942,14 @@ static void raid10d(struct md_thread *thread)
 						   retry_list);
 			list_del(&r10_bio->retry_list);
 
+			/*
+			 * If the array failed while this write was held, the
+			 * failed copy might not be recorded. Fail the write,
+			 * except for dm-raid.
+			 */
+			if (!mddev_is_dm(mddev) &&
+			    test_bit(MD_BROKEN, &mddev->flags))
+				clear_bit(R10BIO_Uptodate, &r10_bio->state);
 			if (test_bit(R10BIO_WriteError,
 				     &r10_bio->state))
 				close_write(r10_bio);
-- 
2.53.0

