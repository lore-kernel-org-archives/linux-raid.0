From: Peter Rabbitson <rabbit@rabbit.us>
Subject: raid10 far layout outperforms offset at writing? (was: Help with
 chunksize on raid10 -p o3 array)
Date: Mon, 19 Mar 2007 15:14:25 +0100
Message-ID: <45FE9AC1.4070200@rabbit.us>
References: <45ED4FE1.5020105@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45ED4FE1.5020105@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:
> I have been trying to figure out the best chunk size for raid10 before 
> migrating my server to it (currently raid1). I am looking at 3 offset 
> stripes, as I want to have two drive failure redundancy, and offset 
> striping is said to have the best write performance, with read 
> performance equal to far.

Incorporating suggestions from previous posts (thank you everyone), I 
used this modified script at http://rabbit.us/pool/misc/raid_test2.txt 
To negate effects of caching memory was jammed below 200mb free by using 
a full tmpfs mount with no swap. Here is what I got with far layout (-p 
f3): http://rabbit.us/pool/misc/raid_far.html The clear winner is 1M 
chunks, and is very consistent at any block size. I was surprised even 
more to see that my read speed was identical to that of a raid0 getting 
near the _maximum_ physical speed of 4 drives (roughly 55MB sustained 
across 1.2G). Unlike offset layout, far really shines at reading stuff 
back. The write speed did not suffer noticeably compared to offset 
striping. Here are the results (-p o3) for comparison: 
http://rabbit.us/pool/misc/raid_offset.html, and they roughly seem to 
correlate with my earlier testing using dd.

So I guess the way to go for this system will be f3, although the md(4) 
says that offset layout should be more beneficial. Is there anything I 
missed while setting my o3 array, so that I got worse performance for 
both read and write compared to f3?

Once again thanks everyone for the help.
Peter
