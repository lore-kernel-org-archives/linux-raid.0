From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Mon, 14 Mar 2005 23:24:00 -0500
Message-ID: <42366360.8020600@steeleye.com>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <16949.5768.392061.95882@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Wednesday March 9, paul.clements@steeleye.com wrote:

>>avoid setting of sb->events_lo = 1 when creating a 0.90 superblock -- it 
>>doesn't seem to be necessary and it was causing the event counters to 
>>start at 4 billion+ (events_lo is actually the high part of the events 
>>counter, on little endian machines anyway)

> events_lo really should be the low part of the counter and it is for
> me....  something funny must be happening for you...

Yikes...compiling mdadm against the kernel headers. I was trying to 
simplify things and avoid the inevitable breakage that occurs when 
kernel and mdadm headers get out of sync, but alas, it's causing 
problems because of differences between kernel and userland header 
definitions...my mdadm was wrongly assuming big endian for the events 
counters.


>>if'ed out super1 definition which is now in the kernel headers

> I don't like this.  I don't mdadm to include the kernel raid headers.
> I want it to use it's own. 

Yes, I agree, see above... :/


>>included sys/time.h to avoid compile error

> I wonder why I don't get an error.. What error do you get?

The machine I happen to be compiling on has old gcc/libc (2.91) and it's 
not getting the definition for one of the time structures (I forget 
which...).

Thanks,
Paul
