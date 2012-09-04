From: Chris Friesen <chris.friesen@genband.com>
Subject: RFC: use TRIM data from filesystems to speed up array rebuild?
Date: Tue, 04 Sep 2012 12:06:26 -0600
Message-ID: <50464322.3010509@genband.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

I'm not really a filesystem guy so this may be a really dumb question.

We currently have an issue where we have a ~1TB RAID1 array that is 
mostly given over to LVM.  If we swap one of the disks it will rebuild 
everything, even though we may only be using a small fraction of the space.

This got me thinking.  Has anyone given thought to using the TRIM 
information from filesystems to allow the RAID code to maintain a 
bitmask of used disk blocks and only sync the ones that are actually used?

Presumably this bitmask would itself need to be stored on the disk.

Thanks,
Chris


-- 

Chris Friesen
Software Designer

3500 Carling Avenue
Ottawa, Ontario K2H 8E9
www.genband.com
