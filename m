Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723351DE4E0;
	Mon, 28 Oct 2024 15:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730129357; cv=fail; b=Lvb5v2REY9ldqUF6bBhJNix9ESQrIsHKuM2x3tBbVRJRtkzmi9lvJ07Wxyxn+GEgQt9T1z8vWxq9sSlex/59emNlYoAl4lTdQZkwlBkwd4HhXESU6DRXcyhRsz8FysBFUKEINR+C0IE+6dgfhQOCrqbjhr5xepgaXFL8LTWF2gk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730129357; c=relaxed/simple;
	bh=iTpHGOmou9QZgep/pRVn/CxUTYsxJkracQjiLbQ/YLk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WPWmLLmqIXsKy3skm+/2KjvNfqPOBVMYfHSP/xGadEAaypTjx81V/hFgiNRf1YBEtSbucHKDSqsgXQaCjQvx4lAh9MYZqaBuo8+JzGNRjTAqzLJFdLFOl1BSMKRhmb6M8C7uGLr4e0UhqxETtzJi+fsN0Zz1UruyV6E6YiKepCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TJECCVZN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=I2CVBH2U; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TJECCVZN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="I2CVBH2U"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49SEtedf020914;
	Mon, 28 Oct 2024 15:29:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Q5CXf+PHJ4l2cVACcluwS/nmIExXFJ+hJGBwEkz4JSA=; b=
	TJECCVZN/54XgYb1sWXw6vHsjbRMyfzrEyM3ZIltrcHl/MsJfd0z9A/s8hGreE6q
	0GRsoV+l0RWFk3cCAHUWV+G8I9wzyEG49psoFdmRpKVNHrMSBfJ3y/bFRRsCyfBM
	1HpsrqoSiTrRJLnkCxLymg79+eze6m9r234T7Tx4GvFspuxzEphDBmVi5czpKzkP
	6QHUmPhbTcpWuv8rLSMkw1FH018OyGMl6v2F9h+EfMtzacdXPrGnNFI8DHJNIl5f
	Stin3NwO91fiooJEvK2G8HNFD4VHv+Yh6EjoVjgzf+rf92HCS63rZ9Sr+aGaNrtf
	GYZ6dIB28dDSHNF/f/GqOw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grys35sm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Oct 2024 15:29:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49SFFiB6011746;
	Mon, 28 Oct 2024 15:29:01 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2048.outbound.protection.outlook.com [104.47.70.48])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42hnaavq6u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Oct 2024 15:29:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pWU599GgKHgdW7hXUfyduYzyZ3PhA6IqCIQA5x+ubsY8PNwXY2U+ZUPu8UW4WGbcRHbQgZoSqL0xS3KOid++nuvGCi/RmslZLlT58pSqFHXOm1hmc/GGCCtbfzUqx7Uqq96UlGvLW+lAUWA/C516dwl7ZvHHAi+U+KsP51yTIIiQqN1gRHRpPFIycnvijKzLKD73DWRQXAPnsg/kEvhIWFPYQgoalypo5X1c0Che1dov71mNZ3HgAp72X5kbM1Owuk2nqwOukzVsZwGrljMWB7+THKpshaaZrLVpTbR705cg1FIpGL0EkJZPemSuIFsML1zhDR0mwrOF0JklXBVR3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q5CXf+PHJ4l2cVACcluwS/nmIExXFJ+hJGBwEkz4JSA=;
 b=Du+Maqg1Xwe7/bHkCSvriiBPdvDwKg3Hh3MfyYrAjFJ8blry3ozUyRHRmK6I9ituslz3pgUa00wr9FGwOStY5XbEKusoLdD39RB9DAkNyBQQz0m7VkoPAoiXi1MIZ1udxUZmL7aItA7sXK5lKxTGTXpoghW7gWkJ0KojubgiTc/mnp6bMudSloD5i7CUxX34oU+JDUx7cl8ML3QHtQTng4TNkXL9PcEajS7i2eYEhVgsQdlVhFtARRo7dV5pBPKPkHJjfCr8TE8o10dfQUry5aSubxHWZZdaoe1iuOGt9uYCyI6mJ1TmpyhPkMYPapABA9Vm3wPlybgv2UonZaIxsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q5CXf+PHJ4l2cVACcluwS/nmIExXFJ+hJGBwEkz4JSA=;
 b=I2CVBH2UZxrX9TIiYE02DrA0mkgtUqZPSH1BsJQs4W1Fu0dna3Qx54CB9RcNn0z6u8cgeiYev0+9Uo2pp77BS59rQaAJAuidNGEQzjTPAlUE5pSmVTVzGScvved46+iScmiUXrp1Jp30g2dnqw6dXueEaeKn4wk5olRNEuQa+3M=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB6299.namprd10.prod.outlook.com (2603:10b6:303:1e2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Mon, 28 Oct
 2024 15:27:57 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.024; Mon, 28 Oct 2024
 15:27:57 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
        Johannes.Thumshirn@wdc.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 7/7] md/raid10: Handle bio_split() errors
Date: Mon, 28 Oct 2024 15:27:30 +0000
Message-Id: <20241028152730.3377030-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241028152730.3377030-1-john.g.garry@oracle.com>
References: <20241028152730.3377030-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0155.namprd03.prod.outlook.com
 (2603:10b6:a03:338::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB6299:EE_
X-MS-Office365-Filtering-Correlation-Id: f73769d8-dfdd-4f66-fdf2-08dcf76519aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CQ9NXAyzaCe6jkVKgn9S/yjhnbCR7yPbpK6+4LH4tCsq/N0cDzesGdfDGn+D?=
 =?us-ascii?Q?2OQHch7ZHmKDiKgYCGfOoYC/bkDOF0gJlcVjodTwjKCMD59lOpigMOHP1Tnb?=
 =?us-ascii?Q?2sq6YwrVRrN2M6wyvSLffnM7CplUH2pP+flKsakWbubiB1JO11GlXrFf0PQC?=
 =?us-ascii?Q?xK0S6G+vUB4OIGLUKoKXi4Licc/97BBkhvsYJmDLWAYnstTQKZ/PvWvMKIqA?=
 =?us-ascii?Q?yOpp0OeXIA0h/jhgTFB+bvmQ+7jt7CdbV/FuVCHK6uqP6Y2hDTt6oZ1F9n4O?=
 =?us-ascii?Q?KI/gaxer/MeNLlwpAxWdQaXF0C+rCyDWQQivacMmSwflg032MWgssAaJiDvq?=
 =?us-ascii?Q?wq7+5Be1iIvJYp6Bs+9hJ8Pax69ZKXoCsEu1JoFwh2krU0lEDFhjglebyaP5?=
 =?us-ascii?Q?OHSVyV7RuEfsH5s4/gw3oYc5V5+Z45zmPbdnlLQb5yEqNgg7DHo0E8kMGWcn?=
 =?us-ascii?Q?90nakY+ZJ/lT0FAzdsQ3NVR5rBoVlVBJ0qgzqk52Dj4pp10M2aUb384bZ81w?=
 =?us-ascii?Q?nHZywaOFtfGXaS8on8gnBomNmYfFef0sqWmExGrPfwGPLDxAuE0jxaUy9AiM?=
 =?us-ascii?Q?RDJEkPQ7Ep3UTSOF5vjUDw2RxzSb0Ekf0ZG/UdT+qbSDQ7PWNZhX7Q2PWN+r?=
 =?us-ascii?Q?OU6uA8q/ZAyRVbGXNw1OkpcAQK81SaVTajxspGU8AWNO3vd3JSY/JkOkEbsJ?=
 =?us-ascii?Q?HZEjFq397/0MidRo5hXxbUsJVKGaWmLyHbsh4BJt+CuO7zg+1ArqzEFOWO3J?=
 =?us-ascii?Q?u/rITvRum4ixm1H6528w7OQ6j9noNw9qgNMH+Zxapv/M441Y9pdTjxPEvBqB?=
 =?us-ascii?Q?Idld2EXgAqOl2Y72VKP7Ht1I9mmFn76Yyd82nOQyPOQivdKJ1rMMzKDZYDqi?=
 =?us-ascii?Q?lsi71m1h18b+xuxIdZ+bCAKP1GEE2RKo+JCsgpZL0jrvodmQSM9uTtrpjeww?=
 =?us-ascii?Q?JUThnMHXVhZnRLuvcfzI+eoxmxLufe+sZlW/VX9+cHDUASM/N4b1y/Ternn6?=
 =?us-ascii?Q?yzz+0WO5es5B/iNB58HCPsRYF39LPhbCsyaV2ouus0vbgHgqIOnI4bLo4ZnS?=
 =?us-ascii?Q?hHFfV2s/2jbKtvH5hYpMed6li90oj2kAk7zAAr2fquqoPf7WfZ3x9jbIsS+e?=
 =?us-ascii?Q?PmRl3Nakfs5USgVi9aoNRhZUzpFhWPQnQRhKFXMSehheXwqdYeDqrN+YHWk6?=
 =?us-ascii?Q?/iPC2eCXtznYNLyDigdKzuqWnNlIVP1isAGysq9FXCE2tQdsWpv+JvgJZ8OI?=
 =?us-ascii?Q?B7h2a0oHPFu0USCHoex8IoT1Gl+d2js7BLE2xvzbqAgO0OgzD5vDnJujvUvG?=
 =?us-ascii?Q?dm4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oyBnkbvaU+6DA709ulDNg0hyfHD1vFG9HeKIcXY1pj9vY52cDymfk3e1BJV8?=
 =?us-ascii?Q?gwEgD+q+ZNfTAl/pF1AXNJ6pjgBtDMSSis2DFW7MyT8WWY/QQrjV5ia3lHi/?=
 =?us-ascii?Q?VCErMRKQX5+9BCo+j0KnaODf8X8yV159brUz3wPt6kxFzQ4KupKbh3Muhwi9?=
 =?us-ascii?Q?P5hk1RfYzRo6b9hnmQYWpV0hA6jxIQDgxQXBA1h5PJCggVPiVVHzW5xhzGt7?=
 =?us-ascii?Q?mD4+pNreg6KMkIhcJD72zEGnAjKej17G/+DMq+eposiGdkuJsecGHROnpamJ?=
 =?us-ascii?Q?4OzdHbqF4vT6/P+zox6LOT9S1FYfu3/Seeze/YscaHyMAuWitgpRri+VqsRo?=
 =?us-ascii?Q?WxMqLEQXxS6bMQp1zUbQPCzcEM/9QnJ272o1dfOnJKlDs5YivkC9CcyIGgDJ?=
 =?us-ascii?Q?2Ba/tP85tF0ITUzd6J+5R9G9sKc6h2Uc/OL5OIiAqzwsyco9j4nOR4bxYE8V?=
 =?us-ascii?Q?vPHElGoBnXW2Ai3TLWviDRuIm9TFOSyQEbPk2uBCDQINhh+6b6R04o+63xzJ?=
 =?us-ascii?Q?2rNCnn3OPEbw/i8uyVXwOAy5gJvpJyNeQyfBBvxdRNR1UGzXW6nmtGgwpT1w?=
 =?us-ascii?Q?+PI5SP6TlOLPH5wvSOio7S0CuKY8i6ul/3a4RrECWPFNHgWyUN9OZ+d944Jt?=
 =?us-ascii?Q?dznwcDsTFuI1YAdpmbY3Ql7cBiu0pWadp90YNt3/bvW9ydEgghTXAecLrQlx?=
 =?us-ascii?Q?OLBUtMpcs16ZGQFyvNPdXjKUYxDHajd72aKU7k6oGF9fQZi3rqGK0dppRQhH?=
 =?us-ascii?Q?4MvNmjJH//13OulGdna56SxpElFEwKMUCVsPko3iXiWp1slxQIxyF5hu6itE?=
 =?us-ascii?Q?JysgJ8ECy760x3clAdUCW82qLK58ekXDhRhaS6dkTozxA/Hq78LzYbAsQJqg?=
 =?us-ascii?Q?ozbfG0rjwE1tSTYEe1gIay9NUUs1cSfTnrlvjZ7H/jtD8CFMDTqUb0RLx9Iv?=
 =?us-ascii?Q?/9t1txot1Lw75ZZMq+NhME6b1j3+K+yxrPLyvsWQZ0l8OSlPqqcuzYfJRPSN?=
 =?us-ascii?Q?jWWzJk7Tq9BL9LMUavzJl1nlB+h7TXRxluLPXProOyFXRjDoCxSuj/y7N89X?=
 =?us-ascii?Q?8L9hzGLOuu6mUduycTlHme5QT8WkYJvGtfzlnFh6Qk+SJOWGIUo1pNTxSREy?=
 =?us-ascii?Q?I2QT/NnvNTa0ILkBJbw09miB1S07A4fvddvgBq/YKH19vARy5aPZNZgeqPQf?=
 =?us-ascii?Q?KwT4r9x1Czb5k4b7rZT52KLtootcd7X5Dv9E3OpYMKozEX4qtX2hCu+iCjyj?=
 =?us-ascii?Q?Ci0lPbkMgOEHgwtpCBtHGpb80GPWI8lLMDNO2fvq0S9+mHi0wA7aYR65euZe?=
 =?us-ascii?Q?Dd8UvqsZvWninwERU/+CCaSOfWbOH3h/UNnpjP8AKdOKD2ZptizDLg1b7kI0?=
 =?us-ascii?Q?f481KOrOCo258jFVsS7d1DUfqIEx0mxFn0L2zXfo8dxEbB79H/samNFYnuH4?=
 =?us-ascii?Q?OaI0MttvFdNqkhKXMZ+C9vDHFdzMaQ0plf2FnbPQWuaDBOMe6r4o8oWJmFQX?=
 =?us-ascii?Q?TGtmV/tpCp44vfIpMjhIHVz2/pNGZ7DfMAhsRLrv/dl7QgbcMS2taBkId01A?=
 =?us-ascii?Q?M5yHqCDVAIgjAVSf5o4jTtBIyQmdeQMzKgpRiEQD1UJ98gn0W1N0jHlLb4av?=
 =?us-ascii?Q?lQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ApcYgCrxHEY3T3HRIQ11M9OLuKY0AYfHstDRd8IapBXjLA8s+WVlQktouRfT1mcinAp70rwpJmQv46NzQTogrWFkayydeIS7KnlXoOJk8Ki+IQr/hdBeUTLSF6ZbKNk0QI/2DTfDemD/lFv3cwIwYrLXRwDedyvxwBaUhJKoaCIv23H4m/TIBlKXcD62+SHCnMWiRU94ph6OlUoblgce8a2U170cQh1zPohfX++87v3hp9n+SgVg2iZekCk5VFmuDFT6glzUZrAApWrGWZ3p7Dd6K2XShusua3KViLNu0SECQJnW0Og9sT9TWHWNihhj6bNPLCr4em6TcXsQKOkCacIrzY9VM8XdKZRFe4cbU3LUalJG+rfCm5aOc8xmoFebvTXbftbGw+dKOzifLRdMGQG6LHBocYJmuIZ14BxYN2F7+kj0uIYbnl0kkmUfciawP/8UgNnBKQTnbvUJDPxw1uQIa+3PGDRwdU2h2olTrni+08zTdikqnKj5Ux0de9t+uh8h60OnrjTjHaLSAI7LukTp1C/ZhK/QKR2ld2m2H58PDSXT5tQAuTfcRoudHk5Btr8MJInuM9gqth0FTCdsLDukIU/lHPYD/savNVhBn7o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f73769d8-dfdd-4f66-fdf2-08dcf76519aa
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 15:27:57.5726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /sTf9GOY8g6wmzp4G4NfYcHuXrXsMEWDtov9nEwiyiK1Q5ks1NwF/4oYgXWfvtvvQcJtISBSghAmFTW+gowwDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6299
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-28_04,2024-10-28_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410280124
X-Proofpoint-ORIG-GUID: TBTtwxzJwTIe6riRWRu-RpkVbDyxXMYp
X-Proofpoint-GUID: TBTtwxzJwTIe6riRWRu-RpkVbDyxXMYp

Add proper bio_split() error handling. For any error, call
raid_end_bio_io() and return. Except for discard, where we end the bio
directly.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid10.c | 47 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index f3bf1116794a..9c56b27b754a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1159,6 +1159,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	int slot = r10_bio->read_slot;
 	struct md_rdev *err_rdev = NULL;
 	gfp_t gfp = GFP_NOIO;
+	int error;
 
 	if (slot >= 0 && r10_bio->devs[slot].rdev) {
 		/*
@@ -1206,6 +1207,10 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	if (max_sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, max_sectors,
 					      gfp, &conf->bio_split);
+		if (IS_ERR(split)) {
+			error = PTR_ERR(split);
+			goto err_handle;
+		}
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		submit_bio_noacct(bio);
@@ -1236,6 +1241,12 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	mddev_trace_remap(mddev, read_bio, r10_bio->sector);
 	submit_bio_noacct(read_bio);
 	return;
+err_handle:
+	atomic_dec(&rdev->nr_pending);
+
+	bio->bi_status = errno_to_blk_status(error);
+	set_bit(R10BIO_Uptodate, &r10_bio->state);
+	raid_end_bio_io(r10_bio);
 }
 
 static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
@@ -1347,9 +1358,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 				 struct r10bio *r10_bio)
 {
 	struct r10conf *conf = mddev->private;
-	int i;
+	int i, k;
 	sector_t sectors;
 	int max_sectors;
+	int error;
 
 	if ((mddev_is_clustered(mddev) &&
 	     md_cluster_ops->area_resyncing(mddev, WRITE,
@@ -1482,6 +1494,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	if (r10_bio->sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, r10_bio->sectors,
 					      GFP_NOIO, &conf->bio_split);
+		if (IS_ERR(split)) {
+			error = PTR_ERR(split);
+			goto err_handle;
+		}
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		submit_bio_noacct(bio);
@@ -1503,6 +1519,25 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 			raid10_write_one_disk(mddev, r10_bio, bio, true, i);
 	}
 	one_write_done(r10_bio);
+	return;
+err_handle:
+	for (k = 0;  k < i; k++) {
+		struct md_rdev *rdev, *rrdev;
+
+		rdev = conf->mirrors[k].rdev;
+		rrdev = conf->mirrors[k].replacement;
+
+		if (rdev)
+			rdev_dec_pending(conf->mirrors[k].rdev, mddev);
+		if (rrdev)
+			rdev_dec_pending(conf->mirrors[k].rdev, mddev);
+		r10_bio->devs[k].bio = NULL;
+		r10_bio->devs[k].repl_bio = NULL;
+	}
+
+	bio->bi_status = errno_to_blk_status(error);
+	set_bit(R10BIO_Uptodate, &r10_bio->state);
+	raid_end_bio_io(r10_bio);
 }
 
 static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
@@ -1644,6 +1679,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	if (remainder) {
 		split_size = stripe_size - remainder;
 		split = bio_split(bio, split_size, GFP_NOIO, &conf->bio_split);
+		if (IS_ERR(split)) {
+			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
+			bio_endio(bio);
+			return 0;
+		}
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		/* Resend the fist split part */
@@ -1654,6 +1694,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	if (remainder) {
 		split_size = bio_sectors(bio) - remainder;
 		split = bio_split(bio, split_size, GFP_NOIO, &conf->bio_split);
+		if (IS_ERR(split)) {
+			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
+			bio_endio(bio);
+			return 0;
+		}
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		/* Resend the second split part */
-- 
2.31.1

