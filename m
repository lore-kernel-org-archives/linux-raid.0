From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: bad performance on RAID 5
Date: Thu, 18 Jan 2007 14:02:28 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0701181353310.8989@coffee.psychology.mcmaster.ca>
References: <45AE9640.1040500@start.no> <45AEA550.5070005@lucidpixels.com>
 <45AFBA3E.9070000@start.no>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45AFBA3E.9070000@start.no>
Sender: linux-raid-owner@vger.kernel.org
To: Sevrin Robstad <quackyo@start.no>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>> gives a speed at only about 5000K/sec , and HIGH load average :
>>> # uptime
>>> 20:03:55 up 8 days, 19:55,  1 user,  load average: 11.70, 4.04, 1.52

loadav is a bit misleading - it doesn't mean you had >11 runnable jobs.
you might just have more jobs waiting on IO, being starved by the 
IO done by resync.

>>>     Chunk Size : 256K

well, that's pretty big.  it means 6*256K is necessary to do a 
whole-stripe update; your stripe cache may be too small to be effective.

>> If they are on the PCI bus, that is about right, you probably should be 
>> getting 10-15MB/s, but it is about right.  If you had each drive on its own 
>> PCI-e controller, then you would get much faster speeds.

10-15 seems bizarrely low - one can certainly achieve >100 MB/s
over the PCI bus, so where does the factor of 6-10 come in?
seems like a R6 resync would do 4 reads and 2 writes for every
4 chunks of throughput (so should achieve more like 50 MB/s if 
the main limit is the bus at 100.)

> There are two controllers, 4 disks connected to one controller on the PCI-bus 
> and 2 disks connected to the other controller.

well, you should probably look at the PCI topology ("lspci -v -t"),
and perhaps even the PCI settings (as well as stripe cache size, 
perhaps nr_requests, etc)
