Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06D247F69;
	Wed, 30 Oct 2024 09:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730281802; cv=fail; b=lZqZ2JBU3xqyYjXQNEMlJPQxsl0Y1VXXLzs5Cgi0CNJgiUl2nSe4qhTmhRC0XbmOZHU0eLvCY0wNWp4JyEA8eF915Sbj94l416KNKo86PNMSO1PRJRaBBAIQOJrN87SyaGXTgjgT6JKUV8aHF9djV4YbpfkP53RAA5+J58NYsBg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730281802; c=relaxed/simple;
	bh=01KhSciHhDpqIB1/6U5BBDLB75C3JmBwAuju0Jwc1vs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=k63VvORrrYsclVCXrp663k+k9jGjloNnIJnRovdqosg/EDqyB4JOsJlPmLsy+tGcsW4aIiGRtVw4AXUNnlV1HnkCVOkYoslusvplbGTQcN2JbE7WgvNfeB6o826WjdF7cZGFrDndXaXUmZJ9YNglwvf3N8KQ8aQ9e3jpG1UEFD8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PnlQWo4l; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tiZ+bcfK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PnlQWo4l";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tiZ+bcfK"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49U1fhbb021327;
	Wed, 30 Oct 2024 09:49:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=/CmkZMrTMQ9ALPs/Yfn/GrGBLtTKbirfOTt6rVEjLxY=; b=
	PnlQWo4lSC2hiXzrFaR04pu2EQqkRKJRYpeQuF8t6iTn2BAcMZK3JWBR5vi0/P7M
	FpEoJMt7oDWv21CIhaLs9RKG5dzZoNPChjyxUbxqnnGtyz9GdG/qsiveA+2lq0y5
	S2E+f5LQdgIqBLgiDbQP+RWNS8iBKMASXgrhSyo8Xt/iOdQxdtsLbu1clqPUfhDB
	uM4d+RMFygY6sq0owYtew7Jw6EPkQwTsqIUyM5TVaic76DDpm4FrKdWjSgXVjYDO
	ee3idpzLgULpWn2oV8wqdKCUApQyJ11NoUpPKzupDPoP6iPD9Xltf6ZOIVzQxoKC
	ie+9F5zvT7hwMtC5Qy6nsg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grc8yka7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 09:49:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49U9C3jT011747;
	Wed, 30 Oct 2024 09:49:49 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42hnadsyqe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 09:49:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P9pmnhsUvEMRoxW1AMrq5ddCzqNVD73x/UckunKDzWlAcGaoAtMVUgPfK/IyELhKs6lUzdO4qKGZ7my5fCiMwxWcND22gJygUhDg1hqIoEX5zDi/sYyTX8fj5xDymOsaeAH2zUVTCtilixy500oPD7jn4eHt4HN+LJVV49EKuyN06W5uzSm//GffC5HfrkPEyrAgD772QGat9MyKgxX5tRtAvVpJgK5ef4JpFgqQocLjLsV0Hro+1M5crwLsrOYyvIqTZv2qxYboKPhMvtGgA4ebS7Zm/XUwGaTUhu5O1YGvNyIck51ehf9KsXMtSCwzKsJH/jx6nGJYp7GN4Bo9wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/CmkZMrTMQ9ALPs/Yfn/GrGBLtTKbirfOTt6rVEjLxY=;
 b=UP8C23zarQl7gRRoDaspdt9DRiaVa7XBWpYHWV89hoxIbm95QccuFf+hnjrm6TpDdWwEeS9dZ9iXwHYALASNZyRfklWjNHNGByRW8oCqH5z8q2RQvVRCS0CGmYBFHpz7GKlz1iHkFzbwsMNJiIv9CqNr+TtsTweZLHtpUNbymJ7O8PNAeVVoyKk9Or++Hrlmt/ZUCQkfNPe438fZVeZ0L0/IUhXBWqbTBRZPX/w7sOICrnJzRk7/aM5ytq7QGG06b159EB8xL2hXzc/ZF5eoN6Z9iRC48fZSR5K5nqE5kdUphokkl//RFk0maljXI9lmNcWZcMHus0E45VagCHPA3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/CmkZMrTMQ9ALPs/Yfn/GrGBLtTKbirfOTt6rVEjLxY=;
 b=tiZ+bcfKoQuhqNafaMwhmNPrnJtUp2vJA7NHSKWtYy4zQdTd8jmcvx5fpiPPlT9HrczssmrJ+iCIiBDyEPJa0qKq3V7Je/lsvvvQ/TR9OpAMKbmq8RdMxXn2xd+OI1NY4bMcu4Zwl08/YtigESmntGZ5QCCrqKB0XJO8OqzKlJs=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ2PR10MB7826.namprd10.prod.outlook.com (2603:10b6:a03:56b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Wed, 30 Oct
 2024 09:49:46 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.027; Wed, 30 Oct 2024
 09:49:46 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 1/5] block: Add extra checks in blk_validate_atomic_write_limits()
Date: Wed, 30 Oct 2024 09:49:08 +0000
Message-Id: <20241030094912.3960234-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241030094912.3960234-1-john.g.garry@oracle.com>
References: <20241030094912.3960234-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0063.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::27) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ2PR10MB7826:EE_
X-MS-Office365-Filtering-Correlation-Id: 072131bf-a184-403c-48cd-08dcf8c8301f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UUIDsj7j/iLinfveKv6q5nWjPeqoBxNx57n8pXYxNodsrmPSQJSWX0TI0FoI?=
 =?us-ascii?Q?EZk0wSqlqBdbetTc84NJ/koiC72WTWsDNC6rhTXg1VYkJrKoP71Pq5hJ2VCj?=
 =?us-ascii?Q?3gPEXnT3XJS7y8z2cx7SHNCpQOVqb7bsXE5Hf4w6x707xmvYTCraRHUKvFF6?=
 =?us-ascii?Q?evLC1ZsHzK0vWC1YJlb7zjdlvzRGMaSshSEK0t6IhWut/i9AHUh8aqmNouvs?=
 =?us-ascii?Q?Y8OduQzDMtUtsrV/D+OmAzC+G/LbLBy/28wbrOXLqgnFd9MxllcoYdSD0Nun?=
 =?us-ascii?Q?uAqWXqA10N4IHGNp9q+dia/BYXbZ9jmeYMbRgjyVQ8zRCyS2jaHvWsh901pC?=
 =?us-ascii?Q?y4O3MkAsXyE4bUudQ2reuAe4a22uot6HI4hggItXwju77++2lpNcycGMA/DX?=
 =?us-ascii?Q?ATS+lbtRsbsJ0wVko3WOZjt9Uy70YtrA4mdD9Pf964qCdKryKDHZ6Vm9OaK1?=
 =?us-ascii?Q?lGvMqp0ilH0App61vFdYniHcxKzKzYzzBRAlx364gDU3XDDQUQDl6p55rSxR?=
 =?us-ascii?Q?sD2pF1KhHMyRaeflgFGWs5X8HYd7e7giAbnc2JhSvqoHfz8iZ8+bgZIQiCzr?=
 =?us-ascii?Q?PA1ycJ3oX0YK2ZyG2lP0L4fDGCSTWxga4Q/Wxjgcg8mfF7urT/rJaiKsyI+G?=
 =?us-ascii?Q?hXxwL/CEguCYlJaXRoBLfva7J6BCVh0Aripn2f8cNYjDMZI3U5CJhlAIp5o7?=
 =?us-ascii?Q?RkIbjLd5rMAwZI5AShEEOF1r404LjaPreY5zo1AU6WKtTSemyu7Lm02pdsxA?=
 =?us-ascii?Q?Hl5rAjxh5ZrM68LDsGgQ+uXIgacU2I/Oaiq6KYFphmx/12HBjNHfigRLsgT3?=
 =?us-ascii?Q?jpSNuwH2yDoLtizYkdrvPw5QRa/3bb+TUaa86WjvLRFICBrZJ8yCjkxKtNcb?=
 =?us-ascii?Q?KxPCkH38f3o7GHELBHcMOa1KRnSzrZB52DecDuiehgq2yAsWTkB4eEF9FIWK?=
 =?us-ascii?Q?DxQbEJ1BZHKLF+p8C09F8Rf6QWKsJlheM19UpD3aCg+lcDW+Uqb3w71sgJrh?=
 =?us-ascii?Q?yQXdFXmSQvXFonSJ/33HRzIx9qt9+adk6FC63UsvQk3ESpYpczBAd9BvS4Jw?=
 =?us-ascii?Q?DjI+Rip4rholfQx89GKjMNIrCaIo8UtIMt/0qlEu/5aFcGcGrVP0D7BssIV6?=
 =?us-ascii?Q?wuBTlCCbI0Drp3Rbu+K5fDqCF9KYkweSVis9n0Q1yJU7r0YrQkayHWm1e2I6?=
 =?us-ascii?Q?ERlRgCLPo1xIufDKi1FvF5piWePjfnUq76myet07AQZPkM+z5sQ9QAtccG6l?=
 =?us-ascii?Q?yl2dY1mlSnDWNAZUM6poHGhpkHTSNdSXd65s0qKGF/ASPEwBToicGAvje3K4?=
 =?us-ascii?Q?iWyrLxpnb9fX0r/4+8J6X/q+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0f1KPGKOfTd++7NbiZ7I8t+CVmmDRhoNDdM4SDcM0QPZJ6y+jtpTQ8iY2iHr?=
 =?us-ascii?Q?MTp3ZxF0IN8hsVylm1sxQOUVbehlYidRbqos5WMy+FJLP45zzIw2XiVPT68E?=
 =?us-ascii?Q?ergerV7w+iRBRqYdrXKZTucQRu/rSR+vXoTYmraA4Sag1aR+MuPaeXykYXQQ?=
 =?us-ascii?Q?/JF68t0ukVk8PCZLjd158xG+Lmj/WyxjM2EhB/kWdKf3edYNAOcw5KwcTaC+?=
 =?us-ascii?Q?gQVtv2bd9XrqCTMfJjG0ursabOpda18XrtJRfaxUvBOYHWz8+TNsBIeIIM+O?=
 =?us-ascii?Q?kE/FIp3Yq1L4V9MKqHSeOQ0xqowlHTcWTO9v4jK01TCDWhvHtcfZrs7eYE17?=
 =?us-ascii?Q?s6NTVuw2foHQYpN3jYNE75UFwwwPywuKc7OoNwLF1TWMNbwxGEsjGGPknnve?=
 =?us-ascii?Q?2QsCdnZvcrybl9Y1nwfRSPbfSr7axJcoM8lRdn/8oxbtmYcixgOSwy7tjrw8?=
 =?us-ascii?Q?Qe4eHvQWwM9lZqW4tnKdIoL5UgqDRydAj8uL271DCPA2Bco7or7xrmiczQDD?=
 =?us-ascii?Q?GknlONxCcqPA42I4SF0/9Yp1pMsEEd8GF6g1msP/GadwMgsDCceTjsa2NKCg?=
 =?us-ascii?Q?rRh1UUg2OGamWIuid4kkveCGFqZ6N9VYsub6MOQL3KW0GAke+D9dmzrWOv1b?=
 =?us-ascii?Q?jYmZQtsNtk/rfNqfbh0MxsviDDEfXfYT49vU1ugxQWZXMKUiG7oMmk7+daDf?=
 =?us-ascii?Q?hIbiK7LhExmDidKRmS+aOebHMeiFD78nfkzDRVU/svEVnHfBotWEIRrvemer?=
 =?us-ascii?Q?APPubXwRM25Wq1H6CRJYkFLhMIv9vBRA1V0dYsgMl0SjNJXqZ89nDFAff2pF?=
 =?us-ascii?Q?aX/MuHPoBEEv+WWAwLOHVOAePfEOjqPZ7QFP6t8GAGCF7JuEc5jqxAyM2JBh?=
 =?us-ascii?Q?9zRl4nd+FlCkOatvP8Dy93N2E5OO87KXbdB6LLFHNQO5T2E88akFwgRRnhxD?=
 =?us-ascii?Q?4g+XVu21BMwePdQH02xqc4ciFY40dRFeWCubHnWVoIrkYENswWojPR8ZCaFe?=
 =?us-ascii?Q?SXqOVAlwLYxbtTVRimBwuwWt/zgA5S2C3/FRBWu52WBTIjA5iUr+16xj0S98?=
 =?us-ascii?Q?TOijsadw71Mk7k7f9972fBv3wPi4LvF7xu3VrQCkgQEyMo4R9egQc9eo3frI?=
 =?us-ascii?Q?MoixYTUZMKxn7SW2qR9rBGV+L6xcLoDscpZpzrLkTC01KWzp0YQNBO10eE9D?=
 =?us-ascii?Q?k4u3Fq8ijgBrdPJThNfwDXRLBK/D9AjGdrrKYgFeiy+zntvoVPUcON0FZY7J?=
 =?us-ascii?Q?QInmnG7mvyUejqM31+GIZgOJSBEKOkyJcg742wrdoLiTAi0RSVXLRzND9gLz?=
 =?us-ascii?Q?1umU5iD1s45rC94ur4jvUKGw4L4xNIk5j45HZWXt+2YBGY5QQcu/XX2TO1kq?=
 =?us-ascii?Q?ikQqYQISftinVvStN90UD4bX8VI2Rjv55FqZQTL9mqBHgOU6NOXB4MsJFAq9?=
 =?us-ascii?Q?Ctyc30zta/m4Z7l1vPpBlblRS+3ZRzfmWMW/trHMYtD32tvAngWdNUjGNvMQ?=
 =?us-ascii?Q?xtHir75iC4bZ5Ef+dzkmp17ZJTJjfTUY0cX237fOzWVHumK1Ns6umo/hkhr8?=
 =?us-ascii?Q?0hO6oyVE9QQaehkpJK4I9BMHl0ylxkm68RiLSoZ64SkAVDm1iyNm9VPrbKe1?=
 =?us-ascii?Q?Lw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RqrX9oe9KwSPAOZV+G2dWqZWGD8mmKvYWc859QC23lmFOyu/ZgAtavAOAuojFCiGbA8GqLLewofr4KV/TBeYWHKhyzWNflwccBD2DBL2dSzWbUB85rjvKFwF7786nIlpd6bHSgsjQwLbYtR9uqic550NPfevpLDZOg4v9StCtLrZS+73GWMYxAizxrO2ZtPKHSsKdV+L7DhbsK/71nv+wLK/eQ/j2G4XTtPnUn3midcA+R/a3NooxlNpdU4jIrOC4isPUvLRwcTlNEvkbFWZgjry3dN+50lE6y9IqJfRfZa62vx+8a3vN/p4rmrROko/Jjf6eopLQ87TZHmV0uU/3NTOVoxKAhYCo3BCzh2g+Z6TFpOZikip3MgF3EJrHpB4KXiFH2S+6dWKyGzeM6Mr4WrN2dJSKDApncXicnvhFzmbUWRhNF2q5jOJrBSd0F9o7hURXfoWV6hho0oILCBhJUbU0UKzeeqsD+zw2rjC1BgnixRhMkvrTe28nZ1AQ8H9onsANPTBgKknSVuDAEFMscsQ8rab/9FGDp6Ft5ZM0iY4x9ke5WHbcQvSSpGo40krNefm1DG7DEVyBIgWeDuH8zZP9VxZhs3o6wAJPRKF+40=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 072131bf-a184-403c-48cd-08dcf8c8301f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2024 09:49:46.6350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aWwhX67tZRSdb9E1yNwXVJ8rxKdnCiw5yOpiXiL//FlFUO6aQq9nc1AdR1b2gLjBoVw4R71q/C+ltLp/L6EtFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7826
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-30_08,2024-10-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410300076
X-Proofpoint-GUID: lWQFthl6aUPzDfOdzuXHnxeHFzV24hp-
X-Proofpoint-ORIG-GUID: lWQFthl6aUPzDfOdzuXHnxeHFzV24hp-

It is so far expected that the limits passed are valid.

In future atomic writes will be supported for stacked block devices, and
calculating the limits there will be complicated, so add extra sanity
checks to ensure that the values are always valid.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-settings.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index a446654ddee5..1642e65a6521 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -179,9 +179,26 @@ static void blk_validate_atomic_write_limits(struct queue_limits *lim)
 	if (!lim->atomic_write_hw_max)
 		goto unsupported;
 
+	if (WARN_ON_ONCE(!is_power_of_2(lim->atomic_write_hw_unit_min)))
+		goto unsupported;
+
+	if (WARN_ON_ONCE(!is_power_of_2(lim->atomic_write_hw_unit_max)))
+		goto unsupported;
+
+	if (WARN_ON_ONCE(lim->atomic_write_hw_unit_min >
+			 lim->atomic_write_hw_unit_max))
+		goto unsupported;
+
+	if (WARN_ON_ONCE(lim->atomic_write_hw_unit_max >
+			 lim->atomic_write_hw_max))
+		goto unsupported;
+
 	boundary_sectors = lim->atomic_write_hw_boundary >> SECTOR_SHIFT;
 
 	if (boundary_sectors) {
+		if (WARN_ON_ONCE(lim->atomic_write_hw_max >
+				 lim->atomic_write_hw_boundary))
+			goto unsupported;
 		/*
 		 * A feature of boundary support is that it disallows bios to
 		 * be merged which would result in a merged request which
-- 
2.31.1

