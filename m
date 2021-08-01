Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B20CC4338F
	for <linux-raid@archiver.kernel.org>; Sun,  1 Aug 2021 11:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E21CB60BD3
	for <linux-raid@archiver.kernel.org>; Sun,  1 Aug 2021 11:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhHALVX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 1 Aug 2021 07:21:23 -0400
Received: from mail-am6eur05on2112.outbound.protection.outlook.com ([40.107.22.112]:12575
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231461AbhHALVX (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 1 Aug 2021 07:21:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZSDlsiP/NvA9HlE9ZVfWJiV9+vFYETAPh7qXXu+QfqC1g8AchpNNNdJrOyet7yVEgDmNG3/xaG4cJrdAZSlTbDtSneVSH9orsIUMVpGZDYo5mgQeReCjOw5rVpnImKZIfeN9tjKoWAqvg5tTztK65FBxqLFujMkuj4+1bmZ6vnq1njbXLfNKmo8egwHi0S6Tk5nUR/ReCi4rrcBi8XUgG8XC8pcecdpAHp9y0aqFhIznqHNzaOJuup6PfhwfMoNsaaLGHh5j0/5sfZ8fjFmOGdoTcirvZSij9L2zz8PHq4ME8Kc3ZDS1xm+4PQZN88Igv0Bqi8FWuoTSe8+OIGXiVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q2LOey0AtlCKnYSrpEuFlOz76JKWFKz3TazogY1cV84=;
 b=ZWZQ1hg+rXrRnce6n+YJeViBPHu4Ii9scj6mUYVzvIy+Iawx34w6JOJ06JD7/gURiNAgoee27nww02ghq3O7IZjPOjNCSWxOX0vvlWjwHgrpUiW4psEsvGop1aavw1M3vsJJsv2I+kmRPMeGQNzVkwVl3W4c5C3U3JVyWE82WlSI7SuwvnUVfChOVST7gP1TeFgjdrNIMYagCwQpYyOPV9PE+aQy2kHEsrYHQsZ6H5N75uMyha9ZDdovjkOqLo92W0YXZd1M92KWow3P/48SPU9h4jo4umdo5e7kIzARFJzbcVGPGf2wkHiwK0fp4ZRwu0GhJrIW2KNVoz+7mfakdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q2LOey0AtlCKnYSrpEuFlOz76JKWFKz3TazogY1cV84=;
 b=dgSN4QDEqvRy1Cb+rc5Jy06WmxEK55G2fiKuIkBl84+s9pwK2U5bFfYrFu6STYYNRdFNrNPeCbA9XZQtqviM4vLQMbqeOC64sKq/EjAvYVTXse/KTovnpszlvKaUYENQUoMWE4/zjEIXnjzduo3SLHIjiw6ul1YVn3ChRQfAS4MP1NNmJGKlLLmd9M4B1ZjrXyNdKBoXpaWUr3udXmpkM9wM9EFrPeqqBo161DXlU/6WdElZ3cOCziJUw1tKusOSND97ViNTtw9qkbnsI46KA43jaN8RQpRwsATwrX9jGqYdT6+cBSfGpDX4fNMMmsgKCSxC+2mglFZfG884uJVZMg==
Authentication-Results: mail.mil; dkim=none (message not signed)
 header.d=none;mail.mil; dmarc=none action=none header.from=volumez.com;
Received: from AS8PR04MB7992.eurprd04.prod.outlook.com (2603:10a6:20b:2a4::6)
 by AM6PR04MB5750.eurprd04.prod.outlook.com (2603:10a6:20b:ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Sun, 1 Aug
 2021 11:21:12 +0000
Received: from AS8PR04MB7992.eurprd04.prod.outlook.com
 ([fe80::a565:bc72:44b3:dd80]) by AS8PR04MB7992.eurprd04.prod.outlook.com
 ([fe80::a565:bc72:44b3:dd80%9]) with mapi id 15.20.4373.026; Sun, 1 Aug 2021
 11:21:12 +0000
Date:   Sun, 1 Aug 2021 14:21:07 +0300
From:   Gal Ofri <gal.ofri@volumez.com>
To:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
Cc:     "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
Subject: Re: Can't get RAID5/RAID6  NVMe randomread  IOPS - AMD ROME what am
 I missing?????
Message-ID: <20210801142107.407b000a@gofri-dell>
In-Reply-To: <5EAED86C53DED2479E3E145969315A2385841062@UMECHPA7B.easf.csd.disa.mil>
References: <5EAED86C53DED2479E3E145969315A2385841062@UMECHPA7B.easf.csd.disa.mil>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MR2P264CA0191.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501::30)
 To AS8PR04MB7992.eurprd04.prod.outlook.com (2603:10a6:20b:2a4::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from gofri-dell (199.203.113.198) by MR2P264CA0191.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Sun, 1 Aug 2021 11:21:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08a8f466-8e68-469c-dcb0-08d954de77f1
X-MS-TrafficTypeDiagnostic: AM6PR04MB5750:
X-Microsoft-Antispam-PRVS: <AM6PR04MB5750407091D08EC20AE33F5891EE9@AM6PR04MB5750.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yO+H/ImttGz/E5AjfWCT/YyRdedR3mQve0+vfPu4Umpr3hBzJBhGSQfdx+LDyxiK5M3pXB4zYMyFTPvuBtb/6Tlqia/4zbg2+3Elx0fAXdC+RsfogrKGurtwEGmsvVuZCIXdqP0HUkw8IQvfjeWojmw5Db1pVLPGK9XWpP2+qFrzqIUfkUfBeHSFFV5LTZJ/ROtQpXTFSuPeyYE4c+wbX100cWViGjeoCcepP1Bt+6G8Zrp31AXOyVGnAy5LNoK3RojAFzyYQfzxH/D85evoCWM4+FRJ27Xe0HCLvp0CUqCFdf33GYtOI8TXrR2/qfACS6Lv7Sq0axJAjNjYiSSVt4AYvhP04VEMYSBiiyt2bSXb7Dk1HYbfgF6IGVHk7ryKa4riX9RTPINHwuLSahip3aH0Vzy3UaGAQYFLa9EIoetn6B/Ed1CQ2hj/vi7e5tuUbHUhltKgoozMglgedm+Y2ERPZe79YQhA9SivgghBg7W+QC8GtvHBbP8eU4MHM8Sym5gpdX50aJs1RersMlQPVuRqLkjOAFTQ9v+SC4xnhPe5+LvoeHkfgyAg3+bfaO5o2m2gXMSkhaqguGkmF+9uJ9W1wos+1BTXCKljt45K6x4Tf3a4b3z3mnB/z8ilziGFFHbnkpuXiVoj8kK+gKOq6x6PZ+0kNxqT4W7uxylWRlPohU7FCqCcsufWr4f6OytPbLp5kkT4Ygacn52wjjNU7O39CnJgwTFKEavJ0ZXnhp2iHjiCmA98Z5yoz+WptnxMmviuw6Y083ptkPqafPzoSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB7992.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39830400003)(396003)(346002)(376002)(8676002)(478600001)(8936002)(66476007)(66556008)(4326008)(33716001)(52116002)(6496006)(6916009)(9686003)(86362001)(966005)(2906002)(26005)(1076003)(66946007)(38100700002)(38350700002)(83380400001)(55016002)(186003)(316002)(5660300002)(956004)(4744005)(6666004)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t+fzBJn7+wUKTcrvFZ2EMXhrWpg8FVY9hpnYD9zRT4TmkVYXkcs8VOOMyprv?=
 =?us-ascii?Q?oMrxa5x9aRaC86CAomoDyy2khgOMLXHdck1mZt7rgvUD193G89ZvqtwNPyou?=
 =?us-ascii?Q?qfuo0X8Jz1zsAFE7pi0n27N+8Qcd3Laod3Dyp8Hrl8lngkPrJ8peBpDOUkW9?=
 =?us-ascii?Q?cGV7csFdSstu2Ff0qaWTfZDcJyOuF+8MVJThI9zGiqPGxPvr4bt+rvLklHQy?=
 =?us-ascii?Q?uoT8XVLPw2skeU0IWRsopZR4wtAvfq7e0BEifLFz2r0RrFH/8H9PojuGv/T4?=
 =?us-ascii?Q?Z7GeGXneCbBG+hJ3VJTbRTm+OOX1V4tRoycU97pedt3AeR3DFBqb6+z0BY57?=
 =?us-ascii?Q?tBSydsUkdkB43LzGphnqKaFa9WDxFqLOhmKIGBZDf3z5ywxb8hiauFTmSH8R?=
 =?us-ascii?Q?Y+hjJpB3z44tXMH4FfbmU2S7bNUVEX3nenoWCfogadXYxLymn/fRbImpOOWV?=
 =?us-ascii?Q?U0SrUify9z63tPUQ+2313rbM4TS6OKzQClLOURUKnpGlm2lLXJmTlcJFisMl?=
 =?us-ascii?Q?lQrg8mNHSbgawyYZN7OXXsXQTk310n8j4UzN7FcrtP8NtLKGxgrflkOhLLXq?=
 =?us-ascii?Q?gnVCJBiFb+6NLtrzzFUWRijcheXYvbT3tNrwhxgEnLJhGKVxROTf0uKMdrxc?=
 =?us-ascii?Q?STp6tiOqK+w0s/+sCEDmCMgymzkjAOeGONMIEIrx47sIcNQKh1CFzBkGBMIX?=
 =?us-ascii?Q?mVUqGAEfGLWBLMT4g2xwVFo539Butpyd7gHlMmOJgL9lvDeiHb+H0p6hbeWF?=
 =?us-ascii?Q?h2m7pfe1N3ba46ytQIU9TGCzwETO8uRlbOkJB8O78zhYYhj+PrvXstPo2OC9?=
 =?us-ascii?Q?QWQII1XELGZpnJS29mKTNuxZ9ExbTqhhxALvT4E3upfhTeMSDMXCsoYkaVg6?=
 =?us-ascii?Q?tgGKZpJfaOOdCcuzOClXbHl6PUPF/6uXyGMYJ/DBxTLm6CjQEIjf7gQREoLX?=
 =?us-ascii?Q?UfsK4HGlHC0alEzRV/LtXElrvRm73IM2+ETk2GZC/Khac9EVOy1EdlEzbpam?=
 =?us-ascii?Q?H63ahD+ebAxpz90yKu/FGlPlrSZzvl9f8+FM3qT2DrEYAt8f+0t2EXJsQZ8p?=
 =?us-ascii?Q?lN4ADQPj27ayMDTa6suyeuKug/F+uuze2pRVRGW7d2uxwbDzbWrzJ9IW/MXl?=
 =?us-ascii?Q?zk8HfQy5G6wi6lmu9sIJhSYaHW/ycULV/CiKtFSSLiNn77yFS+eMyW10KoGI?=
 =?us-ascii?Q?lTipmLmFybklm7+52DMAVAV9uTWjZfQvxHTP3Gtxfst1UqGHxbpi4PXTeKpn?=
 =?us-ascii?Q?oJrCR7RcppNRvcArTQCk4Psq4i7ikCzwigEVqzDssnko8L8U4t82/UxyTxlB?=
 =?us-ascii?Q?qxrV3LU/aw055AakTwOaSpzR?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08a8f466-8e68-469c-dcb0-08d954de77f1
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB7992.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2021 11:21:12.3200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PScow9UsjTg+9X1bKiwxNlzrdUDMCK0Un1E3nZ/KGy9b5QNq9tSXPsD/qE0Cav2Yyi0SbEO4vb7mMC5RvGWI7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5750
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hey Jim,

Read iops (rand/seq) were addressed in a recent commit:
97ae27252f49 md/raid5: avoid device_lock in read_one_chunk()
https://github.com/torvalds/linux/commit/97ae27252f4962d0fcc38ee1d9f913d817a2024e
It was merged into 5.14, so you can either cherry-pick it or just use a
latest-master kernel.

Sounds like your environment is stronger than the one I used for the
testing, so please do share your benchmark if you manage to surpass the
results described in the commit message.

Cheers,
Gal Ofri,
Volumez (formerly storing.io)
