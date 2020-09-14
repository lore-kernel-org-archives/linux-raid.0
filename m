Return-Path: <SRS0=PPQD=CX=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4641C433E2
	for <linux-raid@archiver.kernel.org>; Mon, 14 Sep 2020 02:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 739AD2168B
	for <linux-raid@archiver.kernel.org>; Mon, 14 Sep 2020 02:53:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="EJ5t2mfy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725982AbgINCxA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 13 Sep 2020 22:53:00 -0400
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:31180 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725965AbgINCw6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sun, 13 Sep 2020 22:52:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1600051973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=We3QzBFPbcotwLzSpGVnhUjqAnE6TggPxVoNe+DUnVo=;
        b=EJ5t2mfyJc/o6PtBdG+lLScXOGKwYGJx0TaR95pG+j748qPsbN9v0W1u72o//NxTuo4359
        IiTDe7Ivbq7mUXVVMQ/g5yxY/XSz+QksuGjGkx5VJXpfkp8U1F7UK/fTGeHeNuMIXVko6K
        5adovXLOdKoQl4/HGEe0waTHXlx++z0=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2173.outbound.protection.outlook.com [104.47.17.173])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-35-DuWvxSrSNZGi1Jsd9EZOxQ-1; Mon, 14 Sep 2020 04:52:52 +0200
X-MC-Unique: DuWvxSrSNZGi1Jsd9EZOxQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UfMF6AFYhnu6SL8eN727EicDQkBYUdZyBvaJxES+oP66NnKPmQz0pbaI1bP2Ao17xUEfPlQUfEx97t7NupNiCs0QxqvaXkLmWUPHJJcHDeMijv/L7JP82QZayS98o178yoMakYgY9mkUbP4yEbAYAglp6nWb2MxCOb/iOH4L/GdTHgXtu3mvuyyiHCTeWPIZT9Y08pKh13wlSvB7iXGaLF3WBI9Yiu4d80C2Eh4cekCfSDplhCn5B+FOJkGzHExvY54+Q6eEvQIdDCgOtfCQkYiu8MkGmYi5Ax1YSFK6kqzaBS9JxR8AYdmkRDz/K253mj56quPawHjJbYiRhysNOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6B/CMJYhl8crs5g75yXnkJiwtdqZN8fBJqfGGNoUkBY=;
 b=JIXbcqvrno24MHF0WrIAb76CLI87kbRCFRdkAj6svrZoKfAcVh26XhUOlr2b6neKb88GcvUsRGMY3G6D1OGzmxjndQtWAytC9VruHc/lU4fqHfL13q60lVsj6T+OymbA45+zxGL/v2elmnFSTANHD600E7akXqd1i2riT8aI/sSrl1I/6kQqfJUiKv/Rj4/0jzX3k9o1dlcv+E/UOE4JLq1T5nvT039OU0muWoIkoupxjPaCXgf6L+tPD5qKSS7aBT+2EtMVe4tg7/ZNV42AjxCPcohMlCgbewgDbTyEJZSxsWYqPH5PIoderVfx0/5cIZdvqItk/JEYqH27Uf20CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: trained-monkey.org; dkim=none (message not signed)
 header.d=none;trained-monkey.org; dmarc=none action=none
 header.from=suse.com;
Received: from AM0PR04MB6529.eurprd04.prod.outlook.com (2603:10a6:208:16f::21)
 by AM0PR0402MB3314.eurprd04.prod.outlook.com (2603:10a6:208:22::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16; Mon, 14 Sep
 2020 02:52:51 +0000
Received: from AM0PR04MB6529.eurprd04.prod.outlook.com
 ([fe80::c8ac:ffb6:8e0d:36e7]) by AM0PR04MB6529.eurprd04.prod.outlook.com
 ([fe80::c8ac:ffb6:8e0d:36e7%3]) with mapi id 15.20.3348.015; Mon, 14 Sep 2020
 02:52:51 +0000
From:   Lidong Zhong <lidong.zhong@suse.com>
To:     jes@trained-monkey.org
CC:     linux-raid@vger.kernel.org, Lidong Zhong <lidong.zhong@suse.com>
Subject: [PATCH v2] Detail: show correct raid level when the array is inactive
Date:   Mon, 14 Sep 2020 10:52:18 +0800
Message-ID: <20200914025218.7197-1-lidong.zhong@suse.com>
X-Mailer: git-send-email 2.26.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0002.eurprd03.prod.outlook.com
 (2603:10a6:205:2::15) To AM0PR04MB6529.eurprd04.prod.outlook.com
 (2603:10a6:208:16f::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from linux-rzeb.suse (39.71.186.250) by AM4PR0302CA0002.eurprd03.prod.outlook.com (2603:10a6:205:2::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 02:52:49 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [39.71.186.250]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 790ec9a8-67c9-4b90-4c8f-08d858594529
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3314:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB33141F6C2A7B9A890A6651CDF8230@AM0PR0402MB3314.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i9uGTlVf4NI1A0WoN2garAsMjbzYjTLzqrGeOrBCvkf07r6U1W6gMc7HbvHWLMxs9n4RY0RtSkkoZ3rDCHh8N/Yoyw+ATnwZK+6TZrMPX3AVkIfAQrZ2+OR99atWIcnlvzlgoH+vqoa4nj89ogGfD0uQn2Lt0hrkkZbyzNevDI7vMESouW/Q7Xz+NLVRdw9ua3igJDFFOq64EATa3NBMfqCVDBoKz7H6Rkmj29yj/KOC0YEE/B5kXH3dzqm9rrmnov3SET452yRQkc2wmcysMZdecWERaaWHdqAoxjncUjwV7SiVmFvk1zAzLcxRCTaxBdr6ShZURKE/1rvPj8940Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6529.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(366004)(376002)(39850400004)(5660300002)(52116002)(16526019)(66946007)(83380400001)(66476007)(478600001)(66556008)(2616005)(36756003)(107886003)(6486002)(44832011)(956004)(26005)(316002)(186003)(6916009)(1076003)(6666004)(2906002)(6512007)(86362001)(4326008)(8936002)(8676002)(6506007)(8886007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: yKINkGRHJ0+gzftObpgn8lBXKaS2v4ocSZrxiEg9kTUrg8K4NodGZ6EYpdB+Rxmbl/nUZ8inhBTL5zqUfdheOapkCoO+vvmxyaAoqLKgSws4b1hO8ib8vgqw7zhtnjyMCZt6lcfzOcG47fjlrhlurRR9T1fiAoXmDKh44a0DdKsTM+xmtpLBODP2xDZo/kwToqJ67EINo2YteJ+SZ4hk3EABq5iQ+Iljo2C/kEIq/2vxvo1E/7Q01IUK6DJIxnesJkGahOylRevXDeqfZhOwXsFJFj0wX/SPI7AUvB9F1bVKzmY0je5nxVhabyhz9RABEJsMqJMsnu+BjzZOGrfCliaEtBjYNjxQh0SAg5m2Sppu/MpmccuKgB3uHIK5wQZQx2GTLdkiWYax1heguc9vGX0o8DB5t93Wbc9p8TRGMDOfqXdQWBVfDhDuvsihcjBR8QPSPpT2J7HCV1gel1wYl2B3RTfReDT4M8xq9nMr2MsuoCHvZntA6sATB9M6KyuUnVZUKwzREGQ2duiMa7uPaqlxFSGR2IUNzcmwWhngnHzQ4rTA9dCAEHsdF3efddED0gTzM5u8I999Suzq1Y2cT6KJIaTZL6kfNne0s5wvIurTMNF4+/z96Gk+du5JBwfkP1rLA0jthRBq7bkjUdJr0g==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 790ec9a8-67c9-4b90-4c8f-08d858594529
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6529.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 02:52:51.3780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M5WtOGc0OjdGMQy3e3LStgo6UZamgI3OB2ncbdBSAV8XSSJrgIvQePSBwZNTyoyJvCDsXOLauHvO1Is2FIc5zA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3314
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Sometimes the raid level in the output of `mdadm -D /dev/mdX` is
misleading when the array is in inactive state. Here is a testcase for
introduction.
1\ creating a raid1 device with two disks. Specify a different hostname
rather than the real one for later verfication.

node1:~ # mdadm --create /dev/md0 --homehost TESTARRAY -o -l 1 -n 2 /dev/sd=
b
/dev/sdc
2\ remove one of the devices and reboot
3\ show the detail of raid1 device

node1:~ # mdadm -D /dev/md127
/dev/md127:
        Version : 1.2
     Raid Level : raid0
  Total Devices : 1
    Persistence : Superblock is persistent
          State : inactive
Working Devices : 1

You can see that the "Raid Level" in /dev/md127 is raid0 now.
After step 2\ is done, the degraded raid1 device is recognized
as a "foreign" array in 64-md-raid-assembly.rules. And thus the
timer to activate the raid1 device is not triggered. The array
level returned from GET_ARRAY_INFO ioctl is 0. And the string
shown for "Raid Level" is
str =3D map_num(pers, array.level);
And the definition of pers is
mapping_t pers[] =3D {
{ "linear", LEVEL_LINEAR},
{ "raid0", 0},
{ "0", 0}
...
So the misleading "raid0" is shown in this testcase.

Changelog:
v1: don't show "Raid Level" when array is inactive
Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>
---
 Detail.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Detail.c b/Detail.c
index 24eeba0..b6587c8 100644
--- a/Detail.c
+++ b/Detail.c
@@ -224,7 +224,10 @@ int Detail(char *dev, struct context *c)
 	}
=20
 	/* Ok, we have some info to print... */
-	str =3D map_num(pers, array.level);
+	if (inactive)
+		str =3D map_num(pers, info->array.level);
+	else
+		str =3D map_num(pers, array.level);
=20
 	if (c->export) {
 		if (array.raid_disks) {
--=20
2.26.1

