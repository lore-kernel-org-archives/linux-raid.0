Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15818C4338F
	for <linux-raid@archiver.kernel.org>; Sun, 22 Aug 2021 14:30:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE4DF6120D
	for <linux-raid@archiver.kernel.org>; Sun, 22 Aug 2021 14:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbhHVOb1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 22 Aug 2021 10:31:27 -0400
Received: from mail-eopbgr130119.outbound.protection.outlook.com ([40.107.13.119]:39233
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232003AbhHVOb0 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 22 Aug 2021 10:31:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cRieKEbSkxJCn8D/805obXMdHuRsLgNQkPeNhjwEQvseCZCAJqGp+A8VYowhK+mL3hnP45msYZ1Rp1hW81IekCvKJdd5ovARKrdPZb3PsEebLvJrptwVLD073iv9mPHMkMhNGpuvQwUinwgo2wKrgjPf9x/enjRjXGOpuI6IAl1GrNghoOC3tY6Z15O/J+OCQJNk72ZELCcFoxI6RVe0V47JO2wEMVwu/LjPR+o4slhuMjZRl191vP7KjZ891E8yqRVaA/GjbryAkVKLxi+JICP8Mrklqdpnza1nwfH40usMy9gqz+gyf5PJxBJp2OmfQN8pLXpJ0d4wW12IhsM+8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pVskrKUyz/wLNqSU8JYI4+O02Szow1FCFp7UvEvmCFk=;
 b=WDBg90DL6zAbkmzG7swvuH/5CPuxT6lCZ6b/Be4lV2Y+XhjjFN5g63XVvp0sZOQaI5egWAT5Gh6fxFwqoAI6If7obU54RdLeLNPHqOE1bT6G7cdFC5UVmiHWBQC7z+UT8iOf/jxkxrLlkmPidmAnmphL8XehLLzVCY5ogE4gGKrsPup7HwtK5VokMS00dwMxaaPGuI6Vf5BvCghYABbBJNQ1161PlwTTc3qhlkCuIWPnwGSLV1Drpukt/DSEeIbV2aPypkC2ljpEr6Pz4KPNpPN+Ww8RKGGVuWknU5BJzDt7IotzsZsAzSapXeydjjXUWN0vpbaUbWGEQbgNZteQeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pVskrKUyz/wLNqSU8JYI4+O02Szow1FCFp7UvEvmCFk=;
 b=hJX26+uqDxyLeiVlTonn7Coo/YSIhN+w6bbQTpSZF1IO7uTZPiewj06xGtYBkcZa09X5p21gJ4JAhdHP/aYF0GWpTedlJqf79jW/ecry3DxnRZ4RyN31Y9NeHqrUZXtT7jcIPvGPHp5g8slVkDd9cKEeYJ8XByrT1OstLeIHdYZvpQQi3VtrDHoRX9IOu0dT83DkDPATKWxrV3IBEhZUScGMN7Q/Xk2pSPOnZ3ClRSRiCTx72kkyiZoPdU7ULfSGYOcJjgXjSlS1sBP62MnppDkf9iu0Fu2X9NLekVTAKle2bIHXkhFiNz/vJ1wZMOmZIYHyXfyPGrl3+Edl8x9Ltg==
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=volumez.com;
Received: from AS8PR04MB7992.eurprd04.prod.outlook.com (2603:10a6:20b:2a4::6)
 by AM6PR04MB6136.eurprd04.prod.outlook.com (2603:10a6:20b:b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Sun, 22 Aug
 2021 14:30:43 +0000
Received: from AS8PR04MB7992.eurprd04.prod.outlook.com
 ([fe80::e4b0:f154:1315:885e]) by AS8PR04MB7992.eurprd04.prod.outlook.com
 ([fe80::e4b0:f154:1315:885e%5]) with mapi id 15.20.4436.024; Sun, 22 Aug 2021
 14:30:43 +0000
Date:   Sun, 22 Aug 2021 17:30:40 +0300
From:   Gal Ofri <gal.ofri@volumez.com>
To:     "NeilBrown" <neilb@suse.de>, linux-raid@vger.kernel.org
Cc:     "Nigel Croxon" <ncroxon@redhat.com>, jes@trained-monkey.org,
        xni@redhat.com, mariusz.tkaczyk@linux.intel.com
Subject: Re: [PATCH V2] Fix buffer size warning for strcpy
Message-ID: <20210822173040.532510ec@gofri-dell>
In-Reply-To: <20210822172657.2d3405db@gofri-dell>
References: <20210819131017.2511208-1-ncroxon@redhat.com>
        <162941140310.9892.4439598009992795158@noble.neil.brown.name>
        <20210822172657.2d3405db@gofri-dell>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR0401CA0018.eurprd04.prod.outlook.com
 (2603:10a6:800:4a::28) To AS8PR04MB7992.eurprd04.prod.outlook.com
 (2603:10a6:20b:2a4::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from gofri-dell (199.203.113.198) by VI1PR0401CA0018.eurprd04.prod.outlook.com (2603:10a6:800:4a::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Sun, 22 Aug 2021 14:30:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 152b34e0-00d6-485d-b925-08d965796c8d
X-MS-TrafficTypeDiagnostic: AM6PR04MB6136:
X-Microsoft-Antispam-PRVS: <AM6PR04MB61360B914A3E1E87BBF3801891C39@AM6PR04MB6136.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ux/oRIVM4Wjq3d3R4cvx9en/19nBeNuFje5ht6QDI6DX2JnDIopoIUAuNqG0dDvK7pPXWLNJDg+Z0PE2/dNqD50QqgAHe9v3ZAsBhIhZ+iDa7RbO2tnsZ0CJSjPfmAoK6fRx1cLDDy50IAquo9nmqB1sQDrCQD5kZtiZjXuRp0PY6foT7iiIFkhz0diP4w0/CKEkZYWWWEPq22ZPy0/qtFzNpGMPAesZ/EwrsndALiO2GHqgpg2r0JKvaavRtoNK8e11nRF7E4v/L3s6ifUg2lZAxlkE0shnP7RFXo5mCiFgRuqwFI0QbZAROIrtRlqjdsrxc8LZnL1T0KXbkeqg38REO1ds+pffiPWymuCz7nhPEq5p0jWOIECf3C77L5kDAiXo+N3iI2dIWpUd9kXZugWEjZGL8KP+7DK89nu1OfXeMPGzx5JeMiQuVrgyFapNQtgdH7oablg61J9ZW+yE0pgTwnC2O/79ax50jtAKx1icsOWS3zfdkF3E8qVVp+x2VY7jmvAjt5j66ml6MMqMGyLdLS4oiqKTB844etDzpaLbPFBc7V9MHHjo6Fa23FPe+uAi0KXDfJPgu2LXqtYs+DxP1ihjbddPwDnmvaT8bdbzfS+BavRmRMaEYCgwDavPUGVG5xFa5lCT/0APWS55kbanqGR6f8fFEVBNVcbfaDK1U7G8/gY8i4blVXde4tUfhgWVjMEHAjNyYt30VX7VsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB7992.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(376002)(39830400003)(346002)(4326008)(2906002)(9686003)(55016002)(33716001)(86362001)(1076003)(66556008)(52116002)(508600001)(26005)(38350700002)(38100700002)(5660300002)(66946007)(186003)(66476007)(6496006)(316002)(44832011)(4744005)(8936002)(8676002)(956004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BFXWHcC35jBNddRQvg7IJxY3zRhP2f7jn0ggwbvhUB5gmTiUB4HKnjbm4SIb?=
 =?us-ascii?Q?H4um3gjRWoH8UnGYHlPCXJgbEal56KuqhGIISptXMdDID3yPfuvQ/tMbLhoQ?=
 =?us-ascii?Q?QT0l7eCdL1evFn0LthLm0L/7gGRfas4xzMbUX2yqh6FNEiHH9FxyOqU84f42?=
 =?us-ascii?Q?E8lghNBx6RMsOY5Est5Ev7TLgTSgDnaoFzI5dgsl8jFBp8Rfk0uFJlGTtokx?=
 =?us-ascii?Q?ut2JhC2095wu1HoYnpYUVF327cVXaMATU6bUejYmw9HZnuXqWLx3SDjABP7I?=
 =?us-ascii?Q?E/zh4nwA/6e7qG5npu0HRH0hzeYUr/+JXYvhy7SoGSrVAIhkF9MrBAAR4C9D?=
 =?us-ascii?Q?cBQH/0LR7AAurQap0k3qm+Mn+m/DI4hdD4QbdKePrB9qEsxeW0ftqDphFgum?=
 =?us-ascii?Q?AKeZzdhDO4Pew6OTasaIgn7T63UGbEW1QWlQbdvxVdiw8AkqO5goi4JtkEq0?=
 =?us-ascii?Q?s+2V7YapS73QEWDFeUI2MGltn/DFMIxq2JQgwCX06zD1AF2J4J/ZS3Up/ZQO?=
 =?us-ascii?Q?RS7GwHD+IKIg3gGnL3QK/mRxdU3PF7oj7OvLn3jUw+cGKJ6p0l+S1Hz/An+q?=
 =?us-ascii?Q?pMb04HpGZlZdcaOHXhwEyE23IbHsb8C19zDD9ov1+KebD3lwYPzL77R5mDSI?=
 =?us-ascii?Q?9NVX2vLy01gQo8iePLTW47nB8fWxyfzAMXAAcHKJbgOm0KJwLc7ngQRFpx5K?=
 =?us-ascii?Q?RD++It3wNwfugKZTmeN/ZpdRFUc9inhMG94kns3IaE9U7Wz3I9jE+Ow27FhG?=
 =?us-ascii?Q?Zc7RRr7WPJ1SBojAj0oQkb5H8LpopkJSC1PHfUZTXnGiVsIX3sMWKEma/E6y?=
 =?us-ascii?Q?34HAiXqQJn4yOd7xbFeUUPWAlXLklpA6oU7n7y+QdU0rlkAj1DI7qJsMcu66?=
 =?us-ascii?Q?Ies+9V//y37M4B17bJAR85qQy6bYIGC8sPz9Uf3XVZmWQY94QcvibrSm6YoE?=
 =?us-ascii?Q?5TPWWthXLpb7lmo8tPIUk6eF6vvwwEHGmUld801UUVbUXrbY6FWGy0d/9RIy?=
 =?us-ascii?Q?BKe5V44li4nphJwDMzV82OssyLwbbkRpdyPC9FAFrSOH47pPwdhNNj+M5tWh?=
 =?us-ascii?Q?eLJTqURB+8XtNHy90/Z5rfLlqlwA/ng52dPEetBPu39P1BEvRqiBo2nK7Br4?=
 =?us-ascii?Q?HO0SyUT8Xrt6fHuZToGzEA4rUQ40CY7yqU/00cMeiAQwtJg5/u1iSoxm0JaD?=
 =?us-ascii?Q?7e5XTNnA0xiXV0mUPQWlsY/a5VuTykq9JtvVqMiX+g4fIl1Re4O4ax4/8mQe?=
 =?us-ascii?Q?vzAtKu3VwGBk/UNso2LTIfhrIuyNRKe/NPxyx8dEFD2N5PO5T6EzUWC4EUff?=
 =?us-ascii?Q?ZuzDyBYkrXhAPjHIxnYK6bye?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 152b34e0-00d6-485d-b925-08d965796c8d
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB7992.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2021 14:30:43.7993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MvfpBfuon7N5Sw6jwjZBal1G2iENWQgCWCnVompU+kxHqdSvDmsJbce3DgqmLg2wpva/DK5qaClLkkDXDOQoIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6136
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> > You really should explain here why we change from filling with spaces to
> > filling with nuls.
> I guess that a commit-comment would still be needed, but I think that a
> more conventional approach could make it all clearer:
> 
> - memset(ve->name, ' ', 16);
> - if (name)
> -	strncpy(ve->name, name, 16);
> + int l = strnlen(ve->name, 16);
> + memcpy(ve->name, name, l);
> + if (l < 16) /* no null-termination expected when all the space is used */
> + 	ve->name[l] = '\0';
> 
> Cheers,
> Gal

my bad - I obviously meant strnlen(name, 16).
