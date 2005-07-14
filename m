From: Dan Christensen <jdc@uwo.ca>
Subject: Re: RAID-5 streaming read performance
Date: Thu, 14 Jul 2005 15:16:40 -0400
Message-ID: <877jftxko7.fsf@uwo.ca>
References: <874qb14btr.fsf@uwo.ca>
	<1121220487.5552.34.camel@localhost.localdomain>
	<87mzorfmdx.fsf@uwo.ca>
	<1121257494.5504.4.camel@localhost.localdomain>
	<87eka2g9dp.fsf@uwo.ca>
	<1121259126.5504.14.camel@localhost.localdomain>
	<87vf3eeqe2.fsf@uwo.ca> <42D5573A.6090801@dgreaves.com>
	<87r7e23uo5.fsf@uwo.ca>
	<1121344255.5544.7.camel@localhost.localdomain>
	<87br55xogl.fsf@uwo.ca>
	<1121364003.5544.80.camel@localhost.localdomain>
	<k564vdgt8u.fsf@jdc.math.uwo.ca>
	<1121364617.5544.83.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ming Zhang <mingz@ele.uri.edu> writes:

> then can u test RAID0 a bit? That is easier to analyze.

I can't easily test RAID-0 with my set-up, but I can test RAID-1
with two partitions.  I found that the read speed from the md
device was about the same as the read speed from each partition.
This was with readahead set to 4096 on the md device, so I had
hoped that it would do better.  Based on the output of iostat,
it looks like the reads were shared roughly equally between the
two partitions (53%/47%).  Does the RAID-1 code try to take
the first stripe from disk 1, the second from disk 2, alternately?
Or is it clever enough to try to take the first dozen from disk 1,
the next dozen from disk 2, etc, in order to get larger, contiguous
reads? 

It's less clear to me that RAID-1 with two drives will be able to
overcome the overhead of skipping various blocks.  But it seems
like RAID-5 with four drives should be able to saturate my
bus/controller.  For example, RAID-5 could just do sequential
reads from 3 of the 4 drives, and use the parity chunks it
reads to reconstruct the data chunks from the fourth drive.
If I do parallel reads from 3 of my 4 disks, I can still get
106MB/s.

Dan

PS: Here's my simple test script, cleaned up a bit:

#!/bin/sh

# Devices to test for speed, and megabytes to read.
MDDEV=/dev/md2
MDMB=300
RAWDEVS="/dev/sda7 /dev/sdb5 /dev/sdc5 /dev/sdd5"
RAWMB=300

# Device to read to clear cache, and amount in megabytes.
CACHEDEV=/dev/sda8
CACHEMB=900

clearcache () {
  echo "Clearing cache..."
  dd if=$CACHEDEV of=/dev/null bs=1M count=$CACHEMB > /dev/null 2>&1
}

testdev () {
  echo "Read test from $1..." 
  dd if=$1 of=/dev/null bs=1M count=$2 2>&1 | grep bytes/sec
  echo 
}

clearcache
for f in $RAWDEVS ; do 
  testdev $f $RAWMB
done

clearcache
testdev $MDDEV $MDMB

