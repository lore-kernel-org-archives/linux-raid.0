Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95072C4338F
	for <linux-raid@archiver.kernel.org>; Sun, 22 Aug 2021 14:27:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6825E6121E
	for <linux-raid@archiver.kernel.org>; Sun, 22 Aug 2021 14:27:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhHVO1x (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 22 Aug 2021 10:27:53 -0400
Received: from mail-eopbgr130090.outbound.protection.outlook.com ([40.107.13.90]:48712
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233487AbhHVO1w (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 22 Aug 2021 10:27:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gYPgnR7ADZsKcS8rJDdvGUE4RoVJIpgRULzzhaE+VQ1ME1SSm2MEF9OyyykGxRzae9xIQ+6WKfJFg12eIui2z1Pfa64zHa23LoIUvJW3slib1pPCs7WXPYGrjlM3zVLgbkmZ7RuiPurMDztndDY3KPZvXr3JJCRYuGkQi1MHzIFQKZgFSZNaOTv63snMPI6jfNOBWNMFIDlyKq2q/35mT49QXklwR+ElBsxE8GOlnTuH5u+ifiE9szfJmNylVpZLzcNGHpVw/oiGeLb0hauILpvLTD4EQQYT+oLFrDhWt5dzPo/e2lK2HAHb6mTxYu3oXpfB3oEG5tjI67p4PPrUxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9AaFX0NvELdCBRWyVR4+N9tvNpqHm96aIuXV4qeGEE=;
 b=Lmkrz24iwqftbW7TWB+nheTSx0aUtbnxTc65FiI8peNi0Us4jS/b0we8T3glByr9ZPBM57AwTCix1dAw/wctQ0zl3CVKNxPTycXw9J7T6UFIZbo3QH6WF64rpvstKoqTTMbufb/jfvh8yyB2HAxWDDo1QTTzY5gGAeqe7weBWvugMH7gakhpPy4BLfq51HlpFd2rhNyZstcvuXAflwCw7VU2rQ0XVf37eFRfl+TnFV7/UVTWJL8ld7Cj3N6Y6PNIcFUmp0VBt67jAgGTTMBgodVpTzJ1CKZRg6mhpQFrl+7MXzfSdCXOvl+mTxL6qLcc5bOOTv7hAH2/jzSbqrRkhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9AaFX0NvELdCBRWyVR4+N9tvNpqHm96aIuXV4qeGEE=;
 b=cKFmQR6aGiFDJhe2I8KkAQqjnNDrlf4jwjJond5NPHCTfixLyrDe/1segsR317EJ5nyBDSXfW4+rBMVkiSTT9q7vJMBnfTaODqu9SLU1v3eWD484uJU7icGPX/cpqTXhNcFqrrCIiZcGD90FCoVxcaFAHH2/nE13KHN6mO004CaQZ/JJ/M6NRrZZ3nf/+/zriHSCFfw9/GXUAAjmTQHSC5cFUbhP53YYGaYZSfcxULIlRNTKaC4HBB3xT/7yZ+5Q1AGZSvZPn4Kn5gqTSWPvswSSwZYBhFD71LqgN5ObUwYtC9eESIjM47b+QsTFUoSDnhUozaQVgx9t4Dzjt7C3sA==
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=volumez.com;
Received: from AS8PR04MB7992.eurprd04.prod.outlook.com (2603:10a6:20b:2a4::6)
 by AM6PR04MB6136.eurprd04.prod.outlook.com (2603:10a6:20b:b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Sun, 22 Aug
 2021 14:27:03 +0000
Received: from AS8PR04MB7992.eurprd04.prod.outlook.com
 ([fe80::e4b0:f154:1315:885e]) by AS8PR04MB7992.eurprd04.prod.outlook.com
 ([fe80::e4b0:f154:1315:885e%5]) with mapi id 15.20.4436.024; Sun, 22 Aug 2021
 14:27:02 +0000
Date:   Sun, 22 Aug 2021 17:26:57 +0300
From:   Gal Ofri <gal.ofri@volumez.com>
To:     "NeilBrown" <neilb@suse.de>, linux-raid@vger.kernel.org
Cc:     "Nigel Croxon" <ncroxon@redhat.com>, jes@trained-monkey.org,
        xni@redhat.com, mariusz.tkaczyk@linux.intel.com
Subject: Re: [PATCH V2] Fix buffer size warning for strcpy
Message-ID: <20210822172657.2d3405db@gofri-dell>
In-Reply-To: <162941140310.9892.4439598009992795158@noble.neil.brown.name>
References: <20210819131017.2511208-1-ncroxon@redhat.com>
 <162941140310.9892.4439598009992795158@noble.neil.brown.name>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR07CA0269.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::36) To AS8PR04MB7992.eurprd04.prod.outlook.com
 (2603:10a6:20b:2a4::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from gofri-dell (199.203.113.198) by VI1PR07CA0269.eurprd07.prod.outlook.com (2603:10a6:803:b4::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.6 via Frontend Transport; Sun, 22 Aug 2021 14:27:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e6cb60f-214f-4286-a852-08d96578e8a1
X-MS-TrafficTypeDiagnostic: AM6PR04MB6136:
X-Microsoft-Antispam-PRVS: <AM6PR04MB61360567E0D081A7F42E484191C39@AM6PR04MB6136.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nBD6BUlLIC4NCyjJc36d/RV95xvfjRs5fBWlNRFp24Sp3K3g3dUVW8AEosB3MualYgG6vMKUY70k1y+yhp2Uj4Urc1AbIWRMRZoXHl2h/TuVmPOLvlDDS9PTdV558UPHwTrzN7Msp2kXJ9fnYPbAqQBHn/1LrnNi0GBQ/tTh0w57b9SZNNL1CM7RKhPDJSTJz0p6wONwPVvcfclI0OK6UEpe9k8/a0nq1QpTNI1ExN11shsiu9QYl58IdsGME5Y0NcKGSl3lTe0F0cwM8Qn9tR2D63KIedF53EFkyICRHBGh6x50gRhxi8QRUZODdOxeuRxk7nyqen4LSF+/V3/OuieTbG0/YpOkLJUEmW/RsEh4AL++T5xV/1g6AILgyGLXfLqn4/UH+2VzUXXkfWCIiltqPXr3pclI18kS3QEVPezvuPKRsLw+F/vmGSfRn0jMrND1b+yvMyS23408bWiRB163YTsMj/zGucHXyIldQlwTf0AKJgBjfDvFpTEtoBrqJlhJjH4wveVVhwnYFuKnFJHw5p/fAJVf1zkLc1Slw8o7vOve67e1UNS6uQh18qvwBquP1ZGksOG7/A2IP0bOy7Mo+5GnQUX0RhF0GHPt0PQeFcq+ZsJF8drne1kbwBDfr/ZB4pR2g2BcrehvJ0DF9Y+dtzKLGB30Z/8niyiVM8bo+WCSTMObnwmhMXla4CPmxCFppiWX6kOZd3MaN+1mUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB7992.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(376002)(39830400003)(346002)(4326008)(2906002)(9686003)(55016002)(33716001)(86362001)(1076003)(66556008)(52116002)(508600001)(26005)(38350700002)(38100700002)(5660300002)(66946007)(186003)(66476007)(6496006)(316002)(44832011)(4744005)(6666004)(8936002)(8676002)(956004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s1etzPkAUVY+BE+b7uAmVXbU7Tmv+uoimEdNsaZ57YelD5Nty1/GOgcyoBFW?=
 =?us-ascii?Q?KvLn0C1q3VIoym3VJnCQubOS9eEjmTGPUzV1s5cAwklTqVCnh0fiYPSSyytL?=
 =?us-ascii?Q?ssOmokgloco4IRWVOisCBGSnHugWMGHgQNTR5hMaFiF2bR+g9ZUok1W02yVy?=
 =?us-ascii?Q?Sgqyq3W8lqc8I8Wm2AcyEkOUvecICWzP0oCz60+7xDHsocNRwnRKMBbvYYAE?=
 =?us-ascii?Q?INYcQDmldjGYooi9tm2ahA/WHx6NoQgY5n/beKq5UddzQtFV0nY9GvgSz+5o?=
 =?us-ascii?Q?kg9c49XB6CUa84DlVTjABxa1nPrHfbqZvoQeoxzTSq5d58NPmbEm7vCydXUv?=
 =?us-ascii?Q?BQdElbj/u8rvqA0qcsj3EdNFvBsG02BxXGU+SjPfIFsW7H9g6UN8QjhbD/Ig?=
 =?us-ascii?Q?tlbONILjHEEB/CmyE9HfQS/LMSJVkeEbGW1fNrVP29kbKc1s9epsOTNvH4Su?=
 =?us-ascii?Q?/XKAXvfTxE96OfppXhtkF0SIwodO07PnJYzO9zv3o+eDo60aWXahnk+N3Aa4?=
 =?us-ascii?Q?e6P2rk54fGn+9ZM6Ax9fUCrVU2NBTTYBXknDXddec6N7AMg4pblQxJFgaUB4?=
 =?us-ascii?Q?CCsEOJH2VT1rIzqxxsuFznuzBLLGRSPvABF72GUB4IlGbGLFUdnxQv4cMYzt?=
 =?us-ascii?Q?dy9kRZ5y9N85hTHoqjKBxk7ixIoS+rR3Q7EJmp5N8+pzz2VW6iLAgFBYXwd3?=
 =?us-ascii?Q?dzTxF7pUbWvmRzU/3il2Ebj+mEcBTGX6pK/aXTtmIzqKvjZFPMM/w0ZY60J1?=
 =?us-ascii?Q?htOgLjKbjV101+VFjxvzHpYlnUMojQnHTCKmYI5oe0dN86CkYdvZ/efML4ss?=
 =?us-ascii?Q?/3HhewvDZYxfcuWxnJ1OdI0WA2ho4d4Xx/+gwkNx9IGtjV9QYutLIlbGAW1f?=
 =?us-ascii?Q?z8R7i2K56shReAnh/rAp3FYdpBZTl9DlxWo4KFYsFW8Kh9aA6OGEHRpfEPdk?=
 =?us-ascii?Q?zmc1owIE5lB10cFJLPQCG0CLflQ/+cUqKTVePqvLYxIxp/50BKgrjyU8Wah/?=
 =?us-ascii?Q?Eiz0tdUKvaRVKWwX7tSkRSddPb8yRamPLc4DtmO2ZMYV1ueqZvMS7YDjOd7F?=
 =?us-ascii?Q?LvbI+EgF75JtCYAa4C2aYE6rqI7FDV93eRnAhxGgRW1V95dPitmb9a3Omk2s?=
 =?us-ascii?Q?/gO+KrUt7u3CU6qt6B2SnNd/EEZcrOVZGyFQEWnxc7eGX9LPsy5x7MdUmwV2?=
 =?us-ascii?Q?9+sPnEUdzgQjc7/xpiKE5ixwy423rPgVQ94bDHofUW2otbz1m+OQpNiWuRUL?=
 =?us-ascii?Q?ckvuv02TdZ/2lzL16NpWXtwAhEBSIt72DTqowQkuftGZjgw5UCtb95XVtikk?=
 =?us-ascii?Q?Bnj0vvrD77eaZ0VZsaeOwzEf?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e6cb60f-214f-4286-a852-08d96578e8a1
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB7992.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2021 14:27:02.5215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FrX7XgsIGRFXbrit05x2OKBIIKrYlD6u7xYnVDkEGeHT3xUg4zwvc3aNuD5W1bqsyh5FMunFnbSUxMK1mEInog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6136
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> You really should explain here why we change from filling with spaces to
> filling with nuls.
I guess that a commit-comment would still be needed, but I think that a
more conventional approach could make it all clearer:

- memset(ve->name, ' ', 16);
- if (name)
-	strncpy(ve->name, name, 16);
+ int l = strnlen(ve->name, 16);
+ memcpy(ve->name, name, l);
+ if (l < 16) /* no null-termination expected when all the space is used */
+ 	ve->name[l] = '\0';

Cheers,
Gal
