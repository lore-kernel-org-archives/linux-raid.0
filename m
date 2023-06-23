Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97EF3EB64D7
	for <linux-raid@archiver.kernel.org>; Fri, 23 Jun 2023 17:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbjFWRDt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 23 Jun 2023 13:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbjFWRDr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 23 Jun 2023 13:03:47 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD81F26B9
        for <linux-raid@vger.kernel.org>; Fri, 23 Jun 2023 10:03:45 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35N2kHFk000703
        for <linux-raid@vger.kernel.org>; Fri, 23 Jun 2023 10:03:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : mime-version; s=s2048-2021-q4;
 bh=v8Vt2lCSOmcFzRTw/SpLBkyl1JlI5Z/DVzs2VShkLS0=;
 b=FPQa0MXfOgqsOSOzSICb6bFFkQ/sDCIgpnGUcmxBu7YFWVj+Yp4osb1AJvcj4FInGaMC
 RZP9oxVEN9nfot3APSHIrBEYHRH9Z1LN9L73Ag0Iyt9mXwiis2f/MtyqIrYsoJz/BFWB
 JO5h1uSzyCA6Uqufbby1vdP2RU46N6tEMmjw19onslAYUz+JJlxJHxQr4VEFE8U4OK0g
 G+zFoxS9eyzJ31XTXFak5xb6ioX8M93EIz6k1IttnE79MtzHCGTo3TkjJl3OsKy6mh5y
 kU7T8EFQgVs3bhEu5QW7JVKFArIi9KXGD2657V6fXC4rvDZNPpVkw0QXI9EHrNPviVfO eQ== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2047.outbound.protection.outlook.com [104.47.73.47])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3rcn2d530j-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Fri, 23 Jun 2023 10:03:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aYPeflj8676plUuPC6XHCmgwGQmdERL/dmwzneEMx+kl+GajXvjd2Dpj/safzhNtbH0GADWbVirjZ+Dmy/QW+n3l5h0U0L5Svgg0yyKe6cevA77YMHqm+GjIrc3/eQ8/GD4FHrTTh0xe304CQx33c9Z9XDOyU5/ihKaHy+E3Jp0MmWDNHfPysmm+UPNeO0vsXgaV+kBc2FMLHKwSi6gRay9X3qKocZ1B0vQZktY9WYbWIQYdMKJt2ngSvNoqOe3ricSoJaV040qGhl4LLIc4g6LmCGeR9d0CVqPnX0mkL4x7X6GoB5M8icABYtNsLW8QlZrKIRu9bUJfC4LAkHUqQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v8Vt2lCSOmcFzRTw/SpLBkyl1JlI5Z/DVzs2VShkLS0=;
 b=NogVuwR8APrm6oWM9raOVy858HLvavFhKyhfsmvXONofwzw1818ModFfHG8Ce0yO8RBaxzk0u7qxxJ1RjmH4kKM6pNlyh3TYnmDFLGGN8E9YOT+DeOGU5W9HIUU2d3XiwTEntxdQ1qSiPRg4FcT2aVGXSqgyGqjLTTtC3i+TGYgY8zAL6fpXYFXnqTRk3aPxrtBK/+d8G1vTHgVRLuuWRxIIYD2JTnwFv5UftpDG8WnWPldVoQ0ogXH6duyQe2qHbYvMx0B/+LTgzxJquN7myTE95nnqdcheADKuZTCu1KmHA1XwtSQvP5pzhOwblXnB+59q+40G1upvgmIfTIZFKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SN7PR15MB4192.namprd15.prod.outlook.com (2603:10b6:806:f6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Fri, 23 Jun
 2023 17:03:42 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a353:7e78:2a58:dac1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a353:7e78:2a58:dac1%7]) with mapi id 15.20.6521.024; Fri, 23 Jun 2023
 17:03:42 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     Song Liu <songliubraving@meta.com>, Christoph Hellwig <hch@lst.de>,
        linux-raid <linux-raid@vger.kernel.org>,
        Li Nan <linan122@huawei.com>, Yu Kuai <yukuai3@huawei.com>
Subject: Re: [GIT PULL] md-next 20230622
Thread-Topic: [GIT PULL] md-next 20230622
Thread-Index: AQHZpZZGsF0fcMg7G0SBiGVFcgbVP6+YbjAAgAAP1QCAAAIbAIAABvaAgAAXA4A=
Date:   Fri, 23 Jun 2023 17:03:42 +0000
Message-ID: <B68B4659-E6BA-464A-8433-BFF952F6527F@fb.com>
References: <BCD9738E-472D-4AA7-B4F9-CCF36B5DA0E1@fb.com>
 <83240030-681c-9ff5-6e2c-600e83b0cc71@kernel.dk>
 <392A5BF5-2961-4F2C-A1C6-D6532B5AAFC2@fb.com>
 <480ac9e9-9257-b1a9-520e-50feb54dfdf5@kernel.dk>
 <bb837894-de92-62f8-05ce-f06b86876ea0@kernel.dk>
In-Reply-To: <bb837894-de92-62f8-05ce-f06b86876ea0@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SN7PR15MB4192:EE_
x-ms-office365-filtering-correlation-id: e3c9c385-5eec-45ea-4f40-08db740bcc34
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RhKyz/YD7WBtvs+N6XwGySMZ3J/E6wVYmA9OR2jBH11dqRtQFTDGrOCkxgdpgUhJfC9KX1PhGj/0+Lc3oFJ7cgcr7tUtS3LEHUAumkjjPOEf6sutG8t4d6W5LQeziZ/dI3tZwjI7VT+O/ReknLwIkb9TYf+jZbb1r1BlwJSVohqb9m2KbWov+EChiJmGGMn9BfjyI2TZoUFqz+GnaNvEGP5+XGsPaBZxsRBAT2RUDMp2yayUdxkAdx302WNKSg8UuxWCcjUBR7zscQNyoA/Isr5jj0xwDQfedINoQPHeJtBUzC7I60rFIPn/GF1AD1tQzaPIzIXkim+SqrXH7cgrIrfVu6HC1dI05xxDDr7pxtf0E2RuR0aD1mLyLUIt4mvqW76yKMfi4WnRn2dCV6PpeDwMQiKf0awL4/FWJuL5E0SkL1f7L9/TOAXJxiURoMxBnbtRDeLxktFBTr3nlbnEPQIqqGnI9c/zJDtV739Ff5WnEhXC+1Bow2qCzFhz+aq9bk70YLDCiHCrcFObD6YhVKBfuoZF0q78Z522+SYPkVTHcADeeCb+TZnQDoSQvkx2ETVifuTsJzxbBKK6NwihcmPz/kty0zA6Zi/VSgKbtgk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(39860400002)(136003)(376002)(366004)(451199021)(5660300002)(2906002)(122000001)(38100700002)(38070700005)(86362001)(36756003)(33656002)(478600001)(71200400001)(54906003)(966005)(6486002)(316002)(8676002)(41300700001)(8936002)(91956017)(64756008)(66446008)(66946007)(66556008)(66476007)(6916009)(76116006)(4326008)(6512007)(186003)(53546011)(9686003)(6506007)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RiCEZwYiLiYehmRR4rVSWVks4G3IeZJCdSZdMdOxLJnyL1kI5aSH3rYklo7O?=
 =?us-ascii?Q?a85ETd8fPXhOIWdWYhi3uO4IRcSNoc4cT0YOSNvOzHNnHsFp3KlahAR29M54?=
 =?us-ascii?Q?KGHVzUuUTG5FL11bD90F4hyIvLIqO71xTZ1UU9CG/VBcTIXpuP5x2q5gqVlB?=
 =?us-ascii?Q?YFZZzYM2Fyrl/B0M//tyxypAhYuiyD/TZsbsY97JLCAqRUS6+8Mb5nyKU2Nz?=
 =?us-ascii?Q?0cMM3dGdechzqTOYxf3cPA5hb7LtKXy721nJ5TYhvB9TKA+37Bong3R7f/A3?=
 =?us-ascii?Q?E3IB7gK/eexlqph+3GkJoeqPHjWG2MPeu4GSwfWFv+TtTnlUDSgSqFZUzyiO?=
 =?us-ascii?Q?8m5jpUIS8ID1TnfwaEuTaoWUxNQPyeRTCNYA74A7cCYF7lYbEqAvVU1m3kZ/?=
 =?us-ascii?Q?wOXFXZ5k6VuIkhYWgPgPBZB/4J/JNpUF2IjrVsRwL1mRr68QluDXDoxmiBni?=
 =?us-ascii?Q?fFS2dcyt7u393yJbkxjk3mLSQvnBj7/o4KUwucTxBTkS3p3UCS2N2xcRdAAq?=
 =?us-ascii?Q?oecHK0fAi8bw9dNrzjr3v3Gvx1/UWXjCoQp4PVxJ5Bg85y/mlTbqQuW212op?=
 =?us-ascii?Q?tccOgTWgjxUH480D2cOKO80t8p1Tco31IAbjG2oj3sRqukyx8udX5K816Hzy?=
 =?us-ascii?Q?vokw4ZHu9QgvwD9LwjLvvwS592bqCzr5Wsl28SmzI/HPcyxI5gnVAXXaPfaq?=
 =?us-ascii?Q?ISu7SV1XU5frAmjMWnhUNR8TIgDWlgHULlC3fCBkFX2DQba+otbCNQfoM1q+?=
 =?us-ascii?Q?Vl2vWRSCq1Evhax+5puy4TK8mbQFgmKkj8sJaFZWyX4FVbyNW+r5bYbLfrGD?=
 =?us-ascii?Q?mpab9dTf1go+3kzbY0DdtxYGHKKWDtVUA2bq3FW79yPkj7Sl+rLgj8d/aZNR?=
 =?us-ascii?Q?/dWXoLxTm2fGHfRW4otf1nMIQiwBZ5pfrGMT8GcuWDN56Cd2tfm6JIezOUCE?=
 =?us-ascii?Q?YWoFSgCEc1DfjjD/j1YTUpELKRM8JoUrosn2EfhG7LZope49fUtLHm7K4+Bt?=
 =?us-ascii?Q?62wBq3xTPq4aIwmf/7kXGeXqfhj+vWZH/Z8xnIob8psgwydAwVfttdNOaB+R?=
 =?us-ascii?Q?UhuCbYIVQzDhyhx6LjfE+gbwzVsvtLNs5A+ALB2tRy6jnzPs6esHsqVWZH2Y?=
 =?us-ascii?Q?pIpA103RggOv356M9uty7pY+RpSr9Mn3/1lQdHvKxTySAo+B0EL2SbnhE7Ev?=
 =?us-ascii?Q?ASHNJigi3mSFH8kolPclPkcRjkH6XncJpKtvspXBEhnaOQwWXqZY+GhLNOWJ?=
 =?us-ascii?Q?6wSWqH1NQ7TSQtkj4B0LNp/4GoaP4q2XMssw4lEI854u7wPJiVxNi29S/M2w?=
 =?us-ascii?Q?dcqnIpRJAv4eXgeEB+PjKU9jQW62REiGcKmMgKGUyx3AZFv9uwXWpMiYkC4f?=
 =?us-ascii?Q?YKdW1kHv+M2W09lpLdK5PKBORW2/DYLS4xQyaV8sE8STC8ZKAQSKZyM8E3M0?=
 =?us-ascii?Q?eOX5vzrlGcUCnElVFScRhiLZ+NaEdIep/eJZeMcSYMbZdI/iYczkvJRc1s7c?=
 =?us-ascii?Q?t9Wl/2PLR5kZ5BXSaP2vxDjJoxfjmja2P2cHWBFEvFTL4KObX2Jk3I+LUhUm?=
 =?us-ascii?Q?iRq/PnPLgOQYnFz6ulyL5nQBdKW8HXfXmlM+EpdncP5kewcoQRly/6P8nckR?=
 =?us-ascii?Q?5TUSsw6jOkr8NmMd5UN5bYA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3620A446E4B32A45A6332168BB14822D@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3c9c385-5eec-45ea-4f40-08db740bcc34
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2023 17:03:42.2227
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KqG+UbP4UqtTo1p+AWY0qU9ow2/tFPrZzJrpUrbVoGj2NJtzV5mcFruUHJHs5lrJXLj3K8WTzEE3j8LLrHA2Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4192
X-Proofpoint-ORIG-GUID: pFVo5o7CE3ej-yT_HUdXtN8aXY7NiVUW
X-Proofpoint-GUID: pFVo5o7CE3ej-yT_HUdXtN8aXY7NiVUW
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-23_08,2023-06-22_02,2023-05-22_02
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> On Jun 23, 2023, at 8:41 AM, Jens Axboe <axboe@kernel.dk> wrote:
> 
> On 6/23/23 9:16?AM, Jens Axboe wrote:
>>> I will prepare another PR with just fixes. 
>>> 
>>> Christoph, 
>>> 
>>> Please let me know if you need set #1 (deprecate file bitmap) to 
>>> unblock other work. Otherwise, we will delay it until 6.6. 
>> 
>> I've done a for-6.5/block-late and put your stuff there, but it can be
>> dropped very easily. It doesn't really matter if Christoph's stuff can
>> get pushed, it's still a lot of commits late. So regardless of that, the
>> only real difference with a new PR would be that we'd drop some bits.
>> It'd still go into a late branch, as it is indeed late.
> 
> On second thought, yes let's go your suggested route. Make a branch with
> JUST the fixes, and send them my way. Anything else will have to wait
> for 6.6 at this point. I'll drop my late branch for now.

Sounds good! Here is the updated pull request with only minor fixes. 
Three of the fixes are for patches in the for-6.5/block branch:

 - md: use mddev->external to select holder in export_rdev()
 - md/raid1-10: fix casting from randomized structure in raid1_submit_write()
 - md: fix 'delete_mutex' deadlock

Thanks,
Song



The following changes since commit fcaa174a9c995cf0af3967e55644a1543ea07e36:

  scsi/sg: don't grab scsi host module reference (2023-06-23 08:28:18 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-next-20230623

for you to fetch changes up to a8d5fdd4d2702d0c7ec125bd3bbce3fc589afa67:

  raid10: avoid spin_lock from fastpath from raid10_unplug() (2023-06-23 09:41:50 -0700)

----------------------------------------------------------------
Li Nan (1):
      md/raid10: fix the condition to call bio_end_io_acct()

Song Liu (1):
      md: use mddev->external to select holder in export_rdev()

Yu Kuai (3):
      md/raid1-10: fix casting from randomized structure in raid1_submit_write()
      md: fix 'delete_mutex' deadlock
      raid10: avoid spin_lock from fastpath from raid10_unplug()

 drivers/md/md.c       | 32 +++++++++++---------------------
 drivers/md/md.h       |  4 +---
 drivers/md/raid1-10.c |  2 +-
 drivers/md/raid10.c   |  6 +++---
 4 files changed, 16 insertions(+), 28 deletions(-)

