Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="NbetqD+J"
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE7310E7
	for <linux-raid@vger.kernel.org>; Thu,  7 Dec 2023 10:33:12 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B7EJxBo022304
	for <linux-raid@vger.kernel.org>; Thu, 7 Dec 2023 10:33:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=9NF142wsCsxcdGiNL1BWbayB9QNsoNk9jxp/oIKyDs8=;
 b=NbetqD+J/o40P0Z4+ja2IsFeoyPJgunFcS4zbS3S9g84wb/tltQ6zUyjKpwG/wmJBorX
 XAug+azLL5SyTjLGVNcKdg6jJfb6XS4A/3So3PKjJ6MolAhzsBLB+JzkVtvOVe72uX91
 PesB6fG7ZZf10IXemh1b+QlWj/sRP2GLFZN9cv0iRiBxPjBHSxujApBGYbvpvCZxdVdM
 Ihv2p8XiwOnq7ejEzRj30r9uVRvvrHNwlGk+0Fwz15VjhtNGVZbOMmBbprKDv6kv45nb
 j+51fYjELuEUoH8bg+P3QCBvh25PWnHdXL2c9VBEFBQCIbaZo4YRe9DgqXtb6r1PqS8U ig== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3uufqaj3fe-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Thu, 07 Dec 2023 10:33:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cR3psiYaGgjP6z/IOu/eWrE8reUxSOpfmwCt3Jer1C+z+ysWgcBfNDBC3fYon+jEKDQHxzRhAlRvD8BLvNH2auIRiEjfbd68BE2ocItAtd+JNwiCIi2EtPPRUhcv7L3DgtXYDq9EO7QeRsaxHYcAYyv6tBNU8o3cLU4siEUFAMsjV3RhIcsPSDHm3zQfsTgeFGHFGJ6PPTHKGX7JOLf0srvBNUEZp5BwgsWgGGF5CieLkASiPvpT6wO3N/xH1qobMZgHKmUgUGfevXDhAxxncmCQdRVjz1paKjOSv5Prd030ZWlY1tarc5qtppej1cFSLAIcLNgEISIlNJf5x7/HGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9NF142wsCsxcdGiNL1BWbayB9QNsoNk9jxp/oIKyDs8=;
 b=BpcEKi+zUilC09m75LvL3g0aR2Gk0L9SCeIS7vdCZXER7NmfnlKe+S9NlcFLo8dm43bUFFfOgbu6LXPhx92sL1wxWkmq1yp8i31u9jekzJh+k5dzdEbR0vMB68x9dZ005sM9mZAENAIVeemqDS8hXuk3gTmyW7/DOqiFnY0z9mRQm3NjfwaF6yUFDw9uYNlnqWnMPBJXo6/W2pJ1TumsLovhtTP4i4igZsm9OBGqwCT5KBqqsOTabdCcufa8InEeEsv72riFy+DsNjjQ5CsISLFpJrUTVBqpqzkAKQkKCxBfYg+6G+l/dobfxfd/AyrLtp8LQMzz4wAGrgtan4U0NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB4499.namprd15.prod.outlook.com (2603:10b6:806:19a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.27; Thu, 7 Dec
 2023 18:33:07 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::9052:3362:76e2:146d]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::9052:3362:76e2:146d%7]) with mapi id 15.20.7068.027; Thu, 7 Dec 2023
 18:33:07 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
        Song Liu
	<song@kernel.org>
Subject: [GIT PULL] md-fixes 20231207
Thread-Topic: [GIT PULL] md-fixes 20231207
Thread-Index: AQHaKTvSp1HzBVar6kKNUIiRFuI2Zg==
Date: Thu, 7 Dec 2023 18:33:07 +0000
Message-ID: <32698B02-C181-4183-9FA5-F4D5C17F11AB@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.200.91.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SA1PR15MB4499:EE_
x-ms-office365-filtering-correlation-id: 5e07f815-ad52-46b3-38d2-08dbf752f52e
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 gF8eFIGgo8pf6ilFiep2GDCqMOKsigEx64PziaOIhPGKoJsClmqgnRos3RMJx+Gb6oV7ASB65ruQEtGIDKKwqRxujHtZwHUvg2bmbKoM4uGqX3ygmS5cjJ7eaqanMy4B0gZ/m/qHynrT855ijThcXJRgpIYEbG3ymdWlaiPkRBMb+QQw7pebyf/wGc+X86D41wrW8EimRMqNUkYvtFuUtUw9db8t9TolzeD3ue6kTioSUZmuZriG/BZr9j0Kr+nny6mNNRZg4hP4sQ+KMIrnOMkh06hk4Uj7d/N8bHEkChOb25C0md36qJztPg96Gt6G2Z5JZL1GiNp+BhfmYi82IsEjkZMnXAQHCV6WDFX/ulmjhEA7oLqaW5FjKdV7NWVY3qPknFizWEW9Mjz1o4sEqsPPVfWEfQ0MaZd2ngb2yEPWiR3B70cTTjAKaqffp9VQ4rpWXeO7FJp6fAs89PpT7Zw8EK4Q1tTui6xy3hJpCoTL9Ax++E/lYQZOZFpXp/pY1NuL5GbM9VNUELBuj9UVucnMdoVpl4QZrCrxzHCqAmlYldJZFNQd1/xVuWwhMJmGcOYc5ractYXrdXqlqZbzML4XTb1qY01B/fJBgh9fn/U=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(366004)(136003)(39860400002)(396003)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(9686003)(6512007)(71200400001)(478600001)(6486002)(966005)(6506007)(122000001)(38100700002)(86362001)(38070700009)(33656002)(91956017)(36756003)(5660300002)(66446008)(2906002)(4744005)(66556008)(41300700001)(66476007)(64756008)(54906003)(110136005)(83380400001)(8676002)(8936002)(4326008)(76116006)(66946007)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?dsNnL73/uq8wqCQTeS98zeLp9xtylmqIhmXe0Pa3eXFT5H0yPxitH21eLpCN?=
 =?us-ascii?Q?HTWyQQbbGJTd/Vz+DpExUGahin6GIlXbJL94NXVhpT789DkL1gNcRmH/jcmG?=
 =?us-ascii?Q?caTkNDnwWO6OY1Kd28yHW+53J/iRUtRiQvJywNeityhmW5G5E0loKtHwT5md?=
 =?us-ascii?Q?oZ/7WVxmMtU06nSSwNmNoxmZh+k6QATNDFk14y1F05gsWSGgvM75YhiR4GQt?=
 =?us-ascii?Q?XI26DVuzJ0qjHDkVgdIjloMtR83JrdGsg3I8G+ySqARVgMWnwxDcgZ8ZUCFG?=
 =?us-ascii?Q?14nj5On40vevpjSFzN3beEWdwsY7Qt7baksU9Axrt0e6rNphyOGPdEpEOqZg?=
 =?us-ascii?Q?e2oG4+nqa7ZsQQuQ1kGMGXHj8bNCWhYNIuyzRiFna60Lc90qHiQBer8hMTuk?=
 =?us-ascii?Q?IY0cu2yVg5YUs++lj2hQWbp1sBhpWdlzLD4PZN1UIrOa5MKRrnd0xFLxJBhY?=
 =?us-ascii?Q?FUm2UFxGvNxzp/0lXtSZaJO1LuIg6KnfsDIAeMbiipMOgQNCyk8ebRZjQq0Q?=
 =?us-ascii?Q?1VM+CQrSQYs/7pvfS7nXMfw8jU0WgrWNrDT2P+63yP0IRTXIivfg0EkFOkbo?=
 =?us-ascii?Q?UcA9UzVpWcoYppjuWxjuXKd5jGbr0RjFuNDJr2Dc4orTEI5jIKyDGITT9mV3?=
 =?us-ascii?Q?TKxZ5ifh+xcjhArg3dApazgU9Fszj2s592DGMv6a1YXkd3JTus5SUsPq3y8D?=
 =?us-ascii?Q?UyZrvMylOqS09625htil/W2mUQe7U8aQbkSEFyDkEcbZR1+k1vDj3QJZzbyb?=
 =?us-ascii?Q?uY8AcLQz2oKeeXIJ1xnTLVhuM5GtL0KAxFsvhr/bQP05OgptnMICd9+3cADT?=
 =?us-ascii?Q?KBBlFjh7HoY9PcFsLIgPXqeJvbNCn+Et4mAxTaAoq/GqbzlGAtHKRuaIiNXp?=
 =?us-ascii?Q?chR7t34SbR3l7AiwI20+2s7wMMELDYZ8UOe6HaN02RSUilM1GZJFOkMAJzEH?=
 =?us-ascii?Q?VRpIJDn8Br6PVrNjzlpbyWndR/ipcX45P1HsVujFYSppCCHcaEDSChexjB5O?=
 =?us-ascii?Q?nISPi0cS/sVbD502P0nyMTnShp0VasfxgI6rzF6HX16JUQ2uZ5g5eEHxN2Qe?=
 =?us-ascii?Q?nKOrGf47ft3HKegwhDCVNm2Xhk5EAEJBwGTm+vwCLctr3S/bcLpHqtyO1DMp?=
 =?us-ascii?Q?SgyZTTWeKX8VyZOlKdcVGoXwqi4O4OZqK+upE+HO5Qtl48ZKN4BV2evNcWCO?=
 =?us-ascii?Q?mIv6DQpW1rkSK9ot0POn7hFyg4IGktz3AdxZZpT3qHLVgIWxSxKMh+5cLjRP?=
 =?us-ascii?Q?11NVtBhJa93LgiPNFbCYa+zMYfkwC+IREFBpbeYlTvDEfYjkPv6hLBUiYut2?=
 =?us-ascii?Q?Va/mCjSKHaUATAR215DWPjwnbA/3jUkRuOMyRXRYhcnNl81mWR1ln6XQGanL?=
 =?us-ascii?Q?GYZpkZZztKqgmVt+Wges+9rW/GykM3fIaeK4cPeVKhQM9g9E8bzL0Iv7rUwd?=
 =?us-ascii?Q?QUqU/8aaFbti9UXkjLF4Kt3/mbnpaeq/DlLjXXCZhvNmu3ky72+cKDaBIxDf?=
 =?us-ascii?Q?XcYtI1bFTtIek7lxVdJc7dHL3SoKbzVoTAy/VC6gSRMtr1PxZhj4U3wv2Hdo?=
 =?us-ascii?Q?BSeUKf5VBpnHyktSQKJX7JM9/Vgiz8WMhPrnfqHdgZckHrGJabGTjFR2uXKP?=
 =?us-ascii?Q?Dm62HXzccH6QNF8spTd/GvA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2BA2DDCFDB51F745B75EE5F6C4F60AE6@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e07f815-ad52-46b3-38d2-08dbf752f52e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2023 18:33:07.5548
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d1hps9cqUwBrzOSKHTDH6GJc3GaqWXfwraIc4y6XEi81GA8o4wYBwoKV/AldLAydb0ZV77NBShnWqapUlxTciA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4499
X-Proofpoint-GUID: Nt5pyx0xKSyi6fqkn59neTJuR8V-hd8f
X-Proofpoint-ORIG-GUID: Nt5pyx0xKSyi6fqkn59neTJuR8V-hd8f
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-07_15,2023-12-07_01,2023-05-22_02

Hi Jens, 

Please consider pulling the following change for md-fixes on top of your
block-6.7 branch. This change from Yu Kuai fixes a bug reported on 
bugzilla [1].

Thanks,
Song

[1] https://bugzilla.kernel.org/show_bug.cgi?id=218200



The following changes since commit f52f5c71f3d4bb0992800139d2f35cf9f6f6e0ee:

  md: fix stopping sync thread (2023-12-06 12:44:00 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-fixes-20231207-1

for you to fetch changes up to b39113349de60e9b0bc97c2e129181b193c45054:

  md: split MD_RECOVERY_NEEDED out of mddev_resume (2023-12-07 10:19:47 -0800)

----------------------------------------------------------------
Yu Kuai (1):
      md: split MD_RECOVERY_NEEDED out of mddev_resume

 drivers/md/md.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

