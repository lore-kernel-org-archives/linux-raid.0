Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB373C07E94
	for <linux-raid@archiver.kernel.org>; Fri,  4 Jun 2021 08:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 857BD61358
	for <linux-raid@archiver.kernel.org>; Fri,  4 Jun 2021 08:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhFDIzp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 4 Jun 2021 04:55:45 -0400
Received: from mail-eopbgr20128.outbound.protection.outlook.com ([40.107.2.128]:35867
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229980AbhFDIzp (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 4 Jun 2021 04:55:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FbD9o19yKpVinW+wOFd7Sy4TlmKWsckKleoTSg6NiFhF8cPqKArl6sGBYc67vwyfXgeUDdx8+s2TWKKmAF2FTT31qtmB1OFqNehgNgLQ6/iCX8WvjY5+5NkenaMNR+wVAxTSHXeYFf5bzAZfxLeI8p0tfryIVSE1fcPoEjfqpkjVbD/URih3QMHeTRqcs6O/5dJEDauI7dcwSNP1AswH8LS2o8oWcbmap4CU2Qkpx2ruBp1iI3mVzDznbSHNo6h6+XMDxk3qus4tBJftlj9wh6GyZO4TIvXLShdkgV1i4DmfsBP78wjAiyHLg3Dj7iNXPdi2KCIssTNTX/JAoxFRrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zK2v5XTcTMr8UtZGmpP8kElxBbdJcA4HHftqGJqedME=;
 b=d1RZACpiVGGjN68jsjrb3mVf/BILPUXgiPc1s5CzXOfe3pLTZc7HWOoGoXmSev86UkWv3qZG72GBOOe7iQzF/FO2oBxRWP7uavrE964DT9xDM2hy8N12DQrBuVMi+TkaYDuOC3zdbbmMoET2GsLPaa5nNkRyPcpPcIC8Q7b60StH6YHHAUT7Lhbitc7omixamehzbH5qDiFy35xrUuUSoOAmHX1v9lxQfAAJ9FfDAGzT0C1Y0n+Gi8xHgm6mAWtJY+/DgERHBHdSWL7g51osRJW0aG9IjA1e8hgdfi4B4VRJ7AVNtgiaslG2b0F2vJl8671Crh5Md+ROthXj1Im6hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=storing.io; dmarc=pass action=none header.from=storing.io;
 dkim=pass header.d=storing.io; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zK2v5XTcTMr8UtZGmpP8kElxBbdJcA4HHftqGJqedME=;
 b=FnLWlm8FVd+SKoNcshRtq724P0k7aYjw/X/TReNDT/XYiWOgebMeKHa4Bug51bF1fs09xlbE5J9XZzC4ynPNSiJbMXb8iEdyTlSVIM5dItEGRiJvOpOOgkEo/KQsZbvoVgylxxJVlXrbikWBFr7sGX9yO6K450mcf5BEHvo3o39zuJhC9rHOe0WpBZRa2ipI83pKDw2vwPsQqMXH36Bp8WBsoBThaY9VRH0ED23fQmYnbFKQ3lwrb7KWE4cL4U630XESDaJ7xY2TA+EOYMy9ABP1nyoyAVMLNqsN0EWMu8g/GMoPbuojUVxyj06n9K3HnPeqs95NW2jOCxQNpBHP7Q==
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=storing.io;
Received: from AS8PR04MB7992.eurprd04.prod.outlook.com (2603:10a6:20b:2a4::6)
 by AM6PR04MB5223.eurprd04.prod.outlook.com (2603:10a6:20b:3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 4 Jun
 2021 08:53:56 +0000
Received: from AS8PR04MB7992.eurprd04.prod.outlook.com
 ([fe80::297f:63fe:225b:3d16]) by AS8PR04MB7992.eurprd04.prod.outlook.com
 ([fe80::297f:63fe:225b:3d16%6]) with mapi id 15.20.4195.023; Fri, 4 Jun 2021
 08:53:56 +0000
Date:   Fri, 4 Jun 2021 11:53:52 +0300
From:   Gal Ofri <gal.ofri@storing.io>
To:     Guoqing Jiang <jgq516@gmail.com>
Cc:     linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
        Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md/raid5: reduce lock contention in read_one_chunk()
Message-ID: <20210604115352.0393aa28@gofri-dell>
In-Reply-To: <2a5d0251-bfa5-4ea5-084d-23bbe52104ac@gmail.com>
References: <20210603135425.152570-1-gal.ofri@storing.io>
        <2a5d0251-bfa5-4ea5-084d-23bbe52104ac@gmail.com>
Organization: Storing.IO
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [77.127.21.223]
X-ClientProxiedBy: MR2P264CA0120.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:33::36) To AS8PR04MB7992.eurprd04.prod.outlook.com
 (2603:10a6:20b:2a4::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from gofri-dell (77.127.21.223) by MR2P264CA0120.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:33::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Fri, 4 Jun 2021 08:53:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cfc91260-e5eb-4360-99c8-08d927364928
X-MS-TrafficTypeDiagnostic: AM6PR04MB5223:
X-Microsoft-Antispam-PRVS: <AM6PR04MB522385BD14DA3F393CD52980FE3B9@AM6PR04MB5223.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KhvK2qWHyL6eY6OzedaPzkGBbYrEoolUXOWAoznIwhWj+yjfiThndWAzhGeuWp/P4eU4ymCIh/SNo4+xEGJNfx9YxOZJCWFGfE/VlCZ/ZWddeW7k7jFep0qNy5xZW83S2pOnr57GuLAYpw7WkFcmgQxSujSV6kA3S3ZkA3R+RJUXCD3n2/TURe+/PGvHaO9+ZrIkvwZfF2xc1BcTB2SV6kgM1KlYOc7DbwLSVuzmd9qWw5nqVfnLWkQDP0UQeNFLlCwSNqny/aEEiDxDlmWbxDP21sx+mV0iCIpM9uR+vjkIiIIC4o0kloagDnlrrCY6YD60/j4iwA+uxENEtrstymm9sqtwcWK3BJmsVTwO5XkiIBCCo0zbv+sH5j++9xPwGA5aWC2cXp2lj6gexDr26GcRBrwg2FCd7crh+8lTCURiBydKpfzwbE3D9ahSM0BxmS5vq7aYIqJ30jcWFx1yCjlRDmz3efbwa9J47YoPTTLzE/Ri0F+kwR/KqfubiBOEckAUxtE57H8fGbz5PtalBgkB+JrcPlhk+lRHkK98GgeCTwz7huQJA4oO3U9wOiH+8zzq3pZ/uAy61IoWmZuBwr0Iv28/KeouNnNNXq33RAN+jcmKBxtBR3NFFDCN/aMdKAEEj7stCBRo8KJbXgrZ6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB7992.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(956004)(66556008)(38100700002)(9686003)(55016002)(66476007)(4744005)(36916002)(44832011)(4326008)(2906002)(54906003)(8936002)(52116002)(5660300002)(33716001)(1076003)(8676002)(6666004)(6496006)(26005)(83380400001)(16526019)(186003)(66946007)(86362001)(6916009)(508600001)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: nHFXcz8d6Jikab1DzLpshuV292bFoYicn5Do8qNGYL2CQ5AeW9DYKKtnBwffeSqizgu9/HjjMhpv5hx1O9M53UU0LFl7d2dSwxW2noyYGQcw79+iLFqZ6u1BWniMQnU5edRQzt0KOS8+rn2j2XhMjL7QFyt7Tj6xlP7gYCnX9tNx8df1UiQ011iaOyBJeLnkEvb1z6t5M4T7H/33jUdMp2omqfXBhg9tVGUF4dnPpUFKokP85WPsSDuSJE5OsPQjitUu6cI/W09ixjSrvTc8c5t3X7A8GDf6HpP7fAtDoFs888Zo4ECXgnnRvuzgXurApMuNcsNlYUeqSXEoJEJO5irKQWNSJbmJ4xiyXQRwiNxjYeY2fMcup9ZSTFzit6LNWfSKolzdj+BXEa3tb2EdqiZtqlZ1VlpSGZh/W0LQSyiTQ2NlINFrNvRrq6KkgmH8LoT64cnmEPMZIPWANyrG4ycY+43O0yVXU5g3Swh+ksXcgyYmT/RHRDLPKSCoVuYFjrni9MV0Bmxww7LKRnNoeGq7pQFCw+9X1MElzjf/ThQuGMV5oTragEgkBVvYRQNFTqBKlLSPvWqqwsjL7lx+Sb0swC+zg62TKKOspOoD3LW2drPU2+p0Jj3UyikKn5mGVGrkdhpDzPjqffzhE/h3gZrgNAxmZAx8zjJuRFMyGa9dTfjd7BumgCff9/usLHSed+Vd+G51ZpoAmgedFyd+KdvKZEzdyrXwBnJZLZf2YQ9YpexC6/z9VPEp4+mCDNxG
X-OriginatorOrg: storing.io
X-MS-Exchange-CrossTenant-Network-Message-Id: cfc91260-e5eb-4360-99c8-08d927364928
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB7992.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 08:53:56.0194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Au73+2zrlo2HUxgTQGLXGd6qpglDsciccMrXzN+bdCjDekmp/fEkZE9SB/SkQVCrnWu+RoOHVeAJSfl7TyYJuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5223
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 4 Jun 2021 15:43:48 +0800
Guoqing Jiang <jgq516@gmail.com> wrote:

> Just curious '8'=C2=A0 is chose for=C2=A0 group_thread_cnt. IIUC, group m=
eans one=20
> numa node, and better to
> set it=C2=A0 to match the number of cores in one numa node in case better=
=20
> performance is expected.
Since the worker threads has really low impact on 100%-read workloads,
group_thread_cnt has no effect here.  It performs just as good with
group_thread_cnt set to 0, 8 or 96.  Thinking about it, I should probably
omit that comment from the patch.

btw, in write workloads, the worker threads are actually contended by
device_lock, so choosing any number >8 often results in degraded
performance in my tests.  I have a p.o.c. branch that reduces the
contention by replacing device_lock with hash locks to remove that
contention, but it's a big-risky patch so I'd need to break it down first.=
=20

Thanks, Gal
