From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: WD "RED" drives - are they any good for mdadm?
Date: Fri, 08 Feb 2013 19:05:01 -0500
Message-ID: <511592AD.6090209@tmr.com>
References: <50CF2112.1090406@gmail.com> <5115727E.9050601@tmr.com> <CACJz6QvUX12rJXrFhxg6FVO3e5qzO8t7UxM8+j=a2qhL215LeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACJz6QvUX12rJXrFhxg6FVO3e5qzO8t7UxM8+j=a2qhL215LeQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: maurice <mhilarius@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Drew wrote:
>> No, they're available big and cheap, but I confess that I don't see why a
>> drive series (red) is needed for NAS use, as opposed to cabled (eSATA)
>> connection. Not sure how the drive use would be different, but they are, as
>> noted, big and cheap.
> It makes sense to me at least.
>
> The big differentiators between the Red & Green/Blue series is
> ERC/TLER and the warranty terms. The drives come equipped with TLER
> set, which is helpful if you run RAID sets, the reasons for which this
> group is well versed in. The drives are also warrantied for 3yrs (as
> opposed to 2yrs) *and* specifically allow for use in enclosures of up
> to 4 bays. Apparently the Green & Blues aren't covered if use in
> enclosures.
That was my point, the requirements for NAS vs. an enclosure in a box on eSATA 
are essentially, run in an enclosure 7x24. Other than marketing the method of 
attaching the box of drives shouldn't matter to the drive. And they're cheaper 
than enterprise drives, which are mainly faster, an issue which really isn't 
going to matter a lot to SOHO users.
> I think at the end of the day the addition of Red's was market driven
> as a lot of people purchase these little home RAID boxes and find out
> the warrany on cheap drives doesn't cover that use, but at the same
> time, won't speend several hundred dollars *each* on enterprise
> drives.
>
> I personally have used a 4 pack of these hung off a LSI 9204 raid
> controller and performance is okay but not spectacular. That'd be
> because of the drives supposedly vary from 5400 to 7200 rpm depending
> on load. I treat them like 5400rpm drives and the benchmarks seem to
> bear that out. Good for bulk storage in home use, not so good for bulk
> storage in commercial use, except perhaps in 3rd or 4th tier storage
> where who cares how fast they are, what I call legal drives. (As in,
> we only keep them around for data the auditors & legal types may
> want.)
>
>
I would be interested to see if the performance really does get better with 
load, and how much load it takes. Maybe read a few TB off an array and measure 
the effective transfer rate every 10MB or so. Interesting project, I will 
probably try these the next time I need storage.

-- 
Bill Davidsen <davidsen@tmr.com>
   We are not out of the woods yet, but we know the direction and have
taken the first step. The steps are many, but finite in number, and if
we persevere we will reach our destination.  -me, 2010


