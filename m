From: Brad Campbell <brad@wasp.net.au>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
 crashing repeatedly and hard)
Date: Wed, 05 Jan 2005 16:02:09 +0400
Message-ID: <41DBD741.4070000@wasp.net.au>
References: <Pine.LNX.3.96.1050105033448.27450A-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.3.96.1050105033448.27450A-100000@Maggie.Linux-Consulting.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alvin Oga <aoga@ns.Linux-Consulting.com>
Cc: Andy Smith <andy@strugglers.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alvin Oga wrote:
> 
> hi ya brad
> 
> On Wed, 5 Jan 2005, Brad Campbell wrote:
> 
> 
>>Alvin Oga wrote:
>>
>>>	for swap ... i personally don't see any reason to mirror
>>>	swap partitions ...
>>>		- once the system dies, ( power off ), all temp
>>>		data is useless unless one continues from a coredump 
>>>		( from the same state as when it went down initially )
>>
>>I beg to differ on this one. Having spend several weeks tracking down random processes dying on a 
>>machine that turned out to be a bad sector in the swap partition, I have had great results by 
>>running swap on a RAID-1. If you develop a bad sector in a non-mirrored swap, bad things happen 
>>indeterminately and can be a royal PITA to chase down. It's just a little extra piece of mind.
> 
> 
> okay .... if the parts of disks is bad that is used for swap, 
> mirroring might help ... 
> 
> but, i wonder, how/why the system used that portion of swap in the first
> place
> 	- even for raid, if sector-10 in swap is bad, why would raid keep
> 	trying to write there instead of to sector-1000

Picture lpd gets swapped out on a friday night. Over the weekend it is not used and the drive 
develops a bad sector in the middle of the file. Monday morning I want to print and the system tries 
to page lpd back in again. *boom*.

I have not looked at the system swap algorithms, but I doubt they include automatic bad block 
management and read after write verification. I'm making big assumptions here, but I'm assuming they 
rely on a bad block table created by mkswap and an otherwise clean, functioning swap area.

Regards,
Brad
