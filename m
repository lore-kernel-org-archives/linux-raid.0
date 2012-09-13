From: NeilBrown <neilb@suse.de>
Subject: Re: md: raid5 resync corrects read errors on data block - is this
 correct?
Date: Thu, 13 Sep 2012 10:19:24 +1000
Message-ID: <20120913101924.13431e6e@notabene.brown>
References: <CAGRgLy6Cqxyf2im+tG2JiaQFooLBBzT76hGpfTb47Cr_sFLr6g@mail.gmail.com>
	<20120912082909.33c8eec0@notabene.brown>
	<CAGRgLy6Syso2dfELFhpK9nCyEgvuD6k3F=MRJBnrVU=btKqKVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8x+Wggq8iqhp58BsQbRrZ2Q"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6Syso2dfELFhpK9nCyEgvuD6k3F=MRJBnrVU=btKqKVw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/8x+Wggq8iqhp58BsQbRrZ2Q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Sep 2012 19:49:52 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> I have done some more investigation on that.
>=20
> I see that according to handle_stripe_dirtying(), raid6 always does
> reconstruct-write, while raid5 checks what will be cheaper in terms of
> IOs - read-modify-write or reconstruct-write. For example, for a
> 3-drive raid5, both are the same, so because of:
>=20
> if (rmw < rcw && rmw > 0)
> ... /* this is not picked, because in this case rmw=3D=3Drcw=3D=3D1 */
>=20
> reconstruct-write is always performed for such 3-drvie raid5. Is this cor=
rect?

Yes.=20

>=20
> The issue with doing read-modify-writes is that later we have no
> reliable way to know whether the parity block is correct - when we
> later do reconstruct-write because of a read error, for example. For
> read requests we could have perhaps checked the bitmap, and do
> reconstruct-write if the relevant bit is not set, but for write
> requests the relevant bit will always be set, because it is set when
> the write is started.
>=20
> I tried the following scenario, which showed a data corruption:
> # Create 4-drive raid5 in "--force" mode, so resync starts
> # Write one sector on a stripe that resync has not handled yet. RMW is
> performed, but the parity is incorrect because two other data blocks
> were not taken into account (they contain garbage).
> # Induce a read-error on the sector that I just wrote to
> # Let resync handle this stripe
>=20
> As a result, resync corrects my sector using other two data blocks +
> parity block, which is out of sync. When I read back the sector, data
> is incorrect.
>=20
> I see that I can easily enforce raid5 to always do reconstruct-write,
> the same way like you do for raid6. However, I realize that for
> performance reasons, it is better to do RMW if possible.
>=20
> What do you think about the following rough suggestion: in
> handle_stripe_dirtying() check whether resync is ongoing or should be
> started - using MD_RECOVERY_SYNC, for example. If there is an ongoing
> resync, there is a good reason for that, probably parity on some
> stripes is out of date. So in that case, always force
> reconstruct-write. Otherwise, count what is cheaper like you do now.
> (Can RCW be really cheaper than RMW?)
>=20
> So during resync, array performance will be lower, but we will ensure
> that all stripe-blocks are consistent. What do you think?

I'm fairly sure we used to do that - long long ago. (hunts through git
history...)  No.  The code-fragment was there but it was commented out.

I think it would be good to avoid 'rmw' if the sector offset is less than
recovery_cp.

Care to write a patch?

Thanks,
NeilBrown

--Sig_/8x+Wggq8iqhp58BsQbRrZ2Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFEmjDnsnt1WYoG5AQJbHRAAk2q+dmC9C2l8m46LVruTOqOmOrB/vi9K
tod0Gu54wDh8oVxZFnDjKlVRYnUZ+HKANq+QkG6AgzNWzA5rsIbb9ANl8Yzl2ShG
/Htmt6eLZ7X3fXBq+/bszdBDLbgmH07xw7/NtCTi2BrBg4E30jNZqm56OTf+PP8d
q831+ZXN7mlANZU2C9mZazQVH6FQ2APXr/tN60BvpQ3uWFwtr9XxG5e9V6CeEpMk
XP2XlVYLNVeGMuGlP7DEkxYWk5E+MvZCkZ4qGym/+3RQF4V4qJ1Ys3E+XG4YaVyX
bPJAf8umePd+HY64JUakqJy53kRbXIRgP+r3bwIqo4cI2CDGszXH13QdECfgQnZ+
nsiKNLUTy14kTnqXE2cnJ04ERhShAG0K7WEb9ougR8fYsOyBf+26dXcbZ5C/FP8p
lRqjzld7ifEKRtJmD3G8FLgjkGsccFe00i3SLWLhuTsSCPSCgXaXQ4fMGe5wBTFy
ZnE33qcNB8CLmgxrFP4uk+HvHlGqE5DcfmizoTyFgGVFo1w38TcAaIN9bGTLTZiP
qRqw+IEg2ALbNCoGNA5nC+Fs4dZqcUXQNeItS6PrZWc3r8x0sDdg26xQcgYAOR1u
20Bb4wV8ZJDvLc+ZI/3DApHLL75I/FW8Uw7n4dIw8gc0PQkZM1GmLRA1HtVfCg5S
7JOhqrHGtJA=
=hBom
-----END PGP SIGNATURE-----

--Sig_/8x+Wggq8iqhp58BsQbRrZ2Q--
