From: David Greaves <david@dgreaves.com>
Subject: Re: RAID-5 streaming read performance
Date: Wed, 13 Jul 2005 19:02:34 +0100
Message-ID: <42D5573A.6090801@dgreaves.com>
References: <874qb14btr.fsf@uwo.ca> <1121220487.5552.34.camel@localhost.localdomain> <87mzorfmdx.fsf@uwo.ca> <1121257494.5504.4.camel@localhost.localdomain> <87eka2g9dp.fsf@uwo.ca> <1121259126.5504.14.camel@localhost.localdomain> <87vf3eeqe2.fsf@uwo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87vf3eeqe2.fsf@uwo.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Christensen <jdc@uwo.ca>
Cc: mingz@ele.uri.edu, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dan Christensen wrote:

>Ming Zhang <mingz@ele.uri.edu> writes:
>
>  
>
>>test on a production environment is too dangerous. :P
>>and many benchmark tool u can not perform as well.
>>    
>>
>
>Well, I put "production" in quotes because this is just a home mythtv
>box.  :-)  So there are plenty of times when it is idle and I can do
>benchmarks.  But I can't erase the hard drives in my tests.
>  
>
Me too.

>>LVM overhead is small, but file system overhead is hard to say.
>>    
>>
>I expected LVM overhead to be small, but in my tests it is very high.
>I plan to discuss this on the lvm mailing list after I've got the RAID
>working as well as possible, but as an example:
>
>Streaming reads using dd to /dev/null:
>
>component partitions, e.g. /dev/sda7: 58MB/s
>raid device /dev/md2:                 59MB/s
>lvm device /dev/main/media:           34MB/s
>  
>
This is not my experience.
What are the readahead settings?
I found significant variation in performance by varying the readahead at
raw, md and lvm device level

In my setup I get

component partitions, e.g. /dev/sda7: 39MB/s
raid device /dev/md2:                 31MB/s
lvm device /dev/main/media:           53MB/s

(oldish system - but note that lvm device is *much* faster)

For your entertainment you may like to try this to 'tune' your readahead
- it's OK to use so long as you're not recording:

(FYI I find that setting readahead to 0 on all devices and 4096 on the
lvm device gets me the best performance - which makes sense if you think
about it...)

#!/bin/bash
RAW_DEVS="/dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/hdb"
MD_DEVS=/dev/md0
LV_DEVS=/dev/huge_vg/huge_lv

LV_RAS="0 128 256 1024 4096 8192"
MD_RAS="0 128 256 1024 4096 8192"
RAW_RAS="0 128 256 1024 4096 8192"

function show_ra()
{
for i in $RAW_DEVS $MD_DEVS $LV_DEVS
do echo -n "$i `blockdev --getra $i`  ::  "
done
echo
}

function set_ra()
{
 RA=$1
 shift
 for dev in $@
 do
   blockdev --setra $RA $dev
 done
}

function show_performance()
{
 COUNT=4000000
 dd if=$LV_DEVS of=/dev/null count=$COUNT 2>&1 | grep seconds
}

for RAW_RA in $RAW_RAS
 do
 set_ra $RAW_RA $RAW_DEVS
 for MD_RA in $MD_RAS
   do
   set_ra $MD_RA $MD_DEVS
   for LV_RA in $LV_RAS
     do
     set_ra $LV_RA $LV_DEVS
     show_ra
     show_performance
     done
   done
 done

