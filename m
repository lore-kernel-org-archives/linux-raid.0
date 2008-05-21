From: David Greaves <david@dgreaves.com>
Subject: Re: Two Drive Failure on RAID-5
Date: Wed, 21 May 2008 21:15:30 +0100
Message-ID: <483482E2.60300@dgreaves.com>
References: <loom.20080519T224713-779@post.gmane.org> <4832966A.3010707@dgreaves.com> <loom.20080521T140522-597@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20080521T140522-597@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Cry <cry_regarder@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Cry wrote:
> David Greaves <david <at> dgreaves.com> writes:
>> Cry wrote:
>> ddrescue /dev/SOURCE /dev/TARGET /somewhere_safe/logfile
>>
>  
>> unless you've rebooted:
>> blockdev --setrw /dev/SOURCE
>> blockdev --setra  <saved readahead value> /dev/SOURCE
>>
>> mdadm --assemble --force /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
>> /dev/sde1
>  
>> cat /proc/mdstat will show the drive status
>> mdadm --detail /dev/md0
>> mdadm --examine /dev/sd[abcdef]1 [components]
> 
> I performed the above steps, however I used dd_rescue instead of ddrescue.
Similar software. I think dd_rescue is more 'scripted' and less maintained.

> ]# dd_rescue -l sda_rescue.log -o sda_rescue.bad -v /dev/sda /dev/sdg1

doh!!
You copied the disk (/dev/sda) into a partition (/dev/sdg1)...


> dd_rescue: (info): /dev/sda (488386592.0k): EOF
> Summary for /dev/sda -> /dev/sdg1:
> dd_rescue: (info): ipos: 488386592.0k, opos: 488386592.0k, 
>   xferd: 488386592.0k
>                    errs:    504, errxfer:       252.0k, 
>   succxfer: 488386336.0k
>              +curr.rate:    47904kB/s, avg.rate:    14835kB/s, 
>   avg.load:  9.6%
So you lost 252k of data. There may be filesystem corruption, a file may be
corrupt or some blank diskspace may be even more blank. Almost impossible to tell.

[aside: It would be nice if we could take the output from ddrescue and friends
to determine what the lost blocks map to via the md stripes.]

> /dev/sdg1 is my replacement drive (750G) that I had tried to sync
> previously.
No. /dev/sdg1 is a *partition* on your old drive.

I'm concerned that running the first ddrescue may have stressed /dev/sda and
you'd lose data running it again with the correct arguments.

> How do I transfer the label from /dev/sda (no partitions) to /dev/sdg1?
Can anyone suggest anything.

Cry don't do this...

I wonder about
 dd if=/dev/sdg1 of=/dev/sdg
but goodness knows if it would work... it'd rely on dd reading from the start of
the partition device and writes to the disk device not overlapping - which they
shouldn't but...

David
