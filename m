Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05olkn2022.outbound.protection.outlook.com [40.92.91.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49F31BD514
	for <linux-raid@vger.kernel.org>; Wed, 14 Aug 2024 19:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.91.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723662573; cv=fail; b=tXw6UkiGMwmVijnhK5JhV3AjwHjVnQz/RFChunUBBhaggq2Azkkb/lbFveY1gAzBmdAecvBq69zJYmIIAdQBg91ZhmowkO6CeGj1q3vvMakGtia4xfI181AYEIH5UmU6VRcW76lfsMG4bbmUJ2345M/wHyTj3GbXrspTKWowOgs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723662573; c=relaxed/simple;
	bh=umKHHZACsl3r4B2T7+Vfz+mUzZk+JBJfcZrIojycBio=;
	h=Message-ID:Date:To:From:Subject:Content-Type:MIME-Version; b=mT+KizpQWua83KCJvv4tklK7f5IYJb1uotyuML8RVhxzdAzIKTmQbREPIhmfQaPpI65QgcugxcQGSCpL9qnxVVTe717AtzPDFbjKtCcLyOK7J3T0euvq3yUYz0r0ZtF+7FAKb1qcqLBEB/pu2+XFC9sAP+yV1EYDXQ92xeINh0k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.at; spf=pass smtp.mailfrom=outlook.at; dkim=pass (2048-bit key) header.d=OUTLOOK.AT header.i=@OUTLOOK.AT header.b=EV33bsAi; arc=fail smtp.client-ip=40.92.91.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=OUTLOOK.AT header.i=@OUTLOOK.AT header.b="EV33bsAi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xz1XOfw/wBVqeSg95Ji+LklV5P2WuQcrfq0uGfskNIwU4q3M7Tj1nXZv9ssfeapZXVg2Ba4R2sDznS5PTLGR2pt/KKkrlZ1KSUZLt4pC+Am56MetuHuuuP0drMeRQkl/jwYAcLtNz0mhqwpEC+45CMAe5543ZoXCjbYv8LkFUQqj4c11qlFCOVMsoYzWtPw2pchcaR6iwqaTARJuX3hkxgpoHsCosTn+dvT4Z0DIE7tznkf/CU0WrUvKgrpcxs0Oxrqjdo6Y8gklddv9Fapx0jLQkWj0/W55ObOlATlbNW1gcXum2pZcTuPjMQIEOjpNYO9N0zI6OSDqGGP5WKO6Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qhy3WU3y4RzpowS08q1uP5ZJLg9bbjldErNrcCEoaWg=;
 b=oEJVpQ102/4D2c28V7vWvrk1YNxcLy0rU/JDH4du7/goNqaXL8JOoPLBT21pbRfTIobdZYUFMhDj0ff4/WtiJ2LhYOnToBilEY718JPfQnSi3NVzE4a0PZqwRKUTbpywnpoa8HxTNXOT4hJoHasRwQoYRyb6wjU8NxCRt2DVy2eGTLE+1HOd75VnrJqn46VBDE7KiVsMtLxnueDqXxVLYGltHXonF6Mr1l2p4g+v8kdfgPISfvvyjiUUbrjAYNOHX528lv1hrukjU6/BT2QgcCKZyli8GvZ0XGafqaZ8rqBUU/FWb7hdd/nqpL7AD7PbEX4AnxmZ2aNnMltj09ptiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=OUTLOOK.AT;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qhy3WU3y4RzpowS08q1uP5ZJLg9bbjldErNrcCEoaWg=;
 b=EV33bsAiPf8apbvKxo9CbFXaCckBYXQy103p1N/+FFcT910NvGRNgMgtfOvitj9cPsHQkY77la8X8yZ32QmF6SL2DsoDmpR+i67Ez9rgn9EvMOip7mB6Qd3JLlCNbq0QyounWqs32n/IfJ1PhnER+m6J+trKdFc6hhh9EswFlNmLxRYvmiDD4wrP+4E/MQr8+In57vaqnUkHOePp1i2YCEtt/X0cEn5VTZ8g67hyUl6+WSFDCwkuTyFdh9fUs4dzT9hGNaybEZSv+mrPovIvZeNG1/4VVnCiO5dyscGssohTi7m6sMCUzomfDta0OPUQ3OF3oKAUHn2UzA26GjBXAg==
Received: from AS2PR03MB9932.eurprd03.prod.outlook.com (2603:10a6:20b:640::9)
 by PAVPR03MB9187.eurprd03.prod.outlook.com (2603:10a6:102:325::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.16; Wed, 14 Aug
 2024 19:09:27 +0000
Received: from AS2PR03MB9932.eurprd03.prod.outlook.com
 ([fe80::62a:d77a:b8ec:8ab]) by AS2PR03MB9932.eurprd03.prod.outlook.com
 ([fe80::62a:d77a:b8ec:8ab%4]) with mapi id 15.20.7849.021; Wed, 14 Aug 2024
 19:09:27 +0000
Message-ID:
 <AS2PR03MB99323D8FD38A563E4D7DE14F83872@AS2PR03MB9932.eurprd03.prod.outlook.com>
Date: Wed, 14 Aug 2024 21:09:28 +0200
User-Agent: Mozilla Thunderbird
To: linux-raid@vger.kernel.org
From: David Alexander Geister <david.geister@outlook.at>
Subject: RAID5 Recovery - superblock lost after reboot
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TMN: [h9Rd+nOQhzTiwZ33fPLRMsUDqvfR458P]
X-ClientProxiedBy: FR2P281CA0140.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::8) To AS2PR03MB9932.eurprd03.prod.outlook.com
 (2603:10a6:20b:640::9)
X-Microsoft-Original-Message-ID:
 <4577fb54-0cc0-416d-b6b6-054412f34fc5@outlook.at>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2PR03MB9932:EE_|PAVPR03MB9187:EE_
X-MS-Office365-Filtering-Correlation-Id: 145de0d2-8288-4310-45ea-08dcbc949df0
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199028|20110799003|15080799003|19110799003|8060799006|5072599009|440099028|3412199025;
X-Microsoft-Antispam-Message-Info:
	7URwulKz7RicNNHA/XI6Fu5A0HI/vMlWXWE+YDzR2B7ApOVYSLJKtirAgBmc3IShxxm+tN9FajnXxi+ak8EebktJY4Yv1kFvI9II1ANnx+rxP2rcDU/By0mdgyVdq2QIwVyKDqyp4JEvQRLkEM02N0m2/zNcHDW+7p7j17CVAMKA53d8xOz83L4BBjLxzDhSpYnj29paHOb8IAue+ADYSI1c31aQ7HxqYldofS5adMA0cuQO5pEWyi1eD35BoVxTC1h57zcfhY7DlbILmiBjTcSUlqCYbt6Ndxd7yEiogcmdwVrB2wTooLzyBzrgclgIFAonNy2XDEGCbMQ0BaQlE28sFPrwLhFLio1d6V/LFyHUjb5P8dCt+cvZciqdGjtsTVuRdCrVPhPQHCLouAZnGLxvkXYfgVaZ22x6FtNyiqBoD93+fmSYGpERI9htwQyZRrqUwET2T8mNXvlhv51ROxHZB9ZH7f8MXYbKV3zMHUrja5tIUu5MV5dPRIrUil4b/mK4gTGXXOomt6U6BqSg9Wlrjc1ODShqU8sMxXhQu8TK1SINEOVP2nwdOkluJAD0I70yTDdjtwewHTKyL5G9CTzO1Of7h5r3T5xioMnA204ARpxD1stTXmsmDpgTUiF/nQM697FUzwCOgbP2H3Y4Hc3FqDkaShKyOzUVfZXErk1UyabVUm+5v4dWQDm4cyrPs13FkLru/kPow/QEdzyXm56lgvFGcIogz7/0gcEEa9C143AVEng37d89GPXtfRmp
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YXQwOC9sMWlWRHd5NHh2OXorUlIrYXFHbmZKUDZFR3g5MHFQQXB6bk1ycE15?=
 =?utf-8?B?VUYwampjb2dudmxHdkpEeS9FRkU5ajFWblNIbitrTWE5TS9GeEFDdU4vZS8r?=
 =?utf-8?B?alJhcWRRU25BeFV2dkZBeUhXOUY0QklkV1AyUFZPRDBTVmU5VVh4TDFIS1M2?=
 =?utf-8?B?Skc3bml4Z0JjbWtmeExwVTF0MmdRQzNtNVBxZTh4YmtGeVZzb3VBVTErYnV4?=
 =?utf-8?B?ZHZpQVJyRU5IcFdEb2NEdHpWaStMZDNMTlZWa2U0VHU2QmpuTXRGMnc3UFho?=
 =?utf-8?B?cUpEUHRKU1IyMEo2Q0RiRGRFWDhodmxXME95NDFxYldVdm9uOG4zZXgzUCsz?=
 =?utf-8?B?cWd3eUZoUmE2UEJYa1czR1JaWThsSWJDSXdzUFdLUXpOaEN2TUFFTjY2WnNN?=
 =?utf-8?B?VUZmVkpGdzVDTkZDcU5kSGlHaG5udDJURTlWa0hyZ3k0bzNraHY5Q0tyRkh6?=
 =?utf-8?B?aVpWM1VnTlJhUDJwQjhZYTNHd1psVWFVNnlSMjk2WlVTOTNqdE4ybllBcmJ1?=
 =?utf-8?B?QUFLbzRNaytVSGRuT1FZMEx3Ny9EWTBycDhoRzJBaTk1OXc3QmxqVjBqY2Uv?=
 =?utf-8?B?cE5Ya3F5V1kyTFNyRXM5akdaejBxOEZkN21CSXZtVm1IZloycVVLOEFXT2Nk?=
 =?utf-8?B?eFFXRWp2SzZSY24vMHlERFYvWW56dEpUNXdwSi91MFRrdVdHQXV1YVBEV2x1?=
 =?utf-8?B?empKZzRGd2xaaGM3cGh2YTlYbUZ4NDZybzVWQ2VnMTNHTk9HeHVlaFF3bVZI?=
 =?utf-8?B?SXh3eVlybzFNR3JBaCtRdnI1dDFkTGUyN3FOZzI2SFNmcStvZGdPYStnV0FT?=
 =?utf-8?B?dTZmZ3NabXNRUVhFT05LWmJ3ZGxWSWV6TW9seWtzd1ZKRHh6OFpVSmVXWVVQ?=
 =?utf-8?B?dVlWK2dNcFQxYUEvSFBTYW9ZTTVxc1duUm50Zk1lWXlqVTBwenVPZ1RIS3Fq?=
 =?utf-8?B?UHc3TC8zczNtTlZGblVNYnAyRFpBbytRL0c3NGRuMDU0SXg4bTgzYk5BNEdS?=
 =?utf-8?B?aHFRUktPeEZrQjVZU3NvVzZucm1ZcTh1S0k3VDJPOGlnTnhna1FuOE5MOG1L?=
 =?utf-8?B?a3pQZmZJdFI4NjB5ZWdYdXYzbTdLYTBKck45TEszRnZmYWtiVFdyNVdQb2g2?=
 =?utf-8?B?bzRFRFRIVDhveENLb2dHdHg2WEhNV2sxTElOZjlFTlZ5KzlpYXk3MkE0UG45?=
 =?utf-8?B?Z1FyNmVjeFYvUko3eS80bEZNLzFIaWxIUGxaMzFKdHRYNXRYNytBSnBtU1lM?=
 =?utf-8?B?YUtsVVpKQzZnaWxLeXFpaE1QcmRRMVJJK2s3ZW1YRk83U29FTEFQSi8yeGMy?=
 =?utf-8?B?Y0d0RVM2L2oycjZVcFBIMW16amtOT0J6ZWtrNkoxTUJnOHB4Wmx3enJMK1dR?=
 =?utf-8?B?bEJQYkNYSktuYmE4L0twUFU5VkRFWVlGaEdkbm9kOHhtRld2N2dxeTZqbnBx?=
 =?utf-8?B?bllaQXhqaDJqZ0E3RTFPcnl4OWh2a3F5UkRjSE1QTDJGMGM0ZGtkQ2xIMUMz?=
 =?utf-8?B?TlRwYVRVcXIyemFlWWJXZFF4cDU5RmxHMjIwd2lYdjZJVzE0S1RIS295TEYv?=
 =?utf-8?B?c0JpQWFONkV1czRmTXc4WmJEYnJ3TzNscVBDMWpObCt5NDZ4bWlXb2JqKzVz?=
 =?utf-8?B?ZDdKRk1pcjlEQXJBeVNWbGcxWENLaVNzeFJQcGYwVFN6RXA2dk5JdW9vUU8y?=
 =?utf-8?B?TGNBZjhkOHVldmhya2FNUEJBdmlsT2cwa1hjRFBxelhlZ2RrUWRCM2pRPT0=?=
X-OriginatorOrg: sct-15-20-7762-17-msonline-outlook-fa1c0.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 145de0d2-8288-4310-45ea-08dcbc949df0
X-MS-Exchange-CrossTenant-AuthSource: AS2PR03MB9932.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 19:09:27.3969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR03MB9187

Dear people on the mailing list,

Disclaimer: this is my first time reaching out to a mailing list and if 
I broke any rules on doing so please let me know. I read the guides as 
best as I could but I'm just a human.

I need help with the recovery of a RAID5, that lost the superblock after 
a reboot. I have read the articles about "RAID_Recovery" and "Recovering 
a failed software RAID" on the kernel wiki and follow the advice given 
there, to write you before attempting a recreation of the array.
I have to confess, the second article is multiple km out of my comfort 
zone and understanding how this works. As it is labeld with "This page 
is obsolete" I did not put multiple hours into the research of 
"parallel". Please correct me if this was/is a mistake.

I'm not 100% sure but I did save a copy of the commands from the time I 
created the raid. Am I correct, that  recreating the array is my last hope?

Kind regards,
Dave

### Logs ###
--- sudo mdadm --examine /dev/sd[a-c] | egrep 'Event|/dev/sd' ---
/dev/sda:
/dev/sdb:
/dev/sdc:

--- sudo dmesg ---
[    3.540074] scsi 2:0:0:0: Direct-Access     ATA      WDC WD8003FFBX-6 
0A83 PQ: 0 ANSI: 5
[    3.540427] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    3.540540] sd 2:0:0:0: [sda] 15628053168 512-byte logical blocks: 
(8.00 TB/7.28 TiB)
[    3.540544] sd 2:0:0:0: [sda] 4096-byte physical blocks
[    3.540563] sd 2:0:0:0: [sda] Write Protect is off
[    3.540567] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.540602] sd 2:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    3.540606] scsi 3:0:0:0: Direct-Access     ATA      WDC WD8003FFBX-6 
0A83 PQ: 0 ANSI: 5
[    3.540640] sd 2:0:0:0: [sda] Preferred minimum I/O size 4096 bytes
[    3.540994] sd 3:0:0:0: Attached scsi generic sg1 type 0
[    3.541038] sd 3:0:0:0: [sdb] 15628053168 512-byte logical blocks: 
(8.00 TB/7.28 TiB)
[    3.541042] sd 3:0:0:0: [sdb] 4096-byte physical blocks
[    3.541078] sd 3:0:0:0: [sdb] Write Protect is off
[    3.541084] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.541109] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    3.541132] sd 3:0:0:0: [sdb] Preferred minimum I/O size 4096 bytes
[    3.543813] ata10.00: configured for UDMA/133
[    3.549042] scsi 5:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GH50N    
B103 PQ: 0 ANSI: 5
[    3.581434]  sdb:
[    3.581481] sd 3:0:0:0: [sdb] Attached SCSI removable disk
[    3.586773]  sda:
[    3.586813] sd 2:0:0:0: [sda] Attached SCSI removable disk
[    3.589970] sr 5:0:0:0: [sr0] scsi3-mmc drive: 48x/48x writer dvd-ram 
cd/rw xa/form2 cdda tray
[    3.589973] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.608265] sr 5:0:0:0: Attached scsi CD-ROM sr0
[    3.608464] sr 5:0:0:0: Attached scsi generic sg2 type 5
[    3.608664] scsi 9:0:0:0: Direct-Access     ATA      WDC WD8003FFBX-6 
0A83 PQ: 0 ANSI: 5
[    3.609032] sd 9:0:0:0: Attached scsi generic sg3 type 0
[    3.609096] sd 9:0:0:0: [sdc] 15628053168 512-byte logical blocks: 
(8.00 TB/7.28 TiB)
[    3.609102] sd 9:0:0:0: [sdc] 4096-byte physical blocks
[    3.609114] sd 9:0:0:0: [sdc] Write Protect is off
[    3.609118] sd 9:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    3.609135] sd 9:0:0:0: [sdc] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    3.609158] sd 9:0:0:0: [sdc] Preferred minimum I/O size 4096 bytes
[    3.656107]  sdc:
[    3.656172] sd 9:0:0:0: [sdc] Attached SCSI removable disk

[...]

[  319.784903] systemd-fstab-generator[3678]: Failed to create unit file 
'/run/systemd/generator/mnt-raid.mount', as it already exists. Duplicate 
entry in '/etc/fstab'?
[  320.493627]  sda:
[  320.523036]  sda:
[  320.553208]  sdb:
[  320.582539]  sdb:
[  320.611367]  sdc:
[  320.645390]  sdc:
[  380.427225] systemd-fstab-generator[4106]: Failed to create unit file 
'/run/systemd/generator/mnt-raid.mount', as it already exists. Duplicate 
entry in '/etc/fstab'?
[  397.527095] systemd-fstab-generator[4317]: Failed to create unit file 
'/run/systemd/generator/mnt-raid.mount', as it already exists. Duplicate 
entry in '/etc/fstab'?
[  398.090051]  sda:
[  398.125241]  sda:
[  398.154056]  sdb:
[  398.183259]  sdb:
[  398.208969]  sdc:
[  398.242772]  sdc:


--- fstab ---
# <file system> <mount point>   <type> <options>       <dump>  <pass>
# / was on /dev/nvme0n1p2 during curtin installation
/dev/disk/by-uuid/12ab46a1-9aa5-4592-950a-3453232d4be8 / ext4 defaults 0 1
# /boot/efi was on /dev/nvme0n1p1 during curtin installation
/dev/disk/by-uuid/727D-6DE0 /boot/efi vfat defaults 0 1
/swap.img       none    swap    sw      0       0
/dev/md0 /mnt/raid ext4 defaults 0 0
/dev/md0 /mnt/raid ext4 defaults 0 0

--- sudo  mdadm --assemble --force /dev/md0 /dev/sd[a-c] ---
mdadm: looking for devices for /dev/md0
mdadm: Cannot assemble mbr metadata on /dev/sda
mdadm: /dev/sda has no superblock - assembly aborted

--- sudo mdadm --examine /dev/sd[a-c] ---
/dev/sda:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdb:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdc:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)


--- Reports from: smartctl -d ata -a ---
for:
/dev/sda
/dev/sdb
/dev/sdc

show now logged errors.

--- mdadm --version ---
mdadm - v4.3 - 2024-02-15 - Ubuntu 4.3-1ubuntu2

--- sudo journalctl ---
kernel: EXT4-fs error (device md0): ext4_validate_block_bitmap:423: comm 
ext4lazyinit: bg 106111: bad block bitmap checksum

--- sudo mdadm --detail /dev/md0 ---
mdadm: Array associated with md device /dev/md0 does not exist.

--- sudo nano /etc/mdadm.conf ---
ARRAY /dev/md0 metadata=1.2 spares=1 
UUID=e8926355:c08133be:4a187ab2:9524a7cc

