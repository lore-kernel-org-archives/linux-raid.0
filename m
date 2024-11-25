Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF2E29CF0;
	Mon, 25 Nov 2024 08:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732524948; cv=fail; b=uyGPRqLx2kukM+NmrjVmJpvZ7qpx7/5Bvf8avHIA4apegv474Feg3GmMF+JdzM4djGaNzVSVg0424s643eJPt8Ch8/a9IrjGi5eQyKH+JkNCqzVHpXquLwtQf9e1ZR0s6wzjJVNUmaZZ/+/5tNZ47rSjSitKgwbJYBQ4voJgbIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732524948; c=relaxed/simple;
	bh=iP4Hsmy+joDT2Ld2+I4ZRH/8jlqJoDRzx+436FnJ2jg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nkGFySg6W2oitErM523BwBEGx9NSgipLqOo72Pv0v4aDTbRfW7sCzFMQjg5sGOMh0ALJQtyUYkUUzggem40+Ifpnq89KC22c7K0dpf08Jy/JdR0k3SNvfVuKMC43lzjcY07o/9jhR7DOD4ox1fz+S7CUCGFb3WKOQ4n8pz6aicI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PV8BDs4p; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=g+nlDwIT; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PV8BDs4p";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="g+nlDwIT"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AP6fgZw032623;
	Mon, 25 Nov 2024 08:55:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=AA/Z0ai8qAo+vM5ooRosoJgZ5Jog/3QspASYWirKfok=; b=
	PV8BDs4p26qhDameTBfCXvrFDgG74de/DxEXH1ga/yeoheT+3Sa3zRFTFyg7nVtf
	wIr/iKmwMI2sQXWm8/n+wjbhgU1K+N5H6AYfT/WQnwoT1QS3P7agfYjsoBn5e8Oy
	uJp5nPvuS2zduWDrPRIsX6YoVpIIPm0B9FMB75WGvotIoJbRN7djX+bXN5zcnLuz
	30E+2FdaVxIk5m//HMBqepYSPG1CLvvNXIWXhJpXF79pNoHE7K34Nk0QljRmrZyk
	4+0v6joPr7APEuJAt2ORLYkJCYP8VKcJtORGMYC44BjaDwgX//5+kW7AE9zH/Pc3
	h/7hf2g11ZktGcqlksVtyA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43385ujm3p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 08:55:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AP8B40m019197;
	Mon, 25 Nov 2024 08:55:24 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2043.outbound.protection.outlook.com [104.47.74.43])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4335gdqhqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 08:55:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J6TEe+8NTbA7Za49nEihH2FT1+Dit+JSJBz4xP1SHg0Ll6j+laOi5nH5uGewZy0eE8UsyrF2hemf5G5ylU+N0OqWJ6lL03DPXVLdV1sOzOkKi1nM+Eun/sJ+nS5QTaxL719b6bqYNlW6spjH+FuV+yDTBeYJK2lEbLmUmAbjJgW6JFazKRiKMLeDBq+iKzvudDwGWjTiuX+g8celxWB8OWBGQYJd/pPRMX1jtFDEz1L23CRzmH84UTzcfyeZo2/1nfFk96XgCck5fzsKjUgG6vE6Kfv4ZYU8idpI/UU2FTOKdYysUyNYB7PNyGJ6sixbetbuVrrpRX4AIJCYG08awA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AA/Z0ai8qAo+vM5ooRosoJgZ5Jog/3QspASYWirKfok=;
 b=nn+J0uc3WpeZJjf3HN7mnf3zPCrN6+XmKSFqb0LCmXgik7ofzb8tBQWbOfs1Uy7soi/l0IoL60USgzXe1KLzaCUO5PrQs2RCcBUG78KBYq4+hVllbDmRKu6hnRSJPZtfVJFtsVhU2aAKkGzMcC02gnCZbYSI/9uuJSmV/pmC6ZalMcrzvVtbo1euAEWRTmhzAflqs5mgm+vTqYYvG8MCQVO3t1UkOFUxrHG02TNveDLMOGGboPrK2Yj+MurzvvLzcjnzgWDo8LgpcH/1FYVOq7TY61LzzAEoWBDT/R7caB8BqdTX0kv9xFUGyqefWpO/czPQQwK2q9vctbyCMgdiqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AA/Z0ai8qAo+vM5ooRosoJgZ5Jog/3QspASYWirKfok=;
 b=g+nlDwITpHRl/r1eKvzHVt/44iFXOaknwwh1ZiR9Qfn3k1LM3RylR+v3ysqFiOmr/SdVVEk2aSJV7KSucrMjhmb5OZq/4FklkYewexLwgH2gOc3c+RxjdyUEawYVlpsdpv9d6/N9kmCP1JwJNyRK532GC+JTdnsaDuWqXvu2BA8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY5PR10MB6046.namprd10.prod.outlook.com (2603:10b6:930:3d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.19; Mon, 25 Nov
 2024 08:55:22 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8182.019; Mon, 25 Nov 2024
 08:55:22 +0000
Message-ID: <77b6928d-020a-4df9-93b0-fef8ef38e891@oracle.com>
Date: Mon, 25 Nov 2024 08:55:19 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 6.12 16/19] md/raid1: Handle bio_split() errors
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc: Yu Kuai <yukuai3@huawei.com>, Hannes Reinecke <hare@suse.de>,
        Jens Axboe <axboe@kernel.dk>, song@kernel.org,
        linux-raid@vger.kernel.org
References: <20241124123912.3335344-1-sashal@kernel.org>
 <20241124123912.3335344-16-sashal@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20241124123912.3335344-16-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0516.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::23) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY5PR10MB6046:EE_
X-MS-Office365-Filtering-Correlation-Id: 0148514b-900d-4e76-00d9-08dd0d2ee511
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b09sT3NmTnJBQ1VlNk9uVkFBSHNpamJObkNnTGw3Y3lwTXR4UktpYWhBNFlC?=
 =?utf-8?B?UklJdVVZaGdWdFc5bDZrSkJsaENQYm85ZU1DcjZCLy93YnVDQk5JeExkVFdP?=
 =?utf-8?B?UXNGZkk5TzJKNUJ6YXV5WXJSQmpudW1mbXk3aWJsZnpZd2s5bktoTmlUL21j?=
 =?utf-8?B?VWVlYzFyaGhLK3hUTk5hTlFuUUQ4TUgxWUxTV1dqSEFEUC9QaEVJMlMrM2Yv?=
 =?utf-8?B?Mlhjdy9rdE9kUTVocVpCRWw2M2M4c0MwaVFpVnZldGIrNi9PSjVmd1VtdzFT?=
 =?utf-8?B?Z003eVJZMTJHeTd2RWtUUnFEYTR1Q3ZucS9QRUc2d1hWNTFKTW54clVnbGN5?=
 =?utf-8?B?Q2ZhUXZhQXh5WXBoKzlFTE9SVXk5c0V0OGQ4Q3dLUHVKZ0NmY3BRRE5VVW40?=
 =?utf-8?B?cnFETW9VeERTVUhwWDk0Z3FQOXNIditWZU1STHhBT282TDJTOEJwUHJPTzZ3?=
 =?utf-8?B?cTdWNVlHdWRYUFVvWnRYbjFrc0dQcnFSSFVUZTVuUms5Z2t4Nm05cUR3Rkxr?=
 =?utf-8?B?Ym9kdTgrNmE2d3ZIbXpLMElBL2R2Q0VsVmplTmVBNkMrMkxxcDE4VWx4VlJT?=
 =?utf-8?B?TEFrdTBsaHhRRjdrQW9OSzVoVTk2eUsrK3JrVWZSTDdoNWhXdWZQdThvdzZm?=
 =?utf-8?B?RWFvdi9wR3JPTktNZTZhUzNNaEh2aHJ2WE9INWpBeklwbUlaQng2U0ZwVnpy?=
 =?utf-8?B?T0k2Q3RmeVRZd2tJZzcrTXdadkg2c1NNTkRNcGQ2akZUUEJ2dmQ4RHNiRlJv?=
 =?utf-8?B?cSt5dE5rZmZnOUpKZnhEMU5YajFNaFVNNDFkS1FmSzVnU3dhY2lKMUpBL1dV?=
 =?utf-8?B?L1k0bW9OOUZwbW5iblJROSt5RjlNK0dzaE4zVEQ1cEY3SmIwdzlMTXE5dzZS?=
 =?utf-8?B?Q2VsSEFOUnJKd1FvVFNudEhhNXVnbjNOd3dXSEh6MFQwWC8rczEvRDZJOVRn?=
 =?utf-8?B?WGZsdktIUnpUV2hjVmxJSkxDMUs0bjNuQTU4NllUK3dYeU5sZ1ZZaEhpZGFF?=
 =?utf-8?B?OS9sRjhma3QxWVh5RXNvRko3Ukk5Qm1UZHN6ZlpzME1SQjQ1eUd3MkZqWkR5?=
 =?utf-8?B?NGhBU3lONkJVekZpcS9YRGpndTlzUncxMjdtREpnREd1ell6RzFNaXkySHRR?=
 =?utf-8?B?dFgyV2xGTG01SXFiN3h2d0cyekRoTDI5WG9WOEZ3Yk94Q1ZaL3ZYSmp0TCtM?=
 =?utf-8?B?ZE5EUmdTTkIvRWwxRisxQlg4eE53TlVkT1hsN1liZStuOGFETzUwbEl3TDcz?=
 =?utf-8?B?eHo0cHhRWGtvdTlHeU93QUtzQU5acWEySFFESzRYclMrRHhoY25YQ2tlZEJz?=
 =?utf-8?B?cEdXcEVVN1dYOU90ZVlqcFk4Q3podWpqVjNnbjFVRDBzQkdsVVhGQXlFVThG?=
 =?utf-8?B?S09BRS9PTjh1ZVJDNFVpdnpaUjUvTG1ZSHU3SmtPaXlFdUQweUN2N2pERVAw?=
 =?utf-8?B?SzhrbnJ0bWx6Y0hYV3pYRlNkaUl6Nkd2OEZNc2dxRkVTc254VjNRV0x3TktF?=
 =?utf-8?B?UVhwQzhNUHA5anVNUDRsWGxMd1VZWWV5MDlDYjE1QnBHeHFWbDBZTEJVbERZ?=
 =?utf-8?B?emU4TEgzZit4VURhWmNZRG01RXhZVVJuUjUxTHVCZlZTQjNSSllPUlB0TjN3?=
 =?utf-8?B?Um9ZcTV2UEpPQlNjSGFRTVQyMVlQSitNTVd0ZFlGa09UU3BYOCtQQTJHS2VH?=
 =?utf-8?B?SFpRSTBaTnFhcUQxbjZveHhXR3JJemZFSlFVam1ML3hzV1JBMjdDSHk4VmpY?=
 =?utf-8?Q?k0CPJoKiGgolrxfbOE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OW84cHBlZjRGbkN0SWlpYVBmaFRLbnh1YVFreHdTZWJwUXQzQ1VobU9jQ3Rt?=
 =?utf-8?B?ZjlDaEZ3SnhRUjNQTk9QbDFmYUw5Q2NKOU5SM1NlQ0dNYVVabWh2NlE3M3M4?=
 =?utf-8?B?dXNXdTdjWk1QUDlSVVBRZCszKy9ESEU4VTBuQXV2TG9iYXBYUmxCV2ZjUHd1?=
 =?utf-8?B?ajVFSlErY1JMaDZIVlI1Z1JMcllMUVFrWGJJWW5sSlRaalRMdzAybFdZRmVQ?=
 =?utf-8?B?UW5tMG9XYkI1RXh5b25RU00vbVVEN1NtYjNCc1ZtRjhIY0grNjBmRmY2MUov?=
 =?utf-8?B?VVhEKzdrSCtaTW9acGdiYVljeTJ6VDBUWmswdTBLZ2lVOXJUY2psbDZzR2V3?=
 =?utf-8?B?RXJJL0E2L1dpeEprNm9tdVFXQlBiK2hJaUpCaWNXcXFJbW1xSFBmSFFpQXly?=
 =?utf-8?B?U3VaU1AwWTUxOGNBdlgwNkJ6bHNFcUxKVTZWd2lkVkpqa00zMmI3STRqNDI4?=
 =?utf-8?B?N0IyUFdoZDhlR0puZnliKzNsRlltZktIcjh3aFpQai9JbEV1TkRhTE1wSklB?=
 =?utf-8?B?VStoUklPVmdBc3NoS3R0cVVEVVhvL0xBUTFzWUVyRVk5Wk5PS0hGaDBwSzgy?=
 =?utf-8?B?ZjBUTzJIUjFwdVczbHRnYVdITTc3b0dISnJSblkrUUhaOWJnTWdBdEJ1TGFi?=
 =?utf-8?B?VHFMVFpVcUhEMGlyZy9LdzdjYkY3VHRPcXdsYUsyTlF1QTJhMFlFZUdKN3pP?=
 =?utf-8?B?djdIUjEyMTlGcVo1MVYyb21DY3RXQ1NnanJOdWJFWVBrLzZ6SG81dkRlTUxs?=
 =?utf-8?B?ZTdQWTdwWlhpbmYxR1V4RmZnK05HZXJwN0gxQmNvVUp0Nlh3MDRrRmRXUTYv?=
 =?utf-8?B?TEhWZGk0djVEZmpTTVZBbzY0NHM1REY5VENQNy8wVG1DNGdDd3pKdUxRTTdr?=
 =?utf-8?B?dUtwMGtqbThVa1IyWW5xR28wQmlQbDhtN28rMzU4MjRSWlZiYVdLYUFRUXpm?=
 =?utf-8?B?Z0lONE4vUXdaN3cyYkx2dlZGSlkwdS9jMy9Kcks5S04rZWE0V0c3dXgvclB4?=
 =?utf-8?B?SHQxTHlCZHhRNzI0L2FEMTVkekNQZVF5eGV4RmpsMXVPbXBvdWpiQkZxNTZ1?=
 =?utf-8?B?ZWZTNG84V0tZbEdHOXRCL2RpOEx1M3RYbkNVL2FnSldHZzAydzQwYVdEYzN0?=
 =?utf-8?B?RjEzTTlINjZvM0c3L24ybmpGeUxnV203RFpNRW5LV2sxU0taT1FhV3BLRFBl?=
 =?utf-8?B?dzBFVy9VYktvSzQxc3daejljVWNrR2NBMEYvbU43eFZjUnFOOGx4cHpvL3hk?=
 =?utf-8?B?QytNSWxnUDN3aG1NajI3WlJLd0hWdUtpT2kxN25HR2dmMWZYUCs2MlhkbndE?=
 =?utf-8?B?K3RmYkhkN0oxdGhjbU1OWHIzd0ZUVWRYUnNEamNCOGNyaUlZbGN1Tnh1V20y?=
 =?utf-8?B?bFIvTTBKbmFKVTQySEIxNmc3NVJZeWVta3k2dDZYWlh0dXdmSm5kM3BQbEtR?=
 =?utf-8?B?Y3EyK1hGbEljK0dKdlFxMGlZeWxDM3NIRmEzTlo3RkNoeGx3a0IzcHk5VlFh?=
 =?utf-8?B?dHJTaThnWjdaYWIvNXRlRUZWcmlDZWFmVzI2VDJrTVRxVzFhakRPT2t6eVRX?=
 =?utf-8?B?UUdBTExtbHBFdjhZVHV4eFZiV1RoSmF5ZjdiVGFGZTNPNXk0aEkrMEM2Ni94?=
 =?utf-8?B?YnVRRnd0cUR2T0FtQ2lHQVREeFFnSDhnd212MlJNN3dWb2FRUWVxWHV3cExO?=
 =?utf-8?B?YXZ3NFREdXhBaG9tQUJ1bzlheXhoR1FXQ1RvZTNqSVdYalRjQlBsSVp3dGJt?=
 =?utf-8?B?Y0k0cUdzYWhycVMrTUNUZ2JwTzBnaEd4UjcxQkZOa2F3clVoMFhrZm5HdC9F?=
 =?utf-8?B?QmhBcURlNWpOYmEzNGV0aUpBYVhablRKN0xzUkx3TzhUbTVHLzlVTFZxQU5D?=
 =?utf-8?B?UFExQ0ViR2kwRFVIakRQbEZlQWlQZGxvYlFkdHkzcWx1c2RHa0Y5NmRvT1RO?=
 =?utf-8?B?YjlzeXR4OWQ0ckRLNFZpNW1OelI3d2pTa3htaHlFTHhsTkl6RXRZUVExTzhF?=
 =?utf-8?B?Nk15QnlQb2NpdmN2YkZTd3ZRN2JxS29ndHg1UjJMOU1EZHl1a3dmcWsvaDY2?=
 =?utf-8?B?VDJoR1NxUjU2VnYvMDJ2aUdWM0lpTFIvbTV5dWdJdDU1RjBML2hULzdTd2ho?=
 =?utf-8?B?c1VPTmFNb3pHa25HYWpKakwvZU9ldWtnVjl5d2xvQUJINmtGOG5nb3pVWUdi?=
 =?utf-8?B?U3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2QmzTNKxhaHDTxx4+KKxk5Nm3nvw3nyCuP6YZU8LtYKUO0Cn9sfpKUUb8Xr3CuK5TPu/PAuavSJZmMsvk0BpNbLIbL5cJcW/Fr7wYX0McboGgDyN1QAa2F8kZDf8nVz0HzPkIKi9YjEV+X9VwjzlzM8V5Il4g9Cq/8XOoIH5o/Lznl5djzNB1kKqIjgoaSf25kS5J8lztbzM27FnkQVEomzU/7DM2KTKXlKQy2aJMVHe9PytqErWbjYSngwuFraFvVyEmBT0INYvAA6sTTnDh48uCvcycih0Vu4glxcHIXjEok89+tRgJUFfh5Wo6YX1vXWkygaMvKvRmAd+mm4DszAcbKEowsO8c+m1ebjfQo0uT5GZUQjS5GtsE/tq7f7HrZzhq+Mf2Xj8/AqW4w6NOqXAO3iCdbFrQ/ljm8/Di5PLf9/+srX5M+c5UmlGKSBxGrlRAlwE+HAOA191rg0kQGyL4H0HsqzyiGjtvvfnIoWIq3ta1TUznJE5CAZp3f00bAH4DtjUqXOc7rBEN1PgjbJhc0Ez6sVGCjRZ5A1KzVrP4lKfz9qqlNlIp2vl0tkZCJJJ82pOwXdLwD+OallnlVgiu/0XTjHLK9cYUTO7vIw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0148514b-900d-4e76-00d9-08dd0d2ee511
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2024 08:55:22.1699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PcapwgqVdm1Bdw+6fdOEZai1/5wf9ErPxmD0oDseqkw1TBcxoskiCrDI4EZjkZSNjW9/Hs/E4DQ0KevXnJmuIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6046
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-25_06,2024-11-21_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411250076
X-Proofpoint-GUID: rGvfH_R7bee-HiZhTAmiVoJOi_GfS9NP
X-Proofpoint-ORIG-GUID: rGvfH_R7bee-HiZhTAmiVoJOi_GfS9NP

On 24/11/2024 12:38, Sasha Levin wrote:
> From: John Garry<john.g.garry@oracle.com>
> 
> [ Upstream commit b1a7ad8b5c4fa28325ee7b369a2d545d3e16ccde ]
> 
> Add proper bio_split() error handling. For any error, call
> raid_end_bio_io() and return.
> 
> For the case of an in the write path, we need to undo the increment in
> the rdev pending count and NULLify the r1_bio->bios[] pointers.
> 
> For read path failure, we need to undo rdev pending count increment from
> the earlier read_balance() call.
> 
> Reviewed-by: Yu Kuai<yukuai3@huawei.com>
> Reviewed-by: Hannes Reinecke<hare@suse.de>
> Signed-off-by: John Garry<john.g.garry@oracle.com>
> Link:https://urldefense.com/v3/__https://lore.kernel.org/ 
> r/20241111112150.3756529-6-john.g.garry@oracle.com__;!!ACWV5N9M2RV99hQ! 
> N4dieLgwxARnrFj9y51O80wHlzi_DtX0LRE- 
> kw6X6c0oWji1y3NBy1HIbHaHEkfRZJ57mxEq0kY_YRAnPg$ 
> Signed-off-by: Jens Axboe<axboe@kernel.dk>
> Signed-off-by: Sasha Levin<sashal@kernel.org>

I don't think that it is proper to backport this change without 
bio_split() error handling update. And I don't think that it is worth 
backporting the bio_split() error handling update.
