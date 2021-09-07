Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AE12C433EF
	for <linux-raid@archiver.kernel.org>; Tue,  7 Sep 2021 23:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0EA861131
	for <linux-raid@archiver.kernel.org>; Tue,  7 Sep 2021 23:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343580AbhIGXEy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Sep 2021 19:04:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19824 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240690AbhIGXEy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Sep 2021 19:04:54 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 187N16oU002201
        for <linux-raid@vger.kernel.org>; Tue, 7 Sep 2021 16:03:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=VUoTFlhx6ooKf/JHMPEG/qv91AtQXS7pbRLQledGpaQ=;
 b=UPDdqF0tSI/W7Rz6qhiR8ONWgNI9TtvMPgoJLqlpJawBDYQis8M+dbh9Dwr2d1tkgBVZ
 wDZw78fUfKTv9MS3cS32RvdnEKRD+RVWspUCYa0ZFD1CWJYyTQQnUb6n3q3NoUnSoCFe
 nYdFqspxyEiZ+33WnwNs2uO7e7ed/FxUI38= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3axcmw1ua4-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-raid@vger.kernel.org>; Tue, 07 Sep 2021 16:03:47 -0700
Received: from intmgw002.06.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 7 Sep 2021 16:03:45 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 96F8E102AA260; Tue,  7 Sep 2021 16:03:40 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <linux-block@vger.kernel.org>, <linux-raid@vger.kernel.org>
CC:     <axboe@kernel.dk>, <marcin.wanat@gmail.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH] blk-mq: allow 4x BLK_MAX_REQUEST_COUNT at blk_plug for multiple_queues
Date:   Tue, 7 Sep 2021 16:03:38 -0700
Message-ID: <20210907230338.227903-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: arWs76SJg9GcCOqF6Pig889SlEuDKCYa
X-Proofpoint-GUID: arWs76SJg9GcCOqF6Pig889SlEuDKCYa
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-07_08:2021-09-07,2021-09-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=680 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0
 mlxscore=0 priorityscore=1501 clxscore=1015 suspectscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109070145
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Limiting number of request to BLK_MAX_REQUEST_COUNT at blk_plug hurts
performance for large md arrays. [1] shows resync speed of md array drops
for md array with more than 16 HDDs.

Fix this by allowing more request at plug queue. The multiple_queue flag
is used to only apply higher limit to multiple queue cases.

[1] https://lore.kernel.org/linux-raid/CAFDAVznS71BXW8Jxv6k9dXc2iR3ysX3iZRB=
ww_rzA8WifBFxGg@mail.gmail.com/
Tested-by: Marcin Wanat <marcin.wanat@gmail.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 block/blk-mq.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 2c4ac51e54eba..d4025c15bd108 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2155,6 +2155,18 @@ static void blk_add_rq_to_plug(struct blk_plug *plug=
, struct request *rq)
 	}
 }
=20
+/*
+ * Allow 4x BLK_MAX_REQUEST_COUNT requests on plug queue for multiple
+ * queues. This is important for md arrays to benefit from merging
+ * requests.
+ */
+static inline unsigned short blk_plug_max_rq_count(struct blk_plug *plug)
+{
+	if (plug->multiple_queues)
+		return BLK_MAX_REQUEST_COUNT * 4;
+	return BLK_MAX_REQUEST_COUNT;
+}
+
 /**
  * blk_mq_submit_bio - Create and send a request to block device.
  * @bio: Bio pointer.
@@ -2251,7 +2263,7 @@ blk_qc_t blk_mq_submit_bio(struct bio *bio)
 		else
 			last =3D list_entry_rq(plug->mq_list.prev);
=20
-		if (request_count >=3D BLK_MAX_REQUEST_COUNT || (last &&
+		if (request_count >=3D blk_plug_max_rq_count(plug) || (last &&
 		    blk_rq_bytes(last) >=3D BLK_PLUG_FLUSH_SIZE)) {
 			blk_flush_plug_list(plug, false);
 			trace_block_plug(q);
--=20
2.30.2

