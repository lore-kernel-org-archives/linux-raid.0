Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A41BC433E0
	for <linux-raid@archiver.kernel.org>; Wed,  3 Feb 2021 00:24:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C12F64E39
	for <linux-raid@archiver.kernel.org>; Wed,  3 Feb 2021 00:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbhBCAYT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Feb 2021 19:24:19 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:42201 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231918AbhBCAYR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Feb 2021 19:24:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1612311790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=9B30GlzX0j1WSN7DQD+J6k4bYyAaGV1chg6Lqxz3Wfg=;
        b=UPWRGf0EzyjeW4SaXQZCZt8CoRUicpAwPQEU+YxNYIFmfkOaA3e8VZpfTBJaO79qv5weM5
        T4UMmTyN/97hsqcC2NJXVFOtZLWR+ySoAtd575SGwH8WvvqUwRo0GTxSjFsyBFvZCNIo1p
        MvzB6oPZVoRIPUBMFRmTk7UM8N/j4DU=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2054.outbound.protection.outlook.com [104.47.14.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-14-NK6tB5doOiuFFBCAvRxV9Q-1; Wed, 03 Feb 2021 01:23:08 +0100
X-MC-Unique: NK6tB5doOiuFFBCAvRxV9Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HLIHnb9HZq9XimY2zgELmPftsL7nFTQwnYc9TuajTCrkbHdw3jGNoPDVY5uf+enwKZ84LUh4qqiz+9MmUrvd0Ur2YfNtsPbq1qb+8EBPvLaLeu5z8B3SFedLQ/OWcyh8801cT+BfN1tCLGq+d+pZQNfOUCjRzBI0wWOWrdb8p1fixqLjT3XFqkc44qcfvVE8p3uaeoGdXqxOIL7VTBlVf/14rglRUwH6nVBNIvN7NSOE7S9Sgm0gXj68pokrRV7JgIUyhUKBS6u08JW7/m/AZTdmcAgPg2PCXJIr0hbZDpJB9qySj9GmcYMYzLq5g2hIQt4PW1rmphNTQ7bVNeZsvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9B30GlzX0j1WSN7DQD+J6k4bYyAaGV1chg6Lqxz3Wfg=;
 b=kiqn4YVM2c0tdMK2C/e+npTHwuaBwkfwI7gVmggWYK2sICbevNtgWmhMV8XxZWV3m16diQ9sYrPSTFkP8fOWr50+QpDSjk8VB0AdPBjnEA/Qc2e4q4Dsv6uX/a/FqX0GzajPX3IrLApCZcm1q39Rj7NjEajfVKZvcY7W6xuiMJnz8S/cBmlXLqkkb4ZYZrAv+0x9BU7DpNQqVnzC63mfyr8iPLLWNVauBkl3g8ErldHWQrYO5hA5Hc+2Cx4mZSNhTDnDHgvrLU0BHlMmHGMnEFzKLb1viORN9Rrag1wjh0u4XZXodb2gDwAGYZYncupUeZnOqg19OfYN/4nDjAqq6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB8PR04MB7002.eurprd04.prod.outlook.com (2603:10a6:10:119::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.19; Wed, 3 Feb 2021 00:23:07 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::dd78:1e78:3ad2:9d7e]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::dd78:1e78:3ad2:9d7e%6]) with mapi id 15.20.3805.024; Wed, 3 Feb 2021
 00:23:07 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, jes@trained-monkey.org
Cc:     Zhao Heming <heming.zhao@suse.com>, xni@redhat.com,
        lidong.zhong@suse.com
Subject: [PATCH v2] super1.c: avoid useless sync when bitmap switches from clustered to none
Date:   Wed,  3 Feb 2021 08:22:51 +0800
Message-Id: <1612311771-17411-1-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [123.123.133.229]
X-ClientProxiedBy: HK2PR04CA0077.apcprd04.prod.outlook.com
 (2603:1096:202:15::21) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.133.229) by HK2PR04CA0077.apcprd04.prod.outlook.com (2603:1096:202:15::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Wed, 3 Feb 2021 00:23:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4acde7d-51cb-4a6b-327a-08d8c7d9e130
X-MS-TrafficTypeDiagnostic: DB8PR04MB7002:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB7002AE7BA5D5ABDA86039A3997B49@DB8PR04MB7002.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:238;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LlyJ/NyxSFtGZiiyc75ONKqNB6pKQxRHX5EhdMG+r/DioEGp8CITnNL0sTA7TAdorD+9Q6dqjZVJNr8fYP1XEVJ3skeHhur66exMJEGEdwMRa+roXli8y7cxZ/T1NejrSeU3I/KyMwdJL62aqkiNWAHsK+OSOZIgWAfjAdkNkCYMw+a+rPUmKUC8ptw6M2gdGXL63qSg4pv2MmbEP6u79w1OzRtlwMz4tU/uXHldBFg9MZGbTkpfE+3EMGop8zlswIU/ffKmLXuvPiP/WtZdzOifPFwuWEgrvmVPAy8g/UKcCFgCMLyhNucOBo1lSgHFTJ1fOaDfL6MP+1dU8DdGHkmeMXeANwum8Mox2CP0avchZb0+AmTa2wphWjED3jT8ViNkxp2SUWos/q9913830I+6rBJeqjp5JliVGUFxp76+Rpge9wDk3w6Qw16jwqm6rRklBIeggpguf9wQVrg4TL5Ub1iAOrWnvIDD+TnOWi3/vIEINLtxCIhRFm3sRCqGVIbHH1Tsr3UTvH186KEIhbvHbftKNUxFwKt7vnLrXe0JtTZ0yTDbus2CaWiiNXv8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(396003)(136003)(39860400002)(478600001)(6512007)(8936002)(36756003)(2906002)(26005)(8676002)(83380400001)(6486002)(6666004)(66476007)(52116002)(4326008)(107886003)(956004)(16526019)(86362001)(6506007)(5660300002)(66556008)(66946007)(316002)(2616005)(186003)(8886007)(9126006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/3cRQNNRIVxaTej6ZDn5TCl1Rum2fDvIR65YvQ+drri+56McOw0fu1wDS8tT?=
 =?us-ascii?Q?XhVsiUKVO5toENeROBlTha3TmjZZxJZsMIC8j+TGTI0DVIQ80/x1touYs/jz?=
 =?us-ascii?Q?MszRCDCyR/lr6R5F11DclnZYQVNvHN5Sg028Wqr1ECCaPwkMvabR+TOnrEWk?=
 =?us-ascii?Q?MIjZ8mCJhY9BmZPjEvVKiUld3OgIZEDxMCIPLvNCfJh7XPQBWCmb4c8wxq/f?=
 =?us-ascii?Q?tSUblT96O5KRFURsjv4l48Vh+46TpAe7EImP7WJ1J8Q7Rjfj5ZRhLdtkkp0c?=
 =?us-ascii?Q?St9vwo+Wq7YU1yEngJ4HpsMUrB6l0BydEsbD3uqJBekGnxuc3Z9eens++AtK?=
 =?us-ascii?Q?sNuRCHFwOZa2Jt+Ee9GItbpGxGV9norh4hg97S3VsdA3e9JOQEz/bNW7wv2A?=
 =?us-ascii?Q?qLyoAxzSwITLFp9z6WPeyrfehCPxiw5aFytno4XbUlJBbpX2CSLHios9Zlyn?=
 =?us-ascii?Q?hHfItUSlRCt4XIC8/HKzzKMZUk8gzxpP6yflJRneQl/wfOiP8aKjYUfK3wkm?=
 =?us-ascii?Q?LPPdu+RDSrD/s6T8UBbv2R7nsBYaADStd66LeNyrPz7usKUW7IEac7f0Y42+?=
 =?us-ascii?Q?ogMEpJkhmYx9xaMSofGxE5jW9BJoOsrYV0MuIrfASiV5x2+q0VBd/wBtIm29?=
 =?us-ascii?Q?8mroX1qv3LkNI+tiv2f+PLblOWgR2Qm0hdmxZ8i1R8QvtSnYaPt7mxfeMeK2?=
 =?us-ascii?Q?93Vn7hwi9iCXBoe0aTK1btF4ZWtRmkplpJyE3VAJguJOmpN7+0YEOtXsy2Q1?=
 =?us-ascii?Q?Dq84u+OvZMAyX/72oxFVaOgaj4OJPc5ljLPnnTf/7gZ1Wde2Pdj66bcAXmAF?=
 =?us-ascii?Q?btSrtqoRSnu1vN/Dkkjpukvft2fnv9UMbmPeaBdtbYKbBo/pfLfBFAXr5JBM?=
 =?us-ascii?Q?eIAZgYC58vjwrY/SXnFtFxM3d7IgZBJtvNp5k0qMEwblUljnJvftAEmZgoxh?=
 =?us-ascii?Q?H6XPtDlFulv/g0C8PTQ0hp7ylMc1fcZQQFbsx8gINAf7WvRn6ougzJddnnlO?=
 =?us-ascii?Q?3QPFppqLUdum1se03VU8HXfudI61X3+skHkrgLBVMBB39y0mIQhGAZ+cllfX?=
 =?us-ascii?Q?QbvLRHtm?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4acde7d-51cb-4a6b-327a-08d8c7d9e130
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 00:23:07.7205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lrCRusIPrPbjSzqdmz2CBpijWQzIcr6MRxHxT0+KZGXxhkT/U/Ei7I9s8xK7SpDHk0se2VWQ7u4l4dxhd9rLzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7002
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

With kernel commit 480523feae58 ("md: only call set_in_sync() when it
is expected to succeed."), mddev->in_sync in clustered array is always
zero. It makes metadata resync_offset to always zero.
When assembling a clusterd array with "-U no-bitmap" option, kernel
md layer "mddev->resync_offset == 0" and "mddev->bitmap == NULL" will
trigger raid1 do sync on every bitmap chunk. the sync action is useless,
we should avoid it.

Related kernel flow:
```
md_do_sync
 mddev->pers->sync_request
  raid1_sync_request
   md_bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, 1)
    __bitmap_start_sync(bitmap, offset,&blocks1, degraded)
      if (bitmap == NULL) {/* FIXME or bitmap set as 'failed' */
        *blocks = 1024;
        return 1; /* always resync if no bitmap */
      }
```

Reprodusible steps:
```
node1 # mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sd{a,b}
node1 # mdadm -Ss
(in another shell, executing & watching: watch -n 1 'cat /proc/mdstat')
node1 # mdadm -A -U no-bitmap /dev/md0 /dev/sd{a,b}
```

Signed-off-by: Zhao Heming <heming.zhao@suse.com>
---
v2: only set MaxSector on bitmap clean device
 
---
 super1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/super1.c b/super1.c
index 19fe6f5..9470025 100644
--- a/super1.c
+++ b/super1.c
@@ -1318,6 +1318,8 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 			memcpy(bms->uuid, sb->set_uuid, 16);
 	} else if (strcmp(update, "no-bitmap") == 0) {
 		sb->feature_map &= ~__cpu_to_le32(MD_FEATURE_BITMAP_OFFSET);
+		if (bms->version == BITMAP_MAJOR_CLUSTERED && !IsBitmapDirty(devname))
+			sb->resync_offset = MaxSector;
 	} else if (strcmp(update, "bbl") == 0) {
 		/* only possible if there is room after the bitmap, or if
 		 * there is no bitmap
-- 
2.30.0

