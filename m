From: Ric Wheeler <ric@emc.com>
Subject: Re: Accelerating Linux software raid
Date: Sat, 10 Sep 2005 22:06:21 -0400
Message-ID: <4323911D.8010307@emc.com>
References: <Pine.LNX.4.44.0509100927130.29141-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0509100927130.29141-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: Dan Williams <dan.j.williams@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Hahn wrote:

>>I think that the above holds for server applications, but there are lots 
>>of places where you will start to see a need for serious IO capabilities 
>>in low power, multi-core designs.  Think of your Tivo starting to store 
>>family photos - you don't want to bolt a server class box under your TV 
>>in order to get some reasonable data protection ;-)
>>    
>>
>
>I understand your point, but are the numbers right?  it seems to me that 
>the main factor in appliance design is power dissipation, and I'm guessing
>a budget of say 20W for the CPU.  these days, that's a pretty fast processor,
>of the mobile-athlon-64 range - probably 3 GB/s xor performance.  I'd 
>guess it amounts to perhaps 5-10% cpu overhead if the appliance were,
>for some reason, writing at 100 MB/s.  of course, it is NOT writing at 
>that rate (remember, reading doesn't require xors, and appliances probably
>do more reads than writes...)
>
>  
>
I think that one thing that your response shows is a small 
misunderstanding in what this class of part is.  It is not a TOE in the 
classic sense, rather a generally useful (non-standard) execution unit 
that can do some restricted set of operations well but is not intended 
to be used as a full second (or third or fourth) CPU.  If you get the 
code and design right, this will be a very simple driver calling 
functions that offload specific computations to these specialized 
execution units. 

If you look at public numbers for power for modern Intel architecture 
CPU's, say Tom's hardware at:

    http://www.tomshardware.com/cpu/20050525/pentium4-02.html

you will see that the 20W budget you allocate for a modern CPU is much 
closer to the power budget for these embedded parts than any modern 
cpu.   Mobile parts draw much less power than server CPUs and come 
somewhat closer to your number.

>>In the Centera group where I work, we have a linux based box that is 
>>used for archival storage.  Customers understand why the cost of a box 
>>is related to the number of disks, but the strength of the CPU, memory 
>>subsystem, etc are all more or less thought of as overhead (not to 
>>mention that nasty software stuff that I work on ;-)).
>>    
>>
>
>again, no offense meant, but I hear you saying "we under-designed the 
>centera host processor, and over-priced it, so that people are trying to 
>Stretch their budget by piling on too many disks".  I'm actually a little
>surprised, since I figured the Centera design would be a sane, modern,
>building-block-based one, where you could cheaply scale the number of 
>host processors, not just disks (like an old-fashioned, not-mourned SAN.)
>I see a lot of people using a high-performance network like IB as an internal
>backplane-like way to tie together a cluster-in-a-box.  (and I expect they'll
>sprint from IB to 10G real soon now.)
>  
>
These operations are not done only during ingest, they can be used to 
check the integrity of the already stored data, regenerate data, etc.  I 
don't want to hawk centera here, but we are definitely a scalable design 
using building blocks ;-)

What I tried to get across is the opposite of your summary, i.e. a 
customer who buys storage devices prefers to pay for storage capacity 
(media) instead of infrastructure used to provide storage and that they 
expect engineers to do the hard work to give them that storage at the 
best possible price.

We definitely use commodity hardware, we just try to get as much out of 
it as possible.

>but then again, you did say this was an archive box.  so what is the
>bandwidth of data coming in?  that's the number that sizes your host cpu.
>being able to do xor at 12 GB/s is kind of pointless if the server has just
>one or two 2 Gb net links... 
>  
>
Storage arrays like Centera are not block device, we do a lot more high 
level functions (real file systems, scrubbing, indexing, etc).  All of 
these functions require CPU, disk, etc, so anything that we can save can 
be used to provide added functionality.

>>Also keep in mind that the Xor done for simple RAID is not the whole 
>>story - think of compression offload, encryption, etc which might also 
>>be able to leverage a well thought out solution.
>>    
>>
>
>this is an excellent point, and one that argues *against* HW coprocessing.
>consider the NIC market: TOE never happened because adding tcp/ssl to a 
>separate card just moves the complexity and bugs from an easy-to-patch place 
>into a harder-to-patch place.  I'd much rather upgrade from a uni server to a
>dual and run the tcp/ssl in software than spend the same amount of money
>on a $2000 nic that runs its own OS.  my tcp stack bugs get fixed in a 
>few hours if I email netdev, but who knows how long bugs would linger in
>the firmware stack of a TOE card?
>  
>
Again, I think you misunderstand the part and the intention of the 
project and the part. Not everyone (much to our sorrow), wants a huge 
storage system - some people might be able to do with very small, quiet 
appliances for their archives.

>same thing here, except moreso.  making storage appliances smarter is great,
>but why put that smarts in some kind of opaque, inaccessible and hard-to-use
>coprocessor?  good, thoughtful design leads towards a loosely-coupled cluster
>of off-the-shelf components...
>
>regards, mark hahn.
>(I run a large supercomputing center, and spend a lot of effort specifying
>and using big compute and storage hardware...)
>
>  
>
I am an ex-Thinking Machines OS developer, who spent time working on the 
paragon OS at OSF and have a fair appreciation for large customers with 
deep wallets.  If everyone wanted to buy large installations built with 
high powered hardware, my life would be much easier ;-)

regards,

ric


