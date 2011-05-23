From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: HBA Adaptor advice
Date: Mon, 23 May 2011 10:09:39 +0600
Message-ID: <20110523100939.0c019ea2@natsu>
References: <4DD50C89.8060006@wildgooses.com>
	<20110520020853.GC4759@bitfolk.com>
	<4DD61948.8050302@wildgooses.com>
	<4DD6409F.9070904@hardwarefreak.com>
	<4DD79F4E.7000509@wildgooses.com>
	<4DD8D1A7.1090803@hardwarefreak.com>
	<4DD8E0D3.1030905@fnarfbargle.com>
	<4DD9633E.5000101@hardwarefreak.com>
	<4DD99A16.5010108@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/DNrjRtYVE7VbnNyMTd6UfxW"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD99A16.5010108@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/DNrjRtYVE7VbnNyMTd6UfxW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 23 May 2011 07:19:50 +0800
Brad Campbell <lists2009@fnarfbargle.com> wrote:

> On 23/05/11 03:25, Stan Hoeppner wrote:
> >> Actually, I'm pretty sure the WD drives have a 5400 rpm spindle speed
> >> period. I've got 15 of them here and I have no evidence of any form of
> >> spindle speed variation. They say the drives have spindle speed :
> >> "intellipower" which is marketspeak for slow enough to save a few watt=
s,
> >> but fast enough to do the job.
> >
> > From:  http://www.anandtech.com/show/2385/2
> >
> > The Western Digital drive's IntelliPower algorithm, which varies the
> > rotational speed between 5400RPM and 7200RPM, dictates the Western
> > Digital's rotational speed.

You can find 100s or 1000s of articles reiterating the manufacturer's
marketing materials without much thought or experimentation.

On the other hand there have been some tests of these drives involving a
microphone and rotational noise frequency to RPM calculation which show it
does not vary ever. I can't dig up those off-hand though; so for the
'next-best' proof see HddRpmEst results by the japanese link below.

> "In 2007 Western Digital announced the WD GP drive touting rotational=20
> speed "between 7200 and 5400 rpm", which, if potentially misleading, is=20
> technically correct; the drive spins at 5405 rpm, and the Green Power=20
> spin speed is not variable.[citation needed]"

And here is a couple of [citations]:
http://www.ciol.com/News/News-Reports/Seagate-targets-Western-Digitals-Inte=
lliPower/131009126262/0/
http://www.storagereview.com/1000.sr

By the way, 5400-7200 isn't even true in any sense of the word.=20
There are some models of WD20EARS (e.g. 00MVWB0, maybe others) which spin at
constant 5000 RPM instead: http://club.coneco.net/user/10682/review/37049/

> > IIRC from discussions here, mdadm has alignment issues with hybrid
> > sector size drives when assembling raw disks.  Not everyone assembles
> > their md devices from partitions.  Many assemble raw devices.
>=20
> Which means the data starts at sector 0. That's an even multiple of 8.=20
> Job done. (Mine are all assembled raw also).

The data does not necessarily start at sector 0. However it still most
likely to be fine:

$ sudo mdadm --examine /dev/sdb3 | grep Offset
    Data Offset : 2048 sectors
   Super Offset : 8 sectors

> > Google WD20EARS and you'll find a 100:1 or more post ratio of problems
> > vs praise for this drive.  This is the original 2TB model which has
> > shipped in much greater numbers into the marketplace than all other
> > Green drives.  Heck, simply search the archives of this list.
>=20
> Indeed, but the same follows for almost any drive. People are quick to=20
> voice their discontent but not so quick to praise something that does=20
> what it says on the tin.

Personally so far I have been sucessful in avoiding the "Advanced Format" c=
rap
that WD and others are pushing down customers' throats; I have none of such
drives. It *is* possible to make a non-AF 2TB drive, even a 3-platter one. =
And
this one in my opinion the ideal Green drive to buy today, which has the
advantages of being non-AF and at the same time still in production (maybe
not for too long, with WD buying Hitachi :-/ ):=20

  Hitachi 5K3000 HDS5C3020ALA632
  http://www.newegg.com/Product/Product.aspx?Item=3DN82E16822145475

I also had only the best experiences with Hitachi HDDs, and it looks like I=
 am
not alone:
http://www.tomshardware.com/reviews/hdd-reliability-storelab,2681-2.html

--=20
With respect,
Roman

--Sig_/DNrjRtYVE7VbnNyMTd6UfxW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3Z3gMACgkQTLKSvz+PZwicjACgl1hUWEvRDXFbWCugn/0ee7qg
rZkAnRS675scLyH/w1SSIAQRFLK2pvc6
=t2/6
-----END PGP SIGNATURE-----

--Sig_/DNrjRtYVE7VbnNyMTd6UfxW--
