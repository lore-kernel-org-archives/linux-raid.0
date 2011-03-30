From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Network-based RAID6
Date: Wed, 30 Mar 2011 14:49:44 +0600
Message-ID: <20110330144944.3c87185c@natsu>
References: <20110330131157.49fd2521@natsu>
	<AANLkTimGK49-XtV9CsfL90bKpb=e9tRRos7fJ50WzNHd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Mizx6BAu+d1pQjiIuH8GddO"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimGK49-XtV9CsfL90bKpb=e9tRRos7fJ50WzNHd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Mizx6BAu+d1pQjiIuH8GddO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Mar 2011 11:20:41 +0400
CoolCold <coolthecold@gmail.com> wrote:

> Looking on your host I think you speak russian, so may be this will be
> somehow helpful for you
> http://community.livejournal.com/ru_root/2216389.html

Thanks -- I have looked through the websites of some distributed filesystems
(Ceph, GlusterFS, MooseFS etc) and checked this thread too, but from what I
could find, all filesystems I read about so far are at most capable of RAID=
0 or
RAID1-like modes, where fault-tolerance is either not provided, or achieved
only by "all data is replicated across N nodes", which of course divides the
total usable space by N. I haven't found any FS which would do block-level
replication relying not on dumb copies, but on RAID5/6-like parity algorith=
ms
for fault-tolerance. Maybe I missed something?

--=20
With respect,
Roman

--Sig_/Mizx6BAu+d1pQjiIuH8GddO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2S7qgACgkQTLKSvz+PZwhXPwCeL7MhqAuHot7oEhg08887ujJY
JmUAoJgFhKpclT9iWSgS06kYQN84xaOt
=VJKp
-----END PGP SIGNATURE-----

--Sig_/Mizx6BAu+d1pQjiIuH8GddO--
