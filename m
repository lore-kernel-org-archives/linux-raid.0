From: Nagilum <nagilum@nagilum.org>
Subject: mdadm RAID safety checks?
Date: Fri, 17 Sep 2010 21:21:23 +0200
Message-ID: <20100917212123.16516hjh67l7k7wg@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-2;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
I recently did a bit of RAID restructuring during the course of which  
I had first created a RAID5 with one member being a SATA disk  
connected to the onboard controller and the rest connected to a RAID  
controller. The array used the default metadata version 1.2.
Then I moved the disk from the onboard controller to a RAID controller  
in the same box and configured it as a single JBOD.
After I booted the machine I examined the disks (mdadm -E) and was a  
bit surprised to find that all disks appeared to have valid metadata.  
Of course I knew the disk I had just moved needed to be rewritten but  
first I would have to safely identify and do a clear-metadata with it.
Luckily I had two more identical disks already attached to the  
controller and configured as JBOD so I could identify the new one by  
looking at the "Used device size" and spot the new one as the one with  
the biggest reported size whereas the other two had a lower size. So  
after I had identified the new disk I cleared the metadata, assembled  
and recovered the array with no issues.
But the experience made me wonder if mdadm/linux does any checks on  
whether the reported size from the metadata is still available when  
assembling the disks (with valid metadata as in this case) to an array?
Thanks,
Alex.


----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..
