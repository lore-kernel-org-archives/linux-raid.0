From: "P. Gautschi" <linuxlist@gautschi.net>
Subject: Re: Bad sequential performance of RAID5 with a lot of disk seeks
Date: Tue, 07 Oct 2014 09:54:22 +0200
Message-ID: <20141007095422.Horde.3l6BckPhfY5U8dchaOdLNA1@webmail.gautschi.net>
References: <54336FC1.6080306@gautschi.net>
 <20141007074347.GA18786@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141007074347.GA18786@cthulhu.home.robinhill.me.uk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yes I did wait for the syncing to complete before accessing md0.
I had the seeks during the syncing and afterwards when reading or  
writing to the array.

Patrick

Quoting Robin Hill <robin@robinhill.me.uk>:
> On Tue Oct 07, 2014 at 06:44:49AM +0200, P. Gautschi wrote:
>
>> I've created a RAID5 on 5 identical SATA disks. Doing some  
>> performance measurements
>> with dd I get a disappointing performance.
>> A dd with bs=1M on a btrfs created on md0 transfers about 110 MB/s.  
>> (both read and write)
>> A dd on md0 has the same write speed but only about 20 MB/s on read.
>> In all of the tests I hear the disk constantly seeking. This was  
>> also the case
>> during creation of the array.
>> I also created a RAID4 to make sure that I doesn't get fooled by  
>> the stripe layout of RAID5.
>> Now I get about 110 MB/s for write and 230 MB/s for read on md0.  
>> But the constant
>> seeking is still present for both read and write and during  
>> creation of the array.
>>
>> Why are the disk perform so many seek operations? I think a  
>> sequential access on md0 should
>> cause a sequential access on the individual disk.
>>
>> I have to add that I did something unusual: I created the RAID4/5  
>> with a chunk size of 4KiB.
>> The idea of this was that when I'm going to use btrfs with the  
>> default nodesize of 16KiB
>> all node write will fill a full stripe and there won't be any RMW  
>> at all. (both fortunate
>> for performance and integrity in a power loss situation.)
>> Nevertheless I think a sequential access on the array should cause  
>> a sequential access on the
>> disks for any chunk size if the read/write block size is a exact multiple of
>> the (numdisks-1)*chunk size.
>>
>> Is there any explanation for the seeks and how do I get rid of them?
>>
> After creating the arrays did you wait for them to finish syncing? The
> array is created in degraded mode initially and then rebuilds onto the
> additional disk (this is the fastest way to do things, unless you know
> the disks are all zeroed initially). Until this rebuild is complete then
> it'll be competing with any other disk activity.
>
> Cheers,
>     Robin
> --
>      ___
>     ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
>    / / )      | Little Jim says ....                            |
>   // !!       |      "He fallen in de water !!"                 |


