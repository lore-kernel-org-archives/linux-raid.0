From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH 1 of 2] MD RAID10:  Improve redundancy for 'far' and 'offset' algorithms
Date: Thu, 13 Dec 2012 18:10:34 -0600
Message-ID: <FDA0427C-37FE-43AD-992A-C78E86CACDC7@redhat.com>
References: <1355330705.26828.14.camel@f16> <20121213122359.724138e2@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121213122359.724138e2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, agk@redhat.com
List-Id: linux-raid.ids


On Dec 12, 2012, at 7:23 PM, NeilBrown wrote:

>> 
>> This has the affect of improving the redundancy of the array.  We can
>> always sustain at least one failure, but sometimes more than one can
>> be handled.  In the first examples, the pairs of devices that CANNOT fail
>> together are:
>> 	(1,2) (2,3) (3,4) (4,5) (5,6) (1, 6) [40% of possible pairs]
>> In the example where the copies are instead shifted by 3, the pairs of
>> devices that cannot fail together are:
>> 	(1,4) (2,5) (3,6)                    [20% of possible pairs]
>> 
>> Performing shifting in this way produces more redundancy and works especially
>> well when the number of devices is a multiple of the number of copies.
> 
> Unfortunately it doesn't bring any benefit (I think) when the number of
> devices is not a multiple of the number of copies.  And if we are going to
> make a change, we should do the best we can.
> 
> An approach that has previously been suggested is to divide the devices up
> into set which are ncopies in size or (for the last set) a little more and
> and rotate within those sets.
> So with 5 devices and two copies there are 2 sets, one of 2, one of 3.
> 
>  A  B  C  D  E
>  B  A  D  E  C
> 
> The  only pairs where we cannot survive failure of both are pairs that are in
> the same set.  This is as good as your scheme when raid_disks divides copies,
> but better when it doesn't.
> 
> So unless there is a good reason not to, I would rather we go with the scheme
> that gives the best in all cases.

I think I've got something now that works like this.  I've got to test and re-document.  I'll repost tomorrow or the day after.

 brassow

