Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DBD5C4338F
	for <linux-raid@archiver.kernel.org>; Tue, 10 Aug 2021 05:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65CCF60F38
	for <linux-raid@archiver.kernel.org>; Tue, 10 Aug 2021 05:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237485AbhHJFLW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 10 Aug 2021 01:11:22 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53494 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234999AbhHJFLV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 10 Aug 2021 01:11:21 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 17A5ASBP005832;
        Mon, 9 Aug 2021 22:10:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=at6uysaR9Lkt8KvUpXR5VZEe85MWsd+HMe2qejhgCq0=;
 b=gT43pTveysZCe4aPABOPSQibSKRgmxFJlX6IQTbOvtjXazYOEQnwTz4goCAo/2lEdP/j
 dNhzFyqTqXNF/BqS5pImUCAOJDVdnN5C8dDYv0Vb2AGsVO1m99rzJMAqM2qyomjC5UBA
 jLtTo5YXWXqlg8SxECGVrNLmejF38f11L2I= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3ab6mmv33u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 09 Aug 2021 22:10:57 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 9 Aug 2021 22:10:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YAHKH0Mj1QoXqWV+fNahDhvrw3+6Lm3G4F73VN1m5yFXnWkwPARx4qexYAKDgEqxsVhbsqmnaRjfd4NHfAVQjQ5X+aAkoj2csAtpcApe0mJctCKPaaSmsqIt4ns9EBHxdL2EaHYQbaMHd/7BzisAeGmrRRtqqaopHZmzYXQHHRSKKGECJbHaHrARf0h7/HElQZsvqMZYyJ2cFaEENMx3WBfGMN7TzU1ts1o78HVaETFUBW8F+QWpyE4Xws8e/MnxqBZJWVg0WY18D3EUBq20KW7MT1yTg2mY0Ks6h/CUwV5GL/pyvkcrNDIKaXoi/o50bb5jdnr8VIHeKO7nblegtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=at6uysaR9Lkt8KvUpXR5VZEe85MWsd+HMe2qejhgCq0=;
 b=fUojNNcJYm7RtNDXJ6YLKkROsGJKBZBelHISyKMpXObJmjs9R9U0QAj4UKLkv3YkuBS8vxf27wttZYRUOxQNsy3ZRlMFhLlLTJKxFLfCDyuvZ5waIUR3kFOjbjzs3pH2E7e7rEIu607acCNv8IgQQaSoqw9bEO85sZeCVc04GyHznkzOaJdVF+QB+bo0zy8vadrCj6r/mJeparq1nV4gSpqXa/cCTXs8+cjBtUnqEN8EaHmthhntWuWJPdd1cfr7Aio8GHIH5BwXd31txKx67HGyI1dgsypHUrTApZhRpbw2uVKIk6sr3IcZ2Mb1pp9Uk/t6vtmN49aOdFosq8d8bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5077.namprd15.prod.outlook.com (2603:10b6:806:1dc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 10 Aug
 2021 05:10:55 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1959:3036:1185:a610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1959:3036:1185:a610%4]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 05:10:55 +0000
From:   Song Liu <songliubraving@fb.com>
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
CC:     linux-raid <linux-raid@vger.kernel.org>
Subject: Re: [GIT PULL] md-fixes 20210804
Thread-Topic: [GIT PULL] md-fixes 20210804
Thread-Index: AQHXiXpCZfTBhg08vEK53vVsuB6fHatj4pCAgAdBhwCAARUkAA==
Date:   Tue, 10 Aug 2021 05:10:55 +0000
Message-ID: <54C9427A-ADEA-4627-B435-FFF5841E6296@fb.com>
References: <2D64F5A2-3D1B-4D27-BEA7-81B03B30D212@fb.com>
 <145aaf29-535b-a0b5-3c6d-25b036df6dbb@kernel.dk>
 <66c72f4f-7fa0-7491-e4ea-8d8a82483aaa@linux.intel.com>
In-Reply-To: <66c72f4f-7fa0-7491-e4ea-8d8a82483aaa@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3446ce77-d20d-402f-8ef2-08d95bbd3b74
x-ms-traffictypediagnostic: SA1PR15MB5077:
x-microsoft-antispam-prvs: <SA1PR15MB5077A2F9D51715BC652ED4C8B3F79@SA1PR15MB5077.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZR3wIY6vF1wt/vfBw+3kXQvXI5w1HlcyO1tCrMtfwTvK7Ar6eLKUZ9osGWPg13tuHAPhIijYbo41IQhF87+gK+qIaElBL96pl1m6xI4mJ+pA+i7c1dpmUhfsQSxifdyLOcI4Ynf5qAT3/8U52oJeQ3SXWkXLYFv04Zuw71TdI2hsXkIlGaxLlmd5jGiV1EyZjY74DSE5m5YOATr/Qnq3KxF7/dmQZsH3Dqd8IsRO2C4wWHSioAmObXQcQiDZjDr5l6eP2G0ujPNEvePx+nCFwXYvzZS4y3lPnpEi+gppdxCp71sOjE6sKERI/Od8Zw6d7spGvssB222AD5wNHvy2gIdJzeXdY4krzo0rztE+xRp2+1fWZ8YfKU9jIT6vUmgCpKU0xCgH9GUDdJSpaPF07hLwLlpfLff84VyBL4VeYv4WaSRAdR5aoE5Ubuew2LR9dH4kQvqC49dVGedpfAgqpQ0RzcmMrEaCfH3isC2jqI9RcEdes+izuA9fEv2o8Z00COVgIgXzTJqVZtiZVBQJnqTyZgYv74gK/6DYtOiJaT2y80IaOhWaUu0R+rvg6Tjs6tOfoZofaL270TzVGJsjFqqHLbMvffXkukkbutM7p4vLI191Msf6KLPgZu5IzHR5V9RudNUnd/LVg/tjm4N1sgariL/iCjbAJRg0NCCQy9kg2+Bgo7KhpVf2OCdSeDZsdIpOeRatCHtyrYQrXtmq+ybtVppQAk1Q4HydCuIStiU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(4326008)(86362001)(66476007)(6512007)(186003)(2906002)(4744005)(64756008)(83380400001)(91956017)(38070700005)(66556008)(66446008)(71200400001)(76116006)(66946007)(38100700002)(2616005)(6916009)(33656002)(53546011)(5660300002)(6486002)(8676002)(122000001)(316002)(508600001)(8936002)(6506007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ytDkPdNT2aBgyE/QGmH51Wwi+zzUF++n6yplNPrIuZGZA6anFpU1IqhwzqCf?=
 =?us-ascii?Q?/udzQ3X3s8vH9lIZpJ216LLoYh0SP5Vu4J4PHZFV9KyeGpU2SCHk6zIdPQeD?=
 =?us-ascii?Q?LrK+jWI8nwmLXSRkAkSZiJxHjThGOnNRuyhnzakaevTxiK5k5O7l0osZpKmD?=
 =?us-ascii?Q?dkkszFCfnXyjWFhAtnOG/zlkay94tmTbYeq4mR6HXx/4W2KsX8ezcC6YxcLX?=
 =?us-ascii?Q?3ANUoFDEcAbIxu5Pr2aK1DgT9PQUvjfjSiAbB+7o0ZR2+Kb3y7pBLQ/mgCFB?=
 =?us-ascii?Q?qDeb5Hy1IFyN39TT025iiwj0ru1JQUG0aDRBeyH16ZIh8aIKP+o7n5qsX9Vb?=
 =?us-ascii?Q?4x4SuoMmpJ70vBZTMWwqThamCmIlPxdVzaciRrvrigHI8pUl72MaMymb+r8l?=
 =?us-ascii?Q?ArpCCr7Jm8Q0O80UEKf5okq26qPv+FnXF/3HigksgVj4X4AfIZ92sPc8Kwzb?=
 =?us-ascii?Q?hdgg6B+7euy/brtnYFNsJ53t/QaKgDZLkXYVOo8dFpoX44jJwVQgELY3LXqH?=
 =?us-ascii?Q?fE0F7cDE+77jBBzz7Rbu/MAj+doIgsKgvHJUgcsJH8BqdFTC0/r8XuiTMxHr?=
 =?us-ascii?Q?x/6xJeYfTvZrvPQEeouo+UqSV87FXIfG/D2NGS534nWTzNK74rBxnqsRvC5J?=
 =?us-ascii?Q?vHf6UF5sCvu32I7PO/pzR5qdYkXrOf5JP71A4lkd8Kp5Z0Tyd/d2s+tplDBl?=
 =?us-ascii?Q?3p4TkL1il9+MOaMmKV3xenOpd1VcjJh2SOhPEblyxK10PHr43fqyVJGkwgeq?=
 =?us-ascii?Q?IoJjwUHqZWYwKXcatjXl+E8qD8Q+OwFQzvOk9RwUwsm/s/kVnTb/QqtaTk37?=
 =?us-ascii?Q?aRIRs0LSL8//qr4rRQ/c3qNisewC/8RIIce1O2cGTJS6j+WkgK4q/IuYIQsa?=
 =?us-ascii?Q?W4RaeNPulZ/IK+iAA4Ckr1iAqsTPPM2J//lutrQY34WASEmgUV4YE6jDgNsQ?=
 =?us-ascii?Q?qQbLXA0HKApMd/ladg2s8r8B1sq+nzUWgpgGReUVChm4pk0FwSq010YQgaeR?=
 =?us-ascii?Q?RoHw87Xb9RtDObf+nNqe1bswXUkP55TH2/q2uCuo3awaWZ8gNyOoabdfNWLX?=
 =?us-ascii?Q?EKoLZFeQqd6dAac8V4gnwpXWL0R10Ge3DlqAZVMHuJAm9um8fjoSn9qFp448?=
 =?us-ascii?Q?/kaVAQr4xlOy00P3uH5FXgG8FKEdML4dctNs0LhrHUEHJ9b60YhPA3XJ6lTz?=
 =?us-ascii?Q?WYOND/flcNWWmzNil1EFLK08oq3jBOgMbvPi9IiyGZaeTtzeYqyPFwd5ppJr?=
 =?us-ascii?Q?50B4lVU3H+NsY9T1Fda0ULhSimZdojDFHE/CnzGXwjlOgl3Md3YlY8BtLRfV?=
 =?us-ascii?Q?amjeNDN3SuEq1FZhuRf/GH73CCycPqybu87ylW4qr4PqTCmuFv9X0E0sN+9E?=
 =?us-ascii?Q?weBLPQ8=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BA5212148E88D14C95C3DD520D8D3A44@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3446ce77-d20d-402f-8ef2-08d95bbd3b74
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2021 05:10:55.3310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CtLEkfwN0KZKU/dr1xInTHl2ZjXLNSWN+Hq98b2shAIL9vcHFw4psjVUsaXNNjppqaZZjwrTX+deUsAYqqpmqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5077
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: M8C-xNH7j9lMRruGDZEbtcPIfTecYARw
X-Proofpoint-ORIG-GUID: M8C-xNH7j9lMRruGDZEbtcPIfTecYARw
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-10_01:2021-08-06,2021-08-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1011 impostorscore=0 suspectscore=0 lowpriorityscore=0 mlxscore=0
 adultscore=0 priorityscore=1501 spamscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108100033
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Mariusz,

> On Aug 9, 2021, at 5:38 AM, Tkaczyk, Mariusz <mariusz.tkaczyk@linux.intel=
.com> wrote:
>=20
> On 04.08.2021 23:50, Jens Axboe wrote:
>> On 8/4/21 3:47 PM, Song Liu wrote:
>>> Hi Jens,
>>>=20
>>> Please consider pulling the following fix on top of your for-5.14/block=
> branch.
>=20
> Hi Song,
>=20
> Could you describe idea behind of "md-next" and "md-fixes" branches?
> I'm asking because we are running regression on "md-next", but since
> development has been divided into two separate branches I probably
> need to change current approach.

Sure. md-next branch is for feature development. Patches applied to=20
md-next will go through linux-next before merging into upstream.=20
md-fixes branch is for bug fixes. Patches applied to md-fixes will
not go through linux-next.=20

Does this answer your question?=20

Thanks,
Song=
