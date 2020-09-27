Return-Path: <SRS0=4Hgh=DE=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5686FC4346E
	for <linux-raid@archiver.kernel.org>; Sun, 27 Sep 2020 05:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E95CC239EE
	for <linux-raid@archiver.kernel.org>; Sun, 27 Sep 2020 05:42:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="iZAno5HS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbgI0FmE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 27 Sep 2020 01:42:04 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:43455 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726382AbgI0FmD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sun, 27 Sep 2020 01:42:03 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1601185320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=IF04kLwJvcWRSpUKYQZCRwbO2RFK8dMNffcz3wHE+48=;
        b=iZAno5HSJPbwMO0KIofbM11pLdaXwJzouGzRCbdLao1Z71W/y8YE2spUmklwf9NTPClcbG
        iDB4OYBmUhe72d6lHd3G8FJfrvE86072zVaypbaWxSPq9DDbZbLRZCrCTAJrZGTEu9tAxl
        2pKdVjSapvgoYJMWn4oFdk504VMm1nU=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2176.outbound.protection.outlook.com [104.47.17.176])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-23-LXF28sukN06gqDNJVneAUQ-1; Sun, 27 Sep 2020 07:40:38 +0200
X-MC-Unique: LXF28sukN06gqDNJVneAUQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0t5ymx0/RhpvhSGxyw7oOrXLVUSbSpDBe40DEKhYZMfrG3MYOANnun2NdBcvUK9V2NOvcVTgJWaVZHxjU9yTUiOkhNYEBLbHeYMhNFTYN1N/F95ggUBHr4LEThtRqhrvdmsdA8Uu+3HVGCi1esVvGZsTqn/VZCRTysNMzJcYrPaoYraovz680yNqLQ5udYXbpp8R4aT9dx2Z2dYSzJuI0030JAfy3XvAXScyIDAaosYCxru5nupl+9v5hUOYUPa3qs1HQzciPcZlz21PQGyBCeOIMuvEQe2a2C4IwiHqxBFz1HqJ2Ke8RaE9nDhqAxnA8IObom4zxjxBuoWsa66IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IF04kLwJvcWRSpUKYQZCRwbO2RFK8dMNffcz3wHE+48=;
 b=kb+BRwAsVozcOHmEu492RIJlc9289CcB3O2dPdZBGIXNYHtjpjcn3UapKPln1nqdIjhLeumzUwmHT9mJxmTiO4MnsRp5+PIPOdcmiCXyWeDvpAW+Yuq44f+jawaB/McOWUodnP6VxRPIRcYzK7RA4Ar2LhbNMSm8GifCwKPEJqH0G4SYWUfzqsw9BYL0VBagZtjaBrPgJ4WwQ4fDO6NjHr8uabV6zDFEmL27usx1A9sEJPhP63F5bwn1yhp0qhYOoLWonlJkxOnTfbEICJieSj3cRdpXh0VUOzfOGhL7s3JrvMdleVok4rpwOppXMjAo036+9Mz4whwB1k5JvqogmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB7PR04MB4268.eurprd04.prod.outlook.com (2603:10a6:5:24::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3391.11; Sun, 27 Sep 2020 05:40:36 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::813a:d38c:ae4e:cac3]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::813a:d38c:ae4e:cac3%7]) with mapi id 15.20.3391.026; Sun, 27 Sep 2020
 05:40:36 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     Zhao Heming <heming.zhao@suse.com>, guoqing.jiang@cloud.ionos.com
Subject: [PATCH] [md-cluster] fix memory leak for bitmap
Date:   Sun, 27 Sep 2020 13:40:13 +0800
Message-Id: <1601185213-7464-1-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0177.apcprd02.prod.outlook.com
 (2603:1096:201:21::13) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.128.189) by HK2PR02CA0177.apcprd02.prod.outlook.com (2603:1096:201:21::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Sun, 27 Sep 2020 05:40:33 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [123.123.128.189]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cbea6a9-81e1-463d-37c9-08d862a7db97
X-MS-TrafficTypeDiagnostic: DB7PR04MB4268:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB42681298371643362AFF25D897340@DB7PR04MB4268.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:341;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TBlonNK5A3a2o8R5Z8gbCLemngm+p64iErbjY00vjur1Kh/uT9KKsHiE1LLmId7Hl3jEcMeIMlIXgwKzH1MkibxIUPvRITCeOG7vMKz2qdSywnFkHVoihDfqMkWgiQ8Wmmt/Hyd7Qf8QJGiN7w/49aLAnVSMdaSLfcZkNjCOO8Ggbw0O0O6KO98Cuar+RvzjJQiQWJXvuqM4mZYRSHJ+78hrDUmrI6ZdWNOyvNOKOg+QLLBA3tjocVuAMTKYfEsia/tiTrBXmFHjpwqISFPcHivzfAKDxOZkZUnrcoZuadYwLpZ8d4jH2EQZBjX3I12vwvAP2dzvtaM37jE5vUJgxxAQ16wWPP7HR2fvfsQJ/ZhVc6nygoMEsytRxis6qphvGzO/EWmguRbACchzF8hqnXlyCNGwaLK31TTyoEXUCO4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(136003)(396003)(66476007)(66556008)(36756003)(66946007)(8886007)(478600001)(6512007)(6666004)(6486002)(26005)(6506007)(316002)(8676002)(52116002)(8936002)(4744005)(186003)(956004)(4326008)(5660300002)(86362001)(2616005)(2906002)(16526019)(9126004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: hVAh3IQxij1phLB/324167wEOvWYgoqX5V8De533Mg1rPkm/19T8QM7t5wJCPlf/+/YPNWsRmhK1vKOhVdr/9omYBafKH5lCKYIYlD+b2jUXysxHybUgosALwfk95tHbfd3K/fAivaj8a+MpqzHxVY/2rTtykxnmIdu9hn9M0MJSqYoknfQrdVqO3HGne//4+QZh6UqZYm52c5ysIKJBcAPnbhpx4N0wxuf5UuJe1nhd8jIwJGAWc1IZceBm4KBq8gmGpwIjLs8b+5CHCj/bEuTyGkwPAXwUqDN4LgwVerXch00t5RoensvhMUuo5P4fDDLIkF7jOa02y3WW5FzAs+FCoSxIa5AXQooNrtdKAtfk0RDxbHkDYI6jLu9xini9rb2qv0WoBqoq2WSYbVdOOu0mltP7MKpd7uCbEnyukocdl/dh99HzjTPlXKRzOmlULJHl+jRqjQoHtkTy2APEvDoQlSswAc1rZ3KHvcAKEhVfw90VnThRmIcDlBz95gCgQWvWtk90gJkMxbwbInrSEizhKfiJFYqKssu0KGN+fsfSnLTkum5IHOikdWrbPuRG6CGGZXuv0Qqp+vejNSqa+l3VOfW21RdGzNvSw0vMLDW0UdcZawQcFYDLQfJq3ZVEqZcLT6+VVauJJKZTo7aHag==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cbea6a9-81e1-463d-37c9-08d862a7db97
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2020 05:40:36.1043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oOIF8XP2aRKJnZkYeHLihIoaYmG4Jo55gZ6g3RbDBYuwH2v49z35bcMgW06tBKMlKmHn9uDXIH6EhvQCC5egsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4268
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

current code doesn't free temporary bitmap memory.

Signed-off-by: Zhao Heming <heming.zhao@suse.com>
---
 drivers/md/md-bitmap.c  | 1 +
 drivers/md/md-cluster.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b10c519..593fe15 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2012,6 +2012,7 @@ int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
 	md_bitmap_unplug(mddev->bitmap);
 	*low = lo;
 	*high = hi;
+	md_bitmap_free(bitmap);
 
 	return rv;
 }
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index d50737e..afbbc55 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1166,6 +1166,7 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
 			 * can't resize bitmap
 			 */
 			goto out;
+		md_bitmap_free(bitmap);
 	}
 
 	return 0;
-- 
1.8.3.1

