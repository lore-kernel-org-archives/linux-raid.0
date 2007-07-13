From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: 3ware 9650 tips
Date: Fri, 13 Jul 2007 15:04:30 -0400 (EDT)
Message-ID: <alpine.LRH.0.999.0707131501350.25773@chaos.egr.duke.edu>
References: <alpine.LRH.0.999.0707131356520.25773@chaos.egr.duke.edu>
 <Pine.LNX.4.64.0707131434470.31742@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707131434470.31742@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-ide-arrays@lists.math.uh.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 13 Jul 2007 at 2:35pm, Justin Piszcz wrote

> On Fri, 13 Jul 2007, Joshua Baker-LePain wrote:
>
>> My new system has a 3ware 9650SE-24M8 controller hooked to 24 500GB WD 
>> drives.  The controller is set up as a RAID6 w/ a hot spare.  OS is CentOS 
>> 5 x86_64.  It's all running on a couple of Xeon 5130s on a Supermicro X7DBE 
>> motherboard w/ 4GB of RAM.
>> 
>> Trying to stick with a supported config as much as possible, I need to run 
>> ext3.  As per usual, though, initial ext3 numbers are less than impressive. 
>> Using bonnie++ to get a baseline, I get (after doing 'blockdev --setra 
>> 65536' on the device):
>> Write: 136MB/s
>> Read:  384MB/s
>> 
>> Proving it's not the hardware, with XFS the numbers look like:
>> Write: 333MB/s
>> Read:  465MB/s
>> 
>> How many folks are using these?  Any tuning tips?
>> 
>> Thanks.
>
> You are using HW RAID then?  Those numbers seem pretty awful for that
> setup, including linux-raid@ even it though it appears you're running HW 
> raid,
> this is rather peculiar.

Yep, hardware RAID -- I need the hot swappability (which, AFAIK, is still 
an issue with md).

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
