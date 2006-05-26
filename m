From: Craig Hollabaugh <craig@hollabaugh.com>
Subject: Re: RAID5 kicks non-fresh drives
Date: Fri, 26 May 2006 11:06:21 -0600
Message-ID: <1148663181.2836.11.camel@hendrix.hollabaugh.com>
References: <Pine.LNX.4.44.0605261231460.20378-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0605261231460.20378-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2006-05-26 at 12:45 -0400, Mark Hahn wrote:
> I think the current situation is good, since there is some danger of 
> going too far.  for instance, testing each partition to see whether 
> it contains a valid superblock would be pretty crazy, right?  requiring
> either the "auto-assemble-me" partition type, or explicit partitions 
> given in a config file is a happy medium...
> 

I created my array in 1/2003, don't know versions of kernel or mdadm I
was using then.

In my situation over the past few days.
  kernel 2.4.30 kicked non-fresh
  kernel 2.6.11.8 kicked non-fresh
  kernel 2.6.18.8 didn't mention anything, just skipped my 'linux'
partitions

These kernels auto-assemble prior to mounting /. So the kernel doesn't
consult my 
/etc/mdadm/mdadm.conf file. Is this correct? 



> 
-- 
------------------------------------------------------------
Dr. Craig Hollabaugh, craig@hollabaugh.com, 970 240 0509
Author of Embedded Linux: Hardware, Software and Interfacing
www.embeddedlinuxinterfacing.com

