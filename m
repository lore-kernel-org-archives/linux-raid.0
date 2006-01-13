From: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>
Subject: md faster than h/w?
Date: Fri, 13 Jan 2006 15:06:54 +0800
Message-ID: <dq7jii$n1c$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've been trying to increase the i/o performance of a new server.

The server is a Dell PowerEdge 2850. It has 2(x2) Intel Xeon 3GHz CPUs, 
  4GB RAM, a Perc4/DC RAID controller (AKA MegaRAID SCSI 320-2), and we 
have 5 Fujitsu MAX3073NC drives attached to one of it's channels (can't 
use the other channel due to a missing 'option').

According to Fujitsu's web site, the disks can each do internal IO at 
upto 147MB/s, and burst upto 320MB/s. According to the LSI Logic web 
page, the controller can do upto 320MB/s. All theoretical numbers, of 
course.

So, we're trying to measure the performance. We've been using 'bonnie++' 
and 'hdparm -t'.

We're primarily focusing on read performance at the moment.

We set up the os (debian) on one of the disks (sda), and we're playing 
around with the others in various configurations.

I figured it'd be good to measure the maximum performance of the array, 
so we have been working with the 4 disks in a raid0 configuration 
(/dev/sdb).

Initially, we were getting 'hdparm -t' numbers around 80MB/s, but this 
was when we were testing /dev/sdb1 - the (only) partition on the device. 
When we started testing /dev/sdb, it increased significantly to around 
180MB/s. I'm not sure what to conclude from this.

In any case, our bonnie++ results weren't so high, at around 100MB/s.

Using theoretical numbers as a maximum, we should be able to read at the 
greater of 4 times a single drive speed (=588MB/s) or the SCSI bus speed 
(320MB/s) ie 320MB/s.

So, 100MB/s seems like a poor result.

I thought I'd try one other thing and that was to configure the drives 
as JBOD (which is actually having each one as RAID0 in the controller 
config s/w), and configure as s/w raid0.

Doing this initially resulted in a doubling of bonnie++ speed at over 
200MB/s, though I have been unable to reproduce this result - the most 
common result is still about 180MB/s.

One further strangeness is that our best results have been while using a 
uni-processor kernel - 2.6.8. We would prefer it if our best results 
were with the most recent kernel we have, which is 2.6.15, but no.

So, any advice on how to obtain best performance (mainly web and mail 
server stuff)?
Is 180MB/s-200MB/s a reasonable number for this h/w?
What numbers do other people see on their raid0 h/w?
Any other advice/comments?

Max.

