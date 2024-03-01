Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3E669952
	for <linux-raid@vger.kernel.org>; Fri,  1 Mar 2024 07:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709279079; cv=fail; b=Kn6ZXBpR59q/MqxsgAfN4l0qXI6I14ipNLMLdt/yxQdnZ8CCk9O1D9w18Z+DOfDG8NiY01dI3soENM3qrnL6xuhBYWWGBEAmpXlaKCN7Q68nHpkdbpUj+3olOHHq1DV9v4KQF7jXMWYJQWa8lT8h92bux/ODHlTiNtas3gQhpN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709279079; c=relaxed/simple;
	bh=s4Pv+bNawm9h1A8M19tiAVyUuo7Kj+3i4Y0EsM61XSc=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=nwJ7UsHBTRN0n4gCc70oAVr6eht/ips5C/SnUs+BHY21HPvU+SmFl7EmLX/46wgvwxCggttKCVRgC8JHJCfbW0drlqdym2Je7ahylJFORrrDi6n9hc+qd1bK3POv6e3PiW5oQwuUqqv6Rbqbi+AQj66bFzFePYft0V6piv3sefo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=l0O1gqu7; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="l0O1gqu7"
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41TNB6Sl031483
	for <linux-raid@vger.kernel.org>; Thu, 29 Feb 2024 23:44:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=Cd1FJy4Itf3PuNDa65btgkUcQeWRFOf93L9Lf7Rpqto=;
 b=l0O1gqu7ZRsrYIp0y0oNeBFafNNfCvK+hD4UrIatXgoEVNUhRw2ncLam8Nn4a6v35JTO
 bfMPrt0Cma+PtZ/CXnniO361RHzRfzXrm2aBIVME0L7hZKTwnEz2ilCHc+W4tNEmk9cQ
 fqLgpKeDM8osopTIiE1h3LlkBphckTd8pEMiLzeUaqZ3rU3P/m6dVDvUUc1hOg+wT+MP
 Eg95N6LQ2jFjmEhc2RukdEAmmAQ+kt2AHqx0IE5ZXfbUdH1hCgE9bkaEZImUuvpJF1FO
 2OCD0CkRL+I+Mxtm8bKn0/OwXD5aaDk9HUClFPfsWM8Km59aj1TSP9dPMY/R1Hl+9Ayd DQ== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3wk3cgj1xk-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Thu, 29 Feb 2024 23:44:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WTKmsEGXYX3qzFFkU7ghKebLoJiqWZ5FuRsDXjK5OrpMSAa1oKYMv/uG8NArRBepIr/WkW0ks9V33hvd49yeDE9eDyRA+xpm2tpbjZZJDC8Hd3gplmXjiS8ZX9ArgiNGiY+plSFihKLhRMI6ESq/AN+Nsi946V5YVWKS/Ejmk0onocIsRi9/+ijHiZNz47YDC9r577XMv2gM3YPu8RfvY28Cly6cm3XRPmQvC02eElPvtUKrwWDbrhQeSvPqzPc3MdCFev8+JOcODAhzofJk864nIfqp2UFM47hIOQryNMwK+EDmJoYmKhqfzVKIzm910xg0p2op1Z3vLpySUbMEJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cd1FJy4Itf3PuNDa65btgkUcQeWRFOf93L9Lf7Rpqto=;
 b=RCJ2mceCTgytFszvCBpljjsDLnlL3eHGd3qAcghGn7cqDzOU6hxdoTr47+/z0iv1fSz+E3nSc9eCYWkJl9q6T5EYFzKIX3pvUPEl7Uxv9um6aklqiY7guDrMOkMN2ffxb2tZdw8cwd7VlA09s7Moo3wcGCpIem72A+tEc4NdOxRTtKXpfbJebUuYWy76dPoGPrnWFZo02Zx/bU0ENplyUrz0eNBBlSnw6eLQVl6tgPRrQCi+jVi4gK64ejnEhjCwkxz1DP2fUoB9QSEKmBotJmAeypNVGQhwhm3shpy1iLXGaYtkzq/4nX8Nzd/mmItoabnJUgI1+gxAMfFkxO7xGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DS0PR15MB6359.namprd15.prod.outlook.com (2603:10b6:8:fe::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.41; Fri, 1 Mar
 2024 07:44:33 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::19:4b77:a9ef:b084]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::19:4b77:a9ef:b084%4]) with mapi id 15.20.7339.031; Fri, 1 Mar 2024
 07:44:33 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
        Heming
 Zhao <heming.zhao@suse.com>, Li Nan <linan122@huawei.com>,
        Paul Luse
	<paul.e.luse@linux.intel.com>
Subject: [GIT PULL] md-6.9 20240301
Thread-Topic: [GIT PULL] md-6.9 20240301
Thread-Index: AQHaa6xMR1UI8nBMzkiP+GMmyIEYjw==
Date: Fri, 1 Mar 2024 07:44:33 +0000
Message-ID: <B6EB79F8-7936-49A6-940A-0053DE38AB20@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.400.31)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|DS0PR15MB6359:EE_
x-ms-office365-filtering-correlation-id: 62e67554-a784-4e59-464a-08dc39c36fc9
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 1svl2WT+CPYUIlacxH5C+0DaMtnS/svztKL3qVrQPfLJRmQYEZ2sYPgq9pMDqX+Bf0EEG2db3bKABt1xw9Rm1TrZrzsg1d59sNlLH0duyFBEKHQqjq1tq/0h7/6efR5YdcNQ9wr2ZZiGbuEI9bOG4WrBAGBDdJp+5+OeaX9IsLfB8eCs4S361Tf9YZDydmAdOTyXyV0L1gn09R3ImWW8W3eaXNTB0MrtoTatIjUe6xL4bzgPa/ZaUaDYRAZn46mTYrgIyAv3oc8TuhlIH8B1C8pLg8OvIofKAuQaASiF9IEOwRcvVEW9dxD24TweeTT3xJkam+g9y3PHNcfUjglcYfknUxAQRClYkBP8wzmXWMomPv3kuLNGDH6fiZPvovwA+AtwCpNRYUU+2Z19lw6it1QgWKYz6cY0itkXoMrv/WJi6YyzoCxanslBIdt36jpHR5yptqa2OYyTqoZqARG3wq9z27bTmGUVq5bYOqIw/EkwRctysZXcjbSUivlRzFFl6I3guKqkwNCW55d6jSELRwi+Q7NjkBwkaIY20/OAjKdqJCsBiADVZl7e815bEiaTp4RKkX7YbKAj+JgFSgkqdhBTYDS5zaCLNz2a5Rg86pCX5UAKk/zV0Nv6JNMmPafZaZ6qP+lfobM3bA//7ddSW9Z4GoHFMOtaIg3KPZBR5Og=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?wLOUxIGa7oXO+Zbynd2TwwaJKuBAPQgD1xkWm/oOT632+HfIKXlfTzLvOob3?=
 =?us-ascii?Q?9d5uaci5nzuvUholJIxcs/pDFf1X1TE4C1iepctXUqO9lv1cyaVeA01ufkVf?=
 =?us-ascii?Q?iYtxiQipK0jO8omm4zCNeNWn64P7K/I86Dk6+jxVfsiV5O5jPitZjC1A8z+9?=
 =?us-ascii?Q?ELBtXMc/DoEnj3R5zArVmi4hNtvJy/fdzZo4XZlaI6CaCLj+r7iwzDlvu5gy?=
 =?us-ascii?Q?FEiI3OF4dFDEh8RUxmaRJA5/Xq2k+/S42HE1a8Bzg1Uw6TdC4FYKKZIQd+Qt?=
 =?us-ascii?Q?WWtoZRqxC6X1V+eV73rTLlbPKVWeburVcdH31vimfd+IU87HY5n3TymiryXv?=
 =?us-ascii?Q?YBs8AnD1GtoSufZkRZP7PxtEFKYvXsO5ufdZUo1QUYiMR1vc0n9i+fO5urVN?=
 =?us-ascii?Q?To435jUEBj9CjpWgf2iLbZMXlSRxmSOzbLC1HnnkK3ByqfXzYQgXIe2CLjT8?=
 =?us-ascii?Q?uRPnuYhYW1HSCYdIcYJ5t6rmrU2IMRaMOox8ryksQQftMHhkJNuIj5Pzc0RR?=
 =?us-ascii?Q?crs0dDzzDmc5BIJl3/tsntpQ4ttm3L5jOknspVwBqc6eYKWMvXD3nd9Q9lod?=
 =?us-ascii?Q?I3yKn0SSxxeAH5XhVmeWyZUspQAoPIN6MGms6F5f/8t5QVLAioFKZWCgEDbl?=
 =?us-ascii?Q?rnLJiTroi1WEcUnAqJUwMsjJZpPveBP+Jq/aw7t+QpaHcaWNvtw45g8CH7YE?=
 =?us-ascii?Q?XtqiUqrM7tyq7HoT6duD+CU4eGCUst4e52FqOQF0IPKdWeUg9E9tVWu44VKt?=
 =?us-ascii?Q?ly8dXEE5sMptPviYMU7F9+fc5U+mUEnzNAewEGa5z6GYalprYNRArQvzsoYz?=
 =?us-ascii?Q?MCjNa5ZG7kpw59BOVHdldjDmpJpBAgiQ8Tw1Ir69GdeVCUumnmgWCqf6OLIT?=
 =?us-ascii?Q?jZyIEwujEqEqOCk9oAsAfpV1yzsIHSdUUKr4IA3DrZw7emNUb4GY78EDZhMz?=
 =?us-ascii?Q?JVxPru6XYamh+epxAcgvk7im/DtPVC1A7yg6GVqF07PTU6qbHKfu/tha0mX2?=
 =?us-ascii?Q?I2LEDuPzdWp6K0PudUD/+hdD9rmJDPsf2keZNCDkdfb6/Byr5FxlmM3RF6bG?=
 =?us-ascii?Q?tYtakc14HKTWxMilI8yx+E0ckwTKCit5u6K8oucIL4O+OQTpH7SQ/sLnPX/q?=
 =?us-ascii?Q?pqUaeYc5OfOI0CzFT1poeOeqFQ8p1NTNtXTPygjICXUJ5ekTdI5W6Z5d5afj?=
 =?us-ascii?Q?NWdd40YKupJF1WPoo301TqUVUtIOybYyxeHKWnEkpF8+P/TUepSvWfbCdmja?=
 =?us-ascii?Q?cqw8MSmtpVZQo/pw3W9FJEfPhaLGX/kqw+6JpwVXv1bVdsq4V3/Ml6qjanRb?=
 =?us-ascii?Q?w9gSQUuvEnyJJ/dq2YppzLTliIitusfLKS/DQVJIuJ4pr3pYIeurWer+q8/H?=
 =?us-ascii?Q?jE+AzQkkUiWuL0yVCIYgVPitPScH8S51GMEGBeusSY8pKRxmYw4FjCbAIL+P?=
 =?us-ascii?Q?8kyFXjhE3NGMnTIhXMHDoksjlEbkPORdZaDju5eRjAq31B79eWpeCJARNaW8?=
 =?us-ascii?Q?c6Q82vrOxTNIW/63V3GzApuYQ9tMsbxmAola8BmlZsD6gzpnQL1JiY84XVIy?=
 =?us-ascii?Q?F5jgCksN7qCOb9LzGLuxTQsUtC+QFlD5/Sxu5onsm29+R5bEV4KsMkpUzC97?=
 =?us-ascii?Q?m4SmYRedY40kgQk4OzKoNzc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D7FA017442AC264EB81DB1D118D314B0@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62e67554-a784-4e59-464a-08dc39c36fc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2024 07:44:33.4133
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: um2rH9bV8/Db8gzNkYsdgTKHAkOOWLh6Cl9aB8rp+zC1S0ZSz7T1IZk0XGCl5fUSAItQZAF5KcOs2ZQYNPovXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR15MB6359
X-Proofpoint-ORIG-GUID: F-Z_0DX8tGtlD-l8DmIMkpysuW9KFr96
X-Proofpoint-GUID: F-Z_0DX8tGtlD-l8DmIMkpysuW9KFr96
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-01_04,2024-02-29_01,2023-05-22_02

Hi Jens, 

Please consider pulling the following changes for md-6.9 on top of your
for-6.9/block branch. The major changes are:

1. Refactor raid1 read_balance, by Yu Kuai and Paul Luse.
2. Clean up and fix for md_ioctl, by Li Nan.
3. Other small fixes, by Gui-Dong Han and Heming Zhao.

Thanks,
Song


The following changes since commit 82c6515d8a970f471eeb8a5ceeaa04c3e5e1b45c:

  bdev: remove SLAB_MEM_SPREAD flag usage (2024-02-24 13:16:08 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-6.9-20240301

for you to fetch changes up to e81faa91a580cd151e3e88816786e0c270cefb98:

  Merge branch 'raid1-read_balance' into md-6.9 (2024-02-29 22:50:26 -0800)

----------------------------------------------------------------
Gui-Dong Han (1):
      md/raid5: fix atomicity violation in raid5_cache_count

Heming Zhao (1):
      md/md-bitmap: fix incorrect usage for sb_index

Li Nan (9):
      md: merge the check of capabilities into md_ioctl_valid()
      md: changed the switch of RAID_VERSION to if
      md: clean up invalid BUG_ON in md_ioctl
      md: return directly before setting did_set_md_closing
      md: Don't clear MD_CLOSING when the raid is about to stop
      md: factor out a helper to sync mddev
      md: sync blockdev before stopping raid or setting readonly
      md: clean up openers check in do_md_stop() and md_set_readonly()
      md: check mddev->pers before calling md_set_readonly()

Song Liu (1):
      Merge branch 'raid1-read_balance' into md-6.9

Yu Kuai (11):
      md: add a new helper rdev_has_badblock()
      md/raid1: factor out helpers to add rdev to conf
      md/raid1: record nonrot rdevs while adding/removing rdevs to conf
      md/raid1: fix choose next idle in read_balance()
      md/raid1-10: add a helper raid1_check_read_range()
      md/raid1-10: factor out a new helper raid1_should_read_first()
      md/raid1: factor out read_first_rdev() from read_balance()
      md/raid1: factor out choose_slow_rdev() from read_balance()
      md/raid1: factor out choose_bb_rdev() from read_balance()
      md/raid1: factor out the code to manage sequential IO
      md/raid1: factor out helpers to choose the best rdev from read_balance()

 drivers/md/md-bitmap.c |   9 +-
 drivers/md/md.c        | 183 ++++++++++++-----------
 drivers/md/md.h        |  11 ++
 drivers/md/raid1-10.c  |  69 +++++++++
 drivers/md/raid1.c     | 550 ++++++++++++++++++++++++++++++++++++++++++----------------------------
 drivers/md/raid1.h     |   1 +
 drivers/md/raid10.c    |  58 +++-----
 drivers/md/raid5.c     |  49 +++----
 8 files changed, 549 insertions(+), 381 deletions(-)

