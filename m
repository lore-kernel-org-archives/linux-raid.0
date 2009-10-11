From: Asdo <asdo@shiftmail.org>
Subject: Re: [PATCH 0/3] md fixes for 2.6.32-rc
Date: Sun, 11 Oct 2009 14:16:57 +0200
Message-ID: <4AD1CCB9.3000301@shiftmail.org>
References: <20091002011747.24095.70355.stgit@dwillia2-linux.ch.intel.com>
 <19141.32211.742547.19481@notabene.brown>
 <1254875779.16798.10.camel@dwillia2-linux.ch.intel.com>
 <Pine.LNX.4.64.0910071141010.29237@diagnostix.dwd.de>
 <4ACCDEF3.5000804@shiftmail.org>
 <Pine.LNX.4.64.0910080840420.22913@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <Pine.LNX.4.64.0910080840420.22913@diagnostix.dwd.de>
Sender: linux-raid-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Holger Kiehl wrote:
> Its a dual cpu mainboard with two Xeon X5460 and 32 GiB Ram.
>
Nice machine...
Earlier intels though, with kinda slow RAM access (who knows if this has 
something to do...)
A few more observations:

>> also: stripe_cache_size current setting for your RAID
>> Raid level, number of disks, chunk size, filesystem...
> Raid level is Raid6 over 8 disks (actually 16, which are made up of 8
> HW Raid1 disks) and chunksize is 2048k. Here the output from /proc/mdstat
Ok the filesystem appears to be aligned then (I am assuming you are not 
using LVM, otherwise pls tell because there can be other tweaks)

I don't really know this multicore implementation, however here is one 
thing you could try:

The default stripe_cache_size might be too small for a multicore 
implementation, considering that there might be many more in-flight 
operations than with single-core (and even with single core it is 
beneficial to raise it).
What is the current value? (cat /sys/block/md4/md/stripe_cache_size)
You can try:
echo 32768 > /sys/block/md4/md/stripe_cache_size

You can also try to raise /sys/block/md4/md/nr_requests echoing a higher 
value in it, but this operation hangs up the kernel immediately on our 
machine with Ubuntu kernel 2.6.31 . This is actually a bug: Neil / Dan 
are you aware of this bug? Is it fixed in 2.6.32?

Secondly, it's surprising that it is slower than single core. How busy 
are the 8 cores you have, running on the MD threads (try htop) ? If you 
see all 8 cores maxed, it's one kind of implementation problem, if you 
see just 1-2 cores maxed, it's another kind...

Maybe stack traces can be used to see where the bottleneck is... I am 
not a profiling expert actually, but you might try this
cat /proc/12345/stack
replace 12345 with the kernel threads for md: you can probably see the 
PIDs with ps auxH | less or with htop (K option enabled)
catting the stack many times should see where they are stuck for most of 
the time

