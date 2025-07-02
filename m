Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F3923D2A4;
	Wed,  2 Jul 2025 09:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751447493; cv=none; b=QlJBZsLNov32UGJNNkxoeU7KnxDInB2bqCD0tQDunEPS/TJAu7HQ+RlCXqc7J6lKNnv87GZa50eBv5VpXjymcc6tOF8s9XKehEvSMDizy8rgnCCCSINNfuWUULh04vslcAHF4YIJeEvDbKX3BcZuAgzEFAdECQidu+bjFhVZEZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751447493; c=relaxed/simple;
	bh=gb9PArGeVtVBJceqS5jT/2Pe/gOdat2eaUjsNLZ204E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=o1QhKAqZ2uWrGI+n4Qu/Iq0XB78qDi8/dWUcvZFFO5nZs97A0LNaAEUw5XlqEq1+6o7or2TKCT263X6rWeNZg46Yq1ISWXQT995fBr2KSn4RrD5r7yla8gfWunYs0mXp5gTvU2vD/ADQ/9t0rVnH8ujl8mF+d33SVgVkTDBSj9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aXMmvAqm; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aXMmvAqm"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5627Mamw026815;
	Wed, 2 Jul 2025 09:10:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=4dBOpWr8id00dZ4J
	PyVc8gbGRIWehHNPoJUiC+hXwHw=; b=aXMmvAqm2HSkl4z/OZn/BOTlupo7hCK5
	XofZ+0om8ZfoVOvivruvtRS8uYeYxBZztTcMg0knGLzh2Xrht+Mn0Xjt1RKXMpQ4
	Xbsi1aqCSF1IUepJU1zPEiXQG5e11znV1qUAssl7IZdbIaFVobqpP7YfV6X4VDzA
	WUhDB1hlqP3MxegPkd9vYrTgRFAarIQeM+Bx8mkNvBYzGPX2XhEduNwgFBGgwHBz
	vjqVA10Rs2KryE7auE+zzzayH7YxNT82NZ3IGYWaI/Idk+uRy+mC63iqbnsskrbV
	7HhCFR1W5UdSzTUui5qkJhwC81AaU9jmHswtjQynAP0olsjbuxiRog==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47j6tfefjs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Jul 2025 09:10:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5628UG43033801;
	Wed, 2 Jul 2025 09:10:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47j6uaxyse-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Jul 2025 09:10:41 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5629Afp3033109;
	Wed, 2 Jul 2025 09:10:41 GMT
Received: from lab61.no.oracle.com (lab61.no.oracle.com [10.172.144.82])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 47j6uaxypg-1;
	Wed, 02 Jul 2025 09:10:40 +0000
From: =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        Zheng Qixing <zhengqixing@huawei.com>
Cc: stable@vger.kernel.org, Gerald Gibson <gerald.gibson@oracle.com>,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] md/md-bitmap: fix GPF in bitmap_get_stats()
Date: Wed,  2 Jul 2025 11:10:34 +0200
Message-ID: <20250702091035.2061312-1-haakon.bugge@oracle.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-02_01,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507020073
X-Authority-Analysis: v=2.4 cv=CMMqXQrD c=1 sm=1 tr=0 ts=6864f792 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=M51BFTxLslgA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=ff15VUUy24FoKP-N-78A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 4R6cwTqIV5KDWNyL6OkaUxTpg5Vebak7
X-Proofpoint-ORIG-GUID: 4R6cwTqIV5KDWNyL6OkaUxTpg5Vebak7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAyMDA3MyBTYWx0ZWRfX4AKsRvmrnLRv 1cNOopFv04eSWZHqgo3LalLefSEubeVK5iV/tr+rR1jbz/0qzi9/wI2dImLLfbwpVQVhUPyNwOF aQm6JJgr4MIJ0sVqSg3FUwlSDbSeAkbfjlISUAsSlnkKPXQm/5WKFKsb40KYGj95nju4DfSiUoo
 HmDyCoQ2KFuBxj76+JI3sG8t6kzCxARIU1ma8LI5SG2eODo+aFocs66t3EIl/1gAG8ysuuNejFq LY3AnAyy7VJao7hurduXbDxzcGqpz7jKf4f6j82YHB0NHaQApM4htZs1O7ZvT1C/Y47Q9D0Jnc/ cGYme1iulurA4OX6oW2tszhDOvr1RR+Z8zfbj9djogtDBt2CFU89dDPxZ4CHsN+7dSmGt6bNT0Y
 TgEzeETz4uNQ2n+WXUT9A/2RoHcqtt1/D5nSklCmIDoQTWoq4WdhoTaS5trjx1F6ICJAv1dt

The commit message of commit 6ec1f0239485 ("md/md-bitmap: fix stats
collection for external bitmaps") states:

    Remove the external bitmap check as the statistics should be
    available regardless of bitmap storage location.

    Return -EINVAL only for invalid bitmap with no storage (neither in
    superblock nor in external file).

But, the code does not adhere to the above, as it does only check for
a valid super-block for "internal" bitmaps. Hence, we observe:

Oops: GPF, probably for non-canonical address 0x1cd66f1f40000028
RIP: 0010:bitmap_get_stats+0x45/0xd0
Call Trace:

 seq_read_iter+0x2b9/0x46a
 seq_read+0x12f/0x180
 proc_reg_read+0x57/0xb0
 vfs_read+0xf6/0x380
 ksys_read+0x6d/0xf0
 do_syscall_64+0x8c/0x1b0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

We fix this by checking the existence of a super-block for both the
internal and external case.

Fixes: 6ec1f0239485 ("md/md-bitmap: fix stats collection for external bitmaps")
Cc: stable@vger.kernel.org
Reported-by: Gerald Gibson <gerald.gibson@oracle.com>
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
---
 drivers/md/md-bitmap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index bd694910b01b0..7f524a26cebca 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2366,8 +2366,7 @@ static int bitmap_get_stats(void *data, struct md_bitmap_stats *stats)
 
 	if (!bitmap)
 		return -ENOENT;
-	if (!bitmap->mddev->bitmap_info.external &&
-	    !bitmap->storage.sb_page)
+	if (!bitmap->storage.sb_page)
 		return -EINVAL;
 	sb = kmap_local_page(bitmap->storage.sb_page);
 	stats->sync_size = le64_to_cpu(sb->sync_size);
-- 
2.43.5

