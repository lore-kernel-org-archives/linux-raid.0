From: Avi Kivity <avi@scylladb.com>
Subject: Re: raid0 vs. mkfs
Date: Wed, 30 Nov 2016 00:45:10 +0200
Message-ID: <33bb250a-4dfd-0acc-9958-30fdac10918c@scylladb.com>
References: <56c83c4e-d451-07e5-88e2-40b085d8681c@scylladb.com>
 <87oa108a1x.fsf@notabene.neil.brown.name>
 <286a5fc1-eda3-0421-a88e-b03c09403259@scylladb.com>
 <87inr880au.fsf@notabene.neil.brown.name>
 <df73ebc4-9b78-09b5-022b-089c30dea17c@scylladb.com>
 <87d1he7zv9.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d1he7zv9.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/29/2016 11:14 PM, NeilBrown wrote:
> On Mon, Nov 28 2016, Avi Kivity wrote:
>>> If it is easy for the upper layer to break a very large request into a
>>> few very large requests, then I wouldn't necessarily object.
>> I can't see why it would be hard.  It's simple arithmetic.
> That is easy to say before writing the code :-)
> It probably is easy for RAID0.  Less so for RAID10.  Even less for
> RAID6.
>

pick the largest subrange wihin the inpu range whose bounds are 0 (mod 
stripe-size); TRIM it (for all members); apply the regular algorithm to 
the head and tail subranges.  Works for all RAID types.  If the RAID is 
undergoing reshaping, exclude the range undergoing reshaping, and treat 
the two halves separately.

>>> But unless it is very hard for the lower layer to merge requests, it
>>> should be doing that too.
>> Merging has tradeoffs.  When you merge requests R1, R2, ... Rn you make
>> the latency request R1 sum of the latencies of R1..Rn.  You may gain
>> some efficiency in the process, but that's not going to make up for a
>> factor of n.  The queuing layer has no way to tell whether the caller is
>> interested in the latency of individual requests.  By sending large
>> requests, the caller indicates it's not interested in the latency of
>> individual subranges.  The queuing layer is still free to internally
>> split the request to smaller ranges, to satisfy hardware constraints, or
>> to reduce worst-case latencies for competing request streams.
> I would have thought that using plug/unplug to group requests is a
> fairly strong statement that they can be handled as a unit if that is
> convenient.

It is not.  As an example, consider a read and a few associated 
read-ahead requests submitted in a batch.  The last thing you want is 
for them to be treated as a unit.

Plug/unplug means: I have a bunch of requests here.  Whether they should 
be merged or reordered is orthogonal to whether they are members of a 
batch or not.

>
>
>> So I disagree that all the work should be pushed to the merging layer.
>> It has less information to work with, so the fewer decisions it has to
>> make, the better.
> I think that the merging layer should be as efficient as it reasonably
> can be, and particularly should take into account plugging.  This
> benefits all callers.

Yes, but plugging does not mean "please merge anything you can until the 
unplug".

> If it can be demonstrated that changes to some of the upper layers bring
> further improvements with acceptable costs, then certainly it is good to
> have those too.

Generating millions of requests only to merge them again is 
inefficient.  It happens in an edge case (TRIM of the entirety of a very 
large RAID), but it already caused on user to believe the system 
failed.  I think the system should be more robust than that.

> NeilBrown


