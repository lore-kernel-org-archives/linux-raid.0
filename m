From: Joe Landman <joe.landman@gmail.com>
Subject: Re: high throughput storage server?
Date: Thu, 17 Feb 2011 17:13:04 -0500
Message-ID: <4D5D9D70.9010603@gmail.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <4D5D017B.50109@anonymous.org.uk> <4D5D9758.2080400@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5D9758.2080400@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: John Robinson <john.robinson@anonymous.org.uk>, Matt Garman <matthew.garman@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/17/2011 04:47 PM, Stan Hoeppner wrote:
> John Robinson put forth on 2/17/2011 5:07 AM:
>> On 14/02/2011 23:59, Matt Garman wrote:
>> [...]
>>> The requirement is basically this: around 40 to 50 compute machines
>>> act as basically an ad-hoc scientific compute/simulation/analysis
>>> cluster.  These machines all need access to a shared 20 TB pool of
>>> storage.  Each compute machine has a gigabit network connection, and
>>> it's possible that nearly every machine could simultaneously try to
>>> access a large (100 to 1000 MB) file in the storage pool.  In other
>>> words, a 20 TB file store with bandwidth upwards of 50 Gbps.
>>
>> I'd recommend you analyse that requirement more closely. Yes, you have
>> 50 compute machines with GigE connections so it's possible they could
>> all demand data from the file store at once, but in actual use, would they?
>
> This is a very good point and one which I somewhat ignored in my initial
> response, making a silent assumption.  I did so based on personal
> experience, and knowledge of what other sites are deploying.

Well, the application area appears to be high performance cluster 
computing, and the storage behind it.  Its a somewhat more specialized 
version of storage, and not one that a typical IT person runs into 
often.  There are different, some profoundly so, demands placed upon 
such storage.

Full disclosure:  this is our major market, we make/sell products in 
this space, have for a while.  Take what we say with that in your mind 
as a caveat, as it does color our opinions.

The spec's as stated, 50Gb/s ... its rare ... exceptionally rare ... 
that you ever see cluster computing storage requirements stated in such 
terms.  Usually they are stated in the MB/s or GB/s regime.  Using  a 
basic conversion of Gb/s to GB/s, the OP is looking for ~6GB/s support.

Some basic facts about this.

Fibre channel (FC-8 in particular), will give you, at best 1GB/s per 
loop, and that presumes you aren't oversubscribing the loop.  The vast 
majority of designs we see coming from IT shops, do, in fact, badly 
oversubscribe the bandwidth, which causes significant contention on the 
loops.  The Nexsan unit you indicated (they are nominally a competitor 
of ours) is an FC device, though we've heard rumblings that they may 
even allow for SAS direct connections (though that would be quite cost 
ineffective as a SAS JBOD chassis compared to other units, and you still 
have the oversubscription problem).

As I said, high performance storage design is a very ... very ... 
different animal from standard IT storage design.  There are very 
different decision points, and design concepts.

> You don't see many deployed filers on the planet with 5 * 10 GbE front
> end connections.  In fact, today, you still don't see many deployed
> filers with even one 10 GbE front end connection, but usually multiple
> (often but not always bonded) GbE connections.

In this space, high performance cluster storage, this statement is 
incorrect.

Our units (again, not trying to be a commercial here, see .sig if you 
want to converse offline) usually ship with either 2x 10GbE, 2x QDR IB, 
or combinations of these.  QDR IB gets you 3.2 GB/s.  Per port.

In high performance computing storage (again, the focus of the OP's 
questions), this is a reasonable configuration and request.
>
> A single 10 GbE front end connection provides a truly enormous amount of
> real world bandwidth, over 1 GB/s aggregate sustained.  *This is
> equivalent to transferring a full length dual layer DVD in 10 seconds*

Trust me.  This is not *enormous*.  Well, ok ... put another way, we 
architect systems that scale well beyond 10GB/s sustained.  We have nice 
TB sprints and similar sorts of "drag racing" as I call them (c.f. 
http://scalability.org/?p=2912 http://scalability.org/?p=2356 
http://scalability.org/?p=2165  http://scalability.org/?p=1980 
http://scalability.org/?p=1756 )

1 GB/s is nothing magical.  Again, not a commercial, but our DeltaV 
units, running MD raid, achieve 850-900MB/s (0.85-0.9 GB/s) for RAID6.

To get good (great) performance you have to start out with a good 
(great) design.  One that will really optimize the performance on a per 
unit basis.

> Few sites/applications actually need this kind of bandwidth, either
> burst or sustained.  But, this is the system I spec'd for the OP
> earlier.  Sometimes people get caught up in comparing raw bandwidth
> numbers between different platforms and lose sight of the real world
> performance they can get from any one of them.

The sad part is that we often wind up fighting against others "marketing 
numbers".  Our real benchmarks are often comparable to their "strong 
wind a the back" numbers.  Heck, our MD raid numbers often are better 
than others hardware RAID numbers.

Theoretical bandwidth from the marketing docs doesn't matter.  The only 
thing that does matter is having a sound design and implementation at 
all levels.  This is why we do what we do, and why we do use MD raid.

Regards,

Joe

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
