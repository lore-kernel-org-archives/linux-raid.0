From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Which raid card to buy for Sarge
Date: Sun, 04 Apr 2004 16:47:40 +1200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <406F936C.2090605@sauce.co.nz>
References: <Pine.LNX.4.44.0403311442520.31572-100000@coffee.psychology.mcmaster.ca> <406B27E4.1000106@sauce.co.nz> <20040401090731.GI6923@chihiro.cern.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040401090731.GI6923@chihiro.cern.ch>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

KELEMEN Peter wrote:
> * Richard Scobie (richard@sauce.co.nz) [20040401 08:19]:
> 
> 
>>3ware hardware RAID 10: Reads - 92.8MB/s    Writes - 88.9MB/s
>>Software RAID 10:  Reads - 53.7MB/s   Writes - 94.9 MB/s
> 
> 
>>If anyone is running similar hardware and is able to get better
>>software RAID performance, I would be very interested to hear
>>the parameters.
> 
> 
> I've tested some configurations with 128 GiB streams (iozone) on a
> dual Xeon 2.4GHz 2G RAM machine (running XFS).
> 
> 3ware HW-RAID1, Linux SW-RAID0:	read 263 MiB/s, write 157 MiB/s
> 3ware HW-RAID5, Linux SW-RAID0:	read 243 MiB/s, write 135 MiB/s
> Linux SW-RAID5:			read 225 MiB/s, write 135 MiB/s
> 3ware HW-RAID10:		read 119 MiB/s, write  91 MiB/s
> 
> Peter
> 


Thanks Peter,

This array is obviously larger than the 4 disc one I have. Unfortunately 
you do not have the one result I would really like - SW-RAID10.

It would be interesting to see how it compares to 3ware HW-RAID10.

Regards,

Richard Scobie

