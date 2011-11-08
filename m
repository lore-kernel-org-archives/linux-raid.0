From: Lennart Poettering <lennart@poettering.net>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually
 by user
Date: Tue, 8 Nov 2011 15:43:37 +0100
Message-ID: <20111108144336.GA12609@tango.0pointer.de>
References: <20110208172822.GC21847@tango.0pointer.de>
 <CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com>
 <20111031110613.GA1402@tango.0pointer.de>
 <20111102114416.7879b77f@notabene.brown>
 <20111102011615.GA5289@tango.0pointer.de>
 <20111102130334.09c3ab51@notabene.brown>
 <20111102133223.GC5119@tango.0pointer.de>
 <20111107135241.64ae261d@notabene.brown>
 <20111107120048.GD25130@tango.0pointer.de>
 <CABE8wwug4-gMLA4rd6FXgV3db2XiwUcfsXp6fC=NipKg333n-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CABE8wwug4-gMLA4rd6FXgV3db2XiwUcfsXp6fC=NipKg333n-g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: NeilBrown <neilb@suse.de>, Andrey Borzenkov <arvidjaar@mail.ru>, Tomasz Torcz <tomek@pipebreaker.pl>, systemd-devel@lists.freedesktop.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 07.11.11 11:09, Williams, Dan J (dan.j.williams@intel.com) wrot=
e:

> >> What exactly is "kill_all_processes()"? =A0 is it SIGTERM or SIGKI=
LL or both
> >> with a gap or ???
> >
> > SIGTERM followed by SIGKILL after 5s if the programs do not react t=
o
> > that in time. But note that this logic only applies to processes wh=
ich
> > for some reason managed to escape systemd's usual cgroup-based kill=
ing
> > logic. Normal services are hence already killed at that time, and o=
nly
> > processes which moved themselves out of any cgroup or for which the
> > service files disabled killing might survive to this point.
>=20
> So I think mdmon should always try to escape itself from cgroup based
> killing.  It follows the lifespan of the array, and if the array is
> not stopped by the cgroup exit (or the array lifespan is not
> controlled in a service file), then mdmon must keep running.

Well, I think when it gets killed by the cgroup-based killer then it
should try to tear down its MD device.

In the mdmon service file use SendSIGKILL=3Dno to disable sending of
SIGKILL after the initial SIGTERM. With KillSignal=3D you chan choose t=
he
signal you first want to be killed with, if you don't want it to be
SIGTERM. With KillMode=3D you can choose whether only the main process =
of
the service, all processes of the service, or no processes of the
service shall be killed. With TimeoutSec=3D you can set the timeout
between the SIGTERM and the SIGKILL. See systemd.service(5) for more
information.

> > You have relatively flexible control of the first step in this code=
=2E The
> > second step is then the hammer that tries to fix up what this step
> > didn't accomplish. My suggestion to check argv[0][0] was to avoid t=
he
> > hammer.
>=20
> I notice that if the rootfs is on a dm or md device systemd/shutdown
> will always fall through to ultimate_send_signal() which will not
> discriminate against processes flagged with '@'.  Since we aren't
> stopping the root md device I wonder if ultimate_send_signal() should
> also ignore flagged processes, or whether the failure to stop the roo=
t
> device is to be expected and let shutdown skip ultimate_send_signal()
> if the only remaining work is shutting down the rootfs-blockdev.  I'm
> leaning towards the latter.

The idea was to skip processes flgged with '@' in both the
ultimate_send_signal() and send_signal() calls.

Lennart

--=20
Lennart Poettering - Red Hat, Inc.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
