From: ravichandra <vmynidi@caviumnetworks.com>
Subject: Problem regarding RAID10 on kernel 2.6.31
Date: Fri, 06 Aug 2010 15:11:58 +0530
Message-ID: <1281087718.14259.5.camel@venkata-pc.in.caveonetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi everyone,
                 I  used 2 (1 TB disks) disks each with 3
partitions(sda[1-3] and sdb[1-3]).Using sda[1-2] and sdb[1-2] i have
created a RAID10 array say md2. Then  i was reading and writing to the
array and simultaneously removing a disk and adding it to the same
array. In the process i got a hang causing recovery process to halt. The
array was not operational after.These were done on kernel 2.6.31.

           I am working on the RAID10 for the first time. Can someone
help in this so that i can proceed further?? 

Thanks in advance.

