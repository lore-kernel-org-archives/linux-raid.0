Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C768C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 16 May 2022 18:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345230AbiEPS6n (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 May 2022 14:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235473AbiEPS6m (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 16 May 2022 14:58:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDA43EBB8
        for <linux-raid@vger.kernel.org>; Mon, 16 May 2022 11:58:39 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GHa02O017457;
        Mon, 16 May 2022 18:58:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=GaMMZTYlUZnsYJILhnG81ibUxt5/SHMDDUY7fwCgUpE=;
 b=EXyllU4gpWtUhu+qaIOdU/dmpGLys5Nmcq9R2jZNtc/EPOx1/zQdaryHr+JWAn3IKcoW
 XSeLaEG2CBDR7tnnREPyJI08szwa0MGCL6f9v9TGM91bHbPpD5P9YiDu//AG9GTrpYkp
 KORNVRAfjwbHaktHP3jskVbYlxptUpunOdkBwhei/Fi6kkx9qQkkucKhlqQ/mGgXUmy2
 KU4wzqZJf+yI0huR3PfvnFUm8l2HaVbhdeDFE2u0in2Uholy1W4EIn1nDKfzHx74gsjY
 9nHgKQj/fT3wwWREcY6Sd0T3v7zU6RxFAA2RE8/x5O6uXQlvwkSoYj4F8yxLGv6T+Tym tQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24aac6ay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 18:58:30 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24GIptV8005124;
        Mon, 16 May 2022 18:58:29 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v7rhn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 18:58:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JnoOghy+T2AIyPBdVd4UPWmN2bv3wjqrr0F4+JtnhNSpAix9fmaNuCxnZeOJyIzhAWPwu/nlrFZiUFekvY9DSwgRqjJ+nBJtXk/Xl74L63k2/LQF6lCh85kSdTnWy87AM596M2vyOHV8D4IhBUuAhvWyRY6sQqdoQ3L1uWUfCJYeW+xU0DokBiSLKHoPb3T7bj6lGxLWHg7oibzzD0OPbWay2sb8usJdhq978X6b52DxnCw0R6pus0ItqSiscWU4bgl9PiJN5xuTnVOuJYkILqdqJ1wYmA3FgxycdSlkrwswHf4PZ5KOZ6I+XLJnruLHJ++3UskPpRaedgUJCfG/mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GaMMZTYlUZnsYJILhnG81ibUxt5/SHMDDUY7fwCgUpE=;
 b=Y6Iw0cf7usofUaOrR88mjse/HBkYRfGLD6eq/G8l7Ouf5t74xbsq2oY9lB7B0LMzENYWIYHlVbVKY3l858vCsXhxUUGuEUNbNqWJnMvAfB8UQXTetZFYZo/Z8dPoECr9+jvxLvFkAPxyIxjrwbOV19le6LuRAvE0WPTAQNq1YxnMEsPOrak1gmfJPZdIrwgQk1nFkpY2meW4j+wKHDaxgwoFouX12LawYEUNVpkEow3NuKR8btuUfwmmjjKgwsHfJwlOq7/ILdaaMV1jRBcIQDcMp+99gMGgn+SHW93uVRo87O+NTsfOpou3DK5bsmxHiSXxN4TyZzXXd4l3ZUxfWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GaMMZTYlUZnsYJILhnG81ibUxt5/SHMDDUY7fwCgUpE=;
 b=lc9kyAeIg9jaN+cjZQkURYUJM3Zb+7C2UuWa5PpSUnpra/luzhxEvS87bXjR+6sdDZ23XkM3CLnTo42f0WeYkO8FxoVFyqaZXq7KcTwq9LNYokeoBpeQ2wg64YGxADdIkD+ZMxy0ombza9P8ViQ0kGXrjBmXtqIpE4k1VIdxngk=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by PH0PR10MB5563.namprd10.prod.outlook.com (2603:10b6:510:f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Mon, 16 May
 2022 18:58:27 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::ccc1:c080:5df4:f478]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::ccc1:c080:5df4:f478%3]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 18:58:27 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
CC:     Nigel Croxon <ncroxon@redhat.com>, Coly Li <colyli@suse.de>,
        Xiao Ni <xni@redhat.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: mdadm test suite improvements
Thread-Topic: mdadm test suite improvements
Thread-Index: AQHYaS6gkZIr9hi5j0WjzG+1sgOF0K0h23yA
Date:   Mon, 16 May 2022 18:58:27 +0000
Message-ID: <009F4164-44B7-4688-9976-4E3AA0185445@oracle.com>
References: <20220516160941.00004e83@linux.intel.com>
In-Reply-To: <20220516160941.00004e83@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ab1b1f6-9d3a-4834-f37a-08da376e0fd6
x-ms-traffictypediagnostic: PH0PR10MB5563:EE_
x-microsoft-antispam-prvs: <PH0PR10MB55630F3D34832967B117B059E6CF9@PH0PR10MB5563.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JrHF2t0xB4dWu40xWkF+h2lcnqKuumTZSCqDERADyi9Diq600H3lVV7y5BHDbkYxyJSotcwo8hDhTnko1f3GQm9e8wDjpyjRh9CIo8gcfJKFOyjjRmr5FrSxve936+PnL3qtZ93GTboTWjNQPjh6NgZw47qKOIchDyGjSVGaYKc8aEdWojB8yrt20tFWwcbuwsqvKOb5Lop93Nuefg0PGO2HVrTiBJf81wSRblN4rQ+QBxiOAcLUwLZgcjo3hDUURDFVLpNdjhjXzj3LSs7g7u6hqRSnf6ulfArZYpV4wnSxJ8scE+RbWEsyS58biCQfJ8urNdcDNjWpPLU0qnfKUGjl+rN1t34gJ+17fiMHuFdf93v86caqJYWUFpeuid0q35RlRLS3YsOSRFY2vfajTWJBphUm+UO2/Ny/m8595uN82hscN1Yy5cARffNgsSqzXYXB2F9jfB7H32bX21VdNN8QaEKd+uBLQJym3ygOarnvlEriw84K/GjUt3M5gPOAbJ5q4uIhkiU4Q4+78eY78evIdWAmvGF+zBtPpj/0TPT00728bho6/Q6aARYRGW9hkGZJKdbXJFTGv/8odAPOlOUCDwkOUq5l1b1L7ihPZIPvctuDqIW6cOdu4E3YxRPr4lmYSKkLwgJ42fULkj1KYFDPNuHK0hnZoU7SKSwxnOu85sopqt3Or+rR+prq+DVh4jpVviyQ0bn0hAg9R78wCtM3Lj5KxPDwsahrLHhNF7NRq45DnjgNx7kztMDDPyxyAK7RRqt97pTV1zl6J+VdYMgcslDcWWwoYhMtOL1fWqrtWEA1fbxwLNxJaMqrmukp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(66556008)(76116006)(66446008)(66476007)(6506007)(83380400001)(186003)(91956017)(8676002)(4326008)(36756003)(71200400001)(3480700007)(44832011)(26005)(38100700002)(86362001)(6916009)(33656002)(2616005)(38070700005)(5660300002)(8936002)(508600001)(53546011)(54906003)(2906002)(316002)(122000001)(64756008)(6512007)(966005)(6486002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?r+qUM4K+YoMRuIj97BPA5yYKc2kznQ1ZYIJjGaaeWkGDfmbl2qmGjOF7aL5C?=
 =?us-ascii?Q?BDnJz4QZbVggsbT7/GGIZwiaXwB2CPqXiGevK2/ahvqFFOcv6Ot4lSO62PhQ?=
 =?us-ascii?Q?yQPU47Y2r/qMhrZTV5+TG2n/5a9zVnubFVYPJiJwgMGg/fLX/TXetjZ727zt?=
 =?us-ascii?Q?w36P3IkLT0mFqX2IoFTqyLOllgdKBX/Us9jwHZmhU0JCNW+jvaks5N7Q/S7u?=
 =?us-ascii?Q?AT/mLnF3E+5E8ozSwllsGxKa0dmpE38IEBn6zKOurfGXaFVpA8reNR5eHnA9?=
 =?us-ascii?Q?GsB0/mbenMoTRYsss0gs6uEHhFXVJzIYKFU/GH5Em5ATtpaswR4OW4k9htZb?=
 =?us-ascii?Q?39XdEMBumSAW3/Yq3GiCezdRZ0/LiBQMFzzzT3DkGtd05+uBd42C3Mhax07N?=
 =?us-ascii?Q?RsllcuV/l5+8Wz/OLtMqk9nQIbr8z4NbHL5f0NZMVVoPZ+QzABOszcYzYXZ+?=
 =?us-ascii?Q?f74R7Th97Otuk4a+Vc7axCykhqJGQlepMT//lakz7IefLx9DtzJPkCBbl1lU?=
 =?us-ascii?Q?WLsIBlcHNDnLZ28A0qwShhmM2TRCK+VMPitMLzcSiB4U34sUXLV2rfVzxd9C?=
 =?us-ascii?Q?AYakfqI36QwQgMpaBzj4yGB/gOuSwcOheqfVkPsCiEpmPq03TIMIpdnoNQYk?=
 =?us-ascii?Q?Ka53gKUygDYH7u+FkZXASH0OlnkEQchc4vmqUN2L9qjYerpC9uDMw9IzSK90?=
 =?us-ascii?Q?L3ApIoAcXC5TxzOz3Pug8frBT7mn6xtOmBdyLjnpL5g9YUyjflBnQGzjmdbm?=
 =?us-ascii?Q?biDal117M0QP614oyZsX9V8biX7qfCnwu5XT/uuNz22gP4VnhIn6AUu3T6Wc?=
 =?us-ascii?Q?EhMwDnlX0MxM5gTXdljAgw2hKacN7RFOrTW1rjo+0d3rFoMhDJVFk1kVGJis?=
 =?us-ascii?Q?ubN+eG1scnj4mwu6h2JDWgTxCASbN9+GoS3bUZ86BKhZawLBsG/Bh5EcSqZp?=
 =?us-ascii?Q?XdbXNsDBQZ5ZrJY+35yrW/1f0OTZ5fRV2lbbX0eO8Fmo63P0+ort8ZkcL3FW?=
 =?us-ascii?Q?R8h2bAeznWw1Ci8TstadJLgO14WKjjHuH5tls91EVfeYfwdyX15dr8T/vUPl?=
 =?us-ascii?Q?sKPIe1VpPRPzfkcskMcxixV4IFCRmwA7NdjouH7M46itgiwafBrLaOQ3SMQ0?=
 =?us-ascii?Q?ENGlHDYdTLFcip5oN7HHfVlSR0TUPN3yZ9vhfwmSQr+lA3xC+luKtKrco3Dc?=
 =?us-ascii?Q?OTvGt/4EOfBiz6ZrWePFOqenprMb3Hkn8Xbo1EfmJ1RHI80uJqdRqqmT9Fg4?=
 =?us-ascii?Q?MvUpZ8OIhamt48K5cKYSIBajMdEEI57KwFQdURA/HmQzkaE2BjVk5EUUHP75?=
 =?us-ascii?Q?Q9o2VZmlGAlwPBIVdOi3ShgSMWGlfBVv+zxMWalg/HMh5VcTA1ZJo4Kq+4uh?=
 =?us-ascii?Q?+QiKWzT2ujS449jjMlRv/SckM9mFe3H6QXHM+EIj8W0i5cLHw6SjbtsqZTar?=
 =?us-ascii?Q?GVSvObGIxtBj8QLMqmVqB8Ie3dbW6PbNU+YXjg/5DqkMX5a1gB4IZHIGTJRV?=
 =?us-ascii?Q?PHXXpAg8G7QIzteE5f7vDUpNQL0vklQvgQ6V+7helRHvvjDrStGUh0+ccGOb?=
 =?us-ascii?Q?zGtu2u4PKDcFeZz6dsYseD3t+svOy1h8pXaIYMExXZEMKqypfhxztbdnfqwC?=
 =?us-ascii?Q?WvAXA19JIABLA5yk0Zw9O7a7J9V+P/m/caTaZWL+nIPj6fPt/eIm2NceDhIt?=
 =?us-ascii?Q?DeOOQFP9ZTY8jYPIoQ6KlVwXmkdfF+J3F4+woL2/os8lEAskXo0Oj2ppjGx1?=
 =?us-ascii?Q?xEKmR4n+RMTmQ9mX9sQIyzpx/SO6P24+4WEoNiN+muYYmPyr4pSf?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AD605C239AA25C4AAB8C85702FEAF09E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ab1b1f6-9d3a-4834-f37a-08da376e0fd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2022 18:58:27.7397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SL/kIRkTWMv6xxTsjhgiqJRxmCSU2zN4XWaiae59Mra7j83fYRaPznl0cKPCUWVEeLDUMMRn2HpmLzGLLvP/4tcEFF3AauK6zFCumYSxnsw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5563
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-16_15:2022-05-16,2022-05-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=970 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205160103
X-Proofpoint-ORIG-GUID: Q-Cu4WBgvvF41prUxJIFQlQgWGQRL8F4
X-Proofpoint-GUID: Q-Cu4WBgvvF41prUxJIFQlQgWGQRL8F4
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Mariusz,=20

> On May 16, 2022, at 7:09 AM, Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel=
.com> wrote:
>=20
> Hello All,
> I'm working on names handling in mdadm and I need to add some new test to
> the mdadm scope - to verify that it is working as desired.
> Bash is not best choice for testing and in current form, our tests are no=
t
> friendly for developers. I would like to introduce another python based t=
est
> scope and add it to repository. I will integrate it with current framewor=
k.
>=20
> I can see that currently test are not well used and they aren't often upd=
ated.
> I want to bring new life to them. Adopting more modern approach seems to =
be good
> start point.
> Any thoughts?
>=20
> Thanks in advance,
> Mariusz

FWIW, Python is the right choice to modernize the framework. I recently ran=
 the test suite and sent out a series [1] addressing issues we found with t=
he test cases. I would agree that python would be more helpful in the wider=
 adoption of the test framework.

[1] https://marc.info/?l=3Dlinux-raid&m=3D165220252031480&w=3D2

--
Himanshu Madhani	Oracle Linux Engineering

