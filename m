From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: mdadm raid5 with lvm: advantages?
Date: Tue, 11 Jan 2011 23:49:45 +0500
Message-ID: <20110111234945.7c601067@natsu>
References: <AANLkTineOZXNQaGoF_WDnzHbzvCq0=Fi+kw=TseV+agQ@mail.gmail.com>
	<4D2CA32E.3030303@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CbtJifDNDojscvuRQwloVld"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D2CA32E.3030303@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zdenek Kaspar <zkaspar82@gmail.com>
Cc: Richard Grundy <richguk@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/CbtJifDNDojscvuRQwloVld
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Jan 2011 19:36:30 +0100
Zdenek Kaspar <zkaspar82@gmail.com> wrote:

> It makes sense to use LVM for virtualization and iSCSI to get rid of big
> file images (unwanted fs overhead/fragmentation). But yes, in some use
> cases this is OK.

Since you mentioned fragmentation - there are ways to both make sparse file
images, and to defragment them when needed (on some filesystems like XFS and
btrfs). But when using LVM instead of file images, the user has neither: LVM
can't have sparse LVs, and it can't (easily) defragment an LV that is
fragmented over one or several PVs. Or am I missing something here?

--=20
With respect,
Roman

--Sig_/CbtJifDNDojscvuRQwloVld
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0spkkACgkQTLKSvz+PZwhI8gCglIDnrPrFGiFpJYr2Xqqxa0R7
w8UAniLih1j+7tyhdjAHC/7aLq48eaGX
=k2KG
-----END PGP SIGNATURE-----

--Sig_/CbtJifDNDojscvuRQwloVld--
