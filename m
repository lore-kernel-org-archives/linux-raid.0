From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Spares and partitioning huge disks
Date: Sat, 15 Jan 2005 14:31:23 +0400
Message-ID: <41E8F0FB.4090104@wasp.net.au>
References: <Pine.LNX.4.44.0501151050110.3584-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0501151050110.3584-100000@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael Abrahamsson wrote:
> On Sat, 15 Jan 2005, Peter T. Breuer wrote:
> 
> 
>>I also agree that "redundancy per block" is probably a much better idea
>>than "redundancy per disk". Probably needs a "how hot are you?"
>>primitive, though!
> 
> 
> Would a methodology that'll do
> 
> if read error then
>   recreate the block from parity
>   write to sector that had read error

In theory this should reallocate the bad sector.

>   wait until write has completed

If the write fails, fail the drive as bad things are going to happen.

>   flush buffers
>   read back block from drive
>     if block still bad
>       fail disk
>   log result

Make sure the logging is done in such a way as mdadm can send you an E-mail and say. "Hey, sda just 
had a bad block. Be aware.

Brad
