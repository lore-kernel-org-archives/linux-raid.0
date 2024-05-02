Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD04757C81
	for <linux-raid@vger.kernel.org>; Thu,  2 May 2024 22:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714687312; cv=fail; b=s6y9IJXB8G9y3MkrLufoZ0hN4ngJULwkSJk4+2dG7FeZx+EvlQbK4/jfKyPclOEdsFv1lp5eQBbFW5K6B/olnJ5cDlhdWI2ewaPZdiNimItT44+XDtlSLbBSrvBhFc1XK3HbCxy2XJGoQmv0cbbCb3memruQ3wqOG5FvgoBP1PU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714687312; c=relaxed/simple;
	bh=Iqt/Cfsfq2c7Hidzqqz4mmW6GTRpM2uUOPpEJZjQdMw=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=fO0k5VWbQvbY6z/+SJQW2iwWYCPBXaafG4xXS4vbppWZ+zflkV2Qml76ofXYDY/JDiSFaRlWQn28tWnjoJlT7bsIJvLxteZNBxa7hBablQy6GqaLN4C93viFwUpk+2AYnBUaMP9h9RKoZydT9NcvQzX7UruHx4PA9uBqnDqCuNs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=RqIPu7aY; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="RqIPu7aY"
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 442KuYpo028871
	for <linux-raid@vger.kernel.org>; Thu, 2 May 2024 15:01:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=qFPwcR3YX3HN1AM0mrv7EKbGvOeSAJEUwh4o1IO0NFI=;
 b=RqIPu7aYY+roSx2Z9Dv/NnHKPyb0UdpGZqvzaBWMns/1pUFOCywak8VekZ9CI+FCqkgq
 7DECI14IzqdPEH6LxH3T6LFsc1MnPp4YlYxftsySnnamtggqxvUVSJM7+iqKZgOPGEfs
 4ux/9gP/mZLQKIwQIjB4dYTnDAcK+zAREAfmH+LumoVyMvHDKGogeChCUKoUcRJCeX/v
 jMFyTloBbJSAvHypvZizviXfOSClzLaI/n1oP5NrJdtQQqH7wuaLuR/M63NbF019zc2X
 Y5xj64fCWnf02D0DApRE+eFJSV17mVzwibmNjjDdXK38cI2G8SQkOKMQsmEAqBGcgxzs uA== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3xuxu8f2vy-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Thu, 02 May 2024 15:01:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bE2tGLgbU2H9a/Wv4JjBognwd9prnL574kzf4Ttt73VuiQUH1cYf35EWhS4ArOEqxmBoQfM6s8pM2at6lp3YBunxUFM6Be/dLi2v5FjLqRfYzgUiBuLgfuv9RexKG7LxgX+LnhbuAVVWNJLjlMNKGHjenH8Fh7K0e5n+q4BsjgpTaSO00SRKmsl2tvcgD6hbGtT8FyXcRAWV5A+LamBL/vdaFITyDVueR5G+XMtqd4Xpok+seamrNPvEOtx/De+VMXFyK3gU15xnrOlGx/QaqYtqBvjoiZIFWFspJ0phSC6Sun+6wp4kJj4GYzTihhK1v6LhBWUxXH7EHFD/eK24yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qFPwcR3YX3HN1AM0mrv7EKbGvOeSAJEUwh4o1IO0NFI=;
 b=bRrml1Cb3OR849SU0lxMgZuRJehKqQdGk0UcFF2hSg+3YcvLUllHOYEucOxEBapuKIlSyH3ImjSU6jAFaCbH4sAeZqtRwWGM5oMR5pUwQ0Gxb4Finf5OdBBzbUkcJUu5vxNWqFNG19lfqhYR5/V+OWXaasy2x8wApbPOpnHBvd4DpHHw9enVKpFn/992mfCuCeHoZru7aBL7+QBAHdtb4ucV3zTsrluKz87bnEbLWOmFIFzoCvuYa+RVY+B9RHQDZgM1/Qb0YWKrMbLZFDfV2FyiXWhLTdP/4oNfzJfbenGjTJnRSq/ZKPn+cOB/hKYCq4J617u3818+yOA+afF35A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM4PR15MB6012.namprd15.prod.outlook.com (2603:10b6:8:184::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Thu, 2 May
 2024 22:01:46 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7544.029; Thu, 2 May 2024
 22:01:46 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
        Nigel
 Croxon <ncroxon@redhat.com>, Song Liu <song@kernel.org>
Subject: [GIT PULL] md-6.10 20240502
Thread-Topic: [GIT PULL] md-6.10 20240502
Thread-Index: AQHanNxT6L81UDEeTE6EgdhbA8MnXA==
Date: Thu, 2 May 2024 22:01:46 +0000
Message-ID: <B0747FE1-2648-42B0-AFDC-017BACB64588@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.500.171.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|DM4PR15MB6012:EE_
x-ms-office365-filtering-correlation-id: 06c37e72-ebfe-407f-bcf3-08dc6af375e6
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: 
 =?us-ascii?Q?VKd0YVkfj89aTv153NmPdjSVY+d+fZVhoJzfeAyAGINijSIUyPUqD9ekNaUg?=
 =?us-ascii?Q?XK1+dOViWalyLB/rFRh6a/uN8vtwBEHv/MvwaCt7IE2XFCupGG3RvJbEqBFU?=
 =?us-ascii?Q?ZkwD0ledPNqS2mxYLKBhzmkIhGv1sojUkGwLPGRCSDPhhaek2Ad49l/Q4sFi?=
 =?us-ascii?Q?wR5rn1KvF567AvXoDgK7XvM18NIO0mrI8YtChCAsSn6WcrbxMn+tf4gHxYe8?=
 =?us-ascii?Q?GN1cDVctdEufl/AoHPIHHw9GOfNGhwIA4ImyKVibboHTTkHn+RHYtYRjlwXH?=
 =?us-ascii?Q?gMUU9kIypGsHub285ecGa3Z1t5t3542Ri2eyvGBnd3c2jATJGP+39wVuoLMK?=
 =?us-ascii?Q?5sIOrLlwuzEs4Z5M71tMntVXV0ZCD2DUFnfcaBKIg6EMdcnKpMNDa4tFTz8/?=
 =?us-ascii?Q?G0bVPi9IkTRqJ2HQwp8YmkKwJ8+1kCVGcUb85koDxE4KyI4mLxuNFM2o7jtx?=
 =?us-ascii?Q?rluRBstjsqxT/u/8Kp53NhAo1gzGyb+8mIRRymHSMvbKTkuc+jmPT1hTpfEd?=
 =?us-ascii?Q?WkFJxOePLmgeFD9WCrXrybDA6ylnfE5i53gXoNZUPSmuY8KEpE2mSgRw25A/?=
 =?us-ascii?Q?ATLdx+9mTztO8jsbItqkXnElQncYpDJNBrhi1OA6CjHGg9H3s833mP7e4h6o?=
 =?us-ascii?Q?GWreVOaNzhvy+wVOgkIAsOmR2FjoOBH960eqpNd6t9kuIjTZ2DUfQRzhZdle?=
 =?us-ascii?Q?KXpFktZGbLiiHuvXpktG1aOrC3iHWfDQlH9nlwV0yPVJbdRulaKEn/5aEaWz?=
 =?us-ascii?Q?4wSK4jwUWgGnEy84pNZnb2FH+j/z6YRqYCjF55K7Ha2KEuXQjZUpsiMA/yFc?=
 =?us-ascii?Q?PWDnKCXRup6dGbTE6WbrKPkfRkh9ZmLnWLHPU7oPwF3ywmfVTi/gPZOOBVZL?=
 =?us-ascii?Q?ljedPH7qT3COoQyNXBc+3sGaSqvCahO22utKCd+TnkfRDXM/g29s4dU7MLNp?=
 =?us-ascii?Q?XMsp3DOJMaD5+vwJOunidtxbpL4DJVTBjWpwIZBh8m/NY/r8Aw6sKQUOtvU1?=
 =?us-ascii?Q?Wwz904J5wEf+W+Ph73uhmjkXgfEXIDNhzP5HRPd7O8DtHo+Dpnkm7bqDRJPn?=
 =?us-ascii?Q?agCBxglsqmqZ1jF2IckTJkQrIRTqwf46P3tJluM8dbEbHvBHMlP7+szClPGR?=
 =?us-ascii?Q?NQrk7nrCobRXF/NYO5b0cytxWsHFd1kq7mpDFDqPNSnN5Em/miYIYczxW5VE?=
 =?us-ascii?Q?ev1IJEzr5hOCfbTyNWsWSwO44owxjvNVeNh0nt82BpRuLYYHFih6UQpC41ex?=
 =?us-ascii?Q?nWJRXyxxrraLRhdN9CgAf9u6eQP3U74J071zlplRHA=3D=3D?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?YSA33IqKBSCIZVGKV386S+gatgol05TfvA3iiwaQ5zjf7Oe8in3sdouI657+?=
 =?us-ascii?Q?HuBI8hY0Z8aIu+0SPJjLyWw+HwKgTLNybXe2FWJOD0qbr6+lC/ZxW6U0SIG+?=
 =?us-ascii?Q?sVhCGbsh6VWms0DJYMAe67yPDr0Qnau89ldSoSpR2f63KbxQ0lG91po43CE6?=
 =?us-ascii?Q?oFejFUcK1EkB8Ks753nK3xd/HgM+csy8X85exBGIz2CSJKwzVn1pSoCwK5CN?=
 =?us-ascii?Q?h3q01E+ZEFulx89rXO10vLGAbOE8tNY9RYQFHe+au1WxhQXqwCteoleKp0Jo?=
 =?us-ascii?Q?5m5CqNApVeJYuB83knQHknFPoiPRNWMD1y09qECSutaff98cGDmCTm+Bx0iX?=
 =?us-ascii?Q?JPMbKXomW1PvEV7Dv+tgAkp7o8Qfd82+nhXdlYW7uIA3CvrADzpOUu5dU1GL?=
 =?us-ascii?Q?F/UYuah5pm3ZaR6s3HnMyMS5HNLCiN5Ks2/sL1B8EcpZ6nwaWLd+gd+G0IDY?=
 =?us-ascii?Q?1GQYOFnCJTnqeepToUvvtw37HFLRaZKlMR1up7la4EoFjVOIMXaHvbYR/gNh?=
 =?us-ascii?Q?8AlEeAhOtqJh5I5wefr2HbFQZCmTZKqYyc8DGJWwAp686KsiQ/bafSe+vY6Q?=
 =?us-ascii?Q?8TRIl84+6+FiHPWHC3pUo3ChQHbzXhEI4hcVXYc23+deD03VBYo0mjunfdR7?=
 =?us-ascii?Q?1309VEwCrs70pQIMATNo4GiFfjB7IvxAi3irtvhOTx2V2Zl8owW8OnXDaK2j?=
 =?us-ascii?Q?Ut/kUX10UmTWQug8/EI7bUePz+DfWqAekUohnAKqMZSxjRmHHPf9TqdeU2tE?=
 =?us-ascii?Q?mBwvgBr+MKzest1WLSnsEHJunjyU+GD6I+47J69yGJ9GfeddLH3kMagxJd5y?=
 =?us-ascii?Q?MTmGI9iSQGj+mb0cvAlsjWWXPQvFD2MlLPjL3jhej/tXr+GcS1HP2iOsEGz2?=
 =?us-ascii?Q?J5tSFxzZqsiWs1c3GWajVtfuigYX6QTn4kMDB1dU6fO8gvvLYXoqKouYsrHJ?=
 =?us-ascii?Q?+HUxwGkRltkO139ZalcVZuZisasnTdjZj6WIDnJ5GwfAJdb8zs2CFiKJ7RHL?=
 =?us-ascii?Q?QWqjNXKFPHRYMQrlGjtEjXLAJg1a5QvOQWoo7BUuLE43UoE5aaX4Zk4A5HEr?=
 =?us-ascii?Q?vPliLc5GU198ExGkNaXQ1ujLAPTkDNzct9tFZCw+oPeuwGALqvKz4YqaaJKa?=
 =?us-ascii?Q?Nindj6JcImTkZM9B1M0O8jptBxpzZIE06sHHDMHppdfCJ4jogdzdPs+YdlXA?=
 =?us-ascii?Q?I5K6ZqDQ0G5MdQ+sfsDhhd5/6RTQrYWmRVi+U4ih3EwSBOihUm5J4F90juNe?=
 =?us-ascii?Q?O5RuAQJF6qe6fLIIdUjEaKlue0uvXjaxeQAPx1NozUkGA+kYqjz7yjhs4Aw0?=
 =?us-ascii?Q?nh52xP8AkoncNXuYIho+0uXY8f9gLwJfCbFb8PwOZvKfviH3AUUkn0vGOeja?=
 =?us-ascii?Q?xxNn4Tzl9PdYR02hmOQkkZmGh0v1FzyGnfOyIo7ljqiYbE9Dnj/6kdavdJQB?=
 =?us-ascii?Q?BWqr7otAIjdYYlfZ8JRbdUD1n+quQUWjUecg2200TVWa2k6HqXAuXlcnaIsO?=
 =?us-ascii?Q?vKdGBN9Z4r2oOFSoL0pVF3579YWRhQEAtq/2UsP4QDIcYKhGE1y3pAsj9soR?=
 =?us-ascii?Q?3sRAMFOIZswdnMFoOxZl56uP14KlJN5jSNnoSutPBU3JwyLCxh3dJu0tDUSk?=
 =?us-ascii?Q?4Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AF2F4E14BC241D45993BD2D5A70D4A3D@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06c37e72-ebfe-407f-bcf3-08dc6af375e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2024 22:01:46.7239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RBsYUvp4nycGPiw+re2dfe/3lqVXrF1JUs8RE4EbaNLSzyq8TDgeFLCmjTJFAkN7a8iOWZX5QZj4xf3pAOLVZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR15MB6012
X-Proofpoint-GUID: mnLuugcmIXbg_vsFM5xCE6HKWyce7e9x
X-Proofpoint-ORIG-GUID: mnLuugcmIXbg_vsFM5xCE6HKWyce7e9x
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-02_14,2024-05-02_03,2023-05-22_02

Hi Jens, 

Please consider pulling the following change for md-6.10 on top of your
for-6.10/block branch. This fixes an issue observed with dm-raid. 

Thanks,
Song
 


The following changes since commit 9d1110f99c253ccef82e480bfe9f38a12eb797a7:

  md: don't account sync_io if iostats of the disk is disabled (2024-04-08 21:15:46 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-6.10-20240502

for you to fetch changes up to f0e729af2eb6bee9eb58c4df1087f14ebaefe26b:

  md: fix resync softlockup when bitmap size is less than array size (2024-05-02 14:44:43 -0700)

----------------------------------------------------------------
Yu Kuai (1):
      md: fix resync softlockup when bitmap size is less than array size

 drivers/md/md-bitmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)
