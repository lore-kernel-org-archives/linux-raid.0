Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492EC426ED5;
	Mon, 29 Jun 2026 14:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782744565; cv=fail; b=q14G16DC5LAbxiMY61oSNbHnXzz5GSd4tvABRs5H1FYecA3SH/DrAve+kvqTAybxR9Hq4rI4PhdL2161ln/Vi0WYUc06xZxYhxLVTB0SPyvTw5vSfwHR9JwioddCLNGCJzCReUHja9luJIx1ssigUjCvbunJtsZu8SU3jnU4vGw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782744565; c=relaxed/simple;
	bh=2SH976In9mvPjGzBFh+0QcH4qZmFQ/X0BUzS10ofOSI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oB8eb/krq+plhCe/5ItNCUQoVKwGZS1+M5ZWJCS9GI45sTx8fyi0uFA1jFsScUOfWz8GkU+GgM0PZODNMjc9TdifAK5xGsDaEUv4SidwgdCSH2pvMw2xN4z52B9vNLk8DHSKKRv3gdoLqSoYwrQXPbOR4xN1iFe6f+Ku4M8fIqU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SHyMcLbY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KQo69FDv; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SHyMcLbY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KQo69FDv"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65TDuaSo1979463;
	Mon, 29 Jun 2026 14:49:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lu3NTpVcqSwre/kddCAaN78972NOsmwbN6lUr6Gys3s=; b=
	SHyMcLbYb8lCVIRPzmJ5HQckeZKKEgQkP4AR9hKIcFYevYF6JNcZXnnZbmJvZcbl
	XGOamoRBr/7lffQyI9XXtGosJ0I0x6QIFdBqF8bkQbP910zomUFFTHPvUz8lORlL
	NtoSnvRrYoP/ERp2yc+cql+GJt3sU8c4jq9nYZHuV+9CiNxwEuXn3b1+JTiu/Kko
	k3/C8qBLjluzC2bMvx1J2mZUa0VP/4KiOLSDD0d2RbALRNPzws7nz4XQoLn551k2
	3Xm3xRrlsYcdDoWTRm4vGpU/7zu+BV8ERDGDGMSsY3b5rOL1zWFvGfhHpRh1WPa3
	ibjgySy0pFDAxYutmMCbvw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26n12b2y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jun 2026 14:49:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65TEmjUY026444;
	Mon, 29 Jun 2026 14:49:05 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010034.outbound.protection.outlook.com [40.93.198.34])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yp7x0c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jun 2026 14:49:04 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fpC6zMvfpJFUnE0QlHFlRsUeqnD/CHgHrIND1bgEuLGGPu+hunqHe2PxUvaieJDGACsNXdzwT8xg13QpEPkbRUc8W7OWLZxVmAUV66JJmwT8mdQUWGxYrPWEvXrRfQvJBBJONHPzSdbmZtD7BoAtiIJAYJ4KqLCeFz80vEwDihjkY8aMivo7LaqtpcKV2rI2wX+iDXW3KvCa0pWgVp5BZjaPHcYQKBsntCpIt0XA3O/QcZiy5ZCP8PUtWiDr8P3YadArNxzrH+EB7w/uE4lqUyzayl5yx7pNA8rUC22IGkPsFlYiWPjKCmkfKGlNOSpTyp6LaDRWzYV4YPp+r79VsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lu3NTpVcqSwre/kddCAaN78972NOsmwbN6lUr6Gys3s=;
 b=bijq+b0GGQ6c8zBez+BLxnLM+khmYUUPrZpvuWCRSVTkjyDlHfF7TvBSber0aFM7jAnO4VZ2csiTPTPnKCfEaqdqgObrxP+/k03evaQVS0gcVG2OZ13bswlpuiVpULkN9UA8HxRSTWKuCzXhNOv8hpqgIIVjzbrsZgfJBM+Z4jAGqkTMQuV5XgleA+oSuX3mcuXWBBPx3YiRPE+7t29jHfc3icsHNqxUYFx3XKO7Bj0ygtEwV+VY9PVso3vy+gQhS7MHxFsCRT/tnTvdYdOvSJbKR9Kx8CjwGBPOwmrI0B9QfommUTkzWUsJzAGVjOUjTtI1x5nj5s6Hb5eajY82ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lu3NTpVcqSwre/kddCAaN78972NOsmwbN6lUr6Gys3s=;
 b=KQo69FDvmUuaJAI/oKhY48P4Ry9D4A3lWz4f3QUybnH7qslRb4u9+pNQDCCC43pJ/FlTQhA/rKlugfQIcOBytsuCSqkCJyZDksWuVWp742rJoHJbfhF7LrFPWKeyOslyMm/PKRWxrtoE2G6UoMEb8ydCk5+ZfRPmr8rpkxTSz6Q=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MW4PR10MB6462.namprd10.prod.outlook.com (2603:10b6:303:213::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.159.19; Mon, 29 Jun 2026 14:49:00 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0159.018; Mon, 29 Jun 2026
 14:48:58 +0000
Message-ID: <7cbaaca3-4eb5-434d-a13f-f9574c9f977b@oracle.com>
Date: Mon, 29 Jun 2026 15:48:44 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] md/raid1: advertise atomic write limits and handle
 runtime constraints
To: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>, song@kernel.org,
        yukuai@fygo.io, magiclinan@didiglobal.com, xiao@kernel.org,
        axboe@kernel.dk, vverma@digitalocean.com, martin.petersen@oracle.com,
        linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
References: <20260628142420.1051027-1-abd.masalkhi@gmail.com>
 <20260628142420.1051027-3-abd.masalkhi@gmail.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260628142420.1051027-3-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0071.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:59::14) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MW4PR10MB6462:EE_
X-MS-Office365-Filtering-Correlation-Id: 8de6f3b5-0992-442d-ca2e-08ded5ed8cc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|6133799003|4143699003|3023799007|56012099006|4133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	UHMJtWZY5ZETPATzxAO1Gv/Jd0TJPOLh/Az+0IxTYf5Q6Ly/P470LqnCNYz59tNMaQ8EOSj66/5W5AFfRUkXgsBl8A4WjNo5mD+TKmtonctCH7zuEDTyzN2R4XsupYeVnDBQEF1wQ8nkDv9aCsaKm4Cjm1a4OGtPVnlGx+8A4LrDVVbwEDDN+GEcA44vGWfO/RJVqMGPoiIenDSNv86G9zw9zj/fsgedxL1pf4x1PxyChOaaKMR56yEyc/pfXxrHqRVtCOOgQFuAXEsnhxU6Bv6PMk3wb2jjXS40N7OpvMHdHBxSlDW0LkFsc0DAx4as8KmV7XBsHMEjbL6lu2srR0dghjlRe1gnz6c5A0GR2WYsTHMo89HtoDXOeOJlnUWXTj8lbp3hD2n9YW9BI6qGVOPNjdw9Ute2PBDFHsak8hDA9b9MHWyNJOGIRsCWxCZfsdQepa2Wgu126Mr0wsE1wksxjwrOfrI8Eab1VFtf17K20G7S9puUPrLUq11y5UKaaJiae7tl8s6sZfJ4Rb6/7caqqeAN9ad8RXAf0i++qlrdzOPchIPttEa/DCS6FHBdzvRCXMA38p4XEXn7mGsP2z3HFe2m4QsHd0yZzE/ieOYkau4iwxOLuoXKwPwUOZ764F9U2YhbwEAm1zjoTvyAnT2MF+YEkSdOcnfqPmZxU7I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(6133799003)(4143699003)(3023799007)(56012099006)(4133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z3lVYm96Ym5iUXBwNm5TRytWYWRaY3RJSUxMdXpncEpKdzJ0K3VlK0N0QTgz?=
 =?utf-8?B?U2JZTElFZExGU1F6R3k5NzJLYS84czJ2eDAvTDlselJTVVR4dHFic0RnNjg4?=
 =?utf-8?B?aEJSb0FCZnhLYTdZVjhZOFlWdTBNSTZCbGhCR1RRbDNENnI2ZTZweThORito?=
 =?utf-8?B?Ty9QZnY2d3hvQVdqbUovT0ZFSlE4S0M4Nm1BOHlFSkpiOHptWjlDakRlQkVz?=
 =?utf-8?B?aUpONlZ4S0lma0pHMVBJUGRUQ2xBUFUzTGxVY25XdmtwbjlDQWxSSmhEaTd5?=
 =?utf-8?B?Q01OMTZvNGk3MmJZZm9xUU9tUHhiSXFzQ1JieForY3NnbUpMSS96WlpiQkY1?=
 =?utf-8?B?TkdEWDJhZW9GZ1ROUEdDd3BIcGxrcVdsck85VG03ZXc4YkFienhZWEx0eEI4?=
 =?utf-8?B?UkVXOVBjM1ZwZjVicnhkMDl0UXZxM0NyRjdJSlNOUmZZYlBHVkNTbllyWkxo?=
 =?utf-8?B?ZUdvaHkzWGRiM2tzOE1TbFdKalJlWHlMLzBSTkttdjlmeE1FWXFqQmxhelVz?=
 =?utf-8?B?YWFpMmNvNWN3dFk5dTdJa0ZBUldqeHV2T1cxaURucnJFK1VvR2xoTHNla2FV?=
 =?utf-8?B?N05NQWtNMDd6Y2ZkUWtJMDRpdlVkVmd4LzMxd1RSU1ZWRGdZTmVkbzdhZkdt?=
 =?utf-8?B?eHg3YzlpRXh6NUt1VUZodFlOR1BoWTljR2xkSy9WeEJSM0dhRmlCWGoxOGhm?=
 =?utf-8?B?OVkrbHpFdU1TcFMxVUNFZUlHRUtjT01mYVN3Y0RwT2M4VVNTb29oVFV0bzJN?=
 =?utf-8?B?czVCZloxQW52Ui9reXlIZGh2dHZiMjg3a2VmZnhMYnFGeWd3NG1reTlGUGhY?=
 =?utf-8?B?M1dmTnoyNmRHbm1hRXVMcGRubWFNU3RQS0NDT0ZET3hTUDBLbVF0RlZlOS9S?=
 =?utf-8?B?b016WWh4ZDRRQUJydHAxYjFld2l5cENpVTVRRU5OMlRHNzJYUkFBL3VMYmRG?=
 =?utf-8?B?a2Z1bk92b3gzVTF6TzlIYWhlY2cwc3J5c3RaMVJpb1c2M0VNZHRnOVlUTlVK?=
 =?utf-8?B?aC9FUysvOWprMU1YV1FpOWlKY2NVSStjQzZUWEtCSXYwUXNiblNLRDFYRTZF?=
 =?utf-8?B?bjI5OGpvTno4UmRlQ0NtdTJwZDh0YVpWY3Z6TWcybGsvTFpVMHBleDRXQ1dV?=
 =?utf-8?B?aFlLWVBaci9wT0Q5NkpDclZRVTF4QWREcURpdEhQYjRzTEd4N2NoY2NQMU8x?=
 =?utf-8?B?ajZ6L2p6WVB1MVZQMkhqK29YamJ3Szlha1dMZUdmK0tXb2VybTNOZ2QrZmJs?=
 =?utf-8?B?NVdLMDVJK3hTSVo5VkI3dlg3S2pmRWNWRDMyNExkeU1zZjlxVnBBTThqZFBv?=
 =?utf-8?B?MkxncllnSC9NTzdRMkJnRFhrYTk1NS8zZ01ubHdBT1NKZ01UK3Njek45eGhs?=
 =?utf-8?B?V01EZXNOMHR4T2J1dGpUeURTYzNNdjdqRmsyYlM1TUltSm94ZUJRaDdWWFov?=
 =?utf-8?B?ckFGTXdQaUNPY0Z0SWcybnZ5Z05KTi9pUWlOMDVLdXp1ME4vdUtEZHBHR2VT?=
 =?utf-8?B?cEx3cW5FZFl2ZmxqL0NoS3NncENubDlJYzR3bUhzK2ljcEc5amVNYkhtbmsr?=
 =?utf-8?B?dkRNRVZQMCtzd1M5RHhCZU05d0F0ckt6NmFDeHJxeUtrZDI4dGp5a2tKOHdO?=
 =?utf-8?B?ajVDR0Fmeit3eWlseklqSmFjY0U3RVdtL2hPQjZuVTJKbkVxSlpqWXlOeU43?=
 =?utf-8?B?WVpOZWl0eTRzcHV5MlBMUzdhVXV5WFBNdS9EVkllaFlMMUxYc2lvR09rQlJ0?=
 =?utf-8?B?dm1NbnZNcG1CMVQvRjNSRXpRNEdSUmpQeE5yWEZzN0UvZ3c4QW50NGE2WDlX?=
 =?utf-8?B?UmZaWmFoMXl4L2t1dVc1N0V2NzltK283NzYrZVBYYkVHODN5YWRBL1RHc2dW?=
 =?utf-8?B?ejFHeVYwcmdpM3o4MlJPeVBsWVUwSlJrYmN0aTlLdE1oeUZZYnZwZEgvcGFT?=
 =?utf-8?B?UXo2RE9DMjJueGpweDAweVFvMGczVHpjb3AzbFFhRVRpaFRodWhvRW92alcx?=
 =?utf-8?B?am5aL2dlOHdJNGVuKzI4TmdFa1pZNmQ5RXBta3hmL1ZZVENHTWkwdUU3ekJV?=
 =?utf-8?B?ZmxFTDJLbmpheTZKNnJ4WU95Z3YzdktiSGZobDF3bm1Jc0dDQzUzVGdnOGJJ?=
 =?utf-8?B?Y04ydnFvejltTE5DN0JyWUFWRjlvOUduTkFkOWhma2tMeU8rVDMwWElZUjE0?=
 =?utf-8?B?UDY3SFh0V082RjFBYkNVanpUZEJrVWlvNTFDUFhnejdJTjN4aFgzNTZsWW5r?=
 =?utf-8?B?RXNUdGJXdjVUQldMZHRFVlNoZUdMMSsxVXFYNHpCZFJXdk9NQlNMYk0ydGQy?=
 =?utf-8?B?S2dyWWhkN1doQjB2NXc5Q3pkWlVUOGFkTXdXL1FWbm00dnFxY2VRTkdkOWJB?=
 =?utf-8?Q?1X2xm1OZPY3/qlRI=3D?=
X-Exchange-RoutingPolicyChecked:
	OieD/sal3MfQ3UAUuQJxLZIFRox6t+BqOJq/dOuMOAAu+ZGKcK46UsYgyp7ur7GK44rZca5nAXn95wIgmOixTb5b/gt6BK4jTenlZa82DNd3cnIIIgt8pLQpJCOkxjZSvotWF5HiikmzaHKD3D4cHa/516n98BpS1LYa43nSYVb0JgtXDzVXwmHNwzqW+ysyDVX8zHWFCC4IlPpD0ZxfcjD4W4bDrfaoiOF7Hmf3wV11sR3TYTprxJmQX8xf9XMqo0prIDIE3RVCUwbXmUWuy+21Ka3Z0rupU2/rgQXtvM0FLVZLmkCYzLWuD8AGQsI7Is7qZ00quw9HU35WuM9Wnw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DLDCXPyhsV6jV//Vh5byVpaKoASIhFobuCPaCdcbzQjCK+TgCZLC15/I1vFBIJMmOeGtwwo6tBF6nlY1qvrB/LIOG7H4XqYZrOcSddBAt8S5QIDsFr2TwO47LD3dhtun88+3DwkC/EopgCReuwFr/mgb+qQ7lzV/UGoGtAtIRq5f1Fgz9YnFYytL1NlJnBib1gE2MKmRrh19XowZcLGYlmZTlenV7CZbkvF6UWFrjbVfh7nNPDUGI8zgQ5wnzZN1+W2o4BhMGSwGiHfomCulGargrga4ODGtr+pkkvZg/CXDcUEOiboIh6D5IgaQLFSpaVQEQZtgt0DbEWm5gYdeucVXeTryR7WQ0lL28CFsburhxPCPFjsrenIV0JK6STZPwrgXghb0m/vjHStXefalKAcQGy9O31jcRcghWenOKjtuGqk5+fgj8Bg/WOhxjT38IU/G7zKDVlFW3gBUTQzt7XZo7RIYDjtD9DkIDkwLBcV57+wjX1nX/+Iap3aM9CWsSxG1kTeGKzFPz5SlRQtEHtV1jBR/roITqo0bsEzLVu731jR8CKsNAmTQHbxWOAVWWTtj71+z3wOpUf5nbpxGP235PE3oLgpMRISnodw+M3I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8de6f3b5-0992-442d-ca2e-08ded5ed8cc3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 14:48:58.2388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2+cYqI4vrm4CaThrjXd0DcuWPj9IjQIUMONPgsFweybZox+VdK7bGfvXjENRYwP6asHS+/CIcnezAjYmASabkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6462
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_03,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=961 lowpriorityscore=0
 spamscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2606290123
X-Proofpoint-GUID: GFKuHAtsCQSPCg0li0-9SBvMmn0k0WxD
X-Authority-Analysis: v=2.4 cv=FvI1OWrq c=1 sm=1 tr=0 ts=6a4285e1 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=USmwyQQ4doAquZvgXpkA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12312
X-Proofpoint-ORIG-GUID: GFKuHAtsCQSPCg0li0-9SBvMmn0k0WxD
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDEyMyBTYWx0ZWRfXyBMTZ9ZHMmzy
 cq3Tmx9McKlO9m8kRNbQWnocHh/gTkeVX07HJr9kmEGR6iEU1pUgflIfHt00+EXjRZ5T3OVNs8D
 Hf2RPicaQx5jFQcR9vj4qPbNZKzWMXNs/g2qj3dpu/+eZzszt3zh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDEyMyBTYWx0ZWRfX3BdG8/XRjYJR
 5PbEGQN0ncpKfbQeikbLDzYGaLScHLflWKMNpeUROl1rnNqIm/ZcBCAOMJhiVibjkdmfuUyJ0ly
 FjWEes5yz7KZABI8vMp+bRXEpMiJwrCRTo6/AiFckJE5q56bQ8wwynwOWSDUn9OHs7qT/usiXUp
 8aojO5Yr1GDXblSTZuFfAHLIBZyv6VVerqKWp30+v2RBdE9hv/if9Ijt+pAvTv9oNBCSmkBZMHD
 oNcxrwDBGcrbHKPFgnmgoXQ5PI+txpsf3nYHvnx/LSdM4Wlr5srFaSaDPa3psn11tJbVPaSwXYR
 VlD0AVgk834BnATPuU/6Yf7JQRY0yBHzDlB54qBU4KHYsJk19maCz5kw0TQ4GS4iKyEfumkFgxL
 4c6cHNzRSCfrJLEGqsaIhychEmfkqrXOhFqW0iqnt0hVrKN1c6EQU96CSru4nvySmvqy/kzJDbr
 xI6+O0Y9Po9Tt12tnwkDVVgiHiCmvso1dXLf2tWU=

On 28/06/2026 15:24, Abd-Alrhman Masalkhi wrote:
> Atomic writes in RAID1 must fit within a single barrier unit. Advertise
> this restriction through the queue limits by setting
> atomic_write_hw_unit_max to BARRIER_UNIT_SECTOR_SIZE so that bios which
> would cross a barrier-unit boundary are rejected by the block layer
> before reaching MD.
> 
> A bio that passes block-layer validation may still become unserviceable
> within RAID1 due to bad blocks or write-behind constraints. In the former
> case, complete the bio with EIO. In the latter case, disable
> write-behind rather than failing the bio with EIO.
> 
> Fixes: f2a38abf5f1c ("md/raid1: Atomic write support")
> Fixes: a4c55c902670 ("md/raid1: simplify raid1_write_request() error handling")
> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
> ---
> Changes in v2:
>   - Drop the early atomic write split check from raid1_write_request().
>   - Advertise the atomic write size limit via queue limits.
>   - Disable write-behind instead of failing atomic writes when the
>     BIO_MAX_VECS limit is encountered.
>   - Link to v1: https://urldefense.com/v3/__https://lore.kernel.org/linux-raid/20260623072456.333437-3-abd.masalkhi@gmail.com/__;!!ACWV5N9M2RV99hQ!LbMSGSClRi0PNBqQti5ZNWGDVjDd34-7saYEAwNyBNjpNTjEA7veqM5RHG8KB1QiscarW4UaIefjm19ywSImtIgh$
> ---
>   drivers/md/raid1.c | 36 +++++++++++++++++++-----------------
>   1 file changed, 19 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index afe2ca96ad8c..f322048ab3c2 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1522,6 +1522,7 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
>   	int first_clone;
>   	bool write_behind = false;
>   	bool nowait = bio->bi_opf & REQ_NOWAIT;
> +	bool atomic = bio->bi_opf & REQ_ATOMIC;
>   	bool is_discard = op_is_discard(bio->bi_opf);
>   	sector_t sector = bio->bi_iter.bi_sector;
>   
> @@ -1603,20 +1604,6 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
>   			}
>   			if (is_bad) {
>   				int good_sectors;
> -
> -				/*
> -				 * We cannot atomically write this, so just
> -				 * error in that case. It could be possible to
> -				 * atomically write other mirrors, but the
> -				 * complexity of supporting that is not worth
> -				 * the benefit.
> -				 */
> -				if (bio->bi_opf & REQ_ATOMIC) {
> -					bio->bi_status = BLK_STS_NOTSUPP;
> -					bio_endio(bio);
> -					goto err_dec_pending;
> -				}
> -
>   				good_sectors = first_bad - sector;
>   				if (good_sectors < max_sectors)
>   					max_sectors = good_sectors;
> @@ -1633,10 +1620,24 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
>   	 * at a time and thus needs a new bio that can fit the whole payload
>   	 * this bio in page sized chunks.
>   	 */
> -	if (write_behind && mddev->bitmap)
> -		max_sectors = min_t(int, max_sectors,
> -				    BIO_MAX_VECS * (PAGE_SIZE >> 9));
> +	if (write_behind && mddev->bitmap) {
> +		if (atomic && max_sectors > BIO_MAX_VECS * (PAGE_SIZE >> 9))

where does BIO_MAX_VECS * (PAGE_SIZE >> 9) even come from?

> +			/*
> +			 * Atomic writes cannot be split, so disable
> +			 * write-behind.
> +			 */
> +			write_behind = false;
> +		else
> +			max_sectors = min_t(int, max_sectors,
> +					    BIO_MAX_VECS * (PAGE_SIZE >> 9));
> +	}
> +
>   	if (max_sectors < bio_sectors(bio)) {
> +		if (atomic) {
> +			bio_io_error(bio);
> +			goto err_dec_pending;
> +		}
> +
>   		bio = bio_submit_split_bioset(bio, max_sectors,
>   					      &conf->bio_split);
>   		if (!bio)
> @@ -3229,6 +3230,7 @@ static int raid1_set_limits(struct mddev *mddev)
>   	lim.max_write_zeroes_sectors = 0;
>   	lim.max_hw_wzeroes_unmap_sectors = 0;
>   	lim.logical_block_size = mddev->logical_block_size;
> +	lim.atomic_write_hw_unit_max = BARRIER_UNIT_SECTOR_SIZE;

This BARRIER_UNIT_SECTOR_SIZE is a bit like chunk sectors, no? I am just 
wondering if we just should set it to chunk sectors = 
BARRIER_UNIT_SECTOR_SIZE

I assume that it affects more than Reads and writes, e.g. discard also.

>   	lim.features |= BLK_FEAT_ATOMIC_WRITES;
>   	lim.features |= BLK_FEAT_PCI_P2PDMA;
>   	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);

