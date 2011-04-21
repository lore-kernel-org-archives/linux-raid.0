From: NeilBrown <neilb@suse.de>
Subject: Re: mismatch_cnt and Raid6
Date: Thu, 21 Apr 2011 23:14:19 +1000
Message-ID: <20110421231419.1caa2f1c@notabene.brown>
References: <4DB02A77.8000902@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DB02A77.8000902@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Falgout <andrew.falgout@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 21 Apr 2011 08:00:39 -0500 Andrew Falgout <andrew.falgout@gmail.com>
wrote:

> I got an error last week from a new raid6 array about a mismatch_cnt.  I 
> did some reading online, performed a repair action on the array, 
> performed a check action, and checked for the mismatch_cnt again.  The 
> number was greatly reduced, but it was still there.  According to mdadm, 
> everything appears to be working fine.  All the drives are passing short 
> tests on smartctl.
> 
> What is mismatch_cnt really?  Should I even be concerned about this? 

Yes, you should be concerned.
mismatch_cnt is a count of sectors where the parity blocks don't match the
data blocks.

The code doesn't check every sector individually.  For raid5/6 it checks 4K
at a time, so divide by 8, and that many 4K blocks are in doubt.

So something if going wrong somewhere.

I would run 'check' a few time and see if the number changes.
If it goes down at all, then it looks like you occasionally get bad reads
from a device.
If it only ever increases, then you are presumably getting bad writes
sometimes.

You could:
 - stop the array
 - run sha1sum on each member disk, several times.
 - if any one disk has an unstable result - check cabling, or replace the disk
 - if more than one disk has an unstable result, replace the controller maybe.
 - if all results are stable it must be a write-only problem - much harder
   to work with.

NeilBrown



> The array is giving me 25-30MB/sec performance on an sshfs mount over 
> the network.  With a local copy I can see speeds of 50 to 60MB/sec.
> 
> Thanks,
> Andrew Falgout
