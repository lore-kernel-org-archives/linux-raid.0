Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B02EC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jul 2022 05:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbiGTF4Y (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Jul 2022 01:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiGTF4W (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Jul 2022 01:56:22 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8B15508D
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 22:56:21 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 26JI4v1j006835
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 22:56:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=1K759oHEOdXOaL1wYsNeX5mmY9CMah4lpbCTrCoBoMU=;
 b=ZuQ0RAvOJVigv6pS805Dgfw4JRqgBYCf07eMGmGSIYUA/DYNLQMXq3TmsVLx+2B9IkqN
 +aLaClNvtm66SDtponhYz++x1bOpbPvK3kHxxmDtL99dSjbrlerucL0AF9UAndetGaEf
 vDSwby9DknWq6VQ+DiOIVoeuzf+YDwBMY6I= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by m0089730.ppops.net (PPS) with ESMTPS id 3hdv8f5um7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 22:56:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L0GcIOFJKJN5SGEkD02Ds6Ie8P1g9b8DXPNfDlf8IWOa8f4HY6Xj4xtWr5+AD24dBMzRiWh+YTzDUz68N6Q3bxssYyOI8eU2SzaN+ior85vXHb38F6qSzf82oM0Cs7tfsVKpl/RAj0Dgeg6nIPnf4f2WK1LNyQrbEdz7Qag3YURY7N8xxozP+GVzcJdPun82OJbeKOhPBMKblxgvHV/bgbgrtVj9FF061BHV8zH9DtBlx6EEtr1NjQEYCycKJqPdrOiVwE60D+TcVcTx4A5GF4QD+YcW31JkfsGP5eFuxIHgO9c20Vw36KoXBIPMoRLntPswOyhGKQtx8gop4aJ2yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1K759oHEOdXOaL1wYsNeX5mmY9CMah4lpbCTrCoBoMU=;
 b=npyTQ4n+h/1rr0Vq5Sz+7jD6PyE4WaWPk+tN2jg9la3hV0HZWtfJOLWFIM0sFgep9OWzxbnLN9WQoImGOlBLSjsN4MjQqjF77KTgK7pb11PHmQiDjH9QSfMCbCnYfJbNdMmZbC6Enlu6/jPos6L66108va9C9emazDT5MMYc/NBNz5vLgWtjoU7VV79ZAEMlO5Z27EeSY+aJMO2+jji7BOxY+l6lKwLiBkcCW4+9guzhaNuUWCeUvyUrSAYT30C22S7g5TMCqP5snT2EpTh2K1/eISQppCJoCBNoEmG4/d9++Uv/1qRo5kNSBDrRPKvz4gxPasHerbYUQjtaRl/xYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SN6PR1501MB2192.namprd15.prod.outlook.com (2603:10b6:805:12::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.24; Wed, 20 Jul
 2022 05:56:18 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5438.023; Wed, 20 Jul 2022
 05:56:18 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     linux-raid <linux-raid@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Jackie Liu <liuyun01@kylinos.cn>
Subject: Re: [GIT PULL] md-next 20220719
Thread-Topic: [GIT PULL] md-next 20220719
Thread-Index: AQHYm59itXAinBFwR027LgYV2rHJOa2GCCmAgAAHHwCAAIQpAIAAMCkA
Date:   Wed, 20 Jul 2022 05:56:18 +0000
Message-ID: <D5C50E0C-3301-428D-9FF8-642EA1568445@fb.com>
References: <5553FDCD-7628-4A40-A228-8E1BEF6FFFA1@fb.com>
 <57876115-7e41-f11e-3cca-738235cd68db@kernel.dk>
 <7C4DD0FE-6C05-4BF4-9A20-8C6A012B6658@fb.com>
 <c8cad78b-08cf-43e4-6610-6978fe0ce201@kernel.dk>
In-Reply-To: <c8cad78b-08cf-43e4-6610-6978fe0ce201@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0ff260b2-b2b8-4ccb-b47f-08da6a1490b3
x-ms-traffictypediagnostic: SN6PR1501MB2192:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sTjUiARQz2Px4Vq0Q5TpiTfTBDOBLFlvK6jW1aSiih1WvryTETz5RgUYqP28Ruma+muNt0E45Zd4HhnhTj+GXvDlA0oZJW+e0O+UskxhSPlvYkIsSSSl6sXIjUHdiOKOCeQNI4MadZdgdFzc4nOEdHQr5F737OzPcrCQuKht5SrB6hnjLAczWSQzvzrVSTd003odetD3VEZVIR0L7GZXgCC23PYzfSvWo3lgpcSZd+rqZSAwur9Ic0BtWWAv99zdAPj3fuL/Hfnljzsx+gyrYHyUijjYPReIMRzVgKqX5Cw+XjmPtXnVbw5NUnjCqNKZCDo52pDSitkMrOhnQt3YLaNBFKvilyBFcNdeKZfFRvc/OcJAvC0Ja3j3v5UNlAo7q1Q9Y9YTFM7QwpZijfqr+nLnKN1D24x43cPoDyEocrF1oWd4geVMcTyU8NByDe1/MAIg6+PlSgG5YtOkK+CRvuz3sNtL1QOSIrCRB0jJtIf9tEFF0uooOAPZhIG+6wyWvllJp8itDqu5X51zkso8+SwbJ16jsjW/aVdkzeGKpdFzjYyb3HLhJ84TKCaSpe5o3CQo4sboiRdtrKyNl8C+S1DyuS+ZNpnpfO72tuRoouomo8ffW2VfosgSiLPeM475Zkod3kMnf/gV7INttRkBvYXrA5fGBBM/+fi0DZJaAI/hH3ALPUX28g9Mtk3RXMLp4fpCFBbyPfl8PtcC/F708eLXaCk52ifa0/IvS/xGhSJtx18vgapSJ2xI96WNt2+o3MZHJp19kh0OVd9brKbF22925cT3SU1PaOuOTnaZaRfzhvYVaA6g5g0hRILcp/49Mw3+x9orAos9YB/VuCpyonzYr0INzaqc5VmjOJ5bVlTO1Np7gmVlNuO0qdlO8nWl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(396003)(346002)(366004)(136003)(316002)(71200400001)(41300700001)(54906003)(6486002)(6506007)(6512007)(6916009)(478600001)(53546011)(2906002)(966005)(91956017)(66946007)(4326008)(66556008)(66476007)(8676002)(76116006)(66446008)(64756008)(8936002)(122000001)(38100700002)(86362001)(33656002)(36756003)(5660300002)(2616005)(83380400001)(38070700005)(186003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YkKdjR4GaH/1bf2ADh9f1QlJI2CfZOZbRre0Ci6CpOzGfz9AMwXYE4DTdglv?=
 =?us-ascii?Q?/MXszT1oOyJndpM6AUzfToCohKOHnRztEORc0oZ9moduNTqJS2UbdZdQsQHW?=
 =?us-ascii?Q?buKVweNjxIiM9Q2w6BbDnrPCGA8X2/PjoL+67uyQ0nYzFrOhYwzTeA8T73sj?=
 =?us-ascii?Q?p934udTHYYNBs8Fdgrf1niHtsZxFW8rRmIFx7bsRqqhCdcra4z1805jN9xrq?=
 =?us-ascii?Q?c2vyd1RnDWV3VMWzqecdq13jtUAUQuXVFFMSCWiBLmjGUdg/MFhVpoSo7ryJ?=
 =?us-ascii?Q?gagLjmfeXVFAo6C1FzyMrNqCKd0IxKyL6iHC+FsaQe3tWmRFtwPzJO4XNUss?=
 =?us-ascii?Q?WyT+GDXwOq9sWrsTGO6epXoYbh+jq5z7lHblYLXbdUCfLpoSzalNBwCzBytB?=
 =?us-ascii?Q?nCng6n62ynD18I/cl8D2rZcX17WLsal0gehBv5JmPIj6UUIzb51iY47Wr0DX?=
 =?us-ascii?Q?cGm9MhIG9AD9clz83Op7BHtBUQZMdtYELGhZIfsS32HaegO6WCibqh5QapSV?=
 =?us-ascii?Q?M0ymqhUGQcGKeqeZfBFcFugGutQMNCoY/yKMTNAWxZa4pGvaTGRz+QGl5sgM?=
 =?us-ascii?Q?YwbbPDhX4R/4D9Kjd9jZE59NeGS8yFSzkEKEa5b59sI46g9GLfVKTt4rW0Nz?=
 =?us-ascii?Q?BxSnt6OQjhlNVsGsIEThlG2zgsCZAUaMW/RlLBfuZKfEtCHrhzZaQ2gksKQl?=
 =?us-ascii?Q?XHDu7sUJsnZF+Mgz84dgAZ1ovUQk3XQZwpjXfl3akT58e+KnKJ06ti64/0KH?=
 =?us-ascii?Q?o+qyZ4zvNSAKCeZ2HpeQQX5SKCF2reiN+/a6K+XshaLeClsixjw/7kuUoFxz?=
 =?us-ascii?Q?veKID76pL185O0DKf7ll/K4VxXfeI4QYEOje16GNURU27llMp1WGewxYJitM?=
 =?us-ascii?Q?e8DBMiV4tJT/gYlsjCVVV0hvrh2++1IdvDppSpSbhXkjKjoSgpn3Pf+AwdJK?=
 =?us-ascii?Q?K3qJgthCJs6zKOp8ECEwc+0uNMAm79Xlt9RSCAcv/uC53Mwsqm6BHobIQdRw?=
 =?us-ascii?Q?MpRvHopsF+/FXus2UW7hNMC+f9U1OBOT2lK7B/9xpgHR3FIWBZhvpFWrSfur?=
 =?us-ascii?Q?0hYby6/Zxiombu67G/+N1Vhd9RBllTL+UpSw3J93VdTN+xxDRodCH0bvVS1P?=
 =?us-ascii?Q?WBBQ0MLkI1OY0ysFwvH2+lM765I3iD+KwJsRhmMY4BXbVVJ9/mF65/aunQW0?=
 =?us-ascii?Q?rV4C5EhQQnJm6mZllZU043D/1VBSrlX4Bp89ytLrENUka0c8g0yKxLZrlQpL?=
 =?us-ascii?Q?hJ46Vymq4WkIKBVm98icBns1WptPOYoiaIDcFwbhahIFGsFYMCMobecDY+Mg?=
 =?us-ascii?Q?T+l5esl7+dh/KKElhsYmXUa53wI6CumBoobGm+2Aj9YJfdMoLR1u6fbCS/cF?=
 =?us-ascii?Q?8MpF5ensMrkhTVkOP0+n6GtiunrP2mH0eaR4Z2a7jHcyywsVaQC/NoQsMIXt?=
 =?us-ascii?Q?QRMPi7eNoYkWk4k4tdpBK/oiXTxs0qDYkaKVbvuERJTz/9jKTcX5miF8wHSV?=
 =?us-ascii?Q?WK4d55iE7TQmyDzyj+P+R1oUshBnEulTD0h8XX72AdGwl0M9loYd/sHigKxb?=
 =?us-ascii?Q?qlXdpH94Nok/gZ6P02HpgjJQBc4hWK23PX3ZbFvbQU7dTde7GG1ccaI1RiGQ?=
 =?us-ascii?Q?jYbZjsQ7QoYY3u4TjVROcA8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <794680C184C05846B1A78D4BFC5FB9A0@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ff260b2-b2b8-4ccb-b47f-08da6a1490b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2022 05:56:18.5620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mdkvLevFC32gAgC+8daogsv+KWdwFeBxoUqICW+MO5XJ6lTZab2C4NiEhf0o1j9MEEassomKjibXaL3oKEiGPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2192
X-Proofpoint-GUID: 9pk1SDTSaRunOCnfbNPY_3FmeS4EzkdR
X-Proofpoint-ORIG-GUID: 9pk1SDTSaRunOCnfbNPY_3FmeS4EzkdR
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-20_02,2022-07-19_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> On Jul 19, 2022, at 8:03 PM, Jens Axboe <axboe@kernel.dk> wrote:
> 
> On 7/19/22 1:10 PM, Song Liu wrote:
>> 
>> 
>>> On Jul 19, 2022, at 11:45 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>> 
>>> On 7/19/22 12:43 PM, Song Liu wrote:
>>>> Hi Jens, 
>>>> 
>>>> Please consider pulling the following changes on top of your for-5.20/drivers
>>>> branch. The major changes are:
>>>> 1. Fix md disk_name lifetime problems, by Christoph Hellwig;
>>>> 2. Convert prepare_to_wait() to wait_woken() api, by Logan Gunthorpe;
>>>> 3. Fix sectors_to_do bitmap issue, by Logan Gunthorpe. 
>>> 
>>> This has worse conflicts, it looks like. And not particularly trivial.
>>> Do you have a merge resolution?
>> 
>> Hmm... it was a clean merge on top of Linus' tree, but got conflicts
>> with linux-next. I guess the conflict is from other changes in the
>> block tree?
> 
> Most likely core block changes, I would suspect, from Christoph.
> 
>>> We might want to consider doing a special branch for this...
>> 
>> Yeah, I can port each patch on top of the special branch. To make sure
>> they all work. 
> 
> I've done a for-5.20/drivers-late branch that you can base on, that
> should be the sanest way to do this.

Thanks Jens! (assuming the branch is named for-5.20/drivers-post). 

Please consider the following pull request. The major changes are: 

1. Fix md disk_name lifetime problems, by Christoph Hellwig;
2. Convert prepare_to_wait() to wait_woken() api, by Logan Gunthorpe;
3. Fix sectors_to_do bitmap issue, by Logan Gunthorpe. 

Thanks!
Song


The following changes since commit bd1ebc67722962962b0d568c26f62bfa7bfe786f:

  Merge branch 'for-5.20/drivers' into for-5.20/drivers-post (2022-07-19 21:03:38 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to cce99141d81f4967ed0936bb3506d6813ec9abfb:

  raid5: fix duplicate checks for rdev->saved_raid_disk (2022-07-19 22:46:28 -0700)

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

Jackie Liu (1):
      raid5: fix duplicate checks for rdev->saved_raid_disk

Logan Gunthorpe (2):
      md/raid5: Fix sectors_to_do bitmap overflow in raid5_make_request()
      md/raid5: Convert prepare_to_wait() to wait_woken() api

 drivers/md/md.c    | 310 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------------------------------------------------------
 drivers/md/md.h    |   2 ++
 drivers/md/raid5.c |  35 ++++++++++++------------
 3 files changed, 183 insertions(+), 164 deletions(-)


