Received: from s1.sapience.com (s1.sapience.com [72.84.236.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0667F1A2562;
	Wed, 20 Nov 2024 11:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=72.84.236.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732100668; cv=fail; b=PuXnMvHHl5u8zv1PMV2AZtjCHDgaVyyWIyb2GOwdJknhP7bPI4Ap7GfW8jOFPEJxd+GZyvDOqN3K9AE/nTcfBCOMfHrcbYmu3NW004TkZ8vc8FnpqNBk/h+2P0gYByErtF8HkL3Uijz+2DkE7a4aS4EirCRkBn7/BVrjgCl73ZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732100668; c=relaxed/simple;
	bh=d8Tva37tunzUVXrkergK6kbO7c6e7kSHNNurJrVq/zo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H8qZR+uBXGHFGDdXNffjNUfXh2A/9ISIRBHAhuowlqmokEzo8A7Zru27pAOWUIACgknFP2iRS5KahqrhbjFDqzML2RyQge3UFM4qYyTdQbKkv/RIajfZbSpaj/aqeGoDzp8zOhGqsh3kGh0rip1mjijR6bthFOprNaTerkvfXkg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sapience.com; spf=pass smtp.mailfrom=sapience.com; dkim=permerror (0-bit key) header.d=sapience.com header.i=@sapience.com header.b=+7YZLOA4; dkim=pass (2048-bit key) header.d=sapience.com header.i=@sapience.com header.b=EeQ8xmfA; arc=fail smtp.client-ip=72.84.236.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sapience.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sapience.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=sapience.com header.i=@sapience.com header.b="+7YZLOA4";
	dkim=pass (2048-bit key) header.d=sapience.com header.i=@sapience.com header.b="EeQ8xmfA"
Authentication-Results: dkim-srvy7; dkim=pass (Good ed25519-sha256 
   signature) header.d=sapience.com header.i=@sapience.com 
   header.a=ed25519-sha256; dkim=pass (Good 2048 bit rsa-sha256 signature) 
   header.d=sapience.com header.i=@sapience.com header.a=rsa-sha256
Received: from srv8.sapience.com (srv8.sapience.com [x.x.x.x])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by s1.sapience.com (Postfix) with ESMTPS id C67ED480AB5;
	Wed, 20 Nov 2024 06:04:25 -0500 (EST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=sapience.com;
 i=@sapience.com; q=dns/txt; s=dk-ed25519-220413; t=1732100665;
 h=message-id : subject : from : to : cc : date : in-reply-to :
 references : content-type : mime-version : from;
 bh=zapun0s3m4q12V8nyro11PzJ8BjJUdOqUJswQ7zVZUA=;
 b=+7YZLOA4TRnSHM2MnOWai+a1Jij2LN3KadrQc+ZfatdzCYnOxOBpg8Ny2e2nQOHPSF2pE
 kYIKHwVkWvsDt1FCg==
ARC-Seal: i=1; a=rsa-sha256; d=sapience.com; s=arc6-rsa-220412; t=1732100665;
	cv=none; b=Q94j/SPPdMNajyT1Cgpeu7ZMj1+yHiLeeqjc74L1UbiQ1cjATjDGaICb8eSMwmG/Nd4LhRqG/AwLwEbH1E/2WAtE5k47wv1H4XEbABRGyj1LTSejoU473Bsdjtnjh+w5KMNhONrPoT33A7731qNHnWDupO9G/oZkTQFXlz+1wXMsO159CXp+/QjWCwGlkx1Ae5bIVbA+sR1aKUPVq/9ByIRixfIyLECjl5u5UUuLnVsCSlxKGLWW7ME7pEfTzFfsYqEiLi7XAQLkB2qM5LYb/sTMpXxx8ZoLV5x6BvGvqkWJ0dzs1SiTQfx6amYVMN+Zv3eyq6y6w0KuymhgTnHiUw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=sapience.com; s=arc6-rsa-220412;
	t=1732100665; c=relaxed/simple;
	bh=d8Tva37tunzUVXrkergK6kbO7c6e7kSHNNurJrVq/zo=;
	h=DKIM-Signature:DKIM-Signature:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Autocrypt:Content-Type:User-Agent:
	 MIME-Version; b=Hm86uAoHdP22HhnNg03+4DGnEVjDUg0CPjF2PSFpKPgz0K0Qt2yYQX5OrtPqRsonH0qBT7N2df1hDQZuiP+i96FT9yjZO7P7jZ8PKb8uNZ/acZ81nAsHInFXCQwI+698leWz+iuocrLxa9QirdFXVA260bDWt+IvVXESotrsPLBebClx8xqRUupOOiq4s4CrnFiT0O0hurKEJsGlUX2fC/rr4wUKraYdhQ1C6jAR2bbKN+2X9bVvYSVsoO6AkaZBsawabwWXrQECRUlxoqXW5mVORXn6pGA/VdwVLVVQXdwr3APB0/B3TfcTyCeve17z/epeAcc60XsbQjbON+4APA==
ARC-Authentication-Results: i=1; arc-srv8.sapience.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sapience.com;
 i=@sapience.com; q=dns/txt; s=dk-rsa-220413; t=1732100665;
 h=message-id : subject : from : to : cc : date : in-reply-to :
 references : content-type : mime-version : from;
 bh=zapun0s3m4q12V8nyro11PzJ8BjJUdOqUJswQ7zVZUA=;
 b=EeQ8xmfAQnxkI53HYOz8eUgAZQR/dLJEaII3Q9pJiwEY/i+A6wmIztqFp3Bfxenr73FJv
 vKwj/RNkO4NBivPqTvfEtUcBK/KQVLZFbwbXRFTEJt01g9UNmUODKu/TqLYYOmoXt/JMlh4
 SzqfKpMr2wAjaN88LAfulQa7dpfPKBgX5tr1I27kwq6EITqb219ED2Dx69NhyxFDYTMz4E6
 vN/XTTdLP+OWkNt52GeXv1VI1LtyjgqwuL8RcUbge+41wqk6yiD50GcE9eg2f+T7w3s1PlQ
 1ptwR4JtWN/JZ3TGlTY7Y6VjLsD37m13kQOXcXQqUjL0H67IfuyV77rHdwTQ==
Received: from lap7.sapience.com (lap7w.sapience.com [x.x.x.x])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits))
	(No client certificate requested)
	by srv8.sapience.com (Postfix) with ESMTPS id 8648D280047;
	Wed, 20 Nov 2024 06:04:25 -0500 (EST)
Message-ID: <9ad77de15c483d31ba10b4b7bcf65a9e133f63ae.camel@sapience.com>
Subject: Re: md-raid  6.11.8 page fault oops
From: Genes Lists <lists@sapience.com>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	linux@leemhuis.info
Date: Wed, 20 Nov 2024 06:04:25 -0500
In-Reply-To: <Zz23Z3RK/AHSXY1I@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
References: <0b579808e848171fc64e04f0629e24735d034d32.camel@sapience.com>
	 <34333c67f5490cda041bc0cbe4336b94271d5b49.camel@sapience.com>
	 <Zzx34Mm5K42GWyKj@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
	 <ef8bd4f9308dbf941076b2f7bd8a81590a09aa5e.camel@sapience.com>
	 <Zz23Z3RK/AHSXY1I@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
Autocrypt: addr=lists@sapience.com; prefer-encrypt=mutual;
 keydata=mDMEXSY9GRYJKwYBBAHaRw8BAQdAwzFfmp+m0ldl2vgmbtPC/XN7/k5vscpADq3BmRy5R
 7y0LU1haWwgTGlzdHMgKEwwIDIwMTkwNzEwKSA8bGlzdHNAc2FwaWVuY2UuY29tPoiWBBMWCAA+Ah
 sBBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAFiEE5YMoUxcbEgQOvOMKc+dlCv6PxQAFAmPJfooFCRl
 vRHEACgkQc+dlCv6PxQAc/wEA/Dbmg91DOGXll0OW1GKaZQGQDl7fHibMOKRGC6X/emoA+wQR5FIz
 BnV/PrXbao8LS/h0tSkeXgPsYxrzvfZInIAC
Content-Type: multipart/signed; micalg="pgp-sha384";
	protocol="application/pgp-signature"; boundary="=-WDsWYzT6rEAUh7xf+AYr"
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0


--=-WDsWYzT6rEAUh7xf+AYr
Content-Type: multipart/alternative; boundary="=-vtO7mtNc6IVZEMUQ8cvh"

--=-vtO7mtNc6IVZEMUQ8cvh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2024-11-20 at 15:48 +0530, Ojaswin Mujoo wrote:
>=20
> Got it, I'm still not sure what might be causing this oops. Would you
> happen to a have a reproducer that I can play around with on my
> system?
>=20
> Regards,
> ojaswin
>=20

Sorry, unfortunately I do not have a reproducer otherwise I could
bisect. This system has an rsync backup of about 5 TB twice a day
(receives data over net and writes to local raid disks) - and it
happened during one of them.

gene

--=20
Gene


--=-vtO7mtNc6IVZEMUQ8cvh
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<html><head><style>pre,code,address {
  margin: 0px;
}
h1,h2,h3,h4,h5,h6 {
  margin-top: 0.2em;
  margin-bottom: 0.2em;
}
ol,ul {
  margin-top: 0em;
  margin-bottom: 0em;
}
blockquote {
  margin-top: 0em;
  margin-bottom: 0em;
}
</style></head><body><div>On Wed, 2024-11-20 at 15:48 +0530, Ojaswin Mujoo =
wrote:</div><blockquote type=3D"cite" style=3D"margin:0 0 0 .8ex; border-le=
ft:2px #729fcf solid;padding-left:1ex"><div><br></div><div>Got it, I'm stil=
l not sure what might be causing this oops. Would you<br></div><div>happen =
to a have a reproducer that I can play around with on my system?<br></div><=
div><br></div><div>Regards,<br></div><div>ojaswin<br></div><div><br></div><=
/blockquote><div><br></div><div>Sorry, unfortunately I do not have a reprod=
ucer otherwise I could bisect. This system has an rsync backup of about 5 T=
B twice a day (receives data over net and writes to local raid disks) - and=
 it happened during one of them.</div><div><br></div><div>gene</div><div><b=
r></div><div><span><pre>-- <br></pre><div><span style=3D"background-color: =
inherit;">Gene</span></div><div><br></div></span></div></body></html>

--=-vtO7mtNc6IVZEMUQ8cvh--

--=-WDsWYzT6rEAUh7xf+AYr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYJAB0WIQRByXNdQO2KDRJ2iXo5BdB0L6Ze2wUCZz3COQAKCRA5BdB0L6Ze
2wLlAQD/NbMyLy7/vCkTJQfXuiuvHtzeCgbehKprPc0SXSSNsgD9Hi9/7pzuDeGr
vrYOwdHkl/KMw/gQ4f6+C8UkrlwuPQY=
=u8Ko
-----END PGP SIGNATURE-----

--=-WDsWYzT6rEAUh7xf+AYr--
