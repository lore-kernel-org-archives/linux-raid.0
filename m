From: christian.schwarz@posteo.de
Subject: System freeze triggered by RAID 10 resync and high io
Date: Tue, 20 May 2014 23:24:36 +0200
Message-ID: <e4069b67814807d1782d8658cfb6f922@posteo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have an issue with stalling writes that within a few seconds 
ultimately lead to a full system freeze. Since all writes fail once the 
condition has been triggered, there is no log output. Also dmesg remains 
without errors.

My setup is as follows:

md127 : active raid10 sda1[0] sdd1[3] sdc1[2] sdb1[1]
       3907023872 blocks super 1.2 512K chunks 2 near-copies [4/4] 
[UUUU]

Linux 3.14.2-hardened-r1 #4 SMP PREEMPT

Dell Poweredge T20 Server


To trigger this condition, a resync of the array has to be running and 
high disk IO needs to be performed in addition. The condition is 
triggered regardless of the resync speed (tested with 1, 10 and 100 
MB/s). I also tried different io schedulers and a non-preempt kernel.


Someone else over at Fedora reported a similiar problem: 
http://www.spinics.net/linux/fedora/fedora-kernel/msg05163.html


How can I help with providing additional information so you can locate 
the problem?


Thanks,

Christian

