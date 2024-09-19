Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF7219B3D3;
	Thu, 19 Sep 2024 09:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726737840; cv=fail; b=cNOE37P4GMx+HmNlktbjhRDboD53TYQvNzvT3yWqJtpwvg1XpMzG0WAf12JIKq+YBA0WMfepaOrcfYjzkyYVGVTdvElpikXNCSBtu9eFUysiaNUxRxr7WWnEpY1E9gVWeZ2cfMv77DRMwIovyhI1CVllKUt3Quzu/0dVbZnZqNA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726737840; c=relaxed/simple;
	bh=wVIKOmse9cotmcM447ue9hT29S/M20kz4mIrTUpMi/Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=X4nHU57T/yYvPmnnnlpcgSBj8AbXa5K9FqjGoaAmnEp6jQCQ3Cbf3WqlInU0ullzMmrjnDvAF9LUUEs5oyv28om0zxK1Go6uE3ZAEpn2CHky9nqo8pOySnyn5EPZ6GubBCAOucOnarVglhN34mcYn5C9aabA5tCOqHuSbtuAx+w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VVZpGopB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=S2GTGitV; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VVZpGopB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="S2GTGitV"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48J7tWcL027028;
	Thu, 19 Sep 2024 09:23:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=Y+5fIuIpZqqSbAffqwFfJYt9lmtkn5/VFvOJfmnsHvA=; b=
	VVZpGopBQutUelc2bWcwyjdn00EPk3ARhgHvPgexTlo82c6z95vcVwdf05xF6fCB
	tDYHUHkX6i53ONT+xXMNMFm0qbzWGwVc6zFZ7r/Q+t8O8FY2jFN0hT6L/mdiLw5A
	oQIxoKBll5tyqEa9NcVyj2QBi8XUUOLweGP1l6Vm9CZU95WUPmFMSUvi4KSiIdwC
	HDxTQePMbB9ys99NYOFUqY981uEiY8E3VWt5zxUdhKv4XL0Cp8TSsajvAyuLbi1X
	rrR9Cv48cHlpV6aw8qVW/FMRBiNl7VL6oeWSklqZxYB/So/cxIudIhsUOFBXd2SA
	6QlJN8u9TQSQB36zLeRKrw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3nfujnt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 09:23:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48J94OfO034143;
	Thu, 19 Sep 2024 09:23:54 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nyckh80k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 09:23:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VMKs/B0JoV3WT/8sXkhM04v+a00g9mYrBs98MQLwetVsxA5g0Y8l5zCpCiFbGMj3YRPnqGN71CxflpaGCZFaC5gwd4Jt4qUTu2uQoNSuJHz0WjjORh+59l4Mv7awnnylHYu/Lm1qZrD4UMPmEH2xSCGOoZ6ZLxlPmRrrkx/wNUJCbD8TLh4Axy4OlzWFkh72QZz5yTVKLT55JR9BzIXRnBq62KCy1AC/c1RlpQqcVyaGAVTZot3vZFnBAuZRLuJtZioBcLRbYaVJ8YyEZvH9XVjAciDIgh0/ltxUl+PjeSPZIN+7lHZKfbAuETGsiORYWctuCd1stN6gQfOi77vI5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y+5fIuIpZqqSbAffqwFfJYt9lmtkn5/VFvOJfmnsHvA=;
 b=wiWJm2CJaofUoUYzPituXRleZS/JNtbnvOiyKXuWIumLvhaQpyGQCKXT49kRyC78I4r2G2f+q9nkWGKm47rpYnaZRCF3n8Dfi5N6XMgTL6yx+bclE3edy6Ro9e9LBTia9ARHor9bkxvS9ErmJ41U45484htya4NIpdRTYxiSA85iLwibJjxDBCuAqGmhkFsYd06z8Cgr+LnGD8cmzm8fIxQPpL0gC14kx3rNE/+TmQ/BE9OY9M4WVrjXWlustcxy5V95nvOA9uJeDGTVWf5F5H7puTXhAWt8UO3ZDFpwW19+rfqaR7DQs4aZhtyzqo8pLMTJ9OgfdW+xDZ7QGiCBjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+5fIuIpZqqSbAffqwFfJYt9lmtkn5/VFvOJfmnsHvA=;
 b=S2GTGitVWSP9xLyzVy0QCtRK7RgjCQTJKktaWhC91LzzYVS8hK7ltdkK4FBPwSwF7d8FV6HXN4d3HtW+asItl3LLTDLTiTGDrTTGgL6aucDF/gFJVs6YmTdnPUmVXo7y3p8I2VYHql2YC2XUHWjfUsZ43+eb95qDpMCdxA1F4wA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV3PR10MB7769.namprd10.prod.outlook.com (2603:10b6:408:1b7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.10; Thu, 19 Sep
 2024 09:23:52 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.8005.006; Thu, 19 Sep 2024
 09:23:52 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC 4/6] md/raid0: Handle bio_split() errors
Date: Thu, 19 Sep 2024 09:23:00 +0000
Message-Id: <20240919092302.3094725-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240919092302.3094725-1-john.g.garry@oracle.com>
References: <20240919092302.3094725-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0517.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:272::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV3PR10MB7769:EE_
X-MS-Office365-Filtering-Correlation-Id: db53b01e-3407-4eae-f94d-08dcd88cc6f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pa0ZTGusRSF0F3ReI4B0kPf22SEoHvaRIUUPkk6kwDTaSTaKwOonOZ9zpyT5?=
 =?us-ascii?Q?MSox0AHxL4BgQTfme037srFBZ5WRsJeerrnVeBhtEXhJN2ep6HkdFyvymwn+?=
 =?us-ascii?Q?g1+IPpMwuCCYQvA3KTPmnSwpWJl8hhzhsBFFNwqy84m7hxmlE0pHeJGFRfQl?=
 =?us-ascii?Q?Uuj9cDlffHrZQTgiEI2HrqWQThxIzYS2iikyRytqLtfZ3tz2xBhG1SnVSZ9w?=
 =?us-ascii?Q?HUk5sKFFMQdLxB7Ij7BHhxgYBrRLp4S85rc5TDYeyh+oWb0+bzE+8eWB2LKJ?=
 =?us-ascii?Q?yOXdw9h4goGwRTjCYdwEW2kdIeNce26PfzjnrRYBwkuhmkpQdvl8qiZBV/ga?=
 =?us-ascii?Q?D/i2kd5tQMK1EwbGKaheicfkM6WqV+EVSeZtdm8drkrVLJWRLs6qU9U0Elrq?=
 =?us-ascii?Q?a4CQw1smyjC++a2GSiDiGUCMvt/WbpOMSdAoag0OkivSUBVoTJLsbAPFdXLW?=
 =?us-ascii?Q?cOAmilrPKmwfcl/Y9PZFI1RkmqJGgtTPxiuYLUe8N2R6kNr3p+VxFeNDsd7Z?=
 =?us-ascii?Q?nTYH4huKTo5YfYoZVZqfXumUYE8FwxwMGya2rirY6ZxF2wg5PUniCZCyz+Gx?=
 =?us-ascii?Q?YWs8HBLxv/iupzjGLyx60o6mtGEi/peBdpsMBV4/VXv7DCfjm8ztgy4BuTvn?=
 =?us-ascii?Q?79grv9cboDXV9FgvhsW2J6N+clEHCGfH8T6pXUH9eXSL3tjOWdwx9jiOF/OB?=
 =?us-ascii?Q?YFklMNutlhAGCFvB54lDPX1q+llr6KXGGAoJQ5RxhxJHaPV95f9QXlc2lk9Q?=
 =?us-ascii?Q?63pM2x180GUpn7z1sbv47Yv8MGN+5t6qA30qKkOubzGHzvixIK8iSsniJ3ev?=
 =?us-ascii?Q?aU58e21sFYWJ5KXJUkSGtxlV+FXYLbdo54pP3LiaPeflS3IDFsnNLXT6rWtm?=
 =?us-ascii?Q?tfMBWi8X1JsCPPLFQtyBBw44JD41sQQyIlk22AVfKdL88eMV/vYuUzuQCA+B?=
 =?us-ascii?Q?k74h41voOxcVkk8vgNSIxyUgrSW0/APUo97gFztaNjvf7eJUkQXuKJGjCOAD?=
 =?us-ascii?Q?a25jhAIxOif8+r6sFfxQ7GI+Xem2403QCBexaO7hWr2SDugHP9kunXh+FoAT?=
 =?us-ascii?Q?yG93yjmnsBhEgoLyqJp1tCE2QpBtbzbV++kGMBdGULUhZj/Y+BjHBslHXkut?=
 =?us-ascii?Q?2TozWQZXmubudcmr5o6xOJRb17qv4FoYzehPtt+u2XDRBFiTxKtAS3fsnhFY?=
 =?us-ascii?Q?83GE/ClIC5PuKPPmNXBbmdZPuhGtF9fjaVRfaLKnK1ZAFLRk2KzAIyBRLidh?=
 =?us-ascii?Q?vJZBcJ4p9PHqVJeQhldIHtvGBL0DI4DOpCAh9yv3b4w6naBs8PwPOCPJHabd?=
 =?us-ascii?Q?caTH3Py6YuXGbDAPTNwF9H5h7Mgd4dftloRqXvM4yLeO6A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2AzR4MHzi182/iwd48N5gjMLovLrSDxFCjNjLZ1AI6/Dm1v+8f3jsw/cQ5qa?=
 =?us-ascii?Q?JhoZsS7w/US2JRZwfScjaoPIHoCfbPKZpc4gfEbgeVcjTYGvrPCf3AuMgJ4f?=
 =?us-ascii?Q?X4C4SQ/CcQpHQ1LYbhvUwcwN9ggtNDULX+aKvtRt9sKtGCsJieKvrlLPKpsa?=
 =?us-ascii?Q?KwuHQ6MHrpKF9VAw80twjrp+FmaA10bzafusAAZ3MGAB4l6G/kSJov67F96R?=
 =?us-ascii?Q?chYblPaQfyMgntuVXm1S2IghBJzvCElidvgembuRgxLb7zr+c5mn0W9emif3?=
 =?us-ascii?Q?bL+U6VcZJqqStop0fFXIInA5hRWOVmA6189E3lcd/oKLFIZxn6bh+dHRatKo?=
 =?us-ascii?Q?XlILRHwuQKBko8tNc2hud0ZHDR4GkMp7YHzEwHwl6TFQtfgf3mVwEQbTaCmH?=
 =?us-ascii?Q?+OaqmGzyQrbPw/wfySE9V3dU2Vsn97r1RDxZcRSAE9REi2JihkRiaNcBtFwM?=
 =?us-ascii?Q?IbFO8O/T5pUAYfnCqH4uaZBeZ8+nOhp403eYK0OrnbAXqFGdWRRQze9ZOOhR?=
 =?us-ascii?Q?o959TA54CtYbVUW3KAkMyMNOzknCuXta4xK9opzJbn4pUmjP0dJD8yC6mxRM?=
 =?us-ascii?Q?wS4GaHQR1UitwtWhpJjnIyNP2HJ6eH689fZgMzM/5pR+Ovx5fpI9qWAvZ+F7?=
 =?us-ascii?Q?qFEvlai85QlN8nWnvPxPQb8KOw+BG6Jf37Pwb1hI6cXxvV91G6pHcAfzPd+V?=
 =?us-ascii?Q?wnJS4zLkZuc4soeMiWE5v7BQpAo971kNdXkFTD+guboQ+ZTDk/LaPUJDp1G7?=
 =?us-ascii?Q?kVZvo6qiOMSvTKT3l0uTbJBUd0aYmWUKZkNdtAEQrJyOBZrV6fraio2i80Rv?=
 =?us-ascii?Q?KfTqimRfItjcHHoZusG9UGxzPXSgsJ81Rqb1ZYUz8dLSV7dQ10ma02qfjBrH?=
 =?us-ascii?Q?QZygxer5QOjSEen6hSkWm9pGzl3rOBnh+8QLgiYRV8v/NMRbrVK4QRiqGSSR?=
 =?us-ascii?Q?jgtsL0jMEIQ5Nfp53OVdmbGd+w85D/h1bbXlgWCiHasq4cbqXtw64HsmfmkX?=
 =?us-ascii?Q?QzhTQP0bQNW9IScYl/a8VJiiEkrB1CHJcaeDsu0RSJMfzU9oKIi0HpqjVp+C?=
 =?us-ascii?Q?r4FVrWEdghH8KBGVmIfiQyZA7zhWQ4BwLywXojdLnN6EgscQofuIgcq2oMcV?=
 =?us-ascii?Q?4/OVzh9S6dGd3tmaTZ8L3LOikuD5P/VSrpCwkfTygXoiYDZuAo2Zo3+4GPd1?=
 =?us-ascii?Q?vgKOU3zmOY27IrkwKqXCXcRo3mr5LMHVoaEyZBFXehPK/BnCBOHeQlgLnr5J?=
 =?us-ascii?Q?A7RbzdZZN2Y/Ag6IJ2H1sDZ1AYmB1PupFcNzsWaKvmy7jxXRYYEKh92Kw98q?=
 =?us-ascii?Q?vTX30s0loQu/OvEwhX/FOP5W5yMkiLS6ZE5Tiz42LiLVDBBEeo6lNX8WG4aI?=
 =?us-ascii?Q?3JcjkEznDC1/v6o2GB/fC13iQl5nchoR2LkrQuFUHO/A8B0G9rxU7FXNn7uL?=
 =?us-ascii?Q?M0q53GfHJjmRzbdhHJuRW3Ewv1xGb9UBDVDwFWEF3cgWbd5t0ovefUsPE5Sy?=
 =?us-ascii?Q?mmSQeQCaYt2PaaLUO/N0apuF/cTRX7RR+kmvpXHGO+iVxVWV+EAo+qVa+w/f?=
 =?us-ascii?Q?KJpQmpobv6x69dCD1T91aIqgqXm9S/pBiONbDaC/JDS/NanphXJpKGlgW1kc?=
 =?us-ascii?Q?dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QaGt+FSo+NDYG4V8pilUR4qrrQD/63Y01f/gb2qgQeYud5+xzJ8uF78/Fhpg3+sr3dtAB+b09UgOvHmixvfmK0Owz0B55SMI8TAYlmKKIh297MCSSu5eJbxBodPrRvxXvKbtXy5GMRmLOPHHdweJopE9w+CJZ335fDdCENMvzkNpWxJLPDn+5lesLlw8h9olp5LhJ03yPpoCoFCKUgQ+6qeJAggbIqQHf6c3iC8EI+UpOCLDK2kss5KTbnuYBgXewn2Q7YwqqSirXesIZ080pPCrBA/29avBn/CrWINkDYac88EYyHnDsUu+RKsBPKvryx8jsV9atiE40Y3UWMFrA1/L7LtpPTwgCYdX6ywSeDWGkZWRQfYm3lxtvfoXf/jSZqJwOaVyRBt6jZOWCL1SEEeV7pGkxTnhAhzTNagEkLc2CsZg3CuRmTcLMT+qTggARVwQAYrirJX6VFbpQPXqb9R0BDVCf4C/bo4tk8kUj+iFVVrdTSypcs1fmEpADs2EPTSpb0hGvR1sDQjbPVK+GAr7Qrf839BwWhUb4ueyKFa+ivhXIIZPqV5gzIIqnDZLFXagZ6DVDe1SwG5WHhvA/wvGtbu1eEprPQMiJNUnrIU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db53b01e-3407-4eae-f94d-08dcd88cc6f5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2024 09:23:52.6718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g8Fx+Q+Mv3jkkvaZmfa0HrbkSvcHT8RPCBQcziyeIK/sz1faf/uudwsgnnGZ9yhMo5xEFDsIOATJpOl9ldVtpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7769
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-19_05,2024-09-18_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409190059
X-Proofpoint-GUID: hRLwaKwixyk3Ia7pgexfr3x9soUcw-IN
X-Proofpoint-ORIG-GUID: hRLwaKwixyk3Ia7pgexfr3x9soUcw-IN

Add proper bio_split() error handling. For any error, set bi_status, end
the bio, and return.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid0.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 32d587524778..d8ad69620c9d 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -466,6 +466,11 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
 		struct bio *split = bio_split(bio,
 			zone->zone_end - bio->bi_iter.bi_sector, GFP_NOIO,
 			&mddev->bio_set);
+		if (IS_ERR(split)) {
+			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
+			bio_endio(bio);
+			return;
+		}
 		bio_chain(split, bio);
 		submit_bio_noacct(bio);
 		bio = split;
@@ -608,6 +613,11 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 	if (sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, sectors, GFP_NOIO,
 					      &mddev->bio_set);
+		if (IS_ERR(split)) {
+			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
+			bio_endio(bio);
+			return true;
+		}
 		bio_chain(split, bio);
 		raid0_map_submit_bio(mddev, bio);
 		bio = split;
-- 
2.31.1

