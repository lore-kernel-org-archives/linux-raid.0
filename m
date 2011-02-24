From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: high throughput storage server?
Date: Thu, 24 Feb 2011 09:53:52 -0600
Message-ID: <4D667F10.6060409@hardwarefreak.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <Pine.GSO.4.64.1102181429201.7398@montezuma.acc.umu.se> <4D5EFDD6.1020504@hardwarefreak.com> <Pine.GSO.4.64.1102211116030.7398@montezuma.acc.umu.se> <4D62DE55.8040705@hardwarefreak.com> <ijvtqg$pke$1@dough.gmane.org> <4D63BC6D.8010209@hardwarefreak.com> <ik0gkm$nn$1@dough.gmane.org> <4D64A082.9000601@hardwarefreak.com> <ik33nt$fd8$1@dough.gmane.org> <4D6518ED.1080908@anonymous.org.uk> <4D658335.3040401@hardwarefreak.com> <4D659B9A.2090406@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D659B9A.2090406@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

John Robinson put forth on 2/23/2011 5:43 PM:
> On 23/02/2011 21:59, Stan Hoeppner wrote:

>> Actually, that's not what I mentioned.
> 
> Yes, it's precisely what you mentioned in this post:
> http://marc.info/?l=linux-raid&m=129777295601681&w=2

Sorry John.  I thought you were referring to my recent post regarding 48
drives.  I usually don't remember my own posts very long, especially
those over a week old.  Heck, I'm lucky to remember a post I made 2-3
days ago.  ;)

> [...]
>>> and I wondered how a 40-drive RAID-60 (i.e. a
>>> 10-way RAID-0 stripe over 4-way RAID-6 arrays) would perform
> [...]
>> First off what you describe here is not a RAID60.  RAID60 is defined as
>> a stripe across _two_ RAID6 arrays--not 10 arrays.  RAID50 is the same
>> but with RAID5 arrays.  What you're describing is simply a custom nested
>> RAID, much like what I mentioned above.
> 
> In the same way that RAID10 is not specified as a stripe across two
> RAID1 arrays, RAID60 is not specified as a stripe across two arrays. But
> yes, it's a nested RAID, in the same way that you have repeatedly
> insisted that RAID10 is nested RAID0 over RAID1.

"RAID 10" is used to describe striped mirrors regardless of the number
of mirror sets used, simply specifying the number of drives in the
description, i.e. "20 drive RAID 10" or "8 drive RAID 10".  As I just
learned from doing some research, apparently when ones stripes more than
2 RAID6s one would then describe the array and an "n leg RAID 60", or "n
element RAID 60".  In your example this would be a "10 leg RAID 60".
I'd only seen the term "RAID 60" used to describe the 2 leg case.  My
apologies for straying out here and wasting time on a non-issue.

>> Anyway, you'd be better off striping 13 three-disk mirror sets with a
>> spare drive making up the 40.  This covers the double drive failure
>> during rebuild (a non issue in my book for RAID1/10), and suffers zero
>> read or write performance, except possibly LVM striping overhead in the
>> event you have to use LVM to create the stripe.  I'm not familiar enough
>> with mdadm to know if you can do this nested setup all in mdadm.
> 
> Yes of course you can. (You can use md RAID10 with layout n3 or do it
> the long way round with multiple RAID1s and a RAID0.) But in order to
> get the 20TB of storage you'd need 60 drives. That's why for the sake of
> slightly better storage and energy efficiency I'd be interested in how a
> RAID 6+0 (if you prefer) in the arrangement I suggested would perform
> compared to a RAID 10.

For the definitive answer to this you'd have to test each RAID level
with your target workload.  In general, I'd say, other than the problems
with parity performance, the possible gotcha is being able to come up
with a workable stripe block/width with such a setup.  Wide arrays
typically don't work well for general use filesystems as most files are
much smaller than the typical stripe block required to get decent
performance from such a wide stripe.  The situation is even worse with
nested stripes.

Your example uses a top level stripe width of 10 with a nested stripe
width of 2.  Getting any filesystem to work efficiently with such a
nested RAID, from both an overall performance and space efficiency
standpoint, may prove to be very difficult.  If you can't find a magic
formula for this, you could very well end up with worse actual space
efficiency in the FS than if you used a straight RAID10.

If you prefer RAID6 legs, what I'd recommend is simply concatenating the
legs instead of striping them.  Using your 40 drive example, I'd
recommend using 4 RAID6 legs of 10 drives each, so you get an 8 drive
stripe width per array and thus better performance than the 4 drive
case.  Use a stripe block size of 64KB on each array as this should
yield a good mix of space efficiency for average size files/extents and
performance for random IO with such size files.  Concatenating in this
manner will avoid the difficult to solve multiple layered stripe
block/width to filesystem harmony problem.

Using XFS atop this concatenated RAID6 setup with an allocation group
count of 32 (4 arrays x 8 stripe spindles/array) will give you good
parallelism across the 4 arrays with a multiuser workload.  AFAIK,
EXT3/4, ReiserFS, JFS, don't use allocation groups or anything like
them, and thus can't get parallelism from such a concatenated setup.
This is one of the many reasons why XFS is the only suitable Linux FS
for large/complex arrays.  I haven't paid any attention to BTRFS, so I
don't know if it would be suitable for scenarios like this.  It's so far
from production quality at this point it's not really even worth
mentioning, but I did so for the sake of being complete.

As always, all of this is a strictly academic guessing exercise without
testing the specific workload.  That said, for any multiuser workload
this setup should perform relatively well, for a parity based array.

The takeaway here is concatenation instead of layered striping, and
using the appropriate filesystem to take advantage of such.

> I'm positing this arrangement specifically to cope with the almost
> inevitable URE when trying to recover an array. You dismissed it above
> as a non-issue but in another post you linked to the zdnet article on
> "why RAID5 stops working in 2009", and as far as I'm concerned much the
> same applies to RAID1 pairs. UREs are now a fact of life. When they do
> occur the drives aren't necessarily even operating outside their specs:
> it's 1 in 10^14 or 10^15 bits, so read a lot more than that (as you will
> on a busy drive) and they're going to happen.

I didn't mean to discount anything.  The math shows that UREs during
rebuild aren't relevant for mirrored RAID schemes.   This is because
with current drive sizes and URE rates you have to read more than
something like 12 TB before encountering a URE.  The largest drives
available are 3TB, or ~1/4th the "URE rebuild threshold" bit count.
Probabilities inform us about the hypothetical world in general terms.
In the real world, sure, anything can happen.  Real world data of this
type isn't published, do we have to base our calculation and planning on
what the manufacturers provide.

The article makes an interesting point in that as drives continue to
increase in capacity, with their URE rates remaining basically static,
eventually every RAID6 rebuild will see a URE.  I haven't done the math
so I don't know at exactly what drive size/count this will occur.  The
obvious answer to it will be RAID7, or triple parity RAID.  At that
point, parity RAID will have, in practical $$, lost its only advantage
over mirrors, i.e. RAID10.

In the long run, if the current size:URE rate trend continues, we may
see the 3 leg RAID 10 becoming popular.  My personal hope is that the
drive makers can start producing drives with much lower URE rates.  I'd
rather never see the days of anything close to hexa parity RAID9 and
quad leg RAID10 being required simply to survive a rebuild process.

-- 
Stan
