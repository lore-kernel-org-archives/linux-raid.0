Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A96205148
	for <linux-raid@vger.kernel.org>; Tue, 12 Nov 2024 16:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731427844; cv=fail; b=GEXEGLfDHSLCfPsNoo1NLgwsAcwNqbvyhjBXZDPnJSW7h47AqU/l54l/ja5ZdXuz8vMkE51S1dt7fV9zI/957krriotO05lakNXVMpN5aqUYvXwXA90OCzHGtCCb/tzC46przP2ig5p37q4AXDRNQZSMKbKsfrNTuIa2AdJkdQ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731427844; c=relaxed/simple;
	bh=GTOe7a7qJPCcV5ARy05NAf+z75sBt7LAUM3mOQdMhUo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SSFt7fTxXLz7aH0IMUdesHgRNZSExnex73mff+uzmy58MmI/PwQclsFIoAX+R+megVcJwl+jABWadLuQIobMDMoab14IjDvpF01pboOsCOiQthX1qGkU5q/UQcuhAxsucVV5QLdkhX672vhGgY5L/MNBx4m51jVbDI7hOORcwNU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mM+mGrbS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FXw6H+by; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mM+mGrbS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FXw6H+by"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACFNdvF008518;
	Tue, 12 Nov 2024 16:10:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=dlrSVlWX6QLqGPQ+F7bKfzSxoO+BKzuz7C8fCrjU/Gk=; b=
	mM+mGrbSCwKnB570PkLcXlNhWCqwmnb2z42MNH53CATiccCXAlDTCpw6ysv6+N40
	1klRZ99AoFCX23/mvJ2mtnWnqwHxDCe8HcQP93/dYJSJ2AWkgewodkEkHDYiEBxC
	eXEjsxI6y/FDMgmCGKm0rmCOv3mwD7MmtU3/sHLipNJPMubB+VlbW3KBBAV9QgqW
	2JaeUbaec0WPmPPED7NL/FPCHgNpN0hZQq5yP9sPLaAMAghJ+pjTHHLDESGVLfcd
	xP1Kn6JR/IhrpNZKvDWzV9JsDJtxy0X3SHtl/FsPNPYs0by0XOOjCksWRYw7X8Xe
	FWnhC1Q2hWGG8sCak0KMJg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0n4vrg1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 16:10:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACFvH9C001369;
	Tue, 12 Nov 2024 16:10:35 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2049.outbound.protection.outlook.com [104.47.70.49])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42sx68c8wj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 16:10:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m0vDvFC6eRX34zuFo5i32GXD6ZzM/WCYpIk6WavEdgH+dHqxZxTMipmdt1AsOeK0L/saIRlMu+hXrEcLkeC9IQRPXGA+UEnFVYb3URZ7RJlUyFvEXOsdktvH0HBp8asoDR5Nfqb1UyMyA3Z8nH4AojARjebbO27HiJn6EUDZjyOSfi85MYMB9asYtGBHsBHT6GZbDUSYtce/c0jzj2VG/UkiyJvsf1E9SOg9iL1UJWrKQQr/A8E5dO5jds8ehOvBuWibIr7qM25cVXlGQYF/GchReKL6tvAi3Zy37UkS1+6HX9j0BJsNhMGiipbN+bj/tmp9iSQhXf7GxZ4y89knKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dlrSVlWX6QLqGPQ+F7bKfzSxoO+BKzuz7C8fCrjU/Gk=;
 b=KayJ6RI4t9ZUyZdJUBHN4/2b1UhK1+wiuC+ro0/FKuzNVYFb7y1OBzp5rmtrkwPGEFmBGRUisHGjMEactRleKkcc+AJg6zwNu5gWOz1Kh4hiiuPj8VF/5yOVjt8BELClX2jC9aXbW3cagmiUtUVKBm3m7reHNJO1ylcTOhmOKZZb10VY6INz4/uZl2HMFs/pc472qa3zOanfHkIAWdPXsIpqeD7faHCCMGlyKEjF8kVvNuMcT3VRaWXyJ5MWeK6tQrg5WK6mPw+QEyQx8Ba6B25Vtyv1kH79KrMpFaH8sZxKBUlBlTJCvtVqkilK43Wq6lKL3QYraarmtV7NXX9ioA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dlrSVlWX6QLqGPQ+F7bKfzSxoO+BKzuz7C8fCrjU/Gk=;
 b=FXw6H+byKP0mfybqhLqYwFDF8C25eL0GUPpBNTuljXHKMps2loPmnDWyucsD6K61ThbzDV1RXQFkc94Bxh12ho7d3U1EyupfSVN02YoWUdtB5yT+HDv/6oukbk/sMDE70ndXwFQg+zbfNnRMyWMOEn3zyd4aOQIixL9T/vBkHTM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW5PR10MB5761.namprd10.prod.outlook.com (2603:10b6:303:19a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Tue, 12 Nov
 2024 16:10:33 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 16:10:33 +0000
From: John Garry <john.g.garry@oracle.com>
To: song@kernel.org, yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 1/2] md/raid5: Increase r5conf.cache_name size
Date: Tue, 12 Nov 2024 16:10:18 +0000
Message-Id: <20241112161019.4154616-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241112161019.4154616-1-john.g.garry@oracle.com>
References: <20241112161019.4154616-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO6P265CA0011.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW5PR10MB5761:EE_
X-MS-Office365-Filtering-Correlation-Id: 44c66ee0-14e1-44c4-8c6c-08dd03348947
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TWdMSzgxeDRDSEV3eGRsb3F3WVgwS2VUZWd4WmNpQ3dNUjFHK0hVbmhoZVpZ?=
 =?utf-8?B?S0t5TlVETGhVbGV2ajVGV2d2VHUzQ1ptaVBDZUFvSUNxemdveVZEYWduRHVM?=
 =?utf-8?B?WGpMRlYrQVJ6NlFrZXdBN2RBNkFjQ2IrSXVoYTRaSVNCTUtNTUxmWWQ4ZXRX?=
 =?utf-8?B?Q294eXNyNS9samFjbTN5eGh4alVLTU5aV0JaN0doYWd6TDduU3A2dnlsQWUz?=
 =?utf-8?B?N0RvOG94L3hmaWVTVnNmTXhZK1hkWXRzL2tLWFlYcDg4YXd5cWVRUEV4YWh3?=
 =?utf-8?B?UVZmU0lHU3BuSjg5R1NxKzFhc1B5U3lIM2djN2UwZWZzOFZSYVVtY1AxMW9M?=
 =?utf-8?B?amJJaHFrbmpSVEVVb1VkU1dLdlByWWpMYVFQMk5LQVhYdzRraW9PSU84bnBt?=
 =?utf-8?B?dVFocGNWL25KOEFrUHpYYlhiZmY5TXlsVDZtM3lySHh5SnpFZm05RVhFTCtS?=
 =?utf-8?B?VmROWTJTL21qNCtrcDMxUUt6Y2lOQnd0eHliMld3VUJVUTV3RTQ1RG5UZitV?=
 =?utf-8?B?YmRLUG9YTmtnT21YZzdnTG5GSE1hV1Q4WFdDL3Bha3paK2RleHVETzYxM0Z1?=
 =?utf-8?B?cGJodWZDaitQa3pueEJMODBEcXk2c2U1N2w2ZTN1c08rMGh5ei9KTXZiNGFu?=
 =?utf-8?B?enErd2JIUk1RakVsNE1UOGdMbHM2c3VYMFJOOVMrNzBtREpFdlBLRDlVd25k?=
 =?utf-8?B?VHc5Qzg2OGZjbGRLNFltUDA0czB2KzdLWXh1NnZwU24wNlBBUTRBbERpdnB4?=
 =?utf-8?B?dy9Ndmxqd1JSK2VPMjgraVBQSUtSd3NzVE4vZ1prY3AvbjJPamp5UENVN1R1?=
 =?utf-8?B?L05CRzVVaHB1OFdpZVBpRndIYmlaTlBWMnlNbFpPTlF6TENKUS9ESEx3UkJL?=
 =?utf-8?B?dndPTGF5M3FQTER0VWdpNXp4NnUzQ2ltMkU2QWZCSFRpSFFvRUZmRk5xZDV2?=
 =?utf-8?B?S3hHaFVIendyYmNCdjdhS1FmMEdqdDhHdGxCSmplZTA4Z2FaNFFPdGRjeU9C?=
 =?utf-8?B?L2ZGZUxHUjhiQjM4OU8vNEFvYngvMjkvTTFVblhsUlhwemRUa1NFSHRRRG0v?=
 =?utf-8?B?NzZnVDEwVXArdFptTnlYYnVVcEJIbUNGRE1xTFRITVRLMHcyOHhGT0xUSDdO?=
 =?utf-8?B?cC9pSnRSVU9ZUmZESFovaGtXNURuYXZhdVpBdFN6L09OajUwdUZCTU9lWVNU?=
 =?utf-8?B?a2VZWUZaZVAxM3J6dXlUTmh6UFhFK3I2bGRhaVQxR2oyRkdsL3ZkWVdEQ2ZE?=
 =?utf-8?B?Y0hDOFp1dzE1R0cySnpqM2lBVUpnMjhjZWh2NFNRbzBjV0FBTlFFekEyaWJC?=
 =?utf-8?B?ajZRRTlyYnpuL2VzbzQvQnl2eUgxVE1RT3lOZHBRWndrNGZCRTRJU2V6L0Vl?=
 =?utf-8?B?cERLazIvdU5oQTBpRGhEK1o3VUdxN1E0UWo3elh3c0NOd3NibXhBV1JaVzNq?=
 =?utf-8?B?dmZEMDNRZTUwZVR5dHpXc3I5M2xVLzk2TnlLcTkrL0ovS2M2K2FDVXlwbjBU?=
 =?utf-8?B?T3hVQmtZZFZwVmVTYU81a095cWlMLzFWNjFHMC82MTczaWpDUDFqYTRDck5C?=
 =?utf-8?B?dlYvblZhZzRLNUMyNTJIbm9XUkdLYmFpUGQ2aW5QbXlaNmw2dU1IaFNuRzll?=
 =?utf-8?B?Zy9ldytydzI3cXlqSStkOEhEbU5pSzdLYVhhRXN6Y2w5NTVRVVNIbmg0Qmh4?=
 =?utf-8?B?ajZrU1lIZi81bGExTDJIZEZ1NmY3eDRsV2lwL2lUQnhtYWpyUkJPYm9RazMw?=
 =?utf-8?Q?B/X8kopmBhicc6aa4/oAPePopKM8RPDAT2aGMgY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Nkl1ZjVNU1dCZ0dMN3FPbGN5cW1Hb0Y4VVBwVVN2aDRrQjFDNnNkeVA0YXNw?=
 =?utf-8?B?eWZsdUoxbzlMMkU2VEF5YVVvTG4xK29nR3psWCtPY1hKQmFHdDVtZDdDaDR2?=
 =?utf-8?B?MVpHY01seXZaSWZNSHVMaGh5MDFpbmd1ZHVvbGFGdytyVjhDVXArWjNRQ29h?=
 =?utf-8?B?cW5GMHdFRTlacW5GdTdHUWFsNzB5VGJwaDB0ZWZRZ3B2cEJ4US9uRzkzSjYx?=
 =?utf-8?B?bVYvanNpNVVvQkY1MndIZG4weGl0LzZJMTJidzA5YzVuWlJCVjJ5UUtQcDdF?=
 =?utf-8?B?YkROTlVjSThpakxzMTNvaURYZDRCS1hGZEJMd1p2WUtKKzBZWW5hR2hhaTZC?=
 =?utf-8?B?YlFqb2EwM3Rwc3VGOGRRemc2TjNrV2ZJSlJqNkV5Q3VZMVZDbEtZOEg0WW5Y?=
 =?utf-8?B?aExHSUJKNDU3aUVMa0pwWUVEbE9KRTFGc1NiSjV3UmRMSzlaTjU4MklnSk1v?=
 =?utf-8?B?czNFclQ1U2FMM3MwK1lTam9jdVdlbUVUZDg5bStzUkJBQzlwYTFNbFI2Yyt0?=
 =?utf-8?B?UUNzT1N6alhTVXhhazFNUFRxVkV3MHY3VVZkVXowemRucjFIVUF5Lzdya0c1?=
 =?utf-8?B?THBZUUREdFFLZ1g1b0tNbjdwQWxPSXR1MFUzbm1QOG8wWnVtWndvWkFKTmE5?=
 =?utf-8?B?Zkdpbk51UWZnSDhhZGZNWHRVWjhVSU5XVEdjeEtpMW9teitVaEtCQnNVZ1My?=
 =?utf-8?B?QUUxUjlGVi9pa3lTTHg3S05kV0ZleTBmdHI0S0ptNGlkVzcweCtabGtzUUNz?=
 =?utf-8?B?cTRpQTA5UDdmV2tJZytzWWpFRklLNFptSEl2bXFQcUs0czJ3dXZUNjJiaUI4?=
 =?utf-8?B?ZGRORFNYeVFOTnh1cWJKUHZnaExrZjlnMUhSQzMxbk5JMm4yQU1CSEprMXlz?=
 =?utf-8?B?Mm5zZ20wc3JOelNXMXFXMDVEaGdrTXRHY1ZHN0FiZVhBOW9MSE5HQ1BoeEhR?=
 =?utf-8?B?Z1hlTzc4dGlMQ21qZGx1N2xaZ2VycVBHUFBFVGNDclZuZEZlVG1aZTVVYXlR?=
 =?utf-8?B?VncwUzVpM3VvSGVnVVF1V21FRnZ1Z2JlK080NDRkUDRpbUplNWRGdm1tVVMx?=
 =?utf-8?B?ek43RUwvUDdhOHdlTzIyZmZiMm9YNmxwRC9VMUJuY3FnUlo4eEVPUk1nd2dD?=
 =?utf-8?B?NnUxUHZGTVliazAxQ3liT1p3QTdDYjR4b05EU1FLVjJCSC9uc3IyellJaHdk?=
 =?utf-8?B?MEU3SXpiR3hGZWJSd2NxWTc4b2lXNFUzQkxyOEszTzJDa3BiVWZweUJMWU54?=
 =?utf-8?B?dVZseTM0RlJzTDZhUGlLalR4V1gwRVZjSmlRNlVYQ2hYOGdqb0ZUV3VOYWY2?=
 =?utf-8?B?ZDJDSG1UWlkwRXJiS0owUktMT1FBTGozYXREVnNqc3YwTC9oZzh3UWNaQ3U3?=
 =?utf-8?B?Yk9LWlJTR1h0TFl4RWFGd1JGMHZtVkd0ZXFncFpLYlRhei9HdEpVdWRvdk9H?=
 =?utf-8?B?U3ViU3RjUmFXVTlCSlBYUXd6M1MrczZxT3lEUmF5dXJKVDF0TVZGT1Via2hw?=
 =?utf-8?B?MkJkbDRLY2lrZmVSY2VyWXI1NUthaTc5U05ibS9VLzFvaitnSzlreVgyVlhw?=
 =?utf-8?B?MXV2M1BHWlN4cjlGWHZKTmsvWnQ4RDQyVFlaRm81Um1FR3Yxa3NObVA1U1FZ?=
 =?utf-8?B?NFhwM1pYTlRvSGJvWFdGSmQwc01Eb1hlTGpFTUJ6aWppNE0zV2Vpc0N3dzBP?=
 =?utf-8?B?MDZzdHA1bE9kNHpCYW5WQmhRa2pvaVpGclEveklUbFhuWEFNd0YvSW9ndGZF?=
 =?utf-8?B?ZGNmU3VWTTFSbDBSL1JNSVpQZERrQW9nSXBpZmZ3WVRRREI2dThtZHgzSGE3?=
 =?utf-8?B?NmpTenZzMWVFWTlqZUVRRkNoekJxR0E0cmNwUkdaTEJBTlk0NkFibUFBd0xt?=
 =?utf-8?B?QndJc0VaRXp4dmF3cUtaTWtRNnNUYngwUU1EcUYyOThGSUI4MlFObzk1eVc1?=
 =?utf-8?B?RTdqWW1SVERuemd0WjNjRGw2R3d4Tm82SUFyVk0vTkJ5dFI4UFpKOVZSYytn?=
 =?utf-8?B?MHFuQmUwUlpCSzV0WDJ3eU1xL3hMSlpqcEJ6T0gvY1ovcEZrNGJkTHVUT1BB?=
 =?utf-8?B?cTZsbkwrL1VGbm42TUdTc2ZlYlA2ZTR0VGhOYVpFUllybi9mb2JWWWVlM2Z0?=
 =?utf-8?B?OGE1NTFXKzRaWCtsVU01OHJtazR3dVo4VnVWcUZDcUROL1E4MHpHa2FwY2hL?=
 =?utf-8?B?TlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4Zt12Awm9CCfS3vzLzsB/TqK5WJRxy441yJsEAigtXrodgRzfDhr12m15IfSI60gcSk+UQTtOzMth1QqTYYdviJWK29sCei1gmWc58GBujFIFmaqybbpAribtd6AnpQcIcKQPiFMtJK1Smp/gUgZyvYqWfftRUF2KBJ995F8sgKKjzfMLgm4AenX/uBA1PpBPnOUJ6FbG49UtkxpUHAqzrYU1KzM4n/KY0z8Mdebvyp0KW31hiPYq9tOsqRs7LngwyRv6dLnhz+hZ1dukL3HCWS0I06XQaZPfG6YfR2w1zTl2JVgBLIA2y+1x53m95ht5zNzIlza2l6+tfiliMcCKT+lmz+nrlHy7amkpP0KIMQ7G9qxpPSdMHZBGI4hY7q0AoNQygD4geSchVQCZbasfH/CHK6cGNSyIvZ53sY2z1nb+TiqA2PDr23xApWnCmZtk4+wak4zJXZj1sDOLc7nEnF2d+tsfYvFQ15ZssdbtyathByJ0GoLy4YVL+WBLSd2nEvUMpzwkoSAV3vigFwvttV47VGD8TbjIfpFSeLH2m3YiidX/wspzm4nSX+bsZEIvDq6MxxyqIljmjLEeJgUld1bV5suhiyq8SYoQeyVAxM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44c66ee0-14e1-44c4-8c6c-08dd03348947
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 16:10:33.4022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PE9tFSy4L6p64McyCzQ57pFrMFeagy3i+2L8QzngLrq2WRS0vFP5GO8jKF0zyNmM+9USW0GBr17zn32gUL821A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5761
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-12_06,2024-11-12_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411120129
X-Proofpoint-ORIG-GUID: ppvZjPYTeUQbeRyd9x61mB9GUrv_gHcN
X-Proofpoint-GUID: ppvZjPYTeUQbeRyd9x61mB9GUrv_gHcN

For compiling with W=1, the following warning can be seen:

drivers/md/raid5.c: In function ‘setup_conf’:
drivers/md/raid5.c:2423:12: error: ‘%s’ directive output may be truncated writing up to 31 bytes into a region of size between 16 and 26 [-Werror=format-truncation=]
    "raid%d-%s", conf->level, mdname(conf->mddev));
            ^~
drivers/md/raid5.c:2422:3: note: ‘snprintf’ output between 7 and 48 bytes into a destination of size 32
   snprintf(conf->cache_name[0], namelen,
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    "raid%d-%s", conf->level, mdname(conf->mddev));
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

Increase the array size to avoid this warning.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid5.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 896ecfc4afa6..3da5b412190b 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -633,7 +633,7 @@ struct r5conf {
 	 * two caches.
 	 */
 	int			active_name;
-	char			cache_name[2][32];
+	char			cache_name[2][38];
 	struct kmem_cache	*slab_cache; /* for allocating stripes */
 	struct mutex		cache_size_mutex; /* Protect changes to cache size */
 
-- 
2.31.1

