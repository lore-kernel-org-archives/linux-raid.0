From: mboisson <maxime.boissonneault@usherbrooke.ca>
Subject: Upgrading a RAID configuration
Date: Fri, 22 May 2009 10:15:02 -0700 (PDT)
Message-ID: <23674714.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello,
I am using Ubuntu Hardy with 3x500GB drives and the following RAID
configuration :

/boot is on a 100MB RAID1
/ is on a 30GB RAID0
/home is on a 906GB RAID5

I want to replace the 3 drives by 3 1TB drives.

Here is how I planned to do it :
0- Backup my /home on some external disk.
1- backup / with something like :
sudo tar cvpzf /backup.tgz --exclude=/media --exclude=/proc
--exclude=/lost+found --exclude=/backup.tgz --exclude=/mnt --exclude=/sys
--exclude=/home /
mv /backup.tgz $1
2- Replace 1 disk
3- Boot and let the RAID1 and RAID5 reconstruct
4- Replace 1 other disk
5- Boot and let the RAID1 and RAID5 reconstruct again
6- Replace the last disk
7- Boot and let the RAID1 and RAID5 reconstruct one last time
8- Boot and restore the backup on the RAID0 / partition.
9- Resize the /home partition to 1 TB.

I suspect there will be a problem replacing the primary disk, but I guessed
that I could solve this simply by changing which is the primary disk in the
BIOS.

Is there any other problem that will or could happen ?

For example, I am not sure if the raid manager is on the /boot partition or
on the /. I guess if it is on /, it won't work at all since the raid manager
itself won't be able to run ?
Also, is it possible to boot and access a command line to restore the backup
with a failed / partition ?

I am also unsure about how I should proceed to resize the /home partition.
Is this done through mdadm ?

Please enlight me on any problems that I will have.

Thanks
-- 
View this message in context: http://www.nabble.com/Upgrading-a-RAID-configuration-tp23674714p23674714.html
Sent from the linux-raid mailing list archive at Nabble.com.

