Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4173218F2FF
	for <linux-raid@vger.kernel.org>; Thu,  5 Sep 2024 19:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725565124; cv=fail; b=sLJ+dx9XQ+kDvKQdF1bXn50hoUr8ZBPAJYbMM0+BX18pDXW/476BAAaUng2+JMtAjfv+Hl/ajczJnnlhR6UXznvl2/JTTlpks1GqxzQO/zZnw8pplagesYELEdSVfc+1SR1HPlxDMKlcX2w2ZS9YYvsg/NpVSTZSpTjWt5SNCgc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725565124; c=relaxed/simple;
	bh=jVoUXGFSPhDohzYsUmwDZ29d1iFIQsQ+/BQYjwz/FCY=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Kc6AbDiwxj25nRY0qUxbZpTpXhITk8X/VK32iKeeB32QIuwapX0RuYHwmbdmZZrvqRZOEqxdkwjXSwC1fnSEKlplk5anMdmM+N5ZV5lXeGd1ZmayJRwjIPiKej0yU0yE9M/M2t9A5cQIcjxiaF0PkddFaz7JvzW9cSjlTnraE1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=YDsH1Ml7; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="YDsH1Ml7"
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 485ISkqF025472
	for <linux-raid@vger.kernel.org>; Thu, 5 Sep 2024 12:38:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:content-type:content-id
	:mime-version; s=s2048-2021-q4; bh=8n9d5ZqcJ3oESf/0b++kNSRTDtVDH
	qSO161pYGc297A=; b=YDsH1Ml72LKqCM9zb2VlwV6i/gBj+jRqeEOdiOF/T7Xwl
	fA22WEjmakzWrX+4RZUqtXSdcSllkr33k9BQ9KzsD/1MjG8nUp60Xt9MRCE+5NeS
	BCvZ/NsZr3DmUr+kC55m2xyfMxlOeDsWArWtYhbQuarb9Q5vG8BScNlPF+4GIAiA
	xg2SuHQprKBLGETj13VSlWBKm0xDKXF3Tt0AcW1IiSf5alh7MBYMDDVaNBtCamXR
	b59RXPXDlPgSZfE9QQ2/Ene2T9aJtjB8XvXYw2cbflsmk90DxHuSFWJwV79vDL/h
	gwzJ2QgBXSOOgaWXRws9TSoS2sVRK9+VOZqsoMj+Q==
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 41fhy1rf4w-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Thu, 05 Sep 2024 12:38:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eyyNOjFZ9dg4+ENFaiW+4IZx2FS2/D7w7qTUyyUoCXn503pvC5hjQlaBR+Zno+H8RAoaDJJ5IJVEOKMsqjrnkmddVtqdK+xinJlxcmChpdsPee2N8J2DSJlzu+Jak0vLAXxZYdcStViXU1K7GFMSNFaE1Y7i5FA8GbLHQaiAmjWH+qvDmziaE1lJVjZgVRREOe5+fBPu72hwqDI4ewcnQWpi3KwqPQoJZv7Pg41ifviKCcOO+NcEK0WNjpW60RgsON5lp4NJyI/YeINIp586zkaQM83MpX8kbpjQpkinTUFpWBrZpWHptplhMkaU58Sd/oQ2FIoRHAjA1xTwqmbV4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8n9d5ZqcJ3oESf/0b++kNSRTDtVDHqSO161pYGc297A=;
 b=IV6FkwTDI/wQACfi4WNvNCCgGUCMV2sZUR4vjNSML1V9wpL9ygZ8fbzzFAVC59FiIkG4rrHvLeywu/P4tOAamlUttN5JbNiTYn66KsbJL+2Ec/zkLiogzemI++nPgWrIo0zBRAifGVn/A/TwyzV2p48fraVUMZgDK1GRqk4wyk4DrEJH3RVtA3QzaAx0q9X/sMuoGWGOuXnmpaOpEjppFWvINsMcQAVIplMro0IgNLXpOx565W/nZy6lpeYMtP17jvH9S15AN66kQmaeeWjN+QZCv3t7qudTDVuPPWelTf+/YqIFEYaxMzfU5DjJbHulyv1t+ry/D/VnkvN9BELaTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by CH3PR15MB6393.namprd15.prod.outlook.com (2603:10b6:610:1bb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Thu, 5 Sep
 2024 19:38:32 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7918.024; Thu, 5 Sep 2024
 19:38:32 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: Mateusz Kusiak <mateusz.kusiak@intel.com>,
        Yu Kuai
	<yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
        Song Liu
	<song@kernel.org>
Subject: [GIT PULL] md-6.12 20240905
Thread-Topic: [GIT PULL] md-6.12 20240905
Thread-Index: AQHa/8swHVUUS1d2ekecbJt+UD1ZYQ==
Date: Thu, 5 Sep 2024 19:38:32 +0000
Message-ID: <3C49640C-030D-4AF6-9F11-9C44E38B1FE0@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3776.700.51)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|CH3PR15MB6393:EE_
x-ms-office365-filtering-correlation-id: ce2426fb-1b7d-49aa-1d25-08dccde2531b
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?ziPf070vyK/yPTvKFbc48BEixBvmYaqmnw/3Mgckuwi9/PixCB/HGgtcykqX?=
 =?us-ascii?Q?bQJeYK9Ts6f/utcxSiz5CG41citoeJNhPNDgaT5nu5V5fOCW7ntkx4ESCBiw?=
 =?us-ascii?Q?L3FrKp8dnL1FzGFKo5FVARUVYO8SY2Sjb2GrpaAat2NScr8fMEE+0opei2lK?=
 =?us-ascii?Q?+RtXZvM5EB3cLGFVn5iD+1cx166dSBeIePKJ8CiCA6GxCaa6QwD4C61W4k2V?=
 =?us-ascii?Q?tqKDPxfk1ZVDEfjLnE05xPIcVdofFyW8LQeYedtq6xSEhKumZbV7miATzwq+?=
 =?us-ascii?Q?AqfzbJf8dPJbxmpswyO17xguqeUc/sZM0fnov4HytwVNpoHOhdO5o1n7WH7i?=
 =?us-ascii?Q?X4L086BL+lnTw429WljZ+1uYqNirdXDjJ+RFNKWPa8uOMm8Gieg3mp1UBEA3?=
 =?us-ascii?Q?mbQsSXpkseWqD8EdlvCCeFpKVVYSlGoxrwlPkWB80oCVpqmgI7rH1KtxrpAQ?=
 =?us-ascii?Q?WZxpySh7DSYcFuPtBVUzelm/yQtI84afAa3ganRBy//NvaOTpJChhrBM0wFu?=
 =?us-ascii?Q?O2uIyK0WU2N64ucOb5BQ7kSLrIJMBbv/lxyji6vmuw/DYgMkSvbkXh2bn8wC?=
 =?us-ascii?Q?qOvkXI2CWfex+LxjuYJO0Vu93dmUMmlLBi/P4Jf4LpzVNpKhigKZBziVym0u?=
 =?us-ascii?Q?ssefimRhHrBHzfPhuN+cFQa+meYoW0z7mh2DqZyApZT/cZNvF264A6QoDbuj?=
 =?us-ascii?Q?NKRg+sJaVZJQEbLIHmcVhki23X9FGoap/CkT82OLvOmzbHJNpczEd1gxxdH0?=
 =?us-ascii?Q?Y53SKWZ5fJfwg0R30HnYuLi20ETmFOKKh+J5QD1oCemSU83x1bwAI2cm/PmM?=
 =?us-ascii?Q?/kqfoZnG7s6N6sI0CBPI0ePFwVj8sqrMz1CrcnnOhTcPJHjOvnXD7tM7oZ6c?=
 =?us-ascii?Q?vZk0iteqmzR2qUcfyrVHhkMpvWkLD1JugjPakRCsmbMR4xY4xcqsR+onYlix?=
 =?us-ascii?Q?+lW4VADVJ7IdxvNbPKgOgreoeoSXXkbQZXbDjXzhdp2tMIsRHbzPC8Otz9YZ?=
 =?us-ascii?Q?fmHgeQ0DmmIafxGRgarLXGYAi7pf9qrwZz4Wgq4jRv8frIyj+RTSXv95xcER?=
 =?us-ascii?Q?v+PtllRpEyMWJec+gpY1yJjB7VkmVhC/i8lPDUYU2kxASkokvLeVnVAcVMnX?=
 =?us-ascii?Q?qHFaPoZOIY+NHTlWvriB5CiCj9Yv3BAT2LE3IECkd/Mt6dRvZzNdUJrEwYiT?=
 =?us-ascii?Q?IU6d5Dsye64AhLZJzhiOxYuZDLUfTmiis1FWDYIPt8Dqm9WFohBR8LFlxHZq?=
 =?us-ascii?Q?Pj/eTxJ9s1EH429Zea5KovSloxB1Fyh0803sU/yIr6/GxXJ4XZ/N9jLvjY8s?=
 =?us-ascii?Q?RQL4Fi0t/7v8xb1F3QETO7k5FaE789VtUE57Ix/OBKgpeXOM1Y34X9D5hE77?=
 =?us-ascii?Q?rJwr78UKOwWwNke3z2s38hFm0fgxmAgU9a5iDN7Z4YWVIdQMCQ=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?9BTZizvfvggpc6X9j2fDGhNMKN5tHo1f4mUC114MRyHBBwqCwHvaSxE35Wjt?=
 =?us-ascii?Q?/KJHuVUdPTxYHQ5BblsN0/Ar6WIPEWVLGD8C0fVVBanpCzbhLG5L83q4GLqZ?=
 =?us-ascii?Q?Qzr+etRCPd5YvmN4QwhSrZWJ/Bbb5jzcI2fLTHccQdmPsYmahhC8n2O8SDgT?=
 =?us-ascii?Q?fmp4yWmKDvJRzHbeAf0jk3bv7RkUJf3Z6jg2GecH8JnD9ac/yA/RYhdS3H0T?=
 =?us-ascii?Q?7x9p8PPg7kGAng7kKaYgHE/5Cs83RoxD1YK+VTuI6bynK+BfVTjkegMIkZBL?=
 =?us-ascii?Q?ddeS8TyTwPvTSaVDyvHDP42QUDtXrMprOHj+1aRBVLAeydIu9642AxJkbvBC?=
 =?us-ascii?Q?qriK08/gk+tkV+XrLW44J5462aDCLo5Sudy4l9HSRsjD2MK57IfYnUdV0j9B?=
 =?us-ascii?Q?ymvKV1CE7ZAhq3N5SanGOkxai4eZiLyJ1n2jksVq/2khAvBrMCmkUmgV/Anp?=
 =?us-ascii?Q?CX1WiWuciYxFVo4qE5OdJIoS/Z7cfSRju+qbrz4rMNn8TmaoWSixpluKT5u/?=
 =?us-ascii?Q?LuoN+uInCmrSLb6kVle3wg31g+TkOgVj1QAJKUA+vKB4b3I7ybkk5aIJUNgV?=
 =?us-ascii?Q?+7C8ze7lR0Kwu4HKG6aLCZDUaCscE25YounhCQGQnLskLbhggfIzUdsbtMJC?=
 =?us-ascii?Q?AoJewGCpWPXR3ZNKhFzxUeCD56knEAPjf8Y/t+ArB1NoPDAWXR6lKnS17oG7?=
 =?us-ascii?Q?M6OmcqzNOrxZkx/XKJR2mIUHDxLEUOFqlb0fOTdp8NciADCSzxJgtdayPPq1?=
 =?us-ascii?Q?vlt6r3u3vpT1AkFSplU/WtZF9alVRxN8jWqr7yN4y+vOo6Rvy/uDe5ueSjc+?=
 =?us-ascii?Q?TwWI9382trviLcG4rwqSXzH9X9AexOnUwr57SgvOb8tCCY746LcQqm8C23Oy?=
 =?us-ascii?Q?13NIwGUnHuH32ecw6Xjm6P3yo5bgbliF79ExW6zd9VX4KkMDyMuAAibfTXfg?=
 =?us-ascii?Q?mU/tTiyZitEfTsYxHR2STE3UsvTs8h5+buxHeuT5bWWk1K4jxXqDoGr2UN8x?=
 =?us-ascii?Q?ZWhrCdsOt2Lx5pYcwWH4hC4xJSg3vJ8MhYxakGiDI2UvjBMa05n9sURZPZXn?=
 =?us-ascii?Q?PKSN+FfV+MFR3BANUgjAIoBOwkqvJv9U5EODJmTR07qIrWB1i3rdTTkQ8MTn?=
 =?us-ascii?Q?OBQ1+f9RqxGQjRxmRWBQfT0Pdr/4J/l6EYaKpc1/Qw35Hdva7WBqPPYdOcR1?=
 =?us-ascii?Q?n7Ne1Ekkx/CavOPalZmZbHo9CQDDFUEehe3vw2q7NotuUp/3zgX1u/vQQ7iI?=
 =?us-ascii?Q?G5Z0RVRUImFG0lYBu3hvWe1G+gsv6b/d/OGw2ZhtQxb7Y4q3TJDbPRgdi5A6?=
 =?us-ascii?Q?vNnoQcHXv7VBL+0VYkIZ9uItK1b6RhPvy19UY8Ve+KdqumpvCn2Qn4MQeHUv?=
 =?us-ascii?Q?8U058NDHD97Zfv/eDHz8Btg5417yph6EzihTT/qCxhn5BL7bE8eyW2pES9IE?=
 =?us-ascii?Q?QFBYwQ+JlC5W6tjYtPLwjVBg1/RGjkwl/Flb3y2VBEb1IBX4n466Ni0pE5T3?=
 =?us-ascii?Q?w0DVNYABziOS1yh5pGugr5oaeYfNCTV1/vDmQNYKyyMtda/KHJOnOJ/LC6iA?=
 =?us-ascii?Q?2SM5WPsxzwsu/4ERFrGY/HIA5rtYeoY26VkI5ryolvrbmCq4/z2tkXutMFQt?=
 =?us-ascii?Q?zHpmz44/SjWO39/6unPQRPU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B6F3F81EE5C3D5469DDD24DD7AEE8198@namprd15.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce2426fb-1b7d-49aa-1d25-08dccde2531b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2024 19:38:32.0278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cInuPjEPSAjfx3gWqJdwpkr6heHxnjsBM1hryLba1goe+6DQmsdXHmdJ9mBhiatsVeubJMRATSNmBW0oVzfDAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR15MB6393
X-Proofpoint-GUID: fP_n3NrcxLR4pyQ-v99cE5LeXg5bGM-J
X-Proofpoint-ORIG-GUID: fP_n3NrcxLR4pyQ-v99cE5LeXg5bGM-J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-05_15,2024-09-05_01,2024-09-02_01

Hi Jens, 

Please consider pulling the following change for md-6.12 on top of your 
for-6.12/block branch. 

This patch, from Mateusz Kusiak, improves the information reported in 
/proc/mdstat. 

Thanks,
Song



The following changes since commit fb16787b396c46158e46b588d357dea4e090020b:

  Merge branch 'md-6.12-raid5-opt' into md-6.12 (2024-08-29 11:22:13 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-6.12-20240905

for you to fetch changes up to 2d2b3bc145b9d5b5c6f07d22291723ddb024ca76:

  md: Report failed arrays as broken in mdstat (2024-09-04 14:52:45 -0700)

----------------------------------------------------------------
Mateusz Kusiak (1):
      md: Report failed arrays as broken in mdstat

 drivers/md/md.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


