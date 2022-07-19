Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D873EC43334
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 18:43:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236344AbiGSSnL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 14:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236319AbiGSSnK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 14:43:10 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB585D0EF
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 11:43:09 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 26JI4vJE010085
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 11:43:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id : mime-version;
 s=facebook; bh=R/cHOqrmBbHQvuen1GnI9bZI0wGuM8lE/BHZoe0rH0Y=;
 b=bQyNi/IfAdYZi25itbK0RsDdyakntR4MIZmGkdSTJyBzgyX5BAJBQnmjqTdAfQbo740f
 VwO8Qk2Bg/mTGloPFikb0tlKbPhs/ntGdGGDKkq/O+WNhjjRrktMQ65xoqwRT6UWs+M0
 fb5cgvWWvMlTmid3ZgjKWX/DOGvIJlppqhc= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by m0001303.ppops.net (PPS) with ESMTPS id 3he0ry8pps-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 11:43:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jMORbMopFuNG0NmyAYa+qJhtkwIl/vkaSs/dDQNtJ9vBO/kDwfwl8zXRZdyiJXC3PoPtW0Tt7QthFQoqKY0mk8M8W+sX3vGh+EHzhzmm28ujr83BjzoaIvtHx05AkLEwc5HECn+airt961Jubf2UxZtOWy4Y0G21qC9BAyvHDw79E9dylGdzcq/dRE1fwUa14RTdN7SG95098UKi8fYuZYkP3dlsQpMPVQLoJGJ7CPEOLfRn0ZjzJRuMKvVmRe66Z9qUpgg2icRQcFby5iHahvVqInRUivtywBSLyzCZ1cmq9/p5SQsxe153gZW4bWqZ8bno2FiFiY4QxbPS2KValg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R/cHOqrmBbHQvuen1GnI9bZI0wGuM8lE/BHZoe0rH0Y=;
 b=af0c0ZK1PD2lgi/CzCnwBN8ZAuKbtw7PPl4FxUT54SLLNJ57cMo+31KdRBcwVPA2wD2z2Lc/QhguHCaGuXo5zfym8OkUCzoahRV9klRqWQbawUOgbdLuR/zuj6tYmqFji/KXNOVFZ39o9DspVMMMu+fvyOISXLayNwSPv/Su04Nx6hMkMryfnq514iEdiylOCMhAET62Bq/KnUa3P0I4gNyNN79plX13Ux3VcGwbt5DaYgsWaxWDoRlnEHrrRGyxDAO25ETfcS6ryAMFdXJvDk9YvRkAKYp18z4xEbP8M3QKCg14g8x1irCcPRyCcS6r8PX//WLwwdWF1HErF74Vmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BY5PR15MB3587.namprd15.prod.outlook.com (2603:10b6:a03:1f8::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 18:43:06 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 18:43:05 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Christoph Hellwig <hch@infradead.org>,
        Logan Gunthorpe <logang@deltatee.com>
Subject: [GIT PULL] md-next 20220719
Thread-Topic: [GIT PULL] md-next 20220719
Thread-Index: AQHYm59ilk4usm/ExkGhwPT0ldqQ3w==
Date:   Tue, 19 Jul 2022 18:43:05 +0000
Message-ID: <5553FDCD-7628-4A40-A228-8E1BEF6FFFA1@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53ad5f0d-9fb8-4bfe-371d-08da69b684cf
x-ms-traffictypediagnostic: BY5PR15MB3587:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Goi9SxAtsSbw84twGhZubfG5SUO0C4HBrwP6Ar5SecC9HVMhC68hEyprfJimrxWg9R1+B2K9ZpNNerRLouXsOv7qoRDNxSDcxEpTlD90DPK7gQsuCwk8wJbxi7q5BxkQP/5oFMFPjuQfpWRBKFBwdjTGVtBIt/guUEuVRlHFNCs6wYfdDAvCutIX2OnipjltY45j24cY2brbVLOTB7auXySUPQm9xjLWpzsYz8Tc2SQZabPMLmzzXDSqwBu1d/Vl7/fTtORd2sakRaTBicg2CJgxGNbIWEaqHOt3llsDPs4gHGG6vJJkHtPL13D2CtATBQDbxTlskjQZa/5Nz2vzsE5fjq5n6Lb6QYugCNjP8y6ZNBJmFu5JBgfB3Pr3PF0dVFcIl61RKRbYZEKe5VnGWL2QnKx8t1MmKnAxboEc3eJIf5eqswTSolEQ8HyLfojW9f0JtJTfbWcV7bNNL5/23ooSTRIVjD/SfuadhtOCpuum5/HWZQ0D7O9KifgzySaJFu1hdcVEqBOwAgX0QQGAOj7kQ2tjDzLS7jdQJ8sj4DvRUkwHQ61bVFc3sdT5X+sR0lzo+1peakAT0IgzM476aIymXA17JMaaJnOGkqgzvoCRqtVXH/OYjQkrnctspQ/bp0rTG1PGp/oWn9TgWguxlxuu3lZoy4WSm82nG4tJG7oM7lFhI2CXYvjRAAtRZIUGWQk6NxwFj8AtmkcU/k1a/fBjtC1mhGq1CZphASZMgrHBdDA5Bom4ACAkn04tjY9v4CiivPopoKGq907Ge08pAhc1msH0mxGwoJ3HMbItp7BNA95nQxpmkAcl4O0hqr3FA5RmMKDZYWil7lMVhzIBjzQeqeUg7GEV6iJ16lVh+6NnHXDU1DLe/BfJspB2bI5V
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(122000001)(5660300002)(2906002)(4326008)(8936002)(6486002)(86362001)(6512007)(2616005)(478600001)(6506007)(41300700001)(33656002)(38100700002)(38070700005)(186003)(966005)(66556008)(71200400001)(36756003)(54906003)(66446008)(110136005)(76116006)(316002)(8676002)(66476007)(66946007)(83380400001)(64756008)(91956017)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TeyhihVrmWxKKqyBLvlxvO5L16HGpjwcqd2KvYoLTW3OVHsXn6L5EbtNQtCf?=
 =?us-ascii?Q?IL1sfkEITdIH7P76Kfh60S9JBsbJLvrzlF/rTPIj+OHjfAtHM9qgG538/Gn6?=
 =?us-ascii?Q?NwFcfpNOgkY8tYC5q58+ONx/056f/nNCljd7/repu470lX/2LOqRnn1PMHgM?=
 =?us-ascii?Q?6+mhpIvPCI210nyhDXyXME5fYJLnB1uk7SRenQv67+WpfZawO3F3FO1g+hRs?=
 =?us-ascii?Q?qO5yMqylxywpQSj9H3b6M0yRqJ5ThvJLVvCUjBPtV4jrlGaAEVWEzVApAymH?=
 =?us-ascii?Q?OFtb0f60I2oAXBmsqbuAgto6IpH2M5tg9UTP9QsAK4t+vpWyjUoKw1qfZld4?=
 =?us-ascii?Q?VySRjnLuThezJX4ElgrLX12PCwGS3SvPMXwjlLhQ2sTLu4zO8ON977Fubbmy?=
 =?us-ascii?Q?MIQBPRK+pGF7Ed+htRrvLATlNi0SSdW6rhm6cJiIX2/v93lpZV6B5hRN3jXU?=
 =?us-ascii?Q?OKtXlrCL0A04CqmOQCH4t0QjkdpldBn5kS7pWEAx/shsh5UM4fKtbx8OGbeg?=
 =?us-ascii?Q?yiIijq6CV9Mgx8qYF/Uz5jy9BlEPPZjFR4LnGNIq0VYZpOrQKdcOuhRWsg4a?=
 =?us-ascii?Q?VfCR2V3+/d6rIFpfo/IvDXDjRGDUFIqU981ZEG7R78AaNpU1Yd8x7YJAreR2?=
 =?us-ascii?Q?ubpjqCND/ZhO3tFO1VtdJq8Ra1h9phPYGWFLHWFofJb/bhBZPm4S0NrJGwct?=
 =?us-ascii?Q?eCZQ9P7/O3xQds+3UW/eVQgC3XO9By+8Pz6vUYMk1HTHX1xr5URmD3/8RhIv?=
 =?us-ascii?Q?BXRFlQSEBgjaP8XU6VeCKIFEkq8U2JBrkwN/2+S220HzwtcXkwVj+KpqLiTi?=
 =?us-ascii?Q?LHK/yk+ZKCQuRjOU+MuJEJ6x/rnfXwozz0HYtHJjQLq2vQgK3liDND1kJum3?=
 =?us-ascii?Q?AlXPkSTXfWDRkK/+dQf3Rmf5qkDS/9b8w1h+mxpdjX7gLqXps0YyGD3Bs7ga?=
 =?us-ascii?Q?Jbl+fwca1rvkbTSgWOunfaxR1CAtfHuC0uB6U8GJdEMMcVTa/GLNdIh6AQD4?=
 =?us-ascii?Q?kEMZ0xtGCqV/4rAz7vtL3cII7j3FL9acxLT1u/Jl1wm0KseSp8xDMoPvCHjT?=
 =?us-ascii?Q?fHFXd/5tx1NwA4QFKGYasNu81jdiBBTfNf7pANEUGKcd65er7tir1XQ1awut?=
 =?us-ascii?Q?t6qBm0esFGDqKffPbY4WCWAoscPbamu6s5MLfw6ZZZ+Fq/BFzcMDQjumNCUz?=
 =?us-ascii?Q?s1WrboAABzYVJ4N5SH6zjhAuZazdSD6/YaapdxEVEVrTeAkRa2SszydLFV3E?=
 =?us-ascii?Q?5C2B/lWcd+bm7UNHluqGQyGK4A8zZ1KgOYCtMxeK5jItK1+GeNc7dMJuQdKM?=
 =?us-ascii?Q?VOVZ3qZc5gY6Na4EOUzxJQcs+a4O9NxeE4+xA4PEsagbXEDXc1rxFPAVWLMF?=
 =?us-ascii?Q?/0goWOufB3N3CEF9rAXbGJOkzRpTMUT+scDJIyGkS5+MuoUMMNyk+5XbNlx9?=
 =?us-ascii?Q?R624ayLxL7E7QMMwV3jxRDVH3TR59K9dmpTVGR9ufRZDwITAS7ghbCV3218O?=
 =?us-ascii?Q?5OT2pcXzymGhghWDabWZPhAWXe5MNsr8nDpMWy17AAGbncaT8DOoys2BNcMD?=
 =?us-ascii?Q?qtqVU9rUGU1po+Ds783sR0+1N/wrQjYIw9j/9qeMnuXFcfDOaLw5p1jr6WjE?=
 =?us-ascii?Q?rzB5/1phvN5W/K9zOHI31B8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F7E7B1FCE57E9248BB52E533D96F42E9@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53ad5f0d-9fb8-4bfe-371d-08da69b684cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2022 18:43:05.9014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L+MsnjRjh1V1ScTeg07JyxF4s/v19RE+E9FReYRxhlRkTDpo46Qk5MC7q5G/hKw7q4mXqkIDPyDX4e/gexxzYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3587
X-Proofpoint-GUID: KJdeq0tOmzkHprDhs3LL2ySiKjPdPs_9
X-Proofpoint-ORIG-GUID: KJdeq0tOmzkHprDhs3LL2ySiKjPdPs_9
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-19_06,2022-07-19_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes on top of your for-5.20/drivers
branch. The major changes are:
1. Fix md disk_name lifetime problems, by Christoph Hellwig;
2. Convert prepare_to_wait() to wait_woken() api, by Logan Gunthorpe;
3. Fix sectors_to_do bitmap issue, by Logan Gunthorpe. 

Thanks,
Song

The following changes since commit 8c740c6bf12dec03b6f35b19fe6c183929d0b88a:

  null_blk: fix ida error handling in null_add_dev() (2022-07-15 09:04:38 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to e6b0075be44e5d0431d4463d4feba2edba8e8d24:

  md: simplify md_open (2022-07-19 10:54:17 -0700)

----------------------------------------------------------------
Christoph Hellwig (10):
      md: fix mddev->kobj lifetime
      md: fix error handling in md_alloc
      md: implement ->free_disk
      md: rename md_free to md_kobj_release
      md: factor out the rdev overlaps check from rdev_size_store
      md: stop using for_each_mddev in md_do_sync
      md: stop using for_each_mddev in md_notify_reboot
      md: stop using for_each_mddev in md_exit
      md: only delete entries from all_mddevs when the disk is freed
      md: simplify md_open

Logan Gunthorpe (2):
      md/raid5: Fix sectors_to_do bitmap overflow in raid5_make_request()
      md/raid5: Convert prepare_to_wait() to wait_woken() api

 drivers/md/md.c    | 310 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------------------------------------------------------
 drivers/md/md.h    |   2 ++
 drivers/md/raid5.c |  32 +++++++++++-----------
 3 files changed, 182 insertions(+), 162 deletions(-)
