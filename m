From: Hebenstreit Michael <michael.hebenstreit@fh-joanneum.at>
Subject: quick help needed - smaller disk in raid5?
Date: Sat, 19 Feb 2005 20:28:17 +0100
Message-ID: <200502192028.17397.michael.hebenstreit@fh-joanneum.at>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everybody,

I've been using a Raid5 with 3 disks of exactly the same size, a little bit 
more than 250 GB (reported as 251)

Disk /dev/sdc: 251.0 GB, 251000193024 bytes
255 heads, 63 sectors/track, 30515 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1       30513   245095641   fd  Linux raid autodetect

Now I want to add a 4th disk - and got one slightly smaller:

sanjose:~ # fdisk -l /dev/sdd
Disk /dev/sdd: 250.0 GB, 250059350016 bytes
255 heads, 63 sectors/track, 30401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Disk /dev/sdd doesn't contain a valid partition table



Is it nevertheless possible (with some minimal losses in possible size) to add 
the new disk? The Funny thing - all disks are from Maxtor, and should have 
the same size.

Thanks a lot

Michael


-- 
Michael HEBENSTREIT
FH JOANNEUM / Aviation
Alte Poststr. 149, 8020 Graz, Austria
Tel.: +43-316-5453-6421
Fax.: +43-316-5453-6401
e-mail: michael.hebenstreit@fh-joanneum.at
