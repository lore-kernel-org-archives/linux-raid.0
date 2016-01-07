From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH] async_tx: use GFP_NOWAIT rather than GFP_IO
Date: Thu, 7 Jan 2016 11:09:11 +0530
Message-ID: <20160107053911.GH11778@localhost>
References: <CAFskJNhmU-N5_odOZV54x10Ku=7SSDnaMz5EtCbKddye+AGReg@mail.gmail.com>
 <87twn928qv.fsf@notabene.neil.brown.name>
 <CAPcyv4im63odabZ_gMF_ESuv=iZ7fyBYqLzXJDPe4cBRwtdG4g@mail.gmail.com>
 <87d1tw23jk.fsf@notabene.neil.brown.name>
 <CAPcyv4g=HBHn3f75gW9JKNdjYEnjxNCYEp3vjJBa_fGm7e+hJw@mail.gmail.com>
 <CAFskJNg9_gJ3HRMqD4N6FSue2R2W3CSz+1KwiZw1Bp6==dOp5A@mail.gmail.com>
 <87wprqxh5f.fsf@notabene.neil.brown.name>
 <CAPcyv4g6ieqx29kPE8ak7Sh2F0ksXEuz-NaYC8tBMW3Ek7ei0Q@mail.gmail.com>
 <20160106090811.GO2940@localhost>
 <87k2nm9rz9.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oC1+HKm2/end4ao3"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87k2nm9rz9.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Stanislav Samsonov <slava@annapurnalabs.com>, linux-raid <linux-raid@vger.kernel.org>, "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>
List-Id: linux-raid.ids


--oC1+HKm2/end4ao3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 07, 2016 at 11:02:34AM +1100, NeilBrown wrote:
>=20
> These async_XX functions are called from md/raid5 in an atomic
> section, between get_cpu() and put_cpu(), so they must not sleep.
> So use GFP_NOWAIT rather than GFP_IO.
>=20
> Dan Williams writes: Longer term async_tx needs to be merged into md
> directly as we can allocate this unmap data statically per-stripe
> rather than per request.
>=20
> Fixed: 7476bd79fc01 ("async_pq: convert to dmaengine_unmap_data")
> Cc: stable@vger.kernel.org (v3.13+)
> Reported-and-tested-by: Stanislav Samsonov <slava@annapurnalabs.com>
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>=20
> Thanks for taking this Vinod.
> It is currently in linux-next from my md tree, but I've just de-staged
> it so the next linux-next won't have it from me.

Okay this is not in dmaengine. But since we all agreed, I have picked and
will send to Linus later today. If anyone has any objections please speak up

Thanks
--=20
~Vinod

--oC1+HKm2/end4ao3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWjfn/AAoJEHwUBw8lI4NHy6MP/A8dNnHU3cUvnT7jAXvgdS9f
zyWwYIug5Wy+wnU9ICgwuNavwIwOYAjLdfrlffcmQtQOW//f1VcvJ1B8fpoMNxrW
xO8NGx5IWSHCp3i4cY5ZBQ1hcgxPTSqmOtABzW3hGr9pQf8pCXkDPAa9sJ8OTF64
FH/tOqzAGEM8z0fIB93VM22CoYu+kQnzhIIjkXeSO+x4N0A2A60p0y3FHAdUOjPl
1tp/xcHnLnICmmeBAsL9j12POZR9tnkONBzGea4qcZfK55hklxslMfcCcZGl1+ys
TKyZbAHaWdWJVREkkV0e+Pk/kwpjePwTBklqa9vcinHwrLKEsGQbI6upaeeJcN5D
945uxDRhc4n1dKSqINflOc5J/6tBBhjZQLTTNseXsoVMDv1yGUNmXDb920iRIWCZ
kohotLMRop8/Ga+sbTvmzqY893I0CMsMg1wjIixnsyeJWi7tOskqZtDylPB1+Kvr
v7dend1wi2uZycbl5OS5a0UQiLF/HhD3yOp9vLkC6/NXKh3aKMpZgkruaTfEPtKw
Imjm3anMsc1j3IROYwviBk9LCpXKuOjxEzoQrJreNblqr36jUtWwxxNiCD8NzaLh
QwM85AXW8/rlPGl+EaCnGFflZDcXnbI05oX+ngn8IiMdNhkfJEYs5hBTvm/6KhGQ
4xyFP8nv3DWbzqeQ0y2K
=I8Nl
-----END PGP SIGNATURE-----

--oC1+HKm2/end4ao3--
