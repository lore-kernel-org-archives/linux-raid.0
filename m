From: Anu Matthew <anu.matthew@bms.com>
Subject: multipath md devices
Date: Wed, 22 Sep 2004 16:41:31 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4151E37B.8040207@bms.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

We have multipath devices created on SAN Luns. Say md0 is created on 
/dev/sdj and /dev/sde, the latter being the alternate path for /dev/sdj.

I've noticed the following:

1) Without much IO to the md device, and  I pull out the cable to say 
/dev/sdj, the /proc/mdstat still shows both devices.  /proc/mdstat won't 
get updated unless I start some considerable IO to the md device. Even 
mdadm scan/query o/p shows both the paths, which is not true. As we 
start IO, /proc/mdstat reflects that one of the devices, /dev/sdj in 
this case, has failed. Thereafter mdadm outputs would be correct too.

The entries (link down) in syslog and dmesg are almost instantaneous 
when the cable is pulled out. This makes it very difficult to monitor 
multipath devices, as we cannot rely on /proc/mdstat to read.  

2) Another situation: Device md0 is active, with healthy multipaths 
/dev/sdj and /dev/sde, under reasonable IO activity. If the cable to 
/dev/sdj is yanked out, md0 remains still active, thanks to the 
alternate path, sde. However, it fails to go back and re-construct the 
spare path allocation even after the fibre link is restored. Here, if I 
pull the cable out for sde even after 30 minutes, the machine ends up 
failing to write to /dev/md0 as it does not care whether /dev/sdj is 
back online, unless I failed, removed and add /dev/sdj  manually from 
the mdadm command line. If something is hard mounted on /dev/md0, it may 
end up in a system crash.

To conclude, if one path goes off, and comes back after a while, and 
then the second path goes off, md0 cannot be read, unless someone 
manually did fail, remove and add the first device which came back 
online, before the second path goes off.

Any help towards this will be much appreciated.

Thanks,

--AM.
