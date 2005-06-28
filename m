From: Michael Stumpf <mjstumpf@pobox.com>
Subject: Re: Problems with software RAID + iSCSI or GNBD
Date: Tue, 28 Jun 2005 11:05:20 -0500
Message-ID: <42C17540.3000709@pobox.com>
References: <42BF67A2.6040601@nighthawkrad.net>
Reply-To: mjstumpf@pobox.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42BF67A2.6040601@nighthawkrad.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christopher Smith <csmith@nighthawkrad.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>
> Problem 2: The system doesn't deal with failure very well.
>
> Once I got the RAID1 up and running, I tried to simulate a node 
> failure by pulling the network cable from the node while disk activity 
> was taking place.  I was hoping the concentrator would detect the 
> "disk" had failed and simply drop it from the array (so it could later 
> be simply re-added).  Unfortunately that doesn't appear to happen.  
> What does happen is that all IO to the md device "hangs" (eg: disktest 
> throughput drops to 0M/sec), I am unable to either 'cat /prod/mdstat' 
> to see the md device's status or use mdadm to manually fail the device 
> - both simply result in the command "hanging".


I probably can't help much at the moment, but...

I didn't realize that NBD type things had advanced to even this level of 
stability.  This is good news.  I've been wanting to do something like 
what you're trying for some time to overcome the bounds of  
power/busses/heat/space that limit you to a single machine when building 
a large md or LVM.  Looking at the GNBD project page, it still seems 
pretty raw, although a related project DDRAID seems to hold some promise.

I'd be pretty timid about putting anything close to production on these 
drivers, though.

What distro / kernel version / level of GNBD are you using? 

Regards-
Michael Stumpf



