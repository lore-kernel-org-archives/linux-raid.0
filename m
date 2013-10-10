From: Brian Candler <brian@soundmouse.com>
Subject: mdadm monitor processes soaking up CPU
Date: Thu, 10 Oct 2013 16:58:45 +0100
Message-ID: <5256CEB5.1070109@soundmouse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Can anybody suggest what is going on here? It looks like mdadm --monitor 
is livelocking.

# ps auxwww | grep mdadm
root      2122 82.0  2.4 1605348 1592784 ?     Ds   Oct02 9664:43 
/sbin/mdadm --monitor --pid-file /var/run/mdadm/monitor.pid --daemonise 
--scan --syslog
root     11875 55.2  0.2 172776 160320 ?       R    06:37 337:23 
/sbin/mdadm --monitor --scan --oneshot
root     12220 79.8  1.5 1018324 1005940 ?     D    Oct04 7394:44 
/sbin/mdadm --monitor --scan --oneshot
root     13808 71.7  0.9 616368 604016 ?       R    Oct06 4572:35 
/sbin/mdadm --monitor --scan --oneshot
root     27512 66.4  0.6 428588 416156 ?       R    Oct08 2322:25 
/sbin/mdadm --monitor --scan --oneshot
root     35333  0.0  0.0   9392   876 pts/1    S+   16:48   0:00 grep 
--color=auto mdadm
root     35636 81.9  1.9 1286204 1273840 ?     R    Oct03 8767:55 
/sbin/mdadm --monitor --scan --oneshot
root     36670 68.0  0.7 511072 498632 ?       D    Oct07 3354:22 
/sbin/mdadm --monitor --scan --oneshot
root     39678 77.3  1.1 796328 784000 ?       R    Oct05 6043:20 
/sbin/mdadm --monitor --scan --oneshot
root     47822 57.5  0.4 290272 277828 ?       D    Oct09 1176:11 
/sbin/mdadm --monitor --scan --oneshot

This is ubuntu 12.04, with mdadm version "mdadm - v3.2.5 - 18th May 
2012" (dpkg-query -s says 3.2.5-1ubuntu0.2)

If I strace all of these, they all show an infinite loop of

...
open("/dev/md126", O_RDONLY)            = 3
fcntl(3, F_SETFD, FD_CLOEXEC)           = 0
ioctl(3, 0x80480911, 0x7fff0235df80)    = 0
close(3)                                = 0
open("/dev/md126", O_RDONLY)            = 3
fcntl(3, F_SETFD, FD_CLOEXEC)           = 0
ioctl(3, 0x80480911, 0x7fff0235df80)    = 0
close(3)                                = 0
...

The arrays themselves mostly look OK, but md126 is in an inactive state:

# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md128 : active raid1 sdx7[1] sdw6[0]
       28303232 blocks super 1.2 [2/2] [UU]

md129 : active raid1 sdx5[1] sdw5[0]
       351430464 blocks super 1.2 [2/2] [UU]

md126 : inactive sdv[14] sdo[15] sdl[16] sda[17]
       2000420864 blocks super 1.2

md127 : active raid0 sds[6] sdt[16] sdu[10] sdr[12] sdq[11] sdp[17] 
sdk[3] sdh[15] sdm[14] sdn[13] sdj[0] sdi[7] sdg[9] sde[4] sdd[1] sdc[5] 
sdf[2] sdb[8]
       9001893888 blocks super 1.2 16384k chunks

unused devices: <none>

All devices say "PASSED" in response to smartctl -H

Probably the disks in md126 were not added to the raid0 array md127 when 
it was built. But this doesn't explain why mdadm is churning up CPU.

Is there anything you want me to check on this box, before I kill all 
these mdadm processes, stop md126, and wipe the metadata off those four 
disks?

Thanks,

Brian.

