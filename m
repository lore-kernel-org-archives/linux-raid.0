Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B940ECAAD8
	for <linux-raid@archiver.kernel.org>; Thu, 22 Sep 2022 00:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiIVAkj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Sep 2022 20:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiIVAke (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Sep 2022 20:40:34 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4436C80F75
        for <linux-raid@vger.kernel.org>; Wed, 21 Sep 2022 17:40:33 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28LKgSsr025516
        for <linux-raid@vger.kernel.org>; Wed, 21 Sep 2022 17:40:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=AZCaU4T0FSRfMorPRoPQc0Gqi8Br9lWanrSRbzwbZjk=;
 b=GdCU23HhmuLlhW6TtpMtxPKdrfLoxfO+GX1Z5gtX8D912BSZoYHYjhvjDLEPNGmCn8fg
 6IbfiXaIO280WQt4I4LgHUf0L5ahkc/KQHT/EmTqge3UOMrT53j4YWM+VgNIPMcyhOvD
 938qJa9rQTPqCiea1EgCQx/mXSTwcn3whEo= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jqbxbe6eb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Wed, 21 Sep 2022 17:40:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TIUMipqIkpYSqCW6DVxd0xUFa6exUl72ZN6hl8SUOuvyoGcnyhbzNH8Mn9tE8asZ0n9yuuQv1znsUy94EMhAv5+BwAV2g2nLBl7t38OQ1jjxjeHrUZS4Fp/6K2j+9k5fBVYKpMj7gM7ukooicKC2vWTfmkI045DPcz7nBtce+6GBpIbV/FWPRXKrzrpI1NGcb+vKhzMDz693N1d3867jzGw9EIVH9a2uFjBGa1r4TpoS6dOSgOsRZAvkk1VQ07YY0jhGY03gJW2K1/VtFC2ZkcPAkacwfFT/4OFtdedIqhMSEgKH0sFCPDy0xtXMiNKGXM7cK94mVcl28MzjXdd3Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AZCaU4T0FSRfMorPRoPQc0Gqi8Br9lWanrSRbzwbZjk=;
 b=ViY/mO/uDrHD9I9M+znewXQ67N1Jm2NjTZV+j/CGeb8f3e9J6cj77fBSNt/yAtlR2ZnPOj2Acaif8RtslCZE7+N910CEUwCSWhOC/dwyPFmpy4F0dk48yxaK/wmZlU++o/zaYFX8DM/VnTAtC7MT2pqV5EC1rNgziQ2jGy/Myr2ZctL5oviqmNPi/WMDPZ0BPIw7U8Sp6Lbcp924bOD07qob5Vyp421gqXdVKXDhRqNz7B/rcJi2th9ykgz248cPu2LLZFmPMTLAmOLR1Ec838tse8Sy598yWCma2gvPkwryTK4z9OjDR62R7crh2slEfbgaVNS0NurWC5xUmay9yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BN7PR15MB2483.namprd15.prod.outlook.com (2603:10b6:406:87::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 00:40:29 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::d70d:8cce:bb1:e537]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::d70d:8cce:bb1:e537%7]) with mapi id 15.20.5654.017; Thu, 22 Sep 2022
 00:40:29 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Logan Gunthorpe <logang@deltatee.com>
CC:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>,
        David Sloan <david.sloan@eideticom.com>,
        Yu Kuai <yukuai3@huawei.com>,
        Mateusz Grzonka <mateusz.grzonka@intel.com>,
        Saurabh Sengar <ssengar@linux.microsoft.com>,
        XU pengfei <xupengfei@nfschina.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Zhou nan <zhounan@nfschina.com>
Subject: Re: [GIT PULL] md-next 20220921
Thread-Topic: [GIT PULL] md-next 20220921
Thread-Index: AQHYzgG71ILx67fnv06BBuh3ElEZ163qeY+AgAASvgCAAA+CAA==
Date:   Thu, 22 Sep 2022 00:40:29 +0000
Message-ID: <2633E2B7-A522-4FD7-B8DE-CF6631CBAF8B@fb.com>
References: <9C523D34-6134-4F86-A357-5F306AC3DD07@fb.com>
 <b347b8e9-d136-3430-5be0-b4b14d067dc4@deltatee.com>
 <80560b23-c124-c8ce-d66b-a7afe5b7fa41@deltatee.com>
In-Reply-To: <80560b23-c124-c8ce-d66b-a7afe5b7fa41@deltatee.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|BN7PR15MB2483:EE_
x-ms-office365-filtering-correlation-id: b4f8b0fb-b177-4955-4fba-08da9c330c96
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 25OrBur0U3hATQvxwqIjz/5kCANCgdwf6wo0idsKzKcuG8fVZA8rqnJsfVhwMhra9LjbgJbttJN6jMOdTwcf3WyIQ05sxFv4TdgUWLTp/2XJRrflSHttJsvxmYOJNRKFk6bISbC8NsZoOeBpiu/sGiMc12ow3Gn7AQRRUZjk2TICPy7h1l2aa+RHABnlWRso5JSrzSEvijVktLsi9P7LAuPipyCiQ47aR/VhLtdqTn3HjeCgPdYnIWxQoaakByxHyo3+SAZtAVOAqGVlwa6dh447lR3PmSMhsGSHmoKWiFrNxImqP1NGyep9E4xyat+JYrPBWg9ZiHSt8G3bJWzGa7++oUhRWrP4mazyZ6MlawotnPC78QjgbzIQ9aRQMZI6Hr+NlDArLVSU8tZSqHeRZA+FdwJSO0hHxmrj3SXeB1SnR16p89oWHAkQzreQY5bB/6S5gCpsZLzVBivoRrX09M11TunHk5BHHAfFpWunZnu/FhKVtC86R8U2kZe9geiGpiDQqs/ueDdRX2KdKCwkxqjkwtBWP7BAFt6gCKc+NtErmdpGi7XTyPZcqnHYZQO2q//Avn+IdGucLie5TpVgvaBj4Rs9PkxPb8V9TnWYHC56v/p3M0ipVAm3JQV/hg4srh/cE9J2alLqUKJTCOC4wW5ZuiDgVaOCSR7bNBtdJfWmYEvC9lmM9S6zPnUgaRBX1IA40/86ZDONbzPrzBofF14SOSFN2uHY3ppbcGTYEUPuVGXwJmp/mSwFSsTCPF80uMvbZ6b08dohAPd8fMn9uwyZZ7q6wlakRikrmJmFDfk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(376002)(39860400002)(346002)(396003)(451199015)(8676002)(36756003)(71200400001)(6486002)(33656002)(8936002)(38070700005)(38100700002)(186003)(7416002)(2616005)(83380400001)(122000001)(6506007)(41300700001)(478600001)(316002)(6512007)(86362001)(54906003)(6916009)(53546011)(76116006)(4326008)(64756008)(5660300002)(66556008)(66946007)(66476007)(91956017)(2906002)(66446008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yKPiB4iynHJO+TO45uYh3UD9sXs4EFjMkqCGVTkuul67gNmGcke9iYj4zdpb?=
 =?us-ascii?Q?UKLb7mfe6UoKMs6GrxqXJ1HX66dtR6hzAGjjDYJVe5tqKETZdJkhmRh1RGZD?=
 =?us-ascii?Q?b8GEpbYflbl4k+R7kvxKUBFYsJwuM2ow5TrXsSgDASPm7YhNH42AiAgYndli?=
 =?us-ascii?Q?nZgONgXi7WYNgrGSC+WWMLMjB+ZWQbEvFo3sAPxR3gzmjhMxbBntnThea9cN?=
 =?us-ascii?Q?gMptfn8UD+PsDzru3grmBobgKcYlB/bYHSDq3QB6TaIJLjSEURkiz4tiz8L1?=
 =?us-ascii?Q?wBLN9xGSjRYbBX+10KTOzFhX87FkSHZo2vH3O8aQlgdO+HHHH6RUq6NKWmT/?=
 =?us-ascii?Q?laI9SIx4hnn+nHi0ScVEayvefYfhEG/Gxj9hU6eVWw4LR/7jPHp4ec7n1cJX?=
 =?us-ascii?Q?4cVgBsfthmpKPU90rDBDyv94sK9YM2W1vZhLSGWgEg6C2/5twk6DlKet8VKx?=
 =?us-ascii?Q?U7S9IXE5BvKBzE99BjkbmMH+J+ndr/R/jbdxoMnlQPZc3X2GSXbRVdUx6M3o?=
 =?us-ascii?Q?LBkmaUr3qaNBdTQo1oZUNHRHDBicZfVv1aL38H5n0mlMLxXzqPwtXXheyzNV?=
 =?us-ascii?Q?bHKPAasrU4OINhwf/sfafCWUjziWHooad9kIbU3biF3rGqdwyLQu61qJCS8E?=
 =?us-ascii?Q?EjbW+Pws/yUp747Wew8ela6jXmDLO5xiJQEyVHoG8Q2fd898r2SqpnI3NX3Y?=
 =?us-ascii?Q?e63Qnya/4qsL95nJMxZaul4yEnFCtTb8XWUh4+mlSQurhzwD6aSIv5hoIVv1?=
 =?us-ascii?Q?qgRvnJ0D7ergHYhczLflF6zr7K0HA9+rTqcJl1b28zmrClFJ2Oiz04DGnwBq?=
 =?us-ascii?Q?fx109h+1Kyoz269FbOequeyU40LIBhC1TelRs3XQyjdJPCUyi1bH4Z7V3dwe?=
 =?us-ascii?Q?nWAhAfHKJmHFr+fDqpB0YhvZDiwAUNtsxKvbWYwyG4q3d/AcEWhuL84hr4wy?=
 =?us-ascii?Q?CLSuobC7sQoR4jtD6NDB71GcVnprrbQU4rRFdMTyKkDhKzsGnfUEZ9wTMmyV?=
 =?us-ascii?Q?PgyQr3a/dqK9wd6SwJwAJXMzcRBNsYaMTWAgHq2tZImyAdkpYOo4u6w4FwLS?=
 =?us-ascii?Q?OxVVQvEeGM/W1bsW5P7XFrdq1pyarn512NrEQ0Wey6vce6QnL1zy9vsyiV4f?=
 =?us-ascii?Q?UWg/L6KBR9ZoFYH08fkqPhmRnLZ5fj+C+T7rxxS6ZXFfRv5S9mTuPFnKvzHM?=
 =?us-ascii?Q?VUHyiCGb79NtOQV1goasAnm9VUJY5c4iRTEkj4MSSMWZ9vWu2yxoHQLPZCol?=
 =?us-ascii?Q?B8WvL1rHlOK5IvYLeM5Zdzm3bP2PxIx5NMAPt4VBO0EniyXGjFQZtu/xBfTT?=
 =?us-ascii?Q?ByCXkOoQ/tsxsWFyM9pWBTWUkuvAMPQo6XebREp1T+6idxILzdgYfMfr9kJl?=
 =?us-ascii?Q?36EhTL48x40+uiBiSpthJ8Edk1sm+i2mku+JCdSm6WpwYidpty7bXvPe26ew?=
 =?us-ascii?Q?GFU9q7aGhOmNdna7SEQHQC1Up0eCgNk9K17hIuFmv/dkzXQPYGBflhp3G/pQ?=
 =?us-ascii?Q?HNjlcqnDpmDIkOUMfaQ3XS5lEgwdN3Dbkubr0oW776e/gdi4R/HY3t50rwGS?=
 =?us-ascii?Q?kI2b/4IPPFHaObEPK81ha4iOTZ6wdmsWieRMMvvXLJAb0jVVES0qyyLK7kzv?=
 =?us-ascii?Q?SBh06AFC3dFWOC8+6fisjPw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4E85CE1498F3E642A8E4BC8F5C895DB6@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4f8b0fb-b177-4955-4fba-08da9c330c96
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 00:40:29.4320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hb6b2wH80nQj/O4WvMj78idlZCheCKNx4GkDVMADJPGaLSx/25Jhv3xzpnhO/0VYR9tUeliRvZtVTQv1TqRxlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2483
X-Proofpoint-GUID: IrianmpG_h57u20-KULCAhlW_GVv4ELA
X-Proofpoint-ORIG-GUID: IrianmpG_h57u20-KULCAhlW_GVv4ELA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_13,2022-09-20_02,2022-06-22_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Hi Logan, 

> On Sep 21, 2022, at 4:44 PM, Logan Gunthorpe <logang@deltatee.com> wrote:
> 
> On 2022-09-21 16:37, Logan Gunthorpe wrote:
>> 
>> 
>> On 2022-09-21 15:33, Song Liu wrote:
>>> Hi Jens, 
>>> 
>>> Please consider pulling the following changes for md-next on top of your
>>> for-6.1/block branch (for-6.1/drivers branch doesn't exist yet). 
>>> 
>>> The major changes are:
>>> 
>>> 1. Various raid5 fix and clean up, by Logan Gunthorpe and David Sloan.
>>> 2. Raid10 performance optimization, by Yu Kuai. 
>>> 3. Generate CHANGE uevents for md device, by Mateusz Grzonka. 
>> 
>> I may have hit a bug with my tests on the latest md-next branch. Still
>> trying to hit it again. The last tests I ran for several days with some
>> patches on the previous md-next branch, but I didn't have Mateusz's
>> changes, and it also looks like the branch was rebased today so it could
>> be caused by either of those things. I'll let you know when I know more.
> 
> Yes, ok, I've found two separate issues and both are fixed by reverting
> 
>   21023a82bff7 ("md: generate CHANGE uevents for md device")
> 
> I suggest we drop that patch for this cycle so we can sort them out.
> 
> The issues are:
> 
> 1) The concrete issue comes when running mdadm test 01r1fail. I get the
> kernel bugs at the end of this email. It seems we cannot call
> kobject_uevent() in at least one of the contexts that md_new_event() is
> called in because it sleeps in a critical section.
> 
> 2) With our custom test suite that creates and destroys arrays, adds and
> removes disks, and runs data through them repeatedly, I randomly start
> seeing these warnings:
> 
>   mdadm: Fail to create md0 when using
> /sys/module/md_mod/parameters/new_array, fallback to creation via node
> 
> And then very occasionally get that warning paired with this error:
> 
>   mdadm: unexpected failure opening /dev/md0
> 
> Which stops the test because it fails to create an array. I also see a
> lot of the same bugs as below so it may be related.

Thanks for testing and debugging these issues. I also see issue 1). 

Jens, please ignore this pull request. I will send v2 later. 

Song





