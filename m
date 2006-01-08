From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: more info on the hang with 2.6.15-rc5
Date: Sun, 08 Jan 2006 13:20:59 -0500
Message-ID: <43C1580B.9020609@tmr.com>
References: <E1EpIfb-0001e2-GR@highlab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1EpIfb-0001e2-GR@highlab.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Kuzminsky <seb@highlab.com>
Cc: linux-raid@vger.kernel.org, linux-lvm@redhat.com
List-Id: linux-raid.ids

Sebastian Kuzminsky wrote:

>Now it works, but I dont trust it one bit.
>
>I had been seeing almost immediate, perfectly repeatable hard lockups
>in 2.6.15-rc5 and 2.6.15-rc5-mm3, when using sata_mv, RAID, and LVM
>together.  Nothing in the syslog or on the console, and the system is
>totally unresponsive to the keyboard & network.
>
>My hardware setup is: four Seagate Barracuda 500 GB disks, on a Marvell
>MV88SX6081 8-port SATA-II PCI-X controller, on a PCI-X bus (64/66).
>
>The disks work great when accessed directly.  They work great when used
>as four PVs for LVM, and when assembled into a 4-disk RAID-6.
>
>But when I make a RAID-6 array out of them, and use the array as a PV,
>the system would hang completely, within seconds.  (This is with LVM
>2.02.01, libdevicemapper 1.02.02, and dm-driver 4.5.0.)
>
>I turned on all the debugging options in the kernel config hoping to get
>some insight, but this "debug" kernel doesnt crash.  It's running fine,
>and I'm pounding on it.  A timing problem in the interaction between
>LVM and RAID?  Some kind of wierd heisenbug....
>
>
>I'd be happy to do any debugging tests people suggest.
>
>
>  
>
I've been waiting for more info on this, did it get fixed? 2.6.15?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

