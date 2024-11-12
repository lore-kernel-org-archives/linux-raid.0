Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188C415A858
	for <linux-raid@vger.kernel.org>; Tue, 12 Nov 2024 16:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731428146; cv=fail; b=b72pKmtnpw+yQVaZV8R4xxO88jA1s3DdyvVALh1wnwo+R68GIyJFIUh3Q0GO7udjCDwlymLAF/++TD0uGI3ydFV6GSuEaBCdNOWgj0O9RP3/Ss1WvHlshQhyXoMopf+8EEDzw+RUbxxw4G4JgQlnO2oHJokdeYlxPUGw2GqZmp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731428146; c=relaxed/simple;
	bh=8Jl1Szxp/vBxJws6yyY3DOqo5oiYieWjfruTQ/de1fo=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=P1liox/7kwW5f4+29Zkt7INB9rnheKwaRmuZ02V2UyLTr7fu3J+6Ga/hjG3k7eAtI3nnhGwbIOnWiDd3y73/Yb4L+bL2Phs1h3suVhT7ul6XIj/qiwGnF0x11eC+ZF8ArMlTxj+iuqUgtjlFKajjuh5R5xL9i9euIjigW3XKj/E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eApUclPQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UzDTdoPz; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eApUclPQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UzDTdoPz"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACFNcaQ012055;
	Tue, 12 Nov 2024 16:10:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=+P1QuXAWvQOO68ZC
	0shuo+hdVS9qPc/tA4fWlhp8hMI=; b=eApUclPQSpBepNaQ6SXz2vYz2KDR9iJ0
	goW9F7w9O0LfiU55hJfI6m00BVnitjVa5VG0UbiJJVSmyVj7YLkb6f1mM+czL21j
	Tz3O4ZnQU3AYv61+lrTMr2PxAwMxOg5QtyZKPQj74I2qygfoBbSt/ArX+dKNA4aX
	ko/IV5JgBr+fRepUX9rb9Rq43DmiZRYL0Kn2HWYA66FkgrdNgxZbI9a0QhIPCVEX
	U1nzrZQ4LLfPpQtdEyFjXNNC1b/RBZMsryFYBt0i1lrggPd9lp9A8eNAFjlMCCgQ
	iO9XRQHIQBzAcWS01la6PRL58WAmUstQWuqfT5odV3g2MNeebwz4cQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0nwmspu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 16:10:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACG1DT0025994;
	Tue, 12 Nov 2024 16:10:34 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2048.outbound.protection.outlook.com [104.47.58.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42sx683jj4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 16:10:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k8eR5bdX4g9JGhDJgHNzpx4vtJcJesU/f6Vf+tDERqDMBfjf1Ch7SBXSjRZ9wXDS1yxnVNKYNjOijbnqdchhjviSMLmAJuAQ1NzN5/TB2zXFhcXptN2mdi1B+sNVRIgtpJWRRvxaXoK3NdpHd0T5M9KJ24aXY6l7l+r5UUGt+pTP8rbIzKAMtdPuY3aG5ugAD3EIRwHt4VxUV5lwlQ+yhUUuYajQDghNDXc7IjWpAvRE2S9xnX+DClvMbuSSUgYh9/Q99J44/QnRA7xwZjirgZjRSsNdS8TxwjqebKllOvq7NBq9QKnj/RO3HKDCBn08YFIJVzNL6mxc84oh5xAzlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+P1QuXAWvQOO68ZC0shuo+hdVS9qPc/tA4fWlhp8hMI=;
 b=qnNFY7MDpAOJsvyvTnr8xO5XbrXfdkdFYVLGgo8qkRSYTNF9KBheeQ4P72nUSxjkYxCA04n4k1vKf3GdCM2N7zk4ueDEVKvUYxnsWF3K6WUta+4DcZGN8FCi6gSMotTTDdBcb/jp5h0nWZC/59VEsn0RZf9M0sncEzE4/G23Gbs54SMDUyQ13hQFrXz/PNKhLxPfSxw1YddWy03Hypn2SLKwKAy2HKWXgXoVeJ4/sLpUgHMa4YEc0PStA1JlK78h5eMT2OOPTcqyELCc6iztvRrc2Def3lqoHotdxLXnfBPwFnlAVtwtJGWXB+YnhEzG/3yDDNk8CKGpy9nW9Iev0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+P1QuXAWvQOO68ZC0shuo+hdVS9qPc/tA4fWlhp8hMI=;
 b=UzDTdoPzvCT23E/a6KR3SUT7RF1KqqsQjtAwLGU+jXC5xMSYdDSxiUcdRAkj5MohlataJZfeA/ky1bH0zOHzDHrWK6L679TqeooT7OCkyFhrnGwPwm2ZAMiLj3797OVtDBS+kT6mRgeEmgztu9hNqRnC3Aj2v+34l7mMfdeI4/8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW5PR10MB5761.namprd10.prod.outlook.com (2603:10b6:303:19a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Tue, 12 Nov
 2024 16:10:30 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 16:10:30 +0000
From: John Garry <john.g.garry@oracle.com>
To: song@kernel.org, yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 0/2] md W=1 build fixes
Date: Tue, 12 Nov 2024 16:10:17 +0000
Message-Id: <20241112161019.4154616-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0386.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::14) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW5PR10MB5761:EE_
X-MS-Office365-Filtering-Correlation-Id: 469af31c-bccb-4c53-804f-08dd0334873d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?akprYmVLdGpVaktLQmZTeWRKbDVPdzlsaGEzYnV4YWtuQXN4ajI5aTRJejhT?=
 =?utf-8?B?NVNwN0F0SXpWd0FWNXdneklaSUtRVmNKZ2l5bEJQY0xGMGtqbTY2eDFPNGZn?=
 =?utf-8?B?L1ptbjRaZVZTcUt4V3NFeDc4cVNPeGwveGd0Vlc4Q0lPOXJQMkpYbXFsZmJv?=
 =?utf-8?B?UjhSWkxMaXVSTUtVVGp3d0pnYm1zUGRML2tsaWNkOTUzTDhSRXJjbTArNERt?=
 =?utf-8?B?SGVDMGI1VkR6TUdQZmllY2dEbEZ5ZEp1VGFnL1pLdlNiak82ZDJ6bHduSTc2?=
 =?utf-8?B?N2NOMmFyWThWYlpSREJOYm9WaDJFOERvRVFMbFVQRXNDY0JVT1J3QzZQM0JV?=
 =?utf-8?B?bmhvZzdhbVdrT3Z4ZUpSS0p5R0NRMWZFeVlkK2hjM0FmYUxxeFZkaDJSY2pz?=
 =?utf-8?B?YTlGaVFqajBoMEVQUjRxQ3Jhb0xRV0ROREMzL2VUQU82dFFaa3VRZEt0M0ww?=
 =?utf-8?B?dWNMOHJRYjVXZm1SZVpOMjF1djRnelI1dDJ4ZDhWbDBOOUtSVE05enNaTG51?=
 =?utf-8?B?TlNiaUdSeHhTcEM2Zlk3TDM3VlBsUHBFRHdMYzVqdEtWSk44TDRiYUkxbFhU?=
 =?utf-8?B?dC9YSk1HakhzRHlDMzB6dExtWTVkSmZqb1ZGVm5CUXhKTmpFeGdERzRVV1pl?=
 =?utf-8?B?d1E4bTNaZW0zek5iQ2JFTDdUZE51L0phWi8xYzg1NnpyS25MYnQ4OUpxRWlp?=
 =?utf-8?B?ZkpKcjQ0ck50WlRyUkJ1RFFtNTI5R2RLMW9RdUVNUExGQXphWWRYamJFUlgz?=
 =?utf-8?B?TE45YVovVHpkeFBGNGYyK2dQQ2lpRmdocEtCa1FYbjdwbXdnbXEvd1hhM3F6?=
 =?utf-8?B?TTAvWGpiTEJXQnZxNXJBckczTlJETjd5a0F5aGZiTG0zSDVJWUErNzJ1RTl6?=
 =?utf-8?B?eGE1ZmtteEs5ZGJMaTdZUVJOa1Q5dzI1NGdZSFZYVzFDK3VXdHZsck02alBV?=
 =?utf-8?B?MGtJZE5DWVkvWStEazFjY3BXVi9tSll6eXR6TktMaWdnUHZOQ1JFV1BzUEI1?=
 =?utf-8?B?bUdibDBtdjR6bExWZk45TERybWZFeENMc0hYTHgzQ2NhUHc5ZUtLRGVzOUhT?=
 =?utf-8?B?WW9UQXFobmFBY2xSMXIzVFBvNGdFaXBLQVdwdThMTHVpL05YWnE5aUFXeUp1?=
 =?utf-8?B?MVZkT2lWQmJaeWVBTTRaNnhxNndRY3lGbXRQREc3bGhrN2h6MW9IZy9NWTNj?=
 =?utf-8?B?KzJkNlp3WjJWaGR5RGRoeGIyZDRlcThFUnBxY0RYL1ExQXJYeFFRMWVWTysx?=
 =?utf-8?B?Qjl4MzhVQkZWenFGWkxCQ2g1T1ZnZ0YydjdiYnZ5SEFITGdaOExhMHdsYThD?=
 =?utf-8?B?QjEwWFVkQVJhUDFBZW5aamNDajBsbFNPL1VZNHY4VFpTeFd4Tjh5R3lEblNn?=
 =?utf-8?B?NHJxNE5iRVJQZ0dFUUlFQTN0R3Z2eFpLMXR2SEZiYVhWOXFqaXh0TUpiMVRi?=
 =?utf-8?B?S1ZaVzRDaXRYVjU3N1NMZFN2SEpuTCtSQTZiWlhMSlFYK3ZGSjFxcGQyQ1gx?=
 =?utf-8?B?Y3dRYUwxVkwvK1gvWmV1L0JvQ2tUUThQTnd6RDduM0d1WTdGWW85RXcrcWJi?=
 =?utf-8?B?QVJ2RFl5cld3SWkyMVV0YThYLzl2b0xlaC9WUi9EREdSQS9BeXBwUitoeGhZ?=
 =?utf-8?B?bE5zSDI4bnRPSTlSOGI2a0p6VkFsMzE1a0c1T1ppbCtkKzZJM00vT09jM1h2?=
 =?utf-8?B?cUpkWVVxRVRvaWU0ZmVrOExhOU5aUGQ4bUluampic3JsWWVIUVc1b1FSb3pq?=
 =?utf-8?Q?nkop5Zf6RLaZ1QPj4ecdg1PR0jV1XTiOB/YtDW5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N3pEZFdyREtzWkgwd09abmlpdkdtUGlKTTErUTFSRTRjQmQ2YTFDalZxRTRL?=
 =?utf-8?B?cTVnaDhOT3JUaFFsMFV2SWFDdVpzNnFodS93dXJiNkl3OHJUY0xpeFJBNjly?=
 =?utf-8?B?VTVHY2U5ME1iKzR0UzFCUW92TFpZUzl2WmxNK0NXUXlJZitZd1IzM0cvdk5m?=
 =?utf-8?B?b3NRZEdPUmlIdkppcnZrRThpV1pMeTZIL0V5cy8zZ1djUmVFR0NXczl4aDZC?=
 =?utf-8?B?eHo4V1lmYjlaNTl5VXF1LytQaWxGZVBqejFnUWl2YWM4TWRQRXNOcjJRVitt?=
 =?utf-8?B?RFFIeHhjazFwbnUvbFhOclFwZzRqamJpdFR4V1BieUlDdGZYTHYyWTk0dGJP?=
 =?utf-8?B?ZnV4bXI0dmZMdVRtazgzQWVTZ1NWVUQ1T2VhVWJCM3hEMDZVYkxudEttb0lu?=
 =?utf-8?B?dVcwUTYxNFVXbXVBeXRYRG1jQzZObUVBQmFzQVVWOEdhdUhtT2dHVUlTVEg4?=
 =?utf-8?B?ZEJabVIySnRadlhSTWNxNDdCSDZTYlFSMFdTc1BVTXdFTDBXWHg0N1J1c1hq?=
 =?utf-8?B?dDF6cEEzbmxBOStLeFdDUVgxNzVCQUxBdzRlcXRRV1dmcmpwSGlHM2ZrMTNl?=
 =?utf-8?B?K1dFSGQ2aVoxTG1rMmQ4azVqM3JHVVdNNUtLYm9oRml2VEtTVFAyNU5MaDdB?=
 =?utf-8?B?bU52Kzd3ZVNyWnozSnF1bkt2ZnhrcjJaZ0FnSmIwdzM3VmdqVjlQSlVPRUgz?=
 =?utf-8?B?OW9wOWxvZWltTUxYbDdIelc4TURHVm9YQ3BpaG9WbTFNOWIxTVZLWXlObmlk?=
 =?utf-8?B?TDNQamNiZzdUdUl1eldPL3JDdy9yWFo3TEJ6aVN0U3VJd0s1NUpwdVRmRTc3?=
 =?utf-8?B?VlRJcDZWSU0wSzd0RUFDcWhLUW5weFlGQ2psV0h6SG5sa1pzT1IzRjdYbE1a?=
 =?utf-8?B?SXlsTHNOYjRjRWxtdkVTQzVYbjFRc0J4d2hTMit4T3gyN1JsUjJhL2hGOHNR?=
 =?utf-8?B?b0RZbFFlNDNYNmcvd0piZ3M4WXJKSnJNTS9HTzRCL3VUM2ZVMG56aG42QTZq?=
 =?utf-8?B?a1RZQ1RvUWZOT1lVN0JpdlEzcFZoVWE3VmNPUE5SMCtRM3hIR3kwOFJNNHV2?=
 =?utf-8?B?YjdITWRhZXcxRCtpRVkzR2x3K0FsQVNmb3ZLTzJRS0lGTU1pcWNGeExUSGsy?=
 =?utf-8?B?TUFxMkFBcC9iUEk2VmM1bXgwZjJPcjFpWXhhS0FybU41RDdzL2RYVzR0Smh5?=
 =?utf-8?B?NVg5eUVvZXE2NXZRVktJdWZjZmorTjBpaDliY21JQWVGWVY5ZkNCWE9IT3Vk?=
 =?utf-8?B?VUx3TUhxeE52eTlYTW5WTDRIaGMyN28zUk81a3pheC8rdDhTcU9Md0M3MXRH?=
 =?utf-8?B?bk5VeG9GdXZVc2pWZTBaNHRCeFc2aW1JTkZlMUw0L001YmFCc3VpamlsN3BZ?=
 =?utf-8?B?UVpvNHB6WEVETDJvVWs4eFdnWHcvT2hCaWFNa3Y3ekl2K0E5bVN6KzFLdzhn?=
 =?utf-8?B?ZlRZQS9TdmtxMlFvZjZlVWdYNjNCcGQ5UjdJK0JLT21QRElnK0F0ZC8vL20x?=
 =?utf-8?B?QUZVZjdHcURxRmJORXNVRmRrVkd0dmFJNXNXbU15aWJEMVRVa0txNU5ObGo3?=
 =?utf-8?B?WFpESUNDaysxRVZtQk55SGViQzJHb2IrQVdxVmhmM1g5Nm8yVVBYaENKTCta?=
 =?utf-8?B?VHBwakcrbDNqZG40WVpJZHRwUnd2cVg4eklQakpFSzhCc1J6enJybWhyQmpr?=
 =?utf-8?B?RzJya3UyeE1ZdWtCWXI3RkY0cGhaREdIb2ZVc1RVNGg3cm9tZzlmcGJaZzcr?=
 =?utf-8?B?aXhSeERCbFNTVndGa3BEam13aWdEWWNFcHV3RTFqNy9yR3VUTktQZGllRHhE?=
 =?utf-8?B?cjBtYnJBL203YVFCY1Z2Z2p4cnZ1d2V5KzQ5cjdxWURyVU5sQk1YcFBFOGt0?=
 =?utf-8?B?aUpqVlRSVklvcmpNR0ZIZ0xmL0o3TDJBQ2ZsRFpQaFZ3bkpXVkc0YlNlMFZD?=
 =?utf-8?B?UzZ5SlVqa1ZpazNnVDlRY1A1cEhZbzVHdkFDd0Uya0ZhTGc3eHpjMkRyZzFY?=
 =?utf-8?B?cUVsRE5LTXJvSzhyNWN4aDZFQUZRd0x0bHlaSGYyTVdGb293d09EWU4xaDdz?=
 =?utf-8?B?SW1KbHdUZTY3OENBdkczZkJTNXNNUDEyN3pFNVBJWWNpM1hOMzFiZFFwbVhL?=
 =?utf-8?B?SWlvQXNOQjRYV1h2OWVOVlZQSEV6VktDbE5zWjkwV2haeitNKzhrWkxhWjRu?=
 =?utf-8?B?cmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6dM+XSKCSNBjRm0bqk3uhjPgj2mZcHLmfuZiX5sI7Qehlff+i/pUQs7UMDodGSWOEeazIqAnYRvaYekijpaa1qgq1n9zuyb63JlDfkJ62XOmZpveBGjpIrtTMk/UbOdzzhagWlNd5w78yd25xgIAIeNGsLeY1+KhvEvXfdy4nEs/+DPoBD2Ja526DeqJFr0TBv2bjVWy8aXtt5fk7cmEkqArJ7Fxq0+LO5ZOi5eQ8PqOBQeKjY04k+brBHhMqTfK1In67FkTSoJswj3DaM6xOmK0f8BnWs+ToXF559CclULeAqaus2xZ/AFDTj9fk+14vqHZ82pAmC4WL52pXCRJeFo7sg8WfNAU5zCs5yl7HpvxVz8o0njk3XHdDv7te81c+79o6bcPjKgcg8b8kBvF+ehAzt0sHBwhErNPQQAndzxs24OT7qQtFhg8ey0kMNjm+7K5DW9N/GZwtV7WQU2BwNowoUDlsPn1ESQr4HhRG/zT/enhHZoHpOWa4yZFTN+D6nkpanFHJIj6Jc+EYtha34sIgVrn1SoGebo5cPe2qyZQqXt6KxGLVg2/wYeENmvrRxrOAvPx6MbEvQZKQ6T4MkNH0Eo2oKZwO5jj18/UO98=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 469af31c-bccb-4c53-804f-08dd0334873d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 16:10:30.0117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sFVJNFwHGWglXjAV+8bk/DIg64DmTz820r3T4W945OxG3SMJ7nW8wsNdWDpStfyLM9cHaekOaZQpEWj4zFnIJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5761
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-12_06,2024-11-12_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 bulkscore=0 phishscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411120129
X-Proofpoint-GUID: dzG-TZa6U0ISyJ4y_xQk5eFIcKsTm-XU
X-Proofpoint-ORIG-GUID: dzG-TZa6U0ISyJ4y_xQk5eFIcKsTm-XU

This series includes a couple of W=1 fixes from array lengths being too
small.

I am not happy with just increasing the sizes by seemingly arbitrary
values, so suggestions welcome on better solutions.

John Garry (2):
  md/raid5: Increase r5conf.cache_name size
  dm vdo: Increase MAX_VDO_WORK_QUEUE_NAME_LEN size

 drivers/md/dm-vdo/funnel-workqueue.h | 2 +-
 drivers/md/raid5.h                   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.31.1

