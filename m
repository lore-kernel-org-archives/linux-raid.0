From: Dan Christensen <jdc@uwo.ca>
Subject: Re: RAID-5 streaming read performance
Date: Wed, 13 Jul 2005 13:56:15 -0400
Message-ID: <87r7e2egjk.fsf@uwo.ca>
References: <874qb14btr.fsf@uwo.ca>
	<1121220487.5552.34.camel@localhost.localdomain>
	<87mzorfmdx.fsf@uwo.ca>
	<1121257494.5504.4.camel@localhost.localdomain>
	<87eka2g9dp.fsf@uwo.ca>
	<1121259126.5504.14.camel@localhost.localdomain>
	<87vf3eeqe2.fsf@uwo.ca>
	<1121264997.5504.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here's a question for people running software raid-5:  do you get
significantly better read speed from a raid-5 device than from it's
component partitions/hard drives, using the simple dd test I did?
Knowing this will help determine whether something is funny with my
set-up and/or hardware, or if just had unrealistic expectations about
software raid performance.

Feel free to reply directly to me if you don't want to clutter the
list.  My dumb script is below.

Thanks,

Dan

#!/bin/sh

dd if=/dev/sda8 of=/dev/null bs=1M count=900 > /dev/null 2>&1
for f in sda7 sdb5 sdc5 sdd5 ; do 
  echo $f; 
  dd if=/dev/$f of=/dev/null bs=1M count=300 2>&1 | grep bytes/sec
  echo; 
done

dd if=/dev/sda8 of=/dev/null bs=1M count=900 > /dev/null 2>&1
for f in md2 ; do 
  echo $f; 
  dd if=/dev/$f of=/dev/null bs=1M count=300 2>&1 | grep bytes/sec
  echo; 
done


