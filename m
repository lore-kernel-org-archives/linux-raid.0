Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47C01DE4D1;
	Mon, 28 Oct 2024 15:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730129287; cv=fail; b=Wk/bBfBhqPjhNebTXpA68EcV2ylIqbrf/vVi5hQF+w8X6WEyil6+HDYlC0fFtnK8M7N18+JpfQ/BCHGb+gRHdhK8/lGV0HihU4QP/tkTv38BGXA3SN104QFihlpOc0GSCXF9OzsdRLSi8J/dwwkdjTvoOExEY7frbxjZuy9gogk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730129287; c=relaxed/simple;
	bh=WRHKSnaSgD997yIucatJroHRtR+E0jB6VZEbSMMQmYk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XXwX8W6MGUe/QYgL/+xfVrlf3ehNagN7tNhOC/RzrI4wy7rILxbNrP0yBKhkUuKTraHZ6iPLlYwZYwvRpLXCBYfFGaGw44BZk7acOPbfAFqIK5XPV7lxJu0Dhd+6N5EcNJjLXKD2w7Zlj6X64z8VdBTasKVtckUkX05bkM150Mw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=n4Pi3ZCZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZFg5FiO7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n4Pi3ZCZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZFg5FiO7"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49SEtcP6029536;
	Mon, 28 Oct 2024 15:27:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=k1mi2FeK4hPZbDgmP/GU+BLYQVVpbgR8Q/UkIZ+SyBc=; b=
	n4Pi3ZCZiQNXbG0lHW72rA890PoFxd2RCaabdfvkSWNVmLIVPWorhTE0TXqdsQ4f
	qXaHyJh6X8GH4wsZebUrLXjmuMWRbG6hOGMkuPHg/deghXrdX+TrOepmW/Y/gXHM
	za9O/2KFODxxFlh4uSUuaxyTyU5gtaC2zPI2hrIT1K+0KlLePO4RovQu34icZMG+
	7KSAQ0Hn+/9TUV/XTAXhH0i83n/9LmUAjn57YiwKZAFN/mbVt7mlBPLwusckfHRj
	Gvq0X333MqIHwjQqJxmGWRLV1jvYTIHoasAQHIiLhDRFihVdeUvtVjzMWMcA/e+8
	nVlbhA0N8l2f2Sl3y+bU8Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grc1u5ae-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Oct 2024 15:27:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49SF0FsJ040424;
	Mon, 28 Oct 2024 15:27:50 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42hnamj91q-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Oct 2024 15:27:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NxiErHxmhqA2VQP8t/iUcKgIaE9DQQaONlpgjXIWQU6nxJUq3FBr7kXGMTQRD2E7AUDD0UJg9CXiH31rkue7s3Aj0mcoSXIrXR3mD3uKJpG0IC5okC+bwHuXUD3FtaIa4sKnB0okVsGRzCh+IsJ+VY++0G8gQPKPPGq6t3hl9lHUuM6hcwkRjorVDMUMofmq8jSASjo2fmfvYfrVJn1h1XAJ/ozyCPOdLnWMFRkdRmZFW6ZNTDkfR3rmrqrsYxZGrL0hcPOu/Ofi4mjFY4zLiuq0G4Q9N/r4V9WtwZVhKocBkqrEo1mGfBHyJAwWQPw8WjvzseyX1X10psjQz+AbTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k1mi2FeK4hPZbDgmP/GU+BLYQVVpbgR8Q/UkIZ+SyBc=;
 b=UYyqg0ThQsSAPOk+m4cJK2dWNR2V32gZ0/D6vNZzkIyBtQEfGpZXEld+7igpYXjgEsrHX/EfpPEcsUFTjUujQUqfwxOLaUz3cIw0NPlRq38bq+FDBNa7jvLguw9Mw1eg3FUlvqhpB3tcVGBzyO6Ot1doZXdJdfCyDmZc2A0Eq9NroA1kuDZGAXwRZy3YGP9EYQIDqDRM+tTBfAmWOpAz4R9HqsrXTVSfBkfhvDFIgossrbR+/j8HRSNtaw6hsLI0UWhH6coik51hSbSkebIaAKJ63bRPXckMVtWbum2yy26fXcUvoNafL5TZa819DQYssjTLFp3hP79QCPefcUS4aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1mi2FeK4hPZbDgmP/GU+BLYQVVpbgR8Q/UkIZ+SyBc=;
 b=ZFg5FiO7R9KTUp35eMRvsvDyd2RkL1iPILLRT79ns+n8dNZ79orxO5O7bAxCJR2Xy2pDStGrpW6Uar4JjnfAI5qGKUH5oaDIHHxtKJfMMI2eJBwNezEvpFxm5RXlxYotgBbcXSAbr8PZBk8IEvxyNibJaMafQvj+kYwXF46GIUU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM6PR10MB4170.namprd10.prod.outlook.com (2603:10b6:5:213::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.27; Mon, 28 Oct
 2024 15:27:49 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.024; Mon, 28 Oct 2024
 15:27:49 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 3/7] block: Error an attempt to split an atomic write in bio_split()
Date: Mon, 28 Oct 2024 15:27:26 +0000
Message-Id: <20241028152730.3377030-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241028152730.3377030-1-john.g.garry@oracle.com>
References: <20241028152730.3377030-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0212.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::7) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM6PR10MB4170:EE_
X-MS-Office365-Filtering-Correlation-Id: dc1bbcdd-51ce-4eac-8831-08dcf765149e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j5d7T5hgRetEv7/6nC16kiXbMsBaxVfK2DH2SHjx3fECDFlpiZsH8iexsRCe?=
 =?us-ascii?Q?yzmewPxvKwWekxRSW3/6KC838rSDMF5BWmqYHy2u5lh8eVU8v52/RHXPQBM5?=
 =?us-ascii?Q?omD9d0Zf/PzKHGpgmvG+BRIeVJeJcoIKdfsAmsEMjlFJDp0jJSON04wlv0tq?=
 =?us-ascii?Q?fOZs2OejWr8Q2+Z1Qt8W0Ywmk8F6pHNrjKgHH8jOTGfTqJdM54Av/07PjRqM?=
 =?us-ascii?Q?4rKMYKURbsXXY4lVIlewFlf42bbCW8j12a8TeJS6dwRMTXsofry6mnzK2tM1?=
 =?us-ascii?Q?GoRIFELNC7Lj90Th9cAfwbLYgzJPNaRjumI9Tf3TSffaJLlCHx0nOjS7Sr8F?=
 =?us-ascii?Q?wFIAFt+iNvyQTgp1gd96qLxMdn/VVWwPhCB2XX1VQsAtHH7oocEy32sBu/y3?=
 =?us-ascii?Q?PfANb0AaSGXWeTMsg7AurxQndV3kO3zIa8zkCenJiavEsUpTEhUDFq6034YF?=
 =?us-ascii?Q?JZ2hqqMkK8f0knbXDOxGmN4pM5/n+7TYAlfzl+PJvSOPuzHqrn1rem9HDolF?=
 =?us-ascii?Q?4GiCiVFWnjVAy4vDKgVZueeinz1ItSQpZeYPeYtqNT+pt0dYgplhiuDDSNVL?=
 =?us-ascii?Q?aqxvt1SoUkow2vRXHVSYMfxZKXq4zbDrco35lPovFQk0kPaP+JL39aS58WXu?=
 =?us-ascii?Q?/CLPlDtUnxQuIscxj1yYdpQwU3PrCRlvh1VTmtB4tuhWaa6WozMTldix2e/v?=
 =?us-ascii?Q?XkekdRAQ4DXRxB8IHmLol3Kjmq9G3tHtalg1iAJIDwBmQaKD3bdyRFTkCq5g?=
 =?us-ascii?Q?OzvvKurCkjed6bau7W9XIe2g+AVZir2QMb8XJ2MsQT6oKwALXgL63irrQdVz?=
 =?us-ascii?Q?XQyWkiGTbgiIyjzGHDpRFgJnIHTp3f5HXATa6LjLO9yBt7lC116Fpc31VFop?=
 =?us-ascii?Q?O5jq+WjsndMWkOXmMzUULY4TdQ6nAFcD2kyRMGt8r7b0z9fs6uiQE8BPkFC8?=
 =?us-ascii?Q?pK/Yu/t7lFiJABMwhFycmJltZmPl+qk+T39MXvAY7gSPb+UegIph873LJ788?=
 =?us-ascii?Q?f3LdDOeg9QZ0BmgIQAXrfDGagQlBJaiUqf1Ghw7NTDqwvHDJ8vsx0td4Ki2b?=
 =?us-ascii?Q?qu5b+xbuPAb2qHUefVtbIV6e5AreFIQpa77wty9AxM1yG7/esNJke6S5Ke0B?=
 =?us-ascii?Q?AwGxhlr3FP36PQ9loVZaFeicKEAHiY8PashHnSIryRn/qvWofDIuYZ+02yyN?=
 =?us-ascii?Q?9q5HEsJ0eMOc5NAzRa/sJu7BsGWUpmCGEQfXMHCH1seJrQOb+xFvTaI528xX?=
 =?us-ascii?Q?9aG/SjzCIGPZTjVdJFC5w4Vuc1YRp1201/8ienydf5xyZXAwen87vxCfr4rc?=
 =?us-ascii?Q?r/tVERpEkwMFbaMO4vjF2YSG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FDkA2r4G0eSXRQvnSKzwgg2NR9TAE8fwlOlbLIIQqUQX5n40hBe313AoqcOC?=
 =?us-ascii?Q?7qZpo/PjOaUfgW+hhNV9J/ylDaSnkCwHCjgcT78FBCbfoA8BBwLYE32lLvaK?=
 =?us-ascii?Q?fYGm0dXj/ZPvQHFAYmlVR7VEpUnwHEdP1GmZP3n5SeMyG4Axy6JslHYAgIDs?=
 =?us-ascii?Q?Q9T6frYS27XAUUbE/AkEJsiLn13QOPglxNY8UES0PJX7GV3YimpV98mcMF0A?=
 =?us-ascii?Q?DVFp6WIEMGM1Dk/dV5p3ey2wASaVrkKbEngj2ktLd/r49dPjmdOJLe76Hnyt?=
 =?us-ascii?Q?dXKwjC1WbEWhynbsuwqi6ANl4OhuWVIYb4Z15HX78DNBVSLZkOTz/r4OLjH+?=
 =?us-ascii?Q?8E4XK5qcpErQylJgTt1lbCU0ZJOpEOuh67MVDvmfNhq+8lrQ3OQ+1/PdI1M8?=
 =?us-ascii?Q?YtiQjQ0zFmMETCBsmnJK328KopoMTyyNU8yoSkIDOiOSR/UBf5WBWlWFS9bd?=
 =?us-ascii?Q?v1iGMc/s7kHcGzGMf1r0fMYW6PFwrWbv4EIq+rDS8O0AE5APYO14th42hwjl?=
 =?us-ascii?Q?EMVCRmk/YUulonRimV805qfRq5+suvmN3PSjKzoihTP+uMVy5x8OZ4P1bYKX?=
 =?us-ascii?Q?N/pp+1nR/L70UlDMEjkUIaKRzQIt+aiygFkghQj/bnIpu0gBIoxF4Avz2xVs?=
 =?us-ascii?Q?uWH9LCHzdclQonNO1LO3EI5ee4uW8FHF4cnN+W68T64pbjZZLe09ABhU5Snd?=
 =?us-ascii?Q?5HkOqN4lLDxjgFjC6GhI1ksNqW7RJ0h07RNt7/iarD9BIb20pTHWSo3pw60R?=
 =?us-ascii?Q?CkUBkiiIB+fkc2FwvHsTLsambLZ532QqGJfx0VqFmSlcJ4U6M6x63+ymCecI?=
 =?us-ascii?Q?k22bSXZGET0SInMr8Zi8+YHyEmIq+GFIj1mQPY2v+eqT2dNYAQlYBrJhKhJJ?=
 =?us-ascii?Q?DgG/GBm1j4gncofnmkVOGYSITHHfndXT8NvxRKLWXo1XlgY6qjhRP9Odwl4c?=
 =?us-ascii?Q?7cBSvSZeTMZVWJgm0fB6lm3Uqlvh8oU9LUyNtebQSeciwhltqiMlo1K3NkhT?=
 =?us-ascii?Q?d5wfFtJt995szrz1bXUDf0lPX1PAoq5UIJXqd7NysgHwietH0YdcXZJ1mwgB?=
 =?us-ascii?Q?geRYCPKzMiO7tGW4SAMxMaLqq6U4zVKMWXWGDheY6HIsvgeyFLgmdsHLJZ2a?=
 =?us-ascii?Q?9e6i59B2tNtXEkjuc76mQkgf6IM2qIAkkDp7lks1LoRH/CDNrQFcSLAgZm0F?=
 =?us-ascii?Q?7f1Npiqy6vU6K+k/MJMUlSceC1d30mpRBNNkL/ZL/dDFL/nMCnOzU4mkTKyF?=
 =?us-ascii?Q?sKV0K9RIG/dUpShrOwsRDy2N3wVHe5sUtM1nLg48Sutd3hlUjeGmRlWjVlMg?=
 =?us-ascii?Q?jf/sgnnlBWQIbzcs2hxoN1xj+yGjZH2hdDTrBu7H03wi6L4HrSScuX4ZNE3j?=
 =?us-ascii?Q?xApb39D/1TQlASnVMQWqBXAZ0xQdPaJFur2FgeLXyEmy4ZYaxHjWAW7j2mVL?=
 =?us-ascii?Q?6GqHPZ2QtnLlh27az45V1ERsaYivMP3FkFmB9pNAYY+miguc0Oqaa3OXmq7E?=
 =?us-ascii?Q?ZBcl+lxGOyPkmGS9toBxpSn+7jI9afveNZLPR1zHK7Mb6I5gsZ67GyQHqLbc?=
 =?us-ascii?Q?I7OeRSKmlbd7iUboHzWjBEtQBJk4v66OLC42Hfm1V9ttuShCUgNJjDAZ/T8e?=
 =?us-ascii?Q?Sg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9Ih1uP9YRUxknJcduD0dQ6nD2vwloZ6ECUK0F0c/WQ2sm66KwUGPUOYnT0enTUs/CvmsLYqBQWoWgIp4WCL4b3msbrGSpKTHk9v0Q0AUgE/t7IHaEuEg9UcWd1sNcXNOrVv5vCelUX/khR2nQ5MwGVHlr6jUr85IOOmzXvkglNHFs7wusMLHpsH2dWZIztBzGpxfj5ok8jI5yg9/kbeNWXpL5+xRb0heOl5yf7bdMY8BHHmoKnHBTm+thtM1kektlAKL+CffguIqxCdGLzcOfFIKGV8YrQxdjc0trl21+YC0XBY//wRHHlh7kLZHoH9fnNsGFyZ6jeKd3ya+1wKmLUd02qVVpSV69e0+RaSDEtSAM27CDqcqIuBn/H2D87bSE0GuUVAmdfsuhYXW6o4Cs0weLEvtT5plsaQSHN187Wnh+6ntU4WO2a9tWoPfauW1FdRhEqGUDzxrCNh4AN5jpfc6pTQxXEKpD8pLkBptIz6Ru0NXD0Ho1ost3+i0d9VaSpTj+Zrq9IYB4lElvcgHrkYtmQkHUnOnIKPVIaGpUNdZple0LBrjkMlWe6jj7qEQ5ShAIgc4rX0edhjg35UDxEZ8kj/Q8yx9hHIrOekNahU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc1bbcdd-51ce-4eac-8831-08dcf765149e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 15:27:49.0445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kzdBW9QaWVn1z3d18LXyCUxudQQVWGuwZRnBP+TmLPFnTFZR3lIL7a0JshylGrHtK2aJYZlqnlUmGIqD08Q3CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4170
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-28_04,2024-10-28_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410280123
X-Proofpoint-GUID: 74FKbV-mPz-HDyO3drbJM_inbF3qdz6K
X-Proofpoint-ORIG-GUID: 74FKbV-mPz-HDyO3drbJM_inbF3qdz6K

This is disallowed.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/bio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index 42cac7c46e55..ac2b11b164af 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1749,6 +1749,10 @@ struct bio *bio_split(struct bio *bio, int sectors,
 	if (WARN_ON_ONCE(bio_op(bio) == REQ_OP_ZONE_APPEND))
 		return ERR_PTR(-EINVAL);
 
+	/* atomic writes cannot be split */
+	if (bio->bi_opf & REQ_ATOMIC)
+		return ERR_PTR(-EINVAL);
+
 	split = bio_alloc_clone(bio->bi_bdev, bio, gfp, bs);
 	if (!split)
 		return ERR_PTR(-ENOMEM);
-- 
2.31.1

