From: =?utf-8?q?=C5=81ukasz_Ole=C5=9B?= <lukasz.oles@open-e.com>
Subject: Tuning scst windows and sw raid5
Date: Fri, 22 Apr 2011 16:16:52 +0200
Message-ID: <201104221616.52719.lukasz.oles@open-e.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm trying to tune Software Raid5, SCST and Windows Initiator to get best 
read/write performance.

On debian based system I created raid5 from 3 disks. I added it to scst config 
in BLOCK IO mode. Then I made some performance tests with Linux and Windows 
initiators. On Linux I used xfs filesystem and ntfs on Windows. 

Here are test results: 
https://spreadsheets6.google.com/spreadsheet/pub?hl=pl&hl=pl&key=0AghOYEb75PA2dGU1WUdKTl9hNDFDc3ZBdkRQeEFrR3c&output=html

What we can see there is that on Linux  results are quite consistent. Windows 
results are more interesting. It looks like to get better performance  NTFS 
block size should be bigger than raid chunk size. Why it only matters on 
Windows? But even then Windows performance is worse than on Linux.

If in SCST I am using FILEIO mode or instead of RAID5 RAID0 then performance 
on both systems is comparable.   

Did anyone have same results and Do you have any tips how to improve 
performance on Windows?

Software details:
iSCSI target: Debian etch
Windows:
        Windows Server R2
        test program: BST5 (http://www.nu2.nu/bst/_
Linux:
        Debian 6.0
        test program: dd        

I'm not sure what is the main cause of problem so I'm sending this mail to 
SCST maillist and to linux-raid maillist.

Regards,

--
Lukasz Oles
