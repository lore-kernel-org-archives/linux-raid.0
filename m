From: Robert Heinzmann <Robert.Heinzmann@gmx.net>
Subject: Migrating from SINGLE DISK to RAID1
Date: Tue, 01 Feb 2005 20:01:12 +0100
Message-ID: <41FFD1F8.3010101@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

can someone verify if the following statements are true ?

- It's not possible to simply  convert a existing partition with a 
filesystem on it to a raid1 mirror set.

This may seem succesfull (filesystem can be mounted and must not be 
checked), but it will cause data integrity problems. One of the last 
Blocks of the device formaly used for file data will be used for the 
raid superblock and so all data on this block will be not accessible 
anymore.

- Using a former disk of a raid1 array as a usual disk (not mounted as 
degrated /dev/mdX, but instead mounted as /dev/sdX or /dev/hdX) is 
successfull.

This is because the MD device layer reports the device size as size of 
disk - superblock offset during the creation of a filesystem on the MD 
device. Thus the used size of the disk, when mounting it as /dev/sdX 
/dev/hdX, is some KB smaller than it could be, but no data is lost.

- Its always possible to use raid1 disks as regular disks (not taking 
the md autodiscovery into concern). Using regular disks as raid disks 
always requires data migration (new filesystem and copy).

Thank you very much. I would really appreshiate some somments on this one.

Robert Heinzmann
