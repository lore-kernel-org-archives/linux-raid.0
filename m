From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: RAID-6: help wanted
Date: Fri, 29 Oct 2004 08:56:13 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410291256.i9TCuIN13270@www.watkins-home.com>
References: <20041029114823.GA6431@jim.sh>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041029114823.GA6431@jim.sh>
To: 'Jim Paris' <jim@jtan.com>, 'Neil Brown' <neilb@cse.unsw.edu.au>
Cc: "'H. Peter Anvin'" <hpa@zytor.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I should read the messages in reverse order!
I just posted a similar email, but I could not think of a good example, or a
bad example. :)

As you said (in my words):
RAID5 on top of RAID1 arrays would be bad if the RAID1 arrays were not
synced and one RAID1 array was to fail.

You also said:
"3. Now lose the disk holding D1, so you need to reconstruct it from D2 and
P."

But loosing D1 would require 2 disk failures since a single disk failure
would not take a RAID1 array offline.  But other things can fail that could
cause the array to go offline.  So your point is still valid.

But it does not require any failures to corrupt data.  Using your example,
once the RAID5 array is synced, if you were to modify a block the old block
and the parity would be read, then the new parity would be computed based on
the old block and the new block, then both block written.  You never know
which disk a RAID1 array will read from.  Since the RAID1 was never synced
you can get different data on the read of the old data which will cause the
new parity to be wrong.

1. Do an initial resync of the raid5 so that D1 + D2 = P.

2. Write a real value to D1, and update P.
   Since this requires a read from D1 you don't know which disk will be
   used, if a different disk is used than the one used during the initial
   sync it will corrupt P.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Jim Paris
Sent: Friday, October 29, 2004 7:48 AM
To: Neil Brown
Cc: H. Peter Anvin; linux-raid@vger.kernel.org
Subject: Re: RAID-6: help wanted

> I have a patch to mdadm to make it resync when there is one failure,
> but I'm no longer convinced that it is needed.
> In fact, the initial resync isn't really needed for raid6 (or raid1)
> at all.

I see.  I figured raid6 should just behave the same as raid5, but
didn't realize that raid5 only did it because of the read-modify-write.

However, I do still think that the data should always be synchronized.
Just because it's holding completely meaningless values at the moment
doesn't mean it should change each time you read it (which can easily
happen if the data gets read from different disks).  Other things
might eventually depend on the "meaningless" value.

Consider running raid5 on top of unsynced raid1 devices /dev/md[012]:

1. Do an initial resync of the raid5 so that D1 + D2 = P.

2. Write a real value to D1, and update P.
   At this point, D1 and P are synced between disks of their raid1s,
   since they have been written.

3. Now lose the disk holding D1, so you need to reconstruct it from D2 and
P.
   But you can't do that, because D2's value changes every time you read it!

-jim
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

