From: Greg Neumarke <greg.neumarke@covchurch.org>
Subject: Software RAID across multiple SATA host controllers - OK?
Date: Mon, 16 Jul 2007 16:42:21 -0500
Message-ID: <469BE63D.8070504@covchurch.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi. I'm looking at setting up software RAID across 5 drives on an Intel 
motherboard that has a ICH7R 4-port SATA controller and also an 
additional 4 SATA ports on a Marvell controller.

Is there anything I should be aware of when creating a software RAID5 
array with drives hosted on more that one controller? Is this a bad 
idea, or no problem?

Thanks
-Greg
