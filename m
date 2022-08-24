Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6722BC32792
	for <linux-raid@archiver.kernel.org>; Wed, 24 Aug 2022 18:31:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235329AbiHXSbP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Aug 2022 14:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbiHXSbO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 Aug 2022 14:31:14 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A935EDDE
        for <linux-raid@vger.kernel.org>; Wed, 24 Aug 2022 11:31:13 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27OH7RCM024397
        for <linux-raid@vger.kernel.org>; Wed, 24 Aug 2022 11:31:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id : mime-version;
 s=facebook; bh=eSRpLCLK5dlb4kjkcnujWwZ/ZAlBkF8ES+qXu/pkxvE=;
 b=FP5YFoImZRP+zFcGTdngabnGxrP0rGDuVDibZ9RPRP6o51J09df9TLLHTR3AFe7h9L6Y
 0LXZhFQ/PLmBB2dQZLTdylJVuh5EzEavhmkYzudiQyZxN+0OVxdL5e3RHEICaWZMGryH
 KBp3SWisfqZUqbC10OCpqaUaVf9A3cr0kkk= 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2049.outbound.protection.outlook.com [104.47.51.49])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3j5a9fwedm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Wed, 24 Aug 2022 11:31:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OxrqpiFb2u5p89dNwKA5CqkXl1AmslZRlkue7omWYcdJQH8XXjmqmMy94DmBmOX19WPIPLUOEXtSeoqr9glArw2t4kdGGjiQOYkYcVJ07TWH7USiueOaI+nexH+m/UHzxUMnD8GbdrH3OaBHlALCEJCObVM304V7K9YbK+fd6nTf4rNPNRctKt8walsqwMf1YAVfm9zFL+mJ1VrzD/C1GCfEq9Kg7Wt3NCfPHCIvBLPJ4JJVmoqvY6JriiIvylmUkA8es4tK6/f+p3VJ3Qyqs07OaV6aDKcsD1R8lnutRekqZurJyukDVcQaNIVLCbKF+NXktLVBCOKhtvi9TOodzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eSRpLCLK5dlb4kjkcnujWwZ/ZAlBkF8ES+qXu/pkxvE=;
 b=VjtqtcJhoih+MkCTkEtZxXW9HEnHfo6/ni4laihNrlsONZNHNapBbji9sYSp7kfP2lM+9UWuenFZO2yRQubsa3gRpxhtEPxCrAQtr355RQ8KmR+bCwImQnwR6odj+7MT8h3/i3YAem+g8J0mhhrV3MBZxWgzeJTzb9TUZ34LqwpA2F4FYpe1jcBiqtTI7Qn+pJJLToB5n7qm7FMxANXehUGXXlD4ouGcK275OJF5IYmuINpaQlFsNdcztdHXGXGCsjkG3YvS1s1oSxlxWVEVKWObZZdKm5E9MJ9Dnm/rhE0dJB0OoQCcOFQ2EescL6KoTA16dFksAxGI48H3ykIPcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM5PR15MB1594.namprd15.prod.outlook.com (2603:10b6:3:d0::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.15; Wed, 24 Aug 2022 18:31:10 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::c488:891f:57b:d5da]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::c488:891f:57b:d5da%9]) with mapi id 15.20.5566.015; Wed, 24 Aug 2022
 18:31:10 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Bart Van Assche <bvanassche@acm.org>,
        David Sloan <david.sloan@eideticom.com>,
        NeilBrown <neilb@suse.de>
Subject: [GIT PULL] md-fixes
Thread-Topic: [GIT PULL] md-fixes
Thread-Index: AQHYt+euCoPI56LSaEG5zQN0fuiqFw==
Date:   Wed, 24 Aug 2022 18:31:09 +0000
Message-ID: <FEC5B8F6-0165-4CE7-A1F4-F7123D37B858@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba5a8f73-ead9-49b9-4acc-08da85fed0f7
x-ms-traffictypediagnostic: DM5PR15MB1594:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6oh0osSEF2NiPVyzrokwEplBh07ryO8jez2YruK0YFe090yaWSe2Bvlo0VeGYldmA6eF0AHx1ZsR44gYjneN+Y8zJ09ELkxg+d0JJ/Wi7SrywjPHKutxG8hOvnFRB0F/FWxCG2OOsS3EGqlcTVY1JK4JoGM+jlxTY6jdvgvtPj19SqcoyPjs2LVW742+mw3pK5ePgInqF6CSDfr+RXQq/B/VLATd/r8rdmdVNE+/q5sobtsh+6zCVnA72n7T2sWscQK94GCRPb8nsLdKkzQlS2igyVCVYwEtghbRmGmIFtDsAUf0IaiZnONS9FAOEidNxdJIGWe11LSm1o6YUV0g3LajFXIe3dzyhGksE+ivwxv2ZOB/LwfG9EKaKriSE9Li+pqgvMxPiAqONVrj6nX9wFTQ35rrx222FEKcsJk0idbU0W0zAYq7nEAWaOLdnsWE1OMrkCKZraKs3YK6453mItaAvLe6hdIbIRXPcOZ6DeEqUdN2kfkqZOV5vCs52tnl1HZ4m0IZ7HkFqU8fFfaZFxlMvfSRd0BP8JJaufLRYrhFFBBccn2T9rkQZ0OWrJUQUkXY8e8KodxxzMBVAT+Duh59h2OlnWHkW3DEmn/+4fv+MsnAwm0Oin6iJCRe6ezb311ibYAnPAJB4FN6CGM8ElFim0pwfgBys9z1/QxQ6m3yFQpcsuWf0yBQj7pHLO79nwFhayjVewZxvGshjW4qciowJ3EqBoEPI7OI8TNARkTHS0XX+fkyfMXsv6Ctxwgp/VgG/k9QeD3hRXWgDW+AOdJARYtZNjvbh7gA0b5OYWw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(4326008)(66946007)(64756008)(66476007)(91956017)(86362001)(66556008)(478600001)(8936002)(66446008)(76116006)(41300700001)(38100700002)(8676002)(316002)(54906003)(110136005)(38070700005)(6486002)(71200400001)(36756003)(33656002)(186003)(2616005)(83380400001)(2906002)(122000001)(6512007)(6506007)(5660300002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rkIxeKXFNGxCMhlR0cYxExUCWrmuej/8LJR7rD2oLTvTnLJMPLjBCIZIZUUr?=
 =?us-ascii?Q?GI7h23+mADSdXjta7M/5O+KeZgu+ty49yH96azf4M/mZ/POPJfRQrSc4uq9A?=
 =?us-ascii?Q?cIEIw6Mf9HvyuCdEo5qZskj5xvfDMIjm57EXEUbDsXFPKMdAjki2AsNLLXwH?=
 =?us-ascii?Q?/p8blXWUe8d9gjZpQvqSZLUlIKIJ1qTyrCL7ZjMPSFQON8miue1D9gNxOBWd?=
 =?us-ascii?Q?yxtpFmCuLhAU6RLc3V2Jj+uoUSTY7RvH6+Cd14KhwPbKsHEEcuX2ka+PdA7e?=
 =?us-ascii?Q?/4dogr2KitOcBK/VLB3iaYlVEZY9/7sSyKb+3xebIbEWxDm8OjXRkMsCGXhp?=
 =?us-ascii?Q?7u9l3iK6Gs/MuzRGaMRrJSFO0dXenMv7x75zFRufhFprDQ/e+hbgRS+14UEy?=
 =?us-ascii?Q?ZwWBMgaqZHfEYgPNX2mhfRIbewGUEZNSWBGOuGSf2rlQsUT2ZyQrK7MKuTZK?=
 =?us-ascii?Q?rm5gs8YaBMnU20C0pZMRCgPtX+yTjElIkZ1LoTg2PD8XWyszAtxK0gJ5jNvo?=
 =?us-ascii?Q?FgyaffUKX7LnG/GSBfSL6+xP16qZwkNdHS2wAVYIcIULTsRgV65/9XVbZTfo?=
 =?us-ascii?Q?FXSadRtKYUCG7WE3QiaU5wsEN0B7yrTBJhneBlGZ1SLDfOy+H8d8KKHIQYgI?=
 =?us-ascii?Q?HxmWdYFgyKEQE6UbPk32DRj4WddZO6CVGTBhkRcLECjRUvIa4Hx+/FRVc5Bp?=
 =?us-ascii?Q?ZRqgKmaBGyp9ZW/ja7/wgeAhrpRgWtXPxJc/8Nn/LUUzYY07JLQWoyd7yKtX?=
 =?us-ascii?Q?3CM23hFhdhWyCF2RN7n2H/8XixqUFCWxax4747QP9BOZTmgtYRHFUqz4eSng?=
 =?us-ascii?Q?Q4x0qkiXrmZ7Rjd09HOsSOn3Oi6ND4pxbbg2iLfGHdhAMvehbSvzZ84owaeX?=
 =?us-ascii?Q?kkeYrngdYIkAQdQ+hFm3XXCT7nvXye71QOHHulCyunUqpbIB1LDkg1fsdKtl?=
 =?us-ascii?Q?gXqF0Aibsu/G+b5ISWVivmroMmeFVbNZbeW+uMZQIk+3eHBPe8ycARVHMvfX?=
 =?us-ascii?Q?GLPSTjbKsSlX7GvJT5/k3BtbEVKVFB3ntly3sXjDEE8ke6LOH/mq77Fxc2v1?=
 =?us-ascii?Q?SAlq2lZihXN4XmEq5Hw6bZ8iKWeakT65PucdnjhJAnJ6gBUcAtySU14k1hIn?=
 =?us-ascii?Q?oa2JjUMVNExWIcXuInIYDMAvzxTMPAnsZzSeaopdL6tpXWMathDFyJuRYW3B?=
 =?us-ascii?Q?vN6TvgdaRQDQS8efrXPO5SDJMmmGEI7kUVRYYjlpOVUQQ+gOF8FySwGB2jp1?=
 =?us-ascii?Q?NT490cwo61As4PDrZgatAEepb+AWg3rJ32NthzFEWkjAO/IZ1bnVwbc1rBqW?=
 =?us-ascii?Q?npAlHT70I2b/8DMDz9z/xIx/dtIUJkADlrlmf2vEoyAkHaVWWlS7ZsVjHlUa?=
 =?us-ascii?Q?RdhvXNHWGZzvRvdp3Lf6fJRo5jcQ/jzW4jRwlg7jiBcvQ+fS2IPVsoLOMm8g?=
 =?us-ascii?Q?kqmYYfjREVgz5uR62XMPoW+xqi+zHaHIxxsi4UlXHkcvgRnbdek6U/Z+sEkl?=
 =?us-ascii?Q?bskQrTCB41ymE9hoUltoLOxYxyqs6d+jjCjR3Nj9nP5O/16eTeD2MNNDNGqu?=
 =?us-ascii?Q?iYieS0isA3ScZl11Y5ldkjlZOkGDTDVx7es5aRXq3OXyNUHzwdreXmlXXhsc?=
 =?us-ascii?Q?RcPqrOY4QcXqVOfcQo3yQl8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BF7CCD26F16D8742A8AFD62167CFCE43@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba5a8f73-ead9-49b9-4acc-08da85fed0f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2022 18:31:10.0244
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8JTVVdO7tlGep5lLfcm3XF6YdAstataSmKJLcF0uXpz7jDbXhhJeJ9NYm4om/Isj4vbONDMtwsIAWxf6MCm5Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1594
X-Proofpoint-GUID: oxPqYFuVInYD_w-Uk7b8FL1BzFVIQpbC
X-Proofpoint-ORIG-GUID: oxPqYFuVInYD_w-Uk7b8FL1BzFVIQpbC
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-24_11,2022-08-22_02,2022-06-22_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes for md-fixes on top of your 
block-6.0 branch. The changes are:

1. Fix for clustered raid, by Guoqing Jiang. 
2. req_op fix, by Bart Van Assche. 
3. Fix race condition in raid recreate, by David Sloan. 

Thanks,
Song


The following changes since commit c490a0b5a4f36da3918181a8acdc6991d967c5f3:

  loop: Check for overflow while configuring loop (2022-08-24 06:52:52 -0600)

are available in the Git repository at:

  ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes

for you to fetch changes up to 0dd84b319352bb8ba64752d4e45396d8b13e6018:

  md: call __md_stop_writes in md_stop (2022-08-24 11:19:59 -0700)

----------------------------------------------------------------
Bart Van Assche (1):
      md/raid10: Fix the data type of an r10_sync_page_io() argument

David Sloan (1):
      md: Flush workqueue md_rdev_misc_wq in md_alloc()

Guoqing Jiang (2):
      Revert "md-raid: destroy the bitmap after destroying the thread"
      md: call __md_stop_writes in md_stop

 drivers/md/md.c     |  4 +++-
 drivers/md/raid10.c | 13 ++++++-------
 2 files changed, 9 insertions(+), 8 deletions(-)
