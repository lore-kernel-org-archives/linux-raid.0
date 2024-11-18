Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33DF1974FA;
	Mon, 18 Nov 2024 10:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731927052; cv=fail; b=FA1lvEcoeqv9tO73a/GD9orZDeTN4bprZ3u32zJAIDe+4SIVZmxA2USai0UbfyQYhHKk3LmWBUUQAu3btI0HzlGA3UPnPfKZ5kpzM4Fi++ZoMtkBRTVRy7QHtstPykAqWebG3DuHNMclbBx9/Hc9hQXV+ByhMqwnP8jWBY8w8K0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731927052; c=relaxed/simple;
	bh=l8jWHfcLWmfiyOix9ULPk9fyb0xYOjtbPQAshuwY22E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UfoLMSqcT9KsQkiDrF7yDUZPKJejy55+gaHdFx3+//07hzbh2omcMQ1nAtBWbYl7Ia1aXRU2itFGjScfkMB7MRxkoXMDLDOrAWJCcN3a3Pl1J3eRttu6U7CwHI7D1o197qlSoFBmCCSSlDM5d/2RbwKmLFZhxbifc5WvxW/FFlU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UL7/vL1h; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Xsr92uL8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UL7/vL1h";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Xsr92uL8"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AI8QZBG012271;
	Mon, 18 Nov 2024 10:50:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=H1sClM6+eh1zgJaFPbwdJ29io/dAbFTNuW/1IeGVBZU=; b=
	UL7/vL1hczD/9aKaDeSqykFR13uoCEkKF4myMIYfZO7rnp+RKFbumSS58P7/BV+u
	qeRXbsHhn2CpKBMvcNJwC5a0FWl2xCAQGLtUF9ZT7wCUPN3Akj/GxLRf630QN/PQ
	Cq9OfiMU1r64uVLave73gg42BOuaJ3CTL8+aJfl7PD0JJD9JYIQ5zyH40I156BlP
	qEjJvowyldRgkycYLaRDVVUD20eBZEZ3zCyjFOiLl0UPJ0ofhjbwEFdEX9WhQGGH
	/4WkNN5J2om91JFa4NM58RA19lfVKHwJiPLT/AeMH/P9jon4gCppOW+sAw+PCBqC
	/mxUBEFvkDeC+UvB8aEq/w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42xk98jb6h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Nov 2024 10:50:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AI8UTK3007762;
	Mon, 18 Nov 2024 10:50:39 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2177.outbound.protection.outlook.com [104.47.73.177])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42xhu6wx72-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Nov 2024 10:50:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eTp4mabZ0r0TCLpkx89NNAkSAwIaF85sj4RkE76wrhLtHngtcnO7V+fjYheL77OZEqcqqWMTQNZ/AXF4UCHTGvKa8B6a+lLN7U9Cya/UFfq1LLGz8sm0x3qt+x/IIKOmtr+uP9q7hQXWbespCMWtpPz6BgSSkVWxV2IhM7cuT5GfyAjCYHuRK5pggpwnSHtygm3kWg1oOI5uBSbwb+ZdQPMDWgA02sF8qwK4sWGS43Sh4OPPl7nR8Tvo8CC9Jh490gspc4dbWGvJn01PJFokRJCMpM0mh0APg+LyKsqVw284HIUDBfffUrummWEBlEXVRVtWBxRtxf3pIrFl4TcjNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H1sClM6+eh1zgJaFPbwdJ29io/dAbFTNuW/1IeGVBZU=;
 b=uqxcnCXmkkcAIiuaf3moS9RxkwHqUWJBC9+f8dpngElk1mjR+qtkqNEe4ETPXiHGoZhFPClMX3IEiRDYG4iV8iSdzabo7F9gLHcwkjUofQ71PU9UbECQqvktPiNxbPpdPpPIPJjHiGQD/pPBec+fMqNdIeaEBmhBrX0bY72NUpirn0g3hWeFnCeYe6kVPJ2/piYvv+Zx+u2BwhmuU5WN/nM4+FlGjNYgEvlRlL48vRWU3PmhzlNjmFxE5NfLauGt+HufPWuzA7h7iLBaXiUlYUfo/vNcg6J4XSZm7T5Z6Kjy3gDmWJW/6I8Bsl7e/1ELosp8hT0LtRmCwEEtqCKaxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H1sClM6+eh1zgJaFPbwdJ29io/dAbFTNuW/1IeGVBZU=;
 b=Xsr92uL8JEnxjM7dytiBwc8lcwFxhECMWdx7mcvtz11wN5AfKHIeo3cTNNvhbQJjSjm2Bu8iWUlaxk3T73iUmKh/8InVB7eXzbfheM6114VwdyFEIz9gHDR/94q3gCZynRSIIDGQcaQHy3w7amEw0LWCYhR5zV4iHZ8i6mBiB3g=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB6812.namprd10.prod.outlook.com (2603:10b6:610:14b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.22; Mon, 18 Nov
 2024 10:50:37 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8158.019; Mon, 18 Nov 2024
 10:50:37 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 3/5] md/raid0: Atomic write support
Date: Mon, 18 Nov 2024 10:50:16 +0000
Message-Id: <20241118105018.1870052-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241118105018.1870052-1-john.g.garry@oracle.com>
References: <20241118105018.1870052-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0054.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::29) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB6812:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ccf4d45-27f6-4bbf-5fee-08dd07bed5c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SdG/mmF6M5S3JLvImhYVG1EacDt3aK7TBd4djXOOyB1/PfqvK8xIx75QV9PE?=
 =?us-ascii?Q?6Dk9ZUsNmuRrr/E+aTMHzW0Uf3bO6UHcky/GCLWSfazdz3tE3kx+nbZo6QKD?=
 =?us-ascii?Q?fkHlEkAHwlIsJ38xh8JXVrxbT62dG7O1ird4jg9NN5DLAyDWeDHQHmR1w/Uz?=
 =?us-ascii?Q?HCGmrwi9f259mVptml0sSrkswH4GbRryJwp3EfVeuxfopLJfScypn2QS+nTU?=
 =?us-ascii?Q?aLQHiQiU5Xh7esog/fAjUVaDoR5MKp6mqgzg9e9OmWIiw2oxpzLw/7lYjFi4?=
 =?us-ascii?Q?L8D9/xswERvLYHQc6R/J28cZCBh32S5emrCzFCFkmjWuN8CWeGtNsHeC3Nqm?=
 =?us-ascii?Q?LCEcZ1q1AInE1BQsR1iCiEHYim/XFtvzoByiqQ3ZjRUc84sNkr0K2qLxOQfV?=
 =?us-ascii?Q?mdYNqWIs+mbXgJa3NaLtWWDgtw20C8A5b0UIxMEGCcCB+U3V+Io1FLUh8rOx?=
 =?us-ascii?Q?luSPb5e1lwWqkyjFftajeVZqkzl71RJXd6YgdZAM7Ft/gsUj+e+MZV0GeH1h?=
 =?us-ascii?Q?z7vEcb+k5jLesbVLVd113z/PUhGeaBSxbnIyZzdnfdLv87EdCLa3jtuyCkaz?=
 =?us-ascii?Q?vwJcTB6cCcmsuZf7/zk9gANbg29BoilNRSD3VlI/aeJ/BJQrvb84Kn4sFxN1?=
 =?us-ascii?Q?7SN2b59I5V2JJzuYCqN1KMDPD50l8s1pMN9vCEZMtK6r3vRVyXNjeq9SjFcw?=
 =?us-ascii?Q?1WC3VPZq0zfE11fLNPVluXuppGgt0K3YolpdFjaVMgfHi1lbo4ozG27LYv3r?=
 =?us-ascii?Q?+MIeATcICb/ZZ47WZ89Tlrg/39myf5QQ+pS5kovSatbRhctxiasYqJ9XTKky?=
 =?us-ascii?Q?EmDjWpRNkVi8ngynZbe+H4umXjqT2zl8dWx+lJRuWnq1a3ghQyIfBuJYqBlJ?=
 =?us-ascii?Q?v8FjwGStefZvLZrY1HdTLhSVBVxL1Q83NVS+FDWylusNKWFXn1CgqQWYCbJI?=
 =?us-ascii?Q?FIweyKPpD7c/7+tRUJ6IKl9GuacPqrlkBg+9PtEifrt5eeqfaaQFwp8eaFNw?=
 =?us-ascii?Q?tuQ1bxGurE9JRA8yFQGd4GHNAaNtuwrH106bBZ4PTBith6qWG4H+y+K62Dfk?=
 =?us-ascii?Q?u6gJP7v8VhqTcKqFbof5pEHL/+vOaBNH6cxkrmvnc7lwiPENKZclvDm7w0gT?=
 =?us-ascii?Q?b1fmJyoe8FVl6kU8L3o5pzHGjeV7ZqDgVw+VHm1+J0JWF4MvFyKGMKguNJQy?=
 =?us-ascii?Q?mHVeJKKvM//LMEmhYV99bRLRu4cHGrSA9gEsGuFdOuhEfXAPsWA3WwMEeoGW?=
 =?us-ascii?Q?iik1pjlNRBFL3/jo3/jyKKQ7vU0BYnuSc3CGtmla0AV4569j0cYVvBZePvDO?=
 =?us-ascii?Q?S/jbdfdYAvwBRXc68KRE+Z6u?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?p5ju4rvp/FQG7+7vQ8DiufY9U/EjpnPK+mCiX4YaDu/g/84ctTIAyUuEl9Od?=
 =?us-ascii?Q?rW7u0vteHuhhv/KWX5eArpYIVC6kBHLn25SUkdGuWrf+wFYQS1G/zONOAknj?=
 =?us-ascii?Q?pVWyIAjzpfyTdQfmINgC2F+246ICCLskjMmvGLZ79xJj5Ntv930739CFQC7w?=
 =?us-ascii?Q?McNA9vAa9w1wgR+EOJGHJ8FUjrvLfZ6QcpZSe+moQrxeUKdr97oeqfrsUAf8?=
 =?us-ascii?Q?9XPo2dzbadnsnL7BOiUoLUlgirZ9AMFySx2Fwu+Htn5XztAwqt3v6DreIEzU?=
 =?us-ascii?Q?3FGOrgeaevzcB7iIIzLUcMvYyL4e8Wu6/tyqWoU7B+5E6ljVxROGH2mCa6lc?=
 =?us-ascii?Q?vcGlnswazXLPqGa1ocKjkXdv88era8tEEoPrbOrGKDUn/pztJkEtzj1ArSke?=
 =?us-ascii?Q?woJiUUYF8b60Erk1AASh4+DnKIqtTodQv45hClD292oomrkORrYsr7Zuz9mi?=
 =?us-ascii?Q?4TPXAMbAiM77cgCuhR3QSc3X2sbpXbqvne6tcBIv2YmS8k7VvznStVLm4sna?=
 =?us-ascii?Q?EcT30sRHE+yqYta69uaK7LrQzQX+HDgFOfFuyEDHKBgB3EU7Kbnyv2D0bgbf?=
 =?us-ascii?Q?NdD5hJrAviwn456t5S4uiyzu++k0ELQa7dJZZlzz1aQNO66fNHAeA2/qHGny?=
 =?us-ascii?Q?m/vie5Ti3mJMcnP64M0YFQskAnVuxuVSZO+SoYMalS3EGYz5SpoM+9hHQ0u+?=
 =?us-ascii?Q?4UILNN0TGTa1WrPGrgaGGL0R+aqMwRLmUoVaxfftm4UpJb65tIcioSezSkiv?=
 =?us-ascii?Q?nRifky4FO5u/mydZ4NQZ+iGpi/M2xJv5d+wDtu5qCY9J7t+b70pjk5/gmffa?=
 =?us-ascii?Q?HMDthU+An4vZCW7d6tPwxpeWLjPXnswc46xeSoDZEReRICN1QD4aIdtO0SVy?=
 =?us-ascii?Q?N8sWw0H5Dg11n67xhxJii7yKSXTE3v/0l2DCAtt+wTN0dBNuGLorJwCffRHJ?=
 =?us-ascii?Q?7U/BhBNMybzqX2Yg17Mmq6o5ntibpEDmt9h/C8wX9iSr6dBeAJqmKsC0L0AF?=
 =?us-ascii?Q?p6ucEn7YucRx9luLteKhySRDp/HTQ/Fi8/hbqmuYiwWaT0T54KFRgQbG3r5A?=
 =?us-ascii?Q?mmDb/bBuqMUSM35fX6a04d9X2JWMFXIvZTxxFsGYAf31yyWxHLkqbTt6+XSr?=
 =?us-ascii?Q?5SUBVgtFjijBN33Ud7NyKNu4hJJA1fMjNlEcncyZd9YeyWTelobZk1hPwam3?=
 =?us-ascii?Q?b5abcwPHD4+I64q7FLKE1LG5d4JJ2DUlL09K5A+RceDeBCVvQU1mam8LrV6r?=
 =?us-ascii?Q?unf3KFM1iGxRuy17FHaVHTseXUIpgX4tZU1VyM1TVmgQO8jtREQ8ea2rtOpz?=
 =?us-ascii?Q?HArIfMKi3Mq3XbN9BkkKQw2ZVXThCxiOUgLJEqp3e1Jav/F0kwGxp/RN0P+E?=
 =?us-ascii?Q?1cLl52nSGx7xsZpHLajGnnLRlgast6BsH0c7FFcA4IOKXqEjpHRsDpOtKnye?=
 =?us-ascii?Q?5k42QTKRlN8gUEXnVqjgfNOYepjlZzGchB58ldqoXBIHnxCcn5ZnMgXoD9W9?=
 =?us-ascii?Q?UlprCSUYIedkdu1m1zFqc1HGylaZLu3TkjZEa5E7i+r17lSyPgftNiK7hMSq?=
 =?us-ascii?Q?/KG3PCaGBJr7rU8k4jlSzBrZDij/3bicgLn22wAnKN65C7FjuD8LVirwWHWn?=
 =?us-ascii?Q?6w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vWnl1xjepli3TLqpqoCGdw37skfenu8N1y6Cu4dBcPaF/kPoMvh8TOfKpgCQTHw2O+VP7iNzZgcylWomFfOeryGtVll6f9fddDjBSlhqfmWnMsIDrQsSmpixVoCA0Kr072iuRq3O9JRKcK98y7zC+Y/BsV4h4AFMdTVkXuXKIy7uQxW176VdAE2jj+Tswg9GmOaQmnr279C+2nbNbX+5yXAl79Ce5B4KmZoQfUK57iquJWoLq54RpiZ0e+H7SGwWVgBq7zvTOZfhOKu4eYgEMtRx/F+7LiR3UlbQaUQAl0n0kIePb3WGxD7uTr/PbY2XOnoHj9NaN/DAkjaL8Y06LuPu9N9FkxufLjxKz9ukf1q2NTkj74hAfRW2E0zuxxAHjlj2L6VQMv0HBSvdw3pdT1BY5ZnAcFMRTpgnjLsV7dPNXx31od6VzfFAyJ/5Ld+OmAqLkbjktjQat+WZQdw5xYwiGVgZ9tTGeeOkeaKeqteWllqP0wI3rOcJ6pgtfcFX6QLhtq5ZrIMortMI8Ip8sYO9FXneS/Kudo9utNFCbCOY8R+VhtFhyxn06ML4Oy5rMeMAMJBIjUB8XN0Ze85crniTRWqgIkOEFORm6QOnP6I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ccf4d45-27f6-4bbf-5fee-08dd07bed5c9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2024 10:50:36.9295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IM8ajaIYNjfuQphTuEmZh8WN3BGEG2XrhL3iX9EnzTnWd+rRIzyStL/WXBURlHO8N3Hwm3s1wsYUiF2qp8CS7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6812
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-18_07,2024-11-14_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411180089
X-Proofpoint-ORIG-GUID: JYuxYXPFMeSAfiACg1UU5GQIIgibeduJ
X-Proofpoint-GUID: JYuxYXPFMeSAfiACg1UU5GQIIgibeduJ

Set BLK_FEAT_ATOMIC_WRITES_STACKED to enable atomic writes. All other
stacked device request queue limits should automatically be set properly.
With regards to atomic write max bytes limit, this will be set at
hw_max_sectors and this is limited by the stripe width, which we want.

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index baaf5f8b80ae..7049ec7fb8eb 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -384,6 +384,7 @@ static int raid0_set_limits(struct mddev *mddev)
 	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * mddev->raid_disks;
+	lim.features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err) {
 		queue_limits_cancel_update(mddev->gendisk->queue);
-- 
2.31.1

