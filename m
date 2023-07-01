Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92A6BEB64DA
	for <linux-raid@archiver.kernel.org>; Sat,  1 Jul 2023 00:12:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjGAAM2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 30 Jun 2023 20:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjGAAM2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 30 Jun 2023 20:12:28 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859583A96
        for <linux-raid@vger.kernel.org>; Fri, 30 Jun 2023 17:12:26 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35UMlfvN011319
        for <linux-raid@vger.kernel.org>; Fri, 30 Jun 2023 17:12:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=d34EINCh3N+m1c2mJbexkc8yslwksANq4ZPCF5emQz0=;
 b=EWH3rimFqnfKSiWjrQ3k/R4D8QJtaGCQjePWnW7W9vUd0RYq8w6pQ95nEp+/cs0WiSl+
 lc7P7ZRDi6UpWdDhGWh+HJ/H4KnET/CkBr3vHAcHOkeoP7D1p7St0xcoHkaMyzJ+OOkm
 Rr4uZ189fBooI1xos5VqEuLdgGEcoRUmLNw2N4kIccFM6QObHhr0WekyfOXmkku5IZJ1
 MFAHjzKbuL+T+w2EABJbKpAAiGlU/s3Jbusey4uZ0I6+kbZHnfKMFZEm4ZCEaLYtO2Qw
 fkkS/lIv29Fnsv/jdd7TU2ntPstpktYu8C0vWuDu68P42eic2vw5gvekEr19ujRkdYOE ug== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3rhuhw76py-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Fri, 30 Jun 2023 17:12:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ducLznNoSi53sLdJ4SBfAmaYAwz1V6kWuBSvLht9Fvz670IndefWoTWITS9Kq8KpA+o8R0xLtQu3ef/+wscFB5W24v5p7FQ3E5tLL05SZUz0rlhsWmBRRw5p89RlSHOYzFBcKqEnu/9bvlH5+vTA5j9bkU0vEilRFPSTRfFMWFcyEMpwonu9pW7aWffHUyCftaZ8ZKqOTZ85aFnHlFgY+Yn1yh8GN/YdZv7zcl6Aurv/ComsmpKpnVoXxDl1NTJH5lthJeA5qRL74iEXYIXQWGMLemf3qKKMvxg8ZZgg1pl7pUFqofV+4bWf2N0v6A+54Y4rLTVnnINAUV3rJ146MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d34EINCh3N+m1c2mJbexkc8yslwksANq4ZPCF5emQz0=;
 b=ZSpX2A+HS2tQpSJwnuN0iBdnKPoSF44ERW03qaGJVbVKVtQ39rcLtd43nbgHQoPEqQ6RTxUriqXkAo5c6DGQkO2CfOXOz1R6wOUXel7iTudjzH11Jd707N+s+SvxrKlN1wDclnLLNtsElrsflZq1Dt+TRjIvCKX4PLJHO/WyCFRzl3F9fWtHWWZ62P+7CsaB4gvWIqW2po6BCOVY0sQ+VxqVlZnZ/YgJ++l9N//uiOcEbFiGLeMnxeWIDnrS8uSlXzQiA4UL6u65+Oyaa+8qa7j1URJI/IcolWad6KGi0dmeqE5nAefLz/XPR2K+0NqplxjUhrEa7dXOeVdW8kfI3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MN6PR15MB6124.namprd15.prod.outlook.com (2603:10b6:208:472::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Sat, 1 Jul
 2023 00:12:22 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a353:7e78:2a58:dac1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a353:7e78:2a58:dac1%7]) with mapi id 15.20.6544.019; Sat, 1 Jul 2023
 00:12:21 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Jason Baron <jbaron@akamai.com>
Subject: [GIT PULL] md-fixes 20230630
Thread-Topic: [GIT PULL] md-fixes 20230630
Thread-Index: AQHZq7C0yGskUYbK+Em4KjCQLmWp9w==
Date:   Sat, 1 Jul 2023 00:12:21 +0000
Message-ID: <A098F73A-40A2-4B8D-8BDC-BB228B4F70A0@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|MN6PR15MB6124:EE_
x-ms-office365-filtering-correlation-id: d0544269-6752-47ac-3237-08db79c7d71a
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3qhCAO2/gXQLZm+atMjCqXN11vLR41NJ9dB6Kx7H28zzqS9dEXMelJniVlxaS51lBXoO9fc/PSxFjV4E326Db+oSz1xlWdhtGb01rcjo6OXeRoDB1zAg8t53f6gafynN3f4dw9x7iUL/EYW6vpT2DLhtcC1mM1J5yR1y0I+ldlg2VcJwuYREE1Ql1OnxEmVhdwZhFIhd2W/DgwbP73B2gFJo4okRUOB4h4WQvfwBG0/wcXe+0IuQjzzOB0M/VI9xUPVywOY3Ejp0DSsF/4HY3L2giWyYE0SRgMtzVRjSxmXz72j8MwZ8e/1TxNaF7d8CWM/Vc+4nvx0DwJ1m0UJkkxdHLs9uHlz6FPrqRwacmPYiKQ7TbptHgj4LEjiLA5d7KIKBSzAZaqZB8PPl6gnw0vsrruG0akkTUnxtQUcOaCLBaqiaJfs61Fu8buXRqpZ05fpFZpZNsb2F4osry73l3TTxURwCzj57YQSO6ivfsW+QkYV18Nh54ahSNCv4MQ0GFFL6ELi+zq0U/8NXH5FExkVy+sKFaRuMGxL3HdOXz1QY+kPct3i4Ww+kV/a6ti54IbTklC58OYJCTHxFEu2No5U72EpodzMgrr30+aTsyD4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(346002)(39860400002)(366004)(451199021)(9686003)(4326008)(66476007)(66556008)(38070700005)(8936002)(6506007)(966005)(110136005)(478600001)(83380400001)(186003)(6486002)(2906002)(71200400001)(4744005)(91956017)(36756003)(41300700001)(66946007)(76116006)(316002)(38100700002)(5660300002)(64756008)(33656002)(122000001)(86362001)(8676002)(66446008)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aj1QZZ+10kHQ/WhnQ0WCLYcM/tYJIpfxw1bncnxPCSaF8d7r/qhqykTViz2C?=
 =?us-ascii?Q?Zafv8XOlALXNz2rTSUgvTVs7WfFZKAG47TBQ3MZw7kfGYN6HgcR7GSWzSza8?=
 =?us-ascii?Q?lLqFSelb2EkEeAcz7MU6fjP6MssALfD89Z/8ANcskZF8BlRoz5ZHzU27a+wI?=
 =?us-ascii?Q?14EVEY2grkC+zH6e3xDS4hOZKGvBwcRpDKCVREeq1D5MgQiZ7x6yqODQIg9Z?=
 =?us-ascii?Q?8buIhFP0R1kUG9pZG1bGKk3evByodzYxrcajVMhic8iqyTlzmakUFDe88Kff?=
 =?us-ascii?Q?vT5M17fykD6yXLpxgoeHZXov1TlY/pREy+WwozBYgUBXwfBzYwyfPjur5LDf?=
 =?us-ascii?Q?F1rSxiJVK2/JVzBr1NoGE5e9q6ugyFqRQDLm2nKOEXzdfZS9zX2P4pdiuMWW?=
 =?us-ascii?Q?pWO5b4UDahEGOJ+P0PaVCvQ8imiOcqXoJUA9m+TprgBphhzOYkBbrowEazdk?=
 =?us-ascii?Q?kIPMsEvMqKNy+8o62Qz1NVgBI/zoUt81D3epQ8XOnuvBoYSVIh1qNnnVy9R7?=
 =?us-ascii?Q?Nsxnbm/D3LZX+2QiI+Bxdf68hKTBU3PlGzpMMT+270MnH/w4NHCjDGYje/Ss?=
 =?us-ascii?Q?9J7OVVMQ1LGWxQsk1iwK6rqXrEdetVaQNLRUkBshv0kjjVU8SVY/CuEyS9yF?=
 =?us-ascii?Q?Qf3M4TCg6306LBO0AYa79geig4fgPt0sIoXefCGmoT1/zhCNS2rfDnWo9ZQt?=
 =?us-ascii?Q?CVemJS4BA+OahZA9gAU3+hyVuuIwZq14UtGZnoufubGx5MXuXfd6sGfMMKNg?=
 =?us-ascii?Q?jlG2woYBCA/SwAWnWz9FjCgPxOhf/wuKw95pzZ6vamOSER1wSl4OExrzs7lC?=
 =?us-ascii?Q?FvIDZmaLhv9ldu0YXw1vgfGOAQhe8HHOARqNM7wy5Bcl811rrwHLyj/Jjc1W?=
 =?us-ascii?Q?36aOvMCudBWtVlNJTUcPp0yEJUdhjKzTe5PtpxWLaQ4SIN4HJQ/wr63QD33E?=
 =?us-ascii?Q?j+ejgVKx9Wiu8iK37oQ6sdL0JFyPVB+YSApyK2zvzUCQoLJ0ZD28YwwCcqB6?=
 =?us-ascii?Q?o4+hUc/iu+10ACZwIZOIl/8ONgULAFcrTq/VQeLYhYQf5u+NkRc3WUUcV+Uc?=
 =?us-ascii?Q?JsjKAiLqIUzYXNKKWRZe8f+VsnXss6GlpZBWioulP6cBLXlP1nm4dmUowumn?=
 =?us-ascii?Q?xL774vUoLdk/WZNHTSn2ZJAV2um+IwEGEpxmzhQwtUs7ONRHeabAVIvcRQtA?=
 =?us-ascii?Q?47oJQzb5GusajMqZZ+bd+50T2BUuedaj1dmXf3HiRU9uZ18z7Uxr8YsQmN3l?=
 =?us-ascii?Q?CaxFCywVPvnm9kg7hsQuYYEu6JWu2TEx3Bt5R8zAsM+cp0fCl2fV1I0hVMiA?=
 =?us-ascii?Q?djJow3x8s0E1/0vsocHWKrJE5jVALj7msAqw6r7V2x/6ztvYaNaZPumtNLvq?=
 =?us-ascii?Q?jsgb544JwHxgJi0t8JoaIrv1Csqm6kiCbhRcoNN/KpTf9XXkz+2+tGIenVsX?=
 =?us-ascii?Q?XXTWWG7f8CcS1xgIF2ZCEZ9Xlvo6E8ZsmF39Xpg+OJzZrIXtACaubjI6Y65P?=
 =?us-ascii?Q?juxvJ0yyAXIsjPu4UsF87Cbp7lsxiMwWqA18oGuErCJ8kuvQB5hNkmihHOw9?=
 =?us-ascii?Q?vzSfSrNVJeE8joWZAERO8dH1/Sj3sU3RlSyICpp6pGZ7tGIXlkMZ8oufU08O?=
 =?us-ascii?Q?bYOLdeS3yxbxCAabba9CuSY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0EEE5C3E966A1749BF2D194EB3820A1B@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0544269-6752-47ac-3237-08db79c7d71a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2023 00:12:21.6729
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3W85a9cyN4TKEBsJpk69XCAEow7KuKr96wgY/U9tqGbZl2TrafkpMCaRy1gDEfYpHfffahVXMuwNaCI0Ls2wCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR15MB6124
X-Proofpoint-ORIG-GUID: MOKgnCf6oLKac2v92BcCYDaCi0I9a66V
X-Proofpoint-GUID: MOKgnCf6oLKac2v92BcCYDaCi0I9a66V
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-30_14,2023-06-30_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following change for md-fixes on top of your
block-6.5 branch. This patch fixes data corruption caused by discard on
raid0 array with original layout. 

Thanks,
Song



The following changes since commit 6e34e784e72132c91b03d4f2f85bd4725b1ad9e5:

  Merge tag 'nvme-6.5-2023-06-30' of git://git.infradead.org/nvme into block-6.5 (2023-06-30 14:04:08 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-fixes-20230630

for you to fetch changes up to e836007089ba8fdf24e636ef2b007651fb4582e6:

  md/raid0: add discard support for the 'original' layout (2023-06-30 15:43:50 -0700)

----------------------------------------------------------------
Jason Baron (1):
      md/raid0: add discard support for the 'original' layout

 drivers/md/raid0.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 drivers/md/raid0.h |  1 +
 2 files changed, 55 insertions(+), 8 deletions(-)
