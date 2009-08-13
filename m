From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: max number of devices in raid6 array
Date: Thu, 13 Aug 2009 04:52:01 +0200
Message-ID: <87zla44e9a.fsf@frosties.localdomain>
References: <20090812090600.GF21118@nfs-rbx.ovh.net>
	<55226.78.86.108.203.1250069920.squirrel@www.yuiop.co.uk>
	<20090812121911.GG21118@nfs-rbx.ovh.net>
	<87ab259j8m.fsf@frosties.localdomain>
	<60099.78.86.108.203.1250094780.squirrel@www.yuiop.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <60099.78.86.108.203.1250094780.squirrel@www.yuiop.co.uk> (John
	Robinson's message of "Wed, 12 Aug 2009 17:33:00 +0100 (BST)")
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, David Cure <lnk@cure.nom.fr>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"John Robinson" <john.robinson@anonymous.org.uk> writes:

> On Wed, 12 August, 2009 3:53 pm, Goswin von Brederlow wrote:
> [...]
>> And compute the overall MTBFS. With how many devices does the MTBFS of a
> raid6 drop below that of a single disk?
>
> First up, we probably want to be talking about Mean Time To Data Loss.
> It'll vary enormously depending on how fast you think you can replace dead
> drives, which in turn depends on how long a rebuild takes (since a dead
> drive doesn't count as having been replaced until the new drive is fully
> sync'ed). And building an array that big, it's going to be hard to get
> drives all from different batches.
>
> Anyway, someone asked Google a similar question:
> http://answers.google.com/answers/threadview/id/730165.html and the MTTDL
> for an 11-disc RAID-5 with 100,000-hour drives and a 24-hour
> replacement+rebuild turnaround was 3.8 million hours (433 years), and a
> RAID-6 was said to be "hundreds of times" more reliable. The 433 years
> figure will be assuming that one drive failure doesn't cause another one,
> though, so it's to be taken with a pinch of salt.
>
> Cheers,
>
> John.

I would take that with a verry large pinch of salt. From the little
experience I have that value doesn't reflects reality.

Unfortunately the MTBFS values for disks vendors give are pretty much
totaly dreamed up. So the 100,000-hours for a single drive already has
a huge uncertainty. Shouldn't affect the cut of point where the MTBFS
of tha raid is less than a single disk though.

Secondly disk failures in a raid are not unrelated. The disk all age
and most people don't rotate in new disk regulary. The chance of a
disk failure is not uniform over time.

On top of that the stress of rebuilding usualy greatly increases the
chances. And with large raids and todays large disks we are talking
days to weeks or rebuild time. As you said, the 433 years are assuming
that one drive failure doesn't cause another one to fail. In reality
that seems to be a real factor though.


If I understood the math in the URL right then the chance of a disk
failing within a week is:

168/100000 = 0.00168

The chance of 2 disks failing within a week with 25 disks would be:

(1-(1-168/100000)^25)^2 =  ~0.00169448195081717874

The chance of 3 disks failing within a week with 75 disks would be:

(1-(1-168/100000)^75)^3 =  ~0.00166310371815668874

So the cut off values are roughly 25 and 75 disks for raid 5/6. Right?


Now lets assume, and I'm totally guessing here, the failure is 4 times
more likely during a rebuild:

(1-(1-168/100000*4)^7)^2  = ~0.00212541503635
(1-(1-168/100000*4)^19)^3 = ~0.00173857193240
(1-(1-336/100000*4)^10)^3 = ~0.00202697761277 (two weeks rebuild time)

So cut off is 7 and 19 (10 for 2 week rebuild) disks. Or am I totaly
doing the wrong math?

MfG
        Goswin
