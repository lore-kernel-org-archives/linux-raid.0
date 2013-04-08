From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: mpt2sas + raid10 goes boom
Date: Mon, 08 Apr 2013 18:39:49 +0800
Message-ID: <51629E75.9090606@fnarfbargle.com>
References: <20130408071834.GA15457@onthe.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130408071834.GA15457@onthe.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Dunlop <chris@onthe.net.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/04/13 15:18, Chris Dunlop wrote:
> G'day,
>
> On a LSI 9211-8i controller with IT firmware, when I use mdadm
> to create a 4-disk raid10 and mount it, the controller reports
> errors on all 4 disks, then the disks go read-only (kern.log
> below).
>
> A raid6 using the same sets of disks works without any problems.
>
> Has anyone had any success or similar failures with similar
> hardware, and/or have any idea what might be going on?

I have a 4 drive RAID10 and a 10 drive RAID6 spread across three of 
these controllers (plus a couple of extra drives). I always run the 
latest stable kernel where x.x.y y >= 2 so I can't give you any details 
on old kernels. I'm using LSI firmware 15, but I only upgraded that last 
time I rebooted, so 14 was ok on 3.7.2 and earlier for a while.

I'm currently on 3.7.9 (have not rebooted since it was upgraded).

I do hammer the living daylights out of the RAID10 (it has 4 15K SAS 
drives).

Apr  8 15:08:53 b4 kernel: [  448.657142] md4: WRITE SAME failed. 
Manually zeroing.

That indicates that the driver is trying to send DISCARD down to the 
drives, which if they are rotating media would be why they are 
complaining loudly.

