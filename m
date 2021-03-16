Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A23D1C433E0
	for <linux-raid@archiver.kernel.org>; Tue, 16 Mar 2021 06:57:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67C3D65245
	for <linux-raid@archiver.kernel.org>; Tue, 16 Mar 2021 06:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbhCPG4m (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 16 Mar 2021 02:56:42 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46680 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233424AbhCPG4Y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 16 Mar 2021 02:56:24 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G6hqWA020030;
        Mon, 15 Mar 2021 23:56:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=kxbtQrRbyQpFet1GIADRmEa6i3Cm+k2wTG5TVn88F/Q=;
 b=YJQ9JaTypOiuo2QYiptUCge/l+zyqp8HAI+TykyE+1vpDemJ13qwb2opS0PDhbSA6vrQ
 vbg3D2+jZ7wi56bFBTgzmmgxqy2r3BHChSDNVhZB3nXKXIMZ5tD06ICp3NkfZJRifxOH
 Yg3LTXSSg0bwNUx03LJ7jtWhceqtAj4JlDg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 379ee5hypw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 15 Mar 2021 23:56:20 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 15 Mar 2021 23:56:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FAXiMTBwp5dFgM4EJgsAWaHLs75mIwHRxZUpjC6eZ75Q5Nd6KIpIkRo7VaHnNaX6YKvtXERZpBxU71+/AKTdqMqbMNChF+tqy2v27icVSBJvMGY8j2RgNsErFN/e2AElp2gKqO+sdPkCqWJYS0YWTGsFoKRgTajIg0tfgDyR53/VPuAtMT7vQk0S9CwbIrZ23mxfA2qBoOEdXQHEfPUlLHiTArDxg22wMYYaFbta8SGrpiz5EaeDeIqqCEpHvy1QVzzLEDhTs9uRQdBElyc/qLut9s4JnV1RSHgMkZb+zuVBdPrwlEZm0WY6NWKmd3NEf7ivihvWoKh9jcRWUWRH+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=URgSVRJlglTQ5w6I7N/M7iu5VI56xE3i6/IXbz/pJuk=;
 b=AMaIkLNbobHhRoFxvsJONP/qAU0nisfRfJI/Jav1Bx1igo/VKANhu7ldVRHXoWOc61IquSQIvjc/sTDQTS7kYGGvfQ22o5AMXvVgdqD4HVdrWyn++w2tf0S8SXUrPVBREKxdUBg03Fcn5XVIRM9lZapa09B4ivle4utpFgoREpJVfkNUHfvq1H8Kfo0dUGfAcGpo0SHAT/qzOKLEMDmPeCQepVej9IUGwFp+q4DbvMGHjxoAjor0q5nZI816/eRjJBiJ3q90t5PUWQ7OM6qITCbPzz674m6n/SoZzKnAV5z+KyBmUEfLAdV6UbfbC2gHkxQ/G1Lqz23MjePdNijvYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3047.namprd15.prod.outlook.com (2603:10b6:a03:f8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Tue, 16 Mar
 2021 06:56:17 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60%4]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 06:56:17 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Xiao Ni <xni@redhat.com>
CC:     kernel test robot <lkp@intel.com>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [song-md:md-next 5/6] drivers/md/raid10.c:1526:8-27:
 atomic_dec_and_test variation before object free at line 1532.
Thread-Topic: [song-md:md-next 5/6] drivers/md/raid10.c:1526:8-27:
 atomic_dec_and_test variation before object free at line 1532.
Thread-Index: AQHXGfuK2W1go3YmQkKMWdIExWVduqqF5FeAgABKnQA=
Date:   Tue, 16 Mar 2021 06:56:17 +0000
Message-ID: <3EE962E0-8054-4460-8EEB-0338EE5C1940@fb.com>
References: <202103160841.GSRvizC4-lkp@intel.com>
 <dda31d3a-3424-6eb3-4f36-e715affc7015@redhat.com>
In-Reply-To: <dda31d3a-3424-6eb3-4f36-e715affc7015@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:17f0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 675f6e66-1060-4aeb-6e80-08d8e84898db
x-ms-traffictypediagnostic: BYAPR15MB3047:
x-microsoft-antispam-prvs: <BYAPR15MB304742522857D47A5C23E10DB36B9@BYAPR15MB3047.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:446;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qEW8QtQNUEgxLPms9x+SqAlssAtdiiVN9jkCJjcMCAX0RZTfyuLBL2mo3l5+NNX3wy3i76w8ctljvWGrB90zcZwv0rOWd/86KKd0veuJQvQ/wFC00/GB6cotAXxIKmAYBqyaWfeT4n5Rl5UHJrzec4MEibJaW7dz9bbBiYm8u8NDArPLe7E3wzDKqojN9hcshFzr0RfsaT2Uv7rJTRFd8ESyKwlP/1055PUzAOpqgAX+xhUBYUjKSY7BxQeEHsJqwOsKq+47drwmN6AmnqkcJJA0mqwpOXwPNdczZIzHrUtbtScPsHPylqXmKqGxD8pXWDoyr1F9pcfdK4BkMZecwHj2urKZoUTnq1pdxo7ovmQ+IMXOOBecuMMBql2w2Zc5I1OV1dGwP5iw89lHLJDrLdP1hpyfx5ph0iBc5sPjIqhXgrx7+kAPebWSTEGAbQDQftW2abYEKxO+34MIcCYzmD10hxOqbATCGR/nFPfK8nRQbOJj2drESC2jw4J7h/jTHkqWEUL112Ua2hBXxFN2cgLZZAFgEePzVy8byZ6FEhOazqww5ISsAkW5CMHR6CGuj2pJGiCJ+4ypr1zpmpbyz1+0hogCVNV83s00KmEFIkZ60cV8foFJHSX19mTF9XDqyeSd9YmL9ZI3NWYFT61lvb/DVcAmt/rsTGy6pXHU2SVUuMyInqi8lcFBN3w4iuIy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(396003)(39860400002)(366004)(6916009)(966005)(8676002)(71200400001)(2906002)(316002)(6506007)(54906003)(478600001)(6512007)(186003)(36756003)(86362001)(76116006)(83380400001)(66556008)(2616005)(33656002)(64756008)(5660300002)(8936002)(53546011)(66946007)(4326008)(66446008)(91956017)(6486002)(66476007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?7rMKuTcbn/3abYTtupMFpSyYtem1AMJ/WSLlRDiUO/1j0tT9RxQGvHeJLA1s?=
 =?us-ascii?Q?YbbvKF5sKIoxk9KYG21vygo7peSEOrgp0ggpDDs81u6IqtfE66BVzlOZ5VWa?=
 =?us-ascii?Q?TxYIlfVEngchHvs2e63Sa7mKFZEKGHwMonq8J3hgPXEITJf1otDceIpgQNkJ?=
 =?us-ascii?Q?DQSRwdtNV2L16cd4P6xsTnH29vl94groMDdG5iuFbDMzoEgVdSHm4Fxwug7T?=
 =?us-ascii?Q?JU41scmSE0w5myBh8KovkgSijMgIFE16EfK78IuBPLvV2w2TjAbD/IkPuIzC?=
 =?us-ascii?Q?TuS1UtTPTYS16AjXe6MKGK4MyNZQ2NxaFOdlmwGqigBH26NIVUlAEYcKm6Hs?=
 =?us-ascii?Q?x4exD967w2zY3X3BhKRE7pZYL4oDhCwI4W9jUVaaNd4eiXde5dZfpdwFpwe9?=
 =?us-ascii?Q?/4S6e7rvYH4qS/GDOUV0afATC5ZNh5RZxXztd5xrA4cZr1OoyoDlBD+2IqXE?=
 =?us-ascii?Q?IQ/wrLW8pC9GCz60AEEPPZXDZ1yZEYycbTUe6EzUviU30KAD7qFT46F/aEMX?=
 =?us-ascii?Q?lzvpU0f+/fOh0BdcI5j6enGRmZTnk75yEH4TbtqRmTA/KgPv3hNAW9aAXUsN?=
 =?us-ascii?Q?GRfUlEljNRpfeoJdMHcAwQQQVe5BKpPZUjZLZHwNcxUfbBT5zhZBuDxMah6X?=
 =?us-ascii?Q?1MrVPVxJfRYyI8iEtxODCHJ+YGj9PiPdlsl6m/CJzNhGl7FqlzE0vtXlYKss?=
 =?us-ascii?Q?BLGPnSC1L8uQwfn/njNMEDDBNz/mQcd23Lpn9FDrvEM8J40gNCkSFy4KszAS?=
 =?us-ascii?Q?mRsjMEjyrO1OgjWg6jgN6/vw59IT6jLeJV7RXgQJqt+h9Lb/R8FAc2CUowu9?=
 =?us-ascii?Q?DnT3hL/SUb4jy5FALi9N30E3hs9WPg4UxHsEkBLg1UbFgdrozTuRFhZL7HN+?=
 =?us-ascii?Q?D8J/LJQB98GWKub1LZk8eLSVDHIzVCFCb3Od+j/rxwuoAd57g3bs69UZAEL0?=
 =?us-ascii?Q?5+hRUyPpNHvxTuN0pyUfC4OpM2ohmv5sKuc6xSo4/JrEx3rByZXuRGZ+yyya?=
 =?us-ascii?Q?ByY9LKp9cTg3kpd9WqNx8M6N7KU1qpgtQIMXXNVyUl/vLl+GVdWiHubWW2wt?=
 =?us-ascii?Q?Ey3UqRgOsBpE45qJkJVa+j/zze0hG1wutPMQAY/Sr4hi10scStAPquZfo9F0?=
 =?us-ascii?Q?peGqEyEHF61c9fmhwjpx33aR1MKIQGMUp3xb6+ZLBobmF53Neh6WBFsJyZiq?=
 =?us-ascii?Q?oAtg1qmIEcBs9GUE3snM9gGEwpmhMsCeQKExbRu+t2gomOiqEHzQITnd2ENx?=
 =?us-ascii?Q?qpOxS45mhTpCi4/vs+STuUcwTQEUib3wddAedn+NhhriWLonniufe+ZaMTbB?=
 =?us-ascii?Q?urDaX37AFCZbTF5fq89oYY8v4Wr54hWZjt8eMR29s1LzTifwdowRouOP3WfD?=
 =?us-ascii?Q?KxIyKJ0=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A46F69251CF49E429859F593D7DB9E95@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 675f6e66-1060-4aeb-6e80-08d8e84898db
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 06:56:17.1182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ANZpNX8Fau70VgCM5QFtPplcMio++xZZfkWAlKpwkEO3pgxp8GKjvrxqPnoRAHNONVJQDZwTJr9Zao/Sfo8X4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3047
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-15_15:2021-03-15,2021-03-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 impostorscore=0 mlxlogscore=883 mlxscore=0 phishscore=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160045
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> On Mar 15, 2021, at 7:29 PM, Xiao Ni <xni@redhat.com> wrote:
>=20
> Hi all
>=20
> The atomic_t r10_bio->remaining starts at 1 in raid10_handle_discard. It =
means
> raid10_handle_discard uses it and sets it to 1. So in fact it starts at 0=
 and sets to 1
> when it's used at first time. Then r10_bio->remaining is added by atomic_=
inc per usage.
>=20
> It decrements the value when leaving raid10_handle_discard and in every c=
allback function.
> So the count of r10_bio->remaining in this patch is right.
>=20
> Regards
> Xiao

It does look like a false alarm, as we set r10bio to first_r10bio after
the free.=20

Thanks,
Song

>=20
> On 03/16/2021 08:29 AM, kernel test robot wrote:
>> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
>> head:   49c4d345c81f149a29b3db6e521e5191e55f02b6
>> commit: f3cf8c2b2caf6ae77b7c786218d3b060faef63a6 [5/6] md/raid10: improv=
e discard request for far layout
>> config: x86_64-allyesconfig (attached as .config)
>> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
>>=20
>> If you fix the issue, kindly add following tag as appropriate
>> Reported-by: kernel test robot <lkp@intel.com>
>>=20
>>=20
>> "coccinelle warnings: (new ones prefixed by >>)"
>>>> drivers/md/raid10.c:1526:8-27: atomic_dec_and_test variation before ob=
ject free at line 1532.
>>    drivers/md/raid10.c:1526:8-27: atomic_dec_and_test variation before o=
bject free at line 1537.
>>=20
>> vim +1526 drivers/md/raid10.c
>>=20
>>   1520=09
>>   1521	static void raid_end_discard_bio(struct r10bio *r10bio)
>>   1522	{
>>   1523		struct r10conf *conf =3D r10bio->mddev->private;
>>   1524		struct r10bio *first_r10bio;
>>   1525=09
>>> 1526		while (atomic_dec_and_test(&r10bio->remaining)) {
>>   1527=09
>>   1528			allow_barrier(conf);
>>   1529=09
>>   1530			if (!test_bit(R10BIO_Discard, &r10bio->state)) {
>>   1531				first_r10bio =3D (struct r10bio *)r10bio->master_bio;
>>> 1532				free_r10bio(r10bio);
>>   1533				r10bio =3D first_r10bio;
>>   1534			} else {
>>   1535				md_write_end(r10bio->mddev);
>>   1536				bio_endio(r10bio->master_bio);
>>   1537				free_r10bio(r10bio);
>>   1538				break;
>>   1539			}
>>   1540		}
>>   1541	}
>>   1542=09
>>=20
>> ---
>> 0-DAY CI Kernel Test Service, Intel Corporation
>> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

