Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795739573;
	b=vW+VakHGSw664Hfm7or1/NnvpulKYGuQMUYSGnu2uWGs9ERVA2dqyxWSDPbdN7TyK9lU
	 M6fJIQYrrkwFik/Q91TuPTeK6WgcAOpvL/uQcV6/xnb9YtZXLibvSevQq8TatYK1d6lMz
	 VRr/6HcmLN/Tp/GWjMP+tpO7MW0DCddBAhmdX09VCKLz2Yws7KfcyXx54C2iPAWeTw1QC
	 TBE3sq2KYbgyY2fn3ylmWHhg2GwyViTIIVbRVH9Uq3tpV12MZ0LfUOkv7Y/dS+tov87QJ
	 CIuofvKSMDtZG4mAvSFngjQPZSlAZGDygORS1gGSfBmbM7onHJEJtiikwvp/oJWo7oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795739573;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=VrziUlYL+ZMnfPhHjIMMvVa3cQE2y05K5kr8Qko+puM=;
	b=yuorbJVgB/kFKzeBbVS2eYqUF6j9Q4fD/sAC2WHGDEFZ/9Yp0nTiVuHOArbrzyfRbY/N
	 iZETysdUArdK8FSc1B/tiTsPKNHN5El1vyxxVzPRzHilxTjtWkeJnyq4D0e0R/i9sz9SC
	 bMzcgdZhNZ5RVIvy84xuj6wonpRyfaNKJVwKHAXPTji8Fbpjs/3SOKLPCw+yDvf53gy+V
	 uuC6oSFbVcf+7SxywY94IUXEObWZhqMvaM3v84aO2e9LnYj7yPX62hN/1O19dBuSzpTZ/
	 XzhcMtWvZlLI8T0Efl3OYk58wdbzwHFQoJvychxEz9itp0QXeO+NyIoXSpgr9HVhU9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=MNuYdVZH;
	arc=none smtp.remote-ip=79.135.106.113
Received: from mail-106113.protonmail.ch (mail-106113.protonmail.ch [79.135.106.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18A9606A327
	for <linux-raid@vger.kernel.org>; Fri, 27 Nov 2026 00:32:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A18A9606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=MNuYdVZH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795739570; x=1795998770;
	bh=VrziUlYL+ZMnfPhHjIMMvVa3cQE2y05K5kr8Qko+puM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=MNuYdVZHlF7UnWePAuQO71caYu/mhqxnHkY+ExWVzq8Ydd571VsYg3MTg4O2/I7mN
	 JK+jPQP0T0qEH+naNX80ZvS9DQ8qd2AFGVJHKdiCtRNl7cY4QZUs7gYJ3h1pavr5f/
	 Bm92t19e+53z6E1ltdmTSraAMXzqt84eI4Z7+7UGYllZafqCvsOZ75404ThZFebvvu
	 GgJ5jIUCOqszkNv7andXQcmQeuVmb97ugH7zlA8uIUeDrNalQAZMcm2krYqKCjv3rE
	 p8k9UVpVlaexgfIRJpnCModI2UmIZq1h0cOS6wuYuqLjQNHbjiedzzajij9a32wkMa
	 XJY+QCmGNrYMA==
X-Pm-Submission-Id: 4jbDsD366gz2ScQJ
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
Subject: [PATCH 5/8] md/raid1,raid10: hold writes that fail on a faulty device
Date: Fri, 27 Nov 2026 00:32:28 +0000
Message-ID: <20261127003231.1180197-6-mc@raidlab.org>
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

If a device is already Faulty when a copy of a write fails on it, the
end_io does not hold the write. The write completes at once with
success from the other copy, before the superblock records the failure.
This happens to writes in flight when another write fails the device,
to writes that raid1_submit_write() fails on a Faulty device, and with
failfast, where md_error() runs in the end_io.

Hold these writes too, but skip narrow_write_error() for a Faulty
device. The "end bio when the device faulty" commits avoided these
retries.

Fixes: eeba6809d8d5 ("md/raid1: end bio when the device faulty")
Fixes: 7cee6d4e6035 ("md/raid10: end bio when the device faulty")
Fixes: 212e7eb7a340 ("md/raid1: add failfast handling for writes.")
Fixes: 1919cbb23bf1 ("md/raid10: add failfast handling for writes.")
Cc: stable@vger.kernel.org # v5.19+
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
 drivers/md/raid1.c  | 16 ++++++----------
 drivers/md/raid10.c | 20 ++++++--------------
 2 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index fcdbccf6e368..54ba3013150e 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -493,16 +493,10 @@ static void raid1_end_write_request(struct bio *bio)
 		}
 
 		/*
-		 * When the device is faulty, it is not necessary to
-		 * handle write error.
+		 * Hold the write until the superblock records the failure,
+		 * also on a Faulty device.
 		 */
-		if (!test_bit(Faulty, &rdev->flags))
-			set_bit(R1BIO_WriteError, &r1_bio->state);
-		else {
-			/* Finished with this branch */
-			r1_bio->bios[mirror] = NULL;
-			to_put = bio;
-		}
+		set_bit(R1BIO_WriteError, &r1_bio->state);
 	} else {
 		/*
 		 * Set R1BIO_Uptodate in our master bio, so that we
@@ -2549,7 +2543,9 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
 			 * errors.
 			 */
 			fail = true;
-			narrow_write_error(r1_bio, m);
+			/* No retries on a Faulty device */
+			if (!test_bit(Faulty, &conf->mirrors[m].rdev->flags))
+				narrow_write_error(r1_bio, m);
 			rdev_dec_pending(conf->mirrors[m].rdev,
 					 conf->mddev);
 		}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 838ae71205c1..519b6ac0accd 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -473,7 +473,6 @@ static void raid10_end_write_request(struct bio *bio)
 	struct r10conf *conf = r10_bio->mddev->private;
 	int slot, repl;
 	struct md_rdev *rdev = NULL;
-	struct bio *to_put = NULL;
 	bool ignore_error = !raid1_should_handle_error(bio) ||
 		(bio->bi_status && bio_op(bio) == REQ_OP_DISCARD);
 
@@ -505,17 +504,10 @@ static void raid10_end_write_request(struct bio *bio)
 			}
 
 			/*
-			 * When the device is faulty, it is not necessary to
-			 * handle write error.
+			 * Hold the write until the superblock records the
+			 * failure, also on a Faulty device.
 			 */
-			if (!test_bit(Faulty, &rdev->flags))
-				set_bit(R10BIO_WriteError, &r10_bio->state);
-			else {
-				/* Fail the request */
-				r10_bio->devs[slot].bio = NULL;
-				to_put = bio;
-				dec_rdev = 1;
-			}
+			set_bit(R10BIO_WriteError, &r10_bio->state);
 		}
 	} else {
 		/*
@@ -560,8 +552,6 @@ static void raid10_end_write_request(struct bio *bio)
 	one_write_done(r10_bio);
 	if (dec_rdev)
 		rdev_dec_pending(rdev, conf->mddev);
-	if (to_put)
-		bio_put(to_put);
 }
 
 /*
@@ -2926,7 +2916,9 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 				rdev_dec_pending(rdev, conf->mddev);
 			} else if (bio != NULL && bio->bi_status) {
 				fail = true;
-				narrow_write_error(r10_bio, m);
+				/* No retries on a Faulty device */
+				if (!test_bit(Faulty, &rdev->flags))
+					narrow_write_error(r10_bio, m);
 				rdev_dec_pending(rdev, conf->mddev);
 			}
 			bio = r10_bio->devs[m].repl_bio;
-- 
2.53.0

