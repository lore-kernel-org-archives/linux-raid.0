From: Neil Brown <neilb@suse.de>
Subject: Re: raid reconstruction speed
Date: Fri, 20 Jan 2006 09:27:48 +1100
Message-ID: <17360.4708.429259.765358@cse.unsw.edu.au>
References: <op.s3mjqms2i22er4@xray.bmc.uu.se>
	<op.s3m7n1pucigqcu@apollo13>
	<op.s3m9znsqcigqcu@apollo13>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from PFC on Thursday January 19
Sender: linux-raid-owner@vger.kernel.org
To: PFC <lists@peufeu.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday January 19, lists@peufeu.com wrote:
> 
> 	Sorry for flooding ;)
> 
> 	I have the following configuration :
> 	- two disks (hda and sda)
> 	- each disk has 2 partitions (hda1/sda1) and (hda2/sda2)
> 	- two raid1 md devices are made :
> 	md0 = sda1 + hda1, contains the OS
> 	md1 = sda2 + hda2, contains a database
> 
> 	I made 2 devices because I wanted to use different FS's.
> 
> 	When rebuilding md1, it does not realize accesses to md0 wait for the  
> same disks. Thus reconstruction of md1 runs happily at full speed, and the  
> machine is dog slow, because the OS and everything is on md0.

Hmmm.. it should.  md measures activity on a component by looking at
the activity of the whole device holding that component.    So any
activity on hda or sda should slow down rebuild of md0 or md1.
It is very strange that it doesn't...

What kernel are you using?

NeilBrown
