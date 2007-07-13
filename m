From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 3ware 9650 tips
Date: Fri, 13 Jul 2007 14:35:18 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0707131434470.31742@p34.internal.lan>
References: <alpine.LRH.0.999.0707131356520.25773@chaos.egr.duke.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.0.999.0707131356520.25773@chaos.egr.duke.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Joshua Baker-LePain <jlb17@duke.edu>
Cc: linux-ide-arrays@lists.math.uh.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Fri, 13 Jul 2007, Joshua Baker-LePain wrote:

> My new system has a 3ware 9650SE-24M8 controller hooked to 24 500GB WD 
> drives.  The controller is set up as a RAID6 w/ a hot spare.  OS is CentOS 5 
> x86_64.  It's all running on a couple of Xeon 5130s on a Supermicro X7DBE 
> motherboard w/ 4GB of RAM.
>
> Trying to stick with a supported config as much as possible, I need to run 
> ext3.  As per usual, though, initial ext3 numbers are less than impressive. 
> Using bonnie++ to get a baseline, I get (after doing 'blockdev --setra 65536' 
> on the device):
> Write: 136MB/s
> Read:  384MB/s
>
> Proving it's not the hardware, with XFS the numbers look like:
> Write: 333MB/s
> Read:  465MB/s
>
> How many folks are using these?  Any tuning tips?
>
> Thanks.
>
> -- 
> Joshua Baker-LePain
> Department of Biomedical Engineering
> Duke University
>

Let's try that again with the right address :)


You are using HW RAID then?  Those numbers seem pretty awful for that
setup, including linux-raid@ even it though it appears you're running HW raid,
this is rather peculiar.

To give you an example I get 464MB/s write and 627MB/s with a 10 disk
raptor software raid5.

Justin.

