Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34D15908D1;
	Tue,  8 Sep 2026 17:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788886875; cv=fail; b=QMx5Iz8OjE8NcSBLWDYMesy9nYjEgb5ksBCQZAOJYaEwoJ243utr68Y0tU4KmXY1ZYoZBzlob8rm2FnlxRtVTViQOrYB0Oh5QFuZ5k0+QGw/nkABMUBxZe421VGG5fTzbziOvJj/DNn4MkExX1V/NPkzrPPmsnvKtDt+4gIH70k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788886875; c=relaxed/simple;
	bh=ZA+4cuiwcF65qMG4/1MFZNhcN/q06SANqyxmX0X1gqY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Kmiem/MJEmq4wgGi96zp5MHF7EglngAR0dUy12S/8zdzl0PhWRcUbfWgVl60OE/8Oq5YZT9dSJER7WX6xtSDfgUzr0UTR9Qxh8MHKjEcMv60aQdFFbY1/YvztUNxtB9cGE609Do2T0/chD86iiEQKzodFgyF6MpJbjUomKQSCN8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=jk5ZCCWW; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=YBUCGh6K; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jk5ZCCWW";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="YBUCGh6K"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788886873; x=1820422873;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZA+4cuiwcF65qMG4/1MFZNhcN/q06SANqyxmX0X1gqY=;
  b=jk5ZCCWWpqxmQKMgyjUJuruv4SRRtsUfVxMJF88aD3uIf/z/bo18zXb5
   478t8Y9OXCi4o/OBu1U2XN2J/7ngSlTInhv1l6PQG/fVgH7uuPE+iH9om
   hu0bnDDz7fYFIpM76vT8n75vk2YAUE2meWJhNWfp1ORV+mboh9LC5ihmE
   wm2eBUd9nGDV0vFkfR1z1MCe0oxux5bcSMnbTz2Ha0UwYgxWi6gTAXsRH
   wN2Y1KE9eEYj1lekqiNBbRs8YYJ0wyAQE0Uaz/kpz5zp1Kf25gLewVkIQ
   5LZ8feU63KZybaGtkW9DSCcZK97apV8pcDabxd/Gc/frnvIPSg6B5V5Z9
   w==;
X-CSE-ConnectionGUID: Id3sKiMpTAeqh0zohEtieA==
X-CSE-MsgGUID: ZAs+/wF4SUmvDxpQLjpPOg==
X-IronPort-AV: E=Sophos;i="6.25,269,1779120000"; 
   d="scan'208";a="155212515"
Received: from mail-eastusazon11011022.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([52.101.52.22])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Sep 2026 01:01:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rnN1kde8kntVGEI890XPBgAHXp9s3aOQTzaJWTfbYxry/bQmzeuFZKVIxS96K04Zm9O601z9Y1wd8uqIYpHfLgLZeWRToBbnWCgVuQg5BuM609NT5CAE4RqhQRLMx3ZsXQjDCrz8lMgtGWt91GG7x15LCCYzVDHTsQDeT9a0B4cI7nQA8CyY+LzrfW0iUT0xNesKCF3D15Iebzr44IQlcDZAdblnlcKmqE8yLxXwcHzRpCqL+yZn1eYR/4r+XJ2+peFbbWrHO2OT6mrSHOZI4XyAmRXn9vKpCSp2P6MRMWnhc5n+/+MlebAGqnDOqOgQIlnlgvjpi4EPi2sjZzaQ1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N9+ybU9+qkj7PYn4emfLddUpaPtDR7bWnKlJESHr6z4=;
 b=ZdBzIU5+UFYzx1XcY3hNQoCHA+vaTJMjM21vjdKmWwT1/KJhF8FeZ5/Cacg/hxOg9Xsg6M8z5JbyAMet/ARFthK4nNhniBZ7vjoEr2j458xevIrms34orBfqSX2hP1BI6j2Gl3HDcKUE1+lmnIShRUJb4YCIiXJXsB5B6UHNeo8nDO3OXcr9H2RVsCyDCoSRcPIws6l34aZwtcHj+bf+ruMBCk+2dtlwJKawE6WyT8fJ+T0ztYTfWf0J7RWJa+wWuo8V0fPJ2apG2/lb/VOEF5fI8sgXtZtPqAQfuKTFasCwHROH0yrP2PVdSrxyrJhSr3WOHXsV6GDhOYUr4RHNrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N9+ybU9+qkj7PYn4emfLddUpaPtDR7bWnKlJESHr6z4=;
 b=YBUCGh6K31r9QI8hKmELhgaNyJC6QWE6iDpsrFf3LcXYZHqJSKkUbF/XzmSGsxO5URDjRsanhMZx5thGnYlVEFwYevd5itx2lOI7sqFwSdWE9Dm0HG7tIV7oRpzhgEk/ePpGsEzagx+VRT3vWvWT/fQfInqN77KywHLWb69pGw8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by SA3PR04MB8716.namprd04.prod.outlook.com (2603:10b6:806:303::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Tue, 8 Sep 2026
 17:01:00 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0406.005; Tue, 8 Sep 2026
 17:01:00 +0000
Message-ID: <f95804a4-c5ed-498f-b24d-107b2f00d858@wdc.com>
Date: Tue, 8 Sep 2026 19:00:55 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] md: don't wait for q->limits_lock while md holds back
 I/O
To: Jack Wang <jinpu.wang@ionos.com>, Nilay Shroff <nilay@linux.ibm.com>,
 abd.masalkhi@gmail.com
Cc: linux-raid <linux-raid@vger.kernel.org>,
 linux-block <linux-block@vger.kernel.org>, Song Liu <song@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
 Damien Le Moal <dlemoal@kernel.org>, Yu Kuai <yukuai@fygo.io>,
 tom.leiming@gmail.com, Jack Wang <jinpu.wang@cloud.ionos.com>
References: <20260907133929.1081540-1-jinpu.wang@ionos.com>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260907133929.1081540-1-jinpu.wang@ionos.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0054.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::8) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|SA3PR04MB8716:EE_
X-MS-Office365-Filtering-Correlation-Id: 026f5ac9-a2aa-4a84-7327-08df0dcac21c
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|366016|376014|23010399003|7416014|1800799024|18002099003|22082099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	WhKrPE8m0WRoKPMyZhefQZQ51e3yvqSjrVKhdhuhnS0+unkpuxednN8AgPeNsPuwHo9pMp6j0oicZOz1NIMyoOXy3QA9XzXQAeEbeMCAFSHe2HxvZQiIgHlHdb+p9LTnvIlU93hI8tAdwi3z2TAYHZKWahjQ40V7HwATlBRaNZbAu66DyFI1zFReCVx5nkG2vKFOMk+4fUq7xgTgHeNS76kxKZW4MDWQDJX5MNHA6lgkzPQXLKMC/8Nw59n+aetgwlIhcssqGzJvUmjRnTl9rlnxBbSj80PrFQl2tSXrB+67deyhUYFwN+/hTQDknZR+xdfQbelvcz0QDMQq50vifV68AhyAtXVq0dCD3m28sKjsdMEGjcio/ucj7WkqvKrmOR3q+MvjphWN5HTsfHk9UldEFHGkHPM5uXZapa+cpqP9/rudlFcoYX221EPa5SL1KEJgTfFV/VAVpiFJgng439gpXTB0nS9iNBMHLqyDB9NsP3gmDc2sIyBh3X5mSvyetoxBAhuc/24m5A8wlgUfN1jKpY6QFwH8IPCjLdrHitoHgOmxzRNCEdlZ445/ILPLx5hdm/mqYIUpuXX7k5C5450rjIh/2haqP4ekk0ff5CvxVNkN84KbqVsVxYIDFgaK9pwOHGwUB1Bh49MW3GgcahwR+zYuYcLCXXoKJTycslA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(376014)(23010399003)(7416014)(1800799024)(18002099003)(22082099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R3lsWlZJbUxaa2xER2RDbmdIdEFGKzN5WXpFQlRDb2E4RDByNGdGdDBWRHNt?=
 =?utf-8?B?NzFzNGR3SmwzUGRVd202YStlV3BFVFgySURCRE40dmoxWFZkcHcrWnlIbGJq?=
 =?utf-8?B?bFJJTk45d1VrVHNXQW5JcE5yV3hMOTNBcCt1d0REY3VmeWZvamc4VFpLYTNa?=
 =?utf-8?B?eEFpMW9pR0dwZ2Y0OUR3V3RXL0pQdmpiVExZcmNra0tUSS94TFhaS3RJS0hE?=
 =?utf-8?B?NHU4cGRhOUFYc2RUNDlyQUVzQ0N5bm1GYjZuWGNvd1JWK1doR2pzV2tHd2h4?=
 =?utf-8?B?T0xvVTA2ZkQwTStBYW1hZlRIUDJhY0hPRjBjTy9BcEMvRkFSeFYzZmptNWZX?=
 =?utf-8?B?SW5mbjFzL1V3a3FyZCs4SGRJcXVhQ205RWpvZUxWYU9OVEErQXNUWk1zRWsw?=
 =?utf-8?B?KzNsbW0ydi9WWmhyVkxjNXkySmNkMlErcW1uZVNzRk9MQWhDaUZDdk5aaTg1?=
 =?utf-8?B?YUNKVUNJcEFrL3lNYytrQXhMSFpxYnE1MDNrR1dYR1BzSTFlWlRFRmwrdkJJ?=
 =?utf-8?B?Si9YSFV3ZEdMTExPc0FjaU9oQTZUbEpoaVJNOC9yeTFYbkk1c0lTUUI1UGJy?=
 =?utf-8?B?Qm1xdnBzM2t4cWJuREZpV25ERzVWWmh2czVweWtnQjRaSGxwTVFlT1VTZUgy?=
 =?utf-8?B?TENteDVUM1RjV0owc2N0Mm1oai9QOEhzb25uRDZGN0tqazBDczM0SjJramxp?=
 =?utf-8?B?QTZzNjJJQTZnR2ovb0JTT29CUVFrTklNenVxNTFlbEJDNGRVZVk3OTJ5ZnhZ?=
 =?utf-8?B?WVR6NW9lNHo4UlMxWitTOUI2dWdUbFI2bmRxK0NiSW1LQlRHMk9hT1hOY20v?=
 =?utf-8?B?YmFVV24rOFJSWmNlV1ZqdTNyTVFIQUUrVTAyRll3L3daZkFpd1RneHRTQVhw?=
 =?utf-8?B?aHhTYTZiaEkxMlVDYUdGcGZjOW9BZlZYT1lZYXBza0w0WHF3TnVlVm9GWkRW?=
 =?utf-8?B?bFhwWnd4VTJ6K1JleDB3bS9CSWRCQzFBUHV6OFJVSlkvcm1yZ250TVhPTysr?=
 =?utf-8?B?KzJBWm4wYVhrbUdqbUo4VTgwd25JQThXQUdtYTFjM295cFRvenpDL3FpTDZZ?=
 =?utf-8?B?WURMQlY0QXRkYU5uLzc0U3YwTUJOTFBCbkV1ZGhkbmlKQk9IbCtCTC9ZM1BH?=
 =?utf-8?B?eDZFMkI0K0hHZkIzbFdkZ05qeElMbFMyK1lpWTZPcEwyMzF3aDgvdmplQXk4?=
 =?utf-8?B?Zm9IT3BOTWVXYWRIM2UvS0hSM0piSHQ4YkhhcjRGM2NHUSszeWt0bXZpeFpN?=
 =?utf-8?B?L2hBZ3EvUlFXWGZSYVJSOU1DbTlka3I2RGRWK3pFZnN6WVJaV2drRGl2TFIr?=
 =?utf-8?B?Zlh6SHlrSmhvVmNFaUh5RndmTk5wVXJpMGdBRC81Qk5KQ3ZWNG1SeVFYM05F?=
 =?utf-8?B?MklldVZLVXdKNjBBbk1FUTVXRzVJN2paU1Nla3QrSlFLb2RUbDE0MVZMdzY4?=
 =?utf-8?B?Y0RNd2xKdXFwOGwycGpQdFhwYmVaK0dEWHQzNEM0ek4zdmlZVTJBQ0V4SWJr?=
 =?utf-8?B?ZG0vQjFuWWkvb2c0eVJtUzQ0WHRscUFDcUl6MVhrZ0hXSkxGWS9vQWs3T3pi?=
 =?utf-8?B?TlVPNVhYU2xjKy9JZ2huSytvdWVYR05DMmU0cXBpaFhwMHJJZlFjV3BkWGR4?=
 =?utf-8?B?R2VtUlJMNmhYVjJVeFBKWnVwWURMQkVvcEs5MFZ1QVJhajZZa2RkcVQySjRW?=
 =?utf-8?B?ZWxaV0JUVm1odDNyaVYyaTlTZkt2aUhLQkNZSFBKT3lKVGZUVjlVOC8wME8y?=
 =?utf-8?B?elVxblZSdEV6cjhiTUppY1dGdUxxSnZhSXM1cnpRenkzRWZYMmxMMVhhVk41?=
 =?utf-8?B?Z3c1c2ZuT3hhSE5mdlpPUE85enh4cVBPcmYrTC81R3l6MUltUm9uMDJoenQ5?=
 =?utf-8?B?S2o5Z2Y4ZXpSbUh3YmpnUlFmZHZxT2xPeUp6Nmw4TFdtdlEzc0JtMGhmK3Mr?=
 =?utf-8?B?TlB4WS8yRjdUTHF0Q1ROYTBJNXBCU2g0UnJZMGRoSXp4OTF1dDYwcnArb0xF?=
 =?utf-8?B?aU1oeG9US0xEeHJ4Q2lNTDJ3c3VQUC9sVjNleWFTS3MwVHF3bFdEeWZkWXc3?=
 =?utf-8?B?UzhmQXFFaGJnWU5RMEpUeFh3NmZ4bFRHZjVKZ0N1UjR6OUtEUTlPSENmSU55?=
 =?utf-8?B?Q1NiVnZhTDdEaHZ4c09lUVRDSG1haEdoQ3NsWUlpSnRRMVZvMS9RangzRXBX?=
 =?utf-8?B?Y3VlWHhJVmQySjd0N1pQMXlYbXhqeU1ncjZDZ2E4S2tzOFNoN1FhUE84cGo4?=
 =?utf-8?B?cUZNYVl3ZXNicm43Z2p4QmxoTVJySkFYYUk2QmhMMldURnNpVlZWTHNKTEVa?=
 =?utf-8?B?eFI1bjR6VzV1bWU2UVZqYWN4ditxdHBUVzJaT1VVYVdXSVg2MDVBSy9RREpL?=
 =?utf-8?Q?fuaUSGcHPCkuvS2Q=3D?=
X-Exchange-RoutingPolicyChecked:
	D35+pUauDC4G0cSzJxqRrk0ctqBXzXlZzT5jI5TexBKcYh9KfHlAaL/j7a8/xUN3ZNYhUXWAJvpS4ptYB7O5M2DBn28McAzidUJTUIw5+GkErO5ep3XddSWDmbq7W860lhGYSI9I0lg/sHCcNmxbRGfJaP6/j8B/NiDRbIl1BkJNtqIyWEM2ccD86Bl/Q2v8CH/km/ja6OJ0u/zLBYzVFO6AX38FzW3kc+BVWwLZiad+TDNdRJNknHYnzURKB1h3A4OpDFe1kGXsNvr53xxYS61ShlV3wKUl08fe+mXzBS+DlXbUqrQyBgFkeTgKFqJd0xnRrNn+Bd54s7GF6Ggdxg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LaRgVJTk20NOdN4ZDCzDL1/4cNHb22972WaF+Scayp4wH6obJrMx/kRZgHnd9VSznl66EhiiYmQerrEw3dxQ1vTF6+9YZQ56lRmDMggAmwvupA47bOyWwDR430JneIkLQo/rYcNLHven0uYnELQJlluCSZQWFjNJnFL3tL5sbpeRBafDqZSglaZVaJbW7daaVYjepAPp+q12u0eHSPSiIl2xJbnjbtK4tJL4720dlQN5+9aet9YysWjvf7J18CEoRG6X3nu0YQJvH0S8fS00krrjPbwJrtp/4sbmaYRYDlaaTCQZaNasax6MRzmn9J/2XsrVIeoM8AScvHjvqB+T6++ktQ+7AHN6XBYyBueQartIt1v7uCNtMkVBbr/84oCmY8pCga/IMkXjtFZXMrXE0HQxgD0ujCeNUqDHeoBWuj64IHofpoAc8yHPuJRiuBVU4SuczyM3RsYnfRLby52LrKTou9E/w9uRtqXL3+xx4AqUOPSaNlAsJYRO48aJeJ3/FRLHY25I/BNGRmGsxZTLy7cxB0JQjwBAEKXl1rftE8HQjruC4tHQxCRbnlNoC9prDY40odJj3oIo3y7j1EFRi+bI3J60vhPo/kn9FjC4XP9GzRne1TIv6WuNkVUBOnuA
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 026f5ac9-a2aa-4a84-7327-08df0dcac21c
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 17:01:00.2388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rTwH1f+1qnjwawD/NUGWdQ/9PTzn98jlpZf3bgTqpHya0dLasEWVzO8AB8bt9BSI3NgJeMAmr8AvzjYnYyYxORwXiVycwx/BoM3CVKmNRqM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR04MB8716

On 9/7/26 3:39 PM, Jack Wang wrote:
> The reproducer, for anyone who wants it:
>
>    mdadm -C /dev/md111 --force -e 1.2 --assume-clean -l 1 \
>          --bitmap=internal -n 2 /dev/ram0 /dev/ram1
>
>    fio --direct=1 --rw=randrw --ioengine=libaio --iodepth=32 --numjobs=4 \
>        --time_based=1 --runtime=180 --filename=/dev/md111 --name=repro &
>
>    while :; do
>        echo 128 > /sys/block/md111/queue/max_sectors_kb 2>/dev/null
>    done &
>
>    for i in $(seq 20); do
>        mdadm /dev/md111 --fail /dev/ram0
>        mdadm /dev/md111 --remove /dev/ram0
>        mdadm /dev/md111 --add /dev/ram0
>        mdadm --wait /dev/md111
>    done

This sounds like something that is worth a blktest, isn't it?

