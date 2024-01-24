Received: from sonic319-27.consmr.mail.bf2.yahoo.com (sonic319-27.consmr.mail.bf2.yahoo.com [74.6.131.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537612566
	for <linux-raid@vger.kernel.org>; Wed, 24 Jan 2024 01:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.6.131.82
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706058002; cv=none; b=aTq3TLL/MeMO4DXJ1Dhuyiym9Q4b4zOZjlweprvNy9ViRb3elFkLHms2c0Szx/8m2XK/9FAn+i5M+eThRLqXiOB55OzVB/4ve9vqSLxTkF01XKY6ODnH12/aJreDng3jyi14/qCsU3abifNuR+eUSFAcY6Zk1dvdj6z/GCfxR78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706058002; c=relaxed/simple;
	bh=RA0XLWsX0uDvEQUaIjClNPDwPzaX0W1iODUnLTBGyhQ=;
	h=Date:From:To:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=jzeu2dbVw04ebp7rxrLTkh292FNglydk380rXpPuDsQnV6RDrTecHuPgowJSSd/8dLz6Tggg5FwE/5Vb9iWLqZwCQG3+uzCzIz00rp+TjoqNWwbbc50gbqtmmGHJ+dfJtt6jYua3/2Ohp72YDYir1wxRdE5LeuUFyxTOTOFj8SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=ZuC77nrd; arc=none smtp.client-ip=74.6.131.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="ZuC77nrd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1706058000; bh=vuYc+TYQeEbQCCZdsWQugYr+c0sESU6QqoBI+H1sj94=; h=Date:From:To:In-Reply-To:References:Subject:From:Subject:Reply-To; b=ZuC77nrdpHP2CkuMxklB/ffUPosE/o+jG8qCPyxvfuEWoVKTtJTj2hhG/mRm1G+Cl5sYk0h+7EEKEI6d7qXS45sdmNtK09YMtSu9XTBIqNl7tFjavWQf+B5x0CgHrxdphafzhYvSiIgBuAtfTrI7wXtWO+koPPncX0zBQbxO/93weWYahAWzYndrTkY9LarQ1wwrKzZ7DvzJOHQwqBugQoZWVCNj881vSIQe6zQ1/2hdp4ixjBNQux3iYGrrM7owk21pTNrmlItZGYQvtU7bQXa7uTB5rZGJ7J4XpbkUvDrznuq5CZ+74/GI4jLY2Vip76lu3YEH8SkbTRxBzdRnjw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1706058000; bh=WI0iFnvo+sbTOoqTN3FkrKcJ0l46rMDjrmVrEhREuaE=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=oD/26jUuaphqKpOoEliOyoX5uGmYQZMBNWh4pnGEDVOTF2ofXbxKNy7z4l4+M/yjkqZU14jEHDwy4wQOecNJ7fjkbhEWYJAIOpMS8gzjeQrz1AFcqkt6/+Fzu776NkgTPxzriRdIZ0o6qfQrdm75prmXj5EydCMc/+DtXyyh3vpZplJb3KPAYIYJ7EEwpAdSnVyuPH6eCx6lowVxtkQKNGUxO3Ga/daPIPmN3MhBwrQ0FQJG6U0V0J7tbbqoDn8K/KqzB57L1qNKO0tU/oEHUR8hNht4m63dbogSd/ht7KrrPdSUR4VnoeHUPb+Z3rG/V00NT2VGNmeNHCJp5pgmfA==
X-YMail-OSG: Au1Pj5YVM1mp2_.BTRjq0M18Kd4Q3fOLeomPDMogCB23L16iDZNuELGgGtGp2tq
 DTR.kcKxmCQieKKseggboH4iQkcF4dKjUJ1K0G5pKSEHBI9BaFwA59.FSngbkp9_p1TDBzE0p3h7
 FIaiYjRAAekM8k5IFQyWXG9oRXXntfkmbN48uVKpL6QOn5TY1NrvKztRTywP1cbZjvBZ8SB9gtbU
 6gmsMmB9_QczuQF8MZ40ZnyiqqRofTD3d8YRsry55BMpM17p2qe.XQx6Jy2uXVzt7D72ivwH6yS2
 Om.ZmdtRsvLT4P3y_GWNSLraNgTrZk4Qi37fJqhy26dTDz4WfZS.2fl5_YP8H9ft0BxQyJAd3WLf
 WNMqny15XImm6Hi4eFVdtF6v397Tunm7OjyLS.VVW4SU2Tnmi2DPbeB33orO7TM_H9BR.RdIGsiq
 xFo48TuXhys9jJyBwxel5CjFrsiRVI1bVR1RrnGNEX6tQamLRA.AFTdLYmR7U4fFFlOXyloHjYrE
 RkjdGMkrAZ_h8Zy9QNbOAopL2KZ09mZT63vujRT2hWNM7HiOEtVF.svk15ey0rcv9pz.8.9yWEuq
 n8w1ijcy9L8QMiv_nos2cz4edISBCDgGok8h.8jJ92CGdSTuJ17G8ar_0sFZ37dOhm8Y6yblkP2p
 XGFl.UQKZb1C_OM9._02XGuVhfRFykian.0AYwEWEy8CnjGEjTRvYVbPP2XTGR.HglxWcr43KCFv
 XnY0J0tVojD1MHVaIS3AoCBkMDZNA2AA52LDRMdFX9NDuBNkcUFlkTgnqv7WMIDxjEDphfWUyGsM
 leXuRYSSR16NZt8IAiCC1SGNzhn89YJPgo6hpHXqqg1Uc4JcUWdZNQVTXz8vpW9f7dEJNg7nJ7sO
 0sb_97AF4Ys4FQSHHAupkBMAPPWNfzXVZ5GmVS6HVFneW1shTVt7xaGLn2iZmQnd3nmhI3vQHFrM
 RqvCMnxEOkFMqor7HhhO.WetwuxdqisQPpH5GexExZYjPd0tAAmaTPKea4HInBX7HfNvvuOBi2tx
 Lereo17L65PBKmQPljcaYwxX0bau2JqR4KEGfzLbs5eeG9qwAVJ99.FEPAOW3OqQQqgjz7pqpGPQ
 xxyq6N9opY8ur1t1ia_DzhFBzZdT5XJ.O_hh67_pIlk5Ee9WHLd6_goHbmuHhtJJJjyTVlcV4.9p
 BXko7V8oHxaQEOZd4XJt8No90DWPgs4UoQxZdO9Dis9CXmvylBxOLMwmAchsN4FXilYSN_ZqDpFw
 s3eQeUSfLIAhAA.LXoPF6S_BCjXuitHcEgi7A2TwIUh595KrioHTuBc9oM932JSiM4cb9DM4S3EV
 goqK4Vpod94Bf5yHk0R25VdtFp6TW.1OdsS5xte2tngmhgGhFbqLLe6qVY3rGFBIb4oMs7.r1ICL
 3MGcdc2BqV_jLzqcvcQ7GJgh0foJYyqD5amx3pxCoibsPoUozC9ASvy8AtgRvn2rxhxLj4.8hTzv
 EIVOGu2o_es6dSkx00ePiiWiTxo3AzuBCWcNj5npM_zOLklQ4ceoFxDceQimFOR_Lw4Xu3lJ9t8S
 46amPj8KacFwLyh8bUhMEav5MN70uqsEbPO9LSOVntLo4S2Elroh218nW7.0SafoRT2kU8AdQJh1
 qT_mQ0ludK..WOy5fb6cfY_swDwOIbpadvyJZ6a7kLivF1rinSRP.V2u21tcYX1cFvCw_oF2bm0i
 QBlhyYlWp1Z2VdcHllGThoF6CSZBtTR8qHuUdcKVE6IiTjp_QqvakaHLTmkj2PuVG5woZT9X2hAZ
 tEAppAEI_fFNUQJwXMgl1Q.3A4kW0xJUXEdkYEDempMt51DKlkIvjX932S2NsOZyOeM97BtxzzVN
 KhOEJpPftEmT0PsW5Qq4oBJ1KmHWC5qnC9N9l1r2ZQpBuV_1M5nyzFpDC_C6Lqh7u7YDdaD0zzay
 VecUAiyAXCH_Yltcv4F6AKdGwiDnNc_58OhjGlWYsKjdvjbocoOOLgPKSgQK0rQi_8TcSlDR3iHl
 aHKJD35Omh9SDDga7DBA8H0TP447DKXCGjVhCdFZTtS39gCpziwoyEu.AtFJBZBsGzUpOaAOHUyA
 85wDo8YaUPA3Dxbd5Ra3DW4GuoE8z74YKKM_bg9NmSNgKI_.1lb9DaaTW7Z5e19BEvpTdezKgynb
 KtX07iXOPkcCus3Zy56Yo2RcWsUgbpyAYMHKq
X-Sonic-MF: <rjm1@yahoo.com>
X-Sonic-ID: 0c8938cb-a4a2-4684-8707-628621ecb518
Received: from sonic.gate.mail.ne1.yahoo.com by sonic319.consmr.mail.bf2.yahoo.com with HTTP; Wed, 24 Jan 2024 01:00:00 +0000
Date: Wed, 24 Jan 2024 00:59:56 +0000 (UTC)
From: RJ Marquette <rjm1@yahoo.com>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Message-ID: <804226557.24031.1706057996425@mail.yahoo.com>
In-Reply-To: <c520a673-9b61-448c-999d-7e1b0b57c098@penguinpee.nl>
References: <432300551.863689.1705953121879.ref@mail.yahoo.com> <432300551.863689.1705953121879@mail.yahoo.com> <04757cef-9edf-449a-93ab-a0534a821dc6@thelounge.net> <1085291040.906901.1705961588972@mail.yahoo.com> <0f28b23e-54f2-49ed-9149-87dbe3cffb30@thelounge.net> <598555968.936049.1705968542252@mail.yahoo.com> <755754794.951974.1705974751281@mail.yahoo.com> <20240123110624.1b625180@firefly> <12445908.1094378.1706026572835@mail.yahoo.com> <c520a673-9b61-448c-999d-7e1b0b57c098@penguinpee.nl>
Subject: Re: Requesting help recovering my array
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.22046 YMailNorrin


That's an interesting theory. I did update Debian a few days ago and hadn't rebooted before the hardware upgrade. So it might not have anything to do with the hardware upgrade. That would make a lot more sense.


When you say manually, is that adding the devices to the conf file then running mdadm --assemble?


Thanks.

--RJ






On Tuesday, January 23, 2024 at 06:00:32 PM EST, Sandro <lists@penguinpee.nl> wrote: 





On 23-01-2024 17:16, RJ Marquette wrote:

> It's like mdadm was assembling them automatically upon bootup, but that
> stopped working with the new motherboard for some reason.


Just a hunch, since you wrote that you updated your system as well:

https://bugzilla.redhat.com/show_bug.cgi?id=2249392

If that's affecting you, `blkid` will be missing some information 
required for RAID assembly during boot. On the other hand, I was able to 
assemble my RAID devices manually.

-- Sandro


