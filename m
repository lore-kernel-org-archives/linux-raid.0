From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Mon, 3 Jan 2005 12:31:33 +0100
Message-ID: <l1nna2-e9i.ln1@news.it.uc3m.es>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es> <200501031017.j03AHO912799@www.watkins-home.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy <bugzilla@watkins-home.com> wrote:
> "Also sprach Guy:"
> > "Well, you can make somewhere. You only require an 8MB (one cylinder)
> > partition."
> > 
> > So, it is ok for your system to fail when this disk fails?
> 
> You lose the journal, that's all.  You can react with a simple tune2fs
> -O ^journal or whatever is appropriate.  And a journal is ONLY there in
> order to protect you against crashes of the SYSTEM (not the disk), so
> what was the point of having the journal in the first place? 
> 
> ** When you lose the journal, does the system continue without it?
> ** Or does it require user intervention?

I don't recall. It certainly at least puts itself into read-only mode
(if that's the error mode specified via tune2fs). And the situation
probably changes from version t version.

On a side note, I don't know why you think user intervention is not
required when a raid system dies.  As a matter of liklihoods, I have
never seen a disk die while IN a working soft (or hard) raid system, and
the system continue working afterwards, instead the normal disaster
sequence as I have experienced it is:

   1) lightning strikes rails, or a/c goes out and room full of servers
      overheats. All lights go off.

   2) when sysadmin arrives to sort out the smoking wrecks, he finds
      that 1 in 3 random disks are fried - they're simply the points
      of failure that died first, and they took down the hardware with
      them.

   3) sysadmin buys or jury-rigs enough pieces of nonsmoking hardware
      to piece together the raid arrays from the surviving disks, and
      hastily does a copy to somewhere very safe and distant, while
      an assistant holds off howling hordes outside the door with
      a shutgun.

In this scenario, a disk simply acts as the weakest link in a fuse
chain, and the whole chain goes down.  But despite my dramatisation it
is likely that a hardware failure will take out or damage your hardware!
Ide disks live on an electric bus conected to other hardware.  Try a
shortcircuit and see what happens.  You can't even yank them out while
the bus is operating if you want to keep your insurance policy.

For scsi the situation is better wrt hot-swap, but still not perfect.
And you have the electric connections also. That makes it likely that a
real nasty hardware failure will do nasty things (tm) to whatever is in
the same electric environment.  It is possible if not likely that you
will lose contact with scsi disks further along the bus, if you don't
actually blow the controller.

That said, there ARE situations which raid protects you from - simply a
"gentle disconnect" (a totally failed disk that goes open circuit), or
a "gradual failure" (a disk that runs out of spare sectors). In the
latter case the raid will fail the disk completely at the first
detected error, which may well be what you want (or may not be!).

However, I don't see how you can expect to replace a failed disk
without taking down the system. For that reason you are expected to be
running "spare disks" that you can virtually insert hot into the array
(caveat, it is possible with scsi, but you will need to rescan the bus,
which will take it out of commission for some seconds, which may
require you to take the bus offline first, and it MAY be possible with
recent IDE buses that purport to support hotswap - I don't know).

So I think the relevant question is: "what is it that you are protecting
yourself from by this strategy of yours".

When you have the scenario, you can evaluate risks.


> > I don't want system failures when a disk fails,
> 
> Your scenario seems to be that you have the disks of your mirror on the
> same physical system.  That's fundamentally dangerous.  They're both
> subject to damage when the system blows up.  [ ... ]  I have an array
> node (where the journal is kept), and a local mirror component and a
> remote mirror component.
> 
> That system is doubled, and each half of the double hosts the others
> remote mirror component. Each half fails over to the other.

> ** So, you have 2 systems, 1 fails and the "system" switches to the other.
> ** I am not going for a 5 nines system.
> ** I just don't want any down time if a disk fails.

Well,

(1) how likely is it that a disk will fail without taking down the system
(2) how likely is it that a disk will fail
(3) how likely is it that a whole system will fail

I would say that (2) is about 10% per year. I would say that (3) is
about 1200% per year. It is therefore difficult to calculate (1), which
is your protection scenario, since it doesn't show up very often in the
stats!

> ** A disk failing is the most common failure a system can have (IMO).

Not in my experience. See above. I'd say each disk has about a 10%
failure expectation per year. Whereas I can guarantee that an
unexpected  system failure will occur about once a month, on every
important system.

If you think about it that is quite likely, since a system is by
definition a complicated thing. And then it is subject to all kinds of
horrible outside influences, like people rewiring the server room in 
order to reroute cables under the floor instead of through he ceiling,
and the maintenance people spraying the building with insecticide,
everywhere, or just "turning off the electricity in order to test it"
(that happens about four times a year here - hey, I remember when they
tested the giant UPS by turning off the electricity! Wrong switch.
Bummer).

Yes, you can try and keep these systems out of harms way on a
colocation site, or something, but by then you are at professional
level paranoia. For "home systems", whole system failures are far more
common than disk failures.

I am not saying that RAID is useless! Just the opposite. It is a useful
and EASY way of allowing you to pick up the pieces when everything
falls apart. In contrast, running a backup regime is DIFFICULT.


> ** In a computer room with about 20 Unix systems, in 1 year I have seen 10
> or so disk failures and no other failures.

Well, let's see. If each system has 2 disks, then that would be 25% per
disk per year, which I would say indicates low quality IDE disks, but
is about the level I would agree with as experiential.


> ** Are your 2 systems in the same state?

No, why should they be?

> ** They should be at least 50 miles apart (at a minimum).

They aren't - they are in two different rooms. Different systems copy
them every day to somewhere else. I have no need for instant
survivability across nuclear attack.

> ** Otherwise if your data center blows up, your system is down!

True. So what? I don't care. The cost of such a thing is zero, because
if my data center goes I get a lot of insurance money and can retire.
The data is already backed up elsewhere if anyone cares.

> ** In my case, this is so rare, it is not an issue.

It's very common here and everywhere else I know! Think about it - if
your disks are in the same box then it is statistically likely that when
one disks fails it is BECAUSE of some local cause, and that therefore
the other disk will also be affected by it.

It's your "if your date center burns down" reasoning, applied to your
box.

> ** Just use off-site tape backups.

No way! I hate tapes. I backup to other disks.

> ** My computer room is for development and testing, no customer access.

Unfortunately, the admins do most of the sabotage.

> ** If the data center is gone, the workers have nowhere to work anyway (in
> my case).

I agree. Therefore who cares. OTOH, if only the  server room smokes
out, they have plenty of places to work, but nothing to work on.
Tut tut.

> ** Some of our customers do have failover systems 50+ miles apart.

Banks don't (hey, I wrote the interbank communications encryption
software here on the peninsula) here.  They have tapes.  As far as I
know, the tapes are sent to vaults. It often happens that their systems
go down. In fact, I have NEVER managed to connect via the internet page
to their systems at a time when they were in working order. And I have
been trying on and off for about three years. And I often have been in
the bank managers office (discussing mortgages, national debt, etc.)
when the bank's internal systems have gone down, nationwide.

> > so mirror (or RAID5)
> > everything required to keep your system running.
> > 
> > "And there is a risk of silent corruption on all raid systems - that is
> > well known."
> > I question this....
> 
> Why!
> ** You lost me here.  I did not make the above statement. 

Yes you did. You can see from the quoting that you did.

> But, in the case
> of RAID5, I believe it can occur.

So do I. I am asking why you "question this">

> Your system crashes while a RAID5 stripe
> is being written, but the stripe is not completely written. 

This is fairly meaningless.  I don't now what precise meaning the word
"stripe" has in raid5 but it's irrelevant.  Simply, if you write
redundant data, whatever way you write it, raid 1, 5, 6 or whatever,
there is a possibility that you write only one of the copies before the
system goes down. Then when the system comes up it has two different 
sources of data to choose to believe.

> During the
> re-sync, the parity will be adjusted,

See. "when the system comes up ...".

There is no need to go into detail and I don't know why you do!

> but it may be more current than 1 or
> more of the other disks.  But this would be similar to what would happen to
> a non-RAID disk (some data not written).

No, it would not be similar. You don't seem to understand the
mechanism. The mechanism for corruption is that there are two different
versions of the data available when the system comes back up, and you
and the raid system don't know which is more correct. Or even what it
means to be "correct". Maybe the earlier written data is "correct"!

> ** Also with RAID1 or RAID5, if corruption does occur without a crash or
> re-boot, then a disk fails, the corrupt data will be copied to the
> replacement disk.

Exactly so. It's a generic problem with redundant data sources. You
don't know which one to believe when they disagree!

> With RAID1 a 50% risk of copying the corruption, and 50%
> risk of correcting the corruption.  With RAID5, risk % depends on the number
> of disks in the array.

It's the same.  There are two sources of data that you can believe.  The
"real data on disk" or "all the other data blocks in the 'stripe' plus
the parity block".  You get to choose which you believe.

> > I bet a non-mirror disk has similar risk as a RAID1.  But with a RAID1, you
> 
> The corruption risk is doubled for a 2-way mirror, and there is a 50%
> chance of it not being detected at all even if you try and check for it,
> because you may be reading from the wrong mirror at the time you pass
> over the imperfection in the check.
> ** After a crash, md will re-sync the array.

It doesn't know which disk to believe is correct.

There is a stamp on the disks superblocks, but it is only updated every
so often. If the whole system dies while both disks are OK, I don't know 
what will be stamped or what will happen (which will be believed) at
resync. I suspect it is random. I would appreciate clarificaton from
Neil.

> ** But during the re-sync, md could be checking for differences and
> reporting them.

It could. That might be helpful.

> ** It won't help correct anything, but it could explain why you may be
> having problems with your data.

Indeed, it sounds a good idea. It could slow down RAID1 resync, but I
don't think the impact on RAID5 would be noticable.

> ** Since md re-syncs after a crash, I don't think the risk is double.

That is not germane. I already pointed out that you are 50% likely to
copy the "wrong" data IF you copy (and WHEN you copy).  Actually doing
the copy merely brings that calculation into play at the moment of the
resync, instead of later, at the moment when one of the two disks
actually dies and yu have to use the remaining one.

> Isn't that simply the most naive calculation? So why would you make
> your bet?
> ** I don't understand this.

Evidently! :)

> And then of course you don't generally check at all, ever.
> ** True, But I would like md to report when a mirror is wrong.
> ** Or a RAID5 parity is wrong.

Software raid does not spin off threads randomly checking data. If you
don't use it, you don't get to check at all. So just leaving disks
sitting there exposes them to corruption that is checked least of all.

> But whether you check or not, corruptions simply have only a 50% chancce
> of being seen (you look on the wrong mirror when you look), and a 200%
> chance of occuring (twice as much real estate) wrt normal rate.
> ** Since md re-syncs after a crash, I don't think the risk is double.

It remains double whatever you think. The question is whether you
detect it or not. You cannot detect it without checking.

> ** Also, I don't think most corruption would be detectable (ignoring a RAID
> problem).

You wouldn't know which disk was right. The disk might know if it was a
hardware problem

Incidentally, I wish raid would NOT offline the disk when it detects a
read error. It should fall back to the redundant data. 

I may submit a patch for that.

In 2.6 the raid system may even do that. The resync thread comments SAY
that it retries reads. I don't know if it actually does.

Neil?

> ** It depends to the type of data.
> ** Example: Your MP3 collection would go undetected until someone listened
> to the corrupt file. 

:-).

> In contrast, on a single disk they have a 100% chance of detection (if
> you look!) and a 100% chance of occuring, wrt normal rate.
> ** Are you talking about the disk drive detecting the error?

No. You are quite right. I should categorise the types of error more
precisely. We want to distinguish

    1) hard errors (detectable by the disk firmware)
    2) soft errors (not detected by the above)

> ** If so, are you referring to a read error or what?

Read.

> ** Please explain the nature of the detectable error.

"wrong data on the disk or as read from the disk". Define "wrong"!


> > know when a difference occurs, if you want.
> 
> How?
> ** Compare the 2 halves or the RAID1, or check the parity of RAID5.

You wouldn't necesarily know  which of the two data sources was
"correct".

Peter

