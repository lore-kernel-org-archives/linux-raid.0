Received: from mail.justnet.pl (mail.justnet.pl [78.9.185.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95612FC0E
	for <linux-raid@vger.kernel.org>; Thu, 19 Sep 2024 08:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.9.185.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726735587; cv=none; b=QmW4WzAan7krMtvU9Ox9BFFQu/wgmCTk4xDgRjIU4UAShs5714OLYADbecQ9e4vlCpNBHSw2C+c1Jw6fGfkNipolu5zFPTxBP4Jkx5a+RsR7bmNyolWeS4hq4wUdbyoKFVWm69zzrir1Q+vucaWlTPqdpw1Op+f4wGmwUcUCoO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726735587; c=relaxed/simple;
	bh=8HgDf/tCpW4VHTGOWjQ2IIi3Ht2XZQEx5G2QPbHP6fU=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=VufIibq8XRSnohamug1j1l20/1KE3+Dd/c7InSqbzdWzIbch/kenQ3/yADc3vyu7SeJP/n3wxglu8iwexVqNlrPATISeVALJ2DVHmWyGJuPgjUCsg88KvuT7vjUt6Zsyn5hx+2UA2uJXVOWBKMn95ObRpdChc3iYMkf7biaYsfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=justnet.pl; spf=pass smtp.mailfrom=justnet.pl; dkim=pass (2048-bit key) header.d=justnet.pl header.i=@justnet.pl header.b=NFD+D8v3; arc=none smtp.client-ip=78.9.185.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=justnet.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justnet.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justnet.pl header.i=@justnet.pl header.b="NFD+D8v3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=justnet.pl;
	s=dkim; h=In-Reply-To:From:References:Cc:To:Subject:Reply-To:MIME-Version:
	Date:Message-ID:Content-Type:Sender:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pc/dV8NPAeLzrYi0JzoeR1oAzfWchYPBPLrIdjYnJPA=; b=NFD+D8v3zAY2BogZNWPafC0Z5T
	7q1H0hkD2Gu4Sn6iQtH9KzCuhJ/9HIH1orG1yUsLfLRpuSuUqlJD2gxn8+xRMDnMhMkhcfdCRb85/
	PCaE8IJ0oKcIQXszFhoBDDpt+sdgB8X4cqfVtgSo7xBXk9MfgXB4zI1vlZCCZKYjtw/Jmr/seO3jV
	bYHtVXjqtXtH6Gc3EeJXyuHIr/c0iW8hxjhQG4LhX4om7GqMcVbUR+8x0GbZZKHAIFt1nWZT6hZxs
	SibyGubSv8bblP1j42hP6Vx1yLmxbcERRmSWA04/Y4puUblJyWg/XjjognT39UoN1NCm7VLHOSHuF
	5xVEB6ZA==;
Received: from [78.9.185.84] (helo=[192.168.255.66])
	by mail.justnet.pl with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98)
	(envelope-from <adam.niescierowicz@justnet.pl>)
	id 1srCO5-00000005AS1-3jT0;
	Thu, 19 Sep 2024 10:19:44 +0200
Content-Type: multipart/mixed; boundary="------------1Jr4YNf2tscI1VZAZOC30JG9"
Message-ID: <89cde0bc-ebf6-48d6-80da-59d93fb4757f@justnet.pl>
Date: Thu, 19 Sep 2024 10:19:36 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Reply-To: adam.niescierowicz@justnet.pl
Subject: Re: RAID 10 reshape is stuck - please help
To: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>,
 William Morgan <therealbrewer@gmail.com>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid
 <linux-raid@vger.kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
References: <CALc6PW6XU07kE7fyWzCnLXdDWs0UDGF6peg=kxxicATGB73wJw@mail.gmail.com>
 <CALc6PW6XayCCkRHK=okVJs13Vy-XSFjBEixCvSVjYdYy6AK-gA@mail.gmail.com>
 <16a80dd3-6bdb-16bb-ec72-0994a3344a86@huaweicloud.com>
 <CALc6PW4GYKSZmMZwfT8_-rgukoDX3jKSoXZUQm3Mjom9oQTeEA@mail.gmail.com>
 <CALc6PW5OMaU=E72rbL3DEi6O0a_3Ag0z3mnQsVxJ2R7rZM2nPQ@mail.gmail.com>
 <CALc6PW7Rb5nhT8f19nfj3Z+23qJr1ynaiE1b3rwm6=HUBnCrqQ@mail.gmail.com>
 <CALtW_ajc4rx4Xfh4+6EtGLQm82A7upro8wF5y8WuXuHS=KJVEQ@mail.gmail.com>
Content-Language: pl
From: Adam Niescierowicz <adam.niescierowicz@justnet.pl>
Organization: =?UTF-8?Q?Adam_Nie=C5=9Bcierowicz_JustNet?=
In-Reply-To: <CALtW_ajc4rx4Xfh4+6EtGLQm82A7upro8wF5y8WuXuHS=KJVEQ@mail.gmail.com>
X-Spam-Score: -1.0
X-Spam-Level: -

This is a multi-part message in MIME format.
--------------1Jr4YNf2tscI1VZAZOC30JG9
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


W dniu 18.09.2024 o 17:40, Dragan Milivojević pisze:
>> I have noticed a lot of this type of stuff in dmesg, repeating every 5
>> minutes or so:
>>
>> [ 1212.352770] sd 3:0:4:0: [sde] tag#3885 CDB: ATA command pass
>> through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
>> [ 1212.353063] sd 3:0:4:0: [sde] tag#3885 CDB: ATA command pass
>> through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
>> [ 1212.353077] mpt2sas_cm0:     sas_address(0x4433221104000000), phy(4)
>> [ 1212.353084] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), slot(4)
>> [ 1212.353090] mpt2sas_cm0:     handle(0x0015),
>> ioc_status(success)(0x0000), smid(3886)
>> [ 1212.353096] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
>> [ 1212.353101] mpt2sas_cm0:     tag(0), transfer_count(0),
>> sc->result(0x00000002)
>> [ 1212.353105] mpt2sas_cm0:     scsi_status(check condition)(0x02),
>> scsi_state(autosense valid )(0x01)
>> [ 1212.353110] mpt2sas_cm0:     [sense_key,asc,ascq]:
>> [0x01,0x00,0x1d], count(22)
>> [ 1212.353248] sd 3:0:9:0: [sdj] tag#3886 CDB: ATA command pass
> ATA command pass through is usually from smart monitoring tools but
> this looks more like drive resets. Cables maybe?

  We had similar problem with disk reset.

In our situation problem was with power. When array started check or 
rebuild disk power consumption went up and circuit on the board doesn't 
have enough capacity.

-- 
---
Regards,
Adam Nieścierowicz

--------------1Jr4YNf2tscI1VZAZOC30JG9
Content-Type: text/vcard; charset=UTF-8; name="adam_niescierowicz.vcf"
Content-Disposition: attachment; filename="adam_niescierowicz.vcf"
Content-Transfer-Encoding: base64

YmVnaW46dmNhcmQNCmZuO3F1b3RlZC1wcmludGFibGU6QWRhbSBOaWU9QzU9OUJjaWVyb3dp
Y3oNCm47cXVvdGVkLXByaW50YWJsZTpOaWU9QzU9OUJjaWVyb3dpY3o7QWRhbQ0KZW1haWw7
aW50ZXJuZXQ6YWRhbS5uaWVzY2llcm93aWN6QGp1c3RuZXQucGwNCngtbW96aWxsYS1odG1s
OlRSVUUNCnZlcnNpb246Mi4xDQplbmQ6dmNhcmQNCg0K

--------------1Jr4YNf2tscI1VZAZOC30JG9--
