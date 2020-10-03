Return-Path: <SRS0=R9UH=DK=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED68C41604
	for <linux-raid@archiver.kernel.org>; Sat,  3 Oct 2020 16:12:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 565A7206DD
	for <linux-raid@archiver.kernel.org>; Sat,  3 Oct 2020 16:12:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="WSjkvHFm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbgJCQMd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Oct 2020 12:12:33 -0400
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:31676 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725808AbgJCQMd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Oct 2020 12:12:33 -0400
X-Greylist: delayed 872 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Oct 2020 12:12:31 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1601741550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=g0wRRSpsXpmdX6taEE5ZfIve79eeL1hwJ7aTCQyLTrg=;
        b=WSjkvHFmrKb/NK4L1ZsGPYC19PNmHLdOv5DO7wHiQKBn3cDEhfWN8Q3/5jr3Q4I+moSNb0
        zF7U2fkZrXy/PLKc6lY7BK/p9Q4EJd+TtDIgUZWA9k5SzcpnrjbHm5vNpXZr7N4hUctRkx
        45VjNsNu9Ps0aVFvlFT1iSlqHr29p/w=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2106.outbound.protection.outlook.com [104.47.18.106])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-21-XSO0l-VFOoW-ytsZ61t-BA-1; Sat, 03 Oct 2020 18:12:29 +0200
X-MC-Unique: XSO0l-VFOoW-ytsZ61t-BA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZNS+iZ7N4rLtfJhAXuAyszDpZkN/Vi2uY0c0Bj0sD11yTZglaHo5lh94EmEei86r2nDZpEVhlubsC67txnPaakXyyCgtW52igO9A0zhhiuqwChY+s7CAmDl2EDqsWRWlIAXQnYnNW5ENOzF5a4Q52BmBvvrj+xWQrGOoxSWGf8PhGhKaumQJRIYAbaqto9v1Rx2ODoA53P0sii8Ib8LXWkJ/w686LY8cHsJJ2GAshuTUxKN17W5xF1ppAOmYs5bVVZpdEXZcQInepiAFsrw3eQb1RF4sY3/I8wOWzaqKuR6VGh7rX2zvHfYyZvWEli6jLdbKfkVEfTkJbzz1JUUwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g0wRRSpsXpmdX6taEE5ZfIve79eeL1hwJ7aTCQyLTrg=;
 b=QirHk3Xn9x+RhP/ZNkTnwq+KkiD+V52Vuv43Qpsk9WnRhjWnd52446oMtViuj0ob36fcBf4CZvV6892wKMmDnyPzPg4B6StBOillkmszzEHRabikz0XZqTOiGsF/hclW7LBMVS2RsK2NL+Pfrk0ZT3/hp/QArdyDco39kfCmDiQ7+deOHEhVewm+mjddexUv7dchLGjm36GVJ+uJpyHk1Z670gxz5mKtY+KMYCh4+HvobQHxeFCmoDgs/Q7pICjG1dpCkPEsZgoS+F6vax/gpqdIrFTFyOeFsX/8lMFJhPHVYBfPMEAHfdlKixJ1LLRqb8TVAY4ccQ5C1PgdEJ6dOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB6PR0401MB2280.eurprd04.prod.outlook.com (2603:10a6:4:48::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.32; Sat, 3 Oct 2020 16:12:27 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::b59c:e9a2:d279:3904]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::b59c:e9a2:d279:3904%4]) with mapi id 15.20.3433.034; Sat, 3 Oct 2020
 16:12:27 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     Zhao Heming <heming.zhao@suse.com>
Subject: [PATCH 1/2] [md/bitmap] md_bitmap_read_sb use wrong bitmap blocks
Date:   Sun,  4 Oct 2020 00:11:31 +0800
Message-Id: <1601741492-17696-1-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [123.123.129.194]
X-ClientProxiedBy: HK2PR0302CA0005.apcprd03.prod.outlook.com
 (2603:1096:202::15) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.129.194) by HK2PR0302CA0005.apcprd03.prod.outlook.com (2603:1096:202::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.13 via Frontend Transport; Sat, 3 Oct 2020 16:12:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0358e4a-56f2-4e0c-a8a9-08d867b71ec8
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2280:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0401MB2280738EC1506895B81E19A9970E0@DB6PR0401MB2280.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zns0a7xxPy+bgZyavucAaI+ZAhtq+j2i8NAxH+lqyO/MaqpEzewWzgM3U9cMnyus0AhUuroOgX7uOYBDNi3mpb4zNFhg24Vsa0lqKV6te1jpM90wGNu3o3rkjkpm+2hE6BADMHQ2Tyx4oBx5uvPJrLA6xtvmLt26rrkvS7/edqHOo7mT659OJfB4/tGQINisAfEtAC1LZseVHdvqxj+o4suOoRf60DgOwU6RfE6Ex9kd56OGXCRZAxWxGxB3s+IUvmerQxX5icsxkBcYd7bm+4yw4r2YQHkszE3wSAyIcvFx3Xwor4/KebsyU1gp8jH6kCx8oiuwEO1bceLPKpY2+LoAZd1KXQpGRlehdV9OawZ6EKRmRgZ0in3PzQMzwFd6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(396003)(376002)(136003)(66946007)(66556008)(66476007)(8886007)(36756003)(26005)(316002)(2906002)(6666004)(478600001)(5660300002)(6506007)(2616005)(6512007)(4744005)(6486002)(16526019)(186003)(52116002)(8936002)(956004)(86362001)(4326008)(107886003)(8676002)(83380400001)(9126004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2+sd2OliEHC09HhzUglJiB/WYgztNwfrBmv+ZchbdTz9Sxx6Z722FqCY80AlKu+hSzWwrM7lXzqxd1P8Mks+t/JOaw18EJyTVf+yOROkVsdLdutYWfPayewBuIUPLubHcKkTEhmGuVLNhUvHHfZG0NbcQrliAPyt/Dwffr0QxNYE4wmUiCYfZ1u5NHFzHvgPjGhb49Y5Tiww3Lmrj0RsryYeBB5I4Xe8gOz74j6x/Hs6v1rCHImnfEv1aUofELhsSe3y1qrUguF/UsvjhIxI7YBbX8xOAfdDmQUcP6LEAQS+7WgUZ3VaAcHdTzRuJFXsqB6qRA639y4817nCEAShDVRXOiHNNnZWCpN3+LgROHwLbyA+kcdOkyg57pg1FhONp7956oRLP7EPiEIC5NWk5e6DBcYfuVkQyXnDB2cwyb0YRqXSMplL8exOHdwaxIlLttdEZGF1cKvRdFamrcaiJ3zd+czZ7gINjkUY6hx4OnhAfXDZtQ/CSAVgAsKd2i2VvfZAPE4WMroWaYoQ67/n7jgiHPXl3HPSyXloe1q2l3Y/okjNVq9CETr/3xheoq0Wg70nRT6A07WCxWNZfWbVPKjIDl0Fmr6BBOB74jndwvKMMlcwoFpmG0nk+1VRn/5LJ+3Lcj/yPqN8AYbovbHCJg==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0358e4a-56f2-4e0c-a8a9-08d867b71ec8
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2020 16:12:26.9816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jslRDkIw/gtyaerBtyqiqPj19yPT79KHGzCOGJdceZrtoJ34o81uS4OLOEwJEGaiLKIEHnawjxMvPrlBoJ4gkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2280
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The patched code is used to get chunks number, should use
round-up div to replace current sector_div.
The same code is in md_bitmap_resize():
```
chunks = DIV_ROUND_UP_SECTOR_T(blocks, 1 << chunkshift);
```

Signed-off-by: Zhao Heming <heming.zhao@suse.com>
---
 drivers/md/md-bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 593fe15..1efd2b4 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -605,7 +605,7 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 	if (bitmap->cluster_slot >= 0) {
 		sector_t bm_blocks = bitmap->mddev->resync_max_sectors;
 
-		sector_div(bm_blocks,
+		DIV_ROUND_UP_SECTOR_T(bm_blocks,
 			   bitmap->mddev->bitmap_info.chunksize >> 9);
 		/* bits to bytes */
 		bm_blocks = ((bm_blocks+7) >> 3) + sizeof(bitmap_super_t);
-- 
1.8.3.1

