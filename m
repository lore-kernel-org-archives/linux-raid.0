From: "Andrew Dedesko" <adedesko@evertz.com>
Subject: RAID array on block device vs. on partition
Date: Thu, 20 Sep 2012 10:08:39 -0400
Message-ID: <C70A636B101FD44999B82525C3E92AFA010A3CE1@otis.burlington.evertz.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

A while ago I set up some RAID 10 arrays (4 x ~750GB drives), in which 
the arrays' member devices were partitions on the hard drives.  I did 
that because I thought that would allow a 750GB drive to be replaced 
with a larger drive in the future; the drive could be paritioned 
similarly to the partitions that that were array members.  Later I 
realized that larger drives can be added to an existing array to replace 
other drives / partitions / devices and it seems to work fine.

I am thinking about setting up arrays to use unpartitioned block devices 
and switching some of the existing arrays to using unparitioned block 
devices, too.  Is there a benefit to using unpartitioned block devices 
over partitions or vice versa?  Or is it recommended to use one over 
another?


Thanks for reading

andrew
