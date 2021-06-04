Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3718AC07E94
	for <linux-raid@archiver.kernel.org>; Fri,  4 Jun 2021 08:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1609F61414
	for <linux-raid@archiver.kernel.org>; Fri,  4 Jun 2021 08:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhFDIn5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 4 Jun 2021 04:43:57 -0400
Received: from mail-am6eur05on2134.outbound.protection.outlook.com ([40.107.22.134]:18657
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229930AbhFDIn5 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 4 Jun 2021 04:43:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HUpjbEn8y39zlD37h+aaGo1fxhF5EiBi+R0Q1IO/L506y2R1H0gmD8wxUb/ECrr01WOyCDriTACfQKI1mo/rRj7MltdLwFruRF7uZLSpVHuYiZ+HQS7SAx4mPdzo8mZwszMX8e6y+0WTQu6i/rbdOrau5me13oEfJ3dIpD7jWLaZMnXvg+W64aWqRrA3WOuQ/N2dLjKCTHQZyrDuIHJf4Ygt12Bf3zOzzRu+ubeuCSivQ5FKEaUS6ZZTOOPIjUbfA4XEDUx+vfiHQSxXmXhTWlPgb/o6TCu+mHbMwAs199PK9CllrcHPlw+oXebvtCKMDJN0+V8KvixANfziw1l3bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jxtV6PUb9qLZGVIal/6Yr/c9zSlFOWpT9fuZ3kwbuTo=;
 b=L9uCaKojXcOeQFMTyy7bDfNdj2ANgB5qdZiTk7vPkRbay5KdVFnXCbFts3m+6L+SKlxxSs++flffiDyErWckXFjAngoFiTRjnvhLCjaZZKLtn8bBluTSO1FbjuxTSji/ioMu49ht8zYvgDMR2pBZStoAj/rKo3s3iPOQBLfBaXJsXX3gkDn6ZntM9szdpl38Xs4z6ldDImVU77of6V67YyLt49BfS2sMQtu1rtzPGazYseTckmW/c3eQuM0XzfpsENV2mNzJAD2n3DkgbuacYme/d8uzEo6zzg62SO9FRTWGBVowXx/D8e5zA687CZvNmIFCvuJDc1d2+tSU3d0Ffw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=storing.io; dmarc=pass action=none header.from=storing.io;
 dkim=pass header.d=storing.io; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jxtV6PUb9qLZGVIal/6Yr/c9zSlFOWpT9fuZ3kwbuTo=;
 b=CaRrPgqcQWawfOmXXYxfvPA0GEALCleHrVrABLpRelCek6bBeFsIBG7cdcKA93AM4yFEPkfA1nHE8Y6f6nGhL45VM1Bx9FVBr0sKWbIfJx2mg8L7vLjx0T7gSHroXPN5KPDBfCs1YhmYhCSH8Tk0lLmTXWF0w1cndYCNSYYeTAqt4JPontPRq1yMxuF6wkGufjN+e8Op2vl6aVjobVptHLo0vTW5SDcqAQ0nGfkEoWe31bncuv3x9WLo2lMP0PeE45NEP8DNSdOsElm9ENh1ajJGhbUWG0uYO0IXYFOZpfMpdVxmMiMcFPPwNYO1tK1V8VRfe+hVE3rpEAfwc+BxQg==
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=storing.io;
Received: from AS8PR04MB7992.eurprd04.prod.outlook.com (2603:10a6:20b:2a4::6)
 by AM6PR04MB6247.eurprd04.prod.outlook.com (2603:10a6:20b:be::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Fri, 4 Jun
 2021 08:42:09 +0000
Received: from AS8PR04MB7992.eurprd04.prod.outlook.com
 ([fe80::297f:63fe:225b:3d16]) by AS8PR04MB7992.eurprd04.prod.outlook.com
 ([fe80::297f:63fe:225b:3d16%6]) with mapi id 15.20.4195.023; Fri, 4 Jun 2021
 08:42:09 +0000
Date:   Fri, 4 Jun 2021 11:42:05 +0300
From:   Gal Ofri <gal.ofri@storing.io>
To:     "NeilBrown" <neilb@suse.de>
Cc:     linux-raid@vger.kernel.org, "Song Liu" <song@kernel.org>
Subject: Re: [PATCH] md/raid5: reduce lock contention in read_one_chunk()
Message-ID: <20210604114205.3daf3e68@gofri-dell>
In-Reply-To: <162276306409.16225.1432054245490518080@noble.neil.brown.name>
References: <20210603135425.152570-1-gal.ofri@storing.io>
        <162276306409.16225.1432054245490518080@noble.neil.brown.name>
Organization: Storing.IO
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [77.127.21.223]
X-ClientProxiedBy: VI1PR08CA0244.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::17) To AS8PR04MB7992.eurprd04.prod.outlook.com
 (2603:10a6:20b:2a4::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from gofri-dell (77.127.21.223) by VI1PR08CA0244.eurprd08.prod.outlook.com (2603:10a6:803:dc::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Fri, 4 Jun 2021 08:42:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cac1f7c2-b0dd-4e06-b037-08d92734a3bd
X-MS-TrafficTypeDiagnostic: AM6PR04MB6247:
X-Microsoft-Antispam-PRVS: <AM6PR04MB624755C15028113B6B71533AFE3B9@AM6PR04MB6247.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V+mof6cliO06Pv7kwyq15y8SCB0gpgUdJAgMUICcKmDce0OBjBJUON1XDJ5woyAEv9z8DqDLqonQypvPitldMOcsRltHixh7TxeJU5qF75FxUrbjEyMW4SY3ELOECfB5BzXfyJTc3VIGk2x56BPDgoSgkoy2GOHYkY4+qRGv+VdqL3lwV2uSHFBAZ7uxCdTwzJlOceJXlS7YnzJav8D3/E6zBC5IzMd43UPRQti+w49LzElBjAjrDyUfAdA7tXn3Xb4fydH2++evA9vBEcBtbMrWQOCnzRjRxKExehD00PAz3OIlTEmzitdFw6ClED/A3Zz5lWkBORCTorsDvbIcMJrrfgEDbN5QzaHlFB/rQ4/3gQHJccu+dTmEx9X48zu0GSjb6c6Rq4REuKugartBeFAOhmOWYLyt0pyP96tGRCcoXQLXAJ/pDCTxZciNQZWN96yZf2ePqObNmkMHebJTauv2mSQk6bMBkIHeCqtYf5D13deTsItJB5s4m3TXgHf7emJ4pk8XASl48e/5bZiyeA+xYyC1LBMz1piN0fC32DknBIKFZ0kNFlhZ8GxrI9AAeXdQG9ivduwW95MW4XRNG8cYCgcl7Bwan3QSN9awSi09vHe3PLjsSjPFZiWSoNN//6jOEmPcjN1EnmayOsHrVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB7992.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(346002)(376002)(396003)(39830400003)(16526019)(186003)(33716001)(66556008)(66946007)(66476007)(26005)(8936002)(316002)(6496006)(1076003)(83380400001)(38350700002)(38100700002)(8676002)(956004)(44832011)(478600001)(6916009)(4326008)(52116002)(36916002)(5660300002)(6666004)(9686003)(2906002)(55016002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: L3oX1U0nov+ICM0NmPoWa9OR48o2dJvyfQ1qOlDzjmhMy0cVFT7vCSJyciGyTZrb7ESkltvK1Dw+ZzDLvCJKcfN00DaHZ3XGBlqiLfDvzLzyI/2fGyy0rgoO2sF+vf4bHizFm2RO4qMpjJWFTF1fKEGPsIUINuJADSgEJOWYFqxwD3W6N99IFiGE5ffzlLVCgICpOE/c9Pr5n+tZLYPMKRa8BSGoBYwqOcSiytewkrlO3BSwXSyF586doa4ATOjYiOwHRStif5NSTyfws5DSR9fU756iYlhikVqHVxU2fCfhYjELBHn2rr/4+YwI/m5fSRYSyXHe3E4yxZgE2LiJBgMoQXiHBCaQiwQG5q4foVOi2ih7VDTgaTY/+arUTpykcZGvNJurdOTACGFZHqYfmWSy9+vmUUyz8G4zaFa0Zz4/rEqPbqFhRpT1tr8k3L17nFySC8c5d7FQ6qEsaPy9WizfGB6yMLI68UU0xdmrCHu85ea3Asc7kmF1k3lAFl2vB3s5g7coR3rXXxrJDXa1E+U3Va55H+1h+bxml8wIZ7iyQDFw0ISST2aR/KMa3oxgyfGegFimLyMHSEcQoSWTkHtalVNOqmX//U4IjBKZX/YTWDqg6gTVChv209+VSjTigpfa8XqoHr4bayxiTry/sMPWcNV1FfzGDitZIUSGJaN3TFgrbSODLDCeVNaVhYk1yYbMoyHH1A0gNKVjBNQ+zPfhtTbIFxwAYor9nTy/c9A41FlsAGPJCo69ta4ITXPa
X-OriginatorOrg: storing.io
X-MS-Exchange-CrossTenant-Network-Message-Id: cac1f7c2-b0dd-4e06-b037-08d92734a3bd
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB7992.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 08:42:09.0417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /CSZEfE8Y38CGguWi+/ppwi2da7ozeZmGgHKLFYEpIr2JE9P5kMCcVdEH9llEr3rI4FCSIM2lsl+zQOFu37AAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6247
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 04 Jun 2021 09:31:04 +1000
"NeilBrown" <neilb@suse.de> wrote:
Hey Neil,
thank you for your feedback !

> This surprises me.  I only expect rwlocks to be a benefit when the
> readlock is held for significantly longer than the time it takes to get
> an uncontended lock, and I don't think that is happening here.
> However, you have done the measurements (thanks for that!) and I cannot
> argue with numbers.
To be honest, I expected spinlock to perform as well as rwlock in this case too,
but experiment proves otherwise (lock contention and iops are almost identical to before the patch).
Maybe it's because wait_event_lock_irq() is in the critical section ?

> Could you try that and report results?  Thanks.
I patched the code as per your suggestion and it performs even better:
up to 4.2M iops with zero contention on that lock (~55GB throughput).
Since it only impacts quiesce now, I thought it'd be better to use spinlock afterall.
Please let me know if you think otherwise.

I'll run all tests again, rephrase where needed and resubmit.

Thanks,
Gal
