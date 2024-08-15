Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03olkn2106.outbound.protection.outlook.com [40.92.59.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA9016BE09
	for <linux-raid@vger.kernel.org>; Thu, 15 Aug 2024 05:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.59.106
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723700346; cv=fail; b=NPIp/J5XXIWpIEL2fN5WmGQ4aqgGWZwM3qKOEKCI+JE+WShEK2Moy/DwbX+58PueEaXPsn8csexUtEkNRRqn/Z60WR3E/wFCnhYN5oNZ+++EQbGTXF+G38DKZbdSDEfXx2C/7TNt5DGZe+q3aiq011pTv8vSpLHs4DjRvEewhhE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723700346; c=relaxed/simple;
	bh=wymV7F3j7SuPQGTK/6KcWT7F2r3eQUpxDi0GdxpDNKo=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NeAKm4U9xcH+qlbqfd+CPjtsNbfFhXuwEBNRR6m2OGzCNPbaKD1NkArFlFCB7cDCNwyQK9rQ+GbYvdPytIeFmTlOe+T0LNmIKF2kKZup8/cr0rQVzImIIogVGE1SLc4aFs+hbq8LUg+E15g1VINMdE9GhO6gQNwI90iKdlqCfTI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.at; spf=pass smtp.mailfrom=outlook.at; dkim=pass (2048-bit key) header.d=OUTLOOK.AT header.i=@OUTLOOK.AT header.b=GixCr3b/; arc=fail smtp.client-ip=40.92.59.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=OUTLOOK.AT header.i=@OUTLOOK.AT header.b="GixCr3b/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UiaO2YUwvH7r8hdwTlIygSmMpb6qjT5KBKReE/NUY/qk9Ej3uZuVaS8x1myNgrkq0t7KhpI/uYp6sBoyXeT6GtpE0XIRMSy0JQThzi5bzgTCsUS8fZ2eVjDCwRbDPKZ5q9fHSG+Yr00PjLF/55qw2b1mnc2HisCHnoNb/+mQ7AvlJiCBy2Mg6Hcvy8GJ3WPi/TvY70zIzoX5yhJ/0Zizx6KddeJht6uMA2wjTDxzYWh1Rid5nRXiNNCpAC+K3p2i9AwF0HLy4x41WgU7ZUxv8np/9bdVT6bLVVcym4T7etUDYPqO4nTtnelKmg9gcAmOoDeEqSHFynCaqyzf7R9U7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7rk2pSAUvLGm5dKN+Ze/1DO545AX914AVv58dZmbvVs=;
 b=DmngcsnrdJV92PSrSt2BHP6KZuELZqcjPWx+oMQjg2llHbYdpZRuFX+Yp6Em3dAAub8hoOUnaV3eBXoThyzN33cE8q0oEHdW0DdHlieW/G8tUuCDh568afUxWxlfhqzMpA1lI7+GRx1dIBJGcpo1b/+nl71eCUWFlRb6P0S2jaZziZz6O6HtnQqCrrko91zrlw3E8OnExt2N1kxo//WOzh5PhxUy6NarB4hr2QqniKExcI2+MJi1In4bXCDYPzXQ5OJCG05SEhuYO4dhvg5RBUIX2/zekm3s21HCFr5JeX7oreSeINzjYYaPdhszJSMek+2kT2WqHubD8Ho/k+eLWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=OUTLOOK.AT;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7rk2pSAUvLGm5dKN+Ze/1DO545AX914AVv58dZmbvVs=;
 b=GixCr3b/wes5mC8DwrIlsEl0bMp8hItqFZTfDbm908+i3C+eOjhSlt2c22+hODjir7+NdiiR+LD1fqAm9rOYQSHWdFFtgQHYhKTtIEMndShyu3T0sxwldLH4WJRwEdEa+aZ/VYWcbAYGb4aDU2bS8jph/Qoopez0B9Ms7DaZ+ZlwNXJma3BejZ00y/gns73I2SJMiEksjLizjXZGOk/gv3m8O/Dsh+2sJhXZbgupDujm9KiLXsl6K6voJdCJ/R4aQAp8c1kIw7eQykSfJJS3hZiH5ogNwv5newqLUbp9DqzUq6+HfUfs+L5bYFWO0k5eDMU+Jc7uaBc9snaBStm2cQ==
Received: from AS2PR03MB9932.eurprd03.prod.outlook.com (2603:10a6:20b:640::9)
 by PA4PR03MB7328.eurprd03.prod.outlook.com (2603:10a6:102:109::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Thu, 15 Aug
 2024 05:39:01 +0000
Received: from AS2PR03MB9932.eurprd03.prod.outlook.com
 ([fe80::62a:d77a:b8ec:8ab]) by AS2PR03MB9932.eurprd03.prod.outlook.com
 ([fe80::62a:d77a:b8ec:8ab%4]) with mapi id 15.20.7849.021; Thu, 15 Aug 2024
 05:39:01 +0000
Message-ID:
 <AS2PR03MB993231A87C17935B96DEF3B283802@AS2PR03MB9932.eurprd03.prod.outlook.com>
Date: Thu, 15 Aug 2024 07:39:04 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: RAID5 Recovery - superblock lost after reboot
To: Pascal Hambourg <pascal@plouf.fr.eu.org>, linux-raid@vger.kernel.org
References: <AS2PR03MB99323D8FD38A563E4D7DE14F83872@AS2PR03MB9932.eurprd03.prod.outlook.com>
 <5419d297-ed97-455c-bee8-969b0d70de27@plouf.fr.eu.org>
From: David Alexander Geister <david.geister@outlook.at>
In-Reply-To: <5419d297-ed97-455c-bee8-969b0d70de27@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TMN: [lDlksXvB5/UUBwQrwmn/8HcPhewrPTIf]
X-ClientProxiedBy: VI1PR02CA0068.eurprd02.prod.outlook.com
 (2603:10a6:802:14::39) To AS2PR03MB9932.eurprd03.prod.outlook.com
 (2603:10a6:20b:640::9)
X-Microsoft-Original-Message-ID:
 <06f1469d-5c48-4b61-ad77-2b814bc9f0b6@outlook.at>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2PR03MB9932:EE_|PA4PR03MB7328:EE_
X-MS-Office365-Filtering-Correlation-Id: aa52a385-1209-4e90-e8a9-08dcbcec913f
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199028|20110799003|19110799003|5072599009|8060799006|15080799003|440099028|3412199025;
X-Microsoft-Antispam-Message-Info:
	t/nfDyFxet45yy+A/4lDZwRXFQCIJZMi1yNgF/0gumiLm/rvN60FdFCXdkeoRbvuAEn8cyUtkcQaFl19w/2oPym8FIaifgoLlWlItY212nblI3HAwaEBUVJlIqE75sNL94WJBrBYZyZ0E4Wfaxrzh7I1yed8OQMjHyqkzbmY5znWix9BGij5u8asQu2sj18j2cXj/P0udNUGMsDVB4c+mlGsfzPs2FRZO3FroCdJtG7zd5jph66v+ryIqCIHoz5nFf3ETqY4EFo48QlbTeCTlD30XffVdy+tWVRFWP8twNckxs9cgKj3Iqd8iex8ZNvnyOkajpDfP78Xj7My2mB7ODQPMYMqkakpWe5gx5Q3edp5S6bOyOVS7RT7u1jDIj4nEAACABDTkvJo9Jp5XixxXWkxxvtqsOxambqtdBL5wUh8nsJlm5/RhVeRCZWKqnluspuAY9W/MdoW++tNas0MFE9RBGo5fnFCEILoPayvteXIRCvsB7akMZAMcd8MU8ED/1njNYsubb9rS2kyaGNSYnUJvM3Zx3X/fATPv5jznXB6OOsklaXk0GVIP5692DbA/vl5u061vY+SnfkQDAmUQq0Y4GDMWfPJkVRH9ntdgCmmRdnV9ITaSgVXzvZD1AhFF+ZpNeWclZoaPcvw1iIMyqI6DWTi8LgDZrcVLwul7S4hSWOirHCtW5YX0Xmi5eiDGYPQOGqOLsaTVXZTyl9EMkMVcRsi8cL1KNqJOpwxnZ/dNzI2kStHYxB4qSDUQ/pE
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VUtoby9hczlCL2ZQUjhaK1R1N0JoWXN2bUY2bnZEN01QOWFVSmFxWXpGMllT?=
 =?utf-8?B?T3VkcUh1eHBuaHJDcUdyc3JrdEZoUXhiSDR1WXJFRmtsUjRlR0kyNWdQelZu?=
 =?utf-8?B?YXZjZjMrMVFyNzdVTGF1RGM1Vys5eVhRQThwdFhqd2VJY2NNSHlNOFJ0NzFM?=
 =?utf-8?B?SjdLdG4yZHljeFgxYWVCN3h3NkJKVlNya295TzB4M0ZoNUl0UFBvNHhSSDlC?=
 =?utf-8?B?M05pVjd3SVZkSUZPMUE0UUEza3VBbStaaThyQjluQTFURkViVDlHRVZDNklp?=
 =?utf-8?B?YzBYQUFWeUp1dXRhMGhQb0wwU0RwTXpOWG5YaUZqZWZVNnhCYVVUemk2V0lD?=
 =?utf-8?B?bG4rMlltZkpzZ2NPYjJTNWR6cCtUTk02K3VPN3ZwNUluckRjd1F3blBlaFp4?=
 =?utf-8?B?c01GUVlXZGV6YnhHNEF1TWxwblpMYTJJeFVaS0lIZFFOazRYTDlCNnRrcjNQ?=
 =?utf-8?B?NEFRY240SnpwcmFPWmlaTEJEaFRVak9YU2F1MWsxV0lZZktaTzQySmxiY2Nv?=
 =?utf-8?B?Zm9mbGtkakNUcy8wck5tS2s3VkNqbk9yVDA2SUg4clZBRWtocDgrZitmTkRy?=
 =?utf-8?B?V0pzVEg2U0t2SmZaVmUzdUprR0hENk5ZRDV5WXBYN3BwTFZSb0JPN0tNTDBZ?=
 =?utf-8?B?L3FJbGVTNVJVVDc3dUp0VUFGaWVDYlFXTW5HZmNUcHFTZTJTTHkyNUphbGU0?=
 =?utf-8?B?aHJ3SUQybU8yZ0VQajVza29lU3orZTZBQnRqVEYzd05XME5JVnpreGF5Q1cy?=
 =?utf-8?B?STA2RzNjSGJhaG5JMUdaWW1mdHB4cHFLSXFBWmxrSWRMQlE3RGNjWkcyTjhl?=
 =?utf-8?B?UTE2NTNCRURBMVMxQjliMFZMVmpaZ2RDU0xzV2p2THhhZmVaRS9lQXhUajk1?=
 =?utf-8?B?REgzSHBMbGdOUUttOXh2WWtWUU8yQ2ZpVFJnRGIxOS9hU29ibXNSNmlBWHlT?=
 =?utf-8?B?OWljRFNnZU1VaUtwa0FCMWd6b3RsdDRqWXREWUxpSHA3cXJhZVkyVnFNOGds?=
 =?utf-8?B?YXdSaS9qV3lmb1lyR2RMRnh3aDQxeG1FaEJwS2NZc0xXZXpjZ3dSVFlLRE5q?=
 =?utf-8?B?WVVxdDFVV3cvY1dXVWtGTjlYMkR3bTJscmtsMDd1aVkvcEJLNmp6UHhydlpI?=
 =?utf-8?B?M3dKS3VNbjlmSnhCY3pkSmRnclFDYmkvUmxYQ0lXVnZLZmZrVTk1NS9vZDk5?=
 =?utf-8?B?MFlEcWFnbnNqbW1iMjVLb0E3L2xEeEJjTE5wUE5WTm1xR1JuSkx4UTMvaTND?=
 =?utf-8?B?amMwWUhzRTFBZ0RNTnZ3Nnl5SEI2aTdaYmNTWERjc1ZnSGxjRFdnOFhWTnBX?=
 =?utf-8?B?dFpxZkNRRWo4cUM1MTJ3SWpJV2tRQnIzd1NxRUNaSGdIRlUrT3FRRStma051?=
 =?utf-8?B?ZkRBK2t6M29UZENDSUkvak5OQlFCZ2dRdXNpRHd3RkhqWUJFTDc5cTIzSHF1?=
 =?utf-8?B?TFR0MmxPb01TOVRaNXM5Mlo2MGpnNjVndm5XQUZSVGdzM3cyTUtORDZ5aHU0?=
 =?utf-8?B?NDh0WEM5ZlYyLzJzSXdhTEhieS9pTDB6aUFIZGo2K1lLeGZ5K2FydmJWRFI0?=
 =?utf-8?B?cS9WeVhVRDlMaW5TTlp0K0hoaWd0bUNlMUhFbjNJTGhwdU1pQm44NVZHcWtK?=
 =?utf-8?B?b2RxeXd0cEFaeEFkRVVlT0ppejJiNXRONlJnV2VhNEdzeGlQUnBReEZMWXRo?=
 =?utf-8?B?MlZvbVo3S09NZ1M1bmFHbXFjQXpVQnBsS1g0bDFhcW9QZTBxd3FBYUJBPT0=?=
X-OriginatorOrg: sct-15-20-7762-17-msonline-outlook-fa1c0.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: aa52a385-1209-4e90-e8a9-08dcbcec913f
X-MS-Exchange-CrossTenant-AuthSource: AS2PR03MB9932.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 05:39:01.6407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB7328

 > What were the commands ?

I created the array with: sudo mdadm --create --verbose /dev/md0 
--level=5 --raid-devices=3 /dev/sda /dev/sdb /dev/sdc
As far as I know this used the default chunk size. I checked the status 
with: cat /proc/mdstat
After the array has been created I formated it with:  sudo mkfs.ext4 -F 
/dev/md0
I saved the configuration with: sudo mdadm --detail --scan | sudo tee -a 
/etc/mdadm.conf
I created the mountpoint: sudo mkdir -p /mnt/raid
I mounted it: sudo mount /dev/md0 /mnt/raid
Updated the fstab for automount: echo '/dev/md0 /mnt/raid ext4 defaults 
0 0' | sudo tee -a /etc/fstab

 > It looks like the disk has a GPT partition table. Is this expected ?
 > If not, it could be another instance of unintended GPT "recovery", 
and a reason against using unpartitionned disks.

Yes I choose GPT intentional as each of the HDDs exceed 2TB but they did 
loose the "Linux RAID" Flag after the reboot.

 > What is the output of

 > wipefs /dev/sda
 > wipefs /dev/sdb
 > wipefs /dev/sdc

DEVICE OFFSET        TYPE UUID LABEL
sda    0x200         gpt
sda    0x74702555e00 gpt
sda    0x1fe         PMBR

DEVICE OFFSET        TYPE UUID LABEL
sdb    0x200         gpt
sdb    0x74702555e00 gpt
sdb    0x1fe         PMBR

DEVICE OFFSET        TYPE UUID LABEL
sdc    0x200         gpt
sdc    0x74702555e00 gpt
sdc    0x1fe         PMBR

