From: Eric BENARD / Free <ebenard@free.fr>
Subject: RAID detection
Date: Fri, 22 Aug 2003 09:39:05 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200308220939.07092.ebenard@free.fr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm trying to switch my raid machine from kernel IDE drivers to promise ones.
The problem is : promise driver "FastTrak.o" can only be compiled as a module 
and shows drive as SCSI ones when opensource driver shows them as IDE.

So I created an initrd which loads FastTrak.o and detects properly drives and 
partitions but raid layer doesn't detect raid array (0, 1 and 5 on 4 drives). 
This initrd also will do raidstart /dev/mdx (with x from 0 to 5) ... but 
befor it needs to detect raid array properly ;-)

md drivers are compiled inside the kernel, not as modules.

Is there a trick to get md layer detect raid array in this case ?

Many thanks and best regards
Eric

