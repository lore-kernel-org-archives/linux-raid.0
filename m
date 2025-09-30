Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE59223507C;
	Tue, 30 Sep 2025 06:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759213927; cv=fail; b=pIiEYHIdbemJrfZY6k1U87lxTDYAvAXHCqm10O5l0Xjv6oFtNBkyIAja0RHyPW/6m74GKDNmJ0/ANUT3GSmDx7JRdif0dteLRJ2TWEhRhRNes0OXpBru/1s78eqq5nx3CTsVBwBv5vIad53CVzlyrG54rozzGGhotBil7F0OaiM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759213927; c=relaxed/simple;
	bh=OU+haWMh8KkMjFADtTuy93sAkV2sTHopbZzRc7adC/8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PGMz07W/XxahvHawR2ImXwABmvg3C43coKLe3D+g5lysCaaOybS7ULf7m5L3sxe6Q8IZY9NKUZLtIoFl0mdkVoPdrnXO1VRDsfAsIhbFS2sxITDaIX8C661etlC1sFemvl5N+myFz1CJdZN0ccUgwIKtHeoCnNJUfXHjD/fWN3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=g+1S1M2V; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ZoEjI6sf; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="g+1S1M2V";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ZoEjI6sf"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1759213926; x=1790749926;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OU+haWMh8KkMjFADtTuy93sAkV2sTHopbZzRc7adC/8=;
  b=g+1S1M2VcvWbF+7yYkFFRvBC2SM0T9GneZ6lw6xzsDvPQ6/S/hqyu7Fb
   7xHvJTm+/p5DnEMKQ7oxFLcYaAcEfbDVgXooqaGgslcloZa02tPhpF2ip
   JAa69mhB/IMXlUsCKmKfBgWb+WE3VwNw63YuLDC7QZHLg+LO5ZylszU/s
   RytAiYks+LGaSZis2wi4QOE4tScehOCzzOl/viORkjYiDcR0s+tygMfcg
   7LypOeHwu14c0cR3I89Ye8JzR/oeXrxN9WRH/3JPHMdBeEEgIkqsTDaYu
   //tSP6lhKylxPQb9gi6LnevbB/qpEwR4xHF1OMeEZg+rj16ZDTwMppsPI
   w==;
X-CSE-ConnectionGUID: oPqCOeezQtao5I4kGU/kaw==
X-CSE-MsgGUID: SKwzlX9ZQzOy4VLEODFfXg==
X-IronPort-AV: E=Sophos;i="6.18,303,1751212800"; 
   d="scan'208";a="133134695"
Received: from mail-westcentralusazon11010050.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.50])
  by ob1.hgst.iphmx.com with ESMTP; 30 Sep 2025 14:32:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rXB8bsM8coSKNTgn2mQl97ZzJpfZJROUONFAuKWnp+afx2xeLB2lmDTE4jB/jPinQpF7b9QrbOuyvVujkGZMyagNCHjoUHacqO9iOFBPBnXLkpJQ+JuT3lp+bL/pAyFbXwDvFs4PsC5cHVSqaJVaERunGiBTVr6zMhOtXA6gcPPX8qOYkTkiL/rfgwtbNriGakuWH6CyV92S44aDUXH/7irliOnqJK6KaoJkvJblxPnIF2Jn1YLn2BESc1UF/gj8P6ccF0b+bZADUVyoPWON0oyNEd8Xhd8fjUn0W9RNjyrSQl70TeefeY8c2yz1xQQ5Uluau20OjnHlSPto86k4kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OU+haWMh8KkMjFADtTuy93sAkV2sTHopbZzRc7adC/8=;
 b=G/ueyrgFYKSZa1UzBqdZ1083InUTOgOTZu/gFqY4/uGmK0mD+s6NYzI+dikYUkbR78TGbL5JDXJGX7uAvoVtimNHEFicTu6PEr6lmRfbBIQtStGp3Zhf8dJFr5lq7ME2ruyquZGgr9Ss1Iw0b+v7kVjwRKkyVAlu12B6RYueRequdKoINKRhj8CWL8mY96jtUlwSDP9apfeVz9MHqhsN89ypgQgJ2SuE4zrZS3XnQ6N7nW1emDmLOy+CZHnHJrDuEemhYmtUveKi86ASJ8WhTc9870FR61vGy2SBE5q75YmLiaBGUTn+6XEhyDva2t8dPlo50ZT2vUOPpSZU/14xcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OU+haWMh8KkMjFADtTuy93sAkV2sTHopbZzRc7adC/8=;
 b=ZoEjI6sfx/QU3I1D/fWkBzIEyzihvvfJyEBVBCJ+CQJLQXQCTziRPtM61z4tp2SAGalSwS79AF9PYWafgKXmvY+XO1vWDU+HM8ZKXztooGQpIYPbpDNbOtI18UXS+LBPmY+d5ZtRNA85C4B2zFIjExjbbn31pmZt6U3otokPOEA=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by DS1PR04MB9630.namprd04.prod.outlook.com (2603:10b6:8:21f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Tue, 30 Sep
 2025 06:32:03 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%7]) with mapi id 15.20.9160.015; Tue, 30 Sep 2025
 06:32:03 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"yi.zhang@huawei.com" <yi.zhang@huawei.com>, "yukuai3@huawei.com"
	<yukuai3@huawei.com>, "yangerkun@huawei.com" <yangerkun@huawei.com>
Subject: Re: [PATCH blktests] md/004: add unmap write zeroes tests
Thread-Topic: [PATCH blktests] md/004: add unmap write zeroes tests
Thread-Index: AQHcLqwtqqVPOo8UV06/Ioui6pvwZLSqKnSAgADLAICAAFUPgA==
Date: Tue, 30 Sep 2025 06:32:02 +0000
Message-ID: <ektg3t6fc262kiwlzrzy5c6jf5cauprmycvhppmakjzxuan3z6@23thzcgc73rr>
References: <20250926060847.3003653-1-yi.zhang@huaweicloud.com>
 <lkyvsmrsep4dh7tfunhplltezt64g7rvsbjdknhdk27xby7hox@j23hyvhr73m3>
 <f587899a-0064-4ae6-8424-bb01704b582a@huaweicloud.com>
In-Reply-To: <f587899a-0064-4ae6-8424-bb01704b582a@huaweicloud.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|DS1PR04MB9630:EE_
x-ms-office365-filtering-correlation-id: b744219a-ad72-4ea6-8eda-08ddffeb1166
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|19092799006|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?2Vi65c+dfWBbLG2rUBdIoIjbGgH2gSx6WkPG0gMbH7IrTiri4Jb0940QLaxP?=
 =?us-ascii?Q?ZyfM0kwMwb+VXaGc8iO0n7T/JasSkANzimDkzY4XVcR/SB39iAzU5fzXK1T2?=
 =?us-ascii?Q?SelTsl1kswnAwojfahAbU+YvHcwUJwzvZ+YUQMjN4tJHudd4xIUlcd9/mIuC?=
 =?us-ascii?Q?BC0lY3vreZpVBTFYysoZJAT8qNcLsWIECBUQJYHc+z9dwZxSfoV1lYksWtNR?=
 =?us-ascii?Q?5r6kYv79U3/JtZ7hAGmo+ILTP1xRkevdGXt/sybZ5SAP2+09pwSdQWGHyXGz?=
 =?us-ascii?Q?6JkNVkOUNN5yS7hUls4x/hZst31j6cw1Y7EnH1jQgjZF/J5GfNr9A1B7eXnF?=
 =?us-ascii?Q?ynEGywaQxld6xfvd06aekYriXihkWx0l+Tj3yPxQ0VlhCd3LyvgElikDPhal?=
 =?us-ascii?Q?J7zW2RIMFJ9P/5ZatHCYBTpvzvE4dTHH98BhYKLwt04rB6XbrXMTK6BDz2rM?=
 =?us-ascii?Q?NJpETSqR9H7UE/LMLZZQp5OdhIRDCvx2wbwQxU5TLduy7KPt4Px4wyW01bzp?=
 =?us-ascii?Q?8/9NSz5H/5xkVETjBfgMIhBAzDE//IKH2R07lbjFeopyUswmKIri9hzlg7/4?=
 =?us-ascii?Q?BBbX1eMUItS7rflYqq0AgUeNcjoO1K+vPb3W+Nnz1Don/X+OmOYTjcWBV8n8?=
 =?us-ascii?Q?9os+0UcFAWNZjp1GUofMPffEuauLFiALYQYLHLch/6AmCUm6fdz4Y09UgPB+?=
 =?us-ascii?Q?pHRaS5DJ1NzRY4BcgSe7tJZsUW4mSvPTaRw4tNMstm8R+xSz5S0OB6+LEa0F?=
 =?us-ascii?Q?u0jB6wNHEK8WHpccPFj33BEqD3zSawcc0QnEMvDq3pw4yY3FonwvcM+nUjC1?=
 =?us-ascii?Q?RQ9e8X0GDQoXRbcp0pWcpQrfWn5J9m9NDs9ibj5EsB7Jo5Pou7LS1yO7AqHO?=
 =?us-ascii?Q?A08qAArTsakVz7Vx6yCZ3eD9FhiE4G16WFcwE3KnPlaQPtg1vrGU57rLhR15?=
 =?us-ascii?Q?kFvd9z52XDB/imSECfGzwo8gAs8Xm+yArATsFP4VWuJYJ7J05Uo1AdAs6G3U?=
 =?us-ascii?Q?Ko79z7Uu0a0Da8DwTTOC2VXm9OsQB+OlMN7aY9x+vo7pjPIeNgYO4cGALM5P?=
 =?us-ascii?Q?JyX0B++LciJeIoolEvN6GOBGPZB9ag6nTUMqWiZ6Mdoa0MAsUBbW+y9t/b+6?=
 =?us-ascii?Q?ug/OQ/OvQbMiTJlgNelj4s1GwpFTig/sH7ttzEa6tX0uHA3BADCbT9I28wcw?=
 =?us-ascii?Q?9FaTNGQIVn9JmUfZzaYYkkbwhKfVYOqhs6WRTxKe0nxKjY0pILvPFlUqxSGj?=
 =?us-ascii?Q?676MAPIHCKSrxSzz07yzF1Cwe6Lg261N1u8uwMutsyJfo3yRu4R9upo6trQP?=
 =?us-ascii?Q?5mNyxAuCy7VY+GYQJTo70ItVl+2WQukZvlu4wjxLvk1aQH9v6dYXvY7vyvEG?=
 =?us-ascii?Q?gUUXrVRLkrGZ0KjkjKk7ZNMZ/oCUlmlAFPNs8ifFdm4s0UAFYQvl0AnFRbRt?=
 =?us-ascii?Q?MyeEcjL6ZUSvcGRxRCn6lb5j70mEX/02DqoNpu60O8mRGKCVtkANvmrv05Fs?=
 =?us-ascii?Q?oeAtL7d7vKaAe5G/ARK1KM0jRGUbPBAfhxQH?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?1/w6WuQcKba5Y0cPLUFmc/v8odDE3QnCKarBiTWgX111N7dNuKy2WnWkFy0N?=
 =?us-ascii?Q?3sJEY3sHTeet1jHEOYOnu3PRaukkF6kndCX9aUg3abVD1KwemzoGEjH05yQm?=
 =?us-ascii?Q?rbYlFPXwiK9bOalogxTy4uCTK4zW1CtDRexQlRWj3h/ILwB4cKESJoQMbs7x?=
 =?us-ascii?Q?ECSlZkhOKJ2Rd8BdjHT6XFUqsvOZBKBUPhOLIfh8W3KC/icjlweNPYpn1xhr?=
 =?us-ascii?Q?7QGTUBh67ye/cv9Vtj4yqVnZBOtvuMzRSvCDUbrZ9zQWPBuOHhcQ2O26y1yg?=
 =?us-ascii?Q?hHSQGDqVHEP36hbIsvCRAhiv18Uyv0YOh+eDIZPcsvvsgTDRYzhDxw5FGrHv?=
 =?us-ascii?Q?BYZlDjrd/0lR8p6/8VUuzHYe1AG0B+dU2WDpUo3CoByG1aEYN+kKKlpa5wYQ?=
 =?us-ascii?Q?/iz9w+Cb07A4YawT/sf3Hfufrfa+RHTpf7JrSDJQ8GSEOZyI08C6KwOyvqTA?=
 =?us-ascii?Q?lregexo7mEOv2bPTVTQZopiPVxrTjSGRiJ32qiWJlXYJ0h1zCcZogwSsKN6f?=
 =?us-ascii?Q?uiKxoEcNqO7ZdmonK0oxMys7CnsJ1n3+Fy7UTfU7jcmMxAXfV4qjC/C8lqPz?=
 =?us-ascii?Q?n6ABT5sKVgd5XOwDwMHcdcrWWZ8tqwQVsWlhDNi9jlcknaflaMYoOUqsUlz5?=
 =?us-ascii?Q?bJKDI8fxxwmGyPjHiyWn8pS5Bw/iNu9/5jGi15xVFJ7bo8mHp52bKriyQyCM?=
 =?us-ascii?Q?CwvYDWK6vSyscoevq9W0PAtg1SMk5Ly0Qxu19npc2DS1p2gtqEK43Ud+g3H8?=
 =?us-ascii?Q?skhhrKT2IXsECIpAyqLIqfHDvN/wllQ6+XgZKzZ2vgtp0k4UO2OoiBKY1uLM?=
 =?us-ascii?Q?EoFxqJB46N0m/z9k67/lZLgRZDWSYtIy77+mDP5WdpOeZ41Sv/pweLLyflX0?=
 =?us-ascii?Q?7/7cu/YGVPaTqGYaGypz9mtE0JHSTj+WRCIEH3hg3kYQ7GefNwTTeqjajKcu?=
 =?us-ascii?Q?tWo+FdVhw1rm3UxC4v+6WHu/cVzRY/Tfo/xfIw9jtBhsooJRE9HManNe7Hgl?=
 =?us-ascii?Q?bRg+deupBA7H03G10W40QBLKnHWCBaAN2V6UZLHDgNIGVOFVHETgztR6xXFs?=
 =?us-ascii?Q?n7v88dX2kaqJvDv3x+BWpwi6YBhwZPOAx4T9I70yW4vHpdIUnySYWuCH4cTb?=
 =?us-ascii?Q?pNSkxV5ZmxgiG+mhzUCuD6rhyIQLtWK/QvWdmEVwjPow0kD9pDSKXISuzVmR?=
 =?us-ascii?Q?1hxXf0FaqxFYh0/XlCKeYxBkAvNhR/If3trjeb+CtWEp66yfEOav9xWZyr1Z?=
 =?us-ascii?Q?Ymy/WSHxkv7NUw6xE7tLrwma1OR50sdi3E4AOOwE8yU8oDDEbw707FHKiusL?=
 =?us-ascii?Q?FWmK9ooMLYl8V/F5I1QPxcfT8MHa75nhZP/AnhGqJgthA3aypJnpTSPkxetx?=
 =?us-ascii?Q?XZyDoOcT7hcvrtZPyds13PAS24L2oRb5KobbE/dMSEx9Ajbxs0xm6128vE45?=
 =?us-ascii?Q?7Jk7ryNufMmxOXCGjBR1Nn3hynH1dWaMBHUJDb+I3C22zK7cAymAKE0tGd/B?=
 =?us-ascii?Q?/RvfrWycAgSZsJZ/psiWxCQhMtOkEqrG+SaB6EDNdN40A7TroCcGngOYTUIx?=
 =?us-ascii?Q?LkC9R/seIkbg7YFtyDv66lxA9GqGxwInpMEMTnsTatgCe6ls5G3kUfVtjOyt?=
 =?us-ascii?Q?RLA2c0c3we3eEOqbDOK+5ZA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3A053ED4261A304E89C06E7AA28FA46D@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZdB9FuatI8UpU+XHSyi6lO5L1+sjeM8dgr6DwIeuzFenBYHrU7ICx8RgKapiVoMRN07Bl4qGwgEJXIMhwAGbAdVbu+JJb8nGQHgXx0/LvZS41hsAECkwM6X4eKfQtNn2wsJKmC+QoI1Xi2F1sr0gu7Igd/MoP1HZ6lKXQxlm+S2pr21BYTSwHfCY6s9Mzte7mU5DyzXkjoA1i+Qc5w7FYXT6V3cO+cQHhprtKxQVRYBFD2h3fpkU1GW1Lg4PaJCcqgsxPPIk9oG3jtq1QWGu0F4UPUk/880W1wQSmpHcSSlIa5oC7o0mhv5ShXizQywpdF5+Hj7uDWMJrFipoUdHXjyifuCrfvxkyC4d8j6Fc6f5WiyaksmvCpT4c7IWh4clHxHB9UkW3jTQpI5WsxhnbSQQyUOvJSU6O9iFmACrNtdURJVLFfw+8Wxsf3+mwwvAEiX9vsLCnCPTB5dXjNYtZKnJJFl97mX393v0bHSjUGvTk0pHUpBXLqgP50P0/qWuWQz1rgydPSfc4cH2mD0xpYJU6K4RkDgSs0I45MeqHDK/tF0SQRl/oZIbREg1gIXLrEj6UivMID3amYmUT8brZ37LeAVjfiK0YMAkl0q3enknqY+naNVBmDSd1RnJ1tnn
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b744219a-ad72-4ea6-8eda-08ddffeb1166
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2025 06:32:03.0769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R2XsFjDmzDsNqHX83T1iVN/3F61LgwP8h87uhyMMyFERs1wgK2e1iBilc6DQ7SHkpKNiSZrwrx+k+x3+tdOTQX4qVjiQ+9V+re3TkydmuO4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR04MB9630

On Sep 30, 2025 / 09:27, Zhang Yi wrote:
[...]
> Hi Shinichiro, thank you for your review and suggestions. They both looks=
 good
> to me, please apply these changes. Besides, I noticed that I referenced t=
he
> wrong rc file(tests/dm/rc). Please correct it as well. Thank you.

Sure, along with my suggestions and the rc path fix, I applied the patch.
Thanks!=
