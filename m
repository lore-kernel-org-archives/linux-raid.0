Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EAB5C433E0
	for <linux-raid@archiver.kernel.org>; Tue,  2 Feb 2021 19:41:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC5D364E56
	for <linux-raid@archiver.kernel.org>; Tue,  2 Feb 2021 19:41:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbhBBThO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Feb 2021 14:37:14 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:41528 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233342AbhBBNzM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Feb 2021 08:55:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1612274044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=ECiPwRNPv42EAeOAakZBZ395NKaTndS8J/wR+1/37x0=;
        b=juHFcgnBQDeQoGhZ2A+vhK7j/eK7RXckdWzmw87SOLzbA6+VmZPtzksz+Pet1oWOaQ5YCt
        xK+0bR1qUQkPgQ4y1iy7aA4AZPqHL4uMAiUnSVUvrwCGajitRGKvciroieL/HLgzG2upkk
        oKn8tKs2DppZ8ylJMy2ememai8odxkI=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2172.outbound.protection.outlook.com [104.47.17.172])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-30-As2Pd5MAMzCIrwzlz6KcfA-1; Tue, 02 Feb 2021 14:54:02 +0100
X-MC-Unique: As2Pd5MAMzCIrwzlz6KcfA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T/mIjU+vMcm8NlsTxKpfEOUvbSQmW2sE5uO4+hXY73jjeYwaN+S2u+KvtJHU3JvVfbFMYUb/a53gkXxStKZALVQvBQ4UsFlRt6VlcibcHPPDHqrOnKLe9QkuJTfIaHCPn1e96WPg2De5lFqXPMeo3ezLuN1Pn+qPcyNcXThBTs1bK7dxVDclCUI79WrYh4mszZDw3S0ALizXwzh5zcI8Om+aZgmjIJmLgL6DwAJZQtINIISIczjnwE0nsP+9oiotp8juPHTAWgYQqdxtqFS604/8Cfzi8WliyKUqlmN8Uio7I6OagUv5HnM7fo7C7Sh+Uv7Sk84lFj8WNfacbBIdPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ECiPwRNPv42EAeOAakZBZ395NKaTndS8J/wR+1/37x0=;
 b=izIjTqNm1uEoG3/CaUtkYncGytgYkbXxqa6m10B3PpZIJ7RDH2ybVkO/AsnUhl0nYoOrVH7/D8thT+6sg40YkXNpvbkUqVBNtS3uXv97DkurXrq3CtIN7dDFJbSAFrlOIY1HDKn4eOCPrNa95mHgnMXLQ3NtUeXxhZZTzFXu+F9h48Z2GeGZV/Sw3nR36cPJ3O5wlkoFsKwIEPks2fm7dc23h4PJZIOPNt6865FKTRekWo5/mFFMVDp+XP7N6DHz/YxFFUEjj+LMLj5/QcL72RAwXBJKnG4LKx6+1KRDhMmKRN8tmlNGNqS5MbXcGooAAcajSO3SlfpJT9jy23LEQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB8PR04MB6908.eurprd04.prod.outlook.com (2603:10a6:10:116::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.19; Tue, 2 Feb 2021 13:54:01 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::dd78:1e78:3ad2:9d7e]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::dd78:1e78:3ad2:9d7e%6]) with mapi id 15.20.3805.024; Tue, 2 Feb 2021
 13:54:01 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, jes@trained-monkey.org
Cc:     Zhao Heming <heming.zhao@suse.com>, xni@redhat.com,
        lidong.zhong@suse.com
Subject: [PATCH] super1.c: avoid useless sync when bitmap switches from clustered to none
Date:   Tue,  2 Feb 2021 21:53:41 +0800
Message-Id: <1612274021-21899-1-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [123.123.133.229]
X-ClientProxiedBy: HK0PR03CA0098.apcprd03.prod.outlook.com
 (2603:1096:203:b0::14) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.133.229) by HK0PR03CA0098.apcprd03.prod.outlook.com (2603:1096:203:b0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Tue, 2 Feb 2021 13:53:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a058be9-408b-4dc5-3369-08d8c781fecd
X-MS-TrafficTypeDiagnostic: DB8PR04MB6908:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB6908021231C3FF84BA91E92697B59@DB8PR04MB6908.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:238;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WaGv18WTHzcayRuMEEAUjElo4AojyVf0EXwoTrI7b3CEPQdUBvRZEMK6t9GreaG9oQGfdwzFgzce19lDt35SMv8HiiAnpgCwOqIuTagcNBRHxZEF3h1EDMHX6JTyCQdlHHAHBqRps0Q5c5+ONXkf1mqSrYd8hVnIuCLWwqkJh1lcJ+gYq8MI4sgVMZ1nU0IsOE6lrHqAqQe8I1YfhUX4rF5PB9cCUoVMKD7yX9Gcn13m3ZuyCd7QUrVEnVDwHAAkLsX6lxqeguhzvbQxKblaVYOQuZP+x0ec30AE/MWmE6BnwbdgIsUEYkKv+YWsS9NaQoMmSg8tpJ6g7J1mAk7/GYGMCPAsVHlMzUV+mRc6QGl0xXsTIW9ed2PNRGdMp52/a77S9b/vKnNRXOc7woeunOcPSPystHjaxhQfstpBCAhTBHb+bIjhsV0cYSdPH0GOHowgU+d0EqjAV/diGd+Z6ZuE1PoBtjVDaN61moOKv4DI8sJ90Fjhpmcv/19Dmp6g0qduXxp/qjq34/0STFYSKL+tfN8MM2F9zebQPEOyACKd5/9i42WUC1cAwUM+9hl0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(39860400002)(396003)(136003)(478600001)(36756003)(6506007)(6512007)(83380400001)(2906002)(6486002)(26005)(86362001)(52116002)(316002)(16526019)(4326008)(8936002)(107886003)(956004)(2616005)(8676002)(66556008)(66476007)(5660300002)(6666004)(66946007)(8886007)(186003)(9126006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?A7+dzpUUCz4OPDquWlC+TyT5sHPk/PbZX4yrEuEuIrs7Sd2KczA4ZAar5Snb?=
 =?us-ascii?Q?saWjdXn7TIQaRO3i3m7QGUJTFJjG5aIuFyguPyaGolXA0toYRI9J84qv2+yz?=
 =?us-ascii?Q?yKkPI8KBf0Piy1qqxxuojZy08Ggp5wxAMKY6g0F1unj+kYdqXi3QqfjHUbqF?=
 =?us-ascii?Q?PVk9ZOwiW2l3gsmT5jVvLGqYtplgcNbJXzgrDT7grohpdk9tI4l9VXNpMokb?=
 =?us-ascii?Q?Gn7qIo4TQ647T5FA8yn8nSlXDLNqZ/V36j4dKVLxdfHspXWInp6jlE/iZk3Z?=
 =?us-ascii?Q?510+8R2gF7p7e+c2CBWNv3BEUhEbFGvIZAb6fD9eloOAWRLPAhVUz1iDmp75?=
 =?us-ascii?Q?LsDKTXWAVSiY9qstO1JBGDCF7CNYZDji0Nnh4Am7i7cb8x8E+YonX5ynqMwV?=
 =?us-ascii?Q?W7IwxtcI3sXHVjY9+6/bbEeRG039kLmspDsl0WtV3sNZLnRAwDuzmXkroFDG?=
 =?us-ascii?Q?dVITU0PkAT//pH47dA0URCQ8Wy9Bf4U9kdMkHIJv+1cwdj4qnPQaBBRH8SHp?=
 =?us-ascii?Q?4TlEx6Rj4cPEgEon+iyQHRt9ETzQJtctHDqXqHSVFOj5e1BmAXBtuAr/NRfB?=
 =?us-ascii?Q?ShBoC+qM2NkwvLGb7qTEqqcB0Q5HpEXa3KG3cTNjRbEcppCy80hUgA2CBmu5?=
 =?us-ascii?Q?jMLRgGXViQ4g+zheUXjbDMtJWYXQU2zw/gxKaOp/Qk6e5YnyEzYUIEEllqFV?=
 =?us-ascii?Q?YAG8wqjQrVRm8v4djUC3auzPDkbTrwGwIuqkC6G2IshQKayshYklEBcr5oXj?=
 =?us-ascii?Q?0sSlUio9Btf6R+z6GxVOZJC/23E0mRe7qw13SqjkDTfu+VyHV9EhQD7bJKCo?=
 =?us-ascii?Q?SqrWDbKQMqN9jsW6tH1dom0Qq7zd4pgaIVPNBzr2zVzNGYwcjKNkRzaNvUUp?=
 =?us-ascii?Q?cJVruPsfpPIPaiZFN4h6CjK53/S5UnJjvoZ47O9Zuu1LY69KlX4g0nKLlbCE?=
 =?us-ascii?Q?PXyO2pw8WJ5I3Ff+JBVeTpnEPRr42VuXtQ4uneuaDmh9eJyI8hm1SjGEOnRj?=
 =?us-ascii?Q?atY1SevXookLhJkyhhLw5aepRYYbTa2awpiZazA5OH2mllvx8Msv0nigjLDg?=
 =?us-ascii?Q?P9BaB9Ro?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a058be9-408b-4dc5-3369-08d8c781fecd
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2021 13:54:01.6312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TSzUWKUN1GJ/0S5awamZuvVSTtzv3X9Jllb/acpIbc9wyl6OflciuPaXKcvM1PqQjTJ0fRbWe3JudwUoSzCwxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6908
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
mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sd{a,b}
mdadm -Ss
(in another shell, executing: watch -n 1 'cat /proc/mdstat')
mdadm -A -U no-bitmap /dev/md0 /dev/sd{a,b}
```

Signed-off-by: Zhao Heming <heming.zhao@suse.com>
---
 super1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/super1.c b/super1.c
index 19fe6f5..92047d5 100644
--- a/super1.c
+++ b/super1.c
@@ -1318,6 +1318,8 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 			memcpy(bms->uuid, sb->set_uuid, 16);
 	} else if (strcmp(update, "no-bitmap") == 0) {
 		sb->feature_map &= ~__cpu_to_le32(MD_FEATURE_BITMAP_OFFSET);
+		if (bms->version == BITMAP_MAJOR_CLUSTERED)
+			sb->resync_offset = MaxSector;
 	} else if (strcmp(update, "bbl") == 0) {
 		/* only possible if there is room after the bitmap, or if
 		 * there is no bitmap
-- 
2.30.0

