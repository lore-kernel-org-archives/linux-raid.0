From: Brad Campbell <brad@wasp.net.au>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
 crashing repeatedly and hard)
Date: Wed, 05 Jan 2005 17:33:32 +0400
Message-ID: <41DBECAC.7040408@wasp.net.au>
References: <Pine.LNX.3.96.1050105051955.9045B-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.3.96.1050105051955.9045B-100000@Maggie.Linux-Consulting.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alvin Oga <aoga@ns.Linux-Consulting.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alvin Oga wrote:
> 
> On Wed, 5 Jan 2005, Brad Campbell wrote:
> 
> 
>>Picture lpd gets swapped out on a friday night. Over the weekend it is not used and the drive 
>>develops a bad sector in the middle of the file. Monday morning I want to print and the system tries 
>>to page lpd back in again. *boom*.
> 
> 
> admin issue ... user related services like printers should NOT be on
> critical servers and take down what everybody will notice due to unrelated
> printer problems

Ok, perhaps bad example. Pick any service that may get swapped out. Hell.. any bad block in any swap 
space that develops while that block is in use is going to cause a problem.

> swap ...  swap partitions is by default checked for bad blocks during
> formatting as swap ...
> 	- it is highly unlikely that you'd get a bad sector in swap space

Yeah? I have 3 hard disks sitting on my desk that say you are wrong..

> 
> - any normal bad things happening to user area of the disks will also
>   happen to swap space

I agree.

>  	- but its unlikely that swap will have bad blocks, while its 
> 	more likely that users did nto do a badblock check during
> 	formatting across the 100GB or 300GB disks ... and even more
> 	time twiddling your thumbs on raid'd disks

I strongly disagree.
I have a 250GB drive I just swapped out that was "growing" bad sectors at the rate of 3 per day that 
did a clean badblocks 5 months ago when it was installed.

I refuse to argue this any more. If you want to tell the world that there is no benefit to swap on 
raid, go ahead.

Brad
