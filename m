From: Mike Hartman <mike@hartmanipulation.com>
Subject: Re: How to initialize "composite" RAID
Date: Sat, 11 Sep 2010 00:58:21 -0400
Message-ID: <AANLkTin7T8rsF=XhWYTZyEwUkb5BUzK6dswVoTB-Sbbs@mail.gmail.com>
References: <AANLkTim9TnyTGMWnRr65SrmJDrLN=Maua_QnVLLDerwS@mail.gmail.com>
	<20100910222814.CB50615242D@gemini.denx.de>
	<20100911083748.14843721@notabene>
	<AANLkTi=kKKYWY9rLG57i-kqV02Lnf2QPhe5cqaBKEVyW@mail.gmail.com>
	<20100911090709.580f3539@notabene>
	<AANLkTi=rA-z6qEO6os+sYQYUh=pJd4vabtaaUpQ5JevN@mail.gmail.com>
	<20100911102319.2435d878@notabene>
	<AANLkTi=Ze-TPiWJNzoxma9Q3h6nHqsNAS2Osu0n+VUP=@mail.gmail.com>
	<20100911144226.59ebc03d@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100911144226.59ebc03d@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Sep 11, 2010 at 12:42 AM, Neil Brown <neilb@suse.de> wrote:
> On Fri, 10 Sep 2010 22:30:30 -0400
> Mike Hartman <mike@hartmanipulation.com> wrote:
>
>> On Fri, Sep 10, 2010 at 8:23 PM, Neil Brown <neilb@suse.de> wrote:
>> > On Fri, 10 Sep 2010 19:36:18 -0400
>> > Mike Hartman <mike@hartmanipulation.com> wrote:
>> >
>> >> >On Fri, Sep 10, 2010 at 7:07 PM, Neil Brown <neilb@suse.de> wrot=
e:
>> >> > On Fri, 10 Sep 2010 18:45:54 -0400
>> >> > Mike Hartman <mike@hartmanipulation.com> wrote:
>> >> >
>> >> >> On Fri, Sep 10, 2010 at 6:37 PM, Neil Brown <neilb@suse.de> wr=
ote:
>> >> >> > On Sat, 11 Sep 2010 00:28:14 +0200
>> >> >> > Wolfgang Denk <wd@denx.de> wrote:
>> >> >> >
>> >> >> >> Dear Mike Hartman,
>> >> >> >>
>> >> >> >> In message <AANLkTim9TnyTGMWnRr65SrmJDrLN=3DMaua_QnVLLDerwS=
@mail.gmail.com> you wrote:
>> >> >> >> > This is unrelated to my other RAID thread, but I discover=
ed this issue
>> >> >> >> > when I was forced to hard restart due to the other one.
>> >> >> >> >
>> >> >> >> > My main raid (md0) is a RAID 5 composite that looks like =
this:
>> >> >> >> >
>> >> >> >> > - partition on hard drive A (1.5TB)
>> >> >> >> > - partition on hard drive B (1.5TB)
>> >> >> >> > - partition on hard drive C (1.5TB)
>> >> >> >> > - partition on RAID 1 (md1) (1.5TB)
>> >> >> >>
>> >> >> >> I guess this is a typo and you mean RAID 0 ?
>> >> >> >>
>> >> >> >> > md1 is a RAID 0 used to combine two 750GB drives I alread=
y had so that
>> >> >> >>
>> >> >> >> ...as used here?
>> >> >> >>
>> >> >> >> > Detecting md0. Can't start md0 because it's missing a com=
ponent (md1)
>> >> >> >> > and thus wouldn't be in a clean state.
>> >> >> >> > Detecting md1. md1 started.
>> >> >> >> > Then I use mdadm to stop md0 and restart it (mdadm --asse=
mble md0),
>> >> >> >> > which works fine at that point because md1 is up.
>> >> >> >>
>> >> >> >> Did you try changing your configurations uch that md0 is th=
e RAID 0
>> >> >> >> and md1 is the RAID 5 array?
>> >> >> >>
>> >> >> >
>> >> >> > Or just swap the order of the two lines in /etc/mdadm.conf.
>> >> >> >
>> >> >> > NeilBrown
>> >> >> >
>> >> >>
>> >> >> I thought about trying that, but I was under the impression th=
at the
>> >> >> autodetect process didn't refer to that file at all. I take it=
 I was
>> >> >> mistaken? If so that sounds like the simplest fix.
>> >> >
>> >> > Depends what you mean by the "auto detect" process.
>> >> >
>> >> > If you are referring to in-kernel auto-detect triggered by the =
0xFD partition
>> >> > type, then just don't use that. =A0You cannot control the order=
 in which arrays
>> >> > are assembled. =A0You could swap the name md1 and md0 (Which is=
n't too hard
>> >> > using --assemble --update=3Dsuper-minor) but it probably wouldn=
't make any
>> >> > change to behaviour.
>> >>
>> >> I'm not using the 0xFD partition type - the partitions my RAIDs a=
re
>> >> composed of are all 0xDA, as suggested in the linux raid wiki. (I=
'd
>> >> provide the link but the site seems to be down at the moment.) I
>> >> believe that type is suggested specifically to avoid triggering t=
he
>> >> kernel auto-detect.
>> >
>> > Good.
>> >
>> > So mdadm must be doing the assembly.
>> >
>> > What are the conrents of /etc/mdadm.conf (or /etc/mdadm/mdadm.conf=
)?
>>
>> ARRAY /dev/md0 metadata=3D1.2 name=3Dodin:0 UUID=3D714c307e:71626854=
:2c2cc6c8:c67339a0
>> ARRAY /dev/md1 metadata=3D1.2 name=3Dodin:1 UUID=3De51aa0b8:e8157c6a=
:c241acef:a2e1fb62
>>
>> >
>> > If you stop both arrays, then run
>> >
>> > =A0mdadm --assemble --scan --verbose
>> >
>> > what is reported, and what happens?
>>
>> I REALLY want to avoid that if possible. It's only 44% of the way
>> through the resync that was started due to the last time it tried to
>> start them automatically. Assuming it still won't detect them
>> properly, I'd be back to a 10+ hour wait before everything was stabl=
e.
>
> If you cleanly stop and restart an array, the resync will pick up fro=
m where
> it left off. =A0But you don't need to do that, the other info you gav=
e is
> sufficient.
>
>>
>> >
>> > The kernel logs should give you some idea of what is happening at =
boot - look
>> > for "md" or "raid".
>>
>> Everything that seems related to "md" or "raid" since the last boot =
is
>> attached (raid_md.log).
>
> The log shows md0 being assembled from 3 of 4 components and then *no=
t*
> started.
> Then md1 is assembled.
> Then 4 minutes later (presumably when you intervened) md0 disassemble=
d and
> re-assembled from all 4 devices.
>
> The reason it then started resync has nothing to do with the order in=
 which
> the array was assembled, but probably more to do with how it was shut=
down.
> The array was already marked 'dirty' as in 'needs a resync' before th=
e system
> booted.
>
>
> If you can used mdadm-3.1.2 or later you will find that mdadm will st=
art md0
> properly after it has started md1. =A0Or you can just swap the order =
of the
> lines in mdadm.conf.
>

I'm using mdadm 3.1.3 but I went ahead and swapped the lines in
mdadm.conf anyway.

> If you add a bitmap (mdadm --grow /dev/md0 --bitmap=3Dinternal) after=
 the
> current resync finished, then any subsequent resync due to an unclean
> shutdown will be much faster.

I read somewhere (I think in the wiki) that an intent bitmap only
works properly on ext2 and ext3 and can cause trouble on other file
systems. Can I use one on ext4 (what I'm using)? I'm hoping/assuming
what I read just predates the common use of ext4.

Will I need to remove the bitmap before adding another disk and
growing the array to use it? If I don't, will it speed up that
operation any?

>
> I don't know why it was marked dirty. =A0Presumably because the syste=
m wasn't
> shut down properly, but I have not details and so cannot make a usefu=
l guess.
>
> NeilBrown
>

Thanks for all the help Neil. I feel much more confident in my
understanding of what mdadm is doing now.

>
>
>>
>> >
>> > NeilBrown
>> >
>> >
>> >>
>> >> I followed the directions on the wiki for creating the arrays,
>> >> creating the file system, etc (including keeping my /etc/mdadm.co=
nf
>> >> updated) and nothing ever really called out what to do to get it =
all
>> >> mounted automatically at boot. I was going to worry about getting=
 them
>> >> built now and getting them automated later, but when a bug (menti=
oned
>> >> in another thread) forced me to reboot I was surprised to see tha=
t
>> >> they were autodetected (more or less) anyway. So I'm not sure if =
it's
>> >> the kernel doing it or mdadm or what. I don't see any kind of ent=
ry
>> >> for mdadm when I run "rc-update show", so if it's mdadm doing the
>> >> detecting and not the kernel I have no idea what's kicking it off=
=2E
>> >>
>> >> Is there something I could look for in the logs that would indica=
te
>> >> how the RAIDs are actually getting assembled?
>> >>
>> >> >
>> >> > Get disable in-kernel autodetect and let mdadm assemble the arr=
ays for you.
>> >> > It has a much better chance of getting it right.
>> >>
>> >> Assuming it's the kernel doing the assembling now, what are the
>> >> specific settings in the config I need to turn off? How would I g=
et
>> >> mdadm to do the assembling? Just put the same commands I use when
>> >> doing it manually into a script run during the boot process? Or i=
s
>> >> there already some kind of mechanism in place for this?
>> >>
>> >> >
>> >> > NeilBrown
>> >> >
>> >>
>> >> Sorry for all the questions. When the wiki addresses a topic it d=
oes a
>> >> good job, but if it's not mentioned it's pretty hard to find good=
 info
>> >> on it anywhere.
>> >
>> >
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
