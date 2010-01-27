From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Read errors on raid5 ignored, array still clean .. then disaster !!
Date: Wed, 27 Jan 2010 10:01:18 +0100
Message-ID: <87zl3z2a75.fsf@frosties.localdomain>
References: <4B5F6C73.30707@texsoft.it>
	<20100127074138.GA9607@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100127074138.GA9607@maude.comedia.it> (Luca Berra's message of
	"Wed, 27 Jan 2010 08:41:38 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luca Berra <bluca@comedia.it> writes:

> On Tue, Jan 26, 2010 at 11:28:03PM +0100, Giovanni Tessore wrote:
>> Is this some kind of bug?
> No
>> Is there any way to configure raid in order to have devices marked
>> faulty on read errors (at least when they clearly become too many)?
> I don't think so
>> This could (and for me did) bring to big disasters!
> Don't agree with you, you had all the info from syslog
> You should have run smart tests on the disks and proactively replace a
> failing disk.
>
>> In a post of some months ago of a person who had a similar problem,
>> I read as reply that ignoring the read errors is the wanted
>> behaviour of md ... but I can't believe this!!
>
> it does _not_ ignore read errors in case of read errors mdadm rewrites
> the erroring sector, and only if
> this fails it will kick the member out of the array.
> with modern drives it is possible to have some failed sector, which the
> drive firmware will reallocate on write (all modern drives have a range
> of sectors reserved for this very purpose)
> mdadm does not do any bookkeeping on reallocated_sector_count per drive
> the drive does. the data can be accessed with smartctl
> drives showing excessive reallocated_sector_count should be replaced.
>
> Consider the following scenario:
> raid5 (sda,b,c,d)
> sda has a read error, mdadm kicks it immediately from the array
> a few minutes/hours later sdc fails completely
> lost data and no time to react, that is far worse than having 50 days of
> warnings and ignoring them.

Plus you should have run the raid check as a cron job. In Debian that is
done per default on every first sunday of a month at 3am. The check
reads every stripe from all disks and checks that the parity
matches. That would have caused all read errors of sda to be repaired
or, when the drive runs out of sectors to remap to, kicked the drive.

MfG
        Goswin
