Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FA22C47082
	for <linux-raid@archiver.kernel.org>; Sat,  5 Jun 2021 15:29:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B182613EF
	for <linux-raid@archiver.kernel.org>; Sat,  5 Jun 2021 15:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhFEPbQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 5 Jun 2021 11:31:16 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:29031 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229930AbhFEPbQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 5 Jun 2021 11:31:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1622906966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=m1dwaGrXKV9/8YBCicbR2j33onf13zDGbnsLHT02gao=;
        b=adBvH4Htv/5iZ+LHJO1ZiGFFt8WP+rSxzftHgDQyVQcTzFbdsgg1YPqpK0ciWRB42PH3nv
        TS1l4r98BpSz8x3Nyto2miHFhY7sWkTjxR9uTsYKFqvGL8FVBxDE3zFDMHdvyUj6d/yAT7
        BoC65URGMMIX2o7RQL2HHlbz9uIyUn8=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2050.outbound.protection.outlook.com [104.47.6.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-33-P8Zh-EREMxWOQN22zbLtWA-1; Sat, 05 Jun 2021 17:29:25 +0200
X-MC-Unique: P8Zh-EREMxWOQN22zbLtWA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CcFeCVJpdAUiVLwz+t0a2ripi7urKUO8OzI2mNBRTkIRcgb5L5RqW1SQBjW7gimPWGGNelJp0nmTMG/8qTVleJJ13ZcJPfXLgKBa2uaWGW+iEGodDHcO387tHu9uF7ZMseD4yClFUHcJU2r7fWbpmjp3SqaZYRcRJRhoG37rrKEyVXcJ0dvx8rwLm10UN7/LHJFVKUpt/iaoF1hzJprhG2C6g4mLS14IpUZS+sCxbmCpucK776xCyh3cbL+m3Drl5g1946dIgJ1ikcWq9sczLsiVkeFtM6owuGcDPGRCfznNMI4AcSEJ2l4/NVRMhmiChJT58bXPxvVn7v9gwLKmHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/DzJbfX9FLtrJSkNwXNiMYT3BheVXhhpXUmiSnw6Gg=;
 b=BAGpWLg6+wd4yzLc1pS3inUAVoQVPIitcdjT/frAGHwEZ0XzXPs4lkABKHzN3y2Zb8dLQJjpvMe7befwPftHqLYJ6m0j8BEY3uFAwwxIbLYgdxdTDU1V37HdTaKnCy0jI0BGec1ApIel8Rr7KvkZc13qIn5ooMJ4mTYsr1V5wtltfuhXAofdyaLRS1YdonagbKZS2utGDRb0oTm+XJ5UGDfPOnQpGSB8/N4KlJfs1l06w94xZbvYMTw/wS4SIuYuMN+zu3Q1PvPHZG/tudxhdtlejnDqCHP8NLH5neiTqQfdHlRF3paVwCH3fti5aDXIWJ7F4RSf6So1Ml0IArqgwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB6529.eurprd04.prod.outlook.com (2603:10a6:208:16f::21)
 by AM0PR04MB6035.eurprd04.prod.outlook.com (2603:10a6:208:138::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Sat, 5 Jun
 2021 15:29:23 +0000
Received: from AM0PR04MB6529.eurprd04.prod.outlook.com
 ([fe80::99c0:486c:b9d7:5740]) by AM0PR04MB6529.eurprd04.prod.outlook.com
 ([fe80::99c0:486c:b9d7:5740%5]) with mapi id 15.20.4195.023; Sat, 5 Jun 2021
 15:29:23 +0000
From:   Lidong Zhong <lidong.zhong@suse.com>
To:     song@kernel.org
CC:     linux-raid@vger.kernel.org
Subject: [RESEND] md: adding a new flag MD_DELETING
Date:   Sat,  5 Jun 2021 23:29:17 +0800
Message-ID: <20210605152917.21806-1-lidong.zhong@suse.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [112.232.225.71]
X-ClientProxiedBy: PR3P192CA0009.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:56::14) To AM0PR04MB6529.eurprd04.prod.outlook.com
 (2603:10a6:208:16f::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (112.232.225.71) by PR3P192CA0009.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Sat, 5 Jun 2021 15:29:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1c8bf0a-6d4b-4c18-91b9-08d92836b163
X-MS-TrafficTypeDiagnostic: AM0PR04MB6035:
X-Microsoft-Antispam-PRVS: <AM0PR04MB60350C7340A4309AEA01C08FF83A9@AM0PR04MB6035.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uPsZEpaZ/XnTXK3omP6FS8FovekiU3IyB1sZsRED7yu/vgFAI5R5SVuOSfU2sFoMcLJ2GSvDI9RI74OnbWzM7ac/V05/VFjwySUrSTyJICmCM8rQnBeIznwhhBUrQRD32P3YuiQtLLmnTb8NeKlVxNIuuMLz1uq/NByV0RCk0YBBQXMj52Wcx3Kkehrk2o63xnd2aRCtw7vuxHWZH82/jvaD4hd+DVLan83Wp4m1M6rC869elSkJB6hiJZ9ifRC/KGOfCTlt7asil86WOxZZ5pxyBbxCR4C8c0/QAhFsUE49bP2eadXhaKXS98rVdVSBKb/Wrd8rKy3Gwr/DxOxBgcyj84SlifQ8QIEVfeOPn41TbrKzZy3buePxvHhEzT5G8uNSwZ1cLAyvC1CxsJZZkm3RwqpHAa81O+FOnzGhEDikZ226eY1r3FMcmf/+bqE4vdWWkktbs2pK+/GLRA/NXe3j4bT0OmfU/YpFcQrGK3K9UeryAeLL2NRil6qFk/ha4PN8Glk9wMHIzdKa1Kuh94KMNmnlrwbAOKzsdR0fI6TwMgGJkqCRMNkYld6ruvLI4h3VVp6TfLh86/sdWR6/y8v1oG31uxusOxaltk1csU8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6529.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39860400002)(346002)(366004)(376002)(38100700002)(478600001)(2906002)(5660300002)(1076003)(6916009)(44832011)(8676002)(2616005)(4326008)(8936002)(66476007)(66556008)(6486002)(66946007)(956004)(83380400001)(16526019)(186003)(26005)(86362001)(36756003)(6666004)(6496006)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?PFYHA/5x+SZfTL2NeU3ZCAIon9HI4KhzJkw/oB+Eo457FSl7gkp4VwaqYQWP?=
 =?us-ascii?Q?O1qMb8joeo8osg9z45EAZ2L4rJfpDXz2Bo9HClbeWh1VJS8WbebX0n4SKdWE?=
 =?us-ascii?Q?YgYvqeDdlVY8k3fyYt9zd9/Ja0QwJZwxLjQXtzE6VBhH4h8VKXecXBf6vCS5?=
 =?us-ascii?Q?/YpTaZPe5ra0l1yUuub7qtxjHQu9BJjx3CcU7CyvpR0oQ5U6M1MxWWvv3i6J?=
 =?us-ascii?Q?JxuPR0ZkUrBgWvUFw832RkupROSj88PSLmD4pCSo1SpB6d5eH1lDm65IfsTH?=
 =?us-ascii?Q?Ppqu9cAyY55FSCa5V/G+ZmhUu+Ebf1zov6SFM2kLuegdnCHO4NADV6BGtfAQ?=
 =?us-ascii?Q?shYjH/tK3Tnmtolcsy7Ohg37Ma6OysyWcbyqfDiUl8juSQZ12Jegy8OmuCjd?=
 =?us-ascii?Q?OfdY9YZaIcHHcEqhOzanxYj7aKy4XwEr2YjeWmLW9x4sofHuY55GZ8AK1Ux/?=
 =?us-ascii?Q?lbh5pwcwGRGpS/7rNLPZTgZ5luPXI/8oqH/ToB6tfvMwsaJPo2Aqz2wF1RWM?=
 =?us-ascii?Q?w2t/4rQFV+Nk1nHfYcYzADOuYkyU21mkAW6RjkhaycEHM4OBZZ7ZCCLeCQ94?=
 =?us-ascii?Q?33FrHgB8uuBeFS5j0I7XE3U9OoL6Y+pQI7g5/DDHLQy1r0uAkx27uogBAyGO?=
 =?us-ascii?Q?rqXevnzEBVjFosX41c95IrLOygDr9BVldONgR9u5pxogxq4GzNyyYoWM6Xew?=
 =?us-ascii?Q?vWXeLS9WA9BrA30I8qlNxPCFAL1iP3kmZRVNy9TtP9/6wtjRIUBRksoPUaE0?=
 =?us-ascii?Q?a2uxvQPsJIDmX0yy0xVmjhsY5sPIGY4nq1uxHuM5dQhYGHSH3QsSKLVLtU3O?=
 =?us-ascii?Q?iUxe9DO6JCne/11qyeMXeCcCeCc1/H2BbeNWSBgKnKfwjRCJ72lP2p2/ggJ9?=
 =?us-ascii?Q?eAce3G0gY1Vuh4rrOOw1cKJQGfUGCByfXN7by6dEYdRknucy1aPvdhLUSwOc?=
 =?us-ascii?Q?VppFKNYJUW2nxc6zT1A8ADcVmqqL/1habAlltM9jfTiH+29AfxVoOtvg5Fu/?=
 =?us-ascii?Q?lXpCpj7t2G24AzUrOswukNb4GOvZXoACG09UiAvopsgfr9evCUt+7TkLEDJG?=
 =?us-ascii?Q?a3LEIjvyqRwCNoXsLiy31cXgQVy+QuA05AiGlRZx7vU8QXRx6VWGEgxrs9vm?=
 =?us-ascii?Q?nds+pQG4MuafHJw5hgeVX16Ftb0mLCDZNI0BgedLgEN+VS9stS3WIEiz1qD0?=
 =?us-ascii?Q?EcwPiJiFg31lqPs8jnEUtnzCn3nOhTuvz+XM5qQK/zeEJMZzwx0g4omTF8/T?=
 =?us-ascii?Q?RbvX+jcYlQagDZIxjZB6cYENiEydXw656v1/ujzmyP2IErztuM7jgzrxJaKg?=
 =?us-ascii?Q?4xWTfonAnVDOG7immBbNJEZt?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1c8bf0a-6d4b-4c18-91b9-08d92836b163
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6529.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2021 15:29:22.2640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O1LAspYwDontOSV4GtgHzYCqdo/0aJDJKSIlBAOkQaufePtzGwAZQhTvLT0EaQQVJUdDyzgl++/mGA7AFKUJEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6035
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The mddev data structure is freed in mddev_delayed_delete(), which is
schedualed after the array is deconfigured completely when stopping. So
there is a race window between md_open() and do_md_stop(), which leads
to /dev/mdX can still be opened by userspace even it's not accessible
any more. As a result, a DeviceDisappeared event will not be able to be
monitored by mdadm in monitor mode. This patch tries to fix it by adding
this new flag MD_DELETING.

Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>
---
 drivers/md/md.c | 4 +++-
 drivers/md/md.h | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 49f897fbb89b..e8fa100a0777 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6456,6 +6456,7 @@ static int do_md_stop(struct mddev *mddev, int mode,
 		md_clean(mddev);
 		if (mddev->hold_active =3D=3D UNTIL_STOP)
 			mddev->hold_active =3D 0;
+		set_bit(MD_DELETING, &mddev->flags);
 	}
 	md_new_event(mddev);
 	sysfs_notify_dirent_safe(mddev->sysfs_state);
@@ -7843,7 +7844,8 @@ static int md_open(struct block_device *bdev, fmode_t=
 mode)
 	if ((err =3D mutex_lock_interruptible(&mddev->open_mutex)))
 		goto out;
=20
-	if (test_bit(MD_CLOSING, &mddev->flags)) {
+	if (test_bit(MD_CLOSING, &mddev->flags) ||
+	    (test_bit(MD_DELETING, &mddev->flags) && mddev->pers =3D=3D NULL)) {
 		mutex_unlock(&mddev->open_mutex);
 		err =3D -ENODEV;
 		goto out;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index fb7eab58cfd5..b70f8885da7a 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -262,6 +262,8 @@ enum mddev_flags {
 	MD_BROKEN,              /* This is used in RAID-0/LINEAR only, to stop
 				 * I/O in case an array member is gone/failed.
 				 */
+	MD_DELETING,		/* If set, we are deleting the array, do not open
+				 * it then */
 };
=20
 enum mddev_sb_flags {
--=20
2.26.2

