From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: raid10 far layout outperforms offset at writing? (was: Help with chunksize on raid10 -p o3 array)
Date: Wed, 17 Dec 2008 13:41:54 +0100
Message-ID: <20081217124154.GA5406@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I found this old message:

> Peter Rabbitson
> Mon, 19 Mar 2007 06:14:38 -0800
> 
> Peter Rabbitson wrote:
> 
>     I have been trying to figure out the best chunk size for raid10
> before migrating my server to it (currently raid1). I am looking at 3
> offset stripes, as I want to have two drive failure redundancy, and
> offset striping is said to have the best write performance, with read
> performance equal to far. 
> 
> Incorporating suggestions from previous posts (thank you everyone), I
> used this modified script at http://rabbit.us/pool/misc/raid_test2.txt
> To negate effects of caching memory was jammed below 200mb free by using
> a full tmpfs mount with no swap. Here is what I got with far layout (-p
> f3): http://rabbit.us/pool/misc/raid_far.html The clear winner is 1M
> chunks, and is very consistent at any block size. I was surprised even
> more to see that my read speed was identical to that of a raid0 getting
> near the _maximum_ physical speed of 4 drives (roughly 55MB sustained
> across 1.2G). Unlike offset layout, far really shines at reading stuff
> back. The write speed did not suffer noticeably compared to offset
> striping. Here are the results (-p o3) for comparison:
> http://rabbit.us/pool/misc/raid_offset.html, and they roughly seem to
> correlate with my earlier testing using dd.
> 
> So I guess the way to go for this system will be f3, although the md(4)
> says that offset layout should be more beneficial. Is there anything I
> missed while setting my o3 array, so that I got worse performance for
> both read and write compared to f3?
> 
> Once again thanks everyone for the help.
> Peter

The links were not valid anymore. I wanted to see the results and 
possibly include the results in the performance wiki page
I would appreciate some new links here.

Furthermore some comments to the post: My take on o3 vs f3 is that both
in theory and practice f3 should be much faster for sequential reading,
as the layout is equivalent to raid0. For random reading and sequential
and random writing f3 and o3 (and the same goes for the more normal f2
vs o2) should be about the same, especially when a filesystem and
its associated elevator algorithm is employed.

Best regards
keld
