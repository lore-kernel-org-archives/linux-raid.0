From: NeilBrown <neilb@suse.com>
Subject: Re: hung grow
Date: Thu, 12 Oct 2017 17:15:42 +1100
Message-ID: <87376ooprl.fsf@notabene.neil.brown.name>
References: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com>
 <89992d1f-172f-9fc6-3a1e-50df34e11d3b@turmel.org>
 <CADg2FGaPFTNLuQPussL=YFDCRndRDFX99D-KjnWfD93MqGJXmg@mail.gmail.com>
 <CADg2FGZNs9KmkKGvbCf-dwsqxYN5ftJd5v7RTJ1M=rLP=v6wJg@mail.gmail.com>
 <CADg2FGa5iUGVqVvy5MrJf00fCqH4NEVXrODPHS6Dc=jsrBx2PQ@mail.gmail.com>
 <87po9xyv0r.fsf@notabene.neil.brown.name>
 <CADg2FGaeuptaWRnM5+Z_aAR08vG-311s8p6OrBwZUNeCrNGu1g@mail.gmail.com>
 <87d15xymgc.fsf@notabene.neil.brown.name>
 <CADg2FGbzr_JcrGfvU6kpGc_5vJ=+L2gXx3PcfpOTsst8BeNA-Q@mail.gmail.com>
 <CADg2FGaFt4_4UHPUSnY8tr=LeJMKKojR_QrPE-YoXvWmgXXZxQ@mail.gmail.com>
 <0d4987d9-e8ff-0cdb-6e45-7f962b75c189@turmel.org>
 <3e5766b0-1437-2857-4806-264386d1633f@youngman.org.uk>
 <6d4b7055-c26c-951e-b63c-273a7fe447b8@turmel.org>
 <CADg2FGad+Tpu-4Z4rx1Kx_U1Tw64nQ_FqGuPRn5ODV=_pYFuDw@mail.gmail.com>
 <e8dce17e-d231-0004-e9a1-511abacfcfda@turmel.org>
 <CADg2FGZ-=VP2Q++qkKqfQ06zeBho1TR3=biqbdxT7-4pMCcLLQ@mail.gmail.com>
 <874lr6ybll.fsf@notabene.neil.brown.name>
 <CADg2FGb4uG5omeQaC7OVVYhvecRJ6z1DzhSDkUqN-ZrS=K_Q-g@mail.gmail.com>
 <87k202wapp.fsf@notabene.neil.brown.name>
 <CADg2FGaGF0wg5P075HwLNEE_zNQETRQNmO9KfxGgTvTMP2nMdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADg2FGaGF0wg5P075HwLNEE_zNQETRQNmO9KfxGgTvTMP2nMdQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Curt <lightspd@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, Anthony Youngman <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Oct 11 2017, Curt wrote:

> On Wed, Oct 11, 2017 at 12:49 AM, NeilBrown <neilb@suse.com> wrote:
>>
>> Nope.  It is a kernel bug that is still present.  I can easily reproduce
>> it on the mainline kernel now that I have your metadata.
>> I know generally what the problem is.  I'll try to craft a fix tomorrow.
>> You'll need to build and run a new kernel to be able to fix you array.
>> That might seem scary, but it really isn't that hard.
>>
>> NeilBrown
>  Awesome thanks.  Just let me know what I need to do.

I had hoped to have this for you today, but it didn't quite work out.  I
have a patch which I believe is correct, but I try not to trust myself
about such things after about 3pm.
Fixing the spin turned out to be very easy, but subsequent testing
showed another problem.  'sdb' is not fully recovered but after the
reverted reshape completed, md thought that it was.  It took a while to
figure out exactly what was going on there.

If nothing urgent intervenes tomorrow I'll review the patches and then
send them along with instructions on how to build a kernel.
It might help to know what distro you plan to do that on.
The key steps will be:
1/ get the kernel source
2/ apply the patch
3/ get a .config that matches what your distro kernel
4/ build the kernel
5/ make install modules_install
6/ reboot

The kernel source is simply https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.13.5.tar.xz
The "make install.." assumes your distro has the right helpers
installed.
The ".config" might be
   zcat /proc/config.gz > .config
If not, you'll need to hunt for it.  Someone can probably help.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnfCJAACgkQOeye3VZi
gblvPBAAh/oaaB2ZphHtjBbcVhmbJnESOAadsrpSodRP9AB8akYXv0NNkTdeHx5E
4p5ziFDOcsSMf7IV3MARTBNQ9OZQtwbZatFX7xlK6X+5cyUGqRlJcW5g7Q4qv0Cs
1Li1Tp6a29SGTBS1mLsqxuS71+Xb6/I8pCobbzLTaPTI1qfBNHpLXp8VcrFY+ENf
ayPEnTS5G7PXOaD+co7KR/wnm4t5jJ4OFzxlTQODVqEHldOg3g+HITPT+codC6cs
QaX/YnZaMpoVY4An1Fnm/sjeUPmajEHyWuZsdh9EdV5DFOvD0LyuL0d6mwKfAS36
y9udFHfodhxs6SqLIcmL9AOSjM0maMTG0NgFneMTuQ+qckVOkSo3cmVVywIAuV54
MTZg3ITza0xvJSAA+NyZtvFSlaNWxOTogUzlRPym5vLxDN8OTsgNWd6MBine+Ef2
eRGn/WSluA9iWKNxEETbUmv+qHJzC3J5oNrjYnjpjzgLVG9ZQ3DVy4zI7Slsh/VD
iqRYz2TwxIrpzkdE8ZlnTRKevepwfPiBcuxbGDwk7fkBqWvDDsZQJ/NNh7cCzoed
XjmeMaQesPEwm/lFccFZJsgCCNLyR/617LskqWK9+z25NddzBGXx3yMe2EB54in4
c2d8fG9HuQOVJs/i6CXhEqNccV1cu7ua6zKpB0oWKPVg3iidVUg=
=R2Ln
-----END PGP SIGNATURE-----
--=-=-=--
