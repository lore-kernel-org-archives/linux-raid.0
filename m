From: David Brown <david.brown@hesbynett.no>
Subject: Re: [PATCH 1 of 2] MD RAID10:  Improve redundancy for 'far' and 'offset'
 algorithms
Date: Wed, 12 Dec 2012 22:59:40 +0100
Message-ID: <50C8FE4C.9000707@hesbynett.no>
References: <1355330705.26828.14.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1355330705.26828.14.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, agk@redhat.com
List-Id: linux-raid.ids

On 12/12/12 17:45, Jonathan Brassow wrote:
> MD RAID10:  Improve redundancy for 'far' and 'offset' algorithms
>
> The MD RAID10 'far' and 'offset' algorithms make copies of entire stripe
> widths - copying them to a different location on the same devices after
> shifting the stripe.  An example layout of each follows below:
>
> 	        "far" algorithm
> 	dev1 dev2 dev3 dev4 dev5 dev6
> 	==== ==== ==== ==== ==== ====
> 	 A    B    C    D    E    F
> 	 G    H    I    J    K    L
> 	            ...
> 	 F    A    B    C    D    E  --> Copy of stripe0, but shifted by 1
> 	 L    G    H    I    J    K
> 	            ...
>
> 		"offset" algorithm
> 	dev1 dev2 dev3 dev4 dev5 dev6
> 	==== ==== ==== ==== ==== ====
> 	 A    B    C    D    E    F
> 	 F    A    B    C    D    E  --> Copy of stripe0, but shifted by 1
> 	 G    H    I    J    K    L
> 	 L    G    H    I    J    K
> 	            ...
>
> Redundancy for these algorithms is gained by shifting the copied stripes
> a certain number of devices - in this case, 1.  This patch proposes the
> number of devices the copy be shifted by be changed from:
> 	device# + near_copies
> to
> 	device# + raid_disks/far_copies
>
> The above "far" algorithm example would now look like:
> 	        "far" algorithm
> 	dev1 dev2 dev3 dev4 dev5 dev6
> 	==== ==== ==== ==== ==== ====
> 	 A    B    C    D    E    F
> 	 G    H    I    J    K    L
> 	            ...
> 	 D    E    F    A    B    C  --> Copy of stripe0, but shifted by 3
> 	 J    K    L    G    H    I
> 	            ...
>
> This has the affect of improving the redundancy of the array.  We can
> always sustain at least one failure, but sometimes more than one can
> be handled.  In the first examples, the pairs of devices that CANNOT fail
> together are:
> 	(1,2) (2,3) (3,4) (4,5) (5,6) (1, 6) [40% of possible pairs]
> In the example where the copies are instead shifted by 3, the pairs of
> devices that cannot fail together are:
> 	(1,4) (2,5) (3,6)                    [20% of possible pairs]
>
> Performing shifting in this way produces more redundancy and works especially
> well when the number of devices is a multiple of the number of copies.
>
> We cannot simply replace the old algorithms, so the 17th bit of the 'layout'
> variable is used to indicate whether we use the old or new method of computing
> the shift.  (This is similar to the way the 16th bit indicates whether the
> "far" algorithm or the "offset" algorithm is being used.)
>

As far as I can see, this new layout will also improve the speed of 
small operations on the array.  With the original layout, if you want to 
blocks A, B and C, then you are writing once to disk 1 and 4, and twice 
to disks 2 and 3.  With the new layout, you are writing once to each 
disk - which is obviously going to be faster (especially for far 
layout).  It might not be a big effect, but it's a nice bonus.


