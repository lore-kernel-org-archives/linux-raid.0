From: "James Lee" <james.lee@cantab.net>
Subject: Re: Proposal: non-striping RAID4
Date: Tue, 13 Nov 2007 23:48:40 +0000
Message-ID: <ef2613f30711131548l2ecacd3p9994fdc6ebb6042a@mail.gmail.com>
References: <ef2613f30711091657q48e57b63if47a3653a92b28a6@mail.gmail.com>
	 <4737AC62.8000308@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4737AC62.8000308@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the reply Bill, and on reflection I agree with a lot of it.

I do feel that the use case is a sensible valid one - though maybe I
didn't illustrate it well.  As an example suppose I want to, starting
from scratch, build up a cost-effective large redundant array to hold
data.

With standard RAID5 I might do as follows:
- Buy 3x 500GB SATA drives, setup as a single RAID5 array.
- Once I have run out of space on this array (say in 12 months, for
example), add another 1x500GB drive and expand the array.
- Another 6 months or so later, buy another 1x 500GB drive and expand
the array, etc.
This isn't that cost-efficient, as by the second or third iteration,
500GB drives are not good value per-GB (as the sweet-spot has moved
onto 1TB drives say).

With a scheme which gives a redundant array with the capacity being
the sum of the size of all drives minus the size of the largest drive,
the sequence can be something like:
- Buy 3x500GB drives.
- Once out of space, add a drive with size determined by current best
price/GB (eg. 1x750GB drive).
- Repeat as above (giving, say, 1TB, 1.5TB,  drives).
(- When adding larger drives, potentially also start removing the
smallest drives from the array and selling them - to avoid having too
many drives.)

However what I do agree with is that this is entirely achievable using
current RAID5 and RAID1, and as you described (and ideally then having
creating a linear array out of the resulting arrays).  All it would
require, as you say, is either a simple wrapper script issuing mdadm
commands, or ideally for this ability to be added to mdadm itself.  So
that the create command for this new "raid type" would just create all
the RAID5 and RAID1 arrays, and use them to make a linear array.  The
grow command (when adding a new drive to the array) would partition it
up, expand each of the RAID5 arrays onto it, convert the existing
RAID1 array to a RAID5 array using the new drive, create a new RAID1
array, and expand the linear array containing them all.  The only
thing I'm not entirely sure about is whether mdadm currently supports
online conversion of 2-drive RAID1 array --> 3-drive RAID5 array?

So thanks for the input, and I'll now ask a slightly different
question to my original one - would there be any interest in enhancing
mdadm to do the above?  By which I mean would patches which did this
be considered, or would this be deemed not to be useful / desirable?

Thanks,
James

On 12/11/2007, Bill Davidsen <davidsen@tmr.com> wrote:
> James Lee wrote:
> > I have come across an unusual RAID configuration type which differs
> > from any of the standard RAID 0/1/4/5 levels currently available in
> > the md driver, and has a couple of very useful properties (see below).
> >  I think it would be useful to have this code included in the main
> > kernel, as it allows for some use cases that aren't well catered for
> > with the standard RAID levels.  I was wondering what people's thoughts
> > on this might be?
> >
> > The RAID type has been named "unRAID" by it's author, and is basically
> > similar to RAID 4 but without data being striped across the drives in
> > the array.  In an n-drive array (where the drives need not have the
> > same capacity), n-1 of the drives appear as independent drives with
> > data written to them as with a single standalone drive, and the 1
> > remaining drive is a parity drive (this must be the largest capacity
> > drive), which stores the bitwise XOR of the data on the other n-1
> > drives (where the data being XORed is taken to be 0 if we're past the
> > end of that particular drive).  Data recovery then works as per normal
> > RAID 4/5 in the case of the failure of any one of the drives in the
> > array.
> >
> > The advantages of this are:
> > - Drives need not be of the same size as each other; the only
> > requirement is that the parity drive must be the largest drive in the
> > array.  The available space of the array is the sum of the space of
> > all drives in the array, minus the size of the largest drive.
> > - Data protection is slightly better than with RAID 4/5 in that in the
> > event of multiple drive failures, only some data is lost (since the
> > data on any non-failed, non-parity drives is usable).
> >
> > The disadvantages are:
> > - Performance:
> >     - As there is no striping, on a non-degraded array the read
> > performance will be identical to that of a single drive setup, and the
> > write performance will be comparable or somewhat worse than that of a
> > single-drive setup.
> >     - On a degraded arrays with many drives the read and write
> > performance could take further hits due to the PCI / PCI-E bus getting
> > saturated.
> >
>
> I personally feel that "this still looks like a bunch of little drives"
> should be listed first...
> > The company which has implemented this is "Lime technology" (website
> > here: http://www.lime-technology.com/); an overview of the technical
> > detail is given on their website here:
> > http://www.lime-technology.com/wordpress/?page_id=13.  The changes
> > made to the Linux md driver to support this have been released under
> > the GPL by the author - I've attached these to this email.
> >
> > Now I'm guessing that the reason this hasn't been implemented before
> > is that in most cases the points above mean that this is a worse
> > option than RAID 5, however there is a strong use case for this
> > system.  For many home users who want data redundancy, the current
> > RAID levels are impractical because the user has many hard drives of
> > different sizes accumulated over the years.  Even for new setups, it
> >
>
> And over the years is just the problem. You have a bunch of tiny drives
> unsuited, or marginally suited, for the size of modern distributions,
> and using assorted old technology. There's a reason these are thrown out
> and available, they're pretty much useless. Also they're power-hungry,
> slow, and you would probably need more of these than would fit in a
> standard case to provide even minimal useful size. They're also probably
> PATA, meaning that many modern motherboards don't support them well (if
> at all).
> > is generally not cost-effective to buy multiple identical sized hard
> > drives, compared with incrementally adding storage of the capacity
> > which is at the best price per GB at the time.  The fact that there is
> > a need for this type of flexibility is evidenced, for example, by
> > various forum threads such as for example this thread containing over
> > 1500 posts in a specialized audio / video forum:
> > http://www.avsforum.com/avs-vb/showthread.php?t=573986, as well as the
> > active community in the forums on the Lime technology website.
> >
>
> I can buy 500GB USB drives for $98+tax if I wait until Stapels or Office
> Max have a sale, $120 anytime, anywhere. I see 250GB PATA drives being
> flogged for $50-70 for lack of demand. I simply can't imagine any case
> where this would be useful other than as a proof of concept.
>
> Note: you can do this with existing code by setting up a partitions of
> various sizes on multiple drives, first partitions size of smallest
> drive, next the remaining space on the next drive, etc. On every set of
>  >2 drives make a raid-5, on every set of two drives make raid-10, and
> have a bunch of smaller redundant drives which are faster. You can then
> combine them all into one linear array if it pleases you. I have a crate
> if drives from 360MB (six) to about 4GB, and they are going to be sold
> by the pound because they are garbage.
> > Would there be interest in making this kind of addition to the md code?
> >
>
> I can't see that the cost of maintaining it is justified by the benefit,
> but not my decision. If you were to set up such a thing using FUSE,
> keeping it out of the kernel but still providing the functionality, it
> might be worth doing. On the other hand, setting up the partitions and
> creating the arrays could probably be done by a perl script which would
> take only a few hours to write.
> > PS: In case it wasn't clear, the attached code is simply the code the
> > author has released under GPL - it's intended just for reference, not
> > as proposed code for review.
> >
> Much as I generally like adding functionality, I *really* can't see much
> in this idea. It seems to me to be in the "clever but not useful" category.
>
> --
> bill davidsen <davidsen@tmr.com>
>   CTO TMR Associates, Inc
>   Doing interesting things with small computers since 1979
>
>
