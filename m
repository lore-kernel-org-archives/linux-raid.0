Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8483FC47083
	for <linux-raid@archiver.kernel.org>; Fri,  4 Jun 2021 09:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6059C6140F
	for <linux-raid@archiver.kernel.org>; Fri,  4 Jun 2021 09:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhFDJVn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 4 Jun 2021 05:21:43 -0400
Received: from mail-eopbgr80105.outbound.protection.outlook.com ([40.107.8.105]:6438
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230122AbhFDJVm (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 4 Jun 2021 05:21:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XDSVqIYLPSVi+HdjdztxoyWf4tA6GHQPjk9jcwHd9XdchqY9C3iV59WXZTV8cSLvTj7zvePkkquJ1C4oUePyCdUnGNbCKMju1pEheofEBxf7My4+pjb/mXTCCRro8TeFm9cFDoMUlW9+IzfZ4ij4hOr620EU+nBSgY8RBy3yLIkcmMqaxZNSFnNspKlMDnGr4zD5DXqH95HefIAcfRWJ3Z1ySDU4YREP4XwLCYJbM9IqZPPZzDJg4O0AbYhoScizvvCDnhvPkTwRu11oTgAhTvTFSw0dOtz47I2sNkBFMyYCMnGoJaPe3B5Fg5EwUVfsvIR/Jdf0lan3qvbG6TIhKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hv5xwa67FZFfiDu5NX4cF22BuSRRAkhDWs1HYyIA8kg=;
 b=cfJih/UR+KV8dZdPtsGRmAcyHiUJf1WvF2YjYezcsQHhtM5BoABLwddp1a2VYq/aYiTT4nn1J8WXtD1sp5ecQjAh34CrcbRAlJcrqkFXLUsZ+D/R2HzCQh/POwXO8Wx+tO8QGepL6xEo1bTxY2KiUH7O1p3FrHddVVsrH0RgmN48Xx+SCxPZZtjuZhc9RmtFS+KNPGIKnACGEKGkX5iwPZHTy9snLJg8IkOSgyHfQyyeS4uhTUcsI6/43z3y9dR2SV8JWTACipWaMcml5JF7WwAozz70dvE2bqGX+TuoUTytrvnQgyqb51z33XaPAY/DGvJjvzLrr84ZnFFKeRNg8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=storing.io; dmarc=pass action=none header.from=storing.io;
 dkim=pass header.d=storing.io; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hv5xwa67FZFfiDu5NX4cF22BuSRRAkhDWs1HYyIA8kg=;
 b=FGMzFsQr97bHDj0v56an/lgfmXpGcSyaiCK1K+LvrBKss8jJc1Btii6dxz/s0Gca30ti+UHsd/hayow6QOkjbe6eEo66/FHitAs1Ep1R38VVF5Op3Ppctv3By6on1E2/JSDue0/9qLGrLomMNqSiSkwqeqImTxYLhUf1aLRut6cmE6tcVHVO1X6Tr0pKzTWyZlkz1PBJ/fnASSRR5khqMhsy8V3QQ2io8MOTKcN7m0lsT6oakFSqIOJwpgo7S9dDmSjNmoGaXAaYVc84MAuz7+SmHkIRgIAUnmbmwndVIZ8X6vAVzaxC/rTpTIekWBcnNpA/pWOee+7Z8xkVhHccPg==
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=storing.io;
Received: from AS8PR04MB7992.eurprd04.prod.outlook.com (2603:10a6:20b:2a4::6)
 by AM5PR0401MB2433.eurprd04.prod.outlook.com (2603:10a6:203:3c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Fri, 4 Jun
 2021 09:19:54 +0000
Received: from AS8PR04MB7992.eurprd04.prod.outlook.com
 ([fe80::297f:63fe:225b:3d16]) by AS8PR04MB7992.eurprd04.prod.outlook.com
 ([fe80::297f:63fe:225b:3d16%6]) with mapi id 15.20.4195.023; Fri, 4 Jun 2021
 09:19:54 +0000
Date:   Fri, 4 Jun 2021 12:19:50 +0300
From:   Gal Ofri <gal.ofri@storing.io>
To:     "NeilBrown" <neilb@suse.de>
Cc:     linux-raid@vger.kernel.org, "Song Liu" <song@kernel.org>
Subject: Re: [PATCH] md/raid5: reduce lock contention in read_one_chunk()
Message-ID: <20210604121950.372672c9@gofri-dell>
In-Reply-To: <20210604114205.3daf3e68@gofri-dell>
References: <20210603135425.152570-1-gal.ofri@storing.io>
        <162276306409.16225.1432054245490518080@noble.neil.brown.name>
        <20210604114205.3daf3e68@gofri-dell>
Organization: Storing.IO
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [77.127.21.223]
X-ClientProxiedBy: MR2P264CA0114.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:33::30) To AS8PR04MB7992.eurprd04.prod.outlook.com
 (2603:10a6:20b:2a4::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from gofri-dell (77.127.21.223) by MR2P264CA0114.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:33::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Fri, 4 Jun 2021 09:19:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 486f8b71-46fb-4292-4832-08d92739ea38
X-MS-TrafficTypeDiagnostic: AM5PR0401MB2433:
X-Microsoft-Antispam-PRVS: <AM5PR0401MB2433BF99D765B33BF0D4CEB6FE3B9@AM5PR0401MB2433.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RO4+H6c4594Xq0AiVLF+bPS0JISYFbOjUq8x7jDHcCYyA7/ITHyXiR7i/pISU/JWVqazZoqbQBQ68cIlQeZykvNtrbhLcnMldXj4dh3kIPJW+nWvi52iiInitgtk9/ygmHvmpV3RTdT2YoijEAAJWUr8Y9mBlV73ASURr13VLiOJyOPQ2iFLhO6aQMdPhYDY1N8LP3eak/urm29j3hn6KhfWviX8ybC5n3m2tSYlDfAG38dglfoAWRO/7xEK5UTZfrcA1SkeCRmH7OQIf97D3/oWxelUrF6GlMcxTAjXpbjg3eaBjbzad1VaTptemSWOtJBsCDlfgOqOVV02tsBbk07Cu7p+ZsWq5LwiW5hr+OVrDJaN04kDeOXB/BoJq+aWrT9H1CtfabteE5ePKn5hsox1ZnMmVYbEVyWSZHtsnslfwGaxbZHr45zpS0UrRnzHAgRuMY/Xb2fN8aXgd0DwyOZxhT84AaWx4mJG2th4foT5DOdx6yLtWFKj0CN1Y+0B/KNu7MdYnkyKp3TyKCd9P0K3F5U+6RpDwRR9h9YVkQLPpih3iU97Ts9g6DtzabHU3qNKb38jp5ZtqZOCccY/dcxqGDouKvp5tMvSENY6sIlymAbwm1lWp5Vb+pJrYxw2NhdfIcAnD22LICgGLclujQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB7992.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(346002)(366004)(39830400003)(316002)(6916009)(8676002)(1076003)(66946007)(33716001)(66476007)(66556008)(8936002)(558084003)(956004)(86362001)(5660300002)(2906002)(6666004)(36916002)(38100700002)(16526019)(38350700002)(186003)(9686003)(4326008)(26005)(478600001)(44832011)(55016002)(52116002)(6496006)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wbL1kg0MvssLjEKrIlvnA2nkwrjrRxvpTfJiUS7f62/OowlJf/MaYugeNWQ2?=
 =?us-ascii?Q?zZjNJkJoQjivl5TA45Peebe1xqtIbn8DtOEodd6PRJopKlj7BCOeCP013gj+?=
 =?us-ascii?Q?v/9NYwQXloqIU6vhIaEFOkNRkKaKNt/qJEGW27pcybfbmUOuwnrCA2JwoSF8?=
 =?us-ascii?Q?EtpjJBLhWCZSFl6WWAc37feBT6SGd4UMgCg5zPGIAWy62As7C+87b01fu9c4?=
 =?us-ascii?Q?MdCqa2VYgAXI+HkcrJ9q0dCRbj7+io/C4PoaEVPFVZeHuAsnNWlc0V0K7pLr?=
 =?us-ascii?Q?LhmLN4DT93+kO+jcqIdZ9rK/7gr6OUFwf0zrbJT70nfuH3jjPr/N/jWtz3oV?=
 =?us-ascii?Q?R2VxzxzZdC3ubaqsAZ459O7BluFw+QvJas6ADeP78j0imvZ4wlC5Q5tOo/jr?=
 =?us-ascii?Q?wXGHqYQIFTWikt7jG+KVSVAz/4ZKh/JE9tZrlTWHlkJupgPgj9aMQXPVRvNL?=
 =?us-ascii?Q?BDZSikpUIX2QsECaSxzD1ZePaEbBiAoSsDY7xG1GVujZ9HRNA5CsQ20fZWhh?=
 =?us-ascii?Q?46uPGFwDD8rcLk/5M0WonY7YJrQsph8L2oOoZAc5sqKialsvu1G2GmWj3sua?=
 =?us-ascii?Q?C5HFFbRPIwj1ZQzRbl82zGYD9V7nSgukgnZ1Mlrht/BOmq5kO9KVyl2sewfW?=
 =?us-ascii?Q?H6M2oFAA/rV8qCofZCUDTYwQlrXelPr7LpT7Ty8kK1UkZxS4bf1naEThMxEW?=
 =?us-ascii?Q?PYDCCNgFKTgNCzEb047a4LSEWMI7SddfRZMoN3BtoGHvEvfl07SPMxCkTRxx?=
 =?us-ascii?Q?we0tMG0971pzTZT0l250XxUhkRHAdbHsTgna9OdxN3QjvY9A4RovUecp0Y1f?=
 =?us-ascii?Q?ZVCbVJbhFRYtdjhXPSIx9c7qeWH1wEbzt/bszESocGAjPZjpTwEsrHbtvlCs?=
 =?us-ascii?Q?DBIf+aXrNF93edCFJFxf1zeXcaqiq7SR4pbv2Fpx7UE+A1xEGp2qpImBj/iw?=
 =?us-ascii?Q?49Gbv8e7sPopMyzLF4bpSrDMfZRE54UTNRPAYGVoUHVtM5NxeDGJpxJOYDiF?=
 =?us-ascii?Q?joT5xJ19uIDmIWZ/wdhepxiTBq826kh2BWYR7EpCiCcUBH3xtF6WD9kaLiBz?=
 =?us-ascii?Q?aWpAxhlPsZ7aQVLiOzPYW/ie7U3fHsdPraEN0oRRZBo+ozG66JRKxrpYznPr?=
 =?us-ascii?Q?eHD5QoxIH2GzCT33RXuEBssZLe8Zz6iOXTq+Hg9/Sz2kgDAK4viVK0Nz3zzz?=
 =?us-ascii?Q?iumuMTonMvxwMo+z6vMakDjJY+XRtsg8VbE4YXITEiM5xcG84ny9YzQ6UYyU?=
 =?us-ascii?Q?U/79SI6KH0POaSv1mRFBfvpUm6DZEyrHUcw/TNG8XjKDW51p8zcV8RLFSUKn?=
 =?us-ascii?Q?tOryX4T3eNzchnKfE7xmMdFh?=
X-OriginatorOrg: storing.io
X-MS-Exchange-CrossTenant-Network-Message-Id: 486f8b71-46fb-4292-4832-08d92739ea38
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB7992.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 09:19:54.7434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FYV15HdPUJie2t5lVdQvlKxZ1d2ATxo67SRG26YQJP9H4IXQ2ug580i5Je6DIXCEhtZluNjKFVBB1cnIk8OuEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0401MB2433
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Just a second thought

> Since it only impacts quiesce now, I thought it'd be better to use spinlock afterall.
> Please let me know if you think otherwise.
Since slow path is only at quiesce, I can remove aligned_reads_lock altogether and use device_lock like before.
What do you think ?
