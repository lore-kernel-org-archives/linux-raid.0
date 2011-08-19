From: NeilBrown <neilb@suse.de>
Subject: Re: Device utilization with RAID-1
Date: Fri, 19 Aug 2011 10:31:35 +1000
Message-ID: <20110819103135.5b6a3998@notabene.brown>
References: <4E4C5C29.6040303@googlemail.com>
	<20110818114205.61aaa454@notabene.brown>
	<CAGqmV7oDQ-LJVi04ZXx6b_hEdjJ6MNJBfoU-zLN5ZLohjygkXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7oDQ-LJVi04ZXx6b_hEdjJ6MNJBfoU-zLN5ZLohjygkXA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: hochglanz@googlemail.com, hochglanz@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 18 Aug 2011 17:44:19 +0400 CoolCold <coolthecold@gmail.com> wro=
te:

> On Thu, Aug 18, 2011 at 5:42 AM, NeilBrown <neilb@suse.de> wrote:
> > On Thu, 18 Aug 2011 02:26:17 +0200 Harald Nikolisin <hochglanz@gmai=
l.com>
> > wrote:
> >
> >> hi,
> >>
> >> I didn't want to complain in general about SW RAID-1 performance. =
I
> >> simply think something is wrong with my setup and I have currently=
 no
> >> idea how to improve.
> >>
> >> The basic questions (where I did not find an answer, neither in FA=
Q's
> >> nor in forum discussions) are.
> >> a) Is it normal that the hard drives show an permanent utilization
> >> (around 20%) without any noticeable actions on the computer?
> >
> > No. =A0If the array is resyncing or recovering then you would expec=
t
> > utilization for as many hours as it takes - but that would show
> > in /proc/mdstat.
> >
> >> b) Should (as long as no resync happens) the state of mdadm active=
 or clean?
> >
> > If anything has been written to the device in the last 200msec (inc=
luding
> > e.g. access time updates) then expect it to be 'active'.
> > If nothing has been written for 200msecc or more, then expect it to=
 be clean.
> >
> > If you crash while it is active, a resync is needed.
> > If you crash while it is clean, no resync is needed.
> > If you don't crash at all .... that is best :-)
>=20
> I think this info should be wikified if not yet.
>=20
> btw, I've experimented a bit on my /boot array (it doesn't being
> updated, checked with iostat ), and:
> root@m2:~# for i in {1..5};do mdname=3D"md0"; echo "iteration $i";
> (mdadm --detail /dev/$mdname|grep 'State ';cat
> /sys/block/$mdname/md/array_state;grep "$mdname :" /proc/mdstat);slee=
p
> 1;done
> iteration 1
>           State : clean
> clean
> md0 : active raid1 sda1[0] sdb1[1]
> iteration 2
>           State : clean
> clean
> md0 : active raid1 sda1[0] sdb1[1]
> iteration 3
>           State : clean
> clean
> md0 : active raid1 sda1[0] sdb1[1]
> iteration 4
>           State : clean
> clean
> md0 : active raid1 sda1[0] sdb1[1]
> iteration 5
>           State : clean
> clean
> md0 : active raid1 sda1[0] sdb1[1]
>=20
> so, mdadm --detail & array_state shows array is "clean", while
> /proc/mdstat shows array is "active" (no reads/writes happen).
>=20
> Some value is lieing or being misunderdstanded by me...

In mdstat you have 'active' or 'inactive'.  You cannot access an array =
at all
until it is active.  If you are assembling an array bit by bit with "md=
adm
-I", it will be inactive until all the devices appear.  Then it will be
active.

In mdadm "State :" you have 'active' or 'clean'. as described above.  I=
t used
to be 'dirty' or 'clean' but people were confused by having 'dirty' arr=
ays in
normal operation.  So I changed it to 'active' and now it confuses a
different set of people.  You just can't win can you :-)

NeilBrown


>=20
> >
> >
> >
> >>
> >> cheers,
> >> =A0 harald
> >>
> >> well, I have only 2 hard drives and no space for more..
> >>
> >> Am 16.08.2011 03:29, schrieb Roberto Spadim:
> >> > try raid10 far layout
> >> >
> >> > 2011/8/15 Harald Nikolisin <hochglanz@gmail.com
> >> > <mailto:hochglanz@gmail.com>>
> >> >
> >> > =A0 =A0 Since a long time I'm unhappy with the performance of my=
 RAID-1 system.
> >> > =A0 =A0 Investigation with atop and iostat unveils that the disk=
 utilization is
> >> > =A0 =A0 always on a certain level although nothing happens on th=
e system. In the
> >> > =A0 =A0 case of reading or writing files the utilization boosts =
always to 100%
> >> > =A0 =A0 for a long time. Very ugly examples are "Firefox startin=
g" or "zypper
> >> > =A0 =A0 updates".
> >> > =A0 =A0 That is snapshot of the output of iostat:
> >> >
> >> >
> >> > =A0 =A0 Device: =A0 =A0 =A0 =A0 rrqm/s =A0 wrqm/s =A0 =A0 r/s =A0=
 =A0 w/s =A0 rsec/s =A0 wsec/s
> >> > =A0 =A0 avgrq-sz avgqu-sz =A0 await =A0svctm =A0%util
> >> > =A0 =A0 sda =A0 =A0 =A0 =A0 =A0 =A0 =A0 0,00 =A0 =A0 0,00 =A0 =A0=
0,00 =A0 =A07,33 =A0 =A0 0,00 =A0 =A043,33
> >> > =A0 =A0 5,91 =A0 =A0 0,33 =A0 43,18 =A033,32 =A024,43
> >> > =A0 =A0 sdb =A0 =A0 =A0 =A0 =A0 =A0 =A0 0,00 =A0 =A0 0,00 =A0 =A0=
0,00 =A0 =A07,33 =A0 =A0 0,00 =A0 =A043,33
> >> > =A0 =A0 5,91 =A0 =A0 0,35 =A0 45,59 =A039,73 =A029,13
> >> > =A0 =A0 md0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0,00 =A0 =A0 0,00 =A0 =A0=
0,00 =A0 =A00,67 =A0 =A0 0,00 =A0 =A0 5,33
> >> > =A0 =A0 8,00 =A0 =A0 0,00 =A0 =A00,00 =A0 0,00 =A0 0,00
> >> > =A0 =A0 md1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0,00 =A0 =A0 0,00 =A0 =A0=
0,00 =A0 =A00,33 =A0 =A0 0,00 =A0 =A0 5,33
> >> > =A0 =A0 16,00 =A0 =A0 0,00 =A0 =A00,00 =A0 0,00 =A0 0,00
> >> > =A0 =A0 md2 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0,00 =A0 =A0 0,00 =A0 =A0=
0,00 =A0 =A00,33 =A0 =A0 0,00 =A0 =A0 1,00
> >> > =A0 =A0 3,00 =A0 =A0 0,00 =A0 =A00,00 =A0 0,00 =A0 0,00
> >> > =A0 =A0 md3 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0,00 =A0 =A0 0,00 =A0 =A0=
0,00 =A0 =A00,00 =A0 =A0 0,00 =A0 =A0 0,00
> >> > =A0 =A0 0,00 =A0 =A0 0,00 =A0 =A00,00 =A0 0,00 =A0 0,00
> >> > =A0 =A0 md4 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0,00 =A0 =A0 0,00 =A0 =A0=
0,00 =A0 =A00,00 =A0 =A0 0,00 =A0 =A0 0,00
> >> > =A0 =A0 0,00 =A0 =A0 0,00 =A0 =A00,00 =A0 0,00 =A0 0,00
> >> > =A0 =A0 md5 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0,00 =A0 =A0 0,00 =A0 =A0=
0,00 =A0 =A00,33 =A0 =A0 0,00 =A0 =A0 0,67
> >> > =A0 =A0 2,00 =A0 =A0 0,00 =A0 =A00,00 =A0 0,00 =A0 0,00
> >> >
> >> > =A0 =A0 I checked with mdadm if a resync happens or so, but this=
 is not the
> >> > =A0 =A0 case. The state says "active" on all RAID devices - btw.=
 what is the
> >> > =A0 =A0 difference to "clean" ?
> >> >
> >> > =A0 =A0 thanks for any hints,
> >> > =A0 =A0 =A0harald
> >> > =A0 =A0 --
> >> > =A0 =A0 To unsubscribe from this list: send the line "unsubscrib=
e linux-raid" in
> >> > =A0 =A0 the body of a message to majordomo@vger.kernel.org
> >> > =A0 =A0 <mailto:majordomo@vger.kernel.org>
> >> > =A0 =A0 More majordomo info at =A0http://vger.kernel.org/majordo=
mo-info.html
> >> >
> >> >
> >> >
> >> >
> >> > --
> >> > Roberto Spadim
> >> > Spadim Technology / SPAEmpresarial
> >>
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
>=20
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
