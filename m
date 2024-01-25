Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F0D175A1
	for <linux-raid@vger.kernel.org>; Thu, 25 Jan 2024 23:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706227198; cv=fail; b=ANuVYwyvQv/vET60qEum4fe5vPD6o6aTXgE/kAutaEKl6/UIjYS6KH6S2TTjtjbGH4Wb5LPPunXzcu0lWk8uSxIKEXJ7k4r/ROnZXGZJWAeePjHOXLQfqalZH5BmzPb/ZU2D3OHVzZGNn426FuA1sS4MWflXiQbHs+X4orSba5c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706227198; c=relaxed/simple;
	bh=TPrdaJSrqAtLqm1uGzU8doodE1fdrU4/J5lVMwixyKo=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=MLd5tZyLz9YePMjsUTmyhEh+IIHWjrpGoZ046Qyzpi+0hfnjqYGOU/17JKLMV0woxJASwO0KHE/B+GLhAbtT3ljYHAmjU4IbYUyIuNzlfWIafx1LPVvxQQ+ZHd42xyGp+z1YnBBVDm0hXs6ibYcSrK9y6sEEg7+jKSykOaYmkF0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=V3gcAJ71; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="V3gcAJ71"
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40PM1nKT017670
	for <linux-raid@vger.kernel.org>; Thu, 25 Jan 2024 15:59:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=EYdmVA6KjSpakzA4x0bFuUmr5MAdHhKL2YW9zfGw1cs=;
 b=V3gcAJ71qHdmKM/D7V/Z1MXqkbs126g4RTv8QVJvtMX31nvjckZAmTAiX1WVtfNT/Ujn
 aSqD5cHAFfK6B7D4B5cPLTNDsvk9GEDZmF6r+Je4Hr5B22p2L51R19qcE96b7Q/xIZJb
 akqLPTzKNByFqyRW+QGagyF6hR7JxyDsFVEO6Q62bLDefFMcwsvomv6No7rEoyNl7GbR
 9FXcOLhPi5tdO11t4jiXARvwXA2ihZypwHCf5uNFQBOc+ume4EBW9VuyQsij1tgnaCcM
 HZQlaApH4y0pe3GO7W5s5GKGk4mNTVkC2atTnyleaMuhp0+/D6MnFwRjl1FKEsAcnYEP xg== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3vuf14xnrv-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Thu, 25 Jan 2024 15:59:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DoTOQ1Rytm53yfcNDqb6KLu+bB/WIcNeJPBj16mrUymy8zgA5+onnLM793momFTQXOFLRuC4K28mSMADuiqxO2EKI9tTGOJnnjGi/x19NYxRC0K4z5LnTbToyvvAqork5dpOOZJDE5j52c2rqGl4S0uBoL4LKiCY7kQMPE7b1Ge4N2vb/yjYCq2dCFZrzHxZADCrSQqoAcuCj3lOpqndrDKE2kIZDs3rdQsjnZpf6764Lx0wzqgA9QOwn1/g5hp6bSjhLOyqhLNiyno3/caWhiqRdXgJ/m6oTV76D8CUTnFRp5uJn+B2HyamuX+lEFx1UgfNF0kBppgTIYK41uRKjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EYdmVA6KjSpakzA4x0bFuUmr5MAdHhKL2YW9zfGw1cs=;
 b=dpXPBSCZOpLUCtJ38ma6i6a2TBrbOEjwUxeet8/+/mCY86g2GQcwLzJYx7sZ4OL2X8nPJipJ1CU5S/wA/OcbtVUYYe7jmPqDSjy0v/mP0ValuSg8qUxqxkav1TA/Ek4JwoEVvQEuNd2tJO9xZ2L9/lzSF5xMMV4wlWhui5G+bLGhgWqhsRVNt4tT7yDG/VTEdq8keIv9zNcIQpvdctAa5fDCrAiIBE/e9l6wqpJFJt0wyeRy4yJSwYxY9ELO3OWyJ7mjO0SPWIsjo+U5xDib/V7/EyQEun2fsdi5nJgTnpdNW8iwwLPjJFRYEbrGoVRw9aB4NBKDWCj2VsVUxzKfbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM6PR15MB4071.namprd15.prod.outlook.com (2603:10b6:5:2b6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Thu, 25 Jan
 2024 23:59:52 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::d467:8e49:f5a8:c0e5]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::d467:8e49:f5a8:c0e5%7]) with mapi id 15.20.7228.026; Thu, 25 Jan 2024
 23:59:51 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: Mikulas Patocka <mpatocka@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>,
        Yu Kuai <yukuai3@huawei.com>
Subject: [GIT PULL] md-6.8 20240125
Thread-Topic: [GIT PULL] md-6.8 20240125
Thread-Index: AQHaT+qWlGLZWBW++0muL/5kUanN0w==
Date: Thu, 25 Jan 2024 23:59:51 +0000
Message-ID: <19B1724B-E840-4A83-BF7F-3A3FE2C26776@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.300.61.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|DM6PR15MB4071:EE_
x-ms-office365-filtering-correlation-id: f7e39020-7515-497c-feb4-08dc1e01b884
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 L3j2RoxXtT82uNSKQNJp7KiHHR9h1EELpAwvfZCVe3c8DKgegqwmwtTsaACWf6uJYYHeJpnxCX5hqYLxUHeOgugFKFcDKPCtF6axXaQtT7RkCwpVtCEvFMYIcaO63G+mgzHNmbrgvEWDC5i1nNZXblD7792jL9w9viGRaAoDH0PZRbLetwVJa60nKddrK64gkO2ZEK1g3OVPSy6JhOXH7gk4vCfh1E74U/YV/kaX3VOsSQHAmhA8JYIAkbzOOck7z0O6Q/pOD3RDG4msPue8bdejmKCkZzeZ7smX4UkXRlZgljH0yhnOsDGODFSBTHAjIkW2XafERYSFSUCaQCc4v5gJMQ3lr1EdlvG67SkBx12XsidNlR8WbJW5PRtdGC+qwZKIjEM/5A/cdr3aJwSfNKLns7ZC1GDNKQOEd8Jz2uDq4VDCLCOvNvyw1f06StHJoe22XSQkCxkQ6LRaVnlMW/ovy8Tx+2Q5SsBzBetZ8vQe5CXGIbk9r4KzNaIrB9GpOssK5y7oYduZ//5mRqly0FltXYWEy9nHRzun1mfXrEH141zajvdCdRqm6RwXKWNxAiArwMta3LzIx9Auvh7z9MiJz9uM4Bh/+c9temfVdgYNLQQD3R6Rinp8Pl3UgQcxlTaEcVGQYKAiKVz33QCZoQ==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(376002)(366004)(39860400002)(230922051799003)(230173577357003)(230273577357003)(1800799012)(186009)(451199024)(64100799003)(4326008)(122000001)(36756003)(38070700009)(76116006)(64756008)(54906003)(66446008)(66556008)(91956017)(316002)(66476007)(66946007)(6486002)(86362001)(110136005)(71200400001)(6506007)(9686003)(478600001)(5660300002)(966005)(6512007)(33656002)(2906002)(83380400001)(4744005)(8676002)(8936002)(41300700001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?2SN7z3zwuYC+ZjOpFRUjHQC+ajqnMk8mIlAMN8i2yKgp5DALE0fY5dPUhNxP?=
 =?us-ascii?Q?BhSSK5PS9bHUZppQDzWP+o/SRDjsLGCxAkkC5Jz2gE+8Re0VJEXD6mehlbWC?=
 =?us-ascii?Q?lWOajeqojsPA6mcMHnfLVnP97aQTQnQDQslxdNT/ClgHMrwX9AOE0f+WwNE8?=
 =?us-ascii?Q?DtBknMXSie/w9vh/lIH4GJ6IpxNRRxR5O9XlOcPOLCW0sTiIX5NRzj5u1OKp?=
 =?us-ascii?Q?1gTdXKU3S7uXjjNSGoF52tYEA6IWSwQvEK0xsZs5DRlK4bjvsQx6ZLQEf1ba?=
 =?us-ascii?Q?MIAW1Gr90yTybMSXbOqNvjYzn8B/ZhmgoyTtI35WthWj4FvjrU2kWP5uSVuv?=
 =?us-ascii?Q?18AcitksZhL6gvQoQvlvTaEEfwk/Fe8So0Ouor/Rt0UevcbOAMS9epFastan?=
 =?us-ascii?Q?bbkht3hEDFlOwTbaJ/Sak7ivvQTH0y08ZW2fOZ0MCzRfcB/6k7ZZ9w4bq5L5?=
 =?us-ascii?Q?f/zUsD9uEgjLS4bIgyGH++R1tizbKQDfY52cSX8JIXUEI1cBBAAcRefSt/09?=
 =?us-ascii?Q?rp7p6jNNUp3wXYE/JzNo5Ci+sP+zxDjpsMJPYR4rf7GtGorN5OpktpJlfKt+?=
 =?us-ascii?Q?bw/M4yadYS43YoqQSpzYAMVo7vXtRluzBS9w5LAZiy9o7NKDF5ZP7yNickVk?=
 =?us-ascii?Q?fxPsW+mRdOKpoB78vjWoFG9CyxrSOMoMivEndCkkxhtedZBpkUQrdpNSfvuV?=
 =?us-ascii?Q?Nx2r40lMXpk39Zuo3ifEKeYaZHo1RdUfyfq3UF0IX0OVqAKE4HOEr8Zr88NR?=
 =?us-ascii?Q?P+AEmTthMd4Tutaa4o//e0eKg9MAuyB6TPwqq4DX9VG2TCqhecO8cUtS9xtQ?=
 =?us-ascii?Q?LXLXLQsO8aKktwlS11xqpVzI6WaOXfxu737y/2SP1vYxdM6ed84jAiH1jlGE?=
 =?us-ascii?Q?e/nl+4XA95VC4mG/kc7Yin9MksTHWOa1sMy8fX/3ZhJtXDY//+O/rU6MuFjY?=
 =?us-ascii?Q?aXt1yeUJO4UQqecLzHdQk2A5KOD4mTapuo2xHmRBZrt8paNeKiYgdoteduE8?=
 =?us-ascii?Q?/VxwflZeJ0MdDHog/37vmci/fV3YQyVR4RAfJV3wQj2ujFGEG+II8cuEVrAk?=
 =?us-ascii?Q?SeWN7U6fi7D23dnuwr0jAC+HeUwZuRpR2Fn1sZsh6v5OsKogP1MO38BuUfDI?=
 =?us-ascii?Q?06OcxPofMOVA9bB8JJkVv9p7NcfTwDUF1XYxt2IDRAOLpANTlwUgMlCq/YLU?=
 =?us-ascii?Q?eP8/HKQtRtOzaUwd1GGdt1JDiZwZKI2Lo6D2zICnb6wfrBmaBiMsuDoABRsu?=
 =?us-ascii?Q?7Faal15JtY8s7HhlIqMNRd9pdftzbGfiVK5oIP31zSlq0CZf+FgnkaPZTdcd?=
 =?us-ascii?Q?l7iwnpyJGudMWiP3WTIaGlCrd4vlcaZXVrMXVfgZg3VKh9sNgZmR2VkRkert?=
 =?us-ascii?Q?W/QlaltO6C7JPonwbt7gLVQoqMT9GrO+unrssVmNtWKtRdLTS/wDJgHyJ3gg?=
 =?us-ascii?Q?l0Fc9CrYq0kem1Diz5JQvm3U2R9DRu6iaRiHDZ0LtUNQ8lJfKMckBnBpP0PO?=
 =?us-ascii?Q?Ic6TZ+a2r1YO+s5fQI3qkcT/3CMAkD3ZbgIlL6DbWP4Qyw0Ecyma1TzhkQ6N?=
 =?us-ascii?Q?Tm0wYF5zNbU9b10fy1KzJNQ//KICsBjtSQ7vxnUA2F9g0eNY0tuygmiOMmdR?=
 =?us-ascii?Q?+vjd4fwA43VO4QeS39E2uVA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <83D7E150AFFC024EA46D4AA324648630@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7e39020-7515-497c-feb4-08dc1e01b884
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2024 23:59:51.8849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B9MNgO4RL2gg9OAZaLzwPSBhMmiqaubK3Yy59UcXF+DKuLvXE1JtugSMAiTuQ0iZrEVANjGiA5l8o5+NGgiJxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB4071
X-Proofpoint-ORIG-GUID: L34_0IbpHGz3b2Twh2EdgfAOgOwS7RB7
X-Proofpoint-GUID: L34_0IbpHGz3b2Twh2EdgfAOgOwS7RB7
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-25_14,2024-01-25_01,2023-05-22_02

Hi Jens, 

Please consider pulling the following fix on top of your block-6.8 branch. 
This change fixes a RCU warning. 

Thanks,
Song



The following changes since commit 6613476e225e090cc9aad49be7fa504e290dd33d:

  Linux 6.8-rc1 (2024-01-21 14:11:32 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-6.8-20240126

for you to fetch changes up to 9f3fe29d77ef4e7f7cb5c4c8c59f6dc373e57e78:

  md: fix a suspicious RCU usage warning (2024-01-24 22:58:00 -0800)

----------------------------------------------------------------
Mikulas Patocka (1):
      md: fix a suspicious RCU usage warning

 drivers/md/raid1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
