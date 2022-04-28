Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C84D0C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 28 Apr 2022 00:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbiD1AdE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Apr 2022 20:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiD1AdD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 27 Apr 2022 20:33:03 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB88BDFFF
        for <linux-raid@vger.kernel.org>; Wed, 27 Apr 2022 17:29:50 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23RLlPka012334
        for <linux-raid@vger.kernel.org>; Wed, 27 Apr 2022 17:29:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id : mime-version;
 s=facebook; bh=nW7sFCz1M2eI6He/TaEWLq6ST3nqoqgS6Ma2ppk/zd0=;
 b=XomRUjQWzjckz8oADTqqPbEikNWcuvkZm6aK7kYroD5lO4qRkWAkXCzylduPQh0CRVWl
 M8jECU7AHFSgbUuvp/3QmzP5R8vykGXi2iq8d8uT33+DwP6aHdjM86E9exbIj7irvbc9
 DF1kG0ZsMQwnl1kjccAInVDxeVfnf/JIuyE= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fprt8gvq2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Wed, 27 Apr 2022 17:29:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kLjOgzfsuOy+9bpdU+DB91c8FE0UIl9+Oupk7QdJKKE6czY9WtXM6jL7NhoZg9BOYnBdMqlg6X1o1/5DetnFkOUEk3xg8AI0bC23B4HwCbipE54xdavB2xtRsasdGx9V8rjPnFXognNkhQW/0oxUjCCOPYzqqUyp78xfOB6FdUIg1DvMskfyvm/aYZcYtsGygIdKu+WSwRfD7G3SnTWHmk7K0Ib5BxUTlvHTVQ07WQWbZhHPmSK1tt7xyULheSqq2Q0LfuIQgpf1ldcq1BM6X2vjft4dD+RpIcMe3OoDg1gitZVW6DAzht7rplrs+Szf801qyF3kYjTOcdxs0vtUzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nW7sFCz1M2eI6He/TaEWLq6ST3nqoqgS6Ma2ppk/zd0=;
 b=NQEAEcAcJb0zC1VpJ3kEFiiVkeDg6+eaXM/tahzy2dA8VhZCWtnBfMOw9KH+C0seUH2MSMthYiBDLv+5c29yASMtXO2SUoBncwmy3semaQxC68P5oQosKcM3xdsRsT1FUT275vm23+8dRlli7b+xNvHXi8vyJ8NJOnDdLY+VF1YQi2xIMMPRbYfQyhW7GiCqUyhMHE/Xlm6D16+ryRO1ZD0wprTYih3gbOg6WbdJE9v9b2SlJ86b+P6Jz87ryqCd4vmmzOeK0Y/nzocQGKBfuaqbDhpIsyPbWECj3EO21PLPdxrFcd3F4lyS/9MnTKpNqCsLeo+mUMkOa4v9IAI6Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BYAPR15MB2294.namprd15.prod.outlook.com (2603:10b6:a02:8a::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21; Thu, 28 Apr
 2022 00:29:47 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::15bd:ee6f:cffa:44d8]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::15bd:ee6f:cffa:44d8%7]) with mapi id 15.20.5206.014; Thu, 28 Apr 2022
 00:29:47 +0000
From:   Song Liu <songliubraving@fb.com>
To:     linux-raid <linux-raid@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
CC:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        David Sloan <david.sloan@eideticom.com>,
        Pascal Hambourg <pascal@plouf.fr.eu.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Heming Zhao <heming.zhao@suse.com>,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>
Subject: [GIT PULL] md-next 20220427
Thread-Topic: [GIT PULL] md-next 20220427
Thread-Index: AQHYWpcQGgJCJxn+R0SYHDZtIi2uUw==
Date:   Thu, 28 Apr 2022 00:29:47 +0000
Message-ID: <EEF117E6-B4F7-4702-AF1C-37FAEA131697@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e529ed27-5496-4ae7-66a8-08da28ae3308
x-ms-traffictypediagnostic: BYAPR15MB2294:EE_
x-microsoft-antispam-prvs: <BYAPR15MB2294E7591668B145E1C03C49B3FD9@BYAPR15MB2294.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8e5OW8c4/ZpEzkBNu50NbTlJyAlNIOQgUmPysXIZh0BH/GKUA75utGqYnpalh+cQxOU3MQsTpjZA1egNYmsyGejB3brsezpEAxP/cQQaRmLxjMGNHbpxCW7qawzAJUj9d0vXpfofJp6f91fqMHKUcBh2/O/CzUmGbXJbjm28xgjh5ZoMtN8pFEioPrI0roW2sl40qeyIHz7hieV4ajVJGcJO3NcLCg6b0KAxkW54Ne/iaQ7vZaxYhilHK/vy7TFCBlgmOZYEmhsvz1ipV5sxTYU+iII41HHwDaUp76ISH5wppc41tDUqZ66gz42GHonJGpO4XdO6xGd55bVTpjvaqEy9UtK6JJ6qIttdvkJ6ZFu7sm35zgILMyYdGyYu5pfWajmmO5NKfFEoZXJQI0UnlSxbWwJQaRa1tkrRLlRM+kn/hOZwpPmcxbJa6/CdgYh0xTKAAtxwN5vtP5XsYwBPXNsR8qufyr/zmGN9u5RWWV9QGgBCCGEj/YKVm55Umpztg4WSp1IwgcWCrq9tEiCxyEovxWi43390dI+JP85W/ahrdib2X3dPZznBQFI5IdKja88Y1iamVQJvRT4bJW7n3TMV5ft1lo4NbhV3R31VE/5PUU2/DW+8KkI5zssUPcVyk5Cw69wrMkbxDswllcdO/DGnYIcEj/nhy1Mpi0EcZ1Eg/V1jvYTxBVlOtbv5QhC/5UPY8788Xjl1a4oey6D7qF97/6Wblc0xFiZCKs5a8JniWjYyDLv5YVukJ/RjAMYg8aJlv7BTcHf2PbvpCJPXYdk2yIi5P1/DljRJCD79GnEIH67cmfwy0VwfxRI6PsFI4aTBkuaG3Vout/DKEFiB8A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(91956017)(66946007)(186003)(2616005)(38070700005)(64756008)(76116006)(66446008)(83380400001)(66556008)(8936002)(5660300002)(508600001)(6486002)(966005)(8676002)(122000001)(316002)(54906003)(33656002)(6512007)(6506007)(110136005)(38100700002)(2906002)(66476007)(36756003)(4326008)(86362001)(71200400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7Uo2uYl58c/eG8VDFX1jpRYRCxmLmq4gnV82E5PI5ewsOAalC1m9TR1s37ql?=
 =?us-ascii?Q?rIiZjAjj2McCOSHkHSJkSnAKpryzW7kPxhPUI7bNqa+KxRN4Wxjh3iwp7mHm?=
 =?us-ascii?Q?qhP7TdWzzXBp1EoBR1vPrfH7jjgF2/8tT9NLuUT2PU2eea09qZOqS9p2dmTd?=
 =?us-ascii?Q?6T6HaYcBJelarV8lNPv26STfsKK/MEVo5A42818dd9mHGE/BsQAAiDjmPJK1?=
 =?us-ascii?Q?KfE0I5yd7mnAR8p1EzVnXJYSbyQ9fKOoS70PAsVjUNP7tay9NQxNcw1D+4jM?=
 =?us-ascii?Q?j55s/p3ZYJmcl+FGMJeNDE34Esuip/BGPxGQsY+Td549URwwLQ9XHzFdt0pP?=
 =?us-ascii?Q?HusMPzEzE9y3mPmIry9NkTyoLAyBHz0YO5pLR7zAIBVNyzb4CRqI0zNJ3qXk?=
 =?us-ascii?Q?9omXAtFoAveXHqCTUr2Hpg/VtG//q1/qs2cWyDJ+kzhKw5gfe3PNFxNjProC?=
 =?us-ascii?Q?v3YPhsPUGZKbhPW3lAShHXM7C12wzZ341DgqXmhzGaW5J0+xCM3BP9BZzdi7?=
 =?us-ascii?Q?mvhGcNUywp+McJktkMQ1JArxv5GNiDFD/6DoA02yoMa2i7YuNLAHOrotpiXv?=
 =?us-ascii?Q?PrfBETqiP+dP1gk3gVqPmdFo7sICU305wXoUhEMw3Ov8SO0zIZWoBwIXPAP0?=
 =?us-ascii?Q?IH48zwKJMSu82u1L0MbvHRAO5nyBr/0hUa+UHATculhcDYjjVe9LcgWbm1NL?=
 =?us-ascii?Q?/EEDx3VTT+HEImQ+hd5ZB4YbozLHKrVVwGw66/XsPVRc/vswoamvvdRrsLIU?=
 =?us-ascii?Q?D0g5kgrnNgle0Vgce3V9VANtrsPGuHz7cEknYavedZJstGaJDjlU3PKmBaRI?=
 =?us-ascii?Q?morfl7XqvgR8aV+PdEVSlqFleUgoKmZmnI/plaCLnJdPmpphnsx2DflQig1G?=
 =?us-ascii?Q?ujRrRPU0xKOrn8DMiJ73YIHlgLhnmbXYX27NCZttHp1J9pz2J4bRWbVjNTa6?=
 =?us-ascii?Q?Pk0L9kZnPm+LZnSdQ1l4bcmOlgXAbIDHFCRAfaR7+cOLi/KTdk6a9vF3Bng9?=
 =?us-ascii?Q?Vp1dOjpA5PTl94F0yKdl85NITSRARf2RYk5pO5NmLbg8hkNpjo9xAar1M1pC?=
 =?us-ascii?Q?u6a4q9/JztJUi/IOJ1QWsJ9xeu2y2PIB0JF/uHH7RlwILdIkO0aubuApkSA6?=
 =?us-ascii?Q?0O15+58kWEWbNs3mUwq0sVK10db2vSk+kw3/2gjlPsAOL9vRlT9Xtw4EM5wv?=
 =?us-ascii?Q?tlBlRHsV+BkYO0PQK0EbjpQvAeoKGn2YL7iBgCpRo0RSogd8B68zrmP25RSM?=
 =?us-ascii?Q?y/A1VmvZVsTfe4aes94Mq/JyZlTKs+L+JG+YTHh047NhFY7V/xJquw+Bqzzu?=
 =?us-ascii?Q?t6/EavbthLczF/VaabOmh0FYFomhoiYB4EZzdHx55f7vqmB2zX/l63CMmysX?=
 =?us-ascii?Q?IkpTkSjQGsbxqlSOVXcQGzhIPQ5IPMG2SnM3V+0S7+TeA+wekgDmOzBfQx6C?=
 =?us-ascii?Q?4rKNIJ86i5GAnEL9osZcV45zw7RRgEUkb/8oC6Z+DAgw76vlv0uYyHlQLnLM?=
 =?us-ascii?Q?VW96IImXZ2uG7nZyYuSCHMb/MblYJKG2Y1xHu2FGAwTusIoZvd+Vx1f66EJo?=
 =?us-ascii?Q?moIV+ahvE9Zm7Nde+c2nbrv4AmxhOwJ9q9Jqbn2p3OULe5JyaOFHHI92AbLy?=
 =?us-ascii?Q?ZqiGF1qb4Oht/2viI7Vl/WOUGpxp1KT3v52op+X/J7wAVkVTqh+3Te6KcOeb?=
 =?us-ascii?Q?+PWZLrZgln2nuKAbMcQRgOHuEzIBh+wU/kODHb9hwksU53eYd8Ob/Rr7+Gss?=
 =?us-ascii?Q?BudAJCjVFp5xkSng3/AZ6E+5DF4Re6KykMxJ3h0BpaxHuLZ9PriJ?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7706516B204A9141B9A705B5A64459AE@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e529ed27-5496-4ae7-66a8-08da28ae3308
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2022 00:29:47.1643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AqJjAo1QCc5yA2ZURCoj3Y0+wD/rQIQfZ9y4m0rh2hQk8RmXoIs9rHWMkh6GpkHihnxCMqtqFcfB05jQ+pD14w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2294
X-Proofpoint-GUID: ioF7SufpllJBw79NDxUDC53PLS1c9z8d
X-Proofpoint-ORIG-GUID: ioF7SufpllJBw79NDxUDC53PLS1c9z8d
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-27_04,2022-04-27_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes for md-next on top of your 
for-5.19/drivers branch. The major changes are

1. Improve annotation in raid5 code, by Logan Gunthorpe.
2. Support MD_BROKEN flag in raid-1/5/10, by Mariusz Tkaczyk.
3. Other small fixes/cleanups. 

Thanks,
Song


The following changes since commit 5ea7c1339e3ed094dd4df48d598f9018a2587283:

  block/rnbd-clt: Avoid flush_workqueue(system_long_wq) usage (2022-04-18 09:24:56 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to 9151ad5d8676a89cf1b6a4051037ab3ca077d938:

  md: Replace role magic numbers with defined constants (2022-04-25 14:22:31 -0700)

----------------------------------------------------------------
David Sloan (1):
      md: Replace role magic numbers with defined constants

Heming Zhao (2):
      md/bitmap: don't set sb values if can't pass sanity check
      md: replace deprecated strlcpy & remove duplicated line

Logan Gunthorpe (7):
      md/raid5: Cleanup setup_conf() error returns
      md/raid5: Un-nest struct raid5_percpu definition
      md/raid5: Add __rcu annotation to struct disk_info
      md/raid5: Annotate rdev/replacement accesses when nr_pending is elevated
      md/raid5: Annotate rdev/replacement access when mddev_lock is held
      md/raid5-ppl: Annotate with rcu_dereference_protected()
      md/raid5: Annotate functions that hold device_lock with __must_hold

Mariusz Tkaczyk (2):
      md: Set MD_BROKEN for RAID1 and RAID10
      raid5: introduce MD_BROKEN

Pascal Hambourg (1):
      md/raid0: Ignore RAID0 layout if the second zone has only one device

Xiaomeng Tong (2):
      md: fix an incorrect NULL check in does_sb_need_changing
      md: fix an incorrect NULL check in md_reload_sb

 drivers/md/md-bitmap.c  |  45 ++++++++++++++++++------------------
 drivers/md/md-cluster.c |   2 +-
 drivers/md/md.c         |  62 ++++++++++++++++++++++++++++----------------------
 drivers/md/md.h         |  62 ++++++++++++++++++++++++++++----------------------
 drivers/md/raid0.c      |  31 +++++++++++++------------
 drivers/md/raid1.c      |  43 +++++++++++++++++++++--------------
 drivers/md/raid10.c     |  40 +++++++++++++++++++-------------
 drivers/md/raid5-ppl.c  |  13 ++++++++---
 drivers/md/raid5.c      | 226 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------------------------
 drivers/md/raid5.h      |  23 +++++++++++--------
 10 files changed, 321 insertions(+), 226 deletions(-)
