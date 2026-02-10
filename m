Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [67.231.157.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECD431D72D;
	Tue, 10 Feb 2026 16:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.157.127
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770742315; cv=none; b=BgDFxwmJKKOVvPkSynzHMhGoiQP2Mz07A5Z6HpvY5NCYv7hnj8pqQSONo2FCmQbMxsxN52XIVUz0A3znU4//3NsJLh3pUNk9hsSVN5k5PdPuTiloat1PdwO+HIsvg9VDpnt4SkKhEnzM1dnfP8orGcflWfsVJ3ozJOQnvEZ1FYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770742315; c=relaxed/simple;
	bh=JLIm3Ajp2nokifNAYIugpAdlCN26av5ZYJ6U/qlBX4k=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Pv5MZU8lEtdtMKT3+6pq/C5tDPg9EGvkZwqISxU+pSG2kDZ42K42jtNDUqne/zWoXMUotflOINrM60RwY3a7Hy2SV5NIOMGOycsnwJqnrrLiEQ+u/QMxfxqYPzCqGh31ww2DcpqxJ4n1FUfZhTrMeqOBIak5IqldOLMp/VfFYlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=akamai.com; spf=pass smtp.mailfrom=akamai.com; dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b=aBREA8XG; arc=none smtp.client-ip=67.231.157.127
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=akamai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=akamai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b="aBREA8XG"
Received: from pps.filterd (m0122331.ppops.net [127.0.0.1])
	by mx0b-00190b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61ACkuNU1000174;
	Tue, 10 Feb 2026 16:51:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=jan2016.eng; bh=SQOWISIN2EEtxnjr7TyU
	6E8Fj6Y7wrnADCdYC6biFC4=; b=aBREA8XG15z70mWxBIF+7MtR9BvceB4yq0kJ
	sE6zEoIi0uQ6IoTTAkK80In1s76U402ln5TM/B0xx5xYcXNH8lXirYVxNS2ilWEP
	xIuCLhlOwPpnZgH5ChUKPE/eCl0OmSfk0jTPXHNieXK8ChYXRF0YKvIZ/8bRCwhy
	UghsmDgQWYGpirWbhNT/vza+NHNbzL03RDe2E3e88H+tkVefhVAdLVB4hcyldzrL
	OtzrUQdjYLIRjBgHd++Urz9FtGn0FMYe8UAzhwPbIKScR0bsPz2PJjV9kAK9G9f7
	AyT85l14nEtJE05XHOu5eJq0eMMT7hqN5iyRE3Mabc2H+rZtug==
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60])
	by mx0b-00190b01.pphosted.com (PPS) with ESMTPS id 4c5xcv1pmq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 16:51:28 +0000 (GMT)
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
	by prod-mail-ppoint5.akamai.com (8.18.1.2/8.18.1.2) with ESMTP id 61ACqQc2026826;
	Tue, 10 Feb 2026 08:51:28 -0800
Received: from email.msg.corp.akamai.com ([172.27.91.40])
	by prod-mail-ppoint5.akamai.com (PPS) with ESMTPS id 4c648futxc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 08:51:28 -0800
Received: from usma1ex-exedge1.msg.corp.akamai.com (172.27.91.34) by
 usma1ex-dag5mb1.msg.corp.akamai.com (172.27.91.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 10 Feb 2026 08:51:27 -0800
Received: from usma1ex-dag5mb2.msg.corp.akamai.com (172.27.91.41) by
 usma1ex-exedge1.msg.corp.akamai.com (172.27.91.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 10 Feb 2026 11:51:27 -0500
Received: from bos-lhvx56.bos01.corp.akamai.com (172.28.222.78) by
 usma1ex-dag5mb2.msg.corp.akamai.com (172.27.91.41) with Microsoft SMTP Server
 id 15.2.2562.29 via Frontend Transport; Tue, 10 Feb 2026 08:51:27 -0800
Received: by bos-lhvx56.bos01.corp.akamai.com (Postfix, from userid 30754)
	id 92E5F15FE0A; Tue, 10 Feb 2026 11:51:27 -0500 (EST)
From: Josh Hunt <johunt@akamai.com>
To: <song@kernel.org>, <yukuai@fnnas.com>, <linan122@huawei.com>,
        <linux-raid@vger.kernel.org>
CC: <ncroxon@redhat.com>, Josh Hunt <johunt@akamai.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] md/raid10: fix deadlock with check operation and nowait requests
Date: Tue, 10 Feb 2026 11:51:26 -0500
Message-ID: <20260210165126.3963677-1-johunt@akamai.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602100140
X-Proofpoint-ORIG-GUID: F34ei3Izttam0qiw_Ti5hHtzs3YWZyTv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDE0MSBTYWx0ZWRfX6ThlStgOkCqC
 J7tWGUzxX1WLe/3YO3w771B4l3RVFBAEGyENu+h2HtaE5M6Ua2/Vp2KdzlLmXeDC1/4WK7s4rmH
 CHfX8LMZ9xpNUgkD3+AIuHMQon00ai2KJsXGqSUtDD/BqmxGerLyQ/pp+ePSgSJm/f6mEljb4l5
 3eBU90VeheHOOpgtDF+WgzLbAUpNgUQJ3Iife8HqtwpvYaJCaDw8tDVF1WlCCGevNZKt4fhL2FX
 LDxIRF19HQogKpzuCf+eQwduuBBpsNQtehdE9fQcABnH/m2AaUnL7g3K198htoaS0sFrqWH9qHa
 0AK+mfXMc4Ru9aqRR1zRUI7nMJfwghZP8URjn+5jhcuThkzp6X/sv+5RkvlFwgaIKNQr+pFkbYD
 1MrAzK6AfgZ5I7iLi8iilE5qt4m3/LCgCP/qeXOmFoX+Y/Pl03CigsRTM8xnXNe52JtFXweBsLZ
 qmBx8mSR1Vm6wsDR2HQ==
X-Proofpoint-GUID: F34ei3Izttam0qiw_Ti5hHtzs3YWZyTv
X-Authority-Analysis: v=2.4 cv=NdPrFmD4 c=1 sm=1 tr=0 ts=698b6210 cx=c_pps
 a=NpDlK6FjLPvvy7XAFEyJFw==:117 a=NpDlK6FjLPvvy7XAFEyJFw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=X7Ea-ya5AAAA:8
 a=yyCKoCU9HyUBiAoV0dgA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 adultscore=0 malwarescore=0
 impostorscore=0 phishscore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602100141

When an array check is running it will raise the barrier at which point
normal requests will become blocked and increment the nr_pending value to
signal there is work pending inside of wait_barrier(). NOWAIT requests
do not block and so will return immediately with an error, and additionally
do not increment nr_pending in wait_barrier(). Upstream change
43806c3d5b9b ("raid10: cleanup memleak at raid10_make_request") added a
call to raid_end_bio_io() to fix a memory leak when NOWAIT requests hit
this condition. raid_end_bio_io() eventually calls allow_barrier() and
it will unconditionally do an atomic_dec_and_test(&conf->nr_pending) even
though the corresponding increment on nr_pending didn't happen in the
NOWAIT case.

This can be easily seen by starting a check operation while an application is
doing nowait IO on the same array. This results in a deadlocked state due to
nr_pending value underflowing and so the md resync thread gets stuck waiting
for nr_pending to == 0.

Output of r10conf state of the array when we hit this condition:

  crash> struct r10conf.barrier,nr_pending,nr_waiting,nr_queued <addr of r10conf>
    barrier = 1,
    nr_pending = {
      counter = -41
    },
    nr_waiting = 15,
    nr_queued = 0,

Example of md_sync thread stuck waiting on raise_barrier() and other requests
stuck in wait_barrier():

md1_resync
[<0>] raise_barrier+0xce/0x1c0
[<0>] raid10_sync_request+0x1ca/0x1ed0
[<0>] md_do_sync+0x779/0x1110
[<0>] md_thread+0x90/0x160
[<0>] kthread+0xbe/0xf0
[<0>] ret_from_fork+0x34/0x50
[<0>] ret_from_fork_asm+0x1a/0x30

kworker/u1040:2+flush-253:4
[<0>] wait_barrier+0x1de/0x220
[<0>] regular_request_wait+0x30/0x180
[<0>] raid10_make_request+0x261/0x1000
[<0>] md_handle_request+0x13b/0x230
[<0>] __submit_bio+0x107/0x1f0
[<0>] submit_bio_noacct_nocheck+0x16f/0x390
[<0>] ext4_io_submit+0x24/0x40
[<0>] ext4_do_writepages+0x254/0xc80
[<0>] ext4_writepages+0x84/0x120
[<0>] do_writepages+0x7a/0x260
[<0>] __writeback_single_inode+0x3d/0x300
[<0>] writeback_sb_inodes+0x1dd/0x470
[<0>] __writeback_inodes_wb+0x4c/0xe0
[<0>] wb_writeback+0x18b/0x2d0
[<0>] wb_workfn+0x2a1/0x400
[<0>] process_one_work+0x149/0x330
[<0>] worker_thread+0x2d2/0x410
[<0>] kthread+0xbe/0xf0
[<0>] ret_from_fork+0x34/0x50
[<0>] ret_from_fork_asm+0x1a/0x30

Fixes: 43806c3d5b9b ("raid10: cleanup memleak at raid10_make_request")
Cc: stable@vger.kernel.org
Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 drivers/md/raid10.c | 40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 9debb20cf129..b05066dde693 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -68,6 +68,7 @@
  */
 
 static void allow_barrier(struct r10conf *conf);
+static void allow_barrier_nowait(struct r10conf *conf);
 static void lower_barrier(struct r10conf *conf);
 static int _enough(struct r10conf *conf, int previous, int ignore);
 static int enough(struct r10conf *conf, int ignore);
@@ -317,7 +318,7 @@ static void reschedule_retry(struct r10bio *r10_bio)
  * operation and are ready to return a success/failure code to the buffer
  * cache layer.
  */
-static void raid_end_bio_io(struct r10bio *r10_bio)
+static void raid_end_bio_io(struct r10bio *r10_bio, bool adjust_pending)
 {
 	struct bio *bio = r10_bio->master_bio;
 	struct r10conf *conf = r10_bio->mddev->private;
@@ -332,7 +333,10 @@ static void raid_end_bio_io(struct r10bio *r10_bio)
 	 * Wake up any possible resync thread that waits for the device
 	 * to go idle.
 	 */
-	allow_barrier(conf);
+	if (adjust_pending)
+		allow_barrier(conf);
+	else
+		allow_barrier_nowait(conf);
 
 	free_r10bio(r10_bio);
 }
@@ -414,7 +418,7 @@ static void raid10_end_read_request(struct bio *bio)
 			uptodate = 1;
 	}
 	if (uptodate) {
-		raid_end_bio_io(r10_bio);
+		raid_end_bio_io(r10_bio, true);
 		rdev_dec_pending(rdev, conf->mddev);
 	} else {
 		/*
@@ -446,7 +450,7 @@ static void one_write_done(struct r10bio *r10_bio)
 			if (test_bit(R10BIO_MadeGood, &r10_bio->state))
 				reschedule_retry(r10_bio);
 			else
-				raid_end_bio_io(r10_bio);
+				raid_end_bio_io(r10_bio, true);
 		}
 	}
 }
@@ -1030,13 +1034,23 @@ static bool wait_barrier(struct r10conf *conf, bool nowait)
 	return ret;
 }
 
-static void allow_barrier(struct r10conf *conf)
+static void __allow_barrier(struct r10conf *conf, bool adjust_pending)
 {
-	if ((atomic_dec_and_test(&conf->nr_pending)) ||
+	if ((adjust_pending && atomic_dec_and_test(&conf->nr_pending)) ||
 			(conf->array_freeze_pending))
 		wake_up_barrier(conf);
 }
 
+static void allow_barrier(struct r10conf *conf)
+{
+	__allow_barrier(conf, true);
+}
+
+static void allow_barrier_nowait(struct r10conf *conf)
+{
+	__allow_barrier(conf, false);
+}
+
 static void freeze_array(struct r10conf *conf, int extra)
 {
 	/* stop syncio and normal IO and wait for everything to
@@ -1184,7 +1198,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	}
 
 	if (!regular_request_wait(mddev, conf, bio, r10_bio->sectors)) {
-		raid_end_bio_io(r10_bio);
+		raid_end_bio_io(r10_bio, false);
 		return;
 	}
 
@@ -1195,7 +1209,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 					    mdname(mddev), b,
 					    (unsigned long long)r10_bio->sector);
 		}
-		raid_end_bio_io(r10_bio);
+		raid_end_bio_io(r10_bio, true);
 		return;
 	}
 	if (err_rdev)
@@ -1240,7 +1254,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	return;
 err_handle:
 	atomic_dec(&rdev->nr_pending);
-	raid_end_bio_io(r10_bio);
+	raid_end_bio_io(r10_bio, true);
 }
 
 static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
@@ -1372,7 +1386,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 
 	sectors = r10_bio->sectors;
 	if (!regular_request_wait(mddev, conf, bio, sectors)) {
-		raid_end_bio_io(r10_bio);
+		raid_end_bio_io(r10_bio, false);
 		return;
 	}
 
@@ -1523,7 +1537,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 		}
 	}
 
-	raid_end_bio_io(r10_bio);
+	raid_end_bio_io(r10_bio, true);
 }
 
 static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
@@ -2952,7 +2966,7 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 			if (test_bit(R10BIO_WriteError,
 				     &r10_bio->state))
 				close_write(r10_bio);
-			raid_end_bio_io(r10_bio);
+			raid_end_bio_io(r10_bio, true);
 		}
 	}
 }
@@ -2987,7 +3001,7 @@ static void raid10d(struct md_thread *thread)
 			if (test_bit(R10BIO_WriteError,
 				     &r10_bio->state))
 				close_write(r10_bio);
-			raid_end_bio_io(r10_bio);
+			raid_end_bio_io(r10_bio, true);
 		}
 	}
 
-- 
2.34.1

