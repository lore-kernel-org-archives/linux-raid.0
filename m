Received: from mail.valdk.tel (mail.valdk.tel [185.177.150.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C4010A18
	for <linux-raid@vger.kernel.org>; Sat,  5 Oct 2024 02:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.177.150.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728096967; cv=none; b=GXWi+v3v0jUAI8UXnhkgYoJUADp7AxrXKR3ouIjeWuLOPni+r6WbCwhsWvKe5dwmQ2HkvS53sS/izQbGs/wpJTwsJIipVaVOFLMW7N9Mq03h9kBzE9yUiA7VkXxgMey21U2vH5+nZTi4cdJ+3FGYDubeqtHf3swSDmNWCg5ryVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728096967; c=relaxed/simple;
	bh=kUQQES3HyxhwRh5ldO/6dZk/MNhCsXpJlFs6yLGrNZk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=iTy7zwwhrt03E8teqklInCNb9Y5vs+eyy5Gbs8OgXka+as9vcCo9L9CVhchv1h3dUryavh4Icye+/bFQ2IXYyBTtAzA4HRbeU2h9qxIPy85PvkVZn/sY4fJXSI7Ri7lWE7xnU66Y/kvIs+NCypN+X1U+U/VYTMpn0v/nOJ7AY0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=valdikss.org.ru; spf=pass smtp.mailfrom=valdikss.org.ru; dkim=pass (2048-bit key) header.d=valdikss.org.ru header.i=@valdikss.org.ru header.b=pI8uG6d0; arc=none smtp.client-ip=185.177.150.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=valdikss.org.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=valdikss.org.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=valdikss.org.ru header.i=@valdikss.org.ru header.b="pI8uG6d0"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 3EF6C15F6A47
	for <linux-raid@vger.kernel.org>; Sat,  5 Oct 2024 05:55:59 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=valdikss.org.ru;
	s=msrv; t=1728096960; h=from:subject:date:message-id:to:mime-version:content-type:
	 content-language:in-reply-to:references:autocrypt;
	bh=kUQQES3HyxhwRh5ldO/6dZk/MNhCsXpJlFs6yLGrNZk=;
	b=pI8uG6d04+NMmNoeHfg8wPG/Qe7DveVq5FhydAxsXkRUbln9FioT4msqfUmbgh8c50B3zt
	XrxP4ta0i3hIfJhKm8K9MJNb3ebOkmfhp6mz1mVnFSfqUNMbt8Zv5HaZkeXSf1vZVMmRuc
	XshcvqtmRRxIH+O1jdl/RkyW11uFGtlgjym9P1PiZyxU3324we2ME1oSW98VPKk9ay2E9R
	hKRM2cPUYoC4GqRzPJdKxprkfStmpVjfFlccrdEHNFMyOfT7uue2551HsUFbtMc6UFfPPW
	yUmrsUooFsvtCSBZXeG7We6WRkPOM59kl4ZU52deyQHdiKPiCtQ8fmEED2Nayg==
Message-ID: <e12e1789-5a07-4d42-8f06-afa99d820444@valdikss.org.ru>
Date: Sat, 5 Oct 2024 05:55:50 +0300
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Null dereference in raid10_size, I/O lockup afterwards
From: ValdikSS <iam@valdikss.org.ru>
To: linux-raid@vger.kernel.org
References: <0dd96820-fe52-4841-bc58-dbf14d6bfcc8@valdikss.org.ru>
Content-Language: ru, en-US
Autocrypt: addr=iam@valdikss.org.ru; keydata=
 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
 OEcVmRU/pw5/zoQyQg==
In-Reply-To: <0dd96820-fe52-4841-bc58-dbf14d6bfcc8@valdikss.org.ru>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------aMkwSrZ5FyqG1QIbgc67KcQs"
X-Last-TLS-Session-Version: TLSv1.3

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------aMkwSrZ5FyqG1QIbgc67KcQs
Content-Type: multipart/mixed; boundary="------------YEm0UdIsL2AKLsi78XimMUYB";
 protected-headers="v1"
From: ValdikSS <iam@valdikss.org.ru>
To: linux-raid@vger.kernel.org
Message-ID: <e12e1789-5a07-4d42-8f06-afa99d820444@valdikss.org.ru>
Subject: Re: Null dereference in raid10_size, I/O lockup afterwards
References: <0dd96820-fe52-4841-bc58-dbf14d6bfcc8@valdikss.org.ru>
In-Reply-To: <0dd96820-fe52-4841-bc58-dbf14d6bfcc8@valdikss.org.ru>

--------------YEm0UdIsL2AKLsi78XimMUYB
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDUuMTAuMjAyNCAwNDozNSwgVmFsZGlrU1Mgd3JvdGU6DQo+IEZlZG9yYSAzOSB3aXRo
IDYuMTAuMTEtMTAwLmZjMzkga2VybmVsIGRlcmVmZXJlbmNlcyBOVUxMIGluIHJhaWQxMF9z
aXplIA0KPiBhbmQgbG9ja3MgdXAgd2l0aCAzLWRyaXZlIHJhaWQxMCBjb25maWd1cmF0aW9u
IHVwb24gaXRzIGRlZ3JhZGF0aW9uIGFuZCANCj4gcmVhdHRhY2htZW50Lg0KPiANCj4gSG93
IHRvIHJlcHJvZHVjZToNCj4gDQo+IDEuIEdldCAzIFVTQiBmbGFzaCBkcml2ZXMNCj4gMi4g
bWRhZG0gLS1jcmVhdGUgLWIgaW50ZXJuYWwgLWwgMTAgLW4gMyAteiAxRyAvZGV2L21kMCAv
ZGV2L3NkYSANCj4gL2Rldi9zZGIgL2Rldi9zZGMNCj4gMy4gVW5wbHVnIDIgVVNCIGRyaXZl
cw0KPiA0LiBQbHVnIG9uZSBvZiB0aGUgZHJpdmUgYWdhaW4NCj4gDQo+IEhhcHBlbnMgZXZl
cnkgdGltZSwgZXZlcnkgVVNCIGZsYXNoIHJlYXR0YWNobWVudC4NCg0KUmVwcm9kdWNlZCBv
biA2LjExLjItMjUwLnZhbmlsbGEuZmMzOS54ODZfNjQNCg==

--------------YEm0UdIsL2AKLsi78XimMUYB--

--------------aMkwSrZ5FyqG1QIbgc67KcQs
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEMiogvXcpmS32v71gXNcgLu+I93IFAmcAqrYFAwAAAAAACgkQXNcgLu+I93LF
chAAkNFCCF/OTdT0kVs23AchVv4CMvCuHOmiEyNaorlrXr8zT+yvawZTG5bXw4Fug5Q0Bg4wrY+l
YsqGsLRziQVXcuIZjsVBewlISnvToqL+plCA4ZXvgxcgg3GdQ5kHqPRp6LqLibntcvLMyzLOqS8/
bFWhsmLSag9u1av4MS6dw+okarHDk5F1GnlAmgW6DxaIVnxM3SXVd2XnzoU/p+9qSyDjEyzupjuh
EY/1q2ZNy2BKFPcM5J418gO9tnm0Rut6EuPRrTdqgxK5vZLjNsErpfMQ9HeGpUKY7wb1YlpaEYiJ
dzAXhu7H+8FUNLTzofd3YHVJFnG3x8cUtRqqKNRryr8Q/hw208vpvxVWuhuwIrNWQtJ853Lix6ys
zq3GEqyMvOKSzIBXuoN+bHm4ivKQQsDbl2pzWPqdhPalrAJ72ObDQUiVd25P4HkPl1+xyl/BWOsR
48vAZ+Kiy9RccmCc9Ic7u4MXsSYrNL2/aLO5WKHfnJyRDG7niUtIiKDLoVlQZaXSGaVtn7IJ2nJ6
/ftRqQarD+D8zn681QL7ul9qdjqatPt9AkOzKQW1s5iLj2sAHq9RFIShYPGYYAHNuD1XZrfDS2KT
30b4vO8QNCwkguc3JvWNRznPYfnHECA2cDZJapDC55lTASuNs6hXSbnq1WOzRHQemlc9qQjwelAv
YAQ=
=hAO9
-----END PGP SIGNATURE-----

--------------aMkwSrZ5FyqG1QIbgc67KcQs--
