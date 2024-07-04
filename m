Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F25FC02
	for <linux-raid@vger.kernel.org>; Thu,  4 Jul 2024 07:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720079503; cv=fail; b=BzCqhbMgY4WlySEluIg5ihVbwZ4DfXZQGxC9ipFIaXzEEcXHWXxjZ0ApQ+pNg1C/DZKmZiSl6dOLrwkIns9vWKbRnB/13g1K2nHIAQkLR4R7nvJ4NXH/iSTy9ua2mHodaPavre6klHcdA2PXtaTKxBg3DYcW/bITUiq77wm1wus=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720079503; c=relaxed/simple;
	bh=8vAsoyDp0BrUj0S0HhsKC1I95hBZOgDHpfphMUNoL7s=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=BG+ear3MKl6A3JW/LYpAseMzqCPxXJ3dhx8+Vnu7UsPkGbo1CujaJ8FQUHgFcFTjE95rQnguxLemfzkOrMZfvbuTlPCz/5YECOV97R139lSKzGZp/N7wz5NsXXF4ckjHUNK3NDxG6PbckuFIh7NKewNSSScpclS49Ytw/XR2xKI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=k1cRA/3h; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="k1cRA/3h"
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 464591TO028666
	for <linux-raid@vger.kernel.org>; Thu, 4 Jul 2024 00:51:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:content-type:content-id
	:mime-version; s=s2048-2021-q4; bh=xK5EEpo7tbGa2yxbDO5pY6jnhZBar
	V3jFNF5P8IFXgo=; b=k1cRA/3hbk5Oetr8MytuHjJyp7Jhvs/wrZ7kCn7KkmEnD
	YbWcA9NpIvIxydW3/X3lp4cuSSu5QMYcPXHsa7TDukQtwOciVHZKxhkbzXHzBsPk
	fmspeJiw6e8UZY016LnEoiXSIVF0Ho2gf3qKKOchAOkowsnbHqJIe2f9NecZvxFo
	UPlBvgtZP5a0WRqEwlik24tGu2xw28AXPOO1JCri9vBRZZ/7KT0c2zc7/I9HuC93
	ZoK6WTW4cy4pdIqtSiZxpFoXqO0tKuamvF6Uvm7FVuwazveMj8np1bdcbJIp57+M
	aW0pEBQxU3gyFNN2rxJAv3hjaWMlEF2whNkDG97yA==
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 40540re99p-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Thu, 04 Jul 2024 00:51:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XO0xHrO+SZQxyWlldGayUDU89EnuOiAiAxlH2J1I8lgM03Jl0JDhLBpGieYQFsvT6FviWa/DXtr60hmDDEjtcMJGPLY/PSoF6/PNM1gExDtP6SD+9akhUZwQwTJb7mHnaYDSk66MCm9NaQFfncSstP1Ivrbpiy/+QsNuPqJ2DPJu/j3uEfOVkPLa7LjMBL2lL1j7G+pkXAwz2NGPcRz03wkCic46nEEWAQZ9y/odyHxjp+0w5YrSXB8425VKRln0TiYDdEt7chfoEH4gwTUPuKY8rPbowHcQ+1H+J88nuvKOTGG9KZmJKFAvAspX7Eh7tKfNqL1g4UoV/VupayoLbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xK5EEpo7tbGa2yxbDO5pY6jnhZBarV3jFNF5P8IFXgo=;
 b=A3BLOOzr8w9yVa11C8QxPPoSDUEyJGDG141+OZuEbsH8pdQ/o+B9YkCIMYFaMY3y24/n9c/EikKLFy2IyIQZNMdWBaN1uRd0pp286OijB+m/9WiZT/SK3q94UFkqEXIV2fBOi5u7LhxOOVJdMmRX6wUe43XNmYdl2iCplFTbu08r+xmejNfPpkgneSCPrwZfcxiyuGm2h0Yp1CyeTtLD1983pl5GN0iTx0k87g0y0HQCKmbkukdMBGwxlQVMpdkuRgP8Xp+6UXZXjGLoLEufZd9Q+ulXNwsJITO6JeRbWpaA/FdkyPeYuI7njQLGVF6VHEPzA7SUdjwuPoGmKsG4Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from PH0PR15MB5117.namprd15.prod.outlook.com (2603:10b6:510:c4::8)
 by CY8PR15MB5777.namprd15.prod.outlook.com (2603:10b6:930:73::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.33; Thu, 4 Jul
 2024 07:51:36 +0000
Received: from PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::90bf:29eb:b07e:94d9]) by PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::90bf:29eb:b07e:94d9%7]) with mapi id 15.20.7741.027; Thu, 4 Jul 2024
 07:51:36 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
        Benjamin
 Marzinski <bmarzins@redhat.com>,
        Christophe JAILLET
	<christophe.jaillet@wanadoo.fr>,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [GIT PULL] md-6.11 20240704
Thread-Topic: [GIT PULL] md-6.11 20240704
Thread-Index: AQHazeb+pjfDkqjKwEOnfSOxgvDENg==
Date: Thu, 4 Jul 2024 07:51:35 +0000
Message-ID: <14E500CE-4D02-4125-AB61-6F65705FD8AF@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR15MB5117:EE_|CY8PR15MB5777:EE_
x-ms-office365-filtering-correlation-id: 6d1e5962-4bab-4be8-4a3a-08dc9bfe2128
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: 
 =?us-ascii?Q?NWvgVB5C/QCfOTjiO4MprKX5pzluhO1h9k5pKu5r7lchmBz9+RUldZPh03wS?=
 =?us-ascii?Q?Jv/ibhYOeiF4wZlTV5eNhfbI5DDQfYk3hxnrdoo0lLzrwv26UgMvdED+uVg3?=
 =?us-ascii?Q?vhb23vmr+aKv/2fuFZzLpOqusMLrjFdUb1s4vyyc6Gx02lDNzDewp83q6nzX?=
 =?us-ascii?Q?j1F41Iw6LUd+BpYbMlIAvQO24MbEN4WSmzG6LPuQIpP2Ba4X0H7JQAGQXPII?=
 =?us-ascii?Q?+O2/2aFROfAq8NXhCkw9vlqPSCZ1WnoZHUU+gXXMQZZnYx9dOq52zZ8hWevg?=
 =?us-ascii?Q?TJnogmbaagRqrAvdiAlz7vFz1kzv8//8EqC4aB0TUYQG19LjgJGb5RtV73WB?=
 =?us-ascii?Q?SehI+eyHdboRQfRN7ZPtKmdRYSrxvJOe75A9ellF9K6Rw6nmpmVpPMAvhj+J?=
 =?us-ascii?Q?c20PAOS5G7TLJJIySx04f8LyFxUyJPL81J8s9P0yAvSX6lLiopy3Tdv/Yy0U?=
 =?us-ascii?Q?+uIu4m6Nc1QY4rg5NvZm056zCRz4jIP47rfogm8K3MYJZXpnj04JIH+V5GlU?=
 =?us-ascii?Q?0DXoW8sx0gAC3SibTHWGXqf9e9bzy+Clo5/G6OQflOphO2NGVQ0g2h4Yhej/?=
 =?us-ascii?Q?oJUzw6QpjGXPd7H1eUNeD0Vxvsvuvd87CIEbyS2CWjmlXu4BPG9pqijtVduP?=
 =?us-ascii?Q?lZvOUd+yDSb0n+XT1tI0nxwqrjIftzHsYrmdD012rLbqh8UKwcvc4xxzjvZf?=
 =?us-ascii?Q?BrSPSxcFKK9ncRFtLe4p3BaG/dmv5VBhgQBMrci3VVwQg2Phdc+vzLF7R8ZY?=
 =?us-ascii?Q?o9VVebU4hteV5OfQAIbzca8CfYayAIoQyFNcrOnWrekkJ3crpxUCUrht/Hcf?=
 =?us-ascii?Q?ZpDyUpQb7vE+hfVGbGkbPNlkOXRtalQTVJrU7WPTVob88MZAUdXuHjQJBHYp?=
 =?us-ascii?Q?8nvR3Pd8n40SCchwMEDrtHISK6tjHHOaK2PLwTK4sz4MDv2dxYD9Me4+4k2T?=
 =?us-ascii?Q?0+uuObRjNid6cnrA/RVPp0fuaud4r9J9xBdbNqw3lSNwfxjVQ3vEconHWzkc?=
 =?us-ascii?Q?a2tnXOdBCz/Oaf6LWg2HXCIlUa+ljviB4H5JLk0r212Se3nJaiWgF9+nj5LR?=
 =?us-ascii?Q?EattmqOJek8sK3pvliZ/m136ku1eDSDIg9HaUZnSM+iPt+EqqhKC01rn5HZJ?=
 =?us-ascii?Q?q00oSAN9RLVdKVqlg4t424FKHhsZ3WOyVk2bENbzulIkqoxPl2dhIkhZDv1I?=
 =?us-ascii?Q?c9DTOwqm6OF/FZFc1PhXdvdrG7Ut1IUTLRRBh5FwIWs1lwYpoFWsqZuFU7D6?=
 =?us-ascii?Q?2/jtA2PAH1LEbbUL7UrPL4X6ip+goocneQApAudN/yYLm3ol/PToxJTeGnU6?=
 =?us-ascii?Q?9Nv0JyJZ1xYHSr4rND6Hu3eWy+o/O5+mRiHck+k+H8axkR7uEG9w4uz0MQ2j?=
 =?us-ascii?Q?XQ6XrBHvmqOCsB5gm3SWIlOjCcpJ4fEbayOYf+ObF6OJwMAZFA=3D=3D?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB5117.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?CO6PceFRjqKulKENtlbC57nL9VGjehfO6TWDgu6o56Lf7nHOG65xctsZyNaV?=
 =?us-ascii?Q?eo3wxfy0ljeizd1gHrMeg3My8j9qfxzBAqsQoLa6LFZXHGDJsNPLdKWgIZT1?=
 =?us-ascii?Q?1Ee9UxmP7VCOZBFpixYc103lPzZda7oomVS3joMCG9j+mdOB4Dhn/BGjuP24?=
 =?us-ascii?Q?8+om98N0vVodeSauB6DlUUlkTC3ukkFVZzuj2pesWarjlBDLhGWeL3/FSVlc?=
 =?us-ascii?Q?8kiLvyZtHJRoPBU2wRCEgM4K7LKqUmKuS17VCDPe5vzd5F4gP+2KaU9OLoww?=
 =?us-ascii?Q?gAMge7FvrzXJkOs5+x90wg4Y64rxIKYdDYBaGbt7gPaaer0vahNJVKDDcZrR?=
 =?us-ascii?Q?CuzqnWl76W6P27WQRsq3f7JZrxycidpjRLt0Cz8Kq6QhM1WUr1OFUGIygsPi?=
 =?us-ascii?Q?1D/h9XCNgEuZ1wvclyTKs3Gj1xK6tBjmghnam+mywtMQ3jvSwXCYxJS/AAra?=
 =?us-ascii?Q?7BDArEMeBum+d1TxB0ZyiabGpUNEhW4slZ8+IHgZcbnaVbpbeVrq8Bmf/VK+?=
 =?us-ascii?Q?H1+CQT6jGuLRYAyOkmtsZrIXdhzvAwoG84QFDr8gMigNlGwovl7lIl/OKPXR?=
 =?us-ascii?Q?zNP0SL8menJbSVfsEUahhV8oEgxkCRoANWW2cf7pKxFeS9rNZaP2A2NI6zMK?=
 =?us-ascii?Q?PVFhS5wJUjjuijxK+m0yTro+71ZZTUzJuKtgTq66M8jNkcLje4MSF/+f/+c+?=
 =?us-ascii?Q?m9YiRjA955L29f5Dgz6hqksjtUNp6V1UxDV0TztWoWPY1vUUER/Bjx6J6xsV?=
 =?us-ascii?Q?X5mNWt7VxHvtfdmx7nl4KT+NDwTcUYD5DV6WjtMgI03itNJbCq88WtqSAFq/?=
 =?us-ascii?Q?znlkT+y71TSgJYttUtLv5S81D2iViaj/nNgHm85bzbmcFxLJMMXV9cBrvcKX?=
 =?us-ascii?Q?P1+3v1AZDqYGr6obKJ0XiIH0cRKA1z6w7kS28vBBVEHqzN1zPZsAHiYdYBtO?=
 =?us-ascii?Q?utQDihPdGbmQ+fWTT8iwEJT/4f9O+kD4UFrycXW6BfMZkH9nyVs/huUKXVvD?=
 =?us-ascii?Q?HubYOkZ8eQUz8dxwBqFK/2ObrLEuEHAZ0mSfApjBAwbHk4gDEoDQFzuW5uIc?=
 =?us-ascii?Q?HvPeIf4xYuRRWt86pDYgsiGwGh+nvy+Ol5Dfi52XQnlRqW7KgjvbXxNF/yqf?=
 =?us-ascii?Q?cfVJdBrLAhLl+WlPBbJLEmwlMyQdb+QRYsUMFiby2x+/UYZ2h4/xxWD8+kOZ?=
 =?us-ascii?Q?2WG8BBixnXVBM43AAVOBUWnGL3XzPKt3AQVu8rA1WQHob4RVKv+GzXWHxpT3?=
 =?us-ascii?Q?I6iSXVxXeVrBJTNVmjEq9QZwWcmbLG7Tz88q0tG2EQuEqdEipiGOh8FzLN+D?=
 =?us-ascii?Q?PQjq45oTw1I/nkamFKUVSshwslnKDqv9IxMFK60PCy5WqqRKztOVVE7ohgRK?=
 =?us-ascii?Q?dFJsmIBl7Vycp+G44p/HkeoiEoZAHXNoI8tJmDYWmel4kjqi/Wfyd5B9wNM0?=
 =?us-ascii?Q?eqkNEaeFtoyjYGGRfXXO4XgUcEX9VAOpPUg3EL0BgzaUpknX1r/ZI21OwuVE?=
 =?us-ascii?Q?E5SQnbw+XO6uG9B7OA/SwD2VOtvtDjh3UR9vdpV2Mxmt6c2iw/IX7R3Ce91Z?=
 =?us-ascii?Q?LkJt4f4g6tBKMltjUQg+404gim/+9QDYUUjkPJycq7aasLQcgka+Kd9Jm7aE?=
 =?us-ascii?Q?loOpVELN5xhbeS3TTj88T58=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CE422C090DEB2243BB55A36D1DF4FAFD@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB5117.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d1e5962-4bab-4be8-4a3a-08dc9bfe2128
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2024 07:51:35.9696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z8o1mlSN+NxDrwwGXp/FLKHi9l1Xvd8jJy/3Y9duTuN1VMW8BfvTq7DO4I+OlV/nGwEOcA59ErgVTL7IIn9yAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR15MB5777
X-Proofpoint-ORIG-GUID: VzH5F30wHSSuv09tdtKGiM3iYar2qSH5
X-Proofpoint-GUID: VzH5F30wHSSuv09tdtKGiM3iYar2qSH5
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-03_18,2024-07-03_01,2024-05-17_01

Hi Jens, 

Please consider pulling the following changes for md-6.11 on top of your
for-6.11/block branch. This PR contains various small fixes by Yu Kuai,
Benjamin Marzinski, Christophe JAILLET, and Yang Li. 

Thanks,
Song


The following changes since commit 98d34c087249d39838874b83e17671e7d5eb1ca7:

  xen-blkfront: fix sector_size propagation to the block layer (2024-07-02 08:58:12 -0600)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-6.11-20240704

for you to fetch changes up to 25b3a8237a03ec0b67b965b52d74862e77ef7115:

  md/raid5: recheck if reshape has finished with device_lock held (2024-07-04 06:35:19 +0000)

----------------------------------------------------------------
Benjamin Marzinski (1):
      md/raid5: recheck if reshape has finished with device_lock held

Christophe JAILLET (1):
      md-cluster: Constify struct md_cluster_operations

Yang Li (1):
      md: Remove unneeded semicolon

Yu Kuai (2):
      md/raid5: fix spares errors about rcu usage
      md: Don't wait for MD_RECOVERY_NEEDED for HOT_REMOVE_DISK ioctl

 drivers/md/md-cluster.c |  2 +-
 drivers/md/md.c         | 12 +++---------
 drivers/md/md.h         |  4 ++--
 drivers/md/raid5.c      | 76 ++++++++++++++++++++++++++++++++++++++++++++++------------------------------
 4 files changed, 52 insertions(+), 42 deletions(-)

