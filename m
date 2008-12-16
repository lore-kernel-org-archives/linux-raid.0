From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: detection/correction of corruption with raid6
Date: Tue, 16 Dec 2008 22:58:33 +0100
Message-ID: <1229464713.6159.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

while I do agree that the issue needs more in deep thinking,
I would like to tell a recent story that happened to me.

I was testing a RAID-6 array, with 7, small, HDs.
Intention was to get used to different situations, repair,
grow, fail, remove, etc.

After some playing, I started to check the files on the array
and I found out that they were not (always) correct.
So I started a check of the array, which returned some 1000 or
more mismatches.

After some investigation, I found out that one HD had a "flaky"
interface, data was correctly written, but sometimes, randomly,
reading returned some "wrong" bits (re-cabling solved the issue).

To check this with RAID-6, I could run the check with 6 disks,
for 7 times, each with a different disk removed, until one run
returned no mismatches.
At this point, I knew which "data path" was defective.

It would have saved a lot of time, if the check could have
done this automatically...

So, my RFE, would be, if possible, to try, during RAID-6 check,
to find out if and which HD has the mismatch.
Ideally, at the end of the check, the system log should show
how many mismatches, if any, are likely to belong to which HD
or are undetermined.
This would help to diagnose the full data path and reduce
testing time in case of problems.
In case only one HD results problematic, this one could be
failed, removed and the complete cabling, I/F and so on checked.
Of course, this goes beyond the simple "HD failure protection"
scope of RAID, nevertheless I do not see why this possibility
should be neglected, unless it is too complex/difficult to
implement and maintain.

Regarding the possibility of recovery, I have one question:

Why a RAID system might have inconsistencies?
Why do we have a "check" command at all, to run weekly or monthly?

Thanks,

bye,


-- 

piergiorgio sartor



