From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID5 / 6 Growth
Date: Wed, 16 Dec 2009 19:51:18 -0600
Message-ID: <1C.0E.01567.69E892B4@cdptpa-omtalb.mail.rr.com>
References: <87eimv6oga.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87eimv6oga.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: goswin-v-b@web.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > High enough?  Wouldn't a higher speed limit mean more stress on the
> systems?
> > Its value is 1000.
> 
> A higher min value will block more normal IO (if there is
> any).

	No, not really.  All the system that is currently being grown does
is incrementally rsync the data from the main server every morning.  The
main server, which will be grown after this server is done, is another
matter.

> Raising min is usefull to ensure the job gets done in a certain
> time, to not let normal IO slow down a rebuild too much.

	OK, but like I said, for the most part there isn't any other I/O.
 
> >> MB/s) along with /proc/sys/dev/raid/speed_limit_max?
> >
> > It's 200,000
> 
> I only ever had to tune this once when too much IO would deadlock an
> external enclosure. Otherwise keep this really high so it uses all
> idle IO there is.

	200MBps is far more than the system can handle.  These are consumer
class drives on a relatively inexpensive 4 port controller feeding a Port
Multiplier chassis.

> As to your initial question: Being able to keep the filesystem mounted
> and used is the whole point of having online growing of the raid
> system. If that weren't save then there would be no point to it as you
> could just as well stop the raid if you already umounted it and grow
> it offline.

	I know that is the point of the utility.  My question boils down to,
"How safe is it to avail one's self of the capability if it is not essential
to have the array mounted for the duration?"  I don't particularly like
having the array unavailable (especially not for nearly 5 days), but I
prefer that to risking data loss, or especially risking irretrievably losing
the entire array.  The question is particularly pertinent given the fact the
growth is going to take nearly 5 days (a lot can happen in 5 days), and the
fact the system was having the rather squirrelly issue a few days back which
seems - emphasis on SEEMS - to have been resolved by disabling NCQ.  What
happens if the system kicks a couple of drives, especially if one drive gets
kicked, a bunch of data gets written and then a few minutes later another
drive gets kicked?  In particular, what if neither of the two drives that
get kicked are the new drive?

