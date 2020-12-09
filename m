Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02081C4361B
	for <linux-raid@archiver.kernel.org>; Wed,  9 Dec 2020 23:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A45FD23A22
	for <linux-raid@archiver.kernel.org>; Wed,  9 Dec 2020 23:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731930AbgLIXOy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Dec 2020 18:14:54 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46338 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727641AbgLIXOy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Dec 2020 18:14:54 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B9N4iqD026593;
        Wed, 9 Dec 2020 15:14:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=q3W/b2TkAI9Iz+H2FQOlfV5pqlk0iQ9vLVxuBVxD9Hg=;
 b=abbL8cMAQ8mFSPS314KvEx1b0XDDoIXuMnxRzwyERQJ+SuJUX56RckJ7kKQ1TvkeVasM
 ZDBz3aSWnYETmQugR5IFnn7DTeofY8IF6Bc4J6RV85Zs4acWXi3RxWw4lpx6vaZVBuz7
 VrUzC8lano9BJo1X+Q+8hakZe4TAUDdmcuc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35ak7a89mm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Dec 2020 15:14:09 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 9 Dec 2020 15:14:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B99yAzhIfLwozvU7sD0drqcYlKSWs1K5wX9ElU1towFsuqQ91ovkBRbPknmKDMd43d/OjH6Fu8NHmqWZ8Rxx462hpyhApAxcWoOyCQkrb74b49To52skV2WazYX5b3t3MUD5Ji51oJKbwjwL8B5d77W7M+P071YdRFmy4YS+/zPqsvVr1Y59z/iVj/jmIqFYQhsvTNCfTnvr6WhPyCsdACgrtbrnr+v/zITwI7xlVldCvz0gK61zWp2zXDocKABZtCg+urJ5/qfcU4LxLpUEMuRIRjk9M8bjhU0nAIBlms1I3Nzrcd8jCMJCqxLVuFisNyndJmEpjPWGJihs2cPS7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nw/JIkKfV58xeVygyZvqEX08Vu9uyS/KOut8ylDvIzo=;
 b=CAan2Hb9F4PKmrYDcCLzgOuoXNPQHMnojeyaaPW3p7psR/cG7tY5t+rB1L+KAEVu+q3BVZd5q53WitoxwG9H05piQ2CHhZfWuYXyJ2qMQZ/g93djinJV7H3wdnLEy9duPV9kCILpV1ZxhqrV8K1Rp5qryk6s8YTd52CVqDVjsZjZLwe2iRhydt47po0qQpSTGoZKFR/0egDAr7LR/TWftyny37SfgGSbwzPUnXLjRm46pGyd6gm+3lu5p5wADMjQ9Sj+iot0AAIEmbBRGQlfx4Zb9KRV+epE7MhIUnUdIMx7gYsRsdQy6EX1gLQlOAAHo+FecUcwOkcFJiMWQOVPDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nw/JIkKfV58xeVygyZvqEX08Vu9uyS/KOut8ylDvIzo=;
 b=bIV041I8+E49fj9fX3xJpkN8Vb3XVK+ZTr2whlL4E1eryj28+ZelTpH6W0F6fYkpB8RyOvFD1HDai91VLZCEHR6Se+Pju+bbC24bEk2ghq5MBWRcEvnf/dnjfC8Mvi0m3P5aDCMnxfWBHGHLTevT3cNA4DNHNYuBSilixxq+dp0=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3303.namprd15.prod.outlook.com (2603:10b6:a03:10e::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Wed, 9 Dec
 2020 23:14:08 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3654.012; Wed, 9 Dec 2020
 23:14:07 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Mike Snitzer <snitzer@redhat.com>
CC:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Matthew Ruffell <matthew.ruffell@canonical.com>,
        "Xiao Ni" <xni@redhat.com>
Subject: Re: Revert "dm raid: remove unnecessary discard limits for raid10"
Thread-Topic: Revert "dm raid: remove unnecessary discard limits for raid10"
Thread-Index: AQHWznvGWYeJlNK5kEy9X37Df/JOxKnvZQSA
Date:   Wed, 9 Dec 2020 23:14:07 +0000
Message-ID: <03EC7F7D-DF6E-4962-BBA7-FA554509C2E5@fb.com>
References: <20201209215814.2623617-1-songliubraving@fb.com>
 <20201209223615.GA2752@redhat.com>
In-Reply-To: <20201209223615.GA2752@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:d023]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aebea487-bebb-4e59-3709-08d89c982142
x-ms-traffictypediagnostic: BYAPR15MB3303:
x-microsoft-antispam-prvs: <BYAPR15MB3303A59E93EAA3A05A5005F3B3CC0@BYAPR15MB3303.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OPlUyXQKAU8h5+9XHSSZbNjldsv980yP1m6bVd/sm8SqEBoO3JaVMl80IzUZ4/q4aVJ9DuCYCJcugerMJxnI9q1Sal2WTy3T/1TKiuC8Jgg+lwMNzRIL2qOfcYPmqDvM8lSkeJ7NCtJffbKBT8Z9KD9T8bqAS4cs9DHAEHgqbH0QvSEw3gSX3CubwrpVLmUBgvnYH6N41LNRiT/JiDzoqLzSltmGUXY9LDhWe2UmhBXZ7fHSTwH8n0CjzU07n9JQkUY829z/7x3AoAZiqfoGnuJoeHsaIRTeLcVdk90hrE8jouP45+9+KmMEENA55O0QmNlbJ0HQgQHoBO1p6aSzgLS8Tfg0kFfWhKX7nfOYdbeSwGwi5ArYJ6H0WGn0OwiLeqcT7p97YCOgBbL13ZukXUK2RNg33miJmlEY3V1ordXv+eIYC6VHgvqtqEuKrgG2/g0nmvflmTo17IZORkWlFA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(6916009)(2616005)(2906002)(6512007)(5660300002)(508600001)(66446008)(8676002)(86362001)(64756008)(66556008)(53546011)(54906003)(71200400001)(6486002)(8936002)(76116006)(66946007)(966005)(4744005)(36756003)(4326008)(6506007)(186003)(66476007)(33656002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?lf6F/SsHBi9ex73b0zNBRiNQODY5yFyURMZFGofbohTi5UB/K39twqvlIv4C?=
 =?us-ascii?Q?uAtORMI1Bvmd9NERGZ6YWhzzhbIwU/1Qw8i5LgGEJ7zeKAPlS53TgxM2dMSG?=
 =?us-ascii?Q?YU8Sknb5U2eEvve6PqEptGgDzHgdnttjoYjd4XXAzbM7WE9K9o0PDBjnkWeR?=
 =?us-ascii?Q?3HiqScj/oV/hmTsIU55HjTJKvcUBm9zq3Yu35VwaEjFNJucg8/wafGKyM/v0?=
 =?us-ascii?Q?yKB4jfugqveL4Ap3t6iQ1fnVk8HWuJ/YdDCyrLK4jcUzI/wtYLgmMTJbQloV?=
 =?us-ascii?Q?uQN0FssO1M4rfaGCFqfJarCPGzQtDMopAYFA/vyAhEjeVX0TITbuToMMMfTi?=
 =?us-ascii?Q?kJcHwMJa5QUPBLZzw6TzUAsBjM+zm8J/4cnPYFCHG8autGYPajuKbZAjG9w9?=
 =?us-ascii?Q?l88v0BkFbCL/JZIN5R2sl6EaZ2j5gMJ2YKn+H6M/E5O2otSOP5YGm9LeySfg?=
 =?us-ascii?Q?HTwbbcRl7edupTRsO1cVc7CNj9ttNHYPt1RkC1fspwuH4Y4CskIwD6qIANnq?=
 =?us-ascii?Q?7PP/kBeT3fpiuB1q5sOQ7ln2XrFHa5gCB6A5W6WCgHn1nkswaMHPswMtHOpH?=
 =?us-ascii?Q?WoNZmH3ZuiM3B91PkQ7kObV9Q/Gh48xqLI5K/Ksbwd3YnamPuXWkT4UEztPD?=
 =?us-ascii?Q?OZHfXIzz4gfa7K4ARCIhE6Vv8YgA7VZ4L7eb9/UWGi7v8fvH4dqfiRLCU4w2?=
 =?us-ascii?Q?YMylKh35+Fkkzyg+Y9AIIIsqqyHLx1y9NbxIys31+11GsSOb6kztB4BQc27n?=
 =?us-ascii?Q?MhUJwCS2KTNb6/RhjD2VMUSKazqJp4cT+yru+aXPcNtvyRYY8Hi53rN6y6Oa?=
 =?us-ascii?Q?d6ZTa02AiUsrsd2iZZYgntGUsps6Ib9wGhSyWkX9gQIrBG+nGRSu6jgIW8+/?=
 =?us-ascii?Q?254CpKLqR80xLYc1wvrW4yv5S+9JUIK5OhGzrYeojDwx0B4NbRvxGms73CPp?=
 =?us-ascii?Q?cosnVsXcQpfQHb8eJxpDuvYx07rY7m3WSFcdphg3NY9e7cL45taEKx31HUM8?=
 =?us-ascii?Q?coHigf3IVeDfLLiR4NPF0D4rusj7RasE89ngBtC+7ZMCFRM=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <69A71CAB8890E444B48DA3D937DD6248@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aebea487-bebb-4e59-3709-08d89c982142
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2020 23:14:07.7995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YCRtnlq/vmdBfoeZnxSiAVpOoPj9CiU3meOYL6wTaPIcZ64oZyzF7rwros4Wt2uFQH1JNV98aIejQ+hhfyWQsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3303
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_18:2020-12-09,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 mlxlogscore=951
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012090159
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> On Dec 9, 2020, at 2:36 PM, Mike Snitzer <snitzer@redhat.com> wrote:
>=20
> On Wed, Dec 09 2020 at  4:58pm -0500,
> Song Liu <songliubraving@fb.com> wrote:
>=20
>> This reverts commit f0e90b6c663a7e3b4736cb318c6c7c589f152c28.
>>=20
>> Matthew Ruffell reported data corruption in raid10 due to the changes
>> in discard handling [1]. Revert these changes before we find a proper fi=
x.
>>=20
>> [1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1907262/=20
>> Cc: Matthew Ruffell <matthew.ruffell@canonical.com>
>> Cc: Xiao Ni <xni@redhat.com>
>> Cc: Mike Snitzer <snitzer@redhat.com>
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>=20
> If you're reverting all the MD code that enabled this DM change, then
> obviously the DM change must be reverted too.  But please do _not_
> separate the DM revert from the MD reverts.

Good point! I should have thought about it through.=20

Thanks,
Song

[...]


