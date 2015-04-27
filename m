From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Help needed recovering from raid failure
Date: Mon, 27 Apr 2015 13:07:51 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1504271256580.16871@uplift.swm.pp.se>
References: <4D8713B5-39E7-4EE2-898C-35DC0948B4CA@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D8713B5-39E7-4EE2-898C-35DC0948B4CA@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter van Es <vanes.peter@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> I booted Linux from a USB stick (which is on /dev/sdc1 hence changing the numbering),
> in recovery mode. Below is the output of /proc/mdstat and
> mdadm --examine. It looks like somehow the /dev/sdd2 and /dev/sde2 drives took on the
> super block of the /dev/md127 device (my swap file). May that have been done by the boot from
> the Ubuntu USB stick?

Your event counters are strange, 2 drives are showing 18014, and two 
drives are showing event count of 26. Two drives show an update time of 
the 26:th, two show update time on the 27:th of April. This doesn't make 
much sense.

If I were you, I would try to make really really sure that I had unplugged 
the drive that first went offline, then I would use "mdadm --assemble 
--force <md> <component drives>" to get the array up in degraded mode, I 
would then mount it read-only and try to copy the most important 
information onto some other disk. After that you can try to add the new 
drive you bought and let it re-sync. Most likely this will not work as you 
most likely have read errors on at least one other drive. You can use 
"smartctl" from "smartmontolls" to verify. Most likely you will have 
"pending sectors" which are sectors that can't be read on at least one 
other drive.

Also, I recommend you do this:

for x in /sys/block/sd[a-z] ; do
         echo 180  > $x/device/timeout
done

echo 4096 > /sys/block/md0/md/stripe_cache_size

Change md0 above to your md-device. This will increase your kernel 
timeouts and lessen the risk that drives will be considered dead when they 
are only having problems reading a block.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
