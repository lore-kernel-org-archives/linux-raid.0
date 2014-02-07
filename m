From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Storage system
Date: Fri, 7 Feb 2014 21:14:46 +0600
Message-ID: <20140207211446.4cf96a7f@natsu>
References: <20140206180909.GA2419@lazy.lzy>
	<52F49433.8080904@hesbynett.no>
	<CAJvUf-BTjmxonub0eWGNm1YNp4zYis5Mgti9FuRiQ8RbVY3cXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/MkSFUm6=SusVCJsbxQIrDqz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJvUf-BTjmxonub0eWGNm1YNp4zYis5Mgti9FuRiQ8RbVY3cXQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: David Brown <david.brown@hesbynett.no>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/MkSFUm6=SusVCJsbxQIrDqz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 7 Feb 2014 08:29:19 -0600
Matt Garman <matthew.garman@gmail.com> wrote:

> FWIW, I use a program called "shred" when I'm done with a disk.

Disks are not always alive when they need to be thrown out, I'd say it's ve=
ry
much to the contrary. And while the drive electronics may be bust so it
doesn't even detect in the computer, all your data could still sit perfectly
intact on the plates.

Of course a physical destruction of the disk is an option in this case, but
what if instead of throwing away such a disk, you need to RMA it to the
vendor (or send to a data recovery company)? It's the absolutely worst case:
an untold number of people will have unlimited access to your data after th=
ey
repair the drive, for as long as they want (they can make a full copy).

Having said all of the above, I do think it is an overkill to use encryption
above/below RAID5/6 to protect against such cases. I feel that "they" get o=
nly
a crude haircomb-like view of the data (every 6th 64KB or whatever) is enou=
gh
to effectively make the data unusable.

Of course there's still 1 in 6 chance, for a 6-device RAID, that your
passwords, or your private ssh key, or whatever, will fall entirely into th=
at
64KB portion that was on the drive in question, and someone will be
determined-enough that in the absense of a working filesystem look through
all of the drive and find it. But I think that's a risk we can learn to live
with. :)

--=20
With respect,
Roman

--Sig_/MkSFUm6=SusVCJsbxQIrDqz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlL0+GYACgkQTLKSvz+PZwhdjwCbBO3NJwu+dtOqEJEhI3/Kza3H
sUgAn16kBbtxtkZDHiyFJ0cdWlxm+rjC
=eBNJ
-----END PGP SIGNATURE-----

--Sig_/MkSFUm6=SusVCJsbxQIrDqz--
