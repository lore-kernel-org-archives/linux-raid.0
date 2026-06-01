Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0640038D007;
	Mon,  1 Jun 2026 08:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780303466; cv=fail; b=p5QlszA4URjJL8ay8mIb1/PpwCIdyg7KE0dK6Bg5xWY1MzHfka8iFPAgKyc//T0nNILFu6j4bvmEEQN0ofsX/Jc/vkkObm+rDHz++Oj3KYXDihFvzazrnLgMaTYI3ygYI8YGJ33b4OXFFKQBIEeAGagW9u3ja4lWy+d7uUHUC6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780303466; c=relaxed/simple;
	bh=cv15DR99DAFsmJU436TFE7Jg96ZfzutmaW0JE0GwlH4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=akgJimVy/ssd03InbKO4gObg0iha2Jk6/CH2+onmQvXUHuElod+wetylHfAbJLwdx7TJTbduP2fwYkDN33YHhwUAan+fFESK17v1LcmOauQLS/P4DGILVg+JJBpzFPluqQYfzHay3qHf7e69dpCFlZ699MQIAivg8XU4IOiLkC4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dF90FeDo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mrho+bHe; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dF90FeDo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mrho+bHe"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6511MUf22522514;
	Mon, 1 Jun 2026 08:43:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fJNfi1l44muKYqRmLD8V+VHLkebWI3u04eb3nhQQfh8=; b=
	dF90FeDo6FHQrBPySwc8HayCyCxBV65twtBwcM2WFxJnY7XHZYULl13wpQVbhmoi
	Fjhwr5cMZer27/yMXWvssSSL0vmxEx9IxG40Z7Q0xCQfeqRd4iXt0opd8E9njQz9
	MeaE4lU7MfIe3/QP8wgH0nECRxkZ/fWLMpP7OH219VO8n0hsGUX7msVWeSw7LV8/
	N9Lvzor3qISED+9xLt5lNEgKoqe1lKNAU9FjT6puwt5LmbJYXAFb9hN93fdfOLOk
	e0tcKOF2/6Mc9NnyVeofGmf0EY3CbtDIPAM5aNlI3PqzviXRKDnaUvDQ1zsMqOKn
	7eQsymrAq94NxMJD3Hw0gQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efqs6htmk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Jun 2026 08:43:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6518djvo033366;
	Mon, 1 Jun 2026 08:43:54 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011024.outbound.protection.outlook.com [52.101.57.24])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbb6dwf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Jun 2026 08:43:54 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sjcVBy4rWk8h/LYh9A1HaKso82aQbqamYv2m2i99r18rEKSTD4L5xBQ++tcUY+GNJqUgf77w45VQehGl8zhwBCBGOHZXWwhx7XER7HjAMnwch9VhK7AOwCxHz6DOuub1FePY8SupYzM5DMneOZq7rS4zOe4i71ZYuH+9EIap1QzFutrkSJgOtkRZ1sE8g7IrB40jgMRIQi7dLsHlS4qoh0fQmJH/AKpPeHFo1vlyVGYhCJb0hzMJD5CE5/YNCx3G7H5SOfRw9BfK0fuB3kip6ttG66/OVYbkF+p6UXEoSKncqsY3DnNGEZZRasweb3mkd+IbYGSZdcbxm94/En3ytQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fJNfi1l44muKYqRmLD8V+VHLkebWI3u04eb3nhQQfh8=;
 b=yqshNz4x39oezJElSdEhmBrEG88a2F4LfSp2HWcLu8a08xANXXbJ8sx3ivEt7uorNmX0GB+lou+ccqHbFyODNBUOxiYZLDztOeDsBDhgxuF1l7hXidJqv90mz9rDOi1HqatP0KLW+ebtjPAMaxiDcIt98LjSjOMHHeXEtdkRMrvWwM3Y0ToeEKEJJehF0vRWIftSAEDJK9taxP7y73PDXXLpBcd+Q4P/ZdAQcO51qKepXtiMU/dNGuFP26I5PCM6Y0DaGNPDQ9KNM8iC4XkcyO/6L3nR1BbBFrKeZP8IDwfATXTLqSP4TO19Jvvjb/44IAFRjfspos3ci60TUeSiIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fJNfi1l44muKYqRmLD8V+VHLkebWI3u04eb3nhQQfh8=;
 b=mrho+bHe8Akm0eeGDiRQDo9t84CgqWJYFEQjlD0X2WGxV5Cr4G+uS1QhaD6H1meKmaMs4pvewY31BtQ+GxMVjWdBhdS/oL1RgNbeTxhpoDRE7A17EDlIZOzKiiRfTFKEoen3xMW3drzSkI+4+aKHhDSI9JBGY2GHog31AyIOLus=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH7PR10MB5813.namprd10.prod.outlook.com
 (2603:10b6:510:132::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.14; Mon, 1 Jun 2026
 08:43:49 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0071.014; Mon, 1 Jun 2026
 08:43:49 +0000
Message-ID: <d9c769f5-19a3-4724-b805-3e2f30541c64@oracle.com>
Date: Mon, 1 Jun 2026 09:43:45 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] raid1: fix nr_pending leak in REQ_ATOMIC bad-block error
 path
To: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>, song@kernel.org,
        yukuai@fnnas.com, linan122@huawei.com, martin.petersen@oracle.com,
        axboe@kernel.dk
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260530151411.4119-1-abd.masalkhi@gmail.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260530151411.4119-1-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0127.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::15) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH7PR10MB5813:EE_
X-MS-Office365-Filtering-Correlation-Id: c069c64f-e79b-4235-2f28-08debfb9e692
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	f86R/9UvvhsOYeSrKZmI/zbpd7ERJv6NHI211m59LknS5rgBe4LUSTQbeomT1pMVIYsIT2fGggbD/irPzY4YRMRWMrTmtYiCJLiwq0VAtMpAAmG3TVw47XvJxp+60lWe8tx1LKJ1q6Njx018JiQPbhqHsQGZgILvb724kcZMfZprhIUD3gLFdBb+U1z6C3KTIEIC1biSE7+FEtjHH5dmxDTGkpYhutnFmt7Fc4/KXfICtnUdW1SmFpGhG19dxVd01QOdg8jqc9E7FH+q3RK6b63PdBFYGcJ2UM8XulyIpfaHD2plcT8plYTYPgWzcVg2d9ihnmMvsQMWW3N0R5/C7YXqB3P33IM3aO5H6XZRTgJgx/yEPFpXiUC1WibwTqQRnqvxMgLyXpUf/ESNwGyJFB+lGMmukHSinbK4w6nfFoixliRmFcHzkn6yyy8ZCk3t6cvU0l2tThkW+OCu7O4YrAc991+5s0cn2ILrnH5hakZ9ODcmLNfBOm2A7nibTwf3HlUvDqZxIqlLIEtXrliEoxQ98dA36/XmhtEvYO15nIL+8kWT7iGRU0vg3P0Xd9KoHPOm4wV4dj6LtVSBVpuTRdGskb5i5dsqZgOOUm3ktyqzKwEO0HsGEujooHrrz3YLGoqpiao2L3LSiKWROF7iZRbAtFYdKtNeqj71m4iKqUr4iOlQJRaVX38TwrMdt3uNZOOjgQkURu3FzFw6kztLng==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OWRhdC9jRThhWitmeWN5WGdUVmgvYlJ6Q1dhaXZrUUlBUEVUTEdJdGFGK1hh?=
 =?utf-8?B?TDhoRDNJSzdkTVZ0VklUb2xQanU5Q0FtbHNQYU96eGpPYTZaeXdQSFE0QlNV?=
 =?utf-8?B?ckRJZXA4aWJCbWY5ek9WSkxjeU9PTENDakovVE54ZHlobFhoU21DdUZUSUJE?=
 =?utf-8?B?djZiMEx1UXcwZCtJcm83NVU0dC9WUjYzdmdLdzBaYUFrVnZhRnVaMnRnMGVz?=
 =?utf-8?B?eUVJUDhsVk5OZUl2S3BTSGVac0ZSWEhtUktuRTFlakxUOWpURW1Zam1PNEpT?=
 =?utf-8?B?NG1VVTM1MUNrYS9PUFlSSWhBRTBWeW5KajdUN2hvRUlSM3hFUGJSQUN3enVa?=
 =?utf-8?B?RmJXYXhNNTljZHo3blFCMnRRQzJLdzhHOHpwR0hoTG9DRzZLeFBYbnJWWGlH?=
 =?utf-8?B?MUh1M2U2cTFwY2dRVHNOSmpMWVl0WGFiTEFEbEZDa25iT0laSUJzV1FWb2JB?=
 =?utf-8?B?ZmYrUkIzMUFGQjNwWGpQVWRjeWlqeGtaUDdwR3lqUVNUdm8wQWl3TWxLTy9r?=
 =?utf-8?B?NjF6ckpmU3dCOVlSUlM0OUNjOXo3eDc0YWQxcEhTNXBhdGZWL29pV0hIeG5o?=
 =?utf-8?B?T0JvZm01ZjlsZ2ZkZkc2cU1oNFhJMk1xa2lIMWNlRVI3V0g1UkRaUFRDeU5G?=
 =?utf-8?B?ZHA5cWpnYVhtUXRITVFPMmJ5RWQwT3dmZTR6SmhkTGNMOEVwdWlMTGxvaGRI?=
 =?utf-8?B?dXUva1NkQnhEWGc0aEFRSzJSU3U4YkExN3JLVXdFWE52M3Nnb2E1RUNTbG5L?=
 =?utf-8?B?QnZHdzZ3bXlKU0ZSbU1mdHNJUGVuKzhvV3diYjdUVjh5L1FXODF4S3RPWEFV?=
 =?utf-8?B?VFdqSk5sZGJsb0RwREpyWVR2SnM3VEVzZlFWZFRBaTVacCsvVWdacU9Wd1FZ?=
 =?utf-8?B?RHNyUGdydmlwcG9Db3R1UlIzdjRZRUFCQ2w2SE5VQlA5aThHdTFPNS9yZzNE?=
 =?utf-8?B?RjVsNmVFampUWGtmcFZJNFBmM0NXWlJqckU5QkdiQU14Z3Baa3JkZXRTclZE?=
 =?utf-8?B?Mkc4dmhURWFzRDBDcFNMUDI1QVVlOHoxZXQwc1dadzJJYlpzSXpTdDBEZ2xy?=
 =?utf-8?B?RDB3U2kyQUdlUGR1SzJaRklTeWN3VjhGUkhTQ3BHSFJ6VEo3K1hSYUttMHRh?=
 =?utf-8?B?eDlsQ0ZBYkYxR002NDFtV1RTQ2dOendyY1o5b0FxNG9JMlBqODZvWDRZNHFT?=
 =?utf-8?B?MFdkS3NDVmVhbmFESE9sSm9DRW9kMEdkT3JlamFJRDJKQTJEZm5OR3hQSzhF?=
 =?utf-8?B?ZFRZT3p4Rm1BTndlSnlsem9kSy9OS2NJSXhyRS9HVE5SZUcvMXZRYm1VM1Nh?=
 =?utf-8?B?QzBPUTdDYmF0TW04TVZNSGZQMXc2d1VQdWNmM0JoTEJKajRkeTVEdzJEcHZZ?=
 =?utf-8?B?TTdwNk50L3hqWHZqaVdYRjRYanQxRktOaVpaMklXU05hS2hpN0RwNW4xd0xx?=
 =?utf-8?B?QnBKZDBaclhiM0Y3OVhDbCtuYkNTM0xlTEFoTFg0ZUo3R1lNV3VHNkJQblNa?=
 =?utf-8?B?K1paMlg3R1FUcy84ZXAvem51NDVIeW1LdVIrSXlWeEdQQjkxUGEyNjlsN25K?=
 =?utf-8?B?OXpTMUkzZTRsUmFrTzZzQUF3bkN5OHc4aXN5OHhOZFluRzhIOHRHaWlsWGRa?=
 =?utf-8?B?RHlQYTR3ZklSeE81MVUxeEpOUXljY3BHaEovYVZvVlZndWZkQXBrQnB0WXdY?=
 =?utf-8?B?TkFLWFdyYWpZMWp6cFFseFVBY05PczUvZnNEc0xvTVFCa3lhS3JDQ3NYZXpi?=
 =?utf-8?B?V0VBNzdKOHJROXUxTm9HbkthcFQ4dXFnYlArNXo4aTFRaFZlV1doOTNINTNw?=
 =?utf-8?B?ajdlcmRiS2ZtU3Q5dE1WcUJXbDJURkI1VWhUdmRmVitYTHR0THRjNWRUaTZs?=
 =?utf-8?B?NzY2N0t0dXd3d3lZZWNmQmdqTUYySGUveG1MYWFVekNZdXZ3UGt5QWhRQVNC?=
 =?utf-8?B?RVhxNUNOd3NuSHI3MkVxSzUydnR5OGljbXgyanRaOFRQRHN6bVZRMzhXZ1lV?=
 =?utf-8?B?T01LbFhkVTdIQlV2bXJVS04yTzZDeGJmM05JSzluZ0thVVpxYlRPZ2FrRTk0?=
 =?utf-8?B?Z05jcUVucVZ2N0tkYkxRQzNMMWs5ZXlQL3BsZG12RElXTnVlOE1DYW1pMzND?=
 =?utf-8?B?MGVZbXNkY0V6VzNRNlpyM0oxK3lSK0lqTDZHTklFdkVUdC9seElSUFR5SjJU?=
 =?utf-8?B?Rk1RYlg1VTAzUytwdXI2UXAxaE41Rjhidk82d2VBWVF2VUdXRTkrbzhvUjNU?=
 =?utf-8?B?LzhhODdpWThOTEdsTGRML1QvdW12d3JkTWNpaDB3K2tXTW1tT00zYUhrdGJz?=
 =?utf-8?B?U3JHUFpVQTFsdlhYQS9ZSVd3R0FHbnFDbEpiazd4cWNZMk1GOXdvdz09?=
X-Exchange-RoutingPolicyChecked:
	s/DL47Agn2L3YnuthRGHZ/gxJztaOZWu5OKwAkDotMMh+4P6/ONMYCvD6CQCjtUx4kCtQoCoOTKGzKxi2vTtctVbQ4AloYCR+IkGlzmkVFXbdEWBDF+A1s4gBudD10NJXtgFW2XjVNS7qsEipJAHAP2q/hR0y3NoUPz2bh3MebXHJlAfM4yT0YlvN46pr4fx6Oj+merjqjL9PrwMi9qgvvLDXPWLNZm4bRIgHWIMLkA44tmwpcykMRUr1LuhUeXCVHZ1ghdEkKffhJbYtHkImeNE5w+/IwbOoe3pk0ExyNcHutJdHKWF9oqII5BjBtGABr76mVBt8AcfOhawR1wkfw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BxyUlgP3N6EzceVDnOJJgFZ23lkKtfxKx1pbmDF/wiFSvQa15UBMEdYMNuUtPsGOw48GmGSFeuaxho1+ACtKdq89u2lmlgEjCDXTrzO1ScQAlYK8QLdgCX4hqLtQbZLAfCTIEV1yckWqzppkSxe2hW5lSw9CB98nP3OK5jDJNECJ4699e4KTu9siKMVlErG/LYGgZ+Tj7IVyfO+J84Qh9vyd9Gk2ZxpEFhefehGYd+mCMFRaNQotKFMtl43o4mOFaGu4OuCryP9UEZdKlZArW1blXJNKv3F2sTxD6gKMWa3ZTagK5PmJSezXdBMdB4fPt6lTdRm5eWgcWFFuDh61KrGbfe0q6wyauM84UqcCI7sQ4cZvghiyffZdmPAn10UHDQXSZUdKdfevKbBOHmehuPhbDx6f4y5l+4WEodIThOcguNJ39P92uSD9+0wadczFc/FXziqHacc1mHWP5PMTfyHozDRdBcN2TZuriQ9b5GTlwqMnoQAB51+no7tvXZJA92SvT37qvy43tg9Uon3A0hsBuba4R3l+UE5Hw/TkWh32B/3Avqm4rQT+tJgShAAulGuLpV72q+hJDP/8RcjwRilWJ82mTS5d1ZoaT7M1KN0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c069c64f-e79b-4235-2f28-08debfb9e692
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2026 08:43:49.3591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RsUGrn22LMXEYVgNvAXzFky0cLKdQkJBep3ByEBXgifFUei8/sfNQ2ExRzlQU7P80WDtj9+xuEo60HRCsdEvcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5813
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_02,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606010086
X-Proofpoint-ORIG-GUID: D9058IuNlKq2RSditgS_Z55km9mnisIB
X-Authority-Analysis: v=2.4 cv=POQ/P/qC c=1 sm=1 tr=0 ts=6a1d464b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=pGLkceISAAAA:8
 a=yPCof4ZbAAAA:8 a=rx5lStYlrIPBbic8xJAA:9 a=QEXdDO2ut3YA:10 a=uGth5_h6dYwA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDA4NyBTYWx0ZWRfX9tw5MriJuqOS
 YSxen8OBsnq46cxID2IKS0cFXbFNFnSARF1xCOguxwotmhlyQo6J2kRthG6jP47S+jxe2vI/vmp
 y3q4vB98WZy+T3d/Iukk7/r9EOMTqyslP1tGM8ek1mVXWW/VhS8doYxaOcbzJpXp5EB9oDGzziT
 jAioi7BlraWbEL6wQ7CzXpm10zS7+XV2vVzdwV3EKyWDQQScPMjbKzXmQcwEZV6PLpOzMgfqpOW
 B4DYVAJ3a6ubZx7hy/fZS6C089cxen2DyIdFxyrqtSobPNRoKO4+lnXocBov9Gd3Hijrgbz8HYn
 yMVhKqdWmiTTshT3fgIaNybyceHRHRJ9RE83+vMTK3oLuHPkmQeGgDAghLzSPFJ+sJZWXd7J/pc
 NVVuOQ4VG6zAEa6gWEQtsqPZ81VfEXLLokrD7h7XC9hxpY4NDCqzWvct6uiqdhbvRCqi7SWMFpq
 /xBc81HeeOOGvSNYDww==
X-Proofpoint-GUID: D9058IuNlKq2RSditgS_Z55km9mnisIB

On 30/05/2026 16:14, Abd-Alrhman Masalkhi wrote:
> In raid1_write_request(), each per-mirror loop iteration begins by
> incrementing rdev->nr_pending. If a REQ_ATOMIC write encounters a
> badblock within the requested range, the code jumps to err_handle
> without dropping the reference taken for the current mirror.
> 
> err_handle's cleanup loop will only decrements for k < i and
> r1_bio->bios[k] is non-NULL. The current slot is therefore skipped,
> leaving its nr_pending reference leaked permanently. The reference
> prevents the rdev from ever being removed, since raid1_remove_conf()
> refuses to remove an rdev with nr_pending > 0.
> 
> Fix this by calling rdev_dec_pending() before jumping to err_handle.
> 
> Fixes: f2a38abf5f1c ("md/raid1: Atomic write support")
> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

FWIW,

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/md/raid1.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 181400e147c0..0084bbc24076 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1580,8 +1580,10 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   				 * complexity of supporting that is not worth
>   				 * the benefit.
>   				 */
> -				if (bio->bi_opf & REQ_ATOMIC)
> +				if (bio->bi_opf & REQ_ATOMIC) {
> +					rdev_dec_pending(rdev, mddev);

It's not so nice that we have 2x locations that does the 
rdev_dec_pending work

>   					goto err_handle;
> +				}
>   
>   				good_sectors = first_bad - r1_bio->sector;
>   				if (good_sectors < max_sectors)

