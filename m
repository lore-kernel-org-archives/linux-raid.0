Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B10BEE81810
	for <linux-raid@archiver.kernel.org>; Fri, 29 Sep 2023 12:12:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbjI2MMd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 29 Sep 2023 08:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbjI2MMc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 29 Sep 2023 08:12:32 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 581291B5
        for <linux-raid@vger.kernel.org>; Fri, 29 Sep 2023 05:12:30 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38SNO5cg003413
        for <linux-raid@vger.kernel.org>; Fri, 29 Sep 2023 05:12:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : mime-version; s=s2048-2021-q4;
 bh=L1OlkBRaA+VAbiqUVV9yfgd2UhA9Ngp9F8vlw9gDo3s=;
 b=RP08j/vwXGR+yWFsDiOcY3NcMVmVaAOEZ/kLMLIFHNgKGufQDGBrxSs/p9o4WZ6my2TD
 PT64ovJVPOZj1PAqZY2u6pcuC2QaiKAkDQK5PEvJA6UxR6n4IIl20ii9pYihZohpT4iV
 LEY/FNgjwad3zX9q0sryNEobYGKEdfdMJfiGVBsmneyza/Qt0C7U8UrHEwTN5hl2n9hI
 8xW/pSD6TfevSFeA1T9ZfxZNH5lcwzINdnrmve6Piu/J+KTGGOhBoOpNChTuHgxk4tvr
 cBHvdm9kXy413sELnBoxtNHK+DvI8LbII/WrCcht9wRF/0GxFRkd9bA7gsOCLt+9h14s yQ== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3tdk4ged75-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Fri, 29 Sep 2023 05:12:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I7bPpfOj3M8O0iWI3R31wdameaFKNjM0S+Y0VCWS2kGlAGMYipxYeOuLtp755bPAeYibiAqAFKB700TXdxCs8KokwKKdvosQAkKPkJmpT4k92tVrpsS/eqcYEr4oP4gg5VC7d+Rk7ecxlEenTyjAPFZUV4TakvV+O4zDTdM6aV01sgEpwPOnzkFeaEJ43GDpyFwTMEqBJY/xf9o4L9V3yD3sjZxrwUy/HvExeJbGyfkl4G/zA1CanPDFth0CfpfNTXwKCZSd+X5+Pe+jdLD3PLPNgb+LJ3bnoXqnUNnbzgZoofT0sWsZsQFqKpakld+sJI9+5OKDZfbOtYwnHiWfoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L1OlkBRaA+VAbiqUVV9yfgd2UhA9Ngp9F8vlw9gDo3s=;
 b=CQ3yfKfAm0TX2Stosk4XrLr09SA9YPhEsIe53dsEkkUuzeynDUDax1NYSFIYi4LwstRFj812DlFhFCegWMVXejbzbR6Bg9WIIK/bCs7hQW+bYxwyeXQSc7bplEbGG5aQTc71VoNvqBdj624xo103TNQ9HqySx/wJYlh2UGySh7RXxfAQbkYhshnYpZBvXVhsm/eAlE5fERfwSsOcvtP7NqOYCgMxJBsOavkxKVRzB6c88q1kJeoGHJHN92B8FarLlGFNEWuBw4KQoFGRKZcijAljcqx6joGK/DTQiC6kkr/DkemQpIsIGKgwDOKD+FgSANwp3bA3R57moxNRb0ywlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SJ2PR15MB5833.namprd15.prod.outlook.com (2603:10b6:a03:4f6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.24; Fri, 29 Sep
 2023 12:12:27 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e0e7:7606:7fef:f9de]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e0e7:7606:7fef:f9de%5]) with mapi id 15.20.6838.027; Fri, 29 Sep 2023
 12:12:27 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     Song Liu <songliubraving@meta.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Justin Stitt <justinstitt@google.com>,
        Yu Kuai <yukuai3@huawei.com>, Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [GIT PULL] md-next 2023-09-28
Thread-Topic: [GIT PULL] md-next 2023-09-28
Thread-Index: AQHZ8k6Yz5y62WGUOUGdago1tEebGLAxUHqAgABnSAA=
Date:   Fri, 29 Sep 2023 12:12:27 +0000
Message-ID: <69B42599-C78A-457F-81A4-DCA643FC32C9@fb.com>
References: <956CEF49-A326-4F68-BCB3-350C4BF3BAA8@fb.com>
 <f945f9bb-68bc-41b5-977c-64a1f2d0e016@kernel.dk>
In-Reply-To: <f945f9bb-68bc-41b5-977c-64a1f2d0e016@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.700.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SJ2PR15MB5833:EE_
x-ms-office365-filtering-correlation-id: 4ad12dd2-68f9-4085-e8ad-08dbc0e558af
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ge5X6IdCY/v9prxk+m5R5MEKPbiXkWWOSi1uCQ2bOegp9eJvktEeLqZX0OaWS2Mx9aY7fhJP37Lz2vbs3GQhixzbvSHjponPIIM3RROLByfEj8gmWRm9B2RV1m3A1PJjLi35VH0WMyblHPW6vlOjBc0/lmi1GjIaxaO2u+tARDp2wINtrVh1zCwIpLLo0jYXzNTlYwxiO8j1/SBM/b7bIeEmatSI3ttmyE2oXu7DlVy6n8LlK+PivVLtX/0F96VRlF8GrTTz6ACqqA+sVNb680/swrRPpM5nyP35zM9bmybynvH105BKv8usSaADzC9Xyf8dReGO+NgNyUVvx1FV6UZszhNR2uilgoGwLDQ5kkOV6NRbBSRiAcI650DErYpzj8N95/kPqYaSLaV4B0zxX7i7jSEmUh2gdlEDjt+BEJS5Ow05BP/4jqWtDUwGb8XvdcG3oUfgLNaecKnUc+p2PwkoqfPX5PJ5n4ijgtf8m5wPzmABykhA8szOACgeUGeEqfoMx6hrGIPulkdevahVkr8LGhHJqna9o1gptlmJjkkh7z6oS3jS/UkOk9374OkJYlFvPUbulIlaORd51BIBrj99aOYDadF+sN56SncmRoo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(346002)(136003)(366004)(376002)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(316002)(64756008)(66946007)(66556008)(66476007)(66446008)(76116006)(6512007)(6916009)(54906003)(8676002)(8936002)(4326008)(41300700001)(36756003)(83380400001)(6486002)(966005)(478600001)(53546011)(6506007)(71200400001)(122000001)(86362001)(38070700005)(38100700002)(9686003)(33656002)(91956017)(2906002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+FRtA8wFc1lhjFqedhtnUrko0ItUiQkzEfCT/HrLNqoLsFj6GULb6lPCm/Gg?=
 =?us-ascii?Q?MrFCjNS5F0hj+i95UaqfvY2+niDSqhIWboxsb7Hv+9G3XJ0r9GS2DZ2EsN4H?=
 =?us-ascii?Q?mQesLXJ1+rb0CAQOZG+8v8NojJhTt4KPNo38qE9dmxIvf+m4pXgx4OrzX0nx?=
 =?us-ascii?Q?LYw2GEZga81J48to4P3KIk6RT05rQuqDGjcjdi+W2yXHFLX0GR5KOwpmZZIr?=
 =?us-ascii?Q?0OQR9iJK1q3Skct4sTWYK4zza0jdCpm3WCEWx7IjARunQreKo6vkiYHLzBSb?=
 =?us-ascii?Q?R8eJl3iCu5bmAkMrsRoOHIgOo+CkALhSPso8mvFxAlJanQCDWeDWh7QnyhYb?=
 =?us-ascii?Q?vZHT0J/EdFW+G1r94N6qY/XipwlajcZ4NgoLCQA3Rq5ba1LJXN38cxRkv8+0?=
 =?us-ascii?Q?rDSYzuVTh04aSgD0vzm/duIrCB/5+ce9dwfmZDYbTud1UEvoeiWYXWMEHOQH?=
 =?us-ascii?Q?/jjyqYBWg1oq+2Bx5+fBjJNOB/ba/elaRz42Gg7lBqaWoradaEvBOZUG+C0Q?=
 =?us-ascii?Q?AChVjogi1RSywg8WNngCfAJFh+XJOmxPpIaFDkha9UG4kfC9R1FNiJun/dOQ?=
 =?us-ascii?Q?Qz6vlvbVHFVuhPM0oY0hgMSuIVbrEvm4WOxQ6b/qPAl35q0yFFEZ6PKMxhg6?=
 =?us-ascii?Q?UmMnt9z1K8HUqZtX1+onbbMb042jWhEqf3DWeg13uveY+/VUU+8AR3H6dYAH?=
 =?us-ascii?Q?4knRdfp8cRDEeZQ/GQpztbjZDaBdqcLANgHwYw0cw/OKGxRCBLxJxYeE55MG?=
 =?us-ascii?Q?z3kW4LYiyDsjXHKlgEDz9+vNlUp0O5qQM1d7SdshFaTiHRYn1qv229o9F9v4?=
 =?us-ascii?Q?P28scH40OpTPQCXatOZxWbPdjeGkrH+0NgOC8xVRTrYpgpLm0eYZQPuQCz9k?=
 =?us-ascii?Q?X/9YAIgxK2gUGdF5X+vcDvcBrR+9Gv4ug/ozjYmJ73UGQ45XxxIuNfJlxaFX?=
 =?us-ascii?Q?TRExFNAV0guRx5goq5nMWzUSFXw+9p8iRbL1/SEQgiBwCdy7phiSpH/HNp6n?=
 =?us-ascii?Q?afc6GsrDixetha6mxw8k5qp0sn4CjMjQpClEQ4YrC22zqy58vYUr4SRuuep0?=
 =?us-ascii?Q?FpAfevz6urHDXzPHuqsb7BGCEVWkZhIB0g5xMFA/B+Niij+okwIE5fEnuI6h?=
 =?us-ascii?Q?ybCqBnZmoBvX47tB7FiQZy06gWxknw28XZ62ktvpoUy3axmpECc3Ur3kAkWe?=
 =?us-ascii?Q?lvoS9uk+n0KO/m+L2I9xk4VHfspMMxG8Um/J4adrAw/+l1CvXrj7mkXGf8cI?=
 =?us-ascii?Q?JUuo+7lvHzeMyd8cM0NS1RoWaNEhOcbW0n9baUnPAhgvHCmSmMgs3GmdcGAZ?=
 =?us-ascii?Q?PXnQbq4JXb17WdsJCaGjG+D98tFMmJ07v1IEpL6p0ijaNflJkHJMh55zPIrg?=
 =?us-ascii?Q?gzo3JDv6AuwOuCp3wv/vyBPb1SbrGkwgYuOQRu3k3fuq+WvuIAoBliAIdp0z?=
 =?us-ascii?Q?wymC2sXg2lM7CHf2FapP5NcruY2yWAcH2a87jLXTT3pF9h/0x6LegLf+bKsj?=
 =?us-ascii?Q?u0q4q1Zzg7cQrBbHX+B91cH70ZHCnoiRAumesW649mNa4X2/ZK7VHyQh4Xvk?=
 =?us-ascii?Q?8qrS64P2JIQeXs1Vul2bWhByiCJYrPhj2oqbIC6LSSHbu6Vt+8oJz4R4sQLC?=
 =?us-ascii?Q?jJzuy8pwIje1S5ILbTGKpDU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4CD1C756D1ACD44E96814562F37D85A5@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ad12dd2-68f9-4085-e8ad-08dbc0e558af
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2023 12:12:27.0660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8GDAwyxz2UxurGS/CEWL/y8s2mqLIBitBAXunAB1/HAeVOdOCpVZKzo2/T3kzi5obtASniPycm9Ad8vLhRqR3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR15MB5833
X-Proofpoint-GUID: otQ_SNJbrJvR3UcJjlT-KMiob-uSzLmY
X-Proofpoint-ORIG-GUID: otQ_SNJbrJvR3UcJjlT-KMiob-uSzLmY
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-29_10,2023-09-28_03,2023-05-22_02
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> On Sep 28, 2023, at 11:02 PM, Jens Axboe <axboe@kernel.dk> wrote:
> 
> On 9/28/23 2:58 PM, Song Liu wrote:
>> Hi Jens, 
>> 
>> Please consider pulling the following changes for md-next on top of your
>> for-6.7/block branch. 
>> 
>> Major changes in these patches are:
>> 
>> 1. Make rdev add/remove independent from daemon thread, by Yu Kuai;
>> 2. Refactor code around quiesce() and mddev_suspend(), by Yu Kuai.
> 
> Changes looks fine to me, but this patch:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?h=md-next&id=b71fe4ac7531d67e6fc8c287cbcb2b176aa93833
> 
> is referencing a commit that doesn't exist:
> 
> "After commit 4d27e927344a ("md: don't quiesce in mddev_suspend()"),"
> 
> which I think should be:
> 
> b39f35ebe86d ("md: don't quiesce in mddev_suspend()")
> 
> where is this other sha from?

The other sha was from a previous md-next that got rebased later. 
I guess Kuai didn't catch it because he had the old sha in his 
local git cache. I should have caught it, but missed it because 
it was not behind a Fixed tag (still my fault). 

I recently improved my process to only do rebase when necessary 
(I used to rebase too often). Hopefully this will prevent sha 
mismatch in the future. However, to fix this one, I guess I have 
no options but rebase the branch? I will fix it later today and 
resend the pull request. 

I am really sorry for having the same issue again. Thanks for 
catching it. 

Song
