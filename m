From: Anu Matthew <anu.matthew@bms.com>
Subject: Trouble assembling multipath md devices between two nodes who see the
 same LUNs.
Date: Mon, 18 Apr 2005 17:14:53 -0400
Message-ID: <4264234D.7030703@bms.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have two nodes, hostA and hostB, both of them see the same 4 multipath 
LUNs.

md0 to md4 are thus visible to both the hosts, (yeah, they both do not 
write to thoe md devices at the same time, hostB mounts them only when 
hostA is down or has crashed, and viceversa.)

It works for a while.

While testing, the latest we have seen is, after md devices are stopped 
on hostA, hostB cannot start the md devices, as the uuid changes, and
comes back with a message in --verbose mode: 

mdadm: /dev/sdc  has wrong uuid

mdadm: no devices found for /dev/md0

Tried copying over the mdadm.conf with the latest uuids from hostA, 
still hostB cannot assemble them. I have to re-create the md devices on  
hostB eventually, then after a while, hostA starts to act up: it simply 
refuses to assemble.

Is there a way I can circumvent this problem? I am running rhel 3.0 (AS 
and ES), and we're on  mdadm - v1.5.0 - 22 Jan 2004, from Redhat's 
mdadm-1.5.0-9 rpm.

Thank you so much in advance,

--AM
