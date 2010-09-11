From: Neil Brown <neilb@suse.de>
Subject: Re: How to initialize "composite" RAID
Date: Sat, 11 Sep 2010 14:42:26 +1000
Message-ID: <20100911144226.59ebc03d@notabene>
References: <AANLkTim9TnyTGMWnRr65SrmJDrLN=Maua_QnVLLDerwS@mail.gmail.com>
	<20100910222814.CB50615242D@gemini.denx.de>
	<20100911083748.14843721@notabene>
	<AANLkTi=kKKYWY9rLG57i-kqV02Lnf2QPhe5cqaBKEVyW@mail.gmail.com>
	<20100911090709.580f3539@notabene>
	<AANLkTi=rA-z6qEO6os+sYQYUh=pJd4vabtaaUpQ5JevN@mail.gmail.com>
	<20100911102319.2435d878@notabene>
	<AANLkTi=Ze-TPiWJNzoxma9Q3h6nHqsNAS2Osu0n+VUP=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=Ze-TPiWJNzoxma9Q3h6nHqsNAS2Osu0n+VUP=@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hartman <mike@hartmanipulation.com>
Cc: Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 10 Sep 2010 22:30:30 -0400
Mike Hartman <mike@hartmanipulation.com> wrote:

> On Fri, Sep 10, 2010 at 8:23 PM, Neil Brown <neilb@suse.de> wrote:
> > On Fri, 10 Sep 2010 19:36:18 -0400
> > Mike Hartman <mike@hartmanipulation.com> wrote:
> >
> >> >On Fri, Sep 10, 2010 at 7:07 PM, Neil Brown <neilb@suse.de> wrote=
:
> >> > On Fri, 10 Sep 2010 18:45:54 -0400
> >> > Mike Hartman <mike@hartmanipulation.com> wrote:
> >> >
> >> >> On Fri, Sep 10, 2010 at 6:37 PM, Neil Brown <neilb@suse.de> wro=
te:
> >> >> > On Sat, 11 Sep 2010 00:28:14 +0200
> >> >> > Wolfgang Denk <wd@denx.de> wrote:
> >> >> >
> >> >> >> Dear Mike Hartman,
> >> >> >>
> >> >> >> In message <AANLkTim9TnyTGMWnRr65SrmJDrLN=3DMaua_QnVLLDerwS@=
mail.gmail.com> you wrote:
> >> >> >> > This is unrelated to my other RAID thread, but I discovere=
d this issue
> >> >> >> > when I was forced to hard restart due to the other one.
> >> >> >> >
> >> >> >> > My main raid (md0) is a RAID 5 composite that looks like t=
his:
> >> >> >> >
> >> >> >> > - partition on hard drive A (1.5TB)
> >> >> >> > - partition on hard drive B (1.5TB)
> >> >> >> > - partition on hard drive C (1.5TB)
> >> >> >> > - partition on RAID 1 (md1) (1.5TB)
> >> >> >>
> >> >> >> I guess this is a typo and you mean RAID 0 ?
> >> >> >>
> >> >> >> > md1 is a RAID 0 used to combine two 750GB drives I already=
 had so that
> >> >> >>
> >> >> >> ...as used here?
> >> >> >>
> >> >> >> > Detecting md0. Can't start md0 because it's missing a comp=
onent (md1)
> >> >> >> > and thus wouldn't be in a clean state.
> >> >> >> > Detecting md1. md1 started.
> >> >> >> > Then I use mdadm to stop md0 and restart it (mdadm --assem=
ble md0),
> >> >> >> > which works fine at that point because md1 is up.
> >> >> >>
> >> >> >> Did you try changing your configurations uch that md0 is the=
 RAID 0
> >> >> >> and md1 is the RAID 5 array?
> >> >> >>
> >> >> >
> >> >> > Or just swap the order of the two lines in /etc/mdadm.conf.
> >> >> >
> >> >> > NeilBrown
> >> >> >
> >> >>
> >> >> I thought about trying that, but I was under the impression tha=
t the
> >> >> autodetect process didn't refer to that file at all. I take it =
I was
> >> >> mistaken? If so that sounds like the simplest fix.
> >> >
> >> > Depends what you mean by the "auto detect" process.
> >> >
> >> > If you are referring to in-kernel auto-detect triggered by the 0=
xFD partition
> >> > type, then just don't use that. =C2=A0You cannot control the ord=
er in which arrays
> >> > are assembled. =C2=A0You could swap the name md1 and md0 (Which =
isn't too hard
> >> > using --assemble --update=3Dsuper-minor) but it probably wouldn'=
t make any
> >> > change to behaviour.
> >>
> >> I'm not using the 0xFD partition type - the partitions my RAIDs ar=
e
> >> composed of are all 0xDA, as suggested in the linux raid wiki. (I'=
d
> >> provide the link but the site seems to be down at the moment.) I
> >> believe that type is suggested specifically to avoid triggering th=
e
> >> kernel auto-detect.
> >
> > Good.
> >
> > So mdadm must be doing the assembly.
> >
> > What are the conrents of /etc/mdadm.conf (or /etc/mdadm/mdadm.conf)=
?
>=20
> ARRAY /dev/md0 metadata=3D1.2 name=3Dodin:0 UUID=3D714c307e:71626854:=
2c2cc6c8:c67339a0
> ARRAY /dev/md1 metadata=3D1.2 name=3Dodin:1 UUID=3De51aa0b8:e8157c6a:=
c241acef:a2e1fb62
>=20
> >
> > If you stop both arrays, then run
> >
> > =C2=A0mdadm --assemble --scan --verbose
> >
> > what is reported, and what happens?
>=20
> I REALLY want to avoid that if possible. It's only 44% of the way
> through the resync that was started due to the last time it tried to
> start them automatically. Assuming it still won't detect them
> properly, I'd be back to a 10+ hour wait before everything was stable=
=2E

If you cleanly stop and restart an array, the resync will pick up from =
where
it left off.  But you don't need to do that, the other info you gave is
sufficient.

>=20
> >
> > The kernel logs should give you some idea of what is happening at b=
oot - look
> > for "md" or "raid".
>=20
> Everything that seems related to "md" or "raid" since the last boot i=
s
> attached (raid_md.log).

The log shows md0 being assembled from 3 of 4 components and then *not*
started.
Then md1 is assembled.
Then 4 minutes later (presumably when you intervened) md0 disassembled =
and
re-assembled from all 4 devices.

The reason it then started resync has nothing to do with the order in w=
hich
the array was assembled, but probably more to do with how it was shutdo=
wn.
The array was already marked 'dirty' as in 'needs a resync' before the =
system
booted.


If you can used mdadm-3.1.2 or later you will find that mdadm will star=
t md0
properly after it has started md1.  Or you can just swap the order of t=
he
lines in mdadm.conf.

If you add a bitmap (mdadm --grow /dev/md0 --bitmap=3Dinternal) after t=
he
current resync finished, then any subsequent resync due to an unclean
shutdown will be much faster.

I don't know why it was marked dirty.  Presumably because the system wa=
sn't
shut down properly, but I have not details and so cannot make a useful =
guess.

NeilBrown



>=20
> >
> > NeilBrown
> >
> >
> >>
> >> I followed the directions on the wiki for creating the arrays,
> >> creating the file system, etc (including keeping my /etc/mdadm.con=
f
> >> updated) and nothing ever really called out what to do to get it a=
ll
> >> mounted automatically at boot. I was going to worry about getting =
them
> >> built now and getting them automated later, but when a bug (mentio=
ned
> >> in another thread) forced me to reboot I was surprised to see that
> >> they were autodetected (more or less) anyway. So I'm not sure if i=
t's
> >> the kernel doing it or mdadm or what. I don't see any kind of entr=
y
> >> for mdadm when I run "rc-update show", so if it's mdadm doing the
> >> detecting and not the kernel I have no idea what's kicking it off.
> >>
> >> Is there something I could look for in the logs that would indicat=
e
> >> how the RAIDs are actually getting assembled?
> >>
> >> >
> >> > Get disable in-kernel autodetect and let mdadm assemble the arra=
ys for you.
> >> > It has a much better chance of getting it right.
> >>
> >> Assuming it's the kernel doing the assembling now, what are the
> >> specific settings in the config I need to turn off? How would I ge=
t
> >> mdadm to do the assembling? Just put the same commands I use when
> >> doing it manually into a script run during the boot process? Or is
> >> there already some kind of mechanism in place for this?
> >>
> >> >
> >> > NeilBrown
> >> >
> >>
> >> Sorry for all the questions. When the wiki addresses a topic it do=
es a
> >> good job, but if it's not mentioned it's pretty hard to find good =
info
> >> on it anywhere.
> >
> >

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
