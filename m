From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Spares and partitioning huge disks
Date: Thu, 13 Jan 2005 15:40:07 -0500
Message-ID: <200501132038.j0DKcB905895@www.watkins-home.com>
References: <u0nib2-4i2.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <u0nib2-4i2.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "'Peter T. Breuer'" <ptb@lab.it.uc3m.es>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Maybe you missed my post from yesterday.
http://marc.theaimsgroup.com/?l=linux-raid&m=110559211400459&w=2

No superblock was to prevent overwriting data on the failing component of
the top RAID5 array.  If you build the top array with degraded RAID1 arrays,
then use a super block for the RAID1 arrays.

Also, so all of the RAID1 arrays don't seem degraded, configure them with
only 1 device.  Grow them to 2 devices when needed.  Then shrink them back
to 1 when done.

The RAID1 idea will not work since a bad block will take out the RAID1.  But
there are more issues, see the above URL.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Peter T. Breuer
Sent: Thursday, January 13, 2005 12:17 PM
To: linux-raid@vger.kernel.org
Subject: Re: Spares and partitioning huge disks

Guy <bugzilla@watkins-home.com> wrote:
> Peter said:
> "Well, I don't see where there's any window in which its degraded."
> 
> These are the steps that cause the window (see "Original Message" for full
> details):
> 
> 1. fail out the chosen drive. (array is now degraded)

I would suggest "don't do that then".  Start with an array of degraded
RAID1s, as I suggested, and add in an extra disk to one of the raid1s,
wait till it syncs, then remove the original component.  Instant new
(degraded) RAID1 in the place of the old, and the array above none the
wiser.

> 2. combine it with the spare in a raid1 with no superblock (re-synce
starts)

Why "no superblock"? Oh well - let's leave it as a mystery.

> 3. add this raid1 back into the main array. (The main array is now in-sync
> other than any changes that occurred since you failed the disk in step 1)

Well, if you have an array of arrays it seems that the main array must
have been degraded too, but I don't see where you took the subarray out
of it in the sequence above (in order to add it back in now).

The problem pointed out is that if the disk you are going to swap out is
faulty, there's no way of copying from it perfectly. The read patch I
posted a few days ago will help, but it won't paper over real sector
errors - it may allow the copy to processd, however (I'll have to check 
what happens during a sync).

So one has to substitute using data from the redundant parts of the
array above (in the array-of-arrays solution). But there's no
communication at present :(.

Well, 

  1) if one were to use bitmaps, I would suggest that in the case of an
     array of arrays that the bitmap be shared between an array and its
     subarrays - do we really care in which disk a problem is? No - we
     know we just have to try and find some good data and correct a
     problem in that block and we can go searching for the details if  
     and when we need.

  2) I don't see any problem in, even without a bitmap, simply augmenting
     the repair strategy (which you people don't have yet, heh) for
     read errors to including getting the data from the array above if
     we are in a subarray, not just using our own redundancy.

Peter

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

