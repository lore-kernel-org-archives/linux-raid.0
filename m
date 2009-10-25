From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Is My Data DESTROYED?!
Date: Sat, 24 Oct 2009 19:22:30 -0500
Message-ID: <20091025002234113.XGGN12118@cdptpa-omta02.mail.rr.com>
References: <a43edf1b0910231444g4c02097dq36640a01689d95f1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a43edf1b0910231444g4c02097dq36640a01689d95f1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> On Fri, Oct 23, 2009 at 15:46, Christian Pernegger <pernegger@gmail.com>
> wrote:
> > For lots of people the primary role of RAID is as a protection against
> > data-loss nowadays.
> 
> Yeah.  Lots of people don't understand technology and have delusional
> expectations of silver bullet happy pill solutions that make their
> tummy feel good.  I am not one of them.  Sysadmins shouldn't have any
> part in that either.

	Correct.  As I admonished adfas asd when he first said he was
undertaking this method of storage, RAID is not fault-free.  It is fault
tolerant.

> > Backups just aren't feasible/cost-effective
> > anymore for the amounts of data involved.
> 
> Backups have never been more feasable, and it is only going to get
> cheaper and easier.  Visit Newegg, microcenter, ebay.  Google "backup
> service".

	The silliest part of this argument is that if one has enough drives
for a mirrored solution, then one has enough drives - or nearly so - for a
separate backup system.  The incremental cost for creating a second system
vs. piling more drives in a single system for a mirrored solution is small.
This is especially true for adfas asd, who is already going to be putting
his mirror drives in a remote system in his garage.

> > Sticking your head in the
> > sand and repeating that mantra doesn't change that and it isn't
> > helping.
> 
> That's odd.  I've always thought that those who imagined a raid array
> as its own backup to be the ones with their heads in the sand.  The
> reason people keep saying raid!=backup is because of those people who
> keep thinking raid=backup.  "Mantra" it all you want.  Raid isn't
> backup.  Ignoring that fact doesn't change it, and isn't helping.

	Absolutely.  A backup helps to eliminate almost all forms of data
loss to one extent or another.  A RAID solution fails completely to
eliminate the most common vector for data loss: human error.  No matter how
robust the RAID solution, however, and even discounting human error, there
will still always be failure modes which can result in data loss.  Of
course, the most obvious is a catastrophic event such as fire or flood.  The
OP is looking to limit those effects by putting his mirrored drives in a
separate system in his garage.

> >> The easiest and cleanest solution is to dd the first and last 100mb or
> >> so of the disks with /dev/zero.
> >
> > Great, that'll destroy all hope of getting the data back. You're
> > really something ...
> 
> You took that out of context and you know it.  Come back when you've
> read the rest of the paragraph.  The filesystem is already gone.  It
> was gone when the machine became unresponsive.  Get a greif counselor,
> and some backup drives.

	Woah, now you are going too far in the other direction.  A lost
filesystem does not necessarily mean an unrecoverable one.

> > How about don't panic, post any and all error messages you're getting
> > (dmesg) and wait?
> 
> Time is money.  It would be quicker to recreate the array and restore
> from a backup than to wait on a mailing list.  He might also want to

	Now that is completely untrue in many cases.  Restoring my system
from backup can easily take 3 or 4 days.  Indeed, the last time I had to do
it, the backup system also had an issue (my own fault), which caused the
restore to take over 2 weeks.  Multi-terrabyte arrays take a long time to
restore.  I expect my Video server and its backup to reach 30T each within
the next two years.  The OP's is 4T, I think, and even that takes a while to
restore.

> And filesystem corruption, which it sounds like this is.  Even fsck is
> not guaranteed to recover files.  It will fix the filesystem, even if
> that means truncating the / directory.
> 
> Here's a new offsite backup service with unlimited transfer and
> unlimited storage, for just $5 a month. That could very realistically
> be cheaper than your cost in power, hvac, and failed drives if you use
> the service enough. http://www.backblaze.com/

	Restoring over 10T of files on a less than 10 Mbps link?  I don't
think so, especially not with ISPs starting to put caps of far less than 1G
per month of data transfer.


