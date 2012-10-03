From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 rebuild stuck
Date: Wed, 3 Oct 2012 11:21:20 +1000
Message-ID: <20121003112120.67d16a3b@notabene.brown>
References: <20121001112946.GB27455@nsrc.org>
	<20121002155642.606b2108@notabene.brown>
	<20121002155633.GC30589@nsrc.org>
	<506B45C3.4090902@anonymous.org.uk>
	<20121003062907.3886b2fd@notabene.brown>
	<506B4FF9.8070904@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lTqH2o=nDgbJ.0oFOs=Xr1x"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <506B4FF9.8070904@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/lTqH2o=nDgbJ.0oFOs=Xr1x
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 02 Oct 2012 21:35:05 +0100 John Robinson
<john.robinson@anonymous.org.uk> wrote:

> On 02/10/2012 21:29, NeilBrown wrote:
> > On Tue, 02 Oct 2012 20:51:31 +0100 John Robinson
> > <john.robinson@anonymous.org.uk> wrote:
> >
> >> On 02/10/2012 16:56, Brian Candler wrote:
> >>> On Tue, Oct 02, 2012 at 03:56:42PM +1000, NeilBrown wrote:
> >>>> Lesson: always do a read test as well as a write test!
> >>>
> >>> And there was me thinking that drives read back data after writing it=
 -
> >>> clearly they do not :-)
> >>
> >> Would it be worth adding a re-read onto the end of the usual read
> >> failure reconstruct-write cycle?
> >
> > What?  Read twice?
> >
> > We already read after the write when attempting to fix a failure.
>=20
> I didn't realise you already did that.
>=20
> > I suspect it doesn't do much good though as the data is in cache in the=
 drive.
>=20
> No, maybe not. There isn't an option you can add to ask for an uncached=20
> read? But I dare say you'd have thought of that already if there was :-)

Maybe setting REQ_FUA would work.  Or maybe it would cause crashes and rand=
om
data corruption.  I suspect most people think of REQ_FUA as being associated
with WRITEs.  Maybe I'm to cynical, but this would be extremely hard to tes=
t,
and I don't feel up to the code review that would be required to provide
sufficient confidence :-(

NeilBrown


>=20
> Cheers,
>=20
> John.
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/lTqH2o=nDgbJ.0oFOs=Xr1x
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGuTEDnsnt1WYoG5AQKKyA//VC55S8fvT8m9UxRqzRV+L3GTxlBJlWBQ
3ib4DtinBk7DWY7qtT8RaPn53NCiehW9NtsecSVkC8sQdphLEBLmk13OdhRg3+OZ
W6AOTMDf/x2+0eQZAbdIFfxMCCYcRvoRsiP9q5yds1uvWIE+xfXzrzorrdAfHzum
uGAP1Xv25/Vnxez5etUVmkx51X4/n+vYwPFwROvkWgU8atWqesrnS0PazeXbYHsK
lnvo7Q4n5VpJbfbAJF0O9SO53Lr4kReB2L5w4Nd3W4SPRDmlqn3sf6ezOjpOQpzk
1a32LLbR2EIgwPUdYoivqCuKemoOVspsiNi6dmUi5t6tlBGIUdoqOC5oc9nkqd2I
q+++VA0RzFv4XYJ2EhoFMo5PQupeWGticgjSbnYl2+19O0/wDwXgncB8lQaTYWBz
pfWjj8u6IvzTHPN/UD9/MPQ3rOr5uO+7IC2/ql+iwc8tGKz4B9klMhN5NBGEQe55
z0cssGVqiDxsKKIEohxbncxEHtbLYB/EqvmU9tNs1WiH0CC1HAN/5TAujrWTxjDC
qwcVHeCFbDeW4r7/+pWAMNDrww6TOEwjzi3uRy3cl0RytDzJ4VLBLchiRtIipbJ+
vugK9vRfYl7yUeyl4tlSLJDrPU+fyvzHTtJD0yohxpBWRkSRiu0bmYY+34RTg5WE
1IbAznZYz4k=
=CX8J
-----END PGP SIGNATURE-----

--Sig_/lTqH2o=nDgbJ.0oFOs=Xr1x--
