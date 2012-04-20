From: "John Stoffel" <john@stoffel.org>
Subject: Re: Removing a failing drive from multiple arrays
Date: Fri, 20 Apr 2012 10:35:40 -0400
Message-ID: <20369.29756.761374.308057@quad.stoffel.home>
References: <4F905F66.6070803@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F905F66.6070803@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Bill> I have a failing drive, and partitions are in multiple
Bill> arrays. 

Ugh!  Why?  This is why I love LVM on top of MD.  I just mirror
drives, then carve them up as needed.  Yes, you need to have two (or
more) drives of the same approximate size, but that's easy.  

Mirroring partitions just seems to be asking for trouble to me.  

Bill> I'm looking for the least painful and most reliable way
Bill> to replace it. It's internal, I have a twin in an external box,
Bill> and can create all the parts now and then swap the drive
Bill> physically. The layout is complex, here's what blkdevtra tells
Bill> me about this device, the full trace is attached.

Bill> Block device sdd, logical device 8:48
Bill> Model Family:     Seagate Barracuda 7200.10
Bill> Device Model:     ST3750640AS
Bill> Serial Number:    5QD330ZW
Bill>      Device size   732.575 GB
Bill>             sdd1     0.201 GB
Bill>             sdd2     3.912 GB
Bill>             sdd3    24.419 GB
Bill>             sdd4     0.000 GB
Bill>             sdd5    48.838 GB [md123] /mnt/workspace
Bill>             sdd6     0.498 GB
Bill>             sdd7    19.543 GB [md125]
Bill>             sdd8    29.303 GB [md126]
Bill>             sdd9   605.859 GB [md127] /exports/common
Bill>    Unpartitioned     0.003 GB

Bill> I think what I want to do is to partition the new drive, then one array 
Bill> at a time fail and remove the partition on the bad drive, and add a 
Bill> partition on the new good drive. Then repeat for each array until all 
Bill> are complete and on a new drive. Then I should be able to power off, 
Bill> remove the failed drive, put the good drive in the case, and the arrays 
Bill> should reassemble by UUID.

Sounds like a plan to me, esp if you script it and let it do all the
work over night while you're asleep.  

Bill> Does that sound right? Is there an easier way?

Niel has the better way if you're running a new kernel, but since that
implies downtime anyway... I doubt you'll do it until you've got the
data moved.

Personally, I'd move to LVM on top of MD to make life simpler...

John
