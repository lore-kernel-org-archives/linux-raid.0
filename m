From: NeilBrown <neilb@suse.com>
Subject: Re: Soft-Raid 0 Performance | Transfer two Data-Streams (CPU+FPGA) to the same Soft-Raid
Date: Mon, 23 Jan 2017 20:56:59 +1100
Message-ID: <87shoacd5g.fsf@notabene.neil.brown.name>
References: <21298bd64ef0dc83b29bd45362ead46c@sw-optimization.com> <0e04b53af8bdf4f39a08b31ea4499626@sw-optimization.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0e04b53af8bdf4f39a08b31ea4499626@sw-optimization.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Schwarz <eas@sw-optimization.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 18 2017, Eric Schwarz wrote:

> Hello mailing list,
>
> I have got two questions:
>
> 1.) I have set-up a softraid (raid level 0) with mdadm using two M.2=20
> modules. For one module the throughput is ~350MB/s (no mdadm) for two=20
> modules the throughput is ~500MB/s which is less than factor 1,5 of the=20
> throughput of a single drive. The filesystem used is ext4. Is there=20
> someone having some values for comparison? For me the throughput gain=20
> seems to be too little. The test was done using a HP Z840 workstation.

Can you try a range of chunk sizes and see what difference it makes?
RAID0 simply remaps each request to the appropriate target device/offset,
imposing very little direct overhead.  There may be an indirect overhead
as a small chunk size causes large request to be chopped up into smaller
requests first.

>
> 2.) We want to configure a softraid (raid level 0) with mdadm which can=20
> be used from within Linux but also it should be possible to write data=20
> to the raid w/ DMA directly from the FPGA which is also connected to the=
=20
> PCIe bus as a slave as well as the M.2 modules. How can that be achieved=
=20
> using existing kernel infrastructure?

What sort of help do you want from the existing kernel infrastructure.
Presumably your FPGA must already understand RAID0 striping, so you just
need to tell the FPGA what devices, offsets, chunk sizes to use.
I suspect it would be easiest to have a user-space program query the
array and feed data to your FPGA, but as you provide no detail for how
the FPGA would be configured, I'm only guessing.

NeilBrown


>
> Many thanks for helpful replies
> Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAliF02sACgkQOeye3VZi
gbmfMBAAib9e0iJOoRr8291wyt4DJYEynPeDp8OGhmEsq5IIQ/zSVjYvWLQxcuSi
WsCj+yVGXpgxew81n5mcDS5H8SrtaBjDbdYGUt//gZt7CP9rAn8GHlu/86+6iI/G
bRTqLr0ayr2KwTidzZTrq8VS2WxR0HerNcHNZkl7spDWOX4dCUpwS3jLrbkEO042
z5A64s6mNSWulPG9IkrmAon7iIchr0saou1FaNK87HoudPizxG2XEnv2FK/sn1eN
eV0Hu4EWg2znMw39vsExldPrty+jik1m0HALGuVcYkziSZvojm3Uk0uFzWf3tR63
G/hmjCcrFLHB0kB/ZSHSOn6jP2TLm+OQfXC1tZ0GCkzi7jjv3Vh8JqSKfAn2G3+b
jaRqsiUDBMciZWk+lxUhjhcrWawwRw8kDUd19m8Q+C9fQg/6zm32mb4xgqEwP1Jp
FklAo0im/NMx9M/SV/SGjUM7vaBtW3H1HSvm4p7Pi2JiOcXaU1Z/tzsfyAikqBgq
4ymesat+alGhW+oaQxTydBySs2bAlWoig6vVv0LbyzkXNiXAW7iv5sWt8OfsCOhH
43B5JnZ/MJpaj40h0wOoeOj25oEVsG7F3o5chFavZat7y9kWbrKzgES/TobDAQl5
4fBSdmwPQDehhRylVQnkFHOWWJA6gilo785ZsCRrIl4INOELpTE=
=7PYe
-----END PGP SIGNATURE-----
--=-=-=--
