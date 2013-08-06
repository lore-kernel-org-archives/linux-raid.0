From: NeilBrown <neilb@suse.de>
Subject: Re: when md raid1 superblock is bad block, what happens
Date: Tue, 6 Aug 2013 11:47:07 +1000
Message-ID: <20130806114707.0c3ffc07@notabene.brown>
References: <CAAL-TMcqej1YYYoCJr3XV7GONYzUR4=8poMnzMcrzTjP7N84KQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/recvJ35=/baXh27Mw6j8IRT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAL-TMcqej1YYYoCJr3XV7GONYzUR4=8poMnzMcrzTjP7N84KQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dong Wu <archer.wudong@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/recvJ35=/baXh27Mw6j8IRT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 6 Aug 2013 09:14:05 +0800 Dong Wu <archer.wudong@gmail.com> wrote:

> Hi all, I have some questions about raid1 superblock and bad block.
> When I create raid1 with two disks, the md will write superblock to
> the disk, if the location of superblock is bad, what will happens?

The drive will be removed from the array.

> Just report create error or add the block to bad-block-list and
> redirect superblock to another place?

No.  That would be nice but it isn't implemented.

> another question, how many bad blocks can be added to bad-block-list,
> when the bad-block-list is full, the raid will degrade?

512 ranges of badblocks.  When it is full the array will degrade.

NeilBrown


>=20
> Thand you
>=20
> Wu Dong
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/recvJ35=/baXh27Mw6j8IRT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUgBVmznsnt1WYoG5AQKLXw//a0lA7bZGZvUgAOjag77H8jdXjCu0pVRJ
OTU6bfKbFliCPIbZW+cJviq+u+Xu5izo7oORFRjcorEdEskrjNcbIiciFBaHH1pY
OtnZQyVcvwycbCKfMIAgj99LjC/YKiUb6nMTyhdNzy3qu0QKE3sBiq/cArHfl+Gk
iC1OKIoBX4UA9Qob1Nyf7wZvUhA1e7+AayjiaAndNowb1eFYVba65eoH5S2KqLAe
RcQYLJmDV0RZV4UGXOHyJLT0LX7u9M8zjrYW0EbtZdQ9rcE5XV53pXE5rgwGONGn
SovBcJEAq0rWr26etvGjpravKaOEm5IGorLxUSE0Msi5uCEdhuuPEZUapXHMV6DO
uD0EnvOMDzLIW6+okp57XoQW4CMbiu8i5dGFf2DPsbSa+k427DFECrbkAr+Q7Kce
+XjbSdFJiYwNzjI8+wE8a1lkI++ku4HWx/cWzo/5ZLyQLjFH0+g/js+ZoUYRzcpr
TtwTwl3yaDXiqLjFuyjml4D/mHhHq6SpvDvbK8wBDnm8V94nzEworKWAINOjt7Jf
rBSnyYKBNhk8vl+2BEhddy3vadL/9kpc1AWJMSjVrKobxGJ6mJKCS/1XIigOkS25
nju+PnzsAFGmev5t6InIaaiOCtMbQagxntESuThx9Dox1UKvy4Nw8KyheDR5yyBZ
wj3D1jtubMg=
=yvxm
-----END PGP SIGNATURE-----

--Sig_/recvJ35=/baXh27Mw6j8IRT--
