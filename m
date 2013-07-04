From: NeilBrown <neilb@suse.de>
Subject: Re: RAID1 repair GPF crash w/3.10-rc7
Date: Thu, 4 Jul 2013 10:53:37 +1000
Message-ID: <20130704105337.2a06cbfd@notabene.brown>
References: <alpine.DEB.2.02.1307012118450.6694@jlaw-desktop.mno.stratus.com>
	<alpine.DEB.2.02.1307031634440.9749@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SiO9Ewr8XM2BKcOI3fHfCZ+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1307031634440.9749@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/SiO9Ewr8XM2BKcOI3fHfCZ+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 3 Jul 2013 17:49:51 -0400 (EDT) Joe Lawrence
<joe.lawrence@stratus.com> wrote:

> On Mon, 1 Jul 2013, Joe Lawrence wrote:
>=20
> > Hi Kent & Neil,
> >=20
> > I've hit a crash in MD during RAID1 repair while running 3.10-rc7:
> >
> > [ ... snip ... ]
>=20
> Hi Neil,
>=20
> Looking through the MD source, I'm trying to understand part of the
> RAID1 repair path.  I came up with a few questions:
>=20
> 1 - During user initiated RAID1 repair, is the loop at the bottom of
> sync_request(), under the bio_full label, responsible for submitting all
> of the initial read bios?

Yes.

>=20
> 2 - Does process_checks() later find the first uptodate read bio and
> copy its data into the other r1_bio->bios[] for write repair to the
> other disks?

Yes.

>=20
> If both are true, then perhaps the following applies to this crash...
>=20
> Comments in commit f79ea416 "block: Refactor blk_update_request()" msg
> include:
>=20
>     Note that req_bio_endio() now always calls bio_advance() - which
>     means it always loops over the biovec, not just on partial
>     completions.  Don't expect it to affect performance, but worth
>     noting.
>=20
> Now that process_checks() has been further modified for immutable bio
> prep (commit d3b45c2 "raid1: use bio_copy_data()"), it calls
> bio_copy_data() to fill in the write repair bios... which starts
> indexing the bi_bio_vec[] from wherever bi_idx happens to be.
>=20
> If this is indeed the case, I'm having trouble coming up with a good
> solution:
>=20
>   - Immutable bios means drivers don't touch bi_idx.  So MD shouldn't
>     "re-wind" the source bi_idx before calling bio_copy_data().

But MD "owns" this bio.  It knows exactly how it was created, and can do
what ever it likes after it has been returned.

I would propose "bio_rewind" that exactly undoes any "bio_advance".=20
Something like

void bio_rewind(struct bio *bio)
{
	int bytes =3D 0;

	if (bio->bi_idx < bio->bi_vcnt && bio_iovec(bio)->bv_offset > 0) {
		bytes =3D bio_iovec(bio)->bv_offset;
		bio_iovec(bio)->bv_offset -=3D bytes;
		bio_iovec(bio)->bv_len +=3D bytes;
	}
	while (bio->bi_idx) {
		bio->bi_idx -=3D 1;
		bio_iovec(bio)->bv_len +=3D bio_iovec(bio)->bv_offset;
		bio_iovec(bio)->bv_offset =3D 0;
		bytes +=3D bio_iovec(bio)->bv_len;
	}
	bio->bi_size +=3D bytes;
	bio->bi_bi_sector -=3D bytes >> 9;
}

Then call that on pbio at the same place we call bio_reset on sbio.

You could probably also call bio_rewind on sbio, and remove lots of that
code for setting the bio up again.
(or don't bother with bio_rewind, and use the same big lump of code on both
pbio and sbio).

Could you confirm that one of those works?

Thanks.

NeilBrown


--Sig_/SiO9Ewr8XM2BKcOI3fHfCZ+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUdTHkTnsnt1WYoG5AQIhug//ZCwV5Z++dvYD/brDDyHJEEuk7DhKuUBQ
3bMYi/KgaAZ5IdBjF/3UFjZUoUTuDHecYa+6Xb45nFq3s+4mmvog+Atgao77nKJK
0ngbaSjFM2Yp7mIldsF55sGC/pZ/QrmOcIvD3KpwsdYX2yhhJTDpoMaZ9DYAtyvt
5AxfvLa5knB07B2ZVlDxIHjqev7rtVR03IBKSm9NKMCYIyNc7NAuqj3T6JCDO1IL
hMbpMK2DK9Mw8WKYi7uXQJHzhL6oCFVLiMMi1LKUiERzXW4mdhqGXcm9ZQJFCtL8
Qv9yhrrEqRwom4M+/RGTsHZdLTGUJbxT2X9ThjhXRRiZnUojvu5ypBMimLAg6rtI
DMNpY9cCJS9MZ/0/uJc3F0wLSN3c1RgIFGEBxeNTzIIZ/jIDM5p6iOAwiVKm26eA
4Xr6VhODRIqckf5uIltNhwdlPItdVgT6w9GMXL4WNNHKdSPSRc1blpuevvoS7nzK
hCh9fQjU+kVUIE23eDPnl/rp38Tb0yeVcEgNA9HfMsO0TXThrMKIkK1AtHmX0tB+
Fa4hus9DcAEmiTRCNn0QtHIpaEspBubWF/AkzH/Tkfnsgz/XpyMO+KGGKm1o3nao
7j9ds75992BOawUOv+XMhWOAciZzdKxtfd8JrFMMY0TZE3XUYUuKoDC9auYK+MYv
ykSoTX5Jffg=
=N8V3
-----END PGP SIGNATURE-----

--Sig_/SiO9Ewr8XM2BKcOI3fHfCZ+--
