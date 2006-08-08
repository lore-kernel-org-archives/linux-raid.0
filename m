From: James Peverill <jamespev@net1plus.com>
Subject: Resize on dirty array?
Date: Mon, 07 Aug 2006 20:36:35 -0400
Message-ID: <44D7DC93.2070905@net1plus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I have a software raid 5 setup with four drives.  One drive failed.  I 
got a replacement but unfortunately it turns out that my original disks 
were just a few gigs over the replacement.  It seems that most 
manufacturers don't actually advertise the REAL capacity of the disk, so 
getting one that is the same size as the old ones could be tough.(and 
they aren't available anymore of course...)

So my question... can I resize the array while it is missing a drive?  
The raid is <50% full, and the few gigs is only a few percent.  In 
retrospect I shouldn't have sized them right to the limit...

Any ideas would be appreciated.  Thanks!

James
