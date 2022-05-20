Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 411EFC433F5
	for <linux-raid@archiver.kernel.org>; Fri, 20 May 2022 21:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349041AbiETVZQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 20 May 2022 17:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351331AbiETVZP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 20 May 2022 17:25:15 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD12719C761
        for <linux-raid@vger.kernel.org>; Fri, 20 May 2022 14:25:11 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KIsopt004418;
        Fri, 20 May 2022 21:25:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=SowPDKVHqMthzpPVdguisXSoQwdN4ohCVB5gLo6VKAc=;
 b=tBV2nfoEm0Q0/hH81s+WuWyW4siE090xNEsuJRoSPerwtp+L82A9f50x2vsmGnwAV3ov
 FNYTfxHrcINHnjoFWVKZbL1LCQ3O4YXdFjJ1ilQ+YLMAK6d+WO2Rp0Yy8uGLmQ2j1hvx
 gC73J5ikY97cc1uCO1vn30QRYQ4naZnAGBRvhPJn7kGDDIN+Nzvf7Fy7LsrvyyslbBzt
 HyA22dSiuicl+bZZyNS4H6NUi/GOnAAUH4mk+MF4KdA31mEsyNtUfwXHSvZwACtlMDRG
 SE+xjdYFB1t6LwQIdPHw/jdWK/0AWJWQhR/y5xVHWucl7D9KLhbJkfR+mvuqaKsFtezd KA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g22ucfp74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 21:25:08 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24KLBv5b008906;
        Fri, 20 May 2022 21:25:07 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22vc6d1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 21:25:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O43yT0pAjjcQcvvru2rmt68LZZJF7bMRbV373Uk+Km9DQYfsb2n7LitcAGZRrRbEHAPIgc/gZFtSoElVDuzrGz/pBWln9p/iAbTdUD6gbhs/QEqWVGslBvpjn/lzR+nskAW5le3qDePeyh3g76pXac1W3qJjaUwg4Fzu0W3gCKjgJe89Jyq7fdbiAGglYAD+rUPUOIEcJVpCM+dmrDycZxluBzcqLdNO54FaqtpmZlGD1P08fQc8A/nCn6+rz8aft4GCclaocxH38bZ5c3Us2ECUN2u+OA+zt1hfjmkpBxznMACMrPb2zhaJr6BQffyPtCZziXxKFYsXCtCnuYfwhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SowPDKVHqMthzpPVdguisXSoQwdN4ohCVB5gLo6VKAc=;
 b=HxYmySvrzaBOfi8dcn9qD7QwFDpHbhhTUHW5IkIbruc+46a4V8T+2AonwxOGutPiopBf7UMDxnOBt/yVavRtMmL8rTBXEu7wG4u54Ie9RnKbcntoSNyM0GGeiddkuFgSfbw/BsvwTmAJfAZqtDekWhlsOGK4nTpu+tCuih3RZUf428yXekotuuVd4KNZOTrh7rEJiCbOY2OF9sOll+dt5BP21yXZ+KViBJ2JdWR+IBaYEJoDW+SGnVlDjuRjboqJ4P2mjmJeYvsmf/GKseeo88sNWkdVByoPVVjp9HvPw0odLEV8RjjrEi0nrOzzhlsSyQZmZtWqkS/uzOBmrlxP5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SowPDKVHqMthzpPVdguisXSoQwdN4ohCVB5gLo6VKAc=;
 b=T5D/iZB/mrHu0xG2dejIPxFkC8RKqHxjmlo/9qHkzoFj3gUiq9U6Usyi7vpm4brqXyo5WbhF+QhBw7abETlFLww7oJsrcvMgcV7hnvFTjPp3rTnWTdUnvQGrCEOThRVd/piopyelE70JYTEVcaAWL1/3jcFjiolu44FQkZAnHk0=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CO1PR10MB4738.namprd10.prod.outlook.com (2603:10b6:303:93::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Fri, 20 May
 2022 21:25:05 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::ccc1:c080:5df4:f478]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::ccc1:c080:5df4:f478%3]) with mapi id 15.20.5273.014; Fri, 20 May 2022
 21:25:05 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Logan Gunthorpe <logang@deltatee.com>
CC:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH v3 7/7] tests: avoid passing chunk size to raid1
Thread-Topic: [PATCH v3 7/7] tests: avoid passing chunk size to raid1
Thread-Index: AQHYZJC+aUriYLxK8ECfUcwADlhNza0oScYAgAANPYA=
Date:   Fri, 20 May 2022 21:25:05 +0000
Message-ID: <60A1601F-ACBA-482F-B8BD-9914B69D510C@oracle.com>
References: <20220510170920.18730-1-himanshu.madhani@oracle.com>
 <20220510170920.18730-8-himanshu.madhani@oracle.com>
 <4f8ab88b-a619-5d4d-8e3b-9baffb2ec236@deltatee.com>
In-Reply-To: <4f8ab88b-a619-5d4d-8e3b-9baffb2ec236@deltatee.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 825ac0fa-c406-4747-e359-08da3aa73562
x-ms-traffictypediagnostic: CO1PR10MB4738:EE_
x-microsoft-antispam-prvs: <CO1PR10MB4738D84AE8C4D6F7D97241A8E6D39@CO1PR10MB4738.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5g1Wj734mXxOrCpxhn2sawzPrthrix7hdqYX7hGRL1YBqkIGDBD76yzkaQ71alvRy7RLvJFVymge+oZN8eotMkPqWeBARagzfIN36G8BMUTH/C1wlP1W4eSjD16rYBtJN2AqUozvLR1a8tOnHWAagd3BSmHwferrpkbk2Lob96EpsT2GQ9ETBwkUOzO/uSYAUZjfINy+0iFUBjZn7VF2DZd0DRtZA8RUQbcrn465iQLAaEIL23kvChOl7u268+tyIs/rp2SGYpsuhtMDlMXmWYzWVxnOli56vA9TUlSABh0z57o1E9Oxks5dkNeuT6HMlQMqIL9QJltC30fpVbGf/AMY6UZk3yjdG/fBZ4RS0szUrVkykbO2LrwDRZEESAVw6O2Ucg8O6S5rqjT4iuq5A+IwguJbwSMxsiRbxdMx3peDARJatxWgs3mZ06r/Pac40lHvbt71DMOGYK97bP/ESpRerrDtgejnC236Fsp3EDgFuTUbSQLAXt5/GtPCb2Lq0D0Kjn1+nEqEV6jOZRI9GGuc1ywj3qq4XZ4jHFiB2pYupsuTAUncL7i0moxqKhiOg7X98Ng8BvoiV/rEaPYWy1rJJsWNCbEzhTdTZUVi9KwSlvb/hF2q+hs+34S3bjUFA5u/O/Nfey4Yaa5hL74ZRXmIcnwt+Vjp+wD7O/XQzg3KiUj3oSmxF+8N64ZeO8AC6KSSOXAFk1sKxb/df7MNuW588uF263VcMtUct8VrQDCuIdsqL/58GQ55+Jru6cyVKS7Hn6ZcSUvHrirQnvjWpVHNs1cSFm1zAOvwIKq7c1Q/joYBuuoroeCqOGpVnUvB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(71200400001)(966005)(38100700002)(6512007)(5660300002)(6916009)(6486002)(316002)(38070700005)(33656002)(2906002)(8936002)(86362001)(6506007)(66446008)(122000001)(53546011)(83380400001)(91956017)(44832011)(36756003)(2616005)(66476007)(66556008)(4326008)(8676002)(66946007)(64756008)(508600001)(76116006)(186003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MOgGmgxsl9/IGRTKN5q0Tqrww3QQtgEADhmCQ9Hnq4hgrcFcK9IeJMwmgiDA?=
 =?us-ascii?Q?4Pk/FWGJ3bXrS241TaGNGtKqBrV8yuxr39rutgiJHlxmIRcDcS4mlZ0zzayZ?=
 =?us-ascii?Q?Mnq6Yt9APoPsMYOURXvpUeC9Z9OBP0bQF0GO0aK9w/01bncHXo3CqTsWSWip?=
 =?us-ascii?Q?BzBzW23MPkGkrlECiCJHSnXQuaDoGKIJy+BE3pLiFdGoPC9jlxsPWR67H6W/?=
 =?us-ascii?Q?KRCa0Nu/M8Ba8xEy+HffuoY4ZN4MsbC3y7ugyqlt8LqTSzZpgpblnpQ5TJHb?=
 =?us-ascii?Q?mfmGlJXZW4oDAV42VvG4Re/QkeKQQ2swymRN11IWEg4g4zGqccniCyN0XMNG?=
 =?us-ascii?Q?7dq2jK0WlEOAAeXxRbb/fVfstTt9dKlWWmNIr5/GSPXMPuZbbkX0chP/wLII?=
 =?us-ascii?Q?aI/lrcaAz3S68vz2rLrW5Ew6eDs7f0J00ue/eQZy5vD+HbsgDLd0VAJ5S2in?=
 =?us-ascii?Q?JvdKbye3qSJrSDskNnf8ZmnE5ds4JDkfy6jGO8SRVdk8vxHbxj0r36d4hkSw?=
 =?us-ascii?Q?98M+bUKPei2S55VF7/4FVyslgyUkWBiu0P8DOti/gVOtBJRWrZv6NXKPRXq3?=
 =?us-ascii?Q?m7zIV/BCYm0H/y5POMWr47giS1uyy9mK55qP0ROeJcAGZyTGjCoRryofEbDD?=
 =?us-ascii?Q?3+RTV8FEGUVv+hPc0dn9TcsH4ssdKbMToRaqpxYZAylIoqI4xE7dUqngnPhM?=
 =?us-ascii?Q?sZl43Fx2PZqyBktdlqrfX1Nv3leaB0Tu6z9ujWqXIUZ3ERtxII/6ugXZgxxb?=
 =?us-ascii?Q?1fqVRHvLDgFxc52ABkMZ30wLPemid1gP+htDjwx3fGVnudRk1Mdl7tT9WzXM?=
 =?us-ascii?Q?3tSN5uV6zbQKLv1wXMFFhsBcCUR2qMKYcme3iyiG4Saxo15+mp4SYRXcHjkG?=
 =?us-ascii?Q?J4q0/ChVPwWmZ9RwWtGx/efR0MWFQQq8oZv+Dg8EGc/nSubtsv8F2FTRag77?=
 =?us-ascii?Q?1NqCFBGSMMB3rXdo0mm1Y19S3tiXY+q/BVLKO/5endsY5r9tXOX3eCYDH2My?=
 =?us-ascii?Q?XEKkCCikdtePpRDSe7vzmT7eyVuivTt6QeEaPM8TZ9uUtEoen9qbo1jNicZt?=
 =?us-ascii?Q?27xXuut7+z/qm8KSDav9TOrnLK/ZiSgTwBFZdIkchyErP8/sta3jykh0vyIe?=
 =?us-ascii?Q?DLiAUlqnMsM4b0qUEshPLbQ/jeiSBjU4kwkGW/WUqUDTwUgjp3XOzpZCZJB2?=
 =?us-ascii?Q?VM+5o578vAWtX3WOQoXDYBVYEpa/ta9PIldfil263nNcvYCg1P9rMLeppJZQ?=
 =?us-ascii?Q?m35Dj8yNi9wZLeomVVrkhP7BTc81jI+UPgm74tprY0zdRXdNzbJIq3ZNnLoE?=
 =?us-ascii?Q?KVdn1R/VSjCPin/62VON1nIGl+FT+oUHbnHM5htwl3wU+IMx4fctANnSz4wz?=
 =?us-ascii?Q?JwiycAnlaV49jBQzr4yfH+KoeRHty0b/8uzRtq4dmOibGPDdjqG9ixJLXJ4C?=
 =?us-ascii?Q?E7jVIN2IDACHoxHiu0sBnTzVXbwtmr3wmtG7jt4eHOP68PZquryJgf+zjlfY?=
 =?us-ascii?Q?mIwF7cj98Uaem011NEYin6r0wWWb6m4Qa5bi/5MbrDyNNsCd00YiCqB6LCmV?=
 =?us-ascii?Q?mplrYBxJZZxadrqjvC5z23/SQ0H4MohtHKScXUlatT9zPVYU6hXwnw8i4N/r?=
 =?us-ascii?Q?SWn5GzwkhcJLWK3Au4mm+rs5HGDGSWbpNV9tGZ4s7jiSKVjjhOEXwNzky5Yu?=
 =?us-ascii?Q?7oXShPdcnIE6wLCyODL/sOyHT48P5C79RSSVja0E8ca9/vmwurhp8EMTtJD4?=
 =?us-ascii?Q?GLSc4hWa9qtT/QL0eOS4XPJgiG+Z7+ltFzsxLamrguiWH86jS7eU?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A73C6CAA78EA824BBC98659DA1F8381E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 825ac0fa-c406-4747-e359-08da3aa73562
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2022 21:25:05.5812
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2biWtiUL3A27tzwtREN6cBbM+wqiNrwiilMYI6fro/NPbTcJv5NWYLH59rrrq0OcY5DTyu9n9fBT2po7Uz1i81kliooglXaY7ctBtQEXAgY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4738
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_07:2022-05-20,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205200131
X-Proofpoint-GUID: 6I9AYJC84AaOKUOgsQqrkRJkMKaJR2J3
X-Proofpoint-ORIG-GUID: 6I9AYJC84AaOKUOgsQqrkRJkMKaJR2J3
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> On May 20, 2022, at 1:37 PM, Logan Gunthorpe <logang@deltatee.com> wrote:
>=20
>=20
>=20
>=20
> On 2022-05-10 11:09, himanshu.madhani@oracle.com wrote:
>> From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
>>=20
>> '04update-metadata' test fails with error, "specifying chunk size is
>> forbidden for this level" added by commit, 5b30a34aa4b5e. Hence,
>> correcting the test to ignore passing chunk size to raid1.
>>=20
>> Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com=
>
>> Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
>=20
> [snip]
>=20
>> diff --git a/tests/05r1-re-add b/tests/05r1-re-add
>> index fa6bbcb421e5..12da5644dee5 100644
>> --- a/tests/05r1-re-add
>> +++ b/tests/05r1-re-add
>> @@ -14,6 +14,7 @@ sleep 4
>> mdadm $md0 -f $dev2
>> sleep 1
>> mdadm $md0 -r $dev2
>> +cat /proc/mdstat
>> mdadm $md0 -a $dev2
>> #cat /proc/mdstat
>> check nosync
>=20
> This hunk doesn't seem like it should be in this patch.
>=20
>=20
> In any case, I've integrated a few of your patches into my work which
> fixes 4 more tests that I had previously marked as broken. Sadly I still
> have 25 tests that appear to be broken in different ways which I'm
> probably not going to get to myself.
>=20
> The current branch is here:
>=20
> https://github.com/lsgunth/mdadm bugfixes2
>=20

Great. Will use this for my testing. That makes it easy to integrate multip=
le series for testing.=20

Thanks,
Himanshu

> I'm waiting for my kernel series to be accepted into md-next before
> sending these patches to the list so I can put a stable git hash of the
> kernel version I tested against in the commit message of the last
> commit. After that, I intend on getting back to the work I was
> originally trying to do. When I do send the series I'll rebase on the
> current master in case your patches have been accepted.
>=20
> Thanks,
>=20
> Logan

--
Himanshu Madhani	Oracle Linux Engineering

