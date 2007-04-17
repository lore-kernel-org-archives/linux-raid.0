From: Tim Dijkstra <newsuser@famdijkstra.org>
Subject: Re: Bug#415441: s2disk and raid
Date: Tue, 17 Apr 2007 20:58:18 +0200
Message-ID: <20070417205818.22fd2d9d@commensaal.drs.p>
References: <20070403175521.70e6c876@commensaal.drs.p>
	<17939.13752.164747.486393@notabene.brown>
	<46140EF5.8080603@tls.msk.ru>
	<20070412053753.GA3602@lisa.rodrigo.nul-unu.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1069514279=="
Return-path: <suspend-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20070412053753.GA3602@lisa.rodrigo.nul-unu.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/suspend-devel>,
	<mailto:suspend-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=suspend-devel>
List-Post: <mailto:suspend-devel@lists.sourceforge.net>
List-Help: <mailto:suspend-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/suspend-devel>,
	<mailto:suspend-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: suspend-devel-bounces@lists.sourceforge.net
Errors-To: suspend-devel-bounces@lists.sourceforge.net
To: Luis Rodrigo Gallardo Cruz <rodrigo@nul-unu.com>, 415441@bugs.debian.org
Cc: Neil Brown <neilb@suse.de>, suspend-devel List <suspend-devel@lists.sourceforge.net>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--===============1069514279==
Content-Type: multipart/signed; boundary="Sig_iueao+HOn0/LKkentQFcptL";
	protocol="application/pgp-signature"; micalg=PGP-SHA1

--Sig_iueao+HOn0/LKkentQFcptL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Apr 2007 00:37:53 -0500
Luis Rodrigo Gallardo Cruz <rodrigo@nul-unu.com> wrote:


> On Thu, Apr 05, 2007 at 12:47:49AM +0400, Michael Tokarev wrote:
> > Neil Brown wrote:
> > > On Tuesday April 3, newsuser@famdijkstra.org wrote:
> > []
> > >> After the power cycle the kernel boots, devices are discovered, among
> > >> which the ones holding raid. Then we try to find the device that hol=
ds
> > >> swap in case of resume and / in case of a normal boot.
> > >>
> > >> Now comes a crucial point. The script that finds the raid array, fin=
ds
> > >> the array in an unclean state and starts syncing.
> > []
> > > So you can start arrays 'readonly', and resume off a raid1 without any
> > > risk of the the resync starting when it shouldn't.
> >=20

> Something that I seem to not have said. It's not *all* arrays that are
> unclean on reboot, just one (that is used as physical volume for
> LVM. I don't know if that's relevant). Also worth mentioning is that
> kernel space suspend on 2.6.17 did not have this problem (or didn't
> show it in my system, anyways).
>=20
> After reading through the responses, I have come to think this is a
> kernel issue, and have posted a report (#418823) to debian's linux-2.6
> package. I'll wait to see what they have to say.

Maybe there is a kernel issue, but we still are doing something wrong;
We shouldn't try to write to raid before we resume, that is just asking
for problems.

I'll look into the `readonly' option. That would fix or problem IMHO.

grts Tim

--Sig_iueao+HOn0/LKkentQFcptL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGJRjPlR+JLH/tVJsRArt/AKDOOFFGeFcZshzkH4CgdaqKS0amcwCggz+V
ARTjKIQ/f7oZNWWJlGvp/cU=
=A42J
-----END PGP SIGNATURE-----

--Sig_iueao+HOn0/LKkentQFcptL--


--===============1069514279==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-------------------------------------------------------------------------
This SF.net email is sponsored by DB2 Express
Download DB2 Express C - the FREE version of DB2 express and take
control of your XML. No limits. Just data. Click to get it now.
http://sourceforge.net/powerbar/db2/
--===============1069514279==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Suspend-devel mailing list
Suspend-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/suspend-devel

--===============1069514279==--
