From: Vinnie <listacct1@lvwnet.com>
Subject: 2.4.21 kernel upgrade and md support (especially mdp partitioned
 arrays)
Date: Sat, 19 Jul 2003 12:58:42 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F1978C2.1070500@lvwnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

I'm currently running a 2.4.18 kernel on our main file/NFS server box, which 
also has an mdp-style RAID1 pair of IDE drives on it (ie, thanks to Neil's 
patches to allow partitioning of a RAID device, so you can build an array of 
complete drives and then partition it like one drive).

I'm looking at updating to a 2.4.21 kernel on this machine due to the 
higher-performance Adaptec drivers of 2.4.19 forward.  But before I can do 
this, I have to be able to successfully patch the 2.4.21 kernel to support 
mdp-style partitioned md devices, since the mdp RAID1 pair on this server 
contains important things like the mailboxes for our domains.

I'm having a bit of trouble getting Neil's 2003-01-06 comprehensive patch to 
apply against a 2.4.21 pristine kernel tree - failed hunks in the parts that 
patch md.c.

Looking back at the individual patches I originally used against 2.4.18 
(patch-A-MdLocking, patch-l-RaidSplit, patch-m-MdPart, patch-n-MdMajor, and 
a modified patch-q-Fixes), even trying a dry run on the first of these 
patches (patch-A-MdLocking) produced failed hunks.

I'm assuming that this is because at least some of Neil's patch work has 
been brought into the kernel source now (as i noticed reading the 2.4.21 
changelog also), but short of some serious digging into the patches and 
comparing to the kernel source, I'm not sure what parts I would still need 
from add-on patches to get the mdp support with a 2.4.21 kernel.

Can anyone offer any advice?

Thanks in advance!
vinnie

