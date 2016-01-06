From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] IMSM: Add support for VMD
Date: Wed, 06 Jan 2016 12:23:31 +1100
Message-ID: <87a8ojxzzg.fsf@notabene.neil.brown.name>
References: <20160105160304.17913.4114.stgit@gklab-154-222.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160105160304.17913.4114.stgit@gklab-154-222.intel.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Jan 06 2016, Pawel Baldysiak wrote:

> The Intel Volume Management Device (VMD) is an integrated
> endpoint on the platform's PCIe root complex that acts
> as a host bridge to a secondary PCIe domain.
>
> This patch adds proper handling of NVMe devices attached to VMD domain.
> Each VMD domain is treated as a separate controller (HBA).
> Spanning between domains is forbidden.
>
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>

I'm not pretending that I follow what is happening here, but I'll take
your word for it.

applied, thanks.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWjGyTAAoJEDnsnt1WYoG5KU4QALiJBUV+5i6IXff482Bc0dWg
uQJk4YVi5GjOAllLdAuiNhpGdluMIyF1ynmC3qJ1w+AXwpzxBd5cGypL6NTyh7qg
s9Gk9gz/HyEtNlcwRFRyaptpX521zppNUMeByElcWjE3zYaPEVJF42OCJLjV7e1B
sMb6xZbdRYcWOE5M/wpEuKo0dS1NkBIPrEf2QptNxPDVt4HGB57wzFsbL2GIGfME
FrQ7X1Az2id0X2rF57DEawRt+19Ok7RRwyFXgEHnMBrjlnhiJyGsS8LdFMfr4s1m
mxRxar4IvQSfPwEXmGSMKiK2hooAgs+H3zmSsBLLGCRuj70Ui8WutAi+LHzJdf6B
ye04WhAEbcfvfXC8KKhMgAEZS2taRYfHquQPwQTT3zulSugqb2Elk0Uuan62N11V
gvzIWHOgdpuF1j7G3Tw/iRE5CYMP+lMTzaIwRqmGyrD5u4c30b1ewkfsL5qV9cSK
Dt/jMO3mK1pHoqljzQ16s+0At9ErWaFH6IHrBuDK2vI3KONqRI2GnOBIfxtq0IrG
MkKnePauEwTMXHwpst81EkEBPG7rT6zCKx7J5dQ4R/y0tAga0Dm/FFeCwO5iPmlx
LvoB5QY5iYkWPhDEoNPM/fZPBLeUGnqsZQAPk10zioApKwc3Nr71LyGTAUPjz5UJ
+yTeKl/cJ6BOt8VIQbXg
=C2Xd
-----END PGP SIGNATURE-----
--=-=-=--
