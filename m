From: NeilBrown <neilb@suse.com>
Subject: Re: [LSF/MM TOPIC] De-clustered RAID with MD
Date: Tue, 30 Jan 2018 22:24:23 +1100
Message-ID: <87372n613s.fsf@notabene.neil.brown.name>
References: <mqdvafkhep0.fsf@linux-x5ow.site> <5A6F4CA6.5060802@youngman.org.uk> <87fu6o5o83.fsf@notabene.neil.brown.name> <5A704C59.4000705@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <5A704C59.4000705@youngman.org.uk>
Sender: linux-block-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Johannes Thumshirn <jthumshirn@suse.de>, lsf-pc@lists.linux-foundation.org
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 30 2018, Wols Lists wrote:

> On 29/01/18 21:50, NeilBrown wrote:
>> By doing declustered parity you can sanely do raid6 on 100 drives, using
>> a logical stripe size that is much smaller than 100.
>> When recovering a single drive, the 10-groups-of-10 would put heavy load
>> on 9 other drives, while the decluster approach puts light load on 99
>> other drives.  No matter how clever md is at throttling recovery, I
>> would still rather distribute the load so that md has an easier job.
>
> Not offering to do it ... :-)
>
> But that sounds a bit like linux raid-10. Could a simple approach be to
> do something like "raid-6,11,100", ie raid-6 with 9 data chunks, two
> parity, striped across 100 drives? Okay, it's not as good as the
> decluster approach, but it would spread the stress of a rebuild across
> 20 drives, not 10. And probably be fairly easy to implement.

If you did that, I think you would be about 80% of the way to fully
declustered-parity RAID.
If you then tweak the math a bit so that one stripe would was

A1 A2 A3 A4 B1 B2 B3 B4 C1 C2 C3 C4 ....

and the next

A1 C1 A2 C2 A3 C3 A4 C4 B1 D1 B2 D2 ....

and then

A1 B1 C1 D1 A2 B2 C2 D2 A3 B3 C3 D3 ....

                  XX
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
When Ax are a logical stripe and Bx are the next,  then you have a
slightly better distribution.  If device XX fails then the reads needed
for the first stripe mostly come from different drives than those for
the second stripe, which are mostly different again for the 3rd stripe.

Presumably the CRUSH algorithm (which I only skim-read once about a year
ago) formalizes how to do this, and does it better.
Once you have the data handling in place for your proposal, it should be
little more than replacing a couple of calculations to get the full
solution.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlpwVecACgkQOeye3VZi
gbk/tA/8DNuJ4QJu9nJ/O0YtpsuiH9cb58Az8OB0SH56YLqSPFKlBAPdFWP3UMj8
68eIav+FkGrSBZ4trnjWhOiuNILHr5EgilarFFg2DnCt5/PZWu6g91TULttMPGBH
pTsZmbZFfsLlG0/WzspYkDLTviFtPijQSfTpwi749Y52dP/nwoLbyyir5SQDvbpi
dqAi5JfYOZUPecndGtEPEZ4uXe8HlNPDR7Lmz8+x+XMwa8fmN4TokCbBEeOkaAbT
FKM7UNXlQbR0Nsz6bI1yCb14KJi5bycQMbamTaDOGpVJN9yeYn4/NmC/krdy4cSx
Q7OS0/VPx13i2LqFnmZ+tOVdCSBiyjeFXckP2OywXIQ1aCP5TXRdX2hsxlhGBEMP
B/1orkvFF9bESAhoc6sFA8sHhlluYgsG0W9u+lmoc5m7sdC7FsvDFUk74LVajO3Y
c6bPJQdtq/KNnl4HWfXmVIYponiHxfwSNHccaBMlDEzviASjaupZx2Z6nHPC2vHA
4zThW7KY0JNUoUMK/T+oG4cF+ArV4Tw+prnruEy0syYpoVP4owNDp/tj65XVwuuv
//kLg2LPnynp3VxRVQDeBbqQ7rvGfUh7MO5OXZnBm4H9bpzSdKWyMLLM43fhoV/p
IEOnlWLh+5RW25gKEGCvrKwBk2zcAG/KRNd2vIbqpTxwyb4yKi0=
=6L06
-----END PGP SIGNATURE-----
--=-=-=--
