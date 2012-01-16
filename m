From: NeilBrown <neilb@suse.de>
Subject: Re: Questions about MD 2-drive RAID-10
Date: Tue, 17 Jan 2012 09:59:47 +1100
Message-ID: <20120117095947.3ea17468@notabene.brown>
References: <8C26A4FDAE599041A13EB499117D3C286B66DA76@ex-mb-1.corp.atlasnetworks.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/H6a=y6KnI0a7uNpa4Iq.Spv"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8C26A4FDAE599041A13EB499117D3C286B66DA76@ex-mb-1.corp.atlasnetworks.us>
Sender: linux-raid-owner@vger.kernel.org
To: Nathan Eisenberg <nathan@atlasnetworks.us>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/H6a=y6KnI0a7uNpa4Iq.Spv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Jan 2012 23:27:06 +0000 Nathan Eisenberg <nathan@atlasnetworks.u=
s>
wrote:

> Hi there,
>=20
> It's my first post here!  For some background, I'm a sysadmin at a datace=
nter provider.  I have a large number of MD devices under my control, and a=
 fair amount of experience using MD and the majority of its RAID drivers.  =
Just so I've said it, I did quite a lot of searching before deciding to pos=
t, in the hopes that I could find my answer documented somewhere.  If I've =
missed a good article where my question was clearly answered, then I do apo=
logize (and feel free to mock me for it)!
>=20
> Until a few hours ago, I was under the impression that a RAID-10 required=
 at least four disks, in pairs that form the underpinning mirrors for the s=
tripe.  A few days ago, a customer of mine requested a two drive RAID-10, a=
nd was surprised by my insistence that it was impossible.  Imagine my shock=
 when I stumbled across http://neil.brown.name/blog/20040827225440.
>=20
> http://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10
> This article talks about MD's RAID-10 driver's support for a 2-disk RAID-=
10, in both 'near' and 'far' modes.  It also mentions the potential perform=
ance advantages (over a RAID-1) of using the RAID10 driver in the 'far' con=
figuration on a 2-disk array, but it doesn't say much about the 'near' mode.
>=20
> My question is this: what differences, if any, are there between building=
 a RAID-1 with two disks, and building a RAID-10 with two disks in the 'nea=
r' configuration?  Does this result in the OS 'striping' its reads across t=
he mirrored disks, improving read (but presumably not write) access?  Do I =
correctly interpret the article's suggestion that the 'far' configuration w=
ill result in increased performance for both reads and writes (again, over =
a RAID-1), or am I crazy?
>=20

It works best if questions are one-per-line so that I can write the answers
between the questions.

1/
There is no differences in where the data gets written to the devices.
There are no differences in how data is written.
There might be differences in how data is read.  Each try to 'balance' reads
between the drives, but might do it slightly differently.

2/ no

3/ 'far' is faster for reads and slower for writes in my measurements.  You
should do your own measurements on you own hardware with your own
load-generation to see how it works for you.

4/  no, I don't think you are crazy.   But the jury is still out....

NeilBrown

--Sig_/H6a=y6KnI0a7uNpa4Iq.Spv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTxSr4znsnt1WYoG5AQI5QQ//VXy96n2B/xAI2ja13tB4SVI9Wzi6EYY9
ILJoqxswI0CAwhWd8lrB7fed/10h/TLR0rIXzPATGBHpoF/lE16FtIfyd5t//SjC
1jenEzup4ClQMoLTGdgHNyzmdY960DZEKD8P+tAVrwTBt0VB3YtsJLuHKP1Aq4cB
1trybM48gqOzNnEnpsEqqEiph+mseajlddZ8PlxhD7snGRNcSV/qRyUoOW+yr9pY
E39umxcFWbnnkJkOAX9QWOW6in4MoXrlhog1KfVWKLWUvyEGBG+MVBeWiZQ0Y5mc
GW67T96d8VXhSjnMNdcxYbH1iafWNLlTiiw2USAWvZRr2HuaPJwMe682zP9B9UOp
APkgO4TQBlJ6U/xubkzs7ng4jg/DzzefkBr9R2a8Kb+1i4XkdkwZWXALGa4FCyOH
yoCqRS9K4t9Nc5riW9bmfQJk0rLyMp/YVDyNgT+F8ozoEQO2qP6C0eMuaSnl2GUE
XN57kl8vdtwynFFbZM31E0QXzHWFLO8dXRLYHu/LC2iJA/zQ+XBj2GOP6fRoJyrx
NntF3e+neo+phjqS1cOmfDD+E1l+6Xv07caC1Oq7a76xXJGNIKcnG9/nN2AFpOdD
MECOtInAehJIyH66lhK4X9mHmWboAtz6RjDJ3RO41dYA25ESRb9TzKxKHWfgpRFW
GTxycLM35n4=
=MvpE
-----END PGP SIGNATURE-----

--Sig_/H6a=y6KnI0a7uNpa4Iq.Spv--
