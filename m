From: NeilBrown <neilb@suse.de>
Subject: Re: md device is read only mode
Date: Mon, 9 Jul 2012 11:40:22 +1000
Message-ID: <20120709114022.58f5d52b@notabene.brown>
References: <20120705172748.GA6464@lazy.lzy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PuVg+0.ma6ZA_t13y0hSZdY"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120705172748.GA6464@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/PuVg+0.ma6ZA_t13y0hSZdY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 5 Jul 2012 19:27:48 +0200 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> Hi all,
>=20
> following the comment of Neil about the fact that
> an md device, in r/o mode, will BUG() in case of
> write attempt, I would like to ask for some more
> information on the topic.
>=20
> The problem is the following, mounting a filesystem
> in r/o does not, correctly, prevent writes to the
> underlying device.

This is only half the story.
If the mount command requests read-only, the filesystem may still write to
the device.
However if the device is marked read-only then the filesystem should not
write to the disk - if it finds that it needs to, it should fail the
mount request.
I believe that filesystems behave correctly in this manner, though there
could still be bugs lurking.

>=20
> Now, assuming a filesystem is mounted r/w over an
> md device, being r/w too, it is pretty clear that
> switching the md device to r/o will create problems.

Not quite.  When the filesystem is mounted, md will refuse to switch the
device to read-only, so that scenario is not possible.

>=20
> What if the md device is started in r/o mode and
> than, later, the filesystem is mounted *without*
> specifying r/o mode?

The mount system call will notice that the device is read-only, and will ma=
ke
assume the read-only mount option.

>=20
> The filesystem might try to write to the device,
> but it will not work, of course.
> Does this will cause a BUG() in md?

Only if there are bugs.

>=20
> Because using a r/o memory card, there are no
> problems, the mount recognize the device is r/o
> and it sets the filesystems r/o too.
> I do not know if it anyway tries to write to the
> r/o device, ignoring the errors reported.
>=20
> I would say that, if md BUG() in any case, it
> could be a bug... :-)
>=20
> Any comments?
>=20
> Thanks,
>=20
> bye,
>=20

NeilBrown

--Sig_/PuVg+0.ma6ZA_t13y0hSZdY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/o2hjnsnt1WYoG5AQIIKBAAsAq/VGm4J1sh4JJB1/608BZzrY0ytKm0
OGDXqbOeTIZGYCWKjAMGgaJKfq0aNIiolq+Pff+9MZrfRNLGkS4WrQ1iED7gd1/M
iv5yQbhrctnjJCi9EvZUa80hvtUI/4+prT5IewDtc33odueNCjwq2PHASbTJBSm/
amYu72SSp3GZyBMjaN5Bwwx9ip5GQT/scGvy95f9DdBbZVMJsEda7w5UKQLdlzeG
IBESXF5M/vXkgjQOHDuM0xIE0Y7T96WXKyE5gUV3n2ATfmO8GLQiBMWFybeYEmKH
pK0yNV4xH1wAoJrs47L8YKmVCoPa2KW7x/NP19h7EndrgM4oXhG7f0w4Jg09HcZI
dF4jZL2C2JZzlq7R3BVQLCD7C6GtUdNUFm3czy3eT7ujlxNGxrcSLb/BsUd2qwLk
Ta4pFvu9pTJ+wJwQvk+TqBs4asIrmnxHR0CE/Aa6W+aigGC2SV2RVL2ZwJJiYbmt
Ln3BYW+LizmOpzhz6HlCmWiqtH98Bl3Do+MEX6dPLGklTXeM7nU2vSaB+dZk4Hmn
tXBoja4+OZq6YibBF5K3jM4kOFmHIKPbQukP4+SWN8tH7yXW2aQ33zhgz+YmN25o
5nbjSBorTA3PqjDSMfEwKoRQUR1gtwbV4Q233N3Ne2G/7WUucsD4YDqq1HzRGVrd
PTj0cB50K1w=
=Gn67
-----END PGP SIGNATURE-----

--Sig_/PuVg+0.ma6ZA_t13y0hSZdY--
