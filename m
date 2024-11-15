Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C898B152E1C
	for <linux-raid@vger.kernel.org>; Fri, 15 Nov 2024 18:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731695711; cv=fail; b=PRgd2SgpD0b6ALSaOW+SV5rsSo+aAzVIji7xz2tQxEDscvYywFPSS+BWlvOlY7ISpMrXwxIbdHxREzMR7U9GaRUA8Rlu7eaDd6vTIYNy3vbr+UYjtJiu0+ScLIhiak6Xy7gxL70e5FJ9AcbldMas2elV3W0vlRmje4MSgDPNzDc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731695711; c=relaxed/simple;
	bh=nLWMwSeE/G3BfQcl8LPADpbKv/K5efh1ii8sIj2Ycbw=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=eiG1B7nz57TwBjQbLG2fcuDhkelNjUL4yVnKgTmDh1+rUMnPuh0TGuKJyGGa5RZYTTevr72Z8OcgJ0KAbRy4sXJyEmLuW4vJfmJ7yk8HXNvLov4Y5VngmIDUFOAbcPBE0xcQuLRtUM1N81Y4KAcnJi+ShXTdIWJoskOyRM4cFZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Zdgx6LdK; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Zdgx6LdK"
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 4AFIV9qT031801
	for <linux-raid@vger.kernel.org>; Fri, 15 Nov 2024 10:35:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-type:date:from:message-id:mime-version
	:subject:to; s=s2048-2021-q4; bh=zWWR9Ccet969pvtS+SyJOW9Zcc5jcZu
	Y0cpiKooUFUI=; b=Zdgx6LdKQnWfIKVpu3Tp1PNEP3Jk3DaJ8MFmB07UjYiEnes
	TkIYIbYR1sb2e5V7+SMGoa01zqg/KgwhSYzv+lPDHFynBrPt8inPpEFSJbZUY3+T
	1hjGx2o7jW9AUx3WUlrCNdhnqZG1DDa5K5qS1hdh+oPTy5+G6LlT0l6yzEey4hSG
	2QyMhE2HkgX4dRBEXNeewMMT8ikEy0EXvomuKb/UM9QBC1ZhpWcdNk7nHLJlLmEK
	iZczwvPirkRM5GD7JPwb44OA18sOgNfWNRIsDr0gpE50UvcLjcecvEXkf9ddyPcP
	6oW/Dor+s40qqnsvQpzPFA4vbSqwUxU9vwCr0Ig==
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2042.outbound.protection.outlook.com [104.47.55.42])
	by m0089730.ppops.net (PPS) with ESMTPS id 42xastggcr-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Fri, 15 Nov 2024 10:35:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wVxIjiebzwUDx4TcCBMRZ1jj/vQ2XC+LEZ5xSnwcWjes2MpKNh8H1lRVWrwDK9IjEZIUm/wWD+iu+aRSuU+48CXEvpMpM8Xqepvxu8sZhB7fYMMO8Ibl7RieEjIZAOfBqjr2fHwsSHANxbm5pFT6wmBvwQe2AAE6847jDUhaXl268fPIIwWQxpmF+yQMJz5rOdFSoN7gQx138Muz2QUKNF+4pRfDCbmbwynEG82Re1IT9FDQiS5f82uNw05W7T42VTr3PCuUZvm7OVH62GYcy7xXhOVr0sDVAwByBkB0UgKZK415VA3NGVF+GvluS7vxWPmN5LPktLQitoSZOxorZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zWWR9Ccet969pvtS+SyJOW9Zcc5jcZuY0cpiKooUFUI=;
 b=Ppw66ebUu+/GYEacTbbDDknJeRtb4wK6MrpTUhAi2BZxo7C9+wMDemlI4ut6ZPORJrIfHLDL5knRmir1ScGb2hkPG3PuogIK7qUrLRyWUkIXG14nI4+jeCUwdAV4+cej5zx0Yv2xjlaX4kKZ+bTp1kQih9TZqVfRvxuwjXUWk1WgdeHqdFhnhTSMBy+2NWVuvabhTSljMB50iAs0qsuRUG1WNtQXRZ4bWF1nY8fG7SAcrxb65GMY29P34iMP3X1Qh49TkSN3sHRyLGQj9y+IIrMMeNhL+vE9+M10knI5v19cj18nO+rnJwDipLaSYPcCsuCgnxFfPSNP177uoeBSWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by CH3PR15MB5842.namprd15.prod.outlook.com (2603:10b6:610:128::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.20; Fri, 15 Nov
 2024 18:35:03 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%3]) with mapi id 15.20.8158.017; Fri, 15 Nov 2024
 18:35:03 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: John Garry <john.g.garry@oracle.com>, Yu Kuai <yukuai1@huaweicloud.com>,
        Yu Kuai <yukuai3@huawei.com>
Subject: [GIT PULL] md-6.13 20241115
Thread-Topic: [GIT PULL] md-6.13 20241115
Thread-Index: AQHbN40V8TOFF8LAOEqRTr+pllQvRw==
Date: Fri, 15 Nov 2024 18:35:03 +0000
Message-ID: <E1943CC6-7FBF-4C7C-BCFC-914C7FFACFA4@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.200.121)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|CH3PR15MB5842:EE_
x-ms-office365-filtering-correlation-id: cf4a2638-564b-4a8e-0b33-08dd05a43862
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?ZMiXGSRw5KUNOy27Cox3peOV7tmotLTMcS9xRfjvzQLW0Jkg11VfC/opA5Sl?=
 =?us-ascii?Q?GtJplERyDjwQ1qycAaRFORbIwcdwv57im8kN6DOXw6HXWwyjIp8wdgs3LlfU?=
 =?us-ascii?Q?YAOizcC9zhH9sTZDA9K0VW049LqEby60EzW8OCuykBNI/w3fiBKweVOiDI/i?=
 =?us-ascii?Q?BtPli+c7KIOfZed5P8IoDs+xHPqG+JgnNqYqqNdkZSRTRq8NB4ovS3D3eT83?=
 =?us-ascii?Q?91l5HsIiX5wsOakV+pXEg8kVhyzPh8TYxlH4tlfEhS17qWUzTEjkmW2NGeOx?=
 =?us-ascii?Q?MvR8PEpQTKFoyTmoOpwIyPZ/HR2TFEK0ej5fvIX0oJidZZsQ1jm10P8HrLOd?=
 =?us-ascii?Q?zo/mwH2l535Jz2vil/G+7/uZNOOsePLgzQ5FtVCFT1DuqQwC14TJn04VP3aQ?=
 =?us-ascii?Q?76Cl1KvBRkH4U+AgdbW7yjru2h/JoC/gwrVFuIKzgu4g0cOCkj/DH9HwQRMS?=
 =?us-ascii?Q?hvzdTwn4IPtGRlF3OTTufAf2/OxhznpGlf2C9t5GycN8jpe6v0I2+sB8GQ32?=
 =?us-ascii?Q?hsL0vg5Hw/B0DElEMY0WYQkHHN5X86PEx7cx0JAdcWk5o8TUTPqDGqax0DQJ?=
 =?us-ascii?Q?YtWJ2xnQ6H1Ei90blpfu/+iH1NdovHqQoJzZ/7C+7QZ59zNPVNmhYjbKWYJ+?=
 =?us-ascii?Q?ESN2rC5M6uxPTSF9Co4ndRA7ASEtkKjTSk1RUJAokmJx1DPICA8xVRNQBmPH?=
 =?us-ascii?Q?qnglS5WooqWXLC+36441ceoUZGfMoOVpwZQMW9GyD8u/jUTTRmKd0gwh3GLB?=
 =?us-ascii?Q?TkdwnEhxLNVfzDauRKzPwaKM2iHd0WdntVY/l53UpndNyMQiGFkZheH47XHY?=
 =?us-ascii?Q?1XOUPrkqFFaShDiCZEmPzC68jYfIU0Xcx4pTGH+L2hj+a7TxTt7VMPwhIvqC?=
 =?us-ascii?Q?mH0yKv728JYMBsYheDF2BZRRDcheCAiDpxeuIZcdgFCtfcrVGx2rwWH1+dxR?=
 =?us-ascii?Q?7P+VvycL2B4AaVnlfcl/bo8rMbDGSaInUUwwCg15WwyNxv/R7WAXh5xQCOG4?=
 =?us-ascii?Q?VpCLM7nAfQ7ajCrUmMcRWXteEnYJvgouO18M2MASRsKUfbBTOxo8H3IhutMn?=
 =?us-ascii?Q?JMw8B3IDZ23PA6soqE8argtU0443YQ9jwezIK70ijBObiPXzPvnKiXdf+mGH?=
 =?us-ascii?Q?yyR6xzV5fc5ooi0cBKMBGI5ABX3f+g4+Epr8+SqqSOemCJ61MpM0X5KB2KHG?=
 =?us-ascii?Q?QXGsg4ghLlsEQHwC/MHnA64yuv3ScG3+NZlPkFPCnyDjUTflyjZTuAimUdvd?=
 =?us-ascii?Q?U8m5LUnE7re5SW4Fd+LLJLksyo0Vi+pe4o2kz8cNmuNkbRJv3kes1sWq+mly?=
 =?us-ascii?Q?DwgbbbrEp1ZQ8sezeDif5GEgqljuK+Q99b5yj2EXNqr/oayAZndV4gwlCMAq?=
 =?us-ascii?Q?LGsOc7hiGeg50YFprJ9wBJz2WRLK?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?itYMs5msCiB7b7Mb2rkUevcjF37EApkV9O1fSQSPt+bDuaMOy2E+jaoPdGmi?=
 =?us-ascii?Q?lzC7mYA6p691JGw3XqgQnaXASEmeytaxkb2zNkrzHuBNpSH+HHtguhOwhwV9?=
 =?us-ascii?Q?mo1hIm79tlUeS4eKakJsZMVbP4bIZMtGCxaKcTn4dxaGU2TgPnXOC9kqyVVD?=
 =?us-ascii?Q?WpKy7BdKe9w5nEtCUjwH4fdVhvmIycz+3QTR8FgIblLE2CSWcCF3switmFWF?=
 =?us-ascii?Q?yMFKtDyV3qxFMFbFxiDordkxKE7DU17VVaoW7z96UVTrQO7YvC/jgeoPiVIj?=
 =?us-ascii?Q?tiCj2Au6RGBec5bmuCXNQBwVbz9/A+f0yyTAkWhROHbTikaUAqtel4QxhNGO?=
 =?us-ascii?Q?1CAz5e6+0xUpovPnhYg73YGyuJ+RtLeFuIYPE15K1QIjmrwFikzaenQ1tzp6?=
 =?us-ascii?Q?hl6EGYwT6diVI+kDXfDt+RoxKOo9yAYefvE/pVzZqhYWMXeE3EjdXQyeLha5?=
 =?us-ascii?Q?NQChJA/jWrnSkNT02hAUqtphyvb1azpbuoy85Hv+7uHOmWyTnGRcqfousUer?=
 =?us-ascii?Q?bwbLGIYDn1h/J1DfhRuHHP0XXcTznrML8AY52eRC1S2C7QqOF3X1Me+ZSX1m?=
 =?us-ascii?Q?T8xEUR/OFSbdSx23o6oM+wsTfnClo8TsqFRkprhu8LFinnJ9EAhEnpIla9Ij?=
 =?us-ascii?Q?bxjSe1qj6DiauzxZ5Coz92jK1MAkKPTj1brFj3KLXX1zhmh9Atu4O/sel0+1?=
 =?us-ascii?Q?PY6reEw4VpUtW+hyh3rMmE2DMpBtmFUTmJQ9meb1CTo6xjQhT1xvHckwZEzR?=
 =?us-ascii?Q?Ely0LvdL7LWkFRUifgLUjZ+ykHCqps0EfGW97TNYOtvvWW3NMmN390f8UXjz?=
 =?us-ascii?Q?fY0xFhrrFV+Ye44LVJo0BEdTjtQjYGuXDmoHfIQJf5tWfGXSls4f8dje2833?=
 =?us-ascii?Q?aRb5iI/B9LOWeVZ+elkIbnBFZDMDJCj000xQxARftVas+RI0Y1KrS+x6iHm8?=
 =?us-ascii?Q?+B98gVzNxEJLZtY2N9v7VeNz93+gqe5hTggIrFFncjOvt1uCtpTjp70uWlHH?=
 =?us-ascii?Q?Co9AWpkzvdNpChMguIHZND4mA0VawSMnrgTaMddNZvlpqtEAHfNoB2kgZ25r?=
 =?us-ascii?Q?x7MaAkew+bwlc/c3iHeatIkCdcS/N2tmJqmyIWLos9KuQ9/LBlTVNLnRELvB?=
 =?us-ascii?Q?GsVuB39JAbzxQ48wluNfaq9evjvR6G05TNEnq5deuftln2aklln92EpIW31e?=
 =?us-ascii?Q?OJu8Mj60I7JW9baLts1N5jVrsic72goXvyTfMCf6KsdkN28MhmvvJ8lsXhmA?=
 =?us-ascii?Q?Uj6qOBB6qeLBEfwceKWWwBZcZxzArSxPhoDa0JJN8DoYVTG8+b5QxySKWBfE?=
 =?us-ascii?Q?wGI5UC3tO7t7L0KlhfGIFV3qEUcM3Noafqj7E+WrzP8ajJ08XjkUiMxQ2fbr?=
 =?us-ascii?Q?UOwYm2lgTfea16La4LLIErkbUissRlZ2C8OSd6YWoUBk7TrFV/fNPvnWp3dL?=
 =?us-ascii?Q?BSYHSSXgnJL8DFQieirPKkQYVWXWTrbkV5VKvlyWg1N1HdA1nBpGZ2ZrOI8b?=
 =?us-ascii?Q?WxwsOfYitRJW9rUk8jZmY6L54OhuAg6uThh+mtf2tJg6pc6PMw6Mhf3l5mP5?=
 =?us-ascii?Q?bGBrZKg5S6NPBFyNPumplH63ZVildPlO3GSM73xHCuTkwrhwffvqPcXccGn4?=
 =?us-ascii?Q?3piz6XfuzPNB0Y67GiebW9Q=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C57AB52460C07B4285D0DEBCBE1A0721@namprd15.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf4a2638-564b-4a8e-0b33-08dd05a43862
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2024 18:35:03.4743
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: up/TGV4fq/jCnTervHzeK5xzixc8l1b8mDc1UBG5ve98QNgo1CYQzKERgDiTzOEP0DhJYtP81cKxZwqAmStdaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR15MB5842
X-Proofpoint-GUID: 7RR94wC6N3LCs62oNRSzT_SHom8zOLO0
X-Proofpoint-ORIG-GUID: 7RR94wC6N3LCs62oNRSzT_SHom8zOLO0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

Hi Jens, 

Please consider pulling the following changes for md-6.13 on top of your
for-6.13/block tree. This set contains a fix for a W=1 warning, by John 
Garry, and a MAINTAINERS update (and yes, this is from our new git repo). 

Thanks,
Song



The following changes since commit 0b4ace9da58df62c1763635ab10ae1bc8ed8182a:

  nvme-multipath: don't bother clearing max_hw_zone_append_sectors (2024-11-11 09:20:36 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git tags/md-6.13-20241115

for you to fetch changes up to 886e4757f42e5775b7c2a6e0e5e2dc9a78177b0a:

  MAINTAINERS: Update git tree for mdraid subsystem (2024-11-15 10:25:53 -0800)

----------------------------------------------------------------
John Garry (1):
      md/raid5: Increase r5conf.cache_name size

Song Liu (1):
      MAINTAINERS: Update git tree for mdraid subsystem

 MAINTAINERS        | 2 +-
 drivers/md/raid5.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


