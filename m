Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F68FC41621
	for <linux-raid@archiver.kernel.org>; Wed,  3 Mar 2021 01:20:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E358964FB2
	for <linux-raid@archiver.kernel.org>; Wed,  3 Mar 2021 01:20:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241967AbhCCBOv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Mar 2021 20:14:51 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:48416 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1381894AbhCBIrZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Mar 2021 03:47:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1614674775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UWrUehUwRW/1YhTec+MSC1klbWdbSxWUsKxnyWW1qqc=;
        b=F5ZMNRgBelm9BNuioc6PxX7numwTbnUS1QyZd59kwUdcgHs+f07+Lm+5XSsJ/KwzaqwwZp
        Lh6tkAJhTgJK9ibh5Oj/spEuwbgzzFm/aswujaDXOJtYtu10nPxcprf9h1w+DYPcns3G4K
        9ozJu888mX50dmiS2JyIalZI4YyZJPY=
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur02lp2055.outbound.protection.outlook.com [104.47.5.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-7-8MKwnVvHMtqJ57LoBFefuA-1;
 Tue, 02 Mar 2021 09:35:24 +0100
X-MC-Unique: 8MKwnVvHMtqJ57LoBFefuA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iu9+J54l89jTF+qOCpUhbfErDuDxj6qjOiQn3qdLjOdqp5dMfg0eH1phhlf7nTCWa6RIGDCDa0GbN9BRLudNAZOg2elPWXJ2Gop78cowvkKcae2eEJaGbhI8MEoDolr43fTSmR8HB/SuZ166WMZQFR1gUd8YBxSkFHA/5rtAG9ZSMYCnXwi7OSBbZwqyjsycJid+WP4R76/PJ900rdEOZNR3xNFcFfk8AUY1JS9gHzxxBUhT1PrSH/uHpXtSKF0MDTNgJC2UlJ8ub/kl1Koiy/40jCE1nu42dZ7qrhnzAlhu+MEqLNsauBGErgksEEGUrvTy3CgACu7BR+3L2Dx3xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UWrUehUwRW/1YhTec+MSC1klbWdbSxWUsKxnyWW1qqc=;
 b=Y/aUAQmcOwiWQWUUYUS3Cx05B/BGmY4SA1+4T4tFibCtuib7Mj60k1B2mc2h2I8/Ms9MCBSr25H9xH6F0IKWCF9rWZIBKrFe9PU0PLJoBVIpiSDUg28NKEF2SnyJPUU6Re99/kv/xylGmQB8mwgX7R0LFlWsit9xbtHSfZkWmRiS2Adaud84hvfobWvWDjSXSUY0dDt1P3KiAlrjwVFkA545r8nDexuwe4r0jHukGvxnXXaXudgksCRS6ZVOQbcwdrTm5/4DaVw7mbRbnoPinqc0/IFDZqv0oWLMpCbuhxeT8Ph+6b0zKm0CXnnfqbcFdWv6R25fG/U1cUfOgeZ2OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DBAPR04MB7208.eurprd04.prod.outlook.com (2603:10a6:10:1a8::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.23; Tue, 2 Mar 2021 08:35:23 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393%4]) with mapi id 15.20.3890.029; Tue, 2 Mar 2021
 08:35:23 +0000
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Subject: resend: [PATCH v2 mdadm] super1.c: avoid useless sync when bitmap
 switches from clustered to none
To:     linux-raid@vger.kernel.org, jes@trained-monkey.org
Cc:     Zhao Heming <heming.zhao@suse.com>, xni@redhat.com,
        lidong.zhong@suse.com
References: <1612311771-17411-1-git-send-email-heming.zhao@suse.com>
Message-ID: <1304a391-532e-0c93-b3c1-58441e3c8200@suse.com>
Date:   Tue, 2 Mar 2021 16:35:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <1612311771-17411-1-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.132.117]
X-ClientProxiedBy: HKAPR03CA0013.apcprd03.prod.outlook.com
 (2603:1096:203:c8::18) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.132.117) by HKAPR03CA0013.apcprd03.prod.outlook.com (2603:1096:203:c8::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.11 via Frontend Transport; Tue, 2 Mar 2021 08:35:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a10dceb-ca81-44f5-b324-08d8dd561f20
X-MS-TrafficTypeDiagnostic: DBAPR04MB7208:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB72087B4F56B22701F663D20597999@DBAPR04MB7208.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:256;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B07fPLz0vdI+cf4xPeVSoPyqnk+4LfSjOhwJmqGXi+PX8sIwWvZ81Yn+N9Mj+x0bXR/fx4kI4n3qEDdmbPJGYLpRyqUvStAo1yjeY1hd2hIGcobV5LrBqlZQRbXth7HwvdmBgLtKRBDEYyoXqmZvAtjh4YTZQR7eb4C9s5Of+JkXxclPZv7UW20OwQ67On1sC/rvf+0C9iuJzWSC46kUTh0K6d4JdVaf6qsj70l4amiI99pF2LG5GVwckl9LraLa0ItM4zmSDW3Wg1snxyW8fV/JCSOUC5Fa9tsAc5qJ35lfqu2OE1uN450i6asN1HwQzVE2j1m11+QmPR2mjdcgd+YcyN/Z6xgGZEqtm70XId/EQCYPF9fN4q7kLjGLfJ3SVwOE/xNWuGnpPTRdNhsmuP18XStRxZJVAN5Xpe8gYItGu2g6/2HKErIW2K8AgSTNB1hpIF17X2zPzqnvkTI4jeRhl06U29+vNwEAB53BvxjmwHr+3wDOVXqhYPuc92D8R0wGRZv1eCaj6YS+/U5H4GwLitTe+qbv16j8qZ/6J5BHa+nMXRmG6MpG4GtNptqqP4jEFCi/9m6eKdCBMO4dfoCpBXVnw5Xro+x5It81+LAP1yaJxaEPYHhHRoQP49T7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(346002)(396003)(39850400004)(16526019)(26005)(8886007)(66946007)(66476007)(478600001)(186003)(86362001)(66556008)(6512007)(956004)(316002)(31686004)(83380400001)(5660300002)(8676002)(2616005)(36756003)(2906002)(52116002)(8936002)(6666004)(4326008)(6486002)(107886003)(31696002)(6506007)(9126006)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?snA5pl+JrKSR7dIojF7HBxf0Drk234A51x45sV+MiHNtbHQ67DBNPfWh?=
 =?Windows-1252?Q?5MjYS8fMmAPbq/pkERZS5u8HXOPjc3DJClkAGXPS3TyNNg0vt7a7fT2n?=
 =?Windows-1252?Q?GPpsQkPQIDrryQHHZHhNHuzDJ4yqwAsQCxl+Y+AsqtlXf06FyLQ/saoe?=
 =?Windows-1252?Q?uliyFDVQccMhoIXMRtpy9d13m8Wvygdv/N9MawlwzMsa/cIbaIE3KUfH?=
 =?Windows-1252?Q?vpcXAxLhLQNQmltWWu2ZmoUT6xpsDILNwjYdkH+JcOHr/wRvEVl6+8vj?=
 =?Windows-1252?Q?Eu/MN07J4INfEY+6FtcuO3FnE+yEiLmeNcywwpjBjPLR0iBWMIjJwOF8?=
 =?Windows-1252?Q?fao8c7Y1sG4+mnpk606g8ClkEsHz9gwPWhYXsE5WaQcApc7J4Wdr61Ub?=
 =?Windows-1252?Q?YJbTlVDg54F1rBMadEZknJYtDmGCzmqUEN0qerYO9DA6oxMjzcv0Nb0K?=
 =?Windows-1252?Q?C7rKlKkP5Q/3KPJVGeAOmUT55+fes4haeMvDDKS5uRl26QB0UmzAjZBu?=
 =?Windows-1252?Q?vTX5mqXnO9STwqZeloH1XTfaIU//o5Zv/FBCAl6D2/fRhsPcCzd4XMmk?=
 =?Windows-1252?Q?G/VriWxsgAcAeEPJ28lZNkzlQ2K7SHkU17Krnb2lq5L7qRpu9xv/p3ss?=
 =?Windows-1252?Q?S9JC7s0dXrZ4rkLCpP841fQCvdyxcfP05yuAEg84J9l6X0bV47OHWuZd?=
 =?Windows-1252?Q?fmc+9EPjsk48a+2lUfA37puqv8DpFmmztaXKJS5i0oJhyVuiElqfIcPs?=
 =?Windows-1252?Q?APXPOaZR0NgLtv1K36z9IrSqZUl7bYLt+DvSKQel6T3U+Z1uXhG5OrTH?=
 =?Windows-1252?Q?q5Oa/IzziqLcIKS0cnqXKY+DKdLMP9xbP+YKCaJ1HGeGcQcEieuZF5Yi?=
 =?Windows-1252?Q?9tVQu7Mvmsl3DPHH/5V9tH6E/npp0apFD+GcH8ENHLIdvgvvvzdSu05t?=
 =?Windows-1252?Q?0ZzL9q443DTtUQdA1lCniB2ghDLUX+4BkmyOS5lQe3nXdfHx3vocUZy/?=
 =?Windows-1252?Q?ZMP7PUaehUfqizUAOd6tkxfz+yVvJKEGwMOPgXzal8hA9Ah9TkhQDAR9?=
 =?Windows-1252?Q?m6Fw3Niuz6GVxTGwZzS8wcPU/fJ3gCQWIe8yP3BvOPQCpK83Evdt7h2d?=
 =?Windows-1252?Q?aZRlrmtSx63vXBHtgkMD/XY14VIUQYr9BTMWQ4f4guRUV3SR8JW5MUM4?=
 =?Windows-1252?Q?w6Wy3MRPt4uMfeq/s6NG07CyESmIMPgRHCgzb/21+zj4QEJ/8f2RKFs0?=
 =?Windows-1252?Q?m79hZvCZTmARoE2CwNU0kshzJEgr6U+v+WP5L+XY/Ec3J900bJ4qn2+B?=
 =?Windows-1252?Q?XUF/AjXw9lx3m4wOWyzruO6RVhAGS/ib9FV5U3HO1Xm/KomGaip1IbsO?=
 =?Windows-1252?Q?cx6e95z48NPgOb870uiB4FVFItiVllTCIqqAOS74JuVehiSqhIe4g01o?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a10dceb-ca81-44f5-b324-08d8dd561f20
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2021 08:35:23.3167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oci1sTlXcUuspK4Ydsd9l9cdXOhowSTUtI5dOk1R7GceSevLlAr9GXIvJGnS4Aw8ED9iuqQ89HFObbPRDSgM/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7208
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

With kernel commit 480523feae58 ("md: only call set_in_sync() when it
is expected to succeed."), mddev->in_sync in clustered array is always
zero. It makes metadata resync_offset to always zero.
When assembling a clusterd array with "-U no-bitmap" option, kernel
md layer "mddev->resync_offset == 0" and "mddev->bitmap == NULL" will
trigger raid1 do sync on every bitmap chunk. the sync action is useless,
it wastes user a lot of time, we should avoid it.

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

