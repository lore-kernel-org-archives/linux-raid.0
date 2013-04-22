From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] MD:  Do not increment resync_mismatches unless
 MD_RECOVERY_REQUESTED
Date: Tue, 23 Apr 2013 09:44:59 +1000
Message-ID: <20130423094459.6e41be55@notabene.brown>
References: <1366402161.18514.1.camel@f16>
	<20130422103626.4cdcefae@notabene.brown>
	<2BD5F32D-4C11-4DA6-A38B-DFA030D78489@redhat.com>
	<517571C3.3060302@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/T.iwCXcF/3EPtaJeDC+=+Es"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <517571C3.3060302@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Brassow Jonathan <jbrassow@redhat.com>, "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/T.iwCXcF/3EPtaJeDC+=+Es
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Apr 2013 13:22:11 -0400 Doug Ledford <dledford@redhat.com> wrote:

> On 04/22/2013 12:26 PM, Brassow Jonathan wrote:
> >=20
> > On Apr 21, 2013, at 7:36 PM, NeilBrown wrote:
> >=20
> >> On Fri, 19 Apr 2013 15:09:21 -0500 Jonathan Brassow
> >> <jbrassow@redhat.com> wrote:
> >>=20
> >>> MD:  Do not increment resync_mismatches unless
> >>> MD_RECOVERY_REQUESTED
> >>>=20
> >>> resync_mismatches is used to display the number of differences
> >>> that have been found or repaired during a scrubbing operation.
> >>> It is not meant to count anything during resync or repair
> >>> operations.  (How much sense does it make to find
> >>> resync_mismatches populated after an initial synchronization of
> >>> the array?  After cleaning-up an unclean shutdown?  After
> >>> [re]integrating a device into an existing array?) The
> >>> incrementing of the variable must be restricted to when the user=20
> >>> initiates a scrubbing operation (i.e. "check" or "repair").
> >>=20
> >> How do you know what it is "meant" to do? :-)
> >=20
> > Yes, I suppose I did infer the meaning, but I don't think it's too
> > much of a stretch - especially given the commit message where
> > 'resync_mismatches' was introduced.
>=20
> Which also matches the understanding other people have had for a long
> time ;-)
>=20
> The information Neil doesn't want to throw away is a valid issue, but
> maybe the proper thing to do here is to have two counters:
> repaired_mistmatches and detected_mismatches, and then you can infer
> total_mismatches from that, and add mismatch_cnt_since (which makes more
> sense to me than last_sync_action if you're using it to delimit when you
> started the current mismatch counts) as a representation of when you
> started the current counts.  If it was since boot, or since disk add, or
> since check/repair, whatever, you put that in the since file (which I
> think answers your other question you had about a set of flags or
> text...I personally think text since the last operation that we might
> want to record could be assemble or something like that).  That way you
> aren't throwing anything away, but you also aren't confusing people and
> making them concerned since most people think mismatch_cnt is
> uncorrected errors found, having that increment for corrected issues
> found during assembly or something can certainly confuse people.
>=20

I don't think 'mismatch_cnt_since' really makes sense.  Mismatches aren't
just found at random points in time.  They are a direct result of a
sync_action.
So "mismatch_cnt_found_during" or "mismatch_cnt_detected_by".

If they were found by "sync" or "check" or "repair" then it means something
different in each case.

The issues isn't "when" as a time or time-range they were found, but what w=
as
happening at the time.

NeilBrown

--Sig_/T.iwCXcF/3EPtaJeDC+=+Es
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXXLeznsnt1WYoG5AQKT3g/+M811mdGaSPemVTmLnY0yi8iBSYPiseSE
0CNit0cDPWWmwAvlDxNMuoMy6O/uwPoMQ+/ZmtyHowRpUbdW2dlDA6pIEGvroddg
YbfAo340fIb1eExIkOq48FTYEKjajrpcCMru86pCV+eMZ2Ob6ar0i8TNSMA8mdVb
hS/F8F+S2WtFoi0RW62DQ9s9lt7K/kVGfMMcHeDKLSS8EzzHU5YYRTKjqPpvtlzb
llDTglViQaCyUNaIx2+USZqfXdNiUoe+0lzYI/awxmy4SWenYgIafrWzQMasLPEH
E88vnIzNMpLc2DkEC70aN6/TRCz6aPVuG7YTZkGNSA2CaYDahXR/YQbOD1ZcwqEv
n6Kwy17Vn55n26XOAGWdPG2dvtDTDf2nBH1arkhY8PgZZeMfcGpGG3lTdEnsPCXP
DOqOBViQDd961J7bwpxC+6dlLCiF+dSboxiiidx+M/htbvT4+ZrwltbnsK8SOWGg
mlaaVUST5KZ+rNIVhphLUihdBajkPisjNWJvmenAsQoiHrD4GlEqns2U02DJ1aW6
FIahgk1M/EPR8z/irRBjrvujY1iwCYOT9FgnmAlIsOHY2MQbEtFaLYqdErS6+Gyp
LSWeDj1eTTnO8RmTAdVddVidyzHpuWB+HKfKCdnXyydCPFDuHE1EMtn5HOJtfi3k
ArZVw8TK2Uk=
=Yvyv
-----END PGP SIGNATURE-----

--Sig_/T.iwCXcF/3EPtaJeDC+=+Es--
