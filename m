From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: RAID1 robust read and read/write correct and EVMS-BBR
Date: Wed, 23 Feb 2005 22:01:44 +0100
Message-ID: <oi7ve2-qug.ln1@news.it.uc3m.es>
References: <CAC3BCBB443DEC439198F230B4BCC7E9092C45CC@exna6-ftsaa.mis.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: evms-devel@lists.sourceforge.net
List-Id: linux-raid.ids

In gmane.linux.raid Nagpure, Dinesh <Dinesh.Nagpure@stratus.com> wrote:
> I noticed the discussion about robust read on the RAID list and similar one
> on the EVMS list so I am sending this mail to both the lists. Latent media
> faults which prevent data from being read from portions of a disk has always
> been a concern for us. Such faults will go undetected till the time that
> block is read.

Well, sure, unless you have some other test. Finding latent faults is
always a question of making them come out into the open. But do you
want to? Testing something to destruction does not make it more useful.

> RAID 1 depends on error free mirrors for proper operation and

Err, if one mirror has a read error you can always read from another one
instead.

> undiscovered bad blocks would only give pseudo illusion of duplexity when in

Well, undiscovered bad blocks are just that, nice and crypto! But I
take your point. The problem with your reasoning however is that it is
not raid-specific - undiscovered errors in ANYTHING are a problem
waiting to be discovered :).

Should we be concerned about that? Sometimes yes, sometimes no.

When we shouldn't be concerned about it is when our aim is merely to DO
BETTER.

When we should be concerned about it is when our aim is to BE PERFECT.

Personally, I am only looking to do better.

> reality the array should be degraded.

Why should we degrade a perfectly good mirror just because one of the
disks has a read error on a particular sector?  You've lost me there!

> Over long run all the mirrors might
> develop latent media faults

Sure they might.  But it's not a crime to have faults!  We all have them.
We don't kill ourselves as soon as we develop a blackhead, which seems
to be what you are suggesting!

Personally I'd launch resyncs every so often. SInce robust-read makes
the array tolerant of read faults during resync too, you will reduce
the number of errors by 1/n (i.e. get rid of 50% of the errors in a
2-disk array) every time you do this.

And/Or you can  also help develop the write-correct addition to the
robust-read patch to make the read errors get corrected on the fly.


>  and none can be replaced with a new disk.

Sure they can. Whenever you like. But why?

> Also
> it is a disaster if the same block goes bad on all the mirrors in a RAID 1
> volume.

No it's not. It's an error. It's no worse than a block going bad on a
single disk. The world doesn't cave in when that happens. It takes
longer to happen on a 2 disk system because one needs to get both disks
with errors in the same place. So the 2 disk raid is a lot BETTER.

> With this concern we developed what we call "disk-scrubber". The

Well, then you are up a gum-tree, because your concerns appear to be
ill-reasoned. That's not to say that there isn't merit in what you
might now propose, but it won't be fully justified by your reasoning so
far, if it is what you have shown!

> approach was to proactively seek for bad spots on the disk and when one is
> discovered, read the correct data from the other mirror and use it to repair

There's nothing wrong with that, if you like your disk humming away
doing a resync in the background. One can do that. Just keep the raid1d
resync thread occupied. There are several possible strategies.

But I wouldn't say you "developed" this! Isn't it a standard tactic in
classical raid to do background tests and syncs? I thought the idea was
to combat the tendency of raid to develop errors that cannot be detected
by the array itself afterwards!

> the disk by way of a write. SCSI disks automatically repair bad spots on
> write by internally mapping the bad spots to spare sectors (Being SCSI

So do IDE. You seem to be a bit behind the times. Surely that's been
the case for at least five years? Or more?

> centric might be one limitation of this solution).

I don't think so.

> The implementation comprised of a thread that looks for bad spots by way of
> slow repeated continuous scan through all disks.

Brilliant , but it's trivial to make the resync thread active the whole
time.

> The RAID error management
> was extended to attempt a repair on read error from a RAID 1 array to permit
> fixing of user discovered bad spots as well as those discovered by the

Wel, I'd like to see how you did that bit. I've only suggested code t
do it, not actually tried it!

> scrubber. The work is lk2.4.26 based as of now.
> 
> I can go back and put together a patch over the weekend if anyone is
> interested in using it. 

Go "back"? I don't understand .. how do you actually have the work if
not as a patch? But yes - of course I would be interested. Please show
the patch as soon as possible! Looks like a combined patch is in order!

Peter

