From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: RAID-6: help wanted
Date: Fri, 29 Oct 2004 08:29:01 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410291229.i9TCT6N13193@www.watkins-home.com>
References: <16769.37446.970293.945527@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16769.37446.970293.945527@cse.unsw.edu.au>
To: 'Neil Brown' <neilb@cse.unsw.edu.au>, "'H. Peter Anvin'" <hpa@zytor.com>
Cc: 'Jim Paris' <jim@jtan.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,
You said:
"the initial resync isn't really needed for raid6 (or raid1)
at all"

I understand your logic, but, I would prefer the data to be synced.  I can't
think of any examples of how it could make a difference, but if I read block
x, then ten minutes later I read the same block again, I want it to be the
same unless I changed it.  With RAID1 you never know which disk will be
read, RAID6 would only change if a disk failed.  If you insist to add this
feature, please make it an option that defaults to sync everything.  This
way someone that knows what they are doing can use the option, others will
get the safer (IMHO) default.

I also want an integrity checker that does not require the array to be
stopped. :)

I know you did not write the RAID6 code, but:
You say RAID6 requires 100% of the stripe to be read to modify the strip.
Is this due to the math of RAID6, or was it done this way because it was
easier?  When doing random disk writes, any idea how this effects the
performance of RAID6 compared to RAID5?  Does the performance of RAID6 get
worse as the number of disks is increased?  Until now, I assumed a disk
write would require read, read, read, modify, write, write, write.  Compared
to RAID5 with read, read, modify, write, write (for small updates).

Thanks for your time,
Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Neil Brown
Sent: Thursday, October 28, 2004 8:44 PM
To: H. Peter Anvin
Cc: Jim Paris; linux-raid@vger.kernel.org
Subject: Re: RAID-6: help wanted

On Thursday October 28, hpa@zytor.com wrote:
> Jim Paris wrote:
> > 
> > Another issue:  If I create a 6-disk RAID-6 array ...
> > 
> > ... with 2 missing, no resync happens.
> > ... with 1 missing, no resync happens.  (???)
> > ... with 0 missing, resync happens.
> > ... with 2 missing, then add 1, recovery happens.
> > ... with 0 missing, then fail 1, resync continues.
> > 
> > Shouldn't resync happen in the created-with-1-disk-missing case?
> > 
> 
> Nevermind, I guess it probably should, since there is still redundancy 
> and therefore it can be inconsistent.
> 
> 	-hpa

I have a patch to mdadm to make it resync when there is one failure,
but I'm no longer convinced that it is needed.
In fact, the initial resync isn't really needed for raid6 (or raid1)
at all.  The first write to any stripe will make the redundancy for
that stripe correct regardless of what it was, and before the first
write, the content of the array is meaningless anyway.

Note that this is different to raid5 which, if using a
read-modify-write cycle, depends on the parity block being correct.

There would be an issue once we start doing background scans of the
arrays as the first scan could find lots of errors.  But maybe that
isn't a problem....

I'll probably include the patch in the next mdadm release, and revisit
the whole idea when (if) I implement background array scans.

NeilBrown
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

