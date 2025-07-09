Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30C4287268
	for <linux-raid@vger.kernel.org>; Wed,  9 Jul 2025 10:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752058129; cv=fail; b=ZhM7v5EpRRav5qTvJ0oqy0JBwrJcf7e49t7VlfyRxg8JXfTs6bFiEf4fL3ThgykyKtXr4m39QNRvwGtpAhPVOcxf+k9ez9hjAXZHJ2oxyffWfaDB1bWqlFNg2KKd2CVluFY+KnBEP9eNn6m6qaR5oULEYUqYQUvn9iOGOVIdzN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752058129; c=relaxed/simple;
	bh=51Xr0pbWbce73kRBnFk6CkBecNnVUSpSnFAblkHK7BA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=CezgDZYpHraSIdPR2xlQS6Reqg8wiSgSf85+hPWpN1cJRQ0p2mYKFhcgrZtzEBen0dD873AYOKDs5W1GO1eIQerm4hmkdlOFkKiM1JqbAAFLUd6ybT70cSm49z9v1hOVzMQ08UWsgT8kBdcMkgF5YNi5NQaFvLIPKKPxTk6/aUI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XGDo/RuQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=I70M7thM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XGDo/RuQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="I70M7thM"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5699jU2w027207;
	Wed, 9 Jul 2025 10:48:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=NO57QADB6FdlTh3j
	mFFd4g2ornj0jDraBC1xQiVIudo=; b=XGDo/RuQe45pWDmRT9lUEFfmp6DvYnyG
	WFMvR7I9v+lSGqEWLvoQo7nrRYZ1VgDMPsdAltCC0pGI2Wj4zAunp2QW0ry4UL1Z
	ofQApSxyuUXntmaeOO6KC62vzZslV4aXSzwfpm1L/0X9KV7QdTkdKZu0ioaBv9Wj
	JzCn8H8aDImRHqVgi1GNOtuV0KF2VjSu3n0bYbdHHrf8dnsho1qEvVLT09WXx2NM
	nUZmdUmzFazq0cEETCKJrJgvsdSUObRPzNnSigLNhEzNINVJeUBVUB3UpB43ELj9
	vqwc0sp7SyEGrVfYNUGsL/dmLFgFnTJRCgPWHf/K+IhhA8XA/xvz+Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47sp2rg31g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 10:48:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56996bxb021449;
	Wed, 9 Jul 2025 10:48:37 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgat055-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 10:48:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SQt12Pbjg9cDgW0DcKNnffgBl/Pkn/okO9QAOxY3uhq3sDbCb4kREgJ3kDirC6iPjZ3H/bGkUcXeWlTDEhTz8yuPd1Oa56UuOH7g76UspYZ6sgV6wVgLeutoI3IPcrXuXJ8wNe192cTdCzOU/orwuHDCfADYrbTK7UhLW6EpJ/xGvvyMMeVQ2wO7M8B/IEdv7GLEHpyARG3DLibGMp/3R5ngtB5xTWRVFKx91Jm3dhL9D6YZ66WmC5kxIiARzQfK9d9JeHGqg+xHZgey4jlVcFEpVw0LVvanCsiCmPOOgrxR9FZtCWEE5xcWlTpL05xx5wrfMdlwGXMXDFAGuQPJKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NO57QADB6FdlTh3jmFFd4g2ornj0jDraBC1xQiVIudo=;
 b=VumyHi/jb2NphBV1g40ZIlMDN2C3C5YopixL7j4Cgxt5fcbUrqmr1wgDoWZKjza0Q0x0al6AJ28VoDp/sBp9otRrPIr1X2AuXF2G0zBBMzo4sHJXmNCRIRO+9U7fiFG0Br2T9AUZ6aMtO9JL8OdB9hjrRDtaLV6K3dl5iI/Iw114U72ZW1ar+ses09I3rmBwox24VsW8IqNI02TQqXQ6b9vAtdY438+wF2x/VRcIm0mljnEx7QySnr/9MtyXmMe/HEyLxqeq8k3lDOhnK1wVzAtjULPKyV1upq1yntbliH+ITKTw5Sdxu5wUebRF4/b8c81C7fnFQuaXlYo6ciB13A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NO57QADB6FdlTh3jmFFd4g2ornj0jDraBC1xQiVIudo=;
 b=I70M7thM5TZ1LDoclatIFeC1mWTZBRGmmGz8kjonxYvKQNAJm+YYrzRF2KdLa9LBupbsZor1ZCpha79ug5VBkqI196VXD9T7uZGK8U5fMoWsfY2wCutjBbAfJjX37Cn4XrEG2L6B5jMGd9wHH+CanYFbpxNhVIiqZlF1isL7cdE=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CH2PR10MB4120.namprd10.prod.outlook.com (2603:10b6:610:7d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.28; Wed, 9 Jul
 2025 10:48:33 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 10:48:33 +0000
From: John Garry <john.g.garry@oracle.com>
To: song@kernel.org, yukuai3@huawei.com, xni@redhat.com
Cc: linux-raid@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH] md/raid10: fix set but not used variable in sync_request_write()
Date: Wed,  9 Jul 2025 10:48:14 +0000
Message-ID: <20250709104814.2307276-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0P220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::10) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CH2PR10MB4120:EE_
X-MS-Office365-Filtering-Correlation-Id: 60655a06-7204-43b3-4d3b-08ddbed6260a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VHp2SW9pR3F0NlRyQ2ZmazY2cW41OUVpVmhhblcvakhvQVo3RFB3Sk5YQW1C?=
 =?utf-8?B?bXNyRlp5Z2xhQ0wzaktQOTJjWU1hZDJ3QWlpTXBQUkdkcENnUWwzd2V3TVhs?=
 =?utf-8?B?RjVKekRSREl3ays3V3ZwRnd0aWJONFFScEtlNzZEUG1FZ3VDRzFaWjBlQVpn?=
 =?utf-8?B?eUkwRUxHTHNjcCtLLy9ZNmpsdUpWc3h4SDBXUGt6TVA5Rm03QmVnWEVDRXpO?=
 =?utf-8?B?bVo4RC9VSkY0QUYxZ2lNRlhzbjZRVmdTU2lMZHlNaTlCeUpaSjRIalJPZzFT?=
 =?utf-8?B?V3NUUVhaWjg5Uzk5Z0tsK3NoZ1YvNStRZEI5TExsYnByQnh0aHVncXlKODJN?=
 =?utf-8?B?RDJyalZjcmpmYStNYmVIY1NMTE9iRklRVDFsUE5IQ1B1WmNGeWlrZ01TR0hx?=
 =?utf-8?B?YVRlMGFZcVhpQVg3cUZoSWpaeHZhUDRMK09LMzZ1cnlFaThOamFET2o3TTQ5?=
 =?utf-8?B?NEI5VjIvczhHZzJiUFlRamJNLzd1OW5MWHJMMkVTRnBFMzJkZGFGcG1hdkk5?=
 =?utf-8?B?Mk1WWStNM0N4WFRETjl1dFBNZkpETGZLSEE1SjU4cVlROUJIUFk1a2dBQ2Q0?=
 =?utf-8?B?NXRIaFBLSzV2Uk9ENHJNaU8wWTZaUXBiTWRHTDJ4NTdKUTNFSjloOGZabW5a?=
 =?utf-8?B?bGZIMStqa0VqYTJUY0hXbnE1TUtzekZLUWNlODQwc2l0TlUxQ0R3Q0N6NGJR?=
 =?utf-8?B?aFdObUhibVl3UkVmWU9pR2M5b2Z1Yy9NQkk3czIxanhzdVdqb2hrOXhOVFNM?=
 =?utf-8?B?cy9DM3VuTUYyL0wrQ3NOcTJjNXVBVnBDSzB6c0ZpeHJVRnkyOGE5NjUzTXN4?=
 =?utf-8?B?TkZKVERKZHliczlWZE80a1ZMdllOOVJMUC9oZzhkRU1zTjRVcnR3VWdJeDdo?=
 =?utf-8?B?V0FEUWRSSER3OU0zT2RYVEo3U3hsaC9rV0pWNFF4VzJNSDc2cGk4VWN4bXdq?=
 =?utf-8?B?VFByd3I4TmxXaURPNUhBUDV1akZUdGdqQzdVT05yZ1NZRFd3c3FqYXJ4OHV5?=
 =?utf-8?B?Rk9WS282bEF5N25CMm9HT0l2TDg5KzM2bkFtd0drYUhicFU2b2M3SVY5OGs2?=
 =?utf-8?B?MWl0OHJIeTNSdVVVNjR2M3F3ZUpYQ3dITVh1SFU4bUxiN3BTcHBnT2lZWGto?=
 =?utf-8?B?RlBmTkwvRGNzMWpQSXdNOWFEZXFhdW5wcGI2QUp0VGZJeStkcDdqelFYa1Vn?=
 =?utf-8?B?NENkR3Rzd0w5THRtNVoya0NHbzNPem1oOEZySEVJazNWK21FQm5PSnprSFhi?=
 =?utf-8?B?dDlkNE84aE1XWCtYOUYwbHNDSUJiTkJZUVlzaE9aS0g0L2NUT202OUxjc1Zl?=
 =?utf-8?B?T3dzNHVhMnloN2dia2JSYkVxbHkyckJMNDlxeUlGLzZWUkxsdjFRMVAwUkRZ?=
 =?utf-8?B?dUoyN3FEdGhXQjI0U1N6Zm1BVmdrb3cycHRVbEw0b1Erc2h0TmJuaDZnWGRj?=
 =?utf-8?B?TXhtRkJNV0swTGNtUWowQ3BleXI0VTRXUDlRVWpxdTMrT2g0amMxdVJPNUNj?=
 =?utf-8?B?RUkrTzNnelRJR3puR1RuanhXNGt2L3JGSi9OUXRnTlZWZGxRb3hISmFMaEFF?=
 =?utf-8?B?cm1kTnNsMUszK3JIdFd3YmZKbkowVWxwUW0xcGdFYTVBTVpkV2wwNzVyVHpQ?=
 =?utf-8?B?ZVlIRzUwalQyTCtIamxqYkdNS3VlejJNcmJnaGt3S2xTOEZVT2lIbnhvdlFD?=
 =?utf-8?B?blpRS0tSUHZUWWpwNUNWRHBwNWIzaHpvYkFZakZjd01DT2pjQmxHRXNneU9G?=
 =?utf-8?B?NFZ0Tkg4V2o4Tk5waHh0UlVhb2RNV2FwWTVuT2M2VUJkTjV2UkVTUnRMREZP?=
 =?utf-8?B?MlNDQTRaODQvdWJ6K3R2ZndZb04wUlFQU1dDaDI5aVZoblpaQnZwZktUV0Vk?=
 =?utf-8?B?dThPNkI5WHM3UHA0NGlVYzNWMXRBMUIxbnZycHJaaGVhcjYyVWdtRDdXMmV1?=
 =?utf-8?Q?BUkYuY849+s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bVMyc1Jkc3JzaExXTlNFS2dNeWhzRG1vUStWMUtrTjIwTStRcHlQRXhwenZs?=
 =?utf-8?B?NXYvUkl5UHAveHJ3UkNHY2VwQjEzbjYyVHl0WE1KQkViVnZuNU40dDRaM05l?=
 =?utf-8?B?UE5waTdoNTZST3daTEhrMmE1RmhhTlBWUHBvWWY5S0VoaDlreWtXQ0dJd3Fi?=
 =?utf-8?B?SzhnQlBXOGtPUGJ4QXR1OElTMTE3L2tpQTVjRVpBWWc5NXVBazVQdHB5ZnFt?=
 =?utf-8?B?TlRrZHlFa3BueitmV2J6NGx3RCs2SFQvVlUwWWMxWmJOa3Z6ME9wendvT2pm?=
 =?utf-8?B?T3R3eUtWc1djK04vWTErMzgrTHJQV3F0R0plODlUMG4vN0ZrRGlRNThONU44?=
 =?utf-8?B?VnJDQkhtSm5QQUQ3R0VCTGpBRWxuMFhGSUp6OEZYOHhtR1JNSUwxdWVkdFRW?=
 =?utf-8?B?YnNPajZqVkx2YWRiM2IrVFNCVTdvOGZ4RG8wL05BS2pmc0FVR1ZZYWhrNCtw?=
 =?utf-8?B?VjIwYStWMHlkMjY1V21lTkdMSy9reU9IL2tnOTFjY3lJUnVPdE5PNHJjQjNG?=
 =?utf-8?B?NjZVYmZ1OWhqQjB6NTVnb1Y1ZFdEeEpUSEtXZ1pjZUZjUXM4NGVnYVBxTE1I?=
 =?utf-8?B?bXBSbU1ONFJhRFlJaklYQ0NsMmw2dTFYazVrdnNVQlNKWXpRaElDS1JqWndZ?=
 =?utf-8?B?UXNXejY3bXdOMUhOeWxiYm81RGg0V0owRmpDZGZBZXdWU2E1Nm5KVmhzbVFs?=
 =?utf-8?B?VkNHRm1SVmwwWGViemsvS0dlb2ZJdSsvb1ptd0UyRzh6aXZ6eU5QU0xqWHJq?=
 =?utf-8?B?VzYyMDB3clFGODBjS2p2dzFsaGhZQnJjdEV4a3lkUlJZdVljRzBYZ3Q1TXpX?=
 =?utf-8?B?SVRZTGFtRHJHKzFQSG1xMkR0S1psalkydlR6N0kyNVRQaitTdWdLM3I3dFJr?=
 =?utf-8?B?TWIvSDJ4eDJhcFUzcjNCdkFmSGxRb0R2WFROZ1VWWG1yb0ZyZXZZNlBqMzRs?=
 =?utf-8?B?NkpiNTdCYlY5UUZuKzQ5Vnd6Sno5SFNjTzBLL042Vm1GKzlsSUFmcTBBSUFM?=
 =?utf-8?B?WWowNTFCVnJCalpJUWJjSWdEbVBVcXJ0Zm53NEw4bjZrSFVORVp3bjJjQ0VB?=
 =?utf-8?B?VDdrcnlORjQ5bkFvQlF3MEp5Syt0cWM0UG9GUFJJY2ZJM3FPeXE0VDZ3V3J0?=
 =?utf-8?B?NW1XMHdGaURvMXlTRk1rbVA0bWxZYWowWWlnUzM4blRkM0RXbEJRSGFIaFds?=
 =?utf-8?B?WjFxWk8wbG9icURNL3BpYXU2Z2hPcGlwL0FvajJNUEwxb0xaanh1NnRydk9J?=
 =?utf-8?B?djBSM1BCVXZlandpMnlsYnYxZFpTN2sxeW5YZ0QxWEoydDRCOEFwYXV0UHox?=
 =?utf-8?B?WEx3Z3I0dm43d2tYMDRhL25UMGx6T01sMmdJNndQWFVxcDZ0MGYxSDRPQXJu?=
 =?utf-8?B?UXNnYUkzd2NYNmhBakh2cjdZSjNjK2RqSGFqTXdJT291bUlQamlRdXBrZ1Rx?=
 =?utf-8?B?RzVtYW5OazRNTHBYRFgxSThuS3BmNlRuQmVmVnJZNVBlVmpTSlNLaGxHODZE?=
 =?utf-8?B?ZUlWaTg0bkNCdEsvcU1KMkR2dWFkamthZ052NVd3aDNvd2VPcmZ2RUhhSWZ5?=
 =?utf-8?B?U0htR2NVZ2NCd0Z0YkcrTHVydDRIY0pGdDNTZ0U3WVFPeXFlVll4VnlKOTEr?=
 =?utf-8?B?cDRsMUxqZWxHWEh3RGljSDU4d25PeU03d202eHNwYTh4MmV3bUNISzAwakVu?=
 =?utf-8?B?V25abUx0aVlOaDlIZFFnK2kxYmZZdHF0Ry9CK1hTT01Fdk9wZmdhRU5lcU5a?=
 =?utf-8?B?eEhXdmZJaWgwVFZiMlFGOC9oSjZQMTVmakV3dTdldDNzMzhRM3ZBTHlvQjVU?=
 =?utf-8?B?QmhNZWU3RXRWRUF5blVoTThxa3dTanZUbHpmNkY0Nld6REo1bXNqaW0vditL?=
 =?utf-8?B?bVZ0cFRnRkY3U052cWxQVTBXelQzcHMzcmp5bm1JQTg0Rmp2OXl4YzI2bWVn?=
 =?utf-8?B?Tk9wdTZPclhxc1RDdk5RR1R2ZGZ5RlJVQnY0MVF4S1lNdlg4Ykl4VjRnYmRM?=
 =?utf-8?B?NWVuQU0xUkZxSzJpbTdobUUrWmFWcVpQNmdjT28rZkYwdUdwRkJ0ZS9IOVVn?=
 =?utf-8?B?ckpRYzk1dUEvNDVybG50dURlZWhkRWFwdHVlcFBSMzdOT1cyVVRlVitvazhK?=
 =?utf-8?B?UUFQckM3NXN1eVdkQlExOC9UTWFCK1pxd29HZ0hoalNtWG9XTC9KY0lZRVlY?=
 =?utf-8?B?Nnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DL3x6mmhiB5wEPsnH7ekdry09klHVZfFi+TJutTt5iOHCkR7zO3B+7pnHeTDtirId31m19O9vH1heHK8HNWk1E8vsMBDo8Urx9YOOhChcb/Fgl76l5IiAce4FR1t/Z0FWmMFO6qq1QjpZaYi0DW3vYXVuAKwNRz35C8adwEnztJScl/msDtAkT5sTRoWeuq5ByyKbDaMR0PIr6lWoNDTcfuxgQffrxL++/qVMcRlzpK8Qoccbw2DSWpMoDuUBglUGPafWwpW/jbdMQSEVyMPYfOxZuVwE/jN/My+qfRwhOJwXKCmI+J7xurhuYGI9M6rFxnX3P3OvqIOfnYBokQJEiw3nThquCgyJKtc5s808WTnKobS5kCX9JSpiL/+M0FbaHXV2BKL2FpYMmugNhXlkipWAVBc/Gb18kS/0jXBfUqmUb6wOeGZD/OLA1fbX9dtiscs6CeMr4IiomF8lRbBg67X+2poGucwUSTee30MT9fGWAWPgpoy4uHssOf/30MSzO70ZvXEBTRKxQBg0dzNPhTGN3GZXbtybRQAueUfLMqgTRLSeL5l1kP5dZjil43ASdnIhttnCvtdyEcgovqV7HNHih50w+h1Ppw/w27xrzs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60655a06-7204-43b3-4d3b-08ddbed6260a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 10:48:32.9788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +mt14yTZfd2ZdHiGd4mCyqvsXY5CP8MgfDp/3OiXYGLIsJcf9dvw+LVIGszmFHRnqxWmqWPQ4zYcL4atxEm0OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4120
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-09_02,2025-07-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507090097
X-Authority-Analysis: v=2.4 cv=e4EGSbp/ c=1 sm=1 tr=0 ts=686e4906 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=PREHeVDh43t4ZJ43DO4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 0xnUOf2ru1XgDYWZGKd14Uo7q5oQwKtf
X-Proofpoint-ORIG-GUID: 0xnUOf2ru1XgDYWZGKd14Uo7q5oQwKtf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA5MDA5NyBTYWx0ZWRfX0dVR6P1WpBhp pqG4kVjjfgx3SJeBbqRIzrs84559b1Jl4p3obRUT3248sNR2RkoSlNP83RwYv8ZtpIKSH+SR7IR guJg0zZsXqqndnQ+O98DSWfdhSmig3C+Vd6x5dy5dVJkcoWVE+l2Vf6REEPaSzyTVsLSCzl9v/t
 /CjJCQOI+T0ImxMOXm2xsS3gOuwF7Q/nvvFta8LGpiC9lB/NqNLeMHphI+HSCamRi0JlE+q+0Eg HoAiEwMULF6G0sMotl/adjzHzlymweGlz7RzgXaA1AVmjmn5u7UlnFtnWheJpPFYjxHX4hZPxV4 rNEgr5jg++rX0lUaGQOpQvi6zlAkj+QSrTRzcAJbFjeT2YmGOGotMPiGX8orna54KH9GAzMp8E9
 YrZaRSIvzvFx83314F6w18HVzYl66DmNbW9urbxa2oUlqjwULYvREesgIt6nVe3Jrt79H16z

Building with W=1 reports the following:

drivers/md/raid10.c: In function ‘sync_request_write’:
drivers/md/raid10.c:2441:21: error: variable ‘d’ set but not used [-Werror=unused-but-set-variable]
 2441 |                 int d;
      |                     ^
cc1: all warnings being treated as errors

Remove the usage of that variable.

Fixes: 752d0464b78a ("md: clean up accounting for issued sync IO")
Signed-off-by: John Garry <john.g.garry@oracle.com>

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b74780af4c22..30b860d05dcc 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2438,15 +2438,12 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	 * that are active
 	 */
 	for (i = 0; i < conf->copies; i++) {
-		int d;
-
 		tbio = r10_bio->devs[i].repl_bio;
 		if (!tbio || !tbio->bi_end_io)
 			continue;
 		if (r10_bio->devs[i].bio->bi_end_io != end_sync_write
 		    && r10_bio->devs[i].bio != fbio)
 			bio_copy_data(tbio, fbio);
-		d = r10_bio->devs[i].devnum;
 		atomic_inc(&r10_bio->remaining);
 		submit_bio_noacct(tbio);
 	}
-- 
2.43.5

