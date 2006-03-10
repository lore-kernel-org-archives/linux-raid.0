From: Raphael Delaporte <jordanrudess@free.fr>
Subject: Did --zero-superblock by mistake ... How can I get back data ?
Date: Fri, 10 Mar 2006 19:03:02 +0100
Message-ID: <4411BF56.7010801@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On a RAID 5 array which is composed by 5 hdd, I did mdadm 
--zero-superblocks on each hdd because I thought it was required to use 
the array on a new system....

But now, I cannot mdadm --assemble the array. It says :

mdadm: no RAID superblock on /dev/sda
mdadm: /dev/sda has no superblock - assembly aborted

Is it possible to assemble this array because I don't want to lose my 
data... Someone told me that I can do a :

mdadm -Cv /dev/md0 -l5 -n5 /dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/hdc

But if do that, all the data on the raid will be lost or not ?

Is there an other way to get back these data ?

Thank you very much for your help.

--
Raph.
