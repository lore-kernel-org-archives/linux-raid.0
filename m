Received: from truschnigg.info (truschnigg.info [78.41.115.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1950A2CAB
	for <linux-raid@vger.kernel.org>; Sun, 12 Jan 2025 19:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.41.115.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736711173; cv=none; b=WaEfeGAoL4IdSqtDoJt8625dMJCCl7mpFqpE6FrckTEulnj4GL+vfQmJ8CBPn86T9pXFDuH9qT1sQBYr8gxEjuKj8LyDNmreXGRgPW1PniQ19TWFqk0MnZhrh6tSP+tebcYemZzd7zYBkxE+lvXZNbc767LVtvbXuxM5OQztiYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736711173; c=relaxed/simple;
	bh=3vV3q5yaQJ/Dvlf7Yt9GXYp8h4usFrqaH+3BlfEkCXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XLQwIKy/6qeh+nZCffLj/XNQEVBLFQlaG7gatBGfnufrcJl1HP7j1evG6TU9WU9yu5DhYs4brdObgWT3un2Es9CUI1Nd7u9//mGjxL3Tj0ovqKYje7FcYHL1sMVq+4UgXlFi7NxBu5WupzYNnGq/rqVVfjGv4GfCZNWXJdiKLBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=truschnigg.info; spf=pass smtp.mailfrom=truschnigg.info; dkim=pass (2048-bit key) header.d=truschnigg.info header.i=@truschnigg.info header.b=IGKhXGFN; arc=none smtp.client-ip=78.41.115.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=truschnigg.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=truschnigg.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=truschnigg.info header.i=@truschnigg.info header.b="IGKhXGFN"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=truschnigg.info;
	s=m22; t=1736710735;
	bh=3vV3q5yaQJ/Dvlf7Yt9GXYp8h4usFrqaH+3BlfEkCXc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IGKhXGFNcbGnrXZJz09Ux4xyAZDO52KL6HggGdpGh6LVtvbj+ac1Nz1lV7jq60T4W
	 5InqdVDpO+vkIx00yJfcRaLPKtUCLy9CDmkHDax+qj8c3znLhMHNJqpgM9oi4ri+TU
	 uZRDhwk+4bQLqkfBpDJnfm98pMU1jlOiDXK8Azbh9vssUpCSsTlyVtzu+jS2hHzCiq
	 /bZCRb5WjvDTAMxg7dZY+wRW53wQLlJkPKGgoNAyiwN0hMLJu4XCiNvbn4GK2BblaK
	 UWuRdiBKpCHAgJUtm8YLsXQbUUAVDYMbVHXyaZ/3E88oEIzfzRSHl4ctnyVlkIfKCH
	 7fEgW+x/oD3EQ==
Received: from vault.lan (unknown [IPv6:2a02:1748:fafe:cf3f:1eb7:2cff:fe02:8261])
	by truschnigg.info (Postfix) with ESMTPSA id 8574540350;
	Sun, 12 Jan 2025 19:38:55 +0000 (UTC)
Date: Sun, 12 Jan 2025 20:38:55 +0100
From: Johannes Truschnigg <johannes@truschnigg.info>
To: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>
Cc: linux-raid@vger.kernel.org
Subject: Re: RAID 1 | Extending Logical Volume
Message-ID: <Z4QaT06f3Ieyy4wW@vault.lan>
References: <c8b2fb3b-80c5-464f-aaa7-0883d5689193@peter-speer.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3JHbzQoyHADJBwm8"
Content-Disposition: inline
In-Reply-To: <c8b2fb3b-80c5-464f-aaa7-0883d5689193@peter-speer.de>


--3JHbzQoyHADJBwm8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steffi,

On Sun, Jan 12, 2025 at 08:02:19PM +0100, Stefanie Leisestreichler wrote:
> Hi.
> I have the system layout shown below.
> Can I safely use
>=20
> lvextend -L +50GB /dev/mapper/vg_raid1-root
> and after that
> resize2fs /dev/mapper/vg_raid1-root

The snipped output below seems to suggest that there's two SATA disks that =
are
partitioned with one partition each. These partitions across devices form a
2-leg RAID1 array via md/mdadm.

That RAID1 array itself is in use as a Physival Volume for LVM2, and it hos=
ts
a Volume Group with a Logical Volume at /dev/mapper/vg_raid1-root that you
want to resize.

> [...]

With these assumptions verified, the operation you are about to execute see=
ms
perfectly safe to me. You can even make `lvresize` perform the fs resizing =
for
you, and shorten the whole ordeal to just

  # lvresize --size +50GB --resizefs /dev/mapper/vg_raid1-root

Godspeed, and remember to always keep working backups handy regardless! ;)

--=20
with best regards:
- Johannes Truschnigg ( johannes@truschnigg.info )

www:   https://johannes.truschnigg.info/

--3JHbzQoyHADJBwm8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEGu9IhkI+7/aKLUWF95W3jMsYfLUFAmeEGkwACgkQ95W3jMsY
fLUO1BAAp7bIaw8SDqwSm0sxNs2BReOfo1QI8PkZDJNci+aDXZ/41DxUySiKgMtK
Hykzq/H7KNsWplFRPIxX9f0DaUFVy2pl17/kzq0lnxcXQi55oSJu8i77WbmKMsCM
glsXCCHNyff9tx/bnw0j//xyiPZKpfHH3OrHYZPiLnx/2yqNUgNct0MGv0aIQ2Du
MkFemCKSKVfmmtzbIf/SOAU1GQ/7uh+f/Stg+cDIq6P6IvrEufQWzprofCWkOLiH
wmpWLdPPAs87sUOsJIamFT1G3yy6aodgjfSI91fldTmLawAu77BetjnzOHkBa3gR
kcUkbA4t5l/Y7m8fbPhU2ZoTuBW3uiMxZTig3RQybs93w7qDHUkfbcI0Z5DWtkc2
0dfbX/4ntAxKIwEPfHwsyxXjXkt0JcAlSkxGZ07nuVvzEa2JZU/qDePO92puhY0m
iK2xJ7egcapUumnjwrcz+AFW0aYrJCKrdNuq4UbrWIgmJH9U5Mar+etfhUu3VKRm
X2bnbS/J/6Xd3pXtoBevyRq088u36ZeNjAFPEX+58HNqgOzxCOM4IkWJNMEJP85l
THluCI8uvANKRzJt9efc3n4XObDHW2dkk6JBy2VS+VSNSSD9kKmNZiv7BLRJE7BE
GJJYWy+VlyCKOFoMgBR8Q0cYWT1GWiQorxKI666/Ff1Z6ts+Uqo=
=tVvm
-----END PGP SIGNATURE-----

--3JHbzQoyHADJBwm8--
