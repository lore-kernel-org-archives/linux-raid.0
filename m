From: David Caldwell <david@porkrind.org>
Subject: RAID 5 recover locks up with 2.4.20
Date: Thu, 02 Jan 2003 14:50:46 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <2147483647.1041519046@[10.0.0.2]>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

  I have a 4 disk RAID 5 array. I upgraded to the 2.4.20 kernel and one of 
my disks went kaput (loose power connector). I fixed the disk and tried to 
rebuilt the raid but it locked up hard (no magic sys-req key, no oops, 
nothing!). So I rebooted and it locked up everytime it started the recovery 
process. So then I tried kernel 2.4.19-rc3 (my old faithful kernel) and it 
rebuilt just fine.

More details:
  The 4 disks are connected to 2 promise chips. One is on a PCI card and is 
just a ATA-100 host adapter. The other is on the motherboard and is a raid 
adapter that I run in straight ATA host adapter mode. All the disks are 
masters. Here are the lines from lspci:

00:0f.0 RAID bus controller: Promise Technology, Inc. PDC20276 IDE (rev 01)
00:09.0 Unknown mass storage controller: Promise Technology, Inc. 20267 
(rev 02)

  Before it locked up the second time it did a ext-3 journal recovery on 
the disk and that worked ok. I mention this because that shows the 
read/write path to the drives is at least partially working.

  Since it locks up completely, I'm not sure how to debug any further. Does 
anyone know what the problem might be?

Thanks,
  David

ps. I am not subscribed to the list so if you could cc me that would be 
great.
