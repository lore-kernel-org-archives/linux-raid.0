From: Marc MERLIN <marc@merlins.org>
Subject: Re: Can reading a raid drive trigger all the other drives in that set?
Date: Sat, 24 Sep 2011 15:33:46 -0700
Message-ID: <20110924223346.GB11340@merlins.org>
References: <20110831022005.GI19892@merlins.org> <4E616224.5040009@pobox.com> <20110628162205.GG20420@merlins.org> <20110902012327.GK30313@merlins.org> <CAFx4rwTDCm67QpegfxpVjqeRHmCt=a3z1tNQB2zvW7=0AV-aSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4E616224.5040009@pobox.com> <CAFx4rwTDCm67QpegfxpVjqeRHmCt=a3z1tNQB2zvW7=0AV-aSQ@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Doug Dumitru <doug@easyco.com>, Mark Lord <mlord@pobox.com>
Cc: linux-raid@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

Mark/Tejun et all, my issue may be linked to the fact that I'm using a =
port
multiplier for my drives. If so, please let me know if that might be th=
e
case.

I'm not quite sure what's going on, but it looks like for 2 sets of 5 d=
rives,
ST drive reads from a drive in sleep mode can happen in // (i.e. all dr=
ives spin up
in //) whereas the WDC drives seem to hang the kernel block layer so th=
at the next
drive will not be read and spun up before the previous one was.

Is that possible?
If not, any idea what's going on?

=46or what it's worth, all the drives are on the same SIL PMP plugged i=
nto the
same Marvel SATA card.

On Fri, Sep 02, 2011 at 02:28:21PM -0700, Doug Dumitru wrote:
> On Thu, Sep 1, 2011 at 6:23 PM, Marc MERLIN <marc@merlins.org> wrote:
> > > I have ext4 over lvm2 on a sw raid5 with 2.6.39.1
> > >
> > > In order to save power I have my drives spin down.
> > >
> > > When I access my filesystem mount point, I get hangs of 30sec or =
a bit more
> > > as each and every drive are woken up serially.
> > >
> > > Is there any chance to put a patch in the block layer so that whe=
n it gets a
> > > read on a block after a certain timeout, it just does one dummy r=
ead on all
> > > the other droves in parallel so that all the drives have a chance=
 to spin
> > > back up at the same time and not serially?
> >
> > Ok, so the lack of answer probably means 'no' :)
> >
> > Given that, is there a user space way to do this?
> > I'm thinking I might be able to poll drives every second to see if =
they
> > were spun down and got an IO. If any drive gets an IO, then the oth=
er
> > ones all get a dummy read, although I'd have to make sure that read=
 is
> > random so that it can't be in the cache.
>
> What you are looking to do is not really what raid is all about.
> Essentially, the side effect of a drive wakeup is non optimal in that
> the raid layer is not aware of this event.  Then again, the drive doe=
s
> this invisibly, so no software is really aware.
>=20
> You "could" fix this with a "filter" plug-in.  Basically, you could
> write a device mapper plug-in that watched IO and after some length o=
f
> pause kicked off dummy reads so that all drives would wake up.  In
> terms of code, this would probably be less than 300 lines to implemen=
t
> the module.
>=20
> Writing a device mapper plug-in is not that hard (see dm-zero.c for a
> hello-world example), but it is kernel code and does require a pretty
> good understanding of the BIO structure and how things flow.  If you
> had such a module, you would load it with a dmsetup command and then
> use the 2nd mapper device instead of /dev/mdX.

I just had a little time to work at what I thought would be the userspa=
ce
solution to this.

Please have a quick look at:
http://marc.merlins.org/linux/scripts/swraidwakeup
Basiscally, I use=20
iostat -z 1
to detect access to /dev/md5 and then read a random sector from all its
drives in //.

The idea is of course trigger a spinup of all the drive in // as oppose=
d to
waiting for the raid block layer to serially wait for the first drive, =
and
then the second, and the third, etc...

My script outputs what it does and I can tell that when I access the ra=
id
while the drives are sleeping, those 5 commands are sent at the same ti=
me:
dd if=3D/dev/sdh of=3D/dev/null bs=3D1024 ibs=3D1024 skip=3D304955122 c=
ount=3D1 2>/dev/null &
dd if=3D/dev/sdi of=3D/dev/null bs=3D1024 ibs=3D1024 skip=3D32879776 co=
unt=3D1 2>/dev/null &
dd if=3D/dev/sdj of=3D/dev/null bs=3D1024 ibs=3D1024 skip=3D214592398 c=
ount=3D1 2>/dev/null &
dd if=3D/dev/sdk of=3D/dev/null bs=3D1024 ibs=3D1024 skip=3D128138452 c=
ount=3D1 2>/dev/null &
dd if=3D/dev/sdl of=3D/dev/null bs=3D1024 ibs=3D1024 skip=3D397070851 c=
ount=3D1 2>/dev/null &

I'm working with 2 sets of drives:
/dev/sdc: ST3500630AS: 34=B0C
/dev/sdd: ST3500630AS: 35=B0C
/dev/sde: ST3750640AS: 36=B0C
/dev/sdf: ST3500630AS: 36=B0C
/dev/sdg: ST3500630AS: 36=B0C

/dev/sdh: WDC WD20EARS-00MVWB0: 38=B0C
/dev/sdi: WDC WD20EADS-00W4B0: 38=B0C
/dev/sdj: WDC WD20EADS-00S2B0: 45=B0C
/dev/sdk: WDC WD20EADS-00R6B0: 41=B0C
/dev/sdl: WDC WD20EADS-00R6B0: 41=B0C

(I use hddtemp since it's a handy way to see if the drive is sleeping o=
r
not without waking it up).

On my raidset with the Seagate drives, the spin up in 7 seconds at the =
same
time:

Here's an example wakeup with 4 drives sleeping and one awake:
/usr/bin/time -f 'sdc: %E secs' dd if=3D/dev/sdc of=3D/dev/null bs=3D10=
24 ibs=3D1024 skip=3D227835482 count=3D1 2>&1 | grep -Ev '(records|copi=
ed)' &
/usr/bin/time -f 'sdd: %E secs' dd if=3D/dev/sdd of=3D/dev/null bs=3D10=
24 ibs=3D1024 skip=3D158569697 count=3D1 2>&1 | grep -Ev '(records|copi=
ed)' &
/usr/bin/time -f 'sde: %E secs' dd if=3D/dev/sde of=3D/dev/null bs=3D10=
24 ibs=3D1024 skip=3D244180302 count=3D1 2>&1 | grep -Ev '(records|copi=
ed)' &
/usr/bin/time -f 'sdf: %E secs' dd if=3D/dev/sdf of=3D/dev/null bs=3D10=
24 ibs=3D1024 skip=3D257519832 count=3D1 2>&1 | grep -Ev '(records|copi=
ed)' &
/usr/bin/time -f 'sdg: %E secs' dd if=3D/dev/sdg of=3D/dev/null bs=3D10=
24 ibs=3D1024 skip=3D248812549 count=3D1 2>&1 | grep -Ev '(records|copi=
ed)' &
sdg: 0:00.01 secs
sdc: 0:07.56 secs
sdf: 0:07.60 secs
sdd: 0:07.78 secs
sde: 0:07.89 secs


On my other raid, my code still runs the 5 dd commands at the same time=
, but the block layer
seems to run them sequentially even though they were scheduled at the s=
ame time.

1) does that make sense?
2) could that be related to the fact that the drives are on a port mult=
iplier?
3) if so, why is it affecting the WDC drives but not the ST drives? Do =
the WDC
   drives hang the kernel when issued a command while in sleep mode, bu=
t not the ST drives?

/usr/bin/time -f 'sdh: %E secs' dd if=3D/dev/sdh of=3D/dev/null bs=3D10=
24 ibs=3D1024 skip=3D31905054 count=3D1 2>&1 | grep -Ev '(records|copie=
d)' &
/usr/bin/time -f 'sdi: %E secs' dd if=3D/dev/sdi of=3D/dev/null bs=3D10=
24 ibs=3D1024 skip=3D261665955 count=3D1 2>&1 | grep -Ev '(records|copi=
ed)' &
/usr/bin/time -f 'sdj: %E secs' dd if=3D/dev/sdj of=3D/dev/null bs=3D10=
24 ibs=3D1024 skip=3D244694085 count=3D1 2>&1 | grep -Ev '(records|copi=
ed)' &
/usr/bin/time -f 'sdk: %E secs' dd if=3D/dev/sdk of=3D/dev/null bs=3D10=
24 ibs=3D1024 skip=3D323059576 count=3D1 2>&1 | grep -Ev '(records|copi=
ed)' &
/usr/bin/time -f 'sdl: %E secs' dd if=3D/dev/sdl of=3D/dev/null bs=3D10=
24 ibs=3D1024 skip=3D286720059 count=3D1 2>&1 | grep -Ev '(records|copi=
ed)' &
sdh: 0:06.91 secs
sdi: 0:10.38 secs
sdk: 0:20.82 secs
sdl: 0:31.29 secs
sdj: 0:31.91 secs


Thanks,
Marc
--=20
"A mouse is a device used to point at the xterm you want to type in" - =
A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet=
 cooking
Home page: http://marc.merlins.org/ =20
