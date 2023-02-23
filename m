Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E591C61DA4
	for <linux-raid@archiver.kernel.org>; Thu, 23 Feb 2023 14:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbjBWOjy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Feb 2023 09:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234851AbjBWOjw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Feb 2023 09:39:52 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2044.outbound.protection.outlook.com [40.107.8.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFAF34333
        for <linux-raid@vger.kernel.org>; Thu, 23 Feb 2023 06:39:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=If1GC77VGU4uHh33v3nMv+BGVolpnXkNmmP4rzT6laFcDgGQtoOatMYLWHHcMLTwsnM1wgkIXyABRZO8D9XxmvGjPgGfhDxnC/PT+k8xEmoiLM0mOdp5w3TiQTSE1V69i0FyxzMBq6qklADOUitYifm2r8oOpA/jDAQEg7UPtmNKJocm4uS/GYL0iUPWqtEkBc2M1ChtXEkzarLNdfM7BKxwv0lIYiEp22xp+f4Zg6H5eu0g4sg0EPVXL4EUZneO4F63LoUzWCOQ7IhfRYQC188FqD3J0G8iplcm1itnGO9RUaWasuY53Ltlr3RmgPJS6OEplPLsELJs065VbvMjmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O8Uk84BbYyLVTH67PAkA4nli9Fn5nLHIdowfOQgTkag=;
 b=mDfjocZPBzpSiWEXWik+eOw0Yvt7dd2mRJuMAJ4s89HKZKA8lPDrnpo74zNhDTLS4P7UlHoL6KOQLIUT87i70WLfsE1kuMdbgTX5BSQ7Hij+xfT4w/Vo8Jph3VxfujvNBVqCLo879zbt6wTLR3e4sA5N2imgC5zdfhO1LjGb7vEWN+jMRZX361gMFApk5g5buA53kh0oyywRoG7S/bQdGPhiRjUZusJaEaeLHPepTZUy0A7lG7P3T9gB04o/PAeZf1jZilCvLvTfYcgAhN4cgYdARS5agG6ISl+JK008g4OBtDlQ9bSYM5WwibcIWJJ2IMPsyNkJgz+3I8Oyhg5bpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8Uk84BbYyLVTH67PAkA4nli9Fn5nLHIdowfOQgTkag=;
 b=tFAH7VVNYlWdAUdWw7MVwnGAEBdynGQ8yfuk2J3Vh8nEj5cOEdhUkDnZGhs7fYzBFPrgKLy85D+S/qsWzvfMpbxv6A3WAMBA4W/d7EUpu7HcBTp9J9lWUPAXX+owcn3blupQ9Ikht05I7Zk1x5wenIBZZlCHvu6zF/Nh0lCpUTbOliYe2EVD4LSYpOs7UqPZo2oZULmXWi40OHjBskmguW5wlXxNE/dpjEH92DISW0oxtrXd6Tli6vqL9V5S1eko3QH61SL90rrnbE52wJAsxLxOdsGqokcbpKyiUdWfWn54aa7qbcA7Z/IzSd3sFfv/9uJ6bR4VbdAZBAeBA43t8Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7997.eurprd04.prod.outlook.com (2603:10a6:102:c9::6)
 by VI1PR04MB6944.eurprd04.prod.outlook.com (2603:10a6:803:133::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Thu, 23 Feb
 2023 14:39:48 +0000
Received: from PA4PR04MB7997.eurprd04.prod.outlook.com
 ([fe80::8b1a:ccfc:b5e:4b4a]) by PA4PR04MB7997.eurprd04.prod.outlook.com
 ([fe80::8b1a:ccfc:b5e:4b4a%9]) with mapi id 15.20.6134.019; Thu, 23 Feb 2023
 14:39:48 +0000
From:   Heming Zhao <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, jes@trained-monkey.org,
        ncroxon@redhat.com
Cc:     Heming Zhao <heming.zhao@suse.com>, colyli@suse.de
Subject: [PATCH] Grow: fix can't change bitmap type from none to clustered.
Date:   Thu, 23 Feb 2023 22:39:39 +0800
Message-Id: <20230223143939.3817-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0039.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::9) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|VI1PR04MB6944:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ccffed2-119a-42ca-d18f-08db15abd042
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dYXvYy1zRGoRcIXR8N/i5YdCi4TwLAeMykToAL75F7PZYDJubqAHYW+25aUJ375EOTZkxh8+1C0HfarwekIs8tjvIijA6QHgw9yhvOpCK0JZKjOe7UO6y5CPT9kgk85sU9bvNBjwvBCSm/3gidegyzUK9eBUPKvoi7jCT9duv1fAoVSSV4H9mL3XUJmmh71umiY808wSBM2oQltSQ/LVU3vJc7o6QatNE7caKIc12rc+GPRE8jIYVclX0Oo7iqiHvunpEcvz8fcmRJxm/ukpdb1N+eGy4AXlrkaYXPVUDjFK+8CJA4k/bC2bNV8TU7P1PizAzkfRWOh1m+waDKC0BoPYls/9hIH+uzNFQbGt6WTTydLUF+DOdzpUoSMZULr/R3m/JERjG15884WACYreSWoYWYeR5c6qAwoaLcLw9mi6U4LKMlPe6GnGozfXg1hGuOaXRUlFfdRXwTx6VeOzuBAe+HJmaPIO9B7Sd4k4oKD3OvCEQoSgq4RGThpFH46h1K8t0FcYxurIe46LpOMBp5LMc4NqUO+PWivOAj657kX7dsCdPbzhH1Uh+PUUWVlxNN7pMGwNItLeu9qQRTU53JQvSHq3dujDrt4zDJOmYZA3QfHOaZTja2sQ+dEnLCKvvgGBUX74IdFtSlnVJI6/+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7997.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(39860400002)(396003)(376002)(346002)(451199018)(26005)(186003)(2616005)(6486002)(6512007)(6506007)(1076003)(6666004)(478600001)(316002)(83380400001)(5660300002)(8676002)(4326008)(8936002)(41300700001)(66946007)(66556008)(66476007)(44832011)(36756003)(38100700002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cNnyzpI1jtUDQUFgsK5vm+/xAk/FYj6dhur3Gm1aIz6YfX0SvFqJJ0P4arHW?=
 =?us-ascii?Q?SGeWeq3X0LTM2WhOc9mql+FdPaQ4V+AD4U0pVe0Kln+3gpe/gXBFh7Ge1K7o?=
 =?us-ascii?Q?gXyqQpfwnTiB69NAr6KTYQcFclt++2XCnibiQM36xOCR+vaEN1qg0Jlnyxkw?=
 =?us-ascii?Q?pnh26VNOZPPZeZjjAm70kwMUD3C+pbUX1hzzrcRt8GHyaXi/v7nZP0np0/0w?=
 =?us-ascii?Q?iDNLuDy8wf4WpN6RUslVpbLukAwqKBYA95z+kgR2pxu3GXGHvzamd0TuDOxk?=
 =?us-ascii?Q?cZy90vpnlrPuOhNbqX4CaG8o8X3oBt8yjdplib3DVadwbpL5KcEFtO2xXBLy?=
 =?us-ascii?Q?k3k+UsCl58Ky8e+OFvM6Yw33N2DMliRNMK9NeNllVzmjnnsEb9HZOeywx2I6?=
 =?us-ascii?Q?RkMiZxOMQ0ApuPlBf3MuZQ0M+9UJB8kDnjZrm0+2TMkmitoCUi8MeWxgfl4h?=
 =?us-ascii?Q?2nDc88hv3T0n8VwPdTJBxTrDdSiahxFBI4v4wVr3atTYbUZQLmFQjvlS5Jfn?=
 =?us-ascii?Q?QaAJv5D3d5mgMdbdaDdICBw7OEK9RjIjXLKbSRjL6DlkQo/gtJiWh/CYfqET?=
 =?us-ascii?Q?0dSpQcPoFKEwqWq6nRemoz2tPYf16VE3nbgeN4Gjrh/Sh2mfAkowJ43DBZIn?=
 =?us-ascii?Q?9iXhDblVnhcXY8LisaSqV5PPuyZWAt+CWaF+991Njc5aM4MKEsZZMjmV2Ja5?=
 =?us-ascii?Q?VawVdTeiW2aJykC/4Km3glsZfdUEXYS5NiA1Ky875BI9BHqtUfE0VlA/dR1X?=
 =?us-ascii?Q?wyh39lEchkYgiu7SbKbVik7i5iFICfIe+pqCxj45I9YXl912NdJsY5xLWJAM?=
 =?us-ascii?Q?xC4ecdYH4WEg4/XDd1PRINWOrmhQina8h2DueH548pT/taLfDtTqCEFIKdHn?=
 =?us-ascii?Q?uAm8uXOFrPEnefzu1MS4PDZCDLKTtSKy/sCrF+accnpni41hQLpCbyMcUnct?=
 =?us-ascii?Q?NN/mmqYlIuJZe9SnZ64Y2/jE0xM9I0PYtY6LESQNtAhVN0cJ8wKw5HyeLecp?=
 =?us-ascii?Q?Gf9uDdUswyG5nXnvB4/rEPsfHFmyXBULgOH2VLzIkEwg2waZVbEPvssuECad?=
 =?us-ascii?Q?76G/fHBZVDhhtiJjzJ43T45zAQ8fA9ACWUhdBLXyul3OivkuGsU0bJdgA3Tz?=
 =?us-ascii?Q?ux8/7KIpNQWav5Xt1EghGtiLGaGAH9dg5tuiP5CA+98P90dZ5j0Wr1CQImkm?=
 =?us-ascii?Q?8ldbXU2lTg/WjLEjTtr4/IuXiuiDjmpBQjJVpb9z+0AHrRBVCmikJhFbNj7t?=
 =?us-ascii?Q?Z5f0vUZ0QcaE03l/sFcU/lgQcoXG/T38TArOebIbawkUj/Sy147pLpgjBKd2?=
 =?us-ascii?Q?1R2tjloglfMYSEGIlSCYJOCugEfVtt/w/o7i+lW0C0QHRHfyp0xAmdYP2sH/?=
 =?us-ascii?Q?p5wHPxRD7Gy08FXUXtsKJ11s73wcWKwQCucSH1uDxdJoztYagv8OcmNa9MVp?=
 =?us-ascii?Q?Eo082XiZPrXBDc8EaQ0qg131I+vrHCG1KJHAeKJY+aGcUPa6eQNT4wYREOLw?=
 =?us-ascii?Q?1kF2UBmqEC2lGUuxakg4OTthcLJ6hsWMW8NXjE9Y437MIIrLq4956RQmSkeV?=
 =?us-ascii?Q?NrOfFvMx5ptUVBE4vXiFIqAgQjOLXKiOFxMyyBote7rDe3bkW9yLPvGn+51Z?=
 =?us-ascii?Q?Zw=3D=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ccffed2-119a-42ca-d18f-08db15abd042
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 14:39:48.1937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: scFo4+5oOl6IZIRtQHZY4VqlwaeJhVBVX2zxmO11m8vh6W+Mx5u4mZvUEO2qemmYrsKJCPROYUkOi7SIduTI0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6944
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Commit a042210648ed ("disallow create or grow clustered bitmap with
writemostly set") introduced this bug. We should use 'true' logic not
'== 0' to deny setting up clustered array under WRITEMOSTLY condition.

How to trigger

```
~/mdadm # ./mdadm -Ss && ./mdadm --zero-superblock /dev/sd{a,b}
~/mdadm # ./mdadm -C /dev/md0 -l mirror -b clustered -e 1.2 -n 2 \
/dev/sda /dev/sdb --assume-clean
mdadm: array /dev/md0 started.
~/mdadm # ./mdadm --grow /dev/md0 --bitmap=none
~/mdadm # ./mdadm --grow /dev/md0 --bitmap=clustered
mdadm: /dev/md0 disks marked write-mostly are not supported with clustered bitmap
```

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 Grow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Grow.c b/Grow.c
index 8f5cf07d10d9..bb5fe45c851c 100644
--- a/Grow.c
+++ b/Grow.c
@@ -429,7 +429,7 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 			dv = map_dev(disk.major, disk.minor, 1);
 			if (!dv)
 				continue;
-			if (((disk.state & (1 << MD_DISK_WRITEMOSTLY)) == 0) &&
+			if ((disk.state & (1 << MD_DISK_WRITEMOSTLY)) &&
 			   (strcmp(s->bitmap_file, "clustered") == 0)) {
 				pr_err("%s disks marked write-mostly are not supported with clustered bitmap\n",devname);
 				free(mdi);
-- 
2.39.1

