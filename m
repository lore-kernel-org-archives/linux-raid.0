Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BCA3C433B4
	for <linux-raid@archiver.kernel.org>; Thu, 22 Apr 2021 16:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30BEF613ED
	for <linux-raid@archiver.kernel.org>; Thu, 22 Apr 2021 16:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235830AbhDVQK5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Apr 2021 12:10:57 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:49560 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230510AbhDVQK5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 22 Apr 2021 12:10:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1619107821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=T1kacetZjJEu1WMCEJ1YNSs9OdZeHQo6EhwOEK/0898=;
        b=ll9GNjy1UzUYFClrC1VSbQ7msPAEEjSTE+bSV5gAg6HSovfDqf5gvhzqE7FHfte+DtZaS/
        zhiZTNeParwP2WPN1qd325oILKqwf7wU61x71C2JGOUOt8RpI6dc9KyrDWa3HCAMr/9+DO
        2cstIq7BBRiLNLLLW9KoXlX+UueVGLQ=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2059.outbound.protection.outlook.com [104.47.12.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-32-3bhz7tXYOw2LKHo54egYPg-1; Thu, 22 Apr 2021 18:10:20 +0200
X-MC-Unique: 3bhz7tXYOw2LKHo54egYPg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KO4+/nXgj3J5S1XzO1FOD3UZ07FkON/73qHqR5VfThAaU1315HQvUCKJa3Niut4HP6IWcn6WLp1BV1t9GqIIgnKieIXoSv5XUJWc+JCGazrtaQiOZ+XM/givZVZ6QgK1ZyMArAAkNnxSgxa7rAs+Cm9eIwxFWxhMn+/ym6mk8RwGYP+8FiE/sD8+UDW74HGOgASVW/GI1ucSi7lDBN1SZAkSebjgksEE29KEHNDrFjqzd8PD+BpU3eWqjzJiMd7PvG++2Vc1CV4PLIIO6mu5P45nEo1eRivLYysIdw/+lJ/BdLyAv6YLT/PCt+s4OvK+rDmUN74v+SSxtyU7YsQWEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T1kacetZjJEu1WMCEJ1YNSs9OdZeHQo6EhwOEK/0898=;
 b=VTSHpiio6W0aUmRKwwdAmUK9uDgCizcIja4+ah4XFRYqooo4YsDCfx6OadHaxKBSo3abHGfk5NmDm0/Nw0KjL8cWqXamQFGG0bKUgHLa72sjnWWtqz/MM4Pcfa8mgyMUz29qs+GIFY3MAGwe/xI4Luj4bxULN6vLI7DFQTCVGbx3lTTqBPemy/S8/XRGD2IDU1/0V13yCiYzODaMQj1JkkQGNLI8G0jK1EBGR7+/sXFDF/JGnwGX60aknIO4khPbqSkyF1zY4UuJplKin6X6nXTyfc7Ft+Fpl4Q00jiL2CyTaaJrPgRPG5QWSZRcCB1xzQUoe63FOlx7Vfp7kQ0R7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DBAPR04MB7270.eurprd04.prod.outlook.com (2603:10a6:10:1af::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.21; Thu, 22 Apr 2021 16:10:17 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::2c69:3d93:4901:ecfc]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::2c69:3d93:4901:ecfc%3]) with mapi id 15.20.4042.025; Thu, 22 Apr 2021
 16:10:17 +0000
From:   Heming Zhao <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     Heming Zhao <heming.zhao@suse.com>, lidong.zhong@suse.com,
        xni@redhat.com, colyli@suse.com, jes@trained-monkey.org
Subject: [PATCH] md-cluster: set correct sb->resync_offset
Date:   Fri, 23 Apr 2021 00:09:54 +0800
Message-Id: <1619107794-30889-1-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [123.123.130.241]
X-ClientProxiedBy: HK2PR0401CA0008.apcprd04.prod.outlook.com
 (2603:1096:202:2::18) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.130.241) by HK2PR0401CA0008.apcprd04.prod.outlook.com (2603:1096:202:2::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Thu, 22 Apr 2021 16:10:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9afdb48-d02f-4701-c202-08d905a91e80
X-MS-TrafficTypeDiagnostic: DBAPR04MB7270:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7270FF456709D303C00A33AD97469@DBAPR04MB7270.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:169;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k7Q75/YmcT2uCn5WSHtO0O7vBNnGpVJxoqn4aWP37dR0SGpDG5ItPab9JlxYWdnx/AuvDNUgichFkwIucz4LwduEwv5lmAcRrGq6bCrzEJxfEtFhnJbhFcNgc2M/v4Ik6xrjtZiYh5YZl+A1E03LblyTBEnP9/0NCNxGyfMDClsV3sryz3W7U2TEhp1fkmlnuRA65NdkxY03hu2/6CsDlbzI0fRJSMjcjEXRI/7mVatDSrJ3iyaLH3dpmU5AaQrrkx5EO2rH8nSSMgRrOulVnNHe6ATLonl275t2KREwqIfLGX0lcZC8xDa+OcpmgyXzyRPpKzVdg70BKFSfTxeR7f1kYWsXmzAyjI9iP9ljxNjNYHsjacLl0l8JZ8G37LtAcmlxnDrCA6F9uCixIn6qXqzs5R19ll4EgRLdjGAIZxS6HxTXr+lPBAphV9Emd53/sIq/xI6/6ltcSoSW+/vnGqikF0yCPbomeIvVyNVd3FzWtNKtCXPMIN9u+yERVmLHtVp/Rd3jcQGHo4UJfZ7UlwZXfCywrFLR0fs2VHZ6zyfcCqAsQbiGan1zSZRqzN3UchPPKQn3OHVKjwu3jbJk3boqqJJZLiNSCCN07oXmsseB5S/tmh8F2lHUZiaLChOFzPF8y7NZmGfgirXEAAH7FIAPqU+Dd4k4oOn9xirUARI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(376002)(396003)(346002)(186003)(6512007)(2906002)(66476007)(4326008)(8886007)(66946007)(26005)(16526019)(8936002)(8676002)(66556008)(6506007)(52116002)(6486002)(6666004)(38100700002)(44832011)(5660300002)(38350700002)(36756003)(478600001)(86362001)(83380400001)(2616005)(316002)(956004)(9126006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?B1fq5ecOnrF/n7Hn5tlEjQqbeTmfMJfDShteJDKvzaSlVGJGIFVsH7otdPgn?=
 =?us-ascii?Q?N6lAjxgCBDlXeBNLjVrz91DcsQqgGSap18geI6K35Y0gPkcHtKQXWp6y6Ds5?=
 =?us-ascii?Q?gvRELJLBy83aYLDjv8OU/nB3++dUzrtk7KO+D+8NjDuv88XxQnlWa6Pngdlj?=
 =?us-ascii?Q?shh3U1Ka4MI2gUy+Q6/y17d9g5Hil2wGTjIEOVYu5ZNm9B9csPHmu6yeiMJU?=
 =?us-ascii?Q?JagXQPobdfVE9Be1B+ljB+WgfSNlZ9rheov2P9FRtRcgpsebExz/k0TcuyE4?=
 =?us-ascii?Q?KkGKATVfsSFgYswRx6TMz0n7GTkxSTaKIatOHLrp8qZAGs6EfShf/8hdJSir?=
 =?us-ascii?Q?F7DM16z6GKsqJAC3T6O93MHqV7GQA1ALo04l2XRoxjgPp9NjRWL7M088CDz+?=
 =?us-ascii?Q?8brEA1cDeGh8IFb3Itjhbi5qNTOPeBS/A7u88An+r+7nc4SdnbvsORT4IExr?=
 =?us-ascii?Q?6u62CpZhru8X7//IIMPrewUjgxcjlv7FdJc0qV/MvbnVmMYqKlg/vzAAAIxt?=
 =?us-ascii?Q?QfdoZRsBewxtW5EF256uhD5wO/nFCRVGfOiIhMQI9CEfW2+/VaDvDDuMa+HN?=
 =?us-ascii?Q?i3wBFSuZjMDTUal/cvfeTDaZvFyT2Oftc40G3j7OQjyjTn+k01pvZDixlkER?=
 =?us-ascii?Q?jLNChGFLeF5e3SfX9nqXijiVtOfp4OBKPSyTZTI0ILmNMbdLmbj93ecqCEH4?=
 =?us-ascii?Q?QgxKOxii+1u2X+VC5YioqIM8/c4+yiaOthMs9A8pxLcbXOTH1wPoTUz6r2ip?=
 =?us-ascii?Q?+2/1PxMi0MtteR0nW2Bm+/MbLbbQw2xMoUSoTupEN8v5maEGi+fySRtCl6Hv?=
 =?us-ascii?Q?yG33NwcH+DcuyKcgsB816GypuibGWiXIEUvjhXHA4hZpUr11p0JIvZsfffZ6?=
 =?us-ascii?Q?45/Sx0H3HRJzrg8Cft05rRDNqtkyic4joM5uqrlthppJL+RwbO/nqTJ+F+O2?=
 =?us-ascii?Q?naFmXl3nimY/RxhxCt6T5YZnRnAwYNwo2H15PTVSj1zpAvi4zpSJ+GVbgLnP?=
 =?us-ascii?Q?5lDAA2zWL12Iwv7FoJZj2Jfg/ophrfaez5NpZ/ZQj2lRiK6cdD66HLumlAyR?=
 =?us-ascii?Q?CyLclucwrPrTuJR/xyUtoU1DB1JsQkxR8FUQnvMcXOK/c4DQ5WRt8Ji7dMnZ?=
 =?us-ascii?Q?H6hbyiXxos55x5QnKWeHTZrwXC0w5JMqdjdJHpWwvZPE5w+Z9RYHAFveyY3V?=
 =?us-ascii?Q?cnZBZ67jAl6a02eMSuThY3sc44XiN4UfrZk9JXt/13toNLQKYkAkzHqDJBJk?=
 =?us-ascii?Q?E9gw99VnQMsAPHlnJTNggLdDChK3qSmwn3BHAjKmJ/hM/yLsxkOVp6uCTw5u?=
 =?us-ascii?Q?oM9wsUyK2wMJqpF0qOFJ+5or?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9afdb48-d02f-4701-c202-08d905a91e80
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 16:10:17.3359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XDnsJ+O7utXAOTrUvsctNRJnemo5eguZq9c42B5XFqsmSYB3lf8jqqTuH+xBzjbIWHsg7vl6QJZ8uaE1WzNuvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7270
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

mddev->in_sync is always zero in clustered array. It will trigger
raid1 report misleading message on assembling:
> md/raid1:md0: not clean -- starting background reconstruction
> md/raid1:md0: active with 2 out of 2 mirrors

This patch allows clustered array to set correct resync_offset.

If this patch is accepted, mdadm can remove commit f7a6246bab1541
("super1.c: avoid useless sync when bitmap switches from clustered
to none")

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 21da0c48f6c2..a8654d7a1ed9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2010,7 +2010,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 
 	sb->utime = cpu_to_le64((__u64)mddev->utime);
 	sb->events = cpu_to_le64(mddev->events);
-	if (mddev->in_sync)
+	if (mddev->in_sync || mddev_is_clustered(mddev))
 		sb->resync_offset = cpu_to_le64(mddev->recovery_cp);
 	else if (test_bit(MD_JOURNAL_CLEAN, &mddev->flags))
 		sb->resync_offset = cpu_to_le64(MaxSector);
-- 
2.30.0

