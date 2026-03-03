Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [67.231.149.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7845F54654;
	Tue,  3 Mar 2026 00:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.149.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772499437; cv=none; b=kFSjcR8BVzzd60nGare/bF4uJcftiJ45w7gV+lM+BV/DRVqHK1kmrJ9FIVf60w0mNTzYXyNgQ1x20omFLyWs5AwISM4Oh3oHWZUKnMHXEGz1EDNGkZKPP9x4d2N/ZUscnWg9q0yLdZigFbhHmqt/Rln/WU1Id795hn6mSXZgHv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772499437; c=relaxed/simple;
	bh=PtYj828HmzWP87pDmMZUpmkjR4O5W7enclaueQIa4r8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LGrbSZJCAgdKiGyeOsOm6YC5oMpD6fcPlKrXVKvVQq55pz94golYhGoSDkfD//0xLOT7Q1gLDTF2yizipR3K+e8KYicZguLNjoV93JNdFkkFRVJTIVg+QFtC2/HLtIpSnA8XLWXb5Ci1TluDil/apjgTS/POjPwOGoLcrVSeBug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=akamai.com; spf=pass smtp.mailfrom=akamai.com; dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b=D4lDqn9v; arc=none smtp.client-ip=67.231.149.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=akamai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=akamai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b="D4lDqn9v"
Received: from pps.filterd (m0050093.ppops.net [127.0.0.1])
	by m0050093.ppops.net-00190b01. (8.18.1.11/8.18.1.11) with ESMTP id 6229iLxs3693597;
	Tue, 3 Mar 2026 00:56:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=jan2016.eng; bh=/BH3wh03RzKCBosuiQet
	YyKo6+5v4tnvbpfPuSrbba0=; b=D4lDqn9vl6Z1ST+Rnw+MStUaVkMtl72g2/dl
	M0yEM3OkudSA/3bH9+x8wFfx3jQ+aWaOhOLdmDNf+HVeAIOmMtvL9ubBWuU+A3Ds
	wmJMRNnHwYPmoBiKlXmQTJeen/jdZuU6V8VKWjh3LBHwum1INwyPIW1TCcxApUmZ
	lOLgSxdd5Ax9s50py07VyK7ywEzYVb3ciZm648luVdM+gcqN42biV8NEVpO9L4fq
	gpYoZyxcHyNLDjkv//I6kefPQc01QoqQESXWkcnJJtIvuT2XlecxFJJFmij4IC2P
	jRt93WGd3iMYdEo+mwn4fmIiWpVj4bFTTpDSHlN5SED2YYizIg==
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60])
	by m0050093.ppops.net-00190b01. (PPS) with ESMTPS id 4cksh8nram-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Mar 2026 00:56:25 +0000 (GMT)
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
	by prod-mail-ppoint5.akamai.com (8.18.1.7/8.18.1.7) with ESMTP id 6230nEr0004861;
	Mon, 2 Mar 2026 16:56:24 -0800
Received: from email.msg.corp.akamai.com ([172.27.91.40])
	by prod-mail-ppoint5.akamai.com (PPS) with ESMTPS id 4cky7aa1q0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Mar 2026 16:56:24 -0800 (PST)
Received: from usma1ex-exedge1.msg.corp.akamai.com (172.27.91.34) by
 usma1ex-dag5mb1.msg.corp.akamai.com (172.27.91.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 2 Mar 2026 16:56:23 -0800
Received: from usma1ex-dag5mb2.msg.corp.akamai.com (172.27.91.41) by
 usma1ex-exedge1.msg.corp.akamai.com (172.27.91.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 2 Mar 2026 19:56:23 -0500
Received: from bos-lhvx56.bos01.corp.akamai.com (172.28.222.78) by
 usma1ex-dag5mb2.msg.corp.akamai.com (172.27.91.41) with Microsoft SMTP Server
 id 15.2.2562.29 via Frontend Transport; Mon, 2 Mar 2026 16:56:23 -0800
Received: by bos-lhvx56.bos01.corp.akamai.com (Postfix, from userid 30754)
	id 7992715FB47; Mon,  2 Mar 2026 19:56:23 -0500 (EST)
From: Josh Hunt <johunt@akamai.com>
To: <song@kernel.org>, <yukuai@fnnas.com>, <linan122@huawei.com>,
        <linux-raid@vger.kernel.org>
CC: <ncroxon@redhat.com>, Josh Hunt <johunt@akamai.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v3] md/raid10: fix deadlock with check operation and nowait requests
Date: Mon, 2 Mar 2026 19:56:19 -0500
Message-ID: <20260303005619.1352958-1-johunt@akamai.com>
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
 definitions=2026-03-02_05,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxlogscore=810
 mlxscore=0 phishscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2602130000 definitions=main-2603030002
X-Authority-Analysis: v=2.4 cv=RZidyltv c=1 sm=1 tr=0 ts=69a631b9 cx=c_pps
 a=NpDlK6FjLPvvy7XAFEyJFw==:117 a=NpDlK6FjLPvvy7XAFEyJFw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Ifg-1AOnLHOf1gn6spyb:22
 a=d4nn1RXdvEacMIURMw2s:22 a=VwQbUJbxAAAA:8 a=X7Ea-ya5AAAA:8
 a=ijEJ2_E4PAzkDUWKhJIA:9
X-Proofpoint-GUID: _Wnf0NDQyDk2O2OOYPDysZ-roVRwLsOW
X-Proofpoint-ORIG-GUID: _Wnf0NDQyDk2O2OOYPDysZ-roVRwLsOW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDAwMiBTYWx0ZWRfXwBLxfO9jlBsl
 sSVCKcVztlvclgDCTy+76qBSP02WbRgVR6Mp3bSTJYuuFZoJAv+a8rndKrHIXLAj7AYK49C9tMA
 soEqIg1nWLCY4YGkj5jK487Sb9irvtiil/74SuRxLPpODH0MVm7KvoAhSmeDPDF3QxaeberEyzS
 6KHY+VTi39RlZCWhUdCdnTIeqst5KGp6cSL9wi8hfKno8b2eXOaKV86oUr0kDe8y3uEv8gbuEwo
 CxfO9Ltf4LvntB/tc9QsuSweM9LGuzlV+Ir6v/lGQpfyHLp6VF5RI344BJvtXOWWXb7eYTAhWBx
 P7z/m+cH8+igr/OkQmFap2hEuEloIo4VFZM6DfhRtnUNO7cxyh4Mk1yMHDeOq+IG8z31+eUKBpl
 Dl5lKmN8RVMxnby5I2rpO2ZuP7WAM6VaHG9+hZD9F8kHy85Mn6ynIT8RXsQgZzvfr6OZ7/K9cqw
 rEmtwfE/iEsHLXKEDug==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603030002

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
v3:
  * Call free_r10bio() as per Yu Kuai's suggestion
---
 drivers/md/raid10.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 9debb20cf129..b4892c5d571c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1184,7 +1184,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	}
 
 	if (!regular_request_wait(mddev, conf, bio, r10_bio->sectors)) {
-		raid_end_bio_io(r10_bio);
+		free_r10bio(r10_bio);
 		return;
 	}
 
@@ -1372,7 +1372,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 
 	sectors = r10_bio->sectors;
 	if (!regular_request_wait(mddev, conf, bio, sectors)) {
-		raid_end_bio_io(r10_bio);
+		free_r10bio(r10_bio);
 		return;
 	}
 
-- 
2.34.1

