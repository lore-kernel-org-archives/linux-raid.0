From: Oliver Heinz <oheinz@fbihome.de>
Subject: Multipath problem
Date: Tue, 23 Nov 2004 13:19:51 +0100
Message-ID: <41A32AE7.2080502@fbihome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm trying to setup a HP packaged cluster (2xDL380G4 Servers +MA500G2 
Storage) both Servers  are connected via 2 SCSI-Links one for each of 
the storages's redundancy controllers.
The Storage shows as /dev/cciss/c0d1 and /dev/cciss/c1d0. When I create 
an multipath md device with version 1.6 of mdadm I can create it but 
restarting the array after I stopped it fails. With version 1.8.2 the 
size of the generated Array is 0 Blocks but I can restart it (which buys 
me nothing with that size ;-)

Mixing mdadm-1.6 and 1.8.1 for creating/managing the device doesn't 
work, it gives me an segfault.

Distro: Is debian woody, with a 2.4.25 debian standard kernel + patches 
for acl+ea and devmapper (linux-2.4.26-rc1-devmapper-ioctl.patch)

Any Ideas?

Thanks in advance,
Oliver


Version 1.60 (debian-package from adrian bunk):
server-b:~# mdadm --create /dev/md0 --level multipath -n 2  
/dev/cciss/c0d1 /dev/cciss/c1d0
VERS = 9000
mdadm: array /dev/md0 started.

server-b:/usr/src/packages# cat /proc/mdstat
Personalities : [multipath]
read_ahead 1024 sectors
md0 : active multipath cciss/c1d0[0] cciss/c0d1[1]
      573496704 blocks [1/1] [U]

unused devices: <none>

mdadm --examine --scan --config=/etc/mdadm/mdadm.conf >> 
/etc/mdadm/mdadm.conf
server-b:/usr/src/packages/mdadm-1.8.1# cat /etc/mdadm/mdadm.conf
DEVICE /dev/cciss/c[0-9]d[0-9]
ARRAY /dev/md0 level=multipath num-devices=1 
UUID=b4370fc9:9f734ab7:d6811ec0:062e8936
   spares=2   devices=/dev/cciss/c1d0,/dev/cciss/c0d1

server-b:/usr/src/packages# mdadm /dev/md0 --stop
server-b:/usr/src/packages# mdadm -A /dev/md0 -f /dev/cciss/c1d0 
/dev/cciss/c0d1
mdadm: failed to RUN_ARRAY /dev/md0: Invalid argument




Version 1.8.2 (source compiled):
server-b:/usr/src/packages# mdadm --create /dev/md0 --level multipath -n 
2  /dev/cciss/c0d1 /dev/cciss/c1d0
mdadm: array /dev/md0 started.

server-b:~# cat /proc/mdstat
Personalities : [multipath]
read_ahead 1024 sectors
md0 : active multipath cciss/c1d0[0] cciss/c0d1[1]
      0 blocks [1/1] [U]

unused devices: <none>

mdadm --examine --scan --config=/etc/mdadm/mdadm.conf >> 
/etc/mdadm/mdadm.conf
server-b:/usr/src/packages# cat /etc/mdadm/mdadm.conf
DEVICE /dev/cciss/c[0-9]d[0-9]
ARRAY /dev/md0 level=multipath num-devices=1 
UUID=afcb797f:f7cfa5f6:e0ed8819:59529278
   devices=/dev/cciss/c1d0,/dev/cciss/c0d1

server-b:/usr/src/packages# mdadm /dev/md0 --stop
server-b:/usr/src/packages/mdadm-1.8.1# mdadm -A /dev/md0 -f 
/dev/cciss/c1d0 /dev/cciss/c0d1
mdadm: /dev/md0 has been started with 1 drive and 1 spare.
