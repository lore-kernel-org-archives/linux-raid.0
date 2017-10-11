From: NeilBrown <neilb@suse.com>
Subject: Re: hung grow
Date: Wed, 11 Oct 2017 15:49:06 +1100
Message-ID: <87k202wapp.fsf@notabene.neil.brown.name>
References: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com> <89992d1f-172f-9fc6-3a1e-50df34e11d3b@turmel.org> <CADg2FGaPFTNLuQPussL=YFDCRndRDFX99D-KjnWfD93MqGJXmg@mail.gmail.com> <CADg2FGZNs9KmkKGvbCf-dwsqxYN5ftJd5v7RTJ1M=rLP=v6wJg@mail.gmail.com> <CADg2FGa5iUGVqVvy5MrJf00fCqH4NEVXrODPHS6Dc=jsrBx2PQ@mail.gmail.com> <87po9xyv0r.fsf@notabene.neil.brown.name> <CADg2FGaeuptaWRnM5+Z_aAR08vG-311s8p6OrBwZUNeCrNGu1g@mail.gmail.com> <87d15xymgc.fsf@notabene.neil.brown.name> <CADg2FGbzr_JcrGfvU6kpGc_5vJ=+L2gXx3PcfpOTsst8BeNA-Q@mail.gmail.com> <CADg2FGaFt4_4UHPUSnY8tr=LeJMKKojR_QrPE-YoXvWmgXXZxQ@mail.gmail.com> <0d4987d9-e8ff-0cdb-6e45-7f962b75c189@turmel.org> <3e5766b0-1437-2857-4806-264386d1633f@youngman.org.uk> <6d4b7055-c26c-951e-b63c-273a7fe447b8@turmel.org> <CADg2FGad+Tpu-4
 Z4rx1Kx_U1Tw64nQ_FqGuPRn5ODV=_pYFuDw@mail.gmail.com> <e8dce17e-d231-0004-e9a1-511abacfcfda@turmel.org> <CADg2FGZ-=VP2Q++qkKqfQ06zeBho1TR3=biqbdxT7-4pMCcLLQ@mail.gmail.com> <CADg2FGYQti9hFAqtRMEH8B-i
 4kwJJ3fYRdrRauD5F3OSZ_Q0vw@mail.gmail.com> <874lr6ybll.fsf@notabene.neil.brown.name> <CADg2FGb4uG5omeQaC7OVVYhvecRJ6z1DzhSDkUqN-ZrS=K_Q-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADg2FGb4uG5omeQaC7OVVYhvecRJ6z1DzhSDkUqN-ZrS=K_Q-g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Curt <lightspd@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, Anthony Youngman <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, Oct 10 2017, Curt wrote:

> On Tue, Oct 10, 2017 at 4:47 PM, NeilBrown <neilb@suse.com> wrote:
>> Clearly a kernel bug.
>> What kernel are you using?  Can you try a newer one easily?
>>
>  I just tried with Kernel 4.13 and got the same results.  Could it be
> another library that wouldn't be updated with the kernel?

Nope.  It is a kernel bug that is still present.  I can easily reproduce
it on the mainline kernel now that I have your metadata.
I know generally what the problem is.  I'll try to craft a fix tomorrow.
You'll need to build and run a new kernel to be able to fix you array.
That might seem scary, but it really isn't that hard.

NeilBrown


>
> I'll see if I can't get to the data center tomorrow with a rescueCD
> and try that. Any other suggestions or further information till then?
>
> Cheers,
> Curt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlndosMACgkQOeye3VZi
gbkw/Q//YTqbH76goR6TKMoI9O0704VOs5ImHppIgGcQ/PGGb3oGFQ7uwRhvt2ay
fdeafxkF1XB73b7Ho1A/xvuadVYsRXyxlExwJSIMrlMlqpyxAbiTMBMucG6TwSDF
bNhWgZXlpRAoij+5e2iQkg7lKLTOrqFjlLl33YLC/LphkGiIbk2+gZHX9zCoPrLq
tDbkAyRxTqkP232mZNX/VB8tt3BXXEzZ02N84ED9YvvnES4PUcodoAunhJOH9C+b
5W1W9ks0IeZSOmsmxmiX4904WJ8qR8IYDTd+cD2G1M5HMxPDBeJveyah4nBR7Eal
PHcQDVqgtICiJy5Us9ndm4vGv2FDktoEb4g98iMUH79ExH8Oc4HreifrsGqW3PRG
fKacMBl1yGMsPGSEHzAo4RFZfvnvX/mcGorG1qTdhQQtXhZ42Pkah8o8PLtoxx1N
FKzgrt5vQR8H0i2zpQzzn24wTNNXcpc8twxMhfhPZ1jUNvsnIpzq9Q9TipfGgDEy
COcUzI8hUJLAJuev3y8FPvs3x37HD3CBcNXvjrroTHL+79Zw/dJTftBgSLQfeizJ
mNDIKYc/Jl2P+MVfgDzmGkEVLag/7hPlSE5vgKNYRxd+/UEEQq2LgKEKj1nMONnU
vULtpTlrFd1P2Ue2mk1BvwwIaaLRYzP7rLCyKAWQ2dTVIajzpq0=
=kSgy
-----END PGP SIGNATURE-----
--=-=-=--
