Return-Path: <SRS0=zRnh=DQ=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12DF9C433DF
	for <linux-raid@archiver.kernel.org>; Fri,  9 Oct 2020 05:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA65A2222F
	for <linux-raid@archiver.kernel.org>; Fri,  9 Oct 2020 05:50:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="M2571xqv";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="AudAo8Fd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731379AbgJIFuK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 9 Oct 2020 01:50:10 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16164 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725917AbgJIFuJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 9 Oct 2020 01:50:09 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0995iisY008910;
        Thu, 8 Oct 2020 22:49:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-id : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=OStPKVNVCh/n7DqAdUIg2BMu2QlH0GcX+bKpLFDrvFM=;
 b=M2571xqvCy3cDoP0bpqTvtDbtAzf8xW6dey0rGVjoyh+8ZDBkadSqfxDhz5ZcVlvPH8H
 t8dZlu4aG66mA/CK/d15B/ZXDWwUoGd7IAAHkv+fEIbmcNF54/2hr9y8LPmGWv14CeQO
 sZxgdkCMK4j7qHdvzvxyUjb9yQumwG8DAvA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3429ggt0vc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 08 Oct 2020 22:49:52 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 8 Oct 2020 22:49:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GfTE1djZXpHsteM4EMJdLZnUMAoASPXylscoVkzlxNcMEyuMEkpUWKhYOnUivy81MpkSetxlViYEkckeoulJANd2wd+SUCIqHtw5A/1QGnTVd4N1fJ1N3wTgQfJK21Y61b6XPjf6sBAYJGR2ML/4J8NGshs3LBpXua1K86dtwVIC/9ZhuAH5eX3ZvNdGOFjDj82dU9oBlK34AGTeKgd98h79FQ1n4eAWbwzz/zPxoP/ak1s7J9mVQlORLygO84F7rC2IiTFDmINwJ74p8fZyOEEe3JvdqXmehDoy307Z4SaFa5N0A4kH6FUfcaBLm2fjPAiAQvuPmbgj+UM5kAy+5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WBUgWQw2vLemuX78M9ieGa5FcIzuICLZ/ZJiuP7nORc=;
 b=VHOkvx5t9m2Oy4+m+tcdSp1gKwAAYcY4mxD5mrBwaNMo2t7gpG4YS9OjjTfW5xWYwoY7Y1g70nCJqKnY2/5XSTBMesaLZ4jTJZpCIItYGC6DYZ2LTXOUi71m2dyBI3wgvY9+9Ny+E3IZifb4aMgHutE90a/SMXOh1G8w94jxRGHwAOttPtmNicdehPQNY6mXCADS+iPJUrESAUX2kfP+Y0n5XjdPS+0SFaM+wztsMXqxTBEgkP8f36q3nBwPzZMDgWNulk5dGc53czU1SGTU04Pm1bGhpW11b2tC1Nui6fVUuMsE/3+fPFNfXPwUKmuRKTRhNMROi6NRBIfLpxWPZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WBUgWQw2vLemuX78M9ieGa5FcIzuICLZ/ZJiuP7nORc=;
 b=AudAo8FdMiPie1/cs8B2/N/AaN91piMPLq4uj06AbuRacVPb29fSmkGkPJ7FjppTslcnOGMXYmcqX7muc4kxyqBM0x54fvnO2mi0vmxniZzVAL0VFn36Fwl8MX6lWqRHyOos20GIBOVqMAEtEnpp6xxFnco+3y0NdYxuya/aa/Q=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3208.namprd15.prod.outlook.com (2603:10b6:a03:10c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.37; Fri, 9 Oct
 2020 05:49:49 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::5448:b1c1:eb05:b08a]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::5448:b1c1:eb05:b08a%7]) with mapi id 15.20.3433.046; Fri, 9 Oct 2020
 05:49:49 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Zhao Heming <heming.zhao@suse.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [GIT PULL] md-next 20201008
Thread-Topic: [GIT PULL] md-next 20201008
Thread-Index: AQHWngAAFDkdXPJcY06kFeIE8U8wig==
Date:   Fri, 9 Oct 2020 05:49:49 +0000
Message-ID: <0AE63FFF-6DBF-4AD1-B93E-F5466E1AF5D9@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:cb37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea953d48-84d6-4962-9ac6-08d86c1722aa
x-ms-traffictypediagnostic: BYAPR15MB3208:
x-microsoft-antispam-prvs: <BYAPR15MB3208208F40108397E1205F2FB3080@BYAPR15MB3208.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +y9q1r1Eom0s7pvznjfsl0Oup/sR5M2DNj4TuQUoUu/Oe9662EISVPPkCWnEJ6iCdFBknJ0ash3DuVOdJqpZibWgXkTCRUBrv/J24IK2hJC6zc9ZuyH97EtuZVraXK6K6S0Nl4KMLP9L75opFO2x9toMuj6E7EbfVv24xrC7vAxOofrC7SFKcqW4QczIA4+iZRZIvue9SiXznu+XtjI/N5dQSFkoH7gN5G/iRNXyAhJmu241l+JQTTH0YKj9yJoFz5igvkVfS49LEhn4oswM/fpLKvEQE1Bv4TWVYpBHpPrVrPthjSR3ubI+UW9Qh9KsLu6zXGhflKlcQqv362bPpmIuvTnI42gN66gVAy420qGkV7SjJPE/HHwaCIvkE85GH8c5Xbeqns3L4tHRHdTonQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(376002)(39860400002)(396003)(6506007)(76116006)(2616005)(186003)(36756003)(8936002)(478600001)(5660300002)(83080400001)(71200400001)(83380400001)(966005)(8676002)(4326008)(6486002)(86362001)(66476007)(66556008)(66446008)(33656002)(66946007)(6512007)(91956017)(110136005)(64756008)(316002)(54906003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: tXg5wtfKXt8qJTuzlEG1+6FwI3Ik1DuS6YL0Tf37PdoYy2PR0BIuDRFN2Z3nZ6SpEoT6mlO/VbIzIahM95qHkZMg1oQ6zlqKEaUEgiY7BeO7RbOSPUvdB8aiP+jhHR+W9wMMKVQDgou+wDGqxdNjn9R7BE++g5/NLunFCLKb2sLjtIvxjTbRpZAYCYQpN/Pws1/+X6HVdcZutv/O/JmiwftipTuPyNuLnce7jFPJ5s5rrQHofBil3MOrx6G5VDZ70YYrW/NOuY4/6hfZpgKlE6HSW+fVfT/YY4SY4O2eR3/RvE9pA7sNXyhp58NmnsJ12o08IH/cPOUiXFTZiZx4gcmB3IvWWOnwGfv1ojqkpznM/XOz1KfqCb99HQANzPGxPboPGSFHYSf4pQZnMW+hUolUi5IM61YJidD1427LsuI1AoKWyaX5hB4+aR/CqsMBq4yHc4lcY3smdyfZQWjUkgfGK9NgxWPw9sLGME2ulMlDSsZsVwzCMLv/YcANMCWNho9OntrimX3IsVL9+RLFZ6JM7h7rRlVZCf+UhzzizM1bcg4o1YbklMXFjiIbss9XoB/R8PpCSpWLHiQL3IqxebYbuAaqUyTx27dBRDyNk/UbU1+aaNEXhKaMU/TogvlfAczlFlvoXNHGdQh0iV3UrI7nZwwzLAXLA6a60pYqSY7ffspZNJoEWHdsTIkWtfR4
x-ms-exchange-transport-forked: True
Content-ID: <C58531AD95AB9A4CA83EBECFD901BDCE@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea953d48-84d6-4962-9ac6-08d86c1722aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2020 05:49:49.2769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C0kU6xeebOUDssWxH7jUEVHE6fEPzpO+KSw3vP9wrvo5Srmvd+sAX+GAtplSblZl4AHFkrhuZEYlHePtcrKIcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3208
X-OriginatorOrg: fb.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-09_02:2020-10-09,2020-10-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 impostorscore=0 malwarescore=0 mlxscore=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010090043
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,=20

Please consider pulling the following changes on top of your for-5.10/drive=
rs=20
branch.=20

The main changes are:
1. Bug fixes in bitmap code, from Zhao Heming.
2. Fix a work queue check, from Guoqing Jiang.
3. Fix raid5 oops with reshape, from Song Liu.
4. Clean up unused code, from Jason Yan.

Thanks,
Song


The following changes since commit b6bf0830a808498146903e0e1f407a1eba95019a:

  Merge tag 'nvme-5.10-2020-10-08' of git://git.infradead.org/nvme into for=
-5.10/drivers (2020-10-08 09:07:09 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to b44c018cdf748b96b676ba09fdbc5b34fc443ada:

  md/raid5: fix oops during stripe resizing (2020-10-08 22:38:10 -0700)

----------------------------------------------------------------
Guoqing Jiang (1):
      md: fix the checking of wrong work queue

Jason Yan (1):
      md/raid0: remove unused function is_io_in_chunk_boundary()

Song Liu (1):
      md/raid5: fix oops during stripe resizing

Zhao Heming (3):
      md/bitmap: md_bitmap_read_sb uses wrong bitmap blocks
      md/bitmap: md_bitmap_get_counter returns wrong blocks
      md/bitmap: fix memory leak of temporary bitmap

 drivers/md/md-bitmap.c  |  9 +++++----
 drivers/md/md-cluster.c |  1 +
 drivers/md/md.c         |  2 +-
 drivers/md/raid0.c      | 17 -----------------
 drivers/md/raid5.c      |  4 ++--
 5 files changed, 9 insertions(+), 24 deletions(-)=
