From: David Brown <david.brown@hesbynett.no>
Subject: Re: Latest on SSD Raid
Date: Sat, 30 Sep 2017 13:00:51 +0200
Message-ID: <d3d6ceb4-0544-c0fc-2487-8de26244a4a4@hesbynett.no>
References: <2931220.pImEXletoV@dag.newtech.fi>
 <5d1bbdd8-5d28-f01b-9000-f245ab9d5c84@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d1bbdd8-5d28-f01b-9000-f245ab9d5c84@gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>, Dag Nygren <dag@newtech.fi>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 29/09/17 18:22, Joe Landman wrote:
> 
> On 09/29/2017 11:53 AM, Dag Nygren wrote:
>> Hi all!
>>
>> Would like to tap some experience out of all here
>> with the question:
>>
>> Any good hints and advice when setting up a RAID5 SSD with
>> 3 disks to start with?
> 
> You would need to worry about write amplification due to R5.  So if you 
> do this, use SSDs with higher DWPD (drive writes per day).  Aim for 
> 3DWPD if you can, so you don't burn out the SSDs early.  Don't do this 
> with consumer grade SSDs (anything 0.5 DWPD or less).  They do burn out 
> (sometimes much) faster.  The little extra money spent on the enterprise 
> SATA (or SAS) with higher DWPD is worth it.
> 
> Precondition the SSDs.  If you don't know how, I wrote a nice little 
> util here: https://github.com/joelandman/disk_test_setup that helps you 
> do it ... uses fio to drive 128k seqeuential writes to fill drives. 
> Drive life appears well correlated with preconditioning and write loads.
> 
> Use a chunk size of 128k or so (larger better).  You want the chunk size 
> at the same size as the erase block size.  Reduces write amplification.
> 
> You still have to worry about the whole RMW cycle for RAID5.  This 
> means, for small IO (below chunk/erase block size), you have to 
> read-modify-write at least 2 blocks back for every block written. If 
> your writes are small (4k -> 32k) you'll want to invest in even higher 
> quality (e.g. more DWPD).
> 
> If you can get enough drives, I'd actually recommend a RAID10.  Much 
> lower write amplification -> longer lifetime.
> 

And also much faster.  The key point for speed in SSD's is low latency - 
and RAID5 can add a lot of latency to writes.

