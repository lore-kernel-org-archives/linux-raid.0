From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: Performance question, RAID5
Date: Mon, 31 Jan 2011 19:44:17 +0100
Message-ID: <20110131184417.GB27952@www2.open-std.org>
References: <20110130094444.68288b0e@natsu> <AANLkTi=jXwcEgRquKgsf5HQUA+AQdt8nHeHCUJYqdSbX@mail.gmail.com> <20110130171533.4c9e236b@natsu> <AANLkTi=6UnGjDXdrM76-8_iW+1D6MC5fkGB-vhhYxUXu@mail.gmail.com> <4D45C3FA.2040900@hardwarefreak.com> <AANLkTikLX-d6CtXhLBQU_qoxx0fQ2HdR8acFCU+o9JeP@mail.gmail.com> <20110131085202.GA25912@www2.open-std.org> <AANLkTi=Zgqs958fSjkmKaDpgL21qshm=SRj_HUvjTbZz@mail.gmail.com> <20110131131131.GA26525@www2.open-std.org> <AANLkTikvRaeF449PxK0BG-fp-UJEa4WxdYRHqZH_G6CR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTikvRaeF449PxK0BG-fp-UJEa4WxdYRHqZH_G6CR@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>, Mathias =?iso-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>, Stan Hoeppner <stan@hardwarefreak.com>, Roman Mamedov <rm@romanrm.ru>, CoolCold <coolthecold@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jan 31, 2011 at 12:43:56PM -0200, Roberto Spadim wrote:
> i think it's cpu wait i/o


Well, you better be sure. Please have a closer look.
Normally saying that a process is CPU bound means that
it is not IO bound.

Best regards
keld

> 2011/1/31 Keld J=F8rn Simonsen <keld@keldix.com>:
> > On Mon, Jan 31, 2011 at 09:37:46AM +0000, Mathias Bur=E9n wrote:
> >> On 31 January 2011 08:52, Keld J=F8rn Simonsen <keld@keldix.com> w=
rote:
> >> > If your intallation is CPU bound, and you are
> >> > using an Atom N270 processor or the like, well some ideas:
> >> >
> >> > The Atom CPU may have threading, so you could run 2 RAIDs
> >> > which then probably would run in each thread.
> >> > It would cost you 1 more disk if you run 2 RAID5's
> >> > so you get 8 TB payload out of your 12 GB total (6 drives of 2 T=
B each).
> >> >
> >> > Another way to get better performance could be to use less
> >> > CPU-intensitive RAID types. RAID5 is intensitive as it needs to
> >> > calculate XOR information all the time. Maybe a mirrored
> >> > raid type like RAID10,f2 would give you less CPU usage,
> >> > and the run 2 RAIDS to have it running in both hyperthreads.
> >> > Here you would then only get 6 TB payload of your 12 GB disks,
> >> > but then also probably a faster system.
> >> >
> >> > Best regards
> >> > keld
> >> >
> >>
> >> Hi,
> >>
> >> It's interesting what you say about the XOR calculations. I though=
t
> >> that it was only calculated on writes? The Atom (330) has HT, so L=
inux
> >> sees 4 logical CPUs.
> >
> > Yes you are right, it only calculates XOR on writes with RAID5.
> > But then I am puzzled what all these CPU cycles are used for.
> > Also many cycles are used on mirrored raid types. Why?
> > Maybe some is because of LVM? I have been puzzled for a long time w=
hy
> > ordinary RAID without LVM need to use so much CPU. Maybe a lot of d=
ata
> > sguffling between buffers? Neil?
> >
> > Best regards
> > Keld
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
> --=20
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
