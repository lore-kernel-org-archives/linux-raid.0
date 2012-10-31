From: David Brown <david.brown@hesbynett.no>
Subject: Re: Best way (only?) to setup SSD's for using TRIM
Date: Wed, 31 Oct 2012 15:11:59 +0100
Message-ID: <509131AF.2030400@hesbynett.no>
References: <508D808A.7040100@curtronics.com> <508FA2C6.2050800@hesbynett.no> <508FE44A.3040507@curtronics.com> <508FF85F.1030308@hesbynett.no> <Pine.LNX.4.64.1210301306470.20143@router.curtronics.com> <B371ADF3-F328-4E1B-A6D2-87DE1974D8FF@colorremedies.com> <5090E239.9040302@hesbynett.no> <CAJEsFnkM9w0kNbNd51ShP0uExvsZE6V9h3WKKs3nxWfncUCYJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJEsFnkM9w0kNbNd51ShP0uExvsZE6V9h3WKKs3nxWfncUCYJA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Haase <mail.alexhaase@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 31/10/2012 14:12, Alexander Haase wrote:
> Has anyone considered handling TRIM via an idle IO queue? You'd have to
> purge queue items that conflicted with incoming writes, but it does get
> around the performance complaint. If the idle period never comes, old
> TRIMs can be silently dropped to lessen queue bloat.
>

I am sure it has been considered - but is it worth the effort and the 
complications?  TRIM has been implemented in several filesystems (ext4 
and, I believe, btrfs) - but is disabled by default because it typically 
slows down the system.  You are certainly correct that putting TRIM at 
the back of the queue will avoid the delays it causes - but it still 
will not give any significant benefit (except for old SSDs with limited 
garbage collection and small over-provisioning ), and you have a lot of 
extra complexity to ensure that a TRIM is never pushed back until after 
a new write to the same logical sectors.

It would be much easier and safer, and give much better effect, to make 
sure the block allocation procedure for filesystems emphasised 
re-writing old blocks as soon as possible (when on an SSD).  Then there 
is no need for TRIM at all.  This would have the added benefit of 
working well for compressed (or sparse) hard disk image files used by 
virtual machines - such image files only take up real disk space for 
blocks that are written, so re-writes would save real-world disk space.

> As far as parity consistency, bitmaps could track which stripes( and
> blocks within those stripes) are expected to be out of parity( also
> useful for lazy device init ). Maybe a bit-per-stripe map at the logical
> device level and a bit-per-LBA bitmap at the stripe level?

Tracking "no-sync" areas of a raid array is already high on the md raid 
things-to-do list (perhaps it is already implemented - I lose track of 
which features are planned and which are implemented).  And yes, such 
no-sync tracking would be useful here.  But it is complicated, 
especially for raid5/6 (raid1 is not too bad) - should TRIMs that cover 
part of a stripe be dropped?  Should the md layer remember them and 
coalesce them when it can TRIM a whole stripe?  Should it try to track 
partial synchronisation within a stripe?

Or should the md developers simply say that since supporting TRIM is not 
going to have any measurable benefits (certainly not with the sort of 
SSD's people use in raid arrays), and since TRIM slows down some 
operations, it is better to keep things simple and ignore TRIM entirely? 
  Even if there are occasional benefits to having TRIM, is it worth it 
in the face of added complication in the code and the risk of errors?

There /have/ been developers working on TRIM support on raid5.  It seems 
to have been a complicated process.  But some people like a challenge!

>
> On the other hand, does it hurt if empty blocks are out of parity( due
> to TRIM or lazy device init)? The parity recovery of garbage is still
> garbage, which is what any sane FS expects from unused blocks. If and
> when you do a parity scrub, you will spend a lot of time recovering
> garbage and undo any good TRIM might have done, but usual drive
> operation should quickly balance that out in a write-intensive
> environment where idle TRIM might help.
>

Yes, it "hurts" if empty blocks are out of sync.  On obvious issue is 
that you will get errors when scrubbing - the md layer has no way of 
knowing that these are unimportant (assuming there is no no-sync 
tracking), so any real problems will be hidden by the unimportant ones.

Another issue is for RMW cycles on raid5.  Small writes are done by 
reading the old data, reading the old parity, writing the new data and 
the new parity - but that only works if the parity was correct across 
the whole stripe.  Even if raid5 TRIM is restricted to whole stripes, a 
later small write to that stripe will be a disaster if it is not in sync.


