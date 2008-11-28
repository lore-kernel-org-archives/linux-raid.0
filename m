From: Chris Webb <chris@arachsys.com>
Subject: Re: Synchronous vs asynchonous mdadm operations
Date: Fri, 28 Nov 2008 16:41:00 +0000
Message-ID: <20081128164100.GB22404@arachsys.com>
References: <20081128162703.GA22404@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081128162703.GA22404@arachsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris Webb <chris@arachsys.com> writes:

> I notice that some mdadm operations appear to be asynchronous. For instance,
> 
>   mdadm --fail /dev/md/shelf.51000 /dev/mapper/slot.51000.1
>   mdadm --remove /dev/md/shelf.51000 /dev/mapper/slot.51000.1
> 
> will always fail at the --remove stage with
> 
>   mdadm: hot remove failed for /dev/mapper/slot.51000.1: Device or resource busy
> 
> whereas adding a short sleep in between will make it successful.
[...]
> Also, is mdadm --stop asynchronous in the same way? If mdadm --stop succeeds
> on one host and I immediately run mdadm --assemble on another host which is
> able to access the same slots, am I at risk of corrupting the array?
> 
> The reason for the question is that I'm seeing occasional cases of arrays which
> won't reassemble following such an operation. dmesg alleges there is an invalid
> superblock for all of the six slots which were originally part of the array:

I should say, both of these were seen with mdadm 2.6.7 and the md driver
from kernel 2.6.27. I notice that Neil released mdadm 2.6.8 while I was
writing my message, including a changelog entry:

  Fix an error when assembling arrays that are in the middle of a reshape. 

Perhaps I've just hit this bug in this case? It would certainly explain why
I'm seeing it so rarely.

Cheers,

Chris.
