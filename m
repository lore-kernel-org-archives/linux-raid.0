From: NeilBrown <neilb@suse.de>
Subject: Re: Question about commit 02e7c5b75cd4ad5176441add156389c71dab6e3a
 - avoid including wayward devices
Date: Thu, 24 May 2012 15:04:30 +1000
Message-ID: <20120524150430.2bb4288c@notabene.brown>
References: <CAGRgLy6RFRQqB0VtV-=C2v+TCu4yKJEOR3i=zF_5yxTtVCHWZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+9KLcALhv1NxGkkC5C.MXdq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6RFRQqB0VtV-=C2v+TCu4yKJEOR3i=zF_5yxTtVCHWZw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/+9KLcALhv1NxGkkC5C.MXdq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 22 May 2012 15:59:50 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> can you pls give some details on that commit.
>=20
> As far as I understand, this change attempts to protect from
> split-brain, most typical to RAID1 (but also, e.g., to 4-drive RAID6)
> , where part of a mirrored set was assembled independently. The code
> first selects "most_recent" based on event count (as usual). Then it
> applies the map check to all those devices that are not "most_recent",
> and might kick them out, if it detects split-brain.
> However, when there is such split-brain, and parts of mirrored sets
> are assembled independently, the highest event count does not really
> tell us which part of the mirrored set is "more up-to-date". This is
> because event count is not tied to any hard clock or something like
> that. So there is really no way to tell what part of the mirrored set
> will be picked up here (WRT to user activity on the separate mirrored
> sets).

In a split brain situation *neither* side is "more up-to-date".  They are
both simply "differently up-to-date".  A wall-clock based event count would
not change this fact.

>=20
> What I am trying to say, I guess: don't you think that in such case,
> it would be better to warn the user and abort, and not pick (more or
> less) arbitrary part of the set? Or, in other words:) might you
> reconsider looking at some ideas for split-brain protection I pitched
> some time ago?:))

This is a policy question and so I am happy for an extension to the new
"policy" mechanism in mdadm to allow finer control for managing it.
I'm fairy sure that I think the default should be the current behaviour.
If you are assembling the arrays with "-I" it not really possible to reject
the first half of the brain that is found, so I don't think we should when
assembling with "-A".

I'm afraid I don't particularly remember the ideas you pitched before.  Feel
free to pitch them again -- and repeat every few weeks until you get an
answer :-)

NeilBrown

--Sig_/+9KLcALhv1NxGkkC5C.MXdq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT73BXjnsnt1WYoG5AQKBZxAAwSeeUp4kME+qsnZTHsCAbBa3YIi4B9ga
kUUFlAlJiALN4JySricjsbRajnNMVjqA5zc5Z++9jnGeTb+EOe7DlzuKP24Ncmar
C9wtlJuLGnNytP84uthoMLQPwcd4x9QOEm4fMwd2lNj7t3zRiysbMBW3D1vnfphV
Ms+b8i/MjE7CIeYEFJJek6Bz9RF91N5mgF52XP3vPSmE1BNd8mHebtBo6Qs2NiGm
3X4vHhJuBhjhKyrAYU0RiDrCK7liDaNJkhxG/HgMKvP5QPOcp2d/JCAwzxKP7s+A
BcWWojE7Exgt5T9s6buKhuJNYhg3QpJ+jeAAYrBgSdGYEuufgM2aCxT88fumxM2i
kxz1PtCLXXTYmvD2vyOFKQs6312f0BsreRy/MAxRgB7XBrwHUqipP/XBbAwSruXu
Dne1xHCTrKenl7afpp2As8gzpG6xgGtGe/FvpU7/Jw2095iJctafu2MUce4iQgF1
hzgTNrwu2uR78Afg30Sgj7IY/ddTkg8gICsQDLD3jp/tVA3WQH8JtQ4Pvj4X+r1T
8JHlxyWkWSC8+iceptL1qdnN9JaV8f3v9CBextOWxE/F+8YbHEawOkLG1rAxROvx
HK2PmwMuCHow99Yk5lKktONKh6wvIWYuoYg0NsfyMHpcKPplRp4Cx1xO4dHLSxJW
whILZjzceHM=
=wleg
-----END PGP SIGNATURE-----

--Sig_/+9KLcALhv1NxGkkC5C.MXdq--
