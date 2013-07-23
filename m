From: NeilBrown <neilb@suse.de>
Subject: Should "mdadm --add" complain if the new device appears to have a
 filesystem on it?
Date: Tue, 23 Jul 2013 11:39:02 +1000
Message-ID: <20130723113902.62368e3e@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_CXNwRr6=l+zFv6rcBSgR.6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux RAID <linux-raid@vger.kernel.org>
Cc: Christian Iversen <chrivers@iversen-net.dk>
List-Id: linux-raid.ids

--Sig_/_CXNwRr6=l+zFv6rcBSgR.6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


As you probably know, when you use "mdadm -C" to create an array, it will
check if the devices appear to contain a filesystem or similar already and
will complain if they do - requiring you do say "yes" or use "--run" to avo=
id
the warning.

However if you use "--add" to add a device to an existing array no such
checks are done.  So it isn't too hard to destroy all those cat photos you
have saved on a USB drive (because device names change every time you boot
and you got confused).


I could easily change "--add" to be more cautious, but that might break
existing scripts, which I would rather not do.

Or I could add a "policy" line to mdadm.conf which would indicate the policy
for "--add" - either "spare" or "force-spare".  But then I would need to
decide on a default.  The default should probably be safe otherwise people
probably won't change it until they get burned.  So people with scripts wou=
ld
still experience breakage, but could now fix it easily with a "policy" line.

Or maybe "--add" should be deprecated so people have to choose between
"--re-add" or a new "--spare" with --spare requiring "--force" to destroy
data.
Then "--add" would generate a deprecation message which scripts could  igno=
re
but people might learn from.


I don't think there is an obviously-correct answer here so I'm open to
suggestions.  What do people think?

NeilBrown

--Sig_/_CXNwRr6=l+zFv6rcBSgR.6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUe3etjnsnt1WYoG5AQICNRAAr83MKoPinj7PSpjVXYNpA+LKEsbD/R3J
zu24+yQv9Rp/roxPEQfpEc7hDl5hlWra4PZsGBrtbICLjDTrTNvedSnKTYN6tIqm
VmNfCpaay5uKFT1Ncssxobts/kKLGd1qtcjAlP39zKJd206R6/YAHwsmxzCUoKi5
/9d6ykuBfibOx7k8AF01PfNK6deI3kM/LrDs2bGAYx9M1pLZAyL3W2z2h5PFFXBQ
2NmJFRx4lMWwtzAXJH+IfowuIG2d8vNrtzdm32X0MgWzrYda7TowWB87VTwGjAuR
Jz3zScn63x4VfMHJ+LvvttFjCrbrrQ25KaWsxmqyt8TtAtjpZbT9vN3vZCvzD4VY
MLph1A4fxjLUaP6oJfbrC7KKBW+3iB4b2DRO9dso6j2p65w6eB7MjeS15U/TRtdl
zmvECOCFjyrjXEXrw35+endWsrZmLskbE4AQ8Uknc2e/EA0qk9DCp573O0s9Nnn/
ruwjqDFPCkaCY7LKjSTYBBz6oHHPpu9txVekaaYZv50Ydq6js5XCMYi0B9iC2ZEd
Df+a+jWrK9l/p/FisgTodIboewZ2Ex/ajqdDst1KRDSVdwKded/ZDJmn0tDte+2s
xaDfMYqFdR5kNqA/JmvzHs8AIbrzFhfhT3F9veLwOlKZo6RwRoljbLMziCHVSlTn
0goHJx5UPEo=
=cxNV
-----END PGP SIGNATURE-----

--Sig_/_CXNwRr6=l+zFv6rcBSgR.6--
