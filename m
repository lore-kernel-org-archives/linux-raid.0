From: Phil Turmel <philip@turmel.org>
Subject: Re: recovering failed raid5
Date: Fri, 28 Oct 2016 17:16:27 -0400
Message-ID: <b878efa4-2581-9284-90ca-170ece7219b5@turmel.org>
References: <CAM97BgQLPUN=t7VKHaVG-=SrJmS_tvaxGDbo3yqMwHm8B-do_Q@mail.gmail.com>
 <20161027160400.GA21042@metamorpher.de>
 <715b259f-1e56-9606-edc4-3e5c4d57744b@shenkin.org>
 <20161028133304.GA11564@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161028133304.GA11564@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>, Alexander Shenkin <al@shenkin.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good afternoon Alexander,

On 10/28/2016 09:33 AM, Andreas Klauer wrote:
> On Fri, Oct 28, 2016 at 01:22:31PM +0100, Alexander Shenkin wrote:
>> One remaining question: is sdc definitely toast?
> 
> In my opinion a drive is toast starting from the very first reallocated/ 
> pending/uncorrectable sector, your drive has several of those and that's 
> only the ones the drive already knows about - there may be more.

Actual vs. Pending relocations are very different things.  Andreas'
approach is rather expensive in practice, as manufacturers of
consumer-grade drives specify an error rate of less than 1 per 10^14
bits read.  That's only 12.5TB.  A moderately used media server will
encounter many of these in a four to five year life span.  Few at first,
then more as the drive ages.  If you insist on replacing drives at the
first "pending" relocation, expect to purchase many more drives than
everyone else.

Enterprise drives work the same way, BTW, just with a spec of 1 per
10^15 bits read.  Since enterprise drives are typically in constant
heavy use, a similar count in a normal lifespan is expected.

>> Or, is it possible that the Timeout Mismatch (as mentioned by Robin Hill; 
>> thanks Robin) is flagging the drive as failed, when something else is at 
>> play and perhaps the drive is actually fine?

Pending relocations are often just glitches that are gone after the
sector is rewritten.  if your drives have an error timeout that is
shorter than the OS device driver timeout, a raid array will silently
fix these errors for you and you'll never notice.  If your array is
lightly used, a weekly or monthly "check" scrub will help flush them out
in a timely fashion.

If you have green or desktop drive that has a long timeout (greater than
the 30-second default linux driver timeout), your array will crash when
your drives age just enough to pop up their first UREs.  Please read the
list archives linked in the wiki to help you understand how and why this
happens.

> I don't believe in timeout mismatches, either. The timeouts are generous. 
> Waiting for a disk to wake from standby is not a problem, and that takes 
> ages already. If a disk gets stuck even longer in error correction limbo 
> and it gets kicked because of it - IMHO that's the right call.

Alex, I strongly recommend you ignore Andreas' advice on this one topic.
 Use the work-arounds for the drives you have, and buy friendlier drives
as age and capacity increases demand.  { If your livelihood or marriage
depends on the security of the contents of your array, buy enterprise
drives and verify your backup system... }

[trim /]

> Your RAID did not fail because of timeouts or not. It's not important. 
> It failed because you didn't notice broken disks in time and you had two. 
> Testing, monitoring, actually acting on the first error, is important. 

Andreas' is flat-out wrong on this.  If you had the work-arounds in
place on your array, your pending errors would have been silently fixed
and your array would almost certainly never have failed.  With or
without SMART enabled.

Not that I recommend running without the SMART features -- you will
still want to know when your drives have real problems.

Phil
