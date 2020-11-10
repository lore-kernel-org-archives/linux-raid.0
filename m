Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF1B5C388F7
	for <linux-raid@archiver.kernel.org>; Tue, 10 Nov 2020 16:07:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6307120797
	for <linux-raid@archiver.kernel.org>; Tue, 10 Nov 2020 16:07:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="QsLRucXO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730468AbgKJQHD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 10 Nov 2020 11:07:03 -0500
Received: from de-smtp-delivery-52.mimecast.com ([62.140.7.52]:59885 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729909AbgKJQHC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 10 Nov 2020 11:07:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1605024421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vIn/rvE3xm47nWwyciZcnhnjGKId/gvIIY+dTMVkokA=;
        b=QsLRucXOu+j3w5Nppdn2SWjCmNUewcxqKgImKBdLPwD/zoQ3V0kta2sIdsBtueXacJy/JQ
        q1VmMq9zd/SyX7j5FwC7XbHT3YL5tRFCOdaZVUtg9Td+mfGfjuu/sB7Fmx6b5D40tTWvkV
        CJF736PnY/obL219TXbU5rfXNzm+/yM=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2050.outbound.protection.outlook.com [104.47.8.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-36-2F0mbHr8PGWtX7g0_k1N4g-1; Tue, 10 Nov 2020 17:06:59 +0100
X-MC-Unique: 2F0mbHr8PGWtX7g0_k1N4g-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=djzMHK1g6P5Z5tmXCMfSwnslIF4/fcCn2Ob5wUr2yXet5Feniz6t8nvrq8OxcDWACPZfQJjETDRT56u4KvLf1chQdLaFjrp49X6txeBLEeEkn4YX76TWJMNyumjrTxLWLD9YZsSg2DKHkf/Xu3tWE2wm9EfgT2CJOrL7OHD6tVmVb8i69EW03yv8t3BPgqO8l+7Gx9ku3W7WNkvdWdy8W4Yr9gbTxBCfkGfaWbZoMH59yvB0DGpFyXTDcjoCn6WswmKlFSLMZ5ANW4KmlB4/tf8pFs+OJWAKFCa+VfTZibaxf/en+D2cg4xI9EY4ZR3meGu8Ja0qF6TVBuUo0REG5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vIn/rvE3xm47nWwyciZcnhnjGKId/gvIIY+dTMVkokA=;
 b=d1vMRd1b3FVXbYp7u/WED/gBTQOQBJDR/NEufV+Uh/hxAAGdR1N1bjtz17eSwaJ2TVgV13mS85IFGadJm014aYVtXXr6c5XA5RhxUmSbTIIfT6UPl5prcdWM21pmgqDGT1LLB/DrnZP9vqV5G3rvLpzBjPU0GOkBNksuVn7niuxssPaTY1HK/TCP9tly+xBh/azO4NiNvR3eZy2oNKfwmnOlp5l35azyhEJo4gNypMxEPVhfZjxEk55nawu2HkETCvC+gB0EnplLujU7Zjy853nikg6D+MuvLci9Wb/Kl9hOxEG1cfOjDfg/VeB1Wrc2iqlEQXjSge2y1KmY2i3Ktw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DBAPR04MB7415.eurprd04.prod.outlook.com (2603:10a6:10:1aa::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Tue, 10 Nov 2020 16:06:56 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a%7]) with mapi id 15.20.3541.025; Tue, 10 Nov 2020
 16:06:56 +0000
Subject: Re: [PATCH v2] md/cluster: block reshape requests with resync job
 initiated from remote node
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@cloud.ionos.com
Cc:     lidong.zhong@suse.com, xni@redhat.com, neilb@suse.de,
        colyli@suse.de
References: <1605023409-1994-1-git-send-email-heming.zhao@suse.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <908ab160-ab34-2416-617b-0d7f22063acd@suse.com>
Date:   Wed, 11 Nov 2020 00:06:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <1605023409-1994-1-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.132.155]
X-ClientProxiedBy: HK2PR02CA0169.apcprd02.prod.outlook.com
 (2603:1096:201:1f::29) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.132.155) by HK2PR02CA0169.apcprd02.prod.outlook.com (2603:1096:201:1f::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Tue, 10 Nov 2020 16:06:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77f1c141-4c48-46e1-9e4b-08d88592a5ae
X-MS-TrafficTypeDiagnostic: DBAPR04MB7415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7415ED0EEC943B57F2C7ED6F97E90@DBAPR04MB7415.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PfEQZGgaY0tVOxUR5WqF5hptlrum+QBQdJe4WghfoKnA2aBeZOYGJ+jCLdHNb6TDTcHJ73FpJ1vNXVtmhGr3OxL31mVEkxzn2zNmgH2wALT+5SJwMAr1qYoVyXalIHnYtu3DcbXmvvNAqE60jmnoDCdc+e6ENlVgkdePFdwZXPAabw41nN2uNnDpCeRAJ6/HDk92zi3d451cHOjb54B1xRO6xpRppNM/iXvrulEv2qwqWG4G120DRg/IVTH+OYGGv+flWtz1bxHO3ofjN/2m+U4UvC3WNiBOgfbsoKZ16pvWYeboMGt3Nu2IB7tG/N7hmcB5XtLevUXBslUROZhKyHqtLkl7HMrVRyU74w1aMGIOsv+vRBPRKHbRmyDnTV/Yd3qeuibeT5Nvl4YLB7v4Pg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(39850400004)(396003)(376002)(83380400001)(8936002)(31686004)(8886007)(478600001)(26005)(16526019)(186003)(4326008)(53546011)(6506007)(8676002)(956004)(2616005)(6512007)(52116002)(66556008)(66476007)(66946007)(36756003)(316002)(5660300002)(2906002)(86362001)(6666004)(31696002)(6486002)(9126006)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HFX6X7BxYTPCgPf6DppjjUPkKixDmDGsmIZ2fatq+n9taK0BON7WtsPArj1xVHYWX+toS9po8kKE5y+71S51smqp0RUEYelVtgSab9/1JJb9+HWdlbUL+lkd6UcSr0uY0r0f7AAJNoeQmmzH36Y3KwxlH6Tm75a1MlwDUvypCmtTkL67r5h1wQ6V7CUPixIhuvriwGHv5E0HZbNb8MXZ6kXIbeRVR3GrIjJRgSfOFAU9nckvjbb4/zY3lBgMfvIQU+VarYOEOizaEAVVnthFb/J9SmRXcyShkf9qnyLvJM73q/EUG6nDbQ1owcEtdDsPy/9vxbNyLKU8+SqzW///qHrualfnnJwuS5ym6JDuhyUNFHf/MHuzSFW/L1hmCdiBvFiMY8on+FpByHA6pEFI9ro89oQjRdCeuRzfEHOPkqEcu8uluN1/Scj3WHsZgQnTBADjl0QJm8bvIgIfdIphUBGTh4XmGqlMLJFlvzxx8GXs7SmeCqhSj2cUsoo3H4Vh0yZAFBDtYur9Lhi9vNUHhHaGGHtgsK+0IxDziqnd3S4q2PDN6AwDf/nn60bOvUpgnZTh0JbV7GLnfIRTsK0ix7BVJ7n1nAA0Kd7XHSG8rPDc2siWzIMjOKRkxzo+wbJPYyyQNG9b/VNROD5Cf0H+8Q==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77f1c141-4c48-46e1-9e4b-08d88592a5ae
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2020 16:06:56.5988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tvHsrIsh5LPguel0sb0utLRt87zXejJCVArgKQWEmsKxiWUzwEnSAPrAbkntgiVhbcAAx5vxfW+FVAGMTMHn8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7415
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Song & Guoqing,

Thank you for your kindly review.
I feel it's unclear and mess up to put patch 1 & 2 together.
So I split them and first send patch 1 for review.

I am not sure whether I should add "reviewd-by Song & Guoqing" in comments.
Because the code is correct, comments need to revise.

btw,
For patch 2, I need some time to answer Guoqing's question. please wait.

Thanks.

On 11/10/20 11:50 PM, Zhao Heming wrote:
> In cluster env, a node can start resync job when the resync cmd was
> executed on a different node. Reshape requests should be blocked for
> resync job initiated by any node. Current code only checks local resync
> condition to block reshape requests. This results in a chaos result when
> resync was doing on different node.
> 
> Fix this by adding the extra check MD_RESYNCING_REMOTE.
> 
> ... ...
>
> Signed-off-by: Zhao Heming <heming.zhao@suse.com>
> ---
> v2:
> - for clearly, split patch-v1 into two single patch to review.
> - revise patch subject & comments.
> - add test result in comments.
> 
> v1:
> - add cover-letter
> - add more descriptions in commit log
> 
> v0:
> - create 2 patches, patch 1/2 is this patch.
> 
> ---
>   drivers/md/md.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 

