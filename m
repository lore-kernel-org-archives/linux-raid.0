Return-Path: <SRS0=7JT0=CJ=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA155C43461
	for <linux-raid@archiver.kernel.org>; Mon, 31 Aug 2020 22:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C633F207EA
	for <linux-raid@archiver.kernel.org>; Mon, 31 Aug 2020 22:27:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="MlnaZcRt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgHaW1h (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 31 Aug 2020 18:27:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62072 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728103AbgHaW1h (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 31 Aug 2020 18:27:37 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07VMQS7u031776
        for <linux-raid@vger.kernel.org>; Mon, 31 Aug 2020 15:27:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=z6WL8UWgQAUu/M6UTZaBAZ2XUzRAgbJPvJ1bCcFa+N8=;
 b=MlnaZcRtxEZ+wkNuePrf0VhtAzcO8Rg4q37aSRmRuyFvcrt8vJCTWdh85BsGplDUn0v4
 MMxcDujlxGTOyTs33QVb8A4yTsOBWMd9jXdNdaUJ3law4HEniiN6I++by1Jg8WcEpajY
 iRzVYJCo0upmop+I3iJj5idcKtZuFDl5XUI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 338734f99j-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-raid@vger.kernel.org>; Mon, 31 Aug 2020 15:27:36 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 31 Aug 2020 15:27:35 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id E87F762E51BC; Mon, 31 Aug 2020 15:27:32 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <linux-block@vger.kernel.org>, <linux-raid@vger.kernel.org>,
        <linux-bcache@vger.kernel.org>
CC:     <colyli@suse.de>, <axboe@kernel.dk>, <kernel-team@fb.com>,
        <song@kernel.org>, <hch@infradead.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v3 0/3] block: improve iostat for md/bcache partitions
Date:   Mon, 31 Aug 2020 15:27:22 -0700
Message-ID: <20200831222725.3860186-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_10:2020-08-31,2020-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 suspectscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=562 priorityscore=1501 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310132
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

Changes v2 =3D> v3:
1. Use EXPORT_SYMBOL_GPL() instead of EXPORT_SYMBOL().
2. Include Christoph's Reviewed-by tag.

Changes v1 =3D> v2:
1. Refactor the code, as suggested by Christoph.
2. Include Coly's Reviewed-by tag.

Song Liu (3):
  block: introduce part_[begin|end]_io_acct
  md: use part_[begin|end]_io_acct instead of disk_[begin|end]_io_acct
  bcache: use part_[begin|end]_io_acct instead of
    disk_[begin|end]_io_acct

 block/blk-core.c            | 39 +++++++++++++++++++++++++++++++------
 drivers/md/bcache/request.c | 10 ++++++----
 drivers/md/md.c             |  8 ++++----
 include/linux/blkdev.h      |  5 +++++
 4 files changed, 48 insertions(+), 14 deletions(-)

--
2.24.1
