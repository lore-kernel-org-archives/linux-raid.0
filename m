Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594BA3D984
	for <linux-raid@vger.kernel.org>; Thu, 15 Aug 2024 20:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723755089; cv=fail; b=qC3yIswvU81oqLe7Ekg1LSY//NFBPKDHZplvqu5PC8DfhU19A35Xer+FY/+hccSNxfg4pmI1IJ8MabWMaj7o0De5Zb6LOZUgt5odvAAO7LzV43V+QjBY5paaYgUHNLW5LBW0B0QFIy18j8C6ViDURJedOs5t6D8+dMLYojSiVOI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723755089; c=relaxed/simple;
	bh=N4ShmC8y38oDyJR1gARqI55QaQEBFmnjHL/zfWmpZ+g=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=eQdIqTOFHT9zW/ZNDrjDc6iwilq9LzWOfL1BvC/Rzu9cfYvZpzVwIRwTAQeh7S2k7TmA8zwZ9oAwGfdRcY92QJRBm+VSX2+1rWug2rKc66aRK9QoiI2kz1NaZ14hG+JNqeROYS4pqd0SKcQ5nffByBk3vZfTUIDIqSElSoaBMCI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Z/+cr3RL; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Z/+cr3RL"
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47FJgTeO004052
	for <linux-raid@vger.kernel.org>; Thu, 15 Aug 2024 13:51:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:content-type:content-id
	:content-transfer-encoding:mime-version; s=s2048-2021-q4; bh=rJ+
	mp3B3EOCnvFmIA4USihuKkBBkBzo9O1g6nV2KeqY=; b=Z/+cr3RLb+DPMHs284j
	n8pM3hgIg6DLyElXS5YzMsLioaZjlROLy63qY3C/g37pWDfAkrx+sIfrV2kG2RGt
	8jQPV6CKQCBiEiDIkkMXKx4nqZGXIW4iy86ANCiM9N7scPxW7rFRNERq8W1Kk7Bl
	dmDBCmJVh8ksn3EGv/985ddps3L8OPS4ZntimMR+E8nvC3xbni6Wqbs3pG2Zo6qW
	EsXQ20RIkKvEdK1nhOTdBGGh+i5u1thgNW53XFFnBUajrr1STFNjJzI1U8nPW1AK
	Q6G4UB0XIsqcoivVlDj+O0GfS1q3bZOSQmNdfxJCRPr0AXQ5TfBFFwbYyBpEJ/4N
	rYg==
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2041.outbound.protection.outlook.com [104.47.70.41])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 411n5t1q1k-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Thu, 15 Aug 2024 13:51:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bZFcqil6CSMjVtzs6C730Qvo+sGEQI0M5SVWW9+KrXve9fZlb3zxyFh2YkXkfUZuGyUdldNYm6YWzzDgrr2A7jpSfI6GVUqvu6mMls+GUna7jBJnpFyzvQ8RnikHflZF00a6Ds3PbEGpVqLTvc6eG3mvECXkQK9uhQPcc/LIH/MHuJ6MgDYvK8Yw8kgnvMdnenKkQUKRitf+KoCRVwddJTzQpG7WgGilXGaI5zMfCoClSZFgS7HsHZJDN5gUtGI5gimwK9tpEcqZ7c2LPhzPvHE/R1+KM0N+VwfS9F2y9PnKPvSy/L0TdBmYrbBU0YCBDQppF94GhszX9q0gmjpkjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rJ+mp3B3EOCnvFmIA4USihuKkBBkBzo9O1g6nV2KeqY=;
 b=WBTNRgHCiwaY0WfVSbm2rCEjxGIOsLpI+AG5/095X/Rvh83DLpS1BWfcesNqrSjcEj/ZXebUgomH/ibhVeIyF/AhwNtMQv7V/Jf63SGIiNz9tQGo9+0DGl6YoGEURka7nVW4NjG5GVVOR+yVkJwLcU2zfPoqkum1k6pTjgTXZNvPvbc83RRKR6kRa8+G8sBMzMgYG0IbRSA3k4ueP/YgT1I2GH0tz+slL3VguhEy1V3B7NSy1Dt6kdH1MEwBL98rl3OiEGgZhduL3W/E1W8A+NoK7iZac+rTqVdAcdvPwDAWgEtt4hVI900VxOa+2NAXJM38+BAbUD27cdlBQWC3gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA0PR15MB3855.namprd15.prod.outlook.com (2603:10b6:806:89::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22; Thu, 15 Aug
 2024 20:51:19 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7875.018; Thu, 15 Aug 2024
 20:51:18 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
        =?iso-8859-2?Q?Mateusz_Jo=F1czyk?= <mat.jonczyk@o2.pl>,
        Paul Luse
	<paul.e.luse@linux.intel.com>
Subject: [GIT PULL] md-6.11 20240815
Thread-Topic: [GIT PULL] md-6.11 20240815
Thread-Index: AQHa71Tg89uCKItgu06hVjrDmmzfeA==
Date: Thu, 15 Aug 2024 20:51:18 +0000
Message-ID: <A867CBE9-CE6D-4A8B-AAC0-C9DA4BCB15BD@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SA0PR15MB3855:EE_
x-ms-office365-filtering-correlation-id: 81024ba9-6b79-438e-1106-08dcbd6c0335
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-2?Q?CtgFXBDeSPkkP02GHDm9QTduXMKvmTjIM/w95xDrYJ+/b4tTxOkN3jgUCa?=
 =?iso-8859-2?Q?4BjwzSjlSDK52fgWLlxOBIo6P1L27mL/T6wEYZ6HgRBL26zaIDWouz5NqF?=
 =?iso-8859-2?Q?sIX3ffc9oylxzuqr+nEIml0WsvcNj8aFAFAb7Tk1fawQgLGUS0Hz3LRvFN?=
 =?iso-8859-2?Q?bdG3rI7EgaELj4rTum/4vxmD4yS99L7TPU/IoSf35LA4qZ+o5B6rhBg3KG?=
 =?iso-8859-2?Q?9lc1CdiXytuS4pBLxj8f1EfH+rU5+gYGimNqxHQfMCe2aQ2u4AIauNHLtt?=
 =?iso-8859-2?Q?0bqwv+iIvs1qbt/WhBJtJ0UULffXZUZ7Z5fhQ3HjZVbvfSxKmjzrlmai7E?=
 =?iso-8859-2?Q?JCcC3BgZZ5Pp0uWhHjCgOb2T3ZiYlym24sR3OUiyg1MS78xHvtRgXZpP2I?=
 =?iso-8859-2?Q?qhInHDIctnH0ffcq9t9O2Ttp8X6Awd+SQ8TSh4OZtTy1bxAp8I8GBPAEZc?=
 =?iso-8859-2?Q?fRRtOAemKIVEfAcrnvG9/bLPQV4n1hpZkwvqmunqtyw//7lbwYs9sGNC5a?=
 =?iso-8859-2?Q?FE5Ku6xOjeV/hhiUP+TSIhJeMYpdoTBeVC7CwwkdsgQu0PXHP4tVWg+U/I?=
 =?iso-8859-2?Q?vHUP/+aSZJhmvr5Y/OqPNt7nZ+magn3xgjFfcvmc8wQmgXTlXURWQ5l0kJ?=
 =?iso-8859-2?Q?Kf+MAM8i0PGzMUBMM6D4mMjsqE64fqXPX+t+o2Oh3TLOriS1WVz/2JbPfo?=
 =?iso-8859-2?Q?BHl1kdePkZ543mBcw9plNUaQE4s/fKZKvav69cfqkhuKbX8MaeYYOa8Pc8?=
 =?iso-8859-2?Q?ma2WpJ+V1IYq74nagaOd2xv6geLM9kBBU8VFfHzz2f9TChPADpsycxFaZj?=
 =?iso-8859-2?Q?lxNmNBr0qMVfWK80i4Gb8asVT3d7iMAMYCVMRcRT8ycT88w0o2GkcDSxpO?=
 =?iso-8859-2?Q?A5A+WLWIzS8R6hE6I1kPDGS+nDk2YvcAgp2+hdirC5O3oUppucBxtATDXY?=
 =?iso-8859-2?Q?0gZxnolR1tOcc5Zn6dcB3YnaTon/rB6vLHmnZLEBpHlPSNrD/0EVJRpf6o?=
 =?iso-8859-2?Q?Vk35icJ4aNOmKoni3u3lyN7dEYsA4T7fJneAE/ISaCW9I4GA8avRsrR3oq?=
 =?iso-8859-2?Q?xiKnS0UoJPAEIeCKtx/o9oJDdt8/MwZmrNPTCjZ5WxFj5sGxfNcty1jVh7?=
 =?iso-8859-2?Q?aHlkQgASiTc8msvtYwLspfKwPiAGkhCnUm5t8t/iCppPixu0MsVFNUyn32?=
 =?iso-8859-2?Q?4KCYJtMHfQy2Zsb3HnTCdfam3dMnNLvt5NO43XEso69tzxaOh71NkCRbi/?=
 =?iso-8859-2?Q?wqtc5b9gVLVIsu1esy1sfGni2b4fRaPsreuUokhnhYJJksfGoenjWWGaFC?=
 =?iso-8859-2?Q?1N0G/drV+Q2+6O5ozkckOcVSVHQLDnDIKCYxKQxwwx0Ql17PH3XekYaaG+?=
 =?iso-8859-2?Q?FDH1PQ3HdQ77dvqncAJcycZQfJJwUPdj5UvYH0ky4hX6YkJaCJgYcUkesf?=
 =?iso-8859-2?Q?7SN9OQrWMiyB9e6UrKpXAuJeEInR0KItT+eNAQ=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-2?Q?L7Fj003OK/VxnYya3gVN82nqLr6k3rpa0OCvOg/I/6C/gI3klXgPnHahIA?=
 =?iso-8859-2?Q?mDNCgbmHrbNxjlgW2NB3kJ7sf/Qg/uM0QiDzgd+XRV//mVZfaa30rM/2su?=
 =?iso-8859-2?Q?sSbKOXTntX6159apyTmMN+mQ7wTOL/d99NhfeZckKA8pJI6JCOXn9tYfxP?=
 =?iso-8859-2?Q?aQsUjLM/NBZgPovA9sEicRKxeO1eWs7F44OPEr84RstPxdscZF5cZLTzOY?=
 =?iso-8859-2?Q?6Q7GXvLYKVzLs+DzceJmgE3L2qXrK6Sy+Et8Huf7Kxs+q+s+Ok7DG7QJOb?=
 =?iso-8859-2?Q?uMrkP/J3rdCxSGZUf+m+WV1Z5z2TCfr/oP3R8qiXwPH2yiRLzfDdjltFOi?=
 =?iso-8859-2?Q?wI0jRfsC9iQh3MrTfx7YOzTadzKd2Oqpyl75898IeRuu15Oo6KM7dDJRTO?=
 =?iso-8859-2?Q?6M2h50MsBUcXtZ4oA2KcwvNzdjiXpTMv70lcYh8udBY+oSBR+em5XWDzVm?=
 =?iso-8859-2?Q?AC6lUkfIwkTv9T8fPu7ka1aK4fGAy1CWXKnqS6GAAeogxugs7kHiqkF/cd?=
 =?iso-8859-2?Q?3ZZEdcD9UwO+hmHijT3byvQqlzaWWPzyNJDtDv7nMuiuSLrKGnpl7VPoiL?=
 =?iso-8859-2?Q?vNqsxa00k9RtejIPnUVzpBikTFXEJMADbvWAKgZY519P/L0Qemqu3KZHO7?=
 =?iso-8859-2?Q?hNUVGCLpTg9qc7IJgeOXe8B2E/hGUxZoi1CMb88V6xCtkradGh5X65wOkO?=
 =?iso-8859-2?Q?eonWzdPt1W7taRLJ+zaOVYpLcR3Entyx8P76C7GGWkS8isAs9vACoiuxNq?=
 =?iso-8859-2?Q?Z9HiP9twEatj6UNtGvserY/VmcVLQMOf4p/nS3TMQzQnKcIVVfweDkv8NV?=
 =?iso-8859-2?Q?HHkBLenh8swA6vhD4qwF0UwQZzXF667ex+1qZw3fFduEjchulr/SLYU30H?=
 =?iso-8859-2?Q?ZAHWuwWjvKHxF5ugHKTmTLVjWGGfYvb9W12fTSSUXgHY8gExZhA1Ti70Gu?=
 =?iso-8859-2?Q?/oKKX2fRzBtl/pN/oFzoHHv1lE9MlSldRhyQwhuR41AvYcTGlyZXLBA/Bl?=
 =?iso-8859-2?Q?C5dK9B+1U0EkNt2yKzz45tCEfwNr4EDjhllowfaePA++FE1q0O2qZ/qh6d?=
 =?iso-8859-2?Q?Vf2G564Ye0BF9V9WUmOxcze9Jh5M0XmhTrdAy5K1y8Nfb2ybFb0w2UFAZe?=
 =?iso-8859-2?Q?AIpmkkebVpz0Wb77iYymvcBmlySEzHeBg7HmDspAL34iiiDtpL9J9sTeGv?=
 =?iso-8859-2?Q?0mE+AYImlmP50ZYyRQNClhgDOK69cr8eS59p8So2OT6gBm639tRGJM/KSo?=
 =?iso-8859-2?Q?Ff/F1fSjMKXfdVLY8yfnNCs/KJ5ShgOqBk8xbijUij6frp/uDhZIVLQWfs?=
 =?iso-8859-2?Q?062ER3raGFW+v+aLlVW8hFPnTidVlUGxk7U/ntcRTGkCeUlYZiK/aptIhD?=
 =?iso-8859-2?Q?4znWZs0odXb2C6AE+rZXiuG/fCzu5TqNgyntEIpruZDyolAnmAz0mP4OVs?=
 =?iso-8859-2?Q?utT1KjvRHck1aDTNlsF1rEiTSoKOwWWtRtOyK3TLSnOfy1fgG63uu0Nlo6?=
 =?iso-8859-2?Q?3/dYR3GZfxweOlFdVBgaCRynfoa14MvEVdUREsbswZevG0uhK8isWUfPUL?=
 =?iso-8859-2?Q?INzbHBJ/BpPb6DtsjOWyyXrFgFl+5hNKuC5jeTcfqu4LZPS/siyXniizMP?=
 =?iso-8859-2?Q?d+b37KFuXqWiMI2DZ+oAjr6iufKftWF46v6n0T9FenHK2/LVLF9zKsxPfz?=
 =?iso-8859-2?Q?V/tS2JOvdA/lFTPWzuw=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-ID: <C0DAE4A15655504E913006D746536C9A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81024ba9-6b79-438e-1106-08dcbd6c0335
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2024 20:51:18.7209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aEG348kzVZH1XdueQA4j8kexHKjM1UolEEp4WdZdBmnRMr6i/KI10TRZ6Qlgw+IQZaj7zQFzLfTTp52VrfhHEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3855
X-Proofpoint-GUID: 0364URwxuOPFlVJBWdAAX3OaVeDK06Os
X-Proofpoint-ORIG-GUID: 0364URwxuOPFlVJBWdAAX3OaVeDK06Os
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-15_12,2024-08-15_01,2024-05-17_01

Hi Jens,=20

Please consider pulling the following fix for md-6.11 on top of your=20
block-6.11 branch.=20

This patch fixes a potential data corruption in degraded raid0 array
with slow (WriteMostly) drives. This issue was introduced in upstream=20
6.9 kernel.=20

Thanks,
Song



The following changes since commit 7db4042336580dfd75cb5faa82c12cd51098c90b=
:

  s390/dasd: fix error recovery leading to data corruption on ESE devices (=
2024-08-12 10:31:08 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-6.11-=
20240815

for you to fetch changes up to c916ca35308d3187c9928664f9be249b22a3a701:

  md/raid1: Fix data corruption for degraded array with slow disk (2024-08-=
15 13:38:17 -0700)

----------------------------------------------------------------
Yu Kuai (1):
      md/raid1: Fix data corruption for degraded array with slow disk

 drivers/md/raid1.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)=
