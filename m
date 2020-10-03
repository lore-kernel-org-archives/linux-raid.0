Return-Path: <SRS0=R9UH=DK=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B74C41604
	for <linux-raid@archiver.kernel.org>; Sat,  3 Oct 2020 16:12:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DA13206DD
	for <linux-raid@archiver.kernel.org>; Sat,  3 Oct 2020 16:12:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kghv1kTO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbgJCQMp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Oct 2020 12:12:45 -0400
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:46341 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725803AbgJCQMo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Oct 2020 12:12:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1601741561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bxLIpJYnS+4siVGv3JgN8eoc2dTo1yGAONzYMjA4eeI=;
        b=kghv1kTOTAsacEg9wND43bbVAhP9OAp96/4l5MAU599m42vjef03H1eu5U6Vb20uenFLEl
        1SKY1q6gk0L3wRJ5jM9vIbMqwlopCWtLWArHpWX+IFbqBEJuQdRfaBY6daQ6cGVTIkQoUx
        1q/J3a09pQ860EWkpLPFBe2G2NfahCY=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2113.outbound.protection.outlook.com [104.47.18.113])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-19-70MmVcrAM2ed_iyG4TriAQ-1; Sat, 03 Oct 2020 18:12:40 +0200
X-MC-Unique: 70MmVcrAM2ed_iyG4TriAQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cOZzFajnrC5Ndh14XG4sHytRb7sXfc3MU8oqTKyFoz7ZgzFGMcai7/FoEVWRP1Yv4gZAt+pZoC/HIm72JnzEmMX4U/MUhy0L4DP0+IkHee+kpfC4yjIC+8BjNQ68tQ3MdscAOXUgxE+FczqnAVFQ3c6uxMKLktCAEVlS/B8SqLCBza0NfZcYCKZRroJo4Rgzsy+cZqMqi+HTKMvWLsHi1k1IwB+VOUAuALIsFGbHJcire7iHwIpzTGFaHRV9mlppN01RgMFaZq1QK7HSSMEE2UwYYbJ6JsBruQP+JbLU/inwv+XrHB6p1TNYDoYGr9NGlv9jZKdEOgd5O54xmqrqEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxLIpJYnS+4siVGv3JgN8eoc2dTo1yGAONzYMjA4eeI=;
 b=KVtEheMOfmxjKqiBXNxHs66TaeV9Di3qvKUgt9oVYe83oSFv0XoTjC7XBrmoZN7456D0yTXUCfFEiMkekN0ocjGJPRUnqiknphmdUfCOOpPMI6QcN43tCDwLhQMGdS0HZwUxZeKOL81B1vzSiVDhha9fsNh8aFoOb9VIdmOfCKr2bTKWqxRcl8jqHRmbaKOK4PaCP59/QYSGrxKNFxjoAvnekNFC+TmZlAxKFwiU30Yjbyqg6rso2+LCssWHFzp63hdkZfKkMT2XmgKCOO+/CeZQqORhR++iAj2oO0ch3Wkd7Cqih1qwkcWrLjX+FpR9ENSSt0iCGSydeBGxIuLEPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB6PR0401MB2280.eurprd04.prod.outlook.com (2603:10a6:4:48::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.32; Sat, 3 Oct 2020 16:12:39 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::b59c:e9a2:d279:3904]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::b59c:e9a2:d279:3904%4]) with mapi id 15.20.3433.034; Sat, 3 Oct 2020
 16:12:39 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     Zhao Heming <heming.zhao@suse.com>
Subject: [PATCH 2/2] [md/bitmap] md_bitmap_get_counter return wrong blocks in some cases
Date:   Sun,  4 Oct 2020 00:11:32 +0800
Message-Id: <1601741492-17696-2-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601741492-17696-1-git-send-email-heming.zhao@suse.com>
References: <1601741492-17696-1-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain
X-Originating-IP: [123.123.129.194]
X-ClientProxiedBy: HK2PR0302CA0005.apcprd03.prod.outlook.com
 (2603:1096:202::15) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.129.194) by HK2PR0302CA0005.apcprd03.prod.outlook.com (2603:1096:202::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.13 via Frontend Transport; Sat, 3 Oct 2020 16:12:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3de4ea1-ffb5-4457-5213-08d867b7267d
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2280:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0401MB2280C1E14CD19BFCA17498A2970E0@DB6PR0401MB2280.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ibJV97hEJO4LpbTAAWgWHbCH2PW1f8DGcJfWw1kKkoaPdHZAyGvon+62x2/TxvdQh42DZaHr82AtqMA/8mG/5eU+A46lctoNKY3+cT99xcj1LOJZsRjN6Qwq5btcp4uc8Mwg5uQ+aEV56N/jcisdSbXCVRZKo7NMec9IPyZSjOqIlOBstNHjaKlIDGWpcZFBXhjjrdNXFUJCTzJlx55kOwyTj/qwHj/gH6VJj9xgoWU54RhlnRGoBR4qZzQVDp3r91t584h8a3xpN577H/zZcFwXlmd2PuoH8GSTA8xBhPGkvTD6HSu3U8+AXBWQ70czS0sx2/TAJWGIx1n71rWU8VcavnqgF4aUE9VVnYdDBa3bq/0Rwc5aiyQiH43QO7N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(396003)(376002)(136003)(66946007)(66556008)(66476007)(8886007)(36756003)(26005)(316002)(2906002)(6666004)(478600001)(5660300002)(6506007)(2616005)(6512007)(6486002)(16526019)(186003)(52116002)(8936002)(956004)(86362001)(4326008)(107886003)(8676002)(83380400001)(9126004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qBa3c71w8BLLUVOBNrY/wRP1h86t6PCC131VFT79F1PjVz0vlYNQEeNPaxryY1eE48CkffRWVBT1h5FV6uiKJ7joXjDvCMxTEGN5b05JILJEr7ghXgQxCYslXq9ygqCgsjjC1OW/1TYrDaYQsWzx2M8N01/JHf6LdF+srjYaRre0Xog+2w3g9xASbMK2hDcoD4pDAKu6QmuiAe7SGfnxKtbBa3GWRyz9z+ufCpEKi6n3Q+ztqIdQkld/o/5CSV1eJpkwcIrdXG5XKtPmsinL9WYaUAsDAnsyENis947BG8YnvGZG0dSzWOdXw1RzLfKYNUVtfZ/UC7wXmM51dltTF/5R2POEKfzvdGNJYWcDt640YSHL7RZyNJpagc8QR5pHkjHE9NxagC0BQqt1KXXSqk81MOijmu4VWIL1QvulIa28+rJ6I7TXInokiyzkl3uoD9DsLVdyU2uw18wGmIzvnHwGCtxr0hdW6jLtqqoYcgVNkTU4swGaZ/4rJGHWpM3ImOTAj44c1R4JzkbRETGMnnns6n24Lbsq146NoTLK3jQLxegSj709K+YCaY4F74YBndsWnG/BCqDZI6YU5XZxo3GTD3cKChMkjGXWuoNuRMiYDT0XA+tJJpjfD+4I8BrDZHTxOZ0ebPErQyd86aMozQ==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3de4ea1-ffb5-4457-5213-08d867b7267d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2020 16:12:39.8416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: icvG+ybFVzJfqI1gnGkOtM8ivV383gVg2UYzRxf5lt14dku1Ae9q9f4spJsnRmNdMOWf72qBRYlSx+R7p9fzDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2280
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

md_bitmap_get_counter() has code:

```
    if (bitmap->bp[page].hijacked ||
        bitmap->bp[page].map == NULL)
        csize = ((sector_t)1) << (bitmap->chunkshift +
                      PAGE_COUNTER_SHIFT - 1);
```

the minus 1 is wrong, this branch should report 2048 bits of space.
with "-1" action, this only report 1024 bit of space.

this bug code returns wrong blocks, but it doesn't inflence bitmap logic:
1. most callers focus this function return value (the counter of offset),
   not the parameter blocks.
2. the bug is only triggered when hijacked is true or map is NULL.
   the hijacked true condition is very rare.
   the "map == null" only true when array is creating or resizing.
3. even the caller gets wrong blocks, current code makes caller just to
   call md_bitmap_get_counter() one more time.

Signed-off-by: Zhao Heming <heming.zhao@suse.com>
---
 drivers/md/md-bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 1efd2b4..145b3b2 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1367,7 +1367,7 @@ static bitmap_counter_t *md_bitmap_get_counter(struct bitmap_counts *bitmap,
 	if (bitmap->bp[page].hijacked ||
 	    bitmap->bp[page].map == NULL)
 		csize = ((sector_t)1) << (bitmap->chunkshift +
-					  PAGE_COUNTER_SHIFT - 1);
+					  PAGE_COUNTER_SHIFT);
 	else
 		csize = ((sector_t)1) << bitmap->chunkshift;
 	*blocks = csize - (offset & (csize - 1));
-- 
1.8.3.1

