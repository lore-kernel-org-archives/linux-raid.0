Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B44C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 10 Mar 2022 22:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343924AbiCJWmo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 10 Mar 2022 17:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237358AbiCJWmn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 10 Mar 2022 17:42:43 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5B6186441
        for <linux-raid@vger.kernel.org>; Thu, 10 Mar 2022 14:41:41 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22AI5BrV000813
        for <linux-raid@vger.kernel.org>; Thu, 10 Mar 2022 14:41:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id : mime-version;
 s=facebook; bh=1XyGo3Gjw56LaYlaktKTyYpWROo2DkZBgaJs/geiZXE=;
 b=RX31CUqPwlqzitYbHZSi+NUJEQeDbsWeATBL/iaJk7arGaJWihbJPdRt8X6AqAw7Oh9L
 C5L0ARwgJiTAmUsvi2gxDIJYlhMvAlgX2pybzSpoM2uf8fJBlovv+P2JontLpOiL56dR
 pd+siMGTAOn8k/SO4QU59o4ZBZYjb6D93l4= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3eqex2deq2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Thu, 10 Mar 2022 14:41:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kqyy8hDWLgczcYaybnkA9Wx3ndiFCRxfEzKWY/66dLqjPWyYzlsnkKGCycqy7g1x1A1jqCP66WvNFSYh6OjMC79qD6YMeDc4Mpyzw8mkb/uLPgFc3mJuw7Z38+0i9gz8s7pYMW0UiJcwa9LcnJQMsSHHMXs13/5dDjZrWppD45Zw7eBRFxLFsB8YK0NCScv6GKJnMyyLVKCcpbqqT83MPutrJmnBfw6INKYaMbAMqumXIiWr8b+QfXRPLXI/xywre+idJj/pTnWIR+zekH9Rn1bSaZmOZnvslVhmawUPySz638/792PaO9Ky+h0CcQ08RTA0tl+X918Q6W/BmsZyvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1XyGo3Gjw56LaYlaktKTyYpWROo2DkZBgaJs/geiZXE=;
 b=jn+qA6kBmNnWetbSnOhrstHea889jhmsKUM8R9IZIpCqvfZ73CXLLqii6C1CU+8pQ60kTrg/FjdsfIZlkcHWsg4IEvxxWd5UeIEjcZN4QUquqvC+ZaYxNx0w4m+KFSo2XL8WU+UrSPdqngClIzrHJM8ZV+lSeo2LpNhdKcLEO+yF0I553FFCyeLUcjPvwN+BOMsFzCA1AHVezNLeOkAzlG4OXPk2y3vne4vKHm/epejeXuO4NcI0ULUj8sV3mXNGJl70IERT4iJ6/+skNsbzSHa0/3WL3o0TZzh88g4nS+6y6AAwHRvjzHlabNBH8+Q0Rx77vVO5ulIGaq4kgkBB7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB4934.namprd15.prod.outlook.com (2603:10b6:806:1d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 10 Mar
 2022 22:41:38 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7da4:795a:91b8:fa54]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7da4:795a:91b8:fa54%7]) with mapi id 15.20.5038.027; Thu, 10 Mar 2022
 22:41:38 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Christoph Hellwig <hch@lst.de>
Subject: [GIT PULL] md-next 20220310
Thread-Topic: [GIT PULL] md-next 20220310
Thread-Index: AQHYNNAB3fIvzVVA8EikR9DnLu4mCg==
Date:   Thu, 10 Mar 2022 22:41:38 +0000
Message-ID: <0F4A0065-2209-40F3-A375-5660B5055FA5@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e8e5935-c2c7-42f3-c764-08da02e723ad
x-ms-traffictypediagnostic: SA1PR15MB4934:EE_
x-microsoft-antispam-prvs: <SA1PR15MB493412C045DDF7B410B2745AB30B9@SA1PR15MB4934.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VQill75WQUE+sShMN83Vo3If3q/Rm2OTqFrRqNFX8Va3rnS7GA6m49Z+LVyORUJoAij0yyPrsfCfiATNNJtfy+vrO8TXw5L/u8jZTyoxK3Z8jqX6a9iI0/enhUMN87xVcHi8YDexZ507D6ZH6DL/fTpjTGY+bQiTJwG8l84DsayU1CQuqYJc01gIfXg7iWkt+fCW81kJPZFwyFn2Fo7xqvrTg0LCdyT2maAPlyV55IxKzgHCOqFt0Ogy6QPYwHPqTm0XRuAyoNouuITc8LVfHlk7I/DzEBcbkan2Yr+qyjdDbJFEG0I1BJgD/dpR1aMAKVLQtrLUslo0H/6F0RqfZA6gJ1oiwMwtfdS8jTR+A4jBP3hORVaSgZGgnFg1h6P6DGk0fhGZ2fN1zIYPsCvkiPvj0/Lbo4XdVr9nX31UhhRmPv8qG1irobcXdNSZQ/+AxyJqShAzTAcKwcLj4wMelGk0C13MchFYGw2ckh+KDs9WkgG3szc6HpOv5flHj1VNLia8Eegq4MWYK45aOdBW1Dk/ZBeeoO0qoJxWpvxrCOc2TAYeF6CvL3XlBB06jUdPELecuO1/wHqzYO5GFaz7Aq2KseQ8CsfecmFK4TqZWn6CEiXjWRSKDyRc3mqwX9N4vNcGiDsoOmtlEdIXKfNLcNMSjp6l2McSaHGWPyfTCCrIei9pyyJWrKLvoDYYFG0H73TZ35ApuVrhPe1WCgDXOmI9pmi2oNyCZn7CLPnmpLg/1MFaCkRXaN4Xnb8NGoRgidMzjLG1SlypXLNctINU5wOdB1teoLFJ83YCz5cCrq9AfOR6TuqJjrtfpxF/c+tshgrDejzpiocWDsi9ixXdl0dHIYTV4tckMgbAZcjrHw0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(2616005)(316002)(110136005)(122000001)(38100700002)(966005)(33656002)(6512007)(6506007)(83380400001)(71200400001)(91956017)(8936002)(5660300002)(508600001)(6486002)(36756003)(86362001)(66476007)(66446008)(66556008)(66946007)(64756008)(38070700005)(8676002)(4326008)(2906002)(76116006)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lyItXl9DoLgIiIGwoENy3IyN3Dcb/dxShGOatp5InmwIuTiGg+1rwiCH40hs?=
 =?us-ascii?Q?cOwg3365fsEbV6FMCunnrKThpLGqfkR11uXJ2uzc+2Lhr3JYMHVeiTrIr8UI?=
 =?us-ascii?Q?UKFHVVtuAEesBFig7y3NksMRQ+0y6snc27MVvFLkFSwrolmg76/zZ0b4nMf1?=
 =?us-ascii?Q?uan5onKFPFEmRr+obJoTHuukVAHg3o9RXgBeQSfvhnq5dIGjZGFlDyOEmvzS?=
 =?us-ascii?Q?zwqcbdceBVLpmI3haDjG136zDgCLDhg9IxQfCT2wlUlWWR1h7u8N8QodKM7y?=
 =?us-ascii?Q?ZP+If/JpAidSuC8E0V/APMc0a9pi8ZHGJFUqiJkcXcbtWWeUb1UTqv254zy7?=
 =?us-ascii?Q?cdvk0VQXHEO5I/eyHAogljJDfHPE8o3mOg5vL8nz4oB4m33l3P8T8DKLHGxd?=
 =?us-ascii?Q?p7D0Uf8bhkYksf4tw8xl5sAGHJOpsGYmcyhQlR6QrmdQ0ibNp6ARm5fvEUUU?=
 =?us-ascii?Q?GEmrxVKyTjuzKKa+iA1meMBLn/9ag7dfSv5Ek6xN17EXoSSu9uwpFH1JvQuz?=
 =?us-ascii?Q?xi14NQFtYIR7X5ZJYR9p7XjGos9fkK8UrXtyKCMAzsV+5Die4NOAT1x6jWX2?=
 =?us-ascii?Q?KfVf10lQdsj2nCLOlRKPwYBzaAjkLAZI5PTsR8anKZA5Em2SOfTviyMEvED6?=
 =?us-ascii?Q?Hu+mH3KGc+iLrcWACKkg42uik0spX97RDmUQy3iG2LD4QVou0uFfUdzqOhHp?=
 =?us-ascii?Q?I+xOhe+HPfgRqcMyiwitUGoTSA30paaR8QXgW6Rll86BAYGCUELMjAIaeMGo?=
 =?us-ascii?Q?kZp2yv9Z/hEEuK+IS2+N2UisNnRMKAcewE5LsBXTDs9PEsaL/fsAT+vkhzjD?=
 =?us-ascii?Q?DZnXCh44kHVAS/gLPQdeN7ywDU5VJMxrlgK8rr60mPzOLx/JTJVpYnxmuyux?=
 =?us-ascii?Q?DfLUK2AonyGILu/DLUtjmg+qYcIRnwJ9ahgZUAOFwknYvVg1WxgDqW2R5UnC?=
 =?us-ascii?Q?U6PInjFGo2KX7APyq4exQuIfx3dT5A45oLL349/lYY0/2emJdXIkz/c1tpAz?=
 =?us-ascii?Q?XFUFumXae8nM7H+S+262etCQ82tHwJmOXKl1sYt8uSTa3X6vNosZLtiqJvYA?=
 =?us-ascii?Q?RFCWwXSdb/urTRP3SuhzKXh4fD0GEDs0d1565VVgtM668H0xmppzFOs/wSTZ?=
 =?us-ascii?Q?7Qu1a68xImOdK+uYcvYwGv9pYOv0B91qoULiNSBqbbRut8LDXzNKHFbYswwM?=
 =?us-ascii?Q?5NuXmam2IRkBHqckgiO74aIb2E+AMq8r63pA/7hl9e5y6ntqdpAz9GtmbUMk?=
 =?us-ascii?Q?t8jOeD5B54UMwhx3GhgJ7//dMg6n356bbUEKYYHugQMXb2G5vN+XKbBmLgFk?=
 =?us-ascii?Q?8KX3QE/DT8MET/sxk8X6WYFghy/iLpUp9ecAvn8OeJLBpZRENbNeyKOgOA38?=
 =?us-ascii?Q?HuRRjkEltETA4Du+ADvQz6VQ55xhE/X9hrkxdxQFm/2kKonDNTRcH1iuyuh+?=
 =?us-ascii?Q?7DZgVHjtA4y/sxf0BiHsSwU8B13YiBsMLTkThQG68FgZBYulIm4tssdyPdur?=
 =?us-ascii?Q?NwRWEI5n9CL3oiKU8tn9qm2rg2udcXmyIMgcBRk7IUB6QmCL438Pzgdz5veo?=
 =?us-ascii?Q?N0OUgSYOieLOMZ3GXDhtFGZp7fOs0ElSrZzJPvDVQKb3i1/1oOfHwCt3ha7E?=
 =?us-ascii?Q?roBq33dVTlwwzxHe56OwWWUFj2DcCvewppXAYzbQRzdPHmZcdDwhbnzeJmGa?=
 =?us-ascii?Q?gPBgXw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E71578B377B22E45934385AB33E88962@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e8e5935-c2c7-42f3-c764-08da02e723ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2022 22:41:38.4857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fsW5qwClViPVSHAf7U0nYubtEy+XnSObZGK6IY48d3ikzX7pE8pVf3zWXFut52lXq34n/xVdByg3o+0cAc8cOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4934
X-Proofpoint-ORIG-GUID: lCQToYOb3aiCrXIk-2eTh4UxLFNV5QxB
X-Proofpoint-GUID: lCQToYOb3aiCrXIk-2eTh4UxLFNV5QxB
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-10_09,2022-03-09_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes for md-next on top of your
for-5.18/drivers branch. This set contains raid5 bio handling cleanups
for raid5. 

Thanks,
Song


The following changes since commit a2daeab5cffa4d81a8c9bfedf8e5576cbca00190:

  Merge branch 'md-next' of https://git.kernel.org/pub/scm/linux/kernel/git/song/md into for-5.18/drivers (2022-03-08 16:40:12 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to 03a6b195e8e846f7373bcbeb3ea2a756dfb9ae61:

  raid5: initialize the stripe_head embeeded bios as needed (2022-03-08 22:55:13 -0800)

----------------------------------------------------------------
Christoph Hellwig (4):
      raid5-ppl: fully initialize the bio in ppl_new_iounit
      raid5-cache: fully initialize flush_bio when needed
      raid5-cache: statically allocate the recovery ra bio
      raid5: initialize the stripe_head embeeded bios as needed

 drivers/md/raid5-cache.c | 33 ++++++++++++++++-----------------
 drivers/md/raid5-ppl.c   |  5 ++---
 drivers/md/raid5.c       | 25 ++++++++-----------------
 3 files changed, 26 insertions(+), 37 deletions(-)
