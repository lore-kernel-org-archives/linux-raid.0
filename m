From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Interesting feature request for linux raid, waking up drives
Date: Wed, 9 May 2012 23:38:16 +0200
Message-ID: <20120509213816.GA11037@lazy.lzy>
References: <CAAOsTSkxo2Lxb2FCO6A19CrWVbDm1VsrtsYwVEykcs7X=-1sTQ@mail.gmail.com>
 <4FAACE5F.2010004@nuclearwinter.com>
 <CAAOsTSnd_hLTdRZeSDs0ThfQspAq7DVAnsVMeXgMEosugoesag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAOsTSnd_hLTdRZeSDs0ThfQspAq7DVAnsVMeXgMEosugoesag@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik =?iso-8859-1?Q?Horn=EDk?= <patrik@dsl.sk>
Cc: Larkin Lowrey <llowrey@nuclearwinter.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Patrik,

On Wed, May 09, 2012 at 11:16:33PM +0200, Patrik Horn=EDk wrote:
> On Wed, May 9, 2012 at 10:06 PM, Larkin Lowrey
> <llowrey@nuclearwinter.com> wrote:
> > I second this suggestion but I don't think it's the job of the raid
> > layer to keep track of whether the member drives are spinning or no=
t.
>=20
> I also dont think it should be directly in the raid level, but it is
> problem of linux raid and so the solution should be sought here.
>=20
> > I have implemented a similar setup to this but am suffering from th=
e
> > sequential spin-up problem you described. It would be nice to have =
a
> > solution.
>=20
> My script is not perfect but it eliminates sequential spin-up problem
> perfectly. If you want, use it. The sequential spin-up problem was th=
e
> reason I wrote it and its main function is to detect woken drives and
> immediately wake other drives from RAID.

you mentioned "aggressive power saving", but, on the other
hand, if I get it correctly, you want to spin-up the HDDs
alltogether.

How do you manage the current peak (power peak) you create
at spin up? Expecially in comparison with PSU efficiency.

I mean, a running HDD can consume 2W~5W, while at spin-up
it consumes 20W~30W.
If you have, let's say, 20 HDDs NAS, at spin-up the PSU
should provide 20*30W=3D600W, while in normal operation it
will have to provide only 20*2W=3D40W (extreme cases, of
course, YMMV).
In stand-by it will be less, probably 10W for the HDDs.

Now, PSU efficiency usually is tuned at a certain power
need, typically 80% of max PSU power rating.
Above and below is less, obviously much less at, let's
say, 10% of max PSU power.
Golden or similar consumer PSU, marked 80+, can keep
high efficiency (80%~90%) up to low power.
The specification goes down to 20% of max power.

In the above NAS example, the PSU will have to provide,
at spin-up, more than 600W, I would say 700~800W,
while in stand-by it will go down to 30~50W (or less).
Keeping some safety margin, will require 1000W PSU,
which will be used only 3~5% in stand-by.
At this level efficiency will be a disaster (usually),
resulting in an effective power usage (from mains)
probably above 100W, defeating the wanted power saving.

How do you deal with this issue?
Have you any real world data about min/max power
consumption?
Do know PSUs (consumer class, ATX) capable of
handling wide power range with high efficiency?

Going back to the spin-up, my idea was exactly the
opposite, i.e. to activate the HDDs with 4~5 secs.
delay one from the other, in order to reduce the
peak power, thus using a lower power rating PSU,
thus havig high efficiency at low power.

Thanks a lot in advance,

bye,

pg
=20
> > A userspace daemon could probably do the job. I found that relying =
on
> > the drive's internal power management for spinning them down was
> > unreliable (especially for WDC "green" drives) so I implemented a s=
cript
> > that watches /sys/block/sdX/stat for activity and spins down the dr=
ive
> > directly (via hdparm) when no activity has been posted for a
> > configurable period of time. A daemon process that was responsible =
for
> > spinning down the constituent drives could also be responsible for
> > spinning them up by watching /sys/block/mdX/stat for pending transf=
ers.
> > Perhaps you and I could work on such a project.
>=20
> I added support for spinning down drives only as addition after I
> bought first WD Greens . It is done in wrong way, it relies on some
> drives in the array working correctly and I guess your way is the
> correct one. Do you have specification of /sys/block/sdX/stat?
>=20
> Right now the script is checking power status of drives by hdparm. I
> dont know yet what is in /sys/block/sdX/stat and what is better, but
> the basic principle behind my script works perfectly at least in my
> setups - if at least one drive from raid array is awake, wake up all
> of them.
>=20
> > One thing mdadm could do which would help greatly is to enumerate t=
he
> > member disk block devices (not just partitions or member raid devic=
es)
> > for a given array. This information is known since concurrent sync
> > operations are serialized so no two sync operations occur at the sa=
me
> > time on the same physical devices.
>=20
> Maybe Neil can give us his thoughts what is the best place / form for
> such functionality.
>=20
> Patrik
>=20
> >
> > --Larkin
> >
> > On 5/9/2012 12:37 PM, Patrik Horn=EDk wrote:
> >> Hello Neil,
> >>
> >> I want to propose some functionality for linux raid subsystem that=
 I
> >> think will be very practical for many users, automatic waking of
> >> drives. I am using my own user land script written years ago to do
> >> that and I dont know if there is some standard solution now. If th=
ere
> >> is some, please point me to it.
> >>
> >> I am using couple of big RAID5 arrays in servers working like NASe=
s in
> >> small office and home, which are in use only small part of the day=
=2E I
> >> am using low power server and aggressive power saving settings on =
HDDs
> >> to make power consumption substantially lower, for example drives =
are
> >> going to sleep after 15 min of inactivity. Normally problem with s=
uch
> >> settings is extremely long waking time when array is accessed.
> >> Software accessing data often first requests only chunk of data on
> >> first drive in array and waiting cca 20-30 sec for them, after
> >> processing them accessing data on another drive and waiting anothe=
r
> >> 20-30 sec and so on.
> >>
> >> I solved it with my own script in PHP, which monitors drives' stat=
us
> >> periodically. When it detects that drive from RAID array woke up, =
it
> >> immediately wakes other drives. So total waking time is equal to
> >> waking of one drive plus couple of seconds. It works perfectly and
> >> smoothly for years for me.
> >>
> >> I attached the script from one of my servers, it is little cruel a=
nd
> >> using hwparm and smartctl to monitor and manipulating drives. It i=
s
> >> little customized and specific for its server, for example one dri=
ve
> >> detected by model is not used to wake up other drives and two driv=
es
> >> are also putting one another into sleep, because I found out the
> >> standby timeout setting was not working reliable on one drive. But=
 you
> >> will get the idea.
> >>
> >> I think it could be useful for some users if there is possibility =
to
> >> use such feature. Do you think it would be useful? Do you think th=
ere
> >> is some place in linux raid infrastructure where it can be somehow
> >> implemented? (Possibly as some user land tool using some kernel AP=
Is,
> >> I dont know.)
> >>
> >> Best regards,
> >>
> >> Patrik Horn=EDk
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20

piergiorgio
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
