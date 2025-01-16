Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1431A22E40F
	for <linux-raid@vger.kernel.org>; Thu, 16 Jan 2025 18:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737052739; cv=fail; b=sFgudcLQMjY5PKHGqW838BRRP39AnCX1dU3sm5D2ZfqjrDj3ghjH3LagmX+u81jWUUfk9eqVPXafnZ+IXXBtcF+opKiif6/4U8H8mbyFnEjoK06iIpiTFefFVnrhpXK9saLTqZxgURzW109YjJiIWlSr6Xnvt8aLOxI8pDzpMBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737052739; c=relaxed/simple;
	bh=0cQWv7MyRELx2o6TYqIAvOWHVOIVuUYpWFWttbGBipU=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=BvydNqrM7uHjB3tZSwHfate/Oxg3vZ4dsL/fZsmSLnI2KqkCwRFvqzxEfVrRKyIfE/QWv9dx2JiBmoJNCUhQXTtcnFlIc9DqCesuHdwolC/udI1YwykBupmWd8eWaSoa4aaAzkkn+ajKYARpQmBXZrnwALIrv1FAoEXSaftQBg4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=kVHT2LLl; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="kVHT2LLl"
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50GHIZ42014218
	for <linux-raid@vger.kernel.org>; Thu, 16 Jan 2025 10:38:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-type:date:from:message-id:mime-version
	:subject:to; s=s2048-2021-q4; bh=hpcG1x6Sury+jpHi7+8mM+Y5fs0EuqY
	FSqyFlSoLcWA=; b=kVHT2LLlqZ0id5gHmVSzr46eYoBJZSvDIklcciBUonaugjb
	obIh0dpguOWsBRGhjTXqkh9Fo6HK5x98BVGPvUxhFjizAvDv2xxJ5tQNxePPL7rx
	LgHXFRQvQIaFOo35N6okBr2K6/hDqSmZ34u3/SfscHl5yj9443iyCmWjHXVt8BA4
	ivN4QdVo/WpZ3jGbDyt6pDa3SmYH5tQ3DGlnPL2SxZMwTeDW+6bk/3tcagRd1qBb
	1G269NiB+TnqdHWnQfrYnVZ+ieMdFd0D45eJ7LO/PhZwuItTmWU4xk40myIDG4ow
	J2Q8g+mSyFpLT76trGzMiV+6GduYesJZ00tbQEw==
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4476cwgmx8-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Thu, 16 Jan 2025 10:38:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j82XHFkjBizjBO1n3GNYVYXj+XpekZr9NMm7jGsxAk9enYE8209QYS8Yk+Htuw7d0gTb4ZJ+drIyK6QN2PBzN4NjrUvEs49PObQx+vuxZrI3CQkdQeJs3jAAX4ZnVkhkjTDnU7A04IdRg04V1KqbFMIuTAXJW9GCtoDyJCq4kUe+ZolhvwRxJ8x41t4Nepz6eZK65g0HUGUXz/zOL0dIaC2NQ2D8XBuKzrEc4vzq6ZAioA9vKmjYpG5qU7VrJ+RgLndiTN27VHydfW6n0Qb1e1muQ+xfTIn9O6EvpPU6kwFmJwfe6OIrRyQclRi4tySQ2kbuho9JM9rfPAsB6Y33NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hpcG1x6Sury+jpHi7+8mM+Y5fs0EuqYFSqyFlSoLcWA=;
 b=GQL/pASbPGDGFJ+ib9RdelL5HsJFryp1k7VfJ46SuorfXfCiBzrNwv+kbQlF9eaS2rCLa7Xfmm4kOiLIdSULlDlskizMvodqOQTncYCVfMHor6vtUtsNk6OPektSxS53czdfORyGmZN9I/NkFbx0Ly2XanRhl7duQxdg7w2hiyCNpnWuR/BNnmHvzlqzgYSHeiqPc0rXwIqcvREERBGwjxNcUtEAq0lNVKTPHNlyti30++Z9yugFRDORTXVmX+7La/r1Wj4sMOsjnSNU999v9TJRWtd2sAWRb1AuDNRlW8H+7pKRPfgl2s/K0410YsjQhgY/+22evOGQsfCei4EHaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by PH7PR15MB5808.namprd15.prod.outlook.com (2603:10b6:510:2b9::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Thu, 16 Jan
 2025 18:38:52 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%7]) with mapi id 15.20.8356.010; Thu, 16 Jan 2025
 18:38:52 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: Dan Carpenter <dan.carpenter@linaro.org>,
        Yu Kuai
	<yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
        Song Liu
	<song@kernel.org>
Subject: [GIT PULL] md-6.14 20250116
Thread-Topic: [GIT PULL] md-6.14 20250116
Thread-Index: AQHbaEXksm+2J5sax0uSGm6qTW11ZQ==
Date: Thu, 16 Jan 2025 18:38:52 +0000
Message-ID: <5A8F7169-012D-4D1F-A2AD-1C95393EC900@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.200.121)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|PH7PR15MB5808:EE_
x-ms-office365-filtering-correlation-id: 8ce92d7c-742a-4702-0750-08dd365d069b
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?lc/BBhAJnVsg7GqY03f1o9CLYu5Tlx/vFOfFWTfFCQ65Xr2G4QGJPBkbHdCI?=
 =?us-ascii?Q?W2ks8bRFHrQRcLsV5aJDrkiIFwV/L8rGhmILDUwJBB49SJXmIW4UnZA765aC?=
 =?us-ascii?Q?EDfujM3kGu6VMm+WgtuVU8+oNSygbPxLSUIblyM98ZYKuX7FRYz84nmmJIy/?=
 =?us-ascii?Q?ahkD7jITZ6HNWwEyyg+R5UoMTua60VzYbLQpV+Bw42tnBKJazXEByWYNXJAa?=
 =?us-ascii?Q?HmXe6ZITwkBVcIOdsutp8jxDvLkSySI5oyfV3+UYew4+HQQeOR07jZgNT9mO?=
 =?us-ascii?Q?19rWDnXULK+EACHIitun4lGwl/fSqpOX+bcDmOdbMPK8W6JmS5Yqe8lYfDNJ?=
 =?us-ascii?Q?zPb3q2jYYEVxEr9qCxEu1gMvuzl+hK4S8gy3MSkhBymoUP4l0VBmFiomO76w?=
 =?us-ascii?Q?+5cBavDzyUgBYblqzDdAhngwCRkvEVFIttQIELBCkQg+2pEtgTlCOjVgwGV8?=
 =?us-ascii?Q?HQzu15nrszrHq0hcyRGzJ0YZTnrC2pdT65himX1I7wdxXuyxMH+bqlxyTvwp?=
 =?us-ascii?Q?ExMKvX/pjquDMpZJnP1nAVz7v8JdSyBi585wz5IuYwbq2vkpyvElfPzmHs+S?=
 =?us-ascii?Q?7WtvfYNQsTcS1uWS2k68yPLugXEt+TgTQivbTJEUP2SQZeQ/hZNSZu6tCHi7?=
 =?us-ascii?Q?mbhXKaX+9s7aq/MYZLZcP7VVc1OR0oJx7b8tx9AVy2sP+RjXUbiiOlnKh9xF?=
 =?us-ascii?Q?0QUh6E3vAhBlc+r1W5tPvesE3AOanLP64L/H4B/RlekwDOMn7yky4BYf66M6?=
 =?us-ascii?Q?NEOMkNaQuMak3iPoOeilFSGeaY1TgXjEdMW3uPA4Btq1A6FKprvSs3a8pCQN?=
 =?us-ascii?Q?AGxxWOe2cp3EdHeQ7pbRCT+rbXY5F1nOzCQMQtXu6LnF6SFoYphad+CuHIfK?=
 =?us-ascii?Q?uAZ9npAcFjbU+Irba6M+DVIM+Mpa0M7YHjtCqDvlOTtk/VJk02RBimpMImMZ?=
 =?us-ascii?Q?nzLsyreIPJ8R2UDZoh+ioaw4ys8cDAg6qhVzx0ruOpSl6TFu11DnSZShbRZ3?=
 =?us-ascii?Q?q9ogLcYqKjFZNmA/uoi+Hi2LFfq2tF2BD2ex0ES+OrNrwXUNRir44VO0KYct?=
 =?us-ascii?Q?/h1vl4gxYC1Os0wt571sD5R2HqpzVX6cmYAH3C0TqWTYn1jdmdz8AEDuwBhA?=
 =?us-ascii?Q?NY1qjjQZDnSbZvIjix3cWfCJGRcN7+8PjQFsonJ0/BytzN3dLoeT09lqoXTS?=
 =?us-ascii?Q?er1iXoOe5D5mlRitSiraZcjSgstr8cBypiEZmmW+6n+njoz/j3FualbyzgBm?=
 =?us-ascii?Q?dx3gb/yS+Udy8tWGsH1QmEt5Odt33Vqw5n5ViqBHswWM19Zz3irKaX/i6QFi?=
 =?us-ascii?Q?iEvak2/eYCJFWw+Z5UMSXruZdmSkpcph3MLKS0nkRrc+pqFdRqZKZFhjDbgJ?=
 =?us-ascii?Q?vOnoRyuNwTiAxFyu8+ECZeMQ2a7B8Y89nlwOn0xxuDdl/eJ1K0YlRWNuFko8?=
 =?us-ascii?Q?eCL0cblaVxWTMhHK1oYGw2b2tXcMUMPZ?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?CcG63zFuARTOntep95uBoCIuz/JlQKWr3np1Mgs7FpirwueKgKFgJQF7Aj64?=
 =?us-ascii?Q?oRxi+wY89Mu8L7hEUz8ptMESzZAU/o//xL5rwZxDJhnrVDvM/FncokIUNETR?=
 =?us-ascii?Q?2yEVUxssNTB77R5qidXGMxhE8OuqWTfHe6UFyPtwFP82s6ZAP8wvwX5Rxi4x?=
 =?us-ascii?Q?11h/snypKPCF2u1iB9UaZtvmbsgx09zojJLoGtQLzddWg90nau0q3xH7XLku?=
 =?us-ascii?Q?U/4mRELXpPkyX37oxlADas254qRpz1ucq6KnPLpWPHHVuVyCP0+tWnuHvhOZ?=
 =?us-ascii?Q?13riXXOhqZqrlfBllu6fciGNBteJg35x1A5zYbtfkNmFjLygugxp1un5MGFo?=
 =?us-ascii?Q?tWtyJtpfhARznpiEYzdnWPdGXbOiGp0YVNo/NuZo+U9n0BFQR9+xbBcrsM9x?=
 =?us-ascii?Q?tC2Mc61unS8s3IKtrZLPq8SrSKEtM8iIZfGyMQDxZvjjLBtJ1sMtfShA+5xR?=
 =?us-ascii?Q?OHFp03I2Un5N5zgoJ+1HbpQmOm39yj02vnhFy2gklaeH4l3Xig2vUPR5w76u?=
 =?us-ascii?Q?ttYePHukefCJJ7ZEPCE7LZPzfEEqdb/he+lLrGMJOV/f/gq9NRL1VY7xRp6+?=
 =?us-ascii?Q?jwoKEdDUWTCS9VpJC+6977alyQhgkFuQVUncdvkn9oFsP7XD9JMfUcXPMcij?=
 =?us-ascii?Q?v+GK9+jKVxEWmsPLIiTIKZgdUcOsFMDIBsqfrHeLmva0iO5p/OvFeaUWAsOa?=
 =?us-ascii?Q?PH5gwg9S2NuDfUJ6tdkyoIhGBBeMVDL75STA8xe0IEb/+UUkCGFM4Pe/ZtlL?=
 =?us-ascii?Q?8axhstYzMJOuxohBkY0ol3+1BUh0RB2Qv1zf0Hc3PHhVI2FiqclAeQcAUWzY?=
 =?us-ascii?Q?I3nj6Z4PHx2GBUaJQ52HdMKBrWk+7FrAAyyriv/PY3erNwRvjgRTG8WYW2CE?=
 =?us-ascii?Q?+Ac76KQgiLL6IAbD47TyulA+7ZH5wy5DhyTQKIK+NUMGeAPgWT0BCouBnKjL?=
 =?us-ascii?Q?52pu6R/rEjHcNCPIq9sMN5R5+8sWzINSSOHuqUG/fNDJja7fGbj+tmMDUNNc?=
 =?us-ascii?Q?f9ZRNNe1SsXZbVmDGXBnFZyHyZRAscC7IrOZx33kVH60XEs+gptIlS8AaedP?=
 =?us-ascii?Q?tHpnYjAoDifsrqQHExMGD0d3ag2FiZMRKCRUoetT+QXXEC4jugI4Ouf7aT99?=
 =?us-ascii?Q?PvQSg4eRR9Xov3CO6Co6i4lMp+0GlxkQEkLkBPQzN9PVWciXrhcDGo8nV3v0?=
 =?us-ascii?Q?p1R3PmNVvjCjKfWkcpTGtirOWLgBwMKaU9OTa3Mf4zcTcMys7jrpy5eNxRq+?=
 =?us-ascii?Q?sLn7Zlv1QmUiQnLmcKD0JGRLaz5hyzRIEQNgLCdPW/hSc55ZUp9cbzzLYqvE?=
 =?us-ascii?Q?76FisB2r6h4rjdnV4RcCXLjiDkmRm0Vp/1Gs0GQy9BCEEbP9XO1aQ6YfnNij?=
 =?us-ascii?Q?DNcNGshWBkXIBEAYbI5joQImsgeepFVzZYsJ0SE4uec4EIX7mJoTcTQ5HKfJ?=
 =?us-ascii?Q?iLQfNf8WrQbLOUuHEvOj4Tk00eVEJBFB/5sZP/2BYX0BwIeQ28vD75QExs2I?=
 =?us-ascii?Q?F19OQRs0R/UPbb6U3wzlORGKKPDB9zQJFLusyfEX9ntqFa8qZLzQAXMj+e/6?=
 =?us-ascii?Q?tvj+3T4/KJhhGOWtYcm8TA3Pno5W3Sv4RTCqlji41lm6No8GKzoYfns7aj0l?=
 =?us-ascii?Q?Wu2UOjYlPA2xTRMtXSbUMYY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4F33995843A149449B466C806875E335@namprd15.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ce92d7c-742a-4702-0750-08dd365d069b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2025 18:38:52.6749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QsVYyguKgBUTmCSN4k5TUQCUIcb7mFOCu3CckZKTkoAXQ/wWgO4lOz9WskjOzA99w3hF39celOLsuIGcWyjKOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR15MB5808
X-Proofpoint-GUID: JU73oJcp_l8G7LYavSFySQCepq23HZrr
X-Proofpoint-ORIG-GUID: JU73oJcp_l8G7LYavSFySQCepq23HZrr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_08,2025-01-16_01,2024-11-22_01

Hi Jens, 

Please consider pulling the following fix for md-6.14 on top of your
for-6.14/block branch. This patch, by Dan Carpenter, fixes an error
handling in md-linear. 

Thanks,
Song



The following changes since commit 3d9a9e9a77c5ebecda43b514f2b9659644b904d0:

  block: limit disk max sectors to (LLONG_MAX >> 9) (2025-01-15 15:46:56 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git tags/md-6.14-20250116

for you to fetch changes up to 62c552070a980363d55a6082b432ebd1cade7a6e:

  md/md-linear: Fix a NULL vs IS_ERR() bug in linear_add() (2025-01-16 09:31:25 -0800)

----------------------------------------------------------------
Dan Carpenter (1):
      md/md-linear: Fix a NULL vs IS_ERR() bug in linear_add()

 drivers/md/md-linear.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
