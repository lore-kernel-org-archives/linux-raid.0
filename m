Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C953821360
	for <linux-raid@vger.kernel.org>; Wed, 12 Jun 2024 21:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718227826; cv=fail; b=AsQRSCUB8zqvANSUHP8ttV8fgAxxbrwXN97Bbuvbg7uuoyaW8jsOrsZ2NwcAqz6cf1S54fUpDOYirwVxzcQfmyJYR0W5dB3RawJAdFjPtG6e4WsQY2c9w07eR0F1pebNrvX94zJn1XgpMHKhvt8Ygp0zrvULqg/cf4ftxk+YgKQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718227826; c=relaxed/simple;
	bh=nGkjnwKfdy7bmo3+v1Lo/LcDjFSFDhmXSR8EWT3+oJ8=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=HroRlz1eIDJrGBr+mSMhma85Q9p8YKbnvlbJ6gfbQKuX0qfkvj9Vmk2okTwy6/4Fz91laNwqFCwA+SKJuOQmmO3gc0NHY8/bLTvyN1B+UuSzmxvqRpZd8qcKgnncIibk3cRkpzwRhhfQ2PK1UyDFrd+TKXqgsTLRk100a8Yo/28=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=XyxIk6e2; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="XyxIk6e2"
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 45CLJITl010577
	for <linux-raid@vger.kernel.org>; Wed, 12 Jun 2024 14:30:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc : content-id :
 content-type : date : from : message-id : mime-version : subject : to;
 s=s2048-2021-q4; bh=YZJI2hrM7XlANUIJa3/FFV7LWnBSWht/hPZUDi6p57w=;
 b=XyxIk6e20p5TQDmoyQAw3FHe56Sgzru/UZGnatcVBldifR/xyf1aA8p3ylE8vjrUcMUf
 4MHwjNwTrmerilKigxt1y3xrWIL+ZwvYpxyHElF0iREH8T4hJWlqOdpIyWcBvlvTaTHW
 hL0phPy0pVvgLnynSL9sqhU0wv7RJci4WqtFcrEZ8jUBuwFNmEeOl4lhHEr8yoi1Cv4/
 DH99P2p125RyD8DC4gV/l0Q5JspQnhXYn06ik1y4mfkxbNwaKuvDgte1WIH5fzerVmXE
 iMsTb8xWCcaOyitl2m/vlMFEnJIvFcDUcjuiSv9cq5FjZmLFnkg5lHDbBk2/8NfxgSY+ 8w== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2174.outbound.protection.outlook.com [104.47.73.174])
	by m0001303.ppops.net (PPS) with ESMTPS id 3ypm6qm7u4-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Wed, 12 Jun 2024 14:30:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jtWD7s/izJua91RU7u6XByT267u4wieahywGf9RianaY+920bjrRV2IYJvWUuZ/5QCBIFnJHJv2LA7YUBdZ/sFGatwHbc9acdWFEZ9ZVkBQtPqRedFG/XvX6nCGJYiLifEBDQ7GlbcmQu24IeCCAXidmkWFmhrYJt5XEFiE5LabNz/cl4GLgTvMQpz/k7AcvzgyV5uZb/DF8lz2OWLi96PetddW/0SqEGmuau5iOz2Tkf+7Zb8afIwuuVopDBuGBrTGlKRLr7TbkqTiz9LuoDCU37w5WpC+HnIONk0wL/nAMipXfHrLpE9tguDxbnUk8sNSqCa5riOFTVQOg6YePvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YZJI2hrM7XlANUIJa3/FFV7LWnBSWht/hPZUDi6p57w=;
 b=Ch34RZQ4k19nRbJm6Ams+moweFuopGF2qOkU4/VoqkDKmYpuq1fSwI1EIkAyrSRZhIRRTmg5XIYfmusy5lap+1nMpMFNLtzvTP4a83F2BUeJXDaabb0MtV8d+KUE9WlOP3wRyqqxknJIG47yJ2ZKVnDxJygw9ziAeuDdEiQd/9N5Y2aZ9WzgUdL4ukEgLO+14TggpziJxHx/MQ4UQKewy6+bcoUYHUjqdpblBdJNstq9sf14N178o0eWqt/FpiyPdJ8Jb0UU1hMhWKh0AM9k04M44TAgxfj/gVtGmxos19mvUbfP1/1HhpQXOtDRvKAv51f6iLhpQm7HsFLs4Cu4Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by CO1PR15MB5052.namprd15.prod.outlook.com (2603:10b6:303:eb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.21; Wed, 12 Jun
 2024 21:30:19 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%5]) with mapi id 15.20.7677.019; Wed, 12 Jun 2024
 21:30:19 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
        Christoph
 Hellwig <hch@lst.de>, Li Nan <linan122@huawei.com>,
        Ofir Gal
	<ofir.gal@volumez.com>
Subject: [GIT PULL] md-6.11 20240612
Thread-Topic: [GIT PULL] md-6.11 20240612
Thread-Index: AQHavQ+5ORsLWyRXUk2irI6wSQFWRg==
Date: Wed, 12 Jun 2024 21:30:19 +0000
Message-ID: <D2932D51-D0A0-4072-876A-D02CE0A8CCC8@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|CO1PR15MB5052:EE_
x-ms-office365-filtering-correlation-id: d1878b03-4e3d-4c9e-0d0d-08dc8b26dbe7
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230034|376008|1800799018|366010|38070700012;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?eD39RrbZMS33/klD/+hJ4pNh6ggs95Uj4IrXZ3GAZW8pjWQbkp12vXcI/kl5?=
 =?us-ascii?Q?L9siYFzbL73ou0VpelImGjOPjj1f6Gbh/H+8yWFPOMnlJhIkdUhdaSG0XCZu?=
 =?us-ascii?Q?I99YhB2YQm97YijBWXZuHZ9dRTwUbFiJq37RmhWTZhfYxdZQUJYDtkwbX/26?=
 =?us-ascii?Q?DLaga8yZsH4gQdanNFqRcBvJ8fG+jTE5RL0audboR6lgsGGQ7RvRDVIxe+06?=
 =?us-ascii?Q?pVCUyuA5bKQK7y9Cz+/+t82RzXs2MTxqHBbHI79IgjknTZrrJYuFxu+B6Ytf?=
 =?us-ascii?Q?ldwLVq8SzFRPVFu+EUvjU8gFt1LOlYarY8IlWIm0GwqSAUW128s/NpSOP7a9?=
 =?us-ascii?Q?50hpesYudjb3+WTRrtg5qlNwkKBcgT9v+1xcc4IXAIcUL7azJj+eGA2RcOyd?=
 =?us-ascii?Q?7fpKChKzyM5XpGrYEPDERxlAzeIuPAG/m4vdZwgm5V8AIPjD4aIZDg+GEEK0?=
 =?us-ascii?Q?c9+nEQMhPjcd18cgvBgk6Cs52EOBvYxtbrowm/tfQ7KEml/xqvmZUGL51utx?=
 =?us-ascii?Q?6oNkLZISyvOy7IolgNbc4Ui3z8orkKgkEIn2QrcA526oDuFR+entAkXUnpKz?=
 =?us-ascii?Q?k9YGtZuYz8fG9p0DlZZ6u7mKmlWj6WU4PbrKeyFw6NncM+sTN8itWJvYk3n4?=
 =?us-ascii?Q?GdCMfLk6qy6VHcL43wYMocFlzwrhAQsI9th7KSrp8IGmod2nG7DGwWs/G1j7?=
 =?us-ascii?Q?eyNwiFCeJsOvxnxURpweSjhQWHhD9BcaiVls/2URFYTqHzNBn33Qv1fVIBkC?=
 =?us-ascii?Q?XWPUT382b/FK13nCNcuTRCDPprozjXTc594Ym2z6lb4NTCfyxKBmfGm3PP1N?=
 =?us-ascii?Q?Mx2u37PkhqAhYjG49GmTn2oqE/oeEIvVHjKOw/BTL2H0MvPt06GBg/pADPVk?=
 =?us-ascii?Q?KmPQYu7NzgT0htWlUiJgtlXce/i/wIUMM8XEMeTAQ03mty3EdEb+b3DWSK3T?=
 =?us-ascii?Q?+Dra62x2oQ8P+R3XAeAo7/bgughWQ5MRn2gmVApcd3k7b6NvU5Cgo3tVvY4z?=
 =?us-ascii?Q?JWpf6/TC1bLgXp7/9Pzp+n2xlWe1W1Vcke/WaeTWceINsSvJ2kNsBVSHMvGQ?=
 =?us-ascii?Q?rmicqLFFn5D+/CIJD8qOLcZkW03rNLAjHMhTh7YwpIOX1vkxfRQWSyVD+bXI?=
 =?us-ascii?Q?p1DTEdKsDxALU/y+rLwPPNuP2UxIOvYq0VKUGHIAhHE4+b6ksD0Sb3Md3X8u?=
 =?us-ascii?Q?/v6LiRTZgGvgjO9WFVwsQjON2a/0mCeHz8IK++i1uLXB/8Lc3C013yJXrgt+?=
 =?us-ascii?Q?5+ARO7nLlmwYyG2ibH1yRaa9We5iPodsWaumoXz29HhzUThKh/c0GCJrYKk9?=
 =?us-ascii?Q?y1405PlLyWmXZs6U8I/s02Jv7gJYYaUFofpVnWS/7Y+cGLJD+5lu23ZJUSDH?=
 =?us-ascii?Q?4w+9LGQ=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230034)(376008)(1800799018)(366010)(38070700012);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?16nzj7OVRdznvRStQm9lPgia0mbgrCiqnU+CyFOhtna15NBk1A9PeoWDWb3X?=
 =?us-ascii?Q?wryVDObJEeLsl0mO5A+zNkxVVyurV8YjOE/Oqr6V2HLtLS0hxK1D8xEB63co?=
 =?us-ascii?Q?MAqYhAJWkLf2zw0qpcHYjBGtrrc2f2rGQURo8jr40Z65xf9qCpEnLh7qWDS6?=
 =?us-ascii?Q?cZD/aeIKTZishFbfELAi6aA0uxSB52sruPAyubugXCcuEuZ6UezAN7BjPwVv?=
 =?us-ascii?Q?8X4V79VH7XGFg/TMSoK0yQBoBFKC44dTv71YTF/4W1QtwmYNkyyZq9uAgUII?=
 =?us-ascii?Q?pIcVGLQnlfXd+0mDkJb4kpVW6SZg92hi2/p+HMD755f6G3OYNVbOIXZfa4cX?=
 =?us-ascii?Q?vUbWVyVxAO2wJ/qINlot5A9I+p5nup5ulxEcccQekWdj38TI/lN+7BLyKvNb?=
 =?us-ascii?Q?nquoR2cJhHtZTeTb6Eo74SJ+I7LqRWMEubO2/O7+zHhDcixRGNvt3Qui7l0c?=
 =?us-ascii?Q?g3MG3y+jl2SYy/Fzd0diL43QBWml9c/To7sS/rWOaiRbimbJmO/piGXKz15f?=
 =?us-ascii?Q?/FC1OSmVpTH3yrRiLb0V0+EfjjO5kz2nS6Uriil+hptsrp8KL7aGwIUykHQG?=
 =?us-ascii?Q?OFNCYz6+JbXl8XpF1B7NY588EnL4pSPgSkYoRy696pE5pCd7bDYYdlZhnfOq?=
 =?us-ascii?Q?C6z7zPtbc/uG5km0x9m+FWf14NG0EClfAAVmiqPt9NZuUILeu+9K3sXtgUWF?=
 =?us-ascii?Q?RqVZJOzMPSTloemUBJa4tPNUXUYIHoEPM9ACcuEqwFnMNqw9v0SAhAlROO2c?=
 =?us-ascii?Q?w7Q3kMHa8OJMwx2zmmQzZdCTSIH2c0p1F5z+U0eUjYJfJxamo3FxHRUwrfQx?=
 =?us-ascii?Q?GlAkoTCnvzsqWbtCcbbNUvo8Bo5kdaQK3mTSKQOawFaaGsK+M2N2DhqBeuLB?=
 =?us-ascii?Q?5yUZb2x1xprBa7N5HnFh3jxT1ij8wi1lTgp0laaZOvtE0gvX4K4ySTiU6cfR?=
 =?us-ascii?Q?So/c8iG5c1liZTGZhqwv4aiBGX+8BBdVIj/wnNOsbkAHXrVYGdh52mzczePi?=
 =?us-ascii?Q?5AukfWanubMJOzK+9xzMD+i1PNrHyIYddNBCPfBj3DWCrrxY4X/g6FUfrM2p?=
 =?us-ascii?Q?jir5ezxnjL1PFfD3JurBbBNn4yqvIctMarxGpX25Kxa2ltVcz3o3IhHSICLM?=
 =?us-ascii?Q?smEv8+cDUOIB4JsFlmDclRIj+IPzZOT59UuwEPTGw+eyUBUS0UWR/RkcRhrI?=
 =?us-ascii?Q?jZqs0KpJZAOFdPf15FLYj6/3CcaWPudTSbznGsJkTShJ1Pshpo/m+m8AidKE?=
 =?us-ascii?Q?f5hdcun5nLNqttjy2aFvponTLBvfUcqw+jIrWD4T2YtEY6y4avo3mqX3f2fJ?=
 =?us-ascii?Q?U0sib2HWDcGtfpeFq+/XeGiHTvcJX42fQIW1CXGsBHVmWH9sipdYjdqpcbWh?=
 =?us-ascii?Q?eBMBQr5w78cHi1+PaC7Fhyx9jFtylEeY/eWHUppBIWKLDu6est1I0KBCmkJX?=
 =?us-ascii?Q?mtKakzn9hC6cJAtNTX6smXHV4fbm3+iZNp5QJNTojA0WrGfGjWehe+stDzLn?=
 =?us-ascii?Q?lo69zLTQRZ2OnBPKaqXJ//Wmkf33Xym2d7jWLZScqSrBBOO2L2y7N7QU5SO4?=
 =?us-ascii?Q?iOU/XT+S++WyKN2BAm0k25ORQV4TNWlHcRxB8XgVcaz5pIDg79rNgbBRynWc?=
 =?us-ascii?Q?aFVfldQIlVSAweOpAgEhQqs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D8CF829EA1723346AE020B3B5FA43F59@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1878b03-4e3d-4c9e-0d0d-08dc8b26dbe7
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2024 21:30:19.3651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YCsQht4BZkAq6JxKGlwn38cuUiLNWTPyAIutZrMEb1TUxeV9v6G2P31dmklnMLFb+p759G9n7rS2JL51wi4ytg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR15MB5052
X-Proofpoint-GUID: u_vvk9U1PcMEeDFkSZ4LLOl9nS3q2o-O
X-Proofpoint-ORIG-GUID: u_vvk9U1PcMEeDFkSZ4LLOl9nS3q2o-O
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-12_10,2024-06-12_02,2024-05-17_01

Hi Jens, 

Please consider pulling the following changes for md-6.11. The major 
change in this PR are:

- sync_action fix and refactoring, by Yu Kuai;
- Various small fixes by Christoph Hellwig, Li Nan, and Ofir Gal.

Thanks,
Song


PS: I noticed that you haven't created the for-6.11/block branch, 
so I used upstream v6.10-rc3 as the base. Please let me know if 
this doesn't work. 



The following changes since commit 83a7eefedc9b56fe7bfeff13b6c7356688ffa670:

  Linux 6.10-rc3 (2024-06-09 14:19:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-6.11-20240612

for you to fetch changes up to 305a5170dc5cf3d395bb4c4e9239bca6d0b54b49:

  md/raid5: avoid BUG_ON() while continue reshape after reassembling (2024-06-12 16:32:57 +0000)

----------------------------------------------------------------
Christoph Hellwig (2):
      md/raid0: don't free conf on raid0_run failure
      md/raid1: don't free conf on raid0_run failure

Li Nan (4):
      md: do not delete safemode_timer in mddev_suspend
      md: change the return value type of md_write_start to void
      md: fix deadlock between mddev_suspend and flush bio
      md: make md_flush_request() more readable

Ofir Gal (1):
      md/md-bitmap: fix writing non bitmap pages

Yu Kuai (12):
      md: rearrange recovery_flags
      md: add a new enum type sync_action
      md: add new helpers for sync_action
      md: factor out helper to start reshape from action_store()
      md: replace sysfs api sync_action with new helpers
      md: remove parameter check_seq for stop_sync_thread()
      md: don't fail action_store() if sync_thread is not registered
      md: use new helpers in md_do_sync()
      md: replace last_sync_action with new enum type
      md: factor out helpers for different sync_action in md_do_sync()
      md: pass in max_sectors for pers->sync_request()
      md/raid5: avoid BUG_ON() while continue reshape after reassembling

 drivers/md/dm-raid.c   |   2 +-
 drivers/md/md-bitmap.c |   6 ++--
 drivers/md/md.c        | 506 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------------------------------------------------------------------
 drivers/md/md.h        | 126 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------
 drivers/md/raid0.c     |  21 +++---------
 drivers/md/raid1.c     |  22 ++++--------
 drivers/md/raid10.c    |  11 ++----
 drivers/md/raid5.c     |  26 ++++++++------
 8 files changed, 435 insertions(+), 285 deletions(-)

