From: Doug Ledford <dledford@redhat.com>
Subject: Re: multipath md devices
Date: Wed, 22 Sep 2004 17:35:23 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1095888922.4196.1548.camel@compaq.xsintricity.com>
References: <4151E37B.8040207@bms.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4151E37B.8040207@bms.com>
To: Anu Matthew <anu.matthew@bms.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2004-09-22 at 16:41, Anu Matthew wrote:
> Hi,
> 
> We have multipath devices created on SAN Luns. Say md0 is created on 
> /dev/sdj and /dev/sde, the latter being the alternate path for /dev/sdj.
> 
> I've noticed the following:
> 
> 1) Without much IO to the md device, and  I pull out the cable to say 
> /dev/sdj, the /proc/mdstat still shows both devices.  /proc/mdstat won't 
> get updated unless I start some considerable IO to the md device. Even 
> mdadm scan/query o/p shows both the paths, which is not true. As we 
> start IO, /proc/mdstat reflects that one of the devices, /dev/sdj in 
> this case, has failed. Thereafter mdadm outputs would be correct too.
> 
> The entries (link down) in syslog and dmesg are almost instantaneous 
> when the cable is pulled out. This makes it very difficult to monitor 
> multipath devices, as we cannot rely on /proc/mdstat to read.  

/proc/mdstat will be correct once the first physical read/write on the
yanked path fails.

> 2) Another situation: Device md0 is active, with healthy multipaths 
> /dev/sdj and /dev/sde, under reasonable IO activity. If the cable to 
> /dev/sdj is yanked out, md0 remains still active, thanks to the 
> alternate path, sde. However, it fails to go back and re-construct the 
> spare path allocation even after the fibre link is restored. Here, if I 
> pull the cable out for sde even after 30 minutes, the machine ends up 
> failing to write to /dev/md0 as it does not care whether /dev/sdj is 
> back online, unless I failed, removed and add /dev/sdj  manually from 
> the mdadm command line. If something is hard mounted on /dev/md0, it may 
> end up in a system crash.
> 
> To conclude, if one path goes off, and comes back after a while, and 
> then the second path goes off, md0 cannot be read, unless someone 
> manually did fail, remove and add the first device which came back 
> online, before the second path goes off.

Yeah, IBM wrote a little app to help with that.  We stuffed it into the
mdadm package we ship since that seemed the most appropriate place for
it.  It's called mdmpd and that's it's job basically.  Very simple app,
but doesn't run on upstream kernels at the moment (it wants the md event
interface which hasn't yet been submitted upstream by Neil).

> Any help towards this will be much appreciated.
> 
> Thanks,
> 
> --AM.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


