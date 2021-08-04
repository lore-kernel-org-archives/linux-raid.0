Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DDF1C4338F
	for <linux-raid@archiver.kernel.org>; Wed,  4 Aug 2021 09:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D938960EE5
	for <linux-raid@archiver.kernel.org>; Wed,  4 Aug 2021 09:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236684AbhHDJdr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 4 Aug 2021 05:33:47 -0400
Received: from mail-eopbgr50111.outbound.protection.outlook.com ([40.107.5.111]:44450
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236642AbhHDJdr (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 4 Aug 2021 05:33:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LKFR76FbXeUJu/LSJaTFYtch0hYi3SFmVA0KBajY0BFqjeQ7ANqBJ5Ur1o1eY9+Gs9w2+89mOv1LehzRRiDbPuoyPTHhFWAu3YMOdD/te3SEo+LDVXH+MAKu068YaqmJBNftUsagg0fsSf9maCIJt8ax9vYvLrspQxBhukSt3a8pRm93TLWbn++MnBCX7odMq277BKwtuN7DzbGZwWV8RPeTu9RDb+WSEhgW934YLoXvP7jGbxnh6E4nZd9Rf4b8jUWB0/X6do/OLRl/0OKlsvJyq1PJV0rWX+sw/pCWWIxf8PjH63+/r56+92yH4iQ/0CZCR7ct3q2DQtkuxNK/lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7UzFiQYRtOn/cmLFS617KQYj/q8kvfjNs6E7fq6toKQ=;
 b=cSwPm1dk39mGPr0XFuYc+uzXHazQavlGatFYm/C6Bun8Ad8PP8M5Yk0hcu+qhVijjH9jPJ8PFrMHmfCKzUG3dyT5Dlx9Xm6ui0dvJzIwSfPuZm6D/+e+JY2+PmmgHFuXt8LuBqgtzexpA6L2L6qrSO/E+FXmNZBGHESi/UIGO0nBgbQ4WcWJAANCZXBjdB6t+RjPNG+kbOMOg8mp6/Xzk1R2wsaYvq9pu/9buJchNwD/Y8/y2xxnFcILMNg/LO4EB6rsx584xkg+exKuGb5XnVc0XyEfn2ISPrCY3rLZARxo05Wy4aXdwCun+ZCpDqfCPIghvo3yOyNlYRblfd3U4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7UzFiQYRtOn/cmLFS617KQYj/q8kvfjNs6E7fq6toKQ=;
 b=N3knxXUBn/NqLYip9TXJvlFIbzaewZWYRCLEsZmzIs+EwwqTgYTi3jrKg5DLeoXeSxh3YuktTr9BDe/WjsHK/AASJCpnQgiT1/xJheTQNwGUnKRFZIlsKhzhDiclLZimL0L3a0TCELsBJi00tfc3lR8Dzfr0mlks52PoLT5VyHHfvcdqc/1zv4L9fZHmfeIF0uHuSHGUmKcP6+LePN28ystV8++hNFU8FIMTUKNvzOxBQiocwsWE1YMJLg+A+m9MZWr3z1gCOC5rlTuH/m2BWq8VLyAVGb3/SkisNa4gmVYSpNb4K4ndAyglVT6iqtudUEvz11F7A98Ios4+iAOekQ==
Authentication-Results: mail.mil; dkim=none (message not signed)
 header.d=none;mail.mil; dmarc=none action=none header.from=volumez.com;
Received: from AS8PR04MB7992.eurprd04.prod.outlook.com (2603:10a6:20b:2a4::6)
 by AM6PR04MB4021.eurprd04.prod.outlook.com (2603:10a6:209:3f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Wed, 4 Aug
 2021 09:33:31 +0000
Received: from AS8PR04MB7992.eurprd04.prod.outlook.com
 ([fe80::a565:bc72:44b3:dd80]) by AS8PR04MB7992.eurprd04.prod.outlook.com
 ([fe80::a565:bc72:44b3:dd80%9]) with mapi id 15.20.4373.026; Wed, 4 Aug 2021
 09:33:31 +0000
Date:   Wed, 4 Aug 2021 12:33:27 +0300
From:   Gal Ofri <gal.ofri@volumez.com>
To:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
Cc:     "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
Subject: Re: [Non-DoD Source] Re: Can't get RAID5/RAID6 NVMe randomread IOPS
 - AMD ROME what am I missing?????
Message-ID: <20210804123327.5c3e903c@gofri-dell>
In-Reply-To: <5EAED86C53DED2479E3E145969315A2385856215@UMECHPA7B.easf.csd.disa.mil>
References: <5EAED86C53DED2479E3E145969315A2385841062@UMECHPA7B.easf.csd.disa.mil>
        <20210801142107.407b000a@gofri-dell>
        <5EAED86C53DED2479E3E145969315A2385856215@UMECHPA7B.easf.csd.disa.mil>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MR2P264CA0113.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:33::29) To AS8PR04MB7992.eurprd04.prod.outlook.com
 (2603:10a6:20b:2a4::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from gofri-dell (199.203.113.198) by MR2P264CA0113.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:33::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Wed, 4 Aug 2021 09:33:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1679bb94-bffa-43f7-45e9-08d9572aec46
X-MS-TrafficTypeDiagnostic: AM6PR04MB4021:
X-Microsoft-Antispam-PRVS: <AM6PR04MB4021685DCB8BAE7476CA6EDA91F19@AM6PR04MB4021.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9NLaXrFP1dFf58naKTBOlE7fESM9tIb446SczpyGSw5cncXZOtpqqGS1Uq+esr2YPn3qel4xtc9hh5Fd6YdDKZeo16wnIlCTNR0VKkW0XTaCFpaa5dhzqNdrtbmT/r1Y9mmQxt9XmCpwNBKSixvt44/7oeYXUaB1173o0ojLOiFYpMVjV4rAnHjOm//pJJLuOXOgJ5pIr+c6A2VEazLAAGNf4peEnM3AboI+2o1+wP0iageAsHmiYhLR+oSObikW4qn4T0V3eSx7CbKTEuJvBbMVRDWsW6BPr4N98elutKzNxeTzj/yFYnlhGKzQQCUMlu0RGnwPRxZA8ipP0OhLM7yp8lcLSeLnt2BYZTpkYtaC4+1lncKk6R1y1wmpNXiOOwc5HmZ49kFPc4p99U5eWDLaEsRxL2DJgkBhgg6eNcId22L5UsIJcD6dpr2cRMGC9PpuWOYtD0KMuW/4TGXYu/6CSjVc6qMJoTk9629UwqbtyY8N0K3PPfM8Tv9JaE8eccvOw7mqhIUBfD+Xqh85Q8YIX7WdYr64GIM6ur+wcJPy+2/fFoOamJs86LfH+4/aCdALUs/oHYuJocO1j2CQxLjsadnh8+dWnr5teHEwcFgG2ZeOWKyT5gONa1Q1p2AjwRoRIfR9FAsVNX4s28bJxBX9V6djHGw/YbGBH04LYM6D5KD4Wh1RZgToSq94axq9hdd7l6OSkaMQZ034QS8sDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB7992.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(39830400003)(346002)(136003)(52116002)(316002)(38350700002)(38100700002)(6666004)(6496006)(86362001)(83380400001)(6916009)(478600001)(55016002)(9686003)(4326008)(8676002)(8936002)(66946007)(956004)(186003)(26005)(5660300002)(66556008)(1076003)(66476007)(44832011)(2906002)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zoDFOqjQ3lv4+l26sBAB7DuDlHMFZD/cvMugv+jMKdBxEFC73ngvRHRoDqG0?=
 =?us-ascii?Q?1YpF0hej4FNtni/DUGwIgBoVx3fc8sK2U9pvnPZMDrJ4SSCOAlj+oovUsjqC?=
 =?us-ascii?Q?RxwxQ9ya9DKLJISo0JZ3U4i4SPAUHk7sVPbsuPvKShwwz10olC0cgM6vFRiO?=
 =?us-ascii?Q?TbMkj0dCiTcJXE3wkgXUdtqQ34dPVIgcvAKgBkRTVLr8MG8CET8ii1FSDXHs?=
 =?us-ascii?Q?up4SOBUIDy2dxd5kfxD41QgGSXqoCk6wN1zOSVH0eiZ0h32f1wIl6kBpSL/9?=
 =?us-ascii?Q?N6PJQXp8+XCSTiGwdZmDnm4qOiOVPMymlOZ22GXvGZ6zh09yur0PEWcFpDZm?=
 =?us-ascii?Q?nU3IB+U5JGwrou1zNceRpq/qA9oROgCwPmXPlG3WMRi3IeAPGBEPwzIKzQzY?=
 =?us-ascii?Q?3J6V8WECapSP2uurrjUTvji1KqsZdO+W+0+I71nnwHxVJ6pB7/qDz/yf4yns?=
 =?us-ascii?Q?1JQu3KIKYMKQMo5QQR1xcPd3FZkdpXxFimnifC0eFGMAfkR1NUSLpPdVqZ1/?=
 =?us-ascii?Q?InjCHHjX8NAZlx9WdJhZiXqiC8waXORi0SweGpqCY4b/3o3FtMFLJuEafBDV?=
 =?us-ascii?Q?74RHr5l9joKUq8ycc8PTmlus3gkmIhF5rphAuQ3i/4uWw+4vwW1b8fDp4ea0?=
 =?us-ascii?Q?zS1olYTpRQnET0JTSKBwklSOCGrrna2ZRyQmm7D24u6HVztLu/tP2WKGBuKo?=
 =?us-ascii?Q?QADAWtLY7AU4TxOfREQdGsXPVOn3hQj/5SMoGidQEfKtcSPjTeegMcv8PwEU?=
 =?us-ascii?Q?ZAOG/1qpadWK0EEhAL4k/g+dVE5mjcQ/8hbZvmOKVoyt4a41WOblbp6DljPi?=
 =?us-ascii?Q?fD/cMQluteD90T2efE2P8pmfmKo4fMJmDachxey+1GoARpqKGwSu1zgYtoUm?=
 =?us-ascii?Q?6sOllFPl2b8J2YUXhhWwijub7WOdlITe2jfEnBzoYoqFErVVPDLlfeXKfLRx?=
 =?us-ascii?Q?I7/SdElqB1jXRnJIDQWUX9Ux85SS2R1sLuUuZ2U2JYUWkHRt+c3AzHIcxk0L?=
 =?us-ascii?Q?qB9nRwKXf5xsIjRlceL9LcZ+5GOR/B/yuUrMhk6Z5lrhf5VOQw69m334Gazm?=
 =?us-ascii?Q?cM0CVfjsQAXAv2SMv4NoEhhSl2j1/VoXX5MswBoN+y4caH9+qa2++HRLHlad?=
 =?us-ascii?Q?tZQAUhoKF0d+RtJX66GtHdQKwoEUynp3s5JdM3ENK9hBIWKpTKboPSxpT/GJ?=
 =?us-ascii?Q?7hlh5CzZN/c0lNtl4hcKqr9xyI6UdW8raXq6NZFLJ3jtg7bNT8fDdgLLc8DZ?=
 =?us-ascii?Q?+jtdQYjBmvc7/+4P41sfLHp1HsZSzGV9jb88uz68kkODrSw1krQmrQGATysL?=
 =?us-ascii?Q?mNmWM9CmoQmXFPQsapR88VYE?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1679bb94-bffa-43f7-45e9-08d9572aec46
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB7992.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 09:33:31.5729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uy7n1b00zjdgebm9w/Tg51DK9PAf0xlHsaPCBAo1od7IU94w6K4Vn8Zk7se+upEiWOfKMhzyTKA7SgwnmeU3pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4021
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 3 Aug 2021 14:59:45 +0000
"Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil> wrote:

> My SA just gave me the server with the 5.14 RC4 kernel built.   I have a two pass preconditioning run  going right now to get us maximum results.   I expect to be able to run the tests hopefully by COB Wednesday.   Preconditioning will take 8 hours unfortunately (15.36TB drives), I have to make BIOS changes for apples to apples "hero runs" and then get the mdraid's created.    In your opinion, if I bypass the initial formatting with mdadm --assume-clean, will that make a difference in the results?    I usually let the format run, but I want to get you results as soon as possible.

You're running Reads workload so it doesn't make sense to read stuff
without formatting first. IMO, you better wait for the formatting to
complete rather than try to skip/reduce it.
Also, note that in my tests I had to setup XFS over the raid in order to
avoid queueing issues. Feel free to ping me if you want the setup script
or the vdbench file(s) that I used.

Cheers,
Gal
