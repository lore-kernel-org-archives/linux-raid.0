Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5B6D529;
	Mon, 23 Sep 2024 07:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727076008; cv=fail; b=SXLH7/0ouFZi8ar8JJTHzFs1BhkViXxP/BfNMslbbyVpgHVUsL6N5eh3LMlKDX5LdiBloEdA17RtL6R7/KN+Rw/JnVltGg5Wpz+FeOSrWN/zneFsUc59vPbMap08fl1Iecik+RDmjMAhnt4Fhkn5C1ppiYrOYEc3a543WOyqxA8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727076008; c=relaxed/simple;
	bh=K6Mm7xhFfArcC4KuvAONKzsHehpkP6Y3hyqPn0qk3c0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=afTNEHo3dypAU5xDZ8NSnXtYnnB7zgYStgH7hOus5vTfWfMCPAUYayEH7/D8KMy+Q6Y6nPfRdlhwwfdBtoecOojNNidxrWVhmdLIuUTUK2TfrnEa43euzrXBP3xdcbpJ//ihmXIBKTHFh62mt9lNypqIifn59bXzQTce1hgszT4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oL4ftEcF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hQC/aB8h; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oL4ftEcF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hQC/aB8h"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48MNaZG2024446;
	Mon, 23 Sep 2024 07:19:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=YmuD9cTb4luFpscZhvq57fgdj6756KTwjX7BB3btou0=; b=
	oL4ftEcFpfiLuAgu6yhRvVn9C/+Y9k0xsAbpj66EHHPpsDFL7nyG3Z5GuezpLic6
	Jf6NdMq1hlU+f+L6+rCPl8foQDHb9z1Tdw2XmO1UVAfhTPq03cs1esyjZI/KpJIf
	yyXkyFVKTrrHvJPHBw2N4LB2V/pH483hAnBCMmqlL/6sN+iTZSW7bB91L7oegt4p
	gEQdFVYVirYkquUC0uRa+N2WaAgHnWEgtzLKJ2UUxCgT0JxUfw+EwYMxaOeFpJm0
	1hT27gdSluHJnNyfJ4/MRa+pmSH9GwoihQ8pqz6LwE3gK0a7AZUxyaxpamwk1Vbg
	n6Czx7eZlS74QHH5KCVApw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41sp1abvnx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Sep 2024 07:19:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48N6W3Dx004787;
	Mon, 23 Sep 2024 07:19:55 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41smk7e3hp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Sep 2024 07:19:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J21TnO7iisI4eEgjSpi8gRkZ3jsOpL9kJPPKcwz9AwySGlMpinEyXxRaouuktuGYSwy8yicfvaEOcfWSqkZHj9fyxGNy8U0LXw4TiHotRfn2cWdhCu8EA1mj9HAuxltyGzJrfp9Y8UaJBq2DuQE0bRNBYH9xwFy3Y8BzA1S1GFFAYwLIVVuFIHc3RevWj2rXcFomOtf7G3mlF9Tnb/Gz9FaXrD74DWv9MWo9gUW1jsea8VJX1No/hpV0Gl/IUj8kVcPdQKbPtEZ1DVYredC+FL0dqFEpz5mDr5CBEzSI8jegU5WNT9ugp0T636TfC+1ER2lKUvgmaP9f1TiD8hEfBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YmuD9cTb4luFpscZhvq57fgdj6756KTwjX7BB3btou0=;
 b=mYlGPL0xuW6moLN18OCcYHqGoEDHFCfMmERw06gNGuXAW2DUemNQ0Ow0DldHRwaMN65p/v+9cmACTy+NcEWVvRfyfCG2IeO9I2pIK4AJopunZnvObIdD8GLEmJTynDoLSNXeiMRbuDWGt9PVwVWSLnh+2ktc6F0X+qdmSNX/5Q8J1y3sEqeWQE+SMG4ZvfQ0601OxOT2kRNT/zygsxkEl9QAnOgno0dpqij81bUm6dCWunbJA/QEk/ufcRvGiipz7/U64E/pIR6Tq1tfBsbk9ZUYeiCxs2cKChb2zbCjOzwqhO37JLwCmbkVHWDpRXvo4a0frvaaK3oQDcU/9l5IcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YmuD9cTb4luFpscZhvq57fgdj6756KTwjX7BB3btou0=;
 b=hQC/aB8h5cnQI1E4FpEZUHuFDZIezo48H0vGpI6hTWi90kgJlgeq9G+a2p+mk+TdY1wlJiCk2seFGgf1cDf1Nzz6n6MXqDDJJYW7NvFOwW//RY3Q6nOZIqFpjiKZtc2VJD59jUuUuU9oeKyUcFhuJj3SGLSZ5xODpPrD95m/4Ds=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4653.namprd10.prod.outlook.com (2603:10b6:a03:2d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.13; Mon, 23 Sep
 2024 07:19:53 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.8005.010; Mon, 23 Sep 2024
 07:19:53 +0000
Message-ID: <86f3586d-5b0a-483e-b94b-d4515d5c5244@oracle.com>
Date: Mon, 23 Sep 2024 08:19:50 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/6] bio_split() error handling rework
To: Hannes Reinecke <hare@suse.de>, axboe@kernel.dk, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, martin.petersen@oracle.com
References: <20240919092302.3094725-1-john.g.garry@oracle.com>
 <bbe71976-c16c-4e3c-b110-6bf8eb709d54@suse.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <bbe71976-c16c-4e3c-b110-6bf8eb709d54@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0566.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:33b::16) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4653:EE_
X-MS-Office365-Filtering-Correlation-Id: 72f5db78-f693-4045-8e7c-08dcdba01e87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N1U3bVJla29vczZtMnVkRnBvL05TVitKNG1kVXVCeDFIQ1ZTZ0pBL01ycitl?=
 =?utf-8?B?M3pGNUFpU2E4U1Q1U0x6RVhENGEreGI3bDQ2QmFtZ3RoL3M5Zm5vQzdwRWNH?=
 =?utf-8?B?RWlpKy95NG5uRStoSGcyaUNLZ0s0NXB6dUxLa0tCdHhJM3FMc3hlcHB5QUF0?=
 =?utf-8?B?Y0pwWHJPOVhLTzlWRzNsMG03dWFiVWtJK1prVmZzWXZtQ3JnOG50ZTVwU0Nu?=
 =?utf-8?B?REtyQ2JaWUxybGduOHlHQjdQQUFYK3BMY0ZDZ2xIZVBwaTVSdlNYYS9xM29m?=
 =?utf-8?B?RFhvWGg0WlNFa0tpVG0zK0hlOUNjQmxjeGlGUWFEY0d3L0FxMjVZajQvV0I4?=
 =?utf-8?B?U1BPWDVGLzJNY2lvbFJnVnUwSTc0K01DNW13TjBwWmRHUjZUUEpsWk4vNjdN?=
 =?utf-8?B?K2R3VEF4YXdCa2FJcFpjWjN6WkhmczRzblhLdXBURDdpQmtWOWlNcHFqQVow?=
 =?utf-8?B?R09YSm1jQTBlVHFNazVhMUVRYXltb2hlTU1lejI1MlFuK01rSENub3dMWDNj?=
 =?utf-8?B?MXl0TnRPUlhlSzhIQWx5Q051YTZMQzRSYklvRnU1bDAyd0s2NGMvc0ZIc3dV?=
 =?utf-8?B?QkwyZlZ2VlNjY2JPby9RWVNSaEhIcGkvRGxiWEUycUhGOENOSnhIU0tJaEJP?=
 =?utf-8?B?dzMzUkQ4UnQ1S09LTEsvTVJjVjEzbEE4MnpPRGRwdlEyUUtpZndIYzlFeEwr?=
 =?utf-8?B?L25JM3lSOEZqRU5uVDFGUmkzc1p1aGgzMjFyRTRIeTljeG5OOFBMdkxQcDEw?=
 =?utf-8?B?cUtOVWVFL3N5TUpkdDNqWnlNNnM0VHlnSTVXS3d5c3prUkUrY0hPNSsvNGVl?=
 =?utf-8?B?Z1NiblhZczNtZDBwMEtRZStRdXU4L3A4TURkTnlyLy9kQkZzM2Q2ZXVyNUow?=
 =?utf-8?B?aFFZbVFxZEorUDNacWlOM3gwQ0tFRmUvejVUSnV2RDhteEdEdGhSVjhXKzc1?=
 =?utf-8?B?Y21vTDllSlhRN2hKQkR6ZGlYYnMyc1JzUVJodDd1cEl4c3FzN1BsUVVsRXZ4?=
 =?utf-8?B?RWNGdnVuWXJ1dGdaOGlOUjN0N1J5K0NjSXFWM0RHdGEvVFU0cTNtUEg5WmJm?=
 =?utf-8?B?V3QzNm9jM1QybHVSdFUrVzhKYkdaVUY4RldEOTJCTzVnYnVWT2hHYUFBRTBG?=
 =?utf-8?B?TzFsbWdiMkxzVG41cG02UzZXUFZEbzRtQlRoZ1hSWE85bmpPZHovUmlHK2U0?=
 =?utf-8?B?cWRmNXZNZ3g4OTZBN1pHVzZyVE1pZEJXYlltVUs5S0c0Wk1ZWldtUHZwWFAv?=
 =?utf-8?B?alc0VUFnbFJLczhqSkdITnFQQjNyNk4vRVR1bVhkM0R3LzhrMjdnSGd6UHpa?=
 =?utf-8?B?RjZTZWl5Szh0ZzlvK2YzZHkzWXFmN1RuUlNJSnB6UU1wTkxhOXp3cEwrMHdS?=
 =?utf-8?B?dGMzeWNHRTQ2SXl1UlV0YWlRN0YyMkM4SlBWb3VRZHR2QUNQWWppMWtsTk5m?=
 =?utf-8?B?QkJwVFJLekplRllobVdhVFZHUGZqVjJqQy94SmE0YzdmTlFybXlUV25tWjBj?=
 =?utf-8?B?Zyt1TEpRWDJXS1ZrS0dFWWNGdmRPQzJ0QTdxdVpSYmRtQ040YVM3Nk9CMXhG?=
 =?utf-8?B?RGNCZ0ZMUG9iVTYwRnJUWXhQdVVQd1dMeFY3WlpHcnB0VGhSc0xETkpERjQ3?=
 =?utf-8?B?eXpkbDlSTUxVLzFnaUlqUnYzUDVxV01iUUdaWkFKQmYvWHExZm9HL2tCM2Vy?=
 =?utf-8?B?SW1URThVbDl2bkxCcFBFY0F2dzdNdWkwWUxwaW91K2dOL3ZIZWNNVlF3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MExIUUhabDR4M3NKaDNuWFhpVm1iSnVxeW1uMk1BSHM0a1F3cllNazFkV1JR?=
 =?utf-8?B?NlFYUkIwTkx0c3N6VGJoMW9jSjlJZllHVW1wbjZYK1hoUnRZc3FUQlE2M3Ba?=
 =?utf-8?B?KzVja21TTUczTmlmUFd5bytzbkowSHFYSjRqNkp5bDdIV1FnMXRMSkF3NHh5?=
 =?utf-8?B?YkZWbVVnOFg0aW5DV201UE91dnMzT1IxV3ZpSkVJSFgyT2MwTjU2aU1vRm1F?=
 =?utf-8?B?S3ZsQjI5YXlSS2Y3NWhERmcrVjJCbUQzT2E3ejNYZzVsYm1pMk1DNGxPT09N?=
 =?utf-8?B?YWFhakR3bm9yRktXcVl3OWVoZXo3dFR5UUtoMVZHbDJ4U3dsVTBzcW9sNjZY?=
 =?utf-8?B?Z0JoYXZQM2hhZjg3MEFzMmdLeDl6aTdZbGpic3RUaXlKNVNnS3BlVTJpdFd6?=
 =?utf-8?B?clBvOVcxRUxDWXJnb2JFSUtMSjdxZ3hyWHhTU2I5MEN1QVZCc0xWbFE1NFpY?=
 =?utf-8?B?Q05tdUlyblFxRGd0YjNlYW9xQU9YVHF2TnZOKythbzdhU1NWTjU0bjIwSG9v?=
 =?utf-8?B?TG04ZUtvaXpRUEZSUUxiQW40K2JxNEs0RCsyc0N2bS9WY0lCdXd1SXZFQUFz?=
 =?utf-8?B?eGNBeWNmbHNHY3B2clZQeVRNVzVoWWdQcUw2VnRwcFJTWU5SbWVuWmlCQXRC?=
 =?utf-8?B?bjdyZmtPNGY0Q0xvdzd1MDJ3OEF2YzlWMVRxN2dWTTVPeEJVRnhCWHFnOFZx?=
 =?utf-8?B?MUZrcXdYeTU0T1dBVnl4ZEIxelM3bEU3Z3JEY05JYnovWGV6TnhCdUExSCto?=
 =?utf-8?B?RCtoZDlvSTdHU3hwRDdYWk9obFM1Y3ZxYXgxQ2I2VHRQbjN6Y0hOeWlCZUQ0?=
 =?utf-8?B?WnAvNFRxdFFvSjd0eDZGZ0xqckZsMzFOTkFGc1h1Ry9yRndSZ09McWx4NThl?=
 =?utf-8?B?b2dXUWprcFVQL3c5V2ErNGljOE5iVW8wQ3hOb25ON2lBcmR1SUtoZVVCdG5Z?=
 =?utf-8?B?azlCb1RSdFFicjZSeHJmYW1nbUI2N0NYQXA4bzlWWkppeFdrMjg3b2NUSWwx?=
 =?utf-8?B?Nlk2Q1VGazV3SnBSM2I1V2FsWTBFOUI0MEhSQ1lxbjEwdlZzTUhlcWxVWmVD?=
 =?utf-8?B?bXdSUEdrRnpGNHFVZzBRRXUrVEZ5cks4RUtNVWdsV3VTYmNTbHpnWEhFQVVM?=
 =?utf-8?B?V0pKZVo3ZmtxTHJPa08rOS94VEpyT0t6V2cvZHZudEF2bjl1MkFBYloxNkxG?=
 =?utf-8?B?MGJFYWlIUktnN0R4cWVsL2FQNlFMTHpYVmJ5L0xMbG1LNVRObVRwakNnZmxz?=
 =?utf-8?B?RlVhN3ZnNXh6MWU0NGoyZFg1bVY1QkJmU0dMRGFjMVdSZkV3QndmY1Izdnl1?=
 =?utf-8?B?Qi9tMjA0ODVOL3dBOGkyWUw5alZOajFHUkNKSjJGQXlxQzhRZ1BEU3ZvdVdM?=
 =?utf-8?B?RzducDR6R2NJUkRhWkQrYmlmRDdDNGF6aFRJMGJnTlp6Q3kxR0pWNEszVTE3?=
 =?utf-8?B?SlFvRjdNMWJDYlcxa2ZGZFhtczdqa2RtaCttNTZBRGNibEh6WVQ5ZDdsWUxH?=
 =?utf-8?B?dFJPSnJrZ0ZHSkxiMDMyWmpBcHkwVEs5a1Foak1Ma1VMc3hXMTZ0SDFENU9Y?=
 =?utf-8?B?VUpsMjNpaG5mVWg0dnVtOWc2MnMzMWNYak5NVE1VdEJIRTNZVUIybUVZeXNU?=
 =?utf-8?B?a2RuOXMwd29pRytPM2VBbHFzRklKdmpnYk5CUE44Y1ZIaVFNa0tDZ1NGQ3Iy?=
 =?utf-8?B?VWxyMnBISnNXeUI1WTd2RHA2dHdKYjFPdnlQbEp6RnFPZituQ3BMby9DcHJV?=
 =?utf-8?B?OWdySEdJWjIzM2EwcE9YNmhWejhHR3NBUXQ4bTdmYXpldGJmV1kwREYrNzBM?=
 =?utf-8?B?SmVlRE9LSDFsNnY4R0dlNU1lREE5Q09VQTlJTWYxVlAwSkZPOUEvU2VVVkNv?=
 =?utf-8?B?dkUxVExHandtaTFWc0pNZzlMWTZhaWtsSUduTzMvdW0rc1VUYTduSmYvMjl2?=
 =?utf-8?B?ZGtPQnQ1Ykl0VVpsK28rOGV4UUdYZ1B4RkEvS3EyS2M3ZDVmYXFtUWYvdXlI?=
 =?utf-8?B?cXBjTlBXb1J3M0E1eDFGNXJ2ekxXdkEzQUlCU09Tam43b3RqejRHZ2FYenQv?=
 =?utf-8?B?eGsvbXlwTXhQOC94Zlk5NVcyRU9pbXhidVo4VW1sQlNwZTh3aklpQU1wa21l?=
 =?utf-8?Q?zvx1nYK2gvbpU33ym2/KqFwz/?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RBgKDKO2+Hfc0aCB0XY/bRC7Ky+bNFSJX+Auip8l2mZizHsJY9aCoSRnsAARBBKTbFibpOMMy6qVYFSdgY0gtJbkU1P9pg1hmcIDFy9gbKoyXkP7PSgbf2HW/3UoLQSdUf9sJ2wfM+a905WKmMWjEI8AU9jMM+rdhJWmlcNcHexFSX/tuOm/XtG6AHFzF+0c2yFEQWb0hljbJf08jwqGpWOqiHE7YCwgF4naw7kf8o8NhLBwlqAtBJyKu7CGvOAwianztYs+SrpH5v8WGLL8/5VGNg/0CpIFwSkVRYnuax+Md98RRYMXbSiDHoZbIfuDGja5JaojdQnk9g/1XscITOHfNOYCiI/TRPDAm5/v/CA0/yH9tIW8UOgBX5hh44Y2Lvk8xCI8I40n+rSM+rd1akL5xfG1schloM4J1VNhbcVl6/ZUYwl1a3c928mHZSLthJ+zeFbW4WRBzGVtOaaK9FZfO1xcWU/JPAnho8zprQNt+HdbQCN2oUeE17q/CMtsZk+PNIHhafFXrybv9NGVULmiKXyXXFqpaFdh1jxm5nTN8JgF6CUcp/YBT9LrqbC0xjTPXQ7hMKyLO67opThyyowN+Off2CG3cOV8bR+83FE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72f5db78-f693-4045-8e7c-08dcdba01e87
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2024 07:19:53.6208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G1DhxxUl9+FUzEL+tj/E0ugCJiIbc/LlK57HfrFtmKrNNChXR9vcnkU6Gc5Rd+qo9NHGdu1c2AcRgv93nRyWtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-23_04,2024-09-19_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409230052
X-Proofpoint-ORIG-GUID: DAEHZqYeIAt2_zGqF7otUGPwTH43uJH3
X-Proofpoint-GUID: DAEHZqYeIAt2_zGqF7otUGPwTH43uJH3

On 23/09/2024 06:53, Hannes Reinecke wrote:
> On 9/19/24 11:22, John Garry wrote:
>> bio_split() error handling could be improved as follows:
>> - Instead of returning NULL for an error - which is vague - return a
>>    PTR_ERR, which may hint what went wrong.
>> - Remove BUG_ON() calls - which are generally not preferred - and instead
>>    WARN and pass an error code back to the caller. Many callers of
>>    bio_split() don't check the return code. As such, for an error we 
>> would
>>    be getting a crash still from an invalid pointer dereference.
>>
>> Most bio_split() callers don't check the return value. However, it could
>> be argued the bio_split() calls should not fail. So far I have just
>> fixed up the md RAID code to handle these errors, as that is my interest
>> now.
>>
>> Sending as an RFC as unsure if this is the right direction.
>>
>> The motivator for this series was initial md RAID atomic write support in
>> https://lore.kernel.org/linux-block/21f19b4b-4b83-4ca2- 
>> a93b-0a433741fd26@oracle.com/
>>
>> There I wanted to ensure that we don't split an atomic write bio, and it
>> made more sense to handle this in bio_split() (instead of the bio_split()
>> caller).
>>
>> John Garry (6):
>>    block: Rework bio_split() return value
>>    block: Error an attempt to split an atomic write in bio_split()
>>    block: Handle bio_split() errors in bio_submit_split()
>>    md/raid0: Handle bio_split() errors
>>    md/raid1: Handle bio_split() errors
>>    md/raid10: Handle bio_split() errors
>>
>>   block/bio.c                 | 14 ++++++++++----
>>   block/blk-crypto-fallback.c |  2 +-
>>   block/blk-merge.c           |  5 +++++
>>   drivers/md/raid0.c          | 10 ++++++++++
>>   drivers/md/raid1.c          |  8 ++++++++
>>   drivers/md/raid10.c         | 18 ++++++++++++++++++
>>   6 files changed, 52 insertions(+), 5 deletions(-)
>>
> You are missing '__bio_split_to_limits()' which looks as it would need 
> to be modified, too.
> 

In __bio_split_to_limits(), for REQ_OP_DISCARD, REQ_OP_SECURE_ERASE, and 
REQ_OP_WRITE_ZEROES, we indirectly call bio_split(). And bio_split() 
might error. But functions like bio_split_discard() can return NULL for 
cases where a split is not required. So I suppose we need to check 
IS_ERR(split) for those request types mentioned. For NULL being 
returned, we would still have the __bio_split_to_limits() is "if 
(split)" check.

Thanks,
John



