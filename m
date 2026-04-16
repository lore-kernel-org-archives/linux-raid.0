Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60903D3CFC
	for <linux-raid@vger.kernel.org>; Thu, 16 Apr 2026 14:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776348244; cv=none; b=KSh1XDOO+yKxuaz4pQu553zxEM8oyD4CTSvTnFo7b5Ed8/rufkxRUSlpQulWMKTYyVe2pTyOG9D4CQFhlG1V3KQQC6i7zQJ+0W302pgnSIlEOvOy48OIYFgjySijPfcbTx10aAESkCcMKGtT/pPjttUHVc6fg9wu/+4ONilsOv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776348244; c=relaxed/simple;
	bh=x1CBEgg3q9ChB7Md8rS9Y30F5msOo7v7SN0c8n7IrB8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hs0fgJNc9AopTMJkxVJ8cxWuVLMjBnkGoYnEe/hKVILVgqRRQfoSyY9trbtAyEl67ST2dFw8tHPbxkSD6XX7pYt08xK+SXV2ZIAtFvf9o21NeCVodR7z/s+jMH+WFgCS+y9Zh1EfUGkOx0Xqo2+wOpYl6+LMfEH6ZD5goc3hmpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Vunx6ZRd; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Vunx6ZRd"
Received: from pps.filterd (m0528009.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63G3SAFS2556189
	for <linux-raid@vger.kernel.org>; Thu, 16 Apr 2026 07:04:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=azEYY16G52ez/CRL7i
	gqb/bU1w3qCSOmMyXs+MvcO8M=; b=Vunx6ZRd7ywKXWzDxBvRIvihEq97Wr4j0o
	fxfxoA14V17mdft7+r5QphRTaeLe25zkIrUTrfF543U17hpC1iZeYLHmztrl1ouD
	Oeaxd3QMjOSgNdTJWMOmvapkkAcqYrG+Ubld6kE6nprcK8g/Vv0gLyckcdU9j17H
	gDD/nf1mkANG/IQGbMnVED25qm4KWScp6Oe86+sMueqU1yhaA1deq3AQ6+ZUcoA5
	ivTgH+qLKwIRuoHRLjJU6e8a+3BnLtCJjinj/MyLF4+8+rc8f3Lx0YFe2yMNTv1q
	4ARukOtausfOo0LXUYRZpCduoKTSF49Cl+gjmZ06roe0nK6Rx4CA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4dh864j6pg-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-raid@vger.kernel.org>; Thu, 16 Apr 2026 07:04:02 -0700 (PDT)
Received: from twshared18017.01.snb2.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.37; Thu, 16 Apr 2026 14:04:00 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 34D9F116259F1; Thu, 16 Apr 2026 07:03:46 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-raid@vger.kernel.org>, <song@kernel.org>, <yukuai@fnnas.com>
CC: <linan122@huawei.com>, <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
        =?UTF-8?q?Tom=C3=A1=C5=A1=20Trnka?= <trnka@scm.com>
Subject: [PATCH] md/raid1,raid10: don't fail devices for invalid IO errors
Date: Thu, 16 Apr 2026 07:03:45 -0700
Message-ID: <20260416140345.3872265-1-kbusch@meta.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Authority-Analysis: v=2.4 cv=GKY41ONK c=1 sm=1 tr=0 ts=69e0ec52 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7x6HtfJdh03M6CCDgxCd:22 a=U_y8lYiYyhHBU5rMqhb2:22 a=VwQbUJbxAAAA:8
 a=wwriUCt6AAAA:8 a=4SQmuqq9RPnOnH_tKe8A:9 a=QEXdDO2ut3YA:10
 a=Xt_3Jk9P2Dyx6dWD9ir1:22
X-Proofpoint-GUID: A93QPFnBKaS3Qxlhc98GWhxNzXTIzd_N
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDEzNSBTYWx0ZWRfX1mjeLp9+VW77
 2SofCqjOPDSCkNPKRRGo1qY94ltVFNDh+Jj8WVb3yBp/EUVaPslDafhaHENzyO5Z5dXfFmanAT9
 SxBWD+mFKlboJ6AEHATiRazaYN0SJsM8v5bdeiwXQhqQvKKh+8HoYx4RDpz0iiavWpfs/h8/ILR
 Qi/D50Z52wCB9ibwnH7ljievTsEUe1rzCeMXryCKvB3pjGRejLGEnhZlBAqyhnwNJmAfHpURpBK
 CUyanURKRUXdXAmcLLEAEhOZjqMik7q5HKPhoAMx7jDwqPmc4hTnaHD6q8zoZalNCHP7njoyU37
 nNztwb9Bar4T99Rvu4SbKlEuA94Bqh1J+XbLR7aDk1cappQpRANBqp7RLgKyr4UsMalt/q11WZb
 iKwQEsx5j3zYqHT5+vN/apb65sXY8T3ajOm+OZKa8fiY+tjxnJiwKpIetDZUUBVHsnbJBkSn1lN
 597Mr/VpUKixHw0tKhg==
X-Proofpoint-ORIG-GUID: A93QPFnBKaS3Qxlhc98GWhxNzXTIzd_N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_03,2026-04-16_02,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

BLK_STS_INVAL indicates the IO request itself was invalid, not that the
device has failed. When raid1 treats this as a device error, it retries
on alternate mirrors which fail the same way, eventually exceeding the
read error threshold and removing the device from the array.

This happens when stacking configurations bypass bio_split_to_limits()
in the IO path: dm-raid calls md_handle_request() directly without going
through md_submit_bio(), skipping the alignment validation that would
otherwise reject invalid bios early. The invalid bio reaches the
lower block layers, which fail the bio with  BLK_STS_INVAL, and raid1
wrongly interprets this as a device failure.

Add BLK_STS_INVAL to raid1_should_handle_error() so that invalid IO
errors are propagated back to the caller rather than triggering device
removal. This is consistent with the previous kernel behavior when
alignment checks were done earlier in the direct-io path.

Fixes: 5ff3f74e145adc7 ("block: simplify direct io validity check")
Link: https://lore.kernel.org/linux-block/2982107.4sosBPzcNG@electra/
Reported-by: Tom=C3=A1=C5=A1 Trnka <trnka@scm.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/md/raid1-10.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index c33099925f230..56a56a4da4f83 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -293,8 +293,13 @@ static inline bool raid1_should_read_first(struct md=
dev *mddev,
  * bio with REQ_RAHEAD or REQ_NOWAIT can fail at anytime, before such IO=
 is
  * submitted to the underlying disks, hence don't record badblocks or re=
try
  * in this case.
+ *
+ * BLK_STS_INVAL means the bio was not valid for the underlying device. =
This
+ * is a user error, not a device failure, so retrying or recording bad b=
locks
+ * would be wrong.
  */
 static inline bool raid1_should_handle_error(struct bio *bio)
 {
-	return !(bio->bi_opf & (REQ_RAHEAD | REQ_NOWAIT));
+	return !(bio->bi_opf & (REQ_RAHEAD | REQ_NOWAIT)) &&
+		bio->bi_status !=3D BLK_STS_INVAL;
 }
--=20
2.52.0

