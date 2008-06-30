From: thomas62186218@aol.com
Subject: Whole drives or Only partitions for mdadm software RAIDs?
Date: Mon, 30 Jun 2008 15:19:44 -0400
Message-ID: <8CAA8FD62E1D4D0-594-672@webmail-nb10.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, thomas62186218@aol.com
List-Id: linux-raid.ids

Hi all,

I have a simple question:

Is there any problem using the full hard drive (/dev/sdb, /dev/sdc, 
etc) as opposed to partitions (/dev/sdb1, /dev/sdc1, etc) when creating 
software RAIDs? I'd rather commit the full device to the RAID since I 
am certain I won't use it for anything else, and I am scripting this so 
I don't want to have to fdisk every drive before creating a RAID...that 
would take far too much time. Most mdadm documentation always refers to 
partitions rather than full devices, so I wanted to make sure it was 
indeed OK to use full devices.

Please let me know. Thank you all!

Thanks!
Thomas
