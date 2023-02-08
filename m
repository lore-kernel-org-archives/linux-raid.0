Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0D97C636D4
	for <linux-raid@archiver.kernel.org>; Wed,  8 Feb 2023 23:54:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbjBHXyK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Feb 2023 18:54:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjBHXyI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Feb 2023 18:54:08 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E841F4AE
        for <linux-raid@vger.kernel.org>; Wed,  8 Feb 2023 15:54:04 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 318JV1fx020449
        for <linux-raid@vger.kernel.org>; Wed, 8 Feb 2023 15:54:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=fEZrT8g1XYZrcdYOVg+kjp2+P4fAe7JC9F5MKT49xzI=;
 b=YAQTvXgeHTIfJ2TdkpHVjUwCht7bndOX+aGubBlFIDUq/jhvaW839vP2Y5w7G3o1ldx2
 aZpfM+Gfin+vn2QyuPmE6NkiOdduWB/y4w3G1xIpjwNMSEAALnesq1GP+8ROxvD8+0nz
 nrXla+cJod+/Akypy3mzMegpeOxaYUkAKkYH98Lyj9IIqCL/cOll8RnBP7nerFhrQ29I
 J2gxKsuTM8XulydF5gRbxB72bpETh+OrOre7WCEcx7JyZ8uM0I2817O+CIznipHdFAUO
 nAsenP6TA52emLE0qbPGM50H6H+WEtJOJvLUQY3N8xX6r+7FDzLt/ICRdsjexVWf8mEY 7Q== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3nkvsba1ww-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Wed, 08 Feb 2023 15:54:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dbIoqJ79kQx3eLis8xe8PKljlSN2PeS2+0VInVI2DyhIJST5F+kuKfPndkwe22tdvqKeklZLMmb1ZDVJp1z7YH7BMOvSasCGSEb5onrtqdOK5XpczaEK9VCkNNW5sishVreNHGrvjo0vCpBSB1fQYDLbk7+xX2VPgSQETepiRVf539JjmwkUMWbo+UI9MPJ7F04X0GAug0eydV+Zs7LKWSgR/PMVf2U6zsrbST0uJ9kbUKzpj7YK5HGQ3+Qw7Fknxs1AwpMZo1jdJTBUIvF1OwtCNr0pzefm+39CaWac10mq9b6M9VUNxKIK1OeLdWe7DqImPwEIEWZ8LsEN6OnVYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fEZrT8g1XYZrcdYOVg+kjp2+P4fAe7JC9F5MKT49xzI=;
 b=JxmqzQActSTPVy0AmIKCZxnXJoFPiuQcwo9ZOJC/QGqdK8Mx/p0ovYUeONss7BkyvxDMMWSiwdZ8pcUDfmUGckyo8caojXcAGr8gjnuTBowQw2iUdv1U8zG3osjM9ahV9DWCLk4lyvr9j/eFwmefQ36XH14Lj6WiXWR0dIjPV9W4Qe3P+7lVcyduxxY29UzJ7NpGp4U9fdCWdUHEAJwFugsfKXKOBis4xZXHBXZa9lQqFxGz8ABr6aaWHBrgdiZ/irbn1fn4VVperLi7QhGCdL8G6cABY+FgO8UfskzDAkjIcfDmVTvdLJvHT6ILYozGJnpIQ8DEzYDolvF8YTHiRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MW5PR15MB5147.namprd15.prod.outlook.com (2603:10b6:303:198::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Wed, 8 Feb
 2023 23:54:00 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7b61:8691:5b41:ecf8]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7b61:8691:5b41:ecf8%5]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 23:54:00 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Xiao Ni <xni@redhat.com>
Subject: [GIT PULL] md-next 20230208
Thread-Topic: [GIT PULL] md-next 20230208
Thread-Index: AQHZPBidPpG2MShjNkahWdKRXJM3Jg==
Date:   Wed, 8 Feb 2023 23:54:00 +0000
Message-ID: <4A5C845C-0EF7-42F8-9804-8C719F2DEADC@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.300.101.1.3)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|MW5PR15MB5147:EE_
x-ms-office365-filtering-correlation-id: 6fd154bc-aeaf-44e9-f3a8-08db0a2fbfe3
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0mPDQ3dnF7Lsv7HoQHi5oEzvlGuxa1ExPM8tA7RfEL1Xa4qNYnlOjyghGL2ASHc0JI1LnOjOcN7J2/v23haoA9ErOlosUIMg6thKS/+YbRrICukUDZ50LX8Ooc9OR/D4oWcuAhOlR+qBypdz7drt+Vyk9OcnCxj+AQ8/IJC2Qho/EsYQkEUA6nzbHq4C8aYzbnELGD4taguT2zK8mEAX329YDcqRxKClF3GsBxOpteane0msZ6STxhVtahSU9L9Cb0TFlYW1oY/ODTosvRPf248pakYP47j+1bn0Gj8BS4iY2LbomIPi3btl3DoKqDqL4msuOk2tq8kDXnkAIvjH4hWywB1pPuHjp2UEZiFnYeRLjIObIvO7Rt6Q48m/izJ6V8JfJfMbCAGGAzJv/pxUR/aGWzFcXTHEaCazESv9xsm7g5IwA5HvYPmpBEu9bXYYY8eQN/TTCkhzRwbe3RO0GWVRwzwrN/Z5xdtN4DgYpqAXuPG1Yt6krIYqCZHW4LfPwDbcpa+Za30kMqu/c6DVP0MCnqoZe4UeaKzeAZCBPqC/6XqwkW51cxLE4CNHStjVoFNepX2agk970+i4ZGAUbzj5dadnauxDBxQvBzwA1CJb2mGknnfTxNPiFVZpjJ6Ry9zpt/1bECFM3MhkSI7UmVaAcdrAniISaMXR5dGo5ZfoH6dK1Hwy/Rw6SnIaH79FQKNIwpn68lv7XEMXeWqyUONEEh15bdHU04WLfyDNrbg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199018)(86362001)(83380400001)(66946007)(966005)(38070700005)(4326008)(6486002)(71200400001)(8676002)(41300700001)(64756008)(66556008)(66446008)(33656002)(66476007)(91956017)(478600001)(36756003)(76116006)(2906002)(316002)(4744005)(38100700002)(8936002)(9686003)(6512007)(186003)(110136005)(6506007)(122000001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2Jp8UYv+ac8A3pSTsZAgqtCw2kHyDrFRxSFtH+aFE6RKoVcCmdtk82CjlOlH?=
 =?us-ascii?Q?OCM43Js3M6mMp8dvb7I8Vxe76wQVPBcxqpdRaP4bOKmiwvgWZNkbPRRZMNaV?=
 =?us-ascii?Q?Nb1vcSvdkRiOP9vpOEvKdg1nW8QfQHA7mkeC4vaYl/hM//w1y2pqmBWwl8pm?=
 =?us-ascii?Q?FWVUOfqUC96d+LOxBhAaCI3jcRLUWIbPJEgLvZZhDfwNM4e9aJ4dLmipATOo?=
 =?us-ascii?Q?38r9asNQks3RTxPyv188/NiBbYzM7bEP3eHcV1nv1YPfzDbn4iy+xerEQdfk?=
 =?us-ascii?Q?HdFIt4AHSMgvWBpjanX1eirz+e7L0cj7gK1iLj3H5T17uVMTn29SHC1A6RVU?=
 =?us-ascii?Q?qm5v4h2oz4fsV690YtlDX0C2JLTt6RdzgZ70mP2tc4JVgEAffMrdXQeZEVsV?=
 =?us-ascii?Q?NjtpZcqByQ9PiuzSDAJq9jquhiEG1Q8KtZGn9Bz6q2hzrN7RQNhvFyz6sNPy?=
 =?us-ascii?Q?2eO4ElS+n4//qSf2p0DzxP3frJwbssRHivb2izt+F96xwGc/dw0vLF48T6wJ?=
 =?us-ascii?Q?Lg4OZtjAKJi5JViZzVCoO3vxzXMFhYDBn84nn9h2Rt61aJ921QBFccxMM3AR?=
 =?us-ascii?Q?LqXOjyIWi48NTjyNYiZ+gI+kY2oGG19TxEIW4ZLQO21evmkJ5WKbrxCOrFc+?=
 =?us-ascii?Q?NF0Zepbw4+7/OgjGqlKGUpKIN3+M5gjXDNgXK1fx8aYJJPYwO9QyXcn3Ah2R?=
 =?us-ascii?Q?OfdVrJUhFXnpp66bRRUAj+NIXxE7g2cB9d2W/cdovlAwv3NstfGKwkYGyCGd?=
 =?us-ascii?Q?2nXOv/yolwh0KQF/QbnGBoRiXXT6gAItqrLN80/YFCqoWnp4JcAgI9HjgkIj?=
 =?us-ascii?Q?BJQqb59zGTiGAxS6H0ISDR0517k+ichbKGocgCohCRePxGCk/xnvGiwTYcQc?=
 =?us-ascii?Q?X95PiJCz/xK0RtSJyFDMpqcfDXc97WrPL6+82EJJo1B3w9bZ+xPQLJ1KREAI?=
 =?us-ascii?Q?y3xNE3zbcgxCwFLEyOutLJ4Jgngevc0uC2L6rlbnTGPDWRMumgkVnLNnVnR8?=
 =?us-ascii?Q?equEhVEhZYdfjxyT6cg7OEc2NmjdahY3erzyxDK2RPf38EBv1fIpp/p27kRg?=
 =?us-ascii?Q?CmEiH5aOMdTWIi95DB6MNiUWU4nl0Jny8ApZA7+/lkEnnOfOBepurqNIysXd?=
 =?us-ascii?Q?uI2hrIQA/vYdGg0KrI0OEEYRaj0njt8uX5r7fXmc/RgK14RHyOgoLAmVlqUk?=
 =?us-ascii?Q?cJJQD8PiqKf5bq+Sf/rV6XYUTtMvSvgXk7kgWg+Lqrnen+T/mrSqr9Q77uvM?=
 =?us-ascii?Q?iIciy4JihbSKy5VsCms2ZJUknFopX99Imtv4t1GCdA4J5J3Ulc6xJYJB0srA?=
 =?us-ascii?Q?S2InojF1HXwpiJBLkoNBDS0TsnnruqTT2HzzEE7jfawWOlpg6nzrhd53cEZg?=
 =?us-ascii?Q?OpSgxADR5TAsz46n5IR/2lflr3+NjMTRxJKCvq9IEwUWjNaJTvf4uylcGR0b?=
 =?us-ascii?Q?pmWK82zBpCKqYZR22GghsNWxmIakvUbSrrdLFyJ4qZ3BYZlh1KNLkM2u7QP7?=
 =?us-ascii?Q?YA30IMc/16/bApCAT4kH996LDZxRFvsrYlzjApXrY1xW6wvLqm868D8g7C4L?=
 =?us-ascii?Q?S1hSgJKsvtp0nIGGp8+qe4fpC0mGijDFR2HJ5ZruZhQw06iUi4B7XtwFqOb+?=
 =?us-ascii?Q?2YbvCAeUx0qm3L7Xd0c4gjaDDMKoca5Sw+msqlO+pnpz?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F9CB87D01420B44C83568DC16785A949@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fd154bc-aeaf-44e9-f3a8-08db0a2fbfe3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2023 23:54:00.1716
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N+2Fq/P80VgisDNWD636RadmFM58JWihNVZ8cYZlp/KF5JXnzKhe7mbIYROXKZ1RrX3teg64stY0BR9oMmqhJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR15MB5147
X-Proofpoint-ORIG-GUID: X-OQ4akNkeompYqfkk2PZ-wf1KgqCprj
X-Proofpoint-GUID: X-OQ4akNkeompYqfkk2PZ-wf1KgqCprj
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-08_10,2023-02-08_02,2022-06-22_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,

Please consider pulling the following change for md-next on top of your 
for-6.3/block branch. 

This commit fixes a rare crash during the takeover process. 

Thanks,
Song


The following changes since commit 0abe39dec065133e3f92a52219c3728fe7d7617f:

  block: ublk: improve handling device deletion (2023-02-07 18:53:51 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to 76fed01420bb8b0e282745a4945925b25751d42b:

  md: account io_acct_set usage with active_io (2023-02-08 15:46:57 -0800)

----------------------------------------------------------------
Xiao Ni (1):
      md: account io_acct_set usage with active_io

 drivers/md/md.c | 6 ++++++
 drivers/md/md.h | 7 ++++---
 2 files changed, 10 insertions(+), 3 deletions(-)
