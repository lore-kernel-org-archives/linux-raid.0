Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673A71E520
	for <linux-raid@vger.kernel.org>; Fri, 16 Feb 2024 20:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708114388; cv=fail; b=ueHPFNlWvAxpDRg3ukKDSCERm4/Ck1qd//BxLkdsYjlHWZW3i2xAgedDYRcSgshz45JJo3GS263W7Uo3HuHpPedA60swixLKrJOFQuoKuphJyIQ2snDwlUVT0pudz1WuVf4twcP82SBimYEE6QOG9NTtfjoHsvQwQ/q4QNTx3f0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708114388; c=relaxed/simple;
	bh=jSJHz670+5aULAkbRGfLXhjL7Pe3qqZcSRS3aUwBOaI=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=YuePACfXuBwiPHT+/u8hR/GzGNeXTsY686Byi4lOGbX/7LdyuzKTerZB0kAJMz3jQg4BWt1LkdwFk/xZbzlL3A43KlCtbTzA4v7f8s2XuPvDaXcFmeKbtCcN4mg9xE59NC0y+u1XvqIahxDJsJwYi2V2JJH37gwssICuZssDKsE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=cac634QL; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="cac634QL"
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 41GDmUCW008553
	for <linux-raid@vger.kernel.org>; Fri, 16 Feb 2024 12:13:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=v6wFTA5tgye27IsaJbqgYLdY62ZUkeI2o7Mgp57AZOw=;
 b=cac634QLUYD1FYPnrEmLV/Ixjig7iAoDCLx6v7OdWQgHYu4isrnkLGiKdcQNKoY3IvFv
 UvS3BlkH5KJpVSKpcp+RQ7RedU1I3clT5A4pEmV2XSGmeKSiJ8WdlWCDCwg0ZvK6msDb
 o5ZgdarDwptvQwSpt6IG9BrBmz1V6dNQ/k8XxI4qJxOFFeGSrbKLb7PjKtDBLPR4dyaj
 WyrA9sEaiZE6PqO38CiNi8BgW21x/5sKdAJc4kvxqcKjQ3gvI7jlUuULaAJyC9p7TqKU
 13vThPRlVcLfW5JeQYHkrDYFssus/XcdCTeJ2sefkIGoXpoaoC0KWBjqoOJVkXgqHBXU 4g== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by m0001303.ppops.net (PPS) with ESMTPS id 3w9dk13gte-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Fri, 16 Feb 2024 12:13:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OrB07AuxO1YuDuCLtJ2Z7bKZFi32bdMCsAYniAyb7HkAmcCpxGnLekESyHLBEsaDu6IkVsHPfyhAu750LBcHfWmCV5qZ/RggtHBdHDKZy8h3lwU8XirCHhiFJK58i9XwdWasSfK2xRLsfukpG7zwU9H9TymyT8ILkDpetiW5j/TdnXPXAaNFkmmAJdwDfZYrA6Ks1K+hq3E24rfqKYNA8xm/noAaZyQ9g6IaGu4LVTWjyQEpAEwwEeajmjw90ywsO3qxmVzmQnPCACbJM0BsF8JQEivUse/Bu3lmjlaDQ7AWRjkg6nxwTvgX5T6BAun+8XMWXq8e8w1iR6UFBvXwNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v6wFTA5tgye27IsaJbqgYLdY62ZUkeI2o7Mgp57AZOw=;
 b=fvSv3PL+IYUhqZj9XpbpUWvoCm1uZKFGekZYc67H6E222N74LzL1aWdrg8cHBJ1qE0td+Y1FBu0S+XsO7rpE6IE4zMd1zgP05ziRBZy6ax7nnU2qYNPlGVUm76hd1blHA4b8vsTeN4h2s17f0/tiCrpMftfjsJBG0Us1hS1+A2kLE2LfDnBAUtmzIYFZo0f8NojLLHgNKVuz3b7TBat+js5NlCd0GeI8LcfZeMBYXWe5tgNQqJe+aelsSqvO+YPs2QtgjBDsPLbz4RuXJvTG0F46xBptD6+lnZi8b8V75HmvC6OPnmiay2CtwKnip/ZadK+k+7ltJvGFrMZz33HXlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA3PR15MB6193.namprd15.prod.outlook.com (2603:10b6:806:2fe::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.32; Fri, 16 Feb
 2024 20:13:01 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::d467:8e49:f5a8:c0e5]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::d467:8e49:f5a8:c0e5%7]) with mapi id 15.20.7292.029; Fri, 16 Feb 2024
 20:13:01 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>,
        "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
CC: Mikulas Patocka <mpatocka@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>,
        Li Nan <linan122@huawei.com>, Yu Kuai <yukuai3@huawei.com>,
        Xiao Ni
	<xni@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>
Subject: [GIT PULL] md-6.8 20240216
Thread-Topic: [GIT PULL] md-6.8 20240216
Thread-Index: AQHaYRSKLjjk8tNMqkue0aPjhpdPXw==
Date: Fri, 16 Feb 2024 20:13:01 +0000
Message-ID: <2D753D1A-F9A6-4196-88A3-91C7596C17DD@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.300.61.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SA3PR15MB6193:EE_
x-ms-office365-filtering-correlation-id: c1aa9327-315e-4e84-edd7-08dc2f2bad59
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 BNtBPTkag6OmodqzKh/60zp2f+WKiTDts//B/9XTo1w2vJGS81WKPdylNGIo0eB2QFlNq22bJ7fPktAGuNx2J6Sf1UsrHOObI5UdcI9vd87n3eXve56eWW1iPKclelhznGZHFo8Q6UdR67qUp8cv3bEpt0uqFqYYuJ/cJn9CbvnjgMyLFIupwkq4cLOMQ+B1+nUf/kPSTvGWrCLXQhg74znmQ/1QlLiOjhPGOFXqZFUU0tx55AeUriYjDcNxuStXX9bIaZb2SQGwmrDj1KtVHryOH5UDL5yX+FGlAKCRXw0Yy+3MIt9PU2yEKxJkYyyEZdA/XbZaVIsBblgIaAFa2s0jK3g793YH6KwFF/keNPb1T3fbEs12YEELHGrIfq14hOrEBaAYXHBGUD8xTiO/tw2QFO0QP6GleoWZIY6tOpnvhA2d3pprIUapAe/IAxkHpLcVUZ1J7mqV/M60zyVg7HEMc0Lv/m7LKwlqOOsqNAydLNGrBxjuabt+Z361P41BhhOZ03NvE4l6bYwBpoO+FwZ8wjUUTXpi3mhIY+aQB/0Q9Vmx/7L6Fgo0piawOba5ME3D6KvaG7UnF0OApDAHRRqyFJBhPBQdUvBlAEX0gtM=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(346002)(396003)(39860400002)(366004)(230273577357003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(71200400001)(41300700001)(4326008)(2906002)(8676002)(8936002)(64756008)(66476007)(66556008)(66446008)(5660300002)(66946007)(76116006)(38070700009)(110136005)(9686003)(6506007)(966005)(6486002)(6512007)(316002)(54906003)(478600001)(86362001)(36756003)(122000001)(83380400001)(38100700002)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?uvq1QDQU1Gc/+CidC2/IKvFrzzWF+a8nuvZ8Y3sHClDNCuQJNcq+o7xJjUWe?=
 =?us-ascii?Q?7PhLT9Rj239SjNl4w3Vace/14KW2Mp0PWhiNpVuYJN/v9Qt5+5wTQeHOa+On?=
 =?us-ascii?Q?/M2YMOpOOX5y/dF8/oEWb4KBhxwcMmE2fqd+xZEPp8rZ0NqOkjEL4oQiBROx?=
 =?us-ascii?Q?DVYcxu5BR+Y+axj4b/JDNS4GNaKIYEFwERwAUEAKb8e7eM5xSl7IXSRSS3KI?=
 =?us-ascii?Q?4o31Ng2DWNh5Pmku6zOIfEV+iN0mfDayNwDMma/HwqpxpVQM22fdA6cs9c5h?=
 =?us-ascii?Q?/4+ee9UddulmDciiK2Lfud0209gjdNFKjnTTXRDLh4w6eA4gYZ5WpEf04ISC?=
 =?us-ascii?Q?KWUt6obT+1oYnrfUixTG9bWESFPuvse3r0XoAdNl36KOSrHeSdCpe79e2Ekn?=
 =?us-ascii?Q?+QwClIWnd4GscDQ1IKKC1n49k+ElxruolFLOXHDYlu176hWO0zR+FRvkcTYG?=
 =?us-ascii?Q?vsrNnhS+kFZ/92STd1Ls4+YVZBkXN5/PPcHHlC2lbsH6iWgC/U2YfQnhzU5n?=
 =?us-ascii?Q?cFpHOm2KQoxI5FsamT36lfF5Is0BX4b6MuLxtyCkUDaY66GUN4Eel0DhHkVb?=
 =?us-ascii?Q?kfXTvCoNBehcvsXt3sHtQ3ImG0Z9boqOzF19K0K820f/MwpaPnh5nUf2l5Sz?=
 =?us-ascii?Q?ZkKdDQ9kMO7ZwMg5gfo0jGsLnA/Si5b5P569G0qr37KiFlI84qau1VvFztHE?=
 =?us-ascii?Q?fiS3QN/pqf6qUaju/v9vETJIC32lY63O3mIHlMf9jgPDEH0WAXt9XoExIkBe?=
 =?us-ascii?Q?k99cc0Q9fbq171/ciXYyXW0KR9ReYIjt9RQAmaBJbr4THg1N7jlmFoIOfRb4?=
 =?us-ascii?Q?MelzNSvEj7smPYOKEg/fp9sULUNIPXOvHCHCLY3J6caF4xRM+nKh5yeOUrju?=
 =?us-ascii?Q?bQsaAnYKzIEPuWz6uPzng2ZkDhb3nfL45EevR/kEOK99bPybJ+7IBF6jpPv2?=
 =?us-ascii?Q?HsmBZLZbRTtr0H/2F82z1dii53se4QShkAesTbc/bui3nsIdKlnhFKAy2oJv?=
 =?us-ascii?Q?jQPHciLD3PU7xFttltvG6A0tb4kqdKUatAT/3xGSA0ymAMSPojucQPHnQ1u+?=
 =?us-ascii?Q?FHE1VQCYFByUbASZln21ZGfK6QZzRQOX1fMsBIFqoXe6Jn/VphLuua+WRFWU?=
 =?us-ascii?Q?QW4TXHWqMTv2GnO1qHizAyyxHoZ583SW6/p5PfOU0DcgDawfHmN2W4xxbQqE?=
 =?us-ascii?Q?poPMA21lvyIdyc3p4vtp/vCH6vjgGwQKhNTGVF1HrclaFbobKgMzE0j71ZvL?=
 =?us-ascii?Q?CK6xUBficEn8mt4ENH96QXI2RiLufxIZs05i7A6HF+Z805aBehbPbdpT7OYS?=
 =?us-ascii?Q?FZgnKf6D/95akTld/YYMk+sz6xwyZ3lWHbsouk+hzOjoE/zH5dIiSgH4mulK?=
 =?us-ascii?Q?udbdmn14gqFIoMYTMej9woreP0rSxP7zmZlLPYl+02RjR85q6UsE1a0yA8AZ?=
 =?us-ascii?Q?zQXu23dpmpQ69gu/rS3XL6YP6G51Pa0dr7dEKS7BK97YOaTpQMtqclXBXeRU?=
 =?us-ascii?Q?wA+US9xALpJGVsHm7KTC+hDZ+Hb3Wl0Vtc5o4IZYsq+j0VYe0N3ulbepg4eu?=
 =?us-ascii?Q?YoyX2lpC+iBhzooKwOkF4YpwPiupEZ7bcSS3k7S468npKITkrbyvW3dw1vOJ?=
 =?us-ascii?Q?VVpeFbjzcVSMWpMilPle52g=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <64FB98B6C616674EBA2FD3CEFB4F7FC0@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1aa9327-315e-4e84-edd7-08dc2f2bad59
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2024 20:13:01.8077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yoUgs+L/pw8ts+Aob56cGYXxMfuEEJy8VE72T4B9DANna4DJl0+8f1hZrjD/tcBnDYuRfR+97YImASg2qVlsDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR15MB6193
X-Proofpoint-ORIG-GUID: XJJNxGuNimFqMk3V6MVdPZQvuFT5aaE8
X-Proofpoint-GUID: XJJNxGuNimFqMk3V6MVdPZQvuFT5aaE8
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-16_19,2024-02-16_01,2023-05-22_02

Hi Jens, 

Please consider pulling the following fixes for md-6.8 on top of your 
block-6.8 branch. The major changes in this set are:

1. Fix issues reported for dm-raid [1], by Yu Kuai. Please note that 
   this PR only contains the first half of the set [2]. We still need 
   more fixes in dm and md code (the rest of the set, or alternative
   fixes).
2. Fix active_io leak, by Yu Kuai. The fix was posted in the same set 
   [2]. But it actually fixes a separate issue [3].  

I still hope to ship another fix for 6.8, which is discussed in [4], and 
fixes bugzilla report [5]. For this fix, I would like to get review/ack
from Yu Kuai and Li Nan. We will get this one queued ASAP. 

Thanks,
Song

[1] https://lore.kernel.org/linux-raid/e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com/
[2] https://lore.kernel.org/linux-raid/20240201092559.910982-1-yukuai1@huaweicloud.com/
[3] https://lore.kernel.org/linux-raid/20240130172524.0000417b@linux.intel.com/
    Note that this specific email is talking about a different issue 
    than the rest of the thread. 
[4] https://lore.kernel.org/linux-raid/20240207092756.2087888-1-linan666@huaweicloud.com/
[5] https://bugzilla.kernel.org/show_bug.cgi?id=218459 



The following changes since commit 9f3fe29d77ef4e7f7cb5c4c8c59f6dc373e57e78:

  md: fix a suspicious RCU usage warning (2024-01-24 22:58:00 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-6.8-20240216

for you to fetch changes up to 9e46c70e829bddc24e04f963471e9983a11598b7:

  md: Don't suspend the array for interrupted reshape (2024-02-15 14:17:27 -0800)

----------------------------------------------------------------
Yu Kuai (6):
      md: Fix missing release of 'active_io' for flush
      md: Don't ignore suspended array in md_check_recovery()
      md: Don't ignore read-only array in md_check_recovery()
      md: Make sure md_do_sync() will set MD_RECOVERY_DONE
      md: Don't register sync_thread for reshape directly
      md: Don't suspend the array for interrupted reshape

 drivers/md/md.c     | 70 ++++++++++++++++++++++++++++++++++++++++++++--------------------------
 drivers/md/raid10.c | 16 ++--------------
 drivers/md/raid5.c  | 29 ++---------------------------
 3 files changed, 48 insertions(+), 67 deletions(-)

