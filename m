Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7504BC432BE
	for <linux-raid@archiver.kernel.org>; Thu, 26 Aug 2021 01:11:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D2BD6103C
	for <linux-raid@archiver.kernel.org>; Thu, 26 Aug 2021 01:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235726AbhHZBMS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 25 Aug 2021 21:12:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7446 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235172AbhHZBMS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 25 Aug 2021 21:12:18 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17Q16FoI019010
        for <linux-raid@vger.kernel.org>; Wed, 25 Aug 2021 18:11:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id : mime-version;
 s=facebook; bh=u5ni8Oqfyxn1XAhEKA9eJleu0sQqb3DmUZFVQBkSLvk=;
 b=QijuW3ZIyS0vQawrnX38YJtsuh/rS5xXdjwTDJHvNYF1Tm62b/ALbMCpN3tUGXqfkwpX
 +AE6cbuWLi2pbDidsuDno45nqKNxN4+PUJQ4IX5LkIfEuzO2dM/nQo6xURD14K7R7Q7e
 G1hMYLrOowWhVXBFvzF8omfoeDNi5C38fo4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3anmjbn2jb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-raid@vger.kernel.org>; Wed, 25 Aug 2021 18:11:31 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 25 Aug 2021 18:11:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QhEcdoSftMAPQ0IMGDjNUhC6/BVd/41RgPSItqcQaDMaIHZu9NQraLLcC5c0K8Q34PMlnj1Jnc5QJq/blW27+/QbgWRzR5p6dr+MDqjblzlJr+PyrG7HROwBApQ96dFtvtedUBz+QKuU7U+T8CvyuRuSYz0DSOW41XPYX5VT9XMZtBnWvvHbyQzEekn+jd9D7PfaxsOJAURyBKEnBJtzDZylWtYQ4slWwk54ytEDFdNsW273sLF38aT5Wk7/nbsA+659702jhgQn7EZPx6eaoUWOk9Pr6TQLEI/0zfNMGm3aWlpupwLkGJhsM+aEb8pDNCWWW2C4+jqUA8n5FuIqqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u5ni8Oqfyxn1XAhEKA9eJleu0sQqb3DmUZFVQBkSLvk=;
 b=IJLt3ttU8VfwLgM5xQ8QdUh/INS+ITz/c5mzSyFkbN2XqM+UZyW049mDrJ1clzTEURC+4oNXj6VJc+L6H4PRnChSInSeUtb6l6Y+SMs8VEGJS4B1LLuB5Ur5GsxMpsrbL73T+jdbgr6UtiaLDpbdzGiAFPYFjAmmdmokS/xzLMS4sO4RAMA2Fx4Kgyp94QCRL7DO24R6OHc+9nZ0UCgr3+VV8qU/7qn/67WykCVuHkdUz0Ah+fHlJQ0lu6SrFi0U81oz7KNYLzNM5Qy/7GixLJmVZhzHiVUEjlCVW/YB4VF+MZh5ng52w64jaLga3zQLGuhtHYauc5ypHIifOZhd7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5096.namprd15.prod.outlook.com (2603:10b6:806:1df::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19; Thu, 26 Aug
 2021 01:11:29 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1959:3036:1185:a610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1959:3036:1185:a610%4]) with mapi id 15.20.4436.025; Thu, 26 Aug 2021
 01:11:29 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Xiao Ni <xni@redhat.com>
Subject: [GIT PULL] md-fixes 20210825
Thread-Topic: [GIT PULL] md-fixes 20210825
Thread-Index: AQHXmhdMJYUZWvmlt0a/PZcrJG5rww==
Date:   Thu, 26 Aug 2021 01:11:29 +0000
Message-ID: <9E359DE1-AFC6-4D46-97C3-C8490D051B6E@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c529748e-b2e9-4c29-6e9a-08d9682e6f2d
x-ms-traffictypediagnostic: SA1PR15MB5096:
x-microsoft-antispam-prvs: <SA1PR15MB50966478079351753FEE2994B3C79@SA1PR15MB5096.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nK+84wRnZP4eFrAHNassSDQWoNZ2fZM2XS2xAVrkC7is2qANxWFri6D4Gw+sHl949zono2b15JLPo7E6sgJipknZMmwMsSHPO40pnfkZM51p5f0F7dbkI+GOD8Dh0x/KFcLlP2fezXUKfl7KlWutdW/7w17jHsm2ptSsFKYTzEwLrUzQEGsbDwHUNxoMDn3NttiTrNPetO+AW3HdLOev58b16n5JuSsZBxKWc0duM2cb1bIFWg4IVVPbSHhtTCY1btUgEcI0RdotUTtIubdN4Etq1z6rZOvltECX1BEh/VAImLQnjMmn/yRgVUjG3IoSZZtHjDIyMs+Ix6ycF+8bI8LUEbqQVjyLnCoGLaa2g6qsxDIm0FUU/of3gUOrqiwqYsKFf0UFly3X8Q0KfA1kqOVfdbIv630D5IgFt6ZscrPtp5NBr29SVfjCmocZR2xekHSjqme0kfQmLCLFRuhTAu5fMUxSByzSupJjtTynx4ls4gg3iLyHTEemB1JdEnYcJ128XXvHoR/bNtGVQa52IQfqC+9ewsEO1z2CeRohmFkJ2OUIiaCnm3qd0f5fdQMQs3MG9TxcjbvVxtwJjdF4BJGgIczOqrLyBMh5bOxu57X9K8JjJJqwZB2/bWIi+PQR9wHRncANfC6y7tDxxOnKEZK7irb5CiqGn9/n9lr8Dji52blWDXmeqj3pHBOoG8329JmyW5ISimmAMHbD/a+NIuWgnWS8vDA/so8cXTcz+Oe1Lai8MDqC8M9eYw+/M71eY+06KUmgfw5vI8RXINyyjz9ySFPUEhxv00NTFwd0D/EZQ9KHoTUPMPG/FA0ElviG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(39860400002)(366004)(396003)(966005)(86362001)(6506007)(6486002)(6512007)(186003)(33656002)(110136005)(316002)(83380400001)(36756003)(5660300002)(71200400001)(66446008)(38070700005)(8936002)(38100700002)(76116006)(66556008)(122000001)(66476007)(4744005)(66946007)(91956017)(478600001)(8676002)(4326008)(2906002)(64756008)(2616005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?O2mUYpAFU7EpqkjcLj925vRAdNRgb3X/A9jZiLHf7o1F4Ux1YHPpoe6zgcgR?=
 =?us-ascii?Q?HbE1zkNP70AOIOwqzlZP6tTeBwXkOaQG729rb1CgsWHR3TIP4uyraJ2p433k?=
 =?us-ascii?Q?lBbKVDP46z+LKKmkfxml0PBldzK7vLzSDwx2c5sVJ1AxHigSo8EuWSWcuoSP?=
 =?us-ascii?Q?MmRxS3+QLF5GuUdz1ENeuRyhCEbnb8aE+/PuQv6iQDRKd2E51rsgGc3xR9Zg?=
 =?us-ascii?Q?aypkVMyKfJiXamhR1Ti8iR/l8aHoeoivn4Vock5/DcgHWeLvY/5V3KSqv8ce?=
 =?us-ascii?Q?P0j4RiT5IpNnqiBlbBxv6LnftrWjlDcI5uVppmb70QVOgSZ8lxBasASn3TqI?=
 =?us-ascii?Q?cNQbAl7fU9IKnwygcEDLwWg/LJleBn89TRZHRQfg2LXs6OXNZXn4kkF4/pYh?=
 =?us-ascii?Q?Z5aAmMLw27al/t2WSfIghP+lFJNfmrHMdXtmEnNRw9hcZIyQ2KOPl2azeU1e?=
 =?us-ascii?Q?7TrgseT+Tj50c7aopFtYsPwNmJ3jXaNQNLzKGlDSGTivXZ07iY5WjhoCXU3b?=
 =?us-ascii?Q?nCPN4oQawvWfWpyLnqwcnAB7H0yvxY3u5OTECBstzZXUI9Tbx1pWxLndzQbx?=
 =?us-ascii?Q?lRdQh0LRCqH8z5U7/B3yPef/HHFXiUpWNR8lZtpI2m9q3UxWofxgue9xwl1R?=
 =?us-ascii?Q?1sb0ABaH4lnrnr2jwUd5eWtshhwIlEb3CiZ3HOQfP/Oq6t5LR2WFkCXFmSAL?=
 =?us-ascii?Q?vVWWvgMDW14Ac9qoZu9dTx5b58vj+O9iHdVOwuXLfhR5HndiJZMv/KBAWm2z?=
 =?us-ascii?Q?r6eLNGfTJpHpCzwio4FP3ujSMxUWpiYhU/iP3kgc74e7c1NcxH27/h/ah/Tj?=
 =?us-ascii?Q?rBMOHLelSVWtkizG+BaJIwBdTJxFDgn21NY/34OpHF5+smKTseG8itsgPxWh?=
 =?us-ascii?Q?n7FBb7rEYDsSyoadamgOvjaCAYx+XCi+jmz8+gKnSst6ZhwRyYPhOuV6Ft7J?=
 =?us-ascii?Q?J5HG/yQWBWZGwYi2c/zqvAoT71Nh3NCejIreoA9ed9vtaMIJWLNTWiELSs1r?=
 =?us-ascii?Q?Vm7YyIVksH9syuiLZIujD25pNpjcGgONm3ZhMCMgm5QDXsRt2tBsaXbRO/FH?=
 =?us-ascii?Q?3WXCpg5Kjn/H+GhZpXz4qtS6Oc9lX/x1tei9YQDRZws7HQBPbD3iLzXi0l1s?=
 =?us-ascii?Q?sey1PXTqej0y8iCUspE8e+xp0oSoKGzsOX7QOvUsfucsO/21/6QlFQ08z9q2?=
 =?us-ascii?Q?g+znERSqiQ9u4CLHhfwGzcb6eYy1gsiT63X0V3+kmHGiBXAhV3LxRvxRsvBE?=
 =?us-ascii?Q?e+1msxi9EG/QJY44sda1dZpGogtcUTK3WKWjQPDgLtwbLOxuPAiXTdjDC9wA?=
 =?us-ascii?Q?DTfDFUl15iYnLbOESIcb2p4a/I4/KRmRDp9nKpHppM2fm+NXtYSHr+yLNNyZ?=
 =?us-ascii?Q?ll+0Di4=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <ABABCF83CAE23E44BFDDC21F0BD6B221@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c529748e-b2e9-4c29-6e9a-08d9682e6f2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 01:11:29.1608
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: soNLgSc0P/zr56xJc6a5r8l+vmTv0nxmzXNm7GEHclQ2phidYmc5ISa0HVdUrwv88YoE6YZnlvvOCkpI32d2Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5096
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: hfqSWZu4dAiWvnkIOoMhWfCNjZzAm5Wf
X-Proofpoint-ORIG-GUID: hfqSWZu4dAiWvnkIOoMhWfCNjZzAm5Wf
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-25_09:2021-08-25,2021-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxscore=0 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108260006
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following fix for raid10 on top of your block-5.14
branch. 

Thanks,
Song


The following changes since commit b6d2b054e8baaee53fd2d4854c63cbf0f2c6262a:

  mq-deadline: Fix request accounting (2021-08-24 16:18:01 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes

for you to fetch changes up to 9cd81ffa6546bea41d67008d4b4e0bcdad2bd5bf:

  md/raid10: Remove unnecessary rcu_dereference in raid10_handle_discard (2021-08-25 18:05:33 -0700)

----------------------------------------------------------------
Xiao Ni (1):
      md/raid10: Remove unnecessary rcu_dereference in raid10_handle_discard

 drivers/md/raid10.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)
