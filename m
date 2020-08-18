Return-Path: <SRS0=fBal=B4=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA58C433DF
	for <linux-raid@archiver.kernel.org>; Tue, 18 Aug 2020 07:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06ED920658
	for <linux-raid@archiver.kernel.org>; Tue, 18 Aug 2020 07:03:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="LeBYtiLb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgHRHDR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 Aug 2020 03:03:17 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21926 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726365AbgHRHDR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 18 Aug 2020 03:03:17 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07I73G6O029730
        for <linux-raid@vger.kernel.org>; Tue, 18 Aug 2020 00:03:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=L0PNibd2KaVJ692BBKDLQ4EPIirvlDr5NvLkhs+Sf7A=;
 b=LeBYtiLbYYl/zVZx9fHNGCPe/xjHn0h9furYtxVLYMOxNJPN9KcaEX5rOJ9qZdXOsbqy
 zYAIHvxVpjW747rBvckSwlfvD/Mg2QrBTjtHcbUAp9Cy/auDq1gGt3l1Eehr6YsgPMM1
 P/qqW22rhUgEoTxMZUh13PN3Y55J2m4rdKI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304p7s6cj-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-raid@vger.kernel.org>; Tue, 18 Aug 2020 00:03:16 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 00:02:50 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 16C3462E54B8; Tue, 18 Aug 2020 00:02:46 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <linux-block@vger.kernel.org>, <linux-raid@vger.kernel.org>,
        <linux-bcache@vger.kernel.org>
CC:     <colyli@suse.de>, <axboe@kernel.dk>, <kernel-team@fb.com>,
        <song@kernel.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH 0/4] block: improve iostat for md/bcache partitions
Date:   Tue, 18 Aug 2020 00:02:34 -0700
Message-ID: <20200818070238.1323126-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_04:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 adultscore=0 priorityscore=1501 malwarescore=0 mlxlogscore=581
 clxscore=1015 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008180049
X-FB-Internal: deliver
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Currently, devices like md, bcache uses disk_[start|end]_io_acct to repor=
t
iostat. These functions couldn't get proper iostat for partitions on thes=
e
devices.

This set resolves this issue by introducing part_[begin|end]_io_acct, and
using them in md and bcache code.

Song Liu (4):
  block: expose disk_map_sector_rcu() and hd_struct_put in genhd.h
  block: introduce part_[begin|end]_io_acct
  md: use part_[begin|end]_io_acct instead of disk_[begin|end]_io_acct
  bcache: use part_[begin|end]_io_acct instead of
    disk_[begin|end]_io_acct

 block/blk-core.c            | 20 ++++++++++++++++----
 block/blk.h                 |  8 --------
 block/genhd.c               |  1 +
 drivers/md/bcache/request.c | 14 ++++++++++----
 drivers/md/md.c             |  8 ++++++--
 include/linux/blkdev.h      |  5 +++++
 include/linux/genhd.h       |  8 ++++++++
 7 files changed, 46 insertions(+), 18 deletions(-)

--
2.24.1
