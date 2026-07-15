Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0023F54AB;
	Wed, 15 Jul 2026 09:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784107580; cv=fail; b=AoMk7YdWD5dHRzmSEHBRTnMhRfuoKxtWA+tK3OJpdAurtW/rG3jLSmLOdK+yzoLabLxMS+YmNLD5zIiZ9DUw8QM2qu5Eajf1ew3x2XaPDcbX46DG+ayw0P3MEA7KBvWVZ160hg++TvF0Kom5S4KwrayXzgtjuaczACs+2ikla1E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784107580; c=relaxed/simple;
	bh=rBiEe9Q5Tr8PsWDyiD2l6P9KCh4Isqrf93DeE2rEJOY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ELDhI1plUZ5UxI+ccgBUeSEQhgzjXd/Hq2R/3vtjkRtXZt2fXrmZKlCoP+t0zJy4cGrOFRJqtOi9jCWdPfpUr86/YKop78UzfgCOzl59f0bnDjQwN+eSjpnWOn4LkGj8mmBOSV8d5YUFRr7CJhIv7ZpTyb+EbU9i2uUfpEcfXvk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZmIvvi1k; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DD0WPu0W; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZmIvvi1k";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DD0WPu0W"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66F3UHl51358563;
	Wed, 15 Jul 2026 09:26:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YoiRgQXb8qgTbwpuu+aEEdH0h9BQtPiVoOYBg4zJzTs=; b=
	ZmIvvi1kLChJAIR+Y/f8k2LyRM04fdAMQABowizMQgBoMeIhw0CMPaojQ6viiEi0
	Wuw2IXFjHRK4AxP83Q5AiIF9fFfXrmq4QgWL0QAK9zFuMxhiT/fzXp/B/X+CJHjq
	2GkLWdnEoYZFkoVZxH5ymOLlyLbkBFmf9dQN2zFIbNREzFfEOxtamYEC0ZifqQfX
	Uo8mGH0k2SsdEpxYvqMaX7bKJ3lJOdZB0/EBERCgVzQA+SB37h9u/kUef265Diwl
	kN5nKdvTrx3w9l3dmHzN+Vr2s5jWWgbiYOXNXmeL5C+ri9/eAEDyyUqPO6q5noUD
	uA7JhHPNJzDQ59xvjZG5Xg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbef0xbgb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jul 2026 09:26:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66F9NXdh029493;
	Wed, 15 Jul 2026 09:26:02 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012070.outbound.protection.outlook.com [40.93.195.70])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9jegnk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 15 Jul 2026 09:26:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h4TC80f7g9q8mlu+RXgOjvnuUQwkw5Psab31ukCKqz+7H85kFnNE6SNQ+xYTJh8olUhTWJdhA2YJikqzgmIVFGWcgb7y9xYk80c7TdHbx9dnq4IxQkorwy+c/gqTPGXJz+hcBYbJifwm8xRAr5nymflWSwBBFCxcKY9ofxTLU6bzLywltNKkc+JJLt62begvOWuGNvRz71dCwUawMeuKRcmPP+ZI0uugdBqfdxqnWJHxvltFHmdj1nm1fMsoj30lcX5W8Ir/Mz/PvV7zHLGiQJyyb20V060YMuBE0X3Dx5dxBmOGqnZ+oo9+RSLsWSsikWN0VK/lYcbldIAR6sMiYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YoiRgQXb8qgTbwpuu+aEEdH0h9BQtPiVoOYBg4zJzTs=;
 b=Y7tNFkfKy0SSpsPoy8KaXntO20dilrtgaXy5FUcDISyYaoyoRuSaQI1ywX/wojx6W6YfldTApvWNjIcd0fO8ieirurUBHifLGtOaZzF6jYKLjpZXcBISJVrYtofIiZz4zbHfE7aZv8eoOcfdwvlkp5fvNcmE0h5PvN6pTT0omado8P+CXpnDjdK/XLqz2A8E3lVPp/6/X+LloRM52vrXM2ei7/r9miTN8q2SkeBr+aR8iTvgGAavHSkYQ56IZGqyXUry+17XbejOZ+gwd5nvqQ7R0gxR3McxdFmgjY1wjLW0qNwmWx6Hi4kFADqOCPefAJxRVunsHWw5FltEoip8ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YoiRgQXb8qgTbwpuu+aEEdH0h9BQtPiVoOYBg4zJzTs=;
 b=DD0WPu0W6VDr0cY6xLo42B8jGbF1370sbVrf8ksw6p/+dip3j4/dsT92dmtB8inFporA/8PWP6RzF8hB62KVZLCNpj/3wszz5K/7d7rv7j4EsSsIPWpuc2oOltFuSkPINsvN8Pi081/XHXMPiHDvjavDHg1kMYL7F40i2Yt//AI=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 BY5PR10MB4290.namprd10.prod.outlook.com (2603:10b6:a03:203::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Wed, 15 Jul
 2026 09:25:58 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0202.018; Wed, 15 Jul 2026
 09:25:58 +0000
Message-ID: <33aca226-f744-45e0-a137-1f85ab146e02@oracle.com>
Date: Wed, 15 Jul 2026 10:25:55 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/7] md/raid10: consistently fail atomic writes that
 require splitting
To: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>, song@kernel.org,
        yukuai@fygo.io, magiclinan@didiglobal.com, xiao@kernel.org,
        axboe@kernel.dk, vverma@digitalocean.com, martin.petersen@oracle.com,
        linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
References: <20260710101521.1714-1-abd.masalkhi@gmail.com>
 <20260710101521.1714-4-abd.masalkhi@gmail.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260710101521.1714-4-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0353.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::16) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|BY5PR10MB4290:EE_
X-MS-Office365-Filtering-Correlation-Id: 823695fd-051e-46eb-9c7f-08dee253145e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Wsrp5And8bfflb++HTc42ng6vmq/7KlDwGILJ8q/IYYwi5LAGmkzV1V8YdnpGJy/ReaOeO75jC3RkwPsz6GfpAEwRW6skxYg08dEI4iLZZQQTltGeW0WrfdvYwG3Vxn4me8RNdtkG/fq5yDusGWvhyJO+9wWbWuO9B+I4dyY7SXBW3X6b1RJJLZJF31/A/lN65ELXz+64XdCUb4jG7/leCYtn+w1oU82so0iYSegaoq4iCwSGlhfkfYcmvIWRFPXYiwLYa/BBvNEHmUTYGaXHxKUfnwcQfGk9agaFfaxNHHunDdwf7s/U7r9rEyG6lzyO9Ob5/nZudl68AUkbcnOOQAQOz4c7d7wREB1EUN9oyCk2RX8HSMKyhU6sR5Jr61xD7qSCAJBoUAmWUIuLzhJRMbIUYRdeTyN9RHgRQZF0N0X7prkzEWcRapRjB5vBqCG1tJBo/dClDErFwaAHjaxwQ6qgWcwpN/tvwogvuwhhksGa6jh/OjvPy3sQYCM9FaC3Zom13morvYbvi+ZUNrY6CaKr7n8rpt268MXkaoqETLx2FVTMmzlvFLzAbJKZuu9wG3bkgEIdcpdjn09NekNgc1pgssyRAn/TxiqLHsw0qMYt/3/BYhoUFChN3Ekpg5dcFkW7C7Nj3F4w22WHAST23CjHJ0KWkwiMCeGynnAE7w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TFJmN3pndEM0SVFCeXVXY0JISEs3ckxlSWtOUDNXL1hKVXhzdmd1WVc4anRt?=
 =?utf-8?B?NmtpWDlEQ01VQ0JPNllkZjZ4SVZiZzZrYjduaDdsRUlON281VmNwb1UzNGhp?=
 =?utf-8?B?MVNYTmtxNE42RjdwbDErQUlLUnlkR0VFdmhscGx0aGxUN0JqTGo2Q2ppRDli?=
 =?utf-8?B?MTBSNTF2YVBESVYvTCtWbGVualZEcHRvR0hnYkVZcjZFMDBsSXR2WmFIdXo1?=
 =?utf-8?B?RnUzMGJLcSttNkp3NVJWRnRFeXZVdnRJd0ovdXFla0Y0aXZBbEw4Q05JODFz?=
 =?utf-8?B?UjlYUUdpU3JadDJpUFlPMUl2b21nTGVmdlRXcnJkK2VhZzY2ZUN6MzRMSElv?=
 =?utf-8?B?RVdEa2tvWVlsVXM4MjlOWkdITHVDbjZ2cmpjOHliNHFNSWdzZHBQdkIvUzdt?=
 =?utf-8?B?amtwN2Q1VVRZQlFGWGtSTmIxY28xbTFGT1VuZlEya2hWTjkxTmx1dnNWdXJj?=
 =?utf-8?B?K1YwdGkySzlza0U0cWVVTmNGTkpmTDNGS3J1MnBKWmNKalRYQ0QvNkpGNkhT?=
 =?utf-8?B?alFnTW1uZHBZeHhNdysrNHFKbmE0Q1MxbGR6citZTjk4YktXbDIzRVhQUkU4?=
 =?utf-8?B?d29WdG1peVJ6TTRuQVdHMzMwcGNsN2lheU81QzRQNHhpY3RHTnNPZDJ0bk1E?=
 =?utf-8?B?VjlhQWRDR2t2K2xrbGI4WHE4QTdoUEtEb3IxTyt2TkNyWldqSmlkOVAyVzBo?=
 =?utf-8?B?Vmppb0lrekp1MUxIZ3BtcnJxVU1QblAzelk2RWVjM21FZ1RWNmZSNWhZS3c1?=
 =?utf-8?B?NmtHakhZMFZDMk1vSDlpZU55cSsyL0xGZlhkTWNiOTYvMVRaTVczTFJEZDEr?=
 =?utf-8?B?QUwxNGhOYVR6Y1hnelRNbkF0dk4xVkNsQnp2ZmwxcTRnU3FVb01TKzJjRlBi?=
 =?utf-8?B?TFAzN2JZV29NWnpEb1lsbjNIOXlXczhtM2FSUXo1TCsxL3c5Nm93aDgyWTJQ?=
 =?utf-8?B?RllZcktBY3owYzhGK2JzNWl5UG1MN2FlcW9xb29VajlGTER4c01yVHpRZTd0?=
 =?utf-8?B?WVZ3TEFwS21vd0hOOXpiNW5TY0hReCtpSnVqd01zRkt3b0NHczFjWk0yS21S?=
 =?utf-8?B?bDVFamdiMC9YWWg3MmtjUXZlTEJ1OGhIdXNsbWg5NjROZEVBdHRjWGVIbXpQ?=
 =?utf-8?B?MlFUMlZxVnI4WXBUT3JMREtVangxNFMvRVI3UlEvb2l4STJ2bENnM21aQlg5?=
 =?utf-8?B?ZXJwV1ZqeVdLeGJFVllpOTJ4SGt2K3RuY0RvcUhOdHlmdnZSZjJiZXQvanJT?=
 =?utf-8?B?RUlWMkpGNW9xOS9KYU1iaG5iT2RIYkd1NzNsZFZnc21oT3VRRlFENVh5NmJ0?=
 =?utf-8?B?UDErVmJBb3BJYkh4cUNwWFl6eDBGSDNHYiszU2dyZmJ3YzVIY1FzNHFIcThV?=
 =?utf-8?B?Qjl0NWxwaXdwaXh1VUdPR3J3dEdEZUZPSWNyT291aXJlN1J5QXVnNTFLN25o?=
 =?utf-8?B?b2V4bGNQUU04RmJxZzdJY2RySTBaSVNQQURCYjE2NXNjTDV0UDlKcTVHYUcw?=
 =?utf-8?B?WGU4UDhSN2U1Y3o4MXdaR05JRFJUbXM1bENYT1lEWGkwVUQvamx1SkZqc2tz?=
 =?utf-8?B?SGZMSm1qaFkyendFc2JRZ0h1YlhEWVcxY1kvNWdoUWx4OXpYSFYvTCtyaG9U?=
 =?utf-8?B?ODNsYU04M1B2akY0T3RSRkwrL2JNMmJPNVhBMEFEQ09HUmk1WFBXNmFIYW1r?=
 =?utf-8?B?RE1Ed2JWaDZ0UlR4Y1ludDlrSlNQZ0Zza2dLTSttUlgwakxkbzZTczgrd3VT?=
 =?utf-8?B?RXV4WHBCdmp0OHRYSnRETnpkeHhqWW1qNHVIL2VIa2lMcjFJUGtqU3AreUlw?=
 =?utf-8?B?SjI5WFRtU0VIWDB1Ry91RFVmR0xweDNtNEJObnQ3WE5tUVhnQjRnbzZra0hT?=
 =?utf-8?B?UFVidGlYeTI4eWFTNTd1UjIwWjkyenJXd2NYNkIxT0w4cWpSSkg5YUQyRmRO?=
 =?utf-8?B?Z3VaYVNkRDFJbHllMTMxem50TjAxZkdOL2ZZSXYxbFplNiswcnFJdlZ0WHVh?=
 =?utf-8?B?VXZqTzZaUGpOdjJseDlRMnpVUVBQRDF6UHJobkszdWxjbnVVTnB2T0xOU1do?=
 =?utf-8?B?Q25VZzNzRS92SEVnU1d4bVpTMzdYTEpXWWMzU2ptUnI5bVVvTVNSa3c3dmZp?=
 =?utf-8?B?K0d6YmM1SXlpeHhocGRiSFlNTE9xL2kxK1lzVUR2RVJ5UlFCK004SlpXaC81?=
 =?utf-8?B?YytJWkVYTjZqWXlrTnlkUG9IY1Uydzg1NW5MaTBMU1NZb0dOTVQ0U2oxM2Fv?=
 =?utf-8?B?dXpTa21iWDFrbndWTXFRL29SZVdSd3FqMzlzM1RRS3ExNzRJU3dUTEUxMExk?=
 =?utf-8?B?ck1pb2NCVEM1d25zNzR5VkdRSE5NamFGUFloYlZOa2l3TFQ2T3hiZVZjSkVs?=
 =?utf-8?Q?ZNHt0mF/5F7hJ5CQ=3D?=
X-Exchange-RoutingPolicyChecked:
	jeE27h7fBUsC3AIs0mkizSm7DyUAjpFujDG5yAXSwugZXTJFmt87CIOHE/WODhRA90CuXpTpnt2jNqPZbpgabEB9d22PEZwnFIL6nYDouXFU5LlftFlc5uRiMLDs/uqCqbs3QMT1txgeoV7txcdChJsWH764/GwRMSVpE6inQJJd01KbpmBRldNIXvHiyo/J9OOBHe/IGLWA3IWCpv+KkJhkqw/MKw9YeQHwWMUZAvCRN7Qrd2imnLpqez/Jz5Ox5hYYYS4vEcA28ruMJfAJuMf4Z8YaAhVpy9uLGAvE1V/w8ixeR7LqyKhB7nmgQD+HQNh8vAzMD3UnbIbPuj0C9A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	77wQUzccfVuJM+4ud4pgd0XhW82LF4IOY8vrBiKCv/U82vJ69UTsv04RQ5JG0WdlEA3h1FlukIv1GkSQLq8TQd17C6Su4DrWDKP6UsJ5rXqg0lba+CbqlHkX+Zvx8seObqmQexrpmQOTQzv0fNFz6gGS4Tg8tRAuMX+AGk+gTw4NqYuMWDP2NPJrbE383qTG0xGx+YDQfc0xSOyXLnow22SOkZqqOr6PsNGGCITkoslrYY845Y84ZS9W70FVRWoubmGooeCYV+BWGP+M63mzHcNxqmqbDH3pS8iOztmHJAhNYdH4//GGyDbg8y2dtvNWV27AVOuUvi+QiDhMJnoMwU1q7MeS9bAo1SjYSaq+9bUoeODdltEps0yFdcCwlGbxiR451qEBzJF4NEgCwGemg/Tw0YmIRI/7xLMywKbMKMiEAPova0EAfECgueZ59ykQFvIObIJYYv5hUgOSnd62jc7RV1JobKAUEstb3VzpMdzN4NAeyzXmVL+gQaqk1cwQF61ZRYjKfFQ5SsQKK/Ct0rOeTBOIXK9+B2KIQ/V4shpYs2FhrHWMZE9Iu9lxHXzrOJtf6+aMa5iYansQxr8n7crSf1PX5lPu3C7fA/pfL64=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 823695fd-051e-46eb-9c7f-08dee253145e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 09:25:58.6645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O2Tn++7cBpQk8X0HByd/HgSmGLikTlw1iRjHx5xx04zgtf7/RWtvqLuyJxYWKuKzVadg2IRlKVtdrKHNEp8UmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4290
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-15_02,2026-07-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=998 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607150091
X-Proofpoint-GUID: WdZCZU8yowQF3iynGLWD4iggJ1s90PdN
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE1MDA5MSBTYWx0ZWRfX99hJ+mHybpri
 hdubP2XDH6NdYjVo+gGsqT2i2L+pCTpHMfrSP5Osybd5BEcqhTzrQ2spwt5SST/ugI/IOyj4LE8
 Dl6ZMDS63qh8FCHToZKiErtdUNzOMANConU0oNEgF1pBBzL0wmAm
X-Authority-Analysis: v=2.4 cv=KJZqylFo c=1 sm=1 tr=0 ts=6a57522c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=pGLkceISAAAA:8
 a=ZO184S0cRueaN1HOxH8A:9 a=QEXdDO2ut3YA:10 a=uGth5_h6dYwA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12218
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE1MDA5MSBTYWx0ZWRfX3vzKFD/8kRRa
 iJQpqd0Npa6YRmr9Hf1NrvchbWYUSJKCHcA8Oiy1GeIAAKF3T8S7T6aKrs3xE4kJSzWWBKY6Nhn
 tUTjCoqbHezSOlD2Sl0sI1K3bmcCEP7hnOPw9Kb3B/Yx/3hcwYTbr1z/3AhGTnwn14tbNzXlI+Z
 qsTsEW4id5fc5FVYfHP7IxvyCCkdpNdhG4342bwObB+EG3gr3oowzxMlQQI32SKvSc17JifZkAx
 h6BKt84KxaHMgyrBwfNGa3LEeTPehnI6YrbANYiA4dYAEpkaVkZ6q1eWOb9SDwcjuBeHdWiISez
 9iezh2nQtICBwKkcEzk92SRJA2hFILhSGKApghraZG0DIRvEF6Qnlpjldc9aGWVjbcfVfNIuXOk
 WHgBy4yHWYN6eQFpFY/4+dEfQNoa5USQFm9hmQVifYTKDJpiRqS82BwIWmR0hgRUHm/ofqU5je7
 VCxhHh9Yo3P//HxXyoNgRhJtdoio3lFMGf6NTyow=
X-Proofpoint-ORIG-GUID: WdZCZU8yowQF3iynGLWD4iggJ1s90PdN

On 10/07/2026 11:15, Abd-Alrhman Masalkhi wrote:
> RAID10 currently handles one badblock path explicitly by failing atomic
> writes with EIO. However, another badblock path can also reduce the
> writable range and force the bio through bio_submit_split_bioset(),

What is this other badblock path which you are referring to?

> which implicitly completes the bio with EINVAL.
> 
> Fix this by handling atomic writes in the common split check. If RAID10
> determines that an atomic write would require splitting, complete the
> bio with EIO.
> 
> Fixes: a1d9b4fd42d9 ("md/raid10: Atomic write support")
> Signed-off-by: Abd-Alrhman Masalkhi<abd.masalkhi@gmail.com>
> ---

