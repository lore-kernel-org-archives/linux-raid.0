Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC99214831D
	for <linux-raid@vger.kernel.org>; Fri, 16 Feb 2024 20:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708115900; cv=fail; b=Fl9i09792Tm/dqurUe6E78zawM73vU1uRhX7TTG8yREj2YW/qiOAHoQXNfKu4BP1FO38grqc/bg37DBGahwiTGELuftRK0Tvi3zEX9YDRBpCELL7ocZClNFO6tkoH1hsDBQ+j3SgvMM6YLIMsHlgtXhkHp/cQhZiR8Gaw/obWGI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708115900; c=relaxed/simple;
	bh=6Hgqyv/ZfvWDKob9EwIRudo3+4bv4g63raBTTNBKJEU=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=TPLQ+epENqhDFff18siY+Tx+o7oOAUg1AzptZ0xYVCe3R7qdxBE83XyRKVQffGOXrDufYkM0TuIrKGaBAjKp37sB1ChPVQ8kSyT7KkPvafZ+/Ewe7zaIVwk2Gw1B2DksC7AmuNaXVuQQCdJZqrglkMmZXcsU6EM4PUFZfTBaOCo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Sa1Cddwp; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Sa1Cddwp"
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41GKbJgI030622
	for <linux-raid@vger.kernel.org>; Fri, 16 Feb 2024 12:38:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=wvVi+N5t3NrsfOBPCihYawaAuRlssbBqLsuC+kyyjPc=;
 b=Sa1Cddwp1Q+AnkXk6vMoSH3frW2adrb2bIwpBec3ztU3MMZwEuPWuwaVGsrEJuFuFjep
 S/0OCx01N3qewBize0+EOkP0cA4tRfV5SQ+upt0z+fZfxHJ6mhgivJkp7tYZoEvDtwax
 nbAauXpWsVRjI+Xx06USZcVlkVdpKuSTFXxV2YIVGZiTMMfrWeHW3N/kVjRISUl5aSSI
 j5gUPx7Q8jzIey23sbPKfc11m3F10mTYAWdiiVAB+BWTCFVMnZApM+Y9qt2G91Xvu01S
 bfqzNeMOIpjjnhma6itKB1eSSQcZZ7c31H1OIx2+cZ99OEEkL2D1al8OfRYxJZcLuud+ 0Q== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3w9a4dmb57-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Fri, 16 Feb 2024 12:38:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZnwcfGSO5tXdGu/kEsgKFA1BP84ACJgDy3+6fg9PfNnTOs15/DobjNn0C+xGVKVwv9mRQQeqos6uPob/XFQNMAhbi5MtMjYdl11g/LUVXid2JdDp1j6plkJiiSXHpr2hjg01p8ZamRi+y0/PfqchvrVHlYxDU/HYiF5Kg9g98LiulzcT42F3KsSm9L8OXC5RNtW2Ps8j4DKnwn0yLb8Z6bSPg449gJkCRsnlQc7WWLKTsVjd29IX26R1EJ+idNIJm9H575hlEARo9WXAmrB7HUsH9qPAfGrLZ5dy//vxIvgVxHtBwA+IB8TiI+Qu0ykcr2hfW1Vn4tAH90c4c7Y47Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wvVi+N5t3NrsfOBPCihYawaAuRlssbBqLsuC+kyyjPc=;
 b=b67FjUoHbLYz6FIVSUnGbsnAygwCKI2CFDf5Jha8ftN7cxBINZXEYvE91WozJZWcMr5hrKMszTCYQKJrud0GmLMLF1pRw/y+4wwX30Mc34zSmfk3EfpQh6eQPabPTIC8OlIgnXWPa7rs4dHl+Bk51nbRzy+EfRampNnBJMVB/sdJWzxwA2hjdA+Hu2Q7eR1kG6yGClnYuCA7S3/aq87FMpKNFPLXk3vrPvXoFSKm66usCW1H0dDZy/iJ26JT1exq3DWfj0uS/7Qoh5pWiRwGRWCrXsfy9YKTvCuJ0BkPisxYiKcPyBV1kflWq49PB3qTQHnG2cllwPZFQ7XO6wIikw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by CH0PR15MB6234.namprd15.prod.outlook.com (2603:10b6:610:18e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.35; Fri, 16 Feb
 2024 20:38:13 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::d467:8e49:f5a8:c0e5]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::d467:8e49:f5a8:c0e5%7]) with mapi id 15.20.7292.029; Fri, 16 Feb 2024
 20:38:13 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
        Li Nan
	<linan122@huawei.com>, Marc Zyngier <maz@kernel.org>,
        Li Lingfeng
	<lilingfeng3@huawei.com>
Subject: [GIT PULL] md-6.9 20240216
Thread-Topic: [GIT PULL] md-6.9 20240216
Thread-Index: AQHaYRgP1YIksPTGRkOQNP2XZeWXqg==
Date: Fri, 16 Feb 2024 20:38:13 +0000
Message-ID: <BC4AC7C1-4B8F-457B-BA66-3D07082650AA@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.300.61.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|CH0PR15MB6234:EE_
x-ms-office365-filtering-correlation-id: 71d28385-3755-48e2-4558-08dc2f2f3237
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 W5/ZTV7Y7SYSmeug5oWZdnlWRQf+igKu5zEJIp6fTouibBVxxixcfZlxzuOMiA0CiGyqqOZ7D4siGhL8wLShzzbfhI1xITRoECZBR7K9OwsPNfqwzM0+Z6c2cb5wfFI7/UWJVs1XSCwAiZFqSQZZ76q05zES5Cf6ng8W5PaMfE5U+XXaeU7re113r0gFyqkDjoxawNe+DlfUt2g9AZBWpgATCI9USaCesD4N/0k4n8t0CxVOzENhCmX/Z+47wRxhKfFbU2jGOFe4Z39C+LKcehFrUzeLvEEOyfDY3QDt/7MyQELNT8gBbn0nhYgVPxUwRHjeEmOurcokqqqoLUgJSAxdw6k8vIC18CgiHN4DyePb4aGkzCKVabl6l4t8X5MSiMb0m037d8v/7hlClDxuFP7MeYX4gTZa5rqAP1AIESunjCNKtPK8HPQ9Fb7fyVpJbWNecl637oClJGS7vjAbEZELV2EIUHWmMQsRxKW4SeLb50OQqMoluzv3qfEifPgC2a6PVfFSt86CuVqKCehNz6z8J9xIdfC8JIAnRSfztYLNGEj3Zd6ozok+XWkRZzn7zlyW2ckZSPrvppgvoGc9it4jCaRalB8tjKcihkIZjQg=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(136003)(346002)(376002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(8936002)(5660300002)(2906002)(86362001)(8676002)(4326008)(76116006)(38070700009)(38100700002)(36756003)(83380400001)(122000001)(66946007)(6506007)(66446008)(66556008)(66476007)(64756008)(316002)(33656002)(54906003)(110136005)(71200400001)(478600001)(6486002)(6512007)(9686003)(966005)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?CVGY/DnJOmz+Ir9EI1WyfJfK8NYktGzgr3rFvid9cnFYa/xYIL/LDGVtblDp?=
 =?us-ascii?Q?OGoobza5P8yhM8mudECx8XFHoypJXDs4wwth3akbANWogQ4PUE9G4O2f4Wi3?=
 =?us-ascii?Q?AR2OgMOvg4CC5KyLQzU3KccwDox9OHcPeWl8vXp6tcd44sPQ26MfaXdMMaFx?=
 =?us-ascii?Q?sRVbhtHNR++YbmU40svYnD18hjkvkqyvEwbMsGKPHNJNmhOcv/oWMinkWdOi?=
 =?us-ascii?Q?y/L4O+jIKfUxVT2Prmq+0hrVHYM2WZY2rxY2p45lVDQnvgzCw+2Z17hfwuAr?=
 =?us-ascii?Q?6efVB2oDTqrfn7116HRpRwJBgQqs9rkmkecLbkEZwS7CFaJzpE1CRht58vlu?=
 =?us-ascii?Q?KxCGGTQ9Hoq+aFHTsjJsXpXd4Lw5zZEYD85tCvLs3csN6NkxRQw7oRM8mNDF?=
 =?us-ascii?Q?UeCgS+JvqAtNspSN3R1qN1z9ztYwS66Hg536SJdfldp4BVju6GTUvbbAh02j?=
 =?us-ascii?Q?DxtlJ8dPqTjF9yYb6EcbVGDyorGLiCm3tfM6Dd0lOaQ1tSEkiJP0fS8peRxJ?=
 =?us-ascii?Q?QGp5bg7iCVBPaWtMdRCPa9UAE3TDwEbVCxuBLejwS0TsaUjxBXIL8gcnDJC4?=
 =?us-ascii?Q?UEcNSpBd4qu4VPi32FX0Z8IiNyNzMnBwaUGfMNU/8Sqemz9QUKCTBzV3CD34?=
 =?us-ascii?Q?V1A+SeWp/u6UX5Tt3EvGxl+K6eQ+l5xY93deB/HGZ/QnUbOHfA2kQLRudPlg?=
 =?us-ascii?Q?ERnyFz7G4MYpvOfph5ndMzABoyLoZsSkZ+hftgtDt8kJ0XHT1lm7/QjCoei0?=
 =?us-ascii?Q?SsIFbChvd9jAaKIKWZDzNVeAk4+dDT+TSTUAxBEkIfygXOifQVUv1ClEf5cD?=
 =?us-ascii?Q?587kt9DavkJ5+bfB4iRRk1V7AANubDl+1Qzu9/gI42YydEe3W8gsAzRVoDou?=
 =?us-ascii?Q?NbehwV8D3nfIGysGTrtja1tz4Vax5NjoYAe1KuJRHma7ke/uuyGhyKhttJ6k?=
 =?us-ascii?Q?P8w6I1fI7Rv7me1x88w5ZSq/QvUYapCHRZbabOVeYHibWp7FUfvRVzliQJa7?=
 =?us-ascii?Q?LMF7f3V2XZ2SvgN1qIXy/hnYGhPJN2pawAcwUI21SQq+H5qefKgSFApRewTa?=
 =?us-ascii?Q?xjF1G6JK0o3G2GBFhOV2H+yCrSvi1VpBv/Q567BC6S9OVOYkdRqiKN8sPGIg?=
 =?us-ascii?Q?X7cq+VMMVj9pbU65TNB3ye/Jl4C5MwHntYGvAZfJWI6HnHexuRnJYJwX9/n8?=
 =?us-ascii?Q?g9o2X+d6PzCwC3p4J+Al6yE2vznBsomh8KmXIsAK1h0rDuX9VJsZ/JaLGnVF?=
 =?us-ascii?Q?92FhczufHUy2581sY4nnzYQXLETltvsg8E9boPnhm5RLeHwOlWE/lx/TkI7R?=
 =?us-ascii?Q?tnOaSSN0+h8YiBhZZem7I/A6AiQdrzHsXB+pokFDWvAdqLLsKgJeZAc+tx22?=
 =?us-ascii?Q?rMyRV7dfSBqrNMBtKEoVGze7q7fs/rtaPIRR+fCw2GSek/nw9e28s82/UnGG?=
 =?us-ascii?Q?JOiCaGGuF070S+XVqNgoCuT5HE/RG7/ulr1u9rzsRfSPHH3jXjySMzNjOsAa?=
 =?us-ascii?Q?e9YjMCPd64HqH6iTILx0SMDDU8dFB7WbtVItwIPm3FjMpdb/s2n37bYmRb0F?=
 =?us-ascii?Q?+LYgVWM1AjtYhc0UDK41t00vtClZA0cwdOR9qyFDmhUbUSPzmVM1iJsGJsDE?=
 =?us-ascii?Q?5i58n8ZUAG3++BpTPSAEbaw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <308DF376853EBC448F8B60234069229F@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71d28385-3755-48e2-4558-08dc2f2f3237
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2024 20:38:13.2093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZYfb1z4fewEsCi7YovOwfo65X79stbZR/W8ZB5QmkJbgEroiuUKenkyUnZw0+CiISTlD4eBfAok8rUWcW2ZzGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR15MB6234
X-Proofpoint-GUID: vfqwfb2F2LQkbFIJwnrL4ycBvZin96R0
X-Proofpoint-ORIG-GUID: vfqwfb2F2LQkbFIJwnrL4ycBvZin96R0
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-16_20,2024-02-16_01,2023-05-22_02

Hi Jens, 

Please consider pulling the following changes for md-6.9 on top of your
for-6.9/block branch. The major changes are: 

1. Cleanup redundant checks, by Yu Kuai.
2. Remove deprecated headers, by Marc Zyngier and Song Liu.
3. Concurrency fixes, by Li Lingfeng.
4. Memory leak fix, by Li Nan. 

Thanks,
Song


The following changes since commit 3bca7640b4c50621b94365a1746f4b86116fec56:

  blk-throttle: Eliminate redundant checks for data direction (2024-02-05 10:16:12 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-6.9-20240216

for you to fetch changes up to 6cf350658736681b9d6b0b6e58c5c76b235bb4c4:

  md: fix kmemleak of rdev->serial (2024-02-12 09:20:08 -0800)

----------------------------------------------------------------
Li Lingfeng (2):
      md: get rdev->mddev with READ_ONCE()
      md: use RCU lock to protect traversal in md_spares_need_change()

Li Nan (1):
      md: fix kmemleak of rdev->serial

Marc Zyngier (1):
      md/linear: Get rid of md-linear.h

Song Liu (1):
      md/multipath: Remove md-multipath.h

Yu Kuai (2):
      md: remove redundant check of 'mddev->sync_thread'
      md: remove redundant md_wakeup_thread()

 drivers/md/md-linear.h    | 17 -----------------
 drivers/md/md-multipath.h | 32 --------------------------------
 drivers/md/md.c           | 48 ++++++++++++++++--------------------------------
 drivers/md/raid5.c        |  6 ++----
 4 files changed, 18 insertions(+), 85 deletions(-)
 delete mode 100644 drivers/md/md-linear.h
 delete mode 100644 drivers/md/md-multipath.h
