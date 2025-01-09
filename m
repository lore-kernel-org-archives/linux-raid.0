Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0975418F2D8
	for <linux-raid@vger.kernel.org>; Thu,  9 Jan 2025 19:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736450083; cv=fail; b=Bf+BqoaeA9Sg03fDRK47WVAD7kZgLtWuzlzhoNFlZB+rUQGzAea93msjqtPwT4JPs5YF9lFMTtVwFhWYQN7/Q+XJK8dmwsbrkIoys4Qx5Nnpn4cOCmeFRtakKj1/SQyEb2TgfO/5aALJpG9+ZiscYkWUfjixJa/g+t4obep0Tqg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736450083; c=relaxed/simple;
	bh=OJcYyMf8Of+FaAsE2BEsP/c/p5CGMYDE0J3sshz0sy4=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=F6/QLTTV7snH9mIvkPJs6BZ39XmEv2RK5TM2AwULErg17PDY8vGcLL/FZCOnBa5EKYLwtxUVoMvbK4pAG9aLk0G7Wlf6QKnD9s8OcS25qzNSRIXOyZ/+d6Aolt9uZD+yvGzjlHqSm/+3BLPfo2HfRjsIMvKYXuIFtvTNEbtMknE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=n5p7uomA; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="n5p7uomA"
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 509J7LPW003279
	for <linux-raid@vger.kernel.org>; Thu, 9 Jan 2025 11:14:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-type:date:from:message-id:mime-version
	:subject:to; s=s2048-2021-q4; bh=Gv3F2tl9bdpjO9yE9y9MLqSXwKDlP0V
	Nv07PjJmURp0=; b=n5p7uomA+cz9u/na5owbk9v5b0mUHgpKgilE+YUu2C/VNoE
	h/WWwbdECOz7WHcaXYTPqF5D+mwnD5hZ4xhQCZgpgXLA8NyE6sANTAoORwsuRdIr
	9T5BnfgEd8mVL3qqJu6HVjHcvP+Z0A1qkgrOHgBEiFrXU+OxLXLuNLvDdD7FW2Ub
	O7jmF7yevp8Ik2rltT99T9xTl4UhStKSKg4mJhkYgmfUfV4bdo0pzmpXYF5VrixS
	HIUEogVbt4TFj4HfkLecZbnn+r5ABYbPT0Tz1onPzP0TO8oJ9iw4fLvVWR1te0qV
	dUFyVHQzyJy4RucyCDXvurnhSb7HE1IItyELuNg==
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 442j5a170b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Thu, 09 Jan 2025 11:14:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GH4ddJT1ADZJwpqtEJNhrCrBE1VKbQDKStu4o3UvcqZL/iGAyoUL7Qv4egi5Sxlng7kA2LvSnhP9Yuz+tOVdmZ90NjkduqV3YqQKuTgW2xYM7fSIIzXzNXzKRrdHzD76oj9vrtlckVi/UUlBNf32IUpR18o7WF9bexRnRpFiYxQrYwkjtZLTfhssAoYWLONocjGCtyYmSfim47lDKxxtz8NOZKo6GftLXYYdlB0GryxTgBUq6R+Ximy32rckax4iEDzapVh8/Wy8tImLpvEGD/SlPrSz8oV2S2oGd/khGroZQ5PlE7LSRDIfR4nJEbClw/lbEnUqDzr+/6usOcPZmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gv3F2tl9bdpjO9yE9y9MLqSXwKDlP0VNv07PjJmURp0=;
 b=JyjowJxrDR+GtjlUQhZrLq6XonZwRA7lw4hKTcPazp6AJ7BVhwgsthIbafum1/Oh9vaYiTdxbDVOD+YpbHSU1f7g60v6Cmd+43VNN1VmwLWu1utlsYo66rcxGLNWbh916Ug46sKQo+uYqqvE1XipvYBKukT3xF4fvQ0y/zBRInPyZPvuQNAKq+fu06SIju8OM9cI8Y13HGiZYEb+6DvmAyz6ptqtmNQ982v+1jz2M7cqx0FU8qdbCJA1AYhiE9C9pUlRrILYMRbFBP74WZaODov9rCxVagR0riF77XJbLr6/LH4lS/Jhl4DZRN5LdVEztQ+FyroVuUawVLuGpEWMVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA6PR15MB6739.namprd15.prod.outlook.com (2603:10b6:806:40c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.11; Thu, 9 Jan
 2025 19:14:37 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%7]) with mapi id 15.20.8314.018; Thu, 9 Jan 2025
 19:14:37 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
        Song Liu
	<song@kernel.org>, David Reaver <me@davidreaver.com>
Subject: [GIT PULL] md-6.14 20250109
Thread-Topic: [GIT PULL] md-6.14 20250109
Thread-Index: AQHbYsq5rR1geM1LV0ibneWeQuUUsQ==
Date: Thu, 9 Jan 2025 19:14:36 +0000
Message-ID: <4A41A8E1-FF2C-405C-8BAD-DA2157E3CDCA@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.200.121)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SA6PR15MB6739:EE_
x-ms-office365-filtering-correlation-id: f71667f9-f6a1-4112-fb51-08dd30e1dbd6
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|10070799003|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?CuWYiLw0wM/xyi1L/lkC/jKsNORR+GcJpnOQzKxwDH6+858UMCyENnusMc4S?=
 =?us-ascii?Q?9jixyTdjAgULoFvvUhvyS7EygpxdUmOKnb9vO8kmvckBkMH2XNYiwjSh6kA1?=
 =?us-ascii?Q?tp098zrHt00MdsE4D5JnEIvuXPqfaTPwzLODwaG3K4cBdmuJ5zwu/wHG9sIs?=
 =?us-ascii?Q?jOfUhQxWbJjEEIB41lyhMyCNYegYYYKTEU1aGBsqpg4bV2Nb01NflLql04oC?=
 =?us-ascii?Q?y+Fb5y9/vmVlfQx+1oHVaTSb+DcfVbgD961cu4GTynSDiJzqQTWfzacyTG7K?=
 =?us-ascii?Q?92+WmSdNcK4Op17KbAy6YP/vmurVjIt9zivuNgYdGl4lhIRmZDKkhe90uFKT?=
 =?us-ascii?Q?3n1UpZhRoWxlLaMJS/1UjcmMvs8UYMjJu2IC+vdGROO+1RwDFw8r963ncxxo?=
 =?us-ascii?Q?1n75KuQzs/yU23KfXZUQlvzOK4IoLd0ZxqBD23y+7lVlzfHBYySyvd0oiUE8?=
 =?us-ascii?Q?2G1pMirT33T5GIHVhVawejmKVXF1F+xDj0SmuYAzA69JDnUERCzEPWkWDStP?=
 =?us-ascii?Q?h+T9AFzoixuLRhKhszYpxqyY4stIIPha/15Zle7NuQ7BMs4I6JIZbILNvbyd?=
 =?us-ascii?Q?4If2CfsLXQ/fIMlkHUpYBxYFII7dLg8iUVOku1sE1BvClxrxMwEZHaj4bICn?=
 =?us-ascii?Q?xGA0VHH/BF2DhHSM/KrjoeLkREzQAM9juZ+VoEXczczJBWDzf75qLJr0Cd8y?=
 =?us-ascii?Q?NIhIj3fe3yqGucvd/ay+TXhVHWUkMuDkaCBPfo4gcPXsXf1E4H+YYhl7tnh4?=
 =?us-ascii?Q?D3rcqUaX6/Y0E577BFI2ZfdC2QU9RxwNKAHY2uzBReuSfFD0yDcEEfWPeohk?=
 =?us-ascii?Q?YHwDEt2ihh70dJL0ilSmFfF9474MzRAcZqvETmskgyFg5fqLlXiLo/jFaQUs?=
 =?us-ascii?Q?hrDVs/EKzaB17WqnUT/X1dLLSU8Pekk9XWTvbR+jP3ryfYj1YjDlwefyui2f?=
 =?us-ascii?Q?EWB+gdVLhKXDIHJgnDZGzIubDhFVa8PCwbuZ8V28xmimK9o0VFpmRZE7nFt5?=
 =?us-ascii?Q?8XQnU8awgHLfUrWrmD9D53iI3QPqEBMg8xEV/5QYOE7BljIdHeu05jHThmFD?=
 =?us-ascii?Q?Oy8wl1m9px1D3bZi48p+qoCo+opEqs3aP30QXQl5ggZdDdzKUcBoeHbZrB1t?=
 =?us-ascii?Q?mkZM+PMNHwwdbaTQweTZvE8W7Znn5skmIAQns1shYB9i+Jiokytvxgr0JhMx?=
 =?us-ascii?Q?n2YWs03n+erhwGlybMeuoXAhbzsI5scW4HhzgS/T5P4yuh2wPCihLcZfLnMv?=
 =?us-ascii?Q?G0mDM5+dXUEd3aZE9vCHi4KhK6JuNFYSYvCQMPHeBoFd67NYv3Rc6xvB8m9D?=
 =?us-ascii?Q?zp0YUIXRcdQqd+rcTJhAF2bKMxQLCmlDYuqhmQNhbvGucUWNgdrc2R80ct1l?=
 =?us-ascii?Q?5VhYO0/mC9SMFo9hptRrvrAKaubgAkGAUEHkn3B9CYpU3uamBdGkLVVUcfHT?=
 =?us-ascii?Q?Fo1LtgL/TOUSrHT8a5ALmhzSVRe8qbiD?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(10070799003)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?J4PBa1+kexLr9FuU0u37c1PmK9Ka3LQ6SFRURSJxRJdLHATyCleKbO6whrXd?=
 =?us-ascii?Q?zDxVhW27Xej/O2tTOmdGSVdmnuGwDi/EF4JEkqLeKmMJuFZbLIdxq8lQfDT5?=
 =?us-ascii?Q?W3Rrv4h60JlSxMj9zhTnn9d0S2RjlLOb7oVkG+0MxL7r1T/amsr6um7vI66c?=
 =?us-ascii?Q?u7AfBJgN0TyJBG2lYngi29dPn52NgKHBUozxcgJC4bTrsMUZQey6tQGz5sfj?=
 =?us-ascii?Q?Zzo/KpkzDqDWNNJPTX7ki+Zjxsmmy9J44FCUG6sjuclnWryXAyL1CV8mD2N3?=
 =?us-ascii?Q?ffoh/JmrrTBOpYX+XPnmfxgfNhpDpOJkSk0DK110IOCMYkivTzROJGAFFip6?=
 =?us-ascii?Q?sp0JVvvMV4y6l5X5/S/iuh0vyWvS6uIpIbNUlLR11NrLIZfhEKIQBQ/y652R?=
 =?us-ascii?Q?WYS2XvyhfCaEXF9lzMBYqhcU5FLs47WcNnXfCvfTkLaSSAqCLhDEbwXDMFFs?=
 =?us-ascii?Q?drfjxyL0I59uAzRQa1vD1pJRdVbjhSEenqKOXC1AvLH5ZuVXUQo7OkwRkBb4?=
 =?us-ascii?Q?WCCZjmLJYTcmjaOGSSV14izGI+2KfWNNyPoPijn4THJ8vBkrHMbAf8HJer1U?=
 =?us-ascii?Q?5mw0TodGgarXF9nR7sTs3pGu7PEyMyU7LG3xiM0hZEMstgDA/ivRhRU7qZ+5?=
 =?us-ascii?Q?F9H0gWqeMrWsewF/JSNp3Qh43GrOM+vbHLb/zs7w9244IWEDGAMrFePPS0zS?=
 =?us-ascii?Q?wXBXC+sPaGVRdP30bEixYHUpK/jRsdcm7gEqg2Gu2RiHBguZqqREliM1DSJx?=
 =?us-ascii?Q?7b16vBGFZhaj/pfZ1NL8/mHzq5nVqd/KYwvQm00XsxTgI2LCw3S+VRxPvbhH?=
 =?us-ascii?Q?f0qNZKa4E2jxYW4q+qH82S1R104bPbPJ0RPffQRz59qIbasyudcIGMfTU1A4?=
 =?us-ascii?Q?dnqGTyAyXGryJq3Q9S2Fs8/oMDDxwGpu0GRNU5jTH9MBs8MCPVWb5asu9v/0?=
 =?us-ascii?Q?LwR7FAW9VpxKiqt2rilQ4LrKbvWY1znqBgeou1CD7Kw/h7ps18AV5ArxyQBC?=
 =?us-ascii?Q?jL5Od5m3lH2+EwlClLY6imcXwUt/mAD23r2Gs0u3ltkX0b1A9iDaqzb7j++W?=
 =?us-ascii?Q?jSIoKG5qHjC2J4HBSM6ZzmHITo8kNq1hNeXPcotde49mq0NhhK1Zng+AYlab?=
 =?us-ascii?Q?ViePAou3Ui2/KjN8bRel6qZe1H4MQnBZsb8QlIxutG2GF2O7P8g/i6odmQT5?=
 =?us-ascii?Q?c/ScMPCpvD6PqvhMBIxjuDj70J6SXJcbuw6z37M25GUAMqwQcRNlQXCLSxl9?=
 =?us-ascii?Q?z0XFmRje3a8j/xATif2c6Pn3buqHkRAUS6yDFA4lomu3cPsG3TCwvJ+Ah/VG?=
 =?us-ascii?Q?1ChvQ7YlxhjMZSmPDZWg7Hz+AQU8bzrAzF22K5k2LKbY+gl9HabooZU/HSgg?=
 =?us-ascii?Q?gIcOXAt/OgfxuhXZUcY4TFFqAp+1rcguNRj4J59kI5cQXCTD27Z31uVQvBha?=
 =?us-ascii?Q?L8cAawiNlbgwdxec9T+UmKy/tHK+MS2zaCYWJE0hJQKEYAh0Gx4SUziP1BSS?=
 =?us-ascii?Q?Iq3HCzV+mSGb/WQdmg//PWN/3TNmzooVigEcKx9ar7B3WHVCalw8U7CYrHRn?=
 =?us-ascii?Q?ULhSxjYPKzLIlJy3NPew9bbo3xI0jGIOcaePuThjmwhMb2HTVL221HRYtp0C?=
 =?us-ascii?Q?YWIRfYjMTNGxvuUZekK/IHs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1B8A682D351356428F607A9FB5D7C871@namprd15.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f71667f9-f6a1-4112-fb51-08dd30e1dbd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2025 19:14:36.9853
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3PAW8LHHT0x6lYDRJrxp0Q+3FI7TkroK6pdkNvaBA3RFCB1qfl+3bRZr/MXKJP1LG66NapTGtFD03hFSIdBKrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR15MB6739
X-Proofpoint-GUID: s7NFEZneRbCax9Wd_TAWZ3V7RjE4aTG-
X-Proofpoint-ORIG-GUID: s7NFEZneRbCax9Wd_TAWZ3V7RjE4aTG-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_02,2024-10-04_01,2024-09-30_01

Hi Jens, 

Please consider pulling the following changes for md-6.14 on top of your
for-6.14/block branch. Major changes in this set are:

1. Reintroduce md-linear, by Yu Kuai.
2. md-bitmap refactor and fix, by Yu Kuai.
3. Replace kmap_atomic with kmap_local_page, by David Reaver. 

Thanks,
Song



The following changes since commit 844b8cdc681612ff24df62cdefddeab5772fadf1:

  nbd: don't allow reconnect after disconnect (2025-01-06 07:38:20 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git tags/md-6.14-20250109

for you to fetch changes up to f319855a3b385a69aecb0a398cfc4855b9d8d999:

  Merge branch 'md-6.14-bitmap' into md-6.14 (2025-01-09 10:48:01 -0800)

----------------------------------------------------------------
David Reaver (1):
      md: Replace deprecated kmap_atomic() with kmap_local_page()

Song Liu (1):
      Merge branch 'md-6.14-bitmap' into md-6.14

Yu Kuai (6):
      md: reintroduce md-linear
      md/md-bitmap: factor behind write counters out from bitmap_{start/end}write()
      md/md-bitmap: remove the last parameter for bimtap_ops->endwrite()
      md: add a new callback pers->bitmap_sector()
      md/raid5: implement pers->bitmap_sector()
      md/md-bitmap: move bitmap_{start, end}write to md upper layer

 drivers/md/Kconfig             |  13 +++++++++++++
 drivers/md/Makefile            |   2 ++
 drivers/md/md-autodetect.c     |   8 ++++++--
 drivers/md/md-bitmap.c         | 116 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------
 drivers/md/md-bitmap.h         |   7 +++++--
 drivers/md/md.c                |  31 ++++++++++++++++++++++++++++++-
 drivers/md/md.h                |   5 +++++
 drivers/md/raid1.c             |  34 ++++++----------------------------
 drivers/md/raid1.h             |   1 -
 drivers/md/raid10.c            |  26 ++------------------------
 drivers/md/raid10.h            |   1 -
 drivers/md/raid5-cache.c       |  20 ++++++++------------
 drivers/md/raid5.c             | 111 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------
 drivers/md/raid5.h             |   4 ----
 include/uapi/linux/raid/md_p.h |   2 +-
 include/uapi/linux/raid/md_u.h |   2 ++
 16 files changed, 203 insertions(+), 180 deletions(-)


