Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="m8IZy5MS"
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DF1E0
	for <linux-raid@vger.kernel.org>; Fri,  8 Dec 2023 10:53:43 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B8IrhIb000362
	for <linux-raid@vger.kernel.org>; Fri, 8 Dec 2023 10:53:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=Vx085R2o4YDUWY5jrrsEp2RBMFM72xNVZWXqW9ONhYo=;
 b=m8IZy5MSIXSuhWd+k41pVV+ln27PHLCTl7EHmguK2ssmf4+2p/UIwId6wwtNJ10VLnom
 k0++gV9sXHZqPRaFzSLY2gj9pxylTr+PCUiGZBJs/XiEFRT7Qt8drb8lszh7wOOX6QR5
 7LBrAog1y0hAi2gqmw8zI44HlcAdf1dqI7uxmpAk8j76yvtgKSeUVjl00dAFtI5xJTaj
 cQkxM4NeFjw0R6eNvCHzKJ5MR3/0i4M7Fz2VSw7ArdhzuEmk7nYeqDkiZvf1E2A+AUTl
 JwhYOfidA+M8LFy4eGVVNRPpOOLMiARhPGV5FlxvuNZVT2wK6e5kwDtfnXSGJswk/tje tA== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3uudj63p4m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Fri, 08 Dec 2023 10:53:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RadORpC8yfLw8eVnpoWcYniXhg+dPVfNxf8bH+gccx6D3bChtm8RvAoyMZcf9Bk5z51cbr1bTrNztAI1tQF/Fwk/4DMbn0rZU4pptsJL9wL2Tf/qme27GE7NRnqHmvX3RzAZ3rBxVkepo9u/Jz9oIFIrPKB2zlUFgnA1Ug5ifxBOTDu8YSTZg5AZgOhnmAU1MGS/CFh9tivX2v/sxmle0PupfOGAY8tpMFz6eltKdEJwZDQ5XdCYJRe0k1XM7cp6pY8J8bhOa/DEwl9gqaGTGECffViwRK1VgggRtXjqEPpmZcDDwwJKaz1vS2forlun2Ly5AD4usO5Hyv/b+djBHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vx085R2o4YDUWY5jrrsEp2RBMFM72xNVZWXqW9ONhYo=;
 b=IbblA/MxWSDTil8IL+WaBq6BPJ4EBnqsiR++XPzNBgUoZVNv8FUsEz0fO6jdyRz7gsHdC7G4mmWNEgzf38lGVaCSiA+l7EZnfC9WZQSlsbJp+2nJTzpSXj1+7/m4gDNp/Rl8f5HShCNTJ1/kwGipaRmaurnL9Dqnjlt5LreS3AHYdVWSlAtV4SqgG2Fn07LpufGZYvt6dbcflbN14c/utw1GVG1CjhF/xIv/7MpGE5rMaKV76ZGVde+0b4eeVmW5s2J3exG+IDPhPzFxd6JNN5QcpBUZiBoeUKD0X2C3Lxdmz6ix83HiI39lzcT2Sw5PF0mCqir702KctcX/YN6u2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by IA1PR15MB5443.namprd15.prod.outlook.com (2603:10b6:208:3ad::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.18; Fri, 8 Dec
 2023 18:52:18 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::9052:3362:76e2:146d]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::9052:3362:76e2:146d%7]) with mapi id 15.20.7068.028; Fri, 8 Dec 2023
 18:52:18 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
        Junxiao
 Bi <junxiao.bi@oracle.com>, Song Liu <song@kernel.org>
Subject: [GIT PULL] md-next 20231208
Thread-Topic: [GIT PULL] md-next 20231208
Thread-Index: AQHaKgeqRosqBgKUrkiWgkyEcs6oYA==
Date: Fri, 8 Dec 2023 18:52:18 +0000
Message-ID: <20C9A854-73A4-4FBE-9857-BB52C7701FAE@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.200.91.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|IA1PR15MB5443:EE_
x-ms-office365-filtering-correlation-id: e5ee462f-54e0-4884-8ca0-08dbf81ecd62
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 BsSd8ako6C8b+0A0Yz/K+j3ac96kdEWHW+L3laWre64u4vFwIhb6B1CuXuj647Wb3CYcuEjYS6Bwyccg6EuIQsflzuXHdC5/NEGlWZ4LqzgbI7V8s/CYR9n2JADsM5u8X/L5GZ9rC6G8PHSXQ4v0PAt95aDfv/mJEpEOBAa3MtMx4gMr8AtDnoVv7YzftRgFjnGYAE0Now7TgPE3gyalbEouxzwL+ykSsEgETFwsHyc4ik74r0hynNo/8RF7voCgQisJwzcNGNgswTByRw0wqO+LuGKeBfloB849Wd3k1zvC9RaCICKrZec6Fmek1jg/qmzcJizKG1kdeUC358rpO88zIMQVnWpk7lhOw1jHCuSpsYw4nh32FwLPPaWKBaxyVvqtbLXpC5D3I50CWmQsCzgrQXnATMQyyDa//rkPur1wcNEjjmTej0CrNs6q8rIBd+Di423m3eYv0k9DKn6yGdb2/hAshaves1fRgNNfo/5bMt1nEhg62REZ1UIJ35lhP/KmLu9du5dEoLgWhXpBykjl6tDfmcl/b9uzJdPJgGxgHgcluR/gJlwhyniJC7n1rIKiNJ7fHRUZlPt75bR+puKTaAyor85TL5qZYphVUYU=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(376002)(396003)(366004)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(9686003)(6512007)(478600001)(6486002)(71200400001)(966005)(6506007)(76116006)(66946007)(41300700001)(4001150100001)(83380400001)(66556008)(2906002)(66446008)(64756008)(5660300002)(54906003)(316002)(8676002)(8936002)(4326008)(110136005)(66476007)(38070700009)(38100700002)(122000001)(33656002)(86362001)(36756003)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?3rQTIW/3CIcQBgdls5/CR6IjBFk8/1W674X6UtrjA1a9jB6oqq/CbgNMsNji?=
 =?us-ascii?Q?IUeqv67eZVBrhr5olfxqQxJK2FCLW+L7itkSzmT4Pr0/7rSI2eQTg1szBkJU?=
 =?us-ascii?Q?ub2HnRHD2IeBB1MmokSeZU8/H/h0jNzkCloCU09FVsjvOyiBQP4YdQXeyKRe?=
 =?us-ascii?Q?Zv99zlmgHVzzp3hLTvq8sSxNod4Ij4W02FCWkbyVjdiP1e5SXj5BTmJIwNEd?=
 =?us-ascii?Q?gz3kG9ndp2jFers+d0YVKBmlQGsYZFEq2h8sy1ZkIsUeXMn9X/RrvDxeOfIQ?=
 =?us-ascii?Q?zdKWlzyAyCh4fIhf/pSkad4kmK5X5+5XhwF4kWZLsxv5ofHHI7OvmEbM+UdR?=
 =?us-ascii?Q?ZKqcDZeWK5yl70onEW0CXVr/HZRYZa1z8nPGraGHYxw7Oz+dXgOl1n/v/eBB?=
 =?us-ascii?Q?KnVD/e+fiqbLsKPLdTosMjij1Jcb2mKwzrOVt5WjHlN4Ycks8DEnQ2h4VpV6?=
 =?us-ascii?Q?t1AR1W6zb4UAO1s7lxE9hf+o2gAaWKmdrXT0FatN4v9mnyv5iC7tFpa/5zJC?=
 =?us-ascii?Q?Mf/jQSdkymxSESfkOujAChAvlog2BfT4tNnFv6FZEJytp2+hED1er7mNwMV9?=
 =?us-ascii?Q?92IwMULwcKmn/nH3r2fEjSebKKHpa6jdPadEx/juPuOuM6w5LERtB4S3AR30?=
 =?us-ascii?Q?Qz4JwwKw5kOs6z9zQu2TegwA4Sm7df8ML7WcuuAJ3zAwj25EE3dbk043vkS2?=
 =?us-ascii?Q?AgajYFPgQKfbJ8cN15uT4YTs3jF2uoWSR4pGB/tIz05PAVul1R+iHiYorJLW?=
 =?us-ascii?Q?R2VBT9bBmoUDIq+YtVcXNu0rCLaqwba4h/mFmzrFqZ8RndLRdH1wtAK05e6+?=
 =?us-ascii?Q?c2gva4veL6v5ikGP/OIoPdvYxVWPLjQ0H8+3MyB1XUKNVSTKnU4d1dSRMm6U?=
 =?us-ascii?Q?yiXt+QC5XGJgIvFAnu5HFFcS4gW1f+vd19opji+xdvDRWIfDoFvr6BdUC6FZ?=
 =?us-ascii?Q?KXXvNsAGhHLywrcrw5XRY3TeSt4KY3ZJCOylO7uyR04GO1JMESnqmw6Bb05H?=
 =?us-ascii?Q?gB/NGCE97EIyB4oVOzaCtR3TiLvZ0JOOuzwr4etL2HzXDflKaJujIQH/I3Sq?=
 =?us-ascii?Q?7BzIWIAcYD1BKnD0ZnT0ilClF/eiopLnyCzFdPjyZpnyOzlW/duPAo4S33Vh?=
 =?us-ascii?Q?rXPHNX4eb1zDFxZ7kCzVgP4ec6keoh3tH4+H08s/uPZqtRGsjU0/rEB1Rs1H?=
 =?us-ascii?Q?N3NoCGjG2i1IWfRueOL0HmzvJeXpVxyOPzYZKp0cf9ahUeZzOly9Yh5jqDLV?=
 =?us-ascii?Q?dTsxCqO7aZY4oi5DC5fhSpWRwRoSFHcXmwXis2Cl/5A3zUIO/MxMA9tZaNPt?=
 =?us-ascii?Q?2QPNXafBwBzICckcnfFzz3U+sENBJiX1CdHkQHipKD8sAQDbICsm3Q+ExnL6?=
 =?us-ascii?Q?ofw5zKQ5FHbwS/r/tOOuqs8QgYi0ch/AzSHmhtnr45+fVCQ4aRVo7NDWMSuq?=
 =?us-ascii?Q?NuGXEVAdSy6MJSs3xSFKAGVyMz8qDvknZdxr3IBxsuOWgxDUcrg45cORB8tm?=
 =?us-ascii?Q?8AuVybjjkUoW8yT+dWylGW3FR8T53zP7A3fO1XMONUSe5kfhn6kWUjQ/zQnU?=
 =?us-ascii?Q?xPULTOZSpnLd0zo5eEDK1vt711mHE4ICbalOAtO09cDDG9EQ2LU/zMnGHFxE?=
 =?us-ascii?Q?bAbZ4nsyTI14GH77Xyx9lzk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A113DDB936F27F419AAA6211A0C4DD55@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5ee462f-54e0-4884-8ca0-08dbf81ecd62
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2023 18:52:18.1253
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kgy1u1gdXX/QzYOIPmb19tT6qoaLNptr8PSCQtf7fWEPU7Ee6gJjIN/pfeVCHI+LiyIc1EV0LmuYNsXMdAPz+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR15MB5443
X-Proofpoint-GUID: _pxtevmfzbF4tqCtpjw2wmFZfNoKu3uT
X-Proofpoint-ORIG-GUID: _pxtevmfzbF4tqCtpjw2wmFZfNoKu3uT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-08_13,2023-12-07_01,2023-05-22_02

Hi Jens, 

Please consider pulling the following changes for md-next on top of your
for-6.8/block branch. The major changes in this set are:

1. Fix/Cleanup RCU usage from conf->disks[i].rdev, by Yu Kuai;
2. Fix raid5 hang issue, by Junxiao Bi;
3. Add Yu Kuai as Reviewer of the md subsystem. 

Thanks,
Song



The following changes since commit 668bfeeabb5e402e3b36992f7859c284cc6e594d:

  block: move a few definitions out of CONFIG_BLK_DEV_ZONED (2023-11-27 09:11:35 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-next-20231208

for you to fetch changes up to fa2bbff7b0b4e211fec5e5686ef96350690597b5:

  md: synchronize flush io with array reconfiguration (2023-12-01 15:49:42 -0800)

----------------------------------------------------------------
Junxiao Bi (2):
      md: bypass block throttle for superblock update
      Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d"

Song Liu (2):
      Merge branch 'md-next-rcu-cleanup' into md-next
      MAINTAINERS: SOFTWARE RAID: Add Yu Kuai as Reviewer

Yu Kuai (6):
      md: remove flag RemoveSynchronized
      md/raid10: remove rcu protection to access rdev from conf
      md/raid1: remove rcu protection to access rdev from conf
      md/raid5: remove rcu protection to access rdev from conf
      md/md-multipath: remove rcu protection to access rdev from conf
      md: synchronize flush io with array reconfiguration

 MAINTAINERS               |   1 +
 drivers/md/md-multipath.c |  32 ++++++++++++--------------------
 drivers/md/md.c           |  66 ++++++++++++++++++++++++++----------------------------------------
 drivers/md/md.h           |   5 -----
 drivers/md/raid1.c        |  71 +++++++++++++++++++++++------------------------------------------------
 drivers/md/raid10.c       | 222 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------------------------------------------------------------------------------------------------------------------
 drivers/md/raid5-cache.c  |  11 ++---------
 drivers/md/raid5-ppl.c    |  16 ++++------------
 drivers/md/raid5.c        | 203 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------------------------------------------------------------------------------------------
 drivers/md/raid5.h        |   4 ++--
 10 files changed, 189 insertions(+), 442 deletions(-)

