Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55FD1D515C;
	Thu, 24 Oct 2024 13:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729777955; cv=fail; b=RSnAFnDvh8v96R3ytOYY+w1VSkWd9uaG34m1/EayPF2chu0/IImS4Ge4b2fm3mTzDLfRKP4mSaHH/6sCKI4t4sSFptfJlHiTMEZHu/lQilzn5pG/h7RvK8X60JAePx9tSwnOcniCH28jHHWe9TOltfqBvDo4GaunHXI1FViqPI4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729777955; c=relaxed/simple;
	bh=JS/nUOYWnOb2jKSMqsN5V56Xzd6AUL7qt+aQvGFoZv4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FaTU2RtXo1Pek+4DIruu+T41IjBU16JWhPT65USpBs45hHDHKx/+IoMawfUjVTRt8UMVCMC9IoE9KfyrcQngWBQeFnijFB27J8C4vaBELmDmPXJVCPYgyAGmXdra5qe9XQzPRzlA2tzslI9BlB/hD4copMOfOvdsXyabCdySCKI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UyUDS0fb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mUpLROun; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UyUDS0fb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mUpLROun"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49OC1axF025361;
	Thu, 24 Oct 2024 13:51:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=anFnGhQkVLRRPYJv3N2BRYWd0wtCNwiTWQQzg95ubdg=; b=
	UyUDS0fbAhR3DL+hzAW7kaHZ1XK3NiDS0rnzMYoBeEs32vBOtXe0bULUzut+SIng
	P93Rqx8Z11uMD+xnV2bJIvhuD/qdOegssGE97JLtcIUk3WGmbggKKULuWNfdZe8D
	3ajFO8Cx8bhJfsl6Uur+h/00YuDoK6lwW/CCKoIDBwcv/i8OyoxTiv243hY8blVN
	t33+ZHcvH2A4KjgqOt8QVbUOFOU8XCz1atGc7k+lCitvZ+nroDQU+rPv5fco6H4h
	bpN/lzRtiZMTzNjWme5vQ0yyeuZzvbjosOUwkZb3Q03i2dEsGzI8ODYHe/f/prSb
	UL+Qnq/OKVphJvKS8VoJeQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c55ejj5y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Oct 2024 13:51:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49OChnIj030970;
	Thu, 24 Oct 2024 13:51:10 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2043.outbound.protection.outlook.com [104.47.55.43])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42emh2ywg9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Oct 2024 13:51:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gg9Ilt9+NfOiOzbpiM/H7kwCSROdjsDen8iujLwBGZka2e94NAEmZsF9qttUURipnzZjvVODecSjBG0bArKTKag9MNvmdQcb061X9C2iIk6qudK/40NvvVO1u2wJqTnlDLe0r0S4qEqFB1RAUd88kS30Rt8VpfeD4eTPCPUpo+TEKzyEGi4+zXuLeojsdEQJdKdJuPpySWTrNyg4ueTcnBZXDJBM34B9X0BiI1XGyeYLV7JBlcY36c/G3KXk/GnfMl+11OFjdRTkijHEd2VzvPAeeS9kgza6EO2luvVHbEPVjJVy5LK2XWUqoBmozZIw8CFuO860a1wliKi5SOZTcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=anFnGhQkVLRRPYJv3N2BRYWd0wtCNwiTWQQzg95ubdg=;
 b=XxfIkGvHKY7oJfkrpNmcgjQ5bhH1sb3DebTNvDeSaOKQGCFKb2dy/WXzfkMLQaUif0jBN8/dtX/q5HE1p8gNXYvmDBCRWBT0LhcenbY3qEMFFY8FKOvd1Aexe7oI+bulP/g5ItdSNnsOTeDWW2Niuc4IgZjjaKk7JCjgZaLgq2a4DdyrIoD1wydFgZVSj2p+8HOcqFQIQEwoS8R+1mjzMLTJ4baAJOsbrQdofNls2sDBLq0MhPBrcauJjkIE+Nka/uUa2BN28o6rovESzY9ryU3WExaXXdoajE7QfChg+QHLurleTBvBvlRA+wM9nZrus5b6hhcJ+fyuP2x8Gko+4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=anFnGhQkVLRRPYJv3N2BRYWd0wtCNwiTWQQzg95ubdg=;
 b=mUpLROunKIB3tCJK5uiUrEmwWyvJlrHgkc4qCUY1zKMpAlBl0VZsTMCXs3pQMwgqy92vdqLGutTxGgFkoftoMwuDz3fFqX2vCDWrNYaKtU0usfr8wHb2G6OrlkJlbwkaJrBs9CM60X21DOa8o022tROj9aDKVEU1h6KR7G//OZU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MN6PR10MB8096.namprd10.prod.outlook.com (2603:10b6:208:4f9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.17; Thu, 24 Oct
 2024 13:51:08 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.018; Thu, 24 Oct 2024
 13:51:08 +0000
Message-ID: <1ca75a4f-3c6b-46ff-a5fd-f34936a0fb12@oracle.com>
Date: Thu, 24 Oct 2024 14:51:04 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 5/6] md/raid1: Handle bio_split() errors
To: Yu Kuai <yukuai1@huaweicloud.com>, axboe@kernel.dk, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        "yangerkun@huawei.com" <yangerkun@huawei.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20240919092302.3094725-1-john.g.garry@oracle.com>
 <20240919092302.3094725-6-john.g.garry@oracle.com>
 <bc4c414c-a7aa-358b-71c1-598af05f005f@huaweicloud.com>
 <0161641d-daef-4804-b4d2-4a83f625bc77@oracle.com>
 <c03de5c7-20b8-3973-a843-fc010f121631@huaweicloud.com>
 <68d10e83-b196-4935-a350-464b82c30e44@oracle.com>
 <169b94ae-8711-1821-75a7-7e3a600745e4@huaweicloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <169b94ae-8711-1821-75a7-7e3a600745e4@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR01CA0074.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MN6PR10MB8096:EE_
X-MS-Office365-Filtering-Correlation-Id: ad4055be-4b50-49ec-d701-08dcf432e922
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?KytrOThQaDN1Z0dYa3ZzaXRxQVRVbTNjM3BPLzBucm9NTnFwTmZCeXVFNEor?=
 =?utf-8?B?MHUwQ0RwMit6WEpaU3RJMmFadUdCYm9sZmkxQUJjYU5NMCt5VjdJWXFRYWY0?=
 =?utf-8?B?bEt3Y0NzbUJWZGpwVmgrakY5NEpSajNzazJERzBMODhsaHdkVll5NnVib0gx?=
 =?utf-8?B?T2JPVWtpcHdWRXlTYU83cTA4VGJSd3pwbzBjdmRBVjhvNmhxQmtKSlU5NEdE?=
 =?utf-8?B?cTFhK1VvSWtBM1FURVFhUkxMMXFMYTRJNjhqYXZXRUdTWkpWbkVHK2d1SUVr?=
 =?utf-8?B?UUU3Wmp2V3FMdXJQN3pCRlE2dGo4eVFtQ1lURWs5QVQyYXFsODdCSGxaU09E?=
 =?utf-8?B?R2RQakcvL3hiaERFQ1ZDZ0hwdUVlZmRKSUZmd1NFY3YzQndsTUVyMkhsOW83?=
 =?utf-8?B?bDhDdGtOMi9MZGNncnovQmRLMUhPdEZWUGsrZVB6eFFnL1BnN1NYczdKeG1F?=
 =?utf-8?B?SHJZSGcrdWZnUUptMGZNM0lNbzlxRVNrUWUxaEtzS2plbWI0eWw3V2dCQVk5?=
 =?utf-8?B?c3NLaGNWUk82RjgyMTcwaVdudHNhSFptQ09KVFRkck9ub1ArUGtvdldPOFh4?=
 =?utf-8?B?WEZrRFJYQ3l6U1hyLzNCL2QxSEppMUhQQmNpUmFBcjdSYjU0UU1xd1MzRlF4?=
 =?utf-8?B?VldteUoxQ2hsSVlmZW9vckN6YVJMNTZtcmFrZFVjOVlyVkdlcUJ0K0cvR25I?=
 =?utf-8?B?b1ZpQnA0dXdGc3QvUkN3NGZlMmVqb1NwVmZYUkNoMllwcVhnYWdVNHBQZ05W?=
 =?utf-8?B?NEV2dk0vaEdxSVNoeExTUUpUOHJpYmkwUGtYWlBDZlVyWFdKSm91T1BQa1pJ?=
 =?utf-8?B?QkwyVTJJL3dZL29BNFMzWjMwQXFMWWh5YVBkTlJpaEIrR2U0RmdIQUF6QXdU?=
 =?utf-8?B?NGI3c2U0R0JkdWYyNWZ0T2oyeGJwcnJyNXlrSjZNbkVSenRJTFpUSEpxTjlz?=
 =?utf-8?B?d2FFbUZPSUNzUFI5TkNnYjltcHorbUl4dFhiSm1GMGs3TWpnMGNuUWIzZEJn?=
 =?utf-8?B?WkQ4UjN4OExDckErTmpzQWlXVnNFZFA3aS9vUW9SWXF3Mnd4LzgvTFVpQ0hM?=
 =?utf-8?B?ZllKSXJvUVB0VE9sRGR4UEV5WEtFUFBFMUJkR3ZJUEtGK2F1SXBrWFFaNW9V?=
 =?utf-8?B?TitaeTZYUHNtdUh1eUJuRHlLaWRVSSswNnFHVFZwWUppNnlhc2x5WWtuWko5?=
 =?utf-8?B?WFJNNzN2WHRtK1hkalh5WjdLTnZ4LzFTQml0V2JoSWRtU3pyZ1VoS2I5bCtt?=
 =?utf-8?B?VzcwZHBRL0N1NmRGWUhLMWw5RkkxS0l5em5NcFVrSlZaMENiaEEvU1R2SXNh?=
 =?utf-8?B?Yis5d25lVi9EN1Q0OWZpR1NzKzAxeHk1K0JvVXB6TnQyWitwVW8wSkVSZS81?=
 =?utf-8?B?aUpmUVhxWVJreWE4NmMveXlQVWJyUlJ5ZzllVVdCQlFXRFk5cWdpUjJ3Zmpm?=
 =?utf-8?B?Z0pNd1AvZUpiOU9vQ25CdVlUT3owTDlYNDhMNEVSNmhyMnBLeHZzWXdDcGxK?=
 =?utf-8?B?QmQwaEo1WHlFajRxaUpKMy9aTXR1YUJmS0lmWGNZalFMWUR0V2MxYlRzYlVW?=
 =?utf-8?B?Q3QrTnBZV1g2QlNTQitwRkZUYmxRTzMyTTF6b043T3d4MkZRU3VhWjgxR1ky?=
 =?utf-8?B?RTNmTHBpV3hCQUVSa3VIYURCVSs2dDZVMFQvWnBIY3o3RXk5a0pnaDZXVVMv?=
 =?utf-8?B?T2dsUzNKRU5yczNla0Eybll6aHZaMTQ2MlF4NElUUWs4ZmZEYXhLRldhOXYz?=
 =?utf-8?Q?O4InmHrGIqCLlVAjGnZwjiVChVVbMCJjRMAEuIN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R2J2TXIzL2RFSk1ZazhTTk5aaWRSMjNNdVVEYXJPTmxYR1g0SlNEekFjWlhJ?=
 =?utf-8?B?cVlNa0QwdWZFc01VYXNpcVRsYVlrcmZPWlE0bS9HdDVNOXY5QkJkeElxVVlB?=
 =?utf-8?B?UTlkOUNVZHhRZTJ3dHFjd0ZubXMxZlBuTFFkYUxjK1FUVFJWdGt6MHNwd3V3?=
 =?utf-8?B?OEJya2ROOXV3ZE4wUmp4QlVjOVdhRGhtdERDVDUyR2JncWp1amljYzRiRDhZ?=
 =?utf-8?B?UmloN2tHWGxhMTBlWGhTL0ZQZmtjR0E2REhnSGIzQzllMWpEbWlMYjdqRU5T?=
 =?utf-8?B?c3M0T3ppSmtQc1NjVjlRYWxIeHRLMGFUNXpXYVp4M2lRQmpSd1JpSVcwdVNu?=
 =?utf-8?B?MnBGTFhTa0pObEVrdnhWbEdDdGQ4bVdTMkZJUTJTcTZ2Tlo3ckhYUG82anpa?=
 =?utf-8?B?c0Q4SmRiWUhmZzUvMW5tanJwUWt5RmFsNDRCdlFiYVpDaGdLMVlTVVJvYklS?=
 =?utf-8?B?Z0N0VVhEaVlLTHZWV0hDTExmcFFyOUk2Vnp3dVNkTnBiSERTZUxOaEtNYkJ4?=
 =?utf-8?B?bjhPa0p3ZExNQ2RwUURsbG9YRC9vYW9xZVV5ejI3Z1JJLytheUpNbWwzZmtE?=
 =?utf-8?B?UlZvT204YWVZRlBSSEJpYkJVVWViTlVVUk1IQkEvYWhDOWZFTXVGaVVIbDgw?=
 =?utf-8?B?U2pvbnhjZmZNZkpQWnFnT1lDYnhCSUhBVFl0V0ZSbGNSdDRndmRYVmIvTm9C?=
 =?utf-8?B?ZGVSZjF6ZUVWYU5tZGpybzB0Z1RFYmpmb0FYekFYQ2NNZ0NSRzlua3N5ZVhK?=
 =?utf-8?B?RVNrYWJqeFNGTUxXMExhb0RiVllsZDA1ajFFNDVVdU9SQjV6b0tlbWw1TzV2?=
 =?utf-8?B?MWxsZnN2WTB2czl3USszUjJlRXpSb1huY0VtNEg0MU90NEkwWjFaOElOd0xN?=
 =?utf-8?B?ZUtqdmU0U2dWYTVzek5iT3BDeVBnaEVYUGM0M2h3bXVNeFJhYkEzeU9rWXBr?=
 =?utf-8?B?ekNlQzl3UnY4RTdXejJpZGJNVUgwS1ZNanVndTNhcm1vRG8vM2wwQUx6bGFW?=
 =?utf-8?B?b3JXSUt2dEl3R0JtYWk3QVhXRkNZRnVDMUhsY1VSaFJqRzc2ZWswVDNWZUEx?=
 =?utf-8?B?cit5R3ZoQnFQTEV4RjBHY1dwaWlONFFOZnczTlJIbzVJOVZCeHBIaUV3ejND?=
 =?utf-8?B?M2pMQ0lubUVnZGFpM1Nndmc0SEVTb1pLWnlVVXNLQ0RpSFVPcU1hdFFZQWFl?=
 =?utf-8?B?ejdmTkxEU3VjZ3U5UkdWUFZaZm1XUERUellVRFNVN1lhVXduK0JxeE42OGpQ?=
 =?utf-8?B?ZG0ydHJNeDNHRGtWYTdmTmkwVmZsRnhYdTV4L3U4T21tMzBLellneGg2SVlO?=
 =?utf-8?B?YlNrc0xwbER0bmJ5V09RWWFZZFdJYkJ3RU1JcmY4TlNiTjNLa2VEczY0Z24y?=
 =?utf-8?B?OGpRNGYyYXArb0VtZmdlQmtnd01vR01iSm1DSUROcEFTQTFyb1FIdlBxN3Yz?=
 =?utf-8?B?TmRFY2xTcWY2OHZtcDNrdGxtb2NtdnprU3daNXMxQmdQdmNaeHVDTXJCUG15?=
 =?utf-8?B?TlNtY2YzNUtLTnFqTWZjOFFxMDkvdXh4dXcvK3MyZkZXL2tsY2RPbFF2eEM2?=
 =?utf-8?B?bHlXTVFCRThreitTMmsxVjBqT2dEN2h2Wm1yOGZVeS9lazFiQ2VWb1Jlcm9z?=
 =?utf-8?B?Sk9GbVRMUU1vTlV0VTM3b2hTV2VMcm9MTUp1NVNENkFtY2VzZ2tTMEkrekZx?=
 =?utf-8?B?OEVyeklRckFkM3dTY3A3U1NkNkZETlVBem9xbzVwSEpETUxmdkVrVTNVcnpY?=
 =?utf-8?B?bG8vbUFQVHcyQjBKVWJTNnhSd1VnQlk4dnA0NEhzaEx5N1FGRDhUWWNuaWMy?=
 =?utf-8?B?V0UvWTJoY2RKQ3NoTTY2cHRGT1FJdWtiV0NaL0lheWJrTlhBa0dtNyt5bGtO?=
 =?utf-8?B?MXNSM0l4dDBvclZRNTQvRWlMMm5uL2krVFI1NWJwUXgvVW54RGFEV2ZReVY4?=
 =?utf-8?B?cWdmZUtpa0VBUkQxSkNOdUNiUis3ckQ0RUJOMjNLTjdPKzU1VlZEdkFjUzRy?=
 =?utf-8?B?eDg1ZnVKNlJoNEhScmlkQ2R1QUJpN1VLYmdNdkpNbUlNYlZtbG55SFlyRVJL?=
 =?utf-8?B?STA4K2VaN3dodm1vWWVBRGhtQ3QxVEJTcFg2UUdERUp2R3Q2MWs1ZEE5RHdp?=
 =?utf-8?Q?IGwWmr1AdlNhUnex31BrqQa1g?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZPxD4aGnR1HTV7RGuLELwUTIACzlgr5ccb0cfkcFLCyVAB700axNAKlglTcRIUVw6W75yrbU96kttXxYEcqcqrkfuJeU7TQ/TNzP7eH1mGiLa5t/5OKPcmpwjJN7ZecNbjZIqAk/DmJno+sdwRkUUwHCJWQdsQOiOPmBz8nPOEtHqOnbyPz1Qt8dt1wEDpeuNRiwBHN/P292APsA6MwvifNtsc7kLuRgip+hfKRQET2nOrwRlqfW6HEGqjQQNev+oikBPkBDY/Rg6RZtu2i+quk7OTHlbNicKaA7y19R1czcirqU8qXUt+X3NW86jo+XNCe/DF5bommLCFzoJ0F1wdaOy94OBRZTTe+/IcTD31d9AbjDVHoA6bluf9OllLO3PDHtACtqaZxwjygPLLFv2io+cyau80etC9wMZuXNJLbjGL/helpxmKPITFAKWr5dQ1piF0esV6VeWs91LI66xoCoMrz5zX2SpElKSWxL1A4Njm6m2A710cveiu9Lkbs+il9io6V0dWSdJ5xAILFF77FcdJK56u1aPCjBqY9YBa6LY82/0t8R0Gbkx0p9o5GVFg8VMfnOKxY7GHaju5cRU15rIIjXTWwKdZeAMkI/RY8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad4055be-4b50-49ec-d701-08dcf432e922
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2024 13:51:07.9586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qZrcfJ1WPJzr1zcHfv/CI0ELP7AIITyd4xS05kj3ykmXNzUpQd0p64SJp8AMMIYhcqQdOkHnSRCvC9VaQ6xF+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8096
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-24_15,2024-10-24_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=891
 phishscore=0 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410240113
X-Proofpoint-ORIG-GUID: 5-RuQiURYOeOW2hAP2L-9jnT5Ko_R_UF
X-Proofpoint-GUID: 5-RuQiURYOeOW2hAP2L-9jnT5Ko_R_UF

On 24/10/2024 04:08, Yu Kuai wrote:
>>
>> I could just have this pattern:

Hi Kuai,

>>
>> bio->bi_status = errno_to_blk_status(err);
>> set_bit(R1BIO_Uptodate, &r1_bio->state);
>> raid_end_bio_io(r1_bio);
>>
> I can live with this. 🙂
> 
>> Is there a neater way to do this?
> 
> Perhaps add a new filed 'status' in r1bio? And initialize it to
> BLK_STS_IOERR;
> 
> Then replace:
> set_bit(R1BIO_Uptodate, &r1_bio->state);
> to:
> r1_bio->status = BLK_STS_OK;

So are you saying that R1BIO_Uptodate could be dropped then?

> 
> and change call_bio_endio:
> bio->bi_status = r1_bio->status;
> 
> finially here:
> r1_bio->status = errno_to_blk_status(err);
> raid_end_bio_io(r1_bio);

Why not just set bio->bi_status directly?

Cheers,
John

