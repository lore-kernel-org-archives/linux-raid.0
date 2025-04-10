Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2138.outbound.protection.outlook.com [40.107.22.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD0B1EB1B7
	for <linux-raid@vger.kernel.org>; Thu, 10 Apr 2025 08:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744275562; cv=fail; b=tNKf+N2wCt4LHgciY7W5Bwgoa6uwa0Uoy9iAmyr6+IjF9AHw9YlVNiusfmsdLUqt2E65c8UiuRIrR8EgIAmGrYDm5nQauclE4Ub4xmzXM2LgoY9i+nK4W0tZk5ooaQ1PKZQCwGM9CeHLt5Q8ajJT+jpkQ1Du+ZrAgIkFhdye11s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744275562; c=relaxed/simple;
	bh=nzcgpvVwUMRMR+7xZAqLloKhZNDGd8whRyAsaX335Iw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=X6K+fPbdRQfd93Ou+PYrJKACmMJr9cowPzmgpyH4ERHb+TyIu8KTH0LaEDLtD6rOm6A5eXPbVxp9YadBVCGSV0Z1o0Kpp/TKM/XWSFw+egphIcPCTuIy8rTFz3aMzudwYqS3gufNQPOkuPRGc5Jju68bxyVIvEX7O9SVjRb/Ql8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=mzXpxllH; arc=fail smtp.client-ip=40.107.22.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="mzXpxllH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EGDmJnkAbTTy1FKKjeHtfyYZ0/SLs9vHy+IFsyyCL0PE1lEYREdrz1Eznl/KgpzQ+qdlLMAj5ijM1/YG6L/+zi3S5Wl8EWcieaTiYPnnOskecq/eDBPpIVHBI3gwQDE5RmewNOYIRyL3cjwuK9OdI4yhkN28iEaxfDRfxZ2K/lAJsGxT4IuFg5EGXj6jc8JXjWfFhdmH5aqtwA5jO6yw8liGKrSu3UfjSU5u5DqQqiiyCCEeSGI7AkdlTRjF9hsJFmrd+BIKOSvfoZ/CxqeZMwBwXRl7BZsQuGJmWIWUWfdYb87t1drND3Bjz4wYVcV10scLlfry0iNCOYpm/ReNmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zRGZUvf65yghC7hTPOkTwmPX837rfV8YxsBc7CVwCqU=;
 b=gw1lZUWLvmSssYYUO3ellKxLHt79LEftddtRsE3jLZzP3J3ZSSbgCH/nvF63+P8vF1PCH15ncYBe+4IvAERsphQztSzKvDerw3QCPjnytoFir3zVF5e8jewztpPgTN978Gl+K5mYjnb8jivOlm5Nq3J4QL6z3RLgzY3c4/C6GbtJ0Sp+WLcP8QS/lZAqnvoamTOdWBFYeAyoyZoEUtLzSyaFlRQnOi7DqF25M2ziteD+D8N2cCKL5fLoOrlP75RIpAm5R+WHDUrb6DYKZfJxvgmVMTbxk8fpigXptu1YRbO7vha2Fd0FD+JXHiAVvGYS96G5FtLhqhwxpEuKZ8u/Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zRGZUvf65yghC7hTPOkTwmPX837rfV8YxsBc7CVwCqU=;
 b=mzXpxllHVhVB55BlOh/yAVTSevBldUkDwDDXQ1sgXDhsR6Nvp6wYHKgO22CEwBX5IONSCiJpR8pJQAY0UZI6HMAU/ZDYoYbDlYdArpAf35AZS0svKewJNM1yA2/Nv9fB7KYckGSwRo5KDrNDmEhKlO5jW0/3OH5RHrq3OqcGVryPjmy2+cc1MTDGz7lcjoI+lvFs4p2XYSCR5lmbJ//5tM1UgMxMVwo8DM9C1QvczCcwHKWbHRmgIWKw8oFQpv1vwiIKS21MYUyNZTkCNHDg6nYtvzcP/XEc5R6A7jsilu54Yxsk75HdwY9tkXvjGBthn0kPRAbcBC7+uAgZP7vldQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from GVXPR04MB9927.eurprd04.prod.outlook.com (2603:10a6:150:118::22)
 by PA1PR04MB10745.eurprd04.prod.outlook.com (2603:10a6:102:489::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.24; Thu, 10 Apr
 2025 08:59:17 +0000
Received: from GVXPR04MB9927.eurprd04.prod.outlook.com
 ([fe80::c944:16d4:ba89:86f8]) by GVXPR04MB9927.eurprd04.prod.outlook.com
 ([fe80::c944:16d4:ba89:86f8%5]) with mapi id 15.20.8606.029; Thu, 10 Apr 2025
 08:59:16 +0000
Message-ID: <0f114488-5233-45c1-a7c2-0bcc6aa6d6ce@volumez.com>
Date: Thu, 10 Apr 2025 11:59:14 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] md/raid1: Add check for missing source disk in
 process_checks()
To: Yu Kuai <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250408143808.1026534-1-meir.elisha@volumez.com>
 <161625c3-8ba5-eb16-7d6d-e5e4cb125d91@huaweicloud.com>
Content-Language: en-US
From: Meir Elisha <meir.elisha@volumez.com>
In-Reply-To: <161625c3-8ba5-eb16-7d6d-e5e4cb125d91@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL0P290CA0014.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:5::8)
 To GVXPR04MB9927.eurprd04.prod.outlook.com (2603:10a6:150:118::22)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR04MB9927:EE_|PA1PR04MB10745:EE_
X-MS-Office365-Filtering-Correlation-Id: 388e7f2f-6c0e-4117-364b-08dd780df919
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M2gwalQxNXVRTWwrdFUxTE1HanRQNmZoQ05rdVVLaUgxVUZKK2UzVGFhWDBM?=
 =?utf-8?B?a21UbTkzSk1HdDBOdjNodExMT3BZWlBRQmlickhuOWMydWlpNEVObXk0a3RQ?=
 =?utf-8?B?eEZkUDZZbTZhanhhVWdzQitHTWxaby9LUFVKUDI5Q0psdFpHVnR0WUVwdGxn?=
 =?utf-8?B?RHZDc1NrT0hFUEdHd2dyc2g3ZW5RQUY1eXhEM3hxYi9WbDRwbFRxQ051Sk4r?=
 =?utf-8?B?Yjk3Z2VIVDJ3RGowQjBlWnlJTUJuZU51RFdqOHdQRVVjUHRkSWt2bzVBcEhm?=
 =?utf-8?B?S0dYMy9wMmRYN3U0dlpOcHZPVS9vVyt0M0hrNXQ5b1drYVVUTktrNVJWN0JG?=
 =?utf-8?B?Uk9GaHYzRUJVakoyYklIZ204MHEvWGg2YVBZUVNRbGtvM2IycytrNGh5OEJW?=
 =?utf-8?B?bGRyKzkvajhZcWhVUnZtUkgva2ZIUmduaDFBTWZXcDhoSTNxejdSU3ljL3lP?=
 =?utf-8?B?d0VnWHFMQVk4STBOVTJiSVJpMC8xYjVoc3hDQVc0Y1FsNVR1OVliOVZ0enpL?=
 =?utf-8?B?bk1xOEJ5MWdrR2JyYWdtRmtTSzg0M2NsVGdPNUxTWTFLd2ZDN3ltcEtWcEZw?=
 =?utf-8?B?T0FrUFhaZ2FRNGNxdEw0ZjNLWW53UVZDcWdCdk80elphcTlhUG1UY1VYYXhC?=
 =?utf-8?B?RzhOYU9ZVkc0alFuU3JjazhyVzFzanVFSUV2NlpuQjhac1JZa0JxbnEyMW1W?=
 =?utf-8?B?bHh2R0U0bnl0OHF2SXRmbmNyZnZ4YjNIVXlWL0c3RmxhSjcyZjBHTVE3SFJa?=
 =?utf-8?B?RURscFZzUm5SS203OVlybVBBZlNRZ3RFMHRZd2Y4UzJHeElNUmIvaXVZZDAw?=
 =?utf-8?B?L3VuNVp6NzlpNnRHWDZrZ2p5VWhwaGxjZy9VMTJvczJwSGpHWk81ZENrOE9y?=
 =?utf-8?B?aENTNFJMSjRPaUY4SG1xMUN3aUVYSVdQWFJkL21naTIzVGFSNXlrY0ZYelJl?=
 =?utf-8?B?SmFXU0V3N0U5NjMxM3VRdEhRVW5nSFdsTmRCWExsSnJybnJYZG80UkljQ29m?=
 =?utf-8?B?b3k0NWdwQlNWSW9rU0JIWjVZNEZjbDdkNi9nS2kxREtvbjVla2Y2dnA3eXJR?=
 =?utf-8?B?Sm9KMElpTDErSFI4ZEppOU5DQnlyQjJZeGVpTTU4dlBtV0hBSkJ1TGxJa3Ez?=
 =?utf-8?B?eERseFR4SDBPS1FrRmxGYmw3UXlFaFAvc2FiL2pSUGkzbjJhcG9Hb2l3V3dw?=
 =?utf-8?B?L1NhdEJnWHJnVjd5Tjk5cjVGT3ZEOUNmcEk1ZnBIMktPNnd0dm5vVTJlejVF?=
 =?utf-8?B?Z01tN3E4anRNMmpRckw4R3RMek03cUZjRXhIN3Irek9sZ2tiaXdCM3d1ZitG?=
 =?utf-8?B?S1VlM1V1OUxnRnBuZWdmRkRCQTAyTjBPcFc4STRLMEVNY3kvdlViTzQ0VEJh?=
 =?utf-8?B?QUd0NXA3a1k1K3NzY3ZMc1JWZFFEd0cwRURSZE85UnRTaElENTROTGVRaHdJ?=
 =?utf-8?B?OVZERldGZVFiUFBJQTZvd1IvS25rdzRMMUs2UlR1QTVYS0xMaCsxcWtmSEMw?=
 =?utf-8?B?NklUa0sySGtURHoyVTJLcVV2cjFLTXljSzZubXJxRm95aTM3Q2pldk8xQ2pN?=
 =?utf-8?B?dnd5OTNqeEIzQkhJc0RSenNIZllOOTN5Y01HN2lhc2JOU2V3VVkvTVViN1h2?=
 =?utf-8?B?NXNST1libHF4R0c2NFpWOERTSFNuZm9yL3FZa2Z3cUt1TzUzTHNwd2FpWmZs?=
 =?utf-8?B?bnFhOTlXclJ3c0dQNnJaUzJHTVlDN05wWDZwaEl0M2Yrd0RFdWJ6U0g3YUFy?=
 =?utf-8?B?c3ByN09aL0xHd2Z6aFF6bHJjODBsWW1JQWRkZWJONmpFVWxxQXh4ZHpzK09K?=
 =?utf-8?B?cm40KzM5WFJ6WDhWYWY2SU12ZXQ3T3lhVUtqL3VxNC9JR3UxTE1kdjd3elVx?=
 =?utf-8?B?SmNaZVNnVlFGRDc5MU4wN0NkVE4vL3hBcXNTdkhYQ2tqNXBsdWluSk5UeThB?=
 =?utf-8?Q?tKNYO+SRY50=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR04MB9927.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VHRMZDFVVGpqNFNpZk02U1lOY2dxZlZ4MmxrL2hGbzBVTUZhUVlmU3RXbnk4?=
 =?utf-8?B?RTJKRk5GbGFHd0l0SENLb2dVUW0rYW1oZmxEc1poU1dLS0xCMm80YzFDUmFF?=
 =?utf-8?B?cCtOTVBYYUhlK1JRZjZja25oUVNiVko1cUlJbmdVUW1NeWt0cWxTUHNiaXNv?=
 =?utf-8?B?T1N3Tk9DWXlKOU91aFpQdEpzRnkveEUvMVBzc1NoRXlsamxkU0hvTm9md1Bl?=
 =?utf-8?B?RzgrSDZtdTZJdld6Zlk0cEc0aDZwU1h6YmJZUStXSldlSUpzYXp6ZzY4NW05?=
 =?utf-8?B?R0tyQ1JwaGVGUXdsNWRMWFJFMVgxUXhaWitVYmxMOHZYZGxaUDZwUFpCS2Zw?=
 =?utf-8?B?aEozM3k4L0F1YUVQbjNRdG1ZVXRwT2FoWUZtRUR1YkdJZzlRN2dYcENOQUtS?=
 =?utf-8?B?dE9lckJ2QVY5aWQydnp6NHJEL1VBQkxQMS9xZ1UxSTNndHFLaXJyZ1hOck53?=
 =?utf-8?B?aE5Hd2RCckVwWWE0dGtoSjdpWmttMExMV3BsK2o4TkxoVHZPUjhvZ3lleGVj?=
 =?utf-8?B?UzV3cDV0YVROLy93YmtMVjMwbTI2WmdyOTRPU3hUbGpaS2tqYVRmRnhUUkhq?=
 =?utf-8?B?WkN6UWlJWkQ4VUNBNmc5RC8rdVpiOGJTMVNHaEZGYU5lZ2pFTFZicmVjRHkz?=
 =?utf-8?B?amRFMVo5TGR2K2VrcmNobnpEbEplYXMzeFVGWmovdEpXT3B4ZVJaWW1xMStO?=
 =?utf-8?B?cG1GSWZmMVlNL1RiQnkzcnJRVnFCc2NZaHU3TTVnTlRKYUZHZkpzMU1LdVEr?=
 =?utf-8?B?VGRwYjg4K3ZnNmNkNXYyN3VEUERNckxJcmdOa3YraTdFYkJQZGp2SEVLTFkv?=
 =?utf-8?B?b1NyQ0xSeFBpY1I4bWU2ck9wdm42MGtJbVBodmlJZSt1V0hiLzZpbk1kazla?=
 =?utf-8?B?MVNsNG9tZnhRWVcxM21FTTZENGxMWFpqM096QXNMeEZvUGNPcVhQL1lyR21j?=
 =?utf-8?B?TCszdXhKYUNHa0Q0Q29GdDdrM2VzOTdnYlJDRnpwV1QxV0FuL2NFRWlocHQ1?=
 =?utf-8?B?azZwRU5hbG9KeC9kazJCZUUvOGNZWTVwZG9kWXlxUnZkcXk2UnFPNlF6YXh3?=
 =?utf-8?B?dzJQaFVKWEthTFI4ZURiL0JDTVFtek9kenY0V2VDYzZHSTFWakpZMDJZVlZx?=
 =?utf-8?B?b3RsWVBDaXNCbzFKWnd4bE1qb1BIRzlzNVduTjdZMVlIakFRbUlRQmMycmpG?=
 =?utf-8?B?WGNQUmFkRjF6Y0hsbmMxVmxQdzJWN2RXdXBtNzZFSEdaNHFNclFPbUUxRzd2?=
 =?utf-8?B?Q1VRVE9VRWlWc1RabHRGUlFVcXlrd0VRWFdTRjM2TkwzdGFLZ3AxSERrSHM3?=
 =?utf-8?B?bWtMWTFiZXFXL25kWHNXRWNyZGZJUm1pQ1Q2L0RDWHRsY2lNM2ZZREh5QWxn?=
 =?utf-8?B?Zm1nbmhjOXIzN3JEMDYrU2JkTEcxMW01d3N1LzlhaE5zM3RoSGY3MEc1NXpC?=
 =?utf-8?B?K3NrSHJ6cG5ZazhEbTEvQ0V1WDJNKy8vTHZxVS9QUWpaTHMvSTBsc01QZ3F4?=
 =?utf-8?B?TVdMdkYrUDZyR1Rib2JvMnNBZ0dHbVlZRGtPWGlPOW45RVZTc3NPN0hKanZz?=
 =?utf-8?B?d1oxQ0pBdWx2TXFlZW1ZNEdpRXlFOUpkL0hJVWgwdGJpdlQxaG9xMUJkdmIr?=
 =?utf-8?B?TU1kZGJ0SXNHbXg3bkc3Q0cwMFVTdFRUd29NTVNzeStBbGwzV0padytkMGx1?=
 =?utf-8?B?VTJOVjFPYzdWY1pvb25XYno3WWx4bGRhY1lJZDhpeHZhdUtwZSszUTNmcmw2?=
 =?utf-8?B?Z3FRMmFIUkJyUG1VNlZ2NDJoSTNBalVpN0Y5a3U5QWRZeHYrUHU0UnlQSksv?=
 =?utf-8?B?d1BucHlOYlhUTHJYMklKQmR0NityelNCdDMrNEVVcHZqWW9ZT1dQTDlyQWhh?=
 =?utf-8?B?ZVFjL2lLSUdQanRQVVYrVmRXMDZ0V3dZdlVzTWg4TG1oKzYyT0FFcmViaGJV?=
 =?utf-8?B?QmFONlEvb0pSWnoydDRSVEJOeXcrRjI4OHR3OGNZeFZiU29TS0dvVmRjS3h5?=
 =?utf-8?B?MytKdmRSOXNZU1lQUUtMTHlwSlBOZ3A2NWI5eVFuZ3lGc2k4Zk9CT1U4eVlB?=
 =?utf-8?B?czh2WnJhRi9pcmUzaFl4NitKNkR0a25Vcy9Iamt1TndwL0hQMG5lZ2VzSWpx?=
 =?utf-8?B?Q1RhUndmallxUk1XWUtRTjEydk94eXNkLzZ5cEJFcEk2RGVEdjdOUnNHZUhR?=
 =?utf-8?B?NHc9PQ==?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 388e7f2f-6c0e-4117-364b-08dd780df919
X-MS-Exchange-CrossTenant-AuthSource: GVXPR04MB9927.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 08:59:16.7645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d/a3KPMC0OKBsjTBlDyXrRWweEsisBRWyh/Be4nbRlKNwn+imCYCtIzYpANrd7eLw2V4YlV7/nIxoM8FmX6ziw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA1PR04MB10745

Hi,

On 10/04/2025 10:15, Yu Kuai wrote:
> Hi,
> 
> 在 2025/04/08 22:38, Meir Elisha 写道:
>> During recovery/check operations, the process_checks function loops
>> through available disks to find a 'primary' source with successfully
>> read data.
>>
>> If no suitable source disk is found after checking all possibilities,
>> the 'primary' index will reach conf->raid_disks * 2. Add an explicit
>> check for this condition after the loop. If no source disk was found,
>> print an error message and return early to prevent further processing
>> without a valid primary source.
>>
>> Signed-off-by: Meir Elisha <meir.elisha@volumez.com>
>> ---
> 
> Just to be sure, do you tested this version?
> 
> Thanks,
> Kuai

I wasn't able to reproduce the crash when using this patch.
 
>> Changes from v1:
>>     - Don't fix read errors on recovery/check
>>
>> This was observed when forcefully disconnecting all iSCSI devices backing
>> a RAID1 array(using --failfast flag) during a check operation, causing
>> all reads within process_checks to fail. The resulting kernel oops shows:
>>
>>    BUG: kernel NULL pointer dereference, address: 0000000000000040
>>    RIP: 0010:process_checks+0x25e/0x5e0 [raid1]
>>    Code: ... <4c> 8b 53 40 ... // mov r10,[rbx+0x40]
>>    Call Trace:
>>     process_checks
>>     sync_request_write
>>     raid1d
>>     md_thread
>>     kthread
>>     ret_from_fork
>>
>>   drivers/md/raid1.c | 26 ++++++++++++++++----------
>>   1 file changed, 16 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 0efc03cea24e..de9bccbe7337 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -2200,14 +2200,9 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
>>                   if (!rdev_set_badblocks(rdev, sect, s, 0))
>>                       abort = 1;
>>               }
>> -            if (abort) {
>> -                conf->recovery_disabled =
>> -                    mddev->recovery_disabled;
>> -                set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>> -                md_done_sync(mddev, r1_bio->sectors, 0);
>> -                put_buf(r1_bio);
>> +            if (abort)
>>                   return 0;
>> -            }
>> +
>>               /* Try next page */
>>               sectors -= s;
>>               sect += s;
>> @@ -2346,10 +2341,21 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
>>       int disks = conf->raid_disks * 2;
>>       struct bio *wbio;
>>   -    if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
>> -        /* ouch - failed to read all of that. */
>> -        if (!fix_sync_read_error(r1_bio))
>> +    if (!test_bit(R1BIO_Uptodate, &r1_bio->state)) {
>> +        /*
>> +         * ouch - failed to read all of that.
>> +         * No need to fix read error for check/repair
>> +         * because all member disks are read.
>> +         */
>> +        if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) ||
>> +            !fix_sync_read_error(r1_bio)) {
>> +            conf->recovery_disabled = mddev->recovery_disabled;
>> +            set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>> +            md_done_sync(mddev, r1_bio->sectors, 0);
>> +            put_buf(r1_bio);
>>               return;
>> +        }
>> +    }
>>         if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
>>           process_checks(r1_bio);
>>
> 
