From: MRK <mrk@shiftmail.org>
Subject: Re: Suggestion needed for fixing RAID6
Date: Fri, 23 Apr 2010 14:34:24 +0200
Message-ID: <4BD193D0.5080003@shiftmail.org>
References: <626601cae203$dae35030$0400a8c0@dcccs>
 <20100423065143.GA17743@maude.comedia.it>
 <695a01cae2c1$a72907d0$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <695a01cae2c1$a72907d0$0400a8c0@dcccs>
Sender: linux-raid-owner@vger.kernel.org
To: Janos Haar <janos.haar@netcenter.hu>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/23/2010 10:47 AM, Janos Haar wrote:
>
> ----- Original Message ----- From: "Luca Berra" <bluca@comedia.it>
> To: <linux-raid@vger.kernel.org>
> Sent: Friday, April 23, 2010 8:51 AM
> Subject: Re: Suggestion needed for fixing RAID6
>
>
>> another option could be using the device mapper snapshot-merge target
>> (writable snapshot), which iirc is a 2.6.33+ feature
>> look at
>> http://smorgasbord.gavagai.nl/2010/03/online-merging-of-cow-volumes-with-dm-snapshot/ 
>>
>> for hints.
>> btw i have no clue how the scsi error will travel thru the dm layer.
>> L.
>
> ...or cowloop! :-)
> This is a good idea! :-)
> Thank you.
>
> I have another one:
> re-create the array (--assume-clean) with external bitmap, than drop 
> the missing drive.
> Than manually manipulate the bitmap file to re-sync only the last 10% 
> wich is good enough for me...


Cowloop is kinda deprecated in favour of DM, says wikipedia, and messing 
with the bitmap looks complicated to me.
I think Luca's is a great suggestion. You can use 3 files with 
loop-device so to store the COW devices for the 3 disks which are 
faulty. So that writes go there and you can complete the resync.
Then you would fail the cow devices one by one from mdadm and replicate 
to spares.

But this will work ONLY if read errors are still be reported across the 
DM-snapshot thingo. Otherwise (if it e.g. returns a block of zeroes 
without error) you are eventually going to get data corruption when 
replacing drives.

You can check if read errors are reported, by looking at the dmesg 
during the resync. If you see many  "read error corrected..." it works, 
while if it's silent it means it hasn't received read errors which means 
that it doesn't work. If it doesn't work DO NOT go ahead replacing 
drives, or you will get data corruption.

So you need an initial test which just performs a resync but *without* 
replicating to a spare. So I suggest you first remove all the spares 
from the array, then create the COW snapshots, then assemble the array, 
perform a resync, look at the dmesg. If it works: add the spares back, 
fail one drive, etc.

If this technique works this would be useful for everybody, so pls keep 
us informed!!
Thank you
