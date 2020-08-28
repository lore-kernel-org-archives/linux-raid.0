Return-Path: <SRS0=wQ6l=CG=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5959AC433E2
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 05:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17BC3208CA
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 05:49:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="FIIhklvC";
	dkim=pass (1024-bit key) header.d=fb.onmicrosoft.com header.i=@fb.onmicrosoft.com header.b="NnKQwItE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgH1FtR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Aug 2020 01:49:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37612 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725858AbgH1FtQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 28 Aug 2020 01:49:16 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07S5ikiw012979;
        Thu, 27 Aug 2020 22:48:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=N6VllCC9Uh1aXcqwvAq6dgxabedZaHHJUzsmU/zkLe4=;
 b=FIIhklvCw+z4vxAg2/K7H4DLNLDQBUcZHnwmerh4makSDCNMBdc2cq2qoHWOYmQtB1xd
 UG8qWX/yu2CknPKypRq7ON3uwbMSeqUm1VQdqUvOUzU+QUY/R0xKcIMDqMrmmhiuGlub
 FJ7FQvaAEWx6Xfw6uASpJmMt/HHm2p5BHW8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 335up89cm2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 27 Aug 2020 22:48:30 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 27 Aug 2020 22:48:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VwkYBsQo/CjLWqpeu31K4Z289xcZsSUCOQVfeZLv51itzUshy6HpkiHvXztKToPKs9yo3tZvHv9sCThNN+dWhBCsvedWVNDhjDKoAWnS6jEqVPXu0VQrsybmjHv6wVRZhBCvEXQbSkwkI4hE64+1kZ+Y6h14j7Gj74QfJcwj/zYu1p6gf8hGig4dlKu64ahOwJZ3TYdoR3U4nRO+1e50QbDTHS1FJve8qZJw2LNLBRs49VUZJFJjMymZO4Gv2pXX6AqETsCvvC0dbOLm1n/6owTUwLwXEhsi+VHB2o2m97dYSkQu+i1HYsf5R1RKSD1uc6yvs7nOrw/IgJOJyL5pgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N6VllCC9Uh1aXcqwvAq6dgxabedZaHHJUzsmU/zkLe4=;
 b=DyQ4W5yI0dbtkU4u86cf54c5AgrepbtWyuOBmZ8462F6pl8pcUtJO59IWO+bieUfUUiZDxH0j6oJDZf+NXSC88BVGJ22WgwS5PL2u9nCfpOv0OU1a6JeFYv4luqejbmfGbn0J0/TtXvhqcEB664VTnx6HAbRvhBsbXoyzvw06wNc6FdWqUSdfn6KgSKigOu4R416U4HDytFAK0/4lGVArKdhyHqpLyoAgt5kmT6nKqRAKT45bzw7NpogtsMtRGLo77eeHCuWmOr2kpcv9SX7U6z0VWEHvQgWbzbIznWBhVspi7efSTxrGOD2TO6D1v8XUHHFgivBfhLo3qiV7CjKVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N6VllCC9Uh1aXcqwvAq6dgxabedZaHHJUzsmU/zkLe4=;
 b=NnKQwItEapmstVbUjYm7aJY6Bq0jhmDy0VEjH5TDtQu308l7Yl6TF8Mqtz3yHrEyiYgOJyVxMvr2y1Y54zUSPYSP3qMOGWwwFpZSRpuU2V1bu6iWlAqylnJMn64hpYGgphX1a4ZCEjHQzCEeyyKb//Yp6btxxyyrtF4bBKmFPV4=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.21; Fri, 28 Aug
 2020 05:48:14 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3326.023; Fri, 28 Aug 2020
 05:48:14 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Yufen Yu <yuyufen@huawei.com>
Subject: [GIT PULL] md-fixes 20200828
Thread-Topic: [GIT PULL] md-fixes 20200828
Thread-Index: AQHWfP7RrnvxlRJQ/0qbP8SvopSutA==
Date:   Fri, 28 Aug 2020 05:48:13 +0000
Message-ID: <D8061404-18E3-401D-8FBB-749F4C6DDAA4@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:858a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2cff6471-310d-4886-64d8-08d84b15f472
x-ms-traffictypediagnostic: BY5PR15MB3571:
x-microsoft-antispam-prvs: <BY5PR15MB35716DEA47DD82F2BE2A8F67B3520@BY5PR15MB3571.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P1fIuikgIzyABw5BMzatL1cnF0d+bmuWJ6HNOxTqM5YMEVettufV/XyPR2JMvIp5fvjAnQl8lINmPAtl7KBnq1uh5F0WWiP4sFfCuvHvXI+7WgqNIvN1aJchIrR6UKuzXZ4foaWah4aHAX4n+BRwnOd/em299Bx1NyYQhnBZuRm6zHwcSMAl6Rg8Oc47J0OmCcYseLjOPsAnrEwmrEfXZb+YkzBA6g0Pk3t4hBFOtd6MJTDS6tppzeRUXUpY9xlVHRu/oG/4LMTczoMLZtEL+4N5T6H2OAEwrHMAa/E/g+ThV34BE4zhMFwVZRQom9wF0wjmPrUDmLwzDg9gdJRNPKnACVCqAdGYUxUz1v61TFUGQwzR8MBoEillaxt1s8XQii0/wNprAsHKbP7ubQWWKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(376002)(39860400002)(366004)(4326008)(8936002)(33656002)(6512007)(316002)(6486002)(8676002)(478600001)(36756003)(5660300002)(966005)(71200400001)(110136005)(64756008)(86362001)(83380400001)(4744005)(6506007)(186003)(2616005)(66946007)(66446008)(76116006)(66476007)(2906002)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: tUmhOxPWZdVMPJtmKYiJmJsZ19E0BTwCLli5s0+eY9i3aK1sd58dXT6dC+FnecxAGvFbISBFv+xKZJPuZWvPrvq4LYbwpyo7Otchs/qUc6hIGzhW9Pdt8AfDfl222dwyDPhVsnedFm7KjTim0Ijl16PQWyxlvokNLCvN1tx99Mr023K7KfAcIhCdcwQF4HldVeYblcAM/lzu/6xbLOY1qDCCiIvTzm4CGteD3BYSVUyrNXmPBvEn61Q7bU3fnfL5TwrsA1/9cyZx5ylI4BuO21bgpMRPeXIll2b/Y61UDT/ekGJWYUxiYEv0Aejyy5Xl74ZQnRwbPLpC6tTKYJtGmTIN5CPO9NJSsS2/VVklKMjnEK2hEgoDF2bBPymrfy9UtjKpmwI8PFHtpKi+nKmBVr5hY3ZBNebyG5kbsHogsdirr7gm9RtQWJWgfQX6mq8HyuDXfGecbGyYmbrYQF411rbldLjK3An0xI8tIZwjYGN2+JP8BQxEKlLnVmi1cY0QoPfnalVTJC/3dIXa/pcwDeL5EbfJbwwA3hUa6i+LU0qvRezr261mxVnE461yNp0G2V9+s6yoDX3ymZrRyXyVnGr29HuZjeuk7cvpGn/XE7pdJ0aRPQLP60ztA76EpEubPdvAUnz2de9//R7opbCnnME7YDpNtxTEb8d1zw7VvO0VYVkdyiZXLiXcV/TjDcIG
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <294E7CC21C28134C8A9619CCC0AC3CF4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cff6471-310d-4886-64d8-08d84b15f472
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2020 05:48:13.9349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bl/k+ci6xpr+00P4mi5YUiiEk7kJTVGSj23OR+Lo2OUVMsJavJccGsI4lwx6IuBrKd2WAyNN93yRCgy78mr70Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3571
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-28_03:2020-08-27,2020-08-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 spamscore=0 impostorscore=0
 clxscore=1011 phishscore=0 priorityscore=1501 mlxscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280047
X-FB-Internal: deliver
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,=20

Please consider pulling the following fix on top of your block-5.9 branch.=
=20

Thanks,
Song


The following changes since commit 79e5dc59e2974a48764269fa9ff544ae8ffe3338=
:

  loop: Set correct device size when using LOOP_CONFIGURE (2020-08-26 09:30=
:31 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes

for you to fetch changes up to 6af10a33c501b0b5878476501143c2cfbbfd63a2:

  md/raid5: make sure stripe_size as power of two (2020-08-27 22:41:03 -070=
0)

----------------------------------------------------------------
Yufen Yu (1):
      md/raid5: make sure stripe_size as power of two

 drivers/md/raid5.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)=
