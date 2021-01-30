Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38025C433DB
	for <linux-raid@archiver.kernel.org>; Sat, 30 Jan 2021 09:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04BC664E06
	for <linux-raid@archiver.kernel.org>; Sat, 30 Jan 2021 09:52:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbhA3JwB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 30 Jan 2021 04:52:01 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:23126 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231954AbhA3Jvc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sat, 30 Jan 2021 04:51:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1612000223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=C15rPmQ21AYTBZGGKRzbhRuz1H2xek5qTa0ljUHM3mM=;
        b=TUfJK01as4qqrSEy/hJNXWvUnizsigqWkN6Xgby0+e2/ZWd7vWfqJrJFzGtckjo0WCvdKb
        UyLr/CGj+MmtWalSMGkOlgq40k8q69kb0GBL4w7CddOjNYUMK5Y/4QmBRXhF+cV0quzGCS
        1rp5Iwr19Pe9ehSwRds0oYv9ED5c/kg=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2058.outbound.protection.outlook.com [104.47.9.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-21-wMLVZVcMNRyHJlw9DueRlQ-1; Sat, 30 Jan 2021 10:50:20 +0100
X-MC-Unique: wMLVZVcMNRyHJlw9DueRlQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C00ypnUcZZu2H+sXOq5cnYPCVUGw71QNYxc7o8X1CVksa4mskWSMHAfdEGEeevLjcOA0W1TH/RW7u3hkS+Vv2gGu3S+u3Ydfh5VxnyBN1x1OWX1W7Xa7yih1v6DpKx2mlg/xbmxueu6ZUxfnTCNrsH35E1QSXOFIUCC5gSACuqLoZIUSjFk1DDx3fZZvKvw+VWlcJHfGL4dyuYpv7FDwlBDF/tcG44yFz7ia/o/i7tkWpJVr5FQ0AWq8+k/Yiz56wB4zgmlmaw0umpj5bIBEeq1nBLrUfvtoXKoPq9hJhLMEL9aNRi0XUZ7u5EOo9u1UCgn8gG+2NiZxoT9eCNsA8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C15rPmQ21AYTBZGGKRzbhRuz1H2xek5qTa0ljUHM3mM=;
 b=eZXiR5e6HW45+LoeWpD/5JBoXaDZKUz9WjTS1kC65/PWddX3xhCqpuTDbcnLgMYqU7ui1c+ZvW8RfIGhMBmqVMquD9XE/MS9JVoTQVIZxQQ/rZYbsAz2jsKNePqcZneXFK0VuQ3xwok4aqC3Lzw2sIN5CAf1Yru+OJFT14d9/CaO6w7KNJPG/Fvmj2cbMO6h+pA14ZGgUuahNBITvu6L6sovn1hXH1VP6nO0t1zMH7ypGbB+0JRM6f8VURBswIvnSj2ra997J6gNP7J5p/xlUzZygteu6Q4x9BHZYX7ElMazGLGC2KQ80yAAvhmID3JBO+r/2hLfskvWPNZoNte5Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB8PR04MB5820.eurprd04.prod.outlook.com (2603:10a6:10:ae::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.16; Sat, 30 Jan 2021 09:50:18 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::dd78:1e78:3ad2:9d7e]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::dd78:1e78:3ad2:9d7e%5]) with mapi id 15.20.3784.019; Sat, 30 Jan 2021
 09:50:18 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, jes@trained-monkey.org
Cc:     Zhao Heming <heming.zhao@suse.com>, lidong.zhong@suse.com,
        xni@redhat.com
Subject: [PATCH] super1: fix Floating point exception
Date:   Sat, 30 Jan 2021 17:49:54 +0800
Message-Id: <1612000194-6015-1-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [123.123.128.203]
X-ClientProxiedBy: HK2PR02CA0204.apcprd02.prod.outlook.com
 (2603:1096:201:20::16) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.128.203) by HK2PR02CA0204.apcprd02.prod.outlook.com (2603:1096:201:20::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Sat, 30 Jan 2021 09:50:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ae06dfc-2429-4ee3-8f65-08d8c5047389
X-MS-TrafficTypeDiagnostic: DB8PR04MB5820:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB582064A495685697CA58BA4F97B89@DB8PR04MB5820.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:66;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 73KklIyF3k6jcLpjylzYkiQSrezUh7d2jMyTgbx9k1Lv6QORQk35UjsvdzGPbuV+QwSoHoNB72HASqbvzKyuNqur9iz6BFpBu3rjZ10XcZAVA47WdeSx8Q4eF6thI4gJNWboVLctOJ0C9enuoPgI87PODX1X1x9BU6S5+dNr2L1NKt1FGaxGK7YLbaHR6lHDjSNDsM0zn3zxr4YETk/c3IO8uVzkocTaT26YeTxi0dR5yB6bWNXkLz/3T0xnFmn4smJwk0hVs8nTgmAwzcD/QSwWorlgrH/NeOifjDuiURQaFT7DS5sAQivVHnrGtBjMWaa1pvP956ui0KywWifpfRzdRUP15lC8NCCsTxFDive4M6Ol1tnbyDvRnZVjMZYtrjO107M4lx9OnEQOtqZTgYttXKnCYT77A83JlC/VjoHIgPOOXYbUgaviF2t9B2mVB7bqLerJPsk5eddoknmHkqs1s9HNjynxSof2h62PrfPcFjoDvbx7fcyf44B0nPoz/UEFai52jggSiqC/JCqb8ZvCDCas2nM65r3nS9gsCb6IQUAGBl/SmCPXZgpCkziN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39860400002)(136003)(366004)(396003)(6512007)(66556008)(8936002)(66476007)(83380400001)(8886007)(36756003)(6666004)(52116002)(5660300002)(478600001)(4744005)(66946007)(186003)(4326008)(316002)(6506007)(956004)(2616005)(86362001)(2906002)(26005)(8676002)(6486002)(16526019)(9126006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?oABrZ4yvMdVndWYNRyIPD7MdgWME456xhoU5OFE+h/WWNSM9uN6/pd5AC/AA?=
 =?us-ascii?Q?9Vj5TXelOzsxKgtBVP5iEMp726bwO7lVA7Yb8twV/7x6l5o1xaFqAo3y75my?=
 =?us-ascii?Q?0LSPlU2BLpKoBU0tUY35cA4N+6Dw7igxdrpUEn99fexBg2ebi//I8a7WQAoe?=
 =?us-ascii?Q?Tlc1YUNGxhoe/OQg1FFiH8y4iDlG+Oxwnc1l8lBKmthl+B1fiQTnBWGw2msv?=
 =?us-ascii?Q?7yG33eFAtBYAFaYfJJlnNgROMurz4PNzADhcdhAi/wLbuGiVAODy3lf665KF?=
 =?us-ascii?Q?enJA0zE5P2aAGikGg7safAMlKqK49hmbvFv/sv8iohj8LNxJMIm6X8+gBTxe?=
 =?us-ascii?Q?Q63dNJE71/iekjJsHZRmR7KjTiW7RsaCPbl2/yNqmvwgN2aJC63fYX5+YjQb?=
 =?us-ascii?Q?fbJki3A7ReP1P9Q5YQ5slshdEznFkvb/sV3rtqm12itLqsGp8lgvXROcO33Z?=
 =?us-ascii?Q?QWu9mr8UUW/Akcm3p51k0R2XKkHyIlXbLupY9Yoqv6s750J2AfJUsKGzvkDK?=
 =?us-ascii?Q?DxOjc2JxfzberHdDLmBbDQnp1u5DqO2MtqzH8gCXGwej+KmcWqdycy+Yn3Pl?=
 =?us-ascii?Q?bnIUdvri43Ta3ka7ookzwqnYMn4eRK+XUGlxjgUbl4GDD9aK+luHbM0ISncO?=
 =?us-ascii?Q?xtkXKs6tjFknVDFS/vUOgX3pbYurCwOI0T5r3KVINepPQoaqrSspUMhdRMTw?=
 =?us-ascii?Q?tXHCnArLocmiH1KiAVleSLDcs97DzV3EcgZCFjZ2gpMMdNBuA7Sj4031ex+s?=
 =?us-ascii?Q?mGzMblH+ISagAjUSk8bAEotpyp1SHA/VQfgFwmlgPwQkSN2brZAzGXZLdppv?=
 =?us-ascii?Q?M4yvW0UbhLOOGSIoabrbpfnWBqKjglEbvjsqFlDkRwxu3+C25e3PA4G1UrAn?=
 =?us-ascii?Q?ktzEDtTxmPLG4m+TBqtuKwy7LPKY9cqXkg9eT1vII7DaL5ECFBoXip9YORSi?=
 =?us-ascii?Q?GKsBHef8USbWpWJxlyNdQl3XbReOaMJoGVp0FWJgfsaQfHBjG4enw7POKkuF?=
 =?us-ascii?Q?xvLElW4sI9wKeghgpq8d4LZsIBiRldr2rfWPf24kyoXjUgXHbUQf+y1/oL+x?=
 =?us-ascii?Q?W7WR3EBL?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ae06dfc-2429-4ee3-8f65-08d8c5047389
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2021 09:50:18.8147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /nK2+7T/HJunkUCQm7ZfdnuAqs7jq/yUsopV8X9Tx2FcoUbRaNHQ/C8dWMu65xLtVD7TZ16v4noKcmxuF/l7aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5820
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

write_bitmap1 didn't check return value of locate_bitmap1, which will
operate bitmap area under invalid bitmap info.

mdadm core dumped when doing below steps:
```
node1 # mdadm -C /dev/md0 -b none -e 1.2 -n 2 -l mirror /dev/sda /dev/sdb
node1 # mdadm -Ss
node1 # mdadm -A -U home-cluster --home-cluster=abc /dev/md0 /dev/sda /dev/sdb
Floating point exception (core dumped)
```

Signed-off-by: Zhao Heming <heming.zhao@suse.com>
---
 super1.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/super1.c b/super1.c
index 8b0d6ff..19fe6f5 100644
--- a/super1.c
+++ b/super1.c
@@ -2683,7 +2683,10 @@ static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update
 
 	init_afd(&afd, fd);
 
-	locate_bitmap1(st, fd, 0);
+	if (locate_bitmap1(st, fd, 0) < 0) {
+		pr_err("Error: Invalid bitmap\n");
+		return -EINVAL;
+	}
 
 	if (posix_memalign(&buf, 4096, 4096))
 		return -ENOMEM;
-- 
2.29.2

