Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="KJizT9qz"
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC3010D8
	for <linux-raid@vger.kernel.org>; Wed,  6 Dec 2023 13:04:50 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B6IgnCu009409
	for <linux-raid@vger.kernel.org>; Wed, 6 Dec 2023 13:04:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=mdONSzWo62d8Cx2yqbwe7CMltPKIgW2lcaR2gMA65ic=;
 b=KJizT9qzqwNXwZAoXw7q84tVcoV4B/iwVVUaVB6SMvr4tvdfvZ8E23KWKEmkaIhGN9hL
 B17GEBYmd+wWd1VkQ+ix6lrDOedt2oHgOvMUG1Gk2rlboXPUYGE6umeq5hMP2oDwpM/8
 16YZEC1IzQom5A1Y4d8met6mozZU0OLzFRCp5+Yu0GEabdeMfd6UT8GV21oh9KW9dDOQ
 hdpRmSKZ/ndFGzj3Q+YI/i8fJpkcmdydTEKJjUPd+2Q+KAbCLAB++Hfi7Eq2dn3fbW3T
 QOFosgnN+5FBGzmbt6k5jBuQr/XmuAwDk0UMxz8V1zEC3IAzSbInQpg0Axl/10tr9XYJ aQ== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3utd31fwa2-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Wed, 06 Dec 2023 13:04:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdyaUGvBxTQYVGiid88mZ7Y3xItYJZzEcKB/3mnO8LRPDEObQxG4JTEeysi/+i/Ylv5b8dEFoJnyfhohqvtEYs1vLh8TwKBeiwRuSX7o8PilWDlvPqoR1F89Xi9OClLbSePUnOKOGiXIKKVYI6Odj9rDddt2XS4QLiheDHWCJoqc6TI3SiklPKviJ+xZ6r1KXgMl8QclJ4bo8oVSnK78/9I8zgHrB0kn/EzSnXkSWgeihgR1OvrEIWwCJQCbEMdiIrK8Ij8CALpyF+hB6auOCCXrXaKDiH8CcdSLTQQdmkd7cQe79eWou78WD2fosrfgfToTGZEsrXmaWi2fcEj0Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mdONSzWo62d8Cx2yqbwe7CMltPKIgW2lcaR2gMA65ic=;
 b=UWRF2eVdAYfw4kXuPK2B/ZX5/j5EBLJ3tKi2z+JAeuTnXnmOuEIiBKq5ZhNIQatSzFACohsYngeqe/k/guAZ+9vSTqA0A5+t2c4H+CWYk/k5Gep12DLWQO3fDjYEUH/ULfC/WWnhuNwKuPJ+iX5w1278owUF9p7f/+h+517QZ6tGDR1UnrKY4L+6mVfCJ3BHsTkGxi/iGFIxlyp6/RySEqPcxzcqLx0+tR4YUBhwFeKLiISuYDA84XCwVuJzZs2sOUeuc/XiFq0d5+QiPfgZPxvtAeHU58ZxuECE+l4+ugSqENkSab2hWd2524VfQ1e0TjAAJbv2nGwZNysM1KMMxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BLAPR15MB3795.namprd15.prod.outlook.com (2603:10b6:208:27b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.25; Wed, 6 Dec
 2023 21:04:47 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::9052:3362:76e2:146d]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::9052:3362:76e2:146d%7]) with mapi id 15.20.7068.022; Wed, 6 Dec 2023
 21:04:47 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>
Subject: [GIT PULL] md-fixes 20231206
Thread-Topic: [GIT PULL] md-fixes 20231206
Thread-Index: AQHaKIfXbSf05bxZ/EiSz9/R6KfPNA==
Date: Wed, 6 Dec 2023 21:04:46 +0000
Message-ID: <8D537C9C-81AD-4906-8A8B-3F103D53C655@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.200.91.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|BLAPR15MB3795:EE_
x-ms-office365-filtering-correlation-id: d5e29b56-f3b7-44ff-e2ce-08dbf69efa70
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 00zO4IenoGP1cxLET9DLVvt9wa0pf+nGAJ7/jtyTbSEo/Vlr0prkrS8kAcF2l8WgmxexUoM4koD+haYt2kNPLWHmM6rFCey4kqPIjG+tsvB9+8/m/U3kNPnzCca16fNJl6OU13nWyLQTLI4h/uDLRbmgyClMRulH5So1e58D0B2VSmN6ZqvXV2D8gKvSbo1CXxfGs/QwwPsBRSDQOTocPcdM2PaxDzN6p3toE91FPBkCs/gqEopUpOdAIs8Xc6US/dyu0f4eL+16rYxPI+awfPJ9VK+Ntj5iBRFRVzrM5adMc5ZIgYcNsRoZ67PXYXs6K/uoIaYVZXEeX31RD9gleKhg2AUdYsQsgxHkuwowJp4WAc4DLLc9vQc9sVcNaA3Jjg43od9nXNiPw1+wLLZUUdQive12ADPbWPpdzyEwBKhgu+Sub82jFZQydc2aM7Xc3GL3J1w8MbuUDdtrhNmYdU4VwKxUzVrACperavkSoANWU7zE+SDPSLOnKD2HQivE9copcPXdK/c1m8uAxy0DLINYNPkNyrZ8ongBlO3jAA8N+qlwWqW6w3GVnrGFuVV14ztu60aMs9IoDjCfGkyb7Zgw2yeqq55Mdz2CT4W4dX8=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(39860400002)(346002)(396003)(366004)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(6512007)(9686003)(41300700001)(83380400001)(66946007)(76116006)(66476007)(66556008)(64756008)(66446008)(316002)(91956017)(54906003)(110136005)(5660300002)(38100700002)(38070700009)(8936002)(86362001)(8676002)(4326008)(33656002)(36756003)(122000001)(71200400001)(6506007)(478600001)(2906002)(966005)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?tMlp5gR3OPvWu8n45ARPoXE4C56r22o0eC4UhwVikRST5urWpYjhA/NdaFOy?=
 =?us-ascii?Q?WX7DLHNJ6EelaEbYKhuk/n6Gp9MX6xVuOeDdDZpmsGOTxL8QKf2IX3iObdE8?=
 =?us-ascii?Q?5KL868bIK40s5tAtdzWSEYpozhkE04VZFUJjL38t/q7iOVyWeLj3q2mlU9OG?=
 =?us-ascii?Q?BH4x34mu/nUSIsCh/Zi2GbB+YpS6Cm/I6d6sGo1TXqN4n5eKycJkXFJuGeYS?=
 =?us-ascii?Q?Q6PZrNmZ4D6HHSHDJjPxvhfTmFOcGyfKqUwjFI9ydzGqaaGHlEN9Tr5l4WyC?=
 =?us-ascii?Q?f9YC9OUwD0LXLop8E8m3jV4UCU7cMNXldMKEYqcfPt7t/Xs3QFTch213oCE8?=
 =?us-ascii?Q?g5idLBfRkfVFThlCfaH4FQ/ORMjvdf34JM1L7CJkhpmCqyh8UZHPJE5QyXy3?=
 =?us-ascii?Q?+os++Fe2UAO/cO4w253pwuaHVFA5fthju1eAvq2jgVV+Lu0Suu6QZeYY9mJG?=
 =?us-ascii?Q?Av5Kt17VztcMQTOceDHxwy5fbPVziLDW/pLKXyyeQ8M1yuwKF00n+KkNeuXq?=
 =?us-ascii?Q?8VZSv15h3TZP4/fjvJgK9HCqMEzBJ9dF9RzqR3284z5ETAjxF8hzxZki5b7J?=
 =?us-ascii?Q?on5OK8urM8OGgTSeGbOlYxlpEsPe4d5O3V95ox57/Q3qVWurrRUqGVD+asNP?=
 =?us-ascii?Q?YPGswRzj1Bn0ywl9WvAX2itmKzUeq/r6rVilOJf937gKQ/4jgyLrjyGMUCzJ?=
 =?us-ascii?Q?wxcD9AzgfgNIVSk2TnEGLsF5wJQA149NYyt0VWQIxeQVVGKS1yPczduCGO/f?=
 =?us-ascii?Q?9OPMUvd4RFEPHcvUODQANphWykheigO05X/kg5PPc2gfyK4tWuxnSj+h7FbJ?=
 =?us-ascii?Q?i8Y37Nza9pZBypCHYmnFsAuSZ8jCQUUc0umkIPrU4WT+ePt/BVouLGts2BoE?=
 =?us-ascii?Q?Q9K+hjJBQwOsDLiYvt972g5cwbuPfLqt+otF6hJZ/20Ys/yJ1Ogzoc/CZRHE?=
 =?us-ascii?Q?dUpcyXab/ciTpvXH86avQk9LTEFMXhKqmIiDAGvhYlZlCm9/PcggkG9aD2a1?=
 =?us-ascii?Q?xCz4csarI8v0ZKq7O/z69YrvHImsahU53JOBcqnsv6Pjf1XvRefuaN1n3Oyn?=
 =?us-ascii?Q?WAlBki/uAjqbqVczEw3m4GEy5WUVKZaXGycIIQ54YxJkJGMZsUI6ounON1nD?=
 =?us-ascii?Q?xM3uS1nXXgIAoutH1O3IkbAUzHMKtrNdJwHGWUi8IcC7iW3Ug3Op5cdv8IYk?=
 =?us-ascii?Q?bSr2YuNxeu0eGcQmwPJtUpUhnT0u1IkwPgR3pBmQq/sT3sznsXmGt52p6eve?=
 =?us-ascii?Q?EEaVyi5eTmlxPkhYCFlGkmBPTXGS/ka9NaOIR79MEpkHkFCrjKhu5SiC73a7?=
 =?us-ascii?Q?3tXKJwxL02nF+/hPWmEm7DzzIwFgFIZVJC9FFsfDYUTUMoMuMsHX7baNashd?=
 =?us-ascii?Q?8cp3+4uigE8+ZuYB6d5cJimSj6tTB+VXxkUtikRdMKSQXvkty0jFbLeq+iHP?=
 =?us-ascii?Q?yzgdK5MIaq/p4GD2jT0GEJQFC0OhOeXuVWZYg8tJGpmeakysByWv6B0r1NBY?=
 =?us-ascii?Q?iryugj6no9rI5YMBYogNr6Wz85tuaf33QTLUJkeI/jNm8M6F7OYOtTGOU0sQ?=
 =?us-ascii?Q?rWfIP9CdaFdIzX+gBiWItIyM4D8tV6FwWTReY+Gy49E+Ns0IseJ+Y/ryYths?=
 =?us-ascii?Q?HtBa+911RKA0CibA9NAw9tI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DFEFD8D786EB8E409B111AC04BA1ACCE@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5e29b56-f3b7-44ff-e2ce-08dbf69efa70
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2023 21:04:46.9650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dtXFBAiWKeUr6LAtCWPflXMK995s/Ql3CBZMK29S3IhBKlWk+ONMpzpozmwNn5ZkUizMucBAhiQYc0rsDS7XWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR15MB3795
X-Proofpoint-ORIG-GUID: ERmFNUtuSEYtGMhHoN_AntqArmmbMo0N
X-Proofpoint-GUID: ERmFNUtuSEYtGMhHoN_AntqArmmbMo0N
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-06_16,2023-12-06_01,2023-05-22_02

Hi Jens, 

Please consider pulling the following changes for md-fixes on top of your
block-6.7 branch. 

This set from Yu Kuai fixes issues around sync_work, which was introduced 
in 6.7 kernels. 

Thanks,
Song


The following changes since commit c467e97f079f0019870c314996fae952cc768e82:

  md/raid6: use valid sector values to determine if an I/O should wait on the reshape (2023-12-01 14:43:29 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-fixes-20231206

for you to fetch changes up to f52f5c71f3d4bb0992800139d2f35cf9f6f6e0ee:

  md: fix stopping sync thread (2023-12-06 12:44:00 -0800)

----------------------------------------------------------------
Yu Kuai (3):
      md: fix missing flush of sync_work
      md: don't leave 'MD_RECOVERY_FROZEN' in error path of md_set_readonly()
      md: fix stopping sync thread

 drivers/md/md.c | 114 ++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------------------
 1 file changed, 50 insertions(+), 64 deletions(-)
