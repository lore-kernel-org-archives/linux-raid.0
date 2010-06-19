From: Ciro Iriarte <cyruspy@gmail.com>
Subject: Re: [Linux-HA] very odd iowait problem
Date: Sat, 19 Jun 2010 09:45:58 -0400
Message-ID: <AANLkTikQSwI1Bxl0PsW-tDMZ8eYagUsInYkOKKGsd1D9@mail.gmail.com>
References: <4C1C7F2F.3040604@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C1C7F2F.3040604@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2010/6/19 Miles Fidelman <mfidelman@meetinghouse.net>:
> Hi Folks,
>
> I'm experiencing a very odd, daily, high-load situation - that seems =
to
> localize in my disk stack. =C2=A0I direct this to the xen-users, linu=
x-raid
> and linux-ha lists as I expect there's a pretty high degree of
> experience on these lists with complicated disk driver stacks.
>
> I recently virtualized a production system, and have been slowly
> wringing out the bugs that have shown up. =C2=A0This seems to be the =
last
> one, and it's a doozie.
>
> Basic setup: =C2=A0Two identical machines except for the DomUs they'r=
e running.
>
> Two machines, slightly older Pentium 4 processors, 4meg RAM each (max=
),
> 2 CPUs each, 4 SATA Drives each.
> Debian Lenny Install for Dom0 and DomUs (2.6.26-2-xen-686)
>
> Disk setup on each:
> - 4 partitions on each drive
> - 3 RAID-1s set up across the 4 drives (4 drives in each - yes it's
> silly, but easy) - for Dom0 /boot / swap
> - 1 RAID-6 set up across the 4 drives - set up as a LVM PV - underlie=
s
> all my DomUs
> note: all the RAIDs are set up with internal metadata, chunk size of
> 131072KB - per advice here - works like a charm
> - pairs of LVs - / and swap per VM
> - each LV is linked with it's counterpart on the other machine, using=
 DRBD
> - LVs are specified as drbd: devices in DomU .cfg files
> - LVs are mounted with noatime option inside production DomU - makes =
a
> big difference
>
> A few DomUs - currently started and stopped either via links in
> /etc/xen/auto or manually - I've temporarily turned off heartbeat and
> pacemaker until I get the underlying stuff stable.
>
> ------
> now to the problem:
>
> for several days in a row, at 2:05am, iowait on the production DomU w=
ent
> from averaging 10% or to 100% (I've been running vmstat 1 in a window
> and watching the iowait column)
>
> the past two days, this has happened at 2:26am instead of 2:05
>
> rebooting the VM fixes the problem, though it has occured again withi=
n
> 20 minutes of the reboot, and then another reboot fixes the problem
> until 2am the next day
>
> killing a bunch of processes also fixed things, but at that point so
> little was running that I just rebooted the DomU - unfortunately, one
> night it looked like lwresd was eating up resources, the next night i=
t
> was something else.
>
> ------
> ok... so I'm thinking there'a cron job that's doing something that ea=
ts
> up all my i/o - I traced a couple of other issues back to cron jobs -=
 I
> can't seem to find either a cron job that runs around this time, or
> anything in my logs
>
> so, now I set up a bunch of things to watch what's going - copies of
> atop running in Dom0 on both servers, and in the production DomU (not=
e:
> I caught a couple of more bugs by running top in a window, and seeing
> what was frozen in the window, after the machine crashed)
>
> ok - so I'm up at 2am for the 4th day in a row (along with a couple o=
f
> proposals I'm writing during the day, and a couple of fires with my
> kids' computers - I've discovered that Mozy is perhaps the world's wo=
rst
> backup service - it's impossible to restore things) - anyway.... 2:26
> rolls around, the iowait goes to 100%, and I start looking using ps, =
and
> iostat, and lsof and such to try to locate whatever process is lockin=
g
> up my DomU, when I notice:
>
> --- on one server, atop is showing one drive (/dev/sdb) maxing out at
> 98% busy - sort of suggestive of a drive failure, and something that
> would certainly ripple through all the layers of RAID, LVM, DRBD to s=
low
> down everything on top of it (which is everything)
>
> Now this is pretty weird - given the way my system is set up, I'd exp=
ect
> a dying disk =C2=A0that to show up as very high iowaits, but....
> - it's a relatively new drive
> - I've been running smartd, and smartctl doesn't yield any results
> suggesting a drive problem
> - the problem goes away when I reboot the DomU
>
> One more symptom: =C2=A0I migrated the DomU to my other server, and t=
here's
> still a correlation between seeing the 98% busy on /dev/sdb, and seei=
ng
> iowait of 100% on the DomU - even though we're now talking a disk on =
one
> machine dragging down a VM on the other machine. =C2=A0(Presumeably i=
t's
> impacting DRBD replication.)
>
> So....
> - on the one hand, the 98% busy on /dev/sdb is rippling up through md=
,
> lvm, drbd, dom0 - and causing 100% iowait in the production DomU - wh=
ich
> is to be expected in a raided, drbd'd environment - a low level delay
> ripples all the way up
> - on the other hand, it's only effecting the one DomU, and it's not
> effecting the Dom0 on that machine
> - there seems to be something going on at 2:25am, give or take a few,
> that kicks everything into the high iowait state (but I can't find a =
job
> running at that time - though I guess someone could be hitting me wit=
h
> some spam that's kicking amavisd or clam into a high-resource mode)
>
> All of which leads to two questions:
> - if it's a disk going bad, why does this manifest nightly, at roughl=
y
> the same time, and effect only one DomU?
> - if it's something in the DomU, by what mechanism is that rippling a=
ll
> they way down to a component of a raid array, hidden below several
> layers of stuff that's supposed to isolate virtual volumes from hardw=
are?
>
> The only thought that occurs to me is that perhaps there's a bad reco=
rd
> or block on that one drive, that only gets exercised when on particul=
ar
> process runs.
> - is that a possibility?
> - if yes, why isn't drbd or md or something catching it and fixing it
> (or adding the block to the bad block table)?
> - any suggestions on diagnostic or drive rebuilding steps to take nex=
t?
> (includings that I can do before staying up until 2am tomorrow!)
>
> If it weren't hitting me, I'd be intrigued by this one. =C2=A0Unfortu=
nately,
> it IS hitting me, and I'm getting tireder and crankier by the minute,
> hour, and day. =C2=A0And it's now 4:26am. =C2=A0Sigh...
>
> Thanks very much for any ideas or suggestions.
>
> Off to bed....
>
> Miles Fidelman
>
>
>
>
>
>

Did you run a long S.M.A.R.T test?. RAID6 on software is not a good
idea, even worse with that hardware. Also, install collectl, it will
save disk, cpu and memory stats as Sar, but will also collect info on
all the processes for later analysis that way you can tell if it's a
particular user space process that triggers the high load.

This deserves a deeper analysis with collected data, but if you are
sure the drive is bad, replace it and check if it still happens (it
will hit you back when adding the new disk again though)

Regards,

--=20
Ciro Iriarte
http://cyruspy.wordpress.com
--
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
