Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2D317A2F5
	for <linux-raid@vger.kernel.org>; Thu,  1 May 2025 05:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746078510; cv=fail; b=R0HQKX0zdFu5hEEl+KcI37R4UUfYe5KZvkVeAX7UoTdxSFseGKGsnQjwjkjytLPIX6jCqUxO0ii21P2M8JMAGEU0Rs/3erD9kqQbhD5ym/kplDRY0OZsvF3aJ93S0Xu84p8hDfZP8yRecE/4OwCeDxq9Okh5ROzbL6r03XhbX9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746078510; c=relaxed/simple;
	bh=jeL7LlKjVdn33bFSJUeVejUVLEgwhp7uWtzIIND/uhc=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=GFylD696mYOmslggKYRMOOZzxLbt+JFNG7cqJtdq+DbrpAsnKOFDVwobPH47VckE1IKlxVj64q9RNADBdKYQJwFkMxAE4oLymJC7OIigaEgGYiib/y4No4jazxYFo8jNQ4bPMpp+R3/PPjbpqv1hlPNtp/9DpA0JP5Uo2rnRqMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pJJrjXIY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eqSc5g4b; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pJJrjXIY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eqSc5g4b"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53UKwX0C002688
	for <linux-raid@vger.kernel.org>; Thu, 1 May 2025 05:48:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=lJ+ljMF8wsi3Kt0k
	P+qzoi3Tc8TN10kGHYRDyMyoFm4=; b=pJJrjXIYZ1xmqEltp1d0Im7F8JCVFdGB
	O/cu6if7E7zz2arGSkMu7f+30NpVFUH2fBA55ZEZwBJ6NrBA2lZ3He6ly1pA8Ul3
	T+AK1Q/kwLl+hd4QtIfa9dyaCJm6N+EnTLfT687EXR90+4ROD0O83lh3ysns4YiN
	Z+a4chCIwLnr5zgoxJ5sUrxEpa42yI5sbHoDfM60xWK1ROkxjMu2hJ89qCScv1AF
	dDn4fN4mNmOEx7Fbn96BGhbWjraVepWVg36aSP+g74kQcnrVw7K5MLj+esaFfZCn
	i19jxt5O5slOF6ld5b3X++YOzZ6AAyEhd0c1Lyg//rHoTDT/e6qlbA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46b6ukjhgg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-raid@vger.kernel.org>; Thu, 01 May 2025 05:48:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54144fVC023840
	for <linux-raid@vger.kernel.org>; Thu, 1 May 2025 05:48:26 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazlp17013061.outbound.protection.outlook.com [40.93.20.61])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 468nxjfpak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-raid@vger.kernel.org>; Thu, 01 May 2025 05:48:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xdPxmxRYhv7Ud0Cnm4sr9mKjXMa0MBOrucKcndl+LzZ680Nsx/i277vQthfkhkBD9hOTi+Ncvxo/MHcLzskK6eXw6baa+6u0qzSPOxMrgPbhgw5xGvbBWKtoavzPNpHWJIszNjT74SCQUjwPQkUgk23uBUtq1AY2imJFfXWH1FgfeP84dGAOrCtdLjNWtJrCtABGTl9ySBDfEOmibd0j3TXrVy6GYvI5Edu/YFmG/K28cBL/5As7lmu/EHzdHn5chPkuOdbxqnTujnsS6uqZbdG2DdsekPXI4gprmI7Ji3VYiM0ERyWfQIlCePcuBBQWXCHzqUH7o4sROpsnqGgOMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lJ+ljMF8wsi3Kt0kP+qzoi3Tc8TN10kGHYRDyMyoFm4=;
 b=N9kkWf9W8RFgK1OPKxwYLPVCfmEsEJA6ZznNXZ7Y4vOvnNKm8SnMmcQzkET5nWVI06CqI+nili5v1hLwDAuvZfkxJ0HKTiuTwUfW3pFEXKx7DhnahSj5sIihIHfCcKsDpQGl0d/fsndlAFoJI+HXcfZAGJd6ot33C2K+XQ2OQBi5ERWPi0kryAFPeA0rhEkNfnHcQgv3vkcPBu3rgECzlBo8LDs7mV2NOhQhQ/2uOvrKAsiNnlOXXHZtoI+PHT7NB6lgRR6GBmwI/lAbTO0gkhGugb2Nnyy1julj150YAwZbiWYigLRMX4AsgelbyLRunW80kNU0wmroJ3PY3Aw+oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lJ+ljMF8wsi3Kt0kP+qzoi3Tc8TN10kGHYRDyMyoFm4=;
 b=eqSc5g4bwtEqVVlLvnK4zfbc4cKeJ1579Rn1IKlkktMZQHMnLi3nQHJDGtGCiYRqkiETeqwJEnPFJGswRSMcZEzUSv3WP2oQpyVhnKfxptFVz4Cc0Y8vJzPVk1k5/MwiyVvzgAyacWG2rOuIzb3YgI8tzSvYEF5u2iKhsHuLro4=
Received: from DM4PR10MB6040.namprd10.prod.outlook.com (2603:10b6:8:b9::13) by
 LV3PR10MB7916.namprd10.prod.outlook.com (2603:10b6:408:218::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.20; Thu, 1 May
 2025 05:48:09 +0000
Received: from DM4PR10MB6040.namprd10.prod.outlook.com
 ([fe80::ced3:7ef9:5d82:5a66]) by DM4PR10MB6040.namprd10.prod.outlook.com
 ([fe80::ced3:7ef9:5d82:5a66%4]) with mapi id 15.20.8678.034; Thu, 1 May 2025
 05:48:09 +0000
From: Richard Li <tianqi.li@oracle.com>
To: linux-raid@vger.kernel.org
Subject: [PATCH] mdadm: Fix IMSM Raid assembly after disk link failure and reboot
Date: Thu,  1 May 2025 05:48:05 +0000
Message-ID: <20250501054805.104978-1-tianqi.li@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0170.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::14) To DM4PR10MB6040.namprd10.prod.outlook.com
 (2603:10b6:8:b9::13)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6040:EE_|LV3PR10MB7916:EE_
X-MS-Office365-Filtering-Correlation-Id: 6087a042-1914-45a0-46e2-08dd8873c096
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VkE1bHJ5MFdnSGc3MEMxcVU4OEdsZ2tNdXhoN2hPS3hTMUo2VXFVRVBFWWZ1?=
 =?utf-8?B?ZWdLNzRacmdGZUwxV2dEUlp0V3NuYjBlNVZWTE9OdVF1WGZmcjNYSXdJM1dp?=
 =?utf-8?B?eXpRVzVPK2YzampGdlBYU0Q4anBsODU1bXUvTzQrSDBHV2oxaFJER1JGdGY4?=
 =?utf-8?B?QjZsQTJjQmwxazhpVGw4ZWRnM2NQb3ZOOTNGMDZOOGlYOGVuQzErMk9EV0la?=
 =?utf-8?B?MUl5YnhkK3JmR3dDakpVaXhFZ2puZ2xIVFJaaFpWSWJ6WUx4YUJxbldYMzNw?=
 =?utf-8?B?Z2ZuemFRNkZkWUdqOTdGT1hMMlNERzJqVFdXZVVXRk9OK2o4YUJYMEUzRXVN?=
 =?utf-8?B?N3NpVTBFN21wZjFyRzI2Q2VxQW95RXlJQS9rSjRBaHpsRTZzU3ZPU0JmT0sy?=
 =?utf-8?B?aEtnRm0rY3JGSWgzU0h2ZHJZZ1VjaU9MQXN1d3V2czE1RVJjTVhwblRkZ0dr?=
 =?utf-8?B?M2o4Wkh4RjBxTEFGM1k0MU8rWW02aU55dHpDcTFVVkRtZC9kcTZxb0xiaS9X?=
 =?utf-8?B?aDV5Rk12NDRkd29XTU9wRkpyZndGVEcvQ3paWVR1S0NqOURyS3pET3lINWt6?=
 =?utf-8?B?TlNyWDdLNlRKWmpFU1VPK05BckJWby92Y0tFZlliVUxrNndRQmNkbHY4RXda?=
 =?utf-8?B?eTlaWFUxUWs1TnBVUXlDTk5JaG5mZ08zYkFZQ0pXUjdvYy8reHBrajFiUm9W?=
 =?utf-8?B?d1ZaT3pRby9SQ1hwZmhMampZa1phb055ZVJxcXpkdFpWWHpCQ2NEUVBpNlYy?=
 =?utf-8?B?Ym1LQVRrTWVxSW5rakdUS3d2RkkxV1BmSHBVZ1J6TmJTY2taajl4RzZhRjI2?=
 =?utf-8?B?M1hIZ09CRnlKRURiQzIxRXlSZmtCeVFsOUhNeTR4dGczTkJOKy9SUlJ6bWt3?=
 =?utf-8?B?b3NkTDI1c2RoTkJOcG92dHNLTVZtR01iV2l2VXVDeXhFSjhsQ1ZxN2lDWTZo?=
 =?utf-8?B?NWcrVjRWYnZDMHFIaGJ5c20zMDlUSGFDVVF5TzRKWVd1b05qQm9vZ2Fpdm5h?=
 =?utf-8?B?Y1dGTDhBdWtwNW1qQjUzakZaR2dZeFNudFF6Q2VRK3E3WnJYMVkxOFowNkNW?=
 =?utf-8?B?bDZ5RWxCTGNZSk0zbHB4Y2xnWmpkMDROZlM1RGJNZE1wZERLOU9XRVdDMlQ2?=
 =?utf-8?B?eWVHRnVDTjA5bDdPaTErRHV3bFFnYzh4K3BjSEZTbXNNU0JEY05sTWtQY3VO?=
 =?utf-8?B?NzlJSko2SU1rVVhGYkNGOXJVdmlPczFzTDVjTVdNTWMvMVYxV0Z3QTg2UGIy?=
 =?utf-8?B?TVpWL1BrUzZtOGg5b0hQQVhEdnpaUW5KVUlmZVdZL2pnUkFKMmRoVktoQ1pl?=
 =?utf-8?B?VW1PdytJWUk5V3JmYUt2UDhIakVURlByOWd4U2Ztcm1iUGtadmdhK1paYlN1?=
 =?utf-8?B?enZEYWRxTkZ4V09WTndaY1NLSFlQUkF0SXYvYlVnOU55TkFEZjNUVUxEUUs3?=
 =?utf-8?B?alU0WGRheXRJWlhwV2FBeDk2SDd2QzlyWGJjWDJjb3VWWVlxbExManZjWjM4?=
 =?utf-8?B?YnJoY0NKQjQyVGxiakZKbDBLRWwrY0pLaTc5VUExV3VuSWt1Ry9DVll0UUN1?=
 =?utf-8?B?UmJDd21yZmJGdmEvSUo4UnA1eVRVR2k5d2IvVk1VUXJHK3Joam4wM2hsZVgw?=
 =?utf-8?B?ei82WnhjNW1yR05Jd1VZV2dvYlJXaHNaMnEydVg3bThtU0E2RHZJQlNhQnB5?=
 =?utf-8?B?QjBoWGFpMFV0WWJkZHdvRHdpcVhhVHpOVHZYOVpQcjZUaC91YVUyQ0VoTmRm?=
 =?utf-8?B?OW5lYW5mWEJzcWxiUVh5YXFoRUV4dCsyenJXdW1ldGluRjlvaXhBWWFwdUhr?=
 =?utf-8?B?SWVZSldQb0RVVXNoSHk0eFA3VmZvb3A5MUROY3ZPb0V5bUhMVzNnbGtEeW1n?=
 =?utf-8?B?SXdyS1UrelhIMWFZZzhQUHhkS1U5cm5EZ2hMTFJmL0JKaGpQM3l1RjJhYXhq?=
 =?utf-8?Q?Gat5Fp6To4A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6040.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a2VCN2tWNFZyQXErU3ZzdHdudkZ5Qzc0TUpYTmo1U2Rqd2FMT3dpWHNkcnBR?=
 =?utf-8?B?NlVzYlc0WUE2eTRVNlkxcU1JNVZGY1Q0VGJKbE9iTU1JTWxLOHBuaGtoNHNx?=
 =?utf-8?B?M3VtMWh6RHVmclFZUCtXdWdJSjlGbEcwN1cra1h2b2tVM1BsTVRkWjhtbHho?=
 =?utf-8?B?T25SQ2E3WWFVYWt0TUkwbFRwUWJMRjhHSXNpS0IvY2Z5RUFjdW0velFrZnVN?=
 =?utf-8?B?elRxZzM0R0VoSVZvWmRiSnR2aHJURkZYdWlJL0N1dVA4WVpiOS9PaTM2YjJz?=
 =?utf-8?B?NGQwMEtGekZHaWtPWE85K3lDYWNtVTc0Q3haL0pzaW9OL1BRL0xjamRPbmFi?=
 =?utf-8?B?ZHNsV0xra1Z3TjMxbVBCaXQ4VnBjTFpBNEZGN1F5TmYzb0NNeXJwR2VGYTZX?=
 =?utf-8?B?SVNiOEZRYzN1bTNYNzJDTFJRc3pXKzQ3WGVEMXdtWE0zYnlIbWFEK2lWSDdr?=
 =?utf-8?B?eHN5Z1FkM3FkLzNUOUFZNVBRTlovZmdSR3NHajJzMmp6VzhhK25tbUxCSDRB?=
 =?utf-8?B?U1VCNmhXeGtXSEhjd1RJeG1OQmNKeUtDWkRKNFc2dndONFU5UEFUYXRhSXRw?=
 =?utf-8?B?OUh0bkVrWGEvYUx6MyszUVJSMGkxSVQxS3pmK3ZOS1ZmWFE0aHlWSXdQWmdY?=
 =?utf-8?B?LzY4Zi9Pd3VJRGRXbHNQZGg5QTBhZy9qNlJOdDh5dUVaZ2wxWFVQRkJ6T1Zq?=
 =?utf-8?B?UVVrNnZhM0x3WU1neENEZHBORFNDZ3p4Z2E5OFVKSm10TGxHZDNkd0FzbUF4?=
 =?utf-8?B?bnVZQmVUM0ZweTRCWjVvRjJxZmN5NitjRXE1SmJ0d3ZZRmgxdFg0QytOanVi?=
 =?utf-8?B?ZjI4RCthNUZoWFhLWVhaWDFkb1Zhand4UE40S2dTdWFQd3RTSGZ4Ykk0ZHRP?=
 =?utf-8?B?ODJCbHVweUpXZUJpRzVtaGhpS3VrN1VkY3hCaHJkaURnTVlnNXdncjJmNlhW?=
 =?utf-8?B?RDllUXBOVlhpK1YrRXZIendDbWRYdUV0Z2NHNmlpdktJS2NJWjRab3lkaVRE?=
 =?utf-8?B?ZXdTR2lua2huMkNLa2s2eG10SEt0VlFLR25CSHh5aTNpRjRnWTVtdFh0cUdV?=
 =?utf-8?B?SE8rbk5kQlR0azFQT0RzYU9zSml1c2hBOHpxblpPWDlBV3RMWGpMTWE2Z2Y2?=
 =?utf-8?B?T28rN252R0ZEN2cyTHNMbVFkNTErSHpZMXAveGRMNThuUk1pNmQvRXFKNFdu?=
 =?utf-8?B?N2lXUkhqS0lvTTlMM2Q4cnRGbHdHZERGclFEU254WW1vclVBUlFCTnBzTld2?=
 =?utf-8?B?Szl0bU55MGtxY05EWUE5S0lXYThyeWZQR1RJeTNoeEJzZ1FaeFZQYnVqaGd2?=
 =?utf-8?B?Mml0MkNVOWt3ZWNoRUtQSHhidDgwUWFPV0VpcnI1T1RiM3pVcHZDb1JDUGMx?=
 =?utf-8?B?Y0JKeWx0VTNpa01GcDE2a3FndTlCTFYvUFkyRHNidzRBSkF2V1FMdW5LY284?=
 =?utf-8?B?WFRUMWJWZFJ4Q0dXdXpVMWxtamY5S3hkK0xsYVBRRnNsQkdSK0Y5ekVnZy9q?=
 =?utf-8?B?TTZiTkhvZEpqV1BILzRrdjhZcUtTemppUkVueFpJR1J5UzFXbWVzekdEMWha?=
 =?utf-8?B?dytpOSsvb3VRb1YxeWt0UENTcHFka3NuUHJ4Qk4yZ2dBT1BvdE5IS0phaVlq?=
 =?utf-8?B?c2wxWnpDQlVOVjJkRGNTTXNYekRCV3JWbmMvYXZ1dkNQZWtHZm84ZEE4Qi96?=
 =?utf-8?B?eXJkazlEeVB3Zmd6K1VEbWR1MXc1NmtpSmpLU2xPbjRodGZtVjhvL21yU3k0?=
 =?utf-8?B?ZlczekNFQUpyV3JSZFhuOHBNZ2Q4emZ1Y011UFFqMmwzWUhBcXF2Rm9TZTd5?=
 =?utf-8?B?bkU2VHlIODlma3hUWktKKzlFZHVnVjlSY2M4Vlk1c0NhRGYrU29DcTRtVXk3?=
 =?utf-8?B?cVF6UnNiMFdudUdpYjQ1MUd1N0dEYWRmeEt5c01SNjBpQTVOeFRWZkR2blNn?=
 =?utf-8?B?S05hd2pHRE40N1kwNUV3YWRZVVhJV3ArRWtHL3pnbFpNUlZpWnUybEdrVW1T?=
 =?utf-8?B?YVdyUGdQdUtoOGxpdkJScE1Tdnc1ajB2WkIxcXI0UzhLM21NNStwODVlVTZQ?=
 =?utf-8?B?enVqbG52R2hQQ1Y1bksvNVArVmFFTHE4K1ppTGk2UkFCOUcrNzNxWWlydzBI?=
 =?utf-8?Q?N71lh8jc7SVRQTPcOlZ75QtuQ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hGPQYUIzTajGQsp/lP4hknDpR2dxP2iIwybBAmRkuRiAq9sXOQAukkmngSRyOqMp34Ql5iRjKoSEqdA4bBQ4rIycH+mlv3pZTIG0rVVvRkQVCepsfVJnPWfeWb6VDalfGdigYy1qxgTXsxgN/XWloSzezsz4uhOpPLyGLuixEerXV8sAbW80vHIpDJtC9iBrTTqgV4VaHsV9vKIB1wPpz7KAfOE2+u9UvdjVJJH7QXC16l7DVBg982mzrzsxDSUaa90EN/SJbZXrkvj7/OGZlYdbIu25E1wPT+FmUc8p2R0cqfOt+8IEaEjySuY97SvLSLF+6wXOyVm8gd1Xi3ygI0AFM1mpM5JqX4muCzQ2e2pcUUVluDEIxCHFa9XPjYyl+KZ4d0kCnT6jRsJXOhbCoz9dWSCD5mRv1knne0yOOVKdKLDxExLRKGnD3VQUzBqsQSnOiVy2oJAr3QeRG+rK13MtSZgfs+0JTJ1XeeCMGoODWWkVShZC+4IUNexAH0ndSXkl768C/Haqjeu5DJa3va2x3Ycr8pua/uUlTzD0V4MU2K6wIMDnbG9Gw35mtqqr2/38MG123Hi3K6MoaUZinYo49tx8oZdrkkUgyaytzcU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6087a042-1914-45a0-46e2-08dd8873c096
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6040.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2025 05:48:09.3347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aWGY6jm79KQvwkGVG+yg0vLGedG93q8TLt3vU7Vj0auCaLoUkfnKhJ5g1hP8IJm0pzq+43GdrVV2IR7d51zcDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7916
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-01_01,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505010042
X-Authority-Analysis: v=2.4 cv=MIZgmNZl c=1 sm=1 tr=0 ts=68130b2a b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=CSnNaLoam6terLhnIKsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13130
X-Proofpoint-GUID: oJ4utz13hnuOxqlmlg2PE3DT5bRuQ6bh
X-Proofpoint-ORIG-GUID: oJ4utz13hnuOxqlmlg2PE3DT5bRuQ6bh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTAxMDA0MiBTYWx0ZWRfX8RZjxKpXTjDK okppNdZO/AKWEo5CPdxvYLVwGtblyuaxX/Ywo6s6nl98II7Lx2Kaooy2+O4q+zSwEtmwWSD1gf6 SwXRNWF31mFaBV3jEqMcw4lRCrBp8K2C0lmVpxbqvtb7YMTWg547Ovr6Yi6smWAtmN19/JEcgAm
 joy559tJ9iUlNEKyBIMVZ8PkoTnaTbuO1nO8sIO2T2Q9V4intwQeqISEFf+Sq8OSIBc/hTjYkKm zO9fjfD6iLAneJwyijnrlGAcCFVKaWaLYJg0XwMr3rPwkm/t2PhbFtjNN/NraM/RrrU12+uXvKR 5KSM+tQVJpTnY6YtTBQnu0TRcv1tw1gUUhXD+/PV9qnehwFuxVdQZ+OVpd1ISKzBgQew6aoIBxh
 2zwPr22CHzRkriow95Ae1sL69kw+LMqyQI6e0KJCHyfIdedulCtNKp/m00wkMGecwIyRrf9H

This patch addresses a scenario observed in production where disk links
go down. After a system reboot, depending on which disk becomes available
first, the IMSM RAID array may either fully assemble or come up with
missing disks.

Below is an example of the production case simulating disk link failures
and subsequent system reboot.

(note: "echo "1" | sudo tee /sys/class/scsi_device/x:x:x:x/device/delete"
is used here to fail/unplug/disconnect disks)

Raid Configuration: IMSM Raid1 with two disks

- When sda is unplugged first, then sdb, and after reboot sdb is
reconnected first followed by sda, the container (/dev/md127) and
subarrays (/dev/md125, /dev/md126) correctly assemble and become active.
- However, when sda is reconnected first, then sdb, the subarrays fail to
fully reconstruct — sda remains missing from the assembled subarrays,
due to stale metadata.

Above behaviors are influenced by udev event handling:

- When a disk disconnects, the rule ACTION=="remove", ENV{ID_PATH}=="?*",
RUN+="/usr/sbin/mdadm -If $devnode --path $env{ID_PATH}" is triggered to
inform mdadm of the removal.
- When a disk reconnects (i.e., ACTION!="remove"), the rule
IMPORT{program}="/usr/sbin/mdadm --incremental --export $devnode
--offroot $env{DEVLINKS}" is triggered to incrementally assemble the
RAID arrays.

During array assembling, the array may not be fully assembled due to
disks with stale metadata.

This patch adds a udev-triggered script that detects this failure
and brings the missing disks back to the array. Basically, it
inspects the RAID configuration in /usr/sbin/mdadm --detail --scan --export,
identifies disks that belong to a container array but are missing from
their corresponding member (sub)arrays, and restores them by performing
a hot remove-and-re-add cycle.

The patch improves resilience by ensuring consistent array reconstruction
regardless of disk detection order. This aligns system behavior with
expected RAID redundancy and reduces risk of unnecessary manual recovery
steps after reboots in degraded hardware environments.

Signed-off-by: Richard Li <tianqi.li@oracle.com>
---
 imsm_rescue.sh              | 148 ++++++++++++++++++++++++++++++++++++
 udev-md-raid-assembly.rules |   3 +
 2 files changed, 151 insertions(+)
 create mode 100644 imsm_rescue.sh

diff --git a/imsm_rescue.sh b/imsm_rescue.sh
new file mode 100644
index 00000000..7dcb0773
--- /dev/null
+++ b/imsm_rescue.sh
@@ -0,0 +1,148 @@
+#!/bin/sh
+# Check IMSM Raid array health and bring up failed/missing disk members
+
+mdadm_output=$(/usr/sbin/mdadm --detail --scan --export)
+export MDADM_INFO="$mdadm_output"
+
+lines=$(echo "$MDADM_INFO" | grep '^MD_')
+
+arrays=()
+array_indexes=()
+index=0
+current=()
+
+# Parse mdadm_output into arrays
+while IFS= read -r line; do
+    if [[ $line == MD_LEVEL=* ]]; then
+        if [[ ${#current[@]} -gt 0 ]]; then
+            arrays[index]="${current[*]}"
+            array_indexes+=($index)
+            current=()
+            index=$((index + 1))
+        fi
+    fi
+    current+=("$line")
+done <<< "$lines"
+
+if [[ ${#current[@]} -gt 0 ]]; then
+    arrays[index]="${current[*]}"
+    array_indexes+=($index)
+fi
+
+# Parse containers and map them to disks
+container_names=()
+container_disks=()
+
+for i in "${array_indexes[@]}"; do
+    IFS=' ' read -r -a props <<< "${arrays[$i]}"
+
+    level=""
+    devname=""
+    disks=""
+
+    for entry in "${props[@]}"; do
+        key="${entry%%=*}"
+        val="${entry#*=}"
+
+        case "$key" in
+            MD_LEVEL) level="$val" ;;
+            MD_DEVNAME) devname="$val" ;;
+            MD_DEVICE_dev*_DEV) disks+=" $val" ;;
+        esac
+    done
+
+    if [[ "$level" == "container" && -n "$devname" ]]; then
+        container_names+=("$devname")
+        container_disks+=("${disks# }")
+    fi
+done
+
+# Check and find missing disks of each container and their subarrays
+containers_with_missing_disks_in_subarray=()
+missing_disks_list=()
+
+for i in "${array_indexes[@]}"; do
+    IFS=' ' read -r -a props <<< "${arrays[$i]}"
+
+    level=""
+    container_path=""
+    devname=""
+    devices=""
+    present=()
+
+    for entry in "${props[@]}"; do
+        key="${entry%%=*}"
+        val="${entry#*=}"
+
+        case "$key" in
+            MD_LEVEL) level="$val" ;;
+            MD_DEVNAME) devname="$val" ;;
+            MD_DEVICES) devices="$val" ;;
+            MD_CONTAINER) container_path="$val" ;;
+            MD_DEVICE_dev*_DEV) present+=("$val") ;;
+        esac
+    done
+
+    if [[ "$level" == "container" || -z "$devices" ]]; then
+        continue
+    fi
+
+    present_count="${#present[@]}"
+    if (( present_count < devices )); then
+        container_name=$(basename "$container_path")
+        # if MD_CONTAINER is empty, then it's a regular raid
+        if [[ -z "$container_name" ]]; then
+            continue
+        fi
+
+        container_real=$(realpath "$container_path")
+
+        if [[ -z "$container_real" ]]; then
+            continue
+        fi
+        
+        # Find disks in container
+        container_idx=-1
+        for j in "${!container_names[@]}"; do
+            if [[ "${container_names[$j]}" == "$container_name" ]]; then
+                container_idx=$j
+                break
+            fi
+        done
+
+        if (( container_idx >= 0 )); then
+            container_disk_line="${container_disks[$container_idx]}"
+            container_missing=()
+
+            for dev in $container_disk_line; do
+                found=false
+                for pd in "${present[@]}"; do
+                    [[ "$pd" == "$dev" ]] && found=true && break
+                done
+                $found || container_missing+=("$dev")
+            done
+
+            if (( ${#container_missing[@]} > 0 )); then
+                containers_with_missing_disks_in_subarray+=("$container_real")
+                missing_disks_list+=("${container_missing[*]}")
+            fi
+        fi
+    fi
+done
+
+# Perform a hot remove-and-re-add cycle to bring missing disks back
+for idx in "${!containers_with_missing_disks_in_subarray[@]}"; do
+    container="${containers_with_missing_disks_in_subarray[$idx]}"
+    missing_disks="${missing_disks_list[$idx]}"
+
+    for dev in $missing_disks; do
+        id_path=$(udevadm info --query=property --name="$dev" | grep '^ID_PATH=' | cut -d= -f2)
+
+        if [[ -z "$id_path" ]]; then
+            continue
+        fi
+
+        /usr/sbin/mdadm -If "$dev" --path "$id_path"
+        /usr/sbin/mdadm --add --run --export "$container" "$dev"
+    done
+done
diff --git a/udev-md-raid-assembly.rules b/udev-md-raid-assembly.rules
index 4cd2c6f4..fc210437 100644
--- a/udev-md-raid-assembly.rules
+++ b/udev-md-raid-assembly.rules
@@ -41,6 +41,9 @@ ACTION=="change", KERNEL!="dm-*|md*", GOTO="md_inc_end"
 ACTION!="remove", IMPORT{program}="BINDIR/mdadm --incremental --export $devnode --offroot $env{DEVLINKS}"
 ACTION!="remove", ENV{MD_STARTED}=="*unsafe*", ENV{MD_FOREIGN}=="no", ENV{SYSTEMD_WANTS}+="mdadm-last-resort@$env{MD_DEVICE}.timer"
 
+# do a health check and try to bring up missing disk members
+ACTION=="add", RUN+="./imsm_rescue.sh"
+
 ACTION=="remove", ENV{ID_PATH}=="?*", RUN+="BINDIR/mdadm -If $devnode --path $env{ID_PATH}"
 ACTION=="remove", ENV{ID_PATH}!="?*", RUN+="BINDIR/mdadm -If $devnode"
 
-- 
2.43.5

