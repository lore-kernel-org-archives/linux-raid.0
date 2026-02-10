Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [67.231.157.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166F621257F;
	Tue, 10 Feb 2026 05:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.157.127
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770702684; cv=none; b=n+gGYDR/fJYwgL+0vhUFw4puqMVWWRpqprRjQASi8Tkby6dMzLqZ/HFbOghzAG2vrS1T7swPwKxPUExL3tlgO2ZuQP6DY5/y+9W/XXJ8345yLaITsgaVsL3i8tQR21WfckO0edPM7yA6jnK8bCWD5ux5Qqq1uGygh/hPc49eCCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770702684; c=relaxed/simple;
	bh=CrAxrGOfINyz0mNJbGSs65GhAsvKmM1rlTR0Y4vgGsM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=u6gl/Z0m5WJilJhFbWL7rfyoXOdgGyDtDivfGEV5nI4SuJBTd5qmQbDnfiel0dUmVvMhSzQIJKEg26g5UfpjLe5Fah6j9I+GvRYiTkMtmiWSp3a3G2m1JUiNDexhLtIqr7so+s/9gieepHHXnqyLchAvhINyj9HO1zbxBimUNH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=akamai.com; spf=pass smtp.mailfrom=akamai.com; dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b=jaFqcAyH; arc=none smtp.client-ip=67.231.157.127
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=akamai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=akamai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b="jaFqcAyH"
Received: from pps.filterd (m0409411.ppops.net [127.0.0.1])
	by m0409411.ppops.net-00190b01. (8.18.1.11/8.18.1.11) with ESMTP id 61A3Tpvq1250456;
	Tue, 10 Feb 2026 05:09:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=jan2016.eng; bh=U9KHZK4t/Ll/7MvTjJW7
	c/3zk4NS5KEo2R/bGrjf3ZM=; b=jaFqcAyHsBt3/D8hnR8RaUVWHWhzGyLxKAwB
	m3yd21UJ29IVHJzeWBmid2jepBc7UYbnOtulXjcK87j9rio6RTBTDLFA4vQCFtax
	LHs5mSpwfTjtPQ1QlVDvh2nWoszq1vm8NK8042PRkp9aE8YSp98NUT6tVkr1AA5s
	guBbZo5rFtkgfl43jGl5caqS0OPjPgjzLWDJrLNRQ8x90OqWVdxqx+4H11fsvNgy
	6EUTpjrKGOEJqjRsRFjV/Wo7fN9A8srKeMs87fltfQmbQ9ahLlqEcIhBN/pkvMxg
	gYXx4OSgFAXrN8Nt1j/C2ckDVtOGCDmAdCTKcqlH06ICsK77Rg==
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18])
	by m0409411.ppops.net-00190b01. (PPS) with ESMTPS id 4c6fm50c0e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 05:09:59 +0000 (GMT)
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
	by prod-mail-ppoint1.akamai.com (8.18.1.2/8.18.1.2) with ESMTP id 61A55a83003396;
	Tue, 10 Feb 2026 00:09:59 -0500
Received: from email.msg.corp.akamai.com ([172.27.91.40])
	by prod-mail-ppoint1.akamai.com (PPS) with ESMTPS id 4c61m3hp4c-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 00:09:58 -0500
Received: from usma1ex-exedge1.msg.corp.akamai.com (172.27.91.34) by
 usma1ex-dag5mb1.msg.corp.akamai.com (172.27.91.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 9 Feb 2026 21:09:55 -0800
Received: from usma1ex-dag5mb1.msg.corp.akamai.com (172.27.91.40) by
 usma1ex-exedge1.msg.corp.akamai.com (172.27.91.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 10 Feb 2026 00:09:55 -0500
Received: from bos-lhvx56.bos01.corp.akamai.com (172.28.222.78) by
 usma1ex-dag5mb1.msg.corp.akamai.com (172.27.91.40) with Microsoft SMTP Server
 id 15.2.2562.29 via Frontend Transport; Mon, 9 Feb 2026 21:09:55 -0800
Received: by bos-lhvx56.bos01.corp.akamai.com (Postfix, from userid 30754)
	id 6622915FE0A; Tue, 10 Feb 2026 00:09:55 -0500 (EST)
From: Josh Hunt <johunt@akamai.com>
To: <song@kernel.org>, <yukuai@fnnas.com>, <linan122@huawei.com>,
        <linux-raid@vger.kernel.org>
CC: <ncroxon@redhat.com>, Josh Hunt <johunt@akamai.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] md/raid10: fix deadlock with check operation and nowait requests
Date: Tue, 10 Feb 2026 00:09:42 -0500
Message-ID: <20260210050942.3731656-1-johunt@akamai.com>
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
 definitions=2026-02-09_01,2026-02-09_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602100039
X-Proofpoint-GUID: LhUpxIfKiQr8nXk-Bmt5YbgwY051-q69
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDA0MSBTYWx0ZWRfX2/ouGncPn35n
 qqjWenAy7cDm6w6Kl0eRU5oCqnpZx2ib+6LIH25LGU4+ixEPR2+Md9Jvlo8WDU4MNfbS8WJ/OVt
 aWnyKrOstyj9TPpB1naK37eC3PYyYtBH9qvNyAX2VsriMdD+eFs3N1AHgathfYgWWj6O8/nK+qy
 f+lmzCyaS+kNgfs7hsxmSnzFhieLklL8+GymoWSwAP+uFbq6mCxfQ+OUbGYQ7vOw4RNsH75LfOW
 TqFyHtzgzVRYhEGp3qosloenFqb8l8sZSLWd04GUUJNTCU25oGLd9qMz5lSX2BqH0ICuQIAIfi7
 68ChnXwI8hz9EIFmzRZUF2B0JNCzLvdBDZoLkSDwyFyox8HX2k7iq1JsTb4SJUnC/jEBdPvA9LS
 wox5x+pNLyB5l4u+Z1Ui4V74HA8+ZvaLJYB1GL+4N5qC6vitrmhsodIm/Kxkr4AI5Rg1HbcnDm/
 zVDqREf1R2t9x3To5QA==
X-Proofpoint-ORIG-GUID: LhUpxIfKiQr8nXk-Bmt5YbgwY051-q69
X-Authority-Analysis: v=2.4 cv=b8y/I9Gx c=1 sm=1 tr=0 ts=698abda7 cx=c_pps
 a=StLZT/nZ0R8Xs+spdojYmg==:117 a=StLZT/nZ0R8Xs+spdojYmg==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=X7Ea-ya5AAAA:8
 a=yyCKoCU9HyUBiAoV0dgA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-09_01,2026-02-09_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 priorityscore=1501 impostorscore=0 suspectscore=0 adultscore=0 clxscore=1011
 phishscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602100041

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

This can be easily seen by starting a check operation while an application
is doing nowait IO on the same array. This results in a deadlocked state
due to nr_pending value underflowing and so the md resync thread gets
stuck waiting for nr_pending to == 0.

Output of r10conf state of the array when we hit this condition:

  crash> struct r10conf.barrier,nr_pending,nr_waiting,nr_queued <addr of r10conf>
    barrier = 1,
    nr_pending = {
      counter = -41
    },
    nr_waiting = 15,
    nr_queued = 0,

Example of md_sync thread stuck waiting on raise_barrier() and other
requests stuck in wait_barrier():

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
 drivers/md/raid10.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 9debb20cf129..184b5b3906d1 100644
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
@@ -1372,7 +1386,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 
 	sectors = r10_bio->sectors;
 	if (!regular_request_wait(mddev, conf, bio, sectors)) {
-		raid_end_bio_io(r10_bio);
+		raid_end_bio_io(r10_bio, false);
 		return;
 	}
 
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

