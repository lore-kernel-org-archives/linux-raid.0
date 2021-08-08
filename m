Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB56C4338F
	for <linux-raid@archiver.kernel.org>; Sun,  8 Aug 2021 14:43:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E7F660F0F
	for <linux-raid@archiver.kernel.org>; Sun,  8 Aug 2021 14:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbhHHOn6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 8 Aug 2021 10:43:58 -0400
Received: from mail-am6eur05on2092.outbound.protection.outlook.com ([40.107.22.92]:15329
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231855AbhHHOn6 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 8 Aug 2021 10:43:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ifnY3rcdJP+quuL9QQy6gJqRBgdCsBA2gQx4YYXKwJ3uE2UpBs8HKU6jtMw9wSCIqYT3ATKts17R4vsP9grOAwVWp+fLEcS04ZDjzUjcgfONGpOFwZj9Y/hiScsKAqQdOZoxbYTFdYJILDh5dcZQV4BH8ZuPJQ9ipNUvwsv2ZC9PUMMmOkHAKRm1V01Azcnmhjue/Ad0+WH7UAvbpTJXN+UfPtPTKouo6rKxwj+MTUX9jKrmwzocnl3ST7wt2VnmfQlAV0c1NyHz09/Hm1jrhKIs2UViZ6dWWwhHt8lpeTNkPzWiX4JIBEPZ5AmGnHS+EM+Mr9faA2NSh4ZwDHRPIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HC18P8DDHeRLcFslA7x+mkMt2Yz53RDcV7iN2VYEmOI=;
 b=cIOm0bDWIyImn2FvrBj10T3ls4x4nUo8ZhFollPPvY19AEjveNS4yQbir+nPmMzjM2CNeNao+KC5tw5hR4PI/MRMrl+TRd/EAdtEmgmW92/aTtnrLEs/RwEnKy/dfAMg721H2PPSldh4mp1bbtg2dB4hJlTMLdf+ir2MCT7mvL30jUz2ckuN5AdFzxDd/wKZm/toSbOjrsfRyn4tMc9hkOxAhGCuZ5ddqYcusu0wlWfwcssFQmY1LsIrtZWgIFmwKes4OnhQcixqeQxtX/YmCrGQrTS/W7xsMEk3e4cD8cP+S6TbP2lR30LXOR+kC8CG9uagvNzWwuB5sMSuaMtQbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HC18P8DDHeRLcFslA7x+mkMt2Yz53RDcV7iN2VYEmOI=;
 b=J7FZrJWlQ3EVaFADPVqYN0mECoNGbzjFlYNReGpmzAMYwcxf97nC3NuzBt+n9Hd583FGo2vsF9EUkPsLwjBLyoDsM6WVC4SK9ugAgsO0Eju7F1gBKXgoI4Sbitf5VFQkV2vbB7wSO1b8Mjeyoie0NN6jiu6cEht94LYT6K8fBuLul5hpHQ5b8G+jKlViwH49wwvM9ly5vF8f/ODEFYZJtjHyn23RFW34YLTWjpZbQFIBcTBA98T5+eAjkGKrNFz8YgSRwN6fR5SkXMsw4JGIvF/JrAc77CaoHAoHu1LOJ47O2DvPEIYgYl8+g74cfN5o4a78qn0jdPWElVxL9RWcjg==
Authentication-Results: mail.mil; dkim=none (message not signed)
 header.d=none;mail.mil; dmarc=none action=none header.from=volumez.com;
Received: from AS8PR04MB7992.eurprd04.prod.outlook.com (2603:10a6:20b:2a4::6)
 by AM6PR04MB5125.eurprd04.prod.outlook.com (2603:10a6:20b:a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Sun, 8 Aug
 2021 14:43:36 +0000
Received: from AS8PR04MB7992.eurprd04.prod.outlook.com
 ([fe80::e4b0:f154:1315:885e]) by AS8PR04MB7992.eurprd04.prod.outlook.com
 ([fe80::e4b0:f154:1315:885e%5]) with mapi id 15.20.4394.022; Sun, 8 Aug 2021
 14:43:36 +0000
Date:   Sun, 8 Aug 2021 17:43:31 +0300
From:   Gal Ofri <gal.ofri@volumez.com>
To:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
Cc:     "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
Subject: Re: [Non-DoD Source] Re: Can't get RAID5/RAID6 NVMe randomread IOPS
 - AMD ROME what am I missing?????
Message-ID: <20210808174331.1e444db9@gofri-dell>
In-Reply-To: <5EAED86C53DED2479E3E145969315A2385856B85@UMECHPA7B.easf.csd.disa.mil>
References: <5EAED86C53DED2479E3E145969315A2385841062@UMECHPA7B.easf.csd.disa.mil>
        <AS8PR04MB799205817C4647DAC740DE9A91EA9@AS8PR04MB7992.eurprd04.prod.outlook.com>
        <5EAED86C53DED2479E3E145969315A2385856AD0@UMECHPA7B.easf.csd.disa.mil>
        <5EAED86C53DED2479E3E145969315A2385856AF7@UMECHPA7B.easf.csd.disa.mil>
        <5EAED86C53DED2479E3E145969315A2385856B25@UMECHPA7B.easf.csd.disa.mil>
        <5EAED86C53DED2479E3E145969315A2385856B62@UMECHPA7B.easf.csd.disa.mil>
        <5EAED86C53DED2479E3E145969315A2385856B85@UMECHPA7B.easf.csd.disa.mil>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MR1P264CA0025.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2f::12) To AS8PR04MB7992.eurprd04.prod.outlook.com
 (2603:10a6:20b:2a4::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from gofri-dell (199.203.113.198) by MR1P264CA0025.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:2f::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Sun, 8 Aug 2021 14:43:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be8528bc-4871-404f-2e97-08d95a7ae715
X-MS-TrafficTypeDiagnostic: AM6PR04MB5125:
X-Microsoft-Antispam-PRVS: <AM6PR04MB5125D55C706376F0EF2E30A191F59@AM6PR04MB5125.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y1DM1Ibv2b+s6rLMx6R1ZVhn4ZbPrFH5aMtLf0NaqlVEMYRZReaargUlg28kmFBeDT+N0S0ioXJqMCAmVsTT/99ciFNMzDyD2ZhrOTIfK+j64PpE9zWBJo2E6ya0GFmNizTI7/fBpztWNg7yPDNlb+qi/yKyhrXBN/PC+EKFggo+Sk+VOY9gurmje1IEBdXZwlNMKekv0WpJAatTklW3VtDDIoyRE6OkLRxCMw5kH2G9Xk6bRiSH8bEwUnOtsME7ucpWdKAa0VHwFhu+xO9vSokrGhX48+kg1zlajXG3gSz+BT2jIlSEuL90VY+Z5pNT4Jo/XggP5HrT5m2lxehLehZqsb5UFt/QxT4UaA8gscjXaspgol2iIVOtBDAROkwwnnbAymjN/KapIq9rXY2NESkEbaO2vecJf9GyXtH6PSVv97zSBFyfZxbpX8ST1ecvZ3h+sYDPXMaJUlFVpvGBEOPCvk+4l7op7IFoiwgpZBZwENx8Wd1cCputM3lEleQDl917MgV9VvIe+71EHIRGb7UYQ+kwy/Pdzhaw6/dmKx/Putg7KcLNfPKULxhEKFdjJatw3e7wEeEv9y1loGIZNHnI5sRD/QBLNuMY8azS7PejQtcxkSswA9IMHbzF5WY2jSq/W/NiTMBd74yoNcmOrn9edENLaBzOWkMSwgkFtgyFYf0PQaruzLy1MaG7HCnPvQB733uHk67CEm+QOJgAOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB7992.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(366004)(376002)(39830400003)(33716001)(6666004)(6916009)(5660300002)(26005)(66476007)(86362001)(66946007)(186003)(66556008)(8676002)(1076003)(2906002)(9686003)(55016002)(38100700002)(8936002)(4326008)(956004)(44832011)(38350700002)(52116002)(316002)(478600001)(6496006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SlM0UXIyMEp3em10M2c1M2ZyZ0QrQmxlNXVZY3dxTEdhNms1WXVOUEc5eFBO?=
 =?utf-8?B?R0Iwa3F4OFNlaGNlRUY2Q2VEWjd0b2VuT0xDemkvNFNRUEZCM0FUQk5wYm5o?=
 =?utf-8?B?dFJzQWJWZmwrcXpjSVhyeTViS3JsMTF5N3NFMVNHWHdiUXhlL1RvWUdjcmNY?=
 =?utf-8?B?ZHpLeUtKelZUa2E4T1NOZGxZb1NGL3RVdmhRaGVYTXlkL1RSeXJWMlU5WGY0?=
 =?utf-8?B?dUdRQW1Ua2I4cFE4MWc5dlZyb2R1WlloWmNzRUVyUTBmTjdjQTcwMm83R2Jp?=
 =?utf-8?B?S1M4RVBjWVNUY250Wmp6Ylo1QmNPUitQdWJxL1lyaC8rYnhiUk1UODluQ2Ru?=
 =?utf-8?B?RzB5dFlJRTVkSlVNcFdTZHVMRjZiWVA1UW9NMm5oVkQ3N2hDSXpUaVBCUWt2?=
 =?utf-8?B?Zm1wamNtMWpXMCtncEZpdHBTdkduYWtiNEo4blhybXNKNU56UWNhaDltdCt6?=
 =?utf-8?B?OEZXZGgxOEFJM3BGeHlWNHVSV0pHVVhPQVA2VzFGK0NjRk9mU2JFMFNaMDkv?=
 =?utf-8?B?VlFDWXZrejJYblJXbzJWOThsL1FUdklXd1MwNmJpTGMwQTR2SDdwR2ZlTTlX?=
 =?utf-8?B?RU1xZDJVWkF0MzZSNGthbFFpbVhabVpXcUdIeWpFc2FTZWpBTmtGRWRVOGo1?=
 =?utf-8?B?VzVzWnEyR0hNSFZqL01iU3hQMkpUTWx3WExtRlNDUi9KdzJ0UnJDMFg0bks0?=
 =?utf-8?B?dWErK1hOc2V6NW5iNU1oZzNqQjYwVjAyTWZhT3FIRTZaTkE2Tm8xRTdoK3JH?=
 =?utf-8?B?ZFhBOWMrSzNIemd6SHdIZ0VLcVdqUFdwVTY2NVRZZXRFZWR0VkYzK3ptMVJs?=
 =?utf-8?B?QXBrWnl6Mi9VUDBJL1d1dGV4V2RIcjlGb0d0RnRvZTY5VytKOXF4RW0wWmUx?=
 =?utf-8?B?NGE1SHdGa0FyMDdLdGtqeGcxVFNMQjZSL1FUbWhFQlk4N0pNUmkwQXo5a2pS?=
 =?utf-8?B?OXh4ZkNoT3A2K3pOVzF1WWhnd3c4TklMODlTbTU0YlhlVnZmcmt4OUFGa3lx?=
 =?utf-8?B?ak9aNTZsTDkzTHhhQ3AzOVd1V3ZEVHNuNWtxUVdMcThWNFNta2h2RTZNZ0N0?=
 =?utf-8?B?RGY5UHZRR3JTNzBGUXE3WWIwTk1McG11ZTAyOTZ4OGZSU3RnbHR3bmY5OEtW?=
 =?utf-8?B?OHBNeGszQnBkZGNjY2JuWXBpTEVrOXZUckJQVzluZW16M2hnN0xDeFlmWWt3?=
 =?utf-8?B?dDlpRXVLMDVFVVFRS2J0Vk56dTAzdlRoYXpqWUN3SUw1dGRoVW4rbG9qVkxO?=
 =?utf-8?B?ZEt4UGFhTXhsY3NFY3lVUXRuMGZGOEovVDBWZWROSG9lNEo2SGVLdU9Cc2NZ?=
 =?utf-8?B?ZDVLSjlZQmdlazVWT1huQXFjNzd6bTZpdi9vWjdJS2tIMUlkd0I3K0RUU256?=
 =?utf-8?B?bUZJVENQUWRWRTZTUnJQOW5kTkJoWjFnR3RVTlVoOVBYQVZ4RjhmV0ZJYWJ3?=
 =?utf-8?B?YmpYL1R3bzJyVVh5dUVQV04xZWN0aDNneVVySzZPQXVubXluczhueEIxM0tD?=
 =?utf-8?B?ZmhoUm1XdEVrTzNoMlg4c09XNEFEYUZ3QVlMOHcwbnR2aDg4OVVBV29RRVl0?=
 =?utf-8?B?aVNjOHZzdk1zMzd5dFdkZDRZSVdSWjdQTzFzLzNYUU1OVFlpUTlUR1Rtcmgv?=
 =?utf-8?B?MXY4SExoNFhNM3dLNDFkdXpjMVlKTUdNZXFqVGowQ1dNUDZWUkJ0ZEZEUTdk?=
 =?utf-8?B?VmlEZTV5YzFOTW0vUlcwM3pGUlUzb3lEaUx1NW9JY01ocmRFeWRob0dUMkNi?=
 =?utf-8?Q?QDrfw/QvZfhWkA1QaYlKekaxk5P6q1Rp42Lp5z6?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be8528bc-4871-404f-2e97-08d95a7ae715
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB7992.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2021 14:43:36.0554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XA6aBr2zOZBRKJSt+9JWFSeLnO/uaqOYIb3SbgnQQ4oONOnUyGW4I4Xp3yqwe0araeDZFDJvIXmY3h4J7/5rrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5125
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 5 Aug 2021 21:10:40 +0000
"Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil> wrote:

> BLUF upfront with 5.14rc3 kernel that our SA built - md0 a 10+1+1 RAID5 -=
 5.332 M IOPS 20.3GiB/s, md1 a 10+1+1 RAID5, 5.892M IOPS 22.5GiB/s=C2=A0 - =
best hero numbers I've ever seen on mdraid =C2=A0RAID5 IOPS.=C2=A0=C2=A0 I =
think the kernel patch is good.=C2=A0 Prior was =C2=A0socket0 1.263M IOPS 4=
934MiB/s, socket1 1.071M IOSP, 4183MiB/s....=C2=A0=C2=A0 I'm willing to hel=
p push this as hard as we can until we hit a bottleneck outside of our cont=
rol.=C2=A0=C2=A0=20
That's great !
Thanks for sharing your results.
I'd appreciate if you could run a sequential-reads workload (128k/256k) so
that we get a better sense of the throughput potential here.

> In my strict numa adherence with mdraid, I see lots of variability betwee=
n reboots/assembles.    Sometimes md0 wins, sometimes md1 wins, and in my e=
arlier runs md0 and md1 are notionally balanced.   I change nothing but see=
 this variance.   I just cranked up a week long extended run of these 10+1+=
1s under the 5.14rc3 kernel and right now   md0 is doing 5M IOPS and md1 6.=
3M=20
Given my humble experience with the code in question, I suspect that it is
not really optimized for numa awareness, so I find your findings quite
reasonable. I don't really have a good tip for that.

I'm focusing now on thin-provisioned logical volumes (lvm - it has a much
worse reads bottleneck actually), but we have plans for researching
md/raid5 again soon to improve write workloads.
I'll ping you when I have a patch that might be relevant.

Cheers,
Gal
