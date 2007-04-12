From: Luis Rodrigo Gallardo Cruz <rodrigo@nul-unu.com>
Subject: Re: s2disk and raid
Date: Thu, 12 Apr 2007 00:37:53 -0500
Message-ID: <20070412053753.GA3602@lisa.rodrigo.nul-unu.com>
References: <20070403175521.70e6c876@commensaal.drs.p>
	<17939.13752.164747.486393@notabene.brown>
	<46140EF5.8080603@tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0106891800=="
Return-path: <suspend-devel-bounces@lists.sourceforge.net>
In-Reply-To: <46140EF5.8080603@tls.msk.ru>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/suspend-devel>,
	<mailto:suspend-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=suspend-devel>
List-Post: <mailto:suspend-devel@lists.sourceforge.net>
List-Help: <mailto:suspend-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/suspend-devel>,
	<mailto:suspend-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: suspend-devel-bounces@lists.sourceforge.net
Errors-To: suspend-devel-bounces@lists.sourceforge.net
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Neil Brown <neilb@suse.de>, suspend-devel List <suspend-devel@lists.sourceforge.net>, linux-raid@vger.kernel.org, 415441@bugs.debian.org
List-Id: linux-raid.ids


--===============0106891800==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[I'm the original bug reporter. Sorry for getting so late into the
conversation]

On Thu, Apr 05, 2007 at 12:47:49AM +0400, Michael Tokarev wrote:
> Neil Brown wrote:
> > On Tuesday April 3, newsuser@famdijkstra.org wrote:
> []
> >> After the power cycle the kernel boots, devices are discovered, among
> >> which the ones holding raid. Then we try to find the device that holds
> >> swap in case of resume and / in case of a normal boot.
> >>
> >> Now comes a crucial point. The script that finds the raid array, finds
> >> the array in an unclean state and starts syncing.
> []
> > So you can start arrays 'readonly', and resume off a raid1 without any
> > risk of the the resync starting when it shouldn't.
>=20
> But I wonder why this raid is necessary in the first place.

In the case of my original report, the array is not actually necesary,
since the resume image is in another (normal) partition. The array
gets resumed since the mdadm scripts run before the resume ones in the
initrd and they by default start *every* array in the system.

But at least the mdadm maintainer seems to think that having the
resume image in a raid device, or in an lvm logical volume inside a
raid device, or other such esoteric arangements, is an use case worth
supporting.

Something that I seem to not have said. It's not *all* arrays that are
unclean on reboot, just one (that is used as physical volume for
LVM. I don't know if that's relevant). Also worth mentioning is that
kernel space suspend on 2.6.17 did not have this problem (or didn't
show it in my system, anyways).

After reading through the responses, I have come to think this is a
kernel issue, and have posted a report (#418823) to debian's linux-2.6
package. I'll wait to see what they have to say.
--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGHcWxAZmDGK3JvCgRAv/tAJ0Vgc4mrVUTdUaLLWlgljIH5SrxCgCeI482
qAKQqtWJGeR/JoWlVouu6yk=
=3rVC
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--


--===============0106891800==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys-and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
--===============0106891800==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Suspend-devel mailing list
Suspend-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/suspend-devel

--===============0106891800==--
