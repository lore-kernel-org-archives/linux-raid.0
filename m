Return-Path: <SRS0=oy2H=DM=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F9C6C4363A
	for <linux-raid@archiver.kernel.org>; Mon,  5 Oct 2020 16:01:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D77D72068E
	for <linux-raid@archiver.kernel.org>; Mon,  5 Oct 2020 16:01:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="mMMNOFLV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgJEQBK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 5 Oct 2020 12:01:10 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:58664 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726760AbgJEQBK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 5 Oct 2020 12:01:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1601913667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2fb8LRnjWEKyDoTn20a9TIhzdD/movpPw3oLOQO+8kk=;
        b=mMMNOFLVtoO3cfj99Vta0dHF3O4NL/3zqLjeAn3sRcoRtzKz5x+OP4AJjJ31x2MECkaHJU
        JAEA4X1RUv9IrxI2MPryo8eFGAj1TPtF5mOU/FNR1DiSQMuQfJyTDdAFd2/8bb7yD3/sa/
        d6DYuvfpsKPcBkYy7F7PDn1AO+/QGi0=
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2051.outbound.protection.outlook.com [104.47.2.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-36-8sUF7fCqMKiA-ui1JOTJrA-1; Mon, 05 Oct 2020 18:01:06 +0200
X-MC-Unique: 8sUF7fCqMKiA-ui1JOTJrA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NCEbW2wUf9GmVR+1zdfITu7ZZ1+vPsM2bd1tnFr8z++m3Y2EENjN6bDxowJQNuIyFMMp8yTk5zLAu6kk57V6phdcuo+pklRwkl7nPWdadmX1AGvFZr6EZGI0hTdzuJCW8MvLRB5NbiLO26BljcbGSpdI1X9WMmB3eeVPeal7LgmIPjdTg8fHiUgtklK3cU/kCG1iPnq3EyPK1RQHCF8p8glivq/oKkwmlNaArU/LBMQrMbaSM1yYOKLpJKUpVUCR3TXL/P86rvEXVbZUdGv3ksIzQiin1WhCOqHTHWRvsqPG4j758VqRn5kdd7WWZh1xrBOfdM0OjoJRU60+Y5os8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2fb8LRnjWEKyDoTn20a9TIhzdD/movpPw3oLOQO+8kk=;
 b=XejEyYFSJbv6+G656lUO3VgtLL+659SE6lUvZJuB+dCcYDd7zxoJ+QkUTBsIefu2VQGqFB+iU78anwnVg+bPpDGRycJb6iP2Nx8gyqb5bODG9TmgbsH5/AKyzGOlVGHCgthYqm/C/l6pOJut0wgMOrMYurzr8OEYSx63fYSRO6UHMEWGinE5yXe5pzSPcQuV8M4O1tQqRj8T6z+OaQj1C7iHKPgfAu5a+BWUXKV6m0G26beLynUeqNkWQnddcsP+nupYGEE0iGfBoPzbHHccQDXD8I6uzVCrPC7jZ7zFZrJrD7mTOn/HrI5VM9whydbE4ybRGF02K+RO7TxIm3Ay1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB7PR04MB5451.eurprd04.prod.outlook.com (2603:10a6:10:8e::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.34; Mon, 5 Oct 2020 16:01:04 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::b59c:e9a2:d279:3904]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::b59c:e9a2:d279:3904%4]) with mapi id 15.20.3433.044; Mon, 5 Oct 2020
 16:01:04 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     Zhao Heming <heming.zhao@suse.com>, guoqing.jiang@cloud.ionos.com
Subject: [PATCH v2 2/2] [md/bitmap] md_bitmap_get_counter returns wrong blocks
Date:   Tue,  6 Oct 2020 00:00:24 +0800
Message-Id: <1601913624-27840-2-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601913624-27840-1-git-send-email-heming.zhao@suse.com>
References: <1601913624-27840-1-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain
X-Originating-IP: [123.123.129.194]
X-ClientProxiedBy: HK2PR02CA0146.apcprd02.prod.outlook.com
 (2603:1096:202:16::30) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.129.194) by HK2PR02CA0146.apcprd02.prod.outlook.com (2603:1096:202:16::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Mon, 5 Oct 2020 16:01:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1137421-4a89-49c2-d459-08d86947dcb4
X-MS-TrafficTypeDiagnostic: DB7PR04MB5451:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB545179609804C0185B678105970C0@DB7PR04MB5451.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a5z8PsQoe3j+0fsmQLQFlU3IUW3ecNuSO9411twTnoWOcMaZFjx7UIdrClq3ciu5cjhUeILMKMPWcZ5KgcnNUu4ODsII6fmquBsbMrWwZwSRgSG46ttKyRZ9l+Z5TwvCKYkT3YEcCnWHJ+mGi3zDBxVBgmWKd+dqehI+77uOr1l9gwtnilNXT+bZDvy9xfh4bcfnKnmhivpHCJUXzYwmKzYpjzx0pQuHO0bO4wiui16UArAUqZP2dDDZnha+bu5YLdwXS0pEOsQA9VlHLvkIFuWTHaTFtbuDVrQYO9YkmoWv/7XF2uVBYA1euUPO5yAbM3KlJj0iVpLOjAAWE2YkPoURgpEPNk0aXPSpd5M8jeIZ4M7yrR+rCRbzP3LdLgky
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39860400002)(346002)(366004)(376002)(52116002)(478600001)(8676002)(316002)(2616005)(956004)(5660300002)(36756003)(6486002)(2906002)(83380400001)(8936002)(66556008)(66476007)(6512007)(186003)(16526019)(26005)(6666004)(4326008)(66946007)(86362001)(8886007)(6506007)(9126004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: irimyt+V0jVl48LdhFVyVeP3QhJq1oN6wL0tny+0ioQdC/op2SqGK2SzWNypBRUwpPErc2d8j3Mc9G6khu/aDOOlW0mPDDJQsD3h2V+4WJUUEFz3cu1yyaxeg4C227uWsOBnWAV0dvwIcOcDFQsMpSeveP1NKPjiW2sX8vEFUmJ3SXqW3fuhCFQWWlbfHip6d7J8/XFyMXK9aamTrbGxjjswRxy4Awhcn9oHebaa+3qKT6w7TrlVbGc9f6cDhRJOmiCagbBOGOorQDiAlGZ4DEMFJ05PIUWWGCwuBILQnkruos8AUw8CaMP8OHehyloJtA8h21uYTXzCfdfOn3M+dlgZ3m1u1mJncZYT8jOcxtt+8iAPDkPKV9660GUTLWT9ah2ZCB0z5jenma5xUZebXyPIUTt3uStt27NAQMvgKnfPEqSiYxrT5o9DHLoX9xBI4+d3iAQqlxZ7h/70EdTjIRRupTlvoCjgB905je3R4R2wOvOU5d6piqmTekoezV9Qu95kvXxPpktW5jHq/MGFOfSTXMxcgMRJu5UkDkylwG9C5mAwS8Fa0syk5efTRwqILX+z7j7XYRp0wsfQ8IhfgpAHxcFrxx8nQ6cErCsStDvADi7tH2xKx2DZA6E6vkGhgTTXT2DhRd1/2IGMi+WCDg==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1137421-4a89-49c2-d459-08d86947dcb4
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2020 16:01:04.3025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5osU/TZAIh+US02xB2IzTlcLArM58QWbZQ4v6fsTvZzCMg3brsNSWadpenw4BLKouQC9rs3rwLssT6g/DakvQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5451
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
v2:
- shorten patch Subject

---
 drivers/md/md-bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 553b6406ba1c..11c75e727b49 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1367,7 +1367,7 @@ __acquires(bitmap->lock)
 	if (bitmap->bp[page].hijacked ||
 	    bitmap->bp[page].map == NULL)
 		csize = ((sector_t)1) << (bitmap->chunkshift +
-					  PAGE_COUNTER_SHIFT - 1);
+					  PAGE_COUNTER_SHIFT);
 	else
 		csize = ((sector_t)1) << bitmap->chunkshift;
 	*blocks = csize - (offset & (csize - 1));
-- 
2.27.0

