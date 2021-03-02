Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FCCCC28E85
	for <linux-raid@archiver.kernel.org>; Wed,  3 Mar 2021 01:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08F4264FAB
	for <linux-raid@archiver.kernel.org>; Wed,  3 Mar 2021 01:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242022AbhCCBPF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Mar 2021 20:15:05 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:25583 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1381892AbhCBIr0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Mar 2021 03:47:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1614674775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C15rPmQ21AYTBZGGKRzbhRuz1H2xek5qTa0ljUHM3mM=;
        b=T8BF55qN2ESEAL8c6aQJ6OrCuC8UCeu2zRR7AK1H7Q/+6rmrQxlfRIfv7Cm5ZR7ONUc5E9
        y5EB4zoX+CY5fHP7uJDeB/wzO7ZNp//4QhvQMpG9MvJQuSQ7pFPayVm63WF+IN3vderjvN
        dh4bIispBqQNKV7X4GL6RGbZakJbPKU=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2051.outbound.protection.outlook.com [104.47.1.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-24-NlJPAGgfN5ab73b02AFuFw-1; Tue, 02 Mar 2021 09:35:05 +0100
X-MC-Unique: NlJPAGgfN5ab73b02AFuFw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQj6lw1uohnS00FyI4GH8uVOYZZr8CqdfXs10OC9NgipKkFMQZuydxnUJoFTBn8T84uh0kfb9lIHHkFKDtTHt/qSJ/U1iRgZ/OtyUZELrzRgcpQocghZADcJEsPCAx02UjGq/ucF1GemROckrqRmmQODL4Cx+Wxip1meDK6uT3QzvNoeelfojVzd276t5tx/x7TA+9/vK3vBfsLdL8EzoCjPPzDJEkpJYgEoq0yDeKGZrIXTctZsb18xprNE34T0PqBGJ6MKqXdSzxxAatARghRRHzSJTjCzRwGTgyU+uFRLQa1I+lbX9EToDUJ8kUTnFJC3TxOrjD5yUdlto8o14Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C15rPmQ21AYTBZGGKRzbhRuz1H2xek5qTa0ljUHM3mM=;
 b=Pr3Bp6xqw19JE4dQwj7gpJhqm3+uX8Nbd8M2PUzSIosbgtNQ2EMDACz6yJzxTyELB4B4bAkVgElcwGu4jlifCjJuRSzWUID30b7Nqa8vBFOufTBVEOVHCPLuub1l1+lQ/fyFuAW4sh9cLRnJvx0dHG4wcaBzIAdAd2YSLqHLBYy2MXqpIuzz3jHKMzce9YfuYAMkDxbLeqd2KGoQCFF3JDPjx3GqVVVjex2IE/meYcCoSkxytSIGvbJepBHZhSLU42FgK8qLb6J3DZw9E2Lu2QgJpPv4E4bKWKd/qI+iVc5Zi0jqqF7DxeCiQIULlqOBIk/rNbdupRlqfP7QysqZ3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB7PR04MB4266.eurprd04.prod.outlook.com (2603:10a6:5:25::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.28; Tue, 2 Mar 2021 08:35:02 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393%4]) with mapi id 15.20.3890.029; Tue, 2 Mar 2021
 08:35:02 +0000
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Subject: resend: [PATCH mdadm] super1: fix Floating point exception
To:     linux-raid@vger.kernel.org, jes@trained-monkey.org
Cc:     Zhao Heming <heming.zhao@suse.com>, lidong.zhong@suse.com,
        xni@redhat.com
References: <1612000194-6015-1-git-send-email-heming.zhao@suse.com>
Message-ID: <eea9f918-0366-7ae6-218b-cd5a87386275@suse.com>
Date:   Tue, 2 Mar 2021 16:34:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <1612000194-6015-1-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.132.117]
X-ClientProxiedBy: HKAPR03CA0009.apcprd03.prod.outlook.com
 (2603:1096:203:c8::14) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.132.117) by HKAPR03CA0009.apcprd03.prod.outlook.com (2603:1096:203:c8::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.9 via Frontend Transport; Tue, 2 Mar 2021 08:35:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fe9e135-d7cf-45ea-4801-08d8dd5612ca
X-MS-TrafficTypeDiagnostic: DB7PR04MB4266:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB42666481661A2555DAAB3AA597999@DB7PR04MB4266.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:66;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oHWthPlo5f8Y8gt4+vml7KyBA8CaAVVcr4Qghcj/BAD25SYyUKFx6gyyorpOYhmPPDic3lzPnwBdE4z0lHURopUI59h4XnncAvjf/9CUzqOgdgyUnQ8e/J74UDj+jpW3bRQ0iMUFcAF7ugiP0f/zrzuIw98+UIR71v9TDYDWQIFwJOxo6X3XWEVfleEF+zffX/9P8QPkpXYd9Ow9ovJypWK/TABvpVEQHQWSDrgfNf+AbIV/ISDCoo/iGe6a7hTNcR2nLNUBq7bKJmRE2xbJu7zgHE6vDFUrv8Tyfbz+dA5Vyy20hgsE5csjTAZAn5cD6bV567k+6mwaH1w9tZZ+VFaqby0q+rNeqrrSWU2O8VD1E9lia/5lq0h9U3Zsi2XUzhcFq19f6D50Qoxa16xlqHKiCdSckZFwu8hU7NPXISmwkbi+ChwFOaMYVKD4pCXWIC7PM3jQm+mgZHN/2nMEoimC/4VIisEVWFnq+LrC+L4n+UxkhUNFtWjfDAsPPoH7sHf5UPVncwatrz66v51MVIfYfkCTt6OPiftr5KRkXldYWaF7pn+pXQrKoSeV+SLCwZZoLQvSc/IPIGOCJGuIHGNuEQBDIA7OSMGYySDYEhOW/cLZE1YR+aL6QShFFGDg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39850400004)(366004)(136003)(376002)(396003)(5660300002)(86362001)(6506007)(8676002)(4744005)(31696002)(4326008)(31686004)(16526019)(66946007)(66556008)(66476007)(83380400001)(6512007)(52116002)(8936002)(316002)(186003)(478600001)(6666004)(6486002)(26005)(956004)(36756003)(2616005)(2906002)(8886007)(9126006)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?bJFYZFZbPmL/59P1hrSG1VMIROA+8pe8n/Qky+wBqCRXKIBPObQaU4xi?=
 =?Windows-1252?Q?Xbj4u2n2eBSAZXiY1MlPFqxwdkgN6CvX8F5gYKijLGhHBes8bRpaVJme?=
 =?Windows-1252?Q?Elj0c9ZhDq31mhAazjtLbEgIdFhVCNG42aSSTm364uuRUb6KNvm2ztmD?=
 =?Windows-1252?Q?p1M3cRuijUqGB3WLAo3f/ZfC7DKq08P5kkGKSehDBUG0N/bE0+qbeWcO?=
 =?Windows-1252?Q?K1S8njlkoce4tySPHIfSuddY1uW8Eg+88gkK36tfKdZ2TAdArLB8g380?=
 =?Windows-1252?Q?SQ5TdVfJZ6PRhkulpGQ/vBOAfG+S0F6BF4L5ljSg8vkl4kd9MRmJaFux?=
 =?Windows-1252?Q?PRr6B1BbtzHtb5vgG+wMwUUF5PT8A3Y3yaGwTGF6ssUvTSI7irMLfscG?=
 =?Windows-1252?Q?E2YA8oNGQKGqGw3BuB8AvXfbSqn5iJ08zR2oIgFkkElIlC4/ImLwx96C?=
 =?Windows-1252?Q?wDhkXjwsmL+SAMrP1kQKmEbjYUFPwQ6zYFoM0NEI3SfTJiEh2YiFXdyR?=
 =?Windows-1252?Q?lku7x7p+aZllYhOTCXuMkigV81quEQTOCMtnX9QMhuuSy0UdUqbn8MDj?=
 =?Windows-1252?Q?ndkvKh2WMzQNaL9pjzIA36UTXg3qwCF6AomYxMcr5sxbIuagoPIUvXRk?=
 =?Windows-1252?Q?p2a7OF8QuwdF8D4gfMff7izw4KXqhVxaYEGf+fog9yYS25ZYa4qf05Dp?=
 =?Windows-1252?Q?l2SXciCPb82uaw1krk4APsST/OP67awSrmckaU3pTxtn4t+eGAp4/Lu8?=
 =?Windows-1252?Q?vrWBsXZlUBOTYD18sXlGdk1OJhwnX89xYsgFgHmn3S4V1eUb1ksjLHuM?=
 =?Windows-1252?Q?TyDaQTLmrvYP/B8PszduW/unN2corhhS9QdAK0kD5fQAsU1FHjL7Z9H4?=
 =?Windows-1252?Q?arpqbCpgLVNIisCRL0Ou0GVgxuXNjAOzsxUnOtymGXYHCRyvnIHnUWxQ?=
 =?Windows-1252?Q?lXHIlFBOjhYjGyJs+HvUOg9/tiaBWZLimjpXdOJqnVBbgHH/eAiqlR3d?=
 =?Windows-1252?Q?6tstp56Bz7KLy72f3ZC0xXISAr7eX7D3AwzYd09ynHJV0R3L2b8z1xpO?=
 =?Windows-1252?Q?79YyaC9xIpSVMBcYkNIjvRYf/qKJ/WazvWJRAJQXPUSy98xFI/9Or/cv?=
 =?Windows-1252?Q?zUMKY+Eix3BcAkEVKgMZCG9fpe0+OmrlrU+D5lFoJcqeTD923dzColDV?=
 =?Windows-1252?Q?7ud9P77CdLtP06bHmH9KwiCUdrX398JjAupK367PGktckcWnMwtQXtd2?=
 =?Windows-1252?Q?c9RRuT74FkMuDcL0SvG4WMeUX0gnTsVfQQqBD8wVYOR8SUI/gACthuyE?=
 =?Windows-1252?Q?4wbG+iTCwF31nivizSlMQ1KG19KqfFNCsFH1a++TBoR6NVJMvQSWlZrm?=
 =?Windows-1252?Q?Dzp0nE6wR7OJqt4u/tvZqGaW+WRIZjuknQk8nrI2LMTB9vSTEoLZWrDZ?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fe9e135-d7cf-45ea-4801-08d8dd5612ca
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2021 08:35:02.7256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w5E0Bm3Y9IzMvnNi9b5EvPh7h4AoUU+VQ2ml/vZA4AOTzFPOQP40SuiA3lK95g1uS83eeVEp+SVALXkRqeA7Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4266
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

