From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
 crashing repeatedly and hard)
Date: Wed, 05 Jan 2005 19:22:04 +0300
Message-ID: <41DC142C.5000704@tls.msk.ru>
References: <Pine.LNX.3.96.1050105072829.9415A-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.3.96.1050105072829.9415A-100000@Maggie.Linux-Consulting.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alvin Oga wrote:
> On Wed, 5 Jan 2005, Guy wrote:
> 
>>I agree, but for a different reason.  Your reason is new to me.
> ...
>>Loosing the swap disk would kill the system.
> 
> if one is using swap space ... i'd add more memory .. before i'd use raid
> 	- swap is too slow and as you folks point out, it could die
> 	due to (unlikely) bad disk sectors in swap area

It isn't always practical.  You add as much memory as needed for
your "typical workload".  But there may be "spikes" of load with
that you have to deal somehow.  Adding more memory to cover that
"spikes" may be too expensive.

Also, if your "typical workload" requires eg 2Gb memory, adding
another, say, 2Gb to cover "spikes" means you have to reconfigure
the kernel to support large amount of memory, which also costs
something in terms of speed on i386 architecture.

Disks are *much* cheaper than ram in terms of money/Mb.

>>I don't want a down system due to a single disk failure.
> 
> that's what raid's for :-)
> 
>>I mirror everything, or RAID5.  Normally, no downtime due to disk failures.
> 
> the problem with mirror ( raid1 ).. or raid5 ...
> 	- if you have a bad diska ... all "bad data" will/could  also get
> 	copied to the good disk

Again: pretty PLEASE, stop talking about thouse mysterious "silent
corruption/errors".  Errors gets detected.  It is *very* unlikely
case when an error on disk (either unability to read, or reading
the "wrong" (aka not the same as has been written) data) will not
be detected during read, and if you do care about that cases, you
have to use some very different hardware with every component
(CPU, memory, buses, controllers etc etc) at least tripled, with
hardware-level online monitoring/comparing stuff to detect errors
at any level and to switch to another component if one is "lying".

> 	- "bad data" is hard to figure out in code ... to prevent it from
> 	getting copied ... how does it know with 100% certainty 

Nothing is 100% certain.. maybe except that we all will die sometime...

> 	- if you know why it's bad data,  it's lot easier to know which
> 	data is more correct than the bad one

Nothing is "more correct".  If the disk isn't working somehow, we know
this (as it reports errors) and kick it from the array.  If disk
"does not work silently", see above.

/mjt
