Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D65D1C2D0A3
	for <linux-raid@archiver.kernel.org>; Tue, 10 Nov 2020 02:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 611E6206D8
	for <linux-raid@archiver.kernel.org>; Tue, 10 Nov 2020 02:31:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="YzFupycv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729451AbgKJCbG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 Nov 2020 21:31:06 -0500
Received: from de-smtp-delivery-52.mimecast.com ([62.140.7.52]:58589 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727311AbgKJCbG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 9 Nov 2020 21:31:06 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Nov 2020 21:31:04 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1604975463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=onKzk7q1l99wlQpNZEVFb9JNUhi+AC3wwnsdcFIJFD4=;
        b=YzFupycvBGJbTP58p/eNfyju/xx5/gQmH3zLPNl1r0/mXrJQIqHhfZ6LbSzBLs0WmdvtcP
        FluRf75iI0ssOeZBw4CliO5SHs963gc2eWc8+aoyS7QQNxJBLxyQe5U6wvMyP/NYL9rSg6
        q20GJQq6KnC+s/oGfb/GNzrEETfCjP0=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2059.outbound.protection.outlook.com [104.47.13.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-9-vsRz_JVuOR2BdowgvAyR_g-1;
 Tue, 10 Nov 2020 03:24:49 +0100
X-MC-Unique: vsRz_JVuOR2BdowgvAyR_g-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hvk8Fc9OuGsyocmSwDFn17DUvE0mDtGgufuiYg/9Cx4HRTSAX/Ee0ExDdcJJuHu5B5twRPJZ+s+GXP8VGEAChQqbWkb7tCS2SIA5FizMEUDpreidEq+RDkJK0qCaCKdsHUdeDuj8e6I3I1cGQEEysbHYyBgbyp/NvBTdfzzbn5TRLm3be+zhvywOfA/PqgUAihWFWjvJlHWtx8Wovg3cCW9nHRUzr/FUZ39XiseBlF4U6KRvhD2FxTUWMvR2v7cYfMTSD/HLh55C57Tip1eZ9yv/8T4CxSisKfF30HPJv4UqE697j/D1mtrf3EwV2RwIiguGyguVJ0c5DK/5r5WtFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=onKzk7q1l99wlQpNZEVFb9JNUhi+AC3wwnsdcFIJFD4=;
 b=KmN+iWEfHqXKroTA+h/adu9raSCN62hxBUpmlzkQ9mC4WN6gzThkIoOLQuD8BFNBJ5h0Vh9XyGyl5VKPyY0jV7nBqGBWK9Bq37zME3eO6Xy4Uzm8WGBJTvzb2s/l+kiLEmnuI4+8aH8c1XYInMRp7Kcnadt9jKimRZ8SnoAPIkQ/sxlIKHdb0Mil0+INmvTVSzLsjfOmzPySHndc9WhS5KyHyKmfMnCyWxNMKtmRo/xWc/++IGO0CSbCwBqTpsyDiclww1zVN+9wj/DHgcpa7oMDJb2dgD5dun4g0wb4GMO9hniudnPxRtzmtOgPPCbTteS05sciVIaHN2hFc2IqnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB7PR04MB5449.eurprd04.prod.outlook.com (2603:10a6:10:8d::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3499.27; Tue, 10 Nov 2020 02:24:47 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a%7]) with mapi id 15.20.3541.025; Tue, 10 Nov 2020
 02:24:47 +0000
Subject: Re: [PATCH 2/2] md/cluster: fix deadlock when doing reshape job
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        lidong.zhong@suse.com, Xiao Ni <xni@redhat.com>,
        NeilBrown <neilb@suse.de>, Coly Li <colyli@suse.de>
References: <1604847181-22086-1-git-send-email-heming.zhao@suse.com>
 <1604847181-22086-3-git-send-email-heming.zhao@suse.com>
 <6dee90a2-4074-c3fd-a4ec-5e006a236b7a@suse.com>
 <CAPhsuW5b1LCNNZAarCE7xTHkYe4u4psQ3cxP5KWA0hLRr0n+VA@mail.gmail.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <99ef70b6-1967-5bd6-40e7-4824747fe886@suse.com>
Date:   Tue, 10 Nov 2020 10:24:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <CAPhsuW5b1LCNNZAarCE7xTHkYe4u4psQ3cxP5KWA0hLRr0n+VA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.132.155]
X-ClientProxiedBy: HK2PR0302CA0002.apcprd03.prod.outlook.com
 (2603:1096:202::12) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.132.155) by HK2PR0302CA0002.apcprd03.prod.outlook.com (2603:1096:202::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.13 via Frontend Transport; Tue, 10 Nov 2020 02:24:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ed2c632-6e48-428e-4fd9-08d8851fcb4d
X-MS-TrafficTypeDiagnostic: DB7PR04MB5449:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB544963CE0E1051C121F2B37D97E90@DB7PR04MB5449.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: idjUz2KKCljyDNBGVafWUDhPpwOl0V+XQL4yoSjACUec3OJcKTBDLg2wnjJ2n7WYXe8lVIEz5s+JgJ9Wx3WHIrq/gWUYBNHjjgJ7MUYn7ejLAqncairWR6dp/jPUYA+cYOWK9Sy4bEOctcNvrDG1EYee7o2ep6Rd5y0lbJAuvOmP8bGxCSb7v6Golchx09K6y/VMBfew5YaJkMaR3zVz0oyHznCZf+FxLGot1TwUx+sfg4/3XD+vIQQVPTw3NKWrqGJ2DAMPCYlNFtCTU1fFg2pt3fez/vIRzwWjl/TOJZ76yFAwh2ScDQjPjc4rDh7DUte3Gu4Os+RMIVB0xmunoOsFA2XwFaQYAcTrqxh/ljEJQqIc2xd8fgKb47lE6IXY2ltute7seCTh9hOmtfOE4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39850400004)(346002)(366004)(376002)(54906003)(31686004)(66556008)(66476007)(6666004)(2616005)(66946007)(956004)(8886007)(83380400001)(6916009)(4326008)(6486002)(8936002)(478600001)(316002)(31696002)(2906002)(6506007)(16526019)(53546011)(8676002)(186003)(36756003)(26005)(6512007)(52116002)(86362001)(5660300002)(9126006)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6GaF0J4iA4GfFVa/pTF9cZZRoK/PTr1YaaKxcw02NzsSC/g3+XrKbaxSCRDeTXxKvTvBaTer+w4EmMylxY1A5KDA6X4Y6iTXy5VWGvsvOLeAlOyTnhf2NlXtrNkMh0fOCyhdLQfvvFmA1zxz9HNNTihp0jXOP5N+Afoq8IhOHasTN0s3SLfoUiMTYbWgE2dxS8w+Z5/5hjKmMceIajNoqPlnCwtV9pQZFxE8NS1AmHpky15PbOu0DxfNjVoo3QfaYdanH30G9xqgnJFbjfRHTVGbWQODee04lGmAq3PY+2QT1K3224b/g8wPnauA6n2qBmeiF2e4CpCJaDlO27k/RIWIz+kTNB3pwBrluXz9NkqQKHQKKi32XFPyIsBBFbJSZxJ9fpacUu8g1Pm3ZshrtcuraUwEABP1G90zgpGNLuJK4nULNKdb9a+57WtZhScc7IJrPlYtC0aTYEIQr/TH8VC5Fuzh915z7GXrYjLDIgt1jSN+kTqh1q9ajxSjiBTkEaHz2X4lp/28p/K8mZ2zt9FSGmTdtLQ3Cd9Znayi4YhpR1KSGcr1gjsKu6KU8VeuFUq3GJrVzLm/4EDDsfH+A5Nzkw6Gx8KyJOcWJc3roNqdqSlJcPxUsXCt5zsFgIQnB+o2mCH1AadQh3mC636HuA==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ed2c632-6e48-428e-4fd9-08d8851fcb4d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2020 02:24:47.5396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2XiDsAgMGIJNUidZC5b2wQkdBa7vZ8zVpryeKfw+YWkeTm9dkSOvnTDQyYfQ6yy+Qoyd+s843OO/3LxF7Cz6OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5449
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/10/20 2:06 AM, Song Liu wrote:
> On Sun, Nov 8, 2020 at 6:02 PM heming.zhao@suse.com
> <heming.zhao@suse.com> wrote:
>>
>> Please note, I gave two solutions for this bug in cover-letter.
>> This patch uses solution 2. For detail, please check cover-letter.
>>
>> Thank you.
>>
> 
> [...]
> 
>>>
>>> How to fix:
>>>
>>> There are two sides to fix (or break the dead loop):
>>> 1. on sending msg side, modify lock_comm, change it to return
>>>      success/failed.
>>>      This will make mdadm cmd return error when lock_comm is timeout.
>>> 2. on receiving msg side, process_metadata_update need to add error
>>>      handling.
>>>      currently, other msg types won't trigger error or error doesn't need
>>>      to return sender. So only process_metadata_update need to modify.
>>>
>>> Ether of 1 & 2 can fix the hunging issue, but I prefer fix on both side.
>>>
> 
> Similar comments on how to make the commit log easy to understand.
> Besides that, please split the change into two commits, for fix #1 and #2
> respectively.
> 

My comment meaning is that solution 2 also has two sub-solutions: sending side or receiving side.
(but in fact, there are 3 sub-solutions: sending, receiving & both sides)

sending side, related with patch 2 functions: sendmsg & lock_comm
 (code flow: sendmsg => lock_comm)

receiving side, related with patch 2 functions: process_recvd_msg & process_metadata_update
 (code flow: process_recvd_msg => process_metadata_update)

To break any side waiting can break deadlock. In the patch 2, my fix is both sides.

