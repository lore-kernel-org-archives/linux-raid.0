From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: recovering failed raid5
Date: Fri, 28 Oct 2016 15:33:04 +0200
Message-ID: <20161028133304.GA11564@metamorpher.de>
References: <CAM97BgQLPUN=t7VKHaVG-=SrJmS_tvaxGDbo3yqMwHm8B-do_Q@mail.gmail.com>
 <20161027160400.GA21042@metamorpher.de>
 <715b259f-1e56-9606-edc4-3e5c4d57744b@shenkin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <715b259f-1e56-9606-edc4-3e5c4d57744b@shenkin.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Oct 28, 2016 at 01:22:31PM +0100, Alexander Shenkin wrote:
> One remaining question: is sdc definitely toast?

In my opinion a drive is toast starting from the very first reallocated/ 
pending/uncorrectable sector, your drive has several of those and that's 
only the ones the drive already knows about - there may be more.

> Or, is it possible that the Timeout Mismatch (as mentioned by Robin Hill; 
> thanks Robin) is flagging the drive as failed, when something else is at 
> play and perhaps the drive is actually fine?

I don't believe in timeout mismatches, either. The timeouts are generous. 
Waiting for a disk to wake from standby is not a problem, and that takes 
ages already. If a disk gets stuck even longer in error correction limbo 
and it gets kicked because of it - IMHO that's the right call.

A disk that is unable to read its data, a disk that refuses to write data, 
a disk that needs help from the RAID layer to correct its errors, 
should be kicked because it's not able to pull its own weight.

You need drives that work without errors, without outside help, because 
during a rebuild, when the RAID is already degraded, there won't be any 
outside help. Either the disks work or your RAID is dead.

RAID redundancy is supposed to allow disks be replaced. (mdadm --replace)
If you use it instead to keep fixing errors on other disks, there is not 
any real redundancy left. In a RAID, if one of your disks has errors, 
you get rid of it as soon as possible.

Your RAID did not fail because of timeouts or not. It's not important. 
It failed because you didn't notice broken disks in time and you had two. 
Testing, monitoring, actually acting on the first error, is important. 

People have different opinions on this. Someone might argue.
It's up to you what risks to take.

Regards
Andreas Klauer
