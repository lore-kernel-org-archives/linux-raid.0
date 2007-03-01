From: Laurent CARON <lcaron@unix-scripts.info>
Subject: Growing a raid 6 array
Date: Thu, 01 Mar 2007 20:11:05 +0100
Message-ID: <45E72549.2080108@unix-scripts.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

As our storage needs are growing i'm in the process of growing a 6TB
array to 9TB by changing the disks one by one (500GB to 750GB).

I'll have to partition the new drives with bigger partitions and then
fail the array, remove a drive, add a new 750GB disk.... repeat it as
long as 500GB disks are remaining in the system.

The question now is to know if i'm right, or ... simply wrong in
thinking that this operation is then just as simple as:

server:~# mdadm -G /dev/mdX -n number_of_disks(same as original array)

once done, i'll have to grow the filesystem (ext3) by issuing

server:~# resize2fs -p /dev/mdX



Does the fact that the ext3 partition is nearly full involves a bigger
risk of screwing the data ?

Would it be better/worse to have a bitmap (internal one) on the mdX
device while growing it ?

Thanks

Laurent
