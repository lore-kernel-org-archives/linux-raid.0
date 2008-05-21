From: "Janos Haar" <janos.haar@netcenter.hu>
Subject: Re: Two Drive Failure on RAID-5
Date: Wed, 21 May 2008 22:47:40 +0200
Message-ID: <09ed01c8bb83$ec3f7230$9300a8c0@dcccs>
References: <loom.20080519T224713-779@post.gmane.org> <4832966A.3010707@dgreaves.com> <loom.20080521T140522-597@post.gmane.org> <483482E2.60300@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>, cry_regarder@yahoo.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message ----- 
From: "David Greaves" <david@dgreaves.com>
To: "Cry" <cry_regarder@yahoo.com>
Cc: <linux-raid@vger.kernel.org>
Sent: Wednesday, May 21, 2008 10:15 PM
Subject: Re: Two Drive Failure on RAID-5


> Cry wrote:
>> David Greaves <david <at> dgreaves.com> writes:
>>> Cry wrote:
>>> ddrescue /dev/SOURCE /dev/TARGET /somewhere_safe/logfile
>>>
>>
>>> unless you've rebooted:
>>> blockdev --setrw /dev/SOURCE
>>> blockdev --setra  <saved readahead value> /dev/SOURCE
>>>
>>> mdadm --assemble --force /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 
>>> /dev/sdd1
>>> /dev/sde1
>>
>>> cat /proc/mdstat will show the drive status
>>> mdadm --detail /dev/md0
>>> mdadm --examine /dev/sd[abcdef]1 [components]
>>
>> I performed the above steps, however I used dd_rescue instead of 
>> ddrescue.
> Similar software. I think dd_rescue is more 'scripted' and less 
> maintained.
>
>> ]# dd_rescue -l sda_rescue.log -o sda_rescue.bad -v /dev/sda /dev/sdg1
>
> doh!!
> You copied the disk (/dev/sda) into a partition (/dev/sdg1)...
>
>
>> dd_rescue: (info): /dev/sda (488386592.0k): EOF
>> Summary for /dev/sda -> /dev/sdg1:
>> dd_rescue: (info): ipos: 488386592.0k, opos: 488386592.0k,
>>   xferd: 488386592.0k
>>                    errs:    504, errxfer:       252.0k,
>>   succxfer: 488386336.0k
>>              +curr.rate:    47904kB/s, avg.rate:    14835kB/s,
>>   avg.load:  9.6%
> So you lost 252k of data. There may be filesystem corruption, a file may 
> be
> corrupt or some blank diskspace may be even more blank. Almost impossible 
> to tell.

The dd_rescue shows if the target device is full.
The errs number divisible by 8, i think its only bad sectors.

But let me note:
With the default -b 64k, dd_rescue sometimes drop the entire soft block area 
on the first error!
If you want more precise result, run it again with -b 4096 and -B 1024, and 
if you can, don't copy the drive to the partition! :-)

>
> [aside: It would be nice if we could take the output from ddrescue and 
> friends
> to determine what the lost blocks map to via the md stripes.]
>
>> /dev/sdg1 is my replacement drive (750G) that I had tried to sync
>> previously.
> No. /dev/sdg1 is a *partition* on your old drive.
>
> I'm concerned that running the first ddrescue may have stressed /dev/sda 
> and
> you'd lose data running it again with the correct arguments.
>
>> How do I transfer the label from /dev/sda (no partitions) to /dev/sdg1?
> Can anyone suggest anything.

Cry i only have this idea:
dd_rescue -v -m 128k -r /dev/source -S 128k superblock.bin
losetup /dev/loop0 superblock.bin
mdadm --build -l linear --raid-devices=2 /dev/md1 /dev/sdg1 /dev/loop0

And the working raid member is /dev/md1. ;-)
But only for recovery!!!

(only idea, not tested.)

Cheers,
Janos

>
> Cry don't do this...
>
> I wonder about
> dd if=/dev/sdg1 of=/dev/sdg
> but goodness knows if it would work... it'd rely on dd reading from the 
> start of
> the partition device and writes to the disk device not overlapping - which 
> they
> shouldn't but...
>
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html 

