Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93716A012
	for <linux-raid@vger.kernel.org>; Tue,  9 Apr 2024 03:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712634213; cv=fail; b=WV4n2tjL/PYbblib7pSFfazUis0tbYV2+fgOFXru4R1IEB9KkZBNI4L8Z8YpoYJ8bpe/x5UcRZZVZKAkkbCOPkwLDIsrT66HJ9qaSk8WUp/oUjVWaAR8qOnGedPK8uH8hiT1CTH+bKMkXwQUkqncmrDUZyU2NB70saGQrSqrA/4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712634213; c=relaxed/simple;
	bh=hhy/X2WT8b/tXOeOO4m2rjrfpICcYvaK1RqFPxDPqZ0=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Uf5Y6vLEcXZdS/0o2bDcYmPFnTq+lcecY+T4XLmcwY8rzpVyjEen59x9fDn0vEbyASzFWG80L7zN5lURbooKxclQnj68dlXkMCqxa8mMq8+3KFB0qnCP9ZYlzsRs2/iIhhsPGg+SiW3IUa7XQy/+funipk4GAFVGEMzSyms5ic0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=empGqpAN; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="empGqpAN"
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 438JprU3028048
	for <linux-raid@vger.kernel.org>; Mon, 8 Apr 2024 20:43:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=8Zxxiwf7/lElBFKbx9oZ7SEPn/s07kL7rpfbaVPdl6M=;
 b=empGqpANpHhYVD54UZSCuhfKpcPnU4HBlUNdfV9B9EAx/DX8+uQqmr/aeonYFKEW82du
 GW4GPsK5sr2BxksaNWvEJUcKykvaBGqsEzxvmoeZqpSvubK75gBkWbwc11Fmq+r19039
 uloUTveOSUgZPIFZ0gHCTS6YKginn8huwX5DYQCGy4p+eE1YAAgwk16aMy9+MLelR6Qg
 tirYeBIrmXjkZq4v9CroHfVRxBx90Twx4S+JS+ufHh+WbPd8Zlx+4wWucnZPti3+JFG+
 fy3rRzx9OoJsHqlgt0bCek5jMQwU/v1oLBPxOkZ45xNCftFS3mNJqINSWOzEj7W7JYT4 hA== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3xcfsqd2nr-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Mon, 08 Apr 2024 20:43:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W2gYb/M0tashpxwOiWZ6P6jCAUXs0EENhZ2nJtImgg3onPun47eqnx9t2GxFiXpU9gyYwBL4Kkazyk4CPFLR5QOO2Vz9gDk0zWSum5G76u0+ktcQqjx6i6CRPU/CRfY8INgq5qTi/wPn6XGyuHuCqNvuP/UjqoTUYRIrlXueBe8dK3qFThyHs/L8/yhs0vH/XCO+9gQ40vqhWnhGxTHdVePxtCc84nw87jMYN5eMr3DcwNbWs4WUgNrLOQrPVBSvSTc3bTGkSEwlYbQVSEDopOsxCCbPQbM0nKL2LGp7evP/2zfx4FijmnOAVmFDPVJzYWtKTGp0j+l9H51Wu7PKNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Zxxiwf7/lElBFKbx9oZ7SEPn/s07kL7rpfbaVPdl6M=;
 b=G9vATjkPJ+ZW8oGIuYRcbHGG4uVWLo5UTlwcqUyS69z0L903bA9MEXWmhUmVb+w+cWiPwS3sDOsn3y5Gx/go+awzLHNQUxOJeY8l1tZmEtI0IBl3RjemL7v6DkBObgSi51y/A24QrWBzr9LXpN8aaUePfdvL1xjnNP5fGpAXJRbdlYP0e24gTXe3OAyWq8sT46RaD1z9Yt3k5CesdiQM2LBcxKQxftQNsnuDUjpyAjdUIOpzUyX9MxO5AjdNE99CZNRKWoXUv5Ec3V+Z8eMV3ufF/3k4/iYZED91xqjzjiV2fVVvNlLEK8h2sgh2C8SdIpKRn/jXq0o5TFHdGLwEUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BY3PR15MB4850.namprd15.prod.outlook.com (2603:10b6:a03:3b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.54; Tue, 9 Apr
 2024 03:43:27 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a9eb:568b:32b:af06]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a9eb:568b:32b:af06%5]) with mapi id 15.20.7409.048; Tue, 9 Apr 2024
 03:43:27 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
        Coly Li
	<colyli@suse.de>
Subject: [GIT PULL] md-6.9 20240408
Thread-Topic: [GIT PULL] md-6.9 20240408
Thread-Index: AQHaijAUxJ6nIyT7FEOA1AabE8gX1A==
Date: Tue, 9 Apr 2024 03:43:27 +0000
Message-ID: <60F0AE23-EB1E-4EAA-A013-DBA0EBE77E15@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.500.171.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|BY3PR15MB4850:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 zgZqGZeiiJ9VSo8B4/DdZujc5VX/M0rycXQTl4yiC+k2rx88DjdCZa3rdtnkK0DsZzJgnty5Wj1j4O892DKZpY8XPwYSqbi36vxkIjcyu/SgeQ9to2yrbmnSthHk3yFcK8cLRyaxBrfWCxV9axAosje1/tuQHlnbBM2TnPeEcunMXPPH0IvH0j24IR8sv1G1AY+eqNmjGZP7tUopuJa9/byH6gYNAfNBsJl5S8nk3GPVgsrxJqT07h+LcAKu/XTRvVqEKnJTZ9+X70c76D6ZfPR2GCvsrDAS7o5NRdn4ssXvSRpgGzwdSDV76tBGcekMLJnI9JQwcFTtLTobIIvHTX+wWPEhn/6o/9TfXtfs7CPKOTHjEz0qGH8I0crBw4zLWw2EE7YHBpzyRonhI31/CME7VU7LYDU+Eq1domGFhHlR45NKTXwni8LL/eQTCXyqpmlLSMJ52CaXq4AEb7iJtCCoKr6L5fBzMsC7NJh8DP6KDT7U7+HJZl2g40krbmu3CaEAjS3QRP/1Y1brMEg5CGEIwNhdGyk5TjZtkQI1mkYyfTU5ds/PkAiKggTDANs24MSS+9/PPsvl+MDEL31Q9+ijVOIt0sMHRW0tBiivovI=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?64i02bA1L8ELMkUgYZxaO94173IY4skXVDky+2RO9pKqTFGLSEyKF2cpqOoc?=
 =?us-ascii?Q?QYGGYbaFwanl5/2Hf198P59OqzYNVBseRlGTqOhD1pW7Rid67+n51cKvLY6T?=
 =?us-ascii?Q?vFQkqs1acWPg018kLVsqwcLKqPuekwURwkAwBL2XAvPP1ynAetdBsukygzKM?=
 =?us-ascii?Q?YKy2ODKsHiZSvMIfTG1oawuzytC05sZ/RTawsGtn+8ZHSlCsF0d6UCO85api?=
 =?us-ascii?Q?Ynp/gaETY2JhwvYVqqcDDjfRn9UILzMYR8fckaVsK0LGwZj9RiUi3PtIQ457?=
 =?us-ascii?Q?RRKUSPEeYC0RzhGrZSwCJIO8gujR3hEHGdAok3MWjlBHnxh7NPn3JLxXnijj?=
 =?us-ascii?Q?YJPIMG3GgIxXkHWgBnzH7NLxup9hDaIBFm4fmLhNUQFxzV5D3Gg9Oy7r7Yxi?=
 =?us-ascii?Q?rgMOODKvVg1apmPCx5uwfx8WrZ0omS1sCnlAuQN0e4WwnKFOfPA+O67+RYqU?=
 =?us-ascii?Q?/uEJ2R7AC0Lsw0qsocBgkuPZt6743QnQ4wmbqHM04E3kKkfFFBpT1ghTGrQK?=
 =?us-ascii?Q?L//51wSmkddtbni8srDhb+mx8v0TzBnjO2WxBcQYSJRq3CIhROfNCw9MgEaE?=
 =?us-ascii?Q?+dZMbxqoNAlOQJPcCDL5GeT/AI2NmIyCvk/w2FrJGz8fGNcXYQBwVhHLXDJS?=
 =?us-ascii?Q?f+D9Kz1HUH0QY/DcJhG6sSTkrDJW1Ug93uUaVS2TgYpkWBfG971+J2rc6/iD?=
 =?us-ascii?Q?nW2PLRYRWLr8RDRNbPthRDTL/2U4YInBPVPhUxPPK0qhvtmJsvtGXGq9vN32?=
 =?us-ascii?Q?ZLQZsR1xpVrghbzeqZkvEl0ewwr1HvjSIkMOezkaiCqVStYN87Mr1n4pBE6X?=
 =?us-ascii?Q?TsZng0+Ng8lmi6J9CehcUCT6XIHS4J83Ok93rLHaNCbYI+vQ3IT2MmQeREsP?=
 =?us-ascii?Q?tuoPyr5m3iAqVgPOSUIPxmtESf2Du1Yz5wFdEMwlIIncpllrGcl7JxKHqq21?=
 =?us-ascii?Q?u8XkZYD6PGTNf4TW+meJ7eDn7A6L5eg6cBMLRuhE0dl9BZdx8GnU6bVRRxR3?=
 =?us-ascii?Q?nHCeQDOV91930yWwWtks1Mg5ppATeP6VIMHGbqFk5MvrK09uKM1nu2NXPhPd?=
 =?us-ascii?Q?1nHStRSxfpWub98LxMmLKSmh6ivrOgUNyQzmJNdV/FhPbmOUGqoX5DeVB/i0?=
 =?us-ascii?Q?6k2dSl8vL3COelYX1agFDfUiIIQOmeTm2rnqD9lzi5r6lXZWS7YwO3EsVvBc?=
 =?us-ascii?Q?S7ESiy6VNocL7fN213K6ajrNwqi2Bwz8zO+T+NFAlCe/BATCjPyi5U3Uk3f1?=
 =?us-ascii?Q?Qg6nHHq/z7OH2kDfh3ciKeL5jl1Ft/jEYSHIDLI1Ew/KUptq+h8V/c6DOqvu?=
 =?us-ascii?Q?L3SPjDFpQiKwHOuIkp44jnc5coI0ETfNRJUWTKxtVMrdnqpSu256dXnZ1AWu?=
 =?us-ascii?Q?Tj8P23XtH/CfrgxdYRHdsRFcq/2xffITDV1pTEl88R08RTrlv5cjmlSL7zK6?=
 =?us-ascii?Q?3jomn3XZeWEX+MfCW1zZgT5Nda3qjApzWBs4DmFT35HAnvKz1lhELWcB/y/n?=
 =?us-ascii?Q?7ZjtJMlvNl2Ojay5lnOMtoEjFsZ1yGUokU1fyXsIGWOp4ickNay36MNNWDSN?=
 =?us-ascii?Q?Vwflp2wcSgzhbs0HEEx/CQoTbPFvwWM7ryBGFNoJo4Oc1bZIdsbN0YOoE6K8?=
 =?us-ascii?Q?kA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B530DD7077C9904190F54E408045BF82@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6be8c794-0c75-4f59-158d-08dc5847377b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2024 03:43:27.6311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 15hFd7mtBsOhmGvGG4DdbldvJImqPx8EFrv/WiGjSK8mfumrTFmlalh9JM+W3PTZxbcGHh9zp7YqqZM8PFhrWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB4850
X-Proofpoint-GUID: mswV2yHEMwZPgpfkjw5IJdV8Z6J5c56P
X-Proofpoint-ORIG-GUID: mswV2yHEMwZPgpfkjw5IJdV8Z6J5c56P
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-08_19,2024-04-05_02,2023-05-22_02

Hi Jens, 

Please consider pulling the following fix on top of your block-6.9
branch. This change, by Yu Kuai, fixes a UAF in a corner case. 

Thanks,
Song



The following changes since commit 0dc31b98d7200a0046de5c760feb0aaff6c4b53c:

  cdrom: gdrom: Convert to platform remove callback returning void (2024-03-07 11:53:30 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-6.9-20240408

for you to fetch changes up to fcf3f7e2fc8a53a6140beee46ec782a4c88e4744:

  raid1: fix use-after-free for original bio in raid1_write_request() (2024-03-08 09:44:22 -0800)

----------------------------------------------------------------
Yu Kuai (1):
      raid1: fix use-after-free for original bio in raid1_write_request()

 drivers/md/raid1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

