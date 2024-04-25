Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F16515350E
	for <linux-raid@vger.kernel.org>; Thu, 25 Apr 2024 20:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714076983; cv=fail; b=tuMXkcrCJb7QVn0xpkg7CfISNWhHPW3Oj1v1W9jUtIu4YniXKU4e0t0LZ9qtJu1rRlohfV7xnFHwYRIPBcjLLWD5/z3HWydWjG/opJZZu3/Umg9FM122XM43Jw/uJJMbbEd/VS64+gzAVaKzv034VUnni6TzhyVcFJEGIIgXyHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714076983; c=relaxed/simple;
	bh=RCleVhV6Qe2dyiWG2CLhPYpcT2NUIbaFPh3+gJXZpTc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ceJiqLfJKh93pXChDMO6SS74ymbglSuNMLNktrwF4/Loa3PAZZB4Ml5eEyMH127ytM3JJoroI5PYxWbmexOghtcRKcH0qVU7F+Hd/CAVJqumDpUpHQSEhcU9jUd9g/e/LcnpzAIsVAA+C7Ltnwg2F7MdASLGXDc5QbclHOHj5rM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Cy0aT42Q; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Cy0aT42Q"
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 43PJ39mf010697
	for <linux-raid@vger.kernel.org>; Thu, 25 Apr 2024 13:29:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=RCleVhV6Qe2dyiWG2CLhPYpcT2NUIbaFPh3+gJXZpTc=;
 b=Cy0aT42QLA6r7TgRL/6VOqQgy79gmH5+Q6rSRzzH8KZ7HVq7PjGXdsmC/7w+whLGQeKd
 HTrd3QqQImdDiwsoVGuL3UejtTr/uo4UxUMAU9Y5k8STP0AdkAWdyxNGCux0e2fkfErq
 5MO86UP+BsnG6eixBiiM9NrsT0Id30sUinv7UFldKose5OcHBPFJo+2If7PpmNASS/iY
 FzOJCdk3yWJM0I3kkuusokp+sAuKJv4V7cvOkcYoADkD1nQCV7pBKWSdG2Ifv6VK54lI
 QzA5qZWQaisz7Z//OpmJP6K3GGFOPqWAsFZS1s5H7Ws/DgJuHvQ+sCjDM7jOmyspYhCj 7g== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by m0089730.ppops.net (PPS) with ESMTPS id 3xqepbnb19-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Thu, 25 Apr 2024 13:29:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ATzaLBBjYMnoaMehE8d5DDj2j8pD9/T4vMbs/V1e35ish7GrE+JOOGkVhm1fb3YKoP2YBILYEt9Kateeron1TkhfCNzfnqeNeraehngABo6INmAD9K0hUX1u4f0/LnnsbbOb9fbP/lW+q6u92Arr3lmJN7wIXu8qJD2I86HV+QVXKtfGuHDMk95NdDWjjcynTHYUtB5yDpg0oSOC4KXWPuEWqRznzdTAVjb+f3nkwqjAJw9YiEJOJjrTVv+QfpjD74yRN1bdAEDt7R2WS/GqcQEA4e2qxLT3XGiuW7uAM0C2w5/ZJ4M9lccteQOvx1qd9lfq4x5NXv8hjmi02W/Iaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RCleVhV6Qe2dyiWG2CLhPYpcT2NUIbaFPh3+gJXZpTc=;
 b=G96Gyx9Uybx2v0Xpm7KWNt1eAA6gNwsIr31jet+tjEfuLlERmT46QyBUvk/sAptp9RW+8pO1uNu1BaMUDeaBtOVYnbYomx7C1IA6W1Im7Niw4IXvxjpV224jnwgnyfZYava/siyPZzDx/B1QSypnuF5Ttgx4mkbcWyFuaxgW/mk3i6Kyp9jLJFnrakWiEB3i4pabW6fE84uWpnfcA4Fa5ApVjijuTbhAHDbBypAxEGBKTcrlg1h7Bd/y/yxhvIF1DLX+Fg+FCVqshd4UQb90z8KMn2LFnJhhQSgNLvfG4XsviC23GkrJTZUf46N7FaC/9OggEf5kCJOr20b4dGT9Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA3PR15MB5727.namprd15.prod.outlook.com (2603:10b6:806:311::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Thu, 25 Apr
 2024 20:29:36 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7472.044; Thu, 25 Apr 2024
 20:29:36 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>
CC: Song Liu <songliubraving@meta.com>,
        linux-raid
	<linux-raid@vger.kernel.org>, Li Nan <linan122@huawei.com>,
        Yu Kuai
	<yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
        Florian-Ewald
 Mueller <florian-ewald.mueller@ionos.com>,
        Song Liu <song@kernel.org>
Subject: Re: [GIT PULL] md-6.10 20240425
Thread-Topic: [GIT PULL] md-6.10 20240425
Thread-Index: AQHal0n6nxF7uwzaVkaFmIZMUUkCybF5aGsAgAAHhgA=
Date: Thu, 25 Apr 2024 20:29:36 +0000
Message-ID: <D2619D49-53C2-476C-BC73-EEB09ED4557D@fb.com>
References: <CE08A995-B84A-4B4B-BC7A-0EB73319877E@fb.com>
 <6addafce-5a59-47d0-b580-9ec3e54fc805@kernel.dk>
In-Reply-To: <6addafce-5a59-47d0-b580-9ec3e54fc805@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.500.171.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SA3PR15MB5727:EE_
x-ms-office365-filtering-correlation-id: f7655388-8594-49c4-de2a-08dc65666c86
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 =?utf-8?B?TmRXY3NmY1Z4djZ3OUxzdVYrdGNWdjA2MjVwekZuRDVDK0Z0NVhIZjIxNFZs?=
 =?utf-8?B?ZmtUa0pmdEl4VlRWNi84Z2oyd1lFQmdpVXVFaExrYk1kU1NXaGlyOHlBekFJ?=
 =?utf-8?B?amNnekhpL1VYaWZrcDdYS282dEZYdDlFYkx4OGs4ajZUbGVLZFprWUo5cHpN?=
 =?utf-8?B?SGdyK2RXTTVGWmo5V0kxVms0S2tBYVBtR1hrcnpIWXM4WVRwWDZvYU1BU083?=
 =?utf-8?B?aHZzNkhQbGNXNklRR2NFOXlqdlhxSmErSFpyNnE3VDZFeUlrYUxTamZ6U0hE?=
 =?utf-8?B?dnFCWE90TUJsZ3ArbFp5c0tlSmdKZ2pEb1ZiaXRKOFdjbVNwSnllMkFqenpa?=
 =?utf-8?B?OFZPaHo4cTZNTWV3eHNpb1dSQ0RaTDVDakZJWkdFVHN0K2tpbW45N1BuZWNw?=
 =?utf-8?B?OEJYamJQYzlxM0ozQ1Y3a1diSHdhZmd1ZWFMN2tQcHBYZWhSK3A5Sll5VDMy?=
 =?utf-8?B?S0JGMnJoL1JUVVVldUUrOE50RFVIcDA2eDVPTllzbHN3djUwU2dyRzZYa0xz?=
 =?utf-8?B?M3ZVR0twZ3AvckxrT01mTnRXbThvUjhVRXRFWXo2bm1QSTRYbERrMk41SDhs?=
 =?utf-8?B?UUhpVHRsT3hqbVZiY3NNRnh1YmZJdmw3OXAyUXhoN1FNa2tXRnNSVzBtSzE0?=
 =?utf-8?B?cmdTaGtHcjMwSldjMisxbEZZbGR5ZWZQUnhXdlc0Q2twVjM1TlA0blFwZEdT?=
 =?utf-8?B?R1FKVE1LcHpzU0xMK05jOXVGeXNoM2Y0MGNyTHl0SDJLcjhqV29pN25IclBn?=
 =?utf-8?B?VTZsd3ErYjNNK1FSZDRZSkhXRjVIZUZUVDVjcWZVLzV5dHk1QXBqT3p4SnVa?=
 =?utf-8?B?TWlrWkJyTkVEMWhHUmlEdENRNUpQTnVFYytjeWw4TkxJbSt6WGdOMHZMbkdL?=
 =?utf-8?B?Q2kxODJkLzNNaGhZL0hrZHRHalFvemNVei9LU20xL29WYWlnbEdDOFMySnU2?=
 =?utf-8?B?b2svbytxdlRhT1V3NytaaTRFeW5WaGpKSmhxNlpMQ2V3a1hGZUp6MWYxa0sw?=
 =?utf-8?B?bmNKSkZNVEJlQTZDTWVwQU5wM3hDVmFDY0ZVRWlWelUyZzJ6MXlyeWFkVVgr?=
 =?utf-8?B?bXNBRFdWN2xtTm0rVGxJRXF5RzdMYXppcmVPZXF2bnBBVzJZZWxibHY2dXlq?=
 =?utf-8?B?YUw2NVFKbEJxeXphT2JiMHVFVmo0d0ZiUnpUUTFZL1hYcENldCt2YTRadkxt?=
 =?utf-8?B?QjZNSER6dDk3dWk1OVBOMDMyMDJGdmJzbWhqaUlST1VmR2RFZFYza0dLbzhR?=
 =?utf-8?B?VCtoWkV0c0cxZkRaa2xFbDhncm5lMndmb0lla0tKdE9SQ0s4OWw2YjYrVVBU?=
 =?utf-8?B?R0R0bGZFRVNUOCtETEo3UW0zNzNrQ1Z1TlhtZ1N4cFc4Ly81Nlk1alE2UmtP?=
 =?utf-8?B?akYwU3EwWjhJRUhMcFBHUGVpdVJnY2Q4ckdDRWJXTlVvRmlpVU1IVkxKNHZw?=
 =?utf-8?B?aFJmZDBjZURLQ3c0K2c5Uzk1NHBhU1psdnR3TGczekltdDFRVHFtRFBpQ0py?=
 =?utf-8?B?bkdSZzhFZnprQlVmdUZLY0cvL3N4WVljUGhScEhYWXdNMFIzSndqYlA1MmZi?=
 =?utf-8?B?VFM3VDE3ZlZwQm56MVVmS3cvV1lFRWQ4TnA1SXBTRWlnSTl4QlhMeU5LQ0pW?=
 =?utf-8?B?YXBneU9URUFKZUFnbjcxekxiQ3dIU0NPSVBneDdoRTByMmwxTEorS24xVU5N?=
 =?utf-8?B?bHUwYm0zNElNVDFyVXpRWkNzUFhKUSttNDE1WHlNbTluVThyZVB5aVdHMnpG?=
 =?utf-8?B?T2lCelVrNFZveDgyN20wZXRNUVlyekFzYi9sV1pjMHpRcGp2NHA3bWk1NEJR?=
 =?utf-8?B?MVFEZHRvTEpDYWhHR3l1UT09?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?WjBSd2JEZE5qM0ZkcytML0tVbDkyckkvQmUxckVDbjBJQ3pDYW5CWm81S2x0?=
 =?utf-8?B?S2x4SFZIbks1cDdoWHQ0ZXBQdmJsT1NxK0RmWDQ5ODdQM25hRkhsalRSYWVO?=
 =?utf-8?B?L3liVWEwSlBUQTV3LzYwZFJ4Y2JvOEd3cDZxU2pWQm9jNDV1NUQ0di96OHZM?=
 =?utf-8?B?dG12WGUydlp3ZXFRbFp0TmUwa1NiYjBodXNJaGE1U2ROZkZacTZaWjR1U0tp?=
 =?utf-8?B?dDJCdDcvNnVHczdUQWxIM1JYZmMwTEJKVmVRRlg1TWx3OGVpU29Zb0pMRGRa?=
 =?utf-8?B?N081NDlHTlN1MTRDelJPSVVIbnV4cUd4OVZJcnVEZm5vMitad2c2dU5CK3pZ?=
 =?utf-8?B?S1g1a2M0MGxSS1hMUUJ2c1dSb0ViMm9hbjkvSDBRN1ZqYjVtbFJicFhsTDha?=
 =?utf-8?B?bk13QnNIMC96R3NRWmVJS3JhbCttaElXU3JWNjNaODUvbWwzdm9Lb1NpTFE2?=
 =?utf-8?B?bFhLWWhCZW1TdWxTM3NLU3RCNW90dXhTYmhvc3ZHNEJEaWJxVVdvYmViNXVt?=
 =?utf-8?B?LzNRSXFJR0ZMOVBqUXZyckxSVGJqdmF1V01ta2RiVGJCZHN5bE00QXRLWlo3?=
 =?utf-8?B?QVVTaGFiNGRPL3MvMlVHeHBBNWc4clp0bndTUWh1SklQVHppRmd4ZnU4b0Er?=
 =?utf-8?B?TzYyNzAyUGg4Q3oweHZLaDI2dW9qRzhLTmI2T0tpYStPVGRxQ282MU9SMGo3?=
 =?utf-8?B?VnpCdnJDcUZZdWkrRnZYMUVac2dwSjJDUG9ZNzFqOWEvbjYveURyV0szemQw?=
 =?utf-8?B?WWg4L3haVW0rUnROR0MrQWx1enFwUE04TEtoYnZqV0JlblhQZUhrTzh6U0Nx?=
 =?utf-8?B?WUljblVuV3RhSWlNaTJWbVBneFpGUThWdmRINHFlWnQrYStjSTdleS9ZbHlN?=
 =?utf-8?B?S0RLQ3VKdjRaNnp2RkVLcGVwU1U5ejZPV2dhL0xDZU9SUHczeTJpQjR5cTVS?=
 =?utf-8?B?SXg4WXFmYW9pMzFtSjBsYS93ZGNScVk1UmF6MVRiYkJWRmxiSC9DcTVPd0lU?=
 =?utf-8?B?dTV4OWJ4YmtvNm9XNU5jMTdyYWFaU1BtWHpCOHhCdWNMSlhOZmQ4bDA1dUxN?=
 =?utf-8?B?VHJDVmhjMTZtanRDSit2QVBMRUpQN25Cd0VXT2U4cWNkaUQ5NVdseTd4VzNr?=
 =?utf-8?B?SGR2SE9mWm1QRWJNb1hoS3ZocmgyakhaNi9YMDNWSUlseVNNVjVha3V1cGdy?=
 =?utf-8?B?SGpFdjZBdE9uYkIyeEh6Mk1HOFNRcjcyY0NCN3FWUTFEbXhzdmw0OVJOOFp2?=
 =?utf-8?B?N2t4ZzFnMTJvYzlkVlZ0V3puVlh5b1NhdzBBV0pBQWhPRkc0emh0Tm1TQWgw?=
 =?utf-8?B?Rnp2ZDRMaldVaHBiV0EzSmxUSldIWEwwbWY4Mjh5WkJWOXh6K21oY0xRQTZE?=
 =?utf-8?B?L0tnVDhnVGpITGlxVDNaenlieDFpT0RwaStvYWZuK0UwdE9aM2RtbzJ1YTVn?=
 =?utf-8?B?NE9VeUlDby9tVHNGVUpMSmRJSnJXcFB5Yk8vVEo1QU02Z0hPSUdGY3BFS2Z0?=
 =?utf-8?B?NHc0RFFraDNhSWpDV3Bsem5iRVg3clFRSDlub3RjWGc1VGdOckpnZitFNW1J?=
 =?utf-8?B?YzZzWFR6aVQzcEUyM1hHZzJMUmRsRkwvT2ltdmpqV2drOFcyeXlOb3lKTG5L?=
 =?utf-8?B?eUc4NlZTNVRmT2t2Nnp5WUUvQkxvRWZhbTF5UzkySkJkTmd4alJ3dGI3Zk5C?=
 =?utf-8?B?TXIzWnFidFhRVFA1SnAyTWZsUDNrb1ljMnQyMysvMWV1TkZKSzlES2dicURv?=
 =?utf-8?B?c1JwRUdUakE5dXhSbUhTdjVRc3VOeDM2OEk2ck9jZEFJTEtIUWRKenl6WlBo?=
 =?utf-8?B?SllRMWRBNmxtejArb0dWNWI2VnhIVzhtcE0vQlhnV1VweUlxaHpSTnlreWxx?=
 =?utf-8?B?SkRQM25nM3BoTm9xWGN6K2Z4Nm9BMWdMa3B4OUFZOWwzRTZjZ2EybEZJSG50?=
 =?utf-8?B?S1p1enFRblcxOTMrRU9sOE1TZHBadTB3MVFSWncxYkViclNESVZUcFNROFBo?=
 =?utf-8?B?NWtuU2tyWmx6cWdlVUN4REpZaWYrTmI5NnEra0V3L29wSERwaUhKR0Rhd2p5?=
 =?utf-8?B?MkMrNytCaE5SelY1NXhNS0FWU3VieUlaa2VLSVRHUThrTEl1enhMRHQzZXA2?=
 =?utf-8?B?S2ZFeE5RSURhZUFiRGdZdDJBRnlLeWJvVnovSWIwaTJOT1RnNW9PZXZIVmcz?=
 =?utf-8?Q?PISCoHn8h2wiUZ3UDgWwZTc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <65D4B09B8BBE8F41B837E12F880F7DC3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7655388-8594-49c4-de2a-08dc65666c86
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2024 20:29:36.1362
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DBVkFZQbqWAffvvdjmEQG0oRmD2twd6dEBbjoGBMTAThZ+fW42O+ZVu5XhYOQFhSD/n0Pb39PjvIYzadOaucGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR15MB5727
X-Proofpoint-GUID: hz1V4zteA1vBMy6EeLNR3HGa30qN-LFQ
X-Proofpoint-ORIG-GUID: hz1V4zteA1vBMy6EeLNR3HGa30qN-LFQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-25_20,2024-04-25_01,2023-05-22_02
Message-ID: <20240425202936.lzXBDskCV7LSegb9zoaJlY5wfCveBUoyNXmsFEI8xog@z>

SGkgSmVucywNCg0KPiBPbiBBcHIgMjUsIDIwMjQsIGF0IDE6MDLigK9QTSwgSmVucyBBeGJvZSA8
YXhib2VAa2VybmVsLmRrPiB3cm90ZToNCj4gDQo+IE9uIDQvMjUvMjQgMTo1MSBQTSwgU29uZyBM
aXUgd3JvdGU6DQo+PiBIaSBKZW5zLCANCj4+IA0KPj4gUGxlYXNlIGNvbnNpZGVyIHB1bGxpbmcg
dGhlIGZvbGxvd2luZyBjaGFuZ2VzIGZvciBtZC02LjEwIG9uIHRvcCBvZiB5b3VyDQo+PiBmb3It
Ni4xMC9ibG9jayBicmFuY2guIFRoZXNlIGNoYW5nZXMgY29udGFpbiB2YXJpb3VzIGZpeGVzIGJ5
IFl1IEt1YWksDQo+PiBMaSBOYW4sIGFuZCBGbG9yaWFuLUV3YWxkIE11ZWxsZXIuIA0KPj4gDQo+
PiBQbGVhc2Ugbm90ZSB0aGF0IGNoYW5nZSAibWQ6IEZpeCBvdmVyZmxvdyBpbiBpc19tZGRldl9p
ZGxlIiBjaGFuZ2VzIA0KPj4gZ2VuZGlzay0+c3luY19pbyBmcm9tIGJsa2Rldi5oLiBUaGlzIGlz
IG9ubHkgdXNlZCBieSBtZCwgc28gSSBpbmNsdWRlZCANCj4+IHRoaXMgY2hhbmdlIGluIHRoaXMg
cHVsbCByZXF1ZXN0Lg0KPiANCj4gQSBiaXQgZHViaW91cyB0byBqdXN0IGJ1bXAgdGhlIGNvdW50
cyB0byA2NC1iaXQsIEkgdGhpbmsuIFlvdSBvbmx5IGNhcmUNCj4gYWJvdXQgdGhlIGRpZmZlcmVu
Y2UsIHNvIHJlZ3VsYXIgaW50ZWdlciBtYXRoIHNob3VsZCBzdWZmaWNlLiBJbiBmYWN0DQo+IHlv
dSBvbmx5IGNhcmUgYWJvdXQgdGhlIGRpZmZlcmVuY2UuIEZlZWxzIGxpa2UgYSBiaXQgb2YgYSBs
YXp5IGZpeCB0byBiZQ0KPiBob25lc3QuDQo+IA0KPiBJJ3ZlIHB1bGxlZCB0aGlzLCBidXQgSSB3
b3VsZCBzdHJvbmdseSBzdWdnZXN0IHRvIHJlLXZpc2l0IHRoaXMgY2hhbmdlDQo+IGFuZCBzcGVu
ZCBhIGJpdCBtb3JlIHRpbWUgZ2V0dGluZyB0aGlzIHJpZ2h0LCByYXRoZXIgdGhhbiBqdXN0IGJs
aW5kbHkNCj4gYnVtcGluZyBldmVyeXRoaW5nIHRvIGEgNjQtYml0IHZhbHVlLiBJIGRvbid0IGNh
cmUgYWJvdXQgdGhlIG1kIGJpdHMNCj4gaGVyZSwganVzdCB0aGUgZ2VuZGlzayBzaWRlLg0KDQpU
aGFua3MgZm9yIHRoZSBhZHZpY2UhIFdlIHdpbGwgbG9vayBtb3JlIGludG8gdGhpcyBhbmQgY29t
ZSB1cCB3aXRoIGENCmZvbGxvdy11cCBvciB1cGRhdGUuIA0KDQpTb25nDQogDQoNCg==
