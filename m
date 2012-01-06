From: Johannes Truschnigg <johannes@truschnigg.info>
Subject: Re: What just happened to my disks/RAID5 array?
Date: Fri, 6 Jan 2012 16:28:19 +0100
Message-ID: <20120106152819.GA3061@vault.local>
References: <4E6F13F7.6070507@truschnigg.info>
 <4E6F4091.7050206@turmel.org>
 <4E6FA76A.90206@truschnigg.info>
 <4E7092F1.5010209@turmel.org>
 <4E70EFA8.4080706@truschnigg.info>
 <4E70FE5B.5080601@turmel.org>
 <20120106105143.GA2932@vault.local>
 <4F06F410.4070807@turmel.org>
 <20120106134625.GA3027@vault.local>
 <4F070A74.3010208@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F070A74.3010208@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 06, 2012 at 09:51:32AM -0500, Phil Turmel wrote:
> [...]
> https://lkml.org/lkml/2012/1/5/76
>=20
> Note that it involves ext4 and LVM snapshots, so may not apply to you.  B=
ut the
> bug hasn't been clearly identified, so my paranoid approach to kernels wo=
uld
> keep me off of it. (On production systems, of course.  I regularly run -rc
> kernels on my laptop.)

I arrived at the same conclusion, and decided to stick with 3.2.0 for now.

> [...]
> You would need them if you ever ran into some catastrophic problem where
> "--create --assume-clean" was needed.

Thanks, I will keep that information in a secure place then.

> [...]
> Actually, given the /proc/mdstat contents you reported, you might be able=
 to just
> do "mdadm --run /dev/md0"

Probably, yes. I stopped the array, --assemble --force'd it, and everything
was up again. The LVM metadata proved consistent, and a read-only fsck of t=
he
filesystem on top of the only LV defined on the array told me that there we=
re
some (very) minor fs inconsistencies. They were corrected by a secind fsck
run, and everything seems perfectly fine again :) I don't keep checksums of
the inodes' data, but I tested with a bunch of archives stored in the fs, a=
nd
there were no CRC errors or the like to be found.

> The output will change substantially, as it attempts to map the entire
> storage tree, reporting all serials, uuids, and labels, along with other
> useful information.  I have a future number of enhancements in mind, but
> it's a spare-time project.  I'm glad you like it, though.

I noticed it did, yes - it's even more nifty than I thought ;) I noticed th=
at
it would die with an uncaught exception (sorry, I had noted it down in a fi=
le
in /tmp, but I involuntarily lost it upon rebooting) if you had an LVM VG/LV
showing up in `lvs` that wasn't "active"/had no corresponding device nodes =
in
/dev; you may want to look into that some time.

> You don't need the report for this incident, though.  Just stick it with =
your
> backups.  And make a new one any time you change your setup.

Will do. Thanks again for your guidance and support! Have a nice day!

--=20
with best regards:
- Johannes Truschnigg ( johannes@truschnigg.info )

www:   http://johannes.truschnigg.info/
phone: +43 650 2 133337
xmpp:  johannes@truschnigg.info

Please do not bother me with HTML-eMail or attachments. Thank you.

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8HExMACgkQnnUApj8OcoLQVgCfXO4FoWmkS/X7PALyBFnoozEl
B5IAnj0kBdDAyQld+ar9QaaWkrLDtZqA
=MpA9
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
