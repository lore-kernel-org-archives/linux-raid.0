Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BEB3D0AE
	for <linux-raid@vger.kernel.org>; Tue, 19 Dec 2023 22:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="GRyCxn6F"
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJLp3MB014141
	for <linux-raid@vger.kernel.org>; Tue, 19 Dec 2023 14:42:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=0N+R071JqgXDeucQ42PcvJao6wACVaXHcb6g3BaI7zU=;
 b=GRyCxn6FbdiX2sm4dWAiLyu++tNQgB/cfdrLcQwj/tQhUH2Z+7UpsWhcHG8zmfmSZAjJ
 gDljMi9gwQzITCCpbTXdvBpZuPI+yE+MoYXL+GiO/x2ZteUATKyzwcVHsVsn2AIK6k3/
 uY7tyEf6JR8JOP+eNhfj7jCK6iNr/Xp7IAipqDTLhx3QKxlbjH5ptdL2fpTf5IDJd5+6
 Ufm0/uOdcpQKDwi5AOdWENO45W+hklONkDU1O0rYE78pe9DD3SL4IfScWrMkewzG6N+I
 jZmQNM8bblCl7+wkxktxS11FN+vwIt0I/jHyfYIIyojsgYTzLA/O0YzdtasGt5Qlr4Jn pg== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3v39u54p5k-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Tue, 19 Dec 2023 14:42:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nrLudqwb+zSEczcafTD/CgWKI+x6WbESeCHXmLOxC4RnZjq60VgVsgIFv87dD9b0O7+Bh+Hl1JFaMaW+ZNql4kGKZIepvvZVT9QdydDXVbo+V2xN9PQYzJLL4aOSxk7JNq/yxA3G05+JGi+5xMwIQNR+uBHv2ALRSIas13cFCFS4Npg4UAK6TVsKnkWB1YdEUvjtc9ZD97Oc43gyQX01zTvBymZPXJrJsSTvvZOBvjOHjgnAYi4iO/TlUyhZh/Ks8x5NDhJ4+Tp+iRe6sALfTiPatzaQRlwamkCA+CONfh482mIPXRedDLttrmvPelrk16TnyU34uVaRmcwfniDYGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0N+R071JqgXDeucQ42PcvJao6wACVaXHcb6g3BaI7zU=;
 b=inOSLfI8HOT2WwJ+ZqR+D4QzcegWYrxqvg2Bs1Woum2siaFqUSzIuttxWv3g8ugpsx04W2WPvlxWi2oAqDFMcLb9OAfYOHGdxOZk4Cda2efAx3T0NdAlrDJvq1zQ0TR+mJHqV/AHdSIIwXTN/C+3jFoIEsq5TmwiG7R1FgE46fS39sZ/C7ku1s4mtB4vibFJPKYgcrezQQGk++aFd8LkwXUl2UOAQ68Oc0D84b7VLNOCINjO1Z5ONVjxZKyAY1NJp4iFkd+U9A4lrcKbKJ7Y1iMg2bhxTv5YIt70kb7WbRzeyWuZTJzV/GDxjN5YnPsp3rt3DPwuLB1j6Ksj276aJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by IA1PR15MB5982.namprd15.prod.outlook.com (2603:10b6:208:446::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Tue, 19 Dec
 2023 22:42:41 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::9052:3362:76e2:146d]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::9052:3362:76e2:146d%7]) with mapi id 15.20.7091.034; Tue, 19 Dec 2023
 22:42:41 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: Song Liu <song@kernel.org>, Li Nan <linan122@huawei.com>,
        Alex Lyakas
	<alex.lyakas@zadara.com>, Gou Hao <gouhao@uniontech.com>,
        Yu Kuai
	<yukuai3@huawei.com>
Subject: [GIT PULL] md-next 20231219
Thread-Topic: [GIT PULL] md-next 20231219
Thread-Index: AQHaMsys0Us4eyOjqESlYinunwNbqw==
Date: Tue, 19 Dec 2023 22:42:41 +0000
Message-ID: <1C677396-6F6F-4930-805C-1C79CE442BE6@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.200.91.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|IA1PR15MB5982:EE_
x-ms-office365-filtering-correlation-id: 5e8db8de-8d71-4c25-fd3f-08dc00e3cf15
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 DY/LOqQvl75uF1oCRpAvLQKCpm2aOHw5I7uQHcF6W70FjQSRl4mRMLHmrNNWHZT2tSJ0K7HdBCqI1J0c1ENEIUq14OKNxS7YENdCHpVTWzYGgI3/Lo82jOHTwDDDZC4GLgk1s5CIZnep0PtfZ75tsDEA56A5FhuU9YSQL2/GKttkVTD6omYP7N/avZbpW6k6trUuKXO3naE1r9JQi0H17UprJnV7R36Ndw4HhjB2YCaA2LMgZDB1UfpOQbkN2n652UPmM5Eie4PyYUKw5Q0lIdWwcuarLxBGs2qV0q0deEnYVUlkcinMY0RpuBfpgbB6NRGz6EwYVg/JOQYXCdX6D4xSbjVnhUatiE/Xjjc1Lj+gru131xGT9UW9Nngunvrbs58YS0CDU9/cec2bDRRFrmy424CWEhgcaZ0Rd5+PceeVz1MDLh4YK+fDWBIMKPQxKBjAZQMfiC5gcqdcudysYHdLDH+R9/MiRq+BTbWVFtmKwHC/Iv2TPRnqIxV+zP1oCjHLySNf+NfSCWpQahhXK5WLK3PWoizqxqiYEPXzGld9PdEA0tct8SN06MyEGTNy79snbPMVDBuXOqcLBUqLPLgc8rDyxqwKkp6Ssm1eMOE=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(136003)(366004)(346002)(396003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(122000001)(38100700002)(71200400001)(83380400001)(36756003)(86362001)(33656002)(38070700009)(9686003)(6512007)(6506007)(478600001)(316002)(966005)(54906003)(66946007)(110136005)(66556008)(66476007)(66446008)(91956017)(76116006)(64756008)(4326008)(8936002)(8676002)(4001150100001)(5660300002)(2906002)(41300700001)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?22+7iITTnfpa1hPGU89ZxCv7jSg/owkf7/2AhBTiN3htcyUUO8Wua1nzoCl0?=
 =?us-ascii?Q?0YeJ4WvnH9BYv2ZHa7mIOSR11/c41yBE6hirvkpdLAlNut+G9alB/zv9P/mu?=
 =?us-ascii?Q?OFpa5pcVP7RPI7otoitWmXIihchAndw3ew6TDuTKymY2zhFy49PNr5NcQD+D?=
 =?us-ascii?Q?VOmfQDpx/HlhvkJDgcErrskib0yz8GvNAH0mesoRLpjCyeWjZElUfyZ8mJcj?=
 =?us-ascii?Q?4fYWYh0hnR64S7k2yqb6jTVeNlMXT5eTQung4RCPmcgiaKGz3lk9G4RqPSlq?=
 =?us-ascii?Q?Mvgrt5RxS0doxgJgwGleweTFhbJgLHbtJgqiyOGZBWK1gdqZ6LTE9JXFtGN1?=
 =?us-ascii?Q?ELn/fKotb272nP+AfswZhyqg6+eFeqYtoZlWN6uIIobVLHLNNNCEGGXve9dm?=
 =?us-ascii?Q?Hf5vNlU1P9VZmdxTwryWnCbzkjvw1zzwA/HYnPQzO/QnZlT6hVAssIgfTMzu?=
 =?us-ascii?Q?2ZQyBcBeV95iPa2KpmOEOeqrpJS6LWxR745ZLdKnsKxT0ROxEo11xERX8xhY?=
 =?us-ascii?Q?lKKopcqB1jvjd6WSPpyuSfbYXV6z1Fh/+Ckkwm6JU6LHphkeXdgmjEJCZR+r?=
 =?us-ascii?Q?Yt3j6dWJPElyvSBljRqR+3PtNYurbgSoRrO1N+50HpQj6KR7BmEIc8kintav?=
 =?us-ascii?Q?Uv/HpxGm2vc/doMzGAg0RjpBUiqt4O/TgYgM1Vs672eKZ/i8gnq/tHD+aWh2?=
 =?us-ascii?Q?BniVvHrLv7f6pYX8F+wt3QpTlJ0o7lgZNcdkjI5QapXNqp8PU3Dzy4z7Y9aO?=
 =?us-ascii?Q?Vd1HPbzA2wAqHnlmBSzhMFmnj26/tOge222tlTlTMLLWiBSWah3FdMfsTcNg?=
 =?us-ascii?Q?+jAY+gRTVT1ZLZMf3EOnL7+L02yZB+SW4T4l9+gwpflqIEN8VLODw2QPhtXw?=
 =?us-ascii?Q?pLXaU/5pkbDvzKHUORZ0M7M2tPC+Se4kkpIJVRA3/0RlcNU3z5JThWh2gqvv?=
 =?us-ascii?Q?qIFikfvVsPY0vJ90Mz/8Z4+5ZYE5wJUo/6HdRsAGsd29S3XO1s7m2eYahECe?=
 =?us-ascii?Q?7jETmd3F575+6/EEdB8sO2Ki5MWqBbyVZhVFZjT4iz8DtJjUklQZ8540fzjP?=
 =?us-ascii?Q?/u/zdY1QfpVUsnPx4C8i69i0mhpbnpN8Fvs3bieJaLNOhgjvcCzBGsvU8uaF?=
 =?us-ascii?Q?P7pBCS6+nG+adiKniJGru+zNkfiWQCsuc6L5CmMOjQn39eJeyHAJvvKy228k?=
 =?us-ascii?Q?iUuaO5cUVxZC1j4Tw+3ItdhtktICj4I1bflMNeNB3nKS18Pl/cj5eeGfNhZB?=
 =?us-ascii?Q?O85XXFgoCjQ3iAd/gW9DgP/QsZnEG7/jpm2xPrse3FeeYSMWHlqQ4PrMDhdq?=
 =?us-ascii?Q?q+46MKkow2vXUzAsmNGxeLH8vclf8fp3QunWp2O0hNL9TDRTcKFXEqsHPBqz?=
 =?us-ascii?Q?y+ZUPPFdLnj1FNctaY8qV6eQFSxH5kLFGzNYNWu5/c4FuM+NX73OHuTWCPHs?=
 =?us-ascii?Q?5Fm49GRuZoqyM598dtS05LZTpMI2bGxTPIdZu/NKksSP/lnuVV+k+xxmuuTU?=
 =?us-ascii?Q?TrGiE17WP2NPPzUFkNT8N8CcJUgAA41wFAEaJ7lbGKhcc1Oaa/vlLsRqlM10?=
 =?us-ascii?Q?ogtUwWV1SKTUCRe9jQHmVRAn10CQKekLJHRgyGK/xEMo29R7osy+BpVo63Lc?=
 =?us-ascii?Q?2GpJencN7a1ajH00NBP1g8I=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D9E65016A2FF694DB80186E355C6841B@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e8db8de-8d71-4c25-fd3f-08dc00e3cf15
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2023 22:42:41.1145
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZTLyiolQqyGIT7VUp/uL1kkTTiuAv7SgkPFdWXKs3k3CiM4lxtkmU7NB3eMX4z+Mvqji9j5iygAKbZx2ay9J7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR15MB5982
X-Proofpoint-GUID: zV4DhvPdAAqG0tWhgf0aMF3FfNh4IYPB
X-Proofpoint-ORIG-GUID: zV4DhvPdAAqG0tWhgf0aMF3FfNh4IYPB
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-19_14,2023-12-14_01,2023-05-22_02

Hi Jens, 

Please consider pulling the following changes for md-next on top of your
for-6.8/block branch. The major changes in this patch are:

1. Remove deprecated flavors, by Song Liu;
2. raid1 read error check support, by Li Nan;
3. Better handle events off-by-1 case, by Alex Lyakas.

Thanks,
Song



The following changes since commit fa2bbff7b0b4e211fec5e5686ef96350690597b5:

  md: synchronize flush io with array reconfiguration (2023-12-01 15:49:42 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-next-20231219

for you to fetch changes up to 415c7451872b0d037760795edd3961eaa63276ea:

  md: Remove deprecated CONFIG_MD_FAULTY (2023-12-19 10:37:50 -0800)

----------------------------------------------------------------
Alex Lyakas (1):
      md: Whenassemble the array, consult the superblock of the freshest device

Gou Hao (1):
      md/raid1: remove unnecessary null checking

Li Nan (2):
      md: factor out a helper exceed_read_errors() to check read_errors
      md/raid1: support read error check

Song Liu (3):
      md: Remove deprecated CONFIG_MD_LINEAR
      md: Remove deprecated CONFIG_MD_MULTIPATH
      md: Remove deprecated CONFIG_MD_FAULTY

 drivers/md/Kconfig             |  34 -------------
 drivers/md/Makefile            |  10 +---
 drivers/md/md-autodetect.c     |   8 +--
 drivers/md/md-faulty.c         | 365 ----------------------------------------------------------------------------------------------------------------------------------------
 drivers/md/md-linear.c         | 318 -----------------------------------------------------------------------------------------------------------------------
 drivers/md/md-multipath.c      | 463 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 drivers/md/md.c                | 239 ++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------
 drivers/md/raid1-10.c          |  54 +++++++++++++++++++++
 drivers/md/raid1.c             |  20 +++++---
 drivers/md/raid10.c            |  49 ++-----------------
 include/uapi/linux/raid/md_p.h |   8 +--
 include/uapi/linux/raid/md_u.h |  11 +----
 12 files changed, 201 insertions(+), 1378 deletions(-)
 delete mode 100644 drivers/md/md-faulty.c
 delete mode 100644 drivers/md/md-linear.c
 delete mode 100644 drivers/md/md-multipath.c
