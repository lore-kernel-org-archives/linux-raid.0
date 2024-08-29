Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB911B9B38
	for <linux-raid@vger.kernel.org>; Thu, 29 Aug 2024 19:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724959613; cv=fail; b=o+ZIJGb2Ezn7R+YNOw+alG4prHUexiQQTaqeB5T9o5ag4zu9UJbhbGOtsOKdTl/WwLjEOHFNFOUX27fN3aXcBfSEW8TdVYISGcwRPDyWoKRgKPZYfHQn5jmfYXPe4VKBuzykVzlCPYN76BmMdGqSfi7do/VAyLgdEgOnfHxojnM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724959613; c=relaxed/simple;
	bh=Yv13uEBvXWaBBdYz5CZi+qrhLITQQvMGzdfZvB5GDhE=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=VHlmkA5JUikvZVWxlA6rjpbtfjfX68w3e+c00/yggHf+Iq/FrNqAmR1uzoCOBVUMFGmYA4I0iG1U6YY9IzaQ0dPSjo+9qJZBI++mqpcKeVjcPJ0p2LbaISUAC3bSPU/Dv6KOO2zSjgpIkznvvwLpw687J7OsKmh3URH9kf1Nzcc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=DcrJs7p0; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="DcrJs7p0"
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47TJOnAe030423
	for <linux-raid@vger.kernel.org>; Thu, 29 Aug 2024 12:26:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:content-type:content-id
	:mime-version; s=s2048-2021-q4; bh=MIPKtmOvVEubFwAtVCNVMOxV79a2P
	1wbQtY437qiA2k=; b=DcrJs7p0QsKlZ/W8X6tCy/ykD8X9dVRDskALxdvZ3m2wW
	TCqgAnWSYGojAKHuQe2yrjTsxfOmHp/KtWYkOXGjZs6l6xFN+bpoLg0G4Ls615Vy
	K8xKukN6WpMeU/t/DANkeE/tfOOmaAs8i9IDtqG1/5MqPKiwsN2em+P3p8QUhMlQ
	aQ8BSoAWYC7ZcYs/fo0yrt81UTb+wVHwpwPozVwSmqmNZodgkrSaByvm8aR6Mzr6
	mi1dzJVAOulKO9c3IJH5aElvjMw3W8YBULqgfz1oSxmgMRoUJjxeGV8fE9zH8Tdy
	RbgAHgTvY+Bibx7D9DUlfT8JHWAQ6CzLlDAM1B9gA==
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2042.outbound.protection.outlook.com [104.47.73.42])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 41awnggsh9-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Thu, 29 Aug 2024 12:26:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cch6uYn44g7B/UZKYpMb1Q1xGDlm00I1Liqm22HFmAt7ePKj8EF6Pn4ZQ4+OUGi0qO9JuHe0W8jLTa4HEMBR8cGN8NeQayGJXa+oc7XKM5TUZwaNBsf83JlZ1QjqUrwkAd7ZY9cVpv7WIx91mVb2MNUtE3lRhcyUOT3eKRVtzi10vePUPD1wQaLkRabQXp9KnH99gXHnRMsY21khsMbMun2K9KWNFrTKOFxe9rWAza6qyPnAC15s1/I22GWttDAubbs5M9gcp3B0tvA6odwJqt3jIeI8yzGtw8F55V642ifxN/6NHYZ4cqS+V+e4T0ehh50Y4Q4cOgz74Ldz1o6lJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MIPKtmOvVEubFwAtVCNVMOxV79a2P1wbQtY437qiA2k=;
 b=BPZY7+z5GginN9fVaV7J5EF1E0XvFe/O+dCazxHmbb4KEHZOl0PoPaSGPs6ayROb/2HNw6Us90L/HDMum6M/jvu5cLpq2a7y7NIAl1JQ2jj4craJg/0ayd5zv5lTj2q9Wf3mMoKqgTYvv/obnyildjIxG/a46Do0gOV1JCA/60nFdRwIQJEtIWpVLt37zQLq9YUoaHwJgQa/b1VbyivJ5obA3UwRssh/Iju9buhJvgGx1h6AcT7/GJBHAhm1/Ox6eGM5LKP1Xr4faoblXG1onK9hBJ9l+aIlzaZQk10yUQR1M+U2u3KuQU5Ibj4OEKuYGZgsE2a0pVdeZl6sPARznQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by IA1PR15MB5918.namprd15.prod.outlook.com (2603:10b6:208:3ff::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Thu, 29 Aug
 2024 19:26:47 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7897.027; Thu, 29 Aug 2024
 19:26:47 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: Song Liu <song@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>,
        Yu Kuai
	<yukuai3@huawei.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Chen
 Ni <nichen@iscas.ac.cn>
Subject: [GIT PULL] md-6.12 20240829
Thread-Topic: [GIT PULL] md-6.12 20240829
Thread-Index: AQHa+kljT25HlXqqpUydQ9h4x+hYCw==
Date: Thu, 29 Aug 2024 19:26:47 +0000
Message-ID: <2AA457C7-E999-4949-BD8B-8779D3FE9B9A@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3776.700.51)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|IA1PR15MB5918:EE_
x-ms-office365-filtering-correlation-id: a3d9ae5d-bbe3-4b05-68c9-08dcc860863d
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?1iySdC5m9+fEoGCKFPrbVuXmwi92iY8XPyOeTj0e5BPS5pyTluvsyMjmP4ao?=
 =?us-ascii?Q?l1dQmTjrnjPuUw4WNJUjO/DG7WgSrw6pSsmhQFF/BdRBHB+WZxvwVFPNgak/?=
 =?us-ascii?Q?1OQH2hRKrp0b+fk0IGpNtXHUIKqSjDAZalo1WID5ucbCMmxfCR39aWXZ5NTF?=
 =?us-ascii?Q?cYrFcDqZVW4V2923d6SzDJOnJzmyS2UFwlZWLODbYeI/TjdHfK/3n4rn4Y8Z?=
 =?us-ascii?Q?UNZY7GxuwdT4vqxzSarjuLzUYUtSJm8D9lEO9D4bY1doH7nYJZlYsH7/5Zjk?=
 =?us-ascii?Q?aOw5FTv3TUDTHz27DrPQ1x8j7eqVWS4hCQ3lyVQNyoioPwLJ60U+eR/w5vOg?=
 =?us-ascii?Q?Z6enS9ZVDkU9ZL8tlsbrKrLiHYPtPCDJUTKomLcLqo2LD9lQSpqOp55hK1Pa?=
 =?us-ascii?Q?3L7O6+0ZNmGhhTc2jQgcHCzjrfQJnmKuI/PeiRn/7LLJA6IiH/nLg3m4KFtQ?=
 =?us-ascii?Q?xHjyP4Tp5c3M5ieM1jP1g6fGZiiqdsjxTebwUtHMmhiFKC89F9FHno+9z5Oa?=
 =?us-ascii?Q?z8L4ln4kmf1tCh96Lospm+F9+VlaW/Nz7MJPu0ZOMatQdirsGGdROMV8EQmm?=
 =?us-ascii?Q?/X0VpE1uL9/vwfA4mya7zU7m1bU9cZVRALfpifqZ2qvOY4zGThjHGG58Gg1+?=
 =?us-ascii?Q?L+e/Rxva5X8BoopFTaSsBUCQk8UCr3n1JIL4AidOHL+1x1ua96yxtn6DJvuA?=
 =?us-ascii?Q?aRj/C/nWTrTPdFr4XNI4kuhankOMIOPmM7JP5HELqTimIJYEHyAeshr1szfW?=
 =?us-ascii?Q?sRUtxjwWc1ddJrHdzmjkwMDO3Kedjiv0eXbqcWuhxmMxrPTCQXouReh4kqIt?=
 =?us-ascii?Q?q5RjzD3xWpETgVFz2QwlEXAydGAxNg4NC3Nn8a0xDhrTwjEfhuTA4G4Ou612?=
 =?us-ascii?Q?JB4DzJAScRiMufn6z/c6YCOxH+vaU2rgOIAXzbdIN+IrTI8AFBMjg3toi3Z2?=
 =?us-ascii?Q?Rdyk8AYpliXazds8mrdS/ychdzKiJU629D2KZ4S0I/CrSbdLmZAS8ziAoMYT?=
 =?us-ascii?Q?b+i9GNSZio8nj43pX7nkv1RDcKDO/KTkA89Hj4QhYQC1xZVg5Ab+6TLy+3XB?=
 =?us-ascii?Q?Ss3nK4wJWIQh2uJekTenHI6Dzmyk39ad5xPrnIflPP2gS5HPwrvz0imzrMAC?=
 =?us-ascii?Q?2/KA0MQD0IQynrf4TXYxuOW1qonCxIWfkDE6ZZiAXMqWgBGvijxNg+zSoUdg?=
 =?us-ascii?Q?zyLDPkthQ67vwuLabpVjosiT0GHbGdvxHeyeuYAAnGqgsNGk0VjoipoagoJn?=
 =?us-ascii?Q?37I9GBac6Eba9TRcwCSqBDihipY+tofb8V91Y1K6s855JnrLlUOrGTnlKm3i?=
 =?us-ascii?Q?tBDuY7IdefJDJ8VLFyLxEZqnt8CjZYoNkP1gvLi6zAY3BUP9JOgdP7d9nSdb?=
 =?us-ascii?Q?nuJoD6t9gNw6yNs2n1rcFdm+0gwsqmHaXoR6CZoNJpfqXcF+VA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?gN9sM0e41tY6Lk2snIRdLHv8+w/Lbf05y1iU4bPI7qAuykl1iL1nBDGC4VUU?=
 =?us-ascii?Q?HOxYVpjNZYDUR3VniM7uv79Ix5RHnBiqn/0qJFdJVIt9oqHBLWrzfHThbLTY?=
 =?us-ascii?Q?eoabl+YXLc4XZPMmMjZPUWVn4NAM2+OTVZuYV4ovl4sW/bwqYd4zuD6gnxPP?=
 =?us-ascii?Q?E5pMgSbvXf6gUQNGorR2FbJ4sxDkGSq8YZ3D1iD7I6gL3IrrVQjRhJCByAKV?=
 =?us-ascii?Q?e74KsgJMDyVAteQqUnRl57/bTwgvbNFbT1VZkuAmOvYhaNAwtq2NHz0MYnvF?=
 =?us-ascii?Q?5nC4NyCOdY35aGqiVHUGgFNSZZzpvhHdKvlE1sBeLD2OljhRcezY+514TqLQ?=
 =?us-ascii?Q?XMvLo0JJd6Yz2h1NJYxmXc9TR/O38/uwCc8Oz3EE2ZITxsUkpN22hZIJwlbC?=
 =?us-ascii?Q?uJlfbwj15RTl4vQCjQS4LG/5yi0KaB5efQzT9qSc4YLlZLvyyxBKBcb5B52F?=
 =?us-ascii?Q?1iYPWHU2pbLcLd/9Pd4ycUL8EERGda41O0DzPbax3on/ZOringzgL4sbu//o?=
 =?us-ascii?Q?NTOUNQx4zETonwYdBDQYywQy6xXc9JulWGhGZQQNKzELI7QIYYJjtisO1DZC?=
 =?us-ascii?Q?Pj/6zf7VMBVtW/Ryl0+6t7Ud07WeLWTV8VeLZ/2C2198coPYaOdQjbzB19Vk?=
 =?us-ascii?Q?zIhxFlrmK8S8yOBfkCxRNzNK+lVoc5lPve3dqr7ph/DBqXimoEZzCXrvL2Rt?=
 =?us-ascii?Q?oMFiIMW6W2abKVYADpi0U83CbOlr+31HfIO7shxAjcImsOAHvsiSOw3sujDn?=
 =?us-ascii?Q?5+epICnFL+b/YEmGP3IG/5sIyc9WxYkDO4QnUFlbWNGeMHpt8IcxPFPao1OH?=
 =?us-ascii?Q?0mrWkoZypZIXa3WJNQN+h3x7SC0aj56Bx0+aBD1b4O91IFqOX4johlWYumwY?=
 =?us-ascii?Q?q58k2GKXmpTntGwwq+IKs89WUWD+Auwr6RkkhDrOzUDMx82SSrDdH1o7aXhx?=
 =?us-ascii?Q?9ckO4+c1bUveDeYiHT+brmb58QD65wqKhG5O48exlGyc31/BAFV8DZhu1Qfr?=
 =?us-ascii?Q?OhJUR+fQCHN3ZUu2LROosK+REdmpoEvLxDapKCWWxMZdgWcagRFYKe73w1kl?=
 =?us-ascii?Q?yPjHGmtMkwzAH2t+Zpm6CsIgtphj58mWnvBnsQ705vGpuouKKZ+gmL31GJOV?=
 =?us-ascii?Q?AdrLkRiNDaM/o8L8j+OS+0COd99QEjedhiPq13vYmjdK6OlgtHmkWsUKig39?=
 =?us-ascii?Q?voIq+rHmD9BHPp6VcFdQxgo4b5s9qwLtPf16A/LQ/rDwFCJS1H3BmPg57p+6?=
 =?us-ascii?Q?NLRAZX8rrlft4OxdH7/SJ2KkPwkoRJ8MzKBqO7dcTB4ScKcyCiZSLzxogQYa?=
 =?us-ascii?Q?YqZM/rI2XVOMTbQWZM3RWGzcRPmiDrxBbkEzJYWHx0bKl2qlc0SVaC74s87K?=
 =?us-ascii?Q?MFV/0RfLhmLVf7h8Xr1mItWV4ukkLz4ciGs6goiFl+k+wMRClBDWoBNMyzey?=
 =?us-ascii?Q?bnx8YeCt9ERqUXho+31Bqw8LTSP/aNWB7HQGtEflChAELsHWSdykHJwSsmfs?=
 =?us-ascii?Q?pfPVlNydf95f6PkKTB1NclZro7J3MDZZgV94mYXcOpttF1k6k5oHxkK7IqUe?=
 =?us-ascii?Q?6z0wYCq5Ow7yEvQL34qunjtAPzz6BByeDf4hjKVFhdY1mFA00+V0OWHNrhst?=
 =?us-ascii?Q?+gE/t3s0nHFRGGlczVWN8MI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <32BFBEAA03D4A940923BA1A57CCA9870@namprd15.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3d9ae5d-bbe3-4b05-68c9-08dcc860863d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2024 19:26:47.4202
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OK9nTSTpnyfS7Ak8Bjjw5Kk8nAMBp/eMYqdz2kzmSYdyLLdYIcDFan1ATs/SLWKWMmz6109VKK0SkrOb0tjokA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR15MB5918
X-Proofpoint-ORIG-GUID: 6zJDyBmqvkkHjqmw2r7TfUYEW03oysKi
X-Proofpoint-GUID: 6zJDyBmqvkkHjqmw2r7TfUYEW03oysKi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-29_06,2024-08-29_02,2024-05-17_01

Hi Jens, 

Please consider pulling the following changes for md-6.12 on top of your 
for-6.12/block branch. Major changes in this set are:

1. md-bitmap refactoring, by Yu Kuai;
2. raid5 performance optimization, by Artur Paszkiewicz;
3. Other small fixes, by Yu Kuai and Chen Ni. 

Thanks,
Song



The following changes since commit a28dc358e28fb0738dd23e401cd7646cb4b0f7f1:

  block: constify ext_pi_ref_escape() (2024-08-13 06:20:02 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-6.12-20240829

for you to fetch changes up to fb16787b396c46158e46b588d357dea4e090020b:

  Merge branch 'md-6.12-raid5-opt' into md-6.12 (2024-08-29 11:22:13 -0700)

----------------------------------------------------------------
Artur Paszkiewicz (3):
      md/raid5: use wait_on_bit() for R5_Overlap
      md/raid5: only add to wq if reshape is in progress
      md/raid5: rename wait_for_overlap to wait_for_reshape

Chen Ni (1):
      md: convert comma to semicolon

Song Liu (2):
      Merge branch 'md-6.12-bitmap' into md-6.12
      Merge branch 'md-6.12-raid5-opt' into md-6.12

Yu Kuai (45):
      md: Don't flush sync_work in md_write_start()
      md/raid1: Clean up local variable 'b' from raid1_read_request()
      md/raid1: use md_bitmap_wait_behind_writes() in raid1_read_request()
      md/md-bitmap: replace md_bitmap_status() with a new helper md_bitmap_get_stats()
      md: use new helper md_bitmap_get_stats() in update_array_info()
      md/md-bitmap: add 'events_cleared' into struct md_bitmap_stats
      md/md-cluster: fix spares warnings for __le64
      md/md-bitmap: add 'sync_size' into struct md_bitmap_stats
      md/md-bitmap: add 'file_pages' into struct md_bitmap_stats
      md/md-bitmap: add 'behind_writes' and 'behind_wait' into struct md_bitmap_stats
      md/md-cluster: use helper md_bitmap_get_stats() to get pages in resize_bitmaps()
      md/md-bitmap: add a new helper md_bitmap_set_pages()
      md/md-bitmap: introduce struct bitmap_operations
      md/md-bitmap: simplify md_bitmap_create() + md_bitmap_load()
      md/md-bitmap: merge md_bitmap_create() into bitmap_operations
      md/md-bitmap: merge md_bitmap_load() into bitmap_operations
      md/md-bitmap: merge md_bitmap_destroy() into bitmap_operations
      md/md-bitmap: merge md_bitmap_flush() into bitmap_operations
      md/md-bitmap: make md_bitmap_print_sb() internal
      md/md-bitmap: merge md_bitmap_update_sb() into bitmap_operations
      md/md-bitmap: merge md_bitmap_status() into bitmap_operations
      md/md-bitmap: remove md_bitmap_setallbits()
      md/md-bitmap: merge bitmap_write_all() into bitmap_operations
      md/md-bitmap: merge md_bitmap_dirty_bits() into bitmap_operations
      md/md-bitmap: merge md_bitmap_startwrite() into bitmap_operations
      md/md-bitmap: merge md_bitmap_endwrite() into bitmap_operations
      md/md-bitmap: merge md_bitmap_start_sync() into bitmap_operations
      md/md-bitmap: remove the parameter 'aborted' for md_bitmap_end_sync()
      md/md-bitmap: merge md_bitmap_end_sync() into bitmap_operations
      md/md-bitmap: merge md_bitmap_close_sync() into bitmap_operations
      md/md-bitmap: merge md_bitmap_cond_end_sync() into bitmap_operations
      md/md-bitmap: merge md_bitmap_sync_with_cluster() into bitmap_operations
      md/md-bitmap: merge md_bitmap_unplug_async() into md_bitmap_unplug()
      md/md-bitmap: merge bitmap_unplug() into bitmap_operations
      md/md-bitmap: merge md_bitmap_daemon_work() into bitmap_operations
      md/md-bitmap: pass in mddev directly for md_bitmap_resize()
      md/md-bitmap: merge md_bitmap_resize() into bitmap_operations
      md/md-bitmap: merge get_bitmap_from_slot() into bitmap_operations
      md/md-bitmap: merge md_bitmap_copy_from_slot() into struct bitmap_operation.
      md/md-bitmap: merge md_bitmap_set_pages() into struct bitmap_operations
      md/md-bitmap: merge md_bitmap_free() into bitmap_operations
      md/md-bitmap: merge md_bitmap_wait_behind_writes() into bitmap_operations
      md/md-bitmap: merge md_bitmap_enabled() into bitmap_operations
      md/md-bitmap: make in memory structure internal
      md: Remove flush handling

 drivers/md/dm-raid.c     |   7 +++-
 drivers/md/md-bitmap.c   | 568 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------------------
 drivers/md/md-bitmap.h   | 268 +++++++++++++++++++++++-------------------------------------------------------------------------------------------------------
 drivers/md/md-cluster.c  |  91 +++++++++++++++++++++++++------------------
 drivers/md/md.c          | 294 ++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------------------------------
 drivers/md/md.h          |  13 +------
 drivers/md/raid1-10.c    |   9 ++---
 drivers/md/raid1.c       |  99 +++++++++++++++++++++--------------------------
 drivers/md/raid10.c      |  75 +++++++++++++++++++----------------
 drivers/md/raid5-cache.c |  14 +++----
 drivers/md/raid5.c       | 157 +++++++++++++++++++++++++++++++++++++++-----------------------------------
 drivers/md/raid5.h       |   2 +-
 12 files changed, 832 insertions(+), 765 deletions(-)
