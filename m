Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5777CC2B9F7
	for <linux-raid@archiver.kernel.org>; Wed, 26 May 2021 05:08:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 357926135F
	for <linux-raid@archiver.kernel.org>; Wed, 26 May 2021 05:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhEZFKQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 26 May 2021 01:10:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19042 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229522AbhEZFKO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 26 May 2021 01:10:14 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14Q55Ehj022847;
        Tue, 25 May 2021 22:08:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=JAgCcYHVI7RR2EEmz58TLqE7kIzVFeVzk2B59N3oODw=;
 b=Plx5TaXJHmJq0IMcJZCBLfy5S6vNprN1Yrg0Gu2xqQ3aL4Hf3jVLL1VknSSW7pdFkP1q
 9kHNBFoyafUFSGXgZEBVPSwzUksCmErATlxnDgCuPCepzbQq5foRiQdkzFf2qFJOk25C
 bmi6X0oUfuRKtUDbCZLmrhzKXmcNw6aXECU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 38rqyd7gd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 25 May 2021 22:08:32 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 25 May 2021 22:08:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZJgdVLbmvGDPKYWV9JOSpTOSuTfVeqxb1NWypnaVMFioAfx7BEl0eSb7bqq1wSGR4a7TTFULjamR8ObNrAD0tlpkLErZD4zQWssBVzfgnaPqNCi8csQTV06mJX6M0mK9OeEmkeTNKskiKnj2L+s/9i0hQqJAyiQJPDeBbkYwsdV6/9G8237d+madk4O0S5SRfjD4C0GpMV0bUkMNE1CNOmP5z3DOtBbiNB4Br0gxt6cTYcALHTayUFIunHfgVMNirhXTkh2UnFaV+PZkIsBj794MP8AL7EtIXZ+nb/hiIjkabQd5lvul0EHJQHOJKqlyg3K7p/nsE6q91QGKwegceA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQWFXsWhgIHMFempnbe5NyAOaMm0yzif0uhTUKL8FuY=;
 b=dJ/JjrC9iABaNndwnv66HyIRFLF4Gnq8bTestmHK6aUgDT5afLFMmtqMS6Ci7/HBKIMPawC8TpDvO1IvesP+sbiQkVQwwmQ/0daYAijNFDdVHGzXEqDCBQR93NgFXG8r3FuMiCxCKBh7nTgFJqbXQAo/1BNMS9tgRGZeT5tmUMRGkyr0mnYTBbur8K+Zm1rwGxo7v9OP7SHENMQorrhjr/UZkjCSCGrWYCtCIqB/MuY/CxNmQ/eUXLQB3KNnRlYXKjOGKe+zveF5gxNPzduV5u6PGqAY4KF+ac+g6iXSGAVm23wAAOtv7PO+huMAbw0jsL2tc9JKOR9L598/C7LUdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3413.namprd15.prod.outlook.com (2603:10b6:a03:10b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Wed, 26 May
 2021 05:08:30 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a%5]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 05:08:30 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     Christoph Hellwig <hch@infradead.org>,
        linux-raid <linux-raid@vger.kernel.org>
Subject: [GIT PULL] md-fixes 20210525
Thread-Topic: [GIT PULL] md-fixes 20210525
Thread-Index: AQHXUe0rbPWlGiWu10CQoCv/0l6GoQ==
Date:   Wed, 26 May 2021 05:08:30 +0000
Message-ID: <589AFEE4-EB54-4313-AECF-89208C1DCD63@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.80.0.2.43)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:5350]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17585cf9-f9e2-417c-d8f0-08d920044db0
x-ms-traffictypediagnostic: BYAPR15MB3413:
x-microsoft-antispam-prvs: <BYAPR15MB3413BE5CB7E1EBD6A6603159B3249@BYAPR15MB3413.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XmLZvul9wOQsa8YiG3nIxALuJZ7/OoJ2gxBLCyR+mtVR0rypxPMMGUOBdtvs4mgM/MqupQbOBQzAJ994DDd7XmW5fVQw7iysRgOgvNDHoo0Sistc1r8hX97W/OVNzk/ds47FyC0zR7l1DhJOC/eiPXJ3bgeia+d8Bmoezt9x5RUuFuaoJaGaxM1KF9v38gHh6z1fB5coX7Xxeq6yN+eDpsiegctj8W5M3IZzwTKza9g0scblcEzx7lblQEfLwiN9DoRaHmZNdFA/PZrm84QSETelstTZ+G+szFWiERrXSix5CnAMWKtWMVQPIkfcVB4pyVJn4S2zG75enshdjn8lrBGtIg6fTKpWJhN4A+YPyHlzIAnY+rXx6SOUXN2s7d1zCQBRtkF52qzpfBn4ziJ0TQh6zMvxzMqMN2t2Dkl/G0ciMXASJy4DGca7dC6gh7rsIuoJI0rBGmyTtKpKsqLV8llWD0aag4jsUhcwnATmtKx82cuSNewS7wNHMi7kcJcwD9hdRaiBzLpz8NtpY+ftPVs80QgARxOzyh+ONdytuusqnvX2IvDOAWrYVaNPQmpiadgCgNcrp8yx3YiFkMO7BKJo9TXjNnWL1yxkHsdX1oHfxTGL5HNyC26D/7M1fCL8RAvwhGb0gVi1n/zlVsw4AV6JeOMVihx3uMMYDcnShxSOUPZcB6Tmli75TR0frj63cfoeAX5fMZO0xD9IdCN2b+U5q8FLwmId0m0qTgX13v8NsPYTEssSHVnm2pvR/seqnQB2NWM4XqWkuRI0kurtyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39860400002)(366004)(376002)(71200400001)(186003)(2906002)(76116006)(478600001)(8936002)(6486002)(33656002)(2616005)(966005)(4326008)(4744005)(66446008)(5660300002)(66556008)(64756008)(66476007)(38100700002)(122000001)(83380400001)(66946007)(91956017)(86362001)(36756003)(316002)(6512007)(6506007)(8676002)(54906003)(6916009)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?dMya5H8a7xC8+hOq3zUFJfp/m/HBpeqvQ16cNPryl7KvxUh5sehAm+Fz6IUg?=
 =?us-ascii?Q?yK7dNaFjEeE8A/7M4btgUvb5uhKejAPLweqJrM7zVCoQTNAeT60rvNrwUlFg?=
 =?us-ascii?Q?NEfLInZ5361vinldqJl1FDVlPzY6Mp36C1wW4tUcGPrevH2Nqn99bvmM/VB9?=
 =?us-ascii?Q?WLX8kgEOkYX/J66PcPBuzGZPyNDLBcfhI3NHx8CTM/rtpHEkAmVNmLw5o3Hz?=
 =?us-ascii?Q?0IQVkTKCeEISyXb09FBBFNFNU12hDQmCh0+LmMVDWCpxrvaJcqVxJEmKPsnq?=
 =?us-ascii?Q?wFAEW3HypI4TaD5IokPwvXMSgpUOLaQWlXQ8QtKDPpHCF5yO6+rIc94B0fQu?=
 =?us-ascii?Q?O2hp/cjzn/G5gkX24j59GdUtvXoBx4FK52XRWLusUgUhn3SGcwkUR/RBwaqS?=
 =?us-ascii?Q?8dPWQgqzFkLB+7+ImHPAmypLknTUEygWnrtjmBJWTjvTvWaHMl9PW/RoCQ8O?=
 =?us-ascii?Q?BL8E4KZU8eQkq0bk30U6BRt94MXizjkN1a/eb2bkHs7yHerd3vz0KPx4M302?=
 =?us-ascii?Q?79ifjmJoLZCsFbdvYNFUFV0qMiun/U5yQ4ymCLSA2lcZVrd69L6gUDQ0Hmt9?=
 =?us-ascii?Q?sf6IQlMH4kOG/u5xOg2VtPWcIVvmKxTfb4VkvmBz0TuFrv0lAKDI5QPK1DTj?=
 =?us-ascii?Q?/7o9oyYnGn3NFHcsc5srBiEvcSTeEy0niCyovAB8oxCtkh3OapZn4sOh2teg?=
 =?us-ascii?Q?m+6Xe0AFmk+Gdj0Qb3LyktsP3yNnfqG1rMEt4K58gCCt1kzF+AlonuGQxAAV?=
 =?us-ascii?Q?lNRItTb+BnkgpcG9IWmmwvKWg6wv52UnX+nKr78QPEcusvJMM6jDAHKbm/N8?=
 =?us-ascii?Q?H0h6/AAnfK1PgK1ZiYNAfgC8U7hx17dJduflWZxY85+35RoXlMdmhG7SBysi?=
 =?us-ascii?Q?In9A/Veb71c1X/uhJmJU7IC+P7DgdTuC6+Ce+0Q/QaEWU3r9JrL6PwW+NeY+?=
 =?us-ascii?Q?w+IAfBd9o7xoyG0INk0o53bC8RACyjI0+LA2K246pKDri3xGZvSnYp2IDMQ9?=
 =?us-ascii?Q?t1UbhGkCvaeXtJG7+KkMvCd+pVFi8nO0SJdL63aGKfdcp3JeqHX3nAZsN0Q3?=
 =?us-ascii?Q?Uo8RMx4UKnhwZHF26rGF0ae0pkmyuWegFPXLyCXEswIT97wpFgAvsIyZ3L4H?=
 =?us-ascii?Q?ZlWIZZKALXtcanRvfdX7a7zTZQ+x7jSZ6zMOqsyNR89ut/8uPVcpWaJ0lDSQ?=
 =?us-ascii?Q?KZ0p4mMFXK3bvYVdRyKWhdNRPUxwWJd4hfG308LoeHfjv8IIttVpcEk85yYX?=
 =?us-ascii?Q?MjIV4yXAG8ivGNGZZEJKn6jTIQoKfFTuiVYLIABliCy+fDjWurDLvCOsJT3R?=
 =?us-ascii?Q?XnWbkPzHL2RbyvhDP/UmrQgZGAepaTL+ztBPLj136TkDLfzJOgFXEd7p0Hx9?=
 =?us-ascii?Q?EW6SS00=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F2D4448FBE546042A523E54287FB0FEA@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17585cf9-f9e2-417c-d8f0-08d920044db0
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2021 05:08:30.2840
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wJvAzxcpUqXtkZpGi9W/S2pGN+kdgKzCw31cbTFZkPpzYFwHNyFbF+7JUJKX0GmvFycp3Gb+OC9RUjY4K8d96g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3413
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: gT3BV_RoDJqvxSMofmElSNOw97YKi_Vj
X-Proofpoint-ORIG-GUID: gT3BV_RoDJqvxSMofmElSNOw97YKi_Vj
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-26_02:2021-05-25,2021-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 adultscore=0 mlxlogscore=990 spamscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105260033
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,=20

Please consider pulling the following fix on top of your block-5.13 branch.
The fix removes a bad WARN_ON_ONCE().=20

Thanks,
Song



The following changes since commit bc6a385132601c29a6da1dbf8148c0d3c9ad36dc:

  block: fix a race between del_gendisk and BLKRRPART (2021-05-20 07:59:35 =
-0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes

for you to fetch changes up to cc146267914950b12c2bdee68c1e9e5453c81cde:

  md/raid5: remove an incorrect assert in in_chunk_boundary (2021-05-25 18:=
03:15 -0700)

----------------------------------------------------------------
Christoph Hellwig (1):
      md/raid5: remove an incorrect assert in in_chunk_boundary

 drivers/md/raid5.c | 2 --
 1 file changed, 2 deletions(-)=
