From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Hardware vs Software and Bad Block Relocation
Date: Fri, 21 May 2004 10:38:55 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200405211438.i4LEcxB24002@www.watkins-home.com>
References: <d4.d36c2f5.2ddf588e@aol.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d4.d36c2f5.2ddf588e@aol.com>
To: AndyLiebman@aol.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have had this same problem.  The funny thing is it could be fixed, but I
bet it is very hard to do.

With most or all modern disk drives (10 years old or less) if you write to
the bad block the disk drive will re-locate the bad block.  The RAID5
software could do this:

Read bad block, get a failure.
	Re-create missing data.
	Write missing data back over the bad block.
	If success then
		go on with life!
	Else
		Report the disk as needing to be replaced,
		but don't fail it for 1 bad block!
		Maybe have a threshold.
		After all 99.99999% of the data is still there!

I have "corrected" disks with bad blocks by using dd to copy /dev/zero to
the disk.  After that test the disk by copying the disk to /dev/null.  Works
every time.

Example:
	/dev/sdf has a bad block.
	And you are willing to loose the data on it!
	dd if=/dev/zero of=/dev/sdf bs=64k
	If success then
		dd if=/dev/sdf of=/dev/null bs=64k
		If success then
			The disk is good as... well it has not bad blocks
for now.

If a disk has a bad block in 1 partition you could just dd zero to that
partition, but still verify 100% of the disk.

I have corrected about 3 disks this way in the past 3 years.  I have never
had any issues since then.  So I know the raid software could automate this
and save some major headaches!

One gotcha, my disks had auto re-locate disabled.  I install a Seagate tool
that allowed me to adjust disk drive options.  I enabled auto re-locate for
read and write.  Since then I have not had a read error.  I think the drive
re-locates blocks on reads if there is a retry on read.  Of course it can't
re-locate the block if it can't read it.

A note about hardware RAID.  Hardware RAID systems will test the disks from
time to time.  So the bad block will be found at a time that you don't need
it.  The chances of having 2 bad blocks on different drives is reduced much
by this extra scanning.  I use a crontab script to read my disks each night.
It sends me an email status.  This way I stand a good chance of knowing
about a bad block before md finds it.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of AndyLiebman@aol.com
Sent: Friday, May 21, 2004 9:05 AM
To: linux-raid@vger.kernel.org
Subject: Hardware vs Software and Bad Block Relocation

From the replies I got to my last question about Hardware versus Software 
RAID, one of the big advantages of true hardware RAID can be the better
handling 
of bad blocks or read errors on RAID 1 and RAID 5 arrays. 

I have encountered this situation a few times with Linux software RAID 5  
where I will get a read error on a particular sector of a particular disk.
Linux 
software RAID will immediately throw this disk out of the array. And now, if
I 
get a read error on another disk before I replace the first disk  (unlikely 
but it did happen to me once -- about a day after getting the first error),
the 
array can be totally lost. Or at least it's not so obvious how to recover
the 
data. 

Yesterday, I spoke with two tech support people at 3ware who explained that 
their hardware RAID cards will remember where a read error is encountered
and 
next time you try to write to that sector the data will get relocated to 
another sector instead. As long as there is still communication with the
disk after 
a read error (within 20 seconds) the disk won't get kicked out of the array 
and the RAID won't go into degraded mode. An error report will get generated

that you can view in the 3ware 3dm or 3dm2 GUI interface -- so you can see
that 
you MIGHT have to start worrying about a particular disk. But the data will 
still be intact and the array will still offer redundancy. 

This seems like a HUGE advantage to data security -- especially in my 
application. I am dealing with Terrabytes of video and audio files, and it's
simply 
not practical to back them up. 

So, my question is, is there a "software equivalent" to what the 3ware card

does with bad sectors or bad blocks. Will EVMS do that? Will the latest LVM
do 
that? I have read that EVMS does have a bad block relocation function, but 
does it work the same way as the 3ware card? Will it prevent an array from
going 
into degraded mode after a read error? 
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


