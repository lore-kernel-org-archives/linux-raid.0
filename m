Return-Path: <SRS0=oy2H=DM=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD40CC4363A
	for <linux-raid@archiver.kernel.org>; Mon,  5 Oct 2020 16:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C8392068E
	for <linux-raid@archiver.kernel.org>; Mon,  5 Oct 2020 16:01:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Lesae5MM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgJEQBA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 5 Oct 2020 12:01:00 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:24688 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726760AbgJEQBA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 5 Oct 2020 12:01:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1601913657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=+GQpFo7eIYdEiBfNiGdUn1W4McY6yDhMVXgL9FOO7ks=;
        b=Lesae5MM4EH1Hj16o7H6SF+M0WNRUtHNbH7xMsWjMVDg5YRuTsJuH6pvQN/yVWHXUJUDo/
        C/2GS+d2XMmZgvOJtFHpJyYFFrBGcu5iut9oVi7MT98njodqvMdzgy8vwx9EH3dbRvwhSp
        RDbdu0vxwiSSRzpHhOSStx8LUmZy1tM=
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2053.outbound.protection.outlook.com [104.47.2.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-24-9_-j9HlRPXmykmEA6GgIwg-1; Mon, 05 Oct 2020 18:00:56 +0200
X-MC-Unique: 9_-j9HlRPXmykmEA6GgIwg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jNRapOtucaXibqeZUA2c4AxoInSzQYNxVD+AzBR6MuyEl66AyWm9ULFverGBKpONg5zDPHrqbMIxdcEzVzoUck5TYnE0D/jJDbwxn17rRouwnAfXnsfUVdGuQ/zSMVQXfnjsu/GUDr117GgjS3VRqxHChEzn2Kb4rfQfH29zy7Q0Ria1NCl3GhC/abTsB00xzJEFC7kxs66cwVYkY4KcpJRmDOluRcgVrmencXqRie3Y+sq+N06mi9XS8MC5AqN1i/y9faK6a0UPAUhLTulUDeCHbVv+lfJ7WgTWwLi1D6xrmNG6EnuwNbp1xKWIh8AgZzKI+zMj7SwC9GvFRt/UFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+GQpFo7eIYdEiBfNiGdUn1W4McY6yDhMVXgL9FOO7ks=;
 b=Fh3OLV077Z14KMDFpvcpeBI7ftarI85tdf+YI42p3LEcQxkxG0V6zwtq3scWuS+a3GJuhDHs3/d5hWa9j23yl0K7wMCFSXUj5R1t6knDTM4YRJbzVp+JJxr/SSuyxzC81+d9aECNsKqAR5ONzZ/Ww+hZ3xv6cW8iDUy+hwP+8GpBxBvaQU32+TLKY3B63rEKIh1fF4IINmTac0OSEmBfhfKPboov8Cw+ZUqk74m/tR7DKN8m0LZaS1cMwKmRwEhElx3n20ajrfIDYfuPyjLLpOHVfnXT40ZB/Vi3X2xIOKr9qFLoQL+Sitj17G2rGlmcgNGk3v8u4lfBqaL+HPopdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB7PR04MB5451.eurprd04.prod.outlook.com (2603:10a6:10:8e::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.34; Mon, 5 Oct 2020 16:00:55 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::b59c:e9a2:d279:3904]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::b59c:e9a2:d279:3904%4]) with mapi id 15.20.3433.044; Mon, 5 Oct 2020
 16:00:55 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     Zhao Heming <heming.zhao@suse.com>, guoqing.jiang@cloud.ionos.com
Subject: [PATCH v2 1/2] [md/bitmap] md_bitmap_read_sb uses wrong bitmap blocks
Date:   Tue,  6 Oct 2020 00:00:23 +0800
Message-Id: <1601913624-27840-1-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [123.123.129.194]
X-ClientProxiedBy: HK2PR02CA0146.apcprd02.prod.outlook.com
 (2603:1096:202:16::30) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.129.194) by HK2PR02CA0146.apcprd02.prod.outlook.com (2603:1096:202:16::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Mon, 5 Oct 2020 16:00:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f14334e2-a3dc-4aa6-3cfe-08d86947d739
X-MS-TrafficTypeDiagnostic: DB7PR04MB5451:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB54518DC75C43AC3C686F6A6C970C0@DB7PR04MB5451.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:989;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l0dke9mgSH58p+OqfhH7oft1KdKzkZwozlwqEr8nVMxPOSeSyG5PomBkOascSxIYRHAFedTmXTt15butr9xAZKz+Sg+UfpzdsBBhAOuNk0igTzJdSlftz7eB+vpB4sftAkNlWJSGTMXRJu3XIT+vvul2pfqqw1J8ASNTeo8wwXseuO/e+H3jX+ORz9J8PoHF7ujyI+kWgEuotJn12fiLiRC2JQGv9BeKZ4eR73rf2Gcgo6ei9AbLYqzIS4gkA7ZiFAT3Zlq9GV+tqC2DQLqZvkCWDxDIT1U2xytxFCn9D+Fi4DHySZJ1BCJYpy70P5N3eRcGuRZYUnK0CA5aSoZ6rBqT2j24SbN1/pgOAtP6ttcIWkjEMzHPxA7K6vck8mmR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39860400002)(346002)(366004)(376002)(52116002)(478600001)(8676002)(316002)(2616005)(956004)(5660300002)(36756003)(6486002)(2906002)(83380400001)(8936002)(66556008)(66476007)(6512007)(186003)(16526019)(26005)(6666004)(4326008)(66946007)(86362001)(8886007)(6506007)(9126004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: elXcXMQ6XLShngxX+3HNXrMaMMC+hciIWIb3pDCx5cquktIrT1eLGFZQUQ4XOeYdMCxJc3Xt6EQALKd5w6XF/l5RINFoSnG8ST2PoH5SYUeTEd9fUBdk6rvluExlvqL4IS9oez8FeP50GLU4abyRp/PjerygJ8fUb08yzyckA2tQS2AgjLwnQKoiuZGi0H79d2MUltg+037n09QpV5Ra0eRGZMZdfWHfSbUa3DhZpzR/Z5YO3pFdoIMr0EOy73NNCiwM17mQ16Ha5JZvJHWFDb5KSCQEDNL4MyV7vnMrUkFkbyJKU5r812eX0Cz4LpFQ7Q3qaNW35j+uEnniK1wfh0OQJOqsultMSuJrMgcMNEEZdMpQbPXUHrpq5sAjG+QbmBm6q5hAdYbs2gdtQeOyxosbrKf/8FDImJ12W8I6GfS4DWbXV1OCBG65BVbr/FQ8y0SG4vaSPBGooYCcNaX0WKjpxj+43xa9QnKkgaQRoHpU2t9SgM1lu1IAbu7FXeISlUFycM3iwtmV+N5ChO297wgcVGYVg6PtWfNvcTRxDTFxDgKFxNnINlW1T3C7mOqZJgMjp+egdoXBEReblOQX6faET5rU4cy6L2dsX+bx5/m6lyoD1Flpzinh7Dp0/r5/EfKtapG1qofZcQ5RpD5ygA==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f14334e2-a3dc-4aa6-3cfe-08d86947d739
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2020 16:00:55.1929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d6cGIqbQLPuKuuWiarkWx+7YQy2mT6Y+9OVAo6AKWdJhA6ELVtWY3pAU+U9qjXf3fZbwdvgODKdhiGnnJ2kZ9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5451
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
v2:
- change grammar mistake in patch Subject
- fix code syntax error 

---
 drivers/md/md-bitmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b10c51988c8e..553b6406ba1c 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -605,8 +605,8 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 	if (bitmap->cluster_slot >= 0) {
 		sector_t bm_blocks = bitmap->mddev->resync_max_sectors;
 
-		sector_div(bm_blocks,
-			   bitmap->mddev->bitmap_info.chunksize >> 9);
+		bm_blocks = DIV_ROUND_UP_SECTOR_T(bm_blocks,
+			   (bitmap->mddev->bitmap_info.chunksize >> 9));
 		/* bits to bytes */
 		bm_blocks = ((bm_blocks+7) >> 3) + sizeof(bitmap_super_t);
 		/* to 4k blocks */
-- 
2.27.0

