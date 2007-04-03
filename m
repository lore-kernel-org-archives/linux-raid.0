From: Tim Dijkstra <newsuser@famdijkstra.org>
Subject: s2disk and raid
Date: Tue, 3 Apr 2007 17:55:21 +0200
Message-ID: <20070403175521.70e6c876@commensaal.drs.p>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0001936081=="
Return-path: <suspend-devel-bounces@lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/suspend-devel>,
	<mailto:suspend-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=suspend-devel>
List-Post: <mailto:suspend-devel@lists.sourceforge.net>
List-Help: <mailto:suspend-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/suspend-devel>,
	<mailto:suspend-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: suspend-devel-bounces@lists.sourceforge.net
Errors-To: suspend-devel-bounces@lists.sourceforge.net
To: suspend-devel List <suspend-devel@lists.sourceforge.net>, linux-raid@vger.kernel.org
Cc: 415441@bugs.debian.org
List-Id: linux-raid.ids

--===============0001936081==
Content-Type: multipart/signed; boundary="Sig_efMB5KA60kiFaVL=sLim455";
	protocol="application/pgp-signature"; micalg=PGP-SHA1

--Sig_efMB5KA60kiFaVL=sLim455
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

I've got a bugreport [0] from a user trying to use raid and uswsusp. He's
using initramfs-tools available in debian. I'll describe the problem
and my analysis, maybe you can comment on what you think. A warning: I only
have a casual understanding of raid, never looked at any code related to it.

This is a setup where root maybe on raid, but swap isn't. Swap on raid
will be very difficult to support, I think.

When s2disk is started, nothing special is done to the array. It may be
in an unclean state (just like filesystems). Image is written to disk.

After the power cycle the kernel boots, devices are discovered, among
which the ones holding raid. Then we try to find the device that holds
swap in case of resume and / in case of a normal boot.

Now comes a crucial point. The script that finds the raid array, finds
the array in an unclean state and starts syncing.

After this, resume finds an image in the swap partition and starts the
resume process. Part of this process is freezing everything but itself,
which fails on the process/thread that does the syncing.

IMO, the problem comes from the fact we started syncing, before we could
start resume.=20

Now the problem could theoretically be solved by not starting the
assembly of the array once it is discovered, but modifying the=20
initramfs to do the assembly after we have had the chance to resume.

The debian-maintainer of mdadm thinks that the suspend process should
have left the array in a clean state, but this is IMHO impossible. We
are freezing userspace. A mdamd process looking after the array will
probably get into trouble if we come back from suspend and we have
done something to the array in the mean time.

What do you think?

grts Tim

[0] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D415441

--Sig_efMB5KA60kiFaVL=sLim455
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGEnjrlR+JLH/tVJsRAguLAJ9emEtwUu9WxsJthRXapBmMKTqL0gCgpbgD
5iMqi6HJs6KN7ONbn/oxJYI=
=f0F3
-----END PGP SIGNATURE-----

--Sig_efMB5KA60kiFaVL=sLim455--


--===============0001936081==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys-and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
--===============0001936081==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Suspend-devel mailing list
Suspend-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/suspend-devel

--===============0001936081==--
