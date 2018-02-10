From: "John Stoffel" <john@stoffel.org>
Subject: Re: RFC - de-clustered raid 60 or 61 algorithm
Date: Fri, 9 Feb 2018 22:02:59 -0500
Message-ID: <23166.24803.938402.52328@quad.stoffel.home>
References: <9f9e737c-d6d1-5cce-8190-14d970320265@youngman.org.uk>
        <876078maui.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <876078maui.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Wol's lists <antlists@youngman.org.uk>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "NeilBrown" == NeilBrown  <neilb@suse.com> writes:

NeilBrown> On Thu, Feb 08 2018, Wol's lists wrote:
>> After the de-clustered thread, Neil said it would probably only take a 
>> small amount of coding to do something like that. It was also discussed 
>> about spreading the load over disks on a reconstruction if there were a 
>> lot of disks in an array. I've been trying to get my head round a simple 
>> algorithm to smear data over the disks along the lines of raid-10.
>> 
>> Basically, the idea is to define a logical stripe which is a multiple of 
>> both the number of physical disks, and of the number of logical disks. 
>> Within this logical stripe the blocks are shuffled using prime numbers 
>> to make sure we don't get a pathological shuffle.
>> 
>> At present, I've defined the logical stripe to be simply the product of 
>> the number of logical disks times the number of mirrors times the number 
>> of physical disks. We could shrink this by removing common factors, but 
>> we don't need to.
>> 
>> Given a logical block within this stripe, its physical position is 
>> calculated by the simple equation "logical block * prime mod logical 
>> stripe size". So long as the "prime" does not share any factors with the 
>> logical stripe size, then (with one exception) you're not going to get 
>> hash collisions, and you're not going to get more than one block per 
>> stripe stored on each drive. The exception, of course, is if physical 
>> disks is not greater than logical disks. Having the two identical is 
>> especially dangerous as users will not expect the pathological behaviour 
>> they will get - multiple blocks per stripe stored on the same disk. 
>> mdadm will need to detect and reject this layout. I think the best 
>> behaviour will be found where logical disks, mirrors, and physical disks 
>> don't share any prime factors.
>> 
>> I've been playing with a mirror setup, and if we have two mirrors, we 
>> can rebuild any failed disk by coping from two other drives. I think 
>> also (I haven't looked at it) that you could do a fast rebuild without 
>> impacting other users of the system too much provided you don't swamp 
>> i/o bandwidth, as half of the requests for data on the three drives 
>> being used for rebuilding could actually be satisfied from other drives.

NeilBrown> I think that ends up being much the same result as a current raid10
NeilBrown> where the number of copies doesn't divide the number of devices.
NeilBrown> Reconstruction reads come from 2 different devices, and half the reads
NeilBrown> that would go to them now go elsewhere.

NeilBrown> I think that if you take your solution and a selection of different
NeilBrown> "prime" number and rotate through the primes from stripe to stripe, you
NeilBrown> can expect a more even distribution of load.

NeilBrown> You hint at this below when you suggest that adding the "*prime" doesn't
NeilBrown> add much.  I think it adds a lot more when you start rotating the primes
NeilBrown> across the stripes.

>> 
>> Rebuilding a striped raid such as a raid-60 also looks like it would 
>> spread the load.
>> 
>> The one thing that bothers me is that I don't know whether the "* prime 
>> mod" logic actually adds very much - whether we can just stripe stuff 
>> across like we do with raid-10. Where it will score is in a storage 
>> assembly that is a cluster of a cluster of disks. Say you have a 
>> controller with ten disks, and ten controllers in a rack, a suitable 
>> choice of prime and logical stripe could ensure the rack would survive 
>> losing a controller. And given that dealing with massive arrays is what 
>> this algorithm is about, that seems worthwhile.

NeilBrown> The case of multiple failures is my major concern with the whole idea.
NeilBrown> If failures were truly independent, then losing 3 in 100 at the same
NeilBrown> time is probably quite unlikely.  But we all know there are various
NeilBrown> factors that can cause failures to correlate - controller failure being
NeilBrown> just one of them.
NeilBrown> Maybe if you have dual-attached fibre channel to each drive, and you get
NeilBrown> the gold-plated drives that have actually been exhaustively tested....

NeilBrown> What do large installations do?  I assumed they had lots of modest
NeilBrown> raid5 arrays and then mirrored between pairs of those (for data they
NeilBrown> actually care about).  Maybe I'm wrong.

Well, I can only really speak to how Netapp does it, but they have
what is called RAID-DP (Dual Parity) but they also build up data in
Aggregates, which is composed of one or more Raid-Groups.  Each raid
group has 2 parity and X data drives, usually around 14-16 drives.

The idea being that for large setups, you try to put each member of
the raid group on a seperate shelf (shelves generally have 24 or 48
drives now, in olded times they had... ummm 12 or 16?  I forget off
the top of my head).

Part of the idea would be that if you lost and entire shelf of disks,
you wouldn't lose all your raidgroups/aggregates.

And yes, if you lost a raidgroup, you lost the aggregate.

So paying attention to and planning for disk failures in large numbers
of disks is a big part of Netapp, even with dual ported SAS links to
shelves, and dual paths to SAS/SATA drives in those shelves.

I would be honestly scared to have 100 disks holding my data with only
two parity disks.   Losing three disks just kills you dead, and it's
going to happen.

For example, you can goto 45drives.com and buy a system with 60 drives
in it, using LSI controllers and (I think) expander cards.  Building a
reliable system to handle the failure of a single controller is key
here.  And I think you can add more controllers, so you reduce your
number of expander ports, which improves (hopefully!) reliability.

It's all a tradeoff.

What I would do is run some simulations where you setup 100 disks with
X number of them parity, and the simulate failure rates.  Then include
the controllers in that simulation and see how likely you are to lose
all your data before you can rebuild.  It's not an easy problem space
at all.

John
