From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Use of WD20EARS with MDADM
Date: Wed, 21 Apr 2010 11:14:04 -0400
Message-ID: <4BCF163C.6040604@cfl.rr.com>
References: <4BAB8D41.4010801@gmail.com> <F50E50EC-32CF-4FC4-949B-E8DA56B08D50@santools.com> <4BABA12D.6040605@shiftmail.org> <4BAF8185.9040307@gmx.net> <4BC61D47.6090403@tmr.com> <4BCC65EB.3080803@cfl.rr.com> <4BCEFB99.9080806@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BCEFB99.9080806@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: st0ff@npl.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/21/2010 9:20 AM, Bill Davidsen wrote:
> I hear this said, but I don't have any data to back it up. Drive vendors
> aren't stupid, so if the parking feature is likely to cause premature
> failures under warranty, I would expect that the feature would not be
> there, or that the drive would be made more robust. Maybe I have too
> much faith in greed as a design goal, but I have to wonder if load
> cycles are as destructive as seems to be the assumption.

Indeed, I think you have too much faith in people doing sensible things.
 Especially when their average customer isn't placing the drive in a
high use environment and they know it, and suggest against doing so.

> I'd love to find some real data, anecdotal stories about older drives
> are not overly helpful. Clearly there is a trade-off between energy
> saving, response, and durability, I just don't have any data from a
> large population of new (green) drives.

I've not seen any anecdotal stories, but I have seen plenty of reports
with real data showing a large number of head unloads from the SMART
data after a relatively short period of use.  Personally mine has a few
hundred so far and I have not even used it for real storage yet, only
testing.  The specifications say it's good for 300,000 cycles, so do the
math... getting 5 unloads per minute would lead to probable failure
after 41 days.  Granted that is about worst case, but still something to
watch out for.  In order to make it the entire 3 year warranty period,
you need to stay under 11.4 unloads per hour.  If you have very little
IO activity, or VERY MUCH, then this is entirely possible, but more
moderate loads in the middle have been observed to cause hundreds of
unloads per hour.

Given that, and the fact that WD themselves have stated that you should
not use these drives in a raid array, I'd either stay away, or watch out
for this problem and try to take action to avoid and monitor it.

