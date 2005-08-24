From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID 5 write performance advice
Date: Thu, 25 Aug 2005 07:32:45 +1000
Message-ID: <17164.59261.540591.841830@cse.unsw.edu.au>
References: <430C2EA6.2050103@web.de>
	<1124887589.5550.27.camel@localhost.localdomain>
	<430C798B.1030107@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mirko Benz on Wednesday August 24
Sender: linux-raid-owner@vger.kernel.org
To: Mirko Benz <mirko.benz@web.de>
Cc: mingz@ele.uri.edu, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday August 24, mirko.benz@web.de wrote:
> Hello,
> 
> The RAID5 configuration is: 8 SATA disks, 8 port Marvel SATA PCI-X 
> controller chip (SuperMicro board), Dual Xeon, 1 GB RAM, stripe size 
> 64K, no spare disk.
> 
> Measurements are performed to the ram md device with:
> disktest -PT -T30 -h1 -K8 -B65536 -ID /dev/md0
> using the default stripe size (64K). 128K stripe size does not make a 
> real difference.

May I suggest you try creating a filesystem on the device and doing
tests in the filesystem?  I have found the raw device slower that
filesystem access before, and a quick test shows writing to the
filesystem (ext3) is about 4 times as fast as writing to /dev/md1 on a
6 drive raid5 array.

> 
> If Linux uses "stripe write" why is it so much slower than HW Raid? Is 
> it disabled by default?

No, it is never disabled.  However it can only work if raid5 gets a
full stripe of data before being asked to flush that data.  Writing to
/dev/md0 directly may cause flushes too often.


Does your application actually require writing to the raw device, or
will you be using a filesystem?  

NeilBrown
