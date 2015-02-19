From: Chris Murphy <lists@colorremedies.com>
Subject: Re: What are mdadm maintainers to do? (error recovery redundancy/data loss)
Date: Wed, 18 Feb 2015 23:12:37 -0700
Message-ID: <CAJCQCtQWBYRu7DFrdoKzj7G1-UKDJKBqyVn=6p91oagLfqd_Kw@mail.gmail.com>
References: <loom.20150214T222329-324@post.gmane.org>
	<20150216142845.0d50207c@notabene.brown>
	<loom.20150216T124230-883@post.gmane.org>
	<54E1EDEA.1030503@turmel.org>
	<loom.20150216T165111-551@post.gmane.org>
	<54E226B5.1080500@turmel.org>
	<loom.20150216T183419-387@post.gmane.org>
	<20150217104906.62d36c62@notabene.brown>
	<loom.20150217T080345-764@post.gmane.org>
	<CAJCQCtQvoB0yPPc=RXPPyJhpaFwH0pQTRCRaR_ycTbzHrD6rLw@mail.gmail.com>
	<54E3C51C.2080106@websitemanagers.com.au>
	<CAJCQCtTv-HMX77GWqA+_1rfkWodsTETp_Y3w5En-N4nGCymWsA@mail.gmail.com>
	<loom.20150218T102011-486@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20150218T102011-486@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 18, 2015 at 4:04 AM, Chris <email.bug@arcor.de> wrote:
>>
>
> Hello all,
>
> the discussion about SCTERC boils down to letting the drive attempt ERC a
> little more or less. For any given disk experience seems to tell the slight
> difference is, that if ERC is allowed longer you may see the first
> unrecoverable erros (UREs) just a little (maybe only a month) later.




>
> UREs are inevitable. Thus, if I run a filesystem on just a single drive it
> will get corrupted at some point, nothing to do about it.

On a single randomly selective drive, I disagree. In aggregate, that's
true, eventually it will happen, you just won't know which drive or
when it'll happen. I have a number of 5+ year old drives that have
never reported a  URE. Meanwhile another drive has so many bad sectors
I only keep it around for abusive purposes.



>
> Wait, except..., use a redundant raid! And here it makes a lot of a
> difference that the drive's ERC actually terminates before the controller
> timeout, to not loose all your redundacy again and be in hight risk of UREs
> showing up during the re-sync.
>
> So for a proper comparison we need to look at the difference it makes in the
> usage scenarios (error delay vs. loosing redundant error resilence + URE
> triggering), not at the single recoverable/unrecoverable error incidence. It
> looks to me, that it makes a lot of a differnce to redundant raids and no
> qualitative difference to single disk filesystems.
>
> And we need to keep in mind that single disk filesystems do also depend on
> the disk to stop grinding away with ERC attempts before the controller
> timout. Otherwise disk reset may make the system clear buffers and loose
> open files? Without prolonging the linux default controller timout, SCTERC
> can prevent that where supported.

To get to one size fits all, where SCT ERC is disabled (consumer
drive), and the kernel command timer is increased accordingly, we
still need the delay reportable to user space. You can't have a by
default 2-3 minute showstopper without an explanation so that the user
can tune this back to 30 seconds or get rid of the drive or some other
mitigation. Otherwise this is a 2-3 minute silent failure. I know a
huge number of users who would assume this is a crash and force power
off the system.

The option where SCT ERC is configurable, you could also do this one
size fits all by setting this to say 50-70 deciseconds, and for read
failures to cause  recovery if raid1+ is used, or cause a read retry
if it's single, raid0, or linear. In other words, control the retries
in software for these drives.




>> I don't know if a udev rule can say "If the drive exclusively uses md,
>> lvm, btrfs, zfs raid1, 4+ or nested of those, and if the drive does
>> not support configurable SCT ERC, then change the kernel command timer
>> for those devices to ~120 seconds" then that might be a plausible
>> solution to use consumer drives the manufacturer rather explicitly
>> proscribes from use in raid...
>
> The script called by the udev rule could do that, but can be kept as simple
> as proposed, and can set SCTERC regardles, because setting SCTERC below the
> controller timout makes a qualitative difference in running the redundant
> arrays and a marginal difference in running non-redundant filesystems. (And
> nevertheless, set long controller timout for devices that don's support SCTERC.)

I can't agree at all, lacking facts, that this change is marginal for
non-redundant configurations. I've seen no data how common long
recovery incidents are, or how much more common data loss would be if
long recovery were prevented.

The mere fact they exist suggests they're necessary. It may very well
be that the ECC code or hardware used is so slow that it really does
take so unbelievably long (really 30 seconds is an eternity, and a
minute seems outrageous, and 2-3 minutes seems wholly ridiculous as in
worthy of brutal unrelenting ridicule); but that doesn't even matter
even if it is true, that's the behavior of the ECC whether we like it
or not, we can't just willy nilly turn these things off without
understanding the consequences. Just saying it's marginal doesn't make
it true.

So if SCT ERC is short, now you have to have a mitigation for the
possibly higher number of URE's this will result in, in the form of
kernel instigated read retries on read fail. And in fact, this may be
false. The retries the drive does internally might be completely
different than the kernel doing another read. The way data is encoded
on the drive these days bears no resemblance to discreet 1's and 0's.

And you also need a reliable opt out for SSD's. Their failures seem
rather different.

-- 
Chris Murphy
