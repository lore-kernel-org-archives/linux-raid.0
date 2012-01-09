From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: "md_raid5: page allocation failure" when resyncing on 3.2
Date: Tue, 10 Jan 2012 00:31:07 +0600
Message-ID: <20120110003107.432e4542@natsu>
References: <4F0B2303.4080109@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/V2k8MztZic=eJUOCD+CwRpm"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F0B2303.4080109@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/V2k8MztZic=eJUOCD+CwRpm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 09 Jan 2012 19:25:23 +0200
Konstantinos Skarlatos <k.skarlatos@gmail.com> wrote:

> Hello, i got this kernel message when i was resyncing my md raid 5 array=
=20
> on a linux 3.2 machine.

This probably doesn't have much to do with md, it is a generic Linux kernel=
 failure in the VM subsystem.

If the search on bugzilla.kernel.org was up, I'd point you to bug numbers (=
there was quite a lot of reports), but it isn't, so just see:
http://www.google.com/search?ie=3DUTF-8&q=3Dpage+allocation+failure
https://bugzilla.redhat.com/buglist.cgi?quicksearch=3Dpage+allocation+failu=
re
e.g.: "they are happening during heavy network and disk activity when the s=
ystem has plenty of memory free"
https://bugzilla.redhat.com/show_bug.cgi?id=3D551937
and: "This is very common.  e1000 attempts to do large memory allocations f=
rom within interrupt context and the page allocator cannot satisfy the allo=
cation and is not allowed to do the necessary work to make the allocation a=
ttempt succeed.  It's the same with all net drivers"
http://kerneltrap.org/mailarchive/linux-netdev/2009/4/13/5473414

In your backtrace I see the system was also handling a network transfer wit=
h the r8169 driver; do you use jumbo frames there (MTU over 1500)?
--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/V2k8MztZic=eJUOCD+CwRpm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk8LMmsACgkQTLKSvz+PZwi/7gCeIDGPmY1UrUvfvN0ajIkdrfMy
lSkAnjZHrB5w0BswgJm1UZdo4fg05pwA
=XHbI
-----END PGP SIGNATURE-----

--Sig_/V2k8MztZic=eJUOCD+CwRpm--
