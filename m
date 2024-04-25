Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EDD152515
	for <linux-raid@vger.kernel.org>; Thu, 25 Apr 2024 19:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714074699; cv=fail; b=C8Nlm4+l0FO2XaZkL66XsmlRgk4fAJgfkSYXrVRMqtcVPX4r/3NdxDhqBRvQrCLAc8GovEJeVj7fvDLiNjIdeAxjs1pILoTztL4EAp1I47ZDxnYH6lbE1wPJakkUjrTlfuzy8YfSaG6YYAqskwz+rB3gVdsYciT2PctmWADRNzI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714074699; c=relaxed/simple;
	bh=PNEvNbYXi4wTxgDjAMoAAtO054x9Kkp+Z6+jvMpJF08=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=VhLqV/LwTsyq27G8p+nOBY+elBO0M5PNS3gz+ElcvQt6vnc2ePkbkWNAahcYTuyUW5zzyQjRI3aoPfYEmMS97YXq9c5glrUhqbNX2uXSK1/d6RyNxVNHqaw5FCpsB7PYCyuiYx36lK2HH+bGZxcsfFK/vF7fncrFM1ghyDqc7CQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=lFOnLFnh; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="lFOnLFnh"
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43PJ3Ehh005032
	for <linux-raid@vger.kernel.org>; Thu, 25 Apr 2024 12:51:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=AGehF2oQQruMkTZuawCRmdbbApT3Q9FQ2fHSvLXGQEI=;
 b=lFOnLFnhCtd9zu9LMyPCpDixjuEfldzoGmzvo/L7PItVjEaIKLGki8AW9LtgZnjpEKkk
 pxTsiRUZqxQLynBoZ7VDQDg5Lz4tMhUzZVZb46NlrJ87WkpgVWmj3wAljSS0JT4MYOfG
 3Mcs3ZMR8FA4ucetNUywK8WALug6asyyruPa4QCuh9O18ENri4XhKLvVm/6voe6e/ZMr
 4Zq3V1AeUsMPab7g6RV+L9udDP2snlrGYWkgE/cn8cE2rsUYS0ku/ngySLZVnw/NBc8f
 qttgN2ui+fksm4B7WU1Uae5uR/4eNr2chlqdrOSkqZzIDiiqGZotS3UE5xu3IOkMBjKV OQ== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3xq31e986m-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Thu, 25 Apr 2024 12:51:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dvpKV7cUVgpEDSNSEoovwyU/bGvqdLnXTfGXoa6k4QMjxY008ulWmkoJoyTyczvB1um+DO/sXfxw5oH0rr++AL6d9ufSdKptAVbP2Q2t3nUABkuJKV+fcHoWQx3/a/Kb5YASnJkMmClV5/QUjbuOx/atsXxmYNsTCi+fyRjZSo4iF0W8wTec6ZFtZKfW0iaIrnLVPk6CMnVEuhBjve02Ru6YJkjeX5NJWsWGMJvjdlYrdiSfXNOKAEpiysbxYcssLfqITdpvpbG9YdCjcXFlyGnajqTx6hoEemW5hJVEqMmm9Uh//uQKaQtB70v/2JwbPcn4GpZNtklMY+peEt9MVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AGehF2oQQruMkTZuawCRmdbbApT3Q9FQ2fHSvLXGQEI=;
 b=Di7bHwfiEGvIy6CvYf9zhd7V5n5C804MqXS2qPzBVGHmmMp4g0dcOLdfE5TRV9egGiOL9BVrIlSGRIX1jQGHglULjUxJ1sVYcaFb0hJJZQ6lph0Ii7jZ3X4Hdk4onhiEvt5e45iHNnTXxCZzUud2MmoDzYPsL0S0imTO74n+BspW6aYcLFOQE8nr0ohA/gL5yXXeVZPf8oBsl8BBzD0Wk4xlnkByUHCE27FJK5HiXPP1AY+Nqbri38UQ7BGHXyZIMNClM73jPTz12z7qYvoLniihMvzeABL6xTV7b87b3AXK4AyVhle5Y3zAsoxDL7Zycjg42AwpZbM9R3kQNGs4pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MW4PR15MB4412.namprd15.prod.outlook.com (2603:10b6:303:101::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.45; Thu, 25 Apr
 2024 19:51:34 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7472.044; Thu, 25 Apr 2024
 19:51:34 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: Li Nan <linan122@huawei.com>, Yu Kuai <yukuai1@huaweicloud.com>,
        Yu Kuai
	<yukuai3@huawei.com>,
        Florian-Ewald Mueller
	<florian-ewald.mueller@ionos.com>,
        Song Liu <song@kernel.org>
Subject: [GIT PULL] md-6.10 20240425
Thread-Topic: [GIT PULL] md-6.10 20240425
Thread-Index: AQHal0n5GoLKoq2zrkakMaZs/QZuUQ==
Date: Thu, 25 Apr 2024 19:51:34 +0000
Message-ID: <CE08A995-B84A-4B4B-BC7A-0EB73319877E@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.500.171.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|MW4PR15MB4412:EE_
x-ms-office365-filtering-correlation-id: abc1165f-f7d8-40ac-3192-08dc65611c7b
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 =?us-ascii?Q?lU66IUMK+CVS6r5z8ylygcgHmLXoAKpdpZu+1NO4WFIY/bFXGaXfk1plx+rY?=
 =?us-ascii?Q?v3oh1GUAgO2VxN8uvSRiCdV8regpJbsl8jI0D7oMvdvJvbP2tg3JJwi80bmU?=
 =?us-ascii?Q?zQIu64xvkPfbN5POlwiO5u73ge1PQyXb1lyEPYS+CmzYsJm8vStBQVeCsx0Y?=
 =?us-ascii?Q?/224WDQQwL2ZTR0BNYLfrdK7LM/mABFrofJq+MjX1J86+Jz4NDj+wFCIDv2u?=
 =?us-ascii?Q?bDf0yLTdT7y30vvVpFO6lbiFNFrdqnRitwSjPnueBCIVE3r7gpFW/T79XXqd?=
 =?us-ascii?Q?sJECfEd4KpOJ2jHj73ZDa89e0Qup5u3Dy9vMX+1OCxAOqGXvo91ft2axk5wa?=
 =?us-ascii?Q?cOGIIioFMb0vqXOEgRTwU5QB/elZhlajOXgjH7cETZMNcPD8nrF79UDi3AY9?=
 =?us-ascii?Q?Wzb9y0gUiJVOwfCsJD8ZKihdLDFAaA8r1wmmt1FpBln3P1NcCdx58uPvcjQv?=
 =?us-ascii?Q?mC6q/BiDqVeOl7M5j1CnkCcVOZgaGkVMyhwdIXuPRkXGxUQG19NqcCEeDwC4?=
 =?us-ascii?Q?2R4CIvyz6byEGRH4j7u4xiub25wYQCSpGTrv1VubrpevRlbI2fVaCeGAmCxk?=
 =?us-ascii?Q?jFkcqoCc3fM9YY5CoItgHnQ6HjMQOSskJx1d6Pty/KCLTggl1kWTQp5SOC3F?=
 =?us-ascii?Q?63pOxiDscRWPmAL5rzZoXKcmRJ3BGFhx2iOBaU8xlcGNzsLUES/2kYxUVT+h?=
 =?us-ascii?Q?SSrrImy3AtrU4pgAXWpnamvCrdJxdVWpctyvpv6lyAfhpvquyTDu9VXDFWCa?=
 =?us-ascii?Q?S+5i4u1moL3bFL1etL17KFsDmGHNB9PKU8smuXV+jkhHVpNRlhCzz+e50hoG?=
 =?us-ascii?Q?0fBT6ETkgeiMv1T8wK31MQPEeTb4t9Cx+GRSXrKrbYAGHDYUMSe06K5bkFxw?=
 =?us-ascii?Q?uWJ2sLvyJUVY66UtzQ64QCqVZ59r0aOzzZ5UZgxwbx0f4FpOgKWGRLoKiKdJ?=
 =?us-ascii?Q?+TIzcTjNvoP28H4OsQVoK/DkAIhhavtSgFQObVUZNmA5v5uypQF8HZrEvmAb?=
 =?us-ascii?Q?rvZ5BowoxeJmQ/DSx1/kirmasMrJkwxqiKAWLi2hcR3/6r+GTB0KS0/Qxz1E?=
 =?us-ascii?Q?aKn3NuYqJ8zihmN5iV26szMkerqTgesle9fFsBJ+Od67kxEhkj3N37A3giN8?=
 =?us-ascii?Q?rgroeWnrftXhq3XPrktewpf4jNuDmjFULk41kzoYC8k/KU82DCRcRqm17AuV?=
 =?us-ascii?Q?EIAhFzt3ot6SaWz3yRavPmf79UvSucK3C4rt7KUTJ6iQMEjODC8ktqUgaUzM?=
 =?us-ascii?Q?ydyPEx3/QirubLg/66+mED1Z5vqeiV9zupEkWpOdUePWQ40BOmiSb5ESqYgM?=
 =?us-ascii?Q?raaW6VqMPP/kJFlp1EXXCaynBlu12vH6mM4qCqDfkvWNMw=3D=3D?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?BIvCK45qYZpR03cX2H8zotaoyXBNv1PA85irkcYEgTKaGoTkyTtiMJnkfbcP?=
 =?us-ascii?Q?okAddMI2LwnXMaRwMmu0IhLhxNAiAopDzGlkytR5H1B+UEMr/OyYvmAVl3P+?=
 =?us-ascii?Q?oXCZkE6z+odVcLFX2AX3pxK+RL1nVM5D964mGtY6N3dYrofh4ponezJrfGgj?=
 =?us-ascii?Q?EfvJM5iH9iN6d9yzXw8a5/3nRrRL/MrxTJjeoRaapRkx2nYbj93g3Ie1wbH2?=
 =?us-ascii?Q?P21oEx3bjGxJ9+Zkc0jAZ/sq+Zwpx6ob1tV7lXLReLinOqOD8dxE337rSFOC?=
 =?us-ascii?Q?V1Fifdt3ZsquU1UFLtn9yoQV1NhFMWeq7RkHwMbr/PiAjXtd2y6PNu5jMEd1?=
 =?us-ascii?Q?+CtggS0cXZb0Q8NfGYRZI7swHosJ8pOS7lWU6vdPNzt9OT8AhVaP7mt3moXL?=
 =?us-ascii?Q?ct/K3qVymkb+YttME5WV9luI7a8JxUzSmKWWO+vDMOo5q/oX46fS7IBUz4FX?=
 =?us-ascii?Q?fSlTnNRn0Fo3pXzksubqB1VELciDB31ILOnpMq/QWDA/zoFgPo9/1rCfdklK?=
 =?us-ascii?Q?OIc09z9xTYvUzueLOpGazwN7IsiRpbYxCjV5HGjpq9zOrbzR+1Kz0IQYVgnJ?=
 =?us-ascii?Q?Bz4QOrE5YcraZSl2M/K0UoehDU92Mg+/FOBu7a4b0wZIa+iOWbR8IgpgxX2X?=
 =?us-ascii?Q?X0Wp+SAhR9kcGjupElO61XfJyopJOwfhNIgkwJLViiYX8oysX+7wmgI3XILr?=
 =?us-ascii?Q?DZWM04afpLpuzcDq3AqTXdNaDqbR0aUC8XRgu3mmyABN27+LXi8tWwfV8GDH?=
 =?us-ascii?Q?A1G8BkVwe2cbivTCUXO2zDYMVuOVR7wR2ipgl20lPaN7nDNgDdlK0oSYqUaK?=
 =?us-ascii?Q?X4zu35+w44TXoqr+sjr8Kdi/mu0KGwA9wDMKfl7pi1LQCFtoZGFqqEJRTJP8?=
 =?us-ascii?Q?JXwTRRss1/kJtW3TLOHk6otybidO/6kHHl1oIl8xsZfuL0Qab/auxAcK0bsU?=
 =?us-ascii?Q?XLIk443K5KA2qNLrwcazKZMvoBW2hW8BV6a8MsFe10s9DgsoeXZ+vTO4rCe8?=
 =?us-ascii?Q?/jqfAqH9h2MPMtWEfdG5Kr3tfAWei87WJ8gkXSFmGZkulRD5Db6DoarOlXW4?=
 =?us-ascii?Q?I49Er+BjQ5TPikbwAEDukOoS2x+UbTIi9bkxDFFqktap1+J4sXQHg2Nfy1QO?=
 =?us-ascii?Q?ig93uvFuDD+4OHnkGt3/ysgQAYvNCfDR+7dEl9CEHsbc/Xl97zj+HgDJRQN3?=
 =?us-ascii?Q?oewHzKSqhySZ9dzH4jvu7WQ4fEVVgrdLrTyfNkAlRuYnOYShqpFTah6Zs/fk?=
 =?us-ascii?Q?3tG5nDY+CiXc7fCCWifRwugp9zda1WBsSXi6F5roWR3vrXdDIFhYoFMiyqim?=
 =?us-ascii?Q?U5yVcGl3C/HOT5if82aOihaCFEkxauTaZDjPU7yUpAJ5IUCUIonOCsZSyAZ0?=
 =?us-ascii?Q?LkcLTHoQe9cFSL4EwZYxMb3trvKoLTP+TVfXuUkc8rtvLszwKkE94EtREJAS?=
 =?us-ascii?Q?c05PLymgF1cibbMR0H614+tvbpDRxsMxoV2tTC8pgNyecDMC1HwXBXgHBbPx?=
 =?us-ascii?Q?yKDqfklUi8rAEdPpEOp6aZVDFKcGg7epWKVmOGsr6mw/E4ruPVxe/XlRbz2b?=
 =?us-ascii?Q?2ORlLcriE+e8w8obBrQ2X4svPTIU6jAhJzGUx4/GH9IWUJZVF9Njb6MKg0K5?=
 =?us-ascii?Q?9ZO/aPNjDFLZ7pyRBBz3FKA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <85F6DA51D442894DA4F85AAD6B68F55B@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abc1165f-f7d8-40ac-3192-08dc65611c7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2024 19:51:34.3540
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I1JdoFlbvC8DPKvi3pqFcD0KVFwYBSzhWmiuAMcAw0aB2JNkj4C5OvtGnJbUAdIIDgtm2yJnYrzd36E2AiWNgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4412
X-Proofpoint-GUID: 4Fi_XqsFDZ_KrKdlfIrzlYg73h4fXGuy
X-Proofpoint-ORIG-GUID: 4Fi_XqsFDZ_KrKdlfIrzlYg73h4fXGuy
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-25_19,2024-04-25_01,2023-05-22_02

Hi Jens, 

Please consider pulling the following changes for md-6.10 on top of your
for-6.10/block branch. These changes contain various fixes by Yu Kuai,
Li Nan, and Florian-Ewald Mueller. 

Please note that change "md: Fix overflow in is_mddev_idle" changes 
gendisk->sync_io from blkdev.h. This is only used by md, so I included 
this change in this pull request. 

Thanks,
Song




The following changes since commit 688c8b9208356eb5c3fa8047f3e35666f3049a4d:

 blk-cgroup: use group allocation/free of per-cpu counters API (2024-04-03 09:10:17 -0600)

are available in the Git repository at:

 https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-6.10-20240425

for you to fetch changes up to 9d1110f99c253ccef82e480bfe9f38a12eb797a7:

 md: don't account sync_io if iostats of the disk is disabled (2024-04-08 21:15:46 -0700)

----------------------------------------------------------------
Florian-Ewald Mueller (1):
     md: add check for sleepers in md_wakeup_thread()

Li Nan (2):
     md: Fix overflow in is_mddev_idle
     md: don't account sync_io if iostats of the disk is disabled

Yu Kuai (1):
     md/raid5: fix deadlock that raid5d() wait for itself to clear MD_SB_CHANGE_PENDING

drivers/md/md.c        | 14 ++++++++++----
drivers/md/md.h        |  5 +++--
drivers/md/raid5.c     | 15 +++------------
include/linux/blkdev.h |  2 +-
4 files changed, 17 insertions(+), 19 deletions(-)

