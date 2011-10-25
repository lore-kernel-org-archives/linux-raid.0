From: NeilBrown <neilb@suse.de>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually
 by user
Date: Tue, 25 Oct 2011 12:40:50 +1100
Message-ID: <20111025124050.397c6546@notabene.brown>
References: <20101204121413.GC11336@mother.pipebreaker.pl>
	<AANLkTi=nTSdHc55f08G9sdEK6u8eXp276VOTHHr0jmXT@mail.gmail.com>
	<20110125034434.GC7046@tango.0pointer.de>
	<AANLkTik189VTXYpzLFqP=MNBg=Nx-Yq6BOKURtiby++B@mail.gmail.com>
	<20110125042814.GA9727@tango.0pointer.de>
	<AANLkTik7dd5SHkuBVrS6LLDR9v57GsFjjxDKQKPp-YVL@mail.gmail.com>
	<20110208094843.GD11446@tango.0pointer.de>
	<AANLkTi=rFoqBwKdd0B3Xx6JrGdJdut0a2r=wFh0oSx73@mail.gmail.com>
	<20110208110730.GF23157@tango.0pointer.de>
	<AANLkTinmO9gsJcwr+0bGGuVJfF2dyM5rDJqqSkmh_hqs@mail.gmail.com>
	<20110208172822.GC21847@tango.0pointer.de>
	<CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3T5yF6.eoU+80zVpVbOKoWu"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Lennart Poettering <lennart@poettering.net>, Andrey Borzenkov <arvidjaar@mail.ru>, Tomasz Torcz <tomek@pipebreaker.pl>, systemd-devel@lists.freedesktop.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/3T5yF6.eoU+80zVpVbOKoWu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 23 Oct 2011 01:00:36 -0700 Dan Williams <dan.j.williams@intel.com>
wrote:

> On Tue, Feb 8, 2011 at 9:28 AM, Lennart Poettering
> <lennart@poettering.net> wrote:
> > On Tue, 08.02.11 16:54, Andrey Borzenkov (arvidjaar@mail.ru) wrote:
> >
> >> >> a) mdmon is perfectly capable of restarting, it is already used to
> >> >> take over mdmon launched in initrd. The problem is to know when to
> >> >> restart - i.e. when respective libraries are changed. This is a job
> >> >> for package management in distribution. It is already employed for
> >> >> glibc, systemd and some others and can just as well be employed for
> >> >> mdmon. And this is totally unrelated to systemd :)
> >> >
> >> > Really, you are sying there is a synchronous way to make mdmon reexec
> >> > itself? How does that work?
> >> >
> >>
> >> I am not sure whether it qualifies as synchronous, but "mdmon
> >> --takeover" will kill any existing mdmon for this and start monitoring
> >> itself.
> >
> > I wonder if this is really fully synchronous, i.e. that a) there is no
> > point in time where mdmon is not running during this restart and b) the
> > mdmom --takeover command returns when the new daemon is fully up, and
> > not right-away.
> >
> >> > Well, the root file systems cannot be unmounted, only remounted.
> >> >
> >> > So, is there a way to invoke mdmon so that it flushes all metadata
> >> > changes to disk and immediately terminates then this should be all we
> >> > need for a clean solution. We'd then shutdown the normal instances of
> >> > mdmon down like any other daemon and simply invoke this metadata
> >> > flushing command as part of late shutdown.
> >>
> >>
> >> Hmm ... it looks like you just need to
> >>
> >> start mdmon
> >> do mdadm --wait-clean
> >>
> >> After this you can kill mdmon again (assuming decide is no more in
> >> use).
> >
> >
> > Well, it would be nice if the md utils would offer something doing this
> > without spawning multiple processes and killing them again.
> >
>=20
> /me wonders why his raid5 resyncs every boot on Fedora 15 and has
> found this old thread.
>=20
> I'm tempted to:
>=20
> 1/ teach ignore_proc() to scan for pid files in /dev/md/ (MDMON_DIR on Fe=
dora)
> 2/ arrange for mdadm --wait-clean --scan to be called after all
> filesytems have been mounted read only
>=20
> ...but a few things strike me.  This does not seem to be what was
> being proposed above.  Systemd does not treat dm devices like a
> service and takes care to shut them down explicitly (but in that case
> there is an api that it can call).  Is it time for a libmd.so,  so
> systemd can invoke the "--wait-clean --scan" process itself?  Probably
> simpler to just SIGTERM mdmon and wait for it.
>=20
> --
> Dan

Hi Dan,
  could you please explain in a bit more detail exactly what you think it is
  that is going wrong for you?

  I don't think it is anything like the original problem, as I don't think
  you are starting array manually.

  I think your problem is that 'mdmon' is being killed too early at shutdow=
n.
  Clear we need to get whatever-kills-user-processes to skip mdmon - maybe =
by
  writing the pid to some magic file that 'ignore_proc' already knows about?

  Ultimately we probably want to get udev to start mdmon for us and have
  mdadm notice and not start it itself.
  We also need to get udev to notice arrays that are being reshaped and to
  start the mdadm which montiors the reshape so that mdadm doesn't have to
  fork it itself.

  That should fix the original problem, but I don't think it addresses your
  problem at all.

  I don't have a Fedora install so I cannot hunt around to see what is
  happening.

  I don't like the idea for a 'libmd.so' at all - certainly not until the
  problem is properly understood and other solutions (like running
  scripts) prove ineffective.

NeilBrown

--Sig_/3T5yF6.eoU+80zVpVbOKoWu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqYTqDnsnt1WYoG5AQKByw//f/wmMD75otrvOM2lSNs5ocKN6yq9EGj9
w6zIPz28rbS3bIqbWcWyUKDA0UNta6D+AoSwZD5XQhj4iqEnw/ttL0gNve//L4Uw
OrFIuuVl26/NyPF/+GytkycVR3ZUR8KtR5qfBW0LE/XGiaTXX7QMtsyslTStNhlu
0y6j/2yPj18IGbiliGrZDYC4AOoZgRPSnl1ZJghxvlebDHp7LYobO5QZwDVpGNip
JNZnqwBMscoyN6jrZKCA4ho9j7XfLyaAY4A6IXjc5wumsPIizfWF9ggc5YXel6z0
77fNMk+x1oX9raF637TM576y09GxTS2NRdNSPlm32i5CnAf1NPpzoE9D1X2O5azx
6PGUfS2QjtfP5bc4oI+rm7SO0X41wvYNsQWfobZ4PS3s6YtA0akKTojsGvrvVXH3
hf8x5NY5uq6XM6J8NOXGj7R2689Kdgua7eFzW8nHQZNeLENdlh701MgavMHI5soz
XRi/MgXtglyThvji4zZGhfj4SwoTmnctecofpPYPyi5FWmFwJ1EeWoUM2q9g9i6o
81UH1dmGEm9wFTsWWzQmNJrygF+xwibmr8ia3fnJ+ip5N75+GxiixiPk1qSpPvgH
KWsGetufQuORPMZx8Ffph0OziuH1fiAl4j3hMstsKKzvU2Ac8zVDZE64BN/dlAGh
OQv2xleY4GY=
=XTlx
-----END PGP SIGNATURE-----

--Sig_/3T5yF6.eoU+80zVpVbOKoWu--
