Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1679199E89;
	Wed, 30 Oct 2024 09:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730281937; cv=fail; b=lgF7I2uJWPF7G7uJgXHvEALVTKiYndg+GpOnW8x67UmwGtLno+9+SExhYNYdhrHYkBZhUf8JLcoyBIjqVATweRVE9lSKu8oGeb334SN9gy7eGqyT/ww9bNRp4WFc5GaAkejOC4d9bclWLD9m/Ewz2aig+Koef/N8sL1vSPOokps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730281937; c=relaxed/simple;
	bh=VLa7wmMYxxFsc0wA/xGtjcLrr3VlrLn8ip4S++ojMVE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=h/bwcz5GaPgM4vUN6s9gLf+jR7jRLerP4bZBsUkWK8Vz+9azDVOgxseV0qOk8RJ2I1Advvm81f6j5HtkI8YNaM3NpAijJP8kCNfheCi0fxBmzVqLzejX/ftPbvp4/DHq9sMYasw9ak+ZezKvVe42nMazEzG1flMGaqEpvhcFvw4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Dt0TrS6d; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MQYEioy1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dt0TrS6d";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MQYEioy1"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49U1fcrT021240;
	Wed, 30 Oct 2024 09:50:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=V6stwJwvLNvHT3vVDGp/GSQm/fuuX97C9la5hgyVBZs=; b=
	Dt0TrS6dMRPYlW0is+SAQfJUb2w8lJPwy2ZMv1UpjzmZZtaFpAfOHeqyylZMj9rD
	U3Gnqmle4h2hBxpPOKHlf/zVw08Qum3lzDzhJAIWWNRUqy0HwfGekX9aIIi2+t/H
	4CR9+WBAprxX/gMcj7m7o0j7J1WKxZmb3iMBOoRjPmNU0osZkYFXrduhx7/+cAFX
	gOObut2SqFch1geLmv1yDxfn5OwrkCwj6mr1B0WYxrRwdxcmowT9WnU6TX/S4uo6
	zOntCC+mhgPHbuKz6Jfku3Q9UEvlWqHXXNoZw2ZvEbleLZQM55XuxbXWsa5KlNO0
	JHlCGEOy/5XeJMsmB8s34g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grc8ykb4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 09:50:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49U8dhBW010151;
	Wed, 30 Oct 2024 09:50:04 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2172.outbound.protection.outlook.com [104.47.73.172])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42hn8y2xu5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 09:50:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZSSgcY0cLRek6WV3XDExHvVmAfRWZ7/scQqh+Pg91EbmrTjzLCX+14zUG1zC8Ee5Cgc5xLFLeaD4QIVaeXHe8W18EScdl63DFurqcG/ixkDn55eAfZzwjVvJEjHSJyMDS61MIYKkXoNvO7KtRz0xwLSlvrkEiGDPfm6O85fhFqgLaZgNjt06ZTWSO8vmOJEERqgVMBwHTSMR1MwzBH62z3xTz9RsuOohP6FYZas+ALUzydMKLIIkqnjjhau6fLNUheneHsiWnG8msdPVSZfXMNtZEJJzpYSB2S9zoJn0y4lEfEZLw003RxfzI2+PrsvLu4HGUmVXj/NuDQAuy7q9yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V6stwJwvLNvHT3vVDGp/GSQm/fuuX97C9la5hgyVBZs=;
 b=JNmukrcTSx8FIWdSOxQtmQezhx9ROp7YmUzMFxHqufd9QWvMSddx3m8YwPQmgNEPnXB+d3xubuIMsZq/Snmi2y7e5Zo9jRLC/R7i2H5mmBmTGW4TtukM2Oy5bvmIyVKNw9YQx4TGbhU7h7ghRGuS/BUteW5cdxdkrrwjwFL0ejaMGYeCvrX7G0EdYeXrM0HeSFgjxpTq+X8B8p4IywHHoucHA6KX9Xsh/iMwhK046V3+y4i8E3dkQZXlP9hVpb7Mxk7oeO2BLMK45VKgQe7D9NtwjBn3WHlHBmc1V99LWz3iTrAJKINlYtEBiP3dNFR+At0Q07xLS2fxW7ZqX7GhUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V6stwJwvLNvHT3vVDGp/GSQm/fuuX97C9la5hgyVBZs=;
 b=MQYEioy15Qf8TM8lToPoogBfIsax4pZ25eyXGTFNz2E1qScpXXAmwJtw/dcs37a/gg7g65NQUHxgA1ByWcfMyIRqIaU4XTIF+vz3L33A7abAiX5M5u5qkab1ZaW4y84JfodeRx3Gnos+/kaqAMcOltYKzF5rO+FQ0hldtJ5ktpE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ2PR10MB7826.namprd10.prod.outlook.com (2603:10b6:a03:56b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Wed, 30 Oct
 2024 09:50:00 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8093.027; Wed, 30 Oct 2024
 09:50:00 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 5/5] md/raid10: Atomic write support
Date: Wed, 30 Oct 2024 09:49:12 +0000
Message-Id: <20241030094912.3960234-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241030094912.3960234-1-john.g.garry@oracle.com>
References: <20241030094912.3960234-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0263.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ2PR10MB7826:EE_
X-MS-Office365-Filtering-Correlation-Id: baebffe1-f166-43ef-f321-08dcf8c83883
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tTYQfpKPmd30DRGTRogtVGg/TASd7q2oaUXcqNhszcA5qumh1sU/SRDtT5dj?=
 =?us-ascii?Q?woJ6wHzsg8uNkuKaRd4toSFCNfwvCaHrcnwCZVjqjSksX4lzi4gaG7BLVvhG?=
 =?us-ascii?Q?Yq802Ed2mGjAldPxUrLFeh+6dMjNRLM/cbHjvEqlR3EDi8Hgj8UI/4TxGBx0?=
 =?us-ascii?Q?tj64mW2uPWNG3UJn02je33ShLdWF59BCLPK0UqZIzv6YcIDgwERhcTZA1mD/?=
 =?us-ascii?Q?/MbsTDnZAVcdLlvnftxxII0e5HBpke5mKa7lpSFIwP/NiucUofWtr4sO4TIF?=
 =?us-ascii?Q?D4oXwnqYepdgsn2+m3VMKC1HP+fIWjWXV6SMIjo5DuI1lUMO5j19JsqikGnd?=
 =?us-ascii?Q?SxLoksoMM/ifdUdbI7+DUky+1OP8rxKssLCxeQHwxw5NTtVKEOVzm+OCeA5D?=
 =?us-ascii?Q?AooM6uw2BKnlO2JoanDrIG46b52mmcFB1D6diaooGEXKdN0U9S43K2ob+UVg?=
 =?us-ascii?Q?EzBLH997Huep/uEQc2js8YZ8nPEvCSQUJZkmdoTNGxUNS1KZ4NW/p9HRVmXU?=
 =?us-ascii?Q?iCAPBfGIqqy3ygZjsWktZkzowzWxAuG1oAy9/TJrv7c2r72F2pIbTLHhkHYq?=
 =?us-ascii?Q?WytHDLIxUhosyc6NRkO2PROUZXs8PSMDa7g8Shl+1RUqad0bDL/CbZyHh+HV?=
 =?us-ascii?Q?UfIb6OMKUAEb+R3NYF66WAaX2tLP2YVWIz7OsWzjuFuOzg6dBrgznwasTkWq?=
 =?us-ascii?Q?5FJ0EkFtB8sJBJMq/nRf0XoFuePgq2B4HGnO/HsNE6uKvokmZI7faX7/C0MN?=
 =?us-ascii?Q?JKtMLyReXcrT6mEqEmOxuMy+ruAWI4ZtLViYKTHj7rTyxdyjcdZ9Sh7saiQj?=
 =?us-ascii?Q?9tP1NUNc1fqduRh0MApkO7+qOl9D6XaGAvPg0fkG03R9q2w37cs1MNPm+eV3?=
 =?us-ascii?Q?fomtqoQCzmgeHgcEb3LvuKkp7JSdQRv2UCqfF0MtRDWlcrSABGyufuA0B/34?=
 =?us-ascii?Q?qK4edCHZ8lfajegfoqleJHXHOs4UiQL56OYCswCzrusJw2EPFhy+FIkXHmSP?=
 =?us-ascii?Q?cA+BJii72MUyh/SIq1LLqjo8PThWr8dBSVVwOWEB9BRWZ9BpGaccmC+0pplM?=
 =?us-ascii?Q?j4a4fER8AqfM3HVKJHokKLtke8rGQx/npAR45VbnQslCZr1hn0OxdQm+VQ9s?=
 =?us-ascii?Q?qgkpeSjSUdFtpEoIAlH7atvfQ2h25+/CCuuuiF3qe5J0Mhsb/ouPSIExX/H4?=
 =?us-ascii?Q?WoRJMLmAdpp8/7gAgy4E7HNQGnxJ49BfnZBZzMjDslF+64Q2NjjALnptWEcC?=
 =?us-ascii?Q?qixQCcYi04NbDI3Z5e/eVhD53u8+EYJJN8fXAbKnLCsBIk5cNx1fz3WYITEi?=
 =?us-ascii?Q?Z2E6BixSOFdWZ6Bq/2Cl7hR9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S5RtWjb2bNvEA47jrFwSyBhmmnagEHnCGiRimOcgjiVCL1ODH4XWbHHw1S0y?=
 =?us-ascii?Q?KZ97yIQ9Lr8JYCipnPSyyeGobUGvzcRtsV6o34/iIUhQupjY8Ha5VFw0LP9f?=
 =?us-ascii?Q?mSU+We2D1zsLd4jc2SGVGK8RSljErfiAfO8ORgpY6Afx67wUvnD0hOLvKfkx?=
 =?us-ascii?Q?LO8bUf07gOxHPaVMRDup4a7fcXBFFusQGN0XZ61nimjppoal1KYktFg2kp5V?=
 =?us-ascii?Q?VOrvDPRnxWveryzEDodS+N5D3hGPtlUDyBNVU5cJCV+hfCDQRh/17RXksYvx?=
 =?us-ascii?Q?mn+9Ygh1ac50bjNrq5ROr5BorS+ADnNNu8159nADy3yrhOzmMgFRpyNAQ3cP?=
 =?us-ascii?Q?PAvryHlGfItgSaRD5sArpj/++J99KaOYystXMeZr59FekNi2xbSv86DAo57V?=
 =?us-ascii?Q?aSOmdYHlNPxxlvP9TrIqHEsybciUwnyM01CzfWvAQFOTL7ycoj25IKzIJuiy?=
 =?us-ascii?Q?Is2H2wCWKEwbchPmKwsiI+ukiomgUldtCBOjM2LHc3U3kRhSXXA1WHcB08AN?=
 =?us-ascii?Q?DtQlS6qQzeiEHvf7lUFxvI2cvN3DTZDZ2a2kRtPkQx7YB6R+0aCXenK5gUfT?=
 =?us-ascii?Q?DEoWYCQZ9y+EFjB2aV5Jur7nZF/dtV3okldtRWHT6poz4EUD/mz9SCKIsoww?=
 =?us-ascii?Q?DS+rfsBXkqesqGwK2IWIQT1cQrzM3+cn4szy+PZ7y7QvHq55x2/pyCHnRmkX?=
 =?us-ascii?Q?V4MRIfme45RGm+MlPDSUa+E1lAukfOqG548a6tAMNIebjyOwza+NwIpYqPre?=
 =?us-ascii?Q?PH++qASKpQzJRFZBiORp6xoo+uMxOtEQPCEBg/XlrC8CCc1KCKaYGPJsFXor?=
 =?us-ascii?Q?broPCvP6yUbYthRF0roVwjmMOTaoMhVb964NErLDm6B1PsgH7Reez4XNowup?=
 =?us-ascii?Q?hBiIy5TDMvlWvLoU6vqcJsaSKDVewJ26zytroox2eWAMSOKY5JbXOKas6xHZ?=
 =?us-ascii?Q?2FwHP0E0Y8vHVUDoYvlIKY6Sw7D2UbXSi5+4RmNWFnwvdqEfHcXSJCbZQFxE?=
 =?us-ascii?Q?Pdge0XC5WCWRVvWDuWOy1x8CTdWMWfA7NBKJQbyy2kdU8Ro7Ys6Co+b+2Ie9?=
 =?us-ascii?Q?d/psuxDE77tz/3tWm+z63fOZhaBV8FNfvoGwOlxWq3yWY1MyebZAihD8+yIr?=
 =?us-ascii?Q?n7Wpv81tEtknzLBS3L5H62s1A/u45bPDGdBGVTJf4eZ+oH9Ehcvc+Rh19NKP?=
 =?us-ascii?Q?YLzXT+GL99hIl8B/XFd2pOqr5AQm2JNXiQj44rcglg/QjQ93zlTfGJ8DChRC?=
 =?us-ascii?Q?7pKR9f8ukF+DZ+ubuDbZAlz3AB/gTMDEVL34zUyjIIMDg/JCyPEaGKyNpROn?=
 =?us-ascii?Q?E7nVU39hTz9akoLy+Myh1TVR0sc/8Chq+LWuFfEq+Zg2bNySS6uHDj0ZdO1t?=
 =?us-ascii?Q?v7C1qb+FAEIJBap3j6f9LpYUNQLmu9AtUye2F5Moj90Mzt1wbuXspdu5zoAq?=
 =?us-ascii?Q?7EiepedasLYIw+JlHWzZ3BqxTGPfRU7kBcjK9UbuBzEWCXBuMrJ7zOrYxn7H?=
 =?us-ascii?Q?gzFeXfHp/rIOtOfs56ey+AeYoLObzOf/KHFOS9TT3WDBFVTtsCjlvRFaHDVX?=
 =?us-ascii?Q?ldBWOUm8rQ/pfYKXP3QqUj3658QhqqKxEmslPJsdye8k1F/jw5AEnfUGHUkV?=
 =?us-ascii?Q?pQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gWN88D8j1xRJbo1cI9O0m9OzDanwm4fWRpQoTFNlwjaBp63cSk3Fkda00OufFjNuk2bHDL9Iy3osTqkih59WAncGaLFN8lcvUkv+No2jugLA6sv7iyZ3GhrjGFSPZuGiuvAT1IPYlGMtowGCdMMI6e6IDhDiq9eHRnc4vahpZ/lt/nDLzPRhTZcmv3Lt/rssyRlvs+AzAstOfxJWpk2i5MkslkiUP81jkdirEtdjD/+WEZi+/aqr3zWbvgnEAJ0EMzVGS+yvQGCSkIiS4zr98YLd2Trt9Sy6KG5jlaORlz5av5n/NbyIfLuQQnOL7uZ6FPz4oRnqBNSFpSvLMIX9OSRpsJF2FLLvsaVrMTp78t6G26xGBplXtNnsVKdGgWmupyc4XJFcLgJLklDaEc8siOuWbKaVQbScz+qf4RRyoIoJVm+2fZMG2lUnjQ35CD0YmbcnSF7FbTHz2XVnk4GSqM9EmQarIT92xN9KzE689ncHlO8fsrMaiU+blZrOgS/Z2fVnrOXIcTYm09Kp0OBaEHJtN1UGaIwhaXdaPUvnyNCVMMVxGcp0snGV3jT4ZvHPjUqAueYY/198fLCnmY6oVTnY8tO/KWPUOGFyn2gJMWM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: baebffe1-f166-43ef-f321-08dcf8c83883
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2024 09:50:00.7257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HHtdtFSNrszvPBz9XL00T42SeT2uPH7wz4vsJ5d0CM3h5aG0NZiocX7ZInjEBWkTHuxiZXTfXqtgOP1QSiGZZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7826
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-30_08,2024-10-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410300076
X-Proofpoint-GUID: LFCBdzeNCmxy-AT3XoeTaCdmmbvJNQ_r
X-Proofpoint-ORIG-GUID: LFCBdzeNCmxy-AT3XoeTaCdmmbvJNQ_r

Set BLK_FEAT_ATOMIC_WRITES_STACKED to enable atomic writes.

For an attempt to atomic write to a region which has bad blocks, error
the write as we just cannot do this. It is unlikely to find devices which
support atomic writes and bad blocks.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid10.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 9c56b27b754a..aacd8c3381f5 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1454,6 +1454,13 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 
 			is_bad = is_badblock(rdev, dev_sector, max_sectors,
 					     &first_bad, &bad_sectors);
+
+			if (is_bad && bio->bi_opf & REQ_ATOMIC) {
+				/* We just cannot atomically write this ... */
+				error = -EFAULT;
+				goto err_handle;
+			}
+
 			if (is_bad && first_bad <= dev_sector) {
 				/* Cannot write here at all */
 				bad_sectors -= (dev_sector - first_bad);
@@ -4029,6 +4036,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	lim.max_write_zeroes_sectors = 0;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
+	lim.features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err) {
 		queue_limits_cancel_update(mddev->gendisk->queue);
-- 
2.31.1

