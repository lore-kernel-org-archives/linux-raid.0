From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid check didn't fix Current_Pending_Sector, but badblocks -nsv
 did
Date: Wed, 8 Jun 2016 08:24:00 -0400
Message-ID: <57580E60.3040104@turmel.org>
References: <20160606174113.GI12382@merlins.org> <5755CA9F.6090807@prgmr.com>
 <20160606224401.GA6672@merlins.org> <57561B38.1070402@turmel.org>
 <20160607045122.GL12382@merlins.org> <5756C67A.2040109@turmel.org>
 <2c7e843f-58a9-a9f0-76bf-ff193935d13b@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2c7e843f-58a9-a9f0-76bf-ff193935d13b@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>, Marc MERLIN <marc@merlins.org>
Cc: Sarah Newman <srn@prgmr.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/07/2016 09:39 PM, Brad Campbell wrote:
> On 07/06/16 21:04, Phil Turmel wrote:
>> On 06/07/2016 12:51 AM, Marc MERLIN wrote:
> 
>>> Right, I understand now, good to know.
>>> So I'll use badblocks next time I have this issue.
>>
>> Or just ignore them.  You aren't using them, so they can't hurt you.
> 
> That's actually not necessarily true.
> 
> If you have a dud sector early on the disk (so before the start of the
> RAID data) you will terminate every SMART long test in the first couple
> of meg of the disk. So while a dud down there won't necessarily impact
> your usage from a RAID perspective, it'll knacker your ability to
> regularly check the disks in their entirety. SMART tests abort on the
> first bad read.

Don't bother doing long self-tests on drives participating in an array
-- check scrubs do everything a long self-test does on the area of
interest, plus actually fixing UREs that are found.  And check scrubs
don't abort on a read failure.

My advice stands: ignore the UREs in unused areas of the disk.

> It's ugly, but in the single instance I had that happen, I removed the
> drive from the array, wrote zero to the entire disk and then added it
> back. That forced a reallocation in the affected area.

Completely pointless exercise that opened a window of higher-risk of
failure of your array.  Unless you used --replace with another spare to
maintain redundancy on your array while that disk was out.

> Usually if it is in the RAID zone, a check scrub will clear it up.
> Having said that I've had a very peculiar one here in the last couple of
> days.
> 
> A WD 2TB Green drive with TLER set to 7 seconds. The first read would
> error out in 7 seconds (as it should), but a second read succeeded.
> After returning the error, the drive must have kept trying to recover in
> the background and eventually succeeded and cached the result. So
> subsequent reads were ok. After reading and writing enough to other
> parts of the drive to flush the drives cache, the process would repeat.

Pure speculation.  Unless you can show better evidence that those drives
will cache a read in that case, I would say it was just a mild enough
weak spot that it randomly succeeded more than not.  And if you follow
my advice, it doesn't matter:  if the array is the only process reading
from the disk, the first appearance of the URE would be the last, as the
array would re-write it immediately.  Whether during a scrub or due to
normal access.

Regular long self-tests are highly recommended for stand-alone disks and
for array hot spares.

Phil
