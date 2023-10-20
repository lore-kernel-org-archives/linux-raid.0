Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBB2BC0032E
	for <linux-raid@archiver.kernel.org>; Fri, 20 Oct 2023 16:21:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjJTQV3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 20 Oct 2023 12:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjJTQV1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 20 Oct 2023 12:21:27 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B3AD46
        for <linux-raid@vger.kernel.org>; Fri, 20 Oct 2023 09:21:25 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39KEI4fV019783
        for <linux-raid@vger.kernel.org>; Fri, 20 Oct 2023 09:21:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=xPW3vKLa4+Dl9+9ZlzSBFa9laA0vlJwxtAN4eX0cHwM=;
 b=O8ib4B0jllVKcRjDdGqXbhouH35h4nwWFqNqlgxoSE5sWmpW+kcwLozEsv4s/KXMdljV
 oDNiO4m9Pf+AbrShlcOoh7RmtR6wcEfDVx/1ZQb9hA3CWFnRQWNY8YHllRcqGwvm86ck
 XYS1xx8mQkJ2HD7xsyIP0pHbZjY30QCDPzcf1vHYx9dwMn9/OofX2FnsWWt0W7xzO++L
 jFCaFKakqIRq37dyOh767hl738/VWc3u0ID4PBL8eas/ZivgFEtdo2Tq3STyVLY28Dnd
 4z3Y09oAsfMHptbFBv+z9JMtMirv3RsiFMwxPVtyplsds6hZy7VWwCRGttN/uPib5CDd ng== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3tubxnwfdq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Fri, 20 Oct 2023 09:21:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hMFkccn8d5WE7nL+maBel8IMt3ZCg9mlaPqVOtvpfWx+RGrXd1t/eqPLiC9Nh5tYWu302tt0SGwMCkm/3eN7zhmlv288IUdJOLWSKBcA4H1ddsmuQhLdIhkykWGW/oGZPQcYTbn+6kC2hSjDWbOYOpu9nIG99JztoV2rqL4S1b/3MKQwh21s6fL+xjJj+NQl415pbf74tqq4v9gIB1DtTzK39wKk3Mr9fTWGzJopNPJrnqT/sQ5HqiuvK6yJs3PPZWt+1HqDRXpnJRqJpgFKw68fj+7Lo/Ud8PzpcTcqFAkDojh7pUYaVFlIjJ59VzqQYor9x3ihCYJoGXAtH6Or8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xPW3vKLa4+Dl9+9ZlzSBFa9laA0vlJwxtAN4eX0cHwM=;
 b=J6E4W0L6syIPnnMfeUsswKAIoRy+Uw6ZXCtR2NBX4PT95LM/I8PXknW8yEwzuylBeikKbBdQC4qwL5o/rQIHG1IDoxe49tDS1nBHCZT7slf6r/74oGQNyBMfvpLeGKTPHFx6m49BZ/6r+sWyytiz4p0Pg8VAN14qZHS/KbnUnXtF57EOakQNHnxBpXpXFzyJ+gcnXVE+rx64iB2Q9NkRb+rPWhA82D691tU0oxP0EaFNMANS4JyS/VKHrxaOG8n2iY2Uh2612Pgq33igDWPoG5hZ/6BegxyTlzOEsodeY5iFnc8h0ioa+FqKmNA9txSfvSHxQdg9NV/08XJ9OPkomA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by PH7PR15MB5402.namprd15.prod.outlook.com (2603:10b6:510:1fe::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.23; Fri, 20 Oct
 2023 16:21:22 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::526c:b078:a1d1:fba8]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::526c:b078:a1d1:fba8%5]) with mapi id 15.20.6933.009; Fri, 20 Oct 2023
 16:21:22 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Yu Kuai <yukuai3@huawei.com>, Yu Kuai <yukuai1@huaweicloud.com>,
        Denis Plotnikov <den-plotnikov@yandex-team.ru>
Subject: [GIT PULL] md-next 20231020
Thread-Topic: [GIT PULL] md-next 20231020
Thread-Index: AQHaA3F24Y5DZjLI8USY5dkA95byGg==
Date:   Fri, 20 Oct 2023 16:21:22 +0000
Message-ID: <50A926AD-D6BB-4635-90FF-DB6DEAF62EE0@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.100.2.1.4)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|PH7PR15MB5402:EE_
x-ms-office365-filtering-correlation-id: 51c3751d-6a0f-412f-0d89-08dbd188995c
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NPPINlixbut3dpBsq+LjhQiXjRqSNzPFSXCodDn+ZZz370VpMw3nd84PHkhIDAS7sGJoZczKNHo9q53zqbsN3dP0qqKyY9cllQUgkIi2IKIfFapLWTBc5MBsjAs8cKki4CB+kT3IMQinRcEuS307E+IUzDt5kQNlez1FBmrO+Oj+4oDYEieK5ua2IJK4CEx26FGmqa0/XZcq/k1ZYDScICdiklVQIlSM7OmjfNvvP3BKys8oGCb/J009jjGffcmudF45NgLmrSxr/slsnF+DDsLObdqVPotuNc/PerFfiuQvY0vw1d0hFLJpuiGiQgL9rA2ci4M2tvs/yap+ZDSoO4lYUGV06zjHY01HjXaAzwhqUh2+wsfx19fTZGyqtgPtbj2hnYJh3OA83YcCixbV2+77lWNP0PQ5IAuJ3ss0aY+cDUbSKjVxTJugVaiF2OqnbvSwAzdcqEivrM+Ae2CjG+JXLmrc77HugyQEzBWpRmjNwZCwQuOIKyJ0v8dd/nGSaZ6mOYRtfP5bg6HueXYgm9RT4LgUsGa4o43BXWj8OTUzYIX3QuLEH3icFiN3L6FF06RDJpJBzLVOlhT3Z50rferRwzomVuX83E/5mmPjk0Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(136003)(39860400002)(396003)(376002)(230922051799003)(186009)(64100799003)(451199024)(1800799009)(33656002)(36756003)(38070700009)(76116006)(122000001)(66446008)(66476007)(110136005)(54906003)(38100700002)(86362001)(91956017)(6512007)(9686003)(83380400001)(71200400001)(64756008)(6506007)(66556008)(66946007)(2906002)(966005)(6486002)(478600001)(316002)(5660300002)(4001150100001)(41300700001)(4326008)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rnJAXf6D9Cx82gYcsuQbd1lS3u7wCwaUVWT+WPOi8qTmzhcv+93yZdaIKBXp?=
 =?us-ascii?Q?aPS4DAekreUM5oRy+Q6ZnIebzWLkIQOgM7C/IUpydBtzcW1ZO4hxrbplCsVQ?=
 =?us-ascii?Q?QbUMTTgO7uMZ+yD74MKfWrL+Jld+lE9Oc9f5USseksl7ztVPUXmo7NZy4qpy?=
 =?us-ascii?Q?gCP/dGhMEfMPOXb/ikGZrqJJrcOlVWmaU/f/DTT0XUJfOU3UjNDQjVR6xqv2?=
 =?us-ascii?Q?VcA511pbmrwECftCYRtT2O8Gw6jkVuMgQ4oGz6/T3d2m9+kaFoJs6fN7b7uk?=
 =?us-ascii?Q?EzDRyZ3bBDAmYJM7ub153wPs2ctcs6b0gWsmaKfglMy8tNqQwhyspsWLQCJp?=
 =?us-ascii?Q?dam34o3Vw7A5aymrJcael/TthjfuCTxnczH22/gRFXcvShORLxsBGR4BFoRG?=
 =?us-ascii?Q?e4H/Xi8y8LV86XGCqyxbxEOrK5XRmScZd/sSMFBEG+XrtvUqzWSIRNudF3Hi?=
 =?us-ascii?Q?38q8GMfc7YwU+o+dFacduIj4o8veJ+337bfrVS9FFuvW0g5QmbECi4aX352N?=
 =?us-ascii?Q?bncjB8/FLeAy3cx0YoXG1/8ikJJNTDtFh4WjYID3QX1pEpVl2TfZ5D+0OOxI?=
 =?us-ascii?Q?jVBW2vEmqi+5j4IlKzkKD8vYrkqOR9Hb9KYQyKRrEg0fW362tJHI7Tv6LNsv?=
 =?us-ascii?Q?BU2eUaa0xINQ6ZGArumVE+7hIg5F7oAx4k3OWGIYjcaaCQ2eZAyJdM+lehoL?=
 =?us-ascii?Q?hlNCAC7MUhSj5/I2zzxIygx0XgBFabvkIj/tv0ipdaT+SYzlWA65Duc9J8vZ?=
 =?us-ascii?Q?pu1CBXnwE9tZJ5gyXAJBQIfem1zITVWW3RvFQYmRkvg3icVRNYnA8bJD90nS?=
 =?us-ascii?Q?7ngewMI5FW5wwiRl+xGEJGfTwuq9p92uM/BhrKo5Y8LLLHENS/a67i1FP7Uu?=
 =?us-ascii?Q?2VhBeM8yNftFmOA+0uqILCLI08BhlDox5DmLI7UsvymyZs/XU6qyz4WkEM9b?=
 =?us-ascii?Q?wbLz5dEOwGESSbWhaAn7U1Rbi6PV0NECIWMJ7IkZxg5xGUI4wusbDxT3C7Mm?=
 =?us-ascii?Q?app3x8POeABqu5OAR/LcBd67j/EWkYPhTfYV2QsgPZEIWhIvRhk+KYqKpTW6?=
 =?us-ascii?Q?NG8P4nYsOHCWAGQJcSgPVHDnn7UNYKbRLVaw3yJVBNhf6QLCKYB7fJWTRTQf?=
 =?us-ascii?Q?J+gyEpmgVReKkkgi2m+Evq6Otz5e4nstqcPLEl03L2iP2N1gzt95k4EvFPJV?=
 =?us-ascii?Q?FVWjxKhx5e3MrgsmsLHR2UaC0G21BCIu161Ir2UbBo5jT6SI9yQ+fpvZJ28W?=
 =?us-ascii?Q?6scrD5uF4oHQYzLLIbr+ZNqfQfPxiYkkxdRahJUvZW2J4tle8QJJC4MP/MIm?=
 =?us-ascii?Q?jSl8tvZxlv/pXGbhJWFRCl3howsO08wMx+uEQPOvMfOH2WqTcejBz2aRWKWG?=
 =?us-ascii?Q?1e5acHiG/OLuOaAhgCofbrVGI0MkYcyrMGneUjQsNOd4YJimiAKYxvm2KyMS?=
 =?us-ascii?Q?wViV3GLcLrmiiCZB+cDoCHZevXSDpFLo0LCfs4s81Quv9j7EHT9FbxSj3tqg?=
 =?us-ascii?Q?SxmJootsFgnU8erogp9m/patkzUmP111X/0xxTzyR9BIIt8tBuvLnfsjPFdD?=
 =?us-ascii?Q?hM1dK283h36GXIhMviQh7A8oaw9TE/yxsSZ3s0TOMbyatXq4D5DrNMW9maGz?=
 =?us-ascii?Q?89oDO5O+qRrePXrnnI65AdM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B9835D6311A48F4F877D0BD04CF57E2E@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51c3751d-6a0f-412f-0d89-08dbd188995c
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2023 16:21:22.1460
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5VmWm9s8PkcHg8ITc31/OL3FVwuXaqFncTsVPSNo60FX/f13Q8014CKBLk2fUsO6SV6eTqgLH84BSwVNhjC5Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR15MB5402
X-Proofpoint-GUID: DaajyibPbEQ-NauUecbCaA_zbYAa36d3
X-Proofpoint-ORIG-GUID: DaajyibPbEQ-NauUecbCaA_zbYAa36d3
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_10,2023-10-19_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,

Please consider pulling the following changes for md-next on top of your 
for-6.7/block branch. This batch contains:

1. Handle timeout in md-cluster, by Denis Plotnikov;
2. Cleanup pers->prepare_suspend, by Yu Kuai. 

Thanks,
Song



The following changes since commit 9164e4a5af9c5587f8fdddeee30c615d21676e92:

  Merge branch 'md-suspend-rewrite' into md-next (2023-10-10 19:23:32 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-next-20231020

for you to fetch changes up to 78b7b13f07a3ca16c03aa8bf63f51d6780e8e9e1:

  md: cleanup pers->prepare_suspend() (2023-10-18 09:22:28 -0700)

----------------------------------------------------------------
Denis Plotnikov (1):
      md-cluster: check for timeout while a new disk adding

Yu Kuai (1):
      md: cleanup pers->prepare_suspend()

 drivers/md/md-cluster.c | 15 +++++++++++----
 drivers/md/md.c         | 17 ++++++++++++++++-
 drivers/md/md.h         | 18 ------------------
 drivers/md/raid5.c      | 44 +-------------------------------------------
 4 files changed, 28 insertions(+), 66 deletions(-)

