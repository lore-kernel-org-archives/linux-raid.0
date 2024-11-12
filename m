Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A2D204001
	for <linux-raid@vger.kernel.org>; Tue, 12 Nov 2024 16:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731427853; cv=fail; b=ddNCbKXQ2jChE8TdOOjqn67A8AvsNbegok12vTKUJpwgDLLh737URbLzNUfM/voz1SVWPPDfPEq9LsCuV+2j3B08LTjkqxt94lxJ+Cb/QUVMGxZWIGOCBOgeycNthDsP+ExNVHF+52MmlO+Ca6KxDNdwKNQluECfpYMYiLXvG10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731427853; c=relaxed/simple;
	bh=2OwTbD0XBnMpC7ElFMuM1aHj87nkYMIgwOC6cakQguo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AInKk3d9p81pydqLttSvhLUXzieKadbwafhKnpEcdPPzR+8XrwN8lPV4Z5SDBSeyChcNhfNrLAvvqclUgTWIgLa+odcHAqQrlVI8uuGc832UgG+kPLbSIHv6D4ji4F4UAtLPyzNHCWRm4d3kQ2KWPoSO8iOXcRWOEbUIhRj0xfY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WhpfKyvW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NSzBHTks; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WhpfKyvW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NSzBHTks"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACFNg8C004572;
	Tue, 12 Nov 2024 16:10:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=lpiJFl4sjcS201aWIZxVeQvY6xhuMYeQ0SLTTBFwi8g=; b=
	WhpfKyvW7wO2kRhVaGgpUoEI74vRLc6x5Jpb3uebSXbuFfMIkGnctg4QRysBr+7e
	5+nbKIMGS4Ifs41I79f7YRwTRxSHbuqGaQhOU29Rso89M49qU9HiWj5U1/Shd2j8
	ykYo5akNHHst/K92L6eufkhB0uRzi5S574IUQ8gtnT4O3y2tqidehImnCOhyPTvR
	FDZ6FVVbSozfKC6d/28S6mz4UppllfSSHsPr/rRbtlTbc+Huovd0kP+BRUwlBk+Q
	HUfdGyWDpF3+CZVe0lEcVrc6jsVjIuQYILP9YW800DFKSC/1kmi2GmFm2Dl2frgW
	XglAyahQwOc9++m50jikYQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0k24s4d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 16:10:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACFv3X8001233;
	Tue, 12 Nov 2024 16:10:39 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2040.outbound.protection.outlook.com [104.47.70.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42sx68c910-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 16:10:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ks++B8jBlW4gRdgWVdkVV2b7vAGhlLV25u8duI2NoxDPdfTLqqVCFtYGGkXyCHdE+jauaifMmAbVWdp4bzA7xsxCDWSLtyjz8PHzk0rgJx9B8fojPzPpD/ku7j/huf0rAxD8cbTIbdOhWDLWiRyFrWWrU1bwYj5V94GrdPhOZrCIfecMDztMtxLKGEx0y/ws6OK4qIoh4XPIzWEScT0+sQjvRLyDWLDZfgpcvdHQ+FuPq+q9jdrjxXTssOhy2VdOiwas2gQ5ZgL6W+qQTvCsTwHjHBAw+Rb443hNqzceSIK7o+duAnYKlDVK7BsaPqKyrituVdVUhYqZXuvib4vUTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lpiJFl4sjcS201aWIZxVeQvY6xhuMYeQ0SLTTBFwi8g=;
 b=vkC0FpFvWC61BBcqUgEOclRz5U2Cs+T8aB2kVwYspWHRuGedQOGElIQwXcPM8NjlbWzs88OmzMdfEET09xBqt4uzf+38gOl8J4jGH7IwH0eaMLvA7dbVOKxWtsC+5byZ0xT+g25kxK274yYfrLiE80qcew711FbBdzaHX1wH3Gol3xdb/gVYlWv6iNIRQCV7d1bTY4hNti7QC6/a9+nNDniS/+yVhsPGV827TvSua4U2i5wg0tJLeVjOAmfvFzdr9SmX3zmATu3TEiOQyOos+gsIazPfoy8Qr5hobUNorsNeJ/ZfZ0ffieduMKpY9Be7HhG97V1s7XcIthRVV4X2TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lpiJFl4sjcS201aWIZxVeQvY6xhuMYeQ0SLTTBFwi8g=;
 b=NSzBHTkssmU2OTNyhDg9aoZl0Q+//QbWXsRSYOfxdUoT2vfwoshZl53dosBipbmeJ8dC28LBKKPIKVvIe7u8jCG+IYKalMj3udKAxu56GThT+GXfjhKNxiBwrlhyP6e6larWiW3rHLZtVuSaeoYlpAFCZsJ0Nqq7mOfKzJkfcjM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW5PR10MB5761.namprd10.prod.outlook.com (2603:10b6:303:19a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Tue, 12 Nov
 2024 16:10:36 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 16:10:36 +0000
From: John Garry <john.g.garry@oracle.com>
To: song@kernel.org, yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 2/2] dm vdo: Increase MAX_VDO_WORK_QUEUE_NAME_LEN size
Date: Tue, 12 Nov 2024 16:10:19 +0000
Message-Id: <20241112161019.4154616-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241112161019.4154616-1-john.g.garry@oracle.com>
References: <20241112161019.4154616-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0434.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::7) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW5PR10MB5761:EE_
X-MS-Office365-Filtering-Correlation-Id: 78838636-bd94-48e9-280c-08dd03348b1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?djU4VTFWanROMnlaYm94a244NE8rUUNWWlo4Zjl5SG9PMFAwVGdFaHZTcFpw?=
 =?utf-8?B?NGZmNE84N0JKcExNUFErdHNSaFRROTlzdFVpYWFjOWVxZ1pXWGpiNG00OTlN?=
 =?utf-8?B?NEtRZmV4Z0tGZFVyZktHMlRxZUh0bUhBQVE5WGpZNXhwQUNVMEFaVnZwYmRi?=
 =?utf-8?B?bjBNaFlSdzhHQWlLVzg5V0t6cUlIdEtUZU0xMzhTdFhwUTU1S0kwTnpxZ0ov?=
 =?utf-8?B?ckF4UmpLWEo1dmJxUGpCSUI0SUFUSWMzcmhpSGZGbDQ0Rlh2K2FmbTdDb01i?=
 =?utf-8?B?dGRmMFNLTmdNRTdVeHRMVk83WlBiQ0pTRjVLdGpIdWhuRm9ROStUMi9adUhC?=
 =?utf-8?B?eXgvQzZ4N00rNzlhaXdaTks5aUpONHd3cXM0cE9CVFlrYk84L1pXeE12V0tr?=
 =?utf-8?B?OC94SmR0SXZkcUpEQTVkRnBpNXhCNzJ0bWovRDlKUkRTOVJDTWtFb1lQYXk5?=
 =?utf-8?B?MC9rYWM3UTIvUi9LMGI3YW04N0VnV0UxcGowbGZ0dFRYMHI2T1JvMDczc1RT?=
 =?utf-8?B?bG05c1ZKWXdPQktYOEhYR2ZqWHRyVUl2SHh0T1ZaZnJDZXR5a2lMcXAvR2Z2?=
 =?utf-8?B?aXgzS1FHcytLSXg4NDdCcHZHTW5Ha3RMTk05Um91KzRIMlp4Sk0zREFiSkpx?=
 =?utf-8?B?bytQWmJ5YVE2U2RxeVBRR29ORWo5ZFl6YTNYVGdBUE42R3RtWjBicTByNmdp?=
 =?utf-8?B?L2VYdk9oSHFlTUV2ZGszUU5NZ1RFVHhJTlhFUHRJQVU5VGZUWjk0MlBycDFG?=
 =?utf-8?B?eXk0WVhydzgxL01KMXhzbWkxK2FyZTZTTXZBM0QydXRCbWdxMURQVG4xbWFT?=
 =?utf-8?B?cGZqMld1c3REK1V3T3dFWlorM2Q5VGpwZldQeU5qQVR5UnFmUE9zYUNsWUgz?=
 =?utf-8?B?ck1tRVdJWFRvaXcyQzMrUEFnSE9wSXBQV1AwYUZVV3RUN0tyTk5tUVI2eXlW?=
 =?utf-8?B?Q2FpaHRlT1k2Z1FFdVgvVkVycVV5L3BrUE83NkduWHliUmZXcFNNL0dyNm16?=
 =?utf-8?B?NUpNbHZrNlRrMGZOQllBMWFId3NKaVRWL2tQZ0p3K0g1T2NhckgyckxuZUxP?=
 =?utf-8?B?bEJlOU8xR1h0MGRPNFdHRk9HTXoxU21HZzJZdEJKU2FxeDM4VGxOYVFnbFNJ?=
 =?utf-8?B?S1R0UWlGQWcvenpNSERYdWJPWVBCNXlTbnlpeUViV2ZMOHl3WnZsVDh1YUVE?=
 =?utf-8?B?N0M1TW0xcjV4ekYvelFEQmt2ek1sVjgwTEZoYjdkd1lWS3J4WGljYmxDbEs1?=
 =?utf-8?B?cTNSb2g1V0E2MmtWaSt5VjRoMFF2Zm41Q2NEU01PQnl0NHVHR3kwWERTWlJn?=
 =?utf-8?B?OWpMLzlpdlpsUmlyL1YrMjRFODFKUXkzTjVHdm9GM2hLVU41L2FITkF4YjNH?=
 =?utf-8?B?SXE5QUthR0tsdm5ndjJhc1F6akZ6bit5WXVLbGFaU1phWmdOdUdoSG02b0gv?=
 =?utf-8?B?RmY5ZUp2ZXJKN25EN1REMHFxam52R2ZkSWRNZEYwazVCREhNTDV5QURaUlFH?=
 =?utf-8?B?SzE2enk1RVhKVERWQWtvczhGNHFwU25hRzZOTHNxRXRJcG1GSURmL0pGeU5C?=
 =?utf-8?B?RFpMMDhDZHJYMnhOckJmai96QlByM1NjWE81WmtsQkJycDBDQlAzcGJOcmNN?=
 =?utf-8?B?TkpZbjN5bDZOM202VVBEc1RlRUFEaFVnYk1VdlBnN3lHbEt0clI2bEJBZEhV?=
 =?utf-8?B?eU9GcW8walRWbVZmUklSQjRNMDBYRTJlbHRHRW1YWVJDRkw5bEIzY1ZrMnZv?=
 =?utf-8?Q?K5cSiRZSbiFXOgn09U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dCtySm5vdjRJNUtJbVY5RWpWVE9EUnF3UjhKWEZYMjU4MHZNVW1IZ2U1ZWta?=
 =?utf-8?B?RTRMUkxTcldnMlg0TDhNdHhUanpmSzNpbE5sMGhlN1F3ZUc3WXRTR251UEtv?=
 =?utf-8?B?cVlZNzAxTkkzSUJmU052djk2ZXMvcjRFRXRVNE5xRFpGdk1OTXBreVc0OGNm?=
 =?utf-8?B?SHhybGpwR3BZS3VCbDdRNDJOY2l0RXhFMittcVM3QzMzUlVyM2dRdVZuL0Zr?=
 =?utf-8?B?UytkZVRMd09ZTG9TQjF2UDlLS2JucG1YY3paK0ZhSzNqQVc3SzcxckhTT04r?=
 =?utf-8?B?NXQvNU9DZGt2R05NRjVRN01KbjhKT0JlbU5helQyb0hFQURXQnE0QnY1SnV5?=
 =?utf-8?B?SkZpYVY4RTJHeHBveCs0Wk9mM09LZXpjNy9TYXlwclVYc0NRMmx4d2pJYVdX?=
 =?utf-8?B?QWw2aXkvdE1XQUgwTGNqeStISURaTS9jWERSVDV4bmRVRldkVGtuMlRuNTUz?=
 =?utf-8?B?SXduci9lZGg2ek9YY05ncTY1MXpmamtWbFEyL3NzeG0wVmIwZkdCQmVEY0tT?=
 =?utf-8?B?THEzVm54UC9vU2NNckZxR01DT0d0NGFmWE5JcWwrTjBjMTFVblAxbEFiajZk?=
 =?utf-8?B?QU5VYU85Nkhid3JUS2o0cTV5TmJjeTBvd2I5WkdnUlFvOElERGxjQnE0Y1Q5?=
 =?utf-8?B?RW13OEV3QmI0aytrUlJhVWtjSmloK1pKejVyRC8rQ1poSUNkcG5vSVZBN0x0?=
 =?utf-8?B?WkJVbkFuRnRCYkF4NnhzQlBZUGpLdXExNWVBNkR3bGNLd0d3dnlqendNWjg1?=
 =?utf-8?B?NkEzTWhLZkY4aGdzdkZ4c29Rd2lYUWgwVnlJYVF3d1psTCt5UzlvMXNNSGsw?=
 =?utf-8?B?eVlUa204Yi9GdjRHSXJsVmpmTlJPWlREUEJsK3g4Y3FLU3JGYytFVTFjbXVF?=
 =?utf-8?B?OGFFQjAzSHdiWTdzaWx1N3NGdmsvbmVwcFJhWmxOMGYwQUN1UEFENE1JVEJD?=
 =?utf-8?B?cDlQNC9Qd2k2MEpKMVdlMkpjL1NMMlRkQTRULzE3dzQ1ejhtNFlOWWkxRjNz?=
 =?utf-8?B?YVdUcWJVRXFXN3lBczcrUm5iTysxKzlNTWdsZjZYS3VHODZoS1dGazl6bndF?=
 =?utf-8?B?VzBpOENXYUpTa2lpYjRnNkJVNy9PNnhyYkRvcjRPaitpQ2tlQ2RGUG5DYkNZ?=
 =?utf-8?B?SG1vK3l2MWE3TG5sN21QNWtiSHZYOGtVRHZDbUY0NnJ1Z1JrbEVLaWNUNWZo?=
 =?utf-8?B?N2d0UzJ3MVhDTk0wekd1R25BMHE4QTVza3UzVDFITC9ZeGhQK1B6T0pqaUhB?=
 =?utf-8?B?cHNBeERxU0taSWJtYVl1OE04eWh1WEtIUmU0ajJ1UVNkdDkrSjBzWWJiZmxJ?=
 =?utf-8?B?Rmd0MTRMTEY2WkVISUNuQk9JTllJRWEvZmpyUUMvckFRbndCb2pQNFUxRFg2?=
 =?utf-8?B?OU9kb05zT2tpVzFnLzNaNEttLzVkbzYxb3ZmUmR6Z3NSSzZPL0pMdDc1VXFO?=
 =?utf-8?B?cVliTFdNaTJiS1c2YVRZVUg2Q0xhL0k2TWhFUWlpWC96czBJcHJOUXlNUlVy?=
 =?utf-8?B?UjJUdE5BZzlRM3oyaUxMeUxJczBYeVZPWFI5VS9IMmZmdnVBUUxmNVBhR0V3?=
 =?utf-8?B?c0hSd1dLa0dTci9oMFNjNjd3d1d1SFpUN3J5OU5SOTc3LzhtRGRGeFI1dFA2?=
 =?utf-8?B?eE9oOW1RRWdjUWllM1FVWENkTHZZSi9zakhrTExUbmlPanJ3RmxVWkV6SXlz?=
 =?utf-8?B?MTJBd2M4WWV4eXVmaGt4NW5FSlNTQ0M3Qmk5SFJaTEllclZRdVhFTTJ6OGt2?=
 =?utf-8?B?R2hrcit5YWN0QXkyM2tmdWphbWEzbFJtMCs2K003T3RScEFvMU5JSDNDODV1?=
 =?utf-8?B?bktQY1ppRUhmMzNFMWJFRzdMY2dzdkVUSlp6c1ZKZW04L0lJelFaRm1VYk8x?=
 =?utf-8?B?bDVHVHIxWnU0bDRpY1RCYzFQMkxMZjgxYlpxMWRXc3FzRjJ3c0hHQlVGZkhU?=
 =?utf-8?B?bGxtdW9HdHc4d1MwTFpMeGt6b2xuM25lSXBQcmxjTGZMcjJlZjhzNUNoWjFh?=
 =?utf-8?B?dlh1KzhpZkw5NnhIVXVrRXRTbzJSWFpxQlBJcDFXMmVteFlya2JWSjljRG9E?=
 =?utf-8?B?NUZVNGFGT2F1UjVMekZkNERiYVpUbk5RdkNiR3IwYkJTWmtPclZ5STlsUFpp?=
 =?utf-8?B?OU9lM3JjYnZBaE5zOTd0MVQ3TXI4TmNBc3NSMElsZk1IQkZubUh5THNibm1h?=
 =?utf-8?B?dmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WkrgOyXuW9pfj17sGDQsU3Oq6AR9dSY//1EfhnsDcBdYGkYrlh5hgepTYOHNPYsD+JOaBxbXXQY3mBF0eX5O4pZWfhatUTnxP4sHMheIT3CKAWtqmGHh9y3zki7hCnzZi/el1QiEfvRSYY7ecu13PHKx6KgytWkWZOr7Non+vESpHVWsNbJgxlrguZV+RmiQ9xGbQCxks1jmOp1qlm6RYw92M9sr8jbsSwWsi3A2V5CRAMdmz0KhvHpj9lW4lpE6Qw/0Rddj52z2LndmJvypehX98g1vGgR4Qe9wESyQ5dMIZbArrfhir/nh5e+vM8mDyUYtjiCLWXi6Ejp376a1XNy1OYoQ6QMtf5biCDSgRhQaaNkHjgoYPBobeTed0XcJlIr1zdS+p8IMCjmacGF0Z7QBid25NEqKzVafi+fyrJSmq0gpkEfB2WwIu/y6uVaV2P+2VAub4Ty47XvEg8sgP44jw7Rg3Wk+4gPtuqSOMqwhnE6rKZkUzdf/9OvuH9Tk1E3OTl182UIeNip+L2T5vUe0NsCdAQgknMKIM22+kfpWBNJbN3iO4UI1WnZamG+XTvwJ+Rpkh7fajrYEkZL0xFEYElep4IRjdYR6fPfSwC4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78838636-bd94-48e9-280c-08dd03348b1a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 16:10:36.5351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LkVwvBE2KSc9dEVM5CRJWHi7VlCbgPQtDIMW6DzpaxgNLz9Ky5S9fX8j/FdaJ8A3kgQRYav4lpEsLhC4XXYvoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5761
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-12_06,2024-11-12_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411120129
X-Proofpoint-ORIG-GUID: Jy3kzpzmkZ5xPXrYPig3v9PrqMxObdh-
X-Proofpoint-GUID: Jy3kzpzmkZ5xPXrYPig3v9PrqMxObdh-

For compiling with W=1 and allmodconfig, the following warning can be seen:

drivers/md/dm-vdo/vdo.c: In function ‘vdo_make’:
drivers/md/dm-vdo/vdo.c:562:19: error: ‘%s’ directive output may be truncated writing up to 55 bytes into a region of size 16 [-Werror=format-truncation=]
  562 |                  "%s%u", MODULE_NAME, instance);
      |                   ^~
drivers/md/dm-vdo/vdo.c:561:9: note: ‘snprintf’ output between 2 and 66 bytes into a destination of size 16
  561 |         snprintf(vdo->thread_name_prefix, sizeof(vdo->thread_name_prefix),
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  562 |                  "%s%u", MODULE_NAME, instance);
      |                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

Increase MAX_VDO_WORK_QUEUE_NAME_LEN in size to deal with this.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/dm-vdo/funnel-workqueue.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-vdo/funnel-workqueue.h b/drivers/md/dm-vdo/funnel-workqueue.h
index b5be6e9e83bc..6307fe811ca0 100644
--- a/drivers/md/dm-vdo/funnel-workqueue.h
+++ b/drivers/md/dm-vdo/funnel-workqueue.h
@@ -11,7 +11,7 @@
 #include "types.h"
 
 enum {
-	MAX_VDO_WORK_QUEUE_NAME_LEN = TASK_COMM_LEN,
+	MAX_VDO_WORK_QUEUE_NAME_LEN = TASK_COMM_LEN + 41,
 };
 
 struct vdo_work_queue_type {
-- 
2.31.1

