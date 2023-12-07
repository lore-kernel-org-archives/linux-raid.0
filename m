Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="ucNKMb4x"
Received: from esa6.fujitsucc.c3s2.iphmx.com (esa6.fujitsucc.c3s2.iphmx.com [68.232.159.83])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125A810CC
	for <linux-raid@vger.kernel.org>; Thu,  7 Dec 2023 00:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1701939539; x=1733475539;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RKrF3E3wk7Etszf7ZttcQ6YFDfMn+3QLQth62cHDewg=;
  b=ucNKMb4xGH02PU0v/nRI8XDPmBYCmO3UOox5JIf+H+C1eYBK5KJyvdxF
   gekolmbZHC/qdI/63EBh0/TzUVCTwQ3ZrqgylJCw2m5eDEfP/CBAJqNfg
   Yye7ut3R1ySReM7iSMxnc2Fl0iLECyiG533jgjHeq7ngzbuHz/SPV/IlO
   OljZuGXtoXa5f4jN2rWmBGq40B+Q/8c1zKUqp45fe0E3106Rv/tOG8VTR
   +sKmrCbzznqu5LpRyeEugISenvwIyBdRxeelze/hIWoinNhy/dWSsfnFL
   wpOqXM2+uSkpXXiiXaL1cbaSkABWm2/Tp9YFIlMO5ilA5bcJyzuTxBEE0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="104983615"
X-IronPort-AV: E=Sophos;i="6.04,256,1695654000"; 
   d="scan'208";a="104983615"
Received: from mail-tycjpn01lp2169.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.169])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2023 17:58:56 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JGEW1awWDKSkW6YKEA7AtTV7SK2WiUJ3ioahoMsiZLyuC3EPsWHXXN8l9oFTwdbqEyYFddMUdoGvrALvbnmH4KSB6vhjBoxW+YxZcO0HjDj6qihhFPIeqKx6mAKJjimI92/mdzqlSTM0ir9DpEgpHF6TOEEUJUDsf4yli6NIHjvyKmrx3aZU5L5fq/WufU8+adcZV1vhljT6sDQKKMz8Hyn6Uu24VH+upyN5yYnA8V5oknFevIw+9Lf6rWA9ys3bsIdC2kkVrdBFdt+hK1KrlEnjuiaJUcbJJGzA/GV6Witf2XFmgJSx/SOVz875XjkqBbG8wW5ilwvyQLCZMpw+gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DF4iuswm5OF6IvcD2BAVuCDQy2gO0cG4FwD2HVnaaJ4=;
 b=DHe4MmFwT2p5agJIocHMLd/8ahaGs7Yqf+flT9WDCw/qw2g3VTVLX1wYkClMpbWgwbbW92ycs7PBBuSSMHX6ift9TJ9Ormo7rBmLyEFFykIMEA45tBL5g5CNqzD8aoI8FTfDXiZte4N+mcghKyX2YxvlNBGICm1hOwPaz2g6OvPGM2RcOO3GDAGapMBsIO/IwNDPsJ/QSnvd0j91+4PDvU8+lMVLIxEpEwI5KZcXgabHRDC6MATOLwfHZ/t/HhVKBDagEBmjSHsPXXuWPrtLvWpvyepic2Q50A3+kq8DApPNmqRc2456dz7ZRYCOveeu+3m0U+xvmuBGOyrvnolL8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TYXPR01MB1647.jpnprd01.prod.outlook.com (2603:1096:403:11::11)
 by OSZPR01MB7699.jpnprd01.prod.outlook.com (2603:1096:604:1b3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Thu, 7 Dec
 2023 08:58:51 +0000
Received: from TYXPR01MB1647.jpnprd01.prod.outlook.com
 ([fe80::effa:4982:39f9:c842]) by TYXPR01MB1647.jpnprd01.prod.outlook.com
 ([fe80::effa:4982:39f9:c842%6]) with mapi id 15.20.7046.034; Thu, 7 Dec 2023
 08:58:52 +0000
From: "Yuya Fujita (Fujitsu)" <fujita.yuya-00@fujitsu.com>
To: 'Yu Kuai' <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>
CC: "mariusz.tkaczyk@linux.intel.com" <mariusz.tkaczyk@linux.intel.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "yukuai (C)"
	<yukuai3@huawei.com>, "Yuya Fujita (Fujitsu)" <fujita.yuya-00@fujitsu.com>
Subject: RE: [PATCH] md: Do not unlock all_mddevs_lock in md_seq_show()
Thread-Topic: [PATCH] md: Do not unlock all_mddevs_lock in md_seq_show()
Thread-Index: AQHaKB98+LUbn4wOEk6z5CFc4zz6LrCcuDKAgABR04CAAHu2AA==
Date: Thu, 7 Dec 2023 08:58:52 +0000
Message-ID:
 <TYXPR01MB16470185D0441788BE920E35C58BA@TYXPR01MB1647.jpnprd01.prod.outlook.com>
References: <20231206083356.9796-1-fujita.yuya-00@fujitsu.com>
 <CAPhsuW7WE8p+ijAx3rJEeafJV8-EtJ+KOaZayUap0G6JpFpdGg@mail.gmail.com>
 <b705bae8-b0af-eaca-c0ed-7f12891cd962@huaweicloud.com>
In-Reply-To: <b705bae8-b0af-eaca-c0ed-7f12891cd962@huaweicloud.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 =?iso-2022-jp?B?TVNJUF9MYWJlbF9hNzI5NWNjMS1kMjc5LTQyYWMtYWI0ZC0zYjBmNGZl?=
 =?iso-2022-jp?B?Y2UwNTBfQWN0aW9uSWQ9NzNjOTQ3YzctMDdhNC00NzU0LTgxNTgtYzRj?=
 =?iso-2022-jp?B?OGUwNmJmZGVjO01TSVBfTGFiZWxfYTcyOTVjYzEtZDI3OS00MmFjLWFi?=
 =?iso-2022-jp?B?NGQtM2IwZjRmZWNlMDUwX0NvbnRlbnRCaXRzPTA7TVNJUF9MYWJlbF9h?=
 =?iso-2022-jp?B?NzI5NWNjMS1kMjc5LTQyYWMtYWI0ZC0zYjBmNGZlY2UwNTBfRW5hYmxl?=
 =?iso-2022-jp?B?ZD10cnVlO01TSVBfTGFiZWxfYTcyOTVjYzEtZDI3OS00MmFjLWFiNGQt?=
 =?iso-2022-jp?B?M2IwZjRmZWNlMDUwX01ldGhvZD1TdGFuZGFyZDtNU0lQX0xhYmVsX2E3?=
 =?iso-2022-jp?B?Mjk1Y2MxLWQyNzktNDJhYy1hYjRkLTNiMGY0ZmVjZTA1MF9OYW1lPUZV?=
 =?iso-2022-jp?B?SklUU1UtUkVTVFJJQ1RFRBskQiJMJT8lUhsoQjtNU0lQX0xhYmVsX2E3?=
 =?iso-2022-jp?B?Mjk1Y2MxLWQyNzktNDJhYy1hYjRkLTNiMGY0ZmVjZTA1MF9TZXREYXRl?=
 =?iso-2022-jp?B?PTIwMjMtMTItMDdUMDg6NTQ6MjlaO01TSVBfTGFiZWxfYTcyOTVjYzEt?=
 =?iso-2022-jp?B?ZDI3OS00MmFjLWFiNGQtM2IwZjRmZWNlMDUwX1NpdGVJZD1hMTlmMTIx?=
 =?iso-2022-jp?B?ZC04MWUxLTQ4NTgtYTlkOC03MzZlMjY3ZmQ0Yzc7?=
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYXPR01MB1647:EE_|OSZPR01MB7699:EE_
x-ms-office365-filtering-correlation-id: 6b890963-738c-493a-b2c5-08dbf702bc1b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 ebTE6BdxTZ2zulzRiofUtG7AymQkph85SbVhplm4L1V8HnCS9HRlI1jtMX/Piihpgzg982vgtimc39007wJzS5bV2I+45dZb1QvRJMI/EJaGXEMpS1A16ahdbGkAcn2Lc713Smhyhh7RiBKaRjDxzvW/EEF7ODCMNvgbCHLXFlnBIXbFkDPb7hqZyhuObvkdBR0LJI8eLCXVdZdqpLCEokUknEw6wZmGVC/o1D9PPAi8GHumGRJdmfLXMTu6DMUytuK1RyRkhwoWwT5ZZcJ4ZFOXY/7OwDwtUeNP4NfX4evV3/FSSIuf3ncduvOowv5zIJyLjoQh0fi0Xn3ao0bhKcjXF74ED85zkd4+MhQkmKboL3V7ZN/akQ63Shhp1+dnUMw4xaFzaA2ZNzL+b8WpWucCICrAGz3hZFNxAtC+2c05VT37QU2RRKxROGpz5OPsmUiVtH82FpTusNcdYn+vj38iEpHEipehoOvF/AoiM752vDH40ShT40vCPqjAbd9u9IGWDJc6L+Kh5JJJia66Vh+t82bWhG5DYdD+WSAX0nL25SFuf5kUFd4IohCWsDScdVXUplQgfTaMyPw7uKbhPglny6eM+zoiVkdNfAZX+4grkfItJrN30yJOypuuendm0s5c+qMvjYh1lTki2wp/fQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYXPR01MB1647.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(376002)(396003)(366004)(346002)(230922051799003)(451199024)(1590799021)(186009)(64100799003)(1800799012)(52536014)(107886003)(85182001)(41300700001)(9686003)(86362001)(26005)(83380400001)(1580799018)(54906003)(8676002)(316002)(66446008)(64756008)(66946007)(76116006)(7696005)(66556008)(110136005)(8936002)(4326008)(66476007)(71200400001)(38070700009)(6506007)(478600001)(45080400002)(38100700002)(82960400001)(33656002)(122000001)(2906002)(55016003)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?dTcvWW1Tc2Z2dVg3MHl4UHMwMEJXWTJZUFVtSTF0Zy9Xd1lRZ1F0UHIv?=
 =?iso-2022-jp?B?UHE3NjFwSS9ZbHNMTWhreUVmcGd4OEpZZGEzMVVBZ1QwK2RseWduOGZD?=
 =?iso-2022-jp?B?Z25walhnSS84em83bnFvZ2RHUHNFOVcxNmprd2FFTC9VZVFaazNHd3RV?=
 =?iso-2022-jp?B?NTYwSTZyaThhRm05enZyU2t5NENHZ2paRnVpWW9YMHlGVUhpY2hqdUQw?=
 =?iso-2022-jp?B?V25KMUQvVzl0bWxVZHpSdjhYWjY3d1U3UFF3RzFuWHBMQVRrek43MUNi?=
 =?iso-2022-jp?B?UUI4cDJldnhsdjhvZkkzZDZhR1NhN3EyeC9CQlBSakYwdEQwZ3BuVlY5?=
 =?iso-2022-jp?B?Ymw3QkF0ditONDJmWkRBbnMxU1Rsb2NvYUxNSVFpSlRTWEw2ZHpGNFNC?=
 =?iso-2022-jp?B?SWFiUCtxUWJReVAxaXdhVmZHQkNnYXVVcHMvQzdUaDI3VDNEZ3dpcGkw?=
 =?iso-2022-jp?B?NDIxQVVFV1hZTXU0NzlqL0xHM1pYSVZQNEVRMzVoTEJzem9WN093U1Nw?=
 =?iso-2022-jp?B?MnlWc1NhVUdMUWd3ME9ETlZoMlYyMXhpWVFGZnJHWlF2MEF5cGdIeWl2?=
 =?iso-2022-jp?B?UU80dlA4K3N1QmIweERtS0Y0UExrT0YwSVdzbk9wQ2N3OUkxMzRreC9a?=
 =?iso-2022-jp?B?RzVJRmozUlhXQURsVmRCWXY0TkEwd0NqRzZLSXFUcnFsZzNWYm02RFh4?=
 =?iso-2022-jp?B?Q1ZqcXNzY0VJck1Yc0d6L0hHSGMzYXZNeFlrR3VIalcrNmF2a0dOMUVR?=
 =?iso-2022-jp?B?ME85dkVhOThPOWEyZlNHZ0dsZ2JNN3oybndMZ2tmOXhRbUJoUmJlL2lN?=
 =?iso-2022-jp?B?ZHgrY3RqTFJLLzVTMC8rUmNRN1U4dGZBNnA0c2xyMTlTcjNkbkErbUov?=
 =?iso-2022-jp?B?QU84ZjVPSkhzblNNWUJvTzFUdkMvSUZBQ1FSUVMxNy9aWGhBMzZWenZG?=
 =?iso-2022-jp?B?OFphbU1PWUdBMThuU0luOXBSbERxYklocW5PR3lNZEtsWlp0VzV1UU9I?=
 =?iso-2022-jp?B?Q3JqK2wvL29UNWF5cEtNSXJXVTRpdHQvQlJJVUxPU1FjOHNHUDZPR2Vw?=
 =?iso-2022-jp?B?VGhoMkZGaW9ObmRZVUJzeW9ucnNpTEE1cVJmK1dVTXA1a1d6QWFVWHUy?=
 =?iso-2022-jp?B?a2ZEOHdsK2VGeEc4bzcrcjBidjArRHVXRTRNeGtjMWRZNzZ3b0thSTgw?=
 =?iso-2022-jp?B?RWF5NGVpUlBoYzdNeXlYSmg0S0VqVHBGUS9tSzNtMnV5ekNDSjZjQ2xC?=
 =?iso-2022-jp?B?dmJUUVM2SWVqQ0pLRE55c1ZrL25xbTlMUXJxN212OWZxNUV0L0hkNGpQ?=
 =?iso-2022-jp?B?b1NPaUUvTHpIczFqbzQvdzJhREIyTEhiemJ0NitHL0NsOXFpNU9Najdi?=
 =?iso-2022-jp?B?VFEvbE5KV01yZzVtYjg0cGdUQ3Fqam5aUkJGdDhWSnVtQXNleTBVSHZ2?=
 =?iso-2022-jp?B?c0p4N3cyN3I2RlBCUjJuV0xVY0FNczcyQ1F3dUtCTVhSU0RjMllGci85?=
 =?iso-2022-jp?B?LzUrc2RaTU9kcXN1UVl3VHhMNnZQd2VmV3d3S1NmOWhHRmVVNnBFNVpF?=
 =?iso-2022-jp?B?OUIyRzBOTE9YdHNCa1VQT1duU2h5YkNYenRQb2NObUVVTmRYQVc3c2Jw?=
 =?iso-2022-jp?B?U0h0M0VSbm9SeGFhUTV6L1UvdzNja3JMZkt2TTl4SHNzK2wrZTBYdk8x?=
 =?iso-2022-jp?B?d3BsZXcreDB0TExyNWlpM3dvZk11bHV5VDdoVE9YZ1hMc0dNTXVUU0Y0?=
 =?iso-2022-jp?B?S3JwelpUbHZCcDN2clZ6bGxzMTVqRXpiT3JTRDNvRWVPS1VTM1FqZ1h6?=
 =?iso-2022-jp?B?ME9TYlJsd1ArOHN6WmRua3VBZktHR3JVa2NsVHM0c1FrRjM4cU4wRFdX?=
 =?iso-2022-jp?B?dUZtUW5rOWpnRURqYnpyMC9oNDFwdTJ5RkRnWUlVMEllZko4Y0hRTkdh?=
 =?iso-2022-jp?B?cjdLTU9JNytmRTBTNm9seUNwK3FvaCtWWDN0dXZxeVMzNk4xYURxcHll?=
 =?iso-2022-jp?B?WE9xbjd1bTJFQkRSRnk5REN0WG9SWk4rUUJ1TWxjK29aNDZWOTBIaFJz?=
 =?iso-2022-jp?B?OGtvNHlpZDlaaGRsbXE0bXUyVXlBRFhYNHhEakFjaWZjbE8xNG9xZTcx?=
 =?iso-2022-jp?B?dFlUc3dtam9zQzBLZG4vMUNPN2lWcm9xSXdySUd5dUNlNEVzM20yYkpK?=
 =?iso-2022-jp?B?MlFIZlo5ckNCa0VCOWs4b2oyL3RMajloODdUV3VxVmducXZpaVo2YlBu?=
 =?iso-2022-jp?B?R2g1YmVXZjJRZy9iZ21GT2RzaERtQWdkVmdBUmYrVTc1YjdOLzFNOHRF?=
 =?iso-2022-jp?B?NmtwbmlGck8rQ1BYNUt3UjBMdWFEajVMSUE9PQ==?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mZL660Vlcj7S3lpwcX22HZx/WnxDVKMwS68mSZ2TdRg1x2PQMTomJzrxgekdvNGhgjsl7YmF4rjGhdWTYOosYbSVhhPckycdkm4wZRYKj/jy6e5uZTYOaYZYlacLGf8lzIXv6QrtWturqc7xfke8ScqyiQCyQGEPkdWgf/Km7o/wfDCFh+FxcQfebrRMb4KeYTPvDAsUB39/NEncFyxS38gyjvgMA1qQKWXdCIB7awo0JP+Il5AZWLIa+s09wQ1j5y+Uwv9n730pIr2krrDJVo02KFyp6o6uqzDlxIWsjyf21vcAGk0jdJp5b/1LuoT1pJ0KYrR36GPZLGH15OvOvuB7mqDCBH2c6BuLzEJT+DrRON+D71hFKoSEGYPCtZ0GCgsLjIhpymq3D1yd+KsuSJkrMMUI6/4B/KUrijGq4Ep4epBPPpHsQLnl+kQ0S0L8yaOQkI3ZUaosZXXUJHYvHZvFamDUWhH3DrTmMG3Okm3UOT4NXtt/F2yooLMhEpyXnvj4/QNKBDcz7NKMZ23e7JvOD/9c61Y26/yiCbsUrB7bvtg80ytPKIRzAkAdnwPWSDOk4LJPRkU+T3au06uxHJCo5SfqusEd7jT6VJggr86bf2gATEZpBUb7e+SS7L38NJGAp3NnQMbzNZWZ33urzrrzjzJKX+BxKPrTGcgP1Ue+r05oYPfscOdjHs3zbhp2tbLRzKJaZvDTP82z/IudUDeOzwUYLJo9fAeJ/FugPpQkMheLcZEZSo71TwhNi8UC+3+ZenMmBs8G8i1JKFvS3n53ccfC02+nfsJ4M70GPsC2wyvUE1gboN5yD4nqEs6EaiTomx3h6I9iGlYzZLX38dbq283K4K49Egh+N4XRgN7KyFOK0YAq8FIzytsOmMIGNNiMQHP9QwjBM5F6y/RquS9QW/5uchaLjhlbStgmf8o=
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYXPR01MB1647.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b890963-738c-493a-b2c5-08dbf702bc1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2023 08:58:52.0685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vsye0+OEk6htClfaRfuyEE8rN3XKhlw0vc0LZt/3v5S0542otCRNiLBANsbtnL4oQTkW6NdqlGMtMbU5BlUXwDypQposRQ9useN+FecvczM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB7699

Hello,

> I fail to understand what is the problem here if other mddev is deleted
> from the list while all_mddevs_lock is released during md_seq_show(),
> can you explain more?

If the list is deleted in md_seq_show(), it is assumed to reference an inva=
lid=20
pointer when traversing the next list.
While all_mddevs_lock is being released, mddev->lock is being retrieved,
but I am not sure if the list will not be deleted during that time.

The following is an example of a kernel module that deletes a list during .=
show().
Initially, three entries are added to the test_list and the list will be=20
deleted in test_seq_show().
---
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/seq_file.h>
#include <linux/proc_fs.h>

MODULE_LICENSE("GPL v2");
MODULE_DESCRIPTION("an example of deleting list in .show()");

static LIST_HEAD(test_list);

struct test_entry {
	struct list_head list;
	int n;
};

static void test_add(int n) {
	struct test_entry *e =3D kmalloc(sizeof(*e), GFP_KERNEL);
	e->n =3D n;
	list_add(&e->list, &test_list);
	printk(KERN_INFO "add %d to test_list\n", n);
}

static void *test_seq_start(struct seq_file *seq, loff_t *pos) {
	printk(KERN_INFO "seq_list_start() is called.\n");
	return seq_list_start(&test_list, *pos);
}

static void *test_seq_next(struct seq_file *seq, void *v, loff_t *pos) {
	struct test_entry *e =3D list_entry(v, struct test_entry, list);
	printk(KERN_INFO "seq_list_next() is called on list %d\n", e->n );
	return seq_list_next(v, &test_list, pos);
}

static void test_seq_stop(struct seq_file *seq, void *v) {
}

static int test_seq_show(struct seq_file *seq, void *v){
	struct test_entry *e =3D list_entry(v, struct test_entry, list);
	printk(KERN_INFO "test_seq_show() is called on list %d\n", e->n );
	list_del(&e->list);
	printk(KERN_INFO "deleted list %d\n", e->n );
	return 0;
}

static const struct seq_operations test_seq_ops =3D {
	.start  =3D test_seq_start,
	.next   =3D test_seq_next,
	.stop   =3D test_seq_stop,
	.show   =3D test_seq_show,
};

int test_seq_open(struct inode *inode, struct file *file)
{
	struct seq_file *seq;
	int error;

	error =3D seq_open(file, &test_seq_ops);
	if (error)
		return error;

	seq =3D file->private_data;
	return error;
}

static const struct proc_ops test_proc_ops =3D {
	.proc_open	=3D test_seq_open,
	.proc_read	=3D seq_read,
	.proc_lseek	=3D seq_lseek,
	.proc_release	=3D seq_release,
};

static int __init test_init( void ) {
	printk( KERN_INFO "insmod test\n" );
	test_add(1);
	test_add(2);
	test_add(3);
	proc_create("test", S_IRUGO, NULL, &test_proc_ops);
	return 0;
}

static void __exit test_exit( void ) {
	printk( KERN_INFO "rmmod test\n" );
}

module_init( test_init );
module_exit( test_exit );
---


Loading the kernel module and executing "cat /proc/test" results in the fol=
lowing message:
---
Dec 07 16:23:42 localhost-live kernel: insmod test
Dec 07 16:23:42 localhost-live kernel: add 1 to test_list
Dec 07 16:23:42 localhost-live kernel: add 2 to test_list
Dec 07 16:23:42 localhost-live kernel: add 3 to test_list
Dec 07 16:23:43 localhost-live kernel: seq_list_start() is called.
Dec 07 16:23:43 localhost-live kernel: test_seq_show() is called on list 3
Dec 07 16:23:43 localhost-live kernel: deleted list 3
Dec 07 16:23:43 localhost-live kernel: seq_list_next() is called on list 3
Dec 07 16:23:43 localhost-live kernel: general protection fault, probably f=
or non-canonical address 0xdead000000000110: 0000 [#1] PREEMPT SMP NOPTI
Dec 07 16:23:43 localhost-live kernel: CPU: 4 PID: 2511 Comm: cat Tainted: =
G           OE      6.7.0-0.rc4.20231205gtbee0e776.335.vanilla.fc39.x86_64 =
#1
Dec 07 16:23:43 localhost-live kernel: Hardware name: QEMU Standard PC (Q35=
 + ICH9, 2009), BIOS 1.16.2-1.fc38 04/01/2014
Dec 07 16:23:43 localhost-live kernel: RIP: 0010:test_seq_show+0xd/0x70 [ma=
in]
Dec 07 16:23:43 localhost-live kernel: Code: e9 d8 2d b5 e4 0f 1f 84 00 00 =
00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 0f 1f =
44 00 00 53 48 89 f3 <8b> 76 10 48 c7 c7 a0 e0 96 c0 e8 d4 42 85 e4 48 89 d=
f e8 ec 35 ee
Dec 07 16:23:43 localhost-live kernel: RSP: 0018:ffffaa7b43377cf8 EFLAGS: 0=
0010287
Dec 07 16:23:43 localhost-live kernel: RAX: ffffffffc0954060 RBX: dead00000=
0000100 RCX: 0000000000000027
Dec 07 16:23:43 localhost-live kernel: RDX: 0000000000000000 RSI: dead00000=
0000100 RDI: ffff9e0ac15b87f8
Dec 07 16:23:43 localhost-live kernel: RBP: 0000000000000000 R08: 000000000=
0000000 R09: ffffaa7b43377b90
Dec 07 16:23:43 localhost-live kernel: R10: 0000000000000003 R11: ffffffffa=
75463a8 R12: ffffaa7b43377d98
Dec 07 16:23:43 localhost-live kernel: R13: ffffaa7b43377d70 R14: dead00000=
0000100 R15: 0000000000000000
Dec 07 16:23:43 localhost-live kernel: FS:  00007fb3ac908740(0000) GS:ffff9=
e0c31d00000(0000) knlGS:0000000000000000
Dec 07 16:23:43 localhost-live kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000=
0000080050033
Dec 07 16:23:43 localhost-live kernel: CR2: 00007fb3ac8e6000 CR3: 000000013=
0c0c005 CR4: 0000000000770ef0
Dec 07 16:23:43 localhost-live kernel: PKRU: 55555554
Dec 07 16:23:43 localhost-live kernel: Call Trace:
Dec 07 16:23:43 localhost-live kernel:  <TASK>
Dec 07 16:23:43 localhost-live kernel:  ? die_addr+0x36/0x90
Dec 07 16:23:43 localhost-live kernel:  ? exc_general_protection+0x1c5/0x43=
0
Dec 07 16:23:43 localhost-live kernel:  ? asm_exc_general_protection+0x26/0=
x30
Dec 07 16:23:43 localhost-live kernel:  ? __pfx_test_seq_show+0x10/0x10 [ma=
in]
Dec 07 16:23:43 localhost-live kernel:  ? test_seq_show+0xd/0x70 [main]
Dec 07 16:23:43 localhost-live kernel:  seq_read_iter+0x120/0x480
Dec 07 16:23:43 localhost-live kernel:  seq_read+0xd4/0x100
Dec 07 16:23:43 localhost-live kernel:  proc_reg_read+0x5a/0xa0
Dec 07 16:23:43 localhost-live kernel:  vfs_read+0xac/0x320
Dec 07 16:23:43 localhost-live kernel:  ksys_read+0x6f/0xf0
Dec 07 16:23:43 localhost-live kernel:  do_syscall_64+0x61/0xe0
Dec 07 16:23:43 localhost-live kernel:  ? do_user_addr_fault+0x30f/0x660
Dec 07 16:23:43 localhost-live kernel:  ? exc_page_fault+0x7f/0x180
Dec 07 16:23:43 localhost-live kernel:  entry_SYSCALL_64_after_hwframe+0x6e=
/0x76
Dec 07 16:23:43 localhost-live kernel: RIP: 0033:0x7fb3aca13121
Dec 07 16:23:43 localhost-live kernel: Code: 00 48 8b 15 11 fd 0c 00 f7 d8 =
64 89 02 b8 ff ff ff ff eb bd e8 40 ce 01 00 f3 0f 1e fa 80 3d 45 82 0d 00 =
00 74 13 31 c0 0f 05 <48> 3d 00 f0 ff ff 77 4f c3 66 0f 1f 44 00 00 55 48 8=
9 e5 48 83 ec
Dec 07 16:23:43 localhost-live kernel: RSP: 002b:00007ffe7d716738 EFLAGS: 0=
0000246 ORIG_RAX: 0000000000000000
Dec 07 16:23:43 localhost-live kernel: RAX: ffffffffffffffda RBX: 000000000=
0020000 RCX: 00007fb3aca13121
Dec 07 16:23:43 localhost-live kernel: RDX: 0000000000020000 RSI: 00007fb3a=
c8e7000 RDI: 0000000000000003
Dec 07 16:23:43 localhost-live kernel: RBP: 00007ffe7d716760 R08: 00000000f=
fffffff R09: 0000000000000000
Dec 07 16:23:43 localhost-live kernel: R10: 0000000000000022 R11: 000000000=
0000246 R12: 0000000000020000
Dec 07 16:23:43 localhost-live kernel: R13: 00007fb3ac8e7000 R14: 000000000=
0000003 R15: 0000000000000000
Dec 07 16:23:43 localhost-live kernel:  </TASK>
Dec 07 16:23:43 localhost-live kernel: Modules linked in: main(OE) uinput s=
nd_seq_dummy snd_hrtimer nf_conntrack_netbios_ns nf_conntrack_broadcast nft=
_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 =
nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defra=
g_ipv6 nf_defrag_ipv4 rfkill ip_set nf_tables nfnetlink qrtr sunrpc binfmt_=
misc snd_hda_codec_generic ledtrig_audio snd_hda_intel snd_intel_dspcfg snd=
_intel_sdw_acpi snd_hda_codec intel_rapl_msr intel_rapl_common snd_hda_core=
 snd_hwdep kvm_intel snd_seq iTCO_wdt intel_pmc_bxt iTCO_vendor_support snd=
_seq_device kvm raid1 snd_pcm irqbypass rapl pktcdvd snd_timer pcspkr i2c_i=
801 i2c_smbus snd lpc_ich soundcore virtio_balloon joydev loop zram crct10d=
if_pclmul crc32_pclmul crc32c_intel polyval_clmulni polyval_generic ghash_c=
lmulni_intel sha512_ssse3 sha256_ssse3 sha1_ssse3 virtio_scsi virtio_gpu vi=
rtio_net virtio_blk virtio_console virtio_dma_buf net_failover failover ser=
io_raw ip6_tables ip_tables fuse qemu_fw_cfg
Dec 07 16:23:43 localhost-live kernel: ---[ end trace 0000000000000000 ]---
Dec 07 16:23:43 localhost-live kernel: RIP: 0010:test_seq_show+0xd/0x70 [ma=
in]
Dec 07 16:23:43 localhost-live kernel: Code: e9 d8 2d b5 e4 0f 1f 84 00 00 =
00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 0f 1f =
44 00 00 53 48 89 f3 <8b> 76 10 48 c7 c7 a0 e0 96 c0 e8 d4 42 85 e4 48 89 d=
f e8 ec 35 ee
Dec 07 16:23:43 localhost-live kernel: RSP: 0018:ffffaa7b43377cf8 EFLAGS: 0=
0010287
Dec 07 16:23:43 localhost-live kernel: RAX: ffffffffc0954060 RBX: dead00000=
0000100 RCX: 0000000000000027
Dec 07 16:23:43 localhost-live kernel: RDX: 0000000000000000 RSI: dead00000=
0000100 RDI: ffff9e0ac15b87f8
Dec 07 16:23:43 localhost-live kernel: RBP: 0000000000000000 R08: 000000000=
0000000 R09: ffffaa7b43377b90
Dec 07 16:23:43 localhost-live kernel: R10: 0000000000000003 R11: ffffffffa=
75463a8 R12: ffffaa7b43377d98
Dec 07 16:23:43 localhost-live kernel: R13: ffffaa7b43377d70 R14: dead00000=
0000100 R15: 0000000000000000
Dec 07 16:23:43 localhost-live kernel: FS:  00007fb3ac908740(0000) GS:ffff9=
e0c31d00000(0000) knlGS:0000000000000000
Dec 07 16:23:43 localhost-live kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000=
0000080050033
Dec 07 16:23:43 localhost-live kernel: CR2: 00007fb3ac8e6000 CR3: 000000013=
0c0c005 CR4: 0000000000770ef0
Dec 07 16:23:43 localhost-live kernel: PKRU: 55555554
---


I think this happens in the following way.
---
seq_read_iter()
->m->op->show()
  ->test_seq_show()
    ->list_del(&e->list);=20
      //the list is deleted here
->m->op->next()
  ->test_seq_next()
    ->seq_list_next()
      ->lh =3D ((struct list_head *)v)->next;=20
        // The list has been deleted, so ->next points to an invalid pointe=
r
->m->op->show()
  ->test_seq_show()
    // .show() is called again and references the invalid pointer.
---

Therefore, I think the same problem will happen when the list is deleted in=
 md_seq_show().


Best Regards,
Yuya Fujita
