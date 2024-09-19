Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2ECA199937;
	Thu, 19 Sep 2024 09:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726737868; cv=fail; b=fP3WXKHYhgVYnsyfkPZXV0opT7lFcA3X9u0OsLHqLN3LESAVlk4SUEFuX1vRoOy1BfF29SPWF7tLAt+tI9ng6N3UCHkkDl3ymyZMnwigSblt/PurA/8kZKoV6ZNoFWDBuji98wySXnGRhz8lUjZQs+fesAirFXKn5grubLdyND8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726737868; c=relaxed/simple;
	bh=aEYqZlzGeJxvd6dN9vMuVZ29TGhh8Fw1bn1lk+tIiLI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TCVsmYFBER/IlStNcdk3hVcYbPNvVGTdSzlivBru7B1Cfak6QQNh0NujKeKJS1rothfrkr+4baH3OF9qOHI64mrTelhAwOK59IM3Gmh03RBV69sMZDcFO9Qh9ZbDVdxE/49yiSBCnqO5fH0u6FmHY8OS7R8T4Wa5P00fA1q1euA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cjqSdjFo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YKHu59jM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cjqSdjFo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YKHu59jM"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48J7taxt003713;
	Thu, 19 Sep 2024 09:23:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=SwBTRq8fhEmqnqW2YuLhLptD85qvbdoK+v0E9le2bJo=; b=
	cjqSdjFo9weGXIYdfDLTJlZdHQt41RFNVB2fIKby0ipfJuJfRFiGHvvvocLz2sw1
	izS9Zw/ipvwmnDku0DAgXljEswgkvdJSj2cJbs5pLFskkG90tbMwvwx+QGcdqval
	JDkNu9f3/K7a0ChR6RJnR5/5NRUnT1egPE5Q8X3SZ9AeJ6x2wyiPVRqW90fpHjKv
	nAryn4x7iHcMQKT8UT/O1hynt1iWg6rdUwykaHSmgHRkcu0MVUOF2tVaR4tO2/jf
	OVNaf/Z69rNSjZ/Dp40ZJasybx2wCx2JT/SAHHyfaB81VKuaSjuxHWjDYBF0BL+6
	wF9w9k11BC2yMu1HWglhVw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232] (may be forged))
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3nskpp6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 09:23:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48J9Epl0018566;
	Thu, 19 Sep 2024 09:23:57 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nyd08chy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 09:23:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=im/vFJl30d3I0HzLYdTXM3VZLfdH5MJo3eaMcZwdR7prL4pvqM/KFoXlXrLrCLwOujNhuPubQgyJs0JfdMdGJnITYIJECtU5Z3jYbMDsa0W2LWTsplQ4TbUB96ztKcFBcfyAtpjLzt6DQ5gpOvcl9jNGiHp/p1GzDTocT4+W4TqzPo2AcnvJQO8sKz5opz2cwBeJSIH/8gJ8wbk1cQYUTRJV/Fc3QN8L6zbZapNlQqkgUSHA8gBwrd2p/O32e45jcM5nyYEV/FiEd8I66B2ccsd1iBkhovuzOiwGUlX+6djtOvNDz4hKlElyEl1koeCIRSBTTqZzoPtoJn/Q6HCeUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SwBTRq8fhEmqnqW2YuLhLptD85qvbdoK+v0E9le2bJo=;
 b=af3IdMs8tFtDCHdh1pI9L9riqWSbMj+1HdNSVsK9dfHroJAdcwFwJQcGdBCSi5waraDBaiL/zFsr/Tc8ZOv2Zz5ZAEudyMFBustT2gnQoBQW7QomMqK1loKhssUE7PUolIrya07uKPQsH/TesvelpIsLoVtF8wYP16XmwIwOSjm5cCkQBOq6KMA3NdnzpDCFT4zWiP8qjT0Ap+Ja44QpfPrE//oBJPnoeY+IVWeTTLWWjY1RWgNFQ86PMKmVKZSqES/dX91eDyZHj4gF0J9f068hUZGiqk8CBjrr5i4LzblFuyj9K5rOoCLA5Bk+WAo46xyWJ3tBOGmEExt4c2PrcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SwBTRq8fhEmqnqW2YuLhLptD85qvbdoK+v0E9le2bJo=;
 b=YKHu59jMvpAChMEpw0cd6wV00/0OB9U7PZPUsK9+WkX0rPgwISZLwg6s7ipQ70UKVUNa/InDJbAaGCoWd7MUNWY0t8+U3p9+JPya+3wG3LAbkcBaKhjK7hA9g9vT8GVnl0xJJ7JADN4JirUfEvOfHVlixNybjE7357Tuy7t2WeE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV3PR10MB7769.namprd10.prod.outlook.com (2603:10b6:408:1b7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.10; Thu, 19 Sep
 2024 09:23:55 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.8005.006; Thu, 19 Sep 2024
 09:23:55 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC 5/6] md/raid1: Handle bio_split() errors
Date: Thu, 19 Sep 2024 09:23:01 +0000
Message-Id: <20240919092302.3094725-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240919092302.3094725-1-john.g.garry@oracle.com>
References: <20240919092302.3094725-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0261.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::14) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV3PR10MB7769:EE_
X-MS-Office365-Filtering-Correlation-Id: ac495188-46a2-4bae-3832-08dcd88cc8c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yfEq8NjY5gAQoFjo/w2M2suSHSKuM1RY+uVV29RNbr/D9YwthUUnJZ0Y96+y?=
 =?us-ascii?Q?Tv/Fe62iFUh++MvyJjxz3csvBN8tf6qhD9NbEW1laYD+tK8EMwS7NqUJQCen?=
 =?us-ascii?Q?kmnBC58KN+9FYXZ+x4pn3wrahFuiMGPolayhcudemUbF9uSH8v2Kso019LJn?=
 =?us-ascii?Q?0OMkTGIh2EgtEr9UuDZggrVScknspp69gOTm4r+iyexM5lHHYb2ToQfhLR3M?=
 =?us-ascii?Q?Up0hZlA+gC43URTw5OtW5TuLLWpYUK5EJC0rVJaIsVO3DEURn938iL9t6ty9?=
 =?us-ascii?Q?INWANlRS6iP6eQfiQzoi5s5X8mhJhw5o8QzGQ0LySgenSv3gsG2klTxPl1Fr?=
 =?us-ascii?Q?guIaC9VUrAZXSH0Lp0joTVR//KGSv/pFzKKa/RHDM+eOa1VeJr1wmAmnGl4O?=
 =?us-ascii?Q?qCQP+arL1ccgCk+nz4iTjdv/fSJsYCOFn0JqV0rutwMqmqY+3KP5k+kBTA14?=
 =?us-ascii?Q?Zk316SAvlUeV0epHdCqrovubAtIPJQ6OkRTHgSY7Ke99RoeBkxMvGxXBXd+r?=
 =?us-ascii?Q?Y39VaG2Vuxiwu6OilnNNgd/1NGlNAnEa+F5uzLOcIXvyRp4apdd8dlmMPQro?=
 =?us-ascii?Q?SZwDV4x2hdC/nJesjlC1qHy6XFXvVgMIucaHSQKGfnbAdmUz0sbL5W6vnZFH?=
 =?us-ascii?Q?YwW41h3rQF6qvkXui9JeDAH8RXwshE3WjMtyMJT7Enc/Q0w+YIlXsXBRAkgH?=
 =?us-ascii?Q?vA+CgVwCQYBvXvCELVhSq5OOXmqkMhOwiWiyWxt1fwEXh4EnS9QuIwL3WsLs?=
 =?us-ascii?Q?ykDB25PcnP9I54Zagiik/otll7ubkx3STb05ivWrHavb74oYVQup4FO9+/9N?=
 =?us-ascii?Q?7aGzg7Ijd0+rCf6wooh40UR2U+yFyk0C1CZjqESvtxlwaLjBDEz7y+EEusdG?=
 =?us-ascii?Q?v19BK/ZMrwX4x3CBeOt0rSr3di6RAWPsf1IUl+hKd3Z6OsHn16tmvYrEfMhj?=
 =?us-ascii?Q?7KR4UrxsLYNnmQ+am70IQWf0/BquMEUamKMr/Dqq6pUM3U/7yHTGl5qnA2cN?=
 =?us-ascii?Q?JiP+3Zr4Yfa0nNb/UDjuMztdjdB2btiY/7aWYfRG+HwlCCVgTpdzF4mF47XS?=
 =?us-ascii?Q?KpkSCEJGMFDFSc3rFOpaByv5wOnWfeXDx7m0iMKPmrEqUngK+VbKZnuCJHmR?=
 =?us-ascii?Q?ZrJMqTPObo1qbC8/QRgTl/rVv/aZi6FZp//y8EsbwST+/cwYnFdJr716D9fh?=
 =?us-ascii?Q?lRvhMNZBlFmVqUXquVXVRI7xByUBUZeOa/K51mftbdfaItr8T7o8hk6lSr70?=
 =?us-ascii?Q?y/hfbYfNZMrrbUhnASwTvVWTvUMfswVbR1LaAoqfa17h0l9hFtld50K6Hw5M?=
 =?us-ascii?Q?vKD18A5wlbMvBcsDe5E5zlvP9nCD+jeCieGGLR5fTxbvXQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MKVUi6SiPOq1WnoVamxpL5yvR04X5KPcSwRx3uHVEYl+PTV4Uzy3kDQQUIUA?=
 =?us-ascii?Q?zSJN7O/tJLx1GCUn8M8XlDVIGtEZ7IoKif+QlYfRJOJF5CwZ9p1FEOab0jPz?=
 =?us-ascii?Q?bmBrSGUL3TClzOjqkzjZJ1XvbPyQpPKvgmWhv3u/OjOtnb1bE9FUwA0dPUGH?=
 =?us-ascii?Q?1EK43RYtleBoIsiWKm9XjwL41ZeWaJcm6fVqb4o8E5IBpVAJBm1+3ivbAe9r?=
 =?us-ascii?Q?yNqoc6I9zMyilonF63VgwGkPVfV+U2aa/BxewQzcl/G1OaW9b1cBeDUhS5O+?=
 =?us-ascii?Q?fbxKdeAl0gidYFOSmx7eMDVV9jfbqAiAG4i8ZD6h+I73T/yDZ7qwDQtmJKi4?=
 =?us-ascii?Q?FU8FAZmXe+gCpoV7WqfKAe8jL4xYsoVhvv5yLImq3p1hRJy2EIqqYbzn/Q4p?=
 =?us-ascii?Q?QW+e9sX8VYuVpG/cCitcWKMFt61n87vxZNCk8pvQkrOXO5quv4v9q69m9Tl3?=
 =?us-ascii?Q?UVXWSoRfTdQh4XfNwpA2ZegdiIYPsFhwgDdlnknlyJT0vFOD34lkJioeQz88?=
 =?us-ascii?Q?mHxL/4aOeq2YPjT5gxExczs13gWdkRzwkoXoqYoGQbQTVUgd9DkPcAmXMdCG?=
 =?us-ascii?Q?zhTr/J/3CD12KYyeuenxhMNE7YLgJF2pxqq6OjueTKYHjeo5XR90GvjcCoRj?=
 =?us-ascii?Q?gW2zOncOvEQ9CstSNwOw70EGLr310pzJOeVVHGPYbj/3XLVEBWyXBemsGZY/?=
 =?us-ascii?Q?btKjmqQHqACjS3JkBocBEOq0rz/qQMMqnvlskZkgR/hg3r/APEJj9Tl8nSDI?=
 =?us-ascii?Q?f4K639whhaVjlukExNeSb+uglfKAeSFqeu5Ecdzy/0VRTnka45xwsH9oergq?=
 =?us-ascii?Q?b16HYyaK+NirTFIgTkmwEt2nDT3Utc+LI9/SsEYiwF46pjEYIhUAfw3vMnWb?=
 =?us-ascii?Q?yfXB+ix4T8FwB2QazFByr7hncgb08AK870h9pN/M9b6/f17RL5uudbTEQqQb?=
 =?us-ascii?Q?P8z9rpT9dLBRHM1XyEr2KEBCGgK1RGjEtlkpNyWWgwBycRSTdg87qzFYBsjg?=
 =?us-ascii?Q?CG+UoWsLY8K+k5tT50fhoOYA+uHNdQyn+DewxkGXAoDwV90YJfu/ZDIH4Epf?=
 =?us-ascii?Q?SWK8JOuPO91oa0d545A7BJDrQ9essxoBbMrTa19CHa0uwfj0LYhWj6sEB6Q2?=
 =?us-ascii?Q?Wb+LEVlzSZLrevCOQfBas+5FObBUEO50+kNFy/WlQQwQLhCsJ9+nyzrUcawj?=
 =?us-ascii?Q?/3XhLhyzC/mSOt+hfuVouCyE8K6J1/9GxFSYeZJKpFt5czgBn/QNT3D/yLwZ?=
 =?us-ascii?Q?Jpwl8cG2vux/VG/4ALQNIqkfzF0Ig25EO3+1evGUd/0mrKq+oadvqUWWUcOt?=
 =?us-ascii?Q?HgAHJnPNwK9yy5UpzwDYOZ9KWPS3Y+rfZmFX+BLYxLCUiR+KKvkeyur6B5W/?=
 =?us-ascii?Q?B/8eXIK1pw7d7i2CCe9zeG4i/a0l3gmQqQuGbSjiiETDMhcge5/8PA4YdKoM?=
 =?us-ascii?Q?3BVs/r7jlZlD5uNEz6yeCUboxwYyZtzirylXm4h9gwehmOrCXFBk1p4Ebg7h?=
 =?us-ascii?Q?WDeqG621iyVieneGa8H+8+fBjGIYSelKdbwrkHfp67Q5nxEJCSvdW4/Fq8xZ?=
 =?us-ascii?Q?AulmCDOQk19Ag3D+VCRm2PQh6VWvjoNHi3PnHN9dqotUBAfAJee/7y36oDEf?=
 =?us-ascii?Q?4Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PKH20TvnjVqLKRXoDEA4SVpXjHH/ClqOVinW/8OUkwPlAsZSd7Hlcvzxis2b8xOioxxQRTSzeVTOUvoqY54VmtecrF8EqMRMvBAHu+qpiEM+4Upw5ZeNQxR30O3EXzGkfsml0SblZobtJZicEaxrojWW0nqDXe54jHRpopHMlFfYDLD//W6JEweSQPDTtuLC70TrbSMcEaX+fg0Kr7peNVdnePcdrGnf4cERq5oXwgOgpzGY5gu/mM9zOmlJ0HsObtr63Uv6hS9D60/UxE07pu5hXCNZCampJNHOFmDXNAHyDyuA1bjK+D+Fo6D4mOhGHYlJW8h8gy20pWoZW7CEhnrTaVGZBpYxKGw5dvvyEetCrI/7r07iJ0lK1+fvicODO+8tjSMIrFXYHch0Bt/I4VLCWOm0q/FfHneGDLukgLL7ZFlRAhtU1uoHZhcYnvaWei854wKXWqHEg6VBGETJobKp3VxxbD1Y3wKgHrBdEu59EqXtfZsUMo245FCcIpUCbnPDdJm1erVkTxRf3G0YWNN5Ci0CiwsuIv7QXUNh/TrCvk1t8xM1PqREymdZH61Yi4r+1XcL5GSktqPzk+ATAtrMhqDZ114vXtiPmfRoBTw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac495188-46a2-4bae-3832-08dcd88cc8c7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2024 09:23:55.6212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eXCvDT88YSQ/YzAbF1at6OyeoO3KdpmZRaFPDzeS+fhgE0Z7SMqTuQyih11o69a0+udBMk+GQLDWv76/eo46EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7769
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-19_05,2024-09-18_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 mlxscore=0 phishscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409190059
X-Proofpoint-GUID: CSH6D5vk1iZ_4BkTRsd-obrvHsu4IUVI
X-Proofpoint-ORIG-GUID: CSH6D5vk1iZ_4BkTRsd-obrvHsu4IUVI

Add proper bio_split() error handling. For any error, call
raid_end_bio_io() and return;

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid1.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 6c9d24203f39..c561e2d185e2 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1383,6 +1383,10 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	if (max_sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, max_sectors,
 					      gfp, &conf->bio_split);
+		if (IS_ERR(split)) {
+			raid_end_bio_io(r1_bio);
+			return;
+		}
 		bio_chain(split, bio);
 		submit_bio_noacct(bio);
 		bio = split;
@@ -1576,6 +1580,10 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	if (max_sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, max_sectors,
 					      GFP_NOIO, &conf->bio_split);
+		if (IS_ERR(split)) {
+			raid_end_bio_io(r1_bio);
+			return;
+		}
 		bio_chain(split, bio);
 		submit_bio_noacct(bio);
 		bio = split;
-- 
2.31.1

