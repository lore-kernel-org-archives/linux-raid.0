From: Sergey Vlasov <vsu@altlinux.ru>
Subject: Re: avoiding the initial resync on --create
Date: Tue, 10 Oct 2006 23:18:28 +0400
Message-ID: <20061010231828.72d68502.vsu@altlinux.ru>
References: <20061009125700.GA10191@piper.madduck.net>
	<20061009134946.GA26122@harddisk-recovery.com>
	<1160411520.2917.76.camel@fc6.xsintricity.com>
	<20061010095524.GF7416@boogie.lpds.sztaki.hu>
	<1160502476.2917.134.camel@fc6.xsintricity.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__10_Oct_2006_23_18_28_+0400_j2v/Ih5t4zPXiJG/"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1160502476.2917.134.camel@fc6.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Gabor Gombas <gombasg@sztaki.hu>, Erik Mouw <erik@harddisk-recovery.com>, linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Signature=_Tue__10_Oct_2006_23_18_28_+0400_j2v/Ih5t4zPXiJG/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Tue, 10 Oct 2006 13:47:56 -0400 Doug Ledford wrote:

[...]
> So, like my original email said, fsck has no business reading any block
> that hasn't been written to either by the install or since the install
> when the filesystem was filled up more.  It certainly does *not* read
> blocks just for the fun of it, nor does it rely on anything the
> filesystem didn't specifically write.

There are fsck implementations which read potentially unwritten
blocks.  E.g., reiserfsck --rebuild-tree reads every block on the
device, finds anything which looks like a tree block and tries to
do something with it.  This procedure sometimes recovers files
which were deleted, and if an uncompressed image of a reiserfs v3
filesystem was stored in a file on reiserfs, it can confuse
reiserfsck badly...

--Signature=_Tue__10_Oct_2006_23_18_28_+0400_j2v/Ih5t4zPXiJG/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFK/IQW82GfkQfsqIRAscdAJ0VoHkiOJ9XFMvO156571PDoQZc5ACePrxq
VY7H8d0ehYlIFoYVthx9Qyo=
=sa0c
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Oct_2006_23_18_28_+0400_j2v/Ih5t4zPXiJG/--
