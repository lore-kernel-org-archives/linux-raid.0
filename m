Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7931828EA56
	for <linux-raid@vger.kernel.org>; Wed, 16 Jul 2025 07:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752651682; cv=fail; b=mCVh0QI2ARIs3G8O7T71IhmwTTGH0A7eXwMuva/WimSvvk1dzWSitriVrLUoLUwslOrjUnbPf/NSH1LY4Rw1yb4cUspSXDeuRrEqJlDgh0Ez5JHdVQnEHzZfDKxKHRi+5JKGQaKLFXuzqTaBY+1lUQLHwhjWqtaKz0Hq+tZXs9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752651682; c=relaxed/simple;
	bh=xzpnyLViRt4/ceJdLegOSQE/+3Lkfm4DujiTmIbEwTQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GrGFV99KLGlSFD26D5yBnrFzH3AlyBU1miOv51IMFxNa7cG2qcSsrrXd6b/Y6fTbzUBvp/wALYiCKsy8b+XIzCxKeOkbsgVsXzCowNfEUYCf3imPmlhxU5gKmbyIdtiQ7tF//sHPmppmWBG/HFrnx4M4+j5omHx0N7SIMUF3F0A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OOgW4LsS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=q0ZpmHRN; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OOgW4LsS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="q0ZpmHRN"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56G5MmdR011944;
	Wed, 16 Jul 2025 07:36:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hqhqzDWAPWa/udHZL6NfnSTOZjIDV5AzMN4gNokjnpE=; b=
	OOgW4LsSCEZ2/5LEcjsWsztIrJAdyX4Udr8o47utWW5u/5PlNCPSMvI/V4RkOnvO
	8KpyaWfdmvIsp71MW8CDw5bnpk4b4JNVYjUMPvzBMIumAmVNAA+vFVJQc9qI3jTw
	GUpihI8La7Y5qWpqBcSTHOidK1eZZvLs8uU5UNApCCVwEilQEfiBdc8CfxnMZShm
	7bLhrOf8aaG4a6ykhpQBg2khxQZsmwTNDXrUamnbrI9Phlgb8YoKeFzJX0p9d6CT
	U83LOmb/2YpkojCbKkaW5I2LseDJmdBazrSvA7MUzw1qoIbT5fA/IWRt9t4rGhCD
	BPojpNhvqzJ2kTKaoFL3dg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ufnqs4wy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Jul 2025 07:36:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56G5SOF8013035;
	Wed, 16 Jul 2025 07:36:01 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012033.outbound.protection.outlook.com [40.93.195.33])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ue5agy9w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Jul 2025 07:36:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UFQwfcH5BZUGWpp8BnlGyXiZ1S8an7nEmhjP7eDLqoK5BJ50q8Sd78ovUVvHg7TIfzjo4qj67vEZ62kJwvKiMSnTOoABszDOSTHlpfPfYuT4I79nnA2n6qvkS3loMoL3VfKpyJsuWM/ty1WLYLrJ3ZNA//D5mL7dqWYDJ+UHFBIBEH8FcJIB87U8bL9Q7y8whaAFaYQ+yWMsXDNlQ16VExV8NqbfziHO9ImxZ5PWlDZ4Nf/eICxKx5bMhekaYSRluRTOhRY2OUG1GKZeKVgQAVUed4wVEHEUTU0IF1fVb2CMTFhr9K+D1eKeWpn6NLK1w7s65+3mlkpNN5olBm827w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hqhqzDWAPWa/udHZL6NfnSTOZjIDV5AzMN4gNokjnpE=;
 b=SXEQS//j0kcIfv2EFkP66TgGSYfwygBpGSXZEL9AFAmiU32LiYkDgtZARjXj1WnlGzfiVcSuMM6ReR8dWMEUSzxc9PG0usV24tgKTDpMDCUfCuu3xWbklzLR2MUfxO0c6TXU6Wsfrl32XQP9mJWffjGlKucbDfYBlK8ml4pZ3ajJSFSBYET2wRUyGIXVHmBZJ/ZKglDqMO8Fpl89fRpQDVQW+k8eLkUbKjaB5o0c1qUch/NSSipprbCf/dxPoLKfV/IzxoLyj46Q3i6XGcqMAedcxFlifErZLiDh9kyIJGpdwOVJwxVlsNYsbkF5lqp75Z97dH0ilf2jt4KXhWpi7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hqhqzDWAPWa/udHZL6NfnSTOZjIDV5AzMN4gNokjnpE=;
 b=q0ZpmHRNHlVsoIOB5RvFsuRP1To1g2OZ5V8NeNftzgFCFGhX7n7f7llbxt0I34xSltjs4TDUPqoKkNnwMSyGHbiCFBoI588WHsuLJ7266Y9Y45crX/gSZ+Rrojpdtc7WtJfEqa0WEPnfRHuMPt7u0VpsDXf7n+QkDizqDyygE5E=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DM6PR10MB4201.namprd10.prod.outlook.com (2603:10b6:5:216::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.32; Wed, 16 Jul
 2025 07:35:58 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.028; Wed, 16 Jul 2025
 07:35:58 +0000
Message-ID: <f494f013-1698-43da-a0ca-ff524b1f305c@oracle.com>
Date: Wed, 16 Jul 2025 08:35:56 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid10: fix set but not used variable in
 sync_request_write()
To: song@kernel.org, yukuai3@huawei.com, xni@redhat.com
Cc: linux-raid@vger.kernel.org
References: <20250709104814.2307276-1-john.g.garry@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250709104814.2307276-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P251CA0025.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::12) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DM6PR10MB4201:EE_
X-MS-Office365-Filtering-Correlation-Id: f227579a-28d2-4c3e-e749-08ddc43b67f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Yjc4cS8yZ1pIRERTOUVnTnBKNjBHWnMrdVRDR2V0bWRVZHZtR0NtRHltNFIv?=
 =?utf-8?B?UEJGTmJnM1BMNnhvNVdUMjNzZHV5MER1V2REU0Fxa0l1TE5UUDBmRWN0OXpy?=
 =?utf-8?B?bkNoVTEvUkYreG9nQWp6UjkxKzZxQ29ZaXR4Z2lzOTlhNnJmV1ZoNGtONlRH?=
 =?utf-8?B?Y0FxdkFUb2FrZWw0TzVoSDRYdndmSG5nWkxmZjJmZmtralJuTDRqdnJZN0Zs?=
 =?utf-8?B?dlVmMTFmQktrcEZka0tOaEkweXBpd1JwQUM3eHJ2a0s4MlVkNXl4d081L3Bl?=
 =?utf-8?B?ZEZYM0lZOUoxeGRSUjlYeE1kd3FKTEtaUTJXV09VVXFzRy9xQk00QWlWUUFL?=
 =?utf-8?B?V2g4WkpxTUxOTXR5S2E0STZld01EZ3BzRWY0VmQyUWZFczRmK3BhbkVqL0pB?=
 =?utf-8?B?eGxTSllCclczalpEKzU2b0lBWFVkZlFic3Vaa0FPeVpOc2lCcndFelNXaXdo?=
 =?utf-8?B?dWdCMFprSG1TUVU4azFFYXhtbkYyeFk1dFgvNk5ySUlhdGovclVMNXhEeVBz?=
 =?utf-8?B?VzAvRHlXQiswZ2k0UW9ZMCtTWUFyM1hSNDFWZTIvY3RhalhWWFhSUERXNlVn?=
 =?utf-8?B?V1I3S3RwM2M5a1pRTDZGa0hwN2cxNjI0RC92NGpMUHJqZFFGOGFHcEFsSUI1?=
 =?utf-8?B?L3hMMzRkblBIeURNVlFxRWMxQWliTW9yaFc2SURwRTRaaXBpZHhGMmdDa3gw?=
 =?utf-8?B?YmVRbHBwVDRkRkdneUZybGZ6OHdBa0tONVV2TmluaFV5aVpBdXIwbEJjNnFj?=
 =?utf-8?B?T1pLMHAzaFlFVFhOWGZXc2lGY0ZUNjM1R092M0RFYTFYaFM2RUhaYjdpMktq?=
 =?utf-8?B?bHRYd2xoaUVCejg4QWNmM3dwUnYrTUJqL2pVWGlCcXk1UjRDK1hkNi9OaGpG?=
 =?utf-8?B?MUpSeWJMTVZFSHpmUHUwY0dHN2pWK0ZJcERmSXpoQkJENFN4cHBFbWYvQWkv?=
 =?utf-8?B?emgxQWRRQUZkc0ZCTEx6VUI5SUhjZzNQSWl3MkFta1dCb2ZRbmt0RU93WENS?=
 =?utf-8?B?WUtuNTVGMy9XTlBMQ0FXbUhXTVZwWW9USzNpb3RnaEhCN2Q0b3IrV2M1L3hG?=
 =?utf-8?B?czZqaGVjZUd0LzdobUhsN1QyWk9CR1NxeTRZV0NaSERrWnBvRXBFKzhKbyt5?=
 =?utf-8?B?M3NRQm04empiQkJtT1ZERVc1ZlM4QTMzTE1yWFhZbW80bTFEdHhJajVyNzJU?=
 =?utf-8?B?d29rNXgwdm0vYlRHLzI1Ymw4VUx3bzZzTjRXMmlDc0lWSmpWa3FDNDJqMmZr?=
 =?utf-8?B?YVFoSG5GYVhJMmJtZGg4dzdtMExkYlBFTm5haUZCUTJzZHM4d2l1MUZzR2pH?=
 =?utf-8?B?S3Ayd0Z2dE5iTytWYTZoRG5NRllOWkcvZ212L0M0NlVXcGFCZ1JKMHp4MWdZ?=
 =?utf-8?B?bGlWR1dpbDRWdTdEV2lDQkgwaFEyelI2ZlhvR3dQT2VralhUditDQnJTZ29y?=
 =?utf-8?B?VnpJNnZFM2J0c08xV1gzZUNZU3FOamVNT2lmc2NpM0dwajRIVGZ5aWpuVlRa?=
 =?utf-8?B?QlFacEh3Ync4Y2NkZm1EK2tOcExVb3R5K1pLOFpNNWQ5NnVZNTF5OTEvMzFV?=
 =?utf-8?B?Z0c0Rnc3a05FOENmZUgvenF1K3BUNit2eFk0R3c1NTFMQlRmTXdqcnFaeVZI?=
 =?utf-8?B?SnowTnBEbVFGb010V3hOUXNPL2hpcXY5cWd4Y1JnaHc5YVd6WUNIYlk4Yy9S?=
 =?utf-8?B?SDhEcDlRTmZWaloyQ1JHTU52QnpvWGVWMTlsZmJRZDZsR2pINVppK0ErTkp2?=
 =?utf-8?B?bXVUTEVFcmlKMnFic1NWcm1vcXhjZkVsNk1JUGxoWXJmSXhKRkVPS3pkMVNr?=
 =?utf-8?B?RUVjUnQ2RlFDTzg5YTNBYmFhZXpDaGF5T0JTSlJMTlBRamRtV0pGVGhPdFhs?=
 =?utf-8?B?dWhYaW40MGx5ZHowcitWTkpuS2lkQW5CSEtnYitTR204SkdGdy9sdkJYejBI?=
 =?utf-8?Q?XJ0Fm0pBlUI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cXNXN01LVkhDM1ZjMjlDZkxLbjVoKzVjL2pyQVpvU1JsRUNHTmR4azhQS0wv?=
 =?utf-8?B?SEFucU0ydTNicW1zaDJFSXJ4ZzFSZFd1cWxsSDZUWHNGTlVuWkFhTWswNTRF?=
 =?utf-8?B?TkMwOTZLTlQxNGwya09HUzhldHdON2toZlMyU29taUwzdDVjcmY0eG96V3ZS?=
 =?utf-8?B?UXFVenFMVlJDRitZSHhmZzdqMTlQbmQ2VzVLYUp6N1J0RzVOVnQvcllwY3hk?=
 =?utf-8?B?Z0lDckxkQ0tzY21oWHlFbFNQT2FSNVlIbUlEMHVNSVNFVTM2MjRBa0pOeHUr?=
 =?utf-8?B?dlU2dnVRcnNwMmttbXNmWER3MUh5SE5qanZycjc1b0NXK3J3cTNnZXlnZngr?=
 =?utf-8?B?WGhaM0kxelhRNXlBTHB6ZVU4U0RzclFINnB1WFZRTEloK2M2eGZqd3NmUkM1?=
 =?utf-8?B?eFhrM011cysvV1ZpZmhLeTcrL0dQcEM2d1NYcWl1QW9EM1lCeFhtNjQxZWZZ?=
 =?utf-8?B?bmFReDdkM2Q5bjJXMGFraTRrdXZBUmJ4SitESUt5Q0dROXlqQzhWUGk5Y0sy?=
 =?utf-8?B?OVRxdEpOR0R4L1J2eGxMMlFoZG5HbmJsQmFFQ1NtaHZkaWJaMUVaNWc2clZG?=
 =?utf-8?B?bHZXSW5EdjVCWXVvYWZXVlVQOUE5TkVYYldmbWVMYXZuWG56YVVJREs3K2Z1?=
 =?utf-8?B?aUpPUTF0QVJhNHNhSlBWRDVESHFGdnozemM4b2dCekVFVC8rK1FQNmV3ZGZm?=
 =?utf-8?B?b3ZHZHBHQ00yS0FOaVBzUG04MWZLSjMxUXNIMHlRakVsYk8yRDF6VGhXbFJS?=
 =?utf-8?B?Rzkxem8vS2RRWHE3bmRPMjJQTFVQNjJYSEpvWis2b2g5V08vODIzUXprdWdp?=
 =?utf-8?B?UlhMcnp2RDZJR2hFRTV0V1lualZDUVRGMGk0b3NTT2UvUThhM2JrRmV5U0ht?=
 =?utf-8?B?OUljdW1KaklVcFliazBkWTlzL1liOVVVSlNpYVJrMGdCWUJsS2NoaU9MTmFr?=
 =?utf-8?B?ZVg5Q3JNNFllUGRBYUpxRzBKL3BGOWgrL3huYWp1dllmQlRpS3Q3eFhEVkhq?=
 =?utf-8?B?MjU2ay93YmxyVTU0LzdIeWp1UXlNYkRNYncxdEZISko1bU1LSzhjbE9PQWJk?=
 =?utf-8?B?cFBjOUovbVVybXA3Mmt2ZVhtM1NFczE4YmlaZE5xTW1pMGhsSDRSRjJvbWtO?=
 =?utf-8?B?ZnZyeVlIbUNLcldDNEtJbEJqYnI3dXZycnlrRUx2VE04YVpEVzNVVU1nQ3ZM?=
 =?utf-8?B?TFdTbjJxNWxjVEl5NVVkdHE5UkhrdjRDMXdHZU5RclZ3YzdpL2JYTDN3YlR2?=
 =?utf-8?B?Vm5sQWhpMUR0cE1DU1lReTJDRmVHTk1Ebk92ZEdOdFNKSGNBejdabnhjM0xE?=
 =?utf-8?B?aWhWb1Z3R2pBNEU0aFpwN2ZxWmcydEZGS010UW9Qcy9aS3YzY0JaUE80dE1K?=
 =?utf-8?B?eU85Q0xJbk5lTER3dlJPTFVla2poN3NMd0szbGVjTmM4dmxPNUV1N05NTnA0?=
 =?utf-8?B?bjgzd3B2VHFZSm1OZGRRUFJyTEwxYklwaXZlcFNKa0F6VURIemZZbkJDcGFI?=
 =?utf-8?B?RUh6UkNCK2pRTmNSbHlmTGZTaTM1dDU2bHFIL05WbThtV0FtWHBUWFhmZFI1?=
 =?utf-8?B?MHdNZ3VHa25lbWs0SEgrenkyOUZZaDZWZEIvY1JwRllwVjZjVFhKVmxCdDhQ?=
 =?utf-8?B?VytEL2ZUU245ZXZIREF0QXErNjBIZGRzOENYNHFRcG5SeDUrMnlVbitaREN3?=
 =?utf-8?B?YWthek5pQkVnRkhtR09KN3ZLWStGNE94MytOWkxNaEV0Y3R3MGNmNVBEbk9x?=
 =?utf-8?B?WlN1SFpscFFsMXFzN1ErY2xYc29hZkkrUDFUNFo3dGYwZXQ3VUYvdE1jK3Zz?=
 =?utf-8?B?SFRKMmdZamZJMnZxYitvbU1lL1BIWU1sdXBkRWJWOXkvalh5WWVPNzZxQTBE?=
 =?utf-8?B?N2hXTlhndnhsZ2QrRnNUTmhSUGRYTzFRQ1h0ak9IdnlYUUlRQXFCOFhSMDNE?=
 =?utf-8?B?WG0zd0lsSzdWS2JZV0EwaTJIZkcxcFRiTFJ3eWNLUmYzUExQc3BBc3RRV0Z5?=
 =?utf-8?B?Vnp0N083amNuZVVneklCUi8zc2tHcC9KU3R6cjBnS2VhZms2NGpRNlBvMFhL?=
 =?utf-8?B?ZkRua1I4WjAvRDluRVU5TFlCa3dVbW9SaGc5VVMweGdIeERGS2hMSnRrM1pq?=
 =?utf-8?Q?LrHchNoFdr2x4mdmFWCKKo6pr?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kX60utOaG5H3WXH+25VXddm4qFcfaylYTF8C43Z65UK92muftVqyjLOTRPBlbruJ80hvYmymGuByBl70hxLaZg+DjzwLqg1M60C7qfKAb7Jgwgz1IkidX+Lbh49T5ixpCbXeU1yS2XT/xYAygoyGhHzmPqBfN0Y4wcvmAX2yqgEJLwJNVo1TUQaIbdNWTBQZKJ+uzqCYnO55DFIFsKD+Btn+tNMia0YCo6IDTEQr+7uCEbiCGQmv4muycOvIOy2HO/3zTz8uHWccjLTKUOTFql+l74wbydh8/XL12VNxVLTuTEx1SEADB2wjViDrtihj6EGsYQ+RWAy9oLm/pQ5Kri0RrnumKFoP5ECp3vLMzsJAYmVhSveYMS2ijQGXGE4WTUZ2mOXxL0K+vQPZnT8ySxkRYr7g8d2vA4KzbDvWI64tvWyzh++XP//k1P/si/K5ExXUNXgZluAi4wZeyVI8PWEux5HfneXKeHckzVKMnBa4Eks8+SdtA4MYBa2JxEodVemlmJ0qKSYlrF2kKeB8nBU9OcAd+X7pdyBlsjGq+h/7NsBCN6Pj2X9rNA0uZQ0L15qBGBcg4Q0wQI2Xpdh6YVaTs/mXt5dbOy3yLn82Hy0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f227579a-28d2-4c3e-e749-08ddc43b67f9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 07:35:58.6239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 10rCCopmxu+2h0vOLNaGdfNBh85m1PGxlXAq+Z9P3WY+Q3MESUZHka7BBqBaIqVDqgyDQ44FEPjAh0N1zfuapQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4201
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-16_01,2025-07-15_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507160067
X-Proofpoint-GUID: UoUvCwyjv6AmOnEwfOenhG1Cm4yT9TgP
X-Proofpoint-ORIG-GUID: UoUvCwyjv6AmOnEwfOenhG1Cm4yT9TgP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE2MDA2NyBTYWx0ZWRfX+fMHrc8pIrGz zgogty+bGQmpEcE0xyTLyQhWtiQDbNLEz0GB+pgwm21sxs5Hx2W6X7Cw4PLHAbiqkd7WPbMb2Kc oWjU+HW5t1Hmro+Evg/f4NcQ6/zAgJLi+qg77EFy0Vzn5STxlvZ6oYZ8Zi6zssIEcOpkxsf9o4X
 yyj/5f0HJqp8xvjL4BgAsSLdAETrj51rHz8MzMzrN8ZypnsmNEmxKJrYKdARffvdYpt/ZZm5ye2 L6wJ9tA6M7Bydc2q3DbMC9GNxJ5dGZtl84FrWLii2FwwamJ5IaFImRoyq6HInEcrwhuy6lYjGEH IuJ6wNYPXUZvlIptJMjzCdYNlTqgaH7p55li3NVIY8jYvG0Fd7mzwdWWul5aboCCxkZGSCTZj+I
 HN6JM5ZoierJsO9Sa8HO0fk4N7DdyIkO/r2amj8kp8/odOt3kIOhGHY7GP4tOaSw8+I5NoBP
X-Authority-Analysis: v=2.4 cv=U9ySDfru c=1 sm=1 tr=0 ts=68775662 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=oZCU-0wtCc8xSIBNLDcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12061

A friendly reminder on this one...

On 09/07/2025 11:48, John Garry wrote:
> Building with W=1 reports the following:
> 
> drivers/md/raid10.c: In function ‘sync_request_write’:
> drivers/md/raid10.c:2441:21: error: variable ‘d’ set but not used [-Werror=unused-but-set-variable]
>   2441 |                 int d;
>        |                     ^
> cc1: all warnings being treated as errors
> 
> Remove the usage of that variable.
> 
> Fixes: 752d0464b78a ("md: clean up accounting for issued sync IO")
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index b74780af4c22..30b860d05dcc 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2438,15 +2438,12 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
>   	 * that are active
>   	 */
>   	for (i = 0; i < conf->copies; i++) {
> -		int d;
> -
>   		tbio = r10_bio->devs[i].repl_bio;
>   		if (!tbio || !tbio->bi_end_io)
>   			continue;
>   		if (r10_bio->devs[i].bio->bi_end_io != end_sync_write
>   		    && r10_bio->devs[i].bio != fbio)
>   			bio_copy_data(tbio, fbio);
> -		d = r10_bio->devs[i].devnum;
>   		atomic_inc(&r10_bio->remaining);
>   		submit_bio_noacct(tbio);
>   	}

