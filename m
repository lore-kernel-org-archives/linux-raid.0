From: Neil Brown <neilb@suse.de>
Subject: Re: How to initialize "composite" RAID
Date: Sat, 11 Sep 2010 10:23:19 +1000
Message-ID: <20100911102319.2435d878@notabene>
References: <AANLkTim9TnyTGMWnRr65SrmJDrLN=Maua_QnVLLDerwS@mail.gmail.com>
	<20100910222814.CB50615242D@gemini.denx.de>
	<20100911083748.14843721@notabene>
	<AANLkTi=kKKYWY9rLG57i-kqV02Lnf2QPhe5cqaBKEVyW@mail.gmail.com>
	<20100911090709.580f3539@notabene>
	<AANLkTi=rA-z6qEO6os+sYQYUh=pJd4vabtaaUpQ5JevN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=rA-z6qEO6os+sYQYUh=pJd4vabtaaUpQ5JevN@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hartman <mike@hartmanipulation.com>
Cc: Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 10 Sep 2010 19:36:18 -0400
Mike Hartman <mike@hartmanipulation.com> wrote:

> >On Fri, Sep 10, 2010 at 7:07 PM, Neil Brown <neilb@suse.de> wrote:
> > On Fri, 10 Sep 2010 18:45:54 -0400
> > Mike Hartman <mike@hartmanipulation.com> wrote:
> >
> >> On Fri, Sep 10, 2010 at 6:37 PM, Neil Brown <neilb@suse.de> wrote:
> >> > On Sat, 11 Sep 2010 00:28:14 +0200
> >> > Wolfgang Denk <wd@denx.de> wrote:
> >> >
> >> >> Dear Mike Hartman,
> >> >>
> >> >> In message <AANLkTim9TnyTGMWnRr65SrmJDrLN=3DMaua_QnVLLDerwS@mai=
l.gmail.com> you wrote:
> >> >> > This is unrelated to my other RAID thread, but I discovered t=
his issue
> >> >> > when I was forced to hard restart due to the other one.
> >> >> >
> >> >> > My main raid (md0) is a RAID 5 composite that looks like this=
:
> >> >> >
> >> >> > - partition on hard drive A (1.5TB)
> >> >> > - partition on hard drive B (1.5TB)
> >> >> > - partition on hard drive C (1.5TB)
> >> >> > - partition on RAID 1 (md1) (1.5TB)
> >> >>
> >> >> I guess this is a typo and you mean RAID 0 ?
> >> >>
> >> >> > md1 is a RAID 0 used to combine two 750GB drives I already ha=
d so that
> >> >>
> >> >> ...as used here?
> >> >>
> >> >> > Detecting md0. Can't start md0 because it's missing a compone=
nt (md1)
> >> >> > and thus wouldn't be in a clean state.
> >> >> > Detecting md1. md1 started.
> >> >> > Then I use mdadm to stop md0 and restart it (mdadm --assemble=
 md0),
> >> >> > which works fine at that point because md1 is up.
> >> >>
> >> >> Did you try changing your configurations uch that md0 is the RA=
ID 0
> >> >> and md1 is the RAID 5 array?
> >> >>
> >> >
> >> > Or just swap the order of the two lines in /etc/mdadm.conf.
> >> >
> >> > NeilBrown
> >> >
> >>
> >> I thought about trying that, but I was under the impression that t=
he
> >> autodetect process didn't refer to that file at all. I take it I w=
as
> >> mistaken? If so that sounds like the simplest fix.
> >
> > Depends what you mean by the "auto detect" process.
> >
> > If you are referring to in-kernel auto-detect triggered by the 0xFD=
 partition
> > type, then just don't use that. =C2=A0You cannot control the order =
in which arrays
> > are assembled. =C2=A0You could swap the name md1 and md0 (Which isn=
't too hard
> > using --assemble --update=3Dsuper-minor) but it probably wouldn't m=
ake any
> > change to behaviour.
>=20
> I'm not using the 0xFD partition type - the partitions my RAIDs are
> composed of are all 0xDA, as suggested in the linux raid wiki. (I'd
> provide the link but the site seems to be down at the moment.) I
> believe that type is suggested specifically to avoid triggering the
> kernel auto-detect.

Good.

So mdadm must be doing the assembly.

What are the conrents of /etc/mdadm.conf (or /etc/mdadm/mdadm.conf)?

If you stop both arrays, then run

 mdadm --assemble --scan --verbose

what is reported, and what happens?

The kernel logs should give you some idea of what is happening at boot =
- look
for "md" or "raid".

NeilBrown


>=20
> I followed the directions on the wiki for creating the arrays,
> creating the file system, etc (including keeping my /etc/mdadm.conf
> updated) and nothing ever really called out what to do to get it all
> mounted automatically at boot. I was going to worry about getting the=
m
> built now and getting them automated later, but when a bug (mentioned
> in another thread) forced me to reboot I was surprised to see that
> they were autodetected (more or less) anyway. So I'm not sure if it's
> the kernel doing it or mdadm or what. I don't see any kind of entry
> for mdadm when I run "rc-update show", so if it's mdadm doing the
> detecting and not the kernel I have no idea what's kicking it off.
>=20
> Is there something I could look for in the logs that would indicate
> how the RAIDs are actually getting assembled?
>=20
> >
> > Get disable in-kernel autodetect and let mdadm assemble the arrays =
for you.
> > It has a much better chance of getting it right.
>=20
> Assuming it's the kernel doing the assembling now, what are the
> specific settings in the config I need to turn off? How would I get
> mdadm to do the assembling? Just put the same commands I use when
> doing it manually into a script run during the boot process? Or is
> there already some kind of mechanism in place for this?
>=20
> >
> > NeilBrown
> >
>=20
> Sorry for all the questions. When the wiki addresses a topic it does =
a
> good job, but if it's not mentioned it's pretty hard to find good inf=
o
> on it anywhere.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
