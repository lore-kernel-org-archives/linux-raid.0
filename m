Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B343FD4;
	Wed, 23 Oct 2024 12:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729685860; cv=fail; b=nuXNiRi88Yitt6HEIves6dImT8HJbHOgEIfS8cshEz8kBQePYm4vGR5GLXgQ1YO54gUvFz1N+DMyrxfl3RAZI9fv/9FojznvfkMCN2+AYWHPa3OdZdzfvxd85zItGo0Aa1KXkp4zUeObbTHOoJLqrmFepq2kXqs6ylAEVHVaT8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729685860; c=relaxed/simple;
	bh=AregmvT4N5lIdoayu4EuqcCeOQma1plc0PFLoM5411g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IzVJ8CMBuIlQbbOADM02xPnibG/UO3sWL4YDKZUojJfpJTGPXstaJPfgU/5cVpt7OWsHN/47MVVDosMEXPg0S+ibhMDaFHV8C8d2pamCNKv0NetVTwPc6+bUx1OsSSsT7slQAeBMvcQ+MHpjsklNdoyLm6Dwk9rq6UQrKjNJWeU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=W9FDCEYX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=D/LHi7GC; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W9FDCEYX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="D/LHi7GC"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49NBQquU016826;
	Wed, 23 Oct 2024 12:12:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=d4XaJAZZBG9f9AmkbXQNeqdqAiALCRvQAEFkqVyb7lk=; b=
	W9FDCEYX86VAoc+dQOusghckvrCRBE5oAQjnyHdyJIaUWlf33CMMsOQqQzMk9bYF
	ocCwfd1SjFEARRgS+icAolcB9qo1yy7Q04Xl4XgGhHH/HCMGEYdIKFYB/PlH+vlq
	pTmP+d/6bNbHJkba4sFEYA8Bn2tQxTiw8QXhlEQnRKslDzzjqi3Kz/KJP88AF4QP
	Fl0Gn7AY56l4QVnTYP15/PpZtcbWFDMeEY2zRAtlJGoOC/57mtuuBo5Z/tZtV+G7
	jxO4nHZkRfOwICSpEXSrudqkehBRfqYZAPp4k1yd5nD3VB3AT+cFqUS7I25/sV9Y
	Cytyn9SA+/0PdohwbGdZsg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c55efurn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Oct 2024 12:12:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49NB3XBn025475;
	Wed, 23 Oct 2024 12:12:12 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42emh9ejq6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Oct 2024 12:12:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gwsg4qrgi+fwZssuEB2kM4ChUyH2MA4U2SbEbgs2sVGFj3DbiGxrYR8OSRsex5JxWciPlFVfIOQ7o50dKh/GSRnFg5PH/8Wqh7aQYUsqd6s0bjgzWlT/qcsEdp9C8bVNWzRhYp7ycYNEez+2BEnPOgeGiAc3ac3TglhqgwHpouos6v34109D1tTCnGnfFG2qchfnyet4LquH67UjeEjMcz+OywWzu+szN5q3oMFmrbLCetgBYZ2Q1M0L3ga+T82SgRMyJaBna6S9oV4TvX1+1TyLVkiXYZqApxcFYj8nGUQPNp1OjVV0+eVPOzikqpSDlo03EeT33mcckr1cOtc0qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d4XaJAZZBG9f9AmkbXQNeqdqAiALCRvQAEFkqVyb7lk=;
 b=x84IWoYpVMF5BZhBH/wh+p1kA3F/EV7Ce8B7muCEtOD52cXNcpPmVlmBCxNDFXaH+aygx5c4toQIVPyjUqeFjnJeFYTnLLcq/HRs0SpjTz0F2OWFXwNO6pniR7s1KfGkDMnqnMpa277HrLuOtaOAoShKGB0lDxkyBI5A+9afL+1U97ZgYZoB6A82M5yBMn8SJrkbJqeZRTpKjDx2jSP92yBc/ntPDyul8lqBqEPIXO3QcssyTA4aMqy2vJRkrw+lZlkRImG28tar7sRduNSvXQ6jhfGuL+e+Wg7pi9ABGP04gfEYrESCgyoSnkLld9RMCKJLqRpmHCrBFRAFFKHGNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d4XaJAZZBG9f9AmkbXQNeqdqAiALCRvQAEFkqVyb7lk=;
 b=D/LHi7GCWYSGY9DKRntQSOT4DpU2lkCdugLMdIipVsdAmv+WKw6MyC//xEIgT+7zIQoWkxmq9GBX0VIBuS05HY7yH4bQeCKi70xLHaO3Ul0Zyz4eT0nO+ApBP9aKz0yK0z5r88WBKdStqEOmvkKbd6m1SfdtUOTaGLMFw1IGfTg=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by DM6PR10MB4138.namprd10.prod.outlook.com (2603:10b6:5:218::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.17; Wed, 23 Oct
 2024 12:12:08 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%5]) with mapi id 15.20.8093.014; Wed, 23 Oct 2024
 12:12:07 +0000
Message-ID: <5a16f8c2-d868-48cf-96c8-a0d99e440ca5@oracle.com>
Date: Wed, 23 Oct 2024 13:11:53 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 5/6] md/raid1: Handle bio_split() errors
To: Geoff Back <geoff@demonlair.co.uk>, Yu Kuai <yukuai1@huaweicloud.com>,
        axboe@kernel.dk, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        "yangerkun@huawei.com" <yangerkun@huawei.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20240919092302.3094725-1-john.g.garry@oracle.com>
 <20240919092302.3094725-6-john.g.garry@oracle.com>
 <bc4c414c-a7aa-358b-71c1-598af05f005f@huaweicloud.com>
 <0161641d-daef-4804-b4d2-4a83f625bc77@oracle.com>
 <c03de5c7-20b8-3973-a843-fc010f121631@huaweicloud.com>
 <44806c6f-d96a-498c-83e1-e3853ee79d5a@oracle.com>
 <59a46919-6c6d-46cb-1fe4-5ded849617e1@huaweicloud.com>
 <6148a744-e62c-45f6-b273-772aaf51a2df@oracle.com>
 <be465913-80c7-762a-51f1-56021aa323dd@huaweicloud.com>
 <0cf7985e-e7ac-4503-827b-eb2a0fd6ef67@oracle.com>
 <098e65e7-53fb-4bf1-b973-2bda425139ae@demonlair.co.uk>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <098e65e7-53fb-4bf1-b973-2bda425139ae@demonlair.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0439.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::12) To MN2PR10MB4318.namprd10.prod.outlook.com
 (2603:10b6:208:1d8::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|DM6PR10MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: 4757b028-4f56-4c17-20e6-08dcf35be71a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YVdXK3I5enRlQ1VVUlUxeGVyZjNLY045dFJXSDgvVDZHdW8xRnNma2NuMXQ4?=
 =?utf-8?B?T1U1UXZzcTQzTXVDcm9KNmw5K0JQV2l4c05vcEQwUWQ4VCtPcFlXalJqMEh0?=
 =?utf-8?B?SG54WjlvUS9hVUhWc05rN25mTHhLaTFyS1oyemtvMTdTWWRpamRlZHp0UHJx?=
 =?utf-8?B?WTdnWmFlRWx5blladW9UcFNJaUtaOE8rRmkrMWd2Rm9JSFFJM1NtbmtRQUhj?=
 =?utf-8?B?RHJaNG9OendadC9CT0gwSFd6UkNRR29kWnZ3R0pWU3VocDVzUm5FSTkreG56?=
 =?utf-8?B?MlRaWHA4eGx0TFJpSXZTN2kwVHlEMUtHVXlxMmlML1kzb0Z6UXB3NHZkTENR?=
 =?utf-8?B?MlYxYWpyc0NxY1RTSW5NK1FMcVYrUHUvU0JqUk81UE9TN2NzNlBBVlRMd2RM?=
 =?utf-8?B?djl2cHVXVnV4MmlvclZ1OUdVTkoxa3FnSmducTh6azdQakR5MlZEUmowMUhj?=
 =?utf-8?B?eWJET2pLSkNGbzVjZ0p6dXlnT1dlaklzZ2xWQWx6WC8rR2JTQStwdWxMaHFZ?=
 =?utf-8?B?R0RkQUV1T0NYK0orRUhoQlRJTnprZkY0QmFabHR0OWZ1ZEJwRFF1KzkxNlJH?=
 =?utf-8?B?TUMwbmcyZ0dPVFpEVUVTWXI0STFDOG1WZ2F3Z0hrRGJGUmN3NG9lMXN5VE1y?=
 =?utf-8?B?aXRCMmF1OThpcmd2Uk9la0E1bzVUUGMvZWR1dzl4UWs3SzIwQkVBZm9uUzY0?=
 =?utf-8?B?YVdYMXhxMEtkWExmQzdDNmN5Z20wSDFwUjJCcHdXN0xmc1c2QWIrcGRlMlZm?=
 =?utf-8?B?cUMwS3N4dG15dFBvWjk2OE03ZXdlZDFNalVaN1J3a05QbTBJRzR6MUoybDFp?=
 =?utf-8?B?MTlrS0I3MVlGTFBiMnRyZGlzclF6VlBrSW53SDdrc3lmYWVQQ0czWjl3MjYy?=
 =?utf-8?B?UVpjMXdmWmxsZnJ5MUNFNWZaOElmNEtNM2pNZy95WXhtdnA4aWFGSDhMWmh3?=
 =?utf-8?B?ZjNvK2pqTnl0eW4zS05oM2ljSnFrQlNmT1BQZzVzVjFQcUFoSUhPWVk1eUVK?=
 =?utf-8?B?aUJ1dzYzcVdNT0taMW1xcmkxa1NKYlJnaWZibjVHNU1za2sySWhRenpkZzN1?=
 =?utf-8?B?S0FUNSs1VFZ0SCt0bTh0TCtVNk0zR2dHSklSVVlxWFRNM2lrY2ovb1lXS1l4?=
 =?utf-8?B?THgwYVk4TnAwREZsU1JVS1dDbWJXY25WV1JSVTdsOEhOM0k0OU5LcDVWYlE4?=
 =?utf-8?B?OTc2Rmd1aDBuOGo0VGRweWxmc3RmQVI3Nk5mWkJOdFNhYW9qcks0cXV2K2Z5?=
 =?utf-8?B?bDF4VzlIWDZ4UERUQ3FVVG4wY3loSWh1eHpMRS9Qby9wZENUMFNtd3RwQVlj?=
 =?utf-8?B?NHpyS3ZQTTlYaG52ODJ0NVlIVUZscldOZkhCZHNKZXlDRTZhOXFiSEY5Q2VO?=
 =?utf-8?B?RnVINjFjejFJRDlZcGV4Y3BsZ2tOS2FxWG5Jd3duUnpRN2JDN011VmMwdlVt?=
 =?utf-8?B?TmFRU2ZHQ080VkdSM203a0QrSW5VNm5JYThnYlBKSmhDUTZlNlBqUW00cFpD?=
 =?utf-8?B?UUpmZGphb21VMkhmZVRLTWpPTW5aUUxSa2lpakYwbndUK1Noc29nNFIyK1Bz?=
 =?utf-8?B?bjdFMkNvZ0lscFdWdU9kTFZXWUc5VHM2dnBDMkhtYVhEMER5eitrRGYvTGw0?=
 =?utf-8?B?Z0ZFNFZBNUN0UmFMMVFITkkwTjFvNTBjZnFFVHVJVkN0L0gvRGQydnlWYVNK?=
 =?utf-8?B?ejJyKzN1SElDUHhNUStpRWVNNFpPK0syaFZ5dnZVUHhIODNXYTJKbTh3dXBC?=
 =?utf-8?Q?xTPhaQwuzqM/ShX78Uv4SORdEdK0EyrjIOHeIzX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NEZkNDdOMDdiK1M5NHlKQ2ZLZjZ0Nm1VbTZ4QVBuZktranJUQ2xTNTByUHlk?=
 =?utf-8?B?aU55bzV3a28xUkJWQWJEUFpMbzN1S3dTQWRCKzZUa0svZnQvcUlEZkxPVUti?=
 =?utf-8?B?QUJ4aTJ5dUFsQklCcUcrdE03dUVqOUhjNTd6dEoxeVMxcXNmWjFsTEl5WXlR?=
 =?utf-8?B?UHF0dGJqOFk4Y01MTThJYVhJV1hWRmVrRXRYUGR3MU5obFVqQWZJVUVkdFBM?=
 =?utf-8?B?Vkc0dzFra3BjWHVWdUVLeHltMXh2dHlSU2Y1ekRVdTFueXNIU3N5NjBoaU9k?=
 =?utf-8?B?a2ViZTYxV01WRUNSQkdUVTNCd1RCNW5QRnUwd1JtS3A5U0pPMVRXQTRydU1m?=
 =?utf-8?B?TVAvUWhXZmNNdXRFV2tFOWVmY0RxSW5oL0t3RTYyd0FLWDFEN1BYWDVJTjRs?=
 =?utf-8?B?TFo3WlVHN2haeWpZcGhQcWcxYlhoOWk2ZUhLUHFBZFovT0xGNDk4cFNMUFR3?=
 =?utf-8?B?SW43YVlaejZMKzQ4RDFHOWEyOEFiU0QrT1JBV25rNkNOZDFnRm9JS05oR1dz?=
 =?utf-8?B?U001QlFtb2djSEFyN1hsRjdWLzRodndmQTRmWkd6Z0gydkxxN1ZQcDZyamhF?=
 =?utf-8?B?MkFablNsd0F3bGh4R2J4ZjFpdFQrb0hJN3FTeU8rZWhGRm4rNEtqOGUyZWs3?=
 =?utf-8?B?Y2lqMHFjZVZVWHVFczA3TjFqdG9GcDNSVm5MQTFDSzVWZ2VoRndhaWQzQ2hE?=
 =?utf-8?B?TDJtd0J5TTVheWdmU2hjSExDc2xISUw4RmNmWW5KSTRUVWpaSmI4bzhDTTJP?=
 =?utf-8?B?aFhPc1hPOG9YcW9wVVNmVGRKMWZGSnVZd1RPenpEZktVL0pZZDBCM3dSNGZv?=
 =?utf-8?B?aW5DSEE1S1JpOXZOSEQyYi9qOUVjei95dlZTdkF4OVZ5U3EwaFZLdnJRT2Uy?=
 =?utf-8?B?L1NMbXl2bUNrWEtWVWh5c2s5amtCY0tqcTI0SmlHRVFIZDZSWFd3OHQwOVkv?=
 =?utf-8?B?c3NmTUc4ZFZnaWEyL0w0dTIvV2JVQWhLTjkwOUwrbE0xbEpTemxCbHAvS3VR?=
 =?utf-8?B?Mkk4YjdQazRJTUFDWnRXOVRkNFlMRU51dHZ5UkVaOFRpNFh3SEhaeXVGY1FD?=
 =?utf-8?B?ejFiT2NzWVUrdkRaeE5waWQ2QXBZMXliRC9CM01haDVpblkrem1ScERRTGlE?=
 =?utf-8?B?c2IvVnBGVUZaZVVQYzg3ZU9Nc29VQkNWa2p4cVozNnJDdmhIZUlxUTNNWkZi?=
 =?utf-8?B?VHR6ZFk1WUI2RFJzek9wQklheWI0NDBmeFlLbWpOY3N5WlI4OTZYNC9CeGxF?=
 =?utf-8?B?dlpMNklWUnowTVBjdlZqZ1BtOW1zYmNXaWY0eEtFTEpjQ2FhYlBTRFJzcDFJ?=
 =?utf-8?B?Rmd3cW5jL2krUUlHNFN5ckNoUW0rcnM1QnJvZUpuVlJBczZKczhGYUlkc3FP?=
 =?utf-8?B?ZDc2MWdDSFM4N3R1R3JEaUJJckd1UGp2aHlRdGJycHBHSC9yaEVGVUVCbUc0?=
 =?utf-8?B?YXl5L0Z3dGk2Rzl0cXpweDBMYlRDTVRWMnFsUHY3cXplZmZMMDk0ZVJ6VGZR?=
 =?utf-8?B?aDY2bENTQVVRakQ1STd0eWxsenltMEZoM2dKV3hNbDRoODdrVkpqYWcwMlha?=
 =?utf-8?B?T09uNlp0czR1ZnRmYzlJOEwvOElsdTUrbVhOU2FQdlc1V0VCVHdIY2FiZm96?=
 =?utf-8?B?L1pYT0p4dWUrSkk2WlNweVZYNmcyN0tlM3J2RG5HVlh0dFkySEFwbDA3ay9v?=
 =?utf-8?B?SFJvcDlGMk0ySFJFVFh6SHRjcTFFTEd1YklOeERNQzY3ZmJBUEpSOFBUZS9p?=
 =?utf-8?B?a1IyYUpJaVRwdkdVM2hsdTNpRjFpdHpHVXZDTTBpbDd1ZUZmK0JPcWV1WlRG?=
 =?utf-8?B?QTg4bUpkWjVFOG9pR2ZRdERrbHRFSWgwOUNYdnExYU5NN1ZVQkVNbFJXV0ZG?=
 =?utf-8?B?cDE0SnFCc2NiTzk1NVp2Uzd3bmN0K0xiVVZwSTlsN0cvQU1GcFFZVnB0UlUx?=
 =?utf-8?B?Y0pMZ3o5R0swSzBaVFR1YWRhdWFpWnBWeHQ1cjB0TjA2V0lyWWFGY0dCa3hI?=
 =?utf-8?B?dGFaaXQ4NUxReDRzWHh6SE5JS2ljaEJkVlJLY0tEUTBNYWdtU2I4ZkU4L0Nv?=
 =?utf-8?B?ZXNoYkF1T3pIQklRMnhjMC9hMUJkWlBvSVhTVGk5T1M2M0xPSERNdnkzT3ZY?=
 =?utf-8?B?S1lYalJ2V0lsT1Jaei9XMEFuVVZaMkhGKzFIaUlGRnpCc3NJR0cxd0lBOSt2?=
 =?utf-8?B?NFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WIsCixdGYp4fMUO2vfVZZ4PqQB4/fuZ38Kd8RSA5idvxy2yY583iwC0u2jt1+VGWJTHlq1K1VtoL+BJkG7V7eeaKoqIT+BqPjiWf2SIPY5JpFy0iF96g6rrdZWA2002pojokWQqkMGFT4jLWKc9nSJpkZgNcG59ouJZH8U/SGO3pw9n0B6KqQFNcbu6WTqa29yflkHrEBirUDAhoJrAdBLnW1sgftpdgaCexf9pwV6+b3taX8X2Yk1idjMXephcP05vv82OqoeLGleP8VGOo5R2levron0q0uMAerin0r0R9wwojY57szJeho5gpnp2+ZD/TPFkY91zMo2vF1GTik/VP0BeDj/A2CkVqfuacBKQSyMWF1xXpAZg2pm5uGbOW0IVCky2FivYbIBORSjv/nfa86MMBILfhU6YrSKpuT3+/jzm2DtJJy8h9WZqy1bfdQUEgIQcxLy/Efu+wMLLhTftCLZ9YJ5RtQ3T1np9/NBCuFP1n37fK79PUNwlQTPMH1fcujDnqMKfBI2h1dXEe+rozM/QZwILGlp1OKcJXsFsCOXGANfvgu8ErIE5wyVFotyNK8YIhcmUmP8kq51F7l8dF3r9ntmpi3NHuNjqdYvw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4757b028-4f56-4c17-20e6-08dcf35be71a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4318.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2024 12:12:07.6585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lhBKU/U6e2nJEXkGYfe7E46XPiZTfcXEtB2E2wdba03QAUfnMvn8F2sTEQVJLI7hU1htMwGWexpPEkhgt69esA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4138
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-23_10,2024-10-23_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410230072
X-Proofpoint-ORIG-GUID: v-zyvn_DQ7GUiH1AW7AoLaCjVmIL-LAM
X-Proofpoint-GUID: v-zyvn_DQ7GUiH1AW7AoLaCjVmIL-LAM

On 23/10/2024 12:46, Geoff Back wrote:
>>> Yes, raid1/raid10 write are the same. If you want to enable atomic write
>>> for raid1/raid10, you must add a new branch to handle badblocks now,
>>> otherwise, as long as one copy contain any badblocks, atomic write will
>>> fail while theoretically I think it can work.
>> Can you please expand on what you mean by this last sentence, "I think
>> it can work".
>>
>> Indeed, IMO, chance of encountering a device with BBs and supporting
>> atomic writes is low, so no need to try to make it work (if it were
>> possible) - I think that we just report EIO.
>>
>> Thanks,
>> John
>>
>>
> Hi all,
> 
> Looking at this from a different angle: what does the bad blocks system
> actually gain in modern environments?  All the physical storage devices
> I can think of (including all HDDs and SSDs, NVME or otherwise) have
> internal mechanisms for remapping faulty blocks, and therefore
> unrecoverable blocks don't become visible to the Linux kernel level
> until after the physical storage device has exhausted its internal
> supply of replacement blocks.  At that point the physical device is
> already catastrophically failing, and in the case of SSDs will likely
> have already transitioned to a read-only state.  Using bad-blocks at the
> kernel level to map around additional faulty blocks at this point does
> not seem to me to have any benefit, and the device is unlikely to be
> even marginally usable for any useful length of time at that point anyway.
> 
> It seems to me that the bad-blocks capability is a legacy from the
> distant past when HDDs did not do internal block remapping and hence the
> kernel could usefully keep a disk usable by mapping out individual
> blocks in software.
> If this is the case and there isn't some other way that bad-blocks is
> still beneficial, might it be better to drop it altogether rather than
> implementing complex code to work around its effects?

I am not proposing to drop it. That is another topic.

I am just saying that I don't expect BBs for a device which supports 
atomic writes. As such, the solution for that case is simple - for an 
atomic write which cover BBs in any rdev, then just error that write.

> 
> Of course I'm happy to be corrected if there's still a real benefit to
> having it, just because I can't see one doesn't mean there isn't one.

I don't know if there is really a BB support benefit for modern devices 
at all.

Thanks,
John

