From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
 crashing repeatedly and hard)
Date: Tue, 04 Jan 2005 14:21:23 +0300
Message-ID: <41DA7C33.8090705@tls.msk.ru>
References: <200501032136.j03LaJ915438@www.watkins-home.com> <200501040115.36729.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501040115.36729.maarten@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

maarten wrote:
> On Monday 03 January 2005 22:36, Guy wrote:
> 
>>Maarten said:
>>"Doing the math, the outcome is still (200% divided by four)= 50%.
>>Ergo: the same as with a single disk.  No change."
>>
>>Guy said:
>>"I bet a non-mirror disk has similar risk as a RAID1."
>>
>>Guy and Maarten agree, but Maarten does a better job of explaining it!  :)
>>
>>I also agree with most of what Maarten said below, but not mirroring
>>swap???
> 
> 
> Yeah... bad choice in hindsight.  
> But, there once was a time, a long long time ago, that the software-raid howto 
> explicitly stated that running swap on raid was a bad idea, and that by 

In 2.2, and probably in early 2.4, there indeed was a prob with having
swap on raid (md) array.  "Random" system lockups, especially during
the array recovery.  That problem(s) has been fixed long ago.  But I
think the howto in question tells about something different...

> telling the kernel all swap partitions had the same priority, the kernel 
> itself would already 'raid' the swap, ie. divide equally between the swap 
> spaces. I'm sure you can read it back somewhere.

> Now we know better, and we realize that that will indeed loadbalance between 
> the various swap partitions, but it will not provide redundancy at all.  
> Oh well, new insights huh ? ;-)

...that is, the howto tells about raid0 setup (striping), and yes, there's
no "r" in "raid0" really (but there IS an "anti-r", as raid0 array is LESS
reliable than a single drive).  That to say: instead of placing swap on
raid0 array, let the swap code itself to perform the striping - swap code
"knows better" about its needs.  This is still applies to recent kernels.
But here, we aren't talking about *reilable* swap, we're talking about
*fast* swap (raid1 aka reliable vs raid0 aka fast).  There's no code in
"swap subsystem" to mirror swap space, but there IS such a code in md.
Hence, if you want reliability, use raid1 arrays for swap space.  In the
same time, if you want speed *too*, use multiple raid1 arrays with equal
priority as swap areas (dunno how current raid10 code compares to "swap
striping" on top of raid1 arrays, but that probably makes very small
difference).

Ie, nothing wrong with howto, which is talking about fast swap (sure it'd
be good to mention reliability too), and nothing wrong with having raid
arrays as swap (esp. when the abovementioned bug(s) has been fixed). Or,
"nothing new"... ;)

I learned to place swap to raid1 arrays instead of striping it (as suggested
by the howto) the hard way, going the full cycle recovering damaged data
because system got foobared after one component (stripe) of swapspace was
lost, and I don't want to repeat that recovery again. ;)

> Maarten

/mjt
