Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD25C77B7C
	for <linux-raid@archiver.kernel.org>; Wed, 24 May 2023 19:03:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbjEXTC7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 May 2023 15:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231633AbjEXTCv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 May 2023 15:02:51 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DF8119
        for <linux-raid@vger.kernel.org>; Wed, 24 May 2023 12:02:50 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34OHFo7l017820
        for <linux-raid@vger.kernel.org>; Wed, 24 May 2023 12:02:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=bhW9KtTbROw57RngNP3fHHpuZl2+/7W4fF77QEKpxgo=;
 b=VfQaiEMMuJn4nqcKxOQyBgmsjDV2xFV7gUlBYb5EyC03ScgZHzCe4W6oNFfR3Jqd4uMO
 L+rkNr10EljZ+jStcJiJ93FKIKy8Rvbo00MaN9l3dV1KuryIZPZdSADjiRRxS51rxJjH
 GOgLCJW4bO1fowjXVwoUpB89xofVHgIR9cVTav2UGy6nusaiSBN5zWpuB8Ny4UhBjmis
 AJ2k2hjmn7o/XY8n4bv8wH40WuZ4J8FuCL90diGVfKK3HMEFdoPNi3nFgm64tLfLYrsM
 d+FXzSxhBQIAIFxrvfAKfuNX8PkARHliGs0HZcycbcQqRnFbLkpE/fQZE0xT9yGJQ3GP IQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3qscwrvvqs-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Wed, 24 May 2023 12:02:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hYOGdq+luLf1XEk5ZonNyUelx6K46u6NwOBb78n3HXhy3KoLNMh5JCT7oSfwz19guG7clng8g3kM+QhLa40/zoUN47sDi6awwziJUOp4/l2Fwfa6KXFKHMBJeDC8RY/Sl48ai2swwErZNndjdRnJ6b6pR2TnsmRvOjl5TJQgdDWTpP2LBcJ4KIO1QDukWBNYulU2Rfz0Kkygv4aj+yZ8yAQOpVBsN6mSsTPbARo64vPfrQ1LYfizTMBncA+cGkEmD1CELHb6t+wJPNNy4qEUka661CN2BT1vSkc5tBSYZ81FE01mnSWcIuhCtc0CClsjgnGr1UGNNsQXaiwiI+a6uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bhW9KtTbROw57RngNP3fHHpuZl2+/7W4fF77QEKpxgo=;
 b=W1w0K6DXQKWCW2NoyqW8sGeVwNDUiZfDK3sE4hP/7ZgHDUWKAyKFsXsirmB1qwyLXB5qXzqNEMJ02tQR+n+qzgCsWPKnCIt6eZ9AE6c2HMKo1ZCSpY7khMCuhKcmfcZEiH+TrjQW//lezNZ6IfdpJWuLUdG0av+lpq/NbB+DAiz4PhDVdINGSf7jOcSrXJn49b8Qfof7+/bKWAIfKJL2iIPuZq2AR6DILXk37MRxRZlOZ5Kkyg/mJeA2hWGcMkxPshXVzj3UZQW+Bg6eOHdeHHKiEi/P0lc5/ieR5Ra8SX/BQdLRQlt3jH+FtDN3wrtRaZ6wK7r6hQ3hVbgvdaRp0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MW4PR15MB4476.namprd15.prod.outlook.com (2603:10b6:303:105::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29; Wed, 24 May
 2023 19:02:46 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e868:d4eb:382:e522]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e868:d4eb:382:e522%5]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 19:02:46 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Yu Kuai <yukuai3@huawei.com>
Subject: [GIT PULL] md-fixes 20230524
Thread-Topic: [GIT PULL] md-fixes 20230524
Thread-Index: AQHZjnJTUGLOGYNOBUKNKXIGGFcGVg==
Date:   Wed, 24 May 2023 19:02:45 +0000
Message-ID: <3D58B70B-92D3-4355-A89D-0F6490448546@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|MW4PR15MB4476:EE_
x-ms-office365-filtering-correlation-id: 808e8227-8a27-47c3-e09d-08db5c8975d6
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D7RZg02pUPbH23Weg61jydAoUwPn+8dqc/3k3IAdlR34Qge/3b3P7sKTtJP5v2AQrficIosLOyRdCI2VdttN44hHofvGarf6TczSiaEFrJgm8iamFv3DyLPoIB1j/Ylmx+QKD6WT3imlytTrgmLjRJnNzMcxaDYJ57dpdYELxqjMFfrcqQBVl90EbvnUdU7wmAoKSS2bY1u8502lhCVZbLtzb86QseKOB6vA22MzXoX6y+hODYwuGN0LQ4VkhB+lSQ5LHyn+/aRpKzcm7V76zwotmNHYhfkx/x8uvOptW+HBT0Q3AizYl+Vo30aSObDUAr4WtEvMB2cf1GjF6whnQzbRa9TMa8JT2qZAYfvwU4SJVOrRtFlNiHy0ahRvHHmpSQuCmN8lNXuwl3bWLPIU6PyFtClf/kSLksmVmrmEC4GVsYOAt5i2FGDdqHlYbiWkKF+fweaERFcMOJxFvfSS14AL0E7LIQQ4hX5Up6kYHzJKiCLeb9TojFgXCOHWf0EYgsbhbF+sRpzxy0Jr9RpKL5E0IeIlx3RtbH5PNl7KhFDXKIRYzZ5inMkePAzPyHKW8P5TNLXCnrRmn7ZNcpVlc4EMFqYOBCfaDQpxf32jrWVUWk5pfL2FFlVkEVDMsIpx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(451199021)(9686003)(122000001)(33656002)(186003)(6512007)(38100700002)(6506007)(36756003)(2906002)(4744005)(71200400001)(316002)(41300700001)(6486002)(110136005)(64756008)(478600001)(86362001)(4326008)(66476007)(66946007)(76116006)(66556008)(66446008)(91956017)(38070700005)(8936002)(8676002)(5660300002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UYPn51WZhbe04Gp9SCuDvJi+BqZBLEeDrPHEkoR9hwbH5wyIAJ7ku1EQKIX2?=
 =?us-ascii?Q?GZdUOJoPq63NvJHngnPrxUVXyjE7eMGCVkWBQ+yfzQ2sVKJfzvt4Oz9A3x2N?=
 =?us-ascii?Q?44XFjSkcgQcRU8kVp7fhp+zQDE4LxEbqyKW5r2PI3uhrrkUMYReBqP+QY9SS?=
 =?us-ascii?Q?9r321h5RcwGoUPvws09NutzFFqjS0wpE3SVXrBVme/JZPYUuVO0OAVfu71kM?=
 =?us-ascii?Q?A47lXSWOECViJ3+/hsLOS6LISRbvjcikMw6dqgk0/WKpz0xvSPRpFZQgcuvr?=
 =?us-ascii?Q?ey2lxMqqXBtBXfA4aoAkJDq7TMCDqu+/CTNA3RgFeqyBeaijQ1w3TnkmKYHX?=
 =?us-ascii?Q?Yr6vRLB2zy6hw52SE2Snx8+IsrqQL4VYQYsShU1kY7LCqOgVVvOKsJ22QqZT?=
 =?us-ascii?Q?LD8XRr1rBsF9dX1gsNVPq0sPLq1eb8tL4lEec9SjQePKh2QiUULCFbqziF64?=
 =?us-ascii?Q?YvC96BzJ7Q4YT+//765YYfbKIdJTRkDQAE5CneOki3t5HXgsfKvEYpA5xJne?=
 =?us-ascii?Q?zhUISTIePUpBGwdoOCTTCw41Lr47raOjaI6cphi06aRkocRoQU/N3gFhVx6d?=
 =?us-ascii?Q?Nu3z54FRe1DK957mXIp4L6q80fqSUI7EQSFqeVoTscvw3Ihcx1INmzubMllo?=
 =?us-ascii?Q?urkYHXS0e8ppmvJ4hIhNVLKA9vS1cb3wcLkq4VIq/2KBHJOkw/cRuZu7gHaj?=
 =?us-ascii?Q?5WTH22FS9KhxrLOGWhu3uq8ny3ssXOiMztSuhStzdToteR6ng2qRbSYawlNd?=
 =?us-ascii?Q?ac6G2y4KumRGrNyCnJQWq3mQqB5RqU21Kwb8ZovSdHG+OgJcCmzaChW+g/Ua?=
 =?us-ascii?Q?Ofuujg66Xo4FZ/7xuRTYAzoFY/UlR/d8YGAPZGfWSOQavmia7Zekz9J16DFE?=
 =?us-ascii?Q?Qvfg8bhC8LQhtUcVtPaIfrZ53pB+XBfnmIRX4P8DokC2LjtsQgF2BAiwsyng?=
 =?us-ascii?Q?heMoKhuUH5w9K30M8EhoWSNGKztGFRDeNDLE5fnWL+1Iu8PG4Z8G044rHdph?=
 =?us-ascii?Q?wMF3PlMA0TMVQSvIwrgud4ULUN08sl2+TJ3mILI/B/fM82oUVVVoBgEWGkmv?=
 =?us-ascii?Q?SgCi7iXG3xGGWyu9AGI/Jxl93//SHfx8XbWqDE14LPgXxWIPulPq1P8TWoEW?=
 =?us-ascii?Q?hhi5AXElClpaoDmUhSkUaTJfZIq+oyoZ6auSXU54cQC8TzfpACexjzON+bUd?=
 =?us-ascii?Q?BlSzL9WwtEYbo9KagNBvVkGoeBWxGN8a6Ty/oaB5M+zKNz9sR3Dp+8qh+ccw?=
 =?us-ascii?Q?c2/tY0/uB02vIlsud2BYDtAgJ+WPEXEV+Ubgl/vFogoe4WAiRl48+u5pgBqb?=
 =?us-ascii?Q?oVoS/2FS+EJO5DjLjR+LeefaS7QrfRS7R2964SmVL44ViXf9/cGU0SMmn0hk?=
 =?us-ascii?Q?9kmeC6ijYsB6NEdwuzoFEcw9jtvPAtW6h2QLm/D0+uJ4Rd13TznYK0uG0/Xu?=
 =?us-ascii?Q?ZhKi4dKfcyoJ9a5BW9Ip2e+HY3i80q/TYX+O4JMfkT5hecZ32JOSffT44E6b?=
 =?us-ascii?Q?RRzCEuf+xwZLGKLnkUMlV7COVmxtv9gYxgl2SQJMVl44uB8Emt3mP4iAcmDy?=
 =?us-ascii?Q?Yl556xG+vg+JoFiJ4j5GaUGRn6T2WagM7x2QmHZD3PnlO+72TFVqE12eHiMz?=
 =?us-ascii?Q?Q9bNnHkZhIXx+qQjMSgpHHw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <03A8E9576710BE41B9F966946B4C7EC4@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 808e8227-8a27-47c3-e09d-08db5c8975d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2023 19:02:46.0325
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Txlezt0zRSDxkGF+5x5dPIG6kX2A2M3eBvdXOEPRmQoDSD+f1W4d3jZYPuFDt1O5MjVpFOsugyUyFMyiNrM2Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4476
X-Proofpoint-GUID: uttsMYprvzeGyFkr0wE-g9i0UPSItMGo
X-Proofpoint-ORIG-GUID: uttsMYprvzeGyFkr0wE-g9i0UPSItMGo
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-24_13,2023-05-24_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following change for md-fixes on top of your
block-6.4 branch. This change fixes a raid5 regression since 5.12 kernels. 

Thanks,
Song



The following changes since commit 3eb96946f0be6bf447cbdf219aba22bc42672f92:

  block: make bio_check_eod work for zero sized devices (2023-05-24 08:19:26 -0600)

are available in the Git repository at:

  ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-fixes-2023-05-24

for you to fetch changes up to 8557dc27126949c702bd3aafe8a7e0b7e4fcb44c:

  md/raid5: fix miscalculation of 'end_sector' in raid5_read_one_chunk() (2023-05-24 10:44:19 -0700)

----------------------------------------------------------------
Yu Kuai (1):
      md/raid5: fix miscalculation of 'end_sector' in raid5_read_one_chunk()

 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
