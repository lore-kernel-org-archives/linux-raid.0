From: NeilBrown <neilb@suse.com>
Subject: Re: [opensuse] raid device mounting problem in Leap 42.2
Date: Fri, 14 Jul 2017 11:40:01 +1000
Message-ID: <87r2xj23v2.fsf@notabene.neil.brown.name>
References: <a7cc2751c4c0b89dee040c1522590fb5@gmail.hu> <ok4bkp$gb0$1@saturn.local.net> <41e64fb5b9e54bf18aff2d663d0649d8@gmail.hu> <CAA91j0UND1UmwOc46G+o1Mh3dKMG9M_HiYxFdXwWO03D=EztpA@mail.gmail.com> <76df60214c0039114ba0a4b6f0f515bc@gmail.hu> <CAA91j0WXkBnSa+F7u95SWMCtR6nYnUN3uzRLj9jqPoCFX2LNXQ@mail.gmail.com> <596628E7.8020905@youngman.org.uk> <CAA91j0Uyz2xZkpo3YDrkQRhYt5FoG4b-Bwhc7HF3ko40i1xs3A@mail.gmail.com> <d71443c0d631c80af4d09c6098b85359@gmail.hu> <5967FFAD.6030807@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5967FFAD.6030807@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, opensuse@opensuse.org, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 14 2017, Wols Lists wrote:

> On 13/07/17 23:46, Istvan Gabor wrote:
>> On Wed, 12 Jul 2017 17:05:17 +0300, Andrei Borzenkov wrote:
>>> On Wed, Jul 12, 2017 at 4:49 PM, Wols Lists <antlists@youngman.org.uk>
>>> wrote:
>>>>
>>>> But I suspect that going back into 12.2, and shrinking the filesystem
>>>> (MAKE SURE you shrink the md device, not the sd device)
>>>
>>> Quite the opposite. Attempting to shrink filesystem that is already
>>> effectively corrupted is potentially dangerous. So the right thing
>>> here is to stop md, backup superblocks (in case they will be
>>=20
>> I am puzzled. Do I need to backup the raid superblock or the device
>> superblocks or all?

You cannot have too many backups.

>>                      How do I backup the superblock? I googled but only

mdadm --dump=3D/some/directory list of devices.

>> find how to recover from superblock backup.
>>=20
> The best bet is to ask the linux-raid list what to do.
>
> For the raid list, this is the array I mentioned where the filesystem,
> and the partitions the raid was on, were the same size.

To the byte?  I really like to see the output of commands that report
sizes, rather than have someone claim "were the same size".  It isn't
that I don't trust you.  I just don't trust humans in general (myself inclu=
ded).

NeilBrown

>
> So we have a v1.0 mirror where the filesystem on the mirror uses up ALL
> the space on the md device, not just the free space that it's supposed
> to use, with all the issues that brings like filling up the filesystem
> will overwrite the superblock.
>
> So what's the best way to recover? Will just shrinking the filesystem
> bring everything back the way it should be, or are we better just
> mounting the original filesystem from one disk as if it weren't a
> mirror, and then recreating the mirror on the other disk, copying the
> data, and then adding the first disk back in to put everything back the
> way it should have been?
>
> Cheers,
> Wol
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlloIPIACgkQOeye3VZi
gbmOlQ/+KjVpizzAEN5bYt/I8CQuzJlcVCv3XL/ZlXBWmFuOf8OFpceXDY16u0Xb
zNDe58AHLDf/yoJbj94m1Xuvv78f0FAKCTaJXObsbNCdrwqpD6UnOD9Qureq9n3m
31pcO2o00To9nZIaTzkRiCYI+5TXNx0FH/2ziMOok7nlPbnf+6GTCCx0jdBB7m+k
HX5j+QmzcJmtobvil4fxsBZOcNwmdF0wPFi8YJiuqrsXRSeFdHoSDELlIldYSDUt
Iold+BV/kTtgn/o8F7IDbuILB1Uv5H0gm/ILSpQamufuqiP81ysEC2MaIybJeVk3
08s3OdxQMZMRhllhkusjjePD6nUjGaahSp+B0LhPbiVrGJnyoEtv621Q032CHRkP
jHxL/joQ04fSL/CIobIqs09PkMdjkXC9auwccTd3AaS9xERf3E2bTl9ABN8SlD3g
3k9EwdnMww8kdQGuqrmriJOKziLlU802biURciH6f42Z3N5QNJBtC8J6O8pZ2hz2
39WFR84b/Qqp6SBkstwldUKuQHHhssne1awn4TfVnBR0VdsFmvrhh+ghGx1w551+
E1abaAPYFitcdsGjSAB5bjE6/0ppG9KbHqPoiYKQ4U3cTkLYEl5NQlWyvC/PJl+m
p59RWD14xqQTZMKZFYzLLQlyUmVFrE9sXfi6C+mT5o+3YQ8n4Fc=
=gOwV
-----END PGP SIGNATURE-----
--=-=-=--
