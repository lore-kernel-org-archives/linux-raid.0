From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: Problems with software RAID + iSCSI or GNBD
Date: Tue, 28 Jun 2005 21:11:39 -0400
Message-ID: <42C1F54B.1060405@steeleye.com>
References: <42BF67A2.6040601@nighthawkrad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42BF67A2.6040601@nighthawkrad.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christopher Smith <csmith@nighthawkrad.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Christopher Smith wrote:

>  stitch it together into a RAID1.  So, it looks like this:
> 
>              "Concentrator"
>                 /dev/md0
>                  /     \
>              GigE       GigE
>                /         \
>     "Disk node 1"       "Disk node 2"
> 
> So far I've tried using iSCSI and GNBD as the "back end" to make the 
> disk space in the nodes visible to the concentrator.  I've had two 
> problems, one unique to using iSCSI and the other common to both.

Personally, I wouldn't mess with iSCSI or GNBD. You don't need GNBD in 
this scenario anyway; simple nbd (which is in the mainline kernel...get 
the userland tools at sourceforge.net/projects/nbd) will do just fine, 
and I'd be willing to bet that it is more stable and faster...


> Problem 2: The system doesn't deal with failure very well.
> 
> Once I got the RAID1 up and running, I tried to simulate a node failure 
> by pulling the network cable from the node while disk activity was 
> taking place.  I was hoping the concentrator would detect the "disk" had 
> failed and simply drop it from the array (so it could later be simply 
> re-added).  Unfortunately that doesn't appear to happen.  What does 
> happen is that all IO to the md device "hangs" (eg: disktest throughput 
> drops to 0M/sec), I am unable to either 'cat /prod/mdstat' to see the md 
> device's status or use mdadm to manually fail the device - both simply 
> result in the command "hanging".

Well, that's the fault of either iSCSI or GNBD. md/raid1 over nbd works 
flawlessly in this scenario on 2.6 kernels (for 2.4, you'll need a 
special patch -- ask me for it, if you want).

--
Paul
