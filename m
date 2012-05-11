From: Daniel Pocock <daniel@pocock.com.au>
Subject: read-ahead for md/lvm combination
Date: Fri, 11 May 2012 14:55:34 +0000
Message-ID: <4FAD2866.8070209@pocock.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



While I was adding the SCTERC settings to my rc.local, I had a look over
/sbin/blockdev --setra ... settings

I do things like this, for example:

/sbin/blockdev --setra 8192 /dev/mapper/myvg-large_media_files

What about
- the devices /dev/sd[ab]2
- the md device, /dev/md2  (which is the PV for LVM) ?

Would it be correct to leave /dev/sd[ab]2 and /dev/md2 at defaults, and
only specify larger sizes for LVs that need it?  Or should I even make
/dev/sd[ab]2 and /dev/md2 smaller than the default value (256)?


Those disks are SATA - but I'm also planning to add in some SSDs and
RAID1 them with md - they will hold things like source code and home
directories (to make compiling and NFS home directories faster).  Can
anyone comment on the read ahead config or any other aspect of such a plan?
