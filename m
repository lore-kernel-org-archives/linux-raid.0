Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="VyeJp7ry"
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B06BD50
	for <linux-raid@vger.kernel.org>; Fri,  1 Dec 2023 15:48:45 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B1LESa9008317
	for <linux-raid@vger.kernel.org>; Fri, 1 Dec 2023 15:48:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=/5fXw8Xakxn7tv7yE3tYuiNVuzAwsZFsGvA1oH5T7QE=;
 b=VyeJp7ryMk4U6/ZpzZGV8sfgKUIa8qBYtK/ykjyTPTtDKG5fS4OHzizmkoQNa7Idym3n
 F1uqGBfXPLqgENiramVeG/u/E4Y36KKb2Y+2h5gkdrIYLmnE7etUBZm+nYfi9iUWjm1E
 ElO4iEjjgTsdHKY9CR+l+mkUxXmn0HVXPnOsdX5DjmYs+r3Klz+iStvf0G6UtX/K+rl/
 0ZQCi44C5EXq1dD96X8uyd1VT/8Lt0sIMRfNfnsk9KnuJw69KJXH8Cc+Q37VQk2vQrVy
 uXoS3S4VpXovYiHOvyXFS0bo+H0H1oGh1r57JtFUL5xhqUKMK8b1AGzwK3mJzntFQejH IQ== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3uqb185f9v-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Fri, 01 Dec 2023 15:48:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AxLBP8U1eNndLvPVRASRRBRJNkIGz7Qs4mRNbbIHLY8deigSKQnOCtT5W188SBBDkZcjTuWKMRqMf4fWSPrHYDHGgcPoxf7jvMeDn+p40YaVAV5QnMM8vxM90Dcj5qKZ0PenFiYrZGbls85VEVP1JmodK2V31ktNRefnvf75shNKCsP4cIvZzSBhCo+/W7pwZmScy5PJwmGsFCXi+uSPrrEKjr0FWTOHTUFzS/tmzNEI/pCjq5qyt+cGHjlLjx6+4Hyltib07UMGWuuK2TqCYKrOgB16WANdy6nTzsWUMmlOTIaZIFNEff3nBS37b5GNaeatOUk4Rs8FO2T3X6P5sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/5fXw8Xakxn7tv7yE3tYuiNVuzAwsZFsGvA1oH5T7QE=;
 b=EitPejqTWAbl9RcEGIul+DijiiXL1hiclmo+xIlS6x7UVQooKW2PrykL9E94xqLv0EnnBflR4g5IoQXTv03ERT2QEgV/MnUU4I7JdLW0pwNWPpFCTDp0JWszem0qB+/TETo3eyRoCNVY11phpd1EOgDEc9x07d2kUINCsUcgUqu+rJozl3wEKoj3xZeK4usIGhlBmkK57AiHTmLAJ9+JTmnvsCxGoQqVPXJIKEp7m0LrzNtvcG0tipZ/Xc0vXLn53zElKp022nVJBWfdwohfFPznA651SC50bzSf6UhQeM9XeexdP4gmrRVvO4fRYCEabkQ4yxyf6t4bhPbdOrI+Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5797.namprd15.prod.outlook.com (2603:10b6:806:339::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.8; Fri, 1 Dec
 2023 23:48:42 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::9052:3362:76e2:146d]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::9052:3362:76e2:146d%7]) with mapi id 15.20.7068.016; Fri, 1 Dec 2023
 23:48:41 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: David Jeffery <djeffery@redhat.com>,
        Laurence Oberman
	<loberman@redhat.com>,
        Yu Kuai <yukuai1@huaweicloud.com>
Subject: [GIT PULL] md-fixes 20231201
Thread-Topic: [GIT PULL] md-fixes 20231201
Thread-Index: AQHaJLDpshiGjfRnAkKhgM96iLPx/g==
Date: Fri, 1 Dec 2023 23:48:41 +0000
Message-ID: <DA07D7E2-9386-4816-8EC8-4420A026181A@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.200.91.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SA1PR15MB5797:EE_
x-ms-office365-filtering-correlation-id: 6016cab5-974a-421b-cc07-08dbf2c80c4e
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 zWxDyyv5bBZ+a28rsVLn8sJ+b5nP7TaF7Urguqvxom0WOOOTQlDkRejaHXCVlXnwJXRCCIBNbEvS1XQjPCbJytBOlc0kMo45oXg5O/dLcLYhqjFEwdiIMxvV2LqQP1xtgbhiRBSrV37YTbXEl6/01tTXkFABt4QsCPZWfFP8Tqf6b5CLg/9e/Xgw35fXyejfghy/w0xoGLUebYOIx+t1W393eGQyq1JM720YCF5aRn3YO4g90Mmbg0wty/XUlHE3diOFZ4Q1GmBmo6BAwKhS6OdQdzvPholk57f+VSFE280xx2GzoJvc1+XL6ADlp94gXaCwzHXWmTtN0V5stA9DB0Uhfon6LoxHYvuWdjcHYoItzYEQUAJanWWSxdFzdHeDaZsud2A8/KXwPQtqehp21n33IMy3a9+qo265lpXqEwlRkBNxAD/lqs/qaQQQ/8PXHNrMyk+Gcw02A16JnVa2PgtdiGgGPyZR+T/PmYnm+8JMvZDP9JH7f+Jb0XuxRkBW8akD9r/jH/4lvsQUJTd6AahCCmbKIXgX/kE2otg9OEvHX0ALdM6BcjYAf+ni2Gxr2tCigerg+1slAK5yaxO2/NQK4dckZl9r7nB6+5Yxfmc=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(346002)(39860400002)(396003)(376002)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(6512007)(83380400001)(64756008)(122000001)(38070700009)(76116006)(54906003)(66476007)(316002)(66946007)(2906002)(66446008)(110136005)(86362001)(66556008)(966005)(91956017)(8936002)(8676002)(4326008)(5660300002)(4001150100001)(71200400001)(6506007)(33656002)(478600001)(41300700001)(6486002)(4744005)(9686003)(36756003)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?6XTn1xaCbUfXXogdZDOE5bneQccWW/Levt4IQEypDT83rRgQkeTlvL242MvF?=
 =?us-ascii?Q?o8xPHZn5iuaHywp3flXbuXJa2TBGrbAAYpudXY6Cdxs890nbNyy/QCEhk18m?=
 =?us-ascii?Q?hrYVTcrHCn4G2hw6gG38viH2XRJMU6KnMvsTMdNzdvSUT7Hj2tymKW/RGyt9?=
 =?us-ascii?Q?ixVCbm2w7sjLha9bwHkCQ1ioauVR69bQzL9lImldLP3R5rCq+b0d+iG07QG8?=
 =?us-ascii?Q?HLO9ZTJRbV0yA1PObA/FjlaqU1tnwrS/WHE8VE78yVP1wdA0B1gEVi16N1n8?=
 =?us-ascii?Q?6/afL28iHbpBOznA2p5V5JUzlWr3Wocl4bZVnd51nyUaO79cBxrmbD+pol9M?=
 =?us-ascii?Q?Agn3xb/mnntJIxSdRW+DRVHpW9rBqkyW/Hz4QvEt7yUiBwleoLlq1ASstnxh?=
 =?us-ascii?Q?d7vZl8k25c6aNriihoWqy7GGnCah59pirQZIF9m4jjA7MIoVwle633vHONXj?=
 =?us-ascii?Q?LGqUqaqlmpPso75Je278TuHv0VOo5B0xcVIK29udqsSv5ZNk+8uMcDzFYC09?=
 =?us-ascii?Q?qeFJOll4usvifCevFfoTtN0obQhml0ViFG7QysGt0xONIacTqa6Uvj9e3L8W?=
 =?us-ascii?Q?1Tl8CM6PDAuZcMIxH2noG99JAYz3QLTpcA/fRi4pgQUlgw6KFl+sgTvQzMJc?=
 =?us-ascii?Q?gG4NSX5pXRawtv+IqkMqUGIp3AM0pBnH9wnOg2efyRR1pIWa8ljYofCX360A?=
 =?us-ascii?Q?RcECRymQRfA2ayYP873cyLRSeYbxyduyTLDkx3jZ1W8OGAhNXrxfaZHD19af?=
 =?us-ascii?Q?QS+efoownSpdQzQnjXOE5TJy11yehCP5B45k8ir5XiYKCtE71GgE4oLZ5N3V?=
 =?us-ascii?Q?SrwvDmgu7y+wD+qxNRmlVBRZe1TTWDLuIBCcYP+n3aKgWh3k1KSDx2AD8y08?=
 =?us-ascii?Q?zPo95kZ5OyI9nS+skpbNtFYn6ghK4stNQJPkEfwvR35egffka5vbDC7racB7?=
 =?us-ascii?Q?HqzN6tN2CxWefbI7SMEzk1bANmeV4sYVXvC+ghz+Ry8DER0zdvEEqQlZpt0y?=
 =?us-ascii?Q?QRV45iNc8tZnbzVwXb/kNCRABBPdi3tu3nEQRul6Sgqx+BEMOaGfJ520BO51?=
 =?us-ascii?Q?HVfIlPLtFryGBWzTKHRPfrwCrlaNWtvYSKGODLF4SaVGXPwNNdeeHFJZF8Eg?=
 =?us-ascii?Q?eA+k0Ycp8KnfFZoes/ahh0+27KOJaRUsGkT47iRHSx9EmZ/GlCobs0wTq8GV?=
 =?us-ascii?Q?Jjc398c3B3DMneMQp8+bpl2aPc9nhUk0LFyzQh0bF6DxGcmHPbBs5fA8q6Rh?=
 =?us-ascii?Q?44dbZRbLyI5vNyyCsEKkotQWkqOsYAwsO9yIHe39UPwqZC4zLfMdC5ZZUh5V?=
 =?us-ascii?Q?BilGFPYun4CB0PBzcD9xmg1EXskPmq4Kmeor+dtERA1GCzhxDxsk81nfGbzI?=
 =?us-ascii?Q?J9k6cuoZ3f4RRvEdmEcPo9zZAH5icvxS6F6hMfhZukJWAAqNnr1/ZH6dqxhl?=
 =?us-ascii?Q?ZSo58bXiGVMKEFUz+uNl87Z55jYjLr+OifCfaG56pXshfH9TOH1oCyr8Anuc?=
 =?us-ascii?Q?KnJCWidrsHojML0ctEx1zpeflcYaDU1uXBjostRxRHED0naMctZ5kNB3XTM6?=
 =?us-ascii?Q?yDKt3cWmVpsM3WK803VLc+4t+rT6hbyj5T774sSKRaGMOw0/aO+3A7EV03cy?=
 =?us-ascii?Q?lw6ntRA0EMnKgHVmssQ9p8w=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9E32AA4653B02D42B2F4EC71170D9F9B@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6016cab5-974a-421b-cc07-08dbf2c80c4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2023 23:48:41.6471
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nd91mtYyyRKzXQiK3I4HfdOpJ2gCOoQ/sLIey0/n3tfaxozyqGFfKIochiw2l/GdcLur/U/iUgGaI2OLAiSQBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5797
X-Proofpoint-ORIG-GUID: riXYVmFPt9z2ciDUFGsMqMxFwySq9HIO
X-Proofpoint-GUID: riXYVmFPt9z2ciDUFGsMqMxFwySq9HIO
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-01_22,2023-11-30_01,2023-05-22_02

Hi Jens, 

Please consider pulling the following change for md-fixes on top of your
block-6.7 branch. This change fixes issue with raid456 reshape. 

Thanks,
Song


The following changes since commit 45b478951b2ba5aea70b2850c49c1aa83aedd0d2:

  md: fix bi_status reporting in md_end_clone_io (2023-11-19 20:51:25 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-fixes-20231201-1

for you to fetch changes up to c467e97f079f0019870c314996fae952cc768e82:

  md/raid6: use valid sector values to determine if an I/O should wait on the reshape (2023-12-01 14:43:29 -0800)

----------------------------------------------------------------
David Jeffery (1):
      md/raid6: use valid sector values to determine if an I/O should wait on the reshape

 drivers/md/raid5.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
