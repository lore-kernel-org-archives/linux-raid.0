From: Gerd Knops <gerti-lraid@bitart.com>
Subject: Save to use spindown?
Date: Sat, 21 Jan 2006 11:46:08 -0600
Message-ID: <12D89F37-5B36-46A6-860F-53DD9F457E6F@bitart.com>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a RAID5 setup with 3 250GB SATA disks. Often the RAID is not  
accessed for days, so I wonder if I can extend the life of the disks  
by spinning them down, eg by setting the spindown timeout for the  
drives with hdparm -S nn.

The hdparm man page says "[after spindown] the drive may take as long  
as 30 seconds to respond to a subsequent disk access". Could that  
cause a timeout when accessing the disks, resulting in one or more  
disks being marked bad?

Thanks

Gerd

