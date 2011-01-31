From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: Performance question, RAID5
Date: Mon, 31 Jan 2011 22:41:13 +0100
Message-ID: <20110131214113.GA5274@www2.open-std.org>
References: <20110130094444.68288b0e@natsu> <AANLkTi=jXwcEgRquKgsf5HQUA+AQdt8nHeHCUJYqdSbX@mail.gmail.com> <20110130171533.4c9e236b@natsu> <AANLkTi=6UnGjDXdrM76-8_iW+1D6MC5fkGB-vhhYxUXu@mail.gmail.com> <4D45C3FA.2040900@hardwarefreak.com> <AANLkTikLX-d6CtXhLBQU_qoxx0fQ2HdR8acFCU+o9JeP@mail.gmail.com> <20110131085202.GA25912@www2.open-std.org> <AANLkTi=Zgqs958fSjkmKaDpgL21qshm=SRj_HUvjTbZz@mail.gmail.com> <20110131131131.GA26525@www2.open-std.org> <20110201074257.3c771181@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110201074257.3c771181@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>, Mathias =?iso-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>, Stan Hoeppner <stan@hardwarefreak.com>, Roman Mamedov <rm@romanrm.ru>, CoolCold <coolthecold@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Feb 01, 2011 at 07:42:57AM +1100, NeilBrown wrote:
> On Mon, 31 Jan 2011 14:11:31 +0100 Keld J=F8rn Simonsen <keld@keldix.=
com> wrote:
>=20
> > On Mon, Jan 31, 2011 at 09:37:46AM +0000, Mathias Bur=E9n wrote:
> > > On 31 January 2011 08:52, Keld J=F8rn Simonsen <keld@keldix.com> =
wrote:
> > > > If your intallation is CPU bound, and you are
> > > > using an Atom N270 processor or the like, well some ideas:
> > > >
> > > > The Atom CPU may have threading, so you could run 2 RAIDs
> > > > which then probably would run in each thread.
> > > > It would cost you 1 more disk if you run 2 RAID5's
> > > > so you get 8 TB payload out of your 12 GB total (6 drives of 2 =
TB each).
> > > >
> > > > Another way to get better performance could be to use less
> > > > CPU-intensitive RAID types. RAID5 is intensitive as it needs to
> > > > calculate XOR information all the time. Maybe a mirrored
> > > > raid type like RAID10,f2 would give you less CPU usage,
> > > > and the run 2 RAIDS to have it running in both hyperthreads.
> > > > Here you would then only get 6 TB payload of your 12 GB disks,
> > > > but then also probably a faster system.
> > > >
> > > > Best regards
> > > > keld
> > > >
> > >=20
> > > Hi,
> > >=20
> > > It's interesting what you say about the XOR calculations. I thoug=
ht
> > > that it was only calculated on writes? The Atom (330) has HT, so =
Linux
> > > sees 4 logical CPUs.
> >=20
> > Yes you are right, it only calculates XOR on writes with RAID5.=20
> > But then I am puzzled what all these CPU cycles are used for.
> > Also many cycles are used on mirrored raid types. Why?
> > Maybe some is because of LVM? I have been puzzled for a long time w=
hy
> > ordinary RAID without LVM need to use so much CPU. Maybe a lot of d=
ata
> > sguffling between buffers? Neil?
>=20
> What is your evidence that RAID1 uses lots of CPU?

Much of this is raid10, but it should be the same:
http://home.comcast.net/~jpiszcz/20080329-raid/
http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.html

It seems like cpu usage is rather proportionate to the IO done.
And the CPU usage does get up to about 40 % for reading, and
45 % for writing - this is most likely a significant delay factor.
=46or slower CPUs like the Atom CPU this may be an even more significan=
t
delay factor.

=46or RAID5 the situation is even worse, as expected.

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
