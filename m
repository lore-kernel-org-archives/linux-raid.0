From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Raid5 Construction Question
Date: Thu, 19 Aug 2004 13:39:13 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41250FF1.9010401@h3c.com>
References: <200408191730.i7JHUd313659@watkins-home.com> <4124E8F5.1010105@psc.edu> <200408192224.06572.maarten@ultratux.net> <20040819202601.GA14858@mutsumi.mindwaresystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040819202601.GA14858@mutsumi.mindwaresystems.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Using the SMART protocol to automatically test and monitor them (after a 
full test when I first build the box is how I typically steer clear of 
these things.

I've only done more err...budget setups using IDE but apparently it 
works well on SCSI too:

http://smartmontools.sourceforge.net/smartmontools_scsi.html

You could very quickly issue a full test command to all the drives then 
come back later and check them to make sure they completed correctly

-Mike

Kourosh wrote:

> I've found that one of the better ways of varifying a disk is to run 
> the disk manufacturers disk utilities on it.  They all provide a 
> bootable disk to run the utilities.  Several times I've had problems 
> similar to this and each time it ended up being a disk that was 
> failing.  Run the utility as all the vendors I've dealt with require 
> the error code from the utility to process an RMA, so might as well do 
> it sooner, rather than later.
> 
> You could also try low-level formating each disk using the SCSI 
> controllers utilities.  IIRC it should remap any bad blocks.
> 
> Hope this helps,
> 
> Kourosh
