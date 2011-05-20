From: Andy Smith <andy@strugglers.net>
Subject: Re: HBA Adaptor advice
Date: Fri, 20 May 2011 20:01:00 +0000
Message-ID: <20110520200100.GF4759@bitfolk.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD65C18.5090804@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="vH3HHxf962mwD/qo"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4DD65C18.5090804@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--vH3HHxf962mwD/qo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Joe,

On Fri, May 20, 2011 at 08:18:32AM -0400, Joe Landman wrote:
>> On 20/05/2011 03:08, Andy Smith wrote:
>>> Are there actually any HBAs that have BBU without using their RAID
>>> features?
>>>
>>> I'd like to stop using hardware RAID but I can't give up the BBU and
>>> write cache.
>
> HBAs don't have BBU or write cache.  Only RAIDs do.  While you can run =
=20
> the RAID in JBOD mode, you effectively lose the cache (and BBU) aspect by=
=20
> doing so.

That's what I thought, thanks.

It's a shame; maybe there will be disks with battery-backed cache
one day.

Cheers,
Andy

--vH3HHxf962mwD/qo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEAREDAAYFAk3WyHwACgkQIJm2TL8VSQvhMQCgrxvve+lFYO7HsXd1SNrkISvT
0UAAoJbgH1Bb+9Ca56GWBF1sZmJA4ZJ6
=yS+8
-----END PGP SIGNATURE-----

--vH3HHxf962mwD/qo--
