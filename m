From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: DAC960 2.6.6 Question
Date: Fri, 11 Jun 2004 23:19:12 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200406120319.i5C3JG329160@watkins-home.com>
References: <1087005023.1765.22.camel@solaris.skunkware.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1087005023.1765.22.camel@solaris.skunkware.org>
To: 'Ben' <ben@easynews.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just as a test, configure the 14 disks as JBOD and create a software RAID.
See if it is faster.

From what I have seen software RAID is very fast compared to hardware RAID.
But my hardware RAID exposure is old, but so is my Linux box I guess.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Ben
Sent: Friday, June 11, 2004 9:50 PM
To: linux-raid@vger.kernel.org
Subject: DAC960 2.6.6 Question

Hello,

I've been having some performance problems with hardware raid.  I've
tired 4 different cards, two of them have been confirmed to have issues
with either the hardware or the driver (a dell perc 3/qc was hardware
and the other was using the aacraid driver which has performace
issues).  I currently have a Mylex eXtremeRaid 2000 in the box I'm
testing.  I have a total of 14 drives in a raid 5 configuration (1 of
which is a hotspare) over all 4 channels.

I can not for the life of me get more then 60-70MB/s write and 70-80MB/s
read.  Considering this is over 4 channels and in a 66MHz PCI slot I
should be seeing a lot more.  I've been playing with the ioschedular in
2.6.6 using all types of values in the /sys/block/rd*/queues/iosched/*
files.  Tried going back to deadlock and playing with the AS scheduler,
etc..  Nothing will get it up to par of where it should be.  Is this a
problem with linux in general and hardware raid support or am I simply
doing something wrong?  I've been fighting with this for a few weeks now
and am completely out of ideas.  I find it hard to believe that linux
doesn't do more then 100MB/s on hardware raid, otherwise no one would
use the hardware raid :)

Thanks,
Ben

-- 
Systems Administrator
Easynews, Inc.
Usenet Made Easy!
http://www.easynews.com

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


