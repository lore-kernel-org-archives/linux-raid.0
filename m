Received: from SY2PR01CU004.outbound.protection.outlook.com (mail-australiaeastazolkn19011059.outbound.protection.outlook.com [52.103.72.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF93D27057D;
	Sat,  4 Apr 2026 07:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.72.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775288787; cv=fail; b=tVUJpm2ftTM2kai6jSz8iCJKj5QuklgveO6P0nmbwuqx+VTKvDNk1265nrWeBpryr9aB8gZrqk9a4wKxTC3phAAkEANeIzbva/YuV48fBRB2P54Pm59uhguN9sYEWXE5YBa8IE6PLm5NVpvvrYGBx6Ym/Aur/i0Z68wq9HYUG9Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775288787; c=relaxed/simple;
	bh=Hf++EhLlmv+2GvsobiZKtOUwC2Tza00UhBa43noutCI=;
	h=From:Date:Subject:Content-Type:Message-ID:To:Cc:MIME-Version; b=pxiNxwviv1+c4MNV6g+5HAdEPQhds+5o2MXfyzF19/zLCVcTLAGNaHTSq0ljMb4oygMk/omwbeeuQFeVrkZfxRTIyMBVOFhvzsFXXR1a6riYllprBLWk/MAWOkO/pNv3OYiQIyl3WFitL6vyLOGrNIZVyq7X8NmImerYEMCgvFg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=Ir3zP/TZ; arc=fail smtp.client-ip=52.103.72.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="Ir3zP/TZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zNJwIB8v4nIo+Ikuqulyw3vOwpJ4NlCbxI6Pn4/O8zp1SrfowtnNiVI2NFbwO0xDgwR9fR43QSCZwcis/wAynAUml7FG5f4u+CTt2g0FL12fT07SrJzkTf4czZkaS6nsJCHXi9zOv5DBNcpVe5AeyQ1sILphQttkB8wR5zzguMbX1iBAxTzp+QGjh3kJlrGvC2YtLENyUsH1dm/NchN2MwdMivvbWcsBgqC5iFDWTs++TOcTUm4ITrptMP3gR0+rAKSHd+9EoOolKyKJ/gtRxQjOnXhnu66OIkG9G5Y4ZvOkMP+GBw9zE5sWGt4EOHGFXwddG8xhTJIzF9SUR6hgbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KhvioE44rMjVUZFfXbEt9U+HOdn9Pp3bYSZXDsGdR/Q=;
 b=yIyor1mmPXB/FTzacGqQlMmTeO7uubNLDIQWHXiQ+brbam9tzDVarmEyk/1X9hBW4tS0h9cpV/eBSPYzxKcnrolpIPXmb1EtqHFaMyu7w3jRNSo4KryIyxPrPNRJd88WLkfdMv0bQrA+JVGwTnnr/BeOSFI9qvn5apxK56GwgD7TbTdIHgSUCNdYt4LrpYYzykZiOBBWojKOsryX3ay6a7Q/1ZRi6KvVvPZfOtEhwB435oMSTBL/l65RUBchmtbUBT2GpQlx3zOb0II9RArbygzPHBlLa4+eP2VH7eUOaudoYDwQoRTM4OP7GgFum+q9Ce3HB9BvL8h3Gt8FaCq/Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KhvioE44rMjVUZFfXbEt9U+HOdn9Pp3bYSZXDsGdR/Q=;
 b=Ir3zP/TZFaZAr/4KDKCaa/zYs0JqN6T05NhKm79dFHa6ejTNe8Pb4Mc7VX9xR80EgkHRtLWPRW4gywm71KFJzfYG9Xb3gpdlrMKHEdrAvnnUXfJd6G95pSLrLqqtc/3PetJEphLR2EIrKeZpZNgRS7r/JMCdGjsJasQ421XD0VVI2e4OjIEjmee4uDhZHiXtmQ5l+wXHxw98GB2OtNYYTlsehwfAqDynbL4CQlw5lmcEXz7GEu/3PxlvzaTMuq77oUNZW1HB82AXuIfj4ZgDDGOyR/KuNhz41RExHX96f7DVwJ5M4FVb3GvgyQvkLCn6T01mmP64y9l8NfLbhfZkpA==
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com (2603:10c6:10:1b0::5)
 by ME3PR01MB8006.ausprd01.prod.outlook.com (2603:10c6:220:193::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Sat, 4 Apr
 2026 07:46:21 +0000
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c]) by SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c%5]) with mapi id 15.20.9769.017; Sat, 4 Apr 2026
 07:46:21 +0000
From: Junrui Luo <moonafterrain@outlook.com>
Date: Sat, 04 Apr 2026 15:44:35 +0800
Subject: [PATCH] md/raid5: validate payload size before accessing journal
 metadata
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID:
 <SYBPR01MB78815E78D829BB86CD7C8015AF5FA@SYBPR01MB7881.ausprd01.prod.outlook.com>
X-B4-Tracking: v=1; b=H4sIAGLB0GkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDEwMT3bTMitRi3dQ0gzRLSwtTYwuTFCWg2oKiVLAEUGl0bG0tAOEWiwl
 XAAAA
X-Change-ID: 20260404-fixes-ef0f9985384d
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, 
 Li Nan <linan122@huawei.com>, Shaohua Li <shli@fb.com>
Cc: Song Liu <songliubraving@fb.com>, linux-raid@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Yuhao Jiang <danisjiang@gmail.com>, 
 stable@vger.kernel.org, Junrui Luo <moonafterrain@outlook.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=5269;
 i=moonafterrain@outlook.com; h=from:subject:message-id;
 bh=Hf++EhLlmv+2GvsobiZKtOUwC2Tza00UhBa43noutCI=;
 b=owJ4nJvAy8zAJVb4wiKgu++DA+NptSSGzAsHkxy471VNiAt3DjI1imjdxnrgwUqu/OdRuzQVf
 n20Pdf+9F5HKQuDGBeDrJgiy/GCS98sfLfobvHZkgwzh5UJZAgDF6cATOSlESPDWSdHfce+Sg+v
 uzl1ook7dXy2hP1btttX7P156yCO7G8RDH84+zd2x6Qoab+ck+QRIl/X0irtb+5apstgEiEt65r
 DwgQAf9JF8Q==
X-Developer-Key: i=moonafterrain@outlook.com; a=openpgp;
 fpr=C770D2F6384DB42DB44CB46371E838508B8EF040
X-ClientProxiedBy: TYCPR01CA0153.jpnprd01.prod.outlook.com
 (2603:1096:400:2b1::12) To SYBPR01MB7881.ausprd01.prod.outlook.com
 (2603:10c6:10:1b0::5)
X-Microsoft-Original-Message-ID:
 <20260404-fixes-v1-1-eee5b704b15e@outlook.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYBPR01MB7881:EE_|ME3PR01MB8006:EE_
X-MS-Office365-Filtering-Correlation-Id: 83a1bda7-139e-4438-ea12-08de921e436b
X-MS-Exchange-SLBlob-MailProps:
	dx7TrgQSB6d5vbofsfC/jnGJ+j4hG4EC3dDR+g1SxAiMVAvS8+LTG6zPIko1D672BdoVBFEXhejTcjCwKyRObsx/I8jU8kY+ljIeHNeNmE+DUE5FB1mnc8TnCJ1XLTmXhSSGCAB6ibAbz510RRo9ftnNs2CNIi9+oR+w1YQzj1v+b4CAPTzs+srB5yWSYfWIUt5EBKf7vySYX//a+Oalmk6Zgnft96v9aMn/AmeUNGHnrqo+0uyW0Me5uzk37AJ4rUCERBxyHKykl0D+vOp9hR+SomBvSBzq+e4oQIjyYLiT10NnxO9tvyuu/wMNLeBcamHFkZL/8+mhtqCOs8R7OKHgoEwzy8vBaSDQ0KJhTHDbcha1X62G1omYcND1gbCyVw0KUYJESsQcsp6EilW39ULAFXHlQHIRVvs3J35ceyv5lQnc4H1M1S4XaYNJeaB1SHcGiZAf7i+/v/wmiSwBz9Zmxa3qXRLC1pzIu9xR53Xj2V4WggPs/hOCLWh4j1x9BGeNEsgXbUEqnMZveX9V1gFWovkg4Fv7YIYBzHydZ3KY6OY/IqDk/CLUej6uafz32fjyzLgTK4GgsC0NJYSpwo9tcmOwg83mGD3dOZA9SlodoncjcT8F2pLBfBXRSbbLtnLq1BRE82AyBpaxzz53QUGydYtGdXk64yWUiGAX1LqKHp7FzcgDU1UN4liItifZCQpst5aQK220mNJr6unaeYbWHEirjeU0KuD1QExX0ur+P8SVaLgv4d1fGP/AYeHaD0PTrXcJu6w=
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|15080799012|23021999003|41001999006|8060799015|461199028|6090799003|5072599009|5062599005|19110799012|24121999003|22091999003|440099028|3412199025|26121999003|40105399003|53005399003|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UXd0SWRtU3BEZ0FFcW9heWUrNzdmV0RiMFozMFl0ZUZEcHFmemJjdlN5SGx3?=
 =?utf-8?B?RWJOMk9SWGgwc2NIcVhIWW8rSk9vMnRGb1lsUlFUNit0amgxVnhkZHZiZWlG?=
 =?utf-8?B?QnRsUzhzWTN1ZENWeElmbFUwcG05Ukt0OUc4SFM3TG01THhpTGg2ZUZQZzdv?=
 =?utf-8?B?Ync5c0M1WjNWcFdmUGkvYUcyTUZINlBtS3ZXeU1kRG5SdFZRYmhoZUdtdkZK?=
 =?utf-8?B?L2kvdGIxR0YxVkN6anBaQ0NnbTV0cnBreXd0MWhQSnlocGdRVFpMZU02andp?=
 =?utf-8?B?US9kWndXUllJLzExRkp0eUw1OEl2dStYc2E2SGRoZkZEdlJYRmxjVFAwM2ZX?=
 =?utf-8?B?VXo3S1E3WndCZzNqUDdUSG4wZmlFS0xWUy9Dd256a1BYbzdMUmptN0NQaHN5?=
 =?utf-8?B?V3grQSt4YVFQcitKN3c0bzIyamNRUVhwTUR6MERBZWFpNjFRZTBTNlBJRzVB?=
 =?utf-8?B?REtYSnRGRkgzZjZQNU5YU2xLeG5xSUkybnhPOGdJUFRDRGlPN0diTVl3ejJP?=
 =?utf-8?B?UVlrMzl3Wng0ZnhCSzh4QjFlUkNmNTRUOFA0UWJxVldqT0xsM3NWeUs0am9G?=
 =?utf-8?B?TE5ZREpDWjFlVG9qWmJhTlF1YlVkODUrV1VNRlpzY1BBSXRHcU1sOUNEZXVV?=
 =?utf-8?B?bFN0U3V1NGJ5dktNK08wQSttV0pDL1dCYXY4c0sxTzAxWjY2ZTVFbUpvOEQv?=
 =?utf-8?B?S1lEUTlXZ3YrdE5Pb0N2RGl6L2dzc0JjaHJUckFSM1pHTHQ2amtOeDgvVEpE?=
 =?utf-8?B?Ui9PWU40b3lwTkNHaVo3bzNtd3pzUjFDZmZhMEVXTnlJTkNXZERRLzl0alJH?=
 =?utf-8?B?TnlwY2xqSU9CZGNPUU5ueTMzS1htcGNYN21EUEE5SlozUEl1ZUdaN0xGZThC?=
 =?utf-8?B?b1dLaHFOQVV6aW1wQjZ1ZDFUT3hVZkpCU3gxeGRZZGM4M0R0dEtGbzlabG9N?=
 =?utf-8?B?M1U4SVVKMXg3dzNod3VpL2lrYmdyakdQUitVTUxZb1BMSTBDOGVSaFA5ZmVj?=
 =?utf-8?B?QytpMTFycjFyK3F0WUtlNFhoZVZ4TEdyYjN1TmhWajhBRzc0c0xhZVE3SFRm?=
 =?utf-8?B?UXV5NUZzNHJpTXkxSzlyUlNQVVUyR3BEcWhpa2JQSDdqTmo1eERPbHNMZFlw?=
 =?utf-8?B?UGlkakk5K1FTNmYrNmUwZFk3bFFycG5wWFRVTmZOSjlUZ1l6ZDhVN1E2bWpG?=
 =?utf-8?B?a3lrbnk3NU1saVFBL0pUc29hMW1oMVU4VFFLWHRSR0NLdFVlb1pBZkVSb2ZJ?=
 =?utf-8?B?TkJ4M2FmcXovRUp0Qk1Gb1VkbnZXdEI4VVB1bUU0aGhCSnFsZUlCcC9DSjEy?=
 =?utf-8?B?R00rbmkvMHdpbFFtL0dOVHRjZjI1WTJDL2dMYWU1MkVxRWkvMDcvNzFLbE8r?=
 =?utf-8?B?ZDBtak9pcXBhMHV1VlVvcGtEejM4d1hiYURMZDkzbGRWeEhWZnpQRTg1TjF6?=
 =?utf-8?B?NVVlUlQrL3AwT1FnZjI1Z3ZhMmtNRmVkRHJlVGxzR2srUFZTSjhHb2JVYWNi?=
 =?utf-8?Q?6iG8lMGFsE71zfxsk0ZsuJygZ4u?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZkUybHY2aVQ2VkI5aFMrbHV4dW4vSGdXTFBpZTl4cFNWK1Nwa01hKzFSY3hB?=
 =?utf-8?B?UlgzN3Vla0dKbHQ1TmtYWkFYZFMzSm9sUFdJbjlIRVhrcVJwelZEZEhkZGI2?=
 =?utf-8?B?ZkY0SWdEZW1Oa2xQQVJmZlZkZjVaWk1CNzRqRDlybHArbDdHdnBra2hEckFC?=
 =?utf-8?B?dDkyZlp5Wld1bDQwVUFibmdvakFmSjRNSUZJcTc1MHZxZHZSdGUvNlRyRFhD?=
 =?utf-8?B?NVFNUks3OHYybWpMaUFkK0lEUVhEaUhjcnk1YSs4Y2EwY0Vrb2tjaUIyY3Rr?=
 =?utf-8?B?bGppb1RzVW10d292QVFrazZ0VVJ5dWtLYjZhRlFwaXRmWE1BcERNSFF6ZkZ3?=
 =?utf-8?B?enpaMjRzbkZobGd3YTZ4U1VERGVLUy95TVpUR3Fpb0hrL0VMZHhOU1Zzck5P?=
 =?utf-8?B?cXluWHRqMWRxeVN6dzZhYXc4ek1oVjMxbnFyZWI3R3lwTXRWU2N6YlJ6a0RM?=
 =?utf-8?B?TTliY0pFR1JzR0dHc1hEZDcxZ3hQVVpvRENwaUg5dkdDaGZ0WldEekpjTk5a?=
 =?utf-8?B?QysyNWhENFpWbkJpTmk2cS9LdkIxRjNybE82S1Z4YWRjQ25tdGR0TnBaVWkv?=
 =?utf-8?B?Qm1aNGtDY0pLWVM4MlF0WGlQNjhpdVd6elNWdGovUUgyTmowN2tITmZLTld3?=
 =?utf-8?B?aVFWRXQxOUZKOHlSV25iWEY2cm1TREdSZWtISkVUUE5JNEk5N2lkcmlNWjFL?=
 =?utf-8?B?RlkzUlVlQ1lrcmtUZHVYZi9iZWVjQlhqaTdqUWNYY01Ua3dtUCtsVEg3TnpD?=
 =?utf-8?B?eS9aYkNBYlljNFNQZ1o3REVraFZ2Q0tZWGVXclVaNzg3WU5YbXpJQ2d5ZXRo?=
 =?utf-8?B?aTkwL1Fqc1U5Wlh4eWRvZm1vRUQyeEhjNmZLUW1ZNGRrWGRHb1J6YllGOXd3?=
 =?utf-8?B?OFhubldlTmV2Um8xYWxxTHF2NjdlanhUTnNRWDdXbHI2YVpSZCtJUDlUMkZ3?=
 =?utf-8?B?U0pBZjR1eUZLMTJnazMrcDhmSWxhbDlWdnprMzJsUGFUV3FIcFFJRDdCSTdS?=
 =?utf-8?B?bUhDME9oOE5wc2w3b2pBR25NWFBqQ2hZTEM1aXVOTXRjVFYyR2s1cDBncUow?=
 =?utf-8?B?MkdRL0U5aDVWdllubzBGVUdWbHhSUmh3dW9sZlk0TnhzTmhEWCsyNm1nOXFh?=
 =?utf-8?B?a1dhbUNBeW9QRGt5MGgrdUJIZlFnNTNDUEc1Q053aSs1OU85Z1V4dytzc0xj?=
 =?utf-8?B?b1N4ZGxwQ3JEdU55dlZhbEZkUXJvK2w5VVQ1Smkwa2VuQ3Vxa0ZFd1ZwZVhx?=
 =?utf-8?B?T3ZSUklsQnBxeWlIQjA1RnRDem9yVzJTY0JRTnNOVzNndzA0cXhUZkQ3ajc4?=
 =?utf-8?B?UzAxQklxdG5wV0lxL0tFRDBvaFk3alVwSFNsZmdQMnRGek5tQnpST3RIRksy?=
 =?utf-8?B?NjllUFV4ZUw0Y0hVUitBMzQ2bHpDbDN0bXBuTVRuMTgxb1E2UTJDUzhZWFdo?=
 =?utf-8?B?Z05CaFBoZWdWZFh1Tk5pMUxJZTY3YjBXUndWNDQ1MWRJdVV0SGk2VHZxRUc3?=
 =?utf-8?B?QjVjSkdNaUVMckRBWUhEZ3VEUk5aeTRBbHk2T3lYMlpQMzhsK1k2aTl5VGIy?=
 =?utf-8?B?TmQ1YkU2ZXJWTnJObXh1Z2ZlQkM0RVAwL2F4cFZKTHJjaEJ3MVk4d1M3MGFH?=
 =?utf-8?B?OVhKTXMvNGdWanRhdEZkV2pON2E3cjNSMlRzZlM0dWNlMkpzOUhYZHpkLzkx?=
 =?utf-8?B?UkJEVm05VFV4YW9aL1lJTis5S0JSbXJPR0pNQ1NNM1c2RDhtQjFwQURMK3pY?=
 =?utf-8?B?bC8vYkI3TnRkU3cwM3d6cmlXc2YzMUkzM3BsTTFtamMzTVlQWWozNFU5UUR0?=
 =?utf-8?B?bXRGVWVVYTkwZE85YU15YkdhUUEvbEwxWFpocWJFNWRnSmYzb0dWOGhFdi9S?=
 =?utf-8?B?RHFPWDlDVHlLaHg3VzF3M3R0WWFKQ0lBajc0TnJXVjdvTXc9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83a1bda7-139e-4438-ea12-08de921e436b
X-MS-Exchange-CrossTenant-AuthSource: SYBPR01MB7881.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2026 07:46:21.3052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ME3PR01MB8006

r5c_recovery_analyze_meta_block() and
r5l_recovery_verify_data_checksum_for_mb() iterate over payloads in a
journal metadata block using on-disk payload size fields without
validating them against the remaining space in the metadata block.

A corrupted journal contains payload sizes extending beyond the PAGE_SIZE
boundary can cause out-of-bounds reads when accessing payload fields or
computing offsets.

Add bounds validation for each payload type to ensure the full payload
fits within meta_size before processing.

Fixes: b4c625c67362 ("md/r5cache: r5cache recovery: part 1")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
---
 drivers/md/raid5-cache.c | 48 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 66b10cbda96d..7b7546bfa21f 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2002,15 +2002,27 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l_log *log,
 		return -ENOMEM;
 
 	while (mb_offset < le32_to_cpu(mb->meta_size)) {
+		sector_t payload_len;
+
 		payload = (void *)mb + mb_offset;
 		payload_flush = (void *)mb + mb_offset;
 
 		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_DATA) {
+			payload_len = sizeof(struct r5l_payload_data_parity) +
+				(sector_t)sizeof(__le32) *
+				(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
+			if (mb_offset + payload_len > le32_to_cpu(mb->meta_size))
+				goto mismatch;
 			if (r5l_recovery_verify_data_checksum(
 				    log, ctx, page, log_offset,
 				    payload->checksum[0]) < 0)
 				goto mismatch;
 		} else if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_PARITY) {
+			payload_len = sizeof(struct r5l_payload_data_parity) +
+				(sector_t)sizeof(__le32) *
+				(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
+			if (mb_offset + payload_len > le32_to_cpu(mb->meta_size))
+				goto mismatch;
 			if (r5l_recovery_verify_data_checksum(
 				    log, ctx, page, log_offset,
 				    payload->checksum[0]) < 0)
@@ -2023,22 +2035,18 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l_log *log,
 				    payload->checksum[1]) < 0)
 				goto mismatch;
 		} else if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_FLUSH) {
-			/* nothing to do for R5LOG_PAYLOAD_FLUSH here */
+			payload_len = sizeof(struct r5l_payload_flush) +
+				(sector_t)le32_to_cpu(payload_flush->size);
+			if (mb_offset + payload_len > le32_to_cpu(mb->meta_size))
+				goto mismatch;
 		} else /* not R5LOG_PAYLOAD_DATA/PARITY/FLUSH */
 			goto mismatch;
 
-		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_FLUSH) {
-			mb_offset += sizeof(struct r5l_payload_flush) +
-				le32_to_cpu(payload_flush->size);
-		} else {
-			/* DATA or PARITY payload */
+		if (le16_to_cpu(payload->header.type) != R5LOG_PAYLOAD_FLUSH) {
 			log_offset = r5l_ring_add(log, log_offset,
 						  le32_to_cpu(payload->size));
-			mb_offset += sizeof(struct r5l_payload_data_parity) +
-				sizeof(__le32) *
-				(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
 		}
-
+		mb_offset += payload_len;
 	}
 
 	put_page(page);
@@ -2089,6 +2097,7 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 	log_offset = r5l_ring_add(log, ctx->pos, BLOCK_SECTORS);
 
 	while (mb_offset < le32_to_cpu(mb->meta_size)) {
+		sector_t payload_len;
 		int dd;
 
 		payload = (void *)mb + mb_offset;
@@ -2097,6 +2106,12 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_FLUSH) {
 			int i, count;
 
+			payload_len = sizeof(struct r5l_payload_flush) +
+				(sector_t)le32_to_cpu(payload_flush->size);
+			if (mb_offset + payload_len >
+			    le32_to_cpu(mb->meta_size))
+				return -EINVAL;
+
 			count = le32_to_cpu(payload_flush->size) / sizeof(__le64);
 			for (i = 0; i < count; ++i) {
 				stripe_sect = le64_to_cpu(payload_flush->flush_stripes[i]);
@@ -2110,12 +2125,17 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 				}
 			}
 
-			mb_offset += sizeof(struct r5l_payload_flush) +
-				le32_to_cpu(payload_flush->size);
+			mb_offset += payload_len;
 			continue;
 		}
 
 		/* DATA or PARITY payload */
+		payload_len = sizeof(struct r5l_payload_data_parity) +
+			(sector_t)sizeof(__le32) *
+			(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
+		if (mb_offset + payload_len > le32_to_cpu(mb->meta_size))
+			return -EINVAL;
+
 		stripe_sect = (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_DATA) ?
 			raid5_compute_sector(
 				conf, le64_to_cpu(payload->location), 0, &dd,
@@ -2180,9 +2200,7 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 		log_offset = r5l_ring_add(log, log_offset,
 					  le32_to_cpu(payload->size));
 
-		mb_offset += sizeof(struct r5l_payload_data_parity) +
-			sizeof(__le32) *
-			(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
+		mb_offset += payload_len;
 	}
 
 	return 0;

---
base-commit: 7aaa8047eafd0bd628065b15757d9b48c5f9c07d
change-id: 20260404-fixes-ef0f9985384d

Best regards,
-- 
Junrui Luo <moonafterrain@outlook.com>

