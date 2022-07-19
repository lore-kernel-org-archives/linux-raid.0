Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0062CC43334
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 19:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiGSTK7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 15:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiGSTK6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 15:10:58 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80F8958E
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 12:10:57 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26JI5DtH031349
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 12:10:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=kqaZ+gEXf0QiX7CbgbmSt9A1CKwglWtdvl++tYRcFbg=;
 b=ILE9sQ7Z8YVQ6C6HaboD36CnG4ga8CaLgw4LzaAjoclHMQ5YKS78ClVlh7ghQp0hlskq
 +VAQ/pyR6sITteTLO5u66Ldv1rKzSunDqZ3f0LlxjwLJZhPqEqL/H9/MNGgqtBJCbhfK
 cqHwk7yf+2DoKWc3Ft1fCt6X+gg5e+A8gi0= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hdyj69fj1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 12:10:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IjFmVh22PP5xt2ZvlfEoaPdPZwLAu3cATUUgetWbJyYsCtrEi8cG9dOes4NHmzbwtcy9Eb2G1Wjp64e7SPnFBevqC2eCn32wH1WD9V4wyb/4w5xC95LcmYlR7dRwYhZyf6oExz7Y3m8IEhfb1tCBIogNfcekO4dyJFd0n3QhGEL7wICikgjT2pvTiEX9063QIMVejxw7beztTh26T2plLBQ+Nl9U2VOI2zOsdbT2LwWP4TPPgFQldWH4LzJ6JrC7aq6mH27UzI+eqbAqx8AyAOaLqnaoVg4g175PuQ081IGcQuhmT33RvmFpxSxxiYbQLAqsz3kwrrwvhl1764yirA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kqaZ+gEXf0QiX7CbgbmSt9A1CKwglWtdvl++tYRcFbg=;
 b=Uj93BtI51DxTk9HwTp2caR4LrqFjVeg+6LRtv23ebOoxhw+GC6Ts+D4Yo4E7P4Zj/ytRKgn0p7ejU313/01II/laXMe/Wgkg2vJIsv+w4+Z+iZHkkkEklgwKrWWxbf7jC8jYRo+/aX0YZASx2gvufvVLgeXfs8UaP6aUVUWQP+/rPFgTz4cgh8LTDScERmwMxwpxWG8E+W+YPcZYsrbswE2iAXljrZ5YpYcDhBqJhmFMyo9/2pRtcEQXkVR3XRypROJZP1/oqb4B0Ho0tXUanH0pEftCRjzqods8G4v8b3RG/gIC/PCq4WanIDXSWBaUe2tk3Lmd+HLbpUPreDnqww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BN8PR15MB2851.namprd15.prod.outlook.com (2603:10b6:408:82::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.24; Tue, 19 Jul
 2022 19:10:53 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 19:10:53 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     linux-raid <linux-raid@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [GIT PULL] md-next 20220719
Thread-Topic: [GIT PULL] md-next 20220719
Thread-Index: AQHYm59itXAinBFwR027LgYV2rHJOa2GCCmAgAAHHwA=
Date:   Tue, 19 Jul 2022 19:10:53 +0000
Message-ID: <7C4DD0FE-6C05-4BF4-9A20-8C6A012B6658@fb.com>
References: <5553FDCD-7628-4A40-A228-8E1BEF6FFFA1@fb.com>
 <57876115-7e41-f11e-3cca-738235cd68db@kernel.dk>
In-Reply-To: <57876115-7e41-f11e-3cca-738235cd68db@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b50a989-f618-4b85-b858-08da69ba66ab
x-ms-traffictypediagnostic: BN8PR15MB2851:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X10vj8w6uVGS9nDN2AECnlzWdWN3kAkKCZEKakJKquv8IKdynWN4aSCotOedxJnF4EQEhHE+HCmQfUjza/LFWt/SLKMQ39GBE2GpTDxKb1IDBy2zA1ntQU3ESa0yUT9d9Zm0dzMJVCE2Jmp72BtXikeJ6DQTUdPrxeY+nh97y7iwCriBbtpHcf/yZghU7i7niHmzCCuyNooqHHVlwea6xEUtJg+kpLFD0bHxR6xgspZ3idPZGz91RDY9TIHPpuXy7ewVtb42RVh3kkS8pGv/dehY0z5CmJbicnS0NoYxigMah5Yww6FCD9FNHX/rp/rt44cJhSp0IFmuAHnfn+SqP0UDmuv/9YmuuMMClYteqYcUUAnm93l9/sCsmd8ujf255lxNdHD3+bM2TuoyBGWgZ7Kcg6riwQIpAkqvINx/3EBVBjDs0DYCfL+6zsBRGkdQgSXZ4oS01WFko4IWsJY6sUBu6GcXzpziwVfUh2bs8dlhvKlyamb5ASu9d14qTpj48BD8Qdg1tx0FQ6cma828bFFsTC+68ZNC/1PFh1XmI9A8FKlUt4fpTzfDB3F0wtBPGKJu47zAyWTd4a/qw/02Jxdan21HHD3Q3Nmpf7w159ul9rRrv/YOMt/3M0yXoVSnehnw2bNycYW723mOU9UlhaSFeyibCaUmnXIC7LKVwzg87F7tHt9YU9t4pfIOoNSCKHXzAa/26Fx5mFPijGnbhTkqrOJyUddpYiuFTjjXoePY7c09DBYwMLaDLQrwVKL6gXM4lKpE6FJ4/0LmnxmxUADC4F/MyyUvknCn98Qb/qxEnJynM3jkXE1vaT6Fv92yvewLau58Uj/R5SBPS7OWVQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(186003)(2906002)(36756003)(33656002)(38100700002)(53546011)(6512007)(2616005)(83380400001)(86362001)(38070700005)(6506007)(54906003)(122000001)(66946007)(6916009)(316002)(91956017)(4744005)(71200400001)(6486002)(5660300002)(41300700001)(76116006)(478600001)(4326008)(66556008)(64756008)(8676002)(8936002)(66446008)(66476007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?B6mDi+PKPHXC+Z9gtIPbjQTgj7bJ230/N6MwUIoiHIazXfWM92CnpxBWdxO+?=
 =?us-ascii?Q?Wh6czAe+FHjIwQcd4UCKQelayCMsIi2cIKklcYFKlaT5UpxU9Lu/hJjPUygC?=
 =?us-ascii?Q?cqtkSoJT+jSCg7+LNpBOK+KemgJIy5YAKYPpguUTThBEg2YCW/3SCuEthEWP?=
 =?us-ascii?Q?SlUcLn356AKOkw2z2ghaFtZE4OZt8Jcl9mRtMAPJx6dCqDFeCUgI9tHzXICA?=
 =?us-ascii?Q?FlrbIp9mLEY1kKvgfUUWHDUil4JsdDECfSg8TShLAtFOJRD1OS7vaB+CHgVy?=
 =?us-ascii?Q?xC/l4AplE4f48jHJZcE2XPrSrSH+txAIKXtVKnYD/rBvU4vppg8ufpY8SZKt?=
 =?us-ascii?Q?eAL/i6B9D/Y7cam/i1GiE7gUZJFuVVcGW/cnzX9mgq7Ivf+jo3296ALUIei6?=
 =?us-ascii?Q?VBbhVnEqYYlQXAVmMqpquNP9Ptbz6qVOXPIVEaAugVyLql7KhilZHot/qq4b?=
 =?us-ascii?Q?zx2QMVKJw4ixToRwxf7i2jS4/m3a+xr3ty3cqkOPL/ipueaPdv2CIGpRqIRH?=
 =?us-ascii?Q?YUfu7Q/gp8jBGn0PMaiVRE+Jldud26gJNDtst1WLyfZqfYYUvMvF6wZGycKf?=
 =?us-ascii?Q?3aEqYAhdoAThdyy0giaSFWtStFdwbVxClbY/Mv6EWwaf0q/rgWocGNhUOJhc?=
 =?us-ascii?Q?EAZUDiCCkrsgQl0GDF4ogo/9xYwJVNOH4SyOLw5Cl4EUeTX5iYFijxv6577P?=
 =?us-ascii?Q?yz8Qw28oTkmT6Nk4+uKEjabipfayzooiHOdcZA6nHOEYlDx0Px6rKolASHRl?=
 =?us-ascii?Q?X7o+T/UxHSzImsyGzo/W9GLzn5d5SKUquO5TtD4SzMMF1cEvF+fQZWyjIEtd?=
 =?us-ascii?Q?nZd3KwR/l6lNzgPHsk/Yldt6OQEb8UKUrKVltob+dYpekNirM+6rcWPrNz+Y?=
 =?us-ascii?Q?EnqKI61PSQsxL8tYa0URqwugGZUl0egwBipFP6iHb4a4er4LgDWXoKXWj39z?=
 =?us-ascii?Q?uaCe+VFzuMmPbB9AYRXsQXrb7S0PYZAH7PiPsJcCRcC+cJoKootScYPKH7Uk?=
 =?us-ascii?Q?QVQ9JjM/ObotuYjonsVlCeXkwwHagvXFL/PmZOGHtFIYH+y5TY4Rtu3LHNxv?=
 =?us-ascii?Q?wTKIQQ7bB/rG85C8Q6VnIO0HYnwZFk9vIAB2lXsfyNapLm4silynN0SXDlAj?=
 =?us-ascii?Q?f+1BPya2gJ6tvoQ4UWMn3gAqZhUW9EzBR/3sz7uM0k8QEE82+13srsSe5lc6?=
 =?us-ascii?Q?iJv+/1zaG6uIgSxZO2stBR0HNAFMqLF3v6cI5fzNz8uld2L8CHD5O8Am0Hf5?=
 =?us-ascii?Q?OH9rTSjfX8UWeAPF2mSdsI2O9BJgciPkgcNk9ymzqb/HNIgiTv6Dp1D/d6BY?=
 =?us-ascii?Q?UMzVL8cV3dzep8ImUh7EmSO4Qkc0u2juhodBht9+xFznjbQVhXYR/Q27Xn6H?=
 =?us-ascii?Q?l5UdsjwtGA87L2EuJyWtDKCfxEZWAzHucVACvGAYUfT862UNbn9GAogg/gAV?=
 =?us-ascii?Q?KhoA16/eqEdbgy/qqfXPGnLS/AixoLLYyeBBTHj43CwQz/lQAoUWHhLc+Mp4?=
 =?us-ascii?Q?Hcut+GUpmJen2tHJf2z7Tg+BFHtxNJ+ih/Ckhy0McGhcD6C+8/hHXl1nvWw9?=
 =?us-ascii?Q?JpVsKAFFAv2G5Kkwfc7Q+YpTRFDPyGXNBVgJ6y6P2MtYzVSV9/nObTsdKcum?=
 =?us-ascii?Q?t5zp5NEh1lyoiYxCovdZfg4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <67F85AF6D6C2E84493C7114F4CAB6D6A@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b50a989-f618-4b85-b858-08da69ba66ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2022 19:10:53.3397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1sNBKkjbR2PPMrV6pndipACXaNo5pkvB+JG9WrREQ8Ylwz4yoas23zu89KVZ1GMnCYhXUSHi2oJHbCOQLg98MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2851
X-Proofpoint-GUID: AJ5YiQtJDMKhy6Vm000jD70omi55EjFH
X-Proofpoint-ORIG-GUID: AJ5YiQtJDMKhy6Vm000jD70omi55EjFH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-19_07,2022-07-19_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> On Jul 19, 2022, at 11:45 AM, Jens Axboe <axboe@kernel.dk> wrote:
> 
> On 7/19/22 12:43 PM, Song Liu wrote:
>> Hi Jens, 
>> 
>> Please consider pulling the following changes on top of your for-5.20/drivers
>> branch. The major changes are:
>> 1. Fix md disk_name lifetime problems, by Christoph Hellwig;
>> 2. Convert prepare_to_wait() to wait_woken() api, by Logan Gunthorpe;
>> 3. Fix sectors_to_do bitmap issue, by Logan Gunthorpe. 
> 
> This has worse conflicts, it looks like. And not particularly trivial.
> Do you have a merge resolution?

Hmm... it was a clean merge on top of Linus' tree, but got conflicts with
linux-next. I guess the conflict is from other changes in the block tree?

> 
> We might want to consider doing a special branch for this...

Yeah, I can port each patch on top of the special branch. To make sure they
all work. 

Thanks,
Song

