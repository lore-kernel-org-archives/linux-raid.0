Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CD9201261
	for <linux-raid@vger.kernel.org>; Wed, 13 Nov 2024 18:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731521910; cv=fail; b=GdKJfbVVTwd/OeFOh4JJXc5/TrE65SdPiGUKXTwXKVOqwI/45IcHgVz/7YEaYPULVuZlaFyahbs7loGAPVY5u6/0WZxKHsG/DDMTrQBIycIchZ49P4a3Hk7VdrATb5JTd7RE6bjTDH1pWOeUnoiESbQaETR0wKmhvShT7B49LjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731521910; c=relaxed/simple;
	bh=+T8NYTiy+W5BLXbZfkNoUo85+f6yZDPVetrFnvc5QOM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OBlS74y3+VlblvmRAUbXH/1yIj8ewvC5gbcAv7WcSs3mciKQBO9XSK0K9fAKAlIfWS63YEkKZ49g4zBU6s+8DJSmvfMIGQuzcmTSOkYgfAGkIyFnzXqTB/XKlNMmJTM0X+M2G7qGX/rYSkjxu9lWhekqESB6qt6LRXdo0bKaoh8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y7pxEzgH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Eq6HNDN/; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y7pxEzgH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Eq6HNDN/"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ADIBXDt024501;
	Wed, 13 Nov 2024 18:18:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=DRfDg7aHjdBwWGpvQk4yfJqh5opjm6VBw7L1qEDPilg=; b=
	Y7pxEzgHYf9sZNiJwEoFN1jte1M9xNT2yNxy8gCz8Lm0Al23iQIkkBYdx9A8Yudm
	BEJzt22+Z3vrCzZrurIihhG6WL8za2K2z2Qs1luewwiHgY/huaDa9pxpgO/ZK0x4
	L7dBe06eK2+NDWEhzXRTR/9BE6rWJCEhFl6+xoC1jr7fA5+IhwNSBZ7868Sh10hJ
	1nAA9c+kXCeyZLrdMlq2Ny7rRWoC+1RPtC1Uwhe9iN+8q1rcKbCzvgIbc3i4ky6j
	qABxK1lirNAZBtwNfJr45QKtVlPe4k5MibtGp8K+xvThjgDxxyCwKs+zazb28IWA
	SGheAbbmGOlJnAxn7FNicg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0k27frk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Nov 2024 18:18:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ADGgHWd035920;
	Wed, 13 Nov 2024 18:18:14 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42sx69pdvp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Nov 2024 18:18:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nERDmpecjejHkXYpviPxxv5vyIeGA8jeQPSgumbf146b2e2Q1QNFxrKHgi8uNGviBV5/fnItrUaPsOck1CCd6rvnzANkWBeRYI3Mr00RAVECukJep2GT5OT+jN1Q51dQvcxQXhNSVABayxgBdi9cTrrGXURfjPzyF5qmP4C1/RqMWxTJQ/WXsQQk+Z7isxUlqMSr70Zyx7SNFKuW05SgMm6qwZd+D5X5T8//BvdIObWTTazh8riyEA4jF2PO7juafyLKYbMXQ6aessCMaj2oaZv8iBWpzST0RquIEnxahstLLJv3jXKVJ+szeovh4OgHC6N7Y8HRVPv9Tm9uw+yZyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DRfDg7aHjdBwWGpvQk4yfJqh5opjm6VBw7L1qEDPilg=;
 b=M2Om9+458ODyyGGbL1a5M6UhqzxNQf33gGbB50sb5qG9HtYcV0il+PJpfkSriDAbsfRceyNToghB789FtG049j9Z+2FtMQvGoBVjzv7Q+e528LaPjaZA7cSRzmCYBS9YSp2zBqK4XOelW+6f1/6beWHeFScD8+1PBWcGx1fKJCDovP5rNjcEbxX9/DYt7gN6JOlmKtkpDxrZxDrek2bGulZexaU9Op3W5ujOTSXBkZ7ljS/lKtl7Cpq/ZwY49xupn4LKRS1KdVOW101bcykOyJfUbgSXOQ4DVKqVMtVIt3FR18lSHaiWwG7llpCPISQUBhigyoxg7AgMfMmDjR2V/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRfDg7aHjdBwWGpvQk4yfJqh5opjm6VBw7L1qEDPilg=;
 b=Eq6HNDN/YCFpeI6fLRCAyHGjKcGcDgLl3BNfafYELygK/VHkk1KNywk2aAs9VYqqzto63VKCYF8/SyCQcPQXaLZ8+JXiJzNXGxOqOOb50wP5XXQ4/QknrYxMD5SofhoZEh3u1XMhv/otA/le1ZqtTzOX9dBLkij45UVcWtQPSBM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA3PR10MB8041.namprd10.prod.outlook.com (2603:10b6:208:514::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Wed, 13 Nov
 2024 18:18:07 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8158.017; Wed, 13 Nov 2024
 18:18:07 +0000
Message-ID: <4c544e1c-507c-4d04-85a2-d6351903de57@oracle.com>
Date: Wed, 13 Nov 2024 18:18:05 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] md/raid5: Increase r5conf.cache_name size
To: Song Liu <song@kernel.org>
Cc: yukuai3@huawei.com, linux-raid@vger.kernel.org
References: <20241112161019.4154616-1-john.g.garry@oracle.com>
 <20241112161019.4154616-2-john.g.garry@oracle.com>
 <CAPhsuW4JstsuyDnXfWuDocr+uVfq72SnmF82f-6KBy2tu3-XOQ@mail.gmail.com>
 <fcb1399d-d28b-4e89-be9e-d260f05d6c8a@oracle.com>
 <CAPhsuW5DC3aP8p3gMWgS0H9eGBzfNwSWOJyNCBK9Syf5Ym2nJg@mail.gmail.com>
 <46c9b171-25bb-45a6-ab4c-990815f5c68b@oracle.com>
 <CAPhsuW6SXTQeh0AESqk_E7c3FceQgQyPwRFUce64sFAmHeVQcA@mail.gmail.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CAPhsuW6SXTQeh0AESqk_E7c3FceQgQyPwRFUce64sFAmHeVQcA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0023.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA3PR10MB8041:EE_
X-MS-Office365-Filtering-Correlation-Id: 48496691-3520-4011-288d-08dd040f85e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RmpKcHZ1eHFVdGRkYkhsUEFqcUF4Wldja0hhekUyVGNydXVzSS83UmlPeldW?=
 =?utf-8?B?eEJ4YlFDN3NtMDVrbVllQnhqbmZyYmJIbWwwR2JtcHNyaTY0NXFiL2R3OGNT?=
 =?utf-8?B?VzhlRllqb2tLNVdDVHVKeWo4YXk3d1FnSHllNE8xZ21lcFFzNlVuR2V6QTBF?=
 =?utf-8?B?VWtiNnNoNk5oUkQ0R2o3NGR3K1BQTzJOR1h0dUFsTVB1Yk14Sjh5dkZ4Q0J1?=
 =?utf-8?B?WWxjYVRnT1Vsc25uNU5XYjBoNERwSytxVjJMYjhYM05lU3EybS9UcWJTb1Ir?=
 =?utf-8?B?OVZPUUNabUtnRmsxUWpBdWJLK1FXTHJOemFkbXkvbUlWZklxYkdOUjI3RHIx?=
 =?utf-8?B?VkFCN3VIOVM0RkJuQmI2WEhCVnV5SU1uTFE1MkdueU1mMk56UndHMUUxTUJo?=
 =?utf-8?B?TE9ySzhhR2dDTW5sWXk5WDJRUlJsclN1VlhoWjRHQUFXL2laOUtDR1gwZ3Fh?=
 =?utf-8?B?U2g0TnA1bEErVnJzaEV2WFFubHp1TFFMeXpjc0NNaSs0REtqT3hnR3dLSEwy?=
 =?utf-8?B?WmlQczRZWXBLTnBKVVgzQXBocm4xRjg2MjMzMG5IODNzYUcvOTlDdFFxcUly?=
 =?utf-8?B?U2Z2NFBkNCtpN0M0MGtGTDMra2Z1Z1hhNWw3TEZSZng2dkxuM0FWakdKRUFS?=
 =?utf-8?B?UUVNMXhjaW5jSFd6ZFdFRHhvZERPbjI4WkJTeGpDRDRrajFSVU5seStuOXE0?=
 =?utf-8?B?MHF6TmNWZkZwdkhrM2I4dnM2RG1kaG1YZmRyV3dYKy9PKzltbm80TXFBaitv?=
 =?utf-8?B?eEJqdGZ1QWhzQ0JhZU1EQkdld2toZW94RXFNcWh0cEJaTStPY1lBVzZwV094?=
 =?utf-8?B?YnJEdWY4T3dZT2NicmlKK2pUSS9tVUJoc2E5RlBhS1hHc2Rkd1kzZmpFYjhE?=
 =?utf-8?B?WW1ibTg4bmd4REJMdTBYSkU1NnI4ckxpdHBDamRzZEJhNjgyamU0RlNFK2pX?=
 =?utf-8?B?anJGNWtlQkwwOEtxNjdFN0FBRGI0MWttRUhYWFdwY2x1MnltL0wrdVVBeDJr?=
 =?utf-8?B?UUt3SDM5R1Vub05lQUsvM3dXQkdrcXhzdWtiTWlyamgxZ1I5ZlEvZUZmQUpU?=
 =?utf-8?B?R0Q5dmJaSFVsc3BuQ294NHQyZXk2Z2tzcEUvRzRVYkdnTWd0ZkQrRVYvT1RL?=
 =?utf-8?B?QlYvMVRsRlY3NEpuYWtnZ2YxaFJtc0RLQm5Da242UnQ3bHFWdlV4YXZKQXFD?=
 =?utf-8?B?Y0F3cFNFaE8xeGlHV1FuSnVtdWh5M0lpQnNFS3g5eHpKcTU1ekNNem9PV2o2?=
 =?utf-8?B?MklHNGxoUHB2b0RCZ0gvN0w3RTRzQWdIeWs1bXJNV0ZTZVRnOWZvV00zamJD?=
 =?utf-8?B?R1pwMU5mN3E5NW9QM0hzOXNQTlZvd0ZlVFpRWnVqTzBaU21Lbm55QnNOYnZH?=
 =?utf-8?B?OXdxemYvRWxYUnlFQ3ltNTh3ZUVSck5BNjhFb2JQSDk0ZktIUmJRdVY3N3JB?=
 =?utf-8?B?c1hIelRwKzIzV1g3YUgxNWNDYWFobDlRbUNqdGRuengyeStUUVg1dFA0ZENz?=
 =?utf-8?B?TU85NjJFOVNzVHZaUE9lNlJxTDVzajU5eHU4eStNTmxyWTBWSWNBMWV1cHZ2?=
 =?utf-8?B?VUlNQXhHTXl1MUxPNUs1b1cyWjYvei9TZ1p3a1VXUVQ4S2NOS2NtbU9VczVN?=
 =?utf-8?B?ZDVuMFpFVkNVRHJOZFJ0Z0ZSN1dpZW1ZZ1ExdjYrQTRpZGVCem5hNGlqZVlw?=
 =?utf-8?Q?t8ARfVFtzWoWgM0luUl0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bUJOaWozdDl6ZkdKcnExbldZTDBGbWdFT2VUQkhsMzN5bnVLRWNISDkrTFZH?=
 =?utf-8?B?NDlOc2FJMVdYT1dRdjVVZHFVRWN6RmRhRlA2REdlVlJFajdOYUsyaVdqakEx?=
 =?utf-8?B?WldWUFJVYWd4ZENPdWEwUGJxdnR3ZVRYYlFwUFZFQy8xdXVLdHVNd0hpQVRv?=
 =?utf-8?B?RmozUkpFZ2NDS1p5ME9mMjZXYWFrNExtM0ZwTVhDa3E3ai9Ua1lNMnBWVnYr?=
 =?utf-8?B?cHAwbkY2TmUyVmdMNDloVHNjUVR1YTUxQkdvRXRaZ2Q1R0NIaFZnWWM3OVhj?=
 =?utf-8?B?dUdBY20yU044bkY1WU42WmlDaWJpUDNMSGthRVNXOUlwbXMvaDE5SGxWT0Vl?=
 =?utf-8?B?K1BSbG1GbE5haVJiL2w4VFhEcmJGU3BUd21LZFREZTBHU2VPK2JTbHMyYy9J?=
 =?utf-8?B?VlNDRHZKb0NxWUN2RFZwdDhrR2NHTHFBcTVYQlpNaW56amx6MWczamNLcTdv?=
 =?utf-8?B?WTY4VUNYOUZQTjdsdGdDcTZqc3plcTZSWkg5L1puaXZwZHR3bmtuMkRIUjZ2?=
 =?utf-8?B?NThEa2J5WmZsVXNqbk8zQmplWGRlMVpJNzVzL2JGTlNSNW1vKzBKRnpZVTd0?=
 =?utf-8?B?OEp0eFZTK2xGOTU2TFFDV3h3Sks2T0g4TnUrUHM0blRKZzBuY09nQXlHTHor?=
 =?utf-8?B?c3VUb3pOWUxyN3Q0TXd5VUxOZ0FlWHJRV0p5YXoydnVwR1hBb0UxRzdvSlk0?=
 =?utf-8?B?eW9WdlRjRW1kcEZsUnRRaHVFK25VT3VmRW05Q3k4MU9vNHhwMWpNMzRwUlgy?=
 =?utf-8?B?Tmg4bjA0V3R6QmZMeURvQndRWjFyZVRuTTNRUmtqQ2U1Ynhybm16ZG1XS2VN?=
 =?utf-8?B?empzUjRraUdrSmpobUNLRi81ajMwMHNNWWJ6SmVjciswS2hRUUl5bXlmc3Fs?=
 =?utf-8?B?MGllVU1JNzg4Rm1oaUF5UnAxVUVLOFJpREVETUprcVo3a1UyOEh1MXBlK2l6?=
 =?utf-8?B?Wnh3emVWaWk4elo5bGFGWHEyb3NJcURieWF0MWlzRTNqVVhNN0hMdUlFc0Zq?=
 =?utf-8?B?d09ma3ROOHA5OU0yQXVJTWtscTFDTUE5dUhORWhybHV2RVk1NUoraWZUdXBo?=
 =?utf-8?B?TlB0NzMyM0tjSVlWcy9ITnBlK0pWSEZwWjNzWDc4MFl2N2xnNm1zczdZVFNB?=
 =?utf-8?B?elVZR3l1dzUyaHNWRStRQm94b1E5UWtyWmIvUi9FTE5iMmFNclJxeWZFSmFm?=
 =?utf-8?B?aEZiN0tQYjZOSXdwdXBQWk52MnlEeHc5NTd4MGxhWS9yQVBvc3NPV1ZkUlEy?=
 =?utf-8?B?bndKenh6bGpscS9HOGJrY3NaT3lpTTNoT2R0a0drQUF5cWwrTWJ5eis5Umdw?=
 =?utf-8?B?b1pKMDdpZEs5cEhPMGlzWnlKeUJlTUVwUDU5RHYva2Z5U3RSTzJJNzVqNHJ0?=
 =?utf-8?B?aXBBRk1LTEZqR1dZNmtjRWJQS2d3MllUaXllRFRBT0huYU1wVDVmNlFYYklX?=
 =?utf-8?B?MHF0ekxGMTNNTzB5ZHBjaG56VkErT0tUSloyMFc4dEU3WTdzVVZUbFhQa3VD?=
 =?utf-8?B?UCtGbTFjYUNiYlZ2NTJhSUwxcWVkeFY0RGExbC9WQTBWUUdENjVGbVF4cUdn?=
 =?utf-8?B?eG9RZlEvWU1xWE1XUzc0Sll3WFFzdjNiZXE3Y1U2VXBoeWdLZEJkL2lDTzdE?=
 =?utf-8?B?dERhMlJUSkM1OEFuM1ZIc0xCTk1ZcEUwcWJCWU92WWJic0dzd0I4SkY1MzVt?=
 =?utf-8?B?RUFNdlVLTTZvNE16NmxGVm1LTXo2SDN6OUhLajVidmJaOXd0NEZsYzBLaEFL?=
 =?utf-8?B?TjVFdUw0U3pUZkFpQmtMWkwzWi9kYkgvcEhjbXBoKytwWm5PUGJ1RGpFcjhE?=
 =?utf-8?B?aHg5TnNhaUdvc1EyOVpTUWFyNys5cjM2dURmQ25OSzZMNEtXbWFvMUJHRjRG?=
 =?utf-8?B?VGR2STRIbUFQTU5CVGZuT3ZtL3NISGxHcEpQeDZOMFdoMy9hem40eStNNWZ2?=
 =?utf-8?B?N1FLblVEcVNnSEU0enJvcnBsYzRJWndRUEtCd3pIdUp3TkpVMDExanhvOUU3?=
 =?utf-8?B?RVNZVG1MK21ZOG9mYjZuQkJBdXBuNjgzLzNqL3J5anBtaDFQVUNjMVc2VlRI?=
 =?utf-8?B?STRCc1MrWHIySVBUYVYrbm84cUZ4emRHeDhKZVh5b3FSTXpyam50T2ZsNmly?=
 =?utf-8?B?REhOd3orbm5JUy84N0dVQW5SY2taVTJJWGpWMzFDRis3WEplOVNpczNUWTRB?=
 =?utf-8?B?UWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UM3D7bHE1+aAIFW/PVNYyNjUMt6kVTC0G+CrjpVx+J05ObaT05UFapbM1TuNpqeRZdLuDLXJb8X4km016cMSOHN4MFx8wlBynVrQM5FTkW1AhPdLd3k0JEMPw3v+J1QthNKaYZnfq/2fMNuukzdv+7f5FYAEka3aJFxGJod0l78rcMH4tfAV9kn1vIGbVH1/G2OIcZk/XO8q+FZ5207YA9z6CxCg6xm/w7maAzEkkiykFKRDHrfqppEdrr+5wI71IThZffmXv8TSrlSvvqL4eWdEDfbqCW5DMSf7sVWVyBbJKml7Yeav9d5khL1rja10UKVPkCMTY4rDj1+r7rDOT5xohJWbn5hPJDpGTg5Ez7lwrBXGFNBayrF8BqAVS/qzEYY2+05n2Oi4f0QAGtn98wRP74CZA1pTZgFDakoMKej8YGkip2cZqmGGP+BN5RMbLH1Ac6OUxIi6sNKmpES43bXKGdAiD1+ybyQ4XVWD3Gw+wuUTBh4f2UahQp9FnVRPaLjLco4nuPRdy8IECwu+MQfBHfpzQ9JGQw+xeS+izDqBdG7A7YEQfzX/bpQ7kTAIOO6JdhRVFlw8PLhf/jphCgA07ouSXxD557RLnu6CG1g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48496691-3520-4011-288d-08dd040f85e5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 18:18:07.6545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ROsbGMTvjk5QRNRWkL5NpyQ4bo3DaaPCUEcL+Ppv/xnmbUAco/4bizX3/ZYqyIqXjTPoYc9Te/PmzWgsOdYj3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8041
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-13_10,2024-11-13_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411130151
X-Proofpoint-ORIG-GUID: TSIAN5-YYCewciqIoLfSfaETynTRGw0f
X-Proofpoint-GUID: TSIAN5-YYCewciqIoLfSfaETynTRGw0f

On 13/11/2024 18:15, Song Liu wrote:
>> And let me know what you think of 2/2, I am even less happy about the
>> solution there.
> 2/2 will go through the device mapper side. Please refer to the following
> (from MAINTAINERS).
> 
> DEVICE-MAPPER  (LVM)
> M:      Alasdair Kergon<agk@redhat.com>
> M:      Mike Snitzer<snitzer@kernel.org>
> M:      Mikulas Patocka<mpatocka@redhat.com>
> L:dm-devel@lists.linux.dev
> S:      Maintained
> Q:https://urldefense.com/v3/__http://patchwork.kernel.org/project/dm- 
> devel/list/__;!!ACWV5N9M2RV99hQ! 
> KdbGHn2DKjuTy6kVmIAkHuremU7VP_2xxwX0e0r8X-3bOEa3FJiA6YnmzXBUbvRTA51J9UGUubVTFnw$ 
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git

ah, ok.

I'll resend.

Thanks
