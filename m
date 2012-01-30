From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 5/5] imsm: verify maximum supported active volumes in
 assembly
Date: Tue, 31 Jan 2012 09:10:56 +1100
Message-ID: <20120131091056.4c64c089@notabene.brown>
References: <F9123E44003394499FDD2B17C60621D4075DE9@IRSMSX101.ger.corp.intel.com>
	<20120130120232.236c5343@notabene.brown>
	<F9123E44003394499FDD2B17C60621D408AE9B@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/d_XrQawB+zuMMG_OVbAGK.p"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F9123E44003394499FDD2B17C60621D408AE9B@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--Sig_/d_XrQawB+zuMMG_OVbAGK.p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Jan 2012 10:24:25 +0000 "Labun, Marcin" <Marcin.Labun@intel.com>
wrote:

> Hi,
> >=20
> > hi,
> >  I've applied the first four in this series, but I don't like this one.
> >=20
> > 1/ I don't think there is any need to impose this restriction when
> >    assembling an array - only when creating a new volume in an array.
> We want to support only as many volumes as OROM (platform) supports. Disk=
s with IMSM metadata may be carried from other systems.

I don't think that makes sense.

There are two important issues here.

1/ we don't want to make a change to an array which will make that array
  inaccessible to the OROM.
2/ we don't want to make it difficult for users to get their data.


So any create or grow attempt which could lead to the OROM being unable to
access the array should be stopped (unless explicitly over-ridden).

But any attempt to access data on any array (i.e. assemble an array) should
succeed no matter whether it is compatible with the OROM or not.

So --create and --grow should check for platform compatibility.
--assemble should not.

--examine and --detail should probably report if the array is incompatible
with the OROM.


>=20
> >=20
> > 2/ The check_volumes_number approach feels clumsy ... there must be a
> >    a better way (Assuming it is needed at all).
> container_content handler is to check OROM capabilities and mark unsuppor=
ted volumes with=20
> disable bits (array.state:MD_SB_BLOCK_CONTAINER_RESHAPE and MD_SB_BLOCK_V=
OLUME). The caller function shall interpret the bits and act
> accordingly to the context (for instance block activation but display the=
 volume information). I think that this restriction
> falls into that area. However, there are only a few situations when this =
info is really needed ie. When volumes are activated in various ways.
> Therefore I thought it makes sense to pass the info if counting of activa=
te volumes is really needed.=20
> More straightforward option is to add another input parameters to contain=
er_content and change it in numerous places.
> Do you prefer this way? Or add a specialized handler to count the volumes=
 when it is needed?

Hmmm.. so the issue is that a single controller can have multiple separate
containers (families?) with their own metadata.
So a controller with 4 ports could have a 2-device container with a RAID1 a=
nd
a RAID0, and a separate 2-device container with just a RAID10.

And maybe the controller has a limit of 3 arrays, so adding another array to
the second pair would be an error.

Is that the right sort of scenario?

So when assembling the second container we don't need to look at the first
one, but when adding an array to the second, we do need to look at the first
one.
And looking at the first one is a little expensive so we don't want to do it
if we don't have to.  Still correct?

It sounds to me like validate_geometry is the place to check for other
containers on the controller.  That should be called at exactly the times y=
ou
need.... for create anyway.  Might also need it in reshape_super as well.

Would that work?

Alternately, we probably do want it for --examine so we can report possible
problems... maybe it isn't that expensive and we can always do the check??
How expensive would it be to always do the check on number of volumes??


NeilBrown

--Sig_/d_XrQawB+zuMMG_OVbAGK.p
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTycVcDnsnt1WYoG5AQLJLA//S7Jq2ISGfUg4GbyP3M7aYYcjD44RLG0X
R1oeIiy/wM1fsVDZibcMEGfiW5DfzBPKMh3VqqYUSIIF4N04uoJ9d2uzWGkLir3e
5vSOZbarKNJWyffjtCxGsGT9jUIg+K14B57tzWB4QME23j7GGzjQReAx+p8CiHKi
TQ02cQD2raNxFRgP9cIbU7Pxn0scVdN3ZIrHhWxG7kbGreencnU3hc0FG38VtMD5
lcEEwo+TZqIsIgBF8tIHT8vtfe5ndwJoFI6+G/NBmUnqK1qXrsn1bvY7gePbWtJE
DzGQHp45wWwTIxQIAatucJ/+QRcSNnvKRn22P0KlHpCTIqUT35hDP2ICssMCIXec
6GxZDDib9P9qMpahl3G4ioCoGUnRtc0CDOopKrrO05Pu4BPyBqwc8N/zdvonaydh
QNHyH4Jlix1oa1hBajiJ61+kcYW42BngV3RA+0aXcH6kQU81oOTVoDxv6GkkzDTs
iRHuvIHf0dNgiYorIunsuBQnPxCW/4ece12DeyoHrvFSqgSnYBgqBzCjBgrLnyNp
AKRw/0qJOdmQyWCTOb/Hsz9PclYD4Q8DZ6hvbn5qGidAwhm+qjLuWXTLbQhbD57s
7B4CrWGHDVwnMf1aAUFQI0neVBgI0gS9VSGNCBWmqKNwCv2xxXGbHvTPQJN9TSEq
hIiLX5eTKaU=
=pXtf
-----END PGP SIGNATURE-----

--Sig_/d_XrQawB+zuMMG_OVbAGK.p--
