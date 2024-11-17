Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E92473477;
	Sun, 17 Nov 2024 18:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731868361; cv=fail; b=noHjeZMbRfEp2pNNdvP/dn/K+0oWsi8nLHpJQp20+3ETMSnXk9mqJO9COm+Dlv26BWubVbZSUmhHETofwcr1rAgE3UyeHF83rGAuFV98pwKZ6XoMo/pXFrjU7k6qyjtfhjyk0hi5TGyLAu4dKm2A7HWZ6UDWMWPGRmVqiTxQ0rE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731868361; c=relaxed/simple;
	bh=H+rD0ON6X35hTmLRdsR600SbDs/1HL3dszVzzSd7Bs8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FaC1wmsHR01B4R/DOzrXyJWtwxpd5d5BIynnTHQccgjUxvqjqda48hnVDOuO5iAtnb+SjjrLPpX/YL1HKWABB93lXTwrdTgiVdXOGazCe/UJTbqv2ymXB/Iwh4h3b3AI/UIu3/XwPDglanDqj7yLEBuIYFh9OLNixUMHEA+IXbs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dm8AAeF3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WcTUtMRh; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dm8AAeF3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WcTUtMRh"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AHGiLNT030648;
	Sun, 17 Nov 2024 18:32:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=deS9KBj4533AE+mc6V5YnKbJ96weFmkxgA+oXz9Xaag=; b=
	dm8AAeF3woe/0MvGtPR1SEeOzsDIe/4Eo3ipm9wxtlUqQ6gRHHNzvrxdOVF3XiKZ
	+S/Im28AJBC7zOIeajsHoqcot6k1+J27V7OBbJ9tRO+MNvBFpzZLaHZUSfoIGvJ8
	V5kEAno77yShxPGXkHRUJPPKtgPxwydcfVIM+oCkr7znFp9MysEGVrnLy2R4yi6O
	g4fvSA3llpCq1k9Ur4j8dUF3iVkoAYAhSL9+oiqfZ84vJ8wuyRLeSSsp8y4jtBn/
	V3SZ/4S+9Nap/yLnERtk+/JH+TVZ6i2TJ8mSB+mOUuQAi1MkoaEfs4BPOx63CMSL
	daSAUqZ0axN/CHvDQC9PqQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42xj629k62-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 17 Nov 2024 18:32:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AHGUDBf008913;
	Sun, 17 Nov 2024 18:32:08 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42xhu6k8b2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 17 Nov 2024 18:32:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dJNCHbnPYYC6ugAmPJLNwU4SwuwkGqUx47cCnsxliZx9Dft2+4onnIplY28EiFxuz2VGyrQYY+HzZDm8MNkV3HW2iQEM5/CJsDmMQsHzAOuO5FrQqXZzRbVOFKnjJ4UBG1WPvIoLORIHzp9N0tVX9yFodFoOBc1LOJXW93E9GXOUUvc6JPTx5kI1hpzZzztn8/UO28kPlNe8DNk6zE1tEiDoEAxI9bsC5Jl5Dknr0dIQdf0aq/ewYXXwCWEi6qkx1iJ6YHeVMhYeNkK+CFcplKF3SRE9OFOC+FY007euWh4wtcUFZxeL3vd0jYJiksH8BHUrzrjf2BFwJu4uD6DcsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=deS9KBj4533AE+mc6V5YnKbJ96weFmkxgA+oXz9Xaag=;
 b=Sw5+8AEZoqrbj3cMZ8LaO7yD6frFsYMlKBkI9ZpYKLywPRUby94Y1ia5aF+8rK2mgrm8faPQixE129wfULnHvw04gMV8zmBc5PZxzzb+caXUR7GZvoYBRKvalJa23N/Vgsryct5AcQxsiz+Lf6oUDyple/opute3WO1Xmn8j05OapYaBjs9NfFgYthPp6mQq5wwVImUUnVFID0fYL3+IiBzfULBTp+KQfVcjoaMn1M83TZVQEiSB+tZrpPapFllHriPyMQRh1Gxc45z74wQc+BXwa51wA31mnmyc9tKnwWt/RIq9rRFhBvlR5ylyAEf4rbnfB0TFh+tQJhU0ckb2RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=deS9KBj4533AE+mc6V5YnKbJ96weFmkxgA+oXz9Xaag=;
 b=WcTUtMRhXVl7vM5Z5ABxJXQmPRUHBh3O2o5uy6BM5/UsLZKKSKkLqwmb/h/qQ8AsKfuMQNxIlnpBdDW2EAcm3Dyb93p03u8qL48W+R7rgIHQXBzpS7AFvxXlY/rAxhd2kEuGgqblEDmoXFsYTV/TGbC6Hyx2GtDvGVrYN/u+j9Y=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SN7PR10MB6452.namprd10.prod.outlook.com (2603:10b6:806:2a3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.22; Sun, 17 Nov
 2024 18:32:05 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8158.017; Sun, 17 Nov 2024
 18:32:05 +0000
Message-ID: <3fa37335-2353-4d24-b2ae-e11f2c26ee4b@oracle.com>
Date: Sun, 17 Nov 2024 18:32:02 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/5] md/raid10: Atomic write support
To: Yu Kuai <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>
Cc: axboe@kernel.dk, hch@lst.de, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        martin.petersen@oracle.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20241112124256.4106435-1-john.g.garry@oracle.com>
 <20241112124256.4106435-6-john.g.garry@oracle.com>
 <CAPhsuW6nJGQMQsEzJFZasg4LuHb3Qf-+JRTgqjaBtbYj_uBNGQ@mail.gmail.com>
 <469d9b9b-dbc4-26c0-4ad6-ee97bba39d47@huaweicloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <469d9b9b-dbc4-26c0-4ad6-ee97bba39d47@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0604.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::13) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SN7PR10MB6452:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fbddfde-c770-4917-055d-08dd073622e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b0cycWs2WVRZcVZxRjlSb1RFaU1YL3JmUHMwZVZ3WXpEbCtaOXpHUmhid0ZX?=
 =?utf-8?B?dHVqYk1XVVltL0hrb2pJK01kNnhzaDRoSzJrdGlhZVZUdmJQZTlrTHdaVlFF?=
 =?utf-8?B?VkRVUGVwUkUrNGhaS21HZ1lrcStmM21acWlOMVVlbVRyNHMrc2dHN3hhd0Js?=
 =?utf-8?B?SVR1U1N4Qy85dC92dnNOMzNlTS9pQzQxbFZZWHY1a3dpQXBHUmdLZDNhY3FY?=
 =?utf-8?B?VFg4dTBIdU5xTDdRbW9uVE5PWnM3SDdaRGk2b1ZhUWVzT2FEMFIxQWFPNUpN?=
 =?utf-8?B?VzhKdVR6RzBLU3h3Y0Z5WVc2eU1JZW4vUUZDaG1Lc1MxL04zRTdUckJqRWRx?=
 =?utf-8?B?NGs4dnU0OGpLT204U2d1ejJLbno3UmNNM295QzVhRmNsSjlRbUZjWkhnOGRa?=
 =?utf-8?B?NU42Zno5SjJXT01BL0FtQy9Ja2lIVWxPbmF5dEk2NWhxZGNjcFRSVjZycVBW?=
 =?utf-8?B?VTJ2Q00zNS9HbW41Zi9xQWNzNzhPSlJIemMrRzBEemRNbHZmT043Q0RxWTc1?=
 =?utf-8?B?SEh0aEdwd3ZYUUp5bmg0SXJJdWwrdTRFZ3BqZ3lMa2RtWFE2VzYwQWZzWk5P?=
 =?utf-8?B?c3EyWEY3cEIrTTVFb045Y0VFczJPaGd0UEU0MVdQZUZXRE9mR3dpb0Z3bUlZ?=
 =?utf-8?B?MkhVa1lTM08vRU9hNlhwTHhBUmViN2cydTJuaWtQdlZKMTBUcVovNmhMM3VG?=
 =?utf-8?B?d1B3Q2Y2VUdkREQ3UkxQbHBLa2N0bEh5QWovU01mZ2Y4WFg4Ti9iSE1QYU5p?=
 =?utf-8?B?d0tYZGo0R0M2OGpIakFWMjFWdWF1VG1ib0RKSUFROWZUQ3RmajdtNGU2UWVF?=
 =?utf-8?B?YlptckZaanJleFcxbUgwaVFzWlV5cmlhQktSeXpWNGdHTVhNNStkRG54YjUv?=
 =?utf-8?B?YUNiSDhGYUhjYXlFa2QxSlIxSkVvUm16NGNNMUpXSWpQeEVmTm9rRDZld3M5?=
 =?utf-8?B?dHk5cEQ1OHRtbzVEWHBkRDFGYUdRVnZPOHJUdTdIS2pWZzd4cjBhZkNzV2ND?=
 =?utf-8?B?MVJzcXpvMWs1ejhKY3drOFpuWHhlWEhDNmFuWnJiQjkzVFhsYVBRcmVSejM5?=
 =?utf-8?B?eUFNL2JDQmlVTyt6NE83eHIvVDdWYWVvRXdWKzNCMVM4clk1QWQvUGU5dVR5?=
 =?utf-8?B?SldmdzhYWFJFWGd2Ti9TYm0rYk1Wa3lTaTVpWU84Z096bzM2ZVpPZ2RSeCs5?=
 =?utf-8?B?NW5oZXIwVEpsQnF4M29TOXNGRXBrK3dDVytiY3V3SU5VRkl5c2hRTWtBYkZF?=
 =?utf-8?B?blNyNWhHbUkvTmsxZVpnS01XNlhCV1JWa1JYajBiaUdrcGVCdFc0ZzlCblhN?=
 =?utf-8?B?VjYzcmt5OG82UlQrRG1aWmQ2aVZzd2NRU0dhS3pMSy9rNEQ2THl4L0NJdzB3?=
 =?utf-8?B?QTFXQ1RVVnMvejQ1a0dveTlnVXdHN2pDbi9zSVQzZzZwZENjUk1VQXkwZTcx?=
 =?utf-8?B?UXkwQTRxaXpCdm1zWDdQb3hlOVg5VHR6c3NCVU9sek52amMraUlITEZzRGNk?=
 =?utf-8?B?VXRvMnR6V1ZpMGJTbmRGQ29ya0hDQ2VzZ1c3ZHVLLzR1Q2dVSVdYYlJlQTNY?=
 =?utf-8?B?NWlBZk9DNzlxZHZKdDQ3QTRXL3A0UXZVeTBqV29hdy9jdUVQMUtRWnhReCs1?=
 =?utf-8?B?eW5iM2tNRStxLzFRS1YxQ3ZGbEVQVGlLT1VmdHVVbFdvbllsOXJxenBzRjha?=
 =?utf-8?B?dlBlQ1lDTXBRQnBGM0pVWlVyVWVpN0xvdm8yU28xcmlGbW5Wc205dHdJV1l6?=
 =?utf-8?Q?XC9rndxep+xH6arjWk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Nk1vZkMwTmcyZ1hGWU5PQUJ4T1g1MGxtTU9oMEtIK2V2TTRQTGpLMXNRUTBs?=
 =?utf-8?B?SGI1Q0g2bFNJci9TZHhxVC93VkU5QkVtMU15bmRJSDR3MEh6QjFYN0JyWDdv?=
 =?utf-8?B?bXl5QzRGNVA4ODFNYW02S0tYZFdMN0Nqc09JY0RKWFR1RkpvWkRXTDhad0NO?=
 =?utf-8?B?clJ5QzdLMldybWV0V3NyZUxGdEJnR2RZSVVxampOUG9MTnU0dk15MjFITjRX?=
 =?utf-8?B?ZTJCekcvMWNWSnRkMVRpcUp0NWoxbTBZV2UzTjRqQnMyaWtyUndlaU1QL1p4?=
 =?utf-8?B?dnhPNG9yWkd2Uy9EUjJHWVdxK1kyM09Oc2hqZXVGcjU2ODVpOVJYMjFjWVVq?=
 =?utf-8?B?T1R3SXlyWGhYb2h6eEoyOEszcTBYWjhEVFdPb0ZjWmsxTDkzTGxyZDZSbjFs?=
 =?utf-8?B?QlBIS0pyVXg3dnpmN1Q1a0x2ZXU2cW1FMmxMekI4YXZOWDE2SE82YWxhd0VC?=
 =?utf-8?B?SmxLbXpNWXpwMm94WTNjS0JqdFVsM3k0WVZ6Y3FrY1AxTFJmMmczTVF4OU15?=
 =?utf-8?B?aE54eldxMklqcCtmUnhHUVcwT3hSNXlqVWorNlpZKzZnMjIzNmJXMEZuNkt0?=
 =?utf-8?B?VVF1RG40UEdwaGlkWWF6UGE5dzRNUkZqblhRR1Vqb2pnRmtjTU1QbDQveTJ5?=
 =?utf-8?B?RjNvcmQwY2tsZ1M5UzZ4MlptRmFCMnd0anNvVXFuRXU4bHg4T3BGdmorN0Uz?=
 =?utf-8?B?QnRLOEE2WUd1dUdoZnBEeXNsc2JoUWF3d3lERW5FUitJU2hvaWZtSUY0dHYw?=
 =?utf-8?B?amxrOWdsRFc0dGN5blVKQ2M5anFPb3lZclcxNHJxR1RHRk16bnhoQTlDMjZq?=
 =?utf-8?B?V1hpdVRjM3dZUUxEYWpQQnRQbTd4azlJY3MvSWg1Tk5aREVFNTUyS0luTVds?=
 =?utf-8?B?L3VqUU13MC9iSnVDbk4yeGY5SDhpaW92K2dBcWZsYzA0Wkpra0NtRWFacGpm?=
 =?utf-8?B?VGs3S0xWQXdOUWNpUGViNVN6UnljWVlFbjBKQUs3TmVhcXpGTGE4SjBJMC8v?=
 =?utf-8?B?eXNPSmdsNlRZZ1J3eGpXY3drL25GVkZoQTNnb2FxTnJLRkc5bTh0N3RCdnVL?=
 =?utf-8?B?amFrUURUYW5mLzZ4QklYT3lZQ3FKTHYvdG9YVm9pVU9vMHZrL1huYUxVbTFY?=
 =?utf-8?B?SHRYT1hLWnZ6dkxhZmJka2dqNy9nOFJ1TXlxOGdaUjEzN1dFSXBxS1htckJW?=
 =?utf-8?B?QjJlZU5iZHdPNTEraUx2L3JldDNubEVHU1g4YmNiL1BjS1ZwL0NuUHhWTS9w?=
 =?utf-8?B?NVpsei9GS0lhTm5JRzNuL29ndTdySDF4R2FFZm5lYXNLK1pVd2RUUEE3eWx4?=
 =?utf-8?B?bmpMUTNla2ZMbXFPTDZGR0hac0lrVnlkU3c3a2VmOW5xYVJrU1U0eVlIOUlC?=
 =?utf-8?B?eXBBTWRkTWsyQ0k1b0l0TjVDZW56NUx1TTMvblNkQTlHQ3E0YXhpM08rZDBr?=
 =?utf-8?B?ZE1xaGttSXVQNTVvbWJ4QTM0M05wSWkvOUp6aHNOeWRKOUNmOVhtakFmcW9K?=
 =?utf-8?B?RkFaazhPVGRxT0JPNnB4UUMxTGZ5d0lXSEVvK2ZtQmZGOEFJcnQydXBBWDQ1?=
 =?utf-8?B?ZGR2RTdrMCtMR3NyZ2J2SnQ2MXk3bmtDcC9CSU1LZFMvckRTQ2JoM2lpSTE5?=
 =?utf-8?B?cm80eVVERlB2TkxUemM3QlJ5THJRbWtwYldZc2RKUERrYnVLL21SdDhNTGVa?=
 =?utf-8?B?Tk02MDU1alVBRnhRWmNiUWp6Z2hJUTRSRVVpMHFKVVcrSU5ZcEFTU2UxL3Bu?=
 =?utf-8?B?WjlaOWN5c0UwdFR3blFXbEVwcFBjMllzN1ZSNWFSazc4VlMvU0VwZ3RYUDAv?=
 =?utf-8?B?VHlaRXJCcGh0V1l1WGdjMUtUL09ySFNlM0tieXFiTWQwSGFCV0JFYndxNDFy?=
 =?utf-8?B?NVFPQ2JZK2sxajZkYzhPZ2RUdFNlSHlIelFCdjFjUHhrL3h6TkdWT041T25P?=
 =?utf-8?B?VHRhY3YzYkJCQnRkZXF4clBVZCtCTVlwSnA3elU4N3VHVURxdjh4ZkxuWjJt?=
 =?utf-8?B?OWgwM281L0czcTNzcnF1U3JkUS9TYSt4d1pBN2s5b1BqdE1pZUthUUtuV0dz?=
 =?utf-8?B?REpobWoxc1FldDY0NVV6UzZhODFsVTJYY3NEMWIxaFdLWG4rOWR6aVcyLzVT?=
 =?utf-8?B?UlFuMWlRYjNwcWlPeEpZZFJnWmpoSTF5cnFibXdFeW1lRzRYODBlMklFRElz?=
 =?utf-8?B?akE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	u17D18sYLma27CEisdZqXiqPSnqdT//jtxFrupvt4/vaePLzk4M45dtxJPaK3ShJHOb9yI8YiUATr68Phvejq15JfgMoneZY4M+GgRpjd7lBtJAc6XMV7hCVZOHwbYIpW0p280/VTkYTa2NJTBvcUdlIu5CCvJUP5tJ/mbn9V0VaTTvSx+ko90reCNkjMP0vbfytEnCnYFBamcLn33sqiGgrA3IKYzIDpAxFOTN+CCx8yBtbgAGVy1Csw9o0ddHjiz9T+4Fxj94v3Ck360iihHPSC2bFG7PEssEIcqA85jH1Qxwo+mAT9f6zqb+AGPdz7552Kkr+rMIDH1bP82cOFQRvpfZIs3aPbXZjx/a0X4pLixFreWfLvWwuF2+7cQdF3/Y0gf/NeJETdPAgEKGs3WcKuKYhbfCDRgGNC2amb13RS+ahXj657fvjgn6pkBIWD4mGjHUptjlyqpW2hv1wdY8jRLlzRRJ3+gTYjCyrSiWIaxcCDApnLDPbLTAlBiyzbT1/KlwnDO/ylPEZ/bKWFRaBNxgsQdHU1W87ddXOg7NsMIBUSmzHrz9eo1qzjKqEceD8y3hK0XQ9Dp5v7bDKvKmAH/jLjp6CmLfD9YZMJwk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fbddfde-c770-4917-055d-08dd073622e9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2024 18:32:05.4814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nfJxQuw6vhopepPLwQT+Oed6NgA+SFWsAM2WQbgkWcIew40w0p8gRiU7ZXeiynr1v+hWFTBnuTKEpawhiKBk8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6452
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-17_16,2024-11-14_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411170166
X-Proofpoint-GUID: uO21FlVkzS9j9yG-zZr5bsRysjRFLKw2
X-Proofpoint-ORIG-GUID: uO21FlVkzS9j9yG-zZr5bsRysjRFLKw2

On 16/11/2024 03:50, Yu Kuai wrote:
> Hi,
> 
> 在 2024/11/16 2:19, Song Liu 写道:
>> On Tue, Nov 12, 2024 at 4:43 AM John Garry <john.g.garry@oracle.com> 
>> wrote:
>>>
>>> Set BLK_FEAT_ATOMIC_WRITES_STACKED to enable atomic writes.
>>>
>>> For an attempt to atomic write to a region which has bad blocks, error
>>> the write as we just cannot do this. It is unlikely to find devices 
>>> which
>>> support atomic writes and bad blocks.
>>>
>>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>>> ---
>>>   drivers/md/raid10.c | 14 ++++++++++++--
>>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>>
> 
> Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> 
> One nit below:
>>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>>> index 8c7f5daa073a..a3936a67e1e8 100644
>>> --- a/drivers/md/raid10.c
>>> +++ b/drivers/md/raid10.c
>>> @@ -1255,6 +1255,7 @@ static void raid10_write_one_disk(struct mddev 
>>> *mddev, struct r10bio *r10_bio,
>>>          const enum req_op op = bio_op(bio);
>>>          const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
>>>          const blk_opf_t do_fua = bio->bi_opf & REQ_FUA;
>>> +       const blk_opf_t do_atomic = bio->bi_opf & REQ_ATOMIC;
>>>          unsigned long flags;
>>>          struct r10conf *conf = mddev->private;
>>>          struct md_rdev *rdev;
>>> @@ -1273,7 +1274,7 @@ static void raid10_write_one_disk(struct mddev 
>>> *mddev, struct r10bio *r10_bio,
>>>          mbio->bi_iter.bi_sector = (r10_bio->devs[n_copy].addr +
>>>                                     choose_data_offset(r10_bio, rdev));
>>>          mbio->bi_end_io = raid10_end_write_request;
>>> -       mbio->bi_opf = op | do_sync | do_fua;
>>> +       mbio->bi_opf = op | do_sync | do_fua | do_atomic;
>>>          if (!replacement && test_bit(FailFast,
>>>                                       &conf->mirrors[devnum].rdev- 
>>> >flags)
>>>                           && enough(conf, devnum))
>>> @@ -1468,7 +1469,15 @@ static void raid10_write_request(struct mddev 
>>> *mddev, struct bio *bio,
>>>                                  continue;
>>>                          }
>>>                          if (is_bad) {
>>> -                               int good_sectors = first_bad - 
>>> dev_sector;
>>> +                               int good_sectors;
>>> +
>>> +                               if (bio->bi_opf & REQ_ATOMIC) {
>>> +                                       /* We just cannot atomically 
>>> write this ... */
> 
> Maybe mention that we can if there is at least one disk without any BB,
> it's just benefit does not worth the complexity. And return the special
> error code to let user retry without atomic write.

ok

> 
>>> +                                       error = -EFAULT;
>>
>> Is EFAULT the right error code here? I think we should return something
>> covered by blk_errors?

sure, so maybe explicitly use BLK_STS_IOERR / EIO, which is what we 
generally use in raid drivers when we cannot read/write - ok?

> 
> The error code is passed to bio by:
> 
> bio->bi_status = errno_to_blk_status(error);
> 
> So, this is fine.
>>
>> Other than this, 4/5 and 5/5 look good to me.
>>

Thanks,
John
