From: Jim Paris <jim@jtan.com>
Subject: Re: RAID-6: help wanted
Date: Fri, 29 Oct 2004 07:48:23 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041029114823.GA6431@jim.sh>
References: <cleqh6$ps4$1@terminus.zytor.com> <16764.37392.910080.718564@cse.unsw.edu.au> <20041025062026.GA17502@jim.sh> <16767.6168.695527.234379@cse.unsw.edu.au> <417F30C7.9050308@zytor.com> <20041027060018.GA17085@jim.sh> <418048C1.8030404@zytor.com> <20041028160003.GA3502@jim.sh> <4181313D.5050905@zytor.com> <16769.37446.970293.945527@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16769.37446.970293.945527@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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

3. Now lose the disk holding D1, so you need to reconstruct it from D2 and P.
   But you can't do that, because D2's value changes every time you read it!

-jim
