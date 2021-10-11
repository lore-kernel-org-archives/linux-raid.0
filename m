Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 135E2C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 11 Oct 2021 13:57:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0BEE61078
	for <linux-raid@archiver.kernel.org>; Mon, 11 Oct 2021 13:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237539AbhJKN7U (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 11 Oct 2021 09:59:20 -0400
Received: from mail-zr0che01on2136.outbound.protection.outlook.com ([40.107.24.136]:10713
        "EHLO CHE01-ZR0-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235092AbhJKN5y (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 11 Oct 2021 09:57:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nanoo.onmicrosoft.com;
 s=selector2-nanoo-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L5TJQ13obgBijWXWhlvwpqnLA7Ro9iD2SrLhZ+t4wUw=;
 b=mu7OX4GMvM8d4wANZFCif5cMpjQHj9IeIyG9gDK7wHWB+lS6nkinE5a4gEfg/qhxgYrB6k39Gnp7IsbwS3L+ckSWanLa12Hno4EQ5gFJJ+SSZLrHHGzqtvJK2fqAWFy6fExZgOuvqzEPCBpqAy7AWbv38SPFV9ZKQYNuvHw/+KE=
Received: from AS9PR06CA0163.eurprd06.prod.outlook.com (2603:10a6:20b:45c::24)
 by ZRAP278MB0786.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:4a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Mon, 11 Oct
 2021 13:55:50 +0000
Received: from VE1EUR02FT013.eop-EUR02.prod.protection.outlook.com
 (2603:10a6:20b:45c:cafe::fd) by AS9PR06CA0163.outlook.office365.com
 (2603:10a6:20b:45c::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.21 via Frontend
 Transport; Mon, 11 Oct 2021 13:55:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 104.40.229.156)
 smtp.mailfrom=werft22.com; vger.kernel.org; dkim=fail (body hash did not
 verify) header.d=nanoo.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=werft22.com;
Received-SPF: Pass (protection.outlook.com: domain of werft22.com designates
 104.40.229.156 as permitted sender) receiver=protection.outlook.com;
 client-ip=104.40.229.156; helo=eu1.smtp.exclaimer.net;
Received: from eu1.smtp.exclaimer.net (104.40.229.156) by
 VE1EUR02FT013.mail.protection.outlook.com (10.152.12.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Mon, 11 Oct 2021 13:55:50 +0000
Received: from CHE01-ZR0-obe.outbound.protection.outlook.com (104.47.22.111)
         by eu1.smtp.exclaimer.net (104.40.229.156) with Exclaimer Signature Manager
         ESMTP Proxy eu1.smtp.exclaimer.net (tlsversion=TLS12,
         tlscipher=TLS_ECDHE_WITH_AES256_SHA384); Mon, 11 Oct 2021 13:55:50 +0000
X-ExclaimerHostedSignatures-MessageProcessed: true
X-ExclaimerProxyLatency: 8043420
X-ExclaimerImprintLatency: 575370
X-ExclaimerImprintAction: 606af3d0ce974781bef80551f55f6f6d
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zbyo/eaRe9TAk/iaexVieB8Yh8HUfssgPEbiEjlmlB4FqsKHguSvCvKFcbo+9UDkOnAVkyP2HIpK2dfQ6GqyHelPReDyeNqHLu0/XHTnYD/uOck6Ampb8ChJVegBcTKBwF6Pejm5QnBBtgbiNp4TzFokJG4oWtr982SBiESrPi9B6Yx2iu/m+AO6lMpdIeNQ0shTLQLcUz5AWUtfkIkCVjGih/6upfyAKyawMMIl2DZPkPEETTCB7y9lwMCrL7wT+mIitYsdIjAzqsmNfBb5tVOLHjlu5F4GphVsjzK31ptY8HBokVJBByfYDut1f7VGqAw6qudyp0EjgZMpDMo5Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2XVWQ+KQEPWQ2uuT+waEfYk75+iHzzNSGpgh64v4l2I=;
 b=HAdliNV1A5GCXsmK0U9ei9EGSa1YRD3i2CwusgAt9jGC6QBv/Snd0gHd9GDTXwrORAC0iYIBSAnXni0Qlu2lJx0s7syYpqWZ1cHYU7W8n4OTh/fIrztRjSLJY/c4b66ORr3SM0RYb3jUraEMR+VuwaCDX69HvTLMkFZAuO6gg7rB3lxICtlqqf9UYc6DU46ZX5369zJAwjiPbKnygb0j0UVBPA5+BUjfmYSBZT9MfD9tD7HHhdDUPgksKpkdgLgj/oLqYbmHzO4DYBO8ad5iuh9lEoR2RJW8HDAFqNTD4DBJdai3XIVxYADk7X3VRe51+dj7IMaYck1MgCHGQg2DZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=werft22.com; dmarc=pass action=none header.from=werft22.com;
 dkim=pass header.d=werft22.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nanoo.onmicrosoft.com;
 s=selector2-nanoo-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2XVWQ+KQEPWQ2uuT+waEfYk75+iHzzNSGpgh64v4l2I=;
 b=KwsF/aBDOeKqznQzA1xDnjwaxFtoCB/MTVNSEzWcbpxYLIw4NLT/B1fY0cp4chY/M0z2p6CAix1pas0pt5GYQLOiIRNAF4VF7dFBUNVexV3u7mn1HTsaTPXthOAI2IJ3+y6Am3K3S+XRX7Uf/kj/Ps6noe97Uy6pdn6Xbv7Jiic=
Authentication-Results-Original: vger.kernel.org; dkim=none (message not
 signed) header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=werft22.com;
Received: from ZRAP278MB0397.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::5) by
 ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:34::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.19; Mon, 11 Oct 2021 13:55:48 +0000
Received: from ZRAP278MB0397.CHEP278.PROD.OUTLOOK.COM
 ([fe80::8d27:f211:395a:f942]) by ZRAP278MB0397.CHEP278.PROD.OUTLOOK.COM
 ([fe80::8d27:f211:395a:f942%6]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 13:55:48 +0000
Subject: Re: "md/raid:mdX: cannot start dirty degraded array."
To:     Wol <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
References: <8b0a13e1-0972-be41-d234-2202abe1a54c@werft22.com>
 <2f1a309d-cb7d-4f93-10f4-5af96690c935@youngman.org.uk>
From:   Andreas Trottmann <andreas.trottmann@werft22.com>
Message-ID: <6a724e83-3165-4df9-be39-b4d78ae0bbdb@werft22.com>
Date:   Mon, 11 Oct 2021 15:55:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <2f1a309d-cb7d-4f93-10f4-5af96690c935@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-CH
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: ZR0P278CA0063.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::14) To ZRAP278MB0397.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::5)
MIME-Version: 1.0
Received: from [195.234.163.98] (195.234.163.98) by ZR0P278CA0063.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.16 via Frontend Transport; Mon, 11 Oct 2021 13:55:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3fbf142-3a45-447f-88a3-08d98cbed5a9
X-MS-TrafficTypeDiagnostic: ZR0P278MB0377:|ZRAP278MB0786:
X-Microsoft-Antispam-PRVS: <ZRAP278MB0786466482258C55615B1DDCE2B59@ZRAP278MB0786.CHEP278.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: =?utf-8?B?OE5MYUZBTHNQWjl4YkllcUlNdnJRZW9GODlpc1NkYStKL1owSm50NWNJUGRX?=
 =?utf-8?B?ZTRsNjhSWlZWcXkyaWl2N1g4bUNnQ3IzdENaVkRzMnRnRWplbVZwYXFheDhY?=
 =?utf-8?B?akhNWHArZW4yVk9uaXNHL2VoOEZGVGllM1RoQS9uU1VhVzE3TFpHVkhFMW9U?=
 =?utf-8?B?TlpjVFN1b1VwMGxvcWZVNGIwQ2hzOTJ2dzZab2dpVDlBZ2NOajFQUWU0clJt?=
 =?utf-8?B?UFhHU1c3VFBNWXhpRlBxUU5MWWZaUEFJbXNEbUloUUF2OEJRRXpLVUh3b1hW?=
 =?utf-8?B?Nzc1aHZNWnlzWHRqandhR2krWXJ2K1QzU0dJcUIzazFpdEQxb1JacVhMMlNM?=
 =?utf-8?B?TElNUUh1bW9xbCtjYWtoTnQzQUs3M2hGaHV6eTVRa0dLcUlYWEdobnlLcDI0?=
 =?utf-8?B?Q1dNMEJXWHRVY1U0aEsvOU95MWVlYy9ENHBrV0Q2RHR5TGl1RDEvQUZWckZM?=
 =?utf-8?B?NlpuNlR5amZKYklZTnJrNUlsM0hjK2t6YUI3Qkt1VGVHUXZDT2hOVzQvaGVD?=
 =?utf-8?B?V1BHcCt0UXFGZjZRZlUvSU5xMldnOWY3eUtsWVN3WVBld2ZyVS90Z0l5cXg3?=
 =?utf-8?B?U2l5Tk5ydWt2cEdBSTA5Y1g4SWhxazJpT012VFdlL0p0OHFpZmhudjQwbUIx?=
 =?utf-8?B?K3JSOGlYOXJWZ2xSYmFXSk1LYkZGYjJYQTRtdTVwWTJLWWdPNy9YYWFCTGc2?=
 =?utf-8?B?M2pSaTZGZGNqOGpVd3V6aEMxTS95SHJqc3I5ZHo5NVhyd1dPZUxpQUFzYWFp?=
 =?utf-8?B?TEJsVTd6V1lnV3NCc1JYQlJaeTJyRWx6UnBoNFdtcE42WTRhNC8ySFpvT25H?=
 =?utf-8?B?cFplaG5tTWRTakFaNHdGWWN3VDR2Q0hmTEVsdTB2UHh0RU53QTVlYWZMSnBy?=
 =?utf-8?B?eWpDdkQ2VE5ieFRqczdIclJ4NHV3bzAwRGN6Nk11NFFGTzF0Mk5pSzUxZFRL?=
 =?utf-8?B?RVh5QWxxVjBZMmVLcEk2bUFJY2I0UmVzZStOb3pMZEZFVXdpMm1NTFE0VTdN?=
 =?utf-8?B?K1VrUWsxNXZZYnBFejkzbituZnpnM1R1OGtvL2p4bi9NZ3AycldiQ2RzTy9w?=
 =?utf-8?B?SFBNRXZRSUJLWW9hR1UyVGdOOUlmeHE4UlArL2RUdXE3TEtTWkduRS9kRG85?=
 =?utf-8?B?bENYcXlzSlV3Y2xxblYwbGdoaEJGZHF1WkxoSmwrNkpUMFlabWlaSDBCZERH?=
 =?utf-8?B?cG5NcUt2NVhrZ21NOXI4VHZ1RERiYUZ2MXpWU3hJYm9LZDkzVThYRW53QS83?=
 =?utf-8?Q?wKcVVcz16zX45yI?=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0397.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(136003)(396003)(376002)(346002)(366004)(8936002)(44832011)(6706004)(8676002)(38100700002)(38350700002)(5660300002)(66556008)(83380400001)(36756003)(15974865002)(2906002)(45080400002)(66946007)(66476007)(508600001)(6486002)(956004)(31696002)(86362001)(31686004)(16576012)(186003)(52116002)(316002)(2616005)(26005)(3940600001)(14143004)(45980500001)(43740500002)(18886075002);DIR:OUT;SFP:1102;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR0P278MB0377
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR02FT013.eop-EUR02.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: f8db535a-7b89-4b8a-81fa-08d98cbed429
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ASeUrU5RNRe+lEVD3Yf6iTVH3mKUu77anni4iy+tebXDvj1s6jiXZYd92sYD748q0EQru29zkv3490I+VFX8eNv56QtVOHT+RY9h9QTyaJlBs5rss+mq+YeatGZprFhX9Ezhi+iIzVHrd+pju5DXm57bxeDwsYLVemkbsnQh8LzC8E/1S0bD2QT0cUnGoHk2kp+QJ5vHfeZqsEHb6L39pXumMm5pUtj7CJZTU2nbItV6cCk7KKcUP4EgmMyB1akE6dzKFi6Z9lJGUW3DgxfMLBCjFDq06wtn9mbJjR1eujnGhleiLRf6jztqC5vdevMdQpNmWkxfXSR5035tb/vMk4tNiCtfmv/8RfD4xUsQ5IyiQ7qdvNSBgVlGVzUk0WvYvELYJUfREZuEBSsyd7lWbwkmbu/BhNOjVyfD1sCxHDZYGAGlodEY4KyxIqP/oDmrWSf508rBjoMzgduu0x6JAHFDtREOvkhvYaODvpq9TKNAjF3wtf9kap6lCpICaQQBiksxSAREWoRYaScS420c1BQMVqQh8+3GN7Yrdu2Zrgy05aeEUA6lYjn6aFWa+8/FDkY8lO/5Cn8RE8Itq7oeew3MwYmQYIMpsrmKoq+2BCRuYTgFct0XusmgW6TzjiP0vXavJE0X6bVTqr56QwK4iaDPw1Vc2zGggaHot09HSG4SLTvWIlApxr8V6Jl4ioXCbgpbjsaJepazJJKZoV6GcvJJVkGrHai9bjW2ha2GW2WL6ka2FAjERkWpHNflAxnt1ELVoIWjf6NMRKuRtwLVhRxaJlEOKZkU8ch3KI1pr+/3m5ccRZ9rYVTxknACk5k5GWfgzJF8+VYsmIx0dCHvYnJXAcFwyU3LpCXoblCrPMNy97dMsnlYLaITvXIfNm8C9dYI0qguioYZnyAUXDlZA==
X-Forefront-Antispam-Report: CIP:104.40.229.156;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:eu1.smtp.exclaimer.net;PTR:eu1.smtp.exclaimer.net;CAT:NONE;SFS:(376002)(346002)(39830400003)(136003)(396003)(46966006)(36840700001)(16576012)(186003)(8676002)(36860700001)(6486002)(82310400003)(26005)(336012)(31696002)(2906002)(70206006)(7596003)(36756003)(7636003)(45080400002)(31686004)(508600001)(356005)(47076005)(70586007)(6706004)(2616005)(15974865002)(44832011)(956004)(83380400001)(5660300002)(316002)(8936002)(86362001)(3940600001)(14143004)(43740500002)(18886075002);DIR:OUT;SFP:1102;
X-OriginatorOrg: werft22.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 13:55:50.3769
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c3fbf142-3a45-447f-88a3-08d98cbed5a9
X-MS-Exchange-CrossTenant-Id: 28eff738-e52c-4df8-9f47-73928389e1b3
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=28eff738-e52c-4df8-9f47-73928389e1b3;Ip=[104.40.229.156];Helo=[eu1.smtp.exclaimer.net]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR02FT013.eop-EUR02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0786
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Am 08.10.21 um 23:04 schrieb Wol:

>> I am running a server that runs a number of virtual machines and=20
>> manages their virtual disks as logical volumes using lvmraid (so:=20
>> indivdual SSDs are used as PVs for LVM; the LVs are using RAID to=20
>> create redundancy and are created with commands such as "lvcreate=20
>> --type raid5 --stripes 4 --stripesize 128 ...")

> Ummm is there an lvm mailing list? I've not seen a question like this=20
> before - this list is really for md-raid. There may be people who can=20
> help but I've got a feeling you're in the wrong place, sorry.

Thank you very much - I'll try linux-lvm@redhat.com.

> In md terms, volumes have an "event count", and that error sounds like=20
> one drive has been lost, and the others do not have a matching event=20
> count. Hopefully that's given you a clue.

Yes, but it appears the event count is the same in all three (of=20
originally four) surviving "metadata" blocks. If I understand the source=20
code correctly, it's an __le64 at offset 0x10, which contains 0x0BCE in=20
all of my _rmeta blocks.




> With mdadm you'd do a forced=20
> assembly, but it carries the risk of data loss.

I'll try to do this; I can work on copies of the data volumes, therefore=20
any data loss that could occur because of me using the wrong mdadm=20
command can be undone by getting the original data back.

If I have any success, I'll reply to this e-mail so at least this part=20
of the solution will be archived somewhere.


Kind regards

--=20
Andreas Trottmann
CTO
Werft22 AG

T +41 56 210 91 32
F +41 56 210 91 34
M +41 79 229 88 55
andreas.trottmann@werft22.com

Landstrasse 1
CH=E2=80=915415 Rieden bei Baden / Schweiz
www.werft22.com
