From: NeilBrown <neilb@suse.de>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually
  by user
Date: Wed, 2 Nov 2011 13:03:34 +1100
Message-ID: <20111102130334.09c3ab51@notabene.brown>
References: <20110125042814.GA9727@tango.0pointer.de>
	<AANLkTik7dd5SHkuBVrS6LLDR9v57GsFjjxDKQKPp-YVL@mail.gmail.com>
	<20110208094843.GD11446@tango.0pointer.de>
	<AANLkTi=rFoqBwKdd0B3Xx6JrGdJdut0a2r=wFh0oSx73@mail.gmail.com>
	<20110208110730.GF23157@tango.0pointer.de>
	<AANLkTinmO9gsJcwr+0bGGuVJfF2dyM5rDJqqSkmh_hqs@mail.gmail.com>
	<20110208172822.GC21847@tango.0pointer.de>
	<CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com>
	<20111031110613.GA1402@tango.0pointer.de>
	<20111102114416.7879b77f@notabene.brown>
	<20111102011615.GA5289@tango.0pointer.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ukHig3KD_EH=ihm+G.9sSnl"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102011615.GA5289@tango.0pointer.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lennart Poettering <lennart@poettering.net>
Cc: Dan Williams <dan.j.williams@intel.com>, Andrey Borzenkov <arvidjaar@mail.ru>, Tomasz Torcz <tomek@pipebreaker.pl>, systemd-devel@lists.freedesktop.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ukHig3KD_EH=ihm+G.9sSnl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 2 Nov 2011 02:16:15 +0100 Lennart Poettering <lennart@poettering.ne=
t>
wrote:

> On Wed, 02.11.11 11:44, NeilBrown (neilb@suse.de) wrote:
>=20
> > > We nowadays jump back into the initrd when we shut down, so that the
> > > initrd disassembles everything it assembled at boot time. This for the
> > > first time enables us to ensure that all layers of our stack are in a
> > > sane state (i.e. fully offline) when we shut down, regardless in which
> > > way you stack it.
> >=20
> > This sounds particularly elegant.
> > Is there some part of the filesystem, that survives through the whole p=
rocess
> > - from before / is mounted until after it is unmounted?
> >
> > Presumably this would be /run if anything.
>=20
> Yes. /run is usually mounted by the initrd these days, and the initrd
> itself places its binaries in /run/initramfs/ which systemd then
> pivot_root()s into at shutdown.
>=20
> > mdmon must be running from the time that / becomes writable until after=
 it
> > becomes readonly.
>=20
> I'd really prefer if we could somehow make it something that isn't
> special and we could just shutdown

It must remain running until the array that it manages is read-only and will
never be written to again.  Then it can be shutdown gracefully.
It may be awkward to shut it down gracefully at the moment - I'm not sure. =
 I
can certainly fix that.


>=20
> > If we can have it from before it is mounted until after it is unmounted=
, that
> > might be even better.
>=20
> Well, that could work if mdmon is invoked in the initrd only. If mdmon
> is always running from the initrd this would solve the issue that it
> keeps files on the real root referenced thus making unmounting of /
> impossible.
>=20
> However, there might be complexities here: what happens if the user
> creates an MD device during normal operation, so that mdmon is started
> at runtime, and not from the initrd?

Each instance of mdmon manages a set of arrays and must remain running
until all of those arrays are readonly (or shut down).  This allows it to
record that all writes have completed and mark the array as 'clean' so a
resync isn't needed at next boot.

If a user creates an array while the system it running, it will not have the
root filesystem on it.  So between unmounting the last non-root filesystem
and unmounting root it is perfectly OK to stop that mdmon.


>=20
> That said I definitely prefer that if mdmon really wants to avoid
> systemd and live independent of it that it does so by being invoked from
> the initrd, so that it runs completely independently from all systemd
> book keeping.=20
>=20
> If this is what you want, then we could come up with a simple scheme
> like "a process owned by root who has +t set on /proc/$PID/stat" is
> excluded from systemd's killing.

You couldn't just do the equivalent of
  fuser -k /some/filesystem
  umount /some/filesystem

iterating over filesystems with '/' last?

Then anything that only uses the /run filesystem will survive.


>=20
> But again, I really think that mdmon should just be fixed to become a
> daemon that can be shtu down at any time.
>=20
> > (It is possible to start a new one which replaces the old one but if th=
at was
> > only used for version upgrades, that would be best).
>=20
> If you do upgrades like that then you end up with a version of mdmon
> running that is still referencing the root dir. That means the initrd
> disassembling will break.

True.  A version upgrade would need to stash the binary in /run.
It might be better to go the 'remount-readonly - then stop mdmon' route.

>=20
> > So if mdmon has a 'cwd' and all open files in /run (and the executable
> > elsewhere in the same filesystem), could it easily survive the 'kill all
> > processes before unmounting /' thing?
>=20
> Right now no. But if the +t scheme would work for you we could at
> that. But you'd need a good story how to handle upgrades and arrays that
> are assembled during ruintime (i.e. after initrd)?
>=20
> > > However, just excluding mdmom from being killed will not make this wo=
rk,
> > > simply because jumping into initrd only works sensibly if we can drop
> > > all references to all previous mounts which requires us to have only =
one
> > > process running at that time, and one process only.
> > >=20
> > > It always boils down to the same thing: mdmon must be something we can
> > > shutdown cleanly like every other process. Excluding it from that will
> > > just move the problem around, but not fix it.
> >=20
> > My ideal would be that you just ignore mdmon.
> > After unmounting '/', you shutdown md arrays with "mdadm -Ss" and then =
mdmon
> > will spontaneously disappear.
>=20
> That's still a chicken and egg problem. We cannot unmount / until all
> references to files on / are dropped. For that we need all processes
> running from it terminated. That means mdmon needs to go first, and only
> then we can unmount /.
>=20
> Lennart
>=20

Does, or can, systemd remount '/' readonly before trying to unmount it and
allow some task to run at that point?

I guess it still needs to be able to differentiate processes that are holdi=
ng
write-access to the filesystem and so need to be killed, from processes are
only holding read-access and so can be permitted to remain.

Probably easiest for  mdmon just register itself as "Leave this until / is
readonly" - maybe by putting it's pid file in
    /run/preserve-until-readonly/mdmon-devname.pid

I don't quite get your "+t on /proc/$PID/stat" suggestion:

# chmod +t /proc/self/stat
chmod: changing permissions of `/proc/self/stat': Operation not permitted


NeilBrown

--Sig_/ukHig3KD_EH=ihm+G.9sSnl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrCk9jnsnt1WYoG5AQLLLg/5AQkL+Qs4rolrHG+M7cPlCFKAnB9vOeDh
lEBAxTA1ZDlOHN4SVkS3NpFSwB4EHRuIPRY31klniZlRCQ6jmYlwm+pS54d8KeB7
r0XQg0APcWUd/egGuwy2C/9+Hp8r5c/Ul1ln19DHVdPeVrmy+seUvTxcrv0MSED6
XZ0iaW0sf8TDYyl3QOVo5K//9vfr1H3nfSrURpBGZWHTg6j/b287lDN5i41N9aoV
63tuXp594u0ElvCgAy4OEKa3mR25Ay2LtMD1/rLIJuRgIHT1cyFutyb8N9vy6M8i
rEXA4ez2Jf+3PDl/NghfQ5OtZnAPFxQihLoYKRBAUxknoa1uQMNf+a+eeU+T28DN
DzLlusA5f2vtoLeLbOy9g5Q7ymkzd7T2ffFLt96Vgpu1/yxCtt2QC3HFvXzc00+H
PIKe7EertpO4guNcThxDmqj23fgYuaOXBsu+zfzc8g71hTpCLpF27g1rlGj04kKc
J2IKPpSy9qEv3lW+bkr3LvKw7iXKdQEl88OD3ymI/1kTeuJZnhH+HAgRTiF3/f+o
859P7cU0wZjeO58RdlKbjKLJa4u5VojzKKs4IkuPnnlXWimIWrERhmI9q33HYpi0
ycbiVliaXl4nZ86nqQIgfGFze+Hm4cnoAQBHkqTuygoO/RcvPYA+c4VhxWyR+bsy
B9iFIiuRrZc=
=REDm
-----END PGP SIGNATURE-----

--Sig_/ukHig3KD_EH=ihm+G.9sSnl--
