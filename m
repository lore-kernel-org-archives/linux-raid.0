Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63795ECAAD8
	for <linux-raid@archiver.kernel.org>; Wed, 21 Sep 2022 21:33:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiIUVdJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Sep 2022 17:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiIUVdI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Sep 2022 17:33:08 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F91A00F5
        for <linux-raid@vger.kernel.org>; Wed, 21 Sep 2022 14:33:07 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28LKgSWl013555
        for <linux-raid@vger.kernel.org>; Wed, 21 Sep 2022 14:33:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id : mime-version;
 s=facebook; bh=PcxO1BHmHt13e4Gn5DZA0o0fCJHLaG2sBJX1yjCKPjE=;
 b=gwvSUC/JtIhvrK+bY4V0Ag8Krce/5XSKGN/AEXdg6RJ4Euk+5xx4Czk6YW/oPPm4NTbt
 vMJfMdal8UXl4LCx0bcMH2CKcCdZLtnBR3CwS79iLdqBhASd+64P799IYuwWRWhpkzIz
 qdlTzwLFomOqJfR+WzoaaS1FQkGFtuyNd9I= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jr7aqsnku-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Wed, 21 Sep 2022 14:33:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DbqqajhDkM6Ya2otqLqcgIbWncJuehxGo9TdtAMOHY0xkNimwk4FrG6XJba6UIquY0XP7qpPY17TlHfRTSuWBUBfJLDdZV3BvyvvG5hxtmcDh5j9Jg5+XaQsuDiRtMN7menFBOBm/+Mq1tpksZukZCOIr+G2f79wbgnhRYWbel2gbHkFnYbI5H+xetWYaISAWoB51DKvJsRxXkC9G7IxBAYFg90T8E8YKZXHHk4ogVVCF7PXJNsVXndkJlwapGLuhfTDOWR9RnP2n492f50Mnoct8wpt+zO7QiUGHNAWuyQ3+MZLMzJ2xnHnwzy2qfBuVOEJM97fkQYd7fkBYWEFJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PcxO1BHmHt13e4Gn5DZA0o0fCJHLaG2sBJX1yjCKPjE=;
 b=O9Q7NowjuHNWCFxY9jPsYhX+YD3x3NBPMp/eBOL8OMLza8IjLWwGLLioot4W67PwDts9clA5a0LtG2ZonHfLXMOMSc4PHTZWS+t7t9KnQKp30A2E/CFKLqcAklc+e85+RJ2Gy0MFzIJ9A47suBcflE788MUinKa9PP/P1cInS/oQ/IyMH6fNFHaH0pBUuXiFFf2XVfxP5Y7I1qA1pDwP/brtYxWzZuA/E9jOz7qr6EdHy83rBYJZa5yuc+a2SIOTC1p+bEzmkiqthmyj/BoZ9dkzQmePXKjfHPu0Gk+IRsxMPGhkQofoewMr6IA8g1F/szla3gr5GqanvuWmP7OufA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by CO6PR15MB4228.namprd15.prod.outlook.com (2603:10b6:5:349::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 21:33:03 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::d70d:8cce:bb1:e537]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::d70d:8cce:bb1:e537%7]) with mapi id 15.20.5654.017; Wed, 21 Sep 2022
 21:33:03 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Logan Gunthorpe <logang@deltatee.com>,
        David Sloan <david.sloan@eideticom.com>,
        Yu Kuai <yukuai3@huawei.com>,
        Mateusz Grzonka <mateusz.grzonka@intel.com>,
        Saurabh Sengar <ssengar@linux.microsoft.com>,
        XU pengfei <xupengfei@nfschina.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Zhou nan <zhounan@nfschina.com>
Subject: [GIT PULL] md-next 20220921
Thread-Topic: [GIT PULL] md-next 20220921
Thread-Index: AQHYzgG7IsB7W7FUYUa6cfJoE5G/ZQ==
Date:   Wed, 21 Sep 2022 21:33:03 +0000
Message-ID: <9C523D34-6134-4F86-A357-5F306AC3DD07@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|CO6PR15MB4228:EE_
x-ms-office365-filtering-correlation-id: 84f8333f-f047-43ad-eb1e-08da9c18dda3
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AnEDEPJvjtIAwYAoraHj6ZrhesQuJy4DcIGMM2azmObdCCQf9IEdm95xIwMXbSWEY4Zxts9itr8WJt1k1xMS6G/DEVoI6Vz1fbcL2+egdwuENtZLM4YnKa2cfGZX/1vBjXGY9R/DIXy24tpJ7N+0MKKZrHbNCcZlUXNh68yJr7uw7/Jc3s5KynDrGZVPlrQulnuosOd07ZtC4okROW7doW3LkoZcsJ1dxQD07CQ58GIbS7DF7TZk7mqxBhgMVKaYwWXVs69K1dwSHTkq+rMAE1fBM2R1NmH39PCZNOYc2FcVmdlKbRLGbb08SuH2616H/C1Og79pWnCwt3d2a849Y/NbKNO10RSX/whzwbfPTnpzAeOI6QKIrmjGx6TcvEpIOx/vqgGtEl0/p6hUja9Vf2t7hTtunNUKm0FkQRDCpRGZQsO0l8bw22abzEIndDGjs28DqkBMJhz601ne2CHCG2bNyIyPj1bXEQiSmKSqHDZ+/TflKb4xNDmfKG2ttfewf44UFC0fOo/ajo7bn4gJ95x7NleImRCAvO4qzzTrCnasX5g+RAqYBmSboqDtdgFhJ2HGX6GNdYAtF6rL5nxZZ9Qln83lIN+UKSlByOngv5qhdTJA+EQrJK4c/hr32lkcQsfT7TvzSzGw37wRWjaNYGBEPjMAkwbHu7ZDej9AbG3ErxX+RiSHtuUymu6O4+g3tg+uQTt+Ycq+8D6ZMw8bYRX+689+C5FK4JWtTorqmP2bMFNl0mMDff2CmS/UEtROgwFGu2B4CcNIrZkgTKXfYXsM6yvxHLxjM20DzBJBcAS8mvbeqm6hWyZr/bb8U2FOa8dVtWMnmUL0h1myKUgnXg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(39860400002)(366004)(376002)(451199015)(41300700001)(186003)(71200400001)(83380400001)(36756003)(66476007)(6506007)(8936002)(6486002)(316002)(2616005)(38070700005)(478600001)(38100700002)(91956017)(76116006)(66946007)(966005)(54906003)(66446008)(8676002)(64756008)(66556008)(33656002)(122000001)(4326008)(110136005)(6512007)(2906002)(86362001)(5660300002)(7416002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?p46/l8TsrHXwfgYmSsqOINqhRzR/1WcTzeL4O36eX6w3bZa06MQbwbPJOLhF?=
 =?us-ascii?Q?sSB/QuKzVLby5Ho/RpOowKsqgHVkqmiejd+Q1jBPfrJkhCEuPUEgWUDri6FX?=
 =?us-ascii?Q?BtAatUqcb/0YDfZGmHYWfFYzQa/5VPIt3Xoj2pyshrji/TNd4n97M9XNwI2X?=
 =?us-ascii?Q?/hXnCawtG6JkVP2TTZ6JP+FgsfWW/XuKBo7ALo2r1Njp8QeoNLc2q9VlimrV?=
 =?us-ascii?Q?ZReq6OCxBjTxvBrOfB/T11cvRaUoUvWTMe/kkpDQq4Ykbb5X0bfIvhBxxKsy?=
 =?us-ascii?Q?cfEDMDZp2i4hpyFfr2S/r3PfAsoND8BaX0wJZv8fhcLfg73Lvh4d7O81iC9x?=
 =?us-ascii?Q?hACprUeGafHEcdhxtyXOD5l/e8z322V9PfILu/NpOY3sGV3hPSYhHrk14hbq?=
 =?us-ascii?Q?TIAoEZcbrRCowYdSbW58U5UmpRWb5pkqwblLA5rdr52LYfG1CMSh8b+sPZEK?=
 =?us-ascii?Q?eSRiZsnT19CpaOa8eNGTxgZb595Zml1SbGPdE3JrjnG5PLDWpOCKFDqNvCQR?=
 =?us-ascii?Q?MIeHhBVfK7QpmDYZJHy/wxm/m6N/+XbW6eidjK95R5IjEOnScdmfLoOh0q8H?=
 =?us-ascii?Q?SOzLHAWTn9AqQu9JybALMWwmOm/fHHHFMNW20M+tWa81qrXHN1PxiLKr2U0q?=
 =?us-ascii?Q?9SOZkLxDX4mHI1p/P5EiqGGZ2K0fwYsRzrs+83qi3Jw169Qq8HjO9sI0A78x?=
 =?us-ascii?Q?zYWmqv75yPc/Oe5Bz1F5L4brFvLPAZWia62ZKys6dYQHs23CDzpDAWnvb/gM?=
 =?us-ascii?Q?RBYYRrJGj+FmuFfhO/syFXDQA6seQ6I52f16mTqLSagJrzRHy2RrPnkjnbPw?=
 =?us-ascii?Q?d1b83mkcgdCvvkSza3fm0nbD8ovte72wtSIHzN0HYYGt/hXSM/xlSlMxMuJS?=
 =?us-ascii?Q?O8mMTNzdQFMGc3nyGga4b6XTEHXoHTjUoS/41Ii2pZZNYMpaEZTp5IWm9q2+?=
 =?us-ascii?Q?t5pe9RjCyyWB12k+m+lLqH0wL6f+BojcraUdgrMq1tF2OwQuRVFwWku5EZW7?=
 =?us-ascii?Q?K0c0NOOcHO6C2xLahjGXdTuvcBJNZcGfcZJcHH/4s+OCKU5ZAxgjA6P29a80?=
 =?us-ascii?Q?aloVsiDFo1uUEQ9NVSOtaj9CtbTYczPQsxe+eLlM35/VAwABn3kCGeyAVgth?=
 =?us-ascii?Q?9lLtKZ0pjDhczEQj5nwU5G53RjubePK44w9j9K+JteRUQrrUNGSg8P60QKpu?=
 =?us-ascii?Q?RH4kR14olddEXxgxx9X1LAKx1h9s9hnmrNrZXCWPNJzjhSJSSgSL574WDOll?=
 =?us-ascii?Q?0PnfA5W3wqjWcoqnZbRVdEKTR9yV7andQeEmYBmm53NOl1r6FEhxkxszlqmt?=
 =?us-ascii?Q?6HvSEdDjlPkNFEvlWLfu7OdNo0u3VArXpUkTjMsWo5N3gsLL801GzExKsZrh?=
 =?us-ascii?Q?lTnobWKoIKkeo+1izXl687qqqy04Eik+mrDrT1mjgOd770M8zrEp/2l7e7tk?=
 =?us-ascii?Q?0GCWENEIgJuvs0uaV0RuE0MO2qWndZGRFD0usPU21lL5eqzx243lQ6pfToUX?=
 =?us-ascii?Q?HqopHgRHcQGt7eKo4M07twAClMKNfN0L+WUBiw6KbruwKCD3T/dO46TYaKi9?=
 =?us-ascii?Q?3/JO2HBk2G9sFLG3NKzLJHis+fbcNeMCy3F+2/S5yUnUXdnkMBoBtAP5y6/R?=
 =?us-ascii?Q?yER9oRMCwmxZtmQEpSdcFlc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5AD9825D1F1AAD4FB5EB1C66C8A4AF9C@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84f8333f-f047-43ad-eb1e-08da9c18dda3
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 21:33:03.7377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fhOHV2cw4eJct8sdGMDTuSkQ9Zqr2jStBPRYW2ZDZdrLLeJPEQNp6BY+05R4/aVEK4ik4DYRbOdkzQhAG3J87w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR15MB4228
X-Proofpoint-GUID: 0zPGHvckAJsfeqcmqfA8lTCYGzgoxEFL
X-Proofpoint-ORIG-GUID: 0zPGHvckAJsfeqcmqfA8lTCYGzgoxEFL
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_11,2022-09-20_02,2022-06-22_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes for md-next on top of your
for-6.1/block branch (for-6.1/drivers branch doesn't exist yet). 

The major changes are:

1. Various raid5 fix and clean up, by Logan Gunthorpe and David Sloan.
2. Raid10 performance optimization, by Yu Kuai. 
3. Generate CHANGE uevents for md device, by Mateusz Grzonka. 

Thanks,
Song


The following changes since commit 8c5035dfbb9475b67c82b3fdb7351236525bf52b:

  blk-wbt: call rq_qos_add() after wb_normal is initialized (2022-09-21 08:36:13 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to 9859e343daaf8b08bbb4bed63a378a05535bcb47:

  md: Fix spelling mistake in comments of r5l_log (2022-09-21 14:22:17 -0700)

----------------------------------------------------------------
David Sloan (1):
      md/raid5: Remove unnecessary bio_put() in raid5_read_one_chunk()

Guoqing Jiang (1):
      md/raid10: fix compile warning

Logan Gunthorpe (7):
      md/raid5: Refactor raid5_get_active_stripe()
      md/raid5: Drop extern on function declarations in raid5.h
      md/raid5: Cleanup prototype of raid5_get_active_stripe()
      md/raid5: Don't read ->active_stripes if it's not needed
      md/raid5: Ensure stripe_fill happens on non-read IO with journal
      md: Remove extra mddev_get() in md_seq_start()
      md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d

Mateusz Grzonka (1):
      md: generate CHANGE uevents for md device

Saurabh Sengar (1):
      md: Replace snprintf with scnprintf

Song Liu (1):
      Merge branch 'md-next-raid10-optimize' into md-next

XU pengfei (1):
      md/raid5: Fix spelling mistakes in comments

Yu Kuai (5):
      md/raid10: factor out code from wait_barrier() to stop_waiting_barrier()
      md/raid10: don't modify 'nr_waitng' in wait_barrier() for the case nowait
      md/raid10: prevent unnecessary calls to wake_up() in fast path
      md/raid10: fix improper BUG_ON() in raise_barrier()
      md/raid10: convert resync_lock to use seqlock

Zhou nan (1):
      md: Fix spelling mistake in comments of r5l_log

 drivers/md/md.c          |  32 ++++++++++++++++----------------
 drivers/md/md.h          |   2 +-
 drivers/md/raid0.c       |   2 +-
 drivers/md/raid10.c      | 153 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------------
 drivers/md/raid10.h      |   2 +-
 drivers/md/raid5-cache.c |  11 ++++++-----
 drivers/md/raid5.c       | 149 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------------------------
 drivers/md/raid5.h       |  32 ++++++++++++++++++++------------
 8 files changed, 223 insertions(+), 160 deletions(-)
