Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D442BC433F5
	for <linux-raid@archiver.kernel.org>; Mon, 15 Nov 2021 03:18:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0BE661A84
	for <linux-raid@archiver.kernel.org>; Mon, 15 Nov 2021 03:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235093AbhKODVb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 14 Nov 2021 22:21:31 -0500
Received: from mail-eopbgr1300128.outbound.protection.outlook.com ([40.107.130.128]:31989
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236458AbhKODV2 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 14 Nov 2021 22:21:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KEkK+f0WVLncMCz/+1sVB+4e9ERMcFopGpGC/takwRWV9hQIvR+UuxF65anwG6GUpsBxCzP7MbRj308UKkHFU5ctPa3beunRpyis05ClifQc0PtquNJKMGI4gnpBpO2/yzVdQv1VhspRAO8FzmY23rPPGG7H2I0zYnjXPkAnua5c3HvfPmx9yFwgNLzKz2wXpvPoOvfJ2vq1/xBAgnyUElsSVAyP9wpe8eCWHSjFQanleBtvp8Jthufwu9lHpQjEJL7pdgTICJK7ix1trx+tHXQ1ssFd3oUbYoEiTMhopgHDWDUCHxelDcRtQtsJhwdROb5rgZM7W8tezH8BYGhD/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QehpzfZq71/ZLtw+t+EZhZpS69K04OqknfmIrOpFHvQ=;
 b=XCeN3hXprIDN8/wGL15WxZSuqGL3/SEQDgSpfmMzlw7PBM2FFruy1XuNRhGNSGdIXokSLhcfOyJLAaZNd7haffoSsyCoupJz4yDiDvfQHYesyuULKrvwEd3UoL/wr7NbDMpGuoyPQfLo4nQyegkgHx8AcL+rmlB3hqf4ZrMVL7hXOVo70ZkuxzmIOLslrpdlYOMI06vSprjiyp5iiGDwCL6caN5Pa8/fWZZBZe++Lu7ElQ/7AaJ4mWN3P/jclE3o6g2HuS+zP2UlymOGTH/R+J8ryh57WTkvGuQSagQt9Tolwe3xzAzg1Hl8myn03EUMYLljkZi607nGmy2irlPuMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QehpzfZq71/ZLtw+t+EZhZpS69K04OqknfmIrOpFHvQ=;
 b=MnZBSdf5ZQHF5YXkiNwTYj3qIyrlyfw6ESbrCGcyZzFhBSMaybUDq1CBB5rjY5GLC4xD7/6ZKVx6XTIZMmsWYFRybpsCc23uzJYifndc4E1rN++G29MTCjPw8SRqkJtWc078OsPYweXCB+2geJdotSM6kWAkzYPOa19MiAIgcLE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from PSAPR06MB4021.apcprd06.prod.outlook.com (2603:1096:301:37::11)
 by PS2PR06MB2936.apcprd06.prod.outlook.com (2603:1096:300:53::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.17; Mon, 15 Nov
 2021 03:18:29 +0000
Received: from PSAPR06MB4021.apcprd06.prod.outlook.com
 ([fe80::395a:f2d7:d67f:b385]) by PSAPR06MB4021.apcprd06.prod.outlook.com
 ([fe80::395a:f2d7:d67f:b385%5]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 03:18:29 +0000
From:   Bernard Zhao <bernard@vivo.com>
To:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bernard Zhao <bernard@vivo.com>
Subject: [PATCH] drivers/md: fix potential memleak
Date:   Sun, 14 Nov 2021 19:18:17 -0800
Message-Id: <20211115031817.4193-1-bernard@vivo.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0136.apcprd04.prod.outlook.com
 (2603:1096:3:16::20) To PSAPR06MB4021.apcprd06.prod.outlook.com
 (2603:1096:301:37::11)
MIME-Version: 1.0
Received: from ubuntu.localdomain (203.90.234.87) by SG2PR04CA0136.apcprd04.prod.outlook.com (2603:1096:3:16::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Mon, 15 Nov 2021 03:18:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 936951e4-188c-4fc6-acc7-08d9a7e69866
X-MS-TrafficTypeDiagnostic: PS2PR06MB2936:
X-Microsoft-Antispam-PRVS: <PS2PR06MB29368A2D8EC6B92E7EF37DCBDF989@PS2PR06MB2936.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:170;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b0GUeVTYLb4vYz9x1U6YMeFIJTB6pZv9Z+Zr2vrbZ0S8W8C93camaKIXqYXJ+eUnZM2k7Ov17f3bWnR38db7rOw9IH3wzHaiibFIx5fXzrnZgy9abxBbEB3GcGrFszKu5bEdSliypXyVkpdVr4LsKE/4McexBI7ym7GOmZ6v/twcLvez4J59e1BQIu8H8PiA5Xp4QRsCzW7KI12VrE9vydm8APOGzaPgvD0GJKPWGwwdWorDv/1MFEMDPFJ26iHu7C4SJsYLtSUy1e+K7BzpmvqE/6ShhvEFzsf8xKGFIDbkosIJr2WoHOhdo/wxlbSphoG8lpoDVrYYdAk5smoMM3Ec9xpNvfTTylXHVzU2PSq2OJE/8TzYY+YQfms+MArFCrrwjWPW9VE/Qv3Luv4DAymgGoK7c2NeWlTaiDDZnMzOt8KUExCFYk6Gu+3UKOo8aPQCR3Q/OwqZi7/C7y4XGph9zspEgX2/7ExF9nTXbLL7WbKCJ720jIuwAfyzOGCTCI9xsiY4GazO776wbNaa9wRgbeQ5kTjbIAYfC3WXbWZ8YSO9/Bh43dnsfPsAdyJIaa0C+DVTvTHsNqNmhEg59UwPNwK7Kka/f4QaTAubm2oVvxyMVKITQkb0wjYrY1u/MPZ7bGUrKIEJHrpN85lXvhdPjxpuhHamdScjTaqGQ+e3pNpAueJ+yFNfon1Z2ZSQC11sEQpqAlZettV6Kq7Uwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB4021.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(6512007)(6486002)(36756003)(86362001)(107886003)(956004)(1076003)(186003)(52116002)(5660300002)(4744005)(26005)(8676002)(2616005)(38100700002)(6666004)(66476007)(6506007)(316002)(66556008)(8936002)(66946007)(2906002)(4326008)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lg8B1mnL90YjnebTJj8+lNA4cgn2O3civegyEa+tg6+M5RYOOpowp2+Mla0F?=
 =?us-ascii?Q?78er4Sv6SQnxFgmpAP+8KL3OA/kbvzFiBN51yeClFec4rIgY5SaAN0UWzIXH?=
 =?us-ascii?Q?K24lS4Ak1vfFFKDVxx0GeUU8/YuWDr55aOeM6Nsq9xvQGfUzmzjnINtriTXl?=
 =?us-ascii?Q?T/PEWPoZ0bH6D72M0RSOy98E1W8+2I2wh5Zy+5SOEPqKqxMuYT7ghxsjw8ZK?=
 =?us-ascii?Q?qh7TjPud7UW+oSkxOu2c+7mP5G4dzaTCoAbpU19IdMfSBvq1xsw0x8YsLGvl?=
 =?us-ascii?Q?oXo++xi7PstTPTxN0ZY8BaoWq3jXiU1b8LDi/Evx3K8WWTIuY6akItnh8jYd?=
 =?us-ascii?Q?dUSW7koSc4EvyPYVKNUx2zaxwmhV6mt+DBctXnpJL0NM93CbQ9Fk/O4GCNAq?=
 =?us-ascii?Q?KG0HQ2VaCCbJaE5dRz0jXwT22pUjurM2pa+p5MnTL7xOU7gIXCi1zJ0S7ipb?=
 =?us-ascii?Q?AaXqt6h+r9vh8ewr5tt6PjjFG/Sye7ZMxXVJOpwE2iNp823KwNlt9HTvVJ9e?=
 =?us-ascii?Q?8bZxHFtm9gTuHeQj5BM1RfYSBQXfYMAztMYB4QcaC8kJlp3krRH5uGWx6q3z?=
 =?us-ascii?Q?z/7o4uKJDQf7tiiHgqfVmT9nKGffoe5KQupYAOpPBW8dw53887exb8CqN2mm?=
 =?us-ascii?Q?8no+Amjp5ACJT+MTYOCD+RxYs55jF+iRIcoTriY+eXL1mDf9M+XctFxHbk3h?=
 =?us-ascii?Q?GqpLVakZuVeIF42NLQdfjmzxPfvGr+NzdXU8qDdG6R45fX6FhyFbkVpXxaJh?=
 =?us-ascii?Q?8c/VopcruE1QRynh+cR2jve1ntkO0Ed1O+GIMSnAbO9ddfNLH+cYIUWcYBBP?=
 =?us-ascii?Q?2tjbKy6EI3qdxAjCWj67ADq7PmK6lC44prEtEDZAn1dgV2tHMIHKWSWqR60F?=
 =?us-ascii?Q?l50cHAObpiXGNhY/hq0Kf7+9bOHObp6Wg6iDCQWSt1KJ296qblhbXGxpQ5Zr?=
 =?us-ascii?Q?CKg5kEifh8UZXWAEs5Oped8oBDTWmAApHubMHq7x4XLBTgmG6TuUbTiiQWRh?=
 =?us-ascii?Q?tdH0ahGWdVzCejBpH943EsJdZ9v/uCvdnGKMQbVBffcWzPOf/SDujnE9L/BQ?=
 =?us-ascii?Q?xhrJch4A4RVkvpHDm2dmPTrG6y7ZH6FWAsOK3ikKEZCYNmEI8eapIGtd3LlK?=
 =?us-ascii?Q?nRV6SLnUjg7NBPNcjtk5Z8oGNjG3yeYNXRaxelzadvsBE4oWfEYFsQgq93q3?=
 =?us-ascii?Q?2BKmNmC4bmL/ypg2pmdxkzW/HT8Yk41st0mu7n4gUFRS1uibM+kAHgITaaDp?=
 =?us-ascii?Q?R8dOVmITJD+2p9aBkskJFP2IyyNQjuxBJmxqCTkPtx0HNWerHpyD4m0LRlUH?=
 =?us-ascii?Q?pP8OteJgppBGdJ0PjiioXmBYJJHNr11EAHH8lAAs3NYgw/cB8QhDnXocii7i?=
 =?us-ascii?Q?SxJkM4U4Gu39U1t/7V/VyiKWk9RGCa4YU3rIzPaQFh1n3/ejWVpdWnuAVPYB?=
 =?us-ascii?Q?hwQoJ336UJKbAgksmIqn/N2It5HXGFcGT80f12GNDpUng/nZ0wk35N2SOjQi?=
 =?us-ascii?Q?zY3VbdVOQYBhpVjMh+4roQrbG1LWSKrGPg7M3umWYvMb8hQVRRp/VRAvFZJi?=
 =?us-ascii?Q?wmLA96ltBIHe+pNxU3T/JjScwywrHKCQU8IZFvEGBIDvWweXIfBuFhxNGA4h?=
 =?us-ascii?Q?5MLJnfqlcnwIE3PgSDVL6eQ=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 936951e4-188c-4fc6-acc7-08d9a7e69866
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB4021.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 03:18:29.4681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IFdKsi/LIhp++o4QB7rEQeSFo9u0LI48cCizZ0CouvWOsQc57VqNgKrYRk0oym6pJbMaG4l2YLwzjZnPbdEw8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS2PR06MB2936
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

In function get_bitmap_from_slot, when md_bitmap_create failed,
md_bitmap_destroy must be called to do clean up.

Signed-off-by: Bernard Zhao <bernard@vivo.com>
---
 drivers/md/md-bitmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index bfd6026d7809..a227bd0b9301 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1961,6 +1961,7 @@ struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot)
 	bitmap = md_bitmap_create(mddev, slot);
 	if (IS_ERR(bitmap)) {
 		rv = PTR_ERR(bitmap);
+		md_bitmap_destroy(mddev)
 		return ERR_PTR(rv);
 	}
 
-- 
2.33.1

