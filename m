From: David Brown <david.brown@hesbynett.no>
Subject: Using of RAID10,offset for faster writes
Date: Sat, 09 Apr 2011 14:03:21 +0200
Message-ID: <inphu9$5kl$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

During a discussion about RAID in another context (a Linux newsgroup), I 
began thinking about the speeds of the different RAID10 layouts for 
different usages.  RAID10,far is often the fastest choice for general 
use - you get striped reads for large reads, and access times are good 
because you can get the data from either disk.  The disadvantage is that 
writes involve a lot of extra head movement, as you need copies of the 
data on two widely separated areas on the each disk.  But for general 
use, you read a lot more often than you write, so the tradeoff is worth it.

In the discussion we were looking particularly at swap space on RAID. 
This is a usage that requires a lot of writing, especially small writes. 
  Using the RAID10,offset layout should give you most of the benefits of 
RAID10,far when it comes to reading - you don't get quite as efficient 
block reads for large reads, but you can still do a lot of striping in 
the reads.  And writes will involve far less head movement, and so 
should complete faster.

Has anyone tried this, or done any benchmarking?

