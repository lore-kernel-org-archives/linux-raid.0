Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11023101.outbound.protection.outlook.com [40.107.159.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B3D299ABF
	for <linux-raid@vger.kernel.org>; Sun,  7 Dec 2025 14:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.101
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765118507; cv=fail; b=cyk9FN8Vjne94ZitcZrScf0bFmGPuTIr1PTahFhLhp/HtCYfHur1x2nHg+sSjaTE3KZNusL2IQWtmCxSLXyQoeff/eLKrfO8RQfDTWRC8vYT49p0Jv3Ql6sx7oTJE/52OTHYGd0w7epY+8E7+wWH/9Z2dYneQxGqLZYM4v+0TwY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765118507; c=relaxed/simple;
	bh=C2lw8Mutp7p86pJqWh5FSFpIQ9ZDr7y/lNUOwiSe10U=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=F2W6pZWYdV0sfaUCnoJVeZLEiAbaTdO3hEQ0koWlnGoK/rU2VWIH6V6KkcQb26Tcq7JdmvT7LQJrx1Ep3Ra98T38JwmqqmUZhVT+LbT75Utr3nBB9vB0/FSCszHLpLtDCAjql+zfxCfg/bj83DSFLbjTkcrZUgEQjiwqVFbWL2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mail.fernfh.ac.at; spf=pass smtp.mailfrom=mail.fernfh.ac.at; dkim=pass (2048-bit key) header.d=mail.fernfh.ac.at header.i=@mail.fernfh.ac.at header.b=fZf/HoNg; arc=fail smtp.client-ip=40.107.159.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mail.fernfh.ac.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.fernfh.ac.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mail.fernfh.ac.at header.i=@mail.fernfh.ac.at header.b="fZf/HoNg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H7QcJeglVmkqFU8sC3FZbQ2eJPRPVbSStzmM9dAZ2YEshShcx+fnz3dcPW/hge5IMDtXQ5QyVLYo4lx7ywYSWVryxH3IXGUtvX7+tw+S82br+w31k8L+4YK8klYfcxOmwPSD62AWkVu7hwBSRC3EXVLa+qsvbe69Y47HamZzxZRbi+qDfo6b8HzIvb6CyrVV5BIpf4l3yhXfqnyklclT9RkMxvxEbxbHCuuKz8Y0PyPoTWBEBwKQDhePGzojDIFimmmVmZVzaVoJ6/YI0KYz2+7vU1SVXKgUuQdRq0+FInZrVbRIkwd8ehTXJd+fjCBjnOCc3my/X99yckiYddybEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C2lw8Mutp7p86pJqWh5FSFpIQ9ZDr7y/lNUOwiSe10U=;
 b=F8EMzqn0wy3vXmtNUmWGoJJSkTrNAcl8B1LHuYpRAOIBSMn5XX32SSG4eW+HABnDTPlbDO7nRk3STmcH7EI/DUYBJAEri5prQqGKsT15Xs6X0MoJQODZtX1EjEXp1Ww9q0kVNWYwva69ARXX9d8Z8ENBd93k66e5gQoid4MpEBKh/07WXu77tGp2KEHBpKbfUflkEvjiDZJAHWvuB4zYJOx6V8ZyjfYcEyinq+ecfVxj+MPgOOgOeX79owLuIdG91dnaBZU9hIcWq8MPdaiK5VEm51vJizfxtaYa4GODJ4NzWo8u3QEZxEy7V8Sb7Ytuh2GU4dakpdnQ9dCkHm2csQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mail.fernfh.ac.at; dmarc=pass action=none
 header.from=mail.fernfh.ac.at; dkim=pass header.d=mail.fernfh.ac.at; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mail.fernfh.ac.at;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2lw8Mutp7p86pJqWh5FSFpIQ9ZDr7y/lNUOwiSe10U=;
 b=fZf/HoNgBb1fPRxqQfYmEwhduYIjOdASEroNTgNsK6ZWJFoVmejp0nAfdO53KQm43HREHsENyMDYhJYA9FaTlmfm326g1SRm7xPuCimcpuBsP7zvz6/9hV6905kJs68JMBdUkdcgpt+lW8ChqiW1qEoOAAna88hB6RLCadoOGpkRV7s2aoNx1f1H0i++R4tlkywDVeeYiAydiX7OZHDP6UaKpnfl+mWCBw8hmXKBX4TTZdFUscmhhQ/Zktaoeo0c3fd3O+yqZI/8IZ4gAS8Cqkp3m3ou0xA+HdTU1W6ddmr4JIdlzP2UFRprs8NKftcdMfxCaaqOss1JbR2CW76DEQ==
Received: from AM9PR04MB8955.eurprd04.prod.outlook.com (2603:10a6:20b:40a::10)
 by GV1PR04MB9152.eurprd04.prod.outlook.com (2603:10a6:150:27::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Sun, 7 Dec
 2025 14:41:37 +0000
Received: from AM9PR04MB8955.eurprd04.prod.outlook.com
 ([fe80::a7ea:d8cb:ae90:8e70]) by AM9PR04MB8955.eurprd04.prod.outlook.com
 ([fe80::a7ea:d8cb:ae90:8e70%4]) with mapi id 15.20.9388.013; Sun, 7 Dec 2025
 14:41:37 +0000
From: Christian Focke-Kiss <christian.focke-kiss@mail.fernfh.ac.at>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
CC: "yukuai3@huawei.com" <yukuai3@huawei.com>, "song@kernel.org"
	<song@kernel.org>
Subject: Possible issue with software RAID 1 in case of disks with different
 speed
Thread-Topic: Possible issue with software RAID 1 in case of disks with
 different speed
Thread-Index: AQHcZ4eXkZCPbP7c9kuXhIJnTRT8kQ==
Date: Sun, 7 Dec 2025 14:41:37 +0000
Message-ID: <ac13d188ba7e2d5b0e2a8943d720f1903003d548.camel@mail.fernfh.ac.at>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mail.fernfh.ac.at;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8955:EE_|GV1PR04MB9152:EE_
x-ms-office365-filtering-correlation-id: 7c27694b-a1ab-4ec2-e1e4-08de359eb9ec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|23032799003|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?blJGSzFYdkJicmU0TG9waDRCU2RTZ1ZKNUNIZHljc1dJY0FYQU9PRzZwVFhL?=
 =?utf-8?B?TlNDTkdCTlZYdUkyUmg2SWJBQnhZOW9qRmwvY0JsbGVPdXBlKy9tMHBSbTQv?=
 =?utf-8?B?MFU2ZklDVEhYN2tkYVFUbmJpL2lpaHY0OXlwS3NHcTBLT0x6d3FTQzVRNmRM?=
 =?utf-8?B?Z203dmVyazlBY2laMU1kaHNHRTg0dElOa3NtWFNZdXZLSVIrN0JnRnRmRDRT?=
 =?utf-8?B?cDAvRGZtaXd6ZmhqdFkxS2FPelM5QWlzay9WdmpkdndPVDFCa3NNNUZPTEdi?=
 =?utf-8?B?c2lNeU5yblRKR1F1YlJJQnd3aEZEL1gvYUI1VGNkUnR4TG9uWXRQdHRLWCtU?=
 =?utf-8?B?czV3bGtIYUNqZzZyMlNwQzVMZjB5cmNWZkJ6TTVwU29jQld3YjQ2MlVWWFJL?=
 =?utf-8?B?TG9WbGlLWnlIQUUxZHVFa0FqRVlpRkRFRlRIb3U5VHBybmVncWVrVHRkeU9C?=
 =?utf-8?B?ZEdUMU9XRGJYVWcxbFgrU2s5Z05wRVN5SVoxTVZWdDlWNE9zaFdRNDRFUklS?=
 =?utf-8?B?WGh5UTJSMS9BbkxPRnM5LzAybGtSaUlRakNMQkVuSGg3VXp3SGJtWUdyamw4?=
 =?utf-8?B?VnhpZUJjME1EbmpKb2RwYmtiWEhBWk9hK1pKWXhZS3A5N0trS21IUDRKVGR3?=
 =?utf-8?B?cHE0Q2ZkMkxRS1dCbnZQQ2UxZXpmOHBUYVRoN05XVjJibWh1SzFjQ0N1Q1ZD?=
 =?utf-8?B?NFd1d2UzSHZmbnVOMzN0N3VHclR4MU1JS3l6SVVPODJHNzlZMk9JdFI4U2k5?=
 =?utf-8?B?cEFkdm1pNU1MalhzZmpYeHVBS0JpYzY1UW9QL0VXMmVlQ3JySDgyKzF3NzlE?=
 =?utf-8?B?YVlpSHJsMVRCTjgvczlrRXpIRFl0VnFLeWFpczNFMDA3dUVSclpaK2dQMWs3?=
 =?utf-8?B?WU1IVXE1ckF1eDZyV05ybTI5ZVo2RC91WmNRUkZtQ09iM25rZ21sL1NoNEht?=
 =?utf-8?B?bzhaUTVDTHFYOW5FUGgyS2V5V3Vxdkk0c3JJMml4Ny81dkJLdzVkNkJNSVJ0?=
 =?utf-8?B?UVB3R3loNkZlVG1IRmFyTnBhbE9NSFBVUzhQZUJwTCtrOTl4RzVwZUtxa25p?=
 =?utf-8?B?ODRFeFdhQk5BeFdLUGJQY3FETDBiVFhURU93blg0MjFyNVlvcGNtbWNNL08w?=
 =?utf-8?B?WGhQdnBldkhQbUdQMldPTVl1Z212eC85RzI0a3laeHg0ZHBKUnJhYTlmamNF?=
 =?utf-8?B?TWRsbEpMc2RIWnRpS0JjMTVURGtlT29JNkpRcVEzNS9wYytYeENTc1MxaUxZ?=
 =?utf-8?B?S3J5bWs4YTdhR1AycnhDalNCTHFZMzJWcHRwcjFYZjRHOGVMYm1sd2Fxd0RV?=
 =?utf-8?B?UGZ4Rm9HcXdzME5EejJ2QmcwWGtaSWJ3MjRlMEdKbWhKS3c4b3RjKzRvelBF?=
 =?utf-8?B?ak9XRU05ckVXaE9YcUIwajJ5UnpJbjNNT3lBR2ZvWVpTc0JJSnk0YkFTMzVt?=
 =?utf-8?B?WVZ5SkJ6R1ROQ29lM1FvQjRrdnZlc1p4R3lzWEZrN0VjdTJSSThFTHZoc1Rw?=
 =?utf-8?B?RDVobWt4YStNdWYxK3RDM2sxMEJmTmZ1T1ZUSlpVQWwyc29qMVdIZWZXT3lh?=
 =?utf-8?B?d243b1UzQ1VZVVYrZXd6b0NkM2czdnpRRGhNMzNVZ0NwNW4yOHNESkwvRnRL?=
 =?utf-8?B?eVk2enU3YVFyQjNmUi8zY1NOV1k3ZW9CeWU2UlViU3l4RDRSVWpWSlhZNThX?=
 =?utf-8?B?VGxyRlh4bm9YOGdnSFpIcjVoQ2NuRWhNTG9MSW5OWjFUOGRkTzFpNHlOUTRY?=
 =?utf-8?B?M0ZDUnVFWFlCV3k1VnZ2akVsM1VNZ2pqNVhITCsyRkdXL0JPb1dxU2J2VkNU?=
 =?utf-8?B?SlQzQ2sxaWIxR0hKaVJjcnRTcG5nd0I0TTREZkoyc0duZmI1UUVCU0V6a2lx?=
 =?utf-8?B?VmpUZE5TcG5pUWx3NFQ2NHp0MldQRzc2d0M3Ykg1bTFaZFBLV0t3SkhhRWRj?=
 =?utf-8?B?cVR2RHBKZVgxTDRZcmJZeWJUWjhmNXVjZXFpYk5pRzdlSVBtbXp2UzNZN2Vh?=
 =?utf-8?B?Q0JBWDdmZ2EzVHB1VVpJQlZWVWpWZ3JTOHVta2JpZENXVzdpT3FrNVV3QlNP?=
 =?utf-8?Q?lP5/p1?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8955.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23032799003)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WlZnZUloTjk3bitFRngrV2N3WE9EaXBxY0pEQk9kMzNiTEMzM0p3dFp2bGVU?=
 =?utf-8?B?QUxjTVBGYnZ3dThHYUZQTTNJQ0txNE16Vjh5OW1PaGN6VmIxR05HeUhvZm1K?=
 =?utf-8?B?a2lFQmVBUlBkeTVTVThSRVkrcXo5QkYyN0d1bFc1TnNhejVGb2gwV2VnbUda?=
 =?utf-8?B?cUhodmZuZ1BhU0dtN3NNTHc2bmFidGtxMzVDV21TZFFsY09FWGtpcHNTWjNS?=
 =?utf-8?B?MHV6MTNBNlcvT1Y1WVlZZGJJRVRocGVvdW02cGYzSzlIVzlDUm5QcExBc29z?=
 =?utf-8?B?ajM2azNCQWFVc1JvVVJVYWl4L2xZUTM5RVhvTndibjdENFFNOVdXOTdXOE9F?=
 =?utf-8?B?T0xlbWhzTDdhcmRXT2puVmRnZW8rb2I2NllvVkxsZXNESWVWZHYzY09LNFBY?=
 =?utf-8?B?Um9acDAyUVV6dU50ZVlDUDBuMnZxUFlLaVR3WTRxUVRmbksvdGVHMDdQby9h?=
 =?utf-8?B?cEM3ZjBabmVyMTMyRm9ETjAwNGQ5TmlQM2xBTlh0cFB3RkIybGpPcWswMXJM?=
 =?utf-8?B?Z24vQVhZYkhheVoyMkJpVi9RRDBxb2pBZ2FDOTRsb0hXM0JIWEpKczlGclBY?=
 =?utf-8?B?dVZ3SXAxdVFMeWkzd29GTjVDMjFIQW1Yamw5Y0NUelBUWWNiSnJLZ3hxc016?=
 =?utf-8?B?Y2tXclQxMFRTYXRCM3VtdEdMQVk5STdVQVkwNnVOUXF2UGhtMFVNdmlGN3l5?=
 =?utf-8?B?N0JmbFlSWDN4K2h2RVlaUWY2S1lNREY1cEhQdHA3MkU4NElBNHNrTGhOSnFF?=
 =?utf-8?B?Tm1hS0pzK3B5MDdFTjRPK2ptR2FLd3R0eG92WHRkYXJOcThvWjBIQnZaSE52?=
 =?utf-8?B?cVQ5RnAvNjhlWWdYeWdXM25jcFloUHcxbENDakYrSGtPWWV4aWhtdlBubE9U?=
 =?utf-8?B?ZTAvdXBZamFYREZvMHF2S3JMT2IydVhvNVZscjZBS0xqLy9VNk9DRGdNK3JS?=
 =?utf-8?B?cWJRcUVUQmxNMEZiM0c2SlRRdVJIUUU5Mno4bDZUK0dyVU9XVjF4Y0dicVc1?=
 =?utf-8?B?cVh0RXBRZGl4VlhyeXFWalZmdzkzaW5QalMrU1pKMVRRUE1TdWtMYUdDL2t1?=
 =?utf-8?B?MSthTVZHSVhGdnBGRmwzZTBqUFdvWHhqTEdWZ3prc1lQZTdQVGdPVlErU2J6?=
 =?utf-8?B?dmlyb01aUlJ2MHoyaWhLMnZ5VW9SVFNZRGM2eFBzNTd5L2l3MlpIdjNnRHNv?=
 =?utf-8?B?OFBCcXFjMm9PTFZYeGVZY2NBbTQvVVo5eVhQdjBzeDVjei9mazZiRW1yVWEr?=
 =?utf-8?B?a3QrbDFzZS9ZU1JyV3R1M3pJcmZHZ1pKRWFCRVRxaCswQmtlaXpCdktTbFRV?=
 =?utf-8?B?L29GSWpDNTk3OW1sdjd5UGYrb1lGK2NiL0lsclJ4bVlnVGFIUkhIZFI5ZzNQ?=
 =?utf-8?B?S2NwTHpNTHF3QStoZEluSlU4OUxNVXh4aVUxWkJFRHBRamxRMkJoTG1QKzVN?=
 =?utf-8?B?andQK0dvbFhEamw1VzkwaUpJUXgwY1hTYzlJTVNKYW9lb2JqNWhnYkE2QXd6?=
 =?utf-8?B?TlhpcURDSlh5UEZocWxDNWVKT1kyWERHb1FmU2psSUcyZENQSjRoR0hKSUZx?=
 =?utf-8?B?c0pJbXN6UkZTTmlxRTY2S3dFeGdCQVJhVGRqdStrd3ZJUDREazk2Y1Bvajdl?=
 =?utf-8?B?ZE5MTWdHeHR4bmpoUzdyeUJPN3MwZ2ZEUEx5eW9QTkpjZ0pRdDk1RkRuUEMx?=
 =?utf-8?B?OVUzYm9YV0dxVnQ4SENTYUlDa1l6ZWN6bWNGSWpIWXEyT1oyMlgxQjZBQlJn?=
 =?utf-8?B?U045RER3Q2hySUVTL0YzVUZJczVUOHJnM1NocVlIU3ZXaE1jd1lhcjIxSnVk?=
 =?utf-8?B?MHdwRHd2WjN1SU9iMEh3bFY4YnpHbTZpeVlrWXJOOSthTE1iVHVQRkpGdi9S?=
 =?utf-8?B?eU05OTVhcUFIbjUvWnBSSnBOZlU3RnpTQ0xGNHp1VjRVLzdHL3ZGWi9uVXRJ?=
 =?utf-8?B?c09vdG1taFFtZFVLNUw1blRWVXJHZXRmMzUzZENiWFErODNQb2Y3MFRjdWVl?=
 =?utf-8?B?aGxyNk9nWVZSMDNUdEJjNVgrcFNwMGxDU3M3UExTclNhc2hJYmticEw3RjN0?=
 =?utf-8?B?RTdWeUhRSGdybUU1OWlScnQzWTZaaWlWdlFCTkJUcy9OTXVqc3M5WlBYSElq?=
 =?utf-8?B?ZjVzRW5lYjdzaTVkVStTRGoxTFRnMEppWVVRRzluVXNhU1ZjM01rM296a1pW?=
 =?utf-8?Q?8FOPpZGUTiZsQqSGyTIQqAjAeuKhCc9p3o9KJUPK//4V?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1A54BA864FFF2F41A7E8D92F47C75755@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: mail.fernfh.ac.at
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8955.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c27694b-a1ab-4ec2-e1e4-08de359eb9ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2025 14:41:37.3242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a94a81de-eb39-48c0-adc6-b3c18a5199fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h4zSqQCbruKKqse0LIOGO7mye4eZFgwENsaY9w7s3Gzv/kxo68rTlOEKhVAOgTMh4I3EMcWjbUx5sXr6INkkv8bSgNpMvZoE00Cfw09DO4reHDT7xIhpB5fOM+ID2eLD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9152

SGVsbG8sDQoNCkkgYW0gdXNpbmcgRGViaWFuIHN0YWJsZSBmb3IgeWVhcnMgKGN1cnJlbnRseSwg
cmVsZWFzZSAxMzsgYmVmb3JlLCAxMiwNCjExLCAxMCwgZXRjLiBzdGFydGluZyB3aXRoIDMuMCwg
aWYgbXkgbG9uZy10aW1lIGJhY2t1cHMgYXJlIGNvbXBsZXRlKS4NCg0KRm9yIHNvbWUgeWVhcnMg
bm93LCBJIGFtIHVzaW5nIHNvZnR3YXJlIFJBSUQgd2l0aCB0d28gUkFJRCAxIHNldHMgd2l0aA0K
dGhyZWUgOFRCIGRpc2tzIGVhY2gsIG9uZSBmb3IgbXkgcHJvZHVjdGlvbiBkYXRhICgvaG9tZSwg
L3Zhci9saWIsDQovdmFyL3d3dywgZXRjLikgYW5kIHRoZSBzZWNvbmQgb25lIGZvciBhIG5pZ2h0
bHkgYmFja3VwIG9mIG15DQpwcm9kdWN0aW9uIGRhdGEgKHRocmVlIGRpc2tzIGVhY2ggYmVjYXVz
ZSBIRERzIGZhaWxlZCBxdWl0ZSBmcmVxdWVudGx5DQp0aGVuLCBhbmQgcmVjb3Zlcnkgd2FzIHNs
b3cpLg0KDQpJbml0aWFsbHksIEkgdXNlZCBleHRlcm5hbCBkaXNrcyBjb25uZWN0ZWQgbWFpbmx5
IHZpYSBVU0IgMy54LCBhbmQgYWxzbw0KdmlhIFVTQiAyLjAsIHdoZW4gSSByYW4gb3V0IG9mIFVT
QiBwb3J0cy4gUmVhc29uIGZvciBVU0Igd2FzIHRoYXQgSQ0KY291bGRuJ3Qvd291bGRuJ3QgYWZm
b3JkIGEgc2VydmVyIHdpdGggc2xvdHMgZm9yIGFjY29tb2RhdGluZyBzaXggMy41Ig0KSEREcy4N
Cg0KQWZ0ZXIgbWlncmF0aW5nIHRoZSBmYWlsZWQgMy41IiBIRERzIHRvIDIuNSIgU1NEcyBvbmUt
Ynktb25lIG92ZXIgdGhlDQp5ZWFycywgSSBmaW5hbGx5IG1pZ3JhdGVkIGZpdmUgZGlza3MgaW50
byBhIHJhY2stbW91bnQgc2VydmVyIGFuZA0KY29ubmVjdGVkIHRoZSBzaXh0aCBkaXNrIHZpYSBV
U0IgMy54IChJIGNvdWxkbid0IG1pZ3JhdGUgYWxsIHNpeCBkaXNrcw0KYmVjYXVzZSBvbmUgc2xv
dCB3YXMgc3RpbGwgb2NjdXBpZWQgYnkgdGhlIGJvb3QgZGlzaykuDQoNCkkgcnVuIG5pZ2h0bHkg
cnN5bmMgam9icyAoJ21hbmFnZWQnIGJ5IEJhY2sgSW4gVGltZSkgdG8gYmFja3VwDQpldmVyeXRo
aW5nIGZyb20gL2Rldi9tZDAgKGJvb3QpIHRvIC9kZXYvbWQxIChwcm9kdWN0aW9uKSBhbmQgdGhl
biB0bw0KL2Rldi9tZDIgKGJhY2t1cCkuDQoNCk5vdywgYXMgbG9uZyBhcyB0aGUgc2l4dGggZGlz
ayB3YXMgc3RpbGwgY29ubmVjdGVkIHZpYSBVU0IgMy54LCB0aGUNCnJzeW5jIGpvYiBhbmQgYSBr
d29ya2VyIGpvYiB3ZXJlICdibG9ja2VkJyBhZnRlciBzb21lIGhvdXJzIG9mIHJzeW5jLQ0KaW5n
LCBhbmQgdGhlIGNvbnNvbGUgZGlzcGxheWVkIHNvbWUgJ3N5bmMnIGVycm9ycywgYW5kIEkgaGFk
IHRvIHByZXNzDQpDdHJsK0FsdCtEZWwgdG8gcmVib290IHRoZSBzeXN0ZW0gYmVjYXVzZSBsb2dp
biBkaWRuJ3Qgd29yayBhbnltb3JlLg0KDQpJIGZsYWdnZWQgdGhlIFVTQiAzLnggZGlzayAnd3Jp
dGUtbW9zdGx5JyBhbmQgJ25vZmFpbGZhc3QnIGJ1dCB0aGlzDQpkaWRuJ3QgcmVzb2x2ZSB0aGUg
aXNzdWUuDQoNCk9ubHkgYWZ0ZXIgSSBhZGRlZCB0d28gTlZNZSBTU0RzIGFzIGJvb3QgZGlza3Mg
YW5kIG1pZ3JhdGVkIHRoZSBzaXh0aA0KU1NEIGludG8gdGhlIHNpeHRoIHNsb3QsIGV2ZXJ5dGhp
bmcgcnVucyBmaW5lLg0KDQpDb25jbHVzaW9uOg0KSSBzdXNwZWN0IHNvZnR3YXJlIFJBSUQgMSBo
YXMgaXNzdWVzIGlmIG9uZSBkaXNrIG9mIGEgdGhyZWUgZGlzayBSQUlEIDENCnNldCBpcyBzaWdu
aWZpY2FudGx5IHNsb3dlciB0aGFuIHRoZSBvdGhlciB0d28gZGlza3MuDQoNCkV2ZXJ5dGhpbmcg
d29ya3MgZmluZSBmb3IgbWUgbm93LCBidXQgaW4gY2FzZSAuLi4NCg0KS2luZCByZWdhcmRzLCBD
aHJpc3RpYW4NCg==
