Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3B18C4338F
	for <linux-raid@archiver.kernel.org>; Wed,  4 Aug 2021 21:47:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B902C61040
	for <linux-raid@archiver.kernel.org>; Wed,  4 Aug 2021 21:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233836AbhHDVrX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 4 Aug 2021 17:47:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21256 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233816AbhHDVrW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 4 Aug 2021 17:47:22 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 174LiOD7005485;
        Wed, 4 Aug 2021 14:47:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=holIbYthEvhGVS9TNpFzFttsICfY82xFg/gMa7XzyWU=;
 b=NIyVREBAmqdXKRnrSftCRt44tFNZefz87OPG4Titsde2fpazDxl4z7JDBywfwreligA0
 m0jtRrjzIL3bsFVyGkm58dFomU4//AtU9d1/zaPmBy1W0gAorc7XNNBI+Pzvdu1JwVBR
 L0j+MJbMDBuf5xznXMXCZoQgfisq8tXxDcU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3a7wsha30m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 04 Aug 2021 14:47:05 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 4 Aug 2021 14:47:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mKkdfdu/qJCdJ79ro+ux2g9tx8aE9apl9vdlQkE2w6t/Zr2zbU8Aj6Hswx60SNHkivbIVEMgWRexionz/m/jE/UeXy5uYx/nI/OMKDFYBGUGcvLsIQ8I27/Wf1qIckSHAvpvanutzEgo3Z9f1KL/HBDcU46a379j99aL+zMNnw8kHeqo4nEt7rKvl+KcpgGkwYwZR9gF9tz+19Sl52zMSnC/L4UqHE+1qxBmb6ZHFpgclBQ+A1Z34PlVvWDcLjDe2QfDFAQrLhpoVOdc5OGacdV+6rGjhTxGWuX4YhcJ0MXL3BYoNlWfHSCUXy3EuuBW9omvTpS40Eeh/t2mRVRiRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FmffdNW4SJtA+rFPNUpZuqta4FyhgjLG+vMIVd1143g=;
 b=m5QykGlIxPNu6PcUtq2JYMeKCk29j+irCEYBbOmfwE02e7Gs5M/azhpmgUykDkNIKOAC623poocKbjscpqSQGFWstB9fVgjXHXyCZWcrozLS79H+InAwKfyNcWOBafepqnYhFtietH4PDViZlbi+817oT2LnD2NZS4XL+zL46rIWXYdmNUOX1GJ3pLJJPj26KuDBiixYd0/pi8SJxRDcC7fL0+/5P7abazPfFS2srGvGixPADrX8gMlm6gO5ZZGQBfGmdGgjHoPwwBCcSbDiS/yiSio3p68SZFljWoAKu5plUjLNTHtRPNRkhvp00hk9dPYt3pfFVnIlYqq1bCw7JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5096.namprd15.prod.outlook.com (2603:10b6:806:1df::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Wed, 4 Aug
 2021 21:47:03 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1959:3036:1185:a610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1959:3036:1185:a610%4]) with mapi id 15.20.4394.017; Wed, 4 Aug 2021
 21:47:02 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Wei Shuyu <wsy@dogben.com>
Subject: [GIT PULL] md-fixes 20210804
Thread-Topic: [GIT PULL] md-fixes 20210804
Thread-Index: AQHXiXpCwrbagaU+F0u37zo7DM4QPg==
Date:   Wed, 4 Aug 2021 21:47:02 +0000
Message-ID: <2D64F5A2-3D1B-4D27-BEA7-81B03B30D212@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a15fb1d-9a4c-4b18-2e7e-08d95791652e
x-ms-traffictypediagnostic: SA1PR15MB5096:
x-microsoft-antispam-prvs: <SA1PR15MB50967E893DC8E11A7F3AEB04B3F19@SA1PR15MB5096.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 93plLV2rWRWfwS/ihkK+kqMO391W+biuDMoONPSuHwSoYRyfC2lh6O6n5+FCuA5tOhVXDTc18Cr4CWiqQT6P4H2GikCzOjCI4ywZ+EUAy7MhOtaaseyBBLjurmKAVjvX++Ze5iW0G7uZFpYHE6iAN2W4Yo7PwRvnsBP6SmHlsAl7P69PTjllk27Bt2acQ0zLu51oowrqPsjVMyXwObW8vKAKa1A+Sbu2isSvlCbk7lIyZo80TtIaZpNxrkXXg5cU2sidtPUO7eEZ1xlLMcA9Ys4f1zFbrpgm4sqC33+qCEG/se6Nm+CU88qCjTPljSOGgwu18WSvUSRG5K30qgHgPvLp0WIipVxs4SvMcLMDzPVha5oiJ+36J9zBtIX8lzkLe+oWEkHLn3BBQEP9HECfsgV591C4NpBYUb0djxE0DVF1jz1VM2jLqI46IW/d/oZ0Zc/0wiDNsImN2UTNBqvQ1PKN46ErLBawkXNILKS1bhGzjt59xZJ8ALMzrDJclKrJWlDbcAMDKChTsUnd+UwrTtE/+HcNhQjk2Rmja1tFezwgwcdE2yWkgOaV2m2wLpOpQQts/5v7yHh7Bjpdf8ado67GX1Mzcxs5BpBhX/o9BuAHPxW31UMC+i78wdjL4WtlyCPXAXW8vAiZMwFn5yMRW/2FztkyMeS4TAtPfUmhkHvGE5qJJatYeJxoneEHRCO43x1D11RfDsvAMLEINmgAtoUnLRhLEyiWe6AR3KAHlYTF0uslq1lUtDEd9BcdMxs98tY+d0IFdPtGxj/ou27ZaLRcYja59Th37Dpao4+iRWlwquNsrvv69ePc6/IB7fSR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(36756003)(110136005)(2616005)(33656002)(66446008)(71200400001)(5660300002)(66556008)(66476007)(478600001)(64756008)(6486002)(91956017)(8676002)(186003)(4326008)(4744005)(76116006)(86362001)(6512007)(38070700005)(66946007)(966005)(83380400001)(8936002)(122000001)(38100700002)(2906002)(316002)(6506007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ie0KoS3rMLTxpXdRWlK+7q/bGsEAM0DaQ5RFhXbq8tD0cl4Gkxh4Gia0lR04?=
 =?us-ascii?Q?JvW+/TrWBN8Ps5bRPD9FWTqRIVO0MaIZmh+Drqnfv/ClG6/YJCVeX2H0dNxj?=
 =?us-ascii?Q?/fmGl8EQ5Z0dNzxLNYTaHCl+edPYAWTVLdH4IYMKBDyuSAgoZQmx6jb2UInh?=
 =?us-ascii?Q?zdlSexMsbVXfFJ6yxLg6CEvSwImNDukfOe+srHVZ1GTh20OTidJCzj/K5pa2?=
 =?us-ascii?Q?ZBSwrnTZi8Zxpfk7sVWvmGVA9LFXZj47n7eElmEruDXt5zlJ2dgEwYHghiT3?=
 =?us-ascii?Q?ee+hK84HrMPUX5+C+I3BW6R/1pp/ig/0vKMPr1PbqfQ/TzU4b8Ydq+GOdnko?=
 =?us-ascii?Q?ZkDoeN4pml9G1AjHv5uNE8iYS/z4616KeHdCUNlb8mNu6lbnjd8JA1dK6qCw?=
 =?us-ascii?Q?cFppGi9CU4QP6boyNIUJopzhUfcb4tVaCkQjv7AxmddcEQ0D69HnEyTa50bO?=
 =?us-ascii?Q?3QkLP71uNuI+mkzA5uW5s+27V4x2rkQ2q5C3Jwx/ZV1PG5jHi4wQ92gi9NnN?=
 =?us-ascii?Q?HkA8kroSf8UN0fAJ7MjMIy2xvv1kTOjgsSXNtmb4QGCtd7PdKJhVW4CGZWZT?=
 =?us-ascii?Q?gsA9N1KRBJyWnwlFa1BRFS/EbKW3VOQXUcxcIn3rWehFTDVUhilwwgeUwD3k?=
 =?us-ascii?Q?rNlIF3Ahh5LO7LvkU6k1FBbyG2LH3aPmHMgdARN6zSlpFWbJ2IIweAePQkTh?=
 =?us-ascii?Q?iHUQk2mNsLL51UiZrNTkfyBrBvRoPfHv1lkfGuK+oTXsy14udZvS2/MgcjRB?=
 =?us-ascii?Q?VSXmg0IhB+yzr8zOi0RCIAI4NZhPg90RunoLHStwg8fj2WROgq2G/HyTFCnx?=
 =?us-ascii?Q?cGqMwPRGe21CEhmjvvPR+1nPkHgvi4JlJ5PTro7fvRihP0zsdJV/7pUnY+Jk?=
 =?us-ascii?Q?rGZVRmlJThuG3lf3QLMahjcwm0TE4zCahE10l/ucy18pO/Oq+HVl85su+J7C?=
 =?us-ascii?Q?doylDED2kWu7Rpx9X9zQA3RSSkxLmqVSH5FnG/hD45tXLGKDntWoYpdR86GW?=
 =?us-ascii?Q?sAOr+4KuSzN1ErbBFcnnLNz6vSUTL9dnIfLdrnLoomIgA90MWrxhJy+Ez1GR?=
 =?us-ascii?Q?XkbKhwwziX9y5IY0/MSEsx9ta7WZWZoeqpPcFfoX4iF02gWHhJasow+tigWU?=
 =?us-ascii?Q?7RWTiH0AR9k6FnlHwxnwTvmdIr9D18Ic/wGP963e2L4Ec05KAkBJm6NSr1vn?=
 =?us-ascii?Q?nY9zbe2FGF3vn1Puc1ovDJ3EteXa4EF55bYnRXdInZhQDGzzfZKVus7kIMQq?=
 =?us-ascii?Q?QjEFpzPm6V7c1tS1I2HuhbhN2p0PDaqdyGUI8pLb9WTxVGyv/gqS46zamt2v?=
 =?us-ascii?Q?0Ex+m5M0gl1TG0lrFfUhO4P0qL9Vo+tg3EfevDuAa5+2GGw8R54yDs8fGrNg?=
 =?us-ascii?Q?R1iMNh4=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <583C540B87A9044397BFD989C28F27BE@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a15fb1d-9a4c-4b18-2e7e-08d95791652e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2021 21:47:02.7074
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pnuin61LNH6O0cJsFf9uid9Mgl/aDVD4SlXTB5EbmCh/el7Ed/TR3SqaVY/+2sVrA921Lgh0xlT+gb1Uxa3OCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5096
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 4aDJPIxu-kabCX_jyxqrCHtblwXe_gUs
X-Proofpoint-ORIG-GUID: 4aDJPIxu-kabCX_jyxqrCHtblwXe_gUs
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-04_07:2021-08-04,2021-08-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 adultscore=0 clxscore=1011 impostorscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 phishscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108040134
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,=20

Please consider pulling the following fix on top of your for-5.14/block
branch.=20

Thanks,
Song



The following changes since commit 2705dfb2094777e405e065105e307074af8965c1:

  block: fix discard request merge (2021-06-29 07:41:08 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes

for you to fetch changes up to 5ba03936c05584b6f6f79be5ebe7e5036c1dd252:

  md/raid10: properly indicate failure when ending a failed write request (=
2021-07-23 10:14:07 -0700)

----------------------------------------------------------------
Wei Shuyu (1):
      md/raid10: properly indicate failure when ending a failed write reque=
st

 drivers/md/raid1.c  | 2 --
 drivers/md/raid10.c | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)=
