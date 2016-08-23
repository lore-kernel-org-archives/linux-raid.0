From: Doug Ledford <dledford@redhat.com>
Subject: Re: kernel checksumming performance vs actual raid device performance
Date: Tue, 23 Aug 2016 15:26:41 -0400
Message-ID: <b12e01c4-72c1-1bc1-3662-3b616d510f85@redhat.com>
References: <CAJvUf-C-Nr8sSnSPL-5jt1NLOAiZjhZ=bjDRUbX_RjphRL+yWA@mail.gmail.com>
 <CAFx4rwQj3_JTNiS0zsQjp_sPXWkrp0ggjg_UiR7oJ8u0X9PQVA@mail.gmail.com>
 <CAJvUf-Dqesy2TJX7W-bPakzeDcOoNy0VoSWWM06rKMYMhyhY7g@mail.gmail.com>
 <CAFx4rwSQQuqeCFm+60+Gm75D49tg+mVjU=BnQSZThdE7E6KqPQ@mail.gmail.com>
 <CAJvUf-BoEJte8TF7_Su90CnjAiJ6q57m+PdGhxHA4cx5AEtxSg@mail.gmail.com>
 <51443e5b-3eef-c35f-8ee7-ad3e85e4e76c@redhat.com>
 <CAFx4rwT0jt9NCu4imruPUhfAR71=cvHwx-kdZxoTniZaQcPByQ@mail.gmail.com>
 <5416db5c-2d2b-8cc5-b477-604e8ccf0707@redhat.com>
 <CAFx4rwTwZPs5gzDXBc+fLVLCi6RW2=uWC1TaK7uNfJ48MxzHWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hGSrRq140Xdnp61lrccsc1WFGkqOTTjK2"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFx4rwTwZPs5gzDXBc+fLVLCi6RW2=uWC1TaK7uNfJ48MxzHWQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: doug@easyco.com
Cc: Matt Garman <matthew.garman@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hGSrRq140Xdnp61lrccsc1WFGkqOTTjK2
Content-Type: multipart/mixed; boundary="4xJvROmaVxnxtr0Dokn06aR4NDSNLVu61"
From: Doug Ledford <dledford@redhat.com>
To: doug@easyco.com
Cc: Matt Garman <matthew.garman@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
Message-ID: <b12e01c4-72c1-1bc1-3662-3b616d510f85@redhat.com>
Subject: Re: kernel checksumming performance vs actual raid device performance
References: <CAJvUf-C-Nr8sSnSPL-5jt1NLOAiZjhZ=bjDRUbX_RjphRL+yWA@mail.gmail.com>
 <CAFx4rwQj3_JTNiS0zsQjp_sPXWkrp0ggjg_UiR7oJ8u0X9PQVA@mail.gmail.com>
 <CAJvUf-Dqesy2TJX7W-bPakzeDcOoNy0VoSWWM06rKMYMhyhY7g@mail.gmail.com>
 <CAFx4rwSQQuqeCFm+60+Gm75D49tg+mVjU=BnQSZThdE7E6KqPQ@mail.gmail.com>
 <CAJvUf-BoEJte8TF7_Su90CnjAiJ6q57m+PdGhxHA4cx5AEtxSg@mail.gmail.com>
 <51443e5b-3eef-c35f-8ee7-ad3e85e4e76c@redhat.com>
 <CAFx4rwT0jt9NCu4imruPUhfAR71=cvHwx-kdZxoTniZaQcPByQ@mail.gmail.com>
 <5416db5c-2d2b-8cc5-b477-604e8ccf0707@redhat.com>
 <CAFx4rwTwZPs5gzDXBc+fLVLCi6RW2=uWC1TaK7uNfJ48MxzHWQ@mail.gmail.com>
In-Reply-To: <CAFx4rwTwZPs5gzDXBc+fLVLCi6RW2=uWC1TaK7uNfJ48MxzHWQ@mail.gmail.com>

--4xJvROmaVxnxtr0Dokn06aR4NDSNLVu61
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 8/23/2016 3:19 PM, Doug Dumitru wrote:
> Mr. Ledford,
>=20
> I am glad that we are in agreement.  My issue is that if the customer
> is reading 4GB/sec with a non-degraded array, the degraded array
> should only have 2X the number of IOs and 2X the transfer sizes to the
> drives.  If the data rate falls to 1GB, I can suspect cpu overhead.
> With this case falling to 200MB/sec, then something else is going on.
>=20
> SSDs tend to be very "flat" reading from q=3D1 up to about q=3D20 assum=
ing
> the HBAs can keep up.

Is he using SSDs?  If so, I missed that bit.  I wrote my response
assuming rotating media.




--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: 0E572FDD


--4xJvROmaVxnxtr0Dokn06aR4NDSNLVu61--

--hGSrRq140Xdnp61lrccsc1WFGkqOTTjK2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXvKNxAAoJELgmozMOVy/dInAP/2s+6/ZPudJZOHD65qsO3LAE
aAk3Sqa5+OoGj/JAl6wBPqPzIT7xrFkRwQB9rLgyv69R3elsxWp181CmeKT7tdAN
+0zxTAJt90+g4YNblU3lbJmm/DkUHnRBl18axKZeGWxiCQrn0R5pmKrEx5TFURpu
CasaOvQevTGbF9gYWKU0jKU17pGTMr26d6GxE/+w9FcxqcNq+xdEQyFCOYBt7w9i
AR8RvT81DUiaXOFSEoqYN8jNXvrpMIxDl97u/466eZEJf03uvHWRa7BGcSdchoYG
AZsItK1Agu0SnnRHXBhMqgIPQfLfc9QDKZX3BNZS+hiZac3pPGWmY5weqFO2yPLp
VfQNIR3RVhtiDQT/5jB7dv+75czF0Ap1E7HFKshSQAgXSYcFz5AlUDZ/mivur23a
Ju0maRWrZTzGazcPKA9+nkMXqwFfeRdV9tcM37py46B7RbX47AwqXQhvVl9bVb9W
UL+G3bjQPozHGZ1rvJoPTJZaXQ8+rrvS2Cyb47V0VGPDW9L69wAQ9VMuschCL+qi
Tt2gQ+bIWoV+x2eKSNsLHVEoR/a2gRk4DvwONnx4vEgZru3TtdtaztYS+M8h9VAw
uMFZp1KmvsZfbb01y53P4zpi9zKBrdAwDdJepeU882Mqo1tpa4CJqTxshzLoq3tY
qghW7kl7O2A+f3Pq7BDe
=UNBA
-----END PGP SIGNATURE-----

--hGSrRq140Xdnp61lrccsc1WFGkqOTTjK2--
