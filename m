Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F94326D40;
	Mon, 18 Aug 2025 12:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755519659; cv=fail; b=mtLJP6wAn+mpe3cvXL4TlAzwCCnzglF+XfBSg+R8pMxDUw8Zi+4MDmWP67XEyJNo/j4gLOZFJZUH/A7opkOdP+8CWOWaHy60i69c/AfVEJezvVAiFf741AotwRI56M73DCKZD/Pl8Jl+dkuLkCiCk9mNu4PnaGSbFrSbWsaybGQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755519659; c=relaxed/simple;
	bh=sc4FkonSZnXDxAPMDA67FdDBbX7RMl575RUJCQ7uOhQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pLMyfD0qBd7js5F3xK6TNeBNCdWEaGw/tAH4uU1CHRyHISVCy2AVsYlYQv4JCYm0ktdieHneTltMEoAbYpnrCVgNcJByFEagaXKFJ2Eh8UhUtnKlF3J3vS1x16Gdh4sSDVOYMLRv3zprjwXXjfn7+E+vTyX5/Ga9e86fGZ8wxWE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Tgi118UP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Tje8iRNu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Tgi118UP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Tje8iRNu"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57I9epCf009828;
	Mon, 18 Aug 2025 12:20:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=AVAvkLBOwBSe+Tj/Q5o0Lg91GoxV4eUyQosZ1RkTYcc=; b=
	Tgi118UPVLbixuNYHB5vUZIra6DHfDHkoY5D0PlN2nTmE+I2MyEf/MNQxFoV6vc4
	LAuRjdnHqC0EwzEGEbTKQdYzqVquMrSiFyO6jc3NinatPibyy+hWfxV2ycvxjs/f
	hM3JUuhXDFzojAJ3ZW8PcilVvUckJqm1NgykHEvSZUYpgLFj6evfYStL/xm3/h3V
	vfqdOucFrLGF7jw55tcaTf9JMIRs3FdyekzfpdEwRgzFRpuBoIDkXiySNxXGriQ4
	dzAVf57sGw5MzkcduUVk/QuRzds5T43KFPylfzbIWF0GTOh0aFFmqvTeGcebyAsT
	oMtMNuTNvmgiJA6KoVjEAQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48jgs5jyaq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Aug 2025 12:20:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57ICK0dX040538;
	Mon, 18 Aug 2025 12:20:46 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48jge9dd9j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Aug 2025 12:20:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bN7j0DnPZavxFnkRwHtLf2qd2qCt2MXZIcjWrQ0+MhV2SFXfxcSZ5Fc58pAr05T5Fir9et/kbblEDo5saN/uWt7J7PYHZIZCKlsVveRJ1iwcSBfZ4QpSCqNyF1pMMamxrNwttOBIY10X+59WFwVbnd7j8K9w6DeQH2Kq4UR9DVTsNUN8v8UeHAJZu8iMaqA5n3y+7LR82Vv2qLVPYC2vj1Lgno/4Q1jsyd02ubhpNXMm7iDM1V9wYIHMpWFu2/OZtoEFHNezEv46hC3tfdOD+sRxBwwXls0r70/J2HlttdFDNxIXr6286HwHQZvvkCS5gKffkr5mPAgPpwsAdVBR7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AVAvkLBOwBSe+Tj/Q5o0Lg91GoxV4eUyQosZ1RkTYcc=;
 b=XkATJqAwnejSaWxjA3p9nUEBqDd3jmhLYKuxkEi5djZ3k+8HBRhI/RNfcW6hiROZ4IApd0GFMnHM6581lc67XEjkIH9OxoqRHNeka3QSbbZggwfrvt/RbS473s2Q3rAvkjWSVXGz6A2YCzjv/MkFtwIg3xsOd5M3kbEiC9hiazFNtIQpjYaHODJ0Dll8hBpefBHqItXnBdE/EcDSH56zIgEHZWizd+zRooHoLP9NuxN6C83fu2RVyiiz0zs5rFJOjMwrOYfYmG9v8oii4eMA6lg9NIWuJD+Y82Kg4pdoM8UfvrTK/BfNqv+XFAs1r3gB9JIqz7AL0CFpEAMcZi6YQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AVAvkLBOwBSe+Tj/Q5o0Lg91GoxV4eUyQosZ1RkTYcc=;
 b=Tje8iRNuzv8m8as8MMBVZO3LnZZ3YK6fOR2YbhyeiJbYz2oD/Twdo6kBVq5pC+k5VRYAx3++tGONom+ioAwL+EiKXGWW4eDZBkBk3FGOt7/L1z2FUHK499Egr5YAJfBEjsZmaz/bs7cQULNTz8H4GCaCm+4u+hoCOv7NnnH//Lc=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by MW4PR10MB6322.namprd10.prod.outlook.com (2603:10b6:303:1e3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 12:20:43 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 12:20:43 +0000
Message-ID: <64f293d2-d824-44bd-a087-75a394576776@oracle.com>
Date: Mon, 18 Aug 2025 13:20:41 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] md: split bio by io_opt size in md_submit_bio()
To: Coly Li <i@coly.li>
Cc: colyli@kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        yukuai3@huawei.com
References: <20250817152645.7115-1-colyli@kernel.org>
 <20250817152645.7115-2-colyli@kernel.org>
 <8b627eed-331c-4ce5-b095-e682bbf8ebe7@oracle.com>
 <6DA25F37-26B3-4912-90A3-346CFD9A6EEA@coly.li>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <6DA25F37-26B3-4912-90A3-346CFD9A6EEA@coly.li>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0256.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::9) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|MW4PR10MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c8f8dd7-e453-4158-7fc2-08ddde51a6cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M0tpVVd0MlhLOW93L0VWZGorV2xwRzU5YzdMdDRrQ2hNMjhVc2NHOVo2ditS?=
 =?utf-8?B?MVN5dXp6ZG9pYVFKOGpaNkY4Z3g0YW5RdTJkeG1rblB4bWx4UEFZMWhzMVRE?=
 =?utf-8?B?elBEemtWbXJwaVhISCs1RkhSOEE3a25OUmwrTStabFJ2Q3krME03eG91VEY0?=
 =?utf-8?B?VklCSkovdDVqV2MweUwrZDVRN0NwYjR4UkNZcGhZT1IwQ2sxUmltK2lDb1la?=
 =?utf-8?B?TWwwVkh1bHpnMjhvVGQyYVhpYmVYN2hRb0R2bTVybC9XTmFrRDlZTkpmZnhY?=
 =?utf-8?B?TUxIT25HVG01UzdPd0R6eUx0TFZzdkNZdlNSM1k0QithZFJhcVgyUWVWWjZj?=
 =?utf-8?B?Q3FIa2NDaDZZa1ZDWVlUUUlLNkxtOVp5d0ExaDFJY0RiZWpIc09uL2ZpNVhu?=
 =?utf-8?B?aTB1UDhUMjhVTW9USy9IUXJXY3I5b0ZSV09tcXhYUGE2bVprQXpiK2UvUzNU?=
 =?utf-8?B?ajVEQllVTUhQVkxtS1BJT29VVUdlMExjbW56dGpnVkNrcTlkdEFmcnRBNUJu?=
 =?utf-8?B?eDVwMkZybnBFWkg3NlQzVmFHcEpMK01rdml4ckxLTTNBeHQzYVVCN2N2Tk5x?=
 =?utf-8?B?U0dmTmNpNUhpUHpsMzhCRzN5ZXpkaGNkcmZudFliN2ZtUW9qcERiMkJ4M1Rp?=
 =?utf-8?B?NWx0alQ4UkVBaCtxb3BmbG12eDZBUm1qNlBxTHVWR2RrbjA2cHVpY2VjL3VX?=
 =?utf-8?B?UWVGSWc5YzFBM3EreG1YUW1lSWpLVWt0L3dFeEhpTW9NVnRWb0FVelZ1cnd2?=
 =?utf-8?B?MDBndmtZODkyL1h0QnJnbnJiU1J6UGpBYjJVUzg5TlJseXFLNlA3MmpmWVlo?=
 =?utf-8?B?eE9NTEljSnN2WkFrc2MxV0VBRVVNVlorU1A5WkVQQWpROWQyOURXaVNJdVF6?=
 =?utf-8?B?b3ZLYU9TNC9raDVMOTA3aVdYVkNNS2N6M2JTaGJ3QUxWR0Z1eHZkajNDbHFX?=
 =?utf-8?B?VjRwZHA5aFpvUE1ZcTJiekRoclNFdjgyUXJDQjZ6S2czaCtXRXdqMWxGODVV?=
 =?utf-8?B?bkhvZEZ1UUNnNE9JU2ppRWtuSFVhd2FiRGVNR09rS3d5MFNxOWdoYUhxcGpU?=
 =?utf-8?B?U2xsc1hreE10QUh5UzJZUTZPODdYd1luQXlNek5xdkIwTTFCZlJFSEV4ejgz?=
 =?utf-8?B?KzVEdGFJTDZpOGJpVWtLRlVCazk0ZndrRnZQVzUrOXNPRnZyZGxxQlJIVXY0?=
 =?utf-8?B?REt4dThDOGxpWmdsWm9HdlNKUGRobVhlaUhNUmZReGZqWlladEc0UE5BTUov?=
 =?utf-8?B?VmFyK3ZJZWZIR3h5N1hDcjgyV09kN3J6VlJNLy9kdGw2QXhwaUdLV0hIQjlJ?=
 =?utf-8?B?V1FOaW5IaU80OVprVEZ2TTF1UFUwcUQ2N2tqREVhWDcrQ1ZURVozTmtoM2lR?=
 =?utf-8?B?YmlYTGFLSXU1dDQ5TC85UWtiNCttdlZDampBbDJGbVcwTXBTNzJzeUV2blZ6?=
 =?utf-8?B?dXp6WWdXVWI3dGU2T0o4WmpwKzNuaDhORlZ1RXpJQ2FpQ2NhdXpuSjdDZTRH?=
 =?utf-8?B?cGN1c0YzREhqeEdrbmh3dDVadTEzalJOb2lwTDk2WFpMRTVJc2VHdDZRWUR0?=
 =?utf-8?B?TXR6TmNpTEJIb0Qyd2plTEZNRzFvUW9ibFk0WEJtZ1VYYTgxclZhWnJqMkMv?=
 =?utf-8?B?c011MHdEM2gzSlNYVHBCNFQzZ1ZMY2tVeFVQMUg5aDk0emtaRnRNZ3dTRXo0?=
 =?utf-8?B?SkRLZGNVT3dydDIzVlcrYkg3djEwUDU5WWN2c3BPY0RvKzl2Q3lwTncraW1m?=
 =?utf-8?B?M0hOUS9QMG4vOVNrMXRJUjdsb3pIK3J3TUd6MHFLZGhIZytsR3VMSUJiWjFM?=
 =?utf-8?B?NE5KL1lJSnIwMmtNUTFEbW41TDNVM1paQktXa01ZOXpocEJrUFppQUEyd2Q1?=
 =?utf-8?B?d1U0eGRtTmhWVSt1Vmd2QW9IZ29Cc081NFhGbTU1T3RTNHlXM1hvdUVzaU55?=
 =?utf-8?Q?d9p5J7K7DG4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R3p4eVQ2akpqNlY4REQrNE9XODZTOGJqYU9EenBnSFJxaVRJWUJTV0puUzhq?=
 =?utf-8?B?M1JrSmxuYXVUMTh6UDVHVVRHTHBWYUU5dU5ablRnMU1TME9jb0tweTNQQmlU?=
 =?utf-8?B?WktEMVllSnVvZ1NUV2dqR1NZcW5aek01ZVY3cEtZZHczd1NZYitiWjhCVk8w?=
 =?utf-8?B?S2hzNmJYM0JFc2YwRERvRG5VR2kzcFF6UjlDMWV3ajkyQnB6VmZNSHU2VmhH?=
 =?utf-8?B?U3RsNHJJclV0bnFTazNsYlprTklvaHFENi9qTTZ6N3lPeFF2SWxZYXJhTXVF?=
 =?utf-8?B?THVGV1VRN2dXNDR2U1cyMWtrMmlBZ1pXeGFKdjFBMWhXem1PU2lYZzAveis1?=
 =?utf-8?B?K1lCc0VaejNaRUttTklQT0x0c3k4STFVYWw1R3VNZDlmTEd4QUdpTWwvM0lk?=
 =?utf-8?B?OTdzSFV5akVISjJXQXdxZkhETDh0bGVsQTVMdG1HTzQ4VE1NNTM4UjB2R3JM?=
 =?utf-8?B?VE1TZHRkbStHYlVUMmVKVG5CWWF2SzN4bDJnZVdmWTNwdDRmWko4Q2hrTVRs?=
 =?utf-8?B?N0ZISW9URUlFN0dqUHIyZ2dYdXB1Q3BMOEZ3R2xnVXpsYlcycnBUaFAxRTZS?=
 =?utf-8?B?TUUyY0o3OVZhNmRqNys3K2RHbys5V1Z1TXJpczZSSG1mMm9uRmUvUWUyeUNV?=
 =?utf-8?B?U29jZnEwNDNITitFWU1vdlhFaURVMWhwdUZVbmxNOHVGYkUyVjFlaU1XNWJj?=
 =?utf-8?B?ZEpvU3RNdDYwZXFhOTVzNWVKakZ6K2hyNGgvT2o2amdPUHgzNjlqeUpIMW5I?=
 =?utf-8?B?eXVRRW5HMTFYeDRUWXAwaG9ndnF3Z2RVKzdFNHF5dE1GY1doSjl0bGZVS3U1?=
 =?utf-8?B?elo5eTVvRkFCMjN4ZGQxYUQxWEFSQUpybWdBbUk1S1M4d0xORzBUeElGamUv?=
 =?utf-8?B?MGlZUWhRcGpVUVlZaFkvOXR2ait4MnpjT083QWpUWFgxbXFJbEc4dXc5QTkr?=
 =?utf-8?B?czJHWGVVbWtpd0hPYjRFenA5cnlkbVBFNFhqeXlvamN5d0N1MHB4b0dldnZ2?=
 =?utf-8?B?S1hQMVlUOU5IWWR2QVVONVFWMnhtK0V6WWo4VkxtelBTdDlTZnFjNHBTRmha?=
 =?utf-8?B?M3VzWUtiWjhMT3BlRUJvc2lxYlc3YTROdFJRMzRtY2pDN0EyOU8vTWpxSk43?=
 =?utf-8?B?VHpGRnJLSklSR0JhSmloYU5iRm01NFFHdHRrQzE0R2dHSk5mSDlOK3Q3bmdG?=
 =?utf-8?B?S2VVRkJucWowdG51NEovNGZpSmJMVXNtS05YQVp6R1dicUVxYW0vQ0tlQVFz?=
 =?utf-8?B?T2Z5NHdiNzBQMFFOYjhUNnVRaTYwdUd6bzVPQ2Vyd2NhT0h2UW9YU3Z4dDJl?=
 =?utf-8?B?eGtUWTRkS2dlQ0I0WXJ2VWxHTXBDY1N5UHBlenlqZDVXcmcrS2dReW5EQWNB?=
 =?utf-8?B?VEV0cUloNzhrMXRMTG04Rmk5REd3UUtxU1ozZ2gwUFU4em16cHlFUHUzNmZC?=
 =?utf-8?B?WVBCbFNNMHRUY1FpSG9qclFxenZMZHN0ZXpGYlMxcUZBR0hlRi9va3hNLzlW?=
 =?utf-8?B?UWdjUWxCUnMwTVdXMUF3UUN6TDJOZDRNdkhYVEd0bkNjbGJWVCsvNXJ0S25Z?=
 =?utf-8?B?a0RyWmlFTCs4OWNZa3NTWmloRmJrZzNHQkpjY21qd0FKTy9MQUNiSVU5V3Ra?=
 =?utf-8?B?S2Y4V00vNDdkNlNUZkJJSWJTV0dYWExQZXJpSDZBUGg4cUhuT0lQRG80Y00y?=
 =?utf-8?B?NURaNGFmRkZSbVcyNVRwRGUrc3pIMmk1MXpBNmI2T3hiRUtWbjdObExJMWJ1?=
 =?utf-8?B?TEYzUHNFa0NXRmthaDVFcUU3QjBHWE1hdGwyQUVtZzluMnlCSU42czA1VXQ4?=
 =?utf-8?B?ZkQ1SVFlQ1lDWmtoZTh0bTd2RzlPemduZXA1V1psV1VpVFJwc1h3dFdHVFhC?=
 =?utf-8?B?b2JIeUVXMGRlK0N2K2h3Q2ZUZmgvL1JhNThYcVBKL1JtUE5NMERNR2dzbjB0?=
 =?utf-8?B?QTI3WHQxeXlEbjVjeFdxenF4NUpCdEhLN3hBVW14bzhhbzdaQlQ5UnhaRDBz?=
 =?utf-8?B?anRjQ1Q4cnBTOStOWWh3a2E4aUhGdGJ0WmZObU9WZDYvcEpyY3lDV05pMVor?=
 =?utf-8?B?RFpCOWlCdHc2YzU1NHdudFA3WWxMbDFtS1V3V1E0aENPRksrY0lkQUJYZ0N0?=
 =?utf-8?B?NmwyOFB2K255S0lvWnhEdmdlVmkyNnV5SVdBdWxuREQ4MXhZU1FST01KWTVZ?=
 =?utf-8?B?OHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tnRZoqmiPLKB9NqqRwfXRIhZyxekQJTUZzjXAjwR7PhUzkUAHdinGZeUcfzIvZaIpc2NPL/P1AnZkJ6eSBQMOFpl1CUtFo0J8ssALSETI38eMVJsdlj6F1GnSxHmlzVBMkG1WOEA/YfQOSGDsTmEY9wqwcEGRgqHPPFVL7qB27ZN34Hxq5wBhAPSpLOhd4WRVTC6gXSJt99EvbWLvf+0hNFqddZi21gx+ONawd02Gue83kv9m4HK/bMREIQ5jvvHT4dqzxYleir1l7mQkpB/CTJR0UjjCNfOtAo0i+E7vcCnKOfZH7lYCX+jcs9chHdKEdWaCKiwQ2T8WqnaUfz7JSBApMlQe9LM43FtieK0ANnvd6pZCs040Ds1lohFgT4gLh3U8BgIYoRQzgfcg/x3N0TSqOWk3dwOh8Bq2PR38YJ4e+KQzO5aYbRkmaDDWoTN7UnS5hFjiFwd4GgR2/nA9McdcgA4EhiPq/NLA9jvLCIjKg5oOnt+gvLFuAWWA/GA2dMaYnWvjPvnq/zxb/678ygpqo4HKhxsV8cRQ+S+yNjksBPJRFyJQyaWkPh2PnXTjFStVSRsraAqnVptrhJY0IjRBm/oHLTwqH4m6raWv/4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c8f8dd7-e453-4158-7fc2-08ddde51a6cd
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 12:20:43.4076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cn8vM+9wU8Hi5rEfAKn7Uxe87QgnDJ6jXy8WK2GwIUeQt/1hQ1BU7efgQLJpqbBc6xxfik5dPhejf1fJLUBRcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6322
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-18_05,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508180118
X-Authority-Analysis: v=2.4 cv=DLiP4zNb c=1 sm=1 tr=0 ts=68a31a9f b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=6ZJVC-iUy3DjeDkw57sA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE4MDExOCBTYWx0ZWRfX4SFbHbQ8zdqF
 Jwc1S+RdqHKR2Tb2thzbrJQg6XMWARwLENDU3IfZb1T/uo1oK/vShr4r19ZksVTgIoomc2wj8VY
 X0iqXt9a+0V9UyozvOlgOv5mYQTP7DorFi51juN2/w3ErYoGG8ox2JV72VBfB6rWUOMpL48dJav
 u6j32m23XXw/cGae1jcMZCTkt0WFF5opLr8QG2Dbs9UfODC3h96bLjwr8AWelXudTXrFd4tPocK
 jWqZn9q65OfbgLKMX0QBLdRvwJxsy6mzfn9P/x4CzKAEjCFwOylS0/0q1xdWo+kRiz8yRHb9+5u
 6E7tag8D1v9z9+T+kFFnNMPBbdKxSq3Crl2eU2rrTAvXyfAAv7nFfUEjYmPx5KZPggjT/wh9VM8
 vMJlxU2+SRwDSFx3zDG3kZ6bsYJDK9qn3yLBfXxoV9RBvLDQmwzmDAGNwOIXa3GmENe4Y3Zp
X-Proofpoint-ORIG-GUID: V-PD3WRUnjKRyZ018-_kVTQH5CG-P5m4
X-Proofpoint-GUID: V-PD3WRUnjKRyZ018-_kVTQH5CG-P5m4

On 18/08/2025 11:26, Coly Li wrote:
>>> static struct bio *bio_split_by_io_opt(struct bio *bio)
>>> +{
>>> + sector_t io_opt_sectors, start, offset;
>>> + struct queue_limits lim;
>>> + struct mddev *mddev;
>>> + struct bio *split;
>>> + int level;
>>> +
>>> + mddev = bio->bi_bdev->bd_disk->private_data;
>>> + level = mddev->level;
>>> +
>>> + /* Only handle read456 read/write requests */
>>> + if (level == 1 || level == 10 || level == 0 || level == LEVEL_LINEAR ||
>>> +     (bio_op(bio) != REQ_OP_READ && bio_op(bio) != REQ_OP_WRITE))
>>> + return bio_split_to_limits(bio);
>> this should be taken outside this function, as we are not splitting to io_opt here
>>
> 
> It is not split to io_opt, it is split to max_hw_sectors. And the value of max_hw_sectors is aligned to io_opt.
> 
> 

Where is alignment of max_hw_sectors and io_opt enforced? raid1 does not 
even explicitly set max_hw_sectors or io_opt for the top device. I also 
note that raid10 does not set max_hw_sectors, which I doubt is proper. 
And md-linear does not set io_opt AFAICS.

> 
>>> +
>>> + /* In case raid456 chunk size is too large */
>>> + lim = mddev->gendisk->queue->limits;
>>> + io_opt_sectors = lim.io_opt >> SECTOR_SHIFT;
>>> + if (unlikely(io_opt_sectors > lim.max_hw_sectors))
>>> + return bio_split_to_limits(bio);
>>> +
>>> + /* Small request, no need to split */
>>> + if (bio_sectors(bio) <= io_opt_sectors)
>>> + return bio;
>> According to 1, above, we should split this if bio->bi_iter.bi_sector is not aligned, yet we possibly don't here
>>
> The split is only for performance, for too small bio, split or not doesn’t matter obviously for performance.
Then it should be part of the documented rules in the commit message.

Thanks,
John
