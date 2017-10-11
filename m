From: NeilBrown <neilb@suse.com>
Subject: Re: hung grow
Date: Wed, 11 Oct 2017 15:46:36 +1100
Message-ID: <87mv4ywatv.fsf@notabene.neil.brown.name>
References: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com> <89992d1f-172f-9fc6-3a1e-50df34e11d3b@turmel.org> <CADg2FGaPFTNLuQPussL=YFDCRndRDFX99D-KjnWfD93MqGJXmg@mail.gmail.com> <CADg2FGZNs9KmkKGvbCf-dwsqxYN5ftJd5v7RTJ1M=rLP=v6wJg@mail.gmail.com> <CADg2FGa5iUGVqVvy5MrJf00fCqH4NEVXrODPHS6Dc=jsrBx2PQ@mail.gmail.com> <87po9xyv0r.fsf@notabene.neil.brown.name> <CADg2FGaeuptaWRnM5+Z_aAR08vG-311s8p6OrBwZUNeCrNGu1g@mail.gmail.com> <87d15xymgc.fsf@notabene.neil.brown.name> <CADg2FGbzr_JcrGfvU6kpGc_5vJ=+L2gXx3PcfpOTsst8BeNA-Q@mail.gmail.com> <CADg2FGaFt4_4UHPUSnY8tr=LeJMKKojR_QrPE-YoXvWmgXXZxQ@mail.gmail.com> <0d4987d9-e8ff-0cdb-6e45-7f962b75c189@turmel.org> <3e5766b0-1437-2857-4806-264386d1633f@youngman.org.uk> <6d4b7055-c26c-951e-b63c-273a7fe447b8@turmel.org> <CADg2FGad+Tpu-4
 Z4rx1Kx_U1Tw64nQ_FqGuPRn5ODV=_pYFuDw@mail.gmail.com> <e8dce17e-d231-0004-e9a1-511abacfcfda@turmel.org> <CADg2FGZ-=VP2Q++qkKqfQ06zeBho1TR3=biqbdxT7-4pMCcLLQ@mail.gmail.com> <874lr6ybll.fsf@notabene.n
 eil.brown.name> <CADg2FGbjqzFvrptLkM9LGYABZWDcmQC_rqEceo44yzADGhFGzw@mail.gmail.com> <CADg2FGbJHbPaPeBdetTGuC-S2e17BWHOchEeiBjevibjH0pHGg@mail.gmail.com> <87po9uwtsl.fsf@notabene.neil.brown.name> <CADg2FGZVgEFddKBAkRX6AbMxYGHpX8o5z=2i0JHNQ9tSZ_VZWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADg2FGZVgEFddKBAkRX6AbMxYGHpX8o5z=2i0JHNQ9tSZ_VZWQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Curt <lightspd@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, Anthony Youngman <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, Oct 10 2017, Curt wrote:

> On Tue, Oct 10, 2017 at 5:56 PM, NeilBrown <neilb@suse.com> wrote:
>> On Tue, Oct 10 2017, Curt wrote:
>>
>>> On Tue, Oct 10, 2017 at 4:58 PM, Curt <lightspd@gmail.com> wrote:
>>>
>>>>> Can you please
>>>>>   mkdir /tmp/dump
>>>>>   mdadm --dump=/dev/dump /dev...list.all.devices.in.the.array
>>>>>   tar czf --sparse /tmp/dump.tgz /tmp/dump
>>>>>
>>>>  Yeah, I will get that for you once I reboot the server.
>>>>
>>> Quick question.  Is that supposed to be mdadm --dump=/dev/dump or /tmp/dump?
>>
>> "/tmp/dump" - yes,  I typed the wrong thing.
>>
>> Thanks,
>> NeilBrown
>
> Out of curiosity, how long should it take to tar these files?  I get
> the system reports them as 1.9T and there not really that big, hence
> the sparse switch. I've just never tarred a sparse file file before.
> It's been churning away for about 2 hours, which I'm going to assume
> is normal.

With a sufficiently recent 'tar' and kernel (I don't know how recent
they need to be) it should be nearly instantaneous.  With older code it
could easily take hours.

The kernel needs to support SEEK_HOLE (v3.1 introduced that) and
tar need to support "--hole-detection=seek", which is the default if it
is supported.  I don't know what version.

NeilBrown


> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlndoi4ACgkQOeye3VZi
gbl09A//Uu5Oc/7Ct4QPqr8CkaX2K/MNrdcCjfvSg6/Ci5lQktib7+AYohjBO33H
dBy+T01+osEj314b5Q4NDhCNLbFaGmTCUquqAdTca0C1fAG97yGRJqttjQFyGseG
tr6f70sFlP2w22Sc3LKiiOo7eIEY4jJU19TDDyzjRw80h+U5C/P5cAwR3+RqkVzy
BgSA6EOQ/azdhwoAPm2FxrLy8gtVZPXggU0l8ilbrKWnlrSlbuYh5lXbUlOfJaSH
6WTK4XNpvEAFGj5eqK3b4G4azlQOUfQdnGMsLjU0PJLuZI+IAznMuw+QKQ69GMKA
rpU5tORcoTGjySUQyqs1MsoNV1zCV0HSMmm+IQDKcDwkVs0bnxLR25MDcgZJblDr
gXtN5KdZHeK5Hni1IrA1/GL2MuTwsotGFHnHjgC1lEiKkyelImI6fCYoe00IXU/V
GYHBRE5BJQ3Mre8ZdiGPNlJFZA/CC+UDwPrhz0M0U1aGljNk5uDby+Ga/YgG/7sg
fhuGFjBFlfjv4tSBkgowUhLU4U7Tgq6ad0RjIho/5c22aIO1SEBn0bCb52NxZt3M
fSgaF0Jbxt2IXd/siKjTcCYXdqMRV7t9BoXGL8fbIT4A6uY1sLj6KK86bB+1o9nv
Wwl/aGeNZfMk0JhUP1GmdAWXTX3IwY00EUkL8/npnxrdOXokeUc=
=F7th
-----END PGP SIGNATURE-----
--=-=-=--
