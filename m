Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D795EB64D8
	for <linux-raid@archiver.kernel.org>; Wed, 14 Jun 2023 05:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234506AbjFNF6U (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Jun 2023 01:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233669AbjFNF6T (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Jun 2023 01:58:19 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1683101
        for <linux-raid@vger.kernel.org>; Tue, 13 Jun 2023 22:58:16 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E39PIu029740
        for <linux-raid@vger.kernel.org>; Tue, 13 Jun 2023 22:58:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=mR7eK//F060+aSiIO8ZZTo+10r1g4c5I8phDlW2a0gQ=;
 b=VH4uiJF1kjEL4LVDIPzChJe6utOQha25KOieVKlTuS+m4Hao6fib56Kk7vVwX/9zvGRg
 LW2N4107tf9TsrsWeyRCyUDu8bM2nw6nrqhOlVSG0Bfth8goEQMLV2RXYm18XZq4f9LZ
 0BczlFaR0aJzva6/ZpOnV9If0ci4xV7YR+RfUz7xl7MM1W2xXBUG8ysm7XFmbjtM+s46
 tKIyTY7oqY93uvJ+D3CHUUshVo4CCOfNA91mE8Sgq65HiCtt1CGNCPwCht3YOk3h+0iz
 FTQFOaiL/EgE5DRIK/uTTw6Tps+4QRpShP+86OZB7NnkkU/rIvq9EHr2DKOrWn4rNOsG lg== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3r75cr8vqb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Tue, 13 Jun 2023 22:58:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ygw35zQwB5Gnf9MVzdNBeWkUNkdO2bODZinhszVNSTdeLQL3p40A+BwCGZAcyS1rrapbuDraNswg8xlopKWikiu1TLNOU/0ohPM7VCSDlNQfVx1scwAySOcNeO7nQ9EYeMJbfIOkLXiGo1O1TJyxreJXLS6F14tXPpY6uomjjQVAeRbwkBMiDflRVXD8NzwhbLFgeHAUXrAbJM/nbdM9lZUth/dhJ/4z6wMFHGtRhwLVEJvd/HffoPpKG6F8HPEG+9juy97F0VBCklNpKqItuAnMytc+L13zZVS8sYgF89FRm74s/8GfbXmz6xb+j9KZILLuL3dWkoQTlVKilrzxVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mR7eK//F060+aSiIO8ZZTo+10r1g4c5I8phDlW2a0gQ=;
 b=gB7YQwi1ipXftY7O83fPvYtPOfkqvR2mvWY9oABvD6Y+B15jT6FAcRmuqOsvtN0ZFitipAZivgogNWbmRJWjEXaRGXmK3xtFcCsnBXPzQhELHFFw9u8sv7FTltCGtG1BwNfnqGt0VKhk+RkXiPViUSiBjOxwTJLNBb4rDDXIAzkIebBsLSS7xet+xHgSoWU/WJbYvcoKRar9345FV9+FBxI1Lg+ZIRZRuGSpT7XskkVypiRKgclc9BX8wYZ8rq0Lf81zY0gvAgdQtpKyGjT50CpNlGSpDkEFnCt83fKxhLs6ZhzBNIqaPEwYO/eMyJcpjMYsCQwv3dUkCVGc+ndgHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BLAPR15MB3987.namprd15.prod.outlook.com (2603:10b6:208:275::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 05:58:13 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a353:7e78:2a58:dac1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a353:7e78:2a58:dac1%6]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 05:58:13 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Yu Kuai <yukuai3@huawei.com>, Li Nan <linan122@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL] md-next 20230613
Thread-Topic: [GIT PULL] md-next 20230613
Thread-Index: AQHZnoU0/9AEhhMLykqKDF7AUQ71MA==
Date:   Wed, 14 Jun 2023 05:58:13 +0000
Message-ID: <89E405DB-3E86-4741-971A-18ED541EEAE8@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|BLAPR15MB3987:EE_
x-ms-office365-filtering-correlation-id: 29155954-b9ff-4524-d97b-08db6c9c56e6
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BuSMvI5Cho/sfdj2E35Cr7kLuBncpkZAQ4Jl2CH26sYSFpQUo96S0FoUhZMyVvHUT+LksE7AJYrR9qVwpozdPVIIovKkvM1Re5gJ+fNEzPmcKCbX6++NQ3Mdq27ZTYghIS5En0oMXG35INPeT9eH5YG+YneWsqdbDdPAs/3NCi//lCod9l17IF8123We9BMAejmgfkNca2ciJK1xN9djLcpKSHenYeIFUyYaqw4+MmrjOnLeGP6WVMLkY8ZDRXTxFnsDUxavb7RTHrg1+ba81eG9r9KZmHoDNTXeKrOwGyYW+ke6tqR0aXnFZgRW990TGfStOpoZ47A5/yFEPA7jvUMjdSuZEvRrQssASi43c6jS4lStF4Qp2/0BP9CozzD83nt5QGb0DFfLocAmK75G20iEKp+mGBiIjtXjEVTGIosRDrJKeDqMKa1LDr+LTAHiydJAiK+2W+VnGTthxHW5uhIOW4eCrAyE1AO3WetqvLHra7pFlbag/6N+BJD9KdhQ+6BBVajgshSci9ui5/SqceBt3crYnmZIavj9UYh9lXPBIJ3lHa+zay8OmG6iFC+V4CHTz0rapprSayDCZC0fKPPrzRfygN2TCFlldopikYY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(39860400002)(366004)(136003)(451199021)(8936002)(9686003)(6486002)(8676002)(6512007)(41300700001)(36756003)(478600001)(38100700002)(71200400001)(66946007)(66476007)(86362001)(4326008)(91956017)(76116006)(66556008)(64756008)(66446008)(316002)(122000001)(38070700005)(33656002)(110136005)(54906003)(6506007)(5660300002)(83380400001)(186003)(966005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?w+WIT8gMJGDUSwgWhFXnfVGi9S3fDJluiWjPasv15I5X8tBhS2gglU+4sVfC?=
 =?us-ascii?Q?n0ngPB9rzQU1FO6xRFNOmc6s+WUSkmpgRPGUCiW4nre/VqDDcspDc7C8qi0R?=
 =?us-ascii?Q?2DJ5fqERggOKC29Zsu2iAEbrq1GAmQi3LlMBVYrAf6QNdrEPwDsS0McxOU7y?=
 =?us-ascii?Q?J+eZsseAT5x63kGL+jH+JSoQ7mc05+BxrDV6y7nRfNt5B0nZP9xbLUy8nb9b?=
 =?us-ascii?Q?Rh9kZ8hlXREYz9q6jLnr0kmZdz6Oyg9t8cbmSwqFjAOhW8CWxaUbD0n6T5K4?=
 =?us-ascii?Q?75slZ5O8F7MsG5g65w2xMWuWiCaCA3i7/n31m1numdIQecELaVeXWyW24ua5?=
 =?us-ascii?Q?2p4YRXRW6u5YcKRrMrpGP1QsPw0BtPkrpQpdwADPT30GrF2f4ifoy3PGVSGE?=
 =?us-ascii?Q?vUK3DIhPw1sKVSH8uTQB6fLU4MWhxR50CGKas08VYoN1j0EmyhuSRRb+wxNe?=
 =?us-ascii?Q?RbUui1M8YijCHB/EFdKJnOzXW3qqotPPXyaW/iXPxzSCXOTgbAMhzBlq2ptH?=
 =?us-ascii?Q?8+3gQaMxVCA1m9OCuJHc2Qj4pXJe6f7Ad8WRmrjYJymo01OyMD1mCV5XzBQc?=
 =?us-ascii?Q?ceh39gmXQxypmEHYzxaJNFSi5gWZtVV+n0dD//GRlM0WiQCIB+GrkdlWkyTy?=
 =?us-ascii?Q?CQkCcaskOvx1vXIKZ8ns3C2ZBfypUKEUmvoXXILGSsZ10+8ORtljyvz06ZvC?=
 =?us-ascii?Q?uQKGOr/lOhwzbx5S/R4eeWgG0jwfxTc9325WadG0TCJ2LrHM6EM0xz+f0OUD?=
 =?us-ascii?Q?/I5YxePhkR9l6hcWI1jejTLr+KigDjb4Mod3wdPFq9pL0eis9+NZLDoa9Kg/?=
 =?us-ascii?Q?PfbvlNo4FbvjkxzqsVUKsnrrnwodRGWFLQHIL5dyEu7ajcA1G5WMRfY5Co6O?=
 =?us-ascii?Q?eCaBuNDZrW0G6ABeC0ZevhM4S9XtTI2B5Jyc2xkmv6DxbDtXDYc1PebU1ggs?=
 =?us-ascii?Q?BJjhTLmxza697a2dERWD2ahzSFSZdQmS6gDJnnE3Iq3gmb1IzsWHUFWWBJ6Y?=
 =?us-ascii?Q?I8Q0OAxs2uXg4iz51K+95/uRAMSJVfnyecLbshZBB6TFHWPctLQ74uUsi9Az?=
 =?us-ascii?Q?3axUYx/3BCy7DMdBanAGPx2D9qzgUrueLpZnuGe81Xn9BsFBEyn4gQ9k+7uN?=
 =?us-ascii?Q?5A9sA44ecEG99IcM5qYuVVgDZsArHRHL0jG821LWNg9Kwrr9HWvo29CmeDKO?=
 =?us-ascii?Q?DYzbDusLIFs6TODokvHgzqBZLU5qVGpYlxmG2ZVI3i7rq6lJHgo05UMlvJU7?=
 =?us-ascii?Q?QZqOKccEoxLDAO63PkemaA0e9Aj+sisbQ+vB0Y+ZSF6zjPVVFY8I6utGr+gt?=
 =?us-ascii?Q?RlWLegZqq2HmrP8nr0wRRz/bDevrEuklYnhgAEeVXMCEd4R9aBz6n0wjbMo6?=
 =?us-ascii?Q?BfDcDfhY/SuQFmXioMwsgzQBpkuChzXwVGgdwbKcON8hf5k4ZsvDKyCES3tk?=
 =?us-ascii?Q?HP5KpwDy2F2woldJZMmlUPxO2NO/DbDptrQGcucR2FrlcJkV+V/DzeR7JcBm?=
 =?us-ascii?Q?1m1gc9GmuwyRSh/FiIx+5TfO6uk0ievYNpE90iBDNtf9L+8Gp/j0zv9jDujE?=
 =?us-ascii?Q?F8GI4Fyh70sjeyXPn2AdKLs7u3/Hti0SsdNYXuddoCNKxPeZ4oYrrjkJCO+Y?=
 =?us-ascii?Q?LoK/H0uYgMKW7dpCM0ArBuk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <30D98B1E1AB180439AD6714DDF87FF16@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29155954-b9ff-4524-d97b-08db6c9c56e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 05:58:13.1199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j5k9jt6H8OJNrLxyig2tKfol6B3ONCGxtW2mPPuWWP0xYFmdX4nrqWkQPY1cbORUWibrPm7iR0C6GY/rZQ43gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR15MB3987
X-Proofpoint-ORIG-GUID: -1_PEkFwR8lFqZAqLObRN_cArkA7hXvu
X-Proofpoint-GUID: -1_PEkFwR8lFqZAqLObRN_cArkA7hXvu
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_02,2023-06-12_02,2023-05-22_02
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes for md-next on top of your
for-6.5/block branch. The major changes are:

1. Protect md_thread with rcu, by Yu Kuai;
2. Various non-urgent raid5 and raid1/10 fixes, by Yu Kuai;
3. Non-urgent raid10 fixes, by Li Nan.

Thanks,
Song




The following changes since commit 3dbd53c7be1c3dd04875a0672262b56417039869:

  swim3: fix the floppy_locked_ioctl prototype (2023-06-13 09:45:40 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-next-20230613

for you to fetch changes up to 460af1f9d9e62acce4a21f9bd00b5bcd5963bcd4:

  md/raid1-10: limit the number of plugged bio (2023-06-13 15:25:44 -0700)

----------------------------------------------------------------
Arnd Bergmann (1):
      raid6: neon: add missing prototypes

Li Nan (9):
      md/raid10: check slab-out-of-bounds in md_bitmap_get_counter
      md/raid10: fix overflow of md/safe_mode_delay
      md/raid10: fix wrong setting of max_corr_read_errors
      md/raid10: fix null-ptr-deref of mreplace in raid10_sync_request
      md/raid10: improve code of mrdev in raid10_sync_request
      md/raid10: prioritize adding disk to 'removed' mirror
      md/raid10: clean up md_add_new_disk()
      md/raid10: Do not add spare disk when recovery fails
      md/raid10: fix io loss while replacement replace rdev

Yu Kuai (19):
      md/raid5: don't allow replacement while reshape is in progress
      md: fix data corruption for raid456 when reshape restart while grow up
      md: export md_is_rdwr() and is_md_suspended()
      md: add a new api prepare_suspend() in md_personality
      md/raid5: fix a deadlock in the case that reshape is interrupted
      md: fix duplicate filename for rdev
      md: factor out a helper to wake up md_thread directly
      dm-raid: remove useless checking in raid_message()
      md/bitmap: always wake up md_thread in timeout_store
      md/bitmap: factor out a helper to set timeout
      md: protect md_thread with rcu
      md/raid5: don't start reshape when recovery or replace is in progress
      md/raid10: prevent soft lockup while flush writes
      md/raid1-10: factor out a helper to add bio to plug
      md/raid1-10: factor out a helper to submit normal write
      md/raid1-10: submit write io directly if bitmap is not enabled
      md/md-bitmap: add a new helper to unplug bitmap asynchrously
      md/raid1-10: don't handle pluged bio by daemon thread
      md/raid1-10: limit the number of plugged bio

 drivers/md/dm-raid.c         |   4 ++--
 drivers/md/md-bitmap.c       |  93 +++++++++++++++++++++++++++++++++++++++++++++++++++----------------------
 drivers/md/md-bitmap.h       |   8 +++++++
 drivers/md/md-cluster.c      |  17 +++++++++-----
 drivers/md/md-multipath.c    |   4 ++--
 drivers/md/md.c              | 226 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------------------------------
 drivers/md/md.h              |  37 ++++++++++++++++++++++++-----
 drivers/md/raid1-10.c        |  63 ++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid1.c           |  36 ++++++++---------------------
 drivers/md/raid1.h           |   2 +-
 drivers/md/raid10.c          | 179 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------------------
 drivers/md/raid10.h          |   2 +-
 drivers/md/raid5-cache.c     |  22 ++++++++++--------
 drivers/md/raid5.c           |  68 ++++++++++++++++++++++++++++++++++++++++++++++-------
 drivers/md/raid5.h           |   2 +-
 lib/raid6/neon.h             |  22 ++++++++++++++++++
 lib/raid6/neon.uc            |   1 +
 lib/raid6/recov_neon.c       |   8 +------
 lib/raid6/recov_neon_inner.c |   1 +
 19 files changed, 508 insertions(+), 287 deletions(-)
 create mode 100644 lib/raid6/neon.h
