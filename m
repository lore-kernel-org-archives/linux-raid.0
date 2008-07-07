From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 12 Veliciraptors again w/x4 card (1.1gbytes/sec aggregate
 read)!
Date: Mon, 7 Jul 2008 15:40:10 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0807071539520.5574@p34.internal.lan>
References: <alpine.DEB.1.10.0807071424100.4694@p34.internal.lan> <alpine.DEB.1.10.0807071436080.5166@p34.internal.lan> <alpine.DEB.1.10.0807071442570.4709@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0807071442570.4709@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
Cc: Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids



On Mon, 7 Jul 2008, Justin Piszcz wrote:

>
>
> On Mon, 7 Jul 2008, Justin Piszcz wrote:
>
>> 
>> 
>> On Mon, 7 Jul 2008, Justin Piszcz wrote:
>> 
>>> Each PCI-e x1 card has 1 veliciraptor on it now.
>>> Got an x4 card wit 4 sata ports:
>>> 
>>> Not quite the > 1 gbyte/sec I was hoping for in regards to the reads
>>> but pretty close!
>> 
>> Going to remove one of the drives from the x1 card and put it on the x4
>> card instead, then I will use all 4 SATA ports on the x4 and hopefully get
>> better bw.
>> 
>
> Four drives on the x4 card, MAX bandwidth for every disk.
>
> p34:~# dd if=/dev/sdi of=/dev/null bs=1M &
> [1] 4720
> p34:~# dd if=/dev/sdj of=/dev/null bs=1M &
> [2] 4721
> p34:~# dd if=/dev/sdk of=/dev/null bs=1M &
> [3] 4722
> p34:~# dd if=/dev/sdl of=/dev/null bs=1M &
> [4] 4723
> p34:~#
>
> 120MiB/s per each one!
>
> Re-running dd test with all 12 disks:
>
> 1.1 gigabytes per second read!
>

bonnie++ benchmarks:

http://home.comcast.net/~jpiszcz/20080707/veliciraptors_with_x4.html

