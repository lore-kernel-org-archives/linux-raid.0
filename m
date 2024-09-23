Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD4026AC3;
	Mon, 23 Sep 2024 10:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727087637; cv=fail; b=QObQHWDOfH5xmy2H8A9uoyJMmODEzbvK+aY/czsj3G5W2HTqEfYlLa/fJh5lhN7YGCBA1QHZrubOCKd+0LQmZuE2MDhs4lCataDTIXIoO4QYlApA8Lj0nm85pnKWtY32b0I8dlT5W368rLADYznBOBhl7xK+iZLTsGyPBVU1oCE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727087637; c=relaxed/simple;
	bh=dyL+mh/PWt/fTKECGfhnuql5pUB7sTeLx8IZo+bxPOQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JBL/TJTigNZ8Y8cbZZyAr1bBjrhywnfyuftX1vcuoRtkQRFYvz7ofDau03OZNjeku/Oyc3Zy8MHKdL7pNaVcswDYRqr3nHBKPna2BMHYR2NtbPG7N/zEjtWkZylrX26wUpVgHbvp4nV9oKKoWgnrZwsYasCeDzhMkF6yC4W03fc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PJPc49uV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EdN1FVQ8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PJPc49uV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EdN1FVQ8"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48NABkwN010226;
	Mon, 23 Sep 2024 10:33:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=IKnWQyVLc0cW34jFAazehrZ/WosY0Lyvjh4ONe6rdys=; b=
	PJPc49uVXbXuy9UdO4xds8JjtcCL7B984e5iIE6rtBYjgSZJtH5jm1JtAraHnqQe
	AFaj1pqkR6LjUsijgmDgfMYcoscOP+XM6ctkLjF4Wn8k5G+TJx6fHEblvouXMtwO
	8FFXsHZpaHo7SVl05Q/eJF/HVS+tR45e7KSf/lX6WQD8RC3JPyEUiiRAFMsT+B3l
	mbOHiJ9wVrvVPJ1uSOfuK8Yvf5ax7tyObDjH5TlFte19YEz0J+QD1rph6JIjnjet
	p/PebbT2MwzNDcdOZLGTDFVHHJXg3m7KmzFRShQutQ/GNDWMdBB0wJWZwfjqHE9M
	E/zScqmoSNh3EDkhozwpqQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41smjd1van-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Sep 2024 10:33:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48N9dYJw024220;
	Mon, 23 Sep 2024 10:33:49 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41smk7ktts-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Sep 2024 10:33:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rvNhBR0l22jhXSr1P8uPZzX2H5QPeK6OWS6w/khYQ90DXrl68x8TPjomHMJkkAha3f4b5CGnQhJA/mG5B0PCtK57x9Rp6UyA+f6RsInZrPZO7TjGWd6xM/nJ/3doCPwsWH0QHqxIO2IzjMDNciRYPKEr4P5rROQWmoCKP6UZjvRiqxAXOC3ay+S+fuMUeyPj+tIiiXGl0j9z5WyqGRhBNAudCPXGLZYU34wQn10f418yqOzoV0CanfN205/2R0Lxa5WsFaPWelC8q9zZPsUJS0pxuUwDQJH5ESA5GPnLuZ44WP2MO+An8O7DW3OQcNg58sbN/4PlmzNIn5nRQ4udZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IKnWQyVLc0cW34jFAazehrZ/WosY0Lyvjh4ONe6rdys=;
 b=mZ0+mhkwPDuaf0xpDiOtM2+oVlUHqml1p9xA7r9rskrCLsXWeGByyUhMsxDw7AfXH0SnLuxwIrrtZZdb7P+QC4oT47QRfK6x6wQbfJudCrHoJQ2qChf2gLcBh/aVZzWNRCH2dI5czUfqrCC3FPVhxLaO61MufKnkX38Bwdlrgso816DJgMJMqwUz5fE9S2wo4SOBMtJLwkDQwbXNAikokyOmLE74BuTbtHWzDQv8oC3x6fMO/F1cMcEAa9cgmzCvNXU+VY+NzG1CedrQuhgfQhpEu12NUGkpeKUCm25iRADISw65tU+mMQx83DkdQJ+u6xFUVDc44unB6iFKlRpStQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IKnWQyVLc0cW34jFAazehrZ/WosY0Lyvjh4ONe6rdys=;
 b=EdN1FVQ8fymLpvBN/x02noGfCIlOVTT/8SShkWp7Yxz/QcPyXC7q6vm/b+dUF5kEzHrxC+lxjc6HGecGyugwFKxR6CiucaGjlhS3I7yTKrqcp45OaruBr0gNqIZNj+Gv+PEOfijh8j7eP745XQMoHSquBGIMjj3QT8mn2CEJQis=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ2PR10MB6961.namprd10.prod.outlook.com (2603:10b6:a03:4d1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.10; Mon, 23 Sep
 2024 10:33:44 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.8005.010; Mon, 23 Sep 2024
 10:33:44 +0000
Message-ID: <e80d8dc3-97df-4dc1-b93f-a5add503b3bf@oracle.com>
Date: Mon, 23 Sep 2024 11:33:41 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 3/6] block: Handle bio_split() errors in
 bio_submit_split()
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com
References: <20240919092302.3094725-1-john.g.garry@oracle.com>
 <20240919092302.3094725-4-john.g.garry@oracle.com>
 <20240920140951.GB2517@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240920140951.GB2517@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P192CA0004.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ2PR10MB6961:EE_
X-MS-Office365-Filtering-Correlation-Id: 53ed98a3-1196-4e14-ff2b-08dcdbbb331d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bjdoZjIyc1JFeU5NeWlERlcwQmJObmg2RWlSVmJJZDFDdm5YNGpkVlV3ZEl3?=
 =?utf-8?B?Q3Yzbi84ckNsbmxFVk94YVVvRWVYbDhXQUpoUDJ0S0hsWFkwZDZOa3FQb29I?=
 =?utf-8?B?NmdJalEzTHl2TEdkYXpHelVxL3htL1BQenc2R00vaUdDOUZGWXJvTzI4NWRZ?=
 =?utf-8?B?SXY3R3RIS1RicHVSeDNOeTdEU3VmV1BzaWw4MGhGRzNwdEFkVk1pWWlHNzRC?=
 =?utf-8?B?dUEzSGFZOElUeWZoY3FYQitoT0dxZWVCaUx0TjJYRUx4ZlVkalRTVkZySWE0?=
 =?utf-8?B?UTAxeCs3Vmx3TytiNUJ2cnE1TU1tWWplZDd4RVlUb3dFdm5QUm40VWdrVXVS?=
 =?utf-8?B?NDZLSHBLZUJyckc3L2JyVExKNGxSZy9IMG9jVnF6aHU5TEc2L2d3RmFRcVJQ?=
 =?utf-8?B?RVNvZGFsOFl6RVAzMERTM2FXc1pwMkRsOTNMdlp1SnpZdjVQMFpOU2pCNnFB?=
 =?utf-8?B?NTlud295SWZRRzNqalFnOEdLelhycDFac3d2aU5WWngvV1oyNWE0TGladUlP?=
 =?utf-8?B?TUpYRmhDaDJPNFR2Nm5YcFl3TUZRSm5LdzMzcG44VUxIZjFob01KOEpyRXVS?=
 =?utf-8?B?cklyM0RudndpR0JTVnh2czJLd0ZOUkRJOEFEL2pQNUQ5SFBuUmRhSDJsTlJl?=
 =?utf-8?B?cXFvS3ZPUDYrR3k0cFptWGMrTml2SlRGVE5sVUpaaElTRUFXelBYRnRTakh5?=
 =?utf-8?B?b3IrelpPcENzUEtIbVpDZEpZTHJ4YVNsR1NzRm81Q1ZyNWVpMUVkTHQ1ZG9E?=
 =?utf-8?B?NllYT2FTTUN3ajhXVzg1YUxhSkJMeFNzTnhxdnhQS2pvWGFvWnZyVmUrUUpw?=
 =?utf-8?B?ZTBnT1BTcEpySHhNU2hCQWR2RldGc3NLdlJNc1hRc2twczloNDdDRUxpVlJK?=
 =?utf-8?B?TG5UWnQySCtvM29haGJUT1EwOUxSa09qQ3JaWUwwWHh0aG80VkY3aitpOEQ2?=
 =?utf-8?B?b2JZTkVNL1FMVGdvUTRHdUZ4Q2ZBeGVUN1BCZEdPWlVoUTE5a0FtZ0xXbXJL?=
 =?utf-8?B?dVZXUXhxWVhNaWpPdHUvbis2T2t6M09TVnNZQWJjcVdPeWtFcGlZMFJudUpG?=
 =?utf-8?B?VEVQMi9GY2NIRkIxSnNabWVBMjA4djVzeHd0SEV3UTZNaVIvRzQvbEhFVEhK?=
 =?utf-8?B?YVRaQUxWOU9pZythRUNuMXJhVko1emFoNUNaeTE0WVN3TUpWOWUwWWxTYXZL?=
 =?utf-8?B?UU11ZWlmTjhrenZIZFJpSHkyZUNBSUg5VDRMc2dFN0RrdHlkay9iVStEc1Iy?=
 =?utf-8?B?NlFPc2FLTVFFeVZOZm9mdUpTZ1JHYjEvNmhMTUtEdk1nc0NtY2pzUGFmeUZ2?=
 =?utf-8?B?allITEtjTWZla3JkMTF2ZFI2L2o3N0UwaWlsVmtzN1VSZEdnUVkzSGJuanl5?=
 =?utf-8?B?bTlXNmluQ1kySDFqam9aSVhjZzZoVWpKSVExMkIvSnFJd0ZTWC9rTCszNExJ?=
 =?utf-8?B?aERVc1JWNUFGYXBnam1GWmF5MCtsSlZtSlRnSHczaEExeEZGemFubDhjL1Fp?=
 =?utf-8?B?bWJ6L1NMZllIR29jaklaQVlJK2xFQk10bmJleUJPU3BSc0Q4alYwYmFhUUd1?=
 =?utf-8?B?bTMvK1J5ZzFCM0lpbktUUWJlL0R1aDBzY1lDNU8zVk9DMll6QjVCWTZjeEF6?=
 =?utf-8?B?OTBpdmFjNDI5THlsUGpkZy81bXVoOEZxT245SVdmUnZhTkZyVktmSW9Nem5Z?=
 =?utf-8?B?WFY1Y0lZYmZycktONndQS0VQQ3RIZnp1NUlRbkpmU084NmY2dTk3ZjRBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OVZZTnk3Qkx2ZUpRVjJIckZQcE9WMGlDdjZDaWZ5eFRLS0RrREZOQ2Zxalhr?=
 =?utf-8?B?YytFUG53d0dQWVFlbWhNTzZPMW9KVjljVEFmbUtqU2ludlNvaisvTGMxVGhZ?=
 =?utf-8?B?MUZqUytqcG9yZlpJQnZCUG9iaXZtTmxjNURGSkFBekdSZmNsTHJhaXE0RTYy?=
 =?utf-8?B?VXp5Yi9SN1JRWmwxS2RZUUFscXU4Tmh5ckpWSlZzWUJoQ0c0cXlIcHUwMG5C?=
 =?utf-8?B?V2NjY1ZwY3FId1lJTjB4cTFHRkEyRHRKRHc2dDVPd0NJZit0dS9zZ3JmTnJV?=
 =?utf-8?B?cTJMQUY1Mm4rNXR3YTB6WnlyMkxucWtMZEhhblhYL2lxUDB0ZXpkTVdlRG9w?=
 =?utf-8?B?SzdPY08zR0dFQ01kT0FjUUI3Tlo2Y2xTOGlLVU1DeWJNb3dBZ2ZOenEybWdl?=
 =?utf-8?B?TDBNMjduRmp1b3RYMmpkZ29nSHhFSXFXMk5tcm5MNWlQdktoNFdEbDVya21s?=
 =?utf-8?B?Rjk1WVVhUnVYd09ZV3RBV1puWXZKMXpPQkpsS3V0OTR5Qi82b3RVZ0VGZVlE?=
 =?utf-8?B?OFNOZmc4OFJ3THIvZ0ozYndULzZMbTBpaUZIRjdjN2kzaGVLZkVjQS9DbkJo?=
 =?utf-8?B?bjlCQlMrdFl5UkJiMHYyTWNuTzNNbjdhS2pXaTV6Nk8yNGwrZkZkZkorUzhJ?=
 =?utf-8?B?TWYvS1MycUlma2p2Y1BYL1QwNFE3VzJRTFNOR1RYelR4ZzRwa2wzbmpqOTI4?=
 =?utf-8?B?emFRL2NUSDhnM2VSVlNLY3J1VHd1L3BqT0FkbjIyUVg5cHdFN0d4ekhCK2Q1?=
 =?utf-8?B?bVhjK2dtMTZyNktkYmd5d0RubFJvUkw4c0dNLzhzUDZkV05MVUtrZGZOdTFn?=
 =?utf-8?B?dnZoV0lCM3RETFIyMlhieUJHcHU3bE5CN08vNi9EZG5HNEtWVUZDSlVzVk8r?=
 =?utf-8?B?QmVoeGV2NnB4R3JRNUdFS1NDTjhmUlZsSnp0b1owWXZOVDhnS0NudVpDVUJv?=
 =?utf-8?B?N0VzZWpiMHZaWE51L3lySUxqalg1bG00SmQzdlFZN0tUa3FUd1cyb2tnaVlw?=
 =?utf-8?B?emtlRVlpOWpzN3BNeFBHZHZkMjB3UTdVZkhGRVNMMDNYdmdUUmxacnVraTh5?=
 =?utf-8?B?cGV4b21GR2NpZ3dKTVRRZ2dLY01ibmhYZk5TWndYeFFRVThRaGJkeVpHbmU5?=
 =?utf-8?B?ZEduSXNhUlkxZUpkK25BdHMxNlM0NXdKRDNRVnlsUHAzbTJ3bGVHNDkySXVt?=
 =?utf-8?B?Vm9UbE96Kzk0S2NXSXU5SkY5S1hLdy9kSVJxQnBONlc3WkVPRVVvYmg5MjJ3?=
 =?utf-8?B?elFjZWFCWFI5eldRVjR1NHJBdlhmOENlbmFzSUlnQmJEaE5ZYzhRL0g4S0F0?=
 =?utf-8?B?c1R1Yk5Ob2JqRVZaMkkyRHg3dkJOdCtjM095VVR6djJ6aHgwSzYrMU5SSXdM?=
 =?utf-8?B?M2pZUUlMVU5KNExOY0V0K0JRTDdhaHcwQldyQWNnSmtkZFdmYXl4enlHK0FF?=
 =?utf-8?B?amJIVWV6YXd6WEJJUjl6Zkd0d1hPbHdib1VFZHkydk55S2hHVnY2RFVySmd6?=
 =?utf-8?B?RVF3UjFKSk16QkRTaVZteTFEbk5hT3RFZXI3bW93OGgrbHIxbVdSWHc5Sm5W?=
 =?utf-8?B?dWpOSVdzVDFRZ0VTZ2JTWUxxN3RFcll1N2pLQnJ5SFY0NnFLN3Yvdi9QblFm?=
 =?utf-8?B?MGZXNGVTUmxUajc4UytpbVZWZUQ3SXN1ZGJ0Z3FKVnFpNzJKYXZtVXpqSjJ2?=
 =?utf-8?B?L1hSeGlzdkNGNVluRGp0YjdNZTJvdGkvSzNLYyt5QkxUYmU3bmFZdlBldU5a?=
 =?utf-8?B?KzlQTStWVTRFL3k1aUhwQXpCd2RLQmdKNzJhcGRvdzBhZHpVWExGVDFDMVl4?=
 =?utf-8?B?QWtyanFrdllTbW9RcFFuRUp3T1k4eCthK00ycGhLMzdEVXgxM3Qxc3h0QkpM?=
 =?utf-8?B?clllaHRzbUp4dHVUazNXSFlXZ3JKbVpVblc0aHp1UjZzOU1RTXp0V0pWbCtM?=
 =?utf-8?B?bDdkc1Q4U0RRdVRrUkxqR0FIM1gzMUZBcnZBVzlzR2VyQW9ONHExQ1krTHAw?=
 =?utf-8?B?VHRIbUxTRi9NRmtybjVIejJjRWxGSC9yK0ZsNVlweE16VkVpcEZ0TTNiajRt?=
 =?utf-8?B?WHhqdWlsQ3FjaWd4NjhOVWdrNGhCWEpEVmxPTU5zS0VRWDlkQWh4MExjZ0pH?=
 =?utf-8?Q?LUrbGfSOO0KYjwsD+tyAzJ3hV?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nTgHNyC7f5Lxoa2fFgbSKwWWF9Hmnt/JyPGAqBc05ksN/Kkyvb6f4w8UCTE5E7GdAaAA0/9l0nGmCdKNPR4ECViTdU3COrDN7w+gcsUWkmfdHrf2luyYcVYhbd7jLrrR5aljnV6zKMM6KCEOUDSXxzcf1L9P8Huk+ee/GV428Z2F2hfC9xZ+ealEpnTZz5QVgnQjI6odJgKHOlshm9JhgXhrtR0IRvkGM4KJRhxxUy8DZ8o+QpzK3wqm95uKGgWOiGVVwDtyjFOLNZeOBhKLh55u2HsqsYf8XN+JQta2TEZT322/2cGn/dfuAbjPTfyM1NCOFRk//0FikaqGT4dtSlZfmQ6cMncTI07EGmD12RTL7XMRsjTD8nYDS0JbIg/6Q6z7jtosN7K4LRDHAxwxPhPsJBVyhq14x9Auk58xmvC5rHwazMVpjKsjzxQdK90YLPbQR2VkRUDmYvIJ3Z3eJaTbzoDZO2T+qHZdNgWEGgqgmvkIN/2DJlR/sANNB6avWUbQX50/V7zIc5QCdouZ6gsMrr3XoggrTamU9YJmhDjap9WfO1m4Pmdr6oTbZXiFmTKoDhf8noxLyVIJilwO0kUM7vi+4MqPsuUq9XZ343Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53ed98a3-1196-4e14-ff2b-08dcdbbb331d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2024 10:33:44.4807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l84U2ea0Iaf0bA8BqiBmNVOYqndgSI0MJp6HughOIO3LD5YEs5AFV7N7fJLPxJmMzj2Vkubu5ZdQi+4bQacIGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB6961
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-23_05,2024-09-19_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409230078
X-Proofpoint-ORIG-GUID: cLHsUYLpzBx_jvpBDYR_QBMKEjLocgvE
X-Proofpoint-GUID: cLHsUYLpzBx_jvpBDYR_QBMKEjLocgvE

On 20/09/2024 15:09, Christoph Hellwig wrote:
> On Thu, Sep 19, 2024 at 09:22:59AM +0000, John Garry wrote:
>> +		if (IS_ERR(split)) {
>> +			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
>> +			bio_endio(bio);
>> +			return NULL;
>> +		}
> This could use a goto to have a single path that ends the bio and
> return NULL instead of duplicating the logic.

Sure, ok.

I was also considering adding a helper for these cases, similar to 
bio_io_error(), which accepts a bio and an int errorno or blk_status_t 
type, like:

void bio_end_error(struct bio* bio, int errno)
{
	bio->bi_status = errno_to_blk_status(errno);
	bio_endio(bio);
}

I didn't bother though. Sometimes we already have the blk_status_t 
value, which made this a half-useful API.
