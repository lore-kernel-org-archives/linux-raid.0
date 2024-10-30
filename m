Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0511EBFFD;
	Wed, 30 Oct 2024 14:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730297343; cv=fail; b=Ty5KwXCBahPHiJiv3CPiwt7vaatOpE5e7tzlotg91mWbE/OCUE21CWdp+dnUK9DZzaLYMiL4+IFD4tAGf2cIHaGoMxABqBv5VgET/V6K7gOgkil7n3i8Q53hxtV7Dgf93u2Swmz3KlOcvKfT3Q/89bUTLouwIJxMJbaAVVhiZh4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730297343; c=relaxed/simple;
	bh=GIN92EyB4CtdzoPODS3+oYgyDrf28O+bwi02l4BnAcQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YBn9kmqicR3kt36WkXVwpXw7rux9QsqZ7cSOBYjmxCg1Ht/KsKKxUIkjQ91QQzQ3RdFh9jHwrqy22W/qgLw0AeSZ1kR14rcIuG5yxV6jLy4hfpPBuU/slqttamzCFjk3AQNS9/688t9VC1f+t6d5XjrVrEEcR/9G1hBMqHejDgs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AIHkGzsL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lghd0ocS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AIHkGzsL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lghd0ocS"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49UCi6xp008940;
	Wed, 30 Oct 2024 14:03:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=e6evJDlpFxeMT41U39oTm/K1U3VZ1vHkLE4+ksNyW3o=; b=
	AIHkGzsLsstFLaWD7W2Xagnvnag6PwTkPTTna4iqc0fP9/W6sCTUMRzerEJUjwzc
	TjQfrBj8KYqNIWIt73aDzx9IUgFGdcS/SWfoebEKP/Gb2mnNfnKC2ieTPsxQEkoI
	jPlRcHmjk3s6LFa5940yaXhbGYuihO+EGfRz7V+8qFjJ5lCN+VAIYkJcURm9+ZOQ
	HVCG/oopDHS6oRQAVHRbROTRE+kBmYvJ+QOGcczHzNHJ1Svzv4VZpNnWvUUP1hlV
	eCvybJ0w4m9GmiLc9Dq00DhocqPOLAC+08UcvoNHskGt/1/qXjrz+s9TeCqKeRIk
	59yw+sWMTjRf02WSJt4Bog==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grdxr2kq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 14:03:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49UChmNq011848;
	Wed, 30 Oct 2024 14:03:38 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2045.outbound.protection.outlook.com [104.47.55.45])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42hnae2gyj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 14:03:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C/MX2Zg1DcutoIiqXUBQSlofhyGQikpthIT87hglDuNCt1c3CRso3SnrnLdZsuA3fiNb8k1FgwRl4GGlqBBr8ZTiJrnELYDQ6Gv8ytg+7eB16syLiq+DN3Y6uhuQLnENgeteuiHL2r2o3jPC7y9nqwLioDESDTCc3kIoYJT52e8zTC0oAq6THhTEftMnQQ+sgYrA8OnrtZ8QvITyZYH9b3a1NvJBhGmJEPODq+9aT4Rcjkyo9h/M5kokFv2FpfndTPkGyLb+cJ7wtMqyHdQ7pGiCA4yZJqZwchKRZn/oJDm802z2wB1XxPJMTG7nkq/xmtpPwoSanzSxbafgNwHXxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e6evJDlpFxeMT41U39oTm/K1U3VZ1vHkLE4+ksNyW3o=;
 b=Zibr0YWDxEDaTPeyc4bkpSydSCJUBMaMscw5Tr/e1Zf31BZDNALFA1v9E4irzbYAbr+6VwrjqMS9y34xUJX6ebcgZfHeabL+fsKOA7hprqUd5gjS4phcyk9BWlW4h3Vsn/w0vGJ9j/PwuQ6cxTeKPML/jTc/X8C//NSCiQ9PZWl3bKKqmKkwgDWA1+pKg68AETGpR3ADB7dc9abzoLfGsT51quYgR0jUV3EOy+E6Jwe6eX24Bty74n1VippnBu+BunvLyJLo8IWfxwSvYAXYjT5i6myti4BkcG/fmIpxz3J9A4H8Drj/RXabpuYeobWUKyEqL/tBG+GtGE7CAd9/Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e6evJDlpFxeMT41U39oTm/K1U3VZ1vHkLE4+ksNyW3o=;
 b=lghd0ocSeb1Lf4qnukxwr8RFHIU2jMhm1f2iBxHWmFzxxYUuhMzj1leUc808xGrjqmq7Jr5oSXhxPSCWXhQTBe+jA58ZebCreeitg0shWAUxohOzNqzm28gudNHH5aflT79VprjR+pGd7LkVojGEgcKGHP+7lZXN4H1MsjU+VE0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB8078.namprd10.prod.outlook.com (2603:10b6:8:1fd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.20; Wed, 30 Oct
 2024 14:03:08 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.027; Wed, 30 Oct 2024
 14:03:07 +0000
Message-ID: <28fb29cc-1c1b-4b26-a859-c29b6cfa337e@oracle.com>
Date: Wed, 30 Oct 2024 14:03:03 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] block: Support atomic writes limits for stacked
 devices
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com
References: <20241030094912.3960234-1-john.g.garry@oracle.com>
 <20241030094912.3960234-3-john.g.garry@oracle.com>
 <20241030135006.GC27762@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20241030135006.GC27762@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PAZP264CA0093.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fb::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB8078:EE_
X-MS-Office365-Filtering-Correlation-Id: dba8e554-ad4d-400c-13c2-08dcf8eb94bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bVAxaXYrd01VK0FjWTJIMjYyTWNUNlNvNFQvQ1YvNUtHWGQ1MzREWk5YQ1Uz?=
 =?utf-8?B?T1NPYTNUdkpKTGpzb3RjTUYwZzNrckwvN0MxbGRlZ0NkMkVYU2k2SnY1OVdm?=
 =?utf-8?B?QkJHRWFWUE5QUkxhbHcwdUlNbnNybm4vNy9ZOStDTjhCZlJLZ2dzNE82MmEy?=
 =?utf-8?B?TkZjejBqK0JHODI0cWt4dlpEaitRL283YXcvU0hySkpOTmEvRDhEUVpZNFd4?=
 =?utf-8?B?T012Q09CY1lvRDh0eGZkNlkyR3RySmsrRFJrSDZOVzhvM3BWVmhlUFYwaWpO?=
 =?utf-8?B?QkkvRG9JNTR1UnhaQUlFYkJPYlkzOVVlZTRvK3Z5L1RjenJZR2tWVmhBQ0JC?=
 =?utf-8?B?Ni85K3FFcGZFeUpqblpUekR0djlDWEhlVDRiVHdET29TTjJraEpMQVVoUDl2?=
 =?utf-8?B?RlZSK3hKbXBoM0lyZ3FTQk1hTjFFSE9zNDVNbHFhYUpyZkx1bUtTdmx5ek5D?=
 =?utf-8?B?bm44d2dpRDZGZnZiUlduVEtIdlhvY3ZmRzFIeGtLTVBqM2xreDU2RVpRdFZa?=
 =?utf-8?B?a2RuaHpoTTRlcVh1S0JIRkZReGZCYjdWM1JzeFJDaDl6Rm9WeXNGN2pDMlNx?=
 =?utf-8?B?WE9uc3lIK3ZZS2Z2MVlUanh4dlJIcE05eFd1aFVna2FkdldzSWNBQzAreU1O?=
 =?utf-8?B?TnIrd084dEw1TWZxUTY2UWZhSU9qY3ppWGZDN3p3MEg5a3V3eWQ5ODBsR2Fi?=
 =?utf-8?B?MHBuT2c2cXNjaVBTN25TREtXekdMMXJRYlllL2VmNzVTTG9TR3FhVkpDaCtn?=
 =?utf-8?B?R2xaZDFCS2xHTFlXYTlGcnVxV3dtM25INmV2M3ZQN29raEVFcWVBdEVMT0xr?=
 =?utf-8?B?dHpBZ3c4b2Y0MzF4aVBrQVpCL05scEh5dlp4dkdOeGpxaExUU1NMaXdtdjBF?=
 =?utf-8?B?M2pES3JSdG5qYzVEKzMxbnJTaGUyR2U0NzBQTGM4U1N2NXNFK3A3TTN1YWpK?=
 =?utf-8?B?QzBYa1JDZFd1QU1SZ1k0UG0wclgwV21NbHE3MmpDQVl0SU12UTRPSHJRelRF?=
 =?utf-8?B?RGdzWkxkbVFLckpBc0tYQkRxZWQ1R1lHTFYzcHRFSHlKcGo5eGQ4MnRmUUFr?=
 =?utf-8?B?YVpBRDY0ODFBa1U2ZFhwdDBObkFHUzZwZ25nbzlncXVVQ2dvWWdUVUVFbHBM?=
 =?utf-8?B?ZjNrdTRsMFVuUGxuRWlYY2c1VVFwVU1Tc0pvYXZxcmcrZGo2N3NUQWVMYllC?=
 =?utf-8?B?OXJaeGNWTmxkcU5FZTNmQ2VoVkJ2YnNUczY1blpKajdJMzE2MWhiN2taUmRH?=
 =?utf-8?B?NUxjU1FLb3ZWSW5JREtEU1NYbmpZMGRWL3IwTnpNY0Y1dW5NdWFpN0drNmdV?=
 =?utf-8?B?a05PVmY4VVQ4L2ZZRi9hM0Q4RHJwTkZtakRyU3FaaVpKNk5aSUpjcmUySVVz?=
 =?utf-8?B?VEFyKzBRWnZDcU9NZjE1WWdJWHRDYlhFRDZhNGxudUxBQnB4b3hsU0Y1eFRi?=
 =?utf-8?B?Vk1tSmxGT1BRK0JIM25nNUJQQ293LzBiMFE5NllBYmNXakl3bUdTOTVHdUo3?=
 =?utf-8?B?TThFOVMwcDlTMnFwWUZSN0lqUDVidHpUbDdkK2F0dHAxTXJIOE5VTmdQbEd0?=
 =?utf-8?B?OWQrZ3I1UU15OWk0MmtuTm8xQUJCcnlpZm9WeU5xYnRmaUFwdG92TlJtNlZS?=
 =?utf-8?B?OWxnbEQvZkFPZFFaaHpHbllzRVBIWStWU2laVjEwVlErOGxVRjdsOTBON3dk?=
 =?utf-8?B?QXJKRVFIVnJKMjA0c2l2L09nMGVwYjRjQUJpcVpCNWczSVVmcWxSVkxKSTlq?=
 =?utf-8?Q?kMudEkW0JQISMaDkl74ilJy4ZyMUin5azdMFD8O?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WGJ6blFIVnlPTzdXMHNNNEFtVDlncldyLzBUTk44am4xOE5ZUXFhMjNtRUcw?=
 =?utf-8?B?NE1lcVNDczFvWWdXZjJ6TUJma2dXOWRWZnY2S29NUkJoUjJ5WjhaRmxhcGhJ?=
 =?utf-8?B?bUl3RnNJTmJQdjRNWkp6eXdtbEZUei9pY3RURzF0S1p4YUtoellFUm5SWWZV?=
 =?utf-8?B?TWQ5SXQvb2dNL0dnSW5VQzhKRVFqMUViakFLa2xEcmtReHlDVEFMNGtFVXRE?=
 =?utf-8?B?c25abEU1WlE5M2o3dGJuWjBUTXptWmcxeFExanNZMHpMd1puMjFvVHVad0ps?=
 =?utf-8?B?eVkycEtycTlycmNlZWcxL2xOUm5LbitZUVYvZG1LOWdlSExYNVR0MG9xMW9Y?=
 =?utf-8?B?bHpLNzA2d0oyNVdNT1QydzJyVVBwbHZZQTVDdVBrLzdyaXpzUzZyamcrVTha?=
 =?utf-8?B?NHZyMWYrSUtYUFI5OTRBd2EwL2lPM1hjQkg1bW1rMmJTZGFHVUdVN01FODU0?=
 =?utf-8?B?eEkxU2cxU2dRWlFXLzFEUDF5MnI3ZFVXYW9VOFhva0ZmMUh1dy9rQTRmR29H?=
 =?utf-8?B?Rmw4ZHJEenJaaGg1ZXdiUnZBZDVNRS9qcTB6NzBtWUlReEpWN0hKSHlxczA4?=
 =?utf-8?B?NWtHUmZUeVRvTmlvT0RwRitLSFp0NmlWdFQvbWhJOTRPbDMrZFhaT25YZktl?=
 =?utf-8?B?WkFrcGp6ZUhWMFFCd0gzNnUxVGNDVUVuc3hqMjhRQlBKNmx1NDZvY3MwQXdF?=
 =?utf-8?B?WDVqUnJxaS9mWG9iOWY5Wm44ajR0a2xrR0VnWjlzTks4bGdsWkRKYVQ5Ykow?=
 =?utf-8?B?ZGVKU2NNcjY5a0xaWklSK2dvRDJtK1V1WjVXbkZTemp2WldpMi91dnVYMkp5?=
 =?utf-8?B?MTNtaFJIa1U5alZ3R2V2YXhyQmliRll2N0l6eFM4bmc5SElhdmtJT2hLc1lI?=
 =?utf-8?B?VVZCbGhmTnhFcDBYN1BUVkFTakxlR2U3RVQ4bWtHYTJqUXk5aFJGa3pwWDlT?=
 =?utf-8?B?NE9iQmJQZGpleFNOaVVVRUlvbHo2NW95SkFPLzJzalNKVEM3MFl2SW5qMHR6?=
 =?utf-8?B?NU1HaDFJaWZDRDVKTjdTRHkwT0QzcVlob1hXRXltczNVTU1mQUVpUmN4ZG1q?=
 =?utf-8?B?cGtTbXhCd0JtYklvYnJTaFpwL3BkZnBLaURyelE2citRczd6TlUzeTUzU3o0?=
 =?utf-8?B?NzJiNFpwYzMza2dWRGhXa3dwYmprZUpxcm5Zc2tuTmU3cW1iVG5YbHBzWWhP?=
 =?utf-8?B?cmVlSzJvZEhyQkR1bSt2MHFhdFVyc0EwNGhyYjJLeTFrMjM5YVdvMm94VERm?=
 =?utf-8?B?dmE3eXpTYnBPeE9LejIxaEVoQVNyTkxvU2RXY0h6SkVEMEt5dnQwUFVJZFNO?=
 =?utf-8?B?alEzNjNRZ20zMVBzeHdkeWxrVk1LVDlySTFxNjVLS0k2Vm9JOWNyditjVzY0?=
 =?utf-8?B?Y011NE1YQzl4NHN0Rkw4QTczRStYUzNIRFlsWnU1aG5YSUNjRG1RODR0dFcz?=
 =?utf-8?B?NitpVFBtWjFSWUlqOW8xaEhDWkhnd21BTW9iQlBucGg1WkFLYXdJSGpoTGRJ?=
 =?utf-8?B?bDlwbzNJeXJqbXZLM1E0STN0a1hpbFJCcm5lR1pKVm51bFhWeWRXY0RrZjlJ?=
 =?utf-8?B?VXprRXEramxmejRnZVV2T3M4MDNYbXc2RVJ4cnVaa0t1TU95UU5TQzlMbU1Z?=
 =?utf-8?B?WmRlYjl5WUlodUdreCsxeTltN2dZZzYyN3c3czgyU1RrWVhzRGlNeFBDUXkr?=
 =?utf-8?B?TC9RYWpGdmxDaThOTkpRNHAwQ0JvVWhMN1NzNnQ2aFVEeWVzMmN5Tm0rS1BZ?=
 =?utf-8?B?ZzB6dmZWaHJ0VkpSeGtXMDl0R0x2b0FaeThrSUE5Z3ZQSXNURFlPOVM3cTdN?=
 =?utf-8?B?WndHRzgzRVRmY0hnWS9nQ00vdDE3bmlRK1M5N3phWCtucjhhcmxUdVZrcjk4?=
 =?utf-8?B?ODFNREVZazA4eUN0S1Jack9ZbnpIRmdwZzNEMk4xWkJNYUlJTHpVMlY3bjFt?=
 =?utf-8?B?enpuK3JVeWdsaE5iNTNFeEVrSzdFejVVUy9FZTZVZlp4RTFpSmtsSytYWSt4?=
 =?utf-8?B?VEZBek5lUXFhQUJNVlo2YjRNV0tqei93VkxWREVTWE1Jd0t4VWVIU1VPREg0?=
 =?utf-8?B?Q1dhSDl6Q2tkV01kM1JvTkdnLzBkSnhuUlBId0JhaU1RNkhZTWFzSVhLVHly?=
 =?utf-8?B?TWpldHZkWXlSVnRkcytyaHAvQTFSbC93ZndBZTVVNkI1NFgzendCUVlsclR5?=
 =?utf-8?B?R1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Kjvhj9rArXWyMiS11I5qck4WMHEkSB6WY63Y4dJ1Gx8ZhkNHYKV+VOIBnqxlAafSwY8B2n0d46RIIBr9Oue1FvQQOwXzpZfNsNJibED7ElYQMiW4sGDgqLx7Xzsmfpd3Kkohk890gRsdhkk0hoMtzVS9AiHJp+50DLouS5x68P8Uo7xO4HJxRw795AjPJpz3H+NAYr1IcouVriZHVrPLiKC+HqTzby3ZOr8MesQtApoohpel4P1qxh7sNZKvt5kV8R2U+6KRl+4BtGQ1l18EEV3uucDhKZIA0yO9nfM1JmGnYMSq49erutGifsveo30GtwkZUzmQkVataeOHJfAnJQ0VJS1120o9d4BAe+sv3Sa3A8ptss+xIciFIs99MmoC6mR6I9OU7JVySLnqB7bDSSi3d6h1zua8nIgoz7KisYdANy/G0wCmbjq6A3CaLLreLF8gqdwTVMUr0OLvZYa5BFKMmfueDg5VE1Vh0OtRm2pLTsIYAtFjiAhJ/Q/s5W1fThsnczKODMs+8tpW9fu58ODQZPwwq6CYs8IGRUoXprBwWD+/XeYlc+i+yI6pEZrrCuLw9qjZhCc1nFo9Hcw0LUE/HzFsMlfLB9dsEG5W5uk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dba8e554-ad4d-400c-13c2-08dcf8eb94bc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2024 14:03:07.8664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OK5EoJ0APE7TjrIBLAzXVbc9ppEp2n+3TgXFbsOeZxX48ytxJ5FuxS7PQAJ/AVCGbrWtFc2571hb1sHvh9EFoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8078
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-30_12,2024-10-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410300111
X-Proofpoint-GUID: _YZ7oHfSJlQeWiLrnN21OmPp7JH0wr0l
X-Proofpoint-ORIG-GUID: _YZ7oHfSJlQeWiLrnN21OmPp7JH0wr0l

On 30/10/2024 13:50, Christoph Hellwig wrote:
>>   
>> +static void blk_stack_atomic_writes_limits(struct queue_limits *t, struct queue_limits *b)
> Avoid the overly long line here.

sure

> 
>> +	if (t->atomic_write_hw_max) {
> Maybe split this branch and the code for when it is not set into
> separate helpers to keep the function to a size where it can be
> easily understood?

I was trying to reduce indentation, but it does read a bit messy now, so 
I can try break into a smaller function.

> 
>> +	/* Check first bottom device limits */
>> +	if (!b->atomic_write_hw_boundary)
>> +		goto check_unit;
>> +	/*
>> +	 * Ensure atomic write boundary is aligned with chunk sectors. Stacked
>> +	 * devices store chunk sectors in t->io_min.
>> +	 */
>> +	if (b->atomic_write_hw_boundary > t->io_min &&
>> +	    b->atomic_write_hw_boundary % t->io_min)
>> +		goto unsupported;
>> +	else if (t->io_min > b->atomic_write_hw_boundary &&
> No need for the else here.
> 
>> +		 t->io_min % b->atomic_write_hw_boundary)
>> +		goto unsupported;
>> +
>> +	t->atomic_write_hw_boundary = b->atomic_write_hw_boundary;
>> +
>> +check_unit:
> Maybe instead of the check_unit goto just move the checks between the
> goto above and this into a branch?

I'm not sure, but I can try to avoid using the "goto check_unit" just to 
skip code.

> 
> Otherwise this looks conceptually fine to me.

ok, thanks!

