Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14C1C6FD1D
	for <linux-raid@archiver.kernel.org>; Wed, 15 Mar 2023 18:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjCOSE0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Mar 2023 14:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjCOSEY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Mar 2023 14:04:24 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425CD22031
        for <linux-raid@vger.kernel.org>; Wed, 15 Mar 2023 11:04:22 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 32FH0oPa018223
        for <linux-raid@vger.kernel.org>; Wed, 15 Mar 2023 11:04:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : subject :
 date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=TrmdC7vIFpWJyCrCtLeR2XxnHUnFelr14fzQ5zyzElc=;
 b=l0IDjZ9JU8j97ppSIYc7mVuJojADdCPUaiEvtgedksxfNoezFEgkTMf34ufrkwVWydQV
 p1Rm5lVoRMeVvlqcClSFBzfW6Vr+V5dACu1WTnq1DGkzAGr0q+OMQZrGcogdTcvvLvCl
 alnKlHF/xgvzkMhtZzc0ZprDr12isVq7a59i6qO42pRasd8HC60kpI5as+G6IsY8Xv6X
 4tpcLOpzjHuX0sDlpw6o6caV4zDlBGHSxPloFksCFcJznpAHUfYfdCKbS8dfQw1UowrB
 aPqaPIY+6Efs8SQZVYbH4QqXz6ujLqGGdZCFpjGtEjIstr+y2zJfJcxwOmo5S0K8FTKz pQ== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by m0001303.ppops.net (PPS) with ESMTPS id 3pb2bu5yp9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Wed, 15 Mar 2023 11:04:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=enHwv7lys8M+xER8lJAta4pC9uurrdqF/98In2+iy1ctVqG+VsEi4DS8nkd8U+AQXLhl8kgqXy3zVupiOhV9p+BNsfqpdkVzk0oX9UYR3vL7TFzzQLKBatMQ3MF3no889WCPOJKGH7rBM6porBM3vBJnwYsANaJMhvQiNyJF7r1kCo2pfds/I+huV2geUgZODsYEl0y5hUp3KAH9oKt5RfejlUtjHkOhrTTbU34ZAzvBFkszeH86uxG7QiauEf5opgddVUKoX0a6iTfomKxdg1X3BKCfEMaCswL73owx1+llf9XdjLLe50NT+EksImj9PmP3mYrmZzyZGyroDAReYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TrmdC7vIFpWJyCrCtLeR2XxnHUnFelr14fzQ5zyzElc=;
 b=lvuF6ZsOrEO6xeSbPqfrKPSDJWFPzOIYilhdLrAiGpA0+yiM7YzLY7MUUyObbPzN53klYpomaUFZCpTt1gfBRIX7mUmT6wICZcQcDR3zH10O1UMzPWLEoaBwzw/xGRhXZ1rQXuaCmPO/iqB+QnQtlCE+duhezLpc2qCbJFtmjTxTCVu4BuYCzsJwZvVDigpr7Pb/ba4R66Z+UgSW6uVb0zkmn8uJtiKf3Ygw1GqcpKahdlRdrG5bIhndWI2L/C/YW556jdwUAvtDANQ6lGoBvSrnj4FHsmDKsUL3Hxgs004aqpBNO8DZ2bx414NBOayBOHGBWTWjpWYNty2J5jXFkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MW3PR15MB3868.namprd15.prod.outlook.com (2603:10b6:303:40::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 18:04:18 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::95a1:140b:9c44:f86d]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::95a1:140b:9c44:f86d%4]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 18:04:18 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
Subject: [GIT PULL] md-fixes 20230315
Thread-Topic: [GIT PULL] md-fixes 20230315
Thread-Index: AQHZV2iPgTc2vYQvm02PnNsjxVRo9w==
Date:   Wed, 15 Mar 2023 18:04:18 +0000
Message-ID: <ECA01A7B-4737-45A7-B853-2A41069173F7@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.400.51.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|MW3PR15MB3868:EE_
x-ms-office365-filtering-correlation-id: fa3be3d2-246a-4866-3a2b-08db257fb22e
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HHE1VaNWYYt568O/hrrrGz2N8os7w5HRdAmr3nQNrRi8ks5DCwYMZ3GM+/cC9V6GrH7YtAw4sCHHsA1btDCb0SSYfN2vHD7jfNMfi7G5mQM0yzADNyJAz0X0NdJXv2I8VIKOFXgDCyXd81ltUK0zfJ4wuBWKIeo6SEQd5EXvCriODWhci/n/o120WwTQqn88/+TRyzABQ0sPInhgsoOkIU2DLAI5hC65KKJH4SFceI045Ksjj38+BQCHSdd7E2CpAh2vDmycVNT4bprJoFGcmgyW7CCAwyQKnUFZwR1+nF7cDjV5fX0UkFL1viVsFlOR+/Dvu6PmPkEBajqdLqWXzaLw82F/hqJZuS3KNCPWnUsesD48MwFr8DkZn+ip+c94DyGpPB2r7SLH0/Y0PfwP5MKrhtJLH4gDGoMzrE5WJ8pmFB0cGAl+edUsfRcpU1BSnHVxqVMHVDIxCGJ/+ZMCuUDrmWoV4P85CWCtatfmU8jWsrC4M7iPWu5p2harDOzp3yGLhrnh8Kl53A7AmLUvvsLROrwyG/a7adl/BtGi5mrYYkMnWW1d836OgM15Vquaa7c2ubD0Rdg4bl6t5qrDSs1FGsnNZ2i9Ne/Wkb+QeF69X4wCebToSHKDiJCwgSO4YaqNP1CFDgcGCIJ936b/4w8+1alf1vVRsIhQnSqb7P8WDEAvv+9YaTtw1Yskmbad
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(451199018)(8936002)(4744005)(5660300002)(41300700001)(33656002)(86362001)(36756003)(38070700005)(122000001)(38100700002)(2906002)(6512007)(6506007)(9686003)(478600001)(83380400001)(186003)(6486002)(966005)(8676002)(71200400001)(64756008)(66556008)(66476007)(66446008)(66946007)(76116006)(91956017)(110136005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CjgP2iBG+SdoHCM2Kd+p4Z3Y4aw6arEkOnfz/tH/YpACPrhUJq+ACviNOHmY?=
 =?us-ascii?Q?vmoXEW7IVNtY+3fkOQgkuxh/jnhqM5vTwc/LLWxN/RV+IE3gZIIM9v0k1YCo?=
 =?us-ascii?Q?4ZdWuwTee3bGzLcyvV6+EbVby+bDLjZxYk/qmOJ0zF80FEpToefnZkoJ85uu?=
 =?us-ascii?Q?pNGX7rxi9oHAYhq/1UjeDdT7dsfOJ/lvf4L+AFyNotsk2CT9G0lK0BRsR1Co?=
 =?us-ascii?Q?nGiyiw9EEkGSSShkCbv0vVBnGZkXhzCGuv5EA0OawW2Zbj5TIRZ+KxJieCGH?=
 =?us-ascii?Q?2bq8T7fi5jf6iEihP84jeaEKMtZReUgsU7kXc8QwZ6OfWKgl988/45JQbdxh?=
 =?us-ascii?Q?NcdMBji7rFh/b+op2n996ePdC4Fr22hlmgHJmm0jJG2sIaV/43snbJpyW4Lx?=
 =?us-ascii?Q?fxtEms/ph3pjiFTcj+U1AvHOAEGutYaYISrYqUnhUVfI+yT//FaJcX5HHGZG?=
 =?us-ascii?Q?ZM7oH51eAHzAa7HAMJ3a9Cl/Ud2Zbs28mUBfV136a6s6RiwoGN+L3fVRLp+3?=
 =?us-ascii?Q?nAYM2put3weP+2hnrs/3ymtBKTiACF1xgdkNcKIqErhiLMbLgxC27h16xVIP?=
 =?us-ascii?Q?OKbQ2Vj3QYr0/+9l5L9aTmejjWruGnWf2EQQ9G0v9gpMjCUyEYhU0TtzPYWr?=
 =?us-ascii?Q?xrZJxqKAKoCdya1vuKZqDuxL69qVzQopgLc/MM81kmGmwO1bKmBsAf9eGNgJ?=
 =?us-ascii?Q?b8T5Z4iGjETdDFYinlLqSxNyvnaB6gO0UovTvhriMLSdnrtKwozjPEOyf1la?=
 =?us-ascii?Q?LgbQr9f/Od9rlzQb+T9sR756kKZVXe0LraQHJAunRCWhf1bQ8wxGUAEU4zzR?=
 =?us-ascii?Q?jN4VsORGxaCgJB2ArQrZZbCbaafnuRdpLdU4+2sUSH9tObMyvDW6JzIFW0Fy?=
 =?us-ascii?Q?oKf/CyyuqvczRRCKt9S2I+E0K2+tCghquazYdHdTCLOlDhDkqZjX1T2a44Zi?=
 =?us-ascii?Q?+EDQjO2BHIMa2qWGx+tqvDMh3WCQo79ApD18762/2hbcu+aadgvg2qjqbPPY?=
 =?us-ascii?Q?lgQk08pjJPXZIBqfLiCkMjZf2wBjDhqcT+Fw0yIH1J6MrzjqMmNvshe5JUpu?=
 =?us-ascii?Q?ONp8Tr2nxxFktTpwDzLsvr+QlUJf1HszZXk3MMvdt2gxaBA8WYitWrHOVI04?=
 =?us-ascii?Q?yWA15E00gBL33Eq9fl+uLmu3KfSBWA0xM5d0AH4kwsPJoNRYELEE1jAuBOUY?=
 =?us-ascii?Q?ltHS/tSJC3wpe19gcmisTF85Hi0WJgKrHX2BYaRBs55iQWbuMgkjt+1fDZnn?=
 =?us-ascii?Q?8gFx+40NiXPynBJBJTmVbsHQvSDSd/ql0ytaw4O4jYWnlTrHOxGuBsGWTT0i?=
 =?us-ascii?Q?1PVCZ+JiqY+TNCmQC2FyLyfX+8Mm/FVW8DZ7ThCvJXzHrZjFN2cjmeaofeNT?=
 =?us-ascii?Q?R6qQOSm0aVjDaAIfqornNWgCb0eWoj+O0wGmgjJqhDCQNdHOGEQlSds0OOUZ?=
 =?us-ascii?Q?naKWszOyS6ZraM015U2shIW+Km8SRbU2s1IuppFpHRhUBAQu7zBpO64qT2f/?=
 =?us-ascii?Q?cVaeL3FHN7MkS9/rbracWCt4tvk5WDjENMUiKcm1g+yhH7JxDye6zjtet1q2?=
 =?us-ascii?Q?c0j3zWmWIRHg6ZLzcMHDfX9g9HRD4xlDEhDZxoiedXnYZSL8gqlS4MCWN8Eu?=
 =?us-ascii?Q?oUlNKRri8qkh7drpFJ72ftFdGMOQHskpSY74YjzsqdOu?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <94464D82F18E4D49B5EF165667313BA7@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa3be3d2-246a-4866-3a2b-08db257fb22e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 18:04:18.3349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rrApGgJKJ35cDPSw5JrG0zawUn0q4KPfnS9g8pDSmjGDvbIko1F+rGXtZ+SuaRkrmSgA0UKmwUCUN81A6P1OQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3868
X-Proofpoint-ORIG-GUID: -_ubuMnfal1Nhbmelno111As71xCzTLo
X-Proofpoint-GUID: -_ubuMnfal1Nhbmelno111As71xCzTLo
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_10,2023-03-15_01,2023-02-09_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,

Please consider pulling the following fixes on top of your for-6.3/block
branch. This set contains two fixes for old issues (by Neil) and one fix
for 6.3 (by Xiao). 

Thanks,
Song


The following changes since commit 49d24398327e32265eccdeec4baeb5a6a609c0bd:

  blk-mq: enforce op-specific segment limits in blk_insert_cloned_request (2023-03-02 21:00:20 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes

for you to fetch changes up to f6bb5176318186880ff2f16ad65f519b70f04686:

  Subject: md: select BLOCK_LEGACY_AUTOLOAD (2023-03-13 13:34:29 -0700)

----------------------------------------------------------------
NeilBrown (2):
      md: avoid signed overflow in slot_store()
      Subject: md: select BLOCK_LEGACY_AUTOLOAD

Xiao Ni (1):
      md: Free resources in __md_stop

 drivers/md/Kconfig |  4 ++++
 drivers/md/md.c    | 17 ++++++++---------
 2 files changed, 12 insertions(+), 9 deletions(-)
