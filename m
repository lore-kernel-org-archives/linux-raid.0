Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719361E32B3;
	Wed, 30 Oct 2024 09:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730281814; cv=fail; b=BnmCfd0dPgF1q4iQFNb/9Wet2o31fLr1AkUZHPYYZ4uwzNac2nCiKXFWdhlS+WW2Q5pAPp1E2thpLiRs70sLPOW9ihw7aw19Ow/NwVWRhM9B9AV8a09oP4NHwmkQCmYKLw2McMVYl4r1iqkAtwRG0FxhPE6DfAovl8eXbC5xh/0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730281814; c=relaxed/simple;
	bh=JUx6i4OLcDLbtSqCsLxDX1UApTuAwuBQb3gIDTrL8W0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KTwADNPjYznj8V+50zY7q6I1+L70FEFEZpNIVoOTact9q0n001XXniUjPsKBiEXcq3CxdvFgG7iRYzBF0db1xgUywzSviBZ6g/nSGrhO+tegT129JWnoyL0A6HxhBsxC71tv1VlaNnAlJIfP45Ee/S6VeYQ5qjwjLyK88ofmUTM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SQccPWfy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uWPI5k88; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SQccPWfy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uWPI5k88"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49U1fjs7009124;
	Wed, 30 Oct 2024 09:50:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=KPzur4AxfWZs5AO4+T4e5EtkO1yoPlQR6W8jWOZbvnA=; b=
	SQccPWfyMhXveIFQKR6AP30DAU03EzMAND/nWKi7iGXtgZ6avm0aiMN+XgGTyHL3
	p2W74Odg5mHoG3PCEFE57p0OqowlsAk+ZvKJvPxRid4y06zlo4dX499QcXrFriPm
	N7a+pBNu3YsELzG2QhBbg9eIO3Ad+gfTsAm+2mt6diBGcrqp936DqOVc61jPR+Bl
	OWOw6qCdeuktseuL+9mol1Ee+cLCfKxXx/LvQDtCfuORdcoHcV8KXjkOwPqpORMO
	SmoXPZ29fesEwut7qh6OhsUhyaClhoWwamyiK3jPO7kuv06dlA2YFzxsT/HSFpfi
	oFOkKExklUgAAF0C6KP6mA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grdxqkg3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 09:50:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49U7TQrt011738;
	Wed, 30 Oct 2024 09:49:58 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42hnadsys9-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 09:49:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dC9/dzNQ6D+7lslJlyXYN7+NyNsa/rSWWn4xbe737iyxSz1NtDYNb3ET5/PlAFF29rvObzgUotCPaK7Ol4xTVtGYtWjpt2GZTAAcU8KScMOKNZAvbWb8LBBy2bf2FhoEF1MvwPEnCq76RaXdTSnB4ThDbewGPIUV40g8kgFCQzHJMkl6hCKvGZF3Y29J5ypMzFdGi1dcq2n6Tm4yBwBlXb2lzT0DE2980BZkXaQTnJCRw0uNGTWkdMlaO7nLWB5GlDNMW+zFL6e3jfTBLIgYJHCNIogaPlpicbFZaZ4SBvxuFJmErm13JrTD/HIbLWQ5s5MNutYlxIyFpxGSKAQ7YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KPzur4AxfWZs5AO4+T4e5EtkO1yoPlQR6W8jWOZbvnA=;
 b=xNyxELY5AIIpiE2IU/JhGEyez2e+pocYhrCq/Qb+IGRHiO43xJnRWd3wbgMbadE8PMFF+kEvFlBUq6tGiMKg/aLkGG3jzgh+xrHlYgOO8jYG4yxWTnsQTN09tWXd6QYVQjjOXWtK+yMc3U2u/bqEbzB+IILhG3dNxIROrqrHAfxlUgLNRlWHatAN7IjNGqqbdoD88A8aYdPcGN3tpALKBoKYBPQqwk8eLHJbntE+Rh1tZloWMRWtFLNemNVp+hObYZhftzRBL7tC3fM56Nqx+XvvdqhcP3np+/nB/i1Smotu6vFIbNBkuPwFN6DHBs872c/duzQ6GYYVHScrTeeSUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KPzur4AxfWZs5AO4+T4e5EtkO1yoPlQR6W8jWOZbvnA=;
 b=uWPI5k88LWnnuKgJE6SzMz+hEcZTO70Im+4N5dMoBqPKXuZCRp+LER/h9NufSzm38PpMqoLcTK6XvOES3Y421ODrs4p6IK5yiRdzHpheS3rqAtgEJ6nj3NYxR+LjUXLBiSYGx0+PUoFQTLvUFFtvhatjB5qqu6SRQgvyN0fY+kk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ2PR10MB7826.namprd10.prod.outlook.com (2603:10b6:a03:56b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Wed, 30 Oct
 2024 09:49:54 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.027; Wed, 30 Oct 2024
 09:49:54 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 3/5] md/raid0: Atomic write support
Date: Wed, 30 Oct 2024 09:49:10 +0000
Message-Id: <20241030094912.3960234-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241030094912.3960234-1-john.g.garry@oracle.com>
References: <20241030094912.3960234-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0129.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ2PR10MB7826:EE_
X-MS-Office365-Filtering-Correlation-Id: 2614fcef-0beb-4bad-af04-08dcf8c834e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5XSvLWN608UsD0xcBaqR07/iN+D1pbks8vRB4CiNTuODXIMrOwxugL7z+72M?=
 =?us-ascii?Q?C1pfac8Ca3PVxF3SvckDtvLc+ufARRa1Tmjk27/cleKVstxn/ZPXUegL/Tyu?=
 =?us-ascii?Q?a5K15zI5tcnUU0D2bMdL7jzo1os4D1/5GDpCFB+LAcmPHKlPK5V8WGgYYbg+?=
 =?us-ascii?Q?90ZEfjzNmGk8ECYN2fxuFx9eELr1HIsOu1es3jjL0408xiSbJyIAcDQQ+G01?=
 =?us-ascii?Q?s874TKhZho8e7fOxWObkonV9UlRzwGLG9tGll+ZdK0czsm+mWe8MOEdWipnH?=
 =?us-ascii?Q?XXE7fGbm6vhH7ww0DoN0gSrMXmdXAooD5PfKFxZRHrtxC0p91lz3pWBR1rSO?=
 =?us-ascii?Q?N8vaxdXdvLjlQXG6kcbM8jR+Orzu3gzSIaTdBDrKQgMFLCis8c/J5oXJq+iz?=
 =?us-ascii?Q?3ig3lvI17eJAjMoRLJ/auKVMEDc2/i/WNeb03DKwEtmVyX5qxTisWDImOfJp?=
 =?us-ascii?Q?Ztwju7WFvy7XoHMCRMixygWNVx3JbOycBsRRuhRhMZS9a7M7G+q/gRC6YFLZ?=
 =?us-ascii?Q?+Yqb1bkDIpFxxLaSXFVBJ+INvgrakWb3fZ1lg3mU1ABlYy4UoSAuxxh4NnOl?=
 =?us-ascii?Q?tKN0Gjaxs2RxB39buHTqrX9bOGv1ivFQQdBRX2v5YJZiKBNMGQa1hdIQhJ18?=
 =?us-ascii?Q?vx9hNhxX9W3lP9ydfOehCOgRNtho4Z7NJAQl3zPf8tR0UnoUNQLZWu8KY27m?=
 =?us-ascii?Q?GsFJc3EBWkvgQJjB8TysyZ0rOnHtO4T/Cl4hN+PjtnF2kB6t+ZH4r8js2/MA?=
 =?us-ascii?Q?NPy8/2ZVyfwUNEvI0199liNfTZRXTDzk2S6rhQG1w45LF9XaDylr9KjDc64Y?=
 =?us-ascii?Q?g7t8VBy8r+LgQ68YhfXO0SrVqLyEhhq5a2WdqkY70egSJM6s1jdaNjccP8JT?=
 =?us-ascii?Q?e97xc6NzGYQMfiIg/eUF9VRdIsNLw+cwDi/wLyiOHe7UPRsdJSZEp7NP0CG5?=
 =?us-ascii?Q?2LyM4Jf9wuUf8h8T0BRJnXea9NrtaFnOzmhpEJY0VmTG2aEk2drKXWNeZDMv?=
 =?us-ascii?Q?7TOX1hJAhSXO43YqXdjVAcu40hnMIMLOlwVWIG3tMgjr96YH1btLaVd0FF9x?=
 =?us-ascii?Q?/kKBvOcd54NExV+3qkBUd+YZnCm2weYO6PiJe5MIpTwweCvEd7xOXXm6lmIE?=
 =?us-ascii?Q?uYhW+I6HPpO6NUhXezx5JTjnbTumngoXkU6jeydbRxP7jeWsNKfjj0DiELLp?=
 =?us-ascii?Q?D0QAHLOH+SMwYLGWh9TSaQ2PI1/qnKUA5hnP/zMyMBZQp7re3eCzZ05oV2Ib?=
 =?us-ascii?Q?pGbjxEXoKXWwvZ4FNvm0VVGiaKTgW+fbmz0X5fRfNAoynzBv9GWanEf9dR+R?=
 =?us-ascii?Q?rYJZDU9Lkrj7jkt0SrOuXb1S?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bAR8I7vj6RAlOKm9s2w7B0NfNb/VGnr0GN2s/HO1bMX2p7wfqTUTHNQf5Owf?=
 =?us-ascii?Q?tljdVu+S1Ec8DgekMI9puCyfKh7W2bLssjQ1nnVxkaE8brIv0Mz3+QKKiM75?=
 =?us-ascii?Q?MuwtoiyY8DULaWTO9rhI2rzvygDeXIwlRIg3cNWuaUwxC+PatUW4bLKI9eJ+?=
 =?us-ascii?Q?+3FK8ASKG/ETgIqebZ61VTM/zcPdh5Gb8ZwfGCn5BcixNpudwJVk1iP+i4Kw?=
 =?us-ascii?Q?cgW8Ols2F8IaGBjScSxZWnpcwA51WXYGm/FV8XF/acOag4b1RDJIpOQMqQN6?=
 =?us-ascii?Q?WljIwwMl4Co5eCxKlAK9iASoznxpeHSyS+Rk/xshGhJzxWtIx9lHvDyhE+t7?=
 =?us-ascii?Q?/csQ9huHn+3nF04eI7SPLSWlwiFCxiYDH2qDHBWavGpCOn1yOoBnwpVmcm5K?=
 =?us-ascii?Q?KqN4gYH/GLfAqyMhB8s0YVSz2i8bBlyYZYNFBeW5i9+SAU/OakfK4namJuP6?=
 =?us-ascii?Q?BCNxiyhNQnQWmF1PCfdASlRs0v8sAg4zLLZXt851KgTPnesMX23/G31lbIzd?=
 =?us-ascii?Q?gFUYcalC3RYEEfyvq19lKzIEeSXEhltT/7HqNh9a7bIUMpKmvfeW4HEJWNtM?=
 =?us-ascii?Q?y1OeZJZ0dnGuVaqmg1/M2Lkm5LSK4Nz7YnN//qkoAQNXoJo6fi9yKGtJdcGv?=
 =?us-ascii?Q?0nqsHQq09jjHVgrBQU/f6cJVsgEaiRE4MO4cArp5dfzVIUUgf81xU+G6w8MK?=
 =?us-ascii?Q?bK8dzadIhQ43hE68ZJQ2uv/3/V97NgCuiUoPKjXLUCt/465gGLrLdpsity1+?=
 =?us-ascii?Q?Xu5OwwSfYWNA586V916458ktldE4vV3BZCUGO06yvBmtRDaMFzOE3uv4xStt?=
 =?us-ascii?Q?ptH93AGZDp8dwe4ISgTMSejEihGnWvXxlEaNUAnZzTMC2duxZrU2u5TSMAIE?=
 =?us-ascii?Q?NQqava7gQKaXwc1mZQkZDdFaWfbOLJeS8wKncl96Ry9yLxLPXk9E7Oay9hhD?=
 =?us-ascii?Q?mguPq2BJtZcxxqjSShA27EPTfTNQJshxCDg1AhQEAUVN9bKjB+PJxkG9xl2P?=
 =?us-ascii?Q?8WJ8tF6dAjKebmtw1Oro6Uv05RtceIz9MEBdfPdp0Pfaz9+f5cLCj0PnK+rj?=
 =?us-ascii?Q?0hn8vpgidRTfAT7I28nBa8yeNh+ESVp6BzibVR6Qw+Y5O0oIBQ3843IAOoIi?=
 =?us-ascii?Q?hskY2JiLpkIzbEzBCeKBZl1RTwUghCrl61/H4Y5ZtufIxGgMLzX+Wd0mL0V/?=
 =?us-ascii?Q?7SAa3ExirLocNrHGkJCJLO/7Jx6gnZz1KEUo3NkWcpvmErbz0xajuPKI789D?=
 =?us-ascii?Q?dp+3+5ai06RsLnB8vO3WUFa0waBPFerTFsm16k8vKwwGHRyenS/QXMl21yoL?=
 =?us-ascii?Q?XUtf8qhwhKw7G596tu7e2is6sgSwhmmm12tuUHchrGBVfNsu+9IOZmNA8p6q?=
 =?us-ascii?Q?63ncj6QK90ZUo1moxav1JgXDtq3gkzNfv1+qWvjFqqaEuPEzuvxxED4wVic2?=
 =?us-ascii?Q?gfywgfPY0WBWu3GsjvSXKw92QeexAXXjr3gl872OXl7PsvtT+ZnOwS+GpHKA?=
 =?us-ascii?Q?sFZR6p2FjvhLwIJ9IbVV1F3GyBxVrtJMTIfyTI7Pn1v7QgoNgItevSV/ah6R?=
 =?us-ascii?Q?Q/OUqXPQc6e/Ro2R/nZRinoURaEof8dhpkrJgiMwJPgnVd2kyqGSB4Du1td7?=
 =?us-ascii?Q?eA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	msiQuwzTnR1NJT8izO9Kb7jxO74dvocvG/ic3Dma+txHJDNe7ydIQbYY/CPdfB65VZ1dDaZRPkoZS/LUDr4S2Plh5xvW80+9/oYAzlDR6iw9jas+e+3aYu7V3m43HkS0oYVRKCpWHt5AY6KT+dOAFVZQb3QZqtT1470u8PVHq9lCQ8Y2Kr8zbdNp9fGFNZqSxAfV6WR13ppVEkyvXINRrAOKl4waUyPbVF43k2bsRB9AzDzROXe13C4425tyPLMW9m+KFU5qntkTZPzyMau+A18IjiHVKhMbHeW/SCHcm/3IO952oJ3KGoqkvP7y4lTXfa5iCBEp301jSo9WD25QVA1CtBcu+LMf7ppxV0+33tULVOpPuT6oKqPsIJvTesFNlV6I88NqoSFWq1lPUsuatZtiWv4plAeyailjMJgyNwFYp6cIrhxU4l+JlzcosCxZPJbAYhts4Commj6BERuBxG9G6Jv+RjV1bsb5g24+5wyj2cGn/Mw/zd96ombsn+eXF1KpLMpI5ZS8yiy5K4vA6v21L7gk3xMuNMcxZjH6BSv732eX3B/VJ+1fjHlfoRWDz4GRFk2CvVgGky+Whx3u/dP3VhngiPB0nZK6lp3a778=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2614fcef-0beb-4bad-af04-08dcf8c834e3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2024 09:49:54.5363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qK2JmUXBDYjpF6aeo9YGJ1XidNDQh9pa5Adfi4FEaCNx79IJC/et5QNBz+f5AOHx1L2KVMbr5ADK2yheybqq4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7826
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-30_08,2024-10-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410300076
X-Proofpoint-GUID: CgRjiMHR4o5sMtQtsJYelpXydNMuvynv
X-Proofpoint-ORIG-GUID: CgRjiMHR4o5sMtQtsJYelpXydNMuvynv

Set BLK_FEAT_ATOMIC_WRITES_STACKED to enable atomic writes. All other
stacked device request queue limits should automatically be set properly.
With regards to atomic write max bytes limit, this will be set at
hw_max_sectors and this is limited by the stripe width, which we want.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index baaf5f8b80ae..7049ec7fb8eb 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -384,6 +384,7 @@ static int raid0_set_limits(struct mddev *mddev)
 	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * mddev->raid_disks;
+	lim.features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err) {
 		queue_limits_cancel_update(mddev->gendisk->queue);
-- 
2.31.1

