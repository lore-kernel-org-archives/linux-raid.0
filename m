From: andy liebman <andyliebman@aol.com>
Subject: Re: Imaging Mirrored OS Drives
Date: Wed, 16 Aug 2006 13:05:39 -0400
Message-ID: <44E35063.3040706@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

For those who have been following my attempt to create IMAGES of a pair 
of drives with mirrored OS partitions, and then restore the IMAGES to a 
new set of drives...

This doesn't work directly. The imaging programs are FAST because they 
do not perform block level copying. They replicated partition structure 
and copy FILES from disk to image and then image to disk.

As I have just discovered, when I restore the images to NEW clean 
drives, the partitions on the NEW drives do not have any RAID 
information. No UUID for mdadm to use. No RAIDS to assemble. But the 
file information is there.

So, my questions are...

1) Is it now possible to CREATE mirrored partitions with mdadm AND still 
KEEP the existing data on the NEW set of drives. In other words, create 
the mirrors AFTER the fact (given that the data on the drives is 
identical).

2) Furthermore, if the above is possible, in creating the arrays on the 
new drives is there a way to force mdadm to give the arrays specific 
UUID numbers? It looks like I can do that with mdadm --update? Should I 
create the arrays first using the normal "mdadm -C" procedure, and then 
update the UUIDs?

I want to update the UUIDs so that they are the same as the UUIDs on the 
partitions on the original set of drives.

Andy Liebman
