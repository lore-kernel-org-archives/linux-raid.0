From: NeilBrown <neilb@suse.de>
Subject: Re: RAID1 round robin read support in md?
Date: Mon, 5 Dec 2011 16:33:44 +1100
Message-ID: <20111205163344.6957df93@notabene.brown>
References: <CAAs5ODuHAE=K-nbd=YuMq-FL33x-22TM2cnmBHud9mEhwuJFOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HSeU1PfuYqNYJ3nVx=vplP9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAs5ODuHAE=K-nbd=YuMq-FL33x-22TM2cnmBHud9mEhwuJFOw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Borg Onion <borg.onion@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/HSeU1PfuYqNYJ3nVx=vplP9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 4 Dec 2011 15:31:30 -0800 Borg Onion <borg.onion@gmail.com> wrote:

> Hello,
>=20
> Is it possible to implement round-robin read support for raid1.c in
> md?  I sure would appreciate the extra speed given my RAID1x3SSD
> setup.  A possible algorithm might go like this:
>=20
> 1) Given the RAID1 drives are enumerated 0,1,2
> 2) For each read request, call an atomic increment
> 3) mod the returned value with # of drives (3)
> 4) Use the modulus result as the drive # to read from for this operation
>=20
> Part of implementation might look like this:
>=20
> uint32_t get_next_read_drive(uint32_t num_drives)
> {
>         static uint32_t op_count;
>=20
>         return __sync_fetch_and_add(&op_count, 1) % num_drives;
> }
>=20
> I'm making the assumption that the md code is multi-threaded.  This
> implementation won't work on all platforms, others might have to do
> some locking.  The num_drives and drive list enumeration is assumed to
> exclude write-mostly devices.  Temporary balancing fairness errors
> from the num_drives variable changing value (adding or removing of
> drives) should be innocuous given these are just read ops on mirrored
> data.
>=20
> Thoughts?

I would suggest using RAID10 if 'far' mode instead.

Then reads are distributed across all your drives just like with RAID0, and
you get to choose the chunk size for distribution.

NeilBrown

--Sig_/HSeU1PfuYqNYJ3nVx=vplP9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTtxXuDnsnt1WYoG5AQLBbRAAh6rqW3sVIGv2QoPPZFVpSwf1EIm5K5WA
5jUZEfSInU4jDRTZrw+lsv0HNyLBCS9qxLav0U1ZJsc5BRVTnNWouWl0y5g++ddX
NmTOASm9BdQN7EjS94/PFM8//h+495WQKZTfgAkfvsCgKkrTK9oU/Hk4bFsaO8ru
ftqrOuJ2W6QA31YRc8iMIfGfvEAyNrpqY4N5iKpyetHAGdke2jC5juvb5x8tuc8S
xcYjDdg6jDZzv9tfvLOlViNx31Hkp+rZ4nzqboaoh9OVxq3BMmy3g71gLiHEvMWC
DkHeP7ffL7ivinRVm+l7e/3aM3ya8u3XhX2Ci+SsYk49VQ/+GZZ08FpDH1KL6lnO
s5HNWuECvwZKZSAL0KsRJ3L93UMKwcU85NDISBszL+f9aQRV+K+ckX+5a3B5CXaZ
Rqo94kRKGjW/o5NvqQjbU95ZtHbGTZozuEAX+Plu8j4OrfjXt95nBR73a8K7hWu/
tKVvBk48ActULs6DqMrAfYYKWqP+F7J/qghlQYqBvPtlhFowDzIgnQF2utQ5cES/
VHQ3Q+q26totYKlHKDVgXSBQajNgmiMfnfKSgZklvcc1TCItK1iT5aKuSWswB9oH
SWzIlLw90Cq+EbMug311AH0NdXNKz8Lj1H7BJ2applHLhMkbFoRV6isZ3sJhwSHD
nTpS3pmQ8eo=
=oGQq
-----END PGP SIGNATURE-----

--Sig_/HSeU1PfuYqNYJ3nVx=vplP9--
