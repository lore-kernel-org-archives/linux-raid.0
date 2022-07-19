Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E80C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 01:05:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233338AbiGSBFP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 21:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiGSBFO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 21:05:14 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8366251
        for <linux-raid@vger.kernel.org>; Mon, 18 Jul 2022 18:05:13 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IGhvjH030269
        for <linux-raid@vger.kernel.org>; Mon, 18 Jul 2022 18:05:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=YacHONfsV6oEC6eVVXElzSyYKQg58Is0IU6vD8gwoNM=;
 b=Hrsr2sffRcODuYmft9U8Slr+WqPeMqMABKuPmU68+LKm6U9EUUpxk4X+WzMArs94Tj8A
 LLWkM3SSUb6/5tFqb71mLqcoXVHGBN/mz51CgF7fx9kkAnrLftBfPq2HvpKs6OSWEMTB
 Pb5KyQTjsr8kUephgAUMld1kGdK4Wgk5fN4= 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2048.outbound.protection.outlook.com [104.47.74.48])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hcs5kr06u-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Mon, 18 Jul 2022 18:05:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vb4ubMIlnFGZwd+hF0Y6LqvGhnHjxQSMKhHla8kAxTsf63V6BvQE7z95fEAONEjhu8QbiGfrK9miYCXtUv5CfzRNgz1O3dB/EbMwEb/6x/BT4EVXZPLN8fts1tVglwZx8HdsWRAOKgMwzv8eEUrPHMUSQ/nzJ5tPIakWInVnt/TV6A+Nk6JLUm9abA8CiSW4n4Z+4RXY4uFZHfcu+Tmucb6KB95+IC5p9y6sbPyWoinQ6grOAGzRd1Kaz8KEJeYFoui2V7amws2PXJgfKVJboDelue6pUr+r9ZPJl43fzxevnfIrjul/9cWKMFHO8xarhcebWDJK/YHX+N96gyYa/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YacHONfsV6oEC6eVVXElzSyYKQg58Is0IU6vD8gwoNM=;
 b=FSOZ6sXTYgAJwG6mivHTZfhKLdtPZURPHnwJnUGJJC7x/nqiD715nSkPuepcqXN9CUvGvL6R+vtWktjhRu/XaO+iz3KHVWBqlfjAdngPgkqwD/kJG7iQoMIUiCknsYbqLZ/ogWkPh1BEQadxIfPITeDXa2tLO2YqGB9qalh+wIq+34GeeBOpFwqJpQOZD2VoqXyxa2ImBQq3vNRMJqblayX7zeo85lJZjKm3nMyP5sXkcpEIBHplCJicar9Gkq0f3wbZXycP4aOI6NhJ+EjX7FvW7JkUmueXJG7szYzWq2xwbxoQ4ao/e4Kto/8s8uFqiYanLWBK+IUuBG/tX6ON3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by PH0PR15MB4461.namprd15.prod.outlook.com (2603:10b6:510:82::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 01:05:09 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 01:05:09 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Logan Gunthorpe <logang@deltatee.com>,
        "liuyun01@kylinos.cn" <liuyun01@kylinos.cn>
Subject: Re: [GIT PULL] md-next 20220718
Thread-Topic: [GIT PULL] md-next 20220718
Thread-Index: AQHYmvAzIK7JseahcE6/NKyv9ZqlfK2E4UwA
Date:   Tue, 19 Jul 2022 01:05:09 +0000
Message-ID: <799F776B-142E-453D-9F8E-595105249E83@fb.com>
References: <4122CEAB-991E-4A4D-90FD-C48325935876@fb.com>
In-Reply-To: <4122CEAB-991E-4A4D-90FD-C48325935876@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 154ebfd4-de23-4b2f-82f0-08da6922ba05
x-ms-traffictypediagnostic: PH0PR15MB4461:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bQUFZHkxRFh9huBJKUaNuGcB0mV+ZW4l54UKn53C+OlFdpSpJ/aLkY0De9v9PsxEhqqWaAoJ6AsZL2+hXvjUNk9aUHKjMqj353/T/hMbuSAM7UYGz4qF8HMs6ZF1/8xeQsGkW1NxCEQIGeMI6rdoHdwlETCqHQoWJhxPSMDEoPVGB3oXdqMiPW/ZxSrBZGJg1RRao/uwSNEonvL3/eE4Uz2nj2006bpnWmDfYEHYgK4/OPDTVooZYjvM/55ZpAQ4wAp8eGomhidyV4cBEAFm/RAxtwuZcn3laeH+kjLB5wnQ2EBz6kHOgdBVqD9EqTa7Zj8ckynXduwvtueBMlg1yJVM5gzk1+jWn8Zgqiag5SnTh3seohs67ftzRJhjeKKRoLF+hKwDdQ2dD0JGuOW2T0/sTLg6jNCoiSaTvhTcz0fa3IyY0sOolCZSlBw8oiRZ8bi9u+dhDumo3VACISCZCz/7xr/kMQnV9j+93ri5V0P8S8tlnVJgnHr5yQgptE3VV6dsKzsC9AIKRw0ehop3mbYKFyXS0tjc0heleDWCacruLfS3SOgk0CF/U29MKkO1oAL9NCy1MWs/99YI7iWPWLTM2R49bSaqGwh5nPjC50SFLtoLrlNslouBYsfWq9S9j1TbuV6bIEUmq211TLLhTqB5hm3+qNoisFrpvRahVh6PeRstnnjQiE0EuYHEJ/XnUgzTImhwlDaDICFYL2NcbM3R+jQrlECeTZXU5FQVUK3quyEYnkwivwZG4WLbwBL4f8517m1DcMhlnU6+vQdcv/oz2j/m4tLMHNJR9RDuaRhdTcc6Eo8qdgoR39PRAV7L2FukEDglbQgp6JDjF2uMq8naVmkmJ1ieWNEd7SDlnjo95LjpAlDmzHqnmvN5WTu/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(39860400002)(366004)(396003)(136003)(8936002)(5660300002)(86362001)(2906002)(33656002)(76116006)(66946007)(54906003)(110136005)(4326008)(66446008)(66476007)(316002)(36756003)(64756008)(91956017)(66556008)(8676002)(6512007)(6506007)(2616005)(6486002)(478600001)(71200400001)(41300700001)(966005)(122000001)(186003)(53546011)(38100700002)(38070700005)(83380400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wy8GOYlhAos8SEJRv5XBE9PUTB71tQJwtD+Mw8Loatk3FB1hrfWG8+abK+yF?=
 =?us-ascii?Q?dUGJigrhBkMfpbHVK0sm/20lI0NwqiEkI6/P3Pajwj5br8KmvFyt55OSOaxj?=
 =?us-ascii?Q?okldAbmplQI2FEguH51YKSozlBzr88PaFzc4AfTCw7T+A79aiSPAJdIBPoHk?=
 =?us-ascii?Q?VNlGAP0IHajLKJpFyWxrrNUX8U6zyv+8W70vYqmuVIHGjxuXgCQWOUt65wEV?=
 =?us-ascii?Q?TDRNlrH8fLzNBoqJ/pqT3EodO42XMWXNIckUH6Ki9xkWqUOohFYMkQvNzlZZ?=
 =?us-ascii?Q?mzdoR77K8M+EVeUE5BoKemWgDFGZdk8a1YBq/WEQUp02IG2KWcVAxLvAKdxI?=
 =?us-ascii?Q?C9COIdJ29cLM+JkJ5B3nhOcAbxIkaVgLDQZ0dZ/qriygkQ4KH74mVMWrJb9t?=
 =?us-ascii?Q?48z0TgllsmHP2/Dz9UykMnNxMb+BVnmxvw9aPZfOMNryDuNGeXHFWFFqqjr8?=
 =?us-ascii?Q?7jTstM5rcpisrcYgNKS9fsGpuB+VS06h7uSRFvSJJ1ACIvOcnX4AsOSyTX3f?=
 =?us-ascii?Q?sSbwakVI00SMlEUQzLw8rARR5bPEIMFxMrWhpRYClF66IMHEILK4Z3/4mr3y?=
 =?us-ascii?Q?sjDn1x79PNvVKuAz/9hPIj/zGugIbkOGJ98M9TvUmRaRXOF6xjLBiwn+672m?=
 =?us-ascii?Q?3A06BMwnPODEPKjZOhefxWwtzxG6Gz5Yv6uR64rx3+MJSW423bdH9+xUEDWg?=
 =?us-ascii?Q?NzL/lCyW1r58dzI+jiC0FUSlUC1zaueHatWrB81h0U/2tPwRtDi5ygX0WlGl?=
 =?us-ascii?Q?zT5X17r3cndx6F4GLp5kkeMWkqgs6sugu9yyIGGWXEa/5vfI1/8bTb1iCxW7?=
 =?us-ascii?Q?puEbLsJWoE/Lu32Q5VHq6hKgBogZd77SPMyRmXAi3FkTcqv0lN4ka8I/bt/3?=
 =?us-ascii?Q?93bKZ0mqzDVmvyT1BKUDqJWjk7EnIBRM1/Zo+fV+hg8F3+8vw2Dr42fOuBuP?=
 =?us-ascii?Q?G3AVvK+Ah6sgide73ZzP/5oKOIFt4ohpFmnCRORxmR/lo1omndy9nhPO1Afe?=
 =?us-ascii?Q?kdAflD6qKQfTzYUTHaDXYQU8QhY93vlCtwYbGDafHUwIDgoxKoC/RCGu9LeT?=
 =?us-ascii?Q?SKEVr348A0ntMFXL0jee/aUF6zwY7edh5MYzlwCpqCmh3LOmrZe+ycyhNLOH?=
 =?us-ascii?Q?pkAAqC9wTfLLk5fbZwUb4tRBVzsZWFT3b087zAvH9bP10+NA2esW3XPwpN1D?=
 =?us-ascii?Q?IU5+US2mXb6cOw4hrVco5SW/u24aRXhC7Ow6JptJQZxBTfS20vWDp6tqE6x9?=
 =?us-ascii?Q?xKhhI+ttZ5nqbfxSVfEoZdbGDPKK2baFU1eVivnfqYAr9ZaxiO8GaY2aamV6?=
 =?us-ascii?Q?mmnvvNKtx8dbZmNfJaQdYmV4c4NOLRuKtrbbRipQe1zqBhe6XPC3FnRra2v9?=
 =?us-ascii?Q?lTMXXVaFndB3DBSQqzaWLLx3w5GafiP/W5i03dBhW/8NmSI0ft3ufMKxzrjt?=
 =?us-ascii?Q?OrZxkJIGOx2fTD8KSDI0y9pvqocL/ICwkiKh2AXFGIRGoEYQcnLHL/c140/e?=
 =?us-ascii?Q?Z1fWFIiQxqQaVirRpDErq5NJdRWeKBxWB3Gc4VjTNpQqyYNxx+dAGYroQOc7?=
 =?us-ascii?Q?rtOjTm3G0BPil+0fAryiK2yRSardihYsxk0kMAc3clcomyva9S0lQn4nozk2?=
 =?us-ascii?Q?EuPc4i1yyE9EjRo7E56JrrE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5BFB23B736726C45ABF04F31610EBA30@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 154ebfd4-de23-4b2f-82f0-08da6922ba05
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2022 01:05:09.7074
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LvoS5dZE6WvgMWpYyuz96fQf87S6F2Qsj9BTNnqlG39VXhg0MnEf5tDv32Bv/torTLOWE7oWVdEhGQWPjSTHsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4461
X-Proofpoint-GUID: uhY7-63vbKkh_OWN5UD2Rn85fM6XGxTV
X-Proofpoint-ORIG-GUID: uhY7-63vbKkh_OWN5UD2Rn85fM6XGxTV
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_22,2022-07-18_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> On Jul 18, 2022, at 2:49 PM, Song Liu <songliubraving@fb.com> wrote:
> 
> Hi Jens, 
> 
> Please consider pulling the following changes on top of your for-5.20/drivers
> branch. The major changes are:
>  1. Convert prepare_to_wait() to wait_woken() api, by Logan Gunthorpe;
>  2. Fix sectors_to_do bitmap issue, by Logan Gunthorpe. 
> 
> Thanks,
> Song
> 
> 
> The following changes since commit 8c740c6bf12dec03b6f35b19fe6c183929d0b88a:
> 
>  null_blk: fix ida error handling in null_add_dev() (2022-07-15 09:04:38 -0600)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
> 
> for you to fetch changes up to f8584a43b407dc0b7277e722a4b7fbca9f4bee44:
> 
>  raid5: fix duplicate checks for rdev->saved_raid_disk (2022-07-18 14:33:58 -0700)
> 
> ----------------------------------------------------------------
> Jackie Liu (1):
>      raid5: fix duplicate checks for rdev->saved_raid_disk

Forgot to mention: 

This patch conflicts with the following commit in upstream and linux-next:

commit 617b365872a2 ("dm raid: fix KASAN warning in raid5_add_disks")

It should be straightforward to fix. 

Thanks,
Song

> 
> Logan Gunthorpe (2):
>      md/raid5: Fix sectors_to_do bitmap overflow in raid5_make_request()
>      md/raid5: Convert prepare_to_wait() to wait_woken() api
> 
> drivers/md/raid5.c | 35 ++++++++++++++++++-----------------
> 1 file changed, 18 insertions(+), 17 deletions(-)

