Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E412C433FE
	for <linux-raid@archiver.kernel.org>; Mon, 23 May 2022 18:49:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239953AbiEWStP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 23 May 2022 14:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243939AbiEWStD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 23 May 2022 14:49:03 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0077CFF592
        for <linux-raid@vger.kernel.org>; Mon, 23 May 2022 11:33:57 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24NFkjwU005254
        for <linux-raid@vger.kernel.org>; Mon, 23 May 2022 11:33:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=oW1WPaEEfwLOEfG7/03Or5s673uwXOFIwDNfFY92wvY=;
 b=Wsvnt5b3dW9r3kRccyQSDBynDxqmYPhxfOA0eZUEw0X+Jv6725Ye42ZaMF1wDkLzmu+j
 8EHLZdIfpkPYNcpi87/PEHsAQiCERDg6JyAl6lIi4IA1qSMchxpUBs/+B44HqhQL+pyu
 5qtDv9UWw7cxFJ7/2vHoPx7RYrK/gSjDgKQ= 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2040.outbound.protection.outlook.com [104.47.73.40])
        by m0001303.ppops.net (PPS) with ESMTPS id 3g6urvu7hr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Mon, 23 May 2022 11:33:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IRJs03NE1BVYx5JKsbyEPOMAWEg7Iur0ODopEBNcssyYMNKvutDgzU18hQcFPRFrwGHpK72MedJW3N1AvTW1TFQ8yptFo4swjKV+C/XqJkS8yFAlLcF6x+fNePzDg/yEbsJLhIK5k53sk9nlidK9CURTTedmKYPiAqKnE6cH/+sBTThPyzkW3pk6nhrNOnB0W/PKdIfUb42hE9yUiDhCLy6BUIabHBp4SXV8ovRWim1M8b3Vopb60PHTAgeoHfEPrs9GsGnebwgFXwKyjNsD0gKNAQyQHsmCv/Trl/28upTRBMXCSmlpGwAgtLRyjZfFBkxwuXuND2zdYbw6PYD5WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oW1WPaEEfwLOEfG7/03Or5s673uwXOFIwDNfFY92wvY=;
 b=nxGbAOfCIKSd8SCfbIXCfO60i9cVpUFQmpD5Qoy9JqhABxv5ZGuHNfjP8YHTWHQVNvWx1zUxZmo5qqJGENhql3j+PzDd7eLz+hUoEjYsc6WrKhJAIyhxqs4zsALHoVjMAy+yJY7gJSSx9TF/q9U7nUIIL7UonFhJ0xTDDXtg0OaN4/VU2uSMzX8YlKGJQSu06imMx6ab8l8hJCtcfhyrhQis6VqU8s8LkHg8Jl9kTLYmT0yDt3Q1DzBn3F8pCLjA6Qmk5ZJB6GQ+lDQfxtpaEylCofzm8Hv+IE803cyBlWR0+iIn+MPZr8BDHCkOF1SxjfyZ55r6h9rYqikr7RZnzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM6PR15MB2508.namprd15.prod.outlook.com (2603:10b6:5:8f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.23; Mon, 23 May
 2022 18:33:20 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa%5]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 18:33:20 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     linux-raid <linux-raid@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Guoqing Jiang <jgq516@gmail.com>, Xiao Ni <xni@redhat.com>
Subject: Re: [GIT PULL] md-next 20220523
Thread-Topic: [GIT PULL] md-next 20220523
Thread-Index: AQHYbtCGljtbaIdBDUKBrqUmqdAERK0sxUyAgAAEOIA=
Date:   Mon, 23 May 2022 18:33:20 +0000
Message-ID: <3120BB0D-7CEA-470B-9C21-AA5E92A49E24@fb.com>
References: <1711B04D-64AF-4398-8852-57AF79260EE3@fb.com>
 <3b5599cc-2d04-c2f0-b456-3db77fb44e91@kernel.dk>
In-Reply-To: <3b5599cc-2d04-c2f0-b456-3db77fb44e91@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36444bdf-c3ad-4573-9d4c-08da3ceab622
x-ms-traffictypediagnostic: DM6PR15MB2508:EE_
x-microsoft-antispam-prvs: <DM6PR15MB2508428EACE184DCFE409908B3D49@DM6PR15MB2508.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dqz23/APw2KLVWG7ktvsWMpZEx3PT9ZHV0+psRcOUvSf09qMhQQZ09Sb2bijxbaRShzHD5w6Un+2Lpqm+UAHjYXOp7GPMdBiUpwUZGWcVaRcNZ2ptMNSNPP5mG7dqVOr7g7r3kCFJ11gDeF+G5bCX02h6cjVJpF2/rjpeVFyAhVPvfK86R/0jvX/MsHGG0FpAyldLUQK+++y41JfNJNcbTLo4qY0QDZEXOlCo7n0AsRNq+Cx2aJKMYW2zMopPYMZRFRYQMFXBb+SqDe1Fhnoj0yWF8ydfXC1/l76ZF/R9ZV2otyfC4SPQ32DY+qUhOppaQfntb/D21D41QPLAkF+5ktBAgaoF8OMWIqTxVI7I70k/TttSBBv8k5BNZQIwNnz8QKccOPxRzywvxPhG6IsYayzNbM4j5epi1/eIZLJcZtlj29A9mU6LjNYO3HBtxIs30XC5Pj3OBCC4ldmif4bGG/LK6kQXu7Mec+C7Aoen3G6dXcJS9N8+rVpJvqcbeX93nSJKvROOrcoZ84igaih87sWi+sm5aeOYOIPEOQaGSsx4cg2bK5brsKvtTyr9wI85jZdQ0voCdjJhkxYZYhfwF3FVW8VLo2K80Ve3WiidxDwDB1q3i3KIIojk57berSzCc4HnmmffJlnzTd5vF1P0aAR8LYzs6WHZ344/5lNv5QgTPyrnj6g1beZK1qsppVuBKCxwRtyHdvWWmGt9aG4jfqLVVgfuk6CCWjq4TRQF/kmBp5vLNtyEllnC1LtKBYn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(508600001)(91956017)(76116006)(66946007)(316002)(4326008)(66446008)(2906002)(53546011)(36756003)(66476007)(54906003)(6916009)(71200400001)(64756008)(5660300002)(4744005)(66556008)(6512007)(33656002)(86362001)(2616005)(8676002)(8936002)(83380400001)(186003)(38100700002)(6506007)(122000001)(38070700005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bv0FmiRDxcHoBr0VjbMsxUVr4KSYttRLwW2WBwFdVbO0t9OP7fNpoaim6soc?=
 =?us-ascii?Q?05m+7kKtH9XK2Loblu5Sn9+vyhKGdnmPLWZCSUge54ESv/X3wHNySQxXxvwK?=
 =?us-ascii?Q?rwIbWco2vIPw1UvuMGeiVCjAHra6eNaVhFd5+iTFWqCUcXFQB/yI16P8uixH?=
 =?us-ascii?Q?Qqhgv/Zow3he7PIIc7og39SAZpZySI2U/5Scfg6ZXEn3W9JyYGQ3LsFm7Pg7?=
 =?us-ascii?Q?0u0Ej7WzArc9xNipl2noKUbR99Ya92ox9W8Lz2uzFQFEQbJwQlZgoH0+L1+n?=
 =?us-ascii?Q?sqYAmYlRTlxYyX1xWdWdQw84G/a3TPrmDNBWCArWsJzV1s+BeaduWatilZAV?=
 =?us-ascii?Q?q9KwhkTuTehu6CG3D3Au/jqXDsWbaGE20lenEGKMg9O0Qv2mZJWUL5JykUlf?=
 =?us-ascii?Q?7zJvrzfjpZ6sRQ3KsH5RuqMgdRfu2i9UBv8RZjz0ct3YIvGpKU/Md3UGBdc9?=
 =?us-ascii?Q?/sBXCkkRzQysJ4zJqkGnBx7e2vT4/o+gr2BuP6UHTiGq3HGEVc+9gQsDq2p4?=
 =?us-ascii?Q?fAyuVkI9ni9zO92NMCiX+av3DECv4f/rvhtiDKRpZ1ZBExsVjpRgTtDkTns2?=
 =?us-ascii?Q?JtIaRGNX5tJDaqg9JSFDKO7A+1KUe6r793CVANn/Qxz3rVvmrHzpOxZuW08j?=
 =?us-ascii?Q?q7v26vJcdPGOHk6le2mlmp7ESxTP4lXiv4hc6H4hdIJJ6pQN2YzqIh1bifJl?=
 =?us-ascii?Q?h1LsaiqEESu2MvRqDSt5C8gedxXeLhq7MEuR+6LWXK3/5cpw4scPTXQyIlvq?=
 =?us-ascii?Q?CRS8rsNdUHPQKZimO6ULHeBOKt1lm/ZQgs+Xb3RKBHj4qPBYsa0zPt3sIsj9?=
 =?us-ascii?Q?PHR0CRZ2BLWRSVAkTcNu1GXwu/r7/YIgB2DzaIVMq2YGB48N57B7wSo0Xu+G?=
 =?us-ascii?Q?3dkVOknNkn7G9xiWnZ+Zn9fkjuzdkX/YxtuPHzxfFiH+WjR6rDblWZmuD9q+?=
 =?us-ascii?Q?3N3AUOJ/4fdx6s2ZDRGZseR91j6TjHfvWV2r2nSUmpz4Jcuwb2ZPf66+hK0N?=
 =?us-ascii?Q?5kFgfr367JgncZ4Uv3u12bJRS8zXlh3q8t1Y0WDSccQ0FKfp//mEJBDgFzXR?=
 =?us-ascii?Q?06X/6udy0Mad9Wh7GpknyG7942CEUFdYxzvNkHMbZL91+nw45Q/Vlxjn2qr6?=
 =?us-ascii?Q?Yw2mLhy1dGN6ehz0GYB13YQiBsD+jdYuJmAOgbaRvrjmE+fkWbcI9+BkYgd5?=
 =?us-ascii?Q?zjmwA8fvdne1Grv+dL/3fkjKagNsGhQKZlVolc+ZNfvY8iIgtSce1z7DWfeg?=
 =?us-ascii?Q?yATEFf+5x1IKP2obraeP/vr/xAPWZjDf+KaQqmSRYnVvmHvsG+3J2c3I2ogD?=
 =?us-ascii?Q?lU4TNxaSF3YdtRvgutTykyhBNv9vsCyU64C/6gLKzf51xkMBrEc9tyU5DB9R?=
 =?us-ascii?Q?/aEqZm1Xb8eqclygx1BR8HAO6/xmaU5BxhfYO+pRRTTtr/43or0gryTJkEch?=
 =?us-ascii?Q?mWIuOWF9jwwU3yfILigUh4tp9JkCkwsC8f1nO4yHNadIRCg5I9r6NO4KLB9Y?=
 =?us-ascii?Q?awd1Up7EVZmbcWW/Gb8BXX6/70+BUrMDZKo91eaZeYWjBbVM96a092CwL5kb?=
 =?us-ascii?Q?0YytGNLN7GW1PXVPXUq4YgkJcBE1kVMgLQInlyasRM5B5JnPHiH7u2E8NNG0?=
 =?us-ascii?Q?FlPGJqyJ4PHtu1hs+oirSgj2kOrQA86P+VNeO1RyOxNYNAzFQKUlCX74W6VU?=
 =?us-ascii?Q?HT2VmOrflNwDzjp2TjztGcV3PKF/Fy2QR8nDiyisS4MuGVMJx38wjtCkdaDD?=
 =?us-ascii?Q?5dsRLDItQukeLlZBG1nUV74PMmqMwJ3jVGzGnhKdhZi7N3zierpd?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1EF3829D06E97C4195967FA091F2B21D@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36444bdf-c3ad-4573-9d4c-08da3ceab622
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2022 18:33:20.1457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xzMFa8XgesUMXDuyUCONm/L8+72hoeZ4VZQLXQnEWAo5QBriYLYpsEl9c2bnZMkvd3o8QRwGXB2/vII11bXLkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2508
X-Proofpoint-GUID: -da3WAH4wPkYwhqXLL0Lq8AyO1uAi0o7
X-Proofpoint-ORIG-GUID: -da3WAH4wPkYwhqXLL0Lq8AyO1uAi0o7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-23_07,2022-05-23_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> On May 23, 2022, at 11:18 AM, Jens Axboe <axboe@kernel.dk> wrote:
> 
> On 5/23/22 12:11 PM, Song Liu wrote:
>> Hi Jens, 
>> 
>> Please consider pulling the following changes for md-next on top of your 
>> for-5.19/drivers branch. The major changes are:
>> 
>>  - Remove uses of bdevname, by Christoph Hellwig;
>>  - Bug fixes by Guoqing Jiang, and Xiao Ni. 
> 
> Grmbl, why are these sent in so late?? I spot checked a few and they are
> ~11 days old since you said you applied them. It seems like I have to
> bring this up every merge window, but changes should be sent in AT LEAST
> a week in advance so they can get some linux-next soak at least.
> 
> I'll pull them and then do _another_ pull request in this merge window,
> but they will sit for a week or so before going any further.

I am sorry for the trouble. There isn't particular reason to delay these. 
I will get future patches in sooner. 

Song

